view: brand_level_split {
  sql_table_name: `fulfillment-dwh-production.rl_sales_revenue.partnerships_brand_level` ;;
  # derived_table: {
  #   sql:
  #     SELECT *
  #     FROM fulfillment-dwh-production.rl_sales_revenue.partnerships_brand_level

  #     UNION ALL --- ADDING TEST DATA FOR EXPLORING PURPOSE

  #     SELECT
  #         period_seg,
  #         "Test" AS global_entity_id,
  #         "Test" AS country_name,
  #         report_period,
  #         "Test" AS city_group,
  #         "Test" AS category_group_global,
  #         is_key_account,
  #         store_type_group,
  #         "Test" AS product_company_market,
  #         "Test" AS product_company,
  #         "Test" AS product_type,
  #         "Test" AS product_subtype,
  #         "Test" AS product_name,
  #         CASE WHEN is_option IS TRUE THEN "Option" ELSE "Product" END AS product_option,
  #         CASE WHEN is_upsell IS TRUE THEN 'With Upselling' ELSE 'Without Upselling' END AS product_upsell,
  #         customers,
  #         vendors AS restaurants,
  #         orders,
  #         quantity,
  #         total_price_lc,
  #         total_price_eur
  #     FROM fulfillment-dwh-production.rl_sales_revenue.partnerships_product_level
  #     WHERE global_entity_id IN ('FP_SG',"MJM_AT")
  #     AND product_company IN ('Coca Cola')

  #     ;;
  #   sql_trigger_value: SELECT MAX(report_period) FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level`  ;;
  #   partition_keys: ["report_period"]
  #   cluster_keys: ["period_seg","global_entity_id","product_company"]
  # }

  dimension: date_granularity {
    type: string
    sql: ${TABLE}.period_seg ;;
  }

  dimension: date_string {
    type: string
    sql: CAST(report_period as string) ;;
  }

  dimension: upselling {
    type: string
    sql: ${TABLE}.product_upsell ;;
  }

  dimension: product_type {
    type: string
    sql:${TABLE}.product_option;;
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


  parameter: currency_picker {
    type: string
    label: "Currency"
    allowed_value: {
      label: "Euro"
      value: "eur"

    }
    allowed_value: {
      label: "Local Currency"
      value: "lc"
    }

  }


  dimension: global_entity_id {
    type: string
    group_label: "Global Entity"
    description: "GEID, identifier for the sub_entity/brand. Example: 'CD_CO', 'PY_AR', etc."
    sql: ${TABLE}.global_entity_id ;;
  }

  dimension: country {
    full_suggestions: yes
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

  dimension: is_key_account {
    group_label: "Business Line"
    type: yesno
    sql: ${TABLE}.is_key_account ;;
  }

  dimension: product_company {
    group_label: "Product"
    type: string
    sql: CASE WHEN ${TABLE}.product_company = 'Coca-Cola Company' THEN 'Coca Cola'
         WHEN ${TABLE}.product_company = 'PepsiCo' THEN 'Pepsico'
          ELSE ${TABLE}.product_company END;;
  }

  dimension: product_subtype {
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_subtype ;;
  }

  dimension: product_name {
    order_by_field: product_name_sorting
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: category_group_global {
    type: string
    sql: ${TABLE}.category_group_global ;;
  }

  filter: brand_selection {
    suggest_dimension: product_name
  }

  filter: product_subtype_filter {
    suggest_dimension: product_subtype
  }

  filter: category_group_global_filter {
    suggest_dimension: category_group_global
  }
  dimension: cuisine_comparitor {
    type: string
    sql:
    CASE
      WHEN {% condition category_group_global_filter %} ${category_group_global} {% endcondition %}
        THEN ${category_group_global}
      ELSE "Others"
    END ;;
  }


  dimension: brand_comparitor {
    type: string
    sql:
    CASE
    WHEN {% condition brand_selection %} "All Brands" {% endcondition %}
    AND {% condition product_subtype_filter %} "All Categories" {% endcondition %}
        THEN ${product_name} ---return each brand values
      WHEN {% condition brand_selection %} ${product_name} {% endcondition %}
        THEN ${product_name}
      ELSE "Others"
    END ;;
  }

  dimension: store_type {
    type: string
    sql: ${TABLE}.store_type_group ;;
  }

  measure: total_customers {
    label: "Distinct Customers"
    description: "Distinct count of analytical_customer_id. NOTE: this can be very slow to calculate with many dimensions over long periods of time."
    type: sum
    sql: ${TABLE}.customers ;;
    value_format_name: decimal_0
  }

  measure: total_vendors {
    label: "Number of Total Vendors"
    description: "Number of unique vendor ids with a successful order"
    type: sum
    sql: ${TABLE}.vendors ;;
  }

  measure: total_order {
    description: "Only Successful Orders"
    label: "Successful Orders"
    type:  sum
    sql: ${TABLE}.orders ;;
  }

  measure: total_cat_quantity {
    description: "Only Successful Orders"
    label: "Total Category Volume"
    type:  sum
    sql: CASE WHEN ${product_company} IS NOT NULL THEN ${TABLE}.quantity ELSE NULL END ;;
    value_format_name: decimal_0
  }

  measure: total_cat_price {
    label: "Total Category Price "
    type: sum
    sql:
      CASE
      WHEN ${product_company} IS NOT NULL
        AND {% parameter currency_picker %} = 'eur'
        THEN ${TABLE}.total_price_eur
      WHEN ${product_company} IS NOT NULL
        AND {% parameter currency_picker %} = 'lc'
        THEN ${TABLE}.total_price_lc
      ELSE NULL
    END ;;
    value_format_name: decimal_2
  }


  dimension: product_name_sorting{
    type: string
    sql: CASE WHEN ${product_name} = 'All Brands' THEN NULL
              ELSE ${product_name}
              END;;
  }
}
