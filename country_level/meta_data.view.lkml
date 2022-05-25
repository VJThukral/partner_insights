view: meta_data {
  label: "meta_data"
  derived_table: {
    sql:SELECT *,
        "Others" AS product_company,
        CAST(report_period as string) as date_string,
        FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_metadata`

        UNION ALL

        SELECT period_seg,
            "Test" AS global_entity_id,
            "Test" AS country_name,
            report_period,
            "Test" AS city_group,
            "Test" AS category_group_global,
            is_key_account,
            store_type_group,
            vendors,
            orders,
            "Others" AS product_company,
        CAST(report_period as string) as date_string,
        FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_metadata`
        WHERE global_entity_id IN ('FP_SG',"MJM_AT","DJ_CZ",'FP_MY',"FP_MM")
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
        THEN ${date_string}
      WHEN ${date_granularity} = 'Weekly'
        THEN ${order_week}
      WHEN ${date_granularity} = 'Monthly'
        THEN format_datetime('%b %y',${TABLE}.report_period)
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

  dimension: date_string {
    type: string
    sql: ${TABLE}.date_string ;;
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

  dimension: product_company {
    type: string
    group_label: "Global Entity"
    sql: ${TABLE}.product_company ;;
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

  dimension: store_type {
    type: string
    sql: ${TABLE}.store_type_group ;;
  }


  measure: orders {
    type: sum
    sql: ${TABLE}.orders ;;
  }

  measure: restaurants {
    type: sum
    sql: ${TABLE}.vendors ;;
  }

}
