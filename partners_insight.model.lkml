connection: "dhh-ncr-live"

include: "/**/*.view.lkml"  # include all views in the views/ folder in this project

datagroup: central_dwh_orders {
  sql_trigger: SELECT COUNT(*) FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_product_level` ;;
  max_cache_age: "24 hours"
}

datagroup: coke_aut {
  sql_trigger: SELECT DATE_TRUNC(DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY),MONTH) ;; #Refresh on the 2nd of each month
  max_cache_age: "24 hours"
}

datagroup: talabat_incidence_rate {
  sql_trigger: SELECT DATE_TRUNC(DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY),WEEK) ;; #Refresh on the 2nd of each month
  max_cache_age: "24 hours"
}

explore: product_level {
  conditionally_filter: {
    filters: [product_level.date_granularity: "Monthly"]
    unless: [date_granularity]
  }

  view_label: "Product"
  label: "Product"
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
  conditionally_filter: {
    filters: [product_level_2.date_granularity: "Monthly"]
    unless: [date_granularity]
  }

  view_label: "Product 2"
  always_filter: {
    filters: [product_level_2.product_company_market: "-NULL"]
  }
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
  view_label: "Top Restaurants"
  label: "Top Restaurants"
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
  conditionally_filter: {
    filters: [meta_data.date_granularity: "Monthly"]
    unless: [date_granularity]
  }
  view_label: "MetaData"
  label: "MetaData"
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

  explore: product_level_without_upselling {
    conditionally_filter: {
      filters: [product_level_without_upselling.date_granularity: "Monthly"]
      unless: [date_granularity]
    }
    view_label: "Product Level without Upselling"
    label: "Product Level without Upselling"
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

explore: product_level_with_upselling {
  conditionally_filter: {
    filters: [product_level_with_upselling.date_granularity: "Monthly"]
    unless: [date_granularity]
  }
  view_label: "Product Level with Upselling"
  label: "Product Level with Upselling"
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
    view_label: "Unique Customers"
    label: "Unique Customers"
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

explore: orders_hour_weekday {
  view_label: "Orders Hour Weekday"
  label: "Orders Hour Weekday"
  persist_with: central_dwh_orders


  access_filter: {
    field: global_entity_id
    user_attribute: global_entity_id
  }
}

explore: coke_aut {}

explore: talabat_incidence_rate {}
