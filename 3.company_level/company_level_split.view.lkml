view: company_level_split {
  derived_table: {
    sql:
      SELECT *
      FROM `dhub-vendor.cl_vendor.partnerships_company_level`
      WHERE data_granularity = "With option"
      ;;
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
