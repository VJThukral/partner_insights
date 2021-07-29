view: top_restaurants {
  label: "top_restaurants"
  derived_table: {
    sql:SELECT * FROM `dhh-ncr-stg.dev_sales_revenue.partnerships_top_restaurants`
      ;;
  }

  dimension: global_entity_id {}
  dimension: country_name {}
  dimension: city_group {}
  dimension: vendor_id {}
  dimension: product_company {}
  dimension: category_group_global {}
  dimension: vendor_name {}
  dimension: street {}
  dimension: zip {}

 }
