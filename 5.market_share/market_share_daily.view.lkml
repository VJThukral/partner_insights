view: market_share_daily {
  derived_table: {
    sql:WITH base_data AS (
    SELECT
          opa.period_seg,
          CAST(report_period as string) as date_string,
          opa.report_period,
          opa.global_entity_id,
          opa.country_name,
          opa.city_group,
          opa.category_group_global,
          opa.is_key_account,
          opa.store_type_group,
          opa.product_company,
          opa.product_company_market,
          opa.product_option,
          opa.product_upsell,
          SUM(opa.quantity) AS quantity,
          SUM(opa.total_price_lc) AS total_price_lc ,
          SUM(opa.total_price_eur) AS total_price_eur ,
    FROM ${company_level_split.SQL_TABLE_NAME} AS opa
    WHERE opa.period_seg = "Daily"
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13

    UNION ALL ---This query is to have "Others" to joinable with Country Data for Incidence Rate Calculation

    SELECT opa.period_seg,
          CAST(report_period as string) as date_string,
          opa.report_period,
          opa.global_entity_id,
          opa.country_name,
          opa.city_group,
          opa.category_group_global,
          opa.is_key_account,
          opa.store_type_group,
          "Others" AS product_company,
          opa.product_company_market,
          opa.product_option,
          opa.product_upsell,
          0 AS quantity,
          0 AS total_price_lc ,
          0 AS total_price_eur ,
    FROM ${company_level_split.SQL_TABLE_NAME} AS opa
    WHERE opa.period_seg = "Daily"
    ),

    filter_relevant_category AS (
    SELECT DISTINCT
          global_entity_id,
          city_group,
          product_company,
          product_company_market,
          store_type_group
    FROM base_data
    ),

    market_share AS (
    SELECT base_data.*,filter_relevant_category.product_company AS product_company_filter
    FROM base_data
    INNER JOIN filter_relevant_category USING (global_entity_id,city_group,product_company_market,store_type_group)
    )

    --This is for dummy data purpose
    SELECT market_share.*
    FROM market_share
      ;;

    datagroup_trigger: central_dwh_orders
    partition_keys: ["report_period"]
    cluster_keys: ["global_entity_id","product_company"]
  }
}

# UNION ALL

#     SELECT opa.period_seg,
#           CAST(report_period as string) as date_string,
#           opa.report_period,
#           'Test' AS global_entity_id,
#           "Test" AS country_name,
#           "Test" AS city_group,
#           "Test" AS category_group_global,
#           opa.is_key_account,
#           opa.store_type_group,
#           "Test" AS product_company,
#           opa.product_company_market,
#           opa.product_option,
#           opa.product_upsell,
#           SUM(opa.quantity) AS quantity,
#           SUM(opa.total_price_lc) AS total_price_lc ,
#           SUM(opa.total_price_eur) AS total_price_eur ,
#           "Test" AS product_company_filter
#     FROM market_share AS opa
#     WHERE global_entity_id IN ('FP_SG',"MJM_AT","DJ_CZ")
#     AND product_company_filter = 'Coca Cola'
#     AND product_company = 'Coca Cola'
#     GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,17

#     UNION ALL

#     SELECT opa.period_seg,
#           CAST(report_period as string) as date_string,
#           opa.report_period,
#           'Test' AS global_entity_id,
#           "Test" AS country_name,
#           "Test" AS city_group,
#           "Test" AS category_group_global,
#           opa.is_key_account,
#           opa.store_type_group,
#           "Others" AS product_company,
#           opa.product_company_market,
#           opa.product_option,
#           opa.product_upsell,
#           SUM(opa.quantity) AS quantity,
#           SUM(opa.total_price_lc) AS total_price_lc ,
#           SUM(opa.total_price_eur) AS total_price_eur ,
#           "Test" AS product_company_filter
#     FROM market_share AS opa
#     WHERE global_entity_id IN ('FP_SG',"MJM_AT","DJ_CZ",'FP_MY',"FP_MM")
#     AND product_company_filter = 'Coca Cola'
#     AND product_company != 'Coca Cola'
#     GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,17
