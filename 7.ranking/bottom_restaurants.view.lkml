view: bottom_restaurants {
  derived_table: {
    explore_source: top_restaurants {
      column: global_entity_id {}
      column: vendor_id {}
      column: vendor_name {}
      column: total_orders {}
      derived_column: rank { sql: row_number() over (order by total_orders asc);;}
      bind_all_filters: yes
      sort: { field: total_orders desc: no}
    }
  }

  parameter: top_n_vendor {
    type: unquoted
    default_value: "100"
    allowed_value: {
      label: "Top 100"
      value: "100"
    }
    allowed_value: {
      label: "Top 500"
      value: "500"
    }
  }
  dimension: global_entity_id {}
  dimension: vendor_id {}
  dimension: vendor_name {}
  dimension: rank {
    type: number
  }

  dimension: vendor_ranked_order {
    type: number
    sql: case
          when ${vendor_ranked_name} = "Others" THEN {% parameter top_n_vendor %} + 1
          else ${rank}
          end;;
  }

  dimension: vendor_ranked_name {
    label: "Restaurant Name"
    order_by_field: vendor_ranked_order
    type: string
    sql: case
          when ${rank} <= {% parameter top_n_vendor %} then ${vendor_name}
          else NULL
          end;;
  }

}
