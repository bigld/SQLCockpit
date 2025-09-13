"! Cadaxo SQL Cockpit - Complex Data Compare
CLASS /cadaxo/cl_sqlc_dcomp_complex DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF tys_table_details,
        number          TYPE i,
        name            TYPE string,
        data            TYPE REF TO data,
        cdxdfies        TYPE /cadaxo/sqlcdfies_t,
        sort_tab        TYPE abap_sortorder_tab,
        link_fieldname  TYPE string,
        compare_prefix  TYPE char2,
        components_view TYPE abap_component_view_tab,
        select_type     TYPE i,
        netplan_tab     TYPE REF TO if_aqqgraphic_table,
        pos_left        TYPE i,
        pos_right       TYPE i,
      END OF tys_table_details .

    "! Container for Custom Controls in the Screen Area
    DATA gr_container_mapping TYPE REF TO cl_gui_custom_container .
    "! Container for Custom Controls in the Screen Area
    DATA gr_container_results TYPE REF TO cl_gui_custom_container .
    "! Container for Custom Controls in the Screen Area
    DATA gr_container_legend TYPE REF TO cl_gui_custom_container .
    "! Container for Custom Controls in the Screen Area
    DATA gr_container_info_0200 TYPE REF TO cl_gui_custom_container .
    "! SAP TextEdit Control
    DATA gr_text_info_0200 TYPE REF TO cl_gui_textedit .
    "! Container for Custom Controls in the Screen Area
    DATA gr_container_info_0300 TYPE REF TO cl_gui_custom_container .
    "! SAP TextEdit Control
    DATA gr_text_info_0300 TYPE REF TO cl_gui_textedit .
    "! ALV List Viewer
    DATA gr_compare_results_grid TYPE REF TO cl_gui_alv_grid .
    "! ALV List Viewer
    DATA gr_legend_grid TYPE REF TO cl_gui_alv_grid .
    "! General Network Control Methods
    DATA gr_netplan TYPE REF TO if_gui_aqqgraphic .
    DATA gv_keys_unique TYPE boolean .
    DATA gd_stat_onemapping TYPE icons-text .
    DATA gd_stat_uniqu_keymapping TYPE icons-text .
    DATA gd_stat_uniqu_keymapping1 TYPE icons-text .
    DATA gd_stat_uniqu_keymapping2 TYPE icons-text .
    DATA:
      BEGIN OF gds_rows_comp_state,
        missing             TYPE c LENGTH 6,
        different           TYPE c LENGTH 6,
        equal               TYPE c LENGTH 6,
        percent_equal       TYPE p LENGTH 6 DECIMALS 2,
        percent_different   TYPE p LENGTH 6 DECIMALS 2,
        percent_missing     TYPE p LENGTH 6 DECIMALS 2,
        percent_equal_c     TYPE c LENGTH 6,
        percent_different_c TYPE c LENGTH 6,
        percent_missing_c   TYPE c LENGTH 6,
      END OF gds_rows_comp_state .
    CLASS-DATA:
      BEGIN OF gs_rows_comp_state,
        missing   TYPE i,
        different TYPE i,
        equal     TYPE i,
      END OF gs_rows_comp_state .
    DATA gs_source TYPE tys_table_details READ-ONLY .
    DATA gs_target TYPE tys_table_details READ-ONLY .

    "! Constructor
    "!
    "! @parameter it_source_dfies   | SQL Cockpit - Table of /CADAXO/SQLCDFIES
    "! @parameter it_target_dfies   | SQL Cockpit - Table of /CADAXO/SQLCDFIES
    "! @parameter i_user_settings   | SQL Cockpit - Usersettings Dynpro
    "! @parameter it_result_details | SQL Cockpit - Table of /CADAXO/SQLCRESULT_DETAILS
    METHODS constructor
      IMPORTING
        !it_source             TYPE STANDARD TABLE
        !it_target             TYPE STANDARD TABLE
        !i_source_number       TYPE i
        !i_target_number       TYPE i
        !it_source_dfies       TYPE /cadaxo/sqlcdfies_t
        !it_target_dfies       TYPE /cadaxo/sqlcdfies_t
        !i_source_name         TYPE string OPTIONAL
        !i_target_name         TYPE string OPTIONAL
        !i_user_settings       TYPE /cadaxo/sqlcusrp_dyn
        !it_result_details     TYPE /cadaxo/sqlcresult_details_t
        !iv_source_select_type TYPE i DEFAULT 0
        !iv_target_select_type TYPE i DEFAULT 0 .
    "! PAI 0100
    "!
    "! @parameter i_ok_code | ABAP System Field: PAI-Triggering Function Code
    METHODS pai_0100
      IMPORTING
        !i_ok_code TYPE sy-ucomm .
    "! PBO 0100
    METHODS pbo_0100 .
    "! PBO 0200
    METHODS pbo_0200 .
    "! do check
    METHODS do_check .
    "! PBO 0300
    METHODS pbo_0300 .
    "! free data
    METHODS free .
    "! free results
    METHODS free_results .
    METHODS do_check_hr .  "Cockpit-405
  PROTECTED SECTION.

    TYPES:
      BEGIN OF tys_mapping_allowed,
        type_source TYPE dynptype,
        type_target TYPE dynptype,
      END OF tys_mapping_allowed .
    TYPES:
      tyt_mapping_allowed TYPE SORTED TABLE OF tys_mapping_allowed WITH UNIQUE DEFAULT KEY .
    TYPES:
      BEGIN OF tys_detail_difference,
        idx       TYPE i,
        row       TYPE i,
        fieldname TYPE fieldname,
      END OF tys_detail_difference .
    TYPES:
      tyt_detail_difference TYPE STANDARD TABLE OF tys_detail_difference .
    TYPES:
      BEGIN OF typ_map,
        icon      TYPE icon_d,
        fieldname TYPE c LENGTH 30,
        fieldtext TYPE c LENGTH 60,
        data_type TYPE c LENGTH 20,
      END OF typ_map .
    TYPES:
      typ_map_tab TYPE STANDARD TABLE OF typ_map WITH DEFAULT KEY .
    TYPES:
      BEGIN OF tys_meta_data,
        datatype TYPE dynptype,
        length   TYPE outputlen,
        decimals TYPE decimals,
        is_key   TYPE boolean,
      END OF tys_meta_data .
    TYPES:
      BEGIN OF  typ_link,
        source TYPE int2,
        target TYPE int2,
        type   TYPE int2,
        link   TYPE REF TO if_aqqgraphic_link,
      END OF typ_link .
    TYPES:
      BEGIN OF tys_progress_indi,
        lines_compare       TYPE char10,
        percentage_previous TYPE i,
        current_line        TYPE char10,
      END OF tys_progress_indi .
    TYPES:
      typ_link_tab TYPE STANDARD TABLE OF typ_link WITH DEFAULT KEY .
    TYPES:
      BEGIN OF typ_sort_components,
        fieldname_1  TYPE fieldname,
        fieldname_2  TYPE fieldname,
        fieldname_3  TYPE fieldname,
        fieldname_4  TYPE fieldname,
        fieldname_5  TYPE fieldname,
        fieldname_6  TYPE fieldname,
        fieldname_7  TYPE fieldname,
        fieldname_8  TYPE fieldname,
        fieldname_9  TYPE fieldname,
        fieldname_10 TYPE fieldname,
        fieldname_11 TYPE fieldname,
        fieldname_12 TYPE fieldname,
        fieldname_13 TYPE fieldname,
        fieldname_14 TYPE fieldname,
        fieldname_15 TYPE fieldname,
        fieldname_16 TYPE fieldname,
        fieldname_17 TYPE fieldname,
        fieldname_18 TYPE fieldname,
        fieldname_19 TYPE fieldname,
        fieldname_20 TYPE fieldname,
      END OF typ_sort_components .

    CONSTANTS c_linktype_field TYPE int2 VALUE 0 ##NO_TEXT.
    CONSTANTS c_linktype_key TYPE int2 VALUE 1 ##NO_TEXT.
    CLASS-DATA gt_mapping_allowed TYPE tyt_mapping_allowed .
    "! SQL Cockpit - Usersettings Dynpro
    DATA g_user_settings TYPE /cadaxo/sqlcusrp_dyn .
    "! SQL Cockpit - Table of /CADAXO/SQLCRESULT_DETAILS
    DATA gt_result_details TYPE /cadaxo/sqlcresult_details_t .
    DATA gt_link TYPE typ_link_tab .
    DATA gv_show_green TYPE boolean .
    DATA gv_show_yellow TYPE boolean .
    DATA gv_show_all_columns TYPE boolean .
    DATA gt_detailed_difference TYPE tyt_detail_difference .
    DATA gv_difference_index TYPE i .
