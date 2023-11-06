view: brand_level {
  derived_table: {
    sql:
    SELECT ii.*
    FROM
    {% if (product_name._is_filtered or product_subtype._is_filtered) and (upselling._is_filtered or product_type._is_filtered) %}
    ${brand_level_split.SQL_TABLE_NAME} ii --brand split
    {% elsif product_name._is_filtered or product_subtype._is_filtered %}
    ${brand_level_all.SQL_TABLE_NAME} ii --brand all
    {% elsif (upselling._is_filtered or product_type._is_filtered) %}
    ${company_level_split.SQL_TABLE_NAME} ii --company split
    {% else %}  --company level
    ${company_level_all.SQL_TABLE_NAME} ii
    {% endif %}
    WHERE {% condition period_seg %} period_seg {% endcondition %}
    ;;
  }

  dimension: period_seg {
    type: string
    sql: ${TABLE}.period_seg ;;
  }

  dimension: date_granularity {
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

  #   dimension: date_string {
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

  dimension: date {
    order_by_field: order_date
    group_label: "Date Dimension"
    sql:
    CASE
      WHEN ${period_seg} = 'Daily'
        THEN CAST(${order_date} AS STRING)
      WHEN ${period_seg} = 'Weekly'
        THEN CAST(${order_week} AS STRING)
      WHEN ${period_seg} = 'Monthly'
        THEN CAST(${order_month} AS STRING)
      ELSE NULL
    END ;;
  }



  dimension: upselling {
    type: string
    sql: ${TABLE}.product_upsell ;;
  }

  dimension: product_type {
    type: string
    sql:${TABLE}.product_option;;
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

  dimension: product_name_sorting{
    type: string
    sql: CASE WHEN ${product_name} = 'All Brands' THEN NULL
              ELSE ${product_name}
              END;;
  }

  filter: brand_selection {
    suggest_dimension: brand_level.product_name
  }

  filter: product_subtype_filter {
    suggest_dimension: brand_level.product_subtype
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

}
