view: top_restaurants {
  label: "top_restaurants"
  derived_table: {
    sql:SELECT * FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_top_restaurants`

    UNION ALL

    SELECT "Test" AS global_entity_id,
          "Test" AS country_name,
          "Test" AS city_group,
          "Test" AS vendor_id,
          "Test" AS product_company,
          category_group_global,
          "Test A" AS vendor_name,
          "Test A" AS street,
          "Test A" AS zip,
    FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_top_restaurants`
    WHERE global_entity_id IN ('FP_SG',"MJM_AT","DJ_CZ")
    AND product_company IN ('Coca Cola')

    UNION ALL

    SELECT "Test" AS global_entity_id,
          "Test" AS country_name,
          "Test" AS city_group,
          "Test" AS vendor_id,
          "Test" AS product_company,
          category_group_global,
          "Test B" AS vendor_name,
          "Test B" AS street,
          "Test B" AS zip,
    FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_top_restaurants`
    WHERE global_entity_id IN ('FP_SG',"MJM_AT","DJ_CZ",'FP_MY',"FP_MM")
    AND product_company = 'Coca Cola'


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