*    DATA gr_datacontainer_pie TYPE REF TO /cdaxo/cl_sqlc_dcomp_complpie .
    DATA gt_components_compare TYPE abap_component_tab .
    DATA grt_compare_result TYPE REF TO data .
    DATA grs_compare_result TYPE REF TO data .
    DATA gv_icon_red TYPE icons-text .
    DATA gv_icon_green TYPE icons-text .
    DATA gt_result_fcat TYPE lvc_t_fcat .
    DATA gt_excluding_alv TYPE ui_functions .
    DATA gv_show_red TYPE boolean .
    DATA gv_key_name01 TYPE string .
    DATA gv_key_name02 TYPE string .
    DATA gv_key_name03 TYPE string .
    DATA gv_key_name04 TYPE string .
    DATA gv_key_name05 TYPE string .
    DATA gv_key_name06 TYPE string .
    DATA gv_key_name07 TYPE string .
    DATA gv_key_name08 TYPE string .
    DATA gv_key_name09 TYPE string .
    DATA gv_key_name10 TYPE string .
    DATA gv_key_name11 TYPE string .
    DATA gv_key_name12 TYPE string .
    DATA gv_key_name13 TYPE string .
    DATA gv_key_name14 TYPE string .
    DATA gv_key_name15 TYPE string .
    DATA gv_key_name16 TYPE string .
    DATA gv_key_name17 TYPE string .
    DATA gv_key_name18 TYPE string .
    DATA gv_key_name19 TYPE string .
    DATA gv_key_name20 TYPE string .
    DATA gv_key_value01 TYPE REF TO data .
    DATA gv_key_value02 TYPE REF TO data .
    DATA gv_key_value03 TYPE REF TO data .
    DATA gv_key_value04 TYPE REF TO data .
    DATA gv_key_value05 TYPE REF TO data .
    DATA gv_key_value06 TYPE REF TO data .
    DATA gv_key_value07 TYPE REF TO data .
    DATA gv_key_value08 TYPE REF TO data .
    DATA gv_key_value09 TYPE REF TO data .
    DATA gv_key_value10 TYPE REF TO data .
    DATA gv_key_value11 TYPE REF TO data .
    DATA gv_key_value12 TYPE REF TO data .
    DATA gv_key_value13 TYPE REF TO data .
    DATA gv_key_value14 TYPE REF TO data .
    DATA gv_key_value15 TYPE REF TO data .
    DATA gv_key_value16 TYPE REF TO data .
    DATA gv_key_value17 TYPE REF TO data .
    DATA gv_key_value18 TYPE REF TO data .
    DATA gv_key_value19 TYPE REF TO data .
    DATA gv_key_value20 TYPE REF TO data .
    DATA gv_row_based TYPE abap_bool . "Cockpit-405

    METHODS free_netplan .
    "! context menu request
    METHODS on_handle_ctxmnureq
      FOR EVENT ctxmnurequest OF if_gui_aqqgraphic
      IMPORTING
        !r_table
        !rowindex
        !r_link
        !background
        !r_ctxmnu .
    "! context menue select
    METHODS on_handle_ctxmnusel
      FOR EVENT ctxmnufcodesel OF if_gui_aqqgraphic
      IMPORTING
        !r_table
        !rowindex
        !r_link
        !background
        !fcode .
    "! new link created
    METHODS on_handle_link_created
      FOR EVENT link_created OF if_gui_aqqgraphic
      IMPORTING
        !r_newlink
        !r_succtab
        !succ_row
        !r_predtab
        !pred_row
        !r_doit .
    "! left button double click
    "! @parameter !r_link |
    "! @parameter !r_table |
    "! @parameter !row |
    METHODS on_handle_double_click
      FOR EVENT object_double_click OF if_gui_aqqgraphic
      IMPORTING
        !r_link
        !r_table
        !row .
    "! result toolbar
    METHODS on_handle_result_toolbar
      FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
        !e_object
        !e_interactive .
    "! result user command
    METHODS on_handle_result_user_command
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
        !e_ucomm .
    METHODS set_netplan_table
      CHANGING
        !is_table_details TYPE tys_table_details .
    "! build mapping table
    "!
    "! @parameter it_dfies | SQL Cockpit - Table of /CADAXO/SQLCDFIES
    METHODS build_mapping_table
      IMPORTING
        !it_dfies       TYPE /cadaxo/sqlcdfies_t
        !iv_select_type TYPE i DEFAULT 0
      RETURNING
        VALUE(rt_tab)   TYPE typ_map_tab .
    "! set netplan tab
    "!
    "! @parameter is_pos  | Position of an Object in Network
    "! @parameter i_title | Object Heading in Network
    "! @parameter ir_tab  | Network Table Object
    METHODS set_netplan_tab
      IMPORTING
        !is_pos  TYPE aqq_s_pos
        !i_title TYPE aqq_title
        !ir_tab  TYPE REF TO if_aqqgraphic_table .
    METHODS link_delete
      IMPORTING
        !ir_link TYPE REF TO if_aqqgraphic_link .
    METHODS link_key_set
      IMPORTING
        !ir_link TYPE REF TO if_aqqgraphic_link .
    METHODS link_key_remove
      IMPORTING
        !ir_link TYPE REF TO if_aqqgraphic_link .
    METHODS link_create
      IMPORTING
        !iv_predrow   TYPE int2
        !iv_succrow   TYPE int2
        !iv_text      TYPE aqq_text DEFAULT ''
        !iv_tooltip   TYPE aqtooltip DEFAULT ''
        !iv_icon      TYPE icon_l4 DEFAULT ''
        !iv_linkstyle TYPE aqq_style DEFAULT '10004'
        !iv_type      TYPE int2
        !ir_link      TYPE REF TO if_aqqgraphic_link OPTIONAL .
    "! check keys
    METHODS check_keys .
    "! clear
    METHODS clear .
    "! set initial status icons
    METHODS set_initial_status_icons .
    "! set link status icons
    METHODS set_link_status_icons .
    METHODS check_keys_table
      CHANGING
        !is_table_details TYPE tys_table_details
      RETURNING
        VALUE(ev_unique)  TYPE flag .
    METHODS set_column_color
      IMPORTING
        !iv_fieldname TYPE string
        !iv_col       TYPE int4
        !iv_int       TYPE int4 DEFAULT 0
      CHANGING
        !ct_lvc_t_col TYPE lvc_t_scol .
    "! refresh filter
    "!
    "! @parameter i_refresh_alv | Boolean Variable (X=True, -=False, Space=Unknown)
    METHODS update_filter
      IMPORTING
        !i_refresh_alv TYPE boolean .
    METHODS toggle_show_all_columns .
    "! update status
    METHODS update_status
      IMPORTING
        !iv_row_status  TYPE i
      CHANGING
        !ec_light_field TYPE char1 .
    "! prepare dfies
    "!
    "! @parameter it_dfies | SQL Cockpit - Table of /CADAXO/SQLCDFIES
    "! @parameter rt_dfies | SQL Cockpit - Table of /CADAXO/SQLCDFIES
    METHODS prepare_dfies
      IMPORTING
        !it_dfies       TYPE /cadaxo/sqlcdfies_t
      RETURNING
        VALUE(rt_dfies) TYPE /cadaxo/sqlcdfies_t .
    METHODS build_sort_table
      CHANGING
        !cs_table_details   TYPE tys_table_details
        !ct_sort_components TYPE typ_sort_components OPTIONAL .
    "! create result table
    METHODS create_result_tables .
    "! breakup components
    METHODS breakup_components
      IMPORTING
        !it_components       TYPE abap_component_view_tab
      RETURNING
        VALUE(rt_components) TYPE abap_component_view_tab .
    "! sort original data
    METHODS sort_original_data .
    "! create compare result table
    METHODS create_compare_result_table .
    "! get fieldname
    "!
    "! @parameter is_dfies_cadaxo | SQL Cockpit - Dictionary Field Information
    METHODS get_fieldname
      IMPORTING
        !is_dfies_cadaxo    TYPE /cadaxo/sqlcdfies
        !iv_select_type     TYPE i DEFAULT 0
      RETURNING
        VALUE(rv_fieldname) TYPE string .
    METHODS dynamic_key_attributes_create
      IMPORTING
        !is_tabline TYPE any .
    "! get field meta
    "!
    "! @parameter is_dfies | DD Interface: Table Fields for DDIF_FIELDINFO_GET
    METHODS get_field_meta
      IMPORTING
        !is_dfies     TYPE dfies
      EXPORTING
        !es_meta_data TYPE tys_meta_data .
    "! link pred changed
    METHODS on_handle_link_pred_changed
      FOR EVENT link_pred_changed OF if_gui_aqqgraphic
      IMPORTING
        !r_link
        !r_predtab
        !predrow
        !r_doit .
    METHODS link_move_allowed
      IMPORTING
        !i_source        TYPE i
        !i_target        TYPE i
      RETURNING
        VALUE(r_allowed) TYPE boolean .
    METHODS build_result_fcat_line
      IMPORTING
        !iv_index         TYPE int2
        !is_table_details TYPE tys_table_details
      RETURNING
        VALUE(es_fcat)    TYPE lvc_s_fcat  ##NO_TEXT.
    "! link succ changed
    METHODS on_handle_link_succ_changed
      FOR EVENT link_succ_changed OF if_gui_aqqgraphic
      IMPORTING
        !r_link
        !r_succtab
        !succrow
        !r_doit .
    METHODS check_field_mapping_types
      IMPORTING
        !iv_datatype_source TYPE dynptype
        !iv_length_source   TYPE outputlen
        !iv_decimals_source TYPE decimals
        !iv_datatype_target TYPE dynptype
        !iv_length_target   TYPE outputlen
        !iv_decimals_target TYPE decimals
      RAISING
        /cadaxo/cx_sqlc_dcomp_fieldmap .
    METHODS fieldmapping_delete .
    METHODS fieldmapping_set
      IMPORTING
        !iv_kind TYPE char1 .
    METHODS legent_build_line
      IMPORTING
        !is_table_details TYPE tys_table_details
        !iv_col           TYPE int4
        !iv_int           TYPE int4 DEFAULT 0
      RETURNING
        VALUE(es_legend)  TYPE /cadaxo/sqlcdatacomplegend_alv .
    METHODS dynamic_key_attributes_clear .
    METHODS get_field_value
      IMPORTING
        !is_table_details TYPE tys_table_details
        !iv_index         TYPE int2
        !is_line          TYPE any
      EXPORTING
        !ev_value         TYPE REF TO data
        !ev_fieldname     TYPE string
        !ev_fieldname_db  TYPE string .
    METHODS compare_column_name_diff
      IMPORTING
        !iv_fieldname  TYPE string
        !iv_line_index TYPE i .
    METHODS compare_set_col_color_diff
      IMPORTING
        !iv_fieldname_source TYPE string
        !iv_fieldname_target TYPE string
        !iv_line_index       TYPE i
      CHANGING
        !ct_lvc_col          TYPE lvc_t_scol .
    METHODS compare_set_col_color_equal
      IMPORTING
        !iv_fieldname_source TYPE string
        !iv_fieldname_target TYPE string
      CHANGING
        !ct_lvc_col          TYPE lvc_t_scol .
    METHODS compare_set_col_color_key
      IMPORTING
        !iv_fieldname_source TYPE string OPTIONAL
        !iv_fieldname_target TYPE string OPTIONAL
      CHANGING
        !ct_lvc_col          TYPE lvc_t_scol .
    METHODS compare_set_col_color_missing
      IMPORTING
        !iv_fieldname     TYPE string
        !iv_link_type     TYPE int2
        !is_table_details TYPE tys_table_details
      CHANGING
        !ct_lvc_col       TYPE lvc_t_scol .
    METHODS compare_set_line_missing
      IMPORTING
        !is_table_details TYPE tys_table_details
        !is_line          TYPE any
      CHANGING
        !is_compare_line  TYPE any .
    METHODS toggle_button
      CHANGING
        !ic_button_flag TYPE boolean .
    METHODS navigate_difference
      IMPORTING
        !iv_kind TYPE int2
      RAISING
        /cadaxo/cx_sqlc_dcomp_complex .
    METHODS get_cusror_field
      IMPORTING
        !it_fcat                   TYPE lvc_t_fcat
        !is_column_id              TYPE lvc_s_col
        !iv_default_field_pos      TYPE i
        !iv_mark_target            TYPE flag DEFAULT abap_true
      RETURNING
        VALUE(rv_cursor_field_pos) TYPE i .
    "! navigate to previous difference
    "!
    "! @parameter iv_cursor_field_pos | actual position in result fcat
    "! @parameter it_fcat | result fcat
    "! @parameter is_row_id | rowid
    "! @parameter ev_focus_field | new focus field
    "! @parameter ev_focus_row | new rowid
    METHODS navigate_difference_next
      IMPORTING
        !iv_cursor_field_pos TYPE i
        !it_fcat             TYPE lvc_t_fcat
        !is_row_id           TYPE lvc_s_row
      EXPORTING
        !ev_focus_field      TYPE lvc_s_fcat-fieldname
        !ev_focus_row        TYPE lvc_s_row-index .
    "! navigate to previous difference
    METHODS navigate_difference_previous
      IMPORTING
        !iv_cursor_field_pos TYPE i
        !it_fcat             TYPE lvc_t_fcat
        !is_row_id           TYPE lvc_s_row
      EXPORTING
        !ev_focus_field      TYPE lvc_s_fcat-fieldname
        !ev_focus_row        TYPE lvc_s_row-index .
    METHODS create_result_table
      CHANGING
        !is_table_details TYPE tys_table_details .
    METHODS set_different_cell
      IMPORTING
        !iv_focus_field TYPE lvc_s_fcat-fieldname
        !iv_focus_row   TYPE lvc_s_row-index
      RAISING
        /cadaxo/cx_sqlc_dcomp_complex .
    METHODS switch_to_hr .    "Cockpit-405
    METHODS switch_to_vr .    "Cockpit-405
    METHODS create_compare_result_table_hr . "Cockpit-405
    METHODS compare_set_line_missing_hr "Cockpit-405
      IMPORTING
        !is_line_s TYPE any
        !is_line_t TYPE any
      CHANGING
        !ct_result TYPE STANDARD TABLE OPTIONAL .
    METHODS build_result_fcat_line_hr "Cockpit-405
      IMPORTING
        !iv_index_s         TYPE int2
        !is_table_details_s TYPE tys_table_details
        !is_table_details_t TYPE tys_table_details
        !iv_index_t         TYPE int2
      RETURNING
        VALUE(es_fcat)      TYPE lvc_s_fcat .
    METHODS update_status_hr "Cockpit-405
      IMPORTING
        !iv_row_status    TYPE i
      CHANGING
        !ec_light_field_s TYPE char1
        !ec_light_field_t TYPE char1 .
    METHODS fill_gds_rows_comp_state . "Cockpit402
  PRIVATE SECTION.

    CONSTANTS c_prefix_source TYPE char2 VALUE 'S_' ##NO_TEXT.
    CONSTANTS c_prefix_target TYPE char2 VALUE 'T_' ##NO_TEXT.
    CONSTANTS c_fieldname_lights TYPE string VALUE 'LIGHTS' ##NO_TEXT.
    CONSTANTS c_mapkind_fieldname TYPE char1 VALUE 'F' ##NO_TEXT.
    CONSTANTS c_mapkind_index TYPE char1 VALUE 'I' ##NO_TEXT.
    CONSTANTS c_action_show_red TYPE stb_button-function VALUE 'SHOW_RED' ##NO_TEXT.
    CONSTANTS c_action_show_yellow TYPE stb_button-function VALUE 'SHOW_YELLOW' ##NO_TEXT.
    CONSTANTS c_action_show_green TYPE stb_button-function VALUE 'SHOW_GREEN' ##NO_TEXT.
    CONSTANTS c_action_show_all_columns TYPE stb_button-function VALUE 'SHOW_ALL_COLUMNS' ##NO_TEXT.
    CONSTANTS c_action_map_delete TYPE string VALUE 'MAP_DELETE' ##NO_TEXT.
    CONSTANTS c_action_map_rows TYPE string VALUE 'MAP_ROWS' ##NO_TEXT.
    CONSTANTS c_action_map_fields TYPE string VALUE 'MAP_FIELDS' ##NO_TEXT.
    CONSTANTS c_action_diff_next TYPE stb_button-function VALUE 'GO_TO_NEXT_DIF' ##NO_TEXT.
    CONSTANTS c_action_diff_previous TYPE stb_button-function VALUE 'GO_TO_PREV_DIF' ##NO_TEXT.
    CONSTANTS c_action_set_key_link TYPE ui_func VALUE 'SET_KEY_MAPPING' ##NO_TEXT.
    CONSTANTS c_action_remove_key_link TYPE ui_func VALUE 'REMOVE_KEY_MAPPING' ##NO_TEXT.
    CONSTANTS c_action_delete_link TYPE ui_func VALUE 'DELETE_MAPPING' ##NO_TEXT.
    CONSTANTS c_status_missing TYPE i VALUE 1 ##NO_TEXT.
    CONSTANTS c_status_different TYPE i VALUE 2 ##NO_TEXT.
    CONSTANTS c_status_equal TYPE i VALUE 3 ##NO_TEXT.
    CONSTANTS c_navkind_next TYPE int2 VALUE 2 ##NO_TEXT.
    CONSTANTS c_navkind_prev TYPE int2 VALUE 3 ##NO_TEXT.

    METHODS show_progress_indicator
      CHANGING
        !cs_progress_inidcator TYPE tys_progress_indi .
    METHODS is_field_mapping_allowed
      IMPORTING
        !iv_idx_source     TYPE int2
        !iv_idx_target     TYPE int2
        !iv_move_source    TYPE flag OPTIONAL
        !iv_move_target    TYPE flag OPTIONAL
      RETURNING
        VALUE(ev_linktype) TYPE int2
      RAISING
        /cadaxo/cx_sqlc_dcomp_fieldmap .
ENDCLASS.



