view: meta_data {
  label: "meta_data"
  derived_table: {
    sql:SELECT *,
        CAST(report_period as string) as date_string,
        FROM `dhh-ncr-stg.dev_sales_revenue.partnerships_metadata`
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
      WHEN ${date_granularity} = 'Monthly'
        THEN CONCAT(${order_month_name} ," ", format_datetime('%y',${TABLE}.report_period))
      WHEN ${date_granularity} = 'Weekly'
        THEN ${order_week}
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

  dimension: city{
    type: string
    group_label: "Global Entity"
    sql: ${TABLE}.city_group ;;
  }

  dimension: is_key_account {
    type: yesno
    sql: ${TABLE}.is_key_account ;;
  }


  measure: orders {
    type: sum
    sql: ${TABLE}.orders ;;
  }

  measure: restaurants {
    type: sum
    sql: ${TABLE}.restaurants ;;
  }

}
