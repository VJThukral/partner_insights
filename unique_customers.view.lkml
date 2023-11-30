view: unique_customers {
  label: "unique_customers"
  derived_table: {
    sql: {% if (product_name._is_filtered) %} --Brand Level

        SELECT *
        FROM `fulfillment-dwh-production.cl_vendor.partnerships_company_monthly_stats`
        WHERE granularity = "Brand"

        {% else %}  --Company Level

        SELECT *
        FROM `fulfillment-dwh-production.cl_vendor.partnerships_company_monthly_stats`
        WHERE granularity = "Company"

        {% endif %}
    ;;
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

  dimension: date {
    order_by_field: order_month
    group_label: "Date Dimension"
    sql: ${order_month};;
  }

  dimension: granularity {
    hidden: yes
    type: string
    sql: ${TABLE}.granularity ;;
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

  dimension: product_company {
    group_label: "Product"
    type: string
    sql: CASE WHEN ${TABLE}.product_company = 'Coca-Cola Company' THEN 'Coca Cola'
         WHEN ${TABLE}.product_company = 'PepsiCo' THEN 'Pepsico'
          ELSE ${TABLE}.product_company END;;
  }

  dimension: product_name {
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: store_type {
    type: string
    sql: ${TABLE}.store_type_group ;;
  }

  measure: total_customers {
    label: "Total Customers"
    type:  sum
    sql:${TABLE}.customers;;
  }

  measure: new_customers {
    label: "New Customers"
    type:  sum
    sql:${TABLE}.new_customers;;
  }

  measure: returning_customers {
    label: "Returning Customers"
    type:  number
    sql: ${total_customers} - ${new_customers} ;;
  }

  measure: acquisition_ratio {
    type:  number
    sql: SAFE_DIVIDE(${new_customers},${total_customers}) ;;
    value_format_name: percent_0
  }

}