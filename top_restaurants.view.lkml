view: top_restaurants {
  label: "top_restaurants"
  derived_table: {
    sql:SELECT * FROM `dhh-ncr-stg.dev_sales_revenue.partnerships_top_restaurants`
    ORDER BY global_entity_id, city_group, product_company,ranking
      ;;
  }

  dimension: global_entity_id {}
  dimension: country_name {}
  dimension: city_group {
    type: string
    sql: INITCAP(${TABLE}.city_group) ;;
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
