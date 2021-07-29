view: market_share {
  label: "market_share"
  derived_table: {
    sql:SELECT opa.global_entity_id,
          opa.country_name,
          opa.report_period,
          opa.city_group,
          opa.is_key_account,
          opa.product_company_market,
          opa.product_company,
          opa.product_subtype,
          opa.product_name,
          opa.order_id,
          opa.quantity,
          opa.total_price_eur,
          opa.total_price_lc,
          CAST(report_period as string) as date_string
          FROM `dhh-ncr-stg.dev_sales_revenue.partnerships_order_level` AS opa
              INNER JOIN fulfillment-dwh-production.curated_data_shared_central_dwh.orders AS oi
                  ON oi. global_entity_id = opa. global_entity_id
                  AND oi. order_id = opa. order_id
                  AND oi. vendor_id = opa. vendor_id
              WHERE placed_at_local > DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)
      ;;
  }


  parameter: date_granularity {
    type: string
    allowed_value: { value: "Weekly" }
    allowed_value: { value: "Monthly" }
    allowed_value: { value: "Daily" }

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

  dimension: date {
    label_from_parameter: date_granularity
    order_by_field: order_month
    group_label: "Date Dimension"
    sql:
    CASE
      WHEN {% parameter date_granularity %} = 'Daily'
        THEN ${date_string}
      WHEN {% parameter date_granularity %} = 'Monthly'
        THEN CONCAT(${order_month_name} ," ", format_datetime('%y',${TABLE}.report_period))
      WHEN {% parameter date_granularity %} = 'Weekly'
        THEN ${order_week}
      ELSE NULL
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

  dimension: brand_selection {
    sql:
     CASE
     WHEN {% condition brand_select %} ${product_company} {% endcondition %}
     THEN ${product_company}
     ELSE NULL
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
    sql: ${TABLE}.product_company ;;
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



  measure: total_quantity {
    description: "Only Successful Orders"
    label: "Total Volume"
    type:  sum
    sql: CASE WHEN ${product_company} IS NOT NULL THEN ${TABLE}.quantity ELSE NULL END ;;
  }

  measure: total_order {
    description: "Only Successful Orders"
    label: "Successful Orders"
    type:  count_distinct
    sql: ${TABLE}.order_id ;;
  }

  measure: total_price {
    label: "Total Price "
    type: sum
    sql:
      CASE
      WHEN ${product_company} IS NOT NULL
        THEN ${TABLE}.total_price_eur
      ELSE NULL
    END ;;
  }
}
