view: top_100_vendors {
  derived_table: {
    explore_source: product_level {
      column: vendor_name {}
      column: total_cat_price {}
      derived_column: rank { sql: rank() over (order by total_cat_price desc);;}
      bind_all_filters: yes
      sort: { field: total_cat_price desc: yes}
    }
  }

  parameter: top_n_vendor {
    type: unquoted
    default_value: "10"
    allowed_value: {
      label: "Top 10"
      value: "10"
    }
    allowed_value: {
      label: "Top 100"
      value: "100"
    }
  }

  dimension: vendor_name {
    sql: ${TABLE}.vendor_name ;;
  }
  dimension: rank {
    hidden: yes
    type: number
  }

  dimension: vendor_ranked_order {
    hidden: yes
    type: number
    sql: case
          when ${vendor_ranked} = "Others" THEN {% parameter top_n_vendor %} + 1
          else ${rank}
          end;;
  }

  dimension: vendor_ranked {
    label: "Top {% parameter top_n_vendor %} Partners"
    order_by_field: vendor_ranked_order
    type: string
    sql: case
        WHEN ${rank} <= {% parameter top_n_vendor %}
          THEN ${vendor_name}
          else "Others"
          end;;
  }

}
