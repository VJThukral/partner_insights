view: vendor_level_split {
  derived_table: {
    sql: SELECT *
          FROM `fulfillment-dwh-production.cl_vendor.partnerships_vendor_level`
          WHERE data_granularity = "With option"
          ;;
  }
}
