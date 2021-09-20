view: top_restaurants {
  label: "top_restaurants"
  derived_table: {
    sql:SELECT * FROM `dhh-ncr-stg.dev_sales_revenue.partnerships_top_restaurants`
    ORDER BY global_entity_id, city_group, product_company
      ;;
  }

  dimension: global_entity_id {}
  dimension: country_name {}
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

  dimension: vendor_id {}
  dimension: product_company {
    group_label: "Product"
    type: string
    sql: CASE WHEN ${TABLE}.product_company = 'Coca-Cola Company' THEN 'Coca Cola'
         WHEN ${TABLE}.product_company = 'PepsiCo' THEN 'Pepsico'
          ELSE ${TABLE}.product_company END;;
  }
  dimension: category_group_global {}
  dimension: vendor_name {}
  dimension: street {}
  dimension: zip {}

 }
