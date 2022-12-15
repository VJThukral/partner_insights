- dashboard: customer_insights
  title: Customer Insights
  layout: newspaper
  preferred_viewer: dashboards-next
  description: Partnerships - Customer Insights
  preferred_slug: BOsmmh6o96VFqSRFtv7fN0
  elements:
  - title: 'Favorite Beverage Categories '
    name: 'Favorite Beverage Categories '
    model: partners_insight
    explore: product_level
    type: looker_grid
    fields: [product_level.product_subtype, new_dimension, product_level.total_cat_quantity]
    filters:
      product_level.date_granularity: Monthly
    sorts: [percentage desc]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${product_level.total_cat_quantity}/sum(${product_level.total_cat_quantity})",
        label: Percentage, value_format: !!null '', value_format_name: percent_2,
        _kind_hint: measure, table_calculation: percentage, _type_hint: number}, {
        category: dimension, expression: 'if(is_null(${product_level.product_subtype}),no,yes)',
        label: New Dimension, value_format: !!null '', value_format_name: !!null '',
        dimension: new_dimension, _kind_hint: dimension, _type_hint: yesno}]
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      product_level.product_subtype: Category
      product_level.category_group_global: Cuisine
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '5'
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    hidden_fields: [product_level.total_quantity, product_level.total_cat_quantity]
    hidden_points_if_no: [new_dimension]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Most ordered beverage category in the market
    listen:
      Country: product_level.country
      City: product_level.city
      Product Company: product_level.product_company
      Time Frame: product_level.order_date
    row: 16
    col: 0
    width: 12
    height: 4
  - title: Favorite Cuisines
    name: Favorite Cuisines
    model: partners_insight
    explore: product_level
    type: looker_grid
    fields: [product_level.category_group_global, product_level.total_order]
    filters: {}
    sorts: [percentage desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: percentage, _type_hint: number,
        category: table_calculation, expression: "${product_level.total_order}/sum(${product_level.total_order})",
        label: Percentage, value_format: !!null '', value_format_name: percent_2},
      {dimension: new_dimension, _kind_hint: dimension, _type_hint: yesno, category: dimension,
        expression: 'if(is_null(${product_level.product_subtype}),no,yes)', label: New
          Dimension, value_format: !!null '', value_format_name: !!null ''}]
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      product_level.product_subtype: Category
      product_level.category_group_global: Cuisine
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '5'
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    hidden_fields: [product_level.total_order]
    hidden_points_if_no: []
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Most ordered cuisine type in the market
    listen:
      Country: product_level.country
      City: product_level.city
      Product Company: product_level.product_company
      Time Frame: product_level.order_date
    row: 16
    col: 12
    width: 12
    height: 4
  - title: Unique Customers (Figure in Thousands)
    name: Unique Customers (Figure in Thousands)
    model: partners_insight
    explore: unique_customers
    type: looker_column
    fields: [unique_customers.date, unique_customers.new_customers, unique_customers.returning_customers,
      unique_customers.acquisition_ratio]
    filters: {}
    sorts: [unique_customers.date]
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
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: unique_customers.new_customers,
            id: unique_customers.new_customers, name: New Customers}, {axisId: unique_customers.returning_customers,
            id: unique_customers.returning_customers, name: Returning Customers}],
        showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: left, series: [{axisId: unique_customers.acquisition_ratio,
            id: unique_customers.acquisition_ratio, name: Acquisition Ratio}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    label_value_format: '[>=1000000]0.00,,"M";[>=1]0.00,"K";[<1]0%'
    series_types:
      unique_customers.acquisition_ratio: line
    series_colors:
      unique_customers.acquisition_ratio: "#ea8f93"
    defaults_version: 1
    hidden_fields: []
    note_state: collapsed
    note_display: hover
    note_text: New Customers who did not place an order in the last 6 months, Current
      Customers who already placed their orders in the last 6 months and Acquisition
      Ratio
    listen:
      Country: unique_customers.country
      City: unique_customers.city
      Product Company: unique_customers.product_company
      Product Name: unique_customers.product_name
      Time Frame: unique_customers.order_date
    row: 0
    col: 0
    width: 12
    height: 8
  - title: 'Meal Distribution (in Percentage of Orders) '
    name: 'Meal Distribution (in Percentage of Orders) '
    model: partners_insight
    explore: orders_hour_weekday
    type: looker_column
    fields: [orders_hour_weekday.total_order, orders_hour_weekday.daytime_distribution]
    filters: {}
    sorts: [orders_hour_weekday.daytime_distribution]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: day_time_distribution,
        _type_hint: number, category: table_calculation, expression: "${orders_hour_weekday.total_order}/sum(${orders_hour_weekday.total_order})",
        label: Day Time Distribution, value_format: !!null '', value_format_name: percent_0}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: day_time_distribution,
            id: day_time_distribution, name: Day Time Distribution}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    defaults_version: 1
    hidden_fields: [orders_hour_weekday.total_order]
    note_state: collapsed
    note_display: hover
    note_text: 'Day time distribution of Partners'' orders '
    listen:
      Country: orders_hour_weekday.country
      City: orders_hour_weekday.city
      Product Company: orders_hour_weekday.product_company
      Product Name: orders_hour_weekday.product_name
      Time Frame: orders_hour_weekday.order_date
    row: 8
    col: 12
    width: 12
    height: 8
  - title: Order Distribution (per Weekday)
    name: Order Distribution (per Weekday)
    model: partners_insight
    explore: orders_hour_weekday
    type: looker_column
    fields: [orders_hour_weekday.total_order, orders_hour_weekday.report_period_weekday]
    filters: {}
    sorts: [orders_hour_weekday.report_period_weekday]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: day_time_distribution,
        _type_hint: number, category: table_calculation, expression: "${orders_hour_weekday.total_order}/sum(${orders_hour_weekday.total_order})",
        label: Day Time Distribution, value_format: !!null '', value_format_name: percent_0}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: day_time_distribution,
            id: day_time_distribution, name: Day Time Distribution}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    defaults_version: 1
    hidden_fields: [orders_hour_weekday.total_order]
    note_state: collapsed
    note_display: hover
    note_text: Distribution of Partner's orders within weekdays
    listen:
      Country: orders_hour_weekday.country
      City: orders_hour_weekday.city
      Product Company: orders_hour_weekday.product_company
      Product Name: orders_hour_weekday.product_name
      Time Frame: orders_hour_weekday.order_date
    row: 8
    col: 0
    width: 12
    height: 8
  - name: Customer Frequency
    title: Customer Frequency
    note_state: collapsed
    note_display: hover
    note_text: Total Orders/Total Unique Customers
    merged_queries:
    - model: partners_insight
      explore: unique_customers
      type: looker_column
      fields: [unique_customers.date, unique_customers.total_customers]
      filters:
        unique_customers.country: Singapore
      sorts: [unique_customers.date]
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
      y_axes: [{label: '', orientation: left, series: [{axisId: unique_customers.total_customers,
              id: unique_customers.total_customers, name: Total Customers}], showLabels: false,
          showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
          type: linear}]
      label_value_format: ''
      defaults_version: 1
      hidden_fields: [unique_customers.total_customers, unique_customers.total_order]
      hidden_pivots: {}
    - model: partners_insight
      explore: brand_level
      type: table
      fields: [brand_level.date, brand_level.total_order]
      filters:
        brand_level.date_granularity: Monthly
      sorts: [brand_level.total_order desc 0]
      limit: 500
      join_fields:
      - field_name: brand_level.date
        source_field_name: unique_customers.date
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: customer_frequency,
            id: customer_frequency, name: Customer Frequency}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, type: linear}]
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
    x_axis_zoom: true
    y_axis_zoom: true
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    series_types: {}
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
    hidden_fields: [unique_customers.total_customers, brand_level.total_order]
    type: looker_column
    dynamic_fields: [{category: table_calculation, expression: "${brand_level.total_order}/${unique_customers.total_customers}",
        label: Customer Frequency, value_format: !!null '', value_format_name: decimal_1,
        _kind_hint: measure, table_calculation: customer_frequency, _type_hint: number}]
    listen:
    - Country: unique_customers.country
      City: unique_customers.city
      Product Company: unique_customers.product_company
      Product Name: unique_customers.product_name
      Time Frame: unique_customers.order_date
    - Country: brand_level.country
      City: brand_level.city
      Product Company: brand_level.product_company
      Product Name: brand_level.product_name
      Time Frame: brand_level.order_date
    row: 0
    col: 12
    width: 12
    height: 8
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
    listens_to_filters: [City, Product Company, Product Name]
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
    listens_to_filters: [Country, Product Company, Product Name]
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
    listens_to_filters: [Time Frame, Country, City, Product Name]
    field: brand_level.product_company
  - name: Product Name
    title: Product Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: partners_insight
    explore: brand_level
    listens_to_filters: [Country, City, Product Company]
    field: brand_level.product_name
  - name: Time Frame
    title: Time Frame
    type: field_filter
    default_value: 15 month
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
