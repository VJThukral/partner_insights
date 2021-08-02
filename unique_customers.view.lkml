view: unique_customers {
  label: "unique_customers"
  derived_table: {
    sql: SELECT *,
        CAST(report_period as string) as date_string
    FROM dhh-ncr-stg.dev_sales_revenue.partnerships_company_monthly_stats ;;
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
    sql: CONCAT(${order_month_name} ," ", format_datetime('%y',${TABLE}.report_period));;
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
    type: string
    group_label: "Global Entity"
    sql: ${TABLE}.city_group ;;
  }



  dimension: product_company {
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_company ;;
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
    sql:${TABLE}.users;;
  }


}