CLASS /cadaxo/cl_sqlc_dcomp_complex IMPLEMENTATION.


  METHOD breakup_components.

    DATA lt_components_view_new TYPE abap_component_view_tab.
    DATA lr_structdescr TYPE REF TO cl_abap_structdescr.
    DATA lt_components_incl TYPE abap_component_view_tab.
    DATA ls_component_view TYPE abap_simple_componentdescr.

    CLEAR lt_components_view_new.

    LOOP AT it_components ASSIGNING FIELD-SYMBOL(<ls_component_view>).
      TRY.
          lr_structdescr ?= <ls_component_view>-type.
          lt_components_incl = lr_structdescr->get_included_view( ).
          LOOP AT lt_components_incl ASSIGNING FIELD-SYMBOL(<ls_components_incl>).
            ls_component_view-name = <ls_component_view>-name && '-' && <ls_components_incl>-name.
            ls_component_view-type = <ls_components_incl>-type.
            APPEND ls_component_view TO lt_components_view_new.
          ENDLOOP.
        CATCH  cx_sy_move_cast_error.
          APPEND <ls_component_view> TO lt_components_view_new.
      ENDTRY.
    ENDLOOP.

    rt_components = lt_components_view_new.

  ENDMETHOD.


  METHOD build_mapping_table.

    LOOP AT it_dfies ASSIGNING FIELD-SYMBOL(<ls_dfies>).

      APPEND INITIAL LINE TO rt_tab ASSIGNING FIELD-SYMBOL(<ls_field>).

      <ls_field>-fieldname = get_fieldname( is_dfies_cadaxo = <ls_dfies>
                                            iv_select_type  = iv_select_type ).

      <ls_field>-fieldtext = <ls_dfies>-fieldtext.


      me->get_field_meta( EXPORTING is_dfies     = CORRESPONDING #( <ls_dfies> )
                          IMPORTING es_meta_data = DATA(ls_meta) ).

      IF <ls_dfies>-leng IS INITIAL.
        <ls_field>-data_type = ls_meta-datatype.
      ELSEIF <ls_dfies>-decimals IS INITIAL.
        <ls_field>-data_type = ls_meta-datatype && '(' && shift_left( val = ls_meta-length sub = '0' ) && ')'.
      ELSE.
        <ls_field>-data_type = ls_meta-datatype && '(' && shift_left( val = ls_meta-length sub = '0' )
                                                                           && ',' && shift_left( val = ls_meta-decimals sub = '0' ) && ')'.
      ENDIF.

      IF ls_meta-is_key = abap_true.
        <ls_field>-icon = icon_foreign_key.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD build_result_fcat_line.

    DATA ls_component TYPE abap_componentdescr.
    DATA lr_element   TYPE REF TO cl_abap_elemdescr.
    DATA ls_dfies     TYPE dfies.
    DATA lv_pos       TYPE i.
    DATA lv_name TYPE string.

    CLEAR es_fcat.

    READ TABLE is_table_details-cdxdfies INDEX iv_index ASSIGNING FIELD-SYMBOL(<ls_dfies>).
    IF sy-subrc = 0.
      READ TABLE is_table_details-components_view INDEX iv_index ASSIGNING FIELD-SYMBOL(<ls_component>).
      IF sy-subrc = 0.

        lv_name = <ls_component>-name.

        ls_component-name =  is_table_details-compare_prefix && <ls_component>-name.
        ls_component-type ?= <ls_component>-type.
        APPEND ls_component TO gt_components_compare.

        lr_element ?= ls_component-type.
        lr_element->get_ddic_field( EXPORTING p_langu = sy-langu
                                    RECEIVING p_flddescr = ls_dfies
                                    EXCEPTIONS no_ddic_type = 1
                                               not_found    = 2
                                               OTHERS       = 3 ).
        IF sy-subrc = 0.

          es_fcat = CORRESPONDING #( ls_dfies ).

          IF ls_dfies-convexit IS NOT INITIAL.
            CONCATENATE '==' ls_dfies-convexit INTO es_fcat-edit_mask.
          ENDIF.

        ELSE.

          IF <ls_dfies> IS NOT INITIAL.
            es_fcat = CORRESPONDING #( <ls_dfies> ).
          ELSE.
            es_fcat-inttype = ls_component-type->type_kind.
            es_fcat-intlen = ls_component-type->length.
          ENDIF.

        ENDIF.

        es_fcat-fieldname = ls_component-name.

        lv_pos = lv_pos + 1.
        es_fcat-col_pos   = lv_pos.

        IF es_fcat-datatype = 'CHAR' OR
           es_fcat-datatype = 'STRG' OR
           ( es_fcat-datatype IS INITIAL AND es_fcat-inttype = 'C' ).
          es_fcat-parameter0 = abap_true.
        ENDIF.

        IF es_fcat-scrtext_l IS INITIAL AND es_fcat-scrtext_m IS INITIAL AND es_fcat-scrtext_s IS INITIAL.
          es_fcat-coltext = lv_name.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD build_result_fcat_line_hr.

    DATA ls_component TYPE abap_componentdescr.
    DATA lr_element   TYPE REF TO cl_abap_elemdescr.
    DATA ls_dfies     TYPE dfies.
    DATA lv_pos       TYPE i.

    FIELD-SYMBOLS: <ls_dfies> TYPE /cadaxo/sqlcdfies.

    CLEAR es_fcat.

    READ TABLE is_table_details_s-cdxdfies INDEX iv_index_s ASSIGNING FIELD-SYMBOL(<ls_dfies_s>).
    READ TABLE is_table_details_t-cdxdfies INDEX iv_index_t ASSIGNING FIELD-SYMBOL(<ls_dfies_t>).
    IF sy-subrc = 0.

      READ TABLE is_table_details_s-components_view INDEX iv_index_s ASSIGNING FIELD-SYMBOL(<ls_component_s>).
      READ TABLE is_table_details_t-components_view INDEX iv_index_t ASSIGNING FIELD-SYMBOL(<ls_component_t>).
      IF sy-subrc = 0.

        IF <ls_component_t> = <ls_component_s>.
          ls_component-name =  <ls_component_t>-name.
          ls_component-type ?= <ls_component_t>-type.
          ASSIGN <ls_dfies_s> TO <ls_dfies>.
        ELSE.

          IF <ls_component_t>-type->length > <ls_component_s>-type->length.
            ls_component-type ?= <ls_component_t>-type.
            ASSIGN <ls_dfies_t> TO <ls_dfies>.
          ELSE.
            ls_component-type ?= <ls_component_s>-type.
            ASSIGN <ls_dfies_s> TO <ls_dfies>.
          ENDIF.
          IF <ls_component_s>-name = <ls_component_t>-name.
            ls_component-name = <ls_component_t>-name.
          ELSE.
            ls_component-name = |{ <ls_component_s>-name }_{ <ls_component_t>-name }|.
          ENDIF.
          IF strlen( ls_component-name ) GT 30.
            ls_component-name = ls_component-name(30).
          ENDIF.
        ENDIF.

        APPEND ls_component TO gt_components_compare.

        lr_element ?= ls_component-type.
        lr_element->get_ddic_field( EXPORTING p_langu = sy-langu
                                    RECEIVING p_flddescr = ls_dfies
                                    EXCEPTIONS no_ddic_type = 1
                                               not_found    = 2
                                               OTHERS       = 3 ).
        IF sy-subrc = 0.

          es_fcat = CORRESPONDING #( ls_dfies ).

          IF ls_dfies-convexit IS NOT INITIAL.
            CONCATENATE '==' ls_dfies-convexit INTO es_fcat-edit_mask.
          ENDIF.

        ELSE.

          IF <ls_dfies> IS NOT INITIAL.
            es_fcat = CORRESPONDING #( <ls_dfies> ).
          ELSE.
            es_fcat-inttype = ls_component-type->type_kind.
            es_fcat-intlen = ls_component-type->length.
          ENDIF.

        ENDIF.

        es_fcat-fieldname = ls_component-name.

        lv_pos = lv_pos + 1.
        es_fcat-col_pos   = lv_pos.

        IF es_fcat-datatype = 'CHAR' OR
           es_fcat-datatype = 'STRG' OR
           ( es_fcat-datatype IS INITIAL AND es_fcat-inttype = 'C' ).
          es_fcat-parameter0 = abap_true.
        ENDIF.

        IF <ls_component_t> NE <ls_component_s>.
          es_fcat-scrtext_s = |{ <ls_dfies_s>-scrtext_s(5) }/{ <ls_dfies_t>-scrtext_s(4) }|.
          es_fcat-scrtext_m = |{ <ls_dfies_s>-scrtext_m(10) }/{ <ls_dfies_t>-scrtext_m(9) }|.
          es_fcat-scrtext_l = |{ <ls_dfies_s>-scrtext_l(20) }/{ <ls_dfies_t>-scrtext_l(19) }|.
        ENDIF.

        IF es_fcat-scrtext_l IS INITIAL AND es_fcat-scrtext_m IS INITIAL AND es_fcat-scrtext_s IS INITIAL.
          es_fcat-coltext = <ls_component_s>-name.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD build_sort_table.
    DATA l_index TYPE int2.
    l_index = 1.

    CLEAR cs_table_details-sort_tab.
    SORT gt_link BY source.
    LOOP AT gt_link ASSIGNING FIELD-SYMBOL(<ls_link>) WHERE type = c_linktype_key.
      ASSIGN COMPONENT cs_table_details-link_fieldname OF STRUCTURE <ls_link> TO FIELD-SYMBOL(<lv_index>).
      READ TABLE cs_table_details-cdxdfies INDEX <lv_index> ASSIGNING FIELD-SYMBOL(<ls_dfies>).
      IF sy-subrc = 0.

        APPEND VALUE #( name = get_fieldname( EXPORTING is_dfies_cadaxo = <ls_dfies>
                                                        iv_select_type = cs_table_details-select_type ) ) TO cs_table_details-sort_tab ASSIGNING FIELD-SYMBOL(<ls_sort>).
        IF ct_sort_components IS SUPPLIED.
          ASSIGN COMPONENT l_index OF STRUCTURE ct_sort_components TO FIELD-SYMBOL(<ls_component>).
          IF sy-subrc = 0.
            <ls_component> = to_upper( <ls_sort>-name ).
          ENDIF.
        ENDIF.
      ENDIF.
      l_index = l_index + 1.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_field_mapping_types.

    IF gt_mapping_allowed IS INITIAL.
      gt_mapping_allowed = VALUE tyt_mapping_allowed( ( type_source = 'char' type_target = 'char' ) ).
    ENDIF.

    IF NOT line_exists( gt_mapping_allowed[ type_source = iv_datatype_source type_target = iv_datatype_target ] ).
      IF iv_datatype_source <> iv_datatype_target OR
         iv_length_source   <> iv_length_target OR
         iv_decimals_source <> iv_decimals_target.

        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_dcomp_fieldmap
          EXPORTING
            textid = /cadaxo/cx_sqlc_dcomp_fieldmap=>invalid_types.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD check_keys.

    DATA lv_key1_unique TYPE boolean.
    DATA lv_key2_unique TYPE boolean.
    DATA lv_key_unique  TYPE boolean.

    lv_key1_unique = check_keys_table( CHANGING is_table_details = gs_source ).
    lv_key2_unique = check_keys_table( CHANGING is_table_details = gs_target ).

    IF lv_key1_unique = abap_true AND lv_key2_unique = abap_true.
      lv_key_unique = abap_true.
    ENDIF.

    IF lv_key_unique = abap_true.
      gd_stat_uniqu_keymapping = gv_icon_green.
    ELSE.
      gd_stat_uniqu_keymapping = gv_icon_red.
    ENDIF.

    IF lv_key1_unique = abap_true.
      gd_stat_uniqu_keymapping1 = gv_icon_green.
    ELSE.
      gd_stat_uniqu_keymapping1 = gv_icon_red.
    ENDIF.

    IF lv_key2_unique = abap_true.
      gd_stat_uniqu_keymapping2 = gv_icon_green.
    ELSE.
      gd_stat_uniqu_keymapping2 = gv_icon_red.
    ENDIF.

    gv_keys_unique = lv_key_unique.
    cl_gui_cfw=>set_new_ok_code( 'KEY_UNIQUE_CHANGED' ).

  ENDMETHOD.


  METHOD check_keys_table.

    DATA lt_table            TYPE REF TO data.
    DATA ls_sort_comp        TYPE typ_sort_components.
    FIELD-SYMBOLS <lt_data>  TYPE STANDARD TABLE.
    FIELD-SYMBOLS <lt_table> TYPE STANDARD TABLE.

    ASSIGN is_table_details-data->* TO <lt_table>.
    CREATE DATA lt_table LIKE <lt_table>.
    ASSIGN lt_table->* TO <lt_data>.
    <lt_data> = <lt_table>.


    me->build_sort_table( CHANGING  cs_table_details   = is_table_details
                                    ct_sort_components = ls_sort_comp ).
    IF is_table_details-sort_tab IS NOT INITIAL.

      SORT <lt_data> BY (is_table_details-sort_tab).
      DELETE ADJACENT DUPLICATES FROM <lt_data> COMPARING (ls_sort_comp-fieldname_1)
                                                          (ls_sort_comp-fieldname_2)
                                                          (ls_sort_comp-fieldname_3)
                                                          (ls_sort_comp-fieldname_4)
                                                          (ls_sort_comp-fieldname_5)
                                                          (ls_sort_comp-fieldname_6)
                                                          (ls_sort_comp-fieldname_7)
                                                          (ls_sort_comp-fieldname_8)
                                                          (ls_sort_comp-fieldname_9)
                                                          (ls_sort_comp-fieldname_10)
                                                          (ls_sort_comp-fieldname_11)
                                                          (ls_sort_comp-fieldname_12)
                                                          (ls_sort_comp-fieldname_13)
                                                          (ls_sort_comp-fieldname_14)
                                                          (ls_sort_comp-fieldname_15)
                                                          (ls_sort_comp-fieldname_16)
                                                          (ls_sort_comp-fieldname_17)
                                                          (ls_sort_comp-fieldname_18)
                                                          (ls_sort_comp-fieldname_19)
                                                          (ls_sort_comp-fieldname_20).


      IF lines( <lt_data> ) = lines( <lt_table> ).
        ev_unique = abap_true.
      ENDIF.

      FREE <lt_data>.
      FREE lt_table.
    ENDIF.
  ENDMETHOD.


  METHOD clear.

    FREE gr_container_mapping.

  ENDMETHOD.


  METHOD compare_column_name_diff.

    IF iv_line_index <> 0 OR NOT line_exists( gt_detailed_difference[ fieldname = iv_fieldname ] ).

      gv_difference_index = gv_difference_index + 1.

      INSERT VALUE #( idx = gv_difference_index row = iv_line_index fieldname = iv_fieldname ) INTO TABLE gt_detailed_difference.

    ENDIF.

  ENDMETHOD.


  METHOD compare_set_col_color_diff.

    set_column_color( EXPORTING iv_fieldname = iv_fieldname_source
                                iv_col       = 3
                      CHANGING ct_lvc_t_col = ct_lvc_col ).

    set_column_color( EXPORTING iv_fieldname = iv_fieldname_target
                                iv_col       = 3
                                iv_int       = 1
                      CHANGING  ct_lvc_t_col = ct_lvc_col ).

    compare_column_name_diff( iv_fieldname = iv_fieldname_source iv_line_index = iv_line_index ).
    compare_column_name_diff( iv_fieldname = iv_fieldname_target iv_line_index = iv_line_index ).


  ENDMETHOD.


  METHOD compare_set_col_color_equal.

    IF iv_fieldname_source IS NOT INITIAL.

      set_column_color( EXPORTING iv_fieldname = iv_fieldname_source
                                  iv_col       = 7
                        CHANGING  ct_lvc_t_col = ct_lvc_col ).

    ENDIF.

    IF iv_fieldname_target IS NOT INITIAL.

      set_column_color( EXPORTING iv_fieldname = iv_fieldname_target
                                  iv_col       = 7
                                  iv_int       = 1
                        CHANGING  ct_lvc_t_col = ct_lvc_col ).

    ENDIF.

  ENDMETHOD.


  METHOD compare_set_col_color_key.
    IF iv_fieldname_source IS NOT INITIAL.
      set_column_color( EXPORTING iv_fieldname = iv_fieldname_source
                                         iv_col       = 1
                               CHANGING ct_lvc_t_col = ct_lvc_col ).
    ENDIF.

    IF iv_fieldname_target IS NOT INITIAL.

      set_column_color( EXPORTING iv_fieldname = iv_fieldname_target
                                         iv_col       = 1
                                         iv_int       = 1
                               CHANGING ct_lvc_t_col = ct_lvc_col ).

    ENDIF.

  ENDMETHOD.


  METHOD compare_set_col_color_missing.
    DATA lv_fieldname TYPE string.

    ASSIGN lv_fieldname TO FIELD-SYMBOL(<lv_source_name>).
    ASSIGN lv_fieldname TO FIELD-SYMBOL(<lv_target_name>).

    IF is_table_details = gs_source.
      ASSIGN iv_fieldname TO <lv_source_name>.
    ELSE.
      ASSIGN iv_fieldname TO <lv_target_name>.
    ENDIF.

    IF iv_link_type = c_linktype_key.

      compare_set_col_color_key( EXPORTING iv_fieldname_source = <lv_source_name>
                                           iv_fieldname_target = <lv_target_name>
                                 CHANGING  ct_lvc_col          = ct_lvc_col ).
    ELSE.

      compare_set_col_color_equal( EXPORTING iv_fieldname_source = <lv_source_name>
                                             iv_fieldname_target = <lv_target_name>
                                   CHANGING  ct_lvc_col          = ct_lvc_col ).

    ENDIF.

  ENDMETHOD.


  METHOD compare_set_line_missing.

    FIELD-SYMBOLS: <lv_value>     TYPE any.

    IF is_table_details = gs_source.
      DATA(lv_prefix)      = c_prefix_source.
    ELSE.
      lv_prefix = c_prefix_target.
    ENDIF.

    ASSIGN COMPONENT c_fieldname_lights                    OF STRUCTURE is_compare_line TO FIELD-SYMBOL(<lv_lights>).
    ASSIGN COMPONENT 'CT'                                  OF STRUCTURE is_compare_line TO FIELD-SYMBOL(<lt_lvc_col>).

    LOOP AT me->gt_link ASSIGNING FIELD-SYMBOL(<ls_link>).

      ASSIGN COMPONENT is_table_details-link_fieldname OF STRUCTURE <ls_link> TO FIELD-SYMBOL(<lv_index>).

      get_field_value( EXPORTING is_table_details = is_table_details
                                 iv_index         = <lv_index>
                                 is_line          = is_line
                       IMPORTING ev_value         = DATA(lv_value_ref)
                                 ev_fieldname     = DATA(l_fieldname) ).
      ASSIGN lv_value_ref->* TO <lv_value>.

      l_fieldname = lv_prefix && l_fieldname.
      ASSIGN COMPONENT l_fieldname OF STRUCTURE is_compare_line TO FIELD-SYMBOL(<lv_value_compare>).
      <lv_value_compare> = <lv_value>.

      compare_set_col_color_missing( EXPORTING iv_fieldname     = l_fieldname
                                               iv_link_type     = <ls_link>-type
                                               is_table_details = is_table_details
                                     CHANGING  ct_lvc_col       = <lt_lvc_col> ).
    ENDLOOP.

    update_status( EXPORTING iv_row_status = c_status_missing CHANGING ec_light_field = <lv_lights> ).


  ENDMETHOD.


  METHOD compare_set_line_missing_hr.

    FIELD-SYMBOLS: <lv_value_s>     TYPE any.
    FIELD-SYMBOLS: <lv_value_t>     TYPE any.

    APPEND INITIAL LINE TO ct_result ASSIGNING FIELD-SYMBOL(<ls_result_s>).
    APPEND INITIAL LINE TO ct_result ASSIGNING FIELD-SYMBOL(<ls_result_t>).

    ASSIGN COMPONENT c_fieldname_lights    OF STRUCTURE <ls_result_s> TO FIELD-SYMBOL(<lv_lights_s>).
    ASSIGN COMPONENT c_fieldname_lights    OF STRUCTURE <ls_result_t> TO FIELD-SYMBOL(<lv_lights_t>).
    ASSIGN COMPONENT 'CT'                  OF STRUCTURE <ls_result_s> TO FIELD-SYMBOL(<lt_lvc_col_s>).
    ASSIGN COMPONENT 'CT'                  OF STRUCTURE <ls_result_t> TO FIELD-SYMBOL(<lt_lvc_col_t>).
    ASSIGN COMPONENT 'TABNO'               OF STRUCTURE <ls_result_s> TO FIELD-SYMBOL(<lv_tabno_s>).
    <lv_tabno_s> = '#1'.
    ASSIGN COMPONENT 'TABNO'               OF STRUCTURE <ls_result_t> TO FIELD-SYMBOL(<lv_tabno_t>).
    <lv_tabno_t> = '#2'.

    LOOP AT me->gt_link ASSIGNING FIELD-SYMBOL(<ls_link>).

      ASSIGN COMPONENT gs_source-link_fieldname OF STRUCTURE <ls_link> TO FIELD-SYMBOL(<lv_index_s>).
      get_field_value( EXPORTING is_table_details = gs_source
                                 iv_index         = <lv_index_s>
                                 is_line          = is_line_s
                       IMPORTING ev_value         = DATA(lv_value_ref_s)
                                 ev_fieldname     = DATA(l_fieldname_s) ).
      ASSIGN lv_value_ref_s->* TO <lv_value_s>.

      ASSIGN COMPONENT gs_target-link_fieldname OF STRUCTURE <ls_link> TO FIELD-SYMBOL(<lv_index_t>).
      get_field_value( EXPORTING is_table_details = gs_target
                                 iv_index         = <lv_index_t>
                                 is_line          = is_line_t
                       IMPORTING ev_value         = DATA(lv_value_ref_t)
                                 ev_fieldname     = DATA(l_fieldname_t) ).
      ASSIGN lv_value_ref_t->* TO <lv_value_t>.

      IF l_fieldname_s = l_fieldname_t.
        DATA(l_fieldname) = l_fieldname_s.
      ELSE.
        l_fieldname = |{ l_fieldname_s }_{ l_fieldname_t }|.
      ENDIF.

      ASSIGN COMPONENT l_fieldname OF STRUCTURE <ls_result_s> TO FIELD-SYMBOL(<lv_value_compare_s>).
      IF <lv_value_s> IS ASSIGNED.
        <lv_value_compare_s> = <lv_value_s>.
        UNASSIGN <lv_value_s>.
      ENDIF.

      ASSIGN COMPONENT l_fieldname OF STRUCTURE <ls_result_t> TO FIELD-SYMBOL(<lv_value_compare_t>).
      IF <lv_value_t> IS ASSIGNED.
        <lv_value_compare_t> = <lv_value_t>.
        UNASSIGN <lv_value_t>.
      ENDIF.

      IF <ls_link>-type = c_linktype_key.
        compare_set_col_color_key( EXPORTING iv_fieldname_source = l_fieldname  CHANGING  ct_lvc_col = <lt_lvc_col_s> ).
        compare_set_col_color_key( EXPORTING iv_fieldname_target = l_fieldname  CHANGING  ct_lvc_col = <lt_lvc_col_t> ).
      ELSE.
        set_column_color( EXPORTING iv_fieldname = l_fieldname iv_col = 7 iv_int = 0  CHANGING  ct_lvc_t_col = <lt_lvc_col_s> )."+405
        set_column_color( EXPORTING iv_fieldname = l_fieldname iv_col = 7 iv_int = 1  CHANGING  ct_lvc_t_col = <lt_lvc_col_t> )."+405
      ENDIF.

    ENDLOOP.

    update_status_hr( EXPORTING iv_row_status = c_status_missing CHANGING ec_light_field_s = <lv_lights_s> ec_light_field_t = <lv_lights_t> ).

  ENDMETHOD.


  METHOD constructor.

    CREATE DATA gs_source-data LIKE it_source.
    CREATE DATA gs_target-data LIKE it_target.

    ASSIGN gs_source-data->* TO FIELD-SYMBOL(<lt_source>).
    ASSIGN gs_target-data->* TO FIELD-SYMBOL(<lt_target>).

    <lt_source> = it_source.
    <lt_target> = it_target.

    gs_source-number = i_source_number.
    gs_target-number = i_target_number.
    gs_source-name = i_source_name.
    gs_target-name = i_target_name.

    gs_source-pos_left  = 50.
    gs_source-pos_right = 500.
    gs_source-link_fieldname = 'SOURCE'.
    gs_source-compare_prefix = c_prefix_source.

    gs_target-pos_left  = 610.
    gs_target-pos_right = 1060.
    gs_target-link_fieldname = 'TARGET'.
    gs_target-compare_prefix = c_prefix_target.

    gs_source-select_type = iv_source_select_type.
    gs_target-select_type = iv_target_select_type.

    gs_source-cdxdfies = prepare_dfies( it_source_dfies ).
    gs_target-cdxdfies = prepare_dfies( it_target_dfies ).

    gt_result_details = it_result_details.

    g_user_settings = i_user_settings.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name       = 'ICON_LED_RED'
        add_stdinf = ''
      IMPORTING
        result     = gv_icon_red
      EXCEPTIONS
        OTHERS     = 1.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name       = 'ICON_LED_GREEN'
        add_stdinf = ''
      IMPORTING
        result     = gv_icon_green
      EXCEPTIONS
        OTHERS     = 1.

    gv_show_green       = abap_false.
    gv_show_yellow      = abap_true.
    gv_show_red         = abap_true.
    gv_show_all_columns = abap_true.

    gt_excluding_alv = VALUE #( ( cl_gui_alv_grid=>mc_mb_sum )
                                ( cl_gui_alv_grid=>mc_mb_subtot )
                                ( cl_gui_alv_grid=>mc_fc_graph )
                                ( cl_gui_alv_grid=>mc_fc_info )
                                ( cl_gui_alv_grid=>mc_mb_variant )
                                ( cl_gui_alv_grid=>mc_fc_view_excel )
                                ( cl_gui_alv_grid=>mc_fc_filter )
                                ( cl_gui_alv_grid=>mc_fc_sort )
                                ( cl_gui_alv_grid=>mc_fc_sort_asc )
                                ( cl_gui_alv_grid=>mc_fc_sort_dsc )
                                ( cl_gui_alv_grid=>mc_fc_print )
                                ( cl_gui_alv_grid=>mc_mb_view ) ).

  ENDMETHOD.


  METHOD create_compare_result_table.

    DATA: lr_abap_elemdescr     TYPE REF TO cl_abap_elemdescr.
    DATA: lr_abap_typedescr     TYPE REF TO cl_abap_typedescr.
    DATA: lr_compare_structtype TYPE REF TO cl_abap_structdescr .
    DATA: ls_component          TYPE abap_componentdescr.
    DATA: lr_tabletype          TYPE REF TO cl_abap_tabledescr.
    DATA: lv_pos                TYPE i.


    FREE: gt_components_compare.
    FREE: grt_compare_result.
    FREE: grs_compare_result.

