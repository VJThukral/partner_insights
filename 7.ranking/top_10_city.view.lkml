view: top_10_city {
  derived_table: {
    explore_source: product_level {
      column: city {}
      column: total_cat_price {}
      derived_column: rank { sql: rank() over (order by total_cat_price desc);;}
      bind_all_filters: yes
      sort: { field: total_cat_price desc: yes}
    }
  }

  parameter: top_n_city {
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

  dimension: city {
    sql: ${TABLE}.city ;;
  }
  dimension: rank {
    hidden: yes
    type: number
  }

  dimension: city_ranked_order {
    hidden: yes
    type: number
    sql: case
          when ${city_ranked} = "Others" THEN {% parameter top_n_city %} + 1
          else ${rank}
          end;;
  }

  dimension: city_ranked {
    label: "Top {% parameter top_n_vendor %} Cities"
    order_by_field: city_ranked_order
    type: string
    sql: case
        WHEN ${rank} <= {% parameter top_n_city %}
          THEN ${city}
          else "Others"
          end;;
  }

}
