- dashboard: penetration_report
  title: Penetration Report
  layout: newspaper
  preferred_viewer: dashboards-next
  description: Penetration Report (With Upselling)
  preferred_slug: 3fpOMkhP7f2i7wLgQ0ZJYb
  elements:
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '<font color="black" size="5"><b>Country Total</b></font>

      '
    row: 0
    col: 0
    width: 24
    height: 2
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '<font color="black" size="5"><b>City Total</b></font>

      '
    row: 8
    col: 0
    width: 24
    height: 2
  - name: "% of Restaurants that sell Brand"
    title: "% of Restaurants that sell Brand"
    note_state: collapsed
    note_display: hover
    note_text: Your penetration % in total Delivery Hero restaurant portfolio
    merged_queries:
    - model: partners_insight
      explore: brand_level
      type: table
      fields: [brand_level.date, brand_level.total_vendors]
      filters:
        brand_level.date_granularity: Monthly
      sorts: [brand_level.total_vendors desc]
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields: []
    - model: partners_insight
      explore: meta_data
      type: table
      fields: [meta_data.date, meta_data.restaurants]
      filters:
        meta_data.date_granularity: Monthly
      sorts: [meta_data.restaurants desc]
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields:
      - field_name: meta_data.date
        source_field_name: brand_level.date
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: percentage, id: percentage,
            name: Percentage}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    type: looker_column
    hidden_fields: [check.total_vendors, meta_data.restaurants, brand_level.total_vendors]
    sorts: [brand_level.date]
    dynamic_fields: [{category: table_calculation, expression: "${brand_level.total_vendors}/${meta_data.restaurants}",
        label: Percentage, value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: percentage, _type_hint: number}]
    listen:
    - Product Company: brand_level.product_company
      Product Name: brand_level.product_name
      Upselling: brand_level.upselling
      Time Frame: brand_level.order_date
      Date Granularity: brand_level.date_granularity
      Is Key Account: brand_level.is_key_account
      Country: brand_level.country
      City: brand_level.city
    - Time Frame: meta_data.order_date
      Date Granularity: meta_data.date_granularity
      Is Key Account: meta_data.is_key_account
      Country: meta_data.country
      City: meta_data.city
    row: 2
    col: 6
    width: 6
    height: 6
  - title: Avg Sales per Restaurant
    name: Avg Sales per Restaurant
    model: partners_insight
    explore: brand_level
    type: looker_column
    fields: [brand_level.date, brand_level.total_vendors, brand_level.total_cat_quantity]
    filters: {}
    sorts: [brand_level.date]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${brand_level.total_cat_quantity}/${brand_level.total_vendors}",
        label: Average Sales per Restaurant, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: average_sales_per_restaurant, _type_hint: number}]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: average_sales_per_restaurant,
            id: average_sales_per_restaurant, name: Average Sales per Restaurant}],
        showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    label_value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0'
    hidden_fields: [brand_level.total_quantity, brand_level.total_vendors, brand_level.total_cat_quantity]
    defaults_version: 1
    listen:
      Product Company: brand_level.product_company
      Product Name: brand_level.product_name
      Upselling: brand_level.upselling
      Time Frame: brand_level.order_date
      Date Granularity: brand_level.date_granularity
      Is Key Account: brand_level.is_key_account
      Country: brand_level.country
      City: brand_level.city
    row: 2
    col: 12
    width: 6
    height: 6
  - title: Avg Revenue per Restaurant
    name: Avg Revenue per Restaurant
    model: partners_insight
    explore: brand_level
    type: looker_column
    fields: [brand_level.date, brand_level.total_vendors, brand_level.total_cat_price]
    filters: {}
    sorts: [brand_level.date]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${brand_level.total_cat_price}/${brand_level.total_vendors}",
        label: Average Revenue per Restaurant, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: average_revenue_per_restaurant, _type_hint: number}]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: average_sales_per_restaurant,
            id: average_sales_per_restaurant, name: Average Sales per Restaurant}],
        showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    label_value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0'
    hidden_fields: [brand_level.total_vendors, brand_level.total_price, brand_level.total_cat_price]
    defaults_version: 1
    listen:
      Product Company: brand_level.product_company
      Product Name: brand_level.product_name
      Upselling: brand_level.upselling
      Time Frame: brand_level.order_date
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
      Is Key Account: brand_level.is_key_account
      Country: brand_level.country
      City: brand_level.city
    row: 2
    col: 18
    width: 6
    height: 6
  - name: New Tile
    title: New Tile
    title_hidden: true
    merged_queries:
    - model: partners_insight
      explore: brand_level
      type: table
      fields: [brand_level.date, brand_level.total_vendors, brand_level.city, brand_level.total_cat_price,
        brand_level.total_cat_quantity]
      filters:
        brand_level.date_granularity: Monthly
      sorts: [brand_level.date desc, brand_level.city]
      limit: 5000
      hidden_fields: []
      y_axes: []
      join_fields: []
    - model: partners_insight
      explore: meta_data
      type: table
      fields: [meta_data.date, meta_data.restaurants, meta_data.city]
      filters:
        meta_data.date_granularity: Monthly
      sorts: [meta_data.date desc, meta_data.city]
      limit: 5000
      hidden_fields: []
      y_axes: []
      join_fields:
      - field_name: meta_data.date
        source_field_name: brand_level.date
      - field_name: meta_data.city
        source_field_name: brand_level.city
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    series_cell_visualizations:
      meta_data.restaurants:
        is_active: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axes: [{label: '', orientation: left, series: [{axisId: percentage, id: percentage,
            name: Percentage}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
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
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    type: looker_grid
    hidden_fields: [check.total_vendors, brand_level.total_vendors, meta_data.restaurants,
      brand_level.total_price, brand_level.total_quantity, brand_level.total_cat_quantity,
      brand_level.total_cat_price]
    series_types: {}
    sorts: [brand_level.date desc, brand_level.city]
    dynamic_fields: [{category: table_calculation, expression: "${meta_data.restaurants}",
        label: No. of Restaurants, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: no_of_restaurants, _type_hint: number},
      {category: table_calculation, expression: "${brand_level.total_vendors}/${meta_data.restaurants}",
        label: "% Restaurants that sell Brand", value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: restaurants_that_sell_brand, _type_hint: number},
      {category: table_calculation, expression: "${brand_level.total_cat_quantity}/${brand_level.total_vendors}",
        label: Avg. Sales per Restaurant, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: avg_sales_per_restaurant, _type_hint: number},
      {category: table_calculation, expression: "${brand_level.total_cat_price}/${brand_level.total_vendors}",
        label: Avg. Revenue per Restaurant, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: avg_revenue_per_restaurant, _type_hint: number}]
    listen:
    - Product Company: brand_level.product_company
      Product Name: brand_level.product_name
      Upselling: brand_level.upselling
      Time Frame: brand_level.order_date
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
      Is Key Account: brand_level.is_key_account
      Country: brand_level.country
      City: brand_level.city
    - Time Frame: meta_data.order_date
      Date Granularity: meta_data.date_granularity
      Is Key Account: meta_data.is_key_account
      Country: meta_data.country
      City: meta_data.city
    row: 10
    col: 0
    width: 24
    height: 7
  - title: Number of Restaurants
    name: Number of Restaurants
    model: partners_insight
    explore: brand_level
    type: looker_column
    fields: [brand_level.date, brand_level.total_vendors]
    filters: {}
    sorts: [brand_level.date]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${brand_level.total_quantity}/${brand_level.total_vendors}",
        label: Average Sales per Restaurant, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: average_sales_per_restaurant, _type_hint: number,
        is_disabled: true}]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: average_sales_per_restaurant,
            id: average_sales_per_restaurant, name: Average Sales per Restaurant}],
        showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    label_value_format: '[>=1000000]0.00,,"M";[>=1000]0.00,"K";0'
    hidden_fields: [brand_level.total_quantity]
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: 'The # of restaurants who have your brands listed on their menu'
    listen:
      Product Company: brand_level.product_company
      Product Name: brand_level.product_name
      Upselling: brand_level.upselling
      Time Frame: brand_level.order_date
      Date Granularity: brand_level.date_granularity
      Is Key Account: brand_level.is_key_account
      Country: brand_level.country
      City: brand_level.city
    row: 2
    col: 0
    width: 6
    height: 6
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
    explore: brand_level
    listens_to_filters: [City, Product Company, Upselling]
    field: brand_level.country
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
    explore: brand_level
    listens_to_filters: [Country, Product Company, Upselling]
    field: brand_level.city
  - name: Product Company
    title: Product Company
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: partners_insight
    explore: brand_level
    listens_to_filters: [Time Frame, Currency, Date Granularity, Is Key Account, Product
        Name, City, Country, Upselling]
    field: brand_level.product_company
  - name: Product Name
    title: Product Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: popover
    model: partners_insight
    explore: brand_level
    listens_to_filters: [City, Country, Product Company, Upselling]
    field: brand_level.product_name
  - name: Upselling
    title: Upselling
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: partners_insight
    explore: brand_level
    listens_to_filters: [Product Name, Product Company]
    field: brand_level.upselling
  - name: Time Frame
    title: Time Frame
    type: field_filter
    default_value: 4 month
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: partners_insight
    explore: meta_data
    listens_to_filters: []
    field: meta_data.order_date
  - name: Currency
    title: Currency
    type: field_filter
    default_value: eur
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: popover
      options: []
    model: partners_insight
    explore: brand_level
    listens_to_filters: []
    field: brand_level.currency_picker
  - name: Date Granularity
    title: Date Granularity
    type: field_filter
    default_value: Monthly
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: popover
      options: []
    model: partners_insight
    explore: meta_data
    listens_to_filters: [Time Frame, Currency, Is Key Account, Product Name, City,
      Country, Product Company, Upselling]
    field: meta_data.date_granularity
  - name: Is Key Account
    title: Is Key Account
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: popover
      options: []
    model: partners_insight
    explore: meta_data
    listens_to_filters: []
    field: meta_data.is_key_account
