# view: talabat_incidence_rate {
#   derived_table: {
#     sql:
#     WITH metadata_level_weekly
#       AS (
#       SELECT DISTINCT
#           'Weekly' AS period_seg,
#           opa.global_entity_id,
#           opa.country_name,
#           DATE_TRUNC(opa.report_period,WEEK) as report_period,
#           opa.product_company,
#           opa.city_group,
#           opa.store_type_group,
#           opa.vendor_id
#       FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level`        AS opa
#       INNER JOIN `fulfillment-dwh-production.curated_data_shared_central_dwh.global_entities` USING (global_entity_id)
#       WHERE opa.report_period BETWEEN DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), MONTH) AND CURRENT_DATE()
#       AND management_entity = "Talabat" OR management_entity = "Instashop"
#       ),

#       metadata_level_monthly
#       AS (
#       SELECT DISTINCT
#           'Monthly' AS period_seg,
#           opa.global_entity_id,
#           opa.country_name,
#           DATE_TRUNC(opa.report_period,MONTH) as report_period,
#           opa.product_company,
#           opa.city_group,
#           opa.store_type_group,
#           opa.vendor_id
#       FROM `fulfillment-dwh-production.rl_sales_revenue.partnerships_order_level`       AS opa
#       INNER JOIN `fulfillment-dwh-production.curated_data_shared_central_dwh.global_entities` USING (global_entity_id)
#       WHERE opa.report_period BETWEEN DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), MONTH) AND CURRENT_DATE()
#       AND management_entity = "Talabat" OR management_entity = "Instashop"
#       ),

#       vendor_weekly
#       AS (
#       SELECT
#           'Weekly' AS period_seg,
#           global_entity_id,
#           DATE_TRUNC(report_date,WEEK) as report_period,
#           vendor_id,
#           successful_orders AS orders
#       FROM `fulfillment-dwh-production.curated_data_shared_central_dwh.agg_vendor_kpis_daily`
#       WHERE report_date BETWEEN DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), MONTH) AND CURRENT_DATE()
#       ),

#       vendor_monthly
#       AS (
#       SELECT
#           'Monthly' AS period_seg,
#           global_entity_id,
#           DATE_TRUNC(report_date,MONTH) as report_period,
#           vendor_id,
#           successful_orders AS orders
#       FROM `fulfillment-dwh-production.curated_data_shared_central_dwh.agg_vendor_kpis_daily`
#       WHERE report_date BETWEEN DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), MONTH) AND CURRENT_DATE()
#       )

#       SELECT
#           period_seg,
#           global_entity_id,
#           country_name,
#           report_period,
#           city_group,
#           product_company,
#           store_type_group,
#           COUNT(DISTINCT vendor_id)   as vendors,
#           SUM(orders)        as orders
#       FROM metadata_level_weekly
#       LEFT JOIN vendor_weekly USING (period_seg,global_entity_id,report_period,vendor_id)
#       GROUP BY 1,2,3,4,5,6,7

#       UNION ALL

#       SELECT
#           period_seg,
#           global_entity_id,
#           country_name,
#           report_period,
#           city_group,
#           product_company,
#           store_type_group,
#           COUNT(DISTINCT vendor_id)   as vendors,
#           SUM(orders)        as orders
#       FROM metadata_level_monthly
#       LEFT JOIN vendor_monthly USING (period_seg,global_entity_id,report_period,vendor_id)
#       GROUP BY 1,2,3,4,5,6,7
#       ;;
#     datagroup_trigger: talabat_incidence_rate
#     partition_keys: ["report_period"]
#     cluster_keys: ["product_company","global_entity_id"]
#   }


# dimension: date_granularity {
#   type: string
#   sql: ${TABLE}.period_seg ;;
# }

# dimension: date {
#   order_by_field: order_date
#   group_label: "Date Dimension"
#   sql:
#     CASE
#       WHEN ${date_granularity} = 'Weekly'
#         THEN ${order_week}
#       WHEN ${date_granularity} = 'Monthly'
#         THEN format_datetime('%b %y',${TABLE}.report_period)
#       ELSE NULL
#     END ;;
# }

# dimension_group: order {
#   #convert_tz: no
#   type: time
#   datatype: datetime
#   description: "Local time when the order was placed. This is partitioning column."
#   timeframes: [
#     raw,
#     hour,
#     hour_of_day,
#     time,
#     date,
#     week,
#     day_of_week,
#     week_of_year,
#     month,
#     month_name,
#     quarter,
#     year
#   ]
#   sql: ${TABLE}.report_period ;;
# }

# dimension: date_string {
#   type: string
#   sql: ${TABLE}.date_string ;;
# }


# dimension: global_entity_id {
#   hidden: yes
#   type: string
#   group_label: "Global Entity"
#   description: "GEID, identifier for the sub_entity/brand. Example: 'CD_CO', 'PY_AR', etc."
#   sql: ${TABLE}.global_entity_id ;;
# }

# dimension: country {
#   type: string
#   group_label: "Global Entity"
#   sql: ${TABLE}.country_name ;;
# }

# dimension: product_company {
#   type: string
#   group_label: "Global Entity"
#   sql: ${TABLE}.product_company ;;
# }

# dimension: city{
#   order_by_field: city_sorting
#   type: string
#   group_label: "Global Entity"
#   sql: INITCAP(${TABLE}.city_group);;
# }

# dimension: city_sorting{
#   type: string
#   group_label: "Global Entity"
#   sql: CASE WHEN ${city} = "Other" Then "ω" ELSE ${city} END;;
# }

# dimension: is_key_account {
#   type: yesno
#   sql: ${TABLE}.is_key_account ;;
# }

# dimension: store_type {
#   type: string
#   sql: ${TABLE}.store_type_group ;;
# }


# measure: orders {
#   type: sum
#   sql: ${TABLE}.orders ;;
# }

# # measure: restaurants {
# #   type: sum
# #   sql: ${TABLE}.vendors ;;
# # }

# }
