view: unique_customers {
  label: "unique_customers"
  derived_table: {
    sql: SELECT *,
        CAST(report_period as string) as date_string
    FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_company_monthly_stats`

    UNION ALL

    SELECT "Test" AS global_entity_id,
        "Test" AS country_name,
        "Test" AS city_group,
        report_period,
        "Test" AS product_company,
        store_type_group,
        vendors,
        orders,
        customers,
        new_customers,
        CAST(report_period as string) as date_string
    FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_company_monthly_stats`
    WHERE global_entity_id IN ('FP_SG',"MJM_AT")
    AND product_company IN ('Coca Cola')
    ;;
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

  dimension: date {
    order_by_field: order_month
    group_label: "Date Dimension"
    sql: format_datetime('%b %y',${TABLE}.report_period);;
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
    type: string
    group_label: "Global Entity"
    sql: CASE WHEN ${city} = "Other" Then "ω" ELSE ${city} END;;
  }

  dimension: product_company {
    group_label: "Product"
    type: string
    sql: CASE WHEN ${TABLE}.product_company = 'Coca-Cola Company' THEN 'Coca Cola'
         WHEN ${TABLE}.product_company = 'PepsiCo' THEN 'Pepsico'
          ELSE ${TABLE}.product_company END;;
  }

  dimension: store_type {
    type: string
    sql: ${TABLE}.store_type_group ;;
  }

  measure: total_vendor{
    label: "Total Vendors"
    type:  sum
    sql: ${TABLE}.restaurants ;;
  }

  measure: total_order {
    label: "Successful Orders"
    type:  sum
    sql:${TABLE}.orders;;
  }

  measure: total_customers {
    label: "Total Customers"
    type:  sum
    sql:${TABLE}.customers;;
  }

  measure: new_customers {
    label: "New Customers"
    type:  sum
    sql:${TABLE}.new_customers;;
  }

  measure: returning_customers {
    label: "Returning Customers"
    type:  number
    sql: ${total_customers} - ${new_customers} ;;
  }

  measure: acquisition_ratio {
    type:  number
    sql: SAFE_DIVIDE(${new_customers},${total_customers}) ;;
    value_format_name: percent_0
  }

}
