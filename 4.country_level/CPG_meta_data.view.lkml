#This is the only metric in Market Share module cant aggregated due to logic itself have to check full week/month
view: cpg_meta_data {
  sql_table_name: `fulfillment-dwh-production.cl_vendor.partnerships_cpg_metadata` ;;

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

  dimension: category_group_global {
    type: string
    sql: ${TABLE}.category_group_global ;;
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