* lights
    cl_abap_elemdescr=>get_c( EXPORTING p_length = 1
                              RECEIVING p_result = lr_abap_elemdescr ).
    ls_component-name = c_fieldname_lights.
    ls_component-type = lr_abap_elemdescr.
    APPEND ls_component TO gt_components_compare.
    lv_pos = lv_pos + 1.

* colors
    lr_abap_typedescr = cl_abap_typedescr=>describe_by_name( 'LVC_T_SCOL' ).
    ls_component-name = 'CT'.
    ls_component-type ?= lr_abap_typedescr.
    APPEND ls_component TO gt_components_compare.
    lv_pos = lv_pos + 1.

* mapped columns
    SORT me->gt_link BY type DESCENDING source ASCENDING.

    LOOP AT me->gt_link ASSIGNING FIELD-SYMBOL(<ls_link>).

      APPEND build_result_fcat_line( EXPORTING iv_index         = <ls_link>-source
                                               is_table_details = gs_source ) TO gt_result_fcat.

      APPEND build_result_fcat_line( EXPORTING iv_index         = <ls_link>-target
                                               is_table_details = gs_target ) TO gt_result_fcat.

    ENDLOOP.

    DELETE gt_result_fcat WHERE fieldname IS INITIAL.

    lr_compare_structtype = cl_abap_structdescr=>create( EXPORTING p_components = gt_components_compare
                                                                        p_strict     = space ).

    lr_tabletype = cl_abap_tabledescr=>create( p_line_type  = lr_compare_structtype
                                               p_table_kind = cl_abap_tabledescr=>tablekind_std
                                               p_unique     = abap_false ).

    CREATE DATA grt_compare_result TYPE HANDLE lr_tabletype.
    CREATE DATA grs_compare_result TYPE HANDLE lr_compare_structtype.
  ENDMETHOD.


  METHOD create_compare_result_table_hr.

    DATA: lr_abap_elemdescr     TYPE REF TO cl_abap_elemdescr.
    DATA: lr_abap_typedescr     TYPE REF TO cl_abap_typedescr.
    DATA: lr_compare_structtype TYPE REF TO cl_abap_structdescr .
    DATA: ls_component          TYPE abap_componentdescr.
    DATA: lr_tabletype          TYPE REF TO cl_abap_tabledescr.

    FREE: gt_components_compare.
    FREE: grt_compare_result.
    FREE: grs_compare_result.

    ls_component-name = 'TABNO'.
    ls_component-type ?= cl_abap_elemdescr=>describe_by_data( '/CADAXO/SQLC_DATA_COMP_LST_NR' ).
    APPEND ls_component TO gt_components_compare.

    DATA ls_fcat_tabno TYPE lvc_s_fcat.
    ls_fcat_tabno-fieldname = 'TABNO'.
    ls_fcat_tabno-scrtext_s = 'Nr.'.
    ls_fcat_tabno-scrtext_m = TEXT-007.
    ls_fcat_tabno-outputlen = '2'.
    ls_fcat_tabno-datatype = '/CADAXO/SQLC_DATA_COMP_LST_NR'.
    APPEND ls_fcat_tabno TO gt_result_fcat.

* lights
    cl_abap_elemdescr=>get_c( EXPORTING p_length = 1
                              RECEIVING p_result = lr_abap_elemdescr ).
    ls_component-name = c_fieldname_lights.
    ls_component-type = lr_abap_elemdescr.
    APPEND ls_component TO gt_components_compare.

* colors
    lr_abap_typedescr = cl_abap_typedescr=>describe_by_name( 'LVC_T_SCOL' ).
    ls_component-name = 'CT'.
    ls_component-type ?= lr_abap_typedescr.
    APPEND ls_component TO gt_components_compare.

* mapped columns
    SORT me->gt_link BY type DESCENDING source ASCENDING.
    LOOP AT me->gt_link ASSIGNING FIELD-SYMBOL(<ls_link>).
      APPEND build_result_fcat_line_hr(
        EXPORTING
          iv_index_s         = <ls_link>-source
          is_table_details_s = gs_source
          is_table_details_t = gs_target
          iv_index_t         = <ls_link>-target )
          TO gt_result_fcat.
    ENDLOOP.
    DELETE gt_result_fcat WHERE fieldname IS INITIAL.

    lr_compare_structtype = cl_abap_structdescr=>create( EXPORTING p_components = gt_components_compare
                                                                        p_strict     = space ).

    lr_tabletype = cl_abap_tabledescr=>create( p_line_type  = lr_compare_structtype
                                               p_table_kind = cl_abap_tabledescr=>tablekind_std
                                               p_unique     = abap_false ).

    CREATE DATA grt_compare_result TYPE HANDLE lr_tabletype.
    CREATE DATA grs_compare_result TYPE HANDLE lr_compare_structtype.
  ENDMETHOD.


  METHOD create_result_table.

    DATA lr_structtype TYPE REF TO cl_abap_structdescr.
    DATA lr_tabletype  TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS: <lt_table> TYPE STANDARD TABLE.

    ASSIGN is_table_details-data->* TO <lt_table>.

    CLEAR is_table_details-components_view.

    lr_tabletype  ?= cl_abap_tabledescr=>describe_by_data( p_data = <lt_table> ).
    lr_structtype ?= lr_tabletype->get_table_line_type( ).
    is_table_details-components_view = breakup_components( lr_structtype->get_included_view( ) ).

  ENDMETHOD.


  METHOD create_result_tables.

    create_result_table( CHANGING is_table_details = gs_source ).
    create_result_table( CHANGING is_table_details = gs_target ).

  ENDMETHOD.


  METHOD do_check.

    DATA lv_fieldname_source      TYPE string.
    DATA lv_fieldname_target      TYPE string.
    DATA lv_index                 TYPE n LENGTH 2.
    DATA ls_progress_indi         TYPE tys_progress_indi.
    DATA lv_row_status            TYPE i.
    DATA lv_source_index          TYPE i.
    DATA lv_target_index          TYPE i.
    DATA lv_previous_target_index TYPE i.


    FIELD-SYMBOLS: <lt_source> TYPE STANDARD TABLE.
    FIELD-SYMBOLS: <lt_target> TYPE STANDARD TABLE.
    FIELD-SYMBOLS: <lt_result> TYPE STANDARD TABLE.

    FIELD-SYMBOLS: <lt_lvc_col>          TYPE lvc_t_scol.
    FIELD-SYMBOLS: <lv_value_target>     TYPE any.


    CLEAR: gt_result_fcat,
           gds_rows_comp_state,
           gs_rows_comp_state,
           gv_difference_index,
           gt_detailed_difference.


    sort_original_data( ).

    create_result_tables( ).

    create_compare_result_table( ).

    ASSIGN gs_source-data->* TO <lt_source>.
    ASSIGN gs_target-data->* TO <lt_target>.

    dynamic_key_attributes_create( <lt_target>[ 1 ] ).

    ASSIGN grs_compare_result->* TO FIELD-SYMBOL(<ls_compare_structure>).
    ASSIGN grt_compare_result->* TO <lt_result>.


    ASSIGN gv_key_value01->* TO FIELD-SYMBOL(<lv_key_value01>).
    ASSIGN gv_key_value02->* TO FIELD-SYMBOL(<lv_key_value02>).
    ASSIGN gv_key_value03->* TO FIELD-SYMBOL(<lv_key_value03>).
    ASSIGN gv_key_value04->* TO FIELD-SYMBOL(<lv_key_value04>).
    ASSIGN gv_key_value05->* TO FIELD-SYMBOL(<lv_key_value05>).
    ASSIGN gv_key_value06->* TO FIELD-SYMBOL(<lv_key_value06>).
    ASSIGN gv_key_value07->* TO FIELD-SYMBOL(<lv_key_value07>).
    ASSIGN gv_key_value08->* TO FIELD-SYMBOL(<lv_key_value08>).
    ASSIGN gv_key_value09->* TO FIELD-SYMBOL(<lv_key_value09>).
    ASSIGN gv_key_value10->* TO FIELD-SYMBOL(<lv_key_value10>).
    ASSIGN gv_key_value11->* TO FIELD-SYMBOL(<lv_key_value11>).
    ASSIGN gv_key_value12->* TO FIELD-SYMBOL(<lv_key_value12>).
    ASSIGN gv_key_value13->* TO FIELD-SYMBOL(<lv_key_value13>).
    ASSIGN gv_key_value14->* TO FIELD-SYMBOL(<lv_key_value14>).
    ASSIGN gv_key_value15->* TO FIELD-SYMBOL(<lv_key_value15>).
    ASSIGN gv_key_value16->* TO FIELD-SYMBOL(<lv_key_value16>).
    ASSIGN gv_key_value17->* TO FIELD-SYMBOL(<lv_key_value17>).
    ASSIGN gv_key_value18->* TO FIELD-SYMBOL(<lv_key_value18>).
    ASSIGN gv_key_value19->* TO FIELD-SYMBOL(<lv_key_value19>).
    ASSIGN gv_key_value20->* TO FIELD-SYMBOL(<lv_key_value20>).


    IF lines( <lt_source> ) > lines( <lt_target> ).
      ls_progress_indi-lines_compare = lines( <lt_source> ).
    ELSE.
      ls_progress_indi-lines_compare = lines( <lt_target> ).
    ENDIF.

* compare data
    LOOP AT <lt_source> ASSIGNING FIELD-SYMBOL(<ls_source>).

      lv_source_index = sy-tabix.

      show_progress_indicator( CHANGING cs_progress_inidcator = ls_progress_indi ).
      CLEAR lv_row_status.
      CLEAR lv_index.

      LOOP AT me->gt_link ASSIGNING FIELD-SYMBOL(<ls_link>) WHERE type = c_linktype_key.
        lv_index = lv_index + 1.
        get_field_value( EXPORTING is_table_details = gs_source
                                   iv_index         = <ls_link>-source
                                   is_line          = <ls_source>
                         IMPORTING ev_value         = DATA(lv_value_ref)
                                   ev_fieldname     = lv_fieldname_source ).
        ASSIGN lv_value_ref->* TO FIELD-SYMBOL(<lv_source_value>).
        IF lv_fieldname_source IS NOT INITIAL.
          DATA(lv_key_fieldname) = '<LV_KEY_VALUE' && lv_index && '>'.
          ASSIGN (lv_key_fieldname) TO FIELD-SYMBOL(<lv_key_value_xx>).
          IF sy-subrc = 0.
            <lv_key_value_xx> = <lv_source_value>.
          ENDIF.
        ENDIF.
      ENDLOOP.

      READ TABLE <lt_target> WITH KEY (gv_key_name01) = <lv_key_value01>
                                      (gv_key_name02) = <lv_key_value02>
                                      (gv_key_name03) = <lv_key_value03>
                                      (gv_key_name04) = <lv_key_value04>
                                      (gv_key_name05) = <lv_key_value05>
                                      (gv_key_name06) = <lv_key_value06>
                                      (gv_key_name07) = <lv_key_value07>
                                      (gv_key_name08) = <lv_key_value08>
                                      (gv_key_name09) = <lv_key_value09>
                                      (gv_key_name10) = <lv_key_value10>
                                      (gv_key_name11) = <lv_key_value11>
                                      (gv_key_name12) = <lv_key_value12>
                                      (gv_key_name13) = <lv_key_value13>
                                      (gv_key_name14) = <lv_key_value14>
                                      (gv_key_name15) = <lv_key_value15>
                                      (gv_key_name16) = <lv_key_value16>
                                      (gv_key_name17) = <lv_key_value17>
                                      (gv_key_name18) = <lv_key_value18>
                                      (gv_key_name19) = <lv_key_value19>
                                      (gv_key_name20) = <lv_key_value20>
                                       ASSIGNING FIELD-SYMBOL(<ls_target>).
      IF sy-subrc = 0.

        lv_target_index = sy-tabix.

        IF lv_previous_target_index + 1 < lv_target_index.
          LOOP AT <lt_target> FROM lv_previous_target_index + 1 TO lv_target_index - 1 ASSIGNING FIELD-SYMBOL(<ls_previous_target>).

            show_progress_indicator( CHANGING cs_progress_inidcator = ls_progress_indi ).

            APPEND INITIAL LINE TO <lt_result> ASSIGNING FIELD-SYMBOL(<ls_compare_previous>).

            compare_set_line_missing( EXPORTING is_table_details = gs_target
                                                is_line          = <ls_previous_target>
                                      CHANGING  is_compare_line  = <ls_compare_previous> ).

          ENDLOOP.

        ENDIF.

        lv_row_status = c_status_equal.

        lv_previous_target_index = lv_target_index.

        CLEAR <ls_compare_structure>.
        APPEND <ls_compare_structure> TO <lt_result> ASSIGNING FIELD-SYMBOL(<ls_compare_line>).
        DATA(lv_compare_index) = sy-tabix.

        ASSIGN COMPONENT c_fieldname_lights OF STRUCTURE <ls_compare_line> TO FIELD-SYMBOL(<lv_lights>).
        ASSIGN COMPONENT 'CT' OF STRUCTURE <ls_compare_line> TO <lt_lvc_col>.

        LOOP AT me->gt_link ASSIGNING <ls_link>.

          get_field_value( EXPORTING is_table_details = gs_source
                                     iv_index         = <ls_link>-source
                                     is_line          = <ls_source>
                           IMPORTING ev_value         = lv_value_ref
                                     ev_fieldname     = lv_fieldname_source ).
          ASSIGN lv_value_ref->* TO <lv_source_value>.

          get_field_value( EXPORTING is_table_details = gs_target
                                     iv_index         = <ls_link>-target
                                     is_line          = <ls_target>
                           IMPORTING ev_value         = lv_value_ref
                                     ev_fieldname     = lv_fieldname_target ).
          ASSIGN lv_value_ref->* TO <lv_value_target>.

          lv_fieldname_source = c_prefix_source && lv_fieldname_source.
          ASSIGN COMPONENT lv_fieldname_source OF STRUCTURE <ls_compare_line> TO FIELD-SYMBOL(<lv_value_compare_source>).
          <lv_value_compare_source> = <lv_source_value>.

          lv_fieldname_target = c_prefix_target && lv_fieldname_target.
          ASSIGN COMPONENT lv_fieldname_target OF STRUCTURE <ls_compare_line> TO FIELD-SYMBOL(<lv_value_compare_target>).
          <lv_value_compare_target> = <lv_value_target>.

          IF <ls_link>-type = c_linktype_field.
            IF <lv_value_compare_source> = <lv_value_compare_target>.

              compare_set_col_color_equal( EXPORTING iv_fieldname_source = lv_fieldname_source
                                                     iv_fieldname_target = lv_fieldname_target
                                           CHANGING  ct_lvc_col          = <lt_lvc_col> ).

            ELSE.

              lv_row_status = c_status_different.

              compare_set_col_color_diff( EXPORTING iv_fieldname_source = lv_fieldname_source
                                                    iv_fieldname_target = lv_fieldname_target
                                                    iv_line_index       = lv_compare_index
                                          CHANGING  ct_lvc_col          = <lt_lvc_col> ).

            ENDIF.

          ELSE.

            compare_set_col_color_key( EXPORTING iv_fieldname_source = lv_fieldname_source
                                                 iv_fieldname_target = lv_fieldname_target
                                       CHANGING  ct_lvc_col          = <lt_lvc_col> ).

            compare_column_name_diff( iv_fieldname = lv_fieldname_source iv_line_index = 0 ).
            compare_column_name_diff( iv_fieldname = lv_fieldname_target iv_line_index = 0 ).

          ENDIF.

        ENDLOOP.

        update_status( EXPORTING iv_row_status = lv_row_status CHANGING ec_light_field = <lv_lights> ).
      ELSE.

        APPEND <ls_compare_structure> TO <lt_result> ASSIGNING <ls_compare_line>.
        compare_set_line_missing( EXPORTING is_table_details = gs_source
                                            is_line          = <ls_source>
                                  CHANGING  is_compare_line  = <ls_compare_line> ).

      ENDIF.

    ENDLOOP.

    IF lv_previous_target_index < lines( <lt_target> ).
      LOOP AT <lt_target> FROM lv_previous_target_index + 1 ASSIGNING <ls_target>.
        CLEAR <ls_compare_structure>.

        show_progress_indicator( CHANGING cs_progress_inidcator = ls_progress_indi ).

        compare_set_line_missing( EXPORTING is_table_details = gs_target
                                    is_line          = <ls_target>
                          CHANGING  is_compare_line  = <ls_compare_structure> ).
        APPEND <ls_compare_structure> TO <lt_result>.

      ENDLOOP.
    ENDIF.

    fill_gds_rows_comp_state( )."cockpit+402
  ENDMETHOD.


  METHOD do_check_hr.

    DATA lv_fieldname_source      TYPE string.
    DATA lv_fieldname_target      TYPE string.
    DATA lv_index                 TYPE n LENGTH 2.
    DATA ls_progress_indi         TYPE tys_progress_indi.
    DATA lv_row_status            TYPE i.
    DATA lv_source_index          TYPE i.
    DATA lv_target_index          TYPE i.
    DATA lv_previous_target_index TYPE i.

    FIELD-SYMBOLS: <lt_source> TYPE STANDARD TABLE.
    FIELD-SYMBOLS: <lt_target> TYPE STANDARD TABLE.
    FIELD-SYMBOLS: <lt_result> TYPE STANDARD TABLE.

    FIELD-SYMBOLS: <lt_lvc_col_s>          TYPE lvc_t_scol.
    FIELD-SYMBOLS: <lv_value_target>     TYPE any.

    CLEAR: gt_result_fcat,
           gds_rows_comp_state,
           gs_rows_comp_state,
           gv_difference_index,
           gt_detailed_difference.

    sort_original_data( ).

    create_result_tables( ).

    create_compare_result_table_hr( ).

    ASSIGN gs_source-data->* TO <lt_source>.
    ASSIGN gs_target-data->* TO <lt_target>.

    dynamic_key_attributes_create( <lt_target>[ 1 ] ).

    ASSIGN grs_compare_result->* TO FIELD-SYMBOL(<ls_compare_source>).
    ASSIGN grs_compare_result->* TO FIELD-SYMBOL(<ls_compare_target>)."+405
    ASSIGN grt_compare_result->* TO <lt_result>.

    ASSIGN gv_key_value01->* TO FIELD-SYMBOL(<lv_key_value01>).
    ASSIGN gv_key_value02->* TO FIELD-SYMBOL(<lv_key_value02>).
    ASSIGN gv_key_value03->* TO FIELD-SYMBOL(<lv_key_value03>).
    ASSIGN gv_key_value04->* TO FIELD-SYMBOL(<lv_key_value04>).
    ASSIGN gv_key_value05->* TO FIELD-SYMBOL(<lv_key_value05>).
    ASSIGN gv_key_value06->* TO FIELD-SYMBOL(<lv_key_value06>).
    ASSIGN gv_key_value07->* TO FIELD-SYMBOL(<lv_key_value07>).
    ASSIGN gv_key_value08->* TO FIELD-SYMBOL(<lv_key_value08>).
    ASSIGN gv_key_value09->* TO FIELD-SYMBOL(<lv_key_value09>).
    ASSIGN gv_key_value10->* TO FIELD-SYMBOL(<lv_key_value10>).
    ASSIGN gv_key_value11->* TO FIELD-SYMBOL(<lv_key_value11>).
    ASSIGN gv_key_value12->* TO FIELD-SYMBOL(<lv_key_value12>).
    ASSIGN gv_key_value13->* TO FIELD-SYMBOL(<lv_key_value13>).
    ASSIGN gv_key_value14->* TO FIELD-SYMBOL(<lv_key_value14>).
    ASSIGN gv_key_value15->* TO FIELD-SYMBOL(<lv_key_value15>).
    ASSIGN gv_key_value16->* TO FIELD-SYMBOL(<lv_key_value16>).
    ASSIGN gv_key_value17->* TO FIELD-SYMBOL(<lv_key_value17>).
    ASSIGN gv_key_value18->* TO FIELD-SYMBOL(<lv_key_value18>).
    ASSIGN gv_key_value19->* TO FIELD-SYMBOL(<lv_key_value19>).
    ASSIGN gv_key_value20->* TO FIELD-SYMBOL(<lv_key_value20>).


    IF lines( <lt_source> ) > lines( <lt_target> ).
      ls_progress_indi-lines_compare = lines( <lt_source> ).
    ELSE.
      ls_progress_indi-lines_compare = lines( <lt_target> ).
    ENDIF.

