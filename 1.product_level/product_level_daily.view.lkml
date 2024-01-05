view: product_level_daily {
 sql_table_name: `fulfillment-dwh-production.cl_vendor.partnerships_product_level` ;;

  parameter: date_granularity {
    type: string
    allowed_value: { value: "Daily" }
    allowed_value: { value: "Weekly" }
    allowed_value: { value: "Monthly" }
  }

  dimension: period_seg {}

  dimension: date {
    label_from_parameter: date_granularity
    order_by_field: Choosing_sorting
    sql:
    CASE
      WHEN {% parameter date_granularity %} = 'Daily'
        THEN ${date_string}
      WHEN {% parameter date_granularity %} = 'Weekly'
        THEN ${order_week}
      WHEN {% parameter date_granularity %} = 'Monthly'
        THEN format_datetime('%b %y',${TABLE}.report_period)
      ELSE NULL
    END ;;
  }

  dimension: Choosing_sorting {
    label_from_parameter: date_granularity
    hidden: yes
    sql:
    CASE
      WHEN {% parameter date_granularity %} = 'Daily'
        THEN DATE_TRUNC(${TABLE}.report_period,DAY)
      WHEN {% parameter date_granularity %} = 'Weekly'
        THEN DATE_TRUNC(${TABLE}.report_period,WEEK)
      WHEN {% parameter date_granularity %} = 'Monthly'
        THEN DATE_TRUNC(${TABLE}.report_period,MONTH)
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
    sql: CAST(${TABLE}.report_period AS string) ;;
  }

  parameter: currency_picker {
    type: string
    label: "Currency Picker"
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
    sql: ${TABLE}.product_option;;
  }

  dimension: upselling {
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_upsell;;
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
      WHEN {% condition brand_selection %} NULL {% endcondition %}
        THEN NULL
      ELSE "000000"
    END ;;
    html:
    {% if value == "000000" %}
    <p style="color: white; font-size: 50%">{{ rendered_value }}</p>
    {% else %}
    <p style="color: black; font-size:100%">{{ rendered_value }}</p>
    {% endif %};;
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
    sql:CASE WHEN ${TABLE}.product_size_numeral = "0" THEN NULL
            WHEN ${TABLE}.quantity > 10 THEN ${TABLE}.product_size_numeral
            ELSE NULL END;;
  }

  dimension: product_size {
    order_by_field: product_size_numeral
    group_label: "Product"
    type: string
    sql: CASE WHEN ${product_size_numeral} IS NOT NULL
          --AND ${TABLE}.product_size_unit = 'ml'
          THEN CONCAT(${product_size_numeral}," ",COALESCE(${TABLE}.product_size_unit,"ml"))
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
    sql: ${TABLE}.vendors ;;
    value_format_name: decimal_0
  }

  measure: total_order {
    description: "Only Successful Orders"
    label: "Successful Orders"
    type:  sum
    sql: ${TABLE}.orders ;;
    value_format_name: decimal_0
  }

  measure: total_cat_quantity {
    description: "Only Successful Orders"
    label: "Total Category Volume"
    type:  sum
    sql: CASE WHEN ${product_company} IS NOT NULL THEN ${TABLE}.quantity ELSE NULL END ;;
    value_format_name: decimal_0
  }

  measure: total_price_eur {
    # type: sum
    type: sum
    value_format_name: decimal_2
    sql: ${TABLE}.total_price_eur ;;
  }


  measure: total_price_lc {
    # type: sum
    type: sum
    value_format_name: decimal_2
    sql: ${TABLE}.total_price_lc ;;
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

  dimension_group: filter_start_date {
    type: time
    timeframes: [raw,date]
    sql: CASE WHEN {% parameter date_granularity %} = "Monthly" THEN DATE_TRUNC(DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY),MONTH)
         WHEN {% parameter date_granularity %} = "Weekly" THEN DATE_TRUNC(DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY),WEEK)
        ELSE DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY) END;;
  }

  dimension_group: filter_end_date {
    type: time
    timeframes: [raw,date]
    sql: DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY) ;;
  }

#start date of the previous period
  dimension: previous_start_date {
    type: string
    sql: CASE WHEN {% parameter date_granularity %} = "Monthly" THEN DATE_SUB(${filter_start_date_date},INTERVAL 1 MONTH)
         WHEN {% parameter date_granularity %} = "Weekly" THEN DATE_SUB(${filter_start_date_date},INTERVAL 1 WEEK)
        ELSE DATE_SUB(${filter_start_date_date},INTERVAL 1 DAY) END;;
  }

  dimension: previous_end_date {
    type: string
    sql: CASE WHEN {% parameter date_granularity %} = "Monthly" THEN DATE_SUB(${filter_end_date_date},INTERVAL 1 MONTH)
         WHEN {% parameter date_granularity %} = "Weekly" THEN DATE_SUB(${filter_end_date_date},INTERVAL 1 WEEK)
        ELSE DATE_SUB(${filter_end_date_date},INTERVAL 1 DAY) END;;
  }


  dimension: timeframes {
    view_label: "_PoP"
    type: string
    case: {
      when: {
        sql: ${is_current_period} = true;;
        label: "Selected Period"
      }
      when: {
        sql: ${is_previous_period} = true;;
        label: "Previous Period"
      }
      else: "Not in time period"
    }
  }

## For filtered measures


  dimension: is_current_period {
    hidden: yes
    type: yesno
    sql: ${order_date} >= ${filter_start_date_date} AND ${order_date} <= ${filter_end_date_date} ;;
  }

  dimension: is_previous_period {
    hidden: yes
    type: yesno
    sql: ${order_date} >= ${previous_start_date} AND ${order_date} <= ${previous_end_date} ;;
  }

  measure: PoP_change {
    view_label: " "
    label:"
    {% if date_granularity._parameter_value == \"'Weekly'\" %}
    vs GMV Last Week
    {% elsif date_granularity._parameter_value == \"'Monthly'\" %}
    vs GMV Last Month
    {% elsif date_granularity._parameter_value == \"'Daily'\" %}
    vs GMV Yesterday
    {% endif %}
    "
    type: percent_of_previous
    sql: ${total_cat_price} ;;
  }

  measure: PoP_volume_change {
    view_label: " "
    label:"
    {% if date_granularity._parameter_value == \"'Weekly'\" %}
    vs Units Last Week
    {% elsif date_granularity._parameter_value == \"'Monthly'\" %}
    vs Units Last Month
    {% elsif date_granularity._parameter_value == \"'Daily'\" %}
    vs Units Yesterday
    {% endif %}
    "
    type: percent_of_previous
    sql: ${total_cat_quantity} ;;
  }

  measure: PoP_order_change {
    view_label: " "
    label:"
    {% if date_granularity._parameter_value == \"'Weekly'\" %}
    vs Orders Last Week
    {% elsif date_granularity._parameter_value == \"'Monthly'\" %}
    vs Orders Last Month
    {% elsif date_granularity._parameter_value == \"'Daily'\" %}
    vs Orders Yesterday
    {% endif %}
    "
    type: percent_of_previous
    sql: ${total_order} ;;
  }

}
