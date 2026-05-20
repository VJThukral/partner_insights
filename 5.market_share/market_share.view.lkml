view: product_level_2 {
  label: "Market Share"
  sql_table_name: ${market_share_daily.SQL_TABLE_NAME} ;;

  parameter: date_granularity {#Used only for aggregatable metrics to rollup different time granularity
    type: unquoted
    allowed_value: { value: "Monthly" }
    allowed_value: { value: "Weekly" }
    allowed_value: { value: "Daily" }
    default_value: "Monthly"
  }

  dimension: date {
    sql:
      {% if date_granularity._parameter_value == 'Daily' %}
        ${order_date}
      {% elsif date_granularity._parameter_value == 'Monthly' %}
        ${order_month}
      {% else %}
        ${order_week}
      {% endif %};;
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

  dimension: unique_key {
    hidden: yes
    primary_key: yes
    type: string
    sql: CONCAT(${order_raw},${global_entity_id},${city},${category_group_global},
                ${is_key_account},${store_type},${product_company},${product_company_market},${product_type},${upselling})
      ;;
  }


  filter: company_selection {
    suggest_dimension: product_company
  }

  dimension: company_comparitor {
    order_by_field: company_comparitor_order
    type: string
    sql:
    CASE
      WHEN {% condition company_selection %} ${product_company} {% endcondition %}
        THEN ${product_company}
      ELSE 'Others'
    END ;;
  }


  dimension: company_comparitor_order {
    type: number
    sql:
    CASE
      WHEN ${company_comparitor} = "Others" THEN 10
      ELSE 1
    END ;;
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
    hidden: yes
    type: string
    group_label: "Global Entity"
    sql: CASE WHEN ${city} = "Other" Then "ω" ELSE ${city} END;;
  }

  dimension: is_key_account {
    group_label: "Business Line"
    type: yesno
    sql: ${TABLE}.is_key_account ;;
  }

  dimension: store_type {
    group_label: "Business Line"
    type: string
    sql: ${TABLE}.store_type_group ;;
  }

  dimension: upselling {
    type: string
    sql: ${TABLE}.product_upsell ;;
  }

  dimension: product_type {
    type: string
    sql:${TABLE}.product_option;;
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

  dimension: product_company_market {
    group_label: "Product"
    type: string
    sql: CASE WHEN ${TABLE}.product_company_market IS NULL OR ${TABLE}.product_company_market ="" THEN "Other" ELSE ${TABLE}.product_company_market END  ;;
  }

  dimension: product_company {
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_company;;
  }

  dimension: product_company_filter {
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_company_filter;;
  }

  # dimension: product_subtype {
  #   group_label: "Product"
  #   type: string
  #   sql: CASE WHEN ${TABLE}.product_subtype IS NULL OR ${TABLE}.product_subtype ="" THEN "Other" ELSE ${TABLE}.product_subtype END  ;;
  # }

  dimension: category_group_global {
    group_label: "Product"
    type: string
    sql: ${TABLE}.category_group_global;;
  }


  measure: total_vendors {
    label: "Number of Total Vendors"
    description: "Number of unique vendor ids with a successful order"
    type: sum_distinct
    sql_distinct_key: ${unique_key} ;;
    sql: ${TABLE}.restaurants ;;
    value_format_name: decimal_0
  }


  measure: total_cat_quantity {
    description: "Only Successful Orders"
    label: "Total Category Volume"
    type: sum_distinct
    sql_distinct_key: ${unique_key} ;;
    sql: CASE WHEN ${product_company} IS NOT NULL THEN ${TABLE}.quantity ELSE NULL END ;;
    value_format_name: decimal_0
  }

  measure: total_cat_price {
    label: "Total Category Price "
    type: sum_distinct
    sql_distinct_key: ${unique_key} ;;
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
}