* compare data
    LOOP AT <lt_source> ASSIGNING FIELD-SYMBOL(<ls_source>).

      lv_source_index = sy-tabix.

      show_progress_indicator( CHANGING cs_progress_inidcator = ls_progress_indi ).
      CLEAR lv_row_status.
      CLEAR lv_index.

      LOOP AT me->gt_link ASSIGNING FIELD-SYMBOL(<ls_link>) WHERE type = c_linktype_key.
        lv_index = lv_index + 1.
        get_field_value( EXPORTING is_table_details = gs_source
                                   iv_index         = <ls_link>-source
                                   is_line          = <ls_source>
                         IMPORTING ev_value         = DATA(lv_value_ref)
                                   ev_fieldname     = lv_fieldname_source ).
        ASSIGN lv_value_ref->* TO FIELD-SYMBOL(<lv_source_value>).
        IF lv_fieldname_source IS NOT INITIAL.
          DATA(lv_key_fieldname) = '<LV_KEY_VALUE' && lv_index && '>'.
          ASSIGN (lv_key_fieldname) TO FIELD-SYMBOL(<lv_key_value_xx>).
          IF sy-subrc = 0.
            <lv_key_value_xx> = <lv_source_value>.
          ENDIF.
        ENDIF.
      ENDLOOP.

      READ TABLE <lt_target> WITH KEY (gv_key_name01) = <lv_key_value01>
                                      (gv_key_name02) = <lv_key_value02>
                                      (gv_key_name03) = <lv_key_value03>
                                      (gv_key_name04) = <lv_key_value04>
                                      (gv_key_name05) = <lv_key_value05>
                                      (gv_key_name06) = <lv_key_value06>
                                      (gv_key_name07) = <lv_key_value07>
                                      (gv_key_name08) = <lv_key_value08>
                                      (gv_key_name09) = <lv_key_value09>
                                      (gv_key_name10) = <lv_key_value10>
                                      (gv_key_name11) = <lv_key_value11>
                                      (gv_key_name12) = <lv_key_value12>
                                      (gv_key_name13) = <lv_key_value13>
                                      (gv_key_name14) = <lv_key_value14>
                                      (gv_key_name15) = <lv_key_value15>
                                      (gv_key_name16) = <lv_key_value16>
                                      (gv_key_name17) = <lv_key_value17>
                                      (gv_key_name18) = <lv_key_value18>
                                      (gv_key_name19) = <lv_key_value19>
                                      (gv_key_name20) = <lv_key_value20>
                                       ASSIGNING FIELD-SYMBOL(<ls_target>).
      IF sy-subrc = 0.

        lv_target_index = sy-tabix.

        IF lv_previous_target_index + 1 < lv_target_index.
          LOOP AT <lt_target> FROM lv_previous_target_index + 1 TO lv_target_index - 1 ASSIGNING FIELD-SYMBOL(<ls_previous_target>).

            show_progress_indicator( CHANGING cs_progress_inidcator = ls_progress_indi ).

            compare_set_line_missing_hr(
              EXPORTING
                is_line_s = space
                is_line_t = <ls_previous_target>
              CHANGING
                ct_result = <lt_result> ).

          ENDLOOP.
        ENDIF.

        lv_row_status = c_status_equal.

        lv_previous_target_index = lv_target_index.

        CLEAR <ls_compare_source>.
        CLEAR <ls_compare_target>."+405
        APPEND <ls_compare_source> TO <lt_result> ASSIGNING FIELD-SYMBOL(<ls_result_source>).
        APPEND <ls_compare_target> TO <lt_result> ASSIGNING FIELD-SYMBOL(<ls_result_target>)."+405
        DATA(lv_compare_index) = sy-tabix.

        ASSIGN COMPONENT c_fieldname_lights OF STRUCTURE <ls_result_source> TO FIELD-SYMBOL(<lv_lights_s>).
        ASSIGN COMPONENT 'CT' OF STRUCTURE <ls_result_source> TO <lt_lvc_col_s>.
        ASSIGN COMPONENT 'TABNO' OF STRUCTURE <ls_result_source> TO FIELD-SYMBOL(<lv_tabno_s>).
        <lv_tabno_s> = '#1'.

        ASSIGN COMPONENT c_fieldname_lights OF STRUCTURE <ls_result_target> TO FIELD-SYMBOL(<lv_lights_t>)."+405
        ASSIGN COMPONENT 'CT' OF STRUCTURE <ls_result_target> TO FIELD-SYMBOL(<lt_lvc_col_t>)."+405
        ASSIGN COMPONENT 'TABNO' OF STRUCTURE <ls_result_target> TO FIELD-SYMBOL(<lv_tabno_t>).
        <lv_tabno_t> = '#2'.

        LOOP AT me->gt_link ASSIGNING <ls_link>.

          get_field_value( EXPORTING is_table_details = gs_source
                                     iv_index         = <ls_link>-source
                                     is_line          = <ls_source>
                           IMPORTING ev_value         = lv_value_ref
                                     ev_fieldname     = lv_fieldname_source ).
          ASSIGN lv_value_ref->* TO <lv_source_value>.

          get_field_value( EXPORTING is_table_details = gs_target
                                     iv_index         = <ls_link>-target
                                     is_line          = <ls_target>
                           IMPORTING ev_value         = lv_value_ref
                                     ev_fieldname     = lv_fieldname_target ).
          ASSIGN lv_value_ref->* TO <lv_value_target>.

          IF lv_fieldname_source NE lv_fieldname_target.
            lv_fieldname_source = lv_fieldname_target = |{ lv_fieldname_source }_{ lv_fieldname_target }|.
          ENDIF.
          ASSIGN COMPONENT lv_fieldname_source OF STRUCTURE <ls_result_source> TO FIELD-SYMBOL(<lv_value_compare_source>).
          <lv_value_compare_source> = <lv_source_value>.

          ASSIGN COMPONENT lv_fieldname_target OF STRUCTURE <ls_result_target> TO FIELD-SYMBOL(<lv_value_compare_target>)."+Cockpit405
          <lv_value_compare_target> = <lv_value_target>.

          IF <ls_link>-type = c_linktype_field.

            IF <lv_value_compare_source> = <lv_value_compare_target>.

              set_column_color( EXPORTING iv_fieldname = lv_fieldname_source iv_col = 7 iv_int = 0  CHANGING  ct_lvc_t_col = <lt_lvc_col_s> )."+405
              set_column_color( EXPORTING iv_fieldname = lv_fieldname_target iv_col = 7 iv_int = 1  CHANGING  ct_lvc_t_col = <lt_lvc_col_t> )."+405

            ELSE.

              lv_row_status = c_status_different.

              compare_column_name_diff( iv_fieldname = lv_fieldname_source iv_line_index = lv_compare_index ).
              compare_column_name_diff( iv_fieldname = lv_fieldname_target iv_line_index = lv_compare_index ).

              set_column_color( EXPORTING iv_fieldname = lv_fieldname_source iv_col = 3 iv_int = 0 CHANGING ct_lvc_t_col = <lt_lvc_col_s> ).
              set_column_color( EXPORTING iv_fieldname = lv_fieldname_target iv_col = 3 iv_int = 1 CHANGING ct_lvc_t_col = <lt_lvc_col_t> ).

            ENDIF.

          ELSE."key field

            compare_set_col_color_key( EXPORTING iv_fieldname_source = lv_fieldname_source  CHANGING  ct_lvc_col = <lt_lvc_col_s> ).
            compare_set_col_color_key( EXPORTING iv_fieldname_target = lv_fieldname_target  CHANGING  ct_lvc_col = <lt_lvc_col_t> ).

            compare_column_name_diff( iv_fieldname = lv_fieldname_source iv_line_index = 0 ).
            compare_column_name_diff( iv_fieldname = lv_fieldname_target iv_line_index = 0 ).

          ENDIF.

        ENDLOOP.

        update_status_hr( EXPORTING iv_row_status = lv_row_status CHANGING ec_light_field_s = <lv_lights_s> ec_light_field_t = <lv_lights_t> )."405

      ELSE.

        compare_set_line_missing_hr(
          EXPORTING
            is_line_s = <ls_source>
            is_line_t = space
          CHANGING
            ct_result = <lt_result> ).

      ENDIF.

    ENDLOOP.

    IF lv_previous_target_index < lines( <lt_target> ).
      LOOP AT <lt_target> FROM lv_previous_target_index + 1 ASSIGNING <ls_target>.

        show_progress_indicator( CHANGING cs_progress_inidcator = ls_progress_indi ).

        compare_set_line_missing_hr(
          EXPORTING
            is_line_s =  space
            is_line_t =  <ls_target>
          CHANGING
            ct_result = <lt_result>
        ).
      ENDLOOP.
    ENDIF.

    fill_gds_rows_comp_state( ).

  ENDMETHOD.


  METHOD dynamic_key_attributes_clear.

    CLEAR: gv_key_value01,
            gv_key_value02,
            gv_key_value03,
            gv_key_value04,
            gv_key_value05,
            gv_key_value06,
            gv_key_value07,
            gv_key_value08,
            gv_key_value09,
            gv_key_value10,
            gv_key_value11,
            gv_key_value12,
            gv_key_value13,
            gv_key_value14,
            gv_key_value15,
            gv_key_value16,
            gv_key_value17,
            gv_key_value18,
            gv_key_value19,
            gv_key_value20.

    CLEAR: gv_key_name01,
           gv_key_name02,
           gv_key_name03,
           gv_key_name04,
           gv_key_name05,
           gv_key_name06,
           gv_key_name07,
           gv_key_name08,
           gv_key_name09,
           gv_key_name10,
           gv_key_name11,
           gv_key_name12,
           gv_key_name13,
           gv_key_name14,
           gv_key_name15,
           gv_key_name16,
           gv_key_name17,
           gv_key_name18,
           gv_key_name19,
           gv_key_name20.

  ENDMETHOD.


  METHOD dynamic_key_attributes_create.

    DATA lv_index         TYPE n LENGTH 2.
    DATA lv_key_fieldname TYPE string.

    dynamic_key_attributes_clear( ).

    CLEAR lv_index.
    lv_index = lv_index + 1.
    LOOP AT gs_target-sort_tab ASSIGNING FIELD-SYMBOL(<ls_sort>).


      lv_key_fieldname = 'GV_KEY_NAME' && lv_index.

      ASSIGN (lv_key_fieldname) TO FIELD-SYMBOL(<ls_key_name_xx>).

      IF sy-subrc = 0.

        <ls_key_name_xx> = <ls_sort>-name.

      ENDIF.

      lv_key_fieldname = 'GV_KEY_VALUE' && lv_index.

      ASSIGN (lv_key_fieldname) TO FIELD-SYMBOL(<ls_key_value_xx>).
      IF sy-subrc = 0.
        ASSIGN COMPONENT <ls_key_name_xx> OF STRUCTURE is_tabline TO FIELD-SYMBOL(<lv_value>).
        IF sy-subrc = 0.
          CREATE DATA <ls_key_value_xx> LIKE <lv_value>.
          lv_index = lv_index + 1.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD fieldmapping_delete.

    DATA lt_links TYPE aqq_t_links.
    DATA ls_link TYPE aqslinks.

    LOOP AT gt_link ASSIGNING FIELD-SYMBOL(<fs_link>).
      ls_link-r_link = <fs_link>-link.
      APPEND ls_link TO lt_links.
    ENDLOOP.

    gr_netplan->delete_objects( i_t_link = lt_links ).

    CLEAR gt_link.

    me->check_keys( ).

    me->set_link_status_icons( ).

  ENDMETHOD.


  METHOD fieldmapping_set.
    DATA l_index_source            TYPE int2.
    DATA l_index_target            TYPE int2.
    DATA ls_dfies                  TYPE dfies.
    CLEAR ls_dfies.


    LOOP AT gs_source-cdxdfies ASSIGNING FIELD-SYMBOL(<ls_dfies_s>).
      l_index_source = sy-tabix.

      IF iv_kind = c_mapkind_fieldname.
        l_index_target = line_index( gs_target-cdxdfies[ fieldname = <ls_dfies_s>-fieldname ] ).
      ELSE.
        l_index_target = l_index_source.
      ENDIF.

      TRY.
          DATA(lv_linktype) = me->is_field_mapping_allowed( EXPORTING iv_idx_source = l_index_source
                                                                      iv_idx_target = l_index_target ).

          me->link_create( EXPORTING iv_predrow   = l_index_source
                                     iv_succrow   = l_index_target
                                     iv_type      = lv_linktype ).

          DATA(lv_changed) = abap_true.

        CATCH /cadaxo/cx_sqlc_dcomp_fieldmap INTO DATA(lx_mapping).

      ENDTRY.

    ENDLOOP.

    IF lv_changed = abap_true.

      me->set_link_status_icons( ).

      gr_netplan->send_data_to_frontend( ).

      me->check_keys( ).

    ENDIF.

  ENDMETHOD.


  METHOD fill_gds_rows_comp_state.

    gds_rows_comp_state = CORRESPONDING #( gs_rows_comp_state ).
    gds_rows_comp_state-percent_equal = ( gds_rows_comp_state-equal / ( gds_rows_comp_state-equal + gds_rows_comp_state-different + gds_rows_comp_state-missing ) ) * 100."+Cockpit402
    gds_rows_comp_state-percent_different = ( gds_rows_comp_state-different / ( gds_rows_comp_state-equal + gds_rows_comp_state-different + gds_rows_comp_state-missing ) ) * 100."+Cockpit402
    gds_rows_comp_state-percent_missing = ( gds_rows_comp_state-missing / ( gds_rows_comp_state-equal + gds_rows_comp_state-different + gds_rows_comp_state-missing ) ) * 100."+Cockpit402
    gds_rows_comp_state-percent_equal_c = gds_rows_comp_state-percent_equal.
    gds_rows_comp_state-percent_different_c = gds_rows_comp_state-percent_different.
    gds_rows_comp_state-percent_missing_c = gds_rows_comp_state-percent_missing.

  ENDMETHOD.


  METHOD free.

    free_netplan( ).

    free_results( ).

  ENDMETHOD.


  METHOD free_netplan.

    IF gr_netplan IS BOUND.
      gr_netplan->free_it( ).
    ENDIF.

    IF gs_target-netplan_tab IS BOUND.
      gs_target-netplan_tab->clear( ).
    ENDIF.

    IF gs_source-netplan_tab IS BOUND.
      gs_source-netplan_tab->clear( ).
    ENDIF.

    IF gr_container_mapping IS BOUND.
      gr_container_mapping->free( ).
    ENDIF.

    FREE gr_netplan.
    FREE gs_source-netplan_tab.
    FREE gs_target-netplan_tab.
    FREE gr_container_mapping.

  ENDMETHOD.


  METHOD free_results.

    IF gr_compare_results_grid IS BOUND.
      gr_compare_results_grid->free( ).
    ENDIF.

    IF gr_container_results IS BOUND.
      gr_container_results->free( ).
    ENDIF.

    FREE grt_compare_result.
    FREE gr_compare_results_grid.
    FREE gr_container_results.

  ENDMETHOD.


  METHOD get_cusror_field.

    IF iv_default_field_pos > lines( it_fcat ).
      rv_cursor_field_pos = lines( it_fcat ).
    ELSE.
      rv_cursor_field_pos = iv_default_field_pos.
    ENDIF.

    IF iv_mark_target = abap_true.
      DATA(lv_add_to_source) = 1.
      DATA(lv_add_to_target) = 0.
    ELSE.
      lv_add_to_source = 0.
      lv_add_to_target = -1.
    ENDIF.

    ASSIGN it_fcat[ fieldname = is_column_id-fieldname ] TO FIELD-SYMBOL(<ls_fcat>).
    IF sy-subrc = 0.

      IF is_column_id-fieldname CP |{ c_prefix_source }*|.
        rv_cursor_field_pos = sy-tabix + lv_add_to_source.
      ELSEIF is_column_id-fieldname CP |{ c_prefix_target }*|.
        rv_cursor_field_pos = sy-tabix + lv_add_to_target.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_fieldname.

    CLEAR rv_fieldname.

    IF iv_select_type = 1.

      rv_fieldname = is_dfies_cadaxo-fieldname.

    ELSEIF is_dfies_cadaxo-map_fieldname CA '-'.

      rv_fieldname = is_dfies_cadaxo-map_fieldname.

    ELSEIF ( is_dfies_cadaxo-tabname IS NOT INITIAL AND is_dfies_cadaxo-map_fieldname IS NOT INITIAL ).

      rv_fieldname = is_dfies_cadaxo-tabname && '-' && is_dfies_cadaxo-map_fieldname.

    ELSEIF is_dfies_cadaxo-tabname IS NOT INITIAL.

      rv_fieldname = is_dfies_cadaxo-tabname.

    ELSEIF is_dfies_cadaxo-map_fieldname IS NOT INITIAL.

      rv_fieldname = is_dfies_cadaxo-map_fieldname.

    ELSE.

      rv_fieldname = is_dfies_cadaxo-fieldname.

    ENDIF.

  ENDMETHOD.


  METHOD get_field_meta.

    DATA ls_dfies TYPE dfies.
    DATA lr_abap_elemdescr TYPE REF TO cl_abap_elemdescr.
    DATA lr_abap_typedescr TYPE REF TO cl_abap_typedescr.

    CLEAR: es_meta_data.

    IF is_dfies-datatype IS NOT INITIAL.
      es_meta_data-datatype = to_lower( is_dfies-datatype ).
      es_meta_data-length   = is_dfies-outputlen.
      es_meta_data-decimals = is_dfies-decimals.
      es_meta_data-is_key   = is_dfies-keyflag.
    ELSE.
      IF is_dfies-reftable IS NOT INITIAL AND
         is_dfies-reffield IS NOT INITIAL.

        DATA(l_name) = is_dfies-reftable && '-' && is_dfies-reffield.

        cl_abap_elemdescr=>describe_by_name( EXPORTING  p_name         = l_name
                                             RECEIVING  p_descr_ref    = lr_abap_typedescr
                                             EXCEPTIONS OTHERS         = 2 ).
        IF sy-subrc = 0.

          lr_abap_elemdescr ?= lr_abap_typedescr.

          ls_dfies = lr_abap_elemdescr->get_ddic_field( ).

          es_meta_data-datatype =  to_lower( ls_dfies-datatype ).
          es_meta_data-length = ls_dfies-outputlen.
          es_meta_data-decimals = ls_dfies-decimals.
          IF ls_dfies-keyflag IS NOT INITIAL OR is_dfies-keyflag IS NOT INITIAL.
            es_meta_data-is_key = abap_true.
          ENDIF.

        ENDIF.


      ENDIF.

      IF es_meta_data-datatype IS INITIAL.

        CASE is_dfies-inttype.
          WHEN 'P'.
            es_meta_data-datatype = 'dec'.
          WHEN 'I'.
            es_meta_data-datatype = 'int'.
          WHEN 'T'.
            es_meta_data-datatype = 'tims'.
          WHEN 'D'.
            es_meta_data-datatype = 'dats'.
          WHEN 'N'.
            es_meta_data-datatype = 'numc'.
          WHEN 'F'.
            es_meta_data-datatype = 'fltp'.
          WHEN 'X'.
            es_meta_data-datatype = 'int2'.
          WHEN 'C'.
            es_meta_data-datatype = 'char'.
          WHEN 'b'.
            es_meta_data-datatype = 'int1'.
          WHEN 's'.
            es_meta_data-datatype = 'int2'.
          WHEN 'g'.
            es_meta_data-datatype = 'strg'.
          WHEN 'y'.
            es_meta_data-datatype = 'rstr'.
          WHEN 'a'.
            es_meta_data-datatype = 'd16d'.
          WHEN 'e'.
            es_meta_data-datatype = 'd34d'.
          WHEN '8'.
            es_meta_data-datatype = 'i8b'.
          WHEN 'p'.
            es_meta_data-datatype = 'dec'.
          WHEN OTHERS.
            es_meta_data-datatype =  to_lower( is_dfies-inttype ).
        ENDCASE.

        es_meta_data-length   = is_dfies-outputlen.
        es_meta_data-decimals = is_dfies-decimals.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_field_value.

    CLEAR ev_fieldname.
