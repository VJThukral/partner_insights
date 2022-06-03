view: top_50_companies {
  derived_table: {
    explore_source: product_level_2 {
      column: product_company {}
      column: total_cat_price {}
      derived_column: rank { sql: rank() over (order by total_cat_price desc);;}
      bind_all_filters: yes
      sort: { field: total_cat_price desc: yes}
    }
  }
  dimension: product_company {}
  dimension: rank {
    type: number
  }

  dimension: company_ranked_order {
    type: number
    sql: case
          when ${company_ranked} = "Others" THEN 51
          else ${rank}
          end;;
  }

  dimension: company_ranked {
    order_by_field: company_ranked_order
    type: string
    sql: case
          when ${rank} <= 49 then ${product_company}
          else "Others"
          end;;
  }

}
