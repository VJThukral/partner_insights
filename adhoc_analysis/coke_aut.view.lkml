view: coke_aut {
    derived_table: {
      sql:
      WITH partnerships_order_product_all AS
(
SELECT
  oi.global_entity_id
  , oi.order_id
  , oi.placed_at_local
  , oi.vendor_id
  , oi.analytical_customer_id
  , FALSE AS is_upsell
  , FALSE AS is_option
  , product.id AS product_id
  --pattern to differentiate combo product, if (1) has combo pattern in main title OR (2) if product exist only in desc but not exists in main product title, we consider them as combo as well
  , COALESCE(pm.product_alias,pm1.product_alias) product_alias
  , COALESCE(pm.product_size_numeral,pm1.product_size_numeral) product_size_numeral
  , COALESCE(pm.product_size_unit,pm1.product_size_unit) product_size_unit
  , COALESCE(pm.product_type,pm1.product_type) product_type
  , COALESCE(pm.product_subtype,pm1.product_subtype) product_subtype
  , COALESCE(pm.product_company,pm1.product_company) product_company
  , product.quantity
  FROM `fulfillment-dwh-production.curated_data_shared_central_dwh.orders` AS oi,
  UNNEST(oi.items) AS product
  LEFT JOIN `fulfillment-dwh-production.curated_data_shared_data_stream.products`  AS p
    ON oi.global_entity_id = p.global_entity_id
    AND oi.vendor_id = p.vendor_id
    AND product.id = p.product_id
  LEFT JOIN `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_product_mapping` AS pm
    ON  oi.global_entity_id = pm.global_entity_id
    AND product.name = pm.product_name
  LEFT JOIN `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_product_mapping` AS pm1 --description
    ON  p.global_entity_id = pm1.global_entity_id
    AND p.description = pm1.product_name
  WHERE oi.placed_at_local BETWEEN DATE_SUB(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH), INTERVAL 1 DAY) AND CURRENT_DATE()
    AND DATE(oi.placed_at) BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)) AND CURRENT_DATE()
    AND oi.global_entity_id = "MJM_AT"
    AND oi.is_sent IS TRUE
    AND oi.is_qcommerce IS FALSE
    AND product.id IS NOT NULL

  UNION ALL

  SELECT
  oo.global_entity_id
  , oo.order_id
  , oo.placed_at_local
  , oo.vendor_id
  , oo.analytical_customer_id
  , option.unit_price > 0 AS is_upsell
  , TRUE AS is_option
  , option.id AS product_id
  , pm.product_alias
  , pm.product_size_numeral
  , pm.product_size_unit
  , pm.product_type
  , pm.product_subtype
  , pm.product_company
  , option.quantity
  FROM `fulfillment-dwh-production.curated_data_shared_central_dwh.orders` AS oo,
  UNNEST(oo.items) AS product,
  UNNEST(product.options) AS option
  LEFT JOIN `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_product_mapping` AS pm
    ON  oo.global_entity_id = pm.global_entity_id
    AND option.name = pm.product_name
  WHERE oo.placed_at_local BETWEEN DATE_SUB(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH), INTERVAL 1 DAY) AND CURRENT_DATE()
    AND DATE(oo.placed_at) BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)) AND CURRENT_DATE()
    AND oo.is_sent IS TRUE
    AND option.id IS NOT NULL
    AND oo.is_qcommerce IS FALSE
    AND oo.global_entity_id = "MJM_AT"

  UNION ALL

  SELECT
  oo.global_entity_id
  , oo.order_id
  , oo.placed_at_local
  , oo.vendor_id
  , oo.analytical_customer_id
  , option.unit_price > 0 AS is_upsell
  , TRUE AS is_option
  , option.id AS product_id
  , pm.product_alias
  , pm.product_size_numeral
  , pm.product_size_unit
  , pm.product_type
  , pm.product_subtype
  , pm.product_company
  , option.quantity
FROM `fulfillment-dwh-production.curated_data_shared_central_dwh.orders` AS oo,
UNNEST(oo.items) AS product,
UNNEST(product.options) AS options, --1st
UNNEST(options.options) AS option --2nd
LEFT JOIN `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_product_mapping` AS pm
  ON  oo.global_entity_id = pm.global_entity_id
  AND option.name = pm.product_name
WHERE oo.placed_at_local BETWEEN DATE_SUB(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH), INTERVAL 1 DAY) AND DATE_ADD(DATETIME(CURRENT_DATE()), INTERVAL 1 DAY)
  AND DATE(oo.placed_at) BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)) AND CURRENT_DATE()
  AND oo.is_sent IS TRUE
  AND oo.is_qcommerce IS FALSE
  AND oo.global_entity_id = "MJM_AT"
)