*    CLEAR ev_fieldname_db.
    CLEAR ev_value.

    READ TABLE is_table_details-cdxdfies INDEX iv_index ASSIGNING FIELD-SYMBOL(<ls_dfies>).
    IF sy-subrc = 0.

*      ev_fieldname_db = <ls_dfies>-fieldname.
      ev_fieldname = get_fieldname( EXPORTING is_dfies_cadaxo = <ls_dfies>
                                              iv_select_type  = is_table_details-select_type ).
      ASSIGN COMPONENT ev_fieldname OF STRUCTURE is_line TO FIELD-SYMBOL(<lv_value>).
      IF sy-subrc = 0.

        ev_value = REF #( <lv_value> ).

      ENDIF.

    ELSE.

    ENDIF.

  ENDMETHOD.


  METHOD is_field_mapping_allowed.
*    DATA lv_datatype_source TYPE dynptype.
*    DATA lv_length_source   TYPE outputlen.
*    DATA lv_decimals_source TYPE decimals.
*    DATA lv_datatype_target TYPE dynptype.
*    DATA lv_length_target   TYPE outputlen.
*    DATA lv_decimals_target TYPE decimals.


    ASSIGN gs_source-cdxdfies[ iv_idx_source ] TO FIELD-SYMBOL(<ls_dfies_source>).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_dcomp_fieldmap
        EXPORTING
          textid  = /cadaxo/cx_sqlc_dcomp_fieldmap=>invalid_index
          iv_msg1 = TEXT-stn
          iv_msg2 = |{ iv_idx_source }|.
    ENDIF.
    ASSIGN gs_target-cdxdfies[ iv_idx_target ] TO FIELD-SYMBOL(<ls_dfies_target>).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_dcomp_fieldmap
        EXPORTING
          textid  = /cadaxo/cx_sqlc_dcomp_fieldmap=>invalid_index
          iv_msg1 = TEXT-ttn
          iv_msg2 = |{ iv_idx_target }|.
    ENDIF.

    IF iv_move_target IS INITIAL AND line_exists( gt_link[ source = iv_idx_source ] ) .
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_dcomp_fieldmap
        EXPORTING
          textid  = /cadaxo/cx_sqlc_dcomp_fieldmap=>mapping_exists
          iv_msg1 = TEXT-stn
          iv_msg2 = CONV #( get_fieldname( is_dfies_cadaxo = <ls_dfies_source>
                                           iv_select_type  = gs_source-select_type ) ).
    ELSEIF iv_move_source IS INITIAL AND line_exists( gt_link[ target = iv_idx_target ] ).
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_dcomp_fieldmap
        EXPORTING
          textid  = /cadaxo/cx_sqlc_dcomp_fieldmap=>mapping_exists
          iv_msg1 = TEXT-ttn
          iv_msg2 = CONV #( get_fieldname( is_dfies_cadaxo = <ls_dfies_target>
                                           iv_select_type  = gs_target-select_type ) ).
    ENDIF.


    me->get_field_meta( EXPORTING is_dfies     = CORRESPONDING #( <ls_dfies_source> )
                        IMPORTING es_meta_data = DATA(ls_meta_source) ).

    ev_linktype = COND #( WHEN ls_meta_source-is_key = abap_true THEN c_linktype_key
                          ELSE c_linktype_field ) .


    me->get_field_meta( EXPORTING is_dfies     = CORRESPONDING #( <ls_dfies_target> )
                        IMPORTING es_meta_data =  DATA(ls_meta_target)  ).

    ev_linktype = COND #( WHEN ev_linktype = c_linktype_key AND ls_meta_target-is_key = abap_true THEN c_linktype_key
                          ELSE c_linktype_field ) .

    TRY.
        check_field_mapping_types( EXPORTING iv_datatype_source = ls_meta_source-datatype
                                             iv_length_source   = ls_meta_source-length
                                             iv_decimals_source = ls_meta_source-decimals
                                             iv_datatype_target = ls_meta_target-datatype
                                             iv_length_target   = ls_meta_target-length
                                             iv_decimals_target = ls_meta_target-decimals  ).
      CATCH /cadaxo/cx_sqlc_dcomp_fieldmap INTO DATA(lx_mapping).
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_dcomp_fieldmap
          EXPORTING
            textid              = /cadaxo/cx_sqlc_dcomp_fieldmap=>invalid_types
            mv_fieldname_source = CONV #( get_fieldname( is_dfies_cadaxo = <ls_dfies_source>
                                                   iv_select_type  = gs_source-select_type ) )
            mv_fieldname_target = CONV #( get_fieldname( is_dfies_cadaxo = <ls_dfies_target>
                                                   iv_select_type  = gs_target-select_type ) )
            iv_msg1             = |{ ls_meta_source-datatype }/{ shift_left( val = ls_meta_source-length sub = '0' ) }/{ shift_left( val = ls_meta_source-decimals sub = '0' ) }|
            iv_msg2             = |{ ls_meta_target-datatype }/{ shift_left( val = ls_meta_target-length sub = '0' ) }/{ shift_left( val = ls_meta_target-decimals sub = '0' ) }|.
    ENDTRY.
  ENDMETHOD.


  METHOD legent_build_line.

    DATA ls_result_details TYPE /cadaxo/sqlcresult_details.
    CLEAR es_legend.
    ls_result_details     = gt_result_details[ is_table_details-number ].

    es_legend-syst        = ls_result_details-syst.
    es_legend-mandant     = ls_result_details-mandant.
    es_legend-list_number = '#' && is_table_details-number.
    es_legend-tables      = is_table_details-name.
    es_legend-saved_list  = ls_result_details-saved_list.

    CONVERT TIME STAMP ls_result_details-create_timestamp TIME ZONE sy-zonlo INTO DATE es_legend-created_date TIME es_legend-created_time.

    set_column_color( EXPORTING iv_fieldname = 'LIST_NUMBER' iv_col = iv_col iv_int = iv_int
                      CHANGING  ct_lvc_t_col = es_legend-ct ).

    set_column_color( EXPORTING iv_fieldname = 'TABLES' iv_col = iv_col iv_int = iv_int
                      CHANGING  ct_lvc_t_col = es_legend-ct ).

    set_column_color( EXPORTING iv_fieldname = 'CREATED_DATE' iv_col = iv_col iv_int = iv_int
                      CHANGING  ct_lvc_t_col = es_legend-ct ).

    set_column_color( EXPORTING iv_fieldname = 'CREATED_TIME' iv_col = iv_col iv_int = iv_int
                      CHANGING  ct_lvc_t_col = es_legend-ct ).

    set_column_color( EXPORTING iv_fieldname = 'SYST' iv_col = iv_col iv_int = iv_int
                      CHANGING  ct_lvc_t_col = es_legend-ct ).

    set_column_color( EXPORTING iv_fieldname =  'MANDANT' iv_col = iv_col iv_int = iv_int
                      CHANGING  ct_lvc_t_col = es_legend-ct ).

    set_column_color( EXPORTING iv_fieldname =  'SAVED_LIST' iv_col = iv_col iv_int = iv_int
                      CHANGING  ct_lvc_t_col = es_legend-ct ).

  ENDMETHOD.


  METHOD link_create.

    DATA lr_link      TYPE REF TO if_aqqgraphic_link.
    DATA lv_linkstyle TYPE aqq_style.

    IF ir_link IS INITIAL.
      lr_link = gr_netplan->get_new_link( ).
      DATA(lv_add_self) = abap_true.
    ELSE.
      lr_link = ir_link.
    ENDIF.

    IF iv_linkstyle IS INITIAL.
      lv_linkstyle = '10004'.
    ELSE.
      lv_linkstyle = iv_linkstyle.
    ENDIF.

    lr_link->set_properties(
      EXPORTING
        i_text      = iv_text
        i_icon      = iv_icon
        i_linkstyle = lv_linkstyle
        i_tooltip   = iv_tooltip ).

    lr_link->set_attributes(
      EXPORTING
        i_moveable     = aqqis_c_true
        i_selectable   = aqqis_c_true
        i_editable     = aqqis_c_false
        i_elbowlink    = aqqis_c_false
        i_anglelink    = aqqis_c_true
        i_bunchlink    = aqqis_c_false
        i_desmergelink = aqqis_c_false
        i_simplelink   = aqqis_c_false ).

    lr_link->set_predecessor( EXPORTING i_r_table  = gs_source-netplan_tab
                                        i_rowindex = iv_predrow ).

    lr_link->set_successor( EXPORTING i_r_table  = gs_target-netplan_tab
                                      i_rowindex = iv_succrow ).

    APPEND VALUE #( source = iv_predrow
                    target = iv_succrow
                    type   = iv_type
                    link   = lr_link ) TO gt_link.

    IF iv_type = c_linktype_key.
      link_key_set( lr_link ).
    ENDIF.

    IF lv_add_self = abap_true.

      gr_netplan->add_link( EXPORTING i_r_link = lr_link ).

      gr_netplan->send_data_to_frontend( ).

    ENDIF.
  ENDMETHOD.


  METHOD link_delete.

    DELETE gt_link WHERE link = ir_link.

    gr_netplan->delete_objects( EXPORTING i_r_link = ir_link ).

  ENDMETHOD.


  METHOD link_key_remove.

    ASSIGN gt_link[ link = ir_link ] TO FIELD-SYMBOL(<ls_link>).
    IF sy-subrc = 0.
      <ls_link>-link->set_properties(  i_icon = '' i_linkstyle =  '10004' ).
      <ls_link>-type = c_linktype_field.

      me->gr_netplan->add_link( i_r_link = <ls_link>-link ).
    ENDIF.

  ENDMETHOD.


  METHOD link_key_set.

    ASSIGN gt_link[ link = ir_link ] TO FIELD-SYMBOL(<ls_link>).
    IF sy-subrc = 0.

      <ls_link>-link->set_properties(  i_icon = icon_foreign_key i_linkstyle =  '10004' ).
      <ls_link>-type = c_linktype_key.

      me->gr_netplan->add_link( i_r_link = <ls_link>-link ).
    ENDIF.

  ENDMETHOD.


  METHOD link_move_allowed.

    CLEAR r_allowed.


    me->get_field_meta( EXPORTING is_dfies     = CORRESPONDING #( gs_source-cdxdfies[ i_source ] )
                        IMPORTING es_meta_data = DATA(ls_meta_source) ).

    me->get_field_meta( EXPORTING is_dfies    = CORRESPONDING #( gs_source-cdxdfies[ i_target ] )
                        IMPORTING es_meta_data = DATA(ls_meta_target) ).

    IF ls_meta_source-datatype = ls_meta_target-datatype AND
       ls_meta_source-length   = ls_meta_target-length   AND
       ls_meta_source-decimals = ls_meta_target-decimals.
      r_allowed = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD navigate_difference.

    DATA ls_row_id           TYPE lvc_s_row.
    DATA ls_column_id        TYPE lvc_s_col.
    DATA lv_cursor_field_pos TYPE i.
    DATA lv_focus_field      TYPE lvc_s_fcat-fieldname.
    DATA lv_focus_row        TYPE lvc_s_row-index.

    gr_compare_results_grid->get_current_cell( IMPORTING es_row_id = ls_row_id
                                                         es_col_id = ls_column_id ).

    gr_compare_results_grid->get_frontend_fieldcatalog( IMPORTING et_fieldcatalog = DATA(lt_fcat) ).

    CASE iv_kind.
      WHEN c_navkind_next.

        lv_cursor_field_pos = get_cusror_field( EXPORTING iv_mark_target = abap_true it_fcat = lt_fcat is_column_id = ls_column_id iv_default_field_pos = 1 ).

        navigate_difference_next( EXPORTING it_fcat             = lt_fcat
                                            is_row_id           = ls_row_id
                                            iv_cursor_field_pos = lv_cursor_field_pos
                                  IMPORTING ev_focus_field      = lv_focus_field
                                            ev_focus_row        = lv_focus_row ).
      WHEN c_navkind_prev.

        lv_cursor_field_pos = get_cusror_field( EXPORTING iv_mark_target = abap_false it_fcat = lt_fcat is_column_id = ls_column_id iv_default_field_pos = 99999 ).

        navigate_difference_previous( EXPORTING it_fcat             = lt_fcat
                                                is_row_id           = ls_row_id
                                                iv_cursor_field_pos = lv_cursor_field_pos
                                      IMPORTING ev_focus_field      = lv_focus_field
                                                ev_focus_row        = lv_focus_row ).
    ENDCASE.

    set_different_cell( iv_focus_field = lv_focus_field
                        iv_focus_row   = lv_focus_row ).

  ENDMETHOD.


  METHOD navigate_difference_next.

    DATA lv_diff_field_pos   TYPE i.

    DATA(lv_cursor_field_pos) = iv_cursor_field_pos.

    SORT gt_detailed_difference BY idx.

    LOOP AT gt_detailed_difference ASSIGNING FIELD-SYMBOL(<ls_diff>) WHERE row >= is_row_id-index.
      CHECK <ls_diff>-row >= is_row_id-index.
      IF <ls_diff>-row > is_row_id-index.
        ev_focus_field = <ls_diff>-fieldname.
      ELSE.
        ASSIGN it_fcat[ fieldname = <ls_diff>-fieldname ] TO FIELD-SYMBOL(<ls_fcat>).
        IF sy-subrc = 0.
          lv_diff_field_pos = sy-tabix.
          IF lv_diff_field_pos > lv_cursor_field_pos.
            ev_focus_field = <ls_diff>-fieldname.
          ENDIF.
        ENDIF.
      ENDIF.
      IF ev_focus_field IS NOT INITIAL.
        ev_focus_row   = <ls_diff>-row.
        EXIT." LOOP
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD navigate_difference_previous.

    DATA lv_diff_field_pos   TYPE i.

    DATA(lv_first_match)      = abap_true.
    DATA(lv_cursor_field_pos) = iv_cursor_field_pos.

    SORT gt_detailed_difference BY idx DESCENDING.


    LOOP AT gt_detailed_difference ASSIGNING FIELD-SYMBOL(<ls_diff>) WHERE row <= is_row_id-index.
      CHECK <ls_diff>-row > 0 AND <ls_diff>-row <= is_row_id-index.
      IF <ls_diff>-row < is_row_id-index.
        IF lv_first_match = abap_true.
          lv_first_match = abap_false.
        ELSE.
          ev_focus_field = <ls_diff>-fieldname.
        ENDIF.
      ELSE.
        ASSIGN it_fcat[ fieldname = <ls_diff>-fieldname ] TO FIELD-SYMBOL(<ls_fcat>).
        IF sy-subrc = 0.
          lv_diff_field_pos = sy-tabix.
          IF lv_diff_field_pos < lv_cursor_field_pos.
            ev_focus_field = it_fcat[ lv_diff_field_pos - 1 ]-fieldname.
          ENDIF.
        ENDIF.
      ENDIF.
      IF ev_focus_field IS NOT INITIAL.
        ev_focus_row   = <ls_diff>-row.
        EXIT." LOOP
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD on_handle_ctxmnureq.

    DATA l_link TYPE typ_link.

    r_ctxmnu->add_function(
      EXPORTING
        fcode = c_action_delete_link
        text = TEXT-004 ).

    r_ctxmnu->add_separator( ).

    r_link->get_predecessor(
       IMPORTING
         e_rowindex = l_link-source
    ).

    r_link->get_successor(
       IMPORTING
         e_rowindex = l_link-target
    ).

    READ TABLE gt_link WITH KEY source = l_link-source target = l_link-target INTO l_link.
    IF sy-subrc = 0.
      IF l_link-type = c_linktype_field.
        r_ctxmnu->add_function(
          EXPORTING
            fcode             = c_action_set_key_link
            text              = TEXT-005
            disabled          = abap_false ).
        r_ctxmnu->add_function(
          EXPORTING
            fcode             = c_action_remove_key_link
            text              = TEXT-006
            disabled          = abap_true ).
      ELSE.
        r_ctxmnu->add_function(
          EXPORTING
            fcode             = c_action_set_key_link
            text              = TEXT-005
            disabled          = abap_true ).
        r_ctxmnu->add_function(
          EXPORTING
            fcode             = c_action_remove_key_link
            text              = TEXT-006
            disabled          = abap_false ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD on_handle_ctxmnusel.

    CASE fcode.
      WHEN c_action_set_key_link.
        me->link_key_set( r_link ).
        check_keys( ).
      WHEN c_action_remove_key_link.
        me->link_key_remove( r_link ).
        check_keys( ).
      WHEN c_action_delete_link.
        me->link_delete( r_link  ).
        check_keys( ).
        set_link_status_icons( ).
    ENDCASE.

    gr_netplan->send_data_to_frontend( ).

  ENDMETHOD.


  METHOD on_handle_double_click.

    READ TABLE gt_link WITH KEY link = r_link ASSIGNING FIELD-SYMBOL(<fs_link>).
    IF sy-subrc = 0.
      CASE <fs_link>-type.
        WHEN c_linktype_field.
          me->link_key_set( r_link ).
        WHEN c_linktype_key.
          me->link_key_remove( r_link ).
      ENDCASE.

      check_keys( ).

      gr_netplan->send_data_to_frontend( ).

    ENDIF.

  ENDMETHOD.


  METHOD on_handle_link_created.

    IF gs_source-netplan_tab = r_succtab.
      DATA(lv_idx_source) = succ_row.
      DATA(lv_idx_target) = pred_row.
    ELSE.
      lv_idx_source = pred_row.
      lv_idx_target = succ_row.
    ENDIF.
    TRY.
        DATA(lv_linktype) = me->is_field_mapping_allowed( EXPORTING iv_idx_source = lv_idx_source
                                                                    iv_idx_target = lv_idx_target ).

        me->link_create( EXPORTING ir_link    = r_newlink
                                   iv_predrow = lv_idx_source
                                   iv_succrow = lv_idx_target
                                   iv_type    = lv_linktype ).

        me->set_link_status_icons( ).

        r_doit->o_ok = aqqis_c_true.

      CATCH /cadaxo/cx_sqlc_dcomp_fieldmap INTO DATA(lx_mapping).
        r_doit->o_ok = aqqis_c_false.
        MESSAGE lx_mapping->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
    ENDTRY.

    me->check_keys( ).

    cl_gui_cfw=>set_new_ok_code( 'KEY_UNIQUE_CHANGED' ).

  ENDMETHOD.


  METHOD on_handle_link_pred_changed.

    r_doit->o_ok = aqqis_c_false.

    READ TABLE me->gt_link WITH KEY link = r_link ASSIGNING FIELD-SYMBOL(<fs_link>).
    IF sy-subrc = 0.
      TRY.

          is_field_mapping_allowed( EXPORTING iv_idx_source  = predrow
                                              iv_idx_target  = <fs_link>-source
                                              iv_move_source = abap_true ).

          <fs_link>-source = predrow.

          r_doit->o_ok = aqqis_c_true.

          me->check_keys( ).

        CATCH /cadaxo/cx_sqlc_dcomp_fieldmap INTO DATA(lx_mapping).
          r_doit->o_ok = aqqis_c_false.

          MESSAGE lx_mapping->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.

      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD on_handle_link_succ_changed.

    r_doit->o_ok = aqqis_c_false.

    READ TABLE me->gt_link WITH KEY link = r_link ASSIGNING FIELD-SYMBOL(<fs_link>).
    IF sy-subrc = 0.
      TRY.

          is_field_mapping_allowed( EXPORTING iv_idx_source  = <fs_link>-source
                                              iv_idx_target  = succrow
                                              iv_move_target = abap_true ).

          <fs_link>-target = succrow.

          r_doit->o_ok = aqqis_c_true.

          me->check_keys( ).

        CATCH /cadaxo/cx_sqlc_dcomp_fieldmap INTO DATA(lx_mapping).
          r_doit->o_ok = aqqis_c_false.

          MESSAGE lx_mapping->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.

      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD on_handle_result_toolbar.

    INSERT VALUE #( function  = c_action_show_green
                    icon      = icon_led_green
                    butn_type = cntb_btype_check
                    disabled  = abap_false
                    quickinfo = SWITCH #( gv_show_green WHEN abap_true THEN TEXT-q11
                                                        ELSE TEXT-q01 )
                    checked   = gv_show_green ) INTO e_object->mt_toolbar INDEX 1.

    INSERT VALUE #( function  = c_action_show_yellow
                    icon      = icon_led_yellow
                    butn_type = cntb_btype_check
                    disabled  = abap_false
                    quickinfo = SWITCH #( gv_show_yellow WHEN abap_true THEN TEXT-q12
                                                         ELSE TEXT-q03 )
                    checked   = gv_show_yellow ) INTO e_object->mt_toolbar INDEX 2.

    INSERT VALUE #( function  = c_action_show_red
                    icon      = icon_led_red
                    butn_type = cntb_btype_check
                    disabled  = abap_false
                    quickinfo = SWITCH #( gv_show_red WHEN abap_true THEN TEXT-q13
                                                      ELSE TEXT-q03 )
                    checked   = gv_show_red ) INTO e_object->mt_toolbar INDEX 3.

    INSERT VALUE #( function  = c_action_show_all_columns
                    icon      = icon_ranking
                    butn_type = cntb_btype_check
                    disabled  = abap_false
                    quickinfo = SWITCH #( gv_show_all_columns WHEN abap_true THEN TEXT-q14
                                                              ELSE TEXT-q04 )
                    checked   = gv_show_all_columns ) INTO e_object->mt_toolbar INDEX 4.

    INSERT VALUE #( butn_type = cntb_btype_sep ) INTO e_object->mt_toolbar INDEX 5.

    INSERT VALUE #( function  = c_action_diff_previous
                    icon      = icon_previous_object
                    butn_type = cntb_btype_button
                    disabled  = abap_false
                    quickinfo = TEXT-q07 ) INTO e_object->mt_toolbar INDEX 6.

    INSERT VALUE #( function  = c_action_diff_next
                    icon      = icon_next_object
                    butn_type = cntb_btype_button
                    disabled  = abap_false
                    quickinfo = TEXT-q06 ) INTO e_object->mt_toolbar INDEX 7.

    INSERT VALUE #( butn_type = cntb_btype_sep ) INTO e_object->mt_toolbar INDEX 8.

