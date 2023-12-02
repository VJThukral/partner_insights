view: coke_aut {
  sql_table_name: `fulfillment-dwh-production.cl_vendor.partnerships_order_level` ;;

  dimension: report_period {
    type: date
    sql: CAST(DATE_TRUNC(${TABLE}.report_period, day) AS TIMESTAMP);;
    hidden: yes
  } ###for partrition only

  dimension: report_day {
    type: date
    sql: CAST(DATE_TRUNC(${TABLE}.placed_at_local, day) AS TIMESTAMP) ;;
  }

  dimension: report_time {
    type: string
    sql: CAST(TIME(${TABLE}.placed_at_local) AS STRING) ;;
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

  dimension: product_option{
  group_label: "Business Line"
  type: string
  sql: ${TABLE}.product_option ;;
  }

  dimension: is_upsell{
  group_label: "Business Line"
  type: yesno
  sql: CASE WHEN ${TABLE}.product_upsell = 'With Upselling' THEN TRUE
          ELSE FALSE
          END;;
  }

  dimension: product_type {
  group_label: "Product"
  type: string
  sql: ${product_option};;
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
