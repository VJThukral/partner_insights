view: brand_level_all {
  derived_table: {
    sql:WITH brand_level_all_daily
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
          opa.product_type,
          opa.product_subtype,
          opa.product_name,
          "All" AS is_option,
          "All" AS is_upsell,
          COUNT(DISTINCT opa.analytical_customer_id)   as customers,
          COUNT(DISTINCT opa.vendor_id)   as vendors,
          COUNT(DISTINCT opa.order_id)        as orders,
          SUM(opa.quantity)                   as quantity,
          SUM(opa.total_price_lc)             as total_price_lc,
          SUM(opa.total_price_eur)            as total_price_eur
      FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level` AS opa
      GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
      ),

      brand_level_all_weekly
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
      opa.product_type,
      opa.product_subtype,
      opa.product_name,
      "All" AS is_option,
      "All" AS is_upsell,
      COUNT(DISTINCT opa.analytical_customer_id)   as customers,
      COUNT(DISTINCT opa.vendor_id)   as vendors,
      COUNT(DISTINCT opa.order_id)        as orders,
      SUM(opa.quantity)                   as quantity,
      SUM(opa.total_price_lc)             as total_price_lc,
      SUM(opa.total_price_eur)            as total_price_eur
      FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level` AS opa
      GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
      ),

      brand_level_all_monthly
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
      opa.product_type,
      opa.product_subtype,
      opa.product_name,
      "All" AS is_option,
      "All" AS is_upsell,
      COUNT(DISTINCT opa.analytical_customer_id)   as customers,
      COUNT(DISTINCT opa.vendor_id)   as restaurants,
      COUNT(DISTINCT opa.order_id)        as vendors,
      SUM(opa.quantity)                   as quantity,
      SUM(opa.total_price_lc)             as total_price_lc,
      SUM(opa.total_price_eur)            as total_price_eur
      FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level` AS opa
      GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
      )

      SELECT * FROM brand_level_all_daily
      UNION ALL
      SELECT * FROM brand_level_all_weekly
      UNION ALL
      SELECT * FROM brand_level_all_monthly
      ;;

    datagroup_trigger: central_dwh_orders
    partition_keys: ["report_period"]
    cluster_keys: ["period_seg","global_entity_id","product_company"]
  }
}
