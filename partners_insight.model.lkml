connection: "data_hub"

include: "/**/*.view.lkml"  # include all views in the views/ folder in this project

datagroup: central_dwh_orders {
  sql_trigger: SELECT COUNT(*) FROM `dhh-ncr-stg.dev_sales_revenue.partnerships_order_level` WHERE report_period >= DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY) ;;
  max_cache_age: "24 hours"
}

explore: product_level_daily {
  view_label: "Orders"
  label: "Orders"
  persist_with: central_dwh_orders

}

explore: market_share {
  view_label: "Market Share"
  label: "Market Share"
  persist_with: central_dwh_orders

}

explore: top_restaurants {
  view_label: "Top Restaurants"
  label: "Top Restaurants"
  persist_with: central_dwh_orders

}
