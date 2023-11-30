view: meta_data {
  label: "meta_data"
  sql_table_name: `fulfillment-dwh-production.cl_vendor.partnerships_metadata` ;;
  # derived_table: {
  #   sql: SELECT * FROM (
  #       SELECT *,
  #       "Others" AS product_company,
  #       FROM `fulfillment-dwh-production.cl_vendor.partnerships_metadata`

  #       --UNION ALL

  #       --SELECT period_seg,
  #           --"Test" AS global_entity_id,
  #           --"Test" AS country_name,
  #           --report_period,
  #           --"Test" AS city_group,
  #           --"Test" AS category_group_global,
  #           --is_key_account,
  #           --store_type_group,
  #           --vendors,
  #           --orders,
  #           --"Others" AS product_company,
  #       --FROM `fulfillment-dwh-production.cl_vendor.partnerships_metadata`
  #       --WHERE global_entity_id IN ('FP_SG',"MJM_AT","DJ_CZ",'FP_MY',"FP_MM")
  #       )
  #   WHERE {% condition date_granularity %} period_seg {% endcondition %}
  #         ;;
  # }

  dimension: period_seg {
    type: string
    sql: ${TABLE}.period_seg ;;
  }

  # parameter: aggregation_level {
  #   type: string
  #   allowed_value: { value: "Aggregatable" }
  #   allowed_value: { value: "Non-Aggregatable" } ###Must use this together with period_seg dim whenever reporting any non-agg metric such as vendor and customer count
  #   default_value: "Aggregatable"
  # }

  # parameter: date_granularity {#Used only for aggregatable metrics to rollup different time granularity
  #   type: unquoted
  #   allowed_value: { value: "Monthly" }
  #   allowed_value: { value: "Weekly" }
  #   allowed_value: { value: "Daily" }
  #   default_value: "Monthly"
  # }

  # dimension: date_string {
  #   type: string
  #   sql: CAST(${TABLE}.report_period as string) ;;
  # }

  # dimension: date {
  #   sql:---For Non-Aggregatable metrics like customers and vendor count
  #     {% if period_seg._value == 'Daily' and aggregation_level._parameter_value == "'Non-Aggregatable'"  %}
  #       ${date_string}
  #     {% elsif period_seg._value == 'Weekly' and aggregation_level._parameter_value == "'Non-Aggregatable'" %}
  #       ${order_week}
  #     {% elsif period_seg._value == 'Monthly' and aggregation_level._parameter_value == "'Non-Aggregatable'" %}
  #       ${order_month}
  #   ---For Aggregatable metrics
  #     {% elsif date_granularity._parameter_value == 'Daily' %}
  #       ${order_date}
  #     {% elsif date_granularity._parameter_value == 'Monthly' %}
  #       ${order_month}
  #     {% elsif date_granularity._parameter_value == 'Weekly' %}
  #       ${order_week}
  #     {% endif %};;
  # }

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
        THEN CAST(${order_date} AS STRING)
      WHEN ${date_granularity} = 'Weekly'
        THEN CAST(${order_week} AS STRING)
      WHEN ${date_granularity} = 'Monthly'
        THEN CAST(${order_month} AS STRING)
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

  dimension: category_group_global {
    type: string
    sql: ${TABLE}.category_group_global ;;
  }

  dimension: product_company {
    type: string
    group_label: "Global Entity"
    sql: "Others";;
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