view: meta_data {
  label: "meta_data"
  derived_table: {
    sql:SELECT *,
        CAST(report_period as string) as date_string,
        FROM `dhh-ncr-stg.dev_sales_revenue.partnerships_metadata`
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
