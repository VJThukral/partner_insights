view: check {
  derived_table: {
    sql:SELECT
            global_entity_id,
            period_seg,
            country_name,
            report_period,
            city_group,
            category_group_global,
            store_type_group,
            is_key_account,
            product_company,
            product_name,
            CAST(report_period as string) as date_string,
            customers,
            restaurants,
            orders,
            quantity,
            total_price_lc,
            total_price_eur
        FROM dhh-ncr-stg.dev_sales_revenue.partnerships_product_level
        UNION ALL
        SELECT
            global_entity_id,
            period_seg,
            country_name,
            report_period,
            city_group,
            category_group_global,
            store_type_group,
            is_key_account,
            product_company,
            "All Brands" AS product_name,
            CAST(report_period as string) as date_string,
            customers,
            restaurants,
            orders,
            quantity,
            total_price_lc,
            total_price_eur
        FROM dhh-ncr-stg.dev_sales_revenue.partnerships_company_level
    ;;
    }

  dimension: date_granularity {
    type: string
    sql: ${TABLE}.period_seg ;;
  }

  dimension: date_string {
    type: string
    sql: ${TABLE}.date_string ;;
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



  dimension: product_company {
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_company ;;
  }

  dimension: product_name {
    order_by_field: product_name_sorting
    group_label: "Product"
    type: string
    sql: ${TABLE}.product_name ;;
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
    sql: ${TABLE}.restaurants ;;
  }

  measure: total_quantity {
    description: "Only Successful Orders"
    label: "Total Volume"
    type:  sum
    sql: ${TABLE}.quantity ;;
  }

  measure: total_order {
    description: "Only Successful Orders"
    label: "Successful Orders"
    type:  sum
    sql: ${TABLE}.orders ;;
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
  }

  measure: total_cat_quantity {
    description: "Only Successful Orders"
    label: "Total Category Volume"
    type:  sum
    sql: CASE WHEN ${product_company} IS NOT NULL THEN ${TABLE}.quantity ELSE NULL END ;;
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
  }


  dimension: product_name_sorting{
    type: string
    sql: CASE WHEN ${product_name} = 'All Brands' THEN NULL
              ELSE ${product_name}
              END;;
  }

}