*begin of insert 405
    INSERT VALUE #( function  = 'TOGGLE_ROW_COLS'
                    icon      = icon_invert_line
                    butn_type = cntb_btype_button
                    disabled  = abap_false
                    quickinfo = TEXT-008 ) INTO e_object->mt_toolbar INDEX 9.
    INSERT VALUE #( butn_type = cntb_btype_sep ) INTO e_object->mt_toolbar INDEX 10.
*end   of insert 405
  ENDMETHOD.


  METHOD on_handle_result_user_command.

    CASE e_ucomm.
      WHEN c_action_show_all_columns.
        me->toggle_show_all_columns( ).
      WHEN c_action_show_green.
        me->toggle_button( CHANGING ic_button_flag = me->gv_show_green ).
        me->update_filter( abap_true ).
      WHEN c_action_show_yellow.
        me->toggle_button( CHANGING ic_button_flag = me->gv_show_yellow ).
        me->update_filter( abap_true ).
      WHEN c_action_show_red.
        me->toggle_button( CHANGING ic_button_flag = me->gv_show_red ).
        me->update_filter( abap_true ).
      WHEN c_action_diff_next.
        TRY.
            me->navigate_difference( iv_kind = c_navkind_next ).
          CATCH /cadaxo/cx_sqlc_dcomp_complex INTO DATA(lx_complex).
            MESSAGE lx_complex->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
        ENDTRY.
      WHEN c_action_diff_previous.
        TRY.
            me->navigate_difference( iv_kind = c_navkind_prev ).
          CATCH /cadaxo/cx_sqlc_dcomp_complex INTO lx_complex.
            MESSAGE lx_complex->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
        ENDTRY.
*      begin of insert cockpit-405
      WHEN 'TOGGLE_ROW_COLS'.
        IF me->gv_row_based = abap_true.
          me->gv_row_based = abap_false.
          me->switch_to_vr( ).
        ELSE.
          me->gv_row_based = abap_true.
          me->switch_to_hr( ).
        ENDIF.
*      end   of insert cockpit-405
    ENDCASE.

  ENDMETHOD.


  METHOD pai_0100.

    CASE i_ok_code.
      WHEN c_action_map_delete.

        me->fieldmapping_delete( ).

      WHEN c_action_map_rows.

        me->fieldmapping_set( iv_kind = c_mapkind_index ).

      WHEN c_action_map_fields.

        me->fieldmapping_set( iv_kind = c_mapkind_fieldname ).

    ENDCASE.

  ENDMETHOD.


  METHOD pbo_0100.

  ENDMETHOD.


  METHOD pbo_0200.

    DATA lt_event      TYPE cntl_simple_events.
    DATA ls_ctxmnu_use TYPE aqqis_s_ctxmnu_use.
    DATA lv_note       TYPE string.

    IF gr_container_info_0200 IS INITIAL.

      gr_container_info_0200 = NEW cl_gui_custom_container( container_name = 'CC_INFO_0200' ).

      gr_text_info_0200 = NEW cl_gui_textedit( parent = gr_container_info_0200 ).

      gr_text_info_0200->set_enable( enable = abap_false ).

      gr_text_info_0200->set_statusbar_mode( statusbar_mode = 0 ).

      gr_text_info_0200->set_toolbar_mode( toolbar_mode = 0 ).

      lv_note = TEXT-i03 && cl_abap_char_utilities=>cr_lf && cl_abap_char_utilities=>cr_lf &&
                TEXT-i01 && cl_abap_char_utilities=>cr_lf && cl_abap_char_utilities=>cr_lf &&
                TEXT-i02.

      gr_text_info_0200->set_textstream( EXPORTING text = lv_note ).


    ENDIF.

    IF gr_container_mapping IS INITIAL.

      APPEND VALUE cntl_simple_event( eventid = aqqis_c_event-contextmenureq ) TO lt_event.
      APPEND VALUE cntl_simple_event( eventid = aqqis_c_event-newlink ) TO lt_event.
      APPEND VALUE cntl_simple_event( eventid = aqqis_c_event-linkleftbuttondblclk ) TO lt_event.
      APPEND VALUE cntl_simple_event( eventid = aqqis_c_event-prechangesrcobject ) TO lt_event.
      APPEND VALUE cntl_simple_event( eventid = aqqis_c_event-prechangedstobject ) TO lt_event.

      ls_ctxmnu_use-link = aqqis_c_true.

      CREATE OBJECT gr_container_mapping
        EXPORTING
          container_name = 'CC_MAPPING'.

      cl_gui_aqqgraphic_netplan=>get_netplan_object( EXPORTING i_r_parent     = gr_container_mapping
                                                               i_t_events     = lt_event
                                                               i_s_ctxmnu_use = ls_ctxmnu_use
                                                     IMPORTING e_r_netplan    = gr_netplan ).

      SET HANDLER on_handle_ctxmnureq FOR gr_netplan.
      SET HANDLER on_handle_ctxmnusel FOR gr_netplan.
      SET HANDLER on_handle_link_created FOR gr_netplan.
      SET HANDLER on_handle_double_click FOR gr_netplan.
      SET HANDLER on_handle_link_pred_changed FOR gr_netplan.
      SET HANDLER on_handle_link_succ_changed FOR gr_netplan.

      gr_netplan->set_activemode( EXPORTING  i_mode = aqqis_c_cntrlmode-createlinkbydd ).
      gr_netplan->set_displayonly( EXPORTING  i_on = aqqis_c_false ).
      gr_netplan->set_zoom( i_zoom = 100 ).
      gr_netplan->set_backgroundcolor( i_color = 12632256 ).

      set_netplan_table( CHANGING is_table_details = gs_source ).

      set_netplan_table( CHANGING is_table_details = gs_target ).

      gr_netplan->send_data_to_frontend( ).

      set_initial_status_icons( ).

    ENDIF.

  ENDMETHOD.


  METHOD pbo_0300.

    DATA lt_legend TYPE TABLE OF /cadaxo/sqlcdatacomplegend_alv.
    DATA ls_layout TYPE lvc_s_layo.
    DATA l_note    TYPE string.
    DATA lt_fcat TYPE lvc_t_fcat.
