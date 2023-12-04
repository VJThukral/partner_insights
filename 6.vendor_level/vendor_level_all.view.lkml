view: vendor_level_all {
  derived_table: {
    sql: SELECT *
    FROM `fulfillment-dwh-production.cl_vendor.partnerships_vendor_level`
    WHERE data_granularity = "No option"
    ;;
  }
}
