- dashboard: market_share_report
  title: Market Share Report
  layout: newspaper
  preferred_viewer: dashboards-next
  description: Market Share Report (With Upselling)
  preferred_slug: 8ajHlzqs1amGIecNikDS6l
  elements:
  - name: Market Share (Units Sold)
    title: Market Share (Units Sold)
    note_state: collapsed
    note_display: hover
    note_text: Market share (units) in relevant product category. Please align on
      the definition of relevant product category with your Delivery Hero partner
    merged_queries:
    - model: partners_insight
      explore: brand_level
      type: table
      fields: [brand_level.date, brand_level.total_cat_quantity]
      filters:
        brand_level.date_granularity: Monthly
      sorts: [brand_level.total_cat_quantity desc]
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields: []
    - model: partners_insight
      explore: product_level_2
      type: table
      fields: [product_level_2.date, product_level_2.total_cat_quantity]
      filters:
        product_level_2.product_company_market: "-NULL"
        product_level_2.date_granularity: Monthly
        product_level_2.product_company_filter: "-Test"
      sorts: [product_level_2.total_cat_quantity desc]
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields:
      - field_name: product_level_2.date
        source_field_name: brand_level.date
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-diverging-0
      options:
        steps: 5
        reverse: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: percentage, id: percentage,
            name: Percentage}], showLabels: false, showValues: true, maxValue: !!null '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
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
    hide_legend: true
    legend_position: center
    font_size: ''
    series_types: {}
    point_style: circle
    series_colors: {}
    series_labels:
      product_level.total_cat_quantity: Selected Company/Brand
      q1_product_level.total_cat_quantity: Others
      new_calculation: Others
    show_value_labels: true
    label_density: 25
    label_color: []
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    type: looker_line
    hidden_fields: [q1_product_level.total_cat_quantity, product_level.total_cat_quantity,
      product_level.product_company_market, product_level_2.total_cat_quantity, brand_level.total_cat_quantity]
    sorts: [brand_level.date]
    dynamic_fields: [{category: table_calculation, expression: "${brand_level.total_cat_quantity}/${product_level_2.total_cat_quantity}",
        label: Percentage, value_format: !!null '', value_format_name: percent_2,
        _kind_hint: measure, table_calculation: percentage, _type_hint: number}]
    listen:
    - Time Frame: brand_level.order_date
      Is Key Account: brand_level.is_key_account
      City: brand_level.city
      Product Company: brand_level.product_company
      Country: brand_level.country
      Product Name: brand_level.product_name
      Product Category: brand_level.product_subtype
      Product Type: brand_level.product_type
      Upselling: brand_level.upselling
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
    - Time Frame: product_level_2.order_date
      Is Key Account: product_level_2.is_key_account
      City: product_level_2.city
      Product Company: product_level_2.product_company_filter
      Country: product_level_2.country
      Product Type: product_level_2.product_type
      Upselling: product_level_2.upselling
      Currency: product_level_2.currency_picker
      Date Granularity: product_level_2.date_granularity
    row: 6
    col: 0
    width: 8
    height: 6
  - name: Incidence Rates (in Total Orders)
    title: Incidence Rates (in Total Orders)
    note_state: collapsed
    note_display: hover
    note_text: The ratio of total orders which includes at least one product from
      your brand portfolio
    merged_queries:
    - model: partners_insight
      explore: brand_level
      type: table
      fields: [brand_level.date, brand_level.total_order]
      filters:
        brand_level.date_granularity: Monthly
        brand_level.product_name: All Brands
        brand_level.product_type: All
        brand_level.upselling: All
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields: []
    - model: partners_insight
      explore: meta_data
      type: table
      fields: [meta_data.orders, meta_data.date]
      filters:
        meta_data.country: ''
        meta_data.date_granularity: Monthly
      sorts: [meta_data.orders desc]
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields:
      - field_name: meta_data.date
        source_field_name: brand_level.date
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-diverging-0
      options:
        steps: 5
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: percentage, id: percentage,
            name: Percentage}], showLabels: false, showValues: true, unpinAxis: false,
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
    hide_legend: true
    legend_position: center
    font_size: ''
    series_types: {}
    point_style: circle
    series_labels:
      product_level.total_order: Selected Company/Brand
      new_calculation: Others
      meta_data.orders: Others
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    hidden_fields: [product_level.total_order, meta_data.orders, brand_level.total_order]
    type: looker_line
    sorts: [brand_level.date]
    dynamic_fields: [{category: table_calculation, expression: "${brand_level.total_order}/${meta_data.orders}",
        label: Percentage, value_format: !!null '', value_format_name: percent_2,
        _kind_hint: measure, table_calculation: percentage, _type_hint: number}]
    listen:
    - Time Frame: brand_level.order_date
      Is Key Account: brand_level.is_key_account
      City: brand_level.city
      Product Company: brand_level.product_company
      Country: brand_level.country
      Product Name: brand_level.product_name
      Product Category: brand_level.product_subtype
      Product Type: brand_level.product_type
      Upselling: brand_level.upselling
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
    - Time Frame: meta_data.order_date
      Is Key Account: meta_data.is_key_account
      City: meta_data.city
      Country: meta_data.country
      Date Granularity: meta_data.date_granularity
    row: 6
    col: 16
    width: 8
    height: 6
  - name: Market Share (Units Sold) (2)
    title: Market Share (Units Sold)
    note_state: collapsed
    note_display: hover
    note_text: Market share (units) in relevant product category. Please align on
      the definition of relevant product category with your Delivery Hero partner
    merged_queries:
    - model: partners_insight
      explore: product_level_2
      type: table
      fields: [product_level_2.total_cat_quantity, top_50_companies.company_ranked]
      filters:
        product_level_2.date_granularity: Monthly
        product_level_2.currency_picker: eur
        product_level_2.company_selection: "{{ _user_attributes['product_cpg'] }}"
      sorts: [top_50_companies.company_ranked]
      limit: 500
      total: true
      hidden_fields: []
      y_axes: []
      join_fields: []
    - model: partners_insight
      explore: brand_level
      type: table
      fields: [brand_level.product_company, brand_level.total_cat_quantity]
      filters:
        brand_level.date_granularity: Monthly
      limit: 500
      total: true
      hidden_fields: []
      y_axes: []
      join_fields:
      - field_name: brand_level.product_company
        source_field_name: top_50_companies.company_ranked
    value_labels: labels
    label_type: labPer
    color_application:
      collection_id: new-custom-collection
      custom:
        id: cc72af0f-4dd3-958e-b36e-8c659b71fecb
        label: Custom
        type: continuous
        stops:
        - color: "#d62028"
          offset: 0
        - color: "#EA565F"
          offset: 50
        - color: "#EB979B"
          offset: 100
      options:
        steps: 5
        reverse: false
    series_colors: {}
    series_labels:
      product_level.total_cat_quantity: Selected Company/Brand
      q1_product_level.total_cat_quantity: Others
      new_calculation: Others
      product_level.total_cat_price: Selected Company/Brand
    show_value_labels: true
    font_size: 0
    hide_legend: true
    series_types: {}
    type: looker_pie
    hidden_fields: [q1_product_level.total_cat_quantity, q1_product_level.total_cat_price,
      product_level.product_company_market, product_level_2.total_cat_quantity, product_level.total_cat_quantity,
      adjusted_quantity, brand_level.total_cat_quantity]
    y_axes: []
    hidden_points_if_no: [is_shown]
    sorts: [top_50_companies.company_ranked]
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'if(${top_50_companies.company_ranked}!="Others",${brand_level.total_cat_quantity},null)',
        label: Adjusted Quantity, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: adjusted_quantity, _type_hint: number},
      {category: table_calculation, expression: 'if(${top_50_companies.company_ranked}="Others",sum(${product_level_2.total_cat_quantity})-sum(${adjusted_quantity}),${adjusted_quantity})',
        label: 'Total Quantity ', value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: total_quantity, _type_hint: number},
      {category: table_calculation, expression: 'if(is_null(${total_quantity}),no,yes)',
        label: is_shown, value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        table_calculation: is_shown, _type_hint: yesno}]
    listen:
    - Time Frame: product_level_2.order_date
      Is Key Account: product_level_2.is_key_account
      City: product_level_2.city
      Product Company: product_level_2.product_company_filter
      Country: product_level_2.country
      Product Type: product_level_2.product_type
      Upselling: product_level_2.upselling
      Currency: product_level_2.currency_picker
      Date Granularity: product_level_2.date_granularity
    - Time Frame: brand_level.order_date
      Is Key Account: brand_level.is_key_account
      City: brand_level.city
      Product Company: brand_level.product_company
      Country: brand_level.country
      Product Name: brand_level.product_name
      Product Category: brand_level.product_subtype
      Product Type: brand_level.product_type
      Upselling: brand_level.upselling
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
    row: 0
    col: 0
    width: 8
    height: 6
  - name: Incidence Rates (in Total Orders) (2)
    title: Incidence Rates (in Total Orders)
    note_state: collapsed
    note_display: hover
    note_text: The ratio of total orders which includes at least one product from
      your brand portfolio
    merged_queries:
    - model: partners_insight
      explore: product_level_2
      type: table
      fields: [top_50_companies.company_ranked]
      filters:
        product_level_2.date_granularity: Monthly
        product_level_2.company_selection: "{{ _user_attributes['product_cpg'] }}"
        product_level_2.product_company_market: "-NULL"
      sorts: [top_50_companies.company_ranked]
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields: []
    - model: partners_insight
      explore: meta_data
      type: table
      fields: [meta_data.orders, meta_data.product_company]
      filters:
        meta_data.country: ''
        meta_data.date_granularity: Monthly
      sorts: [meta_data.orders desc]
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields:
      - field_name: meta_data.product_company
        source_field_name: top_50_companies.company_ranked
    - model: partners_insight
      explore: brand_level
      type: table
      fields: [brand_level.product_company, brand_level.total_order]
      filters:
        brand_level.date_granularity: Monthly
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields:
      - field_name: brand_level.product_company
        source_field_name: top_50_companies.company_ranked
    value_labels: labels
    label_type: labPer
    color_application:
      collection_id: new-custom-collection
      custom:
        id: 3c1ac4e2-a651-994b-e80e-f6e47e63da60
        label: Custom
        type: continuous
        stops:
        - color: "#d62028"
          offset: 0
        - color: "#EA565F"
          offset: 50
        - color: "#EB979B"
          offset: 100
      options:
        steps: 5
    series_labels:
      product_level.total_order: Selected Company/Brand
      new_calculation: Others
      meta_data.orders: Others
    show_value_labels: true
    font_size: 0
    hide_legend: true
    hidden_fields: [meta_data.orders, adjusted_orders, product_level.total_order,
      brand_level.total_order]
    series_types: {}
    type: looker_pie
    y_axes: []
    hidden_points_if_no: [is_shown]
    sorts: [top_50_companies.company_ranked]
    dynamic_fields: [{category: table_calculation, expression: 'if(${top_50_companies.company_ranked}!="Others",${brand_level.total_order},null)',
        label: Adjusted Orders, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: adjusted_orders, _type_hint: number},
      {category: table_calculation, expression: 'if(${top_50_companies.company_ranked}="Others",sum(${meta_data.orders})-sum(${adjusted_orders}),${adjusted_orders})',
        label: Total Orders, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: total_orders, _type_hint: number},
      {category: table_calculation, expression: 'if(is_null(${total_orders}),no,yes)',
        label: is_shown, value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        table_calculation: is_shown, _type_hint: yesno}]
    listen:
    - Time Frame: product_level_2.order_date
      Is Key Account: product_level_2.is_key_account
      City: product_level_2.city
      Product Company: product_level_2.product_company_filter
      Country: product_level_2.country
      Product Type: product_level_2.product_type
      Upselling: product_level_2.upselling
      Currency: product_level_2.currency_picker
      Date Granularity: product_level_2.date_granularity
    - Time Frame: meta_data.order_date
      Is Key Account: meta_data.is_key_account
      City: meta_data.city
      Country: meta_data.country
      Date Granularity: meta_data.date_granularity
    - Time Frame: brand_level.order_date
      Is Key Account: brand_level.is_key_account
      City: brand_level.city
      Product Company: brand_level.product_company
      Country: brand_level.country
      Product Name: brand_level.product_name
      Product Category: brand_level.product_subtype
      Product Type: brand_level.product_type
      Upselling: brand_level.upselling
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
    row: 0
    col: 16
    width: 8
    height: 6
  - name: Market Share (Total Revenue)
    title: Market Share (Total Revenue)
    note_state: collapsed
    note_display: hover
    note_text: Market share (Total Revenue) in relevant product category. Please align
      on the definition of relevant product category with your Delivery Hero partner
    merged_queries:
    - model: partners_insight
      explore: product_level_2
      type: table
      fields: [top_50_companies.company_ranked, product_level_2.total_cat_price]
      filters:
        product_level_2.date_granularity: Monthly
        product_level_2.currency_picker: eur
        product_level_2.company_selection: "{{ _user_attributes['product_cpg'] }}"
        product_level_2.product_company_market: "-NULL"
        product_level_2.product_company_filter: "-Test"
      sorts: [top_50_companies.company_ranked]
      limit: 500
      total: true
      hidden_fields: []
      y_axes: []
      join_fields: []
    - model: partners_insight
      explore: brand_level
      type: table
      fields: [brand_level.product_company, brand_level.total_cat_price]
      filters:
        brand_level.date_granularity: Monthly
      limit: 500
      total: true
      hidden_fields: []
      y_axes: []
      join_fields:
      - field_name: brand_level.product_company
        source_field_name: top_50_companies.company_ranked
    value_labels: labels
    label_type: labPer
    color_application:
      collection_id: new-custom-collection
      custom:
        id: cc72af0f-4dd3-958e-b36e-8c659b71fecb
        label: Custom
        type: continuous
        stops:
        - color: "#d62028"
          offset: 0
        - color: "#EA565F"
          offset: 50
        - color: "#EB979B"
          offset: 100
      options:
        steps: 5
        reverse: false
    series_colors: {}
    series_labels:
      product_level.total_cat_quantity: Selected Company/Brand
      q1_product_level.total_cat_quantity: Others
      new_calculation: Others
      product_level.total_cat_price: Selected Company/Brand
    show_value_labels: true
    font_size: 0
    hide_legend: true
    series_types: {}
    type: looker_pie
    hidden_fields: [q1_product_level.total_cat_quantity, q1_product_level.total_cat_price,
      product_level.product_company_market, product_level.total_cat_quantity, adjusted_quantity,
      product_level_2.total_cat_price, brand_level.total_cat_price, adjusted_revenue]
    y_axes: []
    hidden_points_if_no: [is_shown]
    sorts: [top_50_companies.company_ranked]
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'if(${top_50_companies.company_ranked}!="Others",${brand_level.total_cat_price},null)',
        label: Adjusted Revenue, value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: adjusted_revenue, _type_hint: number},
      {category: table_calculation, expression: 'if(${top_50_companies.company_ranked}="Others",sum(${product_level_2.total_cat_price})-sum(${adjusted_revenue}),${adjusted_revenue})',
        label: 'Total Revenue ', value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, table_calculation: total_revenue, _type_hint: number},
      {category: table_calculation, expression: 'if(is_null(${total_revenue}),no,yes)',
        label: is_shown, value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        table_calculation: is_shown, _type_hint: yesno}]
    listen:
    - Time Frame: product_level_2.order_date
      Is Key Account: product_level_2.is_key_account
      City: product_level_2.city
      Product Company: product_level_2.product_company_filter
      Country: product_level_2.country
      Product Type: product_level_2.product_type
      Upselling: product_level_2.upselling
      Currency: product_level_2.currency_picker
      Date Granularity: product_level_2.date_granularity
    - Time Frame: brand_level.order_date
      Is Key Account: brand_level.is_key_account
      City: brand_level.city
      Product Company: brand_level.product_company
      Country: brand_level.country
      Product Name: brand_level.product_name
      Product Category: brand_level.product_subtype
      Product Type: brand_level.product_type
      Upselling: brand_level.upselling
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
    row: 0
    col: 8
    width: 8
    height: 6
  - name: Market Share (Revenue)
    title: Market Share (Revenue)
    note_state: collapsed
    note_display: hover
    note_text: Market share (Total Revenue) in relevant product category. Please align
      on the definition of relevant product category with your Delivery Hero partner
    merged_queries:
    - model: partners_insight
      explore: brand_level
      type: table
      fields: [brand_level.date, brand_level.total_cat_price]
      filters:
        brand_level.date_granularity: Monthly
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields: []
    - model: partners_insight
      explore: product_level_2
      type: table
      fields: [product_level_2.date, product_level_2.total_cat_price]
      filters:
        product_level_2.product_company_market: "-NULL"
        product_level_2.date_granularity: Monthly
        product_level_2.product_company_filter: "-Test"
      limit: 500
      hidden_fields: []
      y_axes: []
      join_fields:
      - field_name: product_level_2.date
        source_field_name: brand_level.date
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-diverging-0
      options:
        steps: 5
        reverse: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: percentage, id: percentage,
            name: Percentage}], showLabels: false, showValues: true, maxValue: !!null '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
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
    hide_legend: true
    legend_position: center
    font_size: ''
    series_types: {}
    point_style: circle
    series_colors: {}
    series_labels:
      product_level.total_cat_quantity: Selected Company/Brand
      q1_product_level.total_cat_quantity: Others
      new_calculation: Others
    show_value_labels: true
    label_density: 25
    label_color: []
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    type: looker_line
    hidden_fields: [q1_product_level.total_cat_quantity, product_level.total_cat_quantity,
      product_level.product_company_market, brand_level.total_cat_price, product_level_2.total_cat_price]
    sorts: [brand_level.date]
    dynamic_fields: [{category: table_calculation, expression: "${brand_level.total_cat_price}/${product_level_2.total_cat_price}",
        label: Percentage, value_format: !!null '', value_format_name: percent_2,
        _kind_hint: measure, table_calculation: percentage, _type_hint: number}]
    listen:
    - Time Frame: brand_level.order_date
      Is Key Account: brand_level.is_key_account
      City: brand_level.city
      Product Company: brand_level.product_company
      Country: brand_level.country
      Product Name: brand_level.product_name
      Product Category: brand_level.product_subtype
      Product Type: brand_level.product_type
      Upselling: brand_level.upselling
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
    - Time Frame: product_level_2.order_date
      Is Key Account: product_level_2.is_key_account
      City: product_level_2.city
      Product Company: product_level_2.product_company_filter
      Country: product_level_2.country
      Product Type: product_level_2.product_type
      Currency: product_level_2.currency_picker
    row: 6
    col: 8
    width: 8
    height: 6
  - title: Brand Share in Total Company (Unit Solds)
    name: Brand Share in Total Company (Unit Solds)
    model: partners_insight
    explore: brand_level
    type: looker_pie
    fields: [brand_level.brand_comparitor, new_dimension, brand_level.total_cat_quantity]
    filters:
      brand_level.product_name: "-All Brands"
    sorts: [brand_level.total_cat_quantity desc]
    limit: 500
    dynamic_fields: [{category: dimension, expression: 'if(${brand_level.brand_comparitor}="Others",2,1)',
        label: New Dimension, value_format: !!null '', value_format_name: !!null '',
        dimension: new_dimension, _kind_hint: dimension, _type_hint: number}, {category: table_calculation,
        expression: 'if(row()<51,yes,no)', label: is_shown, value_format: !!null '',
        value_format_name: !!null '', _kind_hint: dimension, table_calculation: is_shown,
        _type_hint: yesno}]
    value_labels: labels
    label_type: labPer
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-diverging-0
      options:
        steps: 5
    show_view_names: false
    defaults_version: 1
    series_types: {}
    hidden_fields: [new_dimension]
    hidden_points_if_no: [is_shown]
    y_axes: []
    listen:
      Country: brand_level.country
      Time Frame: brand_level.order_date
      Product Company: brand_level.product_company
      Product Name: brand_level.brand_selection
      Product Category: brand_level.product_subtype_filter
      Product Type: brand_level.product_type
      Upselling: brand_level.upselling
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
    row: 12
    col: 0
    width: 8
    height: 6
  - title: Brand Share in Total Company (Basket Penetration)
    name: Brand Share in Total Company (Basket Penetration)
    model: partners_insight
    explore: brand_level
    type: looker_pie
    fields: [brand_level.brand_comparitor, new_dimension, brand_level.total_order]
    filters:
      brand_level.product_name: "-All Brands"
    sorts: [brand_level.total_order desc]
    limit: 500
    dynamic_fields: [{category: dimension, expression: 'if(${brand_level.brand_comparitor}="Others",2,1)',
        label: New Dimension, value_format: !!null '', value_format_name: !!null '',
        dimension: new_dimension, _kind_hint: dimension, _type_hint: number}, {category: table_calculation,
        expression: 'if(row()<51,yes,no)', label: is_shown, value_format: !!null '',
        value_format_name: !!null '', _kind_hint: dimension, table_calculation: is_shown,
        _type_hint: yesno}]
    value_labels: labels
    label_type: labPer
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-diverging-0
      options:
        steps: 5
    show_view_names: false
    defaults_version: 1
    series_types: {}
    hidden_fields: [new_dimension]
    hidden_points_if_no: [is_shown]
    y_axes: []
    listen:
      Country: brand_level.country
      Time Frame: brand_level.order_date
      Product Company: brand_level.product_company
      Product Name: brand_level.brand_selection
      Product Category: brand_level.product_subtype_filter
      Product Type: brand_level.product_type
      Upselling: brand_level.upselling
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
    row: 12
    col: 16
    width: 8
    height: 6
  - title: Brand Share in Total Company (Revenue)
    name: Brand Share in Total Company (Revenue)
    model: partners_insight
    explore: brand_level
    type: looker_pie
    fields: [brand_level.brand_comparitor, new_dimension, brand_level.total_cat_price]
    filters:
      brand_level.product_name: "-All Brands"
    sorts: [brand_level.total_cat_price desc]
    limit: 500
    dynamic_fields: [{category: dimension, expression: 'if(${brand_level.brand_comparitor}="Others",2,1)',
        label: New Dimension, value_format: !!null '', value_format_name: !!null '',
        dimension: new_dimension, _kind_hint: dimension, _type_hint: number}, {category: table_calculation,
        expression: 'if(row()<51,yes,no)', label: is_shown, value_format: !!null '',
        value_format_name: !!null '', _kind_hint: dimension, table_calculation: is_shown,
        _type_hint: yesno}]
    value_labels: labels
    label_type: labPer
    color_application:
      collection_id: new-custom-collection
      palette_id: new-custom-collection-diverging-0
      options:
        steps: 5
    show_view_names: false
    defaults_version: 1
    series_types: {}
    hidden_fields: [new_dimension]
    hidden_points_if_no: [is_shown]
    y_axes: []
    listen:
      Country: brand_level.country
      Time Frame: brand_level.order_date
      Product Company: brand_level.product_company
      Product Name: brand_level.brand_selection
      Product Category: brand_level.product_subtype_filter
      Product Type: brand_level.product_type
      Upselling: brand_level.upselling
      Currency: brand_level.currency_picker
      Date Granularity: brand_level.date_granularity
    row: 12
    col: 8
    width: 8
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
    explore: brand_level_split
    listens_to_filters: [City, Product Company, Product Category, Product Name]
    field: brand_level_split.country
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
    listens_to_filters: [Is Upsell, Time Frame, Is Key Account, Date Granularity,
      Country, Product Company, Product Category, Product Name]
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
    explore: brand_level_split
    listens_to_filters: [Country, City, Product Category, Product Name]
    field: brand_level_split.product_company
  - name: Product Name
    title: Product Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: brand_level_split
    listens_to_filters: [Country, City, Product Company, Product Category]
    field: brand_level_split.product_name
  - name: Product Category
    title: Product Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: partners_insight
    explore: brand_level_split
    listens_to_filters: [Country, City, Product Company, Product Name]
    field: brand_level_split.product_subtype
  - name: Product Type
    title: Product Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: popover
    model: partners_insight
    explore: brand_level_split
    listens_to_filters: [Product Company, Product Category, Product Name]
    field: brand_level_split.product_type
  - name: Upselling
    title: Upselling
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: popover
    model: partners_insight
    explore: brand_level_split
    listens_to_filters: [Product Company, Product Category, Product Name]
    field: brand_level_split.upselling
  - name: Time Frame
    title: Time Frame
    type: field_filter
    default_value: 12 month
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: partners_insight
    explore: brand_level_split
    listens_to_filters: []
    field: brand_level_split.order_date
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
  - name: Date Granularity
    title: Date Granularity
    type: field_filter
    default_value: Monthly
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: popover
    model: partners_insight
    explore: brand_level_split
    listens_to_filters: []
    field: brand_level_split.date_granularity
  - name: Currency
    title: Currency
    type: field_filter
    default_value: eur
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: partners_insight
    explore: brand_level_split
    listens_to_filters: []
    field: brand_level_split.currency_picker