*
*    data cc_pie_chart type ref to CL_GUI_CUSTOM_CONTAINER.
*    data gp_inst type ref to cl_gui_gp_pres.



    FIELD-SYMBOLS <lt_compare_result> TYPE STANDARD TABLE.

    IF gr_container_info_0300 IS INITIAL.

      gr_container_info_0300 = NEW cl_gui_custom_container( container_name = 'CC_INFO_0300' ).

      gr_text_info_0300 = NEW cl_gui_textedit( parent = gr_container_info_0300 ).

      gr_text_info_0300->set_enable( enable = abap_false ).

      gr_text_info_0300->set_statusbar_mode( statusbar_mode = 0 ).

      gr_text_info_0300->set_toolbar_mode( toolbar_mode = 0 ).

      gr_text_info_0300->set_textstream( text = l_note ).

*
*
*      cc_pie_chart = new #( container_name = 'CC_PIE' ).
*      gp_inst = new #( ).
*
*      gp_inst->if_graphic_proxy~init(
*                       exporting parent       = cc_pie_chart
*                                 dc           = GDC_INST
*                                 prod_id      = cl_gui_gp_pres=>co_prod_chart
*                                 force_prod   = gfw_true
*                       importing retval       = retval )

    ENDIF.

    IF gr_container_results IS INITIAL.

      CLEAR ls_layout.
      ls_layout-excp_fname = c_fieldname_lights.
      ls_layout-excp_led   = abap_true.
      ls_layout-ctab_fname = 'CT'.
      ls_layout-cwidth_opt = abap_false.

      ASSIGN grt_compare_result->* TO <lt_compare_result>.

      gr_container_results = NEW cl_gui_custom_container( container_name = 'CC_RESULTS' ).

      gr_compare_results_grid = NEW cl_gui_alv_grid( i_parent = gr_container_results ).

      gr_compare_results_grid->set_table_for_first_display( EXPORTING is_layout            = ls_layout
                                                                      it_toolbar_excluding = gt_excluding_alv
                                                            CHANGING  it_outtab            = <lt_compare_result>
                                                                      it_fieldcatalog      = gt_result_fcat ).

      SET HANDLER: on_handle_result_toolbar       FOR gr_compare_results_grid,
                   on_handle_result_user_command  FOR gr_compare_results_grid.

      update_filter( i_refresh_alv = abap_true ).

    ENDIF.

    IF gr_container_legend IS INITIAL.

      CLEAR ls_layout.
      ls_layout-no_toolbar = abap_true.
      ls_layout-ctab_fname = 'CT'.
      ls_layout-no_rowmark = abap_true.
      ls_layout-sel_mode   = 'A'." 'D'.
      ls_layout-cwidth_opt = abap_true.

      APPEND legent_build_line( is_table_details = gs_source iv_col = 7 iv_int = 0 ) TO lt_legend.
      APPEND legent_build_line( is_table_details = gs_target iv_col = 7 iv_int = 1 ) TO lt_legend.

      gr_container_legend = NEW cl_gui_custom_container( container_name = 'CC_LEGEND' ).

      gr_legend_grid = NEW cl_gui_alv_grid( i_parent = gr_container_legend ).

      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name   = '/CADAXO/SQLCDATACOMPLEGEND_ALV'
          i_bypassing_buffer = 'X'
        CHANGING
          ct_fieldcat        = lt_fcat.

      LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<fs_fcat>).
        CASE <fs_fcat>-fieldname.
          WHEN 'SAVED_LIST'.
            <fs_fcat>-checkbox = abap_true.
        ENDCASE.
      ENDLOOP.

      gr_legend_grid->set_table_for_first_display( EXPORTING is_layout        = ls_layout
                                                             i_structure_name = '/CADAXO/SQLCDATACOMPLEGEND_ALV'
                                                   CHANGING  it_outtab        = lt_legend
                                                             it_fieldcatalog  = lt_fcat ).

    ENDIF.


  ENDMETHOD.


  METHOD prepare_dfies.

    DATA ls_sdfies TYPE /cadaxo/sqlcdfies.
    DATA ls_dfies TYPE dfies.
    DATA lt_dfies TYPE STANDARD TABLE OF dfies.
    DATA lr_structdescr TYPE REF TO cl_abap_structdescr.
    DATA lr_element TYPE REF TO cl_abap_elemdescr.

    LOOP AT it_dfies ASSIGNING FIELD-SYMBOL(<ls_sdfies>).

      CLEAR lt_dfies.

      IF <ls_sdfies>-stru_name IS NOT INITIAL.

        lr_structdescr ?= cl_abap_structdescr=>describe_by_name( <ls_sdfies>-stru_name ).

        DATA(lt_included_view) = lr_structdescr->get_included_view( ).

        CALL FUNCTION 'DDIF_FIELDINFO_GET'
          EXPORTING
            tabname        = CONV ddobjname( <ls_sdfies>-stru_name )
          TABLES
            dfies_tab      = lt_dfies
          EXCEPTIONS
            not_found      = 1
            internal_error = 2
            OTHERS         = 3.

        LOOP AT lt_included_view ASSIGNING FIELD-SYMBOL(<ls_component>).


          TRY.
              ls_dfies = lt_dfies[ fieldname = <ls_component>-name ].
            CATCH cx_sy_itab_line_not_found.
              lr_element ?= <ls_component>-type.
              ls_dfies = lr_element->get_ddic_field( ).
          ENDTRY.
          ls_sdfies = CORRESPONDING #( ls_dfies ).

          ls_sdfies-fieldname = <ls_component>-name.
          ls_sdfies-tabname = <ls_sdfies>-stru_name.
          ls_sdfies-/cadaxo/alias = <ls_sdfies>-fieldname.
          ls_sdfies-map_fieldname = <ls_sdfies>-fieldname && '-' && ls_sdfies-fieldname.

          APPEND ls_sdfies TO rt_dfies.

        ENDLOOP.

      ELSE.

        ls_sdfies = <ls_sdfies>.
        ls_sdfies-map_fieldname = ls_sdfies-fieldname.
        APPEND ls_sdfies TO rt_dfies.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD set_column_color.

    APPEND VALUE #( fname     = iv_fieldname
                    color-col = iv_col
                    color-int = iv_int ) TO ct_lvc_t_col.
  ENDMETHOD.


  METHOD set_different_cell.

    DATA ls_row_id TYPE lvc_s_row.
    DATA ls_column_id TYPE lvc_s_col.

    IF iv_focus_field IS NOT INITIAL.

      CLEAR: ls_row_id,
             ls_column_id.

      ls_row_id-index        = iv_focus_row.
      ls_column_id-fieldname = iv_focus_field.

      gr_compare_results_grid->set_selected_rows( EXPORTING it_index_rows = VALUE #( ( ls_row_id ) ) ).
      gr_compare_results_grid->set_current_cell_via_id( EXPORTING is_row_id    = ls_row_id
                                                                  is_column_id = ls_column_id ).

    ELSE.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_dcomp_complex
        EXPORTING
          textid = /cadaxo/cx_sqlc_dcomp_complex=>no_further_differnce.

    ENDIF.

  ENDMETHOD.


  METHOD set_initial_status_icons.

    gd_stat_uniqu_keymapping  =
    gd_stat_uniqu_keymapping1 =
    gd_stat_uniqu_keymapping2 =
    gd_stat_onemapping        = gv_icon_red.

  ENDMETHOD.


  METHOD set_link_status_icons.

    IF lines( gt_link ) > 0.
      gd_stat_onemapping = gv_icon_green.
    ELSE.
      gd_stat_onemapping = gv_icon_red.
    ENDIF.

  ENDMETHOD.


  METHOD set_netplan_tab.

    ir_tab->set_table_properties( EXPORTING  i_title          = i_title
                                             i_tooltip        = ''
                                             i_level          = 16
                                             i_tablheadicon   = icon_view_list
                                             i_linecolor      = aqqis_c_defval-linecolor
                                             i_scrollbarcolor = aqqis_c_defval-scrollbarcolor
                                             i_s_position     = is_pos ).
    ir_tab->set_table_attributes(
      EXPORTING
        i_moveable            = aqqis_c_false
        i_resizeable          = aqqis_c_false
        i_autoarranging       = aqqis_c_false
        i_tableconnectable    = aqqis_c_false
        i_allrowsconnectable  = aqqis_c_true
        i_dragdroprows        = aqqis_c_false
        i_selectablerows      = aqqis_c_true
        i_multiselectablerows = aqqis_c_false
        i_tooltip             = aqqis_c_false
        i_vscrollbar          = aqqis_c_true
        i_autocolwidth        = aqqis_c_false
        i_autocolwidth_wh     = aqqis_c_false
        i_hscrollbar          = aqqis_c_true ).

    ir_tab->set_column_properties( i_column_nr = 1
                                   i_colwidth  = 400 ).

    ir_tab->set_column_properties( i_column_nr = 2
                                   i_title     = TEXT-001
                                   i_colwidth  = 4000 ).

    ir_tab->set_column_properties( i_column_nr = 3
                                   i_title     = TEXT-002
                                   i_colwidth  = 5700 ).

    ir_tab->set_column_properties( i_column_nr = 4
                                   i_title     = TEXT-003
                                   i_colwidth  = 0 ).

  ENDMETHOD.


  METHOD set_netplan_table.


    DATA lr_data_tab       TYPE REF TO data.
    DATA l_pos             TYPE aqq_s_pos.
    DATA l_title           TYPE aqq_title.

    FIELD-SYMBOLS <lt_tab> TYPE typ_map_tab.


    is_table_details-netplan_tab = gr_netplan->get_new_table( ).

    lr_data_tab = NEW typ_map_tab( ).

    ASSIGN lr_data_tab->* TO <lt_tab>.

    <lt_tab> = build_mapping_table( it_dfies       = is_table_details-cdxdfies
                                    iv_select_type = is_table_details-select_type ).

    is_table_details-netplan_tab->set_tabledata( i_t_table = <lt_tab> ).

    l_pos-leftpos   = is_table_details-pos_left.
    l_pos-toppos    = 50.
    l_pos-rightpos  = is_table_details-pos_right.
    l_pos-bottompos = 640.

    l_title = '#' && is_table_details-number && ` ` && is_table_details-name.

    me->set_netplan_tab( EXPORTING is_pos = l_pos
                                   i_title = l_title
                                   ir_tab = is_table_details-netplan_tab ).

    LOOP AT <lt_tab> ASSIGNING FIELD-SYMBOL(<ls_tab>) WHERE icon IS NOT INITIAL.
      is_table_details-netplan_tab->set_cell_properties( EXPORTING i_rowindex    = CONV #( sy-tabix )
                                                                   i_colindex    = 1
                                                                   i_icon        = <ls_tab>-icon ).
    ENDLOOP.

    gr_netplan->add_table( EXPORTING i_r_table = is_table_details-netplan_tab ).

  ENDMETHOD.


  METHOD show_progress_indicator.

    DATA l_percentage TYPE p.

    cs_progress_inidcator-current_line = cs_progress_inidcator-current_line + 1.
    l_percentage = 100 / cs_progress_inidcator-lines_compare * cs_progress_inidcator-current_line.
    IF l_percentage <> cs_progress_inidcator-percentage_previous.
      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          percentage = l_percentage
          text       = |{ TEXT-pi1 } { shift_left( val = cs_progress_inidcator-current_line sub = '0' ) } { TEXT-pi2 } { shift_left( val = cs_progress_inidcator-lines_compare sub = '0' ) }|.
      cs_progress_inidcator-percentage_previous = l_percentage.
    ENDIF.

  ENDMETHOD.


  METHOD sort_original_data.

    FIELD-SYMBOLS: <lt_source> TYPE STANDARD TABLE.
    FIELD-SYMBOLS: <lt_target> TYPE STANDARD TABLE.

    ASSIGN gs_source-data->* TO <lt_source>.
    ASSIGN gs_target-data->* TO <lt_target>.

    me->build_sort_table( CHANGING cs_table_details = gs_source ).

    me->build_sort_table( CHANGING cs_table_details = gs_target ).

    SORT <lt_source> BY (gs_source-sort_tab).
    SORT <lt_target> BY (gs_target-sort_tab).

  ENDMETHOD.


  METHOD switch_to_hr.

    DATA ls_layout TYPE lvc_s_layo.
    FIELD-SYMBOLS <lt_compare_result> TYPE STANDARD TABLE.

    me->do_check_hr( ).

    gr_compare_results_grid->set_frontend_fieldcatalog( gt_result_fcat ).

    CLEAR ls_layout.
    ls_layout-excp_fname = c_fieldname_lights.
    ls_layout-excp_led   = abap_true.
    ls_layout-ctab_fname = 'CT'.
    ls_layout-cwidth_opt = abap_false.
    ls_layout-zebra =  abap_true.

    ASSIGN grt_compare_result->* TO <lt_compare_result>.

    gr_compare_results_grid->set_table_for_first_display( EXPORTING is_layout            = ls_layout
                                                                    it_toolbar_excluding = gt_excluding_alv
                                                          CHANGING  it_outtab            = <lt_compare_result>
                                                                    it_fieldcatalog      = gt_result_fcat ).

    SET HANDLER: on_handle_result_toolbar       FOR gr_compare_results_grid,
                 on_handle_result_user_command  FOR gr_compare_results_grid.

    update_filter( i_refresh_alv = abap_true ).

  ENDMETHOD.


  METHOD switch_to_vr.
    me->do_check( ).
    CALL METHOD gr_compare_results_grid->set_frontend_fieldcatalog( gt_result_fcat ).

    DATA ls_layout TYPE lvc_s_layo.
    FIELD-SYMBOLS <lt_compare_result> TYPE STANDARD TABLE.

    CLEAR ls_layout.
    ls_layout-excp_fname = c_fieldname_lights.
    ls_layout-excp_led   = abap_true.
    ls_layout-ctab_fname = 'CT'.
    ls_layout-cwidth_opt = abap_false.
    ASSIGN grt_compare_result->* TO <lt_compare_result>.


    gr_compare_results_grid->set_table_for_first_display( EXPORTING is_layout            = ls_layout
                                                                    it_toolbar_excluding = gt_excluding_alv
                                                          CHANGING  it_outtab            = <lt_compare_result>
                                                                    it_fieldcatalog      = gt_result_fcat ).

    SET HANDLER: on_handle_result_toolbar       FOR gr_compare_results_grid,
                 on_handle_result_user_command  FOR gr_compare_results_grid.

    update_filter( i_refresh_alv = abap_true ).


  ENDMETHOD.


  METHOD toggle_button.

    IF ic_button_flag = abap_false.
      ic_button_flag = abap_true.
    ELSE.
      ic_button_flag = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD toggle_show_all_columns.

    DATA lt_fcat TYPE lvc_t_fcat.

    DATA(lv_nodiff_hide) = me->gv_show_all_columns.

    IF me->gv_show_all_columns = abap_false.
      me->gv_show_all_columns = abap_true.
    ELSE.
      me->gv_show_all_columns = abap_false.
    ENDIF.

    lt_fcat = gt_result_fcat.

    LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE key = space.

      IF NOT line_exists( gt_detailed_difference[ fieldname = <ls_fcat>-fieldname ] ).
        <ls_fcat>-no_out = lv_nodiff_hide.
      ENDIF.

    ENDLOOP.

    gr_compare_results_grid->set_frontend_fieldcatalog( EXPORTING it_fieldcatalog = lt_fcat ).

    gr_compare_results_grid->refresh_table_display( i_soft_refresh = abap_true ).

    FREE lt_fcat.

  ENDMETHOD.


  METHOD update_filter.

    DATA lt_filter TYPE lvc_t_filt.

    gr_compare_results_grid->get_filter_criteria( IMPORTING et_filter = lt_filter ).

    DELETE lt_filter WHERE fieldname = c_fieldname_lights.

    DATA(ls_light_filter) = VALUE lvc_s_filt( fieldname = c_fieldname_lights
                                              low       = ''
                                              sign      = 'I'
                                              option    = 'EQ'
                                              order     = '01'
                                              ref_field = c_fieldname_lights
                                              no_sign   = 'X'
                                              exception = 'X'
                                              inttype   = 'C' ).

    IF me->gv_show_red = abap_true.
      ls_light_filter-low = '1'.
      APPEND ls_light_filter TO lt_filter.
    ENDIF.

    IF me->gv_show_yellow = abap_true.
      ls_light_filter-low = '2'.
      APPEND ls_light_filter TO lt_filter.
    ENDIF.

    IF me->gv_show_green = abap_true.
      ls_light_filter-low = '3'.
      APPEND ls_light_filter TO lt_filter.
    ENDIF.

* filter for the header line!
    ls_light_filter-low = ''.
    APPEND ls_light_filter TO lt_filter.

* set filter criteria
    gr_compare_results_grid->set_filter_criteria( EXPORTING it_filter = lt_filter ).

* refresh table display
    IF i_refresh_alv = abap_true.
      gr_compare_results_grid->refresh_table_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD update_status.

    ASSIGN COMPONENT iv_row_status OF STRUCTURE gs_rows_comp_state TO FIELD-SYMBOL(<ls_count>).
    IF sy-subrc = 0.
      <ls_count> = <ls_count> + 1.
      ec_light_field = iv_row_status.
    ENDIF.

  ENDMETHOD.


  METHOD update_status_hr.

    ASSIGN COMPONENT iv_row_status OF STRUCTURE gs_rows_comp_state TO FIELD-SYMBOL(<ls_count>).
    IF sy-subrc = 0.
      <ls_count> = <ls_count> + 1.
      ec_light_field_s = iv_row_status.
      ec_light_field_t = iv_row_status.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
