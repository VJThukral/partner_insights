view: company_level_split {
  derived_table: {
    sql:
    WITH company_level_split_daily
    AS (
    SELECT
        'Daily' AS period_seg,
        opa.global_entity_id,
        opa.country_name,
        DATE_TRUNC(opa.report_period,DAY) as report_period,
        opa.city_group,
        opa.category_group_global,
        opa.is_key_account,
        opa.store_type_group,
        opa.product_type as product_company_market,
        opa.product_company,
        "" AS product_type,
        "" AS product_subtype,
        "" AS product_name,
        CASE WHEN opa.is_option IS TRUE THEN "Option" ELSE "Product" END AS product_option,
        CASE WHEN opa.is_upsell IS TRUE THEN 'With Upselling' ELSE 'Without Upselling' END AS product_upsell,
        COUNT(DISTINCT opa.analytical_customer_id)   as customers,
        COUNT(DISTINCT opa.vendor_id)   as vendors,
        COUNT(DISTINCT opa.order_id)        as orders,
        SUM(opa.quantity)                   as quantity,
        SUM(opa.total_price_lc)             as total_price_lc,
        SUM(opa.total_price_eur)            as total_price_eur
    FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level` AS opa
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    ),

    company_level_split_weekly
    AS (
    SELECT
        'Weekly' AS period_seg,
        opa.global_entity_id,
        opa.country_name,
        DATE_TRUNC(opa.report_period,WEEK) as report_period,
        opa.city_group,
        opa.category_group_global,
        opa.is_key_account,
        opa.store_type_group,
        opa.product_type as product_company_market,
        opa.product_company,
        "" AS product_type,
        "" AS product_subtype,
        "" AS product_name,
        CASE WHEN opa.is_option IS TRUE THEN "Option" ELSE "Product" END AS product_option,
        CASE WHEN opa.is_upsell IS TRUE THEN 'With Upselling' ELSE 'Without Upselling' END AS product_upsell,
        COUNT(DISTINCT opa.analytical_customer_id)   as customers,
        COUNT(DISTINCT opa.vendor_id)   as vendors,
        COUNT(DISTINCT opa.order_id)        as orders,
        SUM(opa.quantity)                   as quantity,
        SUM(opa.total_price_lc)             as total_price_lc,
        SUM(opa.total_price_eur)            as total_price_eur
    FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level` AS opa
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    ),

    company_level_split_monthly
    AS (
    SELECT
        'Monthly' AS period_seg,
        opa.global_entity_id,
        opa.country_name,
        DATE_TRUNC(opa.report_period,MONTH) as report_period,
        opa.city_group,
        opa.category_group_global,
        opa.is_key_account,
        opa.store_type_group,
        opa.product_type as product_company_market,
        opa.product_company,
        "" AS product_type,
        "" AS product_subtype,
        "" AS product_name,
        CASE WHEN opa.is_option IS TRUE THEN "Option" ELSE "Product" END AS product_option,
        CASE WHEN opa.is_upsell IS TRUE THEN 'With Upselling' ELSE 'Without Upselling' END AS product_upsell,
        COUNT(DISTINCT opa.analytical_customer_id)   as customers,
        COUNT(DISTINCT opa.vendor_id)   as vendors,
        COUNT(DISTINCT opa.order_id)        as orders,
        SUM(opa.quantity)                   as quantity,
        SUM(opa.total_price_lc)             as total_price_lc,
        SUM(opa.total_price_eur)            as total_price_eur
    FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level` AS opa
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    ),

    company_split_consolidated AS (
    SELECT * FROM company_level_split_daily
    UNION ALL
    SELECT * FROM company_level_split_weekly
    UNION ALL
    SELECT * FROM company_level_split_monthly
    )

    SELECT *
    FROM company_split_consolidated

      ;;
    sql_trigger_value: SELECT MAX(report_period) FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level`  ;;
    partition_keys: ["report_period"]
    cluster_keys: ["period_seg","global_entity_id","product_company"]
  }
}

    # UNION ALL

    # SELECT
    #   period_seg,
    #   "Test" AS global_entity_id,
    #   "Test" AS country_name,
    #   report_period,
    #   "Test" AS city_group,
    #   "Test" AS category_group_global,
    #   is_key_account,
    #   store_type_group,
    #   "Test" AS product_company_market,
    #   "Test" AS product_company,
    #   "" AS product_type,
    #   "" AS product_subtype,
    #   "" AS product_name,
    #   product_option,
    #   product_upsell,
    #   customers,
    #   vendors,
    #   orders,
    #   quantity,
    #   total_price_lc,
    #   total_price_eur
    # FROM company_split_consolidated
    # WHERE global_entity_id IN ('FP_SG',"MJM_AT")
    # AND product_company IN ('Coca Cola')
