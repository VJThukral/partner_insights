view: product_level {
label: "product_level"
  derived_table: {
    sql:SELECT
    opa.period_seg,
    opa.global_entity_id,
    opa.country_name,
    opa.report_period,
    opa.city_group,
    opa.category_group_global,
    opa.is_key_account,
    opa.store_type_group,
    opa.product_company_market,
    opa.product_company,
    opa.product_type,
    opa.product_subtype,
    opa.product_name,
    opa.product_size_numeral,
    opa.product_size_unit,
    opa.is_option,
    opa.is_upsell,
    restaurants,
    opa.orders,
    opa.quantity,
    opa.total_price_lc,
    opa.total_price_eur,
    CAST(report_period as string) as date_string
    FROM `dhh-ncr-stg.dev_sales_revenue.partnerships_product_level` AS opa
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
        THEN format_datetime('%b %y',${TABLE}.report_period)
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
    type: string
    group_label: "Global Entity"
    sql: ${TABLE}.city_group ;;
  }

  dimension: is_key_account {
    group_label: "Business Line"
    type: yesno
    sql: ${TABLE}.is_key_account ;;
  }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    label: "Order ID"
    type: string
    description: "Backend id used to identify the order, which is used also by other services, like Hurrier, Salesforce, etc."
    sql: ${TABLE}.order_id ;;
  }

  dimension: vendor_id {
    hidden: yes
    label: "Vendor ID"
    type: string
    description: "Identifier for the vendor on the platform."
    sql: ${TABLE}.vendor_id ;;
  }

  dimension: unique_vendor_id {
    type: string
    hidden: yes
    sql: ${global_entity_id} || '--' || ${vendor_id};;
  }

  dimension: customer_id {
    hidden: yes
    label: "Analytical Customer ID"
    type: string
    description: "Analytical Customer ID (ACID). Unique identifier for actual, analytically-recognised and grouped customers. May include more than one customer_id or customer_account_id"
    sql: ${TABLE}.customer_id ;;
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


  filter: brand_select {
    suggest_dimension: product_company

  }

  dimension: brand_comparitor {
    sql:
     CASE
     WHEN {% condition brand_select %} ${product_company} {% endcondition %}
     THEN ${product_company}
     ELSE "Others"
     END ;;
  }

  dimension: brand_product_show {
    sql: CASE WHEN ${brand_comparitor} = 'Others'
          THEN 'Others'
          ELSE ${product_name}
          END;;
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
    hidden: yes
    type: number
    sql:CASE WHEN ${TABLE}.quantity > 2 THEN ${TABLE}.product_size_numeral ELSE NULL END;;
  }

  dimension: product_size {
    order_by_field: product_size_numeral
    group_label: "Product"
    type: string
    sql: CASE WHEN ${product_size_numeral} IS NOT NULL
    AND ${TABLE}.product_size_unit = 'ml'
    THEN CONCAT(${product_size_numeral}," ",${TABLE}.product_size_unit)
    ELSE 'Other'
    END;;
  }

  dimension: category_group_global {
    group_label: "Product"
    type: string
    sql: ${TABLE}.category_group_global;;
  }

  measure: total_customers {
    label: "Distinct Customers"
    description: "Distinct count of analytical_customer_id. NOTE: this can be very slow to calculate with many dimensions over long periods of time."
    type: count_distinct
    sql: ${customer_id} ;;
    value_format_name: decimal_0
  }

  measure: total_vendors {
    label: "Number of Total Vendors"
    description: "Number of unique vendor ids with a successful order"
    type: sum
    sql: ${TABLE}.restaurants ;;
    value_format_name: decimal_0
  }

  measure: total_quantity {
    description: "Only Successful Orders"
    label: "Total Volume"
    type:  sum
    sql: ${TABLE}.quantity ;;
    value_format_name: decimal_0
  }

  measure: total_order {
    description: "Only Successful Orders"
    label: "Successful Orders"
    type:  sum
    sql: ${TABLE}.orders ;;
    value_format_name: decimal_0
  }

  measure: total_price {
    label: "Total Price "
    type: sum
    sql:
      CASE
      WHEN {% parameter currency_picker %} = 'eur'
        THEN ${TABLE}.total_price_eur
      ELSE ${TABLE}.total_price_lc
    END ;;
    value_format_name: decimal_2
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
        THEN ${TABLE}.total_price_eur
      ELSE NULL
    END ;;
    value_format_name: decimal_2
  }
}
