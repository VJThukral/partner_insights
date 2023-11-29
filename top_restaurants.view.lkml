view: top_restaurants {
  label: "top_restaurants"
  sql_table_name:`fulfillment-dwh-production.rl_sales_revenue.partnerships_top_restaurants` ;;


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
  dimension: has_sold {
    type: yesno
    sql: ${TABLE}.has_sold ;;
  }
  dimension: vendor_name {}
  dimension: street {}
  dimension: zip {}
  measure: total_orders {
    type: sum
  }
  measure: company_orders {
    type: sum
  }
  measure: top_ranking {
    hidden: yes
    type: max
  }
  measure: company_top_ranking {
    hidden: yes
    type: max
  }
  measure: company_bottom_ranking {
    hidden: yes
    type: max
  }
 }
