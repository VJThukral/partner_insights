view: dh_orders_hour_weekday {
  label: "orders_hour_weekday"
  derived_table: {
    sql: DECLARE end_date DATE DEFAULT '{{ next_ds }}';

CREATE OR REPLACE TABLE `{{ params.project_id }}.{{ params.dataset.rl }}.partnerships_dh_orders_by_hour`
CLUSTER BY global_entity_id
AS
SELECT
    rfo.global_entity_id,
    dim_r.country_name,
    dim_r.city_group,
    EXTRACT(DAYOFWEEK FROM rfo.placed_at_local) as report_period_weekday,
    EXTRACT(HOUR FROM rfo.placed_at_local) AS report_period_hour,
    COUNT(*) as orders
FROM `fulfillment-dwh-production.curated_data_shared_central_dwh.orders` AS rfo
    INNER JOIN `fulfillment-dwh-production.curated_data_shared_central_dwh.global_entities` AS dim_c
        ON  rfo.global_entity_id       = dim_c.global_entity_id
        AND dim_c.is_reporting_enabled IS TRUE
        AND dim_c.is_platform_online IS TRUE
    INNER JOIN `{{ params.project_id }}.{{ params.dataset.rl }}.partnerships_dim_restaurant` AS dim_r
        ON  rfo.global_entity_id       = dim_r.global_entity_id
        AND rfo.vendor_id   = dim_r.vendor_id
WHERE rfo.is_sent IS TRUE
        AND rfo.placed_at_local BETWEEN DATE_SUB(DATE_TRUNC(DATE_ADD(end_date,INTERVAL -6 MONTH),MONTH), INTERVAL 1 DAY) AND DATE_ADD(DATETIME(end_date), INTERVAL 1 DAY)
        AND DATE(rfo.placed_at) BETWEEN DATETIME(DATE_TRUNC(DATE_ADD(end_date,INTERVAL -6 MONTH),MONTH)) AND end_date
        AND rfo.placed_at_local != CAST(rfo.placed_at_local AS DATE)
        -- exclude orders with the timestamp of 00:00:00
        -- because DATE_PART(hour, ...) yields 0 with dates without timestamps too
GROUP BY 1,2,3,4,5

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


  measure: total_order {
    label: "Successful Orders"
    type:  sum
    sql:${TABLE}.orders;;
  }



}
