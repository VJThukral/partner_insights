connection: "dhh-ncr-live"

include: "/**/*.view.lkml"  # include all views in the views/ folder in this project
#include: "/**/*.dashboard.lookml"

datagroup: central_dwh_orders {
  sql_trigger: SELECT COUNT(*) FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_product_level` ;;
  max_cache_age: "24 hours"
}

# datagroup: coke_aut {
#   sql_trigger: SELECT DATE_TRUNC(DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY),MONTH) ;; #Refresh on the 2nd of each month
#   max_cache_age: "24 hours"
# }

# datagroup: talabat_incidence_rate {
#   sql_trigger: SELECT DATE_TRUNC(DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY),WEEK) ;; #Refresh on the 2nd of each month
#   max_cache_age: "24 hours"
# }

explore: product_level {
  sql_always_where: ${order_raw} BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 14 MONTH), MONTH)) AND CURRENT_DATE() ;;
  always_filter: {
    filters: [product_level.date_granularity: "Monthly",product_level.product_company: "-Test"]
  }

  label: "Partnership - Product Level"
  view_label: "Partnership - Product Level"
  persist_with: central_dwh_orders

  access_filter: {
    field: product_company
    user_attribute: product_cpg
  }

  access_filter: {
    field: store_type
    user_attribute: shoptype
  }

  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }
}

explore: product_level_daily {
  sql_always_where: ${order_raw} BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 14 MONTH), MONTH)) AND CURRENT_DATE() ;;
  always_filter: {
    filters: [product_level_daily.date_granularity: "Monthly",product_level_daily.product_company: "-Test"]
  }

  label: "Partnership - Product Level Daily"
  view_label: "Partnership - Product Level Daily"
  persist_with: central_dwh_orders

  access_filter: {
    field: product_company
    user_attribute: product_cpg
  }

  access_filter: {
    field: store_type
    user_attribute: shoptype
  }

  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }
}

explore: product_level_2 {
  sql_always_where: ${order_raw} BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 14 MONTH), MONTH)) AND CURRENT_DATE() ;;
  always_filter: {
    filters: [product_level_2.product_company_market: "-NULL",product_level_2.product_company_filter: "-Test"]
  }

  label: "Partnership - Market Share"
  view_label: "Partnership - Market Share"
  persist_with: central_dwh_orders

  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }

  access_filter: {
    field: store_type
    user_attribute: shoptype
  }

  access_filter: {
    field: product_company_filter
    user_attribute: product_cpg
  }

  join: top_50_companies {
    view_label: "Top 50 Companies"
    sql_on: ${top_50_companies.product_company} = ${product_level_2.product_company}
      ;;

    type: inner
    relationship: many_to_one
  }
}


explore: top_restaurants {
  label: "Partnership - Top Restaurants"
  view_label: "Partnership - Top Restaurants"
  persist_with: central_dwh_orders

  access_filter: {
    field: product_company
    user_attribute: product_cpg
  }

  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }

}

explore: meta_data {
  sql_always_where: ${order_raw} BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 14 MONTH), MONTH)) AND CURRENT_DATE() ;;
  conditionally_filter: {
    filters: [meta_data.date_granularity: "Monthly"]
    unless: [date_granularity]
  }
  label: "Partnership - Country Data"
  view_label: "Partnership - Country Level"
  persist_with: central_dwh_orders

  access_filter: {
    field: store_type
    user_attribute: shoptype
  }

  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }

}

#   explore: product_level_without_upselling {
#     conditionally_filter: {
#       filters: [product_level_without_upselling.date_granularity: "Monthly"]
#       unless: [date_granularity]
#     }
#     view_label: "Partnership - Brand Level"
#     label: "Brand Level"
#     persist_with: central_dwh_orders

#     access_filter: {
#       field: store_type
#       user_attribute: shoptype
#     }

#     access_filter: {
#       field: product_company
#       user_attribute: product_cpg
#     }

#     access_filter: {
#       field: global_entity_id
#       user_attribute: global_entity_id
#     }
# }

explore: brand_level {
  sql_always_where: ${order_raw} BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 14 MONTH), MONTH)) AND CURRENT_DATE() ;;
  always_filter: {
    filters: [brand_level.date_granularity: "Monthly"]
  }
  label: "Partnership - Brand Level"
  view_label: "Partnership - Brand Level"
  persist_with: central_dwh_orders

  access_filter: {
    field: store_type
    user_attribute: shoptype
  }

  access_filter: {
    field: product_company
    user_attribute: product_cpg
  }


  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }
}

explore: brand_level_split {
  sql_always_where: ${order_raw} BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 14 MONTH), MONTH)) AND CURRENT_DATE() ;;
  always_filter: {
    filters: [brand_level_split.date_granularity: "Monthly"]
  }
  label: "Partnership - Brand Level (With Option/Upselling)"
  view_label: "Partnership - Brand Level (With Option/Upselling)"
  persist_with: central_dwh_orders

  access_filter: {
    field: store_type
    user_attribute: shoptype
  }

  access_filter: {
    field: product_company
    user_attribute: product_cpg
  }

  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }
}

explore: unique_customers {
  sql_always_where: ${order_raw} BETWEEN DATETIME(DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 14 MONTH), MONTH)) AND CURRENT_DATE() ;;
  view_label: "Partnership - Unique Customers"
  label: "Partnership - Unique Customers"
  persist_with: central_dwh_orders

  access_filter: {
    field: store_type
    user_attribute: shoptype
  }

  access_filter: {
    field: product_company
    user_attribute: product_cpg
  }

  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }
}

explore: orders_hour_weekday {
  view_label: "Partnership - Orders Hour Weekday"
  label: "Partnership - Orders Hour Weekday"
  persist_with: central_dwh_orders


  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }
}

explore: coke_aut {
  view_label: "Parnership Adhoc - Coke Austria"
  always_filter: {
    filters: [coke_aut.product_company: "Coca Cola"
              ,coke_aut.global_entity_id: "MJM_AT"
              , coke_aut.report_period: "1 month ago for 1 month"]
  }
}

# explore: talabat_incidence_rate {
#   view_label: "Parnership Adhoc - Talabat Incidence Rate"
# }
