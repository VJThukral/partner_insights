view: orders_hour_weekday {###Total platform orders in the last 6 months
  label: "orders_hour_weekday"
  sql_table_name: `fulfillment-dwh-production.cl_vendor.partnerships_orders_by_hour`  ;;
  # derived_table: {
  #   sql: SELECT *
  #   FROM `fulfillment-dwh-production.cl_vendor.partnerships_orders_by_hour`

  #   UNION ALL

  #   SELECT 'Test' AS global_entity_id,
  #       'Test' AS country_name,
  #       report_period,
  #       report_period_weekday,
  #       report_period_hour,
  #       'Test' AS city_group,
  #       'Test' AS product_company,
  #       'Test' AS product_name,
  #       orders,
  #   FROM `fulfillment-dwh-production.cl_vendor.partnerships_orders_by_hour`
  #   WHERE global_entity_id IN ('FP_SG',"MJM_AT","DJ_CZ",'FP_MY',"FP_MM")

    # ;;
    # }

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

  dimension: report_period_weekday {
    type: string
    order_by_field: report_period_weekday_sorting
    sql: CASE WHEN ${TABLE}.report_period_weekday = 1 THEN 'Sunday'
              WHEN ${TABLE}.report_period_weekday = 2 THEN 'Monday'
              WHEN ${TABLE}.report_period_weekday = 3 THEN 'Tuesday'
              WHEN ${TABLE}.report_period_weekday = 4 THEN 'Wednesday'
              WHEN ${TABLE}.report_period_weekday = 5 THEN 'Thursday'
              WHEN ${TABLE}.report_period_weekday = 6 THEN 'Friday'
              WHEN ${TABLE}.report_period_weekday = 7 THEN 'Saturday'
              ElSE NULL END;;
  }

  dimension: report_period_weekday_sorting {
    type: number
    hidden: yes
    sql:CASE WHEN ${report_period_weekday} = 'Sunday' THEN 7
              WHEN ${report_period_weekday} = 'Monday' THEN 1
              WHEN ${report_period_weekday}= 'Tuesday' THEN 2
              WHEN ${report_period_weekday} = 'Wednesday' THEN 3
              WHEN ${report_period_weekday} = 'Thursday' THEN 4
              WHEN ${report_period_weekday} = 'Friday' THEN 5
              WHEN ${report_period_weekday} = 'Saturday' THEN 6
              ElSE NULL END;;
  }


  dimension: report_period_hour {
    hidden: yes
    type: number
    sql: ${TABLE}.report_period_hour ;;
  }

  dimension: daytime_distribution {
    order_by_field: daytime_distribution_sorting
    type: string
    sql: CASE WHEN ${report_period_hour} >= 7 and ${report_period_hour} < 11
                THEN 'Breakfast'
              WHEN ${report_period_hour} >= 11 and ${report_period_hour} < 14
                THEN 'Lunch'
              WHEN ${report_period_hour} >= 14 and ${report_period_hour} < 17
                THEN 'Late Lunch/Snack'
              WHEN ${report_period_hour} >= 17 and ${report_period_hour} < 20
                THEN 'Dinner'
              WHEN (${report_period_hour} >= 20 and ${report_period_hour} <= 23) or (${report_period_hour} >= 0 and ${report_period_hour} < 7)
                THEN 'Late Night'
              ELSE NULL
              END;;
  }

  dimension: daytime_distribution_sorting {
    type: number
    hidden: yes
    sql: CASE WHEN ${daytime_distribution} = 'Breakfast' THEN 1
              WHEN ${daytime_distribution} = 'Lunch' THEN 2
              WHEN ${daytime_distribution} = 'Late Lunch/Snack' THEN 3
              WHEN ${daytime_distribution} = 'Dinner' THEN 4
              WHEN ${daytime_distribution} = 'Late Night' THEN 5
              ELSE NULL
              END;;
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

  dimension: city{
    order_by_field: city_sorting
    type: string
    group_label: "Global Entity"
    sql: INITCAP(${TABLE}.city_group);;
  }

  dimension: city_sorting{
    hidden: yes
    type: string
    group_label: "Global Entity"
    sql: CASE WHEN ${city} = "Other" Then "ω" ELSE ${city} END;;
  }

  dimension: product_company {
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_company;;
  }

  dimension: product_name {
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  measure: total_order {
    label: "Successful Orders"
    type:  sum
    sql:${TABLE}.orders;;
  }



}