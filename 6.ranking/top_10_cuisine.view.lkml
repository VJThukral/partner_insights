view: top_10_cuisine {
  label: ""
  derived_table: {
    explore_source: brand_level {
      column: category_group_global {}
      column: total_order {}
      derived_column: rank { sql: rank() over (order by total_order desc);;}
      bind_all_filters: yes
      sort: { field: total_order desc: yes}
    }
  }
  dimension: category_group_global {}
  dimension: rank {
    type: number
  }

  dimension: cuisine_ranked_order {
    type: number
    sql: case
          when ${cuisine_ranked} = "Others" THEN 11
          else ${rank}
          end;;
  }

  dimension: cuisine_ranked {
    label: "Cuisine Type"
    order_by_field: cuisine_ranked_order
    type: string
    sql: case
          when ${rank} <= 10 then ${category_group_global}
          else "Others"
          end;;
  }

}
