- dashboard: sale_reporting
  title: Sale Reporting
  layout: newspaper
  preferred_viewer: dashboards-next
  description: Partnerships - Sale Reporting (With Upselling)
  preferred_slug: Xdoj3FNX1hS1G1MDzXJihV
  elements:
  - title: Total Volume (Units Sold)
    name: Total Volume (Units Sold)
    model: partners_insight
    explore: product_level
    type: looker_column
    fields: [product_level.date, product_level.breakdown, product_level.total_cat_price,
      product_level.total_cat_quantity]
    pivots: [product_level.breakdown]
    filters: {}
    sorts: [product_level.breakdown, product_level.date]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-categorical-0
      options:
        steps: 5
        reverse: false
    y_axes: [{label: '', orientation: left, series: [{axisId: product_level.total_quantity,
            id: product_level.total_quantity, name: Total Volume}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    hide_legend: true
    label_value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0'
    series_colors: {}
    hidden_fields: [product_level.total_price, product_level.total_cat_price]
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: 'Total number of units sold '
    listen:
      Breakdown: product_level.breakdown_type
      Country: product_level.country
      City: product_level.city
      Product Company: product_level.product_company
      Product Brand: product_level.product_name
      Product Size: product_level.product_size
      Cuisine Group: product_level.category_group_global
      Product Type: product_level.product_type
      Upselling: product_level.upselling
      Is Key Account: product_level.is_key_account
      Time Frame: product_level.order_date
      Date Granularity: product_level.date_granularity
      Currency: product_level.currency_picker
    row: 4
    col: 0
    width: 24
    height: 7
  - title: Total Sales (Figure in Chosen Currency)
    name: Total Sales (Figure in Chosen Currency)
    model: partners_insight
    explore: product_level
    type: looker_column
    fields: [product_level.date, product_level.breakdown, product_level.total_cat_price,
      product_level.total_cat_quantity]
    pivots: [product_level.breakdown]
    filters: {}
    sorts: [product_level.breakdown, product_level.date]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-categorical-0
      options:
        steps: 5
        reverse: false
    y_axes: [{label: '', orientation: left, series: [{axisId: product_level.total_quantity,
            id: product_level.total_quantity, name: Total Volume}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    hide_legend: true
    label_value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0.00'
    series_colors: {}
    hidden_fields: [product_level.total_quantity, product_level.total_cat_quantity]
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: Total amount of revenue (in chosen currency) generated
    listen:
      Breakdown: product_level.breakdown_type
      Country: product_level.country
      City: product_level.city
      Product Company: product_level.product_company
      Product Brand: product_level.product_name
      Product Size: product_level.product_size
      Cuisine Group: product_level.category_group_global
      Product Type: product_level.product_type
      Upselling: product_level.upselling
      Is Key Account: product_level.is_key_account
      Time Frame: product_level.order_date
      Date Granularity: product_level.date_granularity
      Currency: product_level.currency_picker
    row: 11
    col: 0
    width: 24
    height: 7
  - title: Total Orders
    name: Total Orders
    model: partners_insight
    explore: product_level
    type: looker_column
    fields: [product_level.date, product_level.breakdown, product_level.total_order]
    pivots: [product_level.breakdown]
    filters: {}
    sorts: [product_level.breakdown, product_level.date]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-categorical-0
      options:
        steps: 5
        reverse: false
    y_axes: [{label: '', orientation: left, series: [{axisId: product_level.total_quantity,
            id: product_level.total_quantity, name: Total Volume}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    hide_legend: true
    label_value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0.00'
    series_colors: {}
    hidden_fields: [product_level.total_quantity]
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: Total amount of orders generated
    listen:
      Breakdown: product_level.breakdown_type
      Country: product_level.country
      City: product_level.city
      Product Company: product_level.product_company
      Product Brand: product_level.product_name
      Product Size: product_level.product_size
      Cuisine Group: product_level.category_group_global
      Product Type: product_level.product_type
      Upselling: product_level.upselling
      Is Key Account: product_level.is_key_account
      Time Frame: product_level.order_date
      Date Granularity: product_level.date_granularity
      Currency: product_level.currency_picker
    row: 18
    col: 0
    width: 24
    height: 7
  - title: Untitled
    name: Untitled
    model: partners_insight
    explore: product_level_daily
    type: single_value
    fields: [product_level_daily.timeframes, product_level_daily.total_cat_price,
      product_level_daily.PoP_change]
    fill_fields: [product_level_daily.timeframes]
    filters: {}
    sorts: [product_level_daily.timeframes desc]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: 'if(row()=max(row()),yes,no)',
        label: New Calculation, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, table_calculation: new_calculation, _type_hint: yesno,
        id: dOOQQYqk0q}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Current Period's GMV
    value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0.00'
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_points_if_no: [new_calculation]
    series_types: {}
    note_state: collapsed
    note_display: above
    note_text: GMV
    listen:
      Country: product_level_daily.country
      City: product_level_daily.city
      Product Company: product_level_daily.product_company
      Product Brand: product_level_daily.product_name
      Product Size: product_level_daily.product_size
      Cuisine Group: product_level_daily.category_group_global
      Product Type: product_level_daily.product_type
      Upselling: product_level_daily.upselling
      Is Key Account: product_level_daily.is_key_account
      Time Frame: product_level_daily.order_date
      Date Granularity: product_level_daily.date_granularity
      Currency: product_level_daily.currency_picker
    row: 0
    col: 0
    width: 8
    height: 4
  - title: Untitled (Copy)
    name: Untitled (Copy)
    model: partners_insight
    explore: product_level_daily
    type: single_value
    fields: [product_level_daily.timeframes, product_level_daily.total_cat_quantity,
      product_level_daily.PoP_volume_change]
    fill_fields: [product_level_daily.timeframes]
    filters: {}
    sorts: [product_level_daily.timeframes desc]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: 'if(row()=max(row()),yes,no)',
        label: New Calculation, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, table_calculation: new_calculation, _type_hint: yesno,
        id: dOOQQYqk0q}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Current Period's GMV
    value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0.00'
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_points_if_no: [new_calculation]
    series_types: {}
    note_state: collapsed
    note_display: above
    note_text: Units Sold
    listen:
      Country: product_level_daily.country
      City: product_level_daily.city
      Product Company: product_level_daily.product_company
      Product Brand: product_level_daily.product_name
      Product Size: product_level_daily.product_size
      Cuisine Group: product_level_daily.category_group_global
      Product Type: product_level_daily.product_type
      Upselling: product_level_daily.upselling
      Is Key Account: product_level_daily.is_key_account
      Time Frame: product_level_daily.order_date
      Date Granularity: product_level_daily.date_granularity
      Currency: product_level_daily.currency_picker
    row: 0
    col: 8
    width: 8
    height: 4
  - title: Untitled (Copy 2)
    name: Untitled (Copy 2)
    model: partners_insight
    explore: product_level_daily
    type: single_value
    fields: [product_level_daily.timeframes, product_level_daily.total_order, product_level_daily.PoP_order_change]
    fill_fields: [product_level_daily.timeframes]
    filters: {}
    sorts: [product_level_daily.timeframes desc]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: 'if(row()=max(row()),yes,no)',
        label: New Calculation, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, table_calculation: new_calculation, _type_hint: yesno,
        id: dOOQQYqk0q}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Current Period's GMV
    value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0.00'
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_points_if_no: [new_calculation]
    series_types: {}
    note_state: collapsed
    note_display: above
    note_text: Orders
    listen:
      Country: product_level_daily.country
      City: product_level_daily.city
      Product Company: product_level_daily.product_company
      Product Brand: product_level_daily.product_name
      Product Size: product_level_daily.product_size
      Cuisine Group: product_level_daily.category_group_global
      Product Type: product_level_daily.product_type
      Upselling: product_level_daily.upselling
      Is Key Account: product_level_daily.is_key_account
      Time Frame: product_level_daily.order_date
      Date Granularity: product_level_daily.date_granularity
      Currency: product_level_daily.currency_picker
    row: 0
    col: 16
    width: 8
    height: 4
  - name: Sales Growth - Total Company vs Selected Brand
    title: Sales Growth - Total Company vs Selected Brand
    note_state: collapsed
    note_display: hover
    note_text: 'Sales Growth trend per Brand versus Total Company '
    merged_queries:
    - model: partners_insight
      explore: product_level_daily
      type: looker_line
      fields: [product_level_daily.total_cat_price, product_level_daily.date, total_category_price_previous]
      filters:
        product_level_daily.date_granularity: Monthly
        product_level_daily.product_company: "-Test"
        product_level_daily.currency_picker: eur
        product_level_daily.order_date: 12 months
      sorts: [product_level_daily.date]
      limit: 500
      dynamic_fields: [{category: measure, expression: '${product_level_daily.timeframes}="Previous
            Period"', label: Total Category Price (Previous), value_format: !!null '',
          value_format_name: !!null '', based_on: product_level_daily.total_cat_price,
          filter_expression: '${product_level_daily.timeframes}="Previous Period"',
          _kind_hint: measure, measure: total_category_price_previous, type: sum,
          _type_hint: number, id: dMPAgOtcuj}, {category: table_calculation, expression: "${product_level_daily.total_cat_price}/(if(row()=max(row()),offset(${total_category_price_previous},-1),offset(${product_level_daily.total_cat_price},-1)))-1",
          label: "% PoP_Selected Brand", value_format: !!null '', value_format_name: percent_0,
          _kind_hint: measure, table_calculation: pop_selected_brand, _type_hint: number,
          id: Ftptz6p7GC}]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      y_axis_tick_density_custom: 5
      show_x_axis_label: false
      show_x_axis_ticks: true
      y_axis_scale_mode: linear
      x_axis_reversed: false
      y_axis_reversed: false
      plot_size_by_field: false
      trellis: ''
      stacking: ''
      limit_displayed_rows: false
      legend_position: center
      point_style: circle_outline
      show_value_labels: true
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      show_null_points: false
      interpolation: linear
      color_application:
        collection_id: new-custom-collection
        palette_id: new-custom-collection-sequential-0
        options:
          steps: 5
      y_axes: [{label: '', orientation: left, series: [{axisId: pop, id: 000000 -
                pop, name: "."}, {axisId: pop, id: A&W - pop, name: A&W - % PoP},
            {axisId: pop, id: Coca-Cola - pop, name: Coca-Cola - % PoP}, {axisId: total_company_pop,
              id: total_company_pop, name: Total Company - %PoP}], showLabels: false,
          showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
          type: linear}]
      hidden_series: []
      hide_legend: false
      series_types:
        000000 - pop: scatter
      series_colors:
        000000 - pop: white
      series_labels:
        000000 - pop_selected_brand: "."
        000000 - pop: "."
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false
      show_comparison_label: true
      enable_conditional_formatting: false
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      single_value_title: Current Period's GMV
      value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0.00'
      ordering: none
      show_null_labels: false
      show_totals_labels: false
      show_silhouette: false
      totals_color: "#808080"
      defaults_version: 1
      hidden_points_if_no: []
      hidden_fields: [euro, new_calculation_1, total_category_price_previous, product_level_daily.total_cat_price]
      show_row_numbers: true
      transpose: false
      truncate_text: true
      hide_totals: false
      hide_row_totals: false
      size_to_fit: true
      table_theme: white
      header_text_alignment: left
      header_font_size: 12
      rows_font_size: 12
    - model: partners_insight
      explore: product_level_daily
      type: table
      fields: [product_level_daily.date, product_level_daily.total_cat_price, total_category_price_previous]
      filters:
        product_level_daily.date_granularity: Monthly
        product_level_daily.product_company: "-Test"
        product_level_daily.currency_picker: eur
      sorts: [product_level_daily.date]
      limit: 500
      dynamic_fields: [{category: measure, expression: '${product_level_daily.timeframes}
            = "Previous Period"', label: Total Category Price (Previous), value_format: !!null '',
          value_format_name: !!null '', based_on: product_level_daily.total_cat_price,
          filter_expression: '${product_level_daily.timeframes} = "Previous Period"',
          _kind_hint: measure, measure: total_category_price_previous, type: sum,
          _type_hint: number, id: kvwtrFbhPC}, {category: table_calculation, expression: "${product_level_daily.total_cat_price}/(if(row()=max(row()),offset(${total_category_price_previous},-1),offset(${product_level_daily.total_cat_price},-1)))-1",
          label: "% PoP_Total Company", value_format: !!null '', value_format_name: percent_0,
          _kind_hint: measure, table_calculation: pop_total_company, _type_hint: number,
          id: vqmRkW1XYe}]
      join_fields:
      - field_name: product_level_daily.date
        source_field_name: product_level_daily.date
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: pop_selected_brand,
            id: pop_selected_brand, name: "% PoP_Selected Brand"}, {axisId: pop_total_company,
            id: pop_total_company, name: "% PoP_Total Company"}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    series_types: {}
    point_style: circle_outline
    series_colors:
      pop_total_company: "#000000"
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    type: looker_line
    hidden_fields: [product_level_daily.total_cat_price, total_category_price_previous,
      q1_product_level_daily.total_cat_price, q1_total_category_price_previous]
    listen:
    - Country: product_level_daily.country
      City: product_level_daily.city
      Product Company: product_level_daily.product_company
      Product Brand: product_level_daily.product_name
      Product Size: product_level_daily.product_size
      Cuisine Group: product_level_daily.category_group_global
      Product Type: product_level_daily.product_type
      Upselling: product_level_daily.upselling
      Is Key Account: product_level_daily.is_key_account
      Time Frame: product_level_daily.order_date
      Date Granularity: product_level_daily.date_granularity
      Currency: product_level_daily.currency_picker
    - Country: product_level_daily.country
      City: product_level_daily.city
      Product Company: product_level_daily.product_company
      Cuisine Group: product_level_daily.category_group_global
      Product Type: product_level_daily.product_type
      Upselling: product_level_daily.upselling
      Is Key Account: product_level_daily.is_key_account
      Time Frame: product_level_daily.order_date
      Date Granularity: product_level_daily.date_granularity
      Currency: product_level_daily.currency_picker
    row: 25
    col: 0
    width: 24
    height: 7
  - title: Average Basket Value
    name: Average Basket Value
    model: partners_insight
    explore: product_level
    type: looker_column
    fields: [product_level.date, product_level.aov]
    filters: {}
    sorts: [product_level.date]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-categorical-0
      options:
        steps: 5
        reverse: false
    y_axes: [{label: '', orientation: left, series: [{axisId: product_level.total_quantity,
            id: product_level.total_quantity, name: Total Volume}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    hide_legend: true
    label_value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0.00'
    series_colors: {}
    hidden_fields: [product_level.total_quantity]
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: Average order value
    listen:
      Breakdown: product_level.breakdown_type
      Country: product_level.country
      City: product_level.city
      Product Company: product_level.product_company
      Product Brand: product_level.product_name
      Product Size: product_level.product_size
      Cuisine Group: product_level.category_group_global
      Product Type: product_level.product_type
      Upselling: product_level.upselling
      Is Key Account: product_level.is_key_account
      Time Frame: product_level.order_date
      Date Granularity: product_level.date_granularity
      Currency: product_level.currency_picker
    row: 32
    col: 0
    width: 24
    height: 7
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: [City, Cuisine Group, Product Type, Upselling, Product Size,
      Product Company, Product Brand]
    field: product_level.country
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: [Cuisine Group, Product Type, Upselling, Product Size, Product
        Company, Product Brand, Country]
    field: product_level.city
  - name: Product Company
    title: Product Company
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: [City, Cuisine Group, Product Type, Upselling, Product Size,
      Product Brand, Country]
    field: product_level.product_company
  - name: Product Brand
    title: Product Brand
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: [City, Cuisine Group, Product Type, Upselling, Product Size,
      Product Company, Country]
    field: product_level.product_name
  - name: Product Size
    title: Product Size
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: [Product Company, Product Brand, Country]
    field: product_level.product_size
  - name: Cuisine Group
    title: Cuisine Group
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: [City, Product Type, Upselling, Product Size, Product Company,
      Product Brand, Country]
    field: product_level.category_group_global
  - name: Product Type
    title: Product Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: [City, Cuisine Group, Upselling, Product Size, Product Company,
      Product Brand, Country]
    field: product_level.product_type
  - name: Upselling
    title: Upselling
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: [Product Size, Product Company, Product Brand, Country]
    field: product_level.upselling
  - name: Is Key Account
    title: Is Key Account
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: []
    field: product_level.is_key_account
  - name: Time Frame
    title: Time Frame
    type: field_filter
    default_value: 12 month
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: partners_insight
    explore: product_level
    listens_to_filters: []
    field: product_level.order_date
  - name: Currency
    title: Currency
    type: field_filter
    default_value: eur
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: []
    field: product_level.currency_picker
  - name: Date Granularity
    title: Date Granularity
    type: field_filter
    default_value: Monthly
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: popover
    model: partners_insight
    explore: product_level
    listens_to_filters: [Upselling, Product Size, Product Company, Product Brand,
      Country]
    field: product_level.date_granularity
  - name: Breakdown
    title: Breakdown
    type: field_filter
    default_value: None
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: partners_insight
    explore: product_level
    listens_to_filters: []
    field: product_level.breakdown_type
