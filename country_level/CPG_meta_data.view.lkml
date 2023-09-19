#This is the only metric in Market Share module cant aggregated due to logic itself have to check full week/month
view: cpg_meta_data {
  derived_table: {
    sql:
    WITH CPG_vendors_monthly AS (
      SELECT
        opa.global_entity_id,
        opa.country_name,
        DATE_TRUNC(opa.report_period,MONTH) AS report_period,
        opa.city_group,
        opa.store_type_group,
        opa.vendor_id,
        opa.is_key_account,
        ARRAY_AGG(DISTINCT opa.product_company ORDER BY opa.product_company) AS CPG_list
      FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level` AS opa
      WHERE opa.product_company != "Other"
      AND opa.product_company IS NOT NULL
      GROUP BY 1,2,3,4,5,6,7
      ),

      CPG_vendors_daily AS (
      SELECT
      opa.global_entity_id,
      opa.country_name,
      DATE_TRUNC(opa.report_period,DAY) AS report_period,
      opa.city_group,
      opa.store_type_group,
      opa.vendor_id,
      opa.is_key_account,
      ARRAY_AGG(DISTINCT opa.product_company ORDER BY opa.product_company) AS CPG_list
      FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level` AS opa
      WHERE opa.product_company != "Other"
      AND opa.product_company IS NOT NULL
      GROUP BY 1,2,3,4,5,6,7
      ),

      CPG_vendors_weekly AS (
      SELECT
      opa.global_entity_id,
      opa.country_name,
      DATE_TRUNC(opa.report_period,WEEK(MONDAY)) AS report_period,
      opa.city_group,
      opa.store_type_group,
      opa.vendor_id,
      opa.is_key_account,
      ARRAY_AGG(DISTINCT opa.product_company ORDER BY opa.product_company) AS CPG_list
      FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level` AS opa
      WHERE opa.product_company != "Other"
      AND opa.product_company IS NOT NULL
      GROUP BY 1,2,3,4,5,6,7
      ),

      vendors_weekly AS (
      SELECT
      DATE_TRUNC(report_date,WEEK(MONDAY)) AS report_period
      , global_entity_id
      , vendor_id
      , SUM(successful_orders)       as orders
      , SUM(value.GMV_eur)        as total_GMV_eur
      , SUM(value.GMV_local)        as total_GMV_local
      FROM `fulfillment-dwh-staging.curated_data_shared_coredata_business.agg_vendor_kpis_daily`
      WHERE report_date BETWEEN DATE_SUB(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 15 MONTH), MONTH), INTERVAL 1 DAY) AND DATE_ADD(DATETIME(CURRENT_DATE()), INTERVAL 1 DAY)
      GROUP BY 1,2,3
      ),

      vendors_monthly AS (
      SELECT
      DATE_TRUNC(report_date,MONTH) AS report_period
      , global_entity_id
      , vendor_id
      , SUM(successful_orders)       as orders
      , SUM(value.GMV_eur)        as total_GMV_eur
      , SUM(value.GMV_local)        as total_GMV_local
      FROM `fulfillment-dwh-staging.curated_data_shared_coredata_business.agg_vendor_kpis_daily`
      WHERE report_date BETWEEN DATE_SUB(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 15 MONTH), MONTH), INTERVAL 1 DAY) AND DATE_ADD(DATETIME(CURRENT_DATE()), INTERVAL 1 DAY)
      GROUP BY 1,2,3
      )

      SELECT
      "Daily" AS period_seg,
      cpg.global_entity_id,
      country_name,
      vendor.report_date AS report_period,
      city_group,
      CPG_list,
      store_type_group,
      is_key_account,
      cpg.vendor_id,
      successful_orders       as orders,
      value.GMV_eur        as total_GMV_eur,
      value.GMV_local        as total_GMV_local
      FROM CPG_vendors_daily AS cpg
      INNER JOIN `fulfillment-dwh-staging.curated_data_shared_coredata_business.agg_vendor_kpis_daily` AS vendor
      ON cpg.global_entity_id = vendor.global_entity_id
      AND cpg.vendor_id = vendor.vendor_id
      AND cpg.report_period = vendor.report_date
      WHERE report_date BETWEEN DATE_SUB(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 15 MONTH), MONTH), INTERVAL 1 DAY) AND DATE_ADD(DATETIME(CURRENT_DATE()), INTERVAL 1 DAY)

      UNION ALL

      SELECT
      "Weekly" AS period_seg,
      cpg.global_entity_id,
      country_name,
      cpg.report_period,
      city_group,
      CPG_list,
      store_type_group,
      is_key_account,
      cpg.vendor_id,
      orders,
      total_GMV_eur,
      total_GMV_local
      FROM CPG_vendors_weekly AS cpg
      INNER JOIN vendors_weekly AS vendor
      ON cpg.global_entity_id = vendor.global_entity_id
      AND cpg.vendor_id = vendor.vendor_id
      AND cpg.report_period = vendor.report_period

      UNION ALL

      SELECT
      "Monthly" AS period_seg,
      cpg.global_entity_id,
      country_name,
      cpg.report_period,
      city_group,
      CPG_list,
      store_type_group,
      is_key_account,
      cpg.vendor_id,
      orders,
      total_GMV_eur,
      total_GMV_local
      FROM CPG_vendors_monthly AS cpg
      INNER JOIN vendors_monthly AS vendor
      ON cpg.global_entity_id = vendor.global_entity_id
      AND cpg.vendor_id = vendor.vendor_id
      AND cpg.report_period = vendor.report_period
      ;;
    datagroup_trigger: central_dwh_orders
    partition_keys: ["report_period"]
    cluster_keys: ["global_entity_id"]
  }

  dimension: unique_key {
    hidden: yes
    primary_key: yes
    type: string
    sql: CONCAT(${date_granularity},${order_raw},${global_entity_id},${city},
                ${is_key_account},${store_type},${vendor_id})
      ;;
  }

  dimension: date_granularity {
    type: string
    sql: ${TABLE}.period_seg ;;
  }

  dimension: date {
    order_by_field: order_date
    group_label: "Date Dimension"
    sql:
      CASE
        WHEN ${date_granularity} = 'Daily'
          THEN CAST(${TABLE}.report_period as string)
        WHEN ${date_granularity} = 'Weekly'
          THEN ${order_week}
        WHEN ${date_granularity} = 'Monthly'
          THEN ${order_month}
        ELSE NULL
      END ;;
  }

  dimension_group: order {
    #convert_tz: no
    type: time
    datatype: datetime
    description: "Local time when the order was placed. This is partitioning column."
    timeframes: [
      raw,
      hour,
      hour_of_day,
      time,
      date,
      week,
      day_of_week,
      week_of_year,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.report_period ;;
  }

  dimension: global_entity_id {
    hidden: yes
    type: string
    group_label: "Global Entity"
    description: "GEID, identifier for the sub_entity/brand. Example: 'CD_CO', 'PY_AR', etc."
    sql: ${TABLE}.global_entity_id ;;
  }

  dimension: country {
    type: string
    group_label: "Global Entity"
    sql: ${TABLE}.country_name ;;
  }

  dimension: product_company { ###Only for joining between explores
    type: string
    group_label: "Global Entity"
    sql: "Others" ;;
  }

  dimension: city{
    order_by_field: city_sorting
    type: string
    group_label: "Global Entity"
    sql: INITCAP(${TABLE}.city_group);;
  }

  dimension: city_sorting{
    type: string
    group_label: "Global Entity"
    sql: CASE WHEN ${city} = "Other" Then "ω" ELSE ${city} END;;
  }

  dimension: is_key_account {
    type: yesno
    sql: ${TABLE}.is_key_account ;;
  }

  dimension: vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
  }

  dimension: CPG_list {
    hidden: yes
    type: string
    sql: ${TABLE}.CPG_list ;;
  }

  dimension: store_type {
    type: string
    sql: ${TABLE}.store_type_group ;;
  }


  measure: orders {
    type: sum_distinct
    sql_distinct_key: ${unique_key} ;;
    sql: ${TABLE}.orders ;;
  }

  # measure: restaurants {
  #   type: sum
  #   sql: ${TABLE}.vendors ;;
  # }

}


view: cpg_list {
  dimension: cpg {
    description: "The names of the CPGs that are purchased"
    type: string
    sql: cpg_list ;;
  }
}
