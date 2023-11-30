view: brand_level_all {
  sql_table_name: `fulfillment-dwh-production.cl_vendor.partnerships_brand_level_all` ;;
  # derived_table: {
  #   sql:
  #     SELECT *
  #     FROM fulfillment-dwh-production.cl_vendor.partnerships_brand_level_all

  #     UNION ALL

  #     SELECT
  #       period_seg,
  #       "Test" AS global_entity_id,
  #       "Test" AS country_name,
  #       report_period,
  #       "Test" AS city_group,
  #       "Test" AS category_group_global,
  #       is_key_account,
  #       store_type_group,
  #       "Test" AS product_company_market,
  #       "Test" AS product_company,
  #       "Test" AS product_type,
  #       "Test" AS product_subtype,
  #       "Test" AS product_name,
  #       "" AS product_option,
  #       "" AS product_upsell,
  #       SUM(customers) AS customers,
  #       SUM(vendors) AS restaurants,
  #       SUM(orders) AS orders,
  #       SUM(quantity) AS quantity,
  #       SUM(total_price_lc) AS total_price_lc,
  #       SUM(total_price_eur) AS total_price_eur
  #     FROM fulfillment-dwh-production.cl_vendor.partnerships_product_level
  #     WHERE global_entity_id IN ('FP_SG',"MJM_AT")
  #     AND product_company IN ('Coca Cola')
  #     GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

  #     ;;
  #   sql_trigger_value: SELECT MAX(report_period) FROM `fulfillment-dwh-production.cl_vendor.partnerships_order_level`  ;;
  #   partition_keys: ["report_period"]
  #   cluster_keys: ["period_seg","global_entity_id","product_company"]
  # }
}