SELECT
  opa.global_entity_id
  , dim_r.country_name
  , CAST(DATE_TRUNC(opa.placed_at_local, day) AS DATE) AS report_day
  , CAST(TIME(placed_at_local) AS STRING) AS report_time
  , dim_r.city_group
  , dim_r.category_group_global
  , dim_r.is_key_account
  , dim_r.store_type_group
  , opa.product_type AS product_company_market
  , opa.product_company
  , opa.product_subtype
  , opa.product_alias AS product_name
  , opa.product_size_numeral
  , opa.product_size_unit
  , opa.is_option
  , opa.is_upsell
  , opa.order_id
  , opa.quantity
FROM partnerships_order_product_all AS opa
INNER JOIN `fulfillment-dwh-production.rl_sales_revenue.partnerships_dim_restaurant` AS dim_r
  ON  opa.global_entity_id = dim_r.global_entity_id
  AND opa.vendor_id = dim_r.vendor_id
WHERE opa.global_entity_id = "MJM_AT"
  AND opa.product_company = "Coca Cola"
        ;;
      datagroup_trigger: coke_aut
      partition_keys: ["report_day"]
      cluster_keys: ["global_entity_id","product_company"]
    }


  dimension: report_day {
    type: date
    sql: TIMESTAMP(${TABLE}.report_day) ;;
  }

  dimension: report_time {
    type: string
    sql: ${TABLE}.report_time ;;
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

  parameter: breakdown_type {
  type: string
  allowed_value: { value: "None" }
  allowed_value: { value: "Country" }
  allowed_value: { value: "City" }
  allowed_value: { value: "Brand" }
  allowed_value: { value: "Product Category" }
  allowed_value: { value: "Product Sub-Category" }
  }

  dimension: breakdown {
  label_from_parameter: breakdown_type
  group_label: "Breakdown Dimension"
  sql:
      CASE
        WHEN {% parameter breakdown_type %} = 'Country'
          THEN ${country}
        WHEN {% parameter breakdown_type %} = 'City'
          THEN ${city}
        WHEN {% parameter breakdown_type %} = 'Brand'
          THEN ${product_name}
        WHEN {% parameter breakdown_type %} = 'Product Category'
          THEN ${product_company_market}
        WHEN {% parameter breakdown_type %} = 'Product Sub-Category'
          THEN ${product_subtype}
        ELSE 'None'
      END ;;
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

  dimension: order_id {
  primary_key: yes
  label: "Order ID"
  type: string
  description: "Backend id used to identify the order, which is used also by other services, like Hurrier, Salesforce, etc."
  sql: ${TABLE}.order_id ;;
  }


  dimension: store_type {
  group_label: "Business Line"
  type: string
  sql: ${TABLE}.store_type_group ;;
  }

  dimension: is_option{
  group_label: "Business Line"
  type: yesno
  sql: ${TABLE}.is_option ;;
  }

  dimension: is_upsell{
  group_label: "Business Line"
  type: yesno
  sql: ${TABLE}.is_upsell ;;
  }

  dimension: product_type {
  group_label: "Product"
  type: string
  sql: CASE WHEN ${is_option} IS TRUE THEN 'Option'
          ELSE 'Product'
          END;;
  }

  dimension: upselling {
  group_label: "Product"
  type: string
  sql: CASE WHEN ${is_upsell} IS TRUE THEN 'With Upselling'
          ELSE 'Without Upselling'
          END;;
  }

  filter: brand_selection {
  suggest_dimension: product_name

  }

  dimension: brand_comparitor {
  type: string
  sql:
      CASE
        WHEN {% condition brand_selection %} ${product_name} {% endcondition %}
          THEN ${product_name}
        ELSE "Others"
      END ;;
  }

  dimension: product_company_market {
  group_label: "Product"
  type: string
  sql: ${TABLE}.product_company_market ;;
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
  group_label: "Product"
  type: string
  sql: ${TABLE}.product_name ;;
  }

  dimension: product_size_numeral {
  group_label: "Product"
  type: number
  sql: ${TABLE}.product_size_numeral;;
  }

  dimension: product_size {
  order_by_field: product_size_numeral
  group_label: "Product"
  type: string
    sql: CASE WHEN ${product_size_numeral} IS NOT NULL
    --AND ${TABLE}.product_size_unit = 'ml'
    THEN CONCAT(${product_size_numeral}," ",COALESCE(${TABLE}.product_size_unit,"ml"))
        ELSE NULL
        END;;
  }

  dimension: category_group_global {
  group_label: "Product"
  type: string
  sql: ${TABLE}.category_group_global;;
  }


  measure: total_quantity {
  description: "Only Successful Orders"
  label: "Total Volume"
  type:  sum
  sql: ${TABLE}.quantity ;;
  value_format_name: decimal_0
  }

  # measure: total_order {
  # description: "Only Successful Orders"
  # label: "Successful Orders"
  # type:  sum
  # sql: ${TABLE}.orders ;;
  # value_format_name: decimal_0
  # }

  # measure: total_price {
  # label: "Total Price "
  # type: sum
  # sql:
  # CASE
  # WHEN {% parameter currency_picker %} = 'eur'
  #   THEN ${TABLE}.total_price_eur
  # ELSE ${TABLE}.total_price_lc
  # END ;;
  # value_format_name: decimal_2
  # }
}
