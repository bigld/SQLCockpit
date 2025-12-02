CLASS /cadaxo/cl_sqlc_cockpit_parse DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC

  GLOBAL FRIENDS /cadaxo/cl_sqlc_background
                 /cadaxo/cl_sqlc_cockpit_main
                 /cadaxo/cl_sqlc_sql_syntax
                 /cadaxo/cl_sqlc_temp_rrg
                 /cadaxo/cl_sqlc_cockpit_lists
                 /cadaxo/cl_sqlc_odata_gen.

  PUBLIC SECTION.

    INTERFACES if_serializable_object .

    TYPES:
      BEGIN OF gts_client_handling,
        client_specified TYPE flag,
        using_client     TYPE flag,
      END OF gts_client_handling .
    TYPES:
      BEGIN OF gts_symbol_variable,
        var_name    TYPE char50,
        data_type   TYPE /cadaxo/sqlcsymbol_datatype,
        range_table TYPE rseloption,
      END OF gts_symbol_variable .
    TYPES:
      gtt_symbol_variable TYPE TABLE OF gts_symbol_variable .
    TYPES:
      "COCKPIT-458 BEGIN
      BEGIN OF gts_domval,
        name         TYPE string,
        name_desc    TYPE string,
        fixed_values TYPE ddfixvalues,
      END OF gts_domval .
    TYPES:
      gtt_domval TYPE TABLE OF gts_domval .

    CONSTANTS c_select_version_0 TYPE /cadaxo/sqlc_select_version VALUE 0 ##NO_TEXT.
    CONSTANTS c_select_version_1 TYPE /cadaxo/sqlc_select_version VALUE 1 ##NO_TEXT.
    CONSTANTS c_select_version_2 TYPE /cadaxo/sqlc_select_version VALUE 2 ##NO_TEXT.
    CLASS-DATA g_main_ref TYPE REF TO /cadaxo/cl_sqlc_cockpit_main .
    DATA cds_parameter_syntax TYPE /cadaxo/sqlcselectcdsparsyntax .
    DATA column_syntax TYPE /cadaxo/sqlcselectcolumnsyntax .
    DATA column_words_t TYPE /cadaxo/sqlccodeline_t .
    DATA comp TYPE /cadaxo/sqlc_compdesc_t .
    DATA components TYPE /iwbep/t_abap_compdescr .
    DATA connection_syntax TYPE /cadaxo/sqlcselectdbhintsyntax .
    DATA dbhint_syntax TYPE /cadaxo/sqlcselectdbhintsyntax .
    DATA fields_syntax TYPE /cadaxo/sqlcselectfieldssyntax .
    DATA group_syntax TYPE /cadaxo/sqlcselectgroupsyntax .
    DATA gs_client_handling TYPE gts_client_handling .
    DATA gt_components TYPE abap_component_view_tab .
    DATA gt_components_domval TYPE /cadaxo/sqlcparsecomponent_t .
    DATA gt_domval TYPE /cadaxo/sqlc_domval_t .
    DATA gt_lvc_t_fcat TYPE lvc_t_fcat .
    DATA gt_result_ddfields TYPE /cadaxo/sqlcdfies_t .
    DATA gt_result_ddfields_all TYPE /cadaxo/sqlcdfies_t .
    DATA gt_sql_where_col_tab_t TYPE /cadaxo/sqlcwherecol_str_t .
    DATA gt_sub_components TYPE abap_component_tab .
    DATA g_bypassing_buffer TYPE abap_bool.
    DATA g_hold_result TYPE c LENGTH 1 .
    DATA g_no_upto TYPE flag .
    DATA g_saved_list TYPE abap_bool .
    DATA g_select_distinct TYPE c LENGTH 1 .
    DATA g_select_single TYPE c LENGTH 1 .
    DATA g_select_version TYPE /cadaxo/sqlc_select_version READ-ONLY .
    DATA g_up_to_x_rows TYPE int4 .
    DATA having_syntax TYPE /cadaxo/sqlcselecthavingsyntax .
    DATA offset_syntax TYPE /cadaxo/sqlcselectoffsetsyntax .
    DATA result_component_t TYPE /cadaxo/sqlcparsecomponent_t .
    DATA result_lines TYPE int4 .
    DATA result_runtime TYPE /cadaxo/sqlcruntime .
    DATA result_source_t TYPE /cadaxo/sqlcselectsource_t .
    DATA result_structure TYPE REF TO data .
    DATA result_table TYPE REF TO data .
    DATA source_syntax TYPE /cadaxo/sqlcselectsourcesyntax .
    DATA sql_syntax TYPE string .
    DATA sql_syntax_without_where TYPE string .
    DATA subquery TYPE c LENGTH 1 .
    DATA where_syntax TYPE /cadaxo/sqlcselectwheresyntax .
    DATA where_syntax_wildcard TYPE /cadaxo/sqlcselectwheresyntax .

    METHODS add_domain_value
      RAISING
        /cadaxo/cx_sqlc_syntax_error .
    METHODS add_domain_value_elm
      EXPORTING
        !e_elm             TYPE abap_simple_componentdescr
        !e_parent_str_name TYPE string
      CHANGING
        !c_domain_values   TYPE gtt_domval
        !c_domain_value    TYPE gts_domval
      RAISING
        /cadaxo/cx_sqlc_syntax_error .
    METHODS add_domain_value_sub
      EXPORTING
        !e_comp           TYPE abap_simple_componentdescr
      CHANGING
        !c_components_new TYPE abap_component_tab
        !c_domain_values  TYPE gtt_domval
        !c_domain_value   TYPE gts_domval
      RAISING
        /cadaxo/cx_sqlc_syntax_error .
    METHODS check_sql_odata_syntax
      RAISING
        /cadaxo/cx_sqlc_syntax_error
        /cadaxo/cx_sqlc_odata_gen .
    METHODS constructor
      IMPORTING
        !i_main_ref_id TYPE i OPTIONAL .
    METHODS create_alv_field_catalog
      IMPORTING
        !i_user_settings    TYPE /cadaxo/sqlcusrp_dyn OPTIONAL
        !i_dragdrop_handle  TYPE int4 OPTIONAL
      RETURNING
        VALUE(r_lvc_t_fcat) TYPE lvc_t_fcat .
    METHODS create_alv_field_catalog_v_1
      IMPORTING
        !i_user_settings    TYPE /cadaxo/sqlcusrp_dyn OPTIONAL
        !i_dragdrop_handle  TYPE int4 OPTIONAL
      RETURNING
        VALUE(r_lvc_t_fcat) TYPE lvc_t_fcat .
    METHODS create_alv_field_catalog_v_2
      IMPORTING
        !i_user_settings    TYPE /cadaxo/sqlcusrp_dyn OPTIONAL
        !i_dragdrop_handle  TYPE int4 OPTIONAL
      RETURNING
        VALUE(r_lvc_t_fcat) TYPE lvc_t_fcat .
    METHODS create_result_structures
      IMPORTING
        !i_mode TYPE char1 DEFAULT 'D' .
    METHODS execute_select
      IMPORTING
        !i_user_settings      TYPE /cadaxo/sqlcusrp_xml OPTIONAL
        !i_progress_indicator TYPE char1 OPTIONAL
      EXPORTING
        !e_result_details     TYPE /cadaxo/sqlcresult_details
      RAISING
        cx_sy_open_sql_db
        /cadaxo/cx_sqlc_syntax_error
        cx_sy_dynamic_osql_semantics
        cx_sy_conversion_overflow .
    METHODS execute_select_v_1
      IMPORTING
        !i_user_settings      TYPE /cadaxo/sqlcusrp_xml OPTIONAL
        !i_progress_indicator TYPE char1 OPTIONAL
      EXPORTING
        !e_result_details     TYPE /cadaxo/sqlcresult_details
      RAISING
        cx_sy_open_sql_db
        /cadaxo/cx_sqlc_syntax_error
        cx_sy_dynamic_osql_semantics
        cx_sy_conversion_overflow .
    METHODS execute_select_v_2
      IMPORTING
        !i_user_settings      TYPE /cadaxo/sqlcusrp_xml OPTIONAL
        !i_progress_indicator TYPE char1 OPTIONAL
      EXPORTING
        !e_result_details     TYPE /cadaxo/sqlcresult_details
      RAISING
        cx_sy_open_sql_db
        /cadaxo/cx_sqlc_syntax_error
        cx_sy_dynamic_osql_semantics
        cx_sy_conversion_overflow .
    CLASS-METHODS parse_sql_i
      IMPORTING
        !i_sql               TYPE /cadaxo/sqlcsql_string
        !i_user_settings     TYPE /cadaxo/sqlcusrp_xml OPTIONAL
        !i_role              TYPE /cadaxo/sqlcrole_auth_xml OPTIONAL
        VALUE(i_main_ref_id) TYPE i OPTIONAL
        VALUE(i_main_ref)    TYPE REF TO /cadaxo/cl_sqlc_cockpit_main OPTIONAL
      RETURNING
        VALUE(e_sql_parsed)  TYPE /cadaxo/sqlc_cl_cockpit_parset
      RAISING
        /cadaxo/cx_sqlc_no_sel_at_firs
        /cadaxo/cx_sqlc_syntax_error
        /cadaxo/cx_sqlc_no_source
        /cadaxo/cx_sqlc_to_much_resrow .
    METHODS parse_sql_ii
      EXCEPTIONS
        no_select_at_first_position .
    METHODS parse_sql_ii_1
      RAISING
        /cadaxo/cx_sqlc_type_not_found .
    METHODS parse_sql_ii_2
      EXCEPTIONS
        no_select_at_first_position
        /cadaxo/cx_sqlc_type_not_found .
    METHODS parse_sql_where_columns
      EXPORTING
        !e_where_column_tab TYPE /cadaxo/sqlcwherecol_str_t
      RAISING
        /cadaxo/cx_sqlc_symb_not_found
        /cadaxo/cx_sqlc_syntax_error
        /cadaxo/cx_sqlc_invalid_value .
    METHODS serialize
      EXPORTING
        !e_xml TYPE string .
    METHODS set_bachground_mode
      IMPORTING
        !i_background_mode TYPE flag DEFAULT abap_true .
    METHODS subpool_result
      IMPORTING
        !p_task TYPE clike
      RAISING
        /cadaxo/cx_sqlc_syntax_error .
    METHODS update_alv_field_catalog_sl
      IMPORTING
        !i_user_settings    TYPE /cadaxo/sqlcusrp_dyn OPTIONAL
        !i_dragdrop_handle  TYPE int4 OPTIONAL
      CHANGING
        VALUE(c_lvc_t_fcat) TYPE lvc_t_fcat .
  PROTECTED SECTION.

    TYPES:
      BEGIN OF gts_subpool_result,
        task TYPE char32.
        INCLUDE TYPE /cadaxo/sqlcresult_details.
    TYPES: END OF gts_subpool_result .
    TYPES:
      gtt_subpool_result TYPE TABLE OF gts_subpool_result .

    DATA order_syntax TYPE /cadaxo/sqlcselectordersyntax .
    CONSTANTS c_apostrophe TYPE c LENGTH 1 VALUE '''' ##NO_TEXT.
    CLASS-DATA gt_abap_typedescr TYPE /cadaxo/sqlctabtypedescr_t .
    CLASS-DATA g_role TYPE /cadaxo/sqlcrole_auth_xml .
    CLASS-DATA g_user_settings TYPE /cadaxo/sqlcusrp_xml .
    DATA gt_subpool_result TYPE gtt_subpool_result .
    DATA gt_symbol_variable TYPE gtt_symbol_variable .
    DATA g_async_calls TYPE int4 .
    DATA g_count_subroutinenpool TYPE int4 .
    DATA g_error_message TYPE string .
    DATA g_tmp_result_details TYPE /cadaxo/sqlcresult_details .
    DATA mr_arfc_exception TYPE REF TO cx_root .
    DATA g_main_ref_id TYPE i .
    DATA background_mode TYPE flag .
    DATA subselects TYPE /cadaxo/sqlc_cl_cockpit_parset .
    DATA unions TYPE /cadaxo/sqlc_cl_cockpit_parset .
    DATA subselect_source_t TYPE /cadaxo/sqlcselectsource_t .
    DATA union_source_t TYPE /cadaxo/sqlcselectsource_t .

    CLASS-METHODS check_for_host_expressions
      IMPORTING
        !i_string TYPE string .
    CLASS-METHODS check_for_host_expr_meth
      IMPORTING
        !i_string TYPE string .
    METHODS check_runtime_error
      IMPORTING
        !iv_error_message       TYPE string
      RETURNING
        VALUE(ev_error_message) TYPE string .
    CLASS-METHODS check_sql_string_includes_subq
      IMPORTING
        !i_sql_string TYPE /cadaxo/sqlcsql_string
      RETURNING
        VALUE(r_true) TYPE /cadaxo/sqlcflagtruefalse .
    CLASS-METHODS concatenate_aggr_prefix
      IMPORTING
        !i_prefix    TYPE string
      CHANGING
        !c_sqlcdfies TYPE /cadaxo/sqlcdfies .
    METHODS execute_select_via_subpool
      IMPORTING
        !i_progress_indicator   TYPE char1 OPTIONAL
      RETURNING
        VALUE(e_result_details) TYPE /cadaxo/sqlcresult_details
      RAISING
        /cadaxo/cx_sqlc_syntax_error .
    METHODS execute_select_via_subpool_v_2
      IMPORTING
        !i_progress_indicator   TYPE char1 OPTIONAL
      RETURNING
        VALUE(e_result_details) TYPE /cadaxo/sqlcresult_details
      RAISING
        /cadaxo/cx_sqlc_syntax_error .
    METHODS format_value
      IMPORTING
        !i_abap_type TYPE REF TO cl_abap_elemdescr
      EXPORTING
        !e_added     TYPE i
      CHANGING
        !c_where_col TYPE /cadaxo/sqlcwherecol_str
      RAISING
        cx_sy_conversion_no_number
        /cadaxo/cx_sqlc_invalid_value .
    METHODS format_value_wo_ddic
      IMPORTING
        !iv_value TYPE csequence
      CHANGING
        !cv_value TYPE any
      RAISING
        cx_sy_conversion_no_number .
    CLASS-METHODS get_abap_typedescr
      IMPORTING
        !i_name                 TYPE string
      RETURNING
        VALUE(r_abap_typedescr) TYPE REF TO cl_abap_typedescr
      RAISING
        /cadaxo/cx_sqlc_type_not_found .
    METHODS get_code_bypassing_buffer
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_connection
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_dbhints
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_fields
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_group_by
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_having
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_into
      IMPORTING
        !i_progress_indicator TYPE char1 OPTIONAL
      CHANGING
        VALUE(ct_code)        TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_offset
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_order_by
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_trace_off
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_trace_on
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_up_to_rows
      CHANGING
        VALUE(ct_code) TYPE /cadaxo/sqlcstring_t .
    METHODS get_code_where
      IMPORTING
        !i_only_initval TYPE abap_bool OPTIONAL
      CHANGING
        VALUE(ct_code)  TYPE /cadaxo/sqlcstring_t .
    METHODS get_ddic_field_list
      IMPORTING
        !i_cl_abap_structdescr TYPE REF TO cl_abap_structdescr
      RETURNING
        VALUE(r_fields_t)      TYPE ddfields .
    CLASS-METHODS get_multisymbol_data_table
      EXPORTING
        !e_symbol_variable TYPE gtt_symbol_variable
      CHANGING
        !c_sql_syntax      TYPE string
        !i_where_syntax    TYPE string .
    CLASS-METHODS is_count_star_only
      IMPORTING
        !iv_fieldlist                TYPE string
      RETURNING
        VALUE(ev_is_count_star_only) TYPE flag .
    METHODS process_subpool_result
      IMPORTING
        !i_data          TYPE xstring
        !i_error_message TYPE string
      RAISING
        /cadaxo/cx_sqlc_syntax_error .
    METHODS split_field
      IMPORTING
        !i_field  TYPE any
      EXPORTING
        !e_field  TYPE any
        !e_table  TYPE any
        !e_alias  TYPE any
        !e_tabfld TYPE any .
    METHODS split_field_v_2
      IMPORTING
        !i_value       TYPE string
      EXPORTING
        !e_table       TYPE string
        !e_field       TYPE string
        !e_alias       TYPE string
        !e_alias_field TYPE string .
  PRIVATE SECTION.
ENDCLASS.



CLASS /CADAXO/CL_SQLC_COCKPIT_PARSE IMPLEMENTATION.


  METHOD add_domain_value.
****************************************************************************************************
* Description             : Add Domainvalues to Result List                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations : COCKPIT-458                                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Attila Kajtar            Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
* 07.12.2020 | A. Kajtar            | Saved List error                            | COCKPIT-468    *
****************************************************************************************************
    DATA structure TYPE REF TO cl_abap_structdescr.
    DATA structure_new TYPE REF TO cl_abap_structdescr.
    DATA sub_structure TYPE REF TO cl_abap_structdescr.
    DATA tabledescr TYPE REF TO cl_abap_tabledescr.
    DATA tabledescr_new TYPE REF TO cl_abap_tabledescr.
    DATA elementdescr TYPE REF TO cl_abap_elemdescr.
    DATA lv_string TYPE string.
    DATA components_new TYPE abap_component_tab.
    DATA domain_values TYPE STANDARD TABLE OF gts_domval.
    DATA domain_value TYPE gts_domval.
    DATA result_new TYPE REF TO data.
    DATA result_struct_new TYPE REF TO data.
    DATA ls_components TYPE /cadaxo/sqlc_s_abap_compdescr.              "COCKPIT-468
    DATA lt_components TYPE /cadaxo/sqlc_t_abap_compdescr.              "COCKPIT-468
    DATA lt_comp       TYPE /cadaxo/sqlc_compdesc_t.                    "COCKPIT-468
    FIELD-SYMBOLS <result_table> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <result_new> TYPE STANDARD TABLE.

    ASSIGN me->result_table->* TO <result_table>.
    tabledescr ?= cl_abap_tabledescr=>describe_by_data( <result_table> ).
    structure ?= tabledescr->get_table_line_type( ).
    me->gt_components = structure->get_included_view( ).

    LOOP AT me->gt_components ASSIGNING FIELD-SYMBOL(<comp>).
      TRY.

          CLEAR me->gt_sub_components.
          sub_structure ?= <comp>-type.

          add_domain_value_sub(
            IMPORTING
              e_comp                       = <comp>
            CHANGING
              c_components_new             = components_new
              c_domain_values              = domain_values
              c_domain_value               = domain_value
          ).

        CATCH cx_sy_move_cast_error.
          elementdescr ?= <comp>-type.

          add_domain_value_elm(
            IMPORTING
              e_elm                        = <comp>
              e_parent_str_name            = lv_string
            CHANGING
              c_domain_values              = domain_values
              c_domain_value               = domain_value
          ).

          APPEND LINES OF me->gt_sub_components TO components_new.
      ENDTRY.
    ENDLOOP.
    "BEGIN OF COCKPIT-468
    me->gt_components_domval = components_new.
    MOVE-CORRESPONDING domain_values TO me->gt_domval.

    LOOP AT components_new INTO DATA(components).
      CLEAR: ls_components, lt_components.
      CASE components-type->kind .
        WHEN cl_abap_typedescr=>kind_struct.
          DATA(o_struct_desc) = CAST cl_abap_structdescr( components-type ).
          lt_components = o_struct_desc->components.
          APPEND lt_components TO lt_comp.
        WHEN cl_abap_typedescr=>kind_elem.
          DATA(o_elem_desc) = CAST cl_abap_elemdescr( components-type ).
          ls_components-name  = components-name.
          ls_components-type_kind = o_elem_desc->type_kind.
          ls_components-length    = o_elem_desc->length.
          ls_components-decimals  = o_elem_desc->decimals.
          APPEND ls_components TO lt_components.
          APPEND lt_components TO lt_comp.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
    me->comp = lt_comp.
    "END OF COCKPIT-468
    structure_new ?= cl_abap_structdescr=>create( components_new ).

    tabledescr_new ?= cl_abap_tabledescr=>create( structure_new ).

    CREATE DATA result_new TYPE HANDLE tabledescr_new.
    CREATE DATA result_struct_new TYPE HANDLE structure_new.

    ASSIGN result_new->* TO <result_new>.
    ASSIGN result_struct_new->* TO FIELD-SYMBOL(<result_struct_new>).

    LOOP AT <result_table> ASSIGNING FIELD-SYMBOL(<result_line>).
      CLEAR: <result_struct_new>.
      MOVE-CORRESPONDING <result_line> TO <result_struct_new>.

      LOOP AT domain_values ASSIGNING FIELD-SYMBOL(<domain_value>).
        ASSIGN COMPONENT <domain_value>-name OF STRUCTURE <result_line> TO FIELD-SYMBOL(<value_key>).
        ASSIGN COMPONENT <domain_value>-name_desc OF STRUCTURE <result_struct_new> TO FIELD-SYMBOL(<value_description>).

        IF <value_key> IS ASSIGNED AND <value_description> IS ASSIGNED.
          READ TABLE <domain_value>-fixed_values WITH KEY low = <value_key> ASSIGNING FIELD-SYMBOL(<dom_value>).
          IF sy-subrc = 0.
            <value_description> = <dom_value>-ddtext.
          ENDIF.
        ENDIF.
      ENDLOOP.

      APPEND <result_struct_new> TO <result_new>.
    ENDLOOP.

    LOOP AT gt_lvc_t_fcat ASSIGNING FIELD-SYMBOL(<lvc_s_fcat>).
      <lvc_s_fcat>-col_pos = sy-tabix.
    ENDLOOP.

    me->result_table = result_new.

  ENDMETHOD.


  METHOD add_domain_value_elm.
****************************************************************************************************
* Description             : Add Domainvalues to Result List Element processing                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations : COCKPIT-458                                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Attila Kajtar            Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
* 19.11.2020 | Attila Kajtar        | Saved lists is not working with Domain Text | COCKPIT-468    *
****************************************************************************************************

    DATA rollname_elem TYPE REF TO cl_abap_elemdescr.
    DATA component_new TYPE abap_componentdescr.
    DATA l_fcat_line TYPE lvc_s_fcat.
    DATA fieldname TYPE string.
    DATA fieldname_fcat TYPE string.
    DATA result_ddfields TYPE /cadaxo/sqlcdfies.

    component_new-name = e_elm-name.
    component_new-type = e_elm-type.
    APPEND component_new TO me->gt_sub_components.

    IF e_parent_str_name IS NOT INITIAL.
      fieldname = e_parent_str_name && '-' && e_elm-name.
    ELSE.
      fieldname = e_elm-name.
    ENDIF.

    READ TABLE me->gt_lvc_t_fcat WITH KEY fieldname = fieldname ASSIGNING FIELD-SYMBOL(<fcat>).
    IF sy-subrc = 0.
      IF <fcat>-domname IS NOT INITIAL.
        rollname_elem ?= cl_abap_elemdescr=>describe_by_name( <fcat>-rollname ).
        DATA(fixed_values) = rollname_elem->get_ddic_fixed_values( ).

        IF fixed_values IS NOT INITIAL.
          component_new-name = 'Q' && to_upper( cl_system_uuid=>create_uuid_c22_static( ) ).
          REPLACE ALL OCCURRENCES OF '}' IN component_new-name WITH 'A'.
          REPLACE ALL OCCURRENCES OF '{' IN component_new-name WITH 'B'.

          IF NOT line_exists( c_domain_values[ name = e_elm-name ] ).
            IF e_parent_str_name IS NOT INITIAL.
              c_domain_value-name = e_parent_str_name && '-' && e_elm-name.
              c_domain_value-name_desc = e_parent_str_name && '-' && component_new-name.
            ELSE.
              c_domain_value-name = e_elm-name.
              c_domain_value-name_desc = component_new-name.
            ENDIF.
            c_domain_value-fixed_values = fixed_values.
            APPEND c_domain_value TO c_domain_values.
          ENDIF.

          IF e_parent_str_name IS NOT INITIAL.
            l_fcat_line-fieldname = e_parent_str_name && '-' && component_new-name.
          ELSE.
            l_fcat_line-fieldname = component_new-name.
          ENDIF.

          READ TABLE gt_lvc_t_fcat WITH KEY fieldname = fieldname INTO DATA(lvc_t_fcat).
          DATA(tab) = sy-tabix + 1.
          IF lvc_t_fcat IS NOT INITIAL.
            l_fcat_line-reptext   = lvc_t_fcat-reptext.
            l_fcat_line-scrtext_s = lvc_t_fcat-scrtext_s.
            l_fcat_line-scrtext_m = lvc_t_fcat-scrtext_m.
            l_fcat_line-scrtext_l = lvc_t_fcat-scrtext_l.

            CLEAR: l_fcat_line-coltext.

            IF me->g_user_settings-colhd_type EQ '1' OR
              me->g_user_settings-colhd_type  EQ space.
              l_fcat_line-coltext     =  component_new-name.
              IF NOT me->g_user_settings-hd_show_alias IS INITIAL.
                IF e_parent_str_name IS INITIAL.
                  l_fcat_line-coltext = component_new-name.
                ELSE.
                  l_fcat_line-coltext = e_parent_str_name && '~' && component_new-name.
                ENDIF.
              ENDIF.
            ELSE.
              IF NOT me->g_user_settings-hd_fieldname IS INITIAL.
                l_fcat_line-coltext = e_elm-name.
              ENDIF.
              CASE abap_true.
                WHEN me->g_user_settings-hd_fieldtext_s.
                  MOVE l_fcat_line-scrtext_s TO l_fcat_line-coltext.
                WHEN me->g_user_settings-hd_fieldtext_m.
                  MOVE l_fcat_line-scrtext_m TO l_fcat_line-coltext.
                WHEN me->g_user_settings-hd_fieldtext_l.
                  MOVE l_fcat_line-scrtext_l TO l_fcat_line-coltext.
              ENDCASE.
            ENDIF.

            IF l_fcat_line-coltext IS INITIAL AND me->g_user_settings-hd_fieldtext_a IS INITIAL.
              l_fcat_line-coltext = lvc_t_fcat-fieldname.
            ENDIF.
            l_fcat_line-col_pos = tab.
            l_fcat_line-outputlen = 60.
            INSERT l_fcat_line INTO me->gt_lvc_t_fcat INDEX tab.
          ENDIF.

          component_new-type = cl_abap_elemdescr=>get_c( p_length = 60 ).
          APPEND component_new TO me->gt_sub_components.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD add_domain_value_sub.
****************************************************************************************************
* Description             : Add Domainvalues to Result Substructure                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations : COCKPIT-458                                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Attila Kajtar            Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA lr_substructure TYPE REF TO cl_abap_structdescr.
    DATA sub_structure_check TYPE REF TO cl_abap_structdescr.
    DATA component_new TYPE abap_componentdescr.
    DATA structure_new TYPE REF TO cl_abap_structdescr.

    lr_substructure ?= e_comp-type.
    DATA(components) =  lr_substructure->get_included_view( ).

    LOOP AT components ASSIGNING FIELD-SYMBOL(<comp>).
      TRY.
          sub_structure_check ?= <comp>-type.
          add_domain_value_sub( IMPORTING e_comp           = <comp>
                                CHANGING  c_components_new = c_components_new
                                          c_domain_values  = c_domain_values
                                          c_domain_value   = c_domain_value
                                           ).
        CATCH cx_sy_move_cast_error.
          add_domain_value_elm(
            IMPORTING
              e_elm                        = <comp>
              e_parent_str_name            = e_comp-name
            CHANGING
              c_domain_values              = c_domain_values
              c_domain_value               = c_domain_value
          ).
      ENDTRY.

    ENDLOOP.

    structure_new ?= cl_abap_structdescr=>create( me->gt_sub_components ).

    component_new-name = e_comp-name.
    component_new-type = structure_new.
    APPEND component_new TO c_components_new.

  ENDMETHOD.


  METHOD check_for_host_expressions.

    DATA l_string TYPE string.
    DATA l_message TYPE string.

    l_string = i_string.

* replace all '' with space
    REPLACE ALL OCCURRENCES OF '''''' IN l_string WITH space.

* replace all 'xyz' with space
    REPLACE ALL OCCURRENCES OF REGEX '.''.[^'']*.?''' IN l_string WITH space.

    FIND REGEX '^.*@\(.*\).*$' IN l_string.
    IF sy-subrc = 0.
      MESSAGE e135(/cadaxo/sqlc) INTO l_message.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
        EXPORTING
          message       = l_message
          /cadaxo/msgid = '/CADAXO/SQLC'
          /cadaxo/msgnr = '135'.

    ENDIF.

  ENDMETHOD.


  METHOD check_for_host_expr_meth.

    DATA l_string TYPE string.
    DATA l_message TYPE string.
    DATA l_functional_method TYPE string.
    DATA l_class TYPE string.
    DATA l_method TYPE string.

    l_string = i_string.

* replace all '' with space
    REPLACE ALL OCCURRENCES OF '''''' IN l_string WITH space.

* replace all 'xyz' with space
    REPLACE ALL OCCURRENCES OF REGEX '.''.[^'']*.?''' IN l_string WITH space.

    " find static method call
    FIND REGEX '^.*@\(\s.*\s*([\w_]*=>[\w_]*)\(.*$' IN l_string
       SUBMATCHES l_functional_method.
    IF sy-subrc <> 0.
      "find instance method call
      FIND REGEX '^.*@\(\s.*NEW\s*([\w_]*\(\s*\)->[\w_]*)\(.*$' IN l_string
        SUBMATCHES l_functional_method.
    ENDIF.

    IF l_functional_method IS NOT INITIAL.

      FIND REGEX '^(.*)=>(.*)$' IN l_functional_method SUBMATCHES l_class l_method.
      IF sy-subrc <> 0.
        FIND REGEX '^(.*)\(\s+\)->(.*)$' IN l_functional_method SUBMATCHES l_class l_method.
      ENDIF.

      IF l_class IS INITIAL OR l_method IS INITIAL.

        MESSAGE e152(/cadaxo/sqlc) INTO l_message WITH l_functional_method.

        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
          EXPORTING
            message       = l_message
            /cadaxo/msgid = '/CADAXO/SQLC'
            /cadaxo/msgnr = '152'.

      ELSE.

        SELECT SINGLE @abap_true INTO @DATA(l_true) FROM /cadaxo/sqlchecl WHERE class = @l_class
                                                                            AND method = @l_method
                                                                            AND active = @abap_true.
        IF l_true <> abap_true.

          MESSAGE e152(/cadaxo/sqlc) INTO l_message WITH l_functional_method.

          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
            EXPORTING
              message       = l_message
              /cadaxo/msgid = '/CADAXO/SQLC'
              /cadaxo/msgnr = '152'.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_runtime_error.
****************************************************************************************************
* Description             : Check for Runtime Error and adjust Error Messages                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 19.02.2017               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lv_dump_msg TYPE string.

    ev_error_message = iv_error_message.

    IF sy-msgid = '00' AND sy-msgno = '341'.
*   Runtime error & has occurred
      DATA(lv_dump) = sy-msgv1.
*      ev_error_message = ev_error_message && text-e03.

      MESSAGE e110(/cadaxo/sqlc) WITH iv_error_message INTO DATA(lv_main_msg).
*   The SELECT cannot be executed: &1
      CASE lv_dump.
        WHEN 'SAPSQL_DATA_LOSS'.
          MESSAGE e111(/cadaxo/sqlc) WITH '&1' INTO DATA(lv_reason_msg).
*   Possible Reason: &1

          MESSAGE e112(/cadaxo/sqlc) INTO lv_dump_msg.
*   A value in the WHERE clause is longer than the database field

          DATA(lv_combined_msg) = replace( val = lv_reason_msg sub = '&1' with = lv_dump_msg ).
          lv_dump_msg = lv_combined_msg.

      ENDCASE.

      APPEND VALUE #( msgtype = icon_red_light
                      text    = lv_main_msg ) TO me->g_main_ref->gt_errors.

      IF lv_dump_msg IS NOT INITIAL.
        APPEND VALUE #( msgtype = icon_red_light
                        text    = lv_dump_msg ) TO me->g_main_ref->gt_errors.
      ENDIF.

      APPEND VALUE #( msgtype = icon_red_light
                      text    = replace( val = TEXT-x00 sub = '&1' with = lv_dump ) ) TO me->g_main_ref->gt_errors.

    ELSE.
      APPEND VALUE #( msgtype = icon_red_light
                      text    = ev_error_message ) TO me->g_main_ref->gt_errors.

    ENDIF.


  ENDMETHOD.


  METHOD check_sql_odata_syntax.
****************************************************************************************************
* Description ....... Checks the Syntax of a sql statement for OData Generating                                        *
* Developer ......... Dusan Sacha      Date .... 24.06.2022                                 *
* Status ............ xxxxxxxxx                                                                    *                                                                                                  *
* Qual. Check(opt.)       :        Company    : CADAXO GesmbH                    *
* Date                    :                                                             *
****************************************************************************************************
* Date       | User              | Description                                       |             *
*------------+-------------------+---------------------------------------------------+-------------*
* <date>     | <developer name>  | <short description>                               |             *
*------------+-------------------+---------------------------------------------------+-------------*
*            |                   |                                                   |             *
*------------+-------------------+---------------------------------------------------+-------------*
*            |                   |                                                   |             *
*------------+-------------------+---------------------------------------------------+-------------*
*            |                   |                                                   |             *
****************************************************************************************************

    "No Select * allowed for OData Generation
    IF me->column_syntax EQ '*' OR me->column_syntax CS '~*'.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error.
    ENDIF.

    "Only new OpenSQL syntax is allowed for OData Generation
    IF me->g_select_version <> 2.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_odata_gen.
    ENDIF.




  ENDMETHOD.


  METHOD check_sql_string_includes_subq.
****************************************************************************************************
* Description             : Check, if the sql command includes a subquery                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | Fößleitner Johann    | Fixed the Problem with the Regex            | CDX001-0011    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_tmp_string(999).

    MOVE i_sql_string TO l_tmp_string.

* replace all '' with space
    REPLACE ALL OCCURRENCES OF '''''' IN l_tmp_string WITH space.

* replace all 'xyz' with space
    REPLACE ALL OCCURRENCES OF REGEX '.''.[^'']*.?''' IN l_tmp_string WITH space.  "CDX001-0011

* and now, check if there is a select command in the given where- or having-syntax
    FIND 'SELECT' IN l_tmp_string.
    IF sy-subrc EQ 0.
      r_true = 'X'.
    ENDIF.

  ENDMETHOD.


  METHOD concatenate_aggr_prefix.
****************************************************************************************************
* Description             : Concatenate aggregations with fieldnames                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    CONCATENATE i_prefix '(' : c_sqlcdfies-fieldname ')' INTO c_sqlcdfies-colhd_fieldname, "Fieldname
                               c_sqlcdfies-scrtext_l ')' INTO c_sqlcdfies-scrtext_l,       "Long Field Label
                               c_sqlcdfies-scrtext_m ')' INTO c_sqlcdfies-scrtext_m,       "Medium Field Label
                               c_sqlcdfies-scrtext_s ')' INTO c_sqlcdfies-scrtext_s,       "Short Field Label
                               c_sqlcdfies-reptext ')'   INTO c_sqlcdfies-reptext,         "Heading
                               c_sqlcdfies-fieldtext ')' INTO c_sqlcdfies-fieldtext.       "Short Description of Repository Objects

  ENDMETHOD.


  METHOD constructor.
****************************************************************************************************
* Description             :                                                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : xx                       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2014                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* xx.xx.2014 |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* xx.xx.2014 |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    g_main_ref_id = i_main_ref_id.
  ENDMETHOD.


  METHOD create_alv_field_catalog.
****************************************************************************************************
* Description             : Create ALV Field Catalog                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2015               Release    : WAS 7.40 SP8                     *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxx         Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    CASE me->g_select_version.
      WHEN me->c_select_version_1 OR me->c_select_version_0.
        r_lvc_t_fcat = me->create_alv_field_catalog_v_1( EXPORTING i_user_settings   = i_user_settings
                                                                   i_dragdrop_handle = i_dragdrop_handle ).

      WHEN OTHERS.
        me->create_alv_field_catalog_v_2( EXPORTING i_user_settings   = i_user_settings
                                                    i_dragdrop_handle = i_dragdrop_handle ).
    ENDCASE.

  ENDMETHOD.


  METHOD create_alv_field_catalog_v_1.
****************************************************************************************************
* Description             : Create ALV Field Catalog                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 12.09.2010 | Fößleitner Johann    | There are problems with the dynamic type    | CDX001-0016    *
*            |                      | definition, when the table+fieldname longer |                *
*            |                      | than 30 characters                          |                *
*------------+----------------------+---------------------------------------------+----------------*
* 13.02.2012 | Fößleitner Johann    | Use TABLE - to export list                  | CDX001-0034    *
*------------+----------------------+---------------------------------------------+----------------*
* 12.09.2014 | Fößleitner Johann/   | Bug Fix - Dump when summing up Curr field   | CR22-031       *
*            | René Rammer          |                                             | RT245          *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | Leading Spaces                              | COCKPIT-125    *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | timestamp handling                          | COCKPIT-105    *
*------------+----------------------+---------------------------------------------+----------------*
* 05.07.2017 | Harald Wiesinger     | fix missing alv headers                     | COCKPIT-198   *
****************************************************************************************************

    DATA l_sql_abap_componentdescr  TYPE abap_componentdescr.
    DATA l_guid22(22)               TYPE c.
    DATA l_tabix                    LIKE sy-tabix.
    DATA l_decimals                 TYPE i.
    DATA l_intlen                   TYPE i.

    FIELD-SYMBOLS: <l_fields>     LIKE LINE OF me->gt_result_ddfields,
                   <l_lvc_s_fcat> TYPE lvc_s_fcat.

    CLEAR: me->result_component_t[].
    CLEAR: me->gt_lvc_t_fcat.

    LOOP AT me->gt_result_ddfields ASSIGNING <l_fields>.

      l_tabix = sy-tabix.

      IF me->column_syntax NE '*'.

        CLEAR: l_sql_abap_componentdescr.

        IF <l_fields>-fieldname NE space.
          CONCATENATE <l_fields>-tabname '-'
                       <l_fields>-fieldname
                      INTO l_sql_abap_componentdescr-name.
        ELSE.
          MOVE <l_fields>-tabname TO l_sql_abap_componentdescr-name.
        ENDIF.

        IF <l_fields>-aggr EQ 'SUM('.
          CASE <l_fields>-inttype.
            WHEN 'P'.
              l_decimals = <l_fields>-decimals.
              l_intlen   = <l_fields>-intlen.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_p( p_length = l_intlen p_decimals = l_decimals ).
            WHEN 'I'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_i( ).
            WHEN OTHERS. "fallback
*            TRY.
*                l_sql_abap_componentdescr-type ?= cl_abap_typedescr=>describe_by_name( l_sql_abap_componentdescr-name ).
*              CATCH cx_root INTO DATA(lv_not_found).
              cl_abap_typedescr=>describe_by_name(
                EXPORTING
                  p_name         = l_sql_abap_componentdescr-name
                RECEIVING
                  p_descr_ref    = DATA(lv_descr_ref)
                EXCEPTIONS
                  type_not_found = 1
                  OTHERS         = 2 ).
              l_sql_abap_componentdescr-type ?= lv_descr_ref.
*            ENDTRY.
          ENDCASE.
        ELSE.
          IF <l_fields>-rollname NE '/CADAXO/SQLCAGGRCOUNT'.
*          l_sql_abap_componentdescr-type ?= cl_abap_typedescr=>describe_by_name( l_sql_abap_componentdescr-name ).
            cl_abap_typedescr=>describe_by_name(
              EXPORTING
                p_name         = l_sql_abap_componentdescr-name
              RECEIVING
                p_descr_ref    = lv_descr_ref
              EXCEPTIONS
                type_not_found = 1
                OTHERS         = 2 ).
            l_sql_abap_componentdescr-type ?= lv_descr_ref.
          ELSE.
*          l_sql_abap_componentdescr-type ?= cl_abap_typedescr=>describe_by_name( '/CADAXO/SQLCAGGRCOUNT' ).
            cl_abap_typedescr=>describe_by_name(
              EXPORTING
                p_name         = '/CADAXO/SQLCAGGRCOUNT'
              RECEIVING
                p_descr_ref    = lv_descr_ref
              EXCEPTIONS
                type_not_found = 1
                OTHERS         = 2 ).
            l_sql_abap_componentdescr-type ?= lv_descr_ref.
          ENDIF.
        ENDIF.

        READ TABLE me->result_component_t
             WITH KEY name = l_sql_abap_componentdescr-name TRANSPORTING NO FIELDS.
        IF sy-subrc EQ 0 OR strlen( l_sql_abap_componentdescr-name ) GT 30.
          IF <l_fields>-map_fieldname IS INITIAL.
            DO.
              TRY.
                  CALL METHOD ('CL_SYSTEM_UUID')=>('CREATE_UUID_C22_STATIC')
                    RECEIVING
                      uuid = l_guid22.
                CATCH cx_root.
                  CALL FUNCTION 'GUID_CREATE'
                    IMPORTING
                      ev_guid_22 = l_guid22.
              ENDTRY.
              TRANSLATE l_guid22 TO UPPER CASE.
              REPLACE ALL OCCURRENCES OF '}' IN l_guid22 WITH 'A'.
              REPLACE ALL OCCURRENCES OF '{' IN l_guid22 WITH 'B'.
* check for existing "GUID" caused by case-sensetivity of CHAR22 GUIDs
              READ TABLE me->result_component_t WITH KEY name = l_guid22 TRANSPORTING NO FIELDS.
              IF sy-subrc <> 0.
                EXIT.
              ENDIF.
            ENDDO.

            l_sql_abap_componentdescr-name = l_guid22.

          ELSE.

            l_sql_abap_componentdescr-name = <l_fields>-map_fieldname.

          ENDIF.

        ENDIF.

        APPEND l_sql_abap_componentdescr TO me->result_component_t.

        <l_fields>-map_fieldname = l_sql_abap_componentdescr-name.

      ENDIF.

      APPEND INITIAL LINE TO me->gt_lvc_t_fcat ASSIGNING <l_lvc_s_fcat>.

      MOVE-CORRESPONDING <l_fields> TO <l_lvc_s_fcat>.

      MOVE 'TABLE' TO <l_lvc_s_fcat>-tabname. "CDX001-0034

      MOVE: <l_fields>-fieldname TO <l_lvc_s_fcat>-ref_field,
            <l_fields>-tabname   TO <l_lvc_s_fcat>-ref_table.

      IF me->column_syntax EQ '*'.
        CASE <l_fields>-datatype.
          WHEN 'CURR'.
            READ TABLE me->gt_result_ddfields WITH KEY fieldname = <l_fields>-reffield TRANSPORTING NO FIELDS.  "CR22-031
            IF sy-subrc EQ 0.                                                                                   "CR22-031
              MOVE <l_fields>-reffield TO <l_lvc_s_fcat>-cfieldname.                                            "CR22-031
            ENDIF.                                                                                              "CR22-031
          WHEN 'QUAN'.
            READ TABLE me->gt_result_ddfields TRANSPORTING NO FIELDS
                       WITH KEY tabname = <l_fields>-tabname
                                fieldname = <l_fields>-reffield.
            IF sy-subrc EQ 0.
              MOVE <l_fields>-reffield TO <l_lvc_s_fcat>-qfieldname.
            ENDIF.
        ENDCASE.
      ELSE.
        CASE <l_fields>-datatype.
          WHEN 'CURR'.
            READ TABLE me->gt_result_ddfields WITH KEY fieldname = <l_fields>-reffield
                                                       tabname   = <l_fields>-reftable
                                                       TRANSPORTING NO FIELDS.
            IF sy-subrc EQ 0.
              CONCATENATE <l_fields>-reftable '-' <l_fields>-reffield INTO <l_lvc_s_fcat>-cfieldname.
            ENDIF.

          WHEN 'QUAN'.
            READ TABLE me->gt_result_ddfields TRANSPORTING NO FIELDS
                       WITH KEY tabname = <l_fields>-reftable
                                fieldname = <l_fields>-reffield.
            IF sy-subrc EQ 0.
              CONCATENATE <l_fields>-reftable '-' <l_fields>-reffield INTO <l_lvc_s_fcat>-qfieldname.
            ENDIF.
        ENDCASE.
      ENDIF.

      IF me->column_syntax NE '*'.
        MOVE l_sql_abap_componentdescr-name TO <l_lvc_s_fcat>-fieldname.
      ENDIF.

      MOVE <l_fields>-keyflag   TO <l_lvc_s_fcat>-key.

* set the column header (fieldname or fieldid)
      IF i_user_settings-hd_fieldname EQ 'X'.
        <l_lvc_s_fcat>-coltext     =  <l_fields>-colhd_fieldname.
        IF NOT <l_fields>-/cadaxo/alias IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
          CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-coltext   INTO <l_lvc_s_fcat>-coltext.
        ELSEIF   NOT <l_fields>-/cadaxo/alias_field IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL. "cockpit-339
          MOVE <l_fields>-/cadaxo/alias_field TO <l_lvc_s_fcat>-coltext. "cockpit-339
        ENDIF.
      ELSE.

        IF NOT <l_fields>-/cadaxo/alias_field IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
          MOVE <l_fields>-/cadaxo/alias_field TO <l_lvc_s_fcat>-coltext.
        ELSE.
          IF NOT <l_fields>-/cadaxo/alias IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
            IF NOT <l_lvc_s_fcat>-scrtext_l IS INITIAL.
              CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-scrtext_l INTO <l_lvc_s_fcat>-scrtext_l.
            ENDIF.
            IF NOT <l_lvc_s_fcat>-scrtext_m IS INITIAL.
              CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-scrtext_m INTO <l_lvc_s_fcat>-scrtext_m.
            ENDIF.
            IF NOT <l_lvc_s_fcat>-scrtext_s IS INITIAL.
              CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-scrtext_s INTO <l_lvc_s_fcat>-scrtext_s.
            ENDIF.
            IF NOT <l_lvc_s_fcat>-reptext IS INITIAL.
              CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-reptext INTO <l_lvc_s_fcat>-reptext.
            ENDIF.
          ENDIF.

          CASE 'X'.
            WHEN i_user_settings-hd_fieldtext_s.
              MOVE <l_lvc_s_fcat>-scrtext_s TO <l_lvc_s_fcat>-coltext.
            WHEN i_user_settings-hd_fieldtext_m.
              MOVE <l_lvc_s_fcat>-scrtext_m TO <l_lvc_s_fcat>-coltext.
            WHEN i_user_settings-hd_fieldtext_l.
              MOVE <l_lvc_s_fcat>-scrtext_l TO <l_lvc_s_fcat>-coltext.
          ENDCASE.
        ENDIF.

        IF <l_lvc_s_fcat>-coltext IS INITIAL AND i_user_settings-hd_fieldtext_a IS INITIAL.
          <l_lvc_s_fcat>-coltext = <l_fields>-fieldname.
        ENDIF.

        IF  i_user_settings-hd_fieldtext_a IS NOT INITIAL           "COCKPIT-198
        AND <l_lvc_s_fcat>-scrtext_s IS INITIAL                     "COCKPIT-198
        AND <l_lvc_s_fcat>-scrtext_m IS INITIAL                     "COCKPIT-198
        AND <l_lvc_s_fcat>-scrtext_l IS INITIAL                     "COCKPIT-198
        AND <l_lvc_s_fcat>-coltext   IS INITIAL.                    "COCKPIT-198
          <l_lvc_s_fcat>-coltext = <l_fields>-fieldname.            "COCKPIT-198
          <l_lvc_s_fcat>-scrtext_s = <l_fields>-fieldname.          "COCKPIT-198
          <l_lvc_s_fcat>-scrtext_m = <l_fields>-fieldname.          "COCKPIT-198
          <l_lvc_s_fcat>-scrtext_l = <l_fields>-fieldname.          "COCKPIT-198
        ENDIF.

      ENDIF.

      <l_lvc_s_fcat>-col_pos    = ( l_tabix * 2 ).
      <l_lvc_s_fcat>-dragdropid = i_dragdrop_handle.

* set the use of the convertion exit
      IF i_user_settings-use_convexit IS INITIAL.
        <l_lvc_s_fcat>-no_convext = abap_true.
        CLEAR <l_lvc_s_fcat>-convexit.                                           "COCKPIT-105
        CLEAR <l_lvc_s_fcat>-edit_mask.                                          "COCKPIT-105
      ENDIF.

      IF <l_fields>-datatype = 'CHAR' OR                                         "COCKPIT-125
         <l_fields>-datatype = 'STRG' OR                                         "COCKPIT-125
       ( <l_fields>-datatype IS INITIAL AND <l_fields>-inttype = 'C' ).          "COCKPIT-125
        <l_lvc_s_fcat>-parameter0 = abap_true.                                   "COCKPIT-125
      ENDIF.                                                                     "COCKPIT-125
    ENDLOOP.

    r_lvc_t_fcat = me->gt_lvc_t_fcat.

  ENDMETHOD.


  METHOD create_alv_field_catalog_v_2.
****************************************************************************************************
* Description             : Create ALV Field Catalog                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2015               Release    : WAS 7.40 SP8                     *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | Leading Spaces                              | COCKPIT-125    *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | timestamp handling                          | COCKPIT-105    *
*------------+----------------------+---------------------------------------------+----------------*
* 04.04.2017 | Domi Bigl            | Sign                                        | COCKPIT-181    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA lr_tabledescr TYPE REF TO cl_abap_tabledescr.
    DATA lr_tab TYPE REF TO data.
    DATA lr_table TYPE REF TO cl_salv_table.
    DATA lr_cols TYPE REF TO cl_salv_columns_table.
    DATA lr_aggr TYPE REF TO cl_salv_aggregations.
    DATA l_pos TYPE i.

    FIELD-SYMBOLS: <ls_lvc_s_fcat> LIKE LINE OF me->gt_lvc_t_fcat,
                   <ls_ddfields>   LIKE LINE OF me->gt_result_ddfields.

    CLEAR me->gt_lvc_t_fcat.

    lr_tabledescr ?= cl_abap_tabledescr=>describe_by_data_ref( me->result_table ).

    CREATE DATA lr_tab TYPE HANDLE lr_tabledescr.

    ASSIGN lr_tab->* TO FIELD-SYMBOL(<lt_result_tmp>).
    TRY.

        cl_salv_table=>factory( IMPORTING r_salv_table = lr_table
                                CHANGING t_table = <lt_result_tmp> ).

        lr_cols = lr_table->get_columns( ).
        lr_aggr = lr_table->get_aggregations( ).

        me->gt_lvc_t_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns      = lr_cols
                                                                               r_aggregations = lr_aggr ).

        DELETE me->gt_lvc_t_fcat WHERE datatype = 'NODE'.

        l_pos = 0.

        LOOP AT me->gt_lvc_t_fcat ASSIGNING <ls_lvc_s_fcat>.
          l_pos = l_pos + 1.
          <ls_lvc_s_fcat>-col_pos = l_pos.

          READ TABLE me->gt_result_ddfields WITH KEY fieldname = <ls_lvc_s_fcat>-fieldname ASSIGNING <ls_ddfields>.
          IF sy-subrc = 0.
            <ls_lvc_s_fcat>-rollname   = <ls_ddfields>-rollname.
            <ls_lvc_s_fcat>-domname    = <ls_ddfields>-domname.
            <ls_lvc_s_fcat>-scrtext_s  = <ls_ddfields>-scrtext_s.
            <ls_lvc_s_fcat>-scrtext_m  = <ls_ddfields>-scrtext_m.
            <ls_lvc_s_fcat>-scrtext_l  = <ls_ddfields>-scrtext_l.
            <ls_lvc_s_fcat>-checktable = <ls_ddfields>-checktable.
            <ls_lvc_s_fcat>-convexit   = <ls_ddfields>-convexit.
            <ls_lvc_s_fcat>-reptext    = <ls_ddfields>-reptext.
            <ls_lvc_s_fcat>-f4availabl = <ls_ddfields>-f4availabl.
            <ls_lvc_s_fcat>-outputlen  = <ls_ddfields>-outputlen.
            <ls_lvc_s_fcat>-ref_field  = <ls_ddfields>-reffield.
            <ls_lvc_s_fcat>-ref_table  = <ls_ddfields>-reftable.
            <ls_lvc_s_fcat>-key        = <ls_ddfields>-keyflag.
            <ls_lvc_s_fcat>-datatype   = <ls_ddfields>-datatype.
            <ls_lvc_s_fcat>-no_sign    = abap_false.                             "COCKPIT-181

            CASE <ls_lvc_s_fcat>-datatype.
              WHEN 'CURR'.
                <ls_lvc_s_fcat>-cfieldname = <ls_ddfields>-reffield.
              WHEN 'QUAN'.
                <ls_lvc_s_fcat>-qfieldname = <ls_ddfields>-reffield.
            ENDCASE.
          ENDIF.

          IF <ls_lvc_s_fcat>-scrtext_s IS INITIAL.
            <ls_lvc_s_fcat>-scrtext_s = <ls_lvc_s_fcat>-fieldname.
          ENDIF.
          IF <ls_lvc_s_fcat>-scrtext_m IS INITIAL.
            <ls_lvc_s_fcat>-scrtext_m = <ls_lvc_s_fcat>-fieldname.
          ENDIF.
          IF <ls_lvc_s_fcat>-scrtext_l IS INITIAL.
            <ls_lvc_s_fcat>-scrtext_l = <ls_lvc_s_fcat>-fieldname.
          ENDIF.

          <ls_lvc_s_fcat>-dragdropid = i_dragdrop_handle.

          IF i_user_settings-use_convexit IS INITIAL.
            <ls_lvc_s_fcat>-no_convext = abap_true.
            CLEAR <ls_lvc_s_fcat>-convexit.                                                "COCKPIT-105
            CLEAR <ls_lvc_s_fcat>-edit_mask.                                               "COCKPIT-105
          ENDIF.

          IF <ls_lvc_s_fcat>-datatype = 'CHAR' OR                                          "COCKPIT-125
             <ls_lvc_s_fcat>-datatype = 'STRG' OR                                          "COCKPIT-125
             ( <ls_lvc_s_fcat>-datatype IS INITIAL AND <ls_lvc_s_fcat>-inttype = 'C' ).    "COCKPIT-125
            <ls_lvc_s_fcat>-parameter0 = abap_true.                                        "COCKPIT-125
          ENDIF.                                                                           "COCKPIT-125
        ENDLOOP.

* set column header based on the user settings
        /cadaxo/cl_sqlc_cockpit_assist=>set_fcat_header_texts(
          EXPORTING
            is_user_settings = me->g_user_settings
            it_ddfields      = me->gt_result_ddfields
          CHANGING
            ct_fcat          = me->gt_lvc_t_fcat ).

      CATCH cx_salv_msg.
    ENDTRY.

    FREE lr_table.
    FREE lr_cols.
    FREE lr_aggr.
    FREE lr_tabledescr.
    FREE lr_tab.

  ENDMETHOD.


  METHOD create_result_structures.
****************************************************************************************************
* Description             : Create and get result structures                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations : This Method splits a field into field, talbe and alias                 *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA lr_data_tab    TYPE REF TO data.
    DATA lr_data_str    TYPE REF TO data.
    DATA l_tab          TYPE string.
    DATA l_alias        TYPE string.
    DATA lcl_structtype TYPE REF TO cl_abap_structdescr.
    DATA lcl_tabletype  TYPE REF TO cl_abap_tabledescr.

    DATA(lines) = lines( me->result_source_t ).

* for "select * from xyz" we use a more direct way to generate the result structures
    IF     me->column_syntax = '*'
       AND lines = 1
       AND i_mode <> 'S'
       AND find( val = me->source_syntax sub = '\' ) < 1.

      SPLIT me->source_syntax AT space INTO l_tab l_alias.
      CREATE DATA lr_data_tab TYPE STANDARD TABLE OF (l_tab).
      CREATE DATA lr_data_str TYPE (l_tab).

    ELSE.

      lcl_structtype = cl_abap_structdescr=>create( p_components = me->result_component_t p_strict = ' ' ).
      lcl_tabletype = cl_abap_tabledescr=>create( p_line_type  = lcl_structtype
                                                  p_table_kind = cl_abap_tabledescr=>tablekind_std
                                                  p_unique     = abap_false ).

      CREATE DATA lr_data_tab TYPE HANDLE lcl_tabletype.
      CREATE DATA lr_data_str TYPE HANDLE lcl_structtype.

    ENDIF.

    me->result_table = lr_data_tab.
    me->result_structure = lr_data_str.

    FREE: lcl_structtype,
          lcl_tabletype,
          lr_data_tab,
          lr_data_str.

  ENDMETHOD.


  METHOD execute_select.
****************************************************************************************************
* Description             : Check, if the sql command includes a subquery                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | Fößleitner Johann    | DB Hints                                    | CDX001-0011    *
*------------+----------------------+---------------------------------------------+----------------*
* 29.05.2012 | Ana Lekic            | restricted lines info - jobs                | CDX130-017     *
*------------+----------------------+---------------------------------------------+----------------*
* 31.05.2012 | Ana Lekic            | timestamps in where - catch dump            | CDX130-018     *
****************************************************************************************************

    CASE me->g_select_version.
      WHEN me->c_select_version_1.
        me->execute_select_v_1(
          EXPORTING
            i_user_settings      = i_user_settings
            i_progress_indicator = i_progress_indicator
          IMPORTING
            e_result_details     = e_result_details ).
      WHEN me->c_select_version_2.
        me->execute_select_v_2(
          EXPORTING
            i_user_settings      = i_user_settings
            i_progress_indicator = i_progress_indicator
          IMPORTING
            e_result_details     = e_result_details ).
    ENDCASE.

  ENDMETHOD.


  METHOD execute_select_via_subpool.
****************************************************************************************************
* Description             : Generate and Execute Subroutine Pool for Subselects                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | Fößleitner Johann    | DB Hints                                    | CDX001-0011    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*    05.2012 | Domi Bigl            | Subroutinenpool                             | CDX130-020     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.04.2016 | Ana Lekic            | trace                                       | $003 COCKPIT-59*
****************************************************************************************************

    FIELD-SYMBOLS: <l_result_table>  TYPE STANDARD TABLE,
                   <l_result_struct> TYPE any.

    DATA l_line            TYPE string.
    DATA l_maxsel(10)      TYPE c.
    DATA lt_abap_code      TYPE /cadaxo/sqlcstring_t.

    DATA: BEGIN OF ls_syn_msg,
            l1(72),
            l2(72),
            l3(72),
          END OF ls_syn_msg.

* assign result table and result structure to local field symbols
    ASSIGN me->result_table->*     TO <l_result_table>.
    ASSIGN me->result_structure->* TO <l_result_struct>.

    "MACRO create_dynamic_select_subpool.
    CLEAR: lt_abap_code.

    APPEND 'REPORT SUBQUERY.' TO lt_abap_code.

    APPEND 'DATA: L_ROWS         TYPE I,' TO lt_abap_code.
    APPEND '      L_PERCENTAGE   TYPE I,' TO lt_abap_code.
    APPEND '      L_PACKAGE_SIZE TYPE I.' TO lt_abap_code.

    IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
      APPEND 'DATA l_result_details         TYPE /cadaxo/sqlcresult_details.' TO lt_abap_code.
      APPEND 'DATA l_sql_trace_activated    TYPE c LENGTH 1.' TO lt_abap_code.
    ENDIF.

    APPEND 'FORM FORM TABLES TAB_RESULT USING EXP_TAB_RESULT_EXP EXP_TAB_RESULT EXP_US_SQL_TRACE EXP_US_TB_TRACE CHANGING UCX_ROOT TYPE REF TO CX_ROOT.' TO lt_abap_code.
    APPEND 'TRY.' TO lt_abap_code.

    IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
      me->get_code_trace_on( CHANGING ct_code = lt_abap_code ).
    ENDIF.

    IF NOT i_progress_indicator IS INITIAL.
      APPEND ' SELECT COUNT( * )' TO lt_abap_code.
      CONCATENATE ' FROM' me->source_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO lt_abap_code.
      IF NOT l_maxsel IS INITIAL.
        CONCATENATE ' UP TO' l_maxsel 'ROWS' INTO l_line SEPARATED BY space.
        APPEND l_line TO lt_abap_code.
      ENDIF.
      APPEND ' INTO L_ROWS' TO lt_abap_code.
      IF NOT me->where_syntax IS INITIAL.
        CONCATENATE ' WHERE' me->where_syntax INTO l_line SEPARATED BY space.
        APPEND l_line TO lt_abap_code.
      ENDIF.
      APPEND '.' TO lt_abap_code.
      APPEND ' L_PACKAGE_SIZE = l_ROWS / 100 * 5.' TO lt_abap_code.
    ENDIF.

    IF NOT me->g_select_single IS INITIAL.
      APPEND 'FIELD-SYMBOLS: <FS_STR_RESULT> TYPE ANY.' TO lt_abap_code.
      APPEND 'APPEND INITIAL LINE TO TAB_RESULT ASSIGNING <fs_str_result>.' TO lt_abap_code.
***    IF me->column_syntax EQ 'COUNT( * )' OR                       "bigld COCKPIT-100
***       me->column_syntax EQ 'COUNT(*)'.                           "bigld COCKPIT-100
      IF is_count_star_only( me->column_syntax ).                       "bigld COCKPIT-100
        APPEND 'FIELD-SYMBOLS: <FS_result_count> TYPE ANY.' TO lt_abap_code.
        APPEND 'ASSIGN (''<FS_STR_RESULT>-/CADAXO/SQLCAGGRCOUNT'') TO <FS_RESULT_COUNT>.' TO lt_abap_code.
      ENDIF.
      CONCATENATE ' SELECT SINGLE' me->column_syntax INTO l_line SEPARATED BY space.
    ELSE.
      IF NOT me->g_select_distinct IS INITIAL.
        CONCATENATE ' SELECT DISTINCT' me->column_syntax INTO l_line SEPARATED BY space.
      ELSE.
        CONCATENATE ' SELECT' me->column_syntax INTO l_line SEPARATED BY space.
      ENDIF.
    ENDIF.

    APPEND l_line TO lt_abap_code.

    CONCATENATE ' FROM' me->source_syntax INTO l_line SEPARATED BY space.
    APPEND l_line TO lt_abap_code.

    IF me->gs_client_handling-client_specified = abap_true.
      APPEND 'CLIENT SPECIFIED' TO lt_abap_code.
    ENDIF.

* connection
    IF NOT me->connection_syntax IS INITIAL.
      CONCATENATE ' CONNECTION' me->connection_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO lt_abap_code.
    ENDIF.

* add "up to x rows"
    IF me->g_select_single IS INITIAL.
      IF NOT me->g_up_to_x_rows IS INITIAL.
        l_maxsel = me->g_up_to_x_rows.
      ELSEIF NOT g_user_settings-maxsel IS INITIAL.
        l_maxsel = me->g_user_settings-maxsel.
      ENDIF.

    ENDIF.

    me->get_code_up_to_rows( CHANGING ct_code = lt_abap_code ).

    me->get_code_bypassing_buffer( CHANGING ct_code = lt_abap_code ).

    IF NOT i_progress_indicator IS INITIAL.
      APPEND ' PACKAGE SIZE L_PACKAGE_SIZE' TO lt_abap_code.
    ENDIF.

* add the into syntax (structure or table)
    IF NOT me->g_select_single IS INITIAL.
***    IF me->column_syntax EQ 'COUNT( * )' OR                       "bigld COCKPIT-100
***       me->column_syntax EQ 'COUNT(*)'.                           "bigld COCKPIT-100
      IF is_count_star_only( me->column_syntax ).                      "bigld COCKPIT-100
        APPEND ' INTO <fs_result_count>' TO lt_abap_code.
      ELSE.
        APPEND ' INTO <fs_str_result>' TO lt_abap_code.
      ENDIF.
    ELSE.
*    CASE me->g_select_version. "SQLC30
*      WHEN c_select_version_1."SQLC30
      IF NOT i_progress_indicator IS INITIAL.
        APPEND ' APPENDING TABLE TAB_RESULT' TO lt_abap_code.
      ELSE.
        APPEND ' INTO TABLE TAB_RESULT' TO lt_abap_code.
      ENDIF.
*      WHEN OTHERS."SQLC30
*        IF NOT i_progress_indicator IS INITIAL."SQLC30
*          APPEND ' APPENDING TABLE @DATA(TAB_RESULT_EXP)' TO lt_abap_code."SQLC30
*        ELSE."SQLC30
*          APPEND ' INTO TABLE @DATA(TAB_RESULT_EXP)' TO lt_abap_code."SQLC30
*        ENDIF."SQLC30
*    ENDCASE."SQLC30
    ENDIF.

* add the where syntax
    IF NOT me->where_syntax IS INITIAL.
      CONCATENATE ' WHERE' me->where_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO lt_abap_code.
    ENDIF.

* add the group by syntax
    IF NOT me->group_syntax IS INITIAL.
      CONCATENATE ' GROUP BY' me->group_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO lt_abap_code.
    ENDIF.

    me->get_code_having( CHANGING ct_code = lt_abap_code ).

    me->get_code_order_by( CHANGING ct_code = lt_abap_code ).

    me->get_code_dbhints( CHANGING ct_code = lt_abap_code ).

    APPEND '.' TO lt_abap_code.

    IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
      me->get_code_trace_off( CHANGING ct_code = lt_abap_code ).
    ENDIF.

    IF NOT i_progress_indicator IS INITIAL.
      APPEND ' l_percentage = l_percentage + 5.' TO lt_abap_code.
      APPEND ' CALL FUNCTION ''SAPGUI_PROGRESS_INDICATOR''' TO lt_abap_code.
      APPEND '   EXPORTING percentage = l_percentage.' TO lt_abap_code.
      APPEND ' ENDSELECT.' TO lt_abap_code.
    ENDIF.

    APPEND 'CATCH CX_SY_OPEN_SQL_DB INTO UCX_ROOT.'  TO lt_abap_code.
    APPEND 'ENDTRY.' TO lt_abap_code.

* format the generated abap code (line length 80)
    /cadaxo/cl_sqlc_cockpit_assist=>format_abap_code( CHANGING ct_code = lt_abap_code ).

    APPEND 'ENDFORM.' TO lt_abap_code.


    DATA lr_tab_result_exp  TYPE REF TO cl_abap_tabledescr.
    DATA lr_result          TYPE REF TO data.
    DATA l_data             TYPE xstring.
    DATA l_error_message    TYPE char128.
    DATA lt_result_source   TYPE /cadaxo/sqlcselectsource_fla_t.

    CREATE DATA lr_result TYPE c.

    MOVE-CORRESPONDING me->result_source_t TO lt_result_source.

    EXPORT dfies          = me->gt_result_ddfields
           result_source  = lt_result_source
           column_syntax  = me->column_syntax
           source_syntax  = me->source_syntax
           code           = lt_abap_code
           user_settings  = me->g_main_ref->g_user_settings
           TO DATA BUFFER l_data.

    CLEAR mr_arfc_exception.

    IF me->background_mode = abap_false.
      g_async_calls = g_async_calls + 1.
      CALL FUNCTION '/CADAXO/SQLCSUBROUTINEPOOL'
        STARTING NEW TASK 'TASK1'
        CALLING me->subpool_result ON END OF TASK
        EXPORTING
          i_version              = me->g_select_version
          i_trace                = me->g_main_ref->g_sql_trace_on "$003
          i_user_sett_sql_trace  = me->g_main_ref->g_user_settings-sql_trace  "$003
          i_user_sett_tabb_trace = me->g_main_ref->g_user_settings-tablebuffer_trace "$003
        CHANGING
          ic_data                = l_data
        EXCEPTIONS
          system_failure         = 1 MESSAGE l_error_message
          communication_failure  = 2 MESSAGE l_error_message
          resource_failure       = 3
          OTHERS                 = 4.

      IF sy-subrc = 0.
        CLEAR g_error_message. "$003
        WAIT FOR ASYNCHRONOUS TASKS UNTIL g_async_calls = 0.
        IF sy-subrc <> 0. "$003
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error "$003
            EXPORTING "$003
              message = g_error_message. "$003
        ENDIF.
        IF mr_arfc_exception IS NOT INITIAL.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error EXPORTING previous = mr_arfc_exception.
        ENDIF.

      ENDIF.
    ELSE.
      DATA: error_message TYPE string.
      CALL FUNCTION '/CADAXO/SQLCSUBROUTINEPOOL'
        EXPORTING
          i_version              = me->g_select_version
          i_trace                = me->g_main_ref->g_sql_trace_on
          i_user_sett_sql_trace  = me->g_main_ref->g_user_settings-sql_trace
          i_user_sett_tabb_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
        IMPORTING
          e_error_message        = error_message
          e_runtime              = g_tmp_result_details-runtime
          e_result_lines         = g_tmp_result_details-lines
          et_dfies               = me->gt_result_ddfields
          et_dfies_all           = me->gt_result_ddfields_all
        CHANGING
          ic_data                = l_data.

      process_subpool_result( i_data          = l_data
                              i_error_message = error_message ).
    ENDIF.
    e_result_details-runtime = g_tmp_result_details-runtime.
    e_result_details-lines   = g_tmp_result_details-lines.


    READ TABLE me->g_main_ref->gt_errors WITH KEY msgtype = icon_red_light INTO DATA(ls_error).
    IF sy-subrc = 0.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
        EXPORTING
          message = ls_error-text.
    ELSE.
      IF me->g_select_version <> c_select_version_1.
        me->create_alv_field_catalog( ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD execute_select_via_subpool_v_2.


    DATA lt_abap_code     TYPE /cadaxo/sqlcstring_t.
    DATA l_line           TYPE string.
    DATA l_maxsel         TYPE c LENGTH 10.
    DATA lt_result_source TYPE /cadaxo/sqlcselectsource_fla_t.
    DATA l_data           TYPE xstring.
    DATA l_error_message  TYPE char128.
    DATA l_dummy          TYPE string.

    " MACRO create_dynamic_select_subpool2.

    APPEND 'REPORT SUBQUERY.' TO lt_abap_code.

    DATA lt_symbol_variable TYPE gtt_symbol_variable.

    me->get_multisymbol_data_table( IMPORTING e_symbol_variable = lt_symbol_variable
                                    CHANGING  c_sql_syntax      = me->sql_syntax "Cockpit-464
                                              i_where_syntax    = me->where_syntax ).


    APPEND 'DATA: L_ROWS         TYPE I,' TO lt_abap_code.
    APPEND '      L_PERCENTAGE   TYPE I,' TO lt_abap_code.
    APPEND '      L_PACKAGE_SIZE TYPE I.' TO lt_abap_code.

    IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
      APPEND 'DATA l_result_details         TYPE /cadaxo/sqlcresult_details.' TO lt_abap_code.
      APPEND 'DATA l_sql_trace_activated    TYPE c LENGTH 1.' TO lt_abap_code.
    ENDIF.

    APPEND 'FORM FORM TABLES TAB_RESULT USING EXP_TAB_RESULT_EXP EXP_TAB_RESULT EXP_US_SQL_TRACE EXP_US_TB_TRACE RANGE_TAB TYPE /CADAXO/CL_SQLC_COCKPIT_PARSE=>gtt_symbol_variable CHANGING UCX_ROOT TYPE REF TO CX_ROOT.' TO lt_abap_code. "SQLC30
    APPEND 'TRY.' TO lt_abap_code.

    IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
      me->get_code_trace_on( CHANGING ct_code = lt_abap_code ).
    ENDIF.

    LOOP AT lt_symbol_variable ASSIGNING FIELD-SYMBOL(<l_symbol_variable>).
      APPEND |DATA { <l_symbol_variable>-var_name } TYPE RANGE OF { <l_symbol_variable>-data_type }.| TO lt_abap_code.
      APPEND |{ <l_symbol_variable>-var_name } = CORRESPONDING #( range_tab[ var_name =  '{ <l_symbol_variable>-var_name }' ]-range_table ).| TO lt_abap_code.
    ENDLOOP.

    IF NOT i_progress_indicator IS INITIAL.
      APPEND ' SELECT COUNT( * )' TO lt_abap_code.
      CONCATENATE ' FROM' me->source_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO lt_abap_code.
      IF NOT l_maxsel IS INITIAL.
        CONCATENATE ' UP TO' l_maxsel 'ROWS' INTO l_line SEPARATED BY space.
        APPEND l_line TO lt_abap_code.
      ENDIF.
      APPEND ' INTO L_ROWS' TO lt_abap_code.
      IF NOT me->where_syntax IS INITIAL.
        CONCATENATE ' WHERE' me->where_syntax INTO l_line SEPARATED BY space.
        APPEND l_line TO lt_abap_code.
      ENDIF.
      APPEND '.' TO lt_abap_code.
      APPEND ' L_PACKAGE_SIZE = l_ROWS / 100 * 5.' TO lt_abap_code.
    ENDIF.

    IF NOT me->g_select_single IS INITIAL.
      APPEND 'FIELD-SYMBOLS: <FS_STR_RESULT> TYPE ANY,' TO lt_abap_code.
      APPEND ' <fs_tab_result> type standard table.' TO lt_abap_code.
      APPEND 'APPEND INITIAL LINE TO TAB_RESULT ASSIGNING <fs_str_result>.' TO lt_abap_code.
***    IF me->column_syntax EQ 'COUNT( * )' OR                       "bigld COCKPIT-100
***       me->column_syntax EQ 'COUNT(*)'.                           "bigld COCKPIT-100
      IF is_count_star_only( me->column_syntax ).                      "bigld COCKPIT-100
        APPEND 'FIELD-SYMBOLS: <fs_result_count> TYPE any.' TO lt_abap_code.
        APPEND 'ASSIGN (''<FS_STR_RESULT>-/CADAXO/SQLCAGGRCOUNT'') TO <fs_result_count>.' TO lt_abap_code.
      ENDIF.
      CONCATENATE ' SELECT SINGLE' me->column_syntax INTO l_line SEPARATED BY space.
    ELSE.
      IF NOT me->g_select_distinct IS INITIAL.
        CONCATENATE ' SELECT DISTINCT' me->column_syntax INTO l_line SEPARATED BY space.
      ELSE.
        CONCATENATE ' SELECT' me->column_syntax INTO l_line SEPARATED BY space.
      ENDIF.
    ENDIF.

    APPEND l_line TO lt_abap_code.

    l_dummy = me->source_syntax && me->cds_parameter_syntax.
    CONCATENATE ' FROM' l_dummy INTO l_line SEPARATED BY space.
    APPEND l_line TO lt_abap_code.

    IF me->gs_client_handling-client_specified = abap_true.
      APPEND 'CLIENT SPECIFIED' TO lt_abap_code.
    ENDIF.

    me->get_code_fields( CHANGING ct_code = lt_abap_code ).

    me->get_code_where(
      EXPORTING i_only_initval = abap_false
      CHANGING ct_code = lt_abap_code
    ).

    me->get_code_dbhints( CHANGING ct_code = lt_abap_code ).

    me->get_code_group_by( CHANGING ct_code = lt_abap_code ).

    me->get_code_having( CHANGING ct_code = lt_abap_code ).

    me->get_code_order_by( CHANGING ct_code = lt_abap_code ).

    me->get_code_into( EXPORTING i_progress_indicator = i_progress_indicator
                       CHANGING ct_code = lt_abap_code ).

    me->get_code_bypassing_buffer( CHANGING ct_code = lt_abap_code ).

    IF NOT i_progress_indicator IS INITIAL.
      APPEND ' PACKAGE SIZE L_PACKAGE_SIZE' TO lt_abap_code.
    ENDIF.

    me->get_code_offset( CHANGING ct_code = lt_abap_code ).

    me->get_code_up_to_rows( CHANGING ct_code = lt_abap_code ).

    me->get_code_connection( CHANGING ct_code = lt_abap_code ).

    APPEND '.' TO lt_abap_code.

*    CASE lr_typedescr->kind.
*      WHEN cl_abap_typedescr=>kind_struct.

    IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
      me->get_code_trace_off( CHANGING ct_code = lt_abap_code ).
    ENDIF.

    IF NOT me->g_select_single IS INITIAL.
      APPEND 'DATA l_name TYPE string.' TO lt_abap_code.
      APPEND 'DATA lr_result_element TYPE REF TO cl_abap_elemdescr.' TO lt_abap_code.
      APPEND 'DATA lr_result_structure TYPE REF TO cl_abap_structdescr.' TO lt_abap_code.
      APPEND 'DATA lr_result_table TYPE REF TO cl_abap_tabledescr.' TO lt_abap_code.
      APPEND 'DATA lr_result  TYPE REF TO cl_abap_typedescr.' TO lt_abap_code.
      APPEND 'DATA lr_data TYPE REF TO data.' TO lt_abap_code.
      APPEND 'DATA ls_comp    TYPE abap_componentdescr.' TO lt_abap_code.
      APPEND 'DATA lt_comp    TYPE abap_component_tab.' TO lt_abap_code.

      APPEND 'FIELD-SYMBOLS: <lt_result> TYPE STANDARD TABLE,' TO lt_abap_code.
      APPEND '<ls_result> TYPE any,' TO lt_abap_code.
      APPEND '<ls_field>  TYPE any.' TO lt_abap_code.

      APPEND 'lr_result ?= cl_abap_typedescr=>describe_by_data( LS_RESULT_EXP ).' TO lt_abap_code.

      APPEND 'CASE lr_result->kind.' TO lt_abap_code.
      APPEND 'WHEN cl_abap_typedescr=>kind_elem.' TO lt_abap_code.
      APPEND 'CLEAR: l_name, ls_comp.' TO lt_abap_code.
      APPEND 'lr_result_element ?= lr_result.' TO lt_abap_code.
      APPEND 'l_name = lr_result_element->get_relative_name( ).' TO lt_abap_code.
      APPEND 'if l_name is initial. l_name = `RESULT`. endif.' TO lt_abap_code.
      APPEND 'ls_comp-type ?= lr_result.' TO lt_abap_code.
      APPEND 'ls_comp-name = l_name.' TO lt_abap_code.
      APPEND 'APPEND ls_comp TO lt_comp.' TO lt_abap_code.

      APPEND 'lr_result_structure ?= cl_abap_structdescr=>create( p_components = lt_comp ).' TO lt_abap_code.
      APPEND 'lr_result_table ?= cl_abap_tabledescr=>create( EXPORTING p_line_type = lr_result_structure ).' TO lt_abap_code.

      APPEND 'CREATE DATA lr_data TYPE HANDLE lr_result_table.' TO lt_abap_code.

      APPEND 'ASSIGN lr_data->* TO <lt_result>.' TO lt_abap_code.
      APPEND 'APPEND INITIAL LINE TO <lt_result> ASSIGNING <ls_result>.' TO lt_abap_code.
      APPEND 'ASSIGN COMPONENT ls_comp-name OF STRUCTURE <ls_result> TO <ls_field>.' TO lt_abap_code.

      APPEND '<ls_field> = LS_RESULT_EXP.' TO lt_abap_code.

      APPEND 'CREATE DATA EXP_TAB_RESULT LIKE <lt_result>.' TO lt_abap_code.
      APPEND 'ASSIGN EXP_TAB_RESULT->* to FIELD-SYMBOL(<LT_TAB_RESULT>).' TO lt_abap_code.
      APPEND '<LT_TAB_RESULT> = <lt_result>.' TO lt_abap_code.
      APPEND 'WHEN cl_abap_typedescr=>kind_struct.' TO lt_abap_code.
      APPEND 'lr_result_structure ?= lr_result.' TO lt_abap_code.
      APPEND 'lr_result_table ?= cl_abap_tabledescr=>create( EXPORTING p_line_type = lr_result_structure ).' TO lt_abap_code.
      APPEND 'CREATE DATA EXP_TAB_RESULT like table of LS_RESULT_EXP.' TO lt_abap_code.
      APPEND 'ASSIGN EXP_TAB_RESULT->* TO <lt_result>.' TO lt_abap_code.
      APPEND 'IF LS_RESULT_EXP IS NOT INITIAL. APPEND LS_RESULT_EXP to <lt_result>. ENDIF.' TO lt_abap_code.
      APPEND 'ENDCASE.' TO lt_abap_code.
    ELSE.
      APPEND 'EXP_TAB_RESULT_EXP ?= cl_abap_tabledescr=>describe_by_data( TAB_RESULT_EXP ).' TO lt_abap_code.
      APPEND 'CREATE DATA EXP_TAB_RESULT LIKE TAB_RESULT_EXP.' TO lt_abap_code.
      APPEND 'ASSIGN EXP_TAB_RESULT->* to FIELD-SYMBOL(<LT_TAB_RESULT>).' TO lt_abap_code.
      APPEND '<LT_TAB_RESULT> = TAB_RESULT_EXP.' TO lt_abap_code.
    ENDIF.

    IF NOT i_progress_indicator IS INITIAL.
      APPEND ' l_percentage = l_percentage + 5.' TO lt_abap_code.
      APPEND ' CALL FUNCTION ''SAPGUI_PROGRESS_INDICATOR''' TO lt_abap_code.
      APPEND '   EXPORTING percentage = l_percentage.' TO lt_abap_code.
      APPEND ' ENDSELECT.' TO lt_abap_code.
    ENDIF.

    APPEND 'CATCH CX_SY_OPEN_SQL_DB INTO UCX_ROOT.'  TO lt_abap_code.
    APPEND 'ENDTRY.' TO lt_abap_code.

* format the generated abap code (line length 80)
    /cadaxo/cl_sqlc_cockpit_assist=>format_abap_code( CHANGING ct_code = lt_abap_code ).

    APPEND 'ENDFORM.' TO lt_abap_code.

    g_async_calls = g_async_calls + 1.

    MOVE-CORRESPONDING me->result_source_t TO lt_result_source.

    EXPORT dfies         = me->gt_result_ddfields
           result_source = lt_result_source
           column_syntax = me->column_syntax
           fields_syntax = me->fields_syntax
           source_syntax = me->source_syntax
           code          = lt_abap_code
           range_tables  = lt_symbol_variable
           user_settings = me->g_main_ref->g_user_settings TO DATA BUFFER l_data.

    " MACRO END

    CLEAR mr_arfc_exception.

    IF me->background_mode = abap_false.
      CALL FUNCTION '/CADAXO/SQLCSUBROUTINEPOOL'
        STARTING NEW TASK 'TASK1'
        CALLING me->subpool_result ON END OF TASK
        EXPORTING
          i_version              = me->g_select_version
          i_trace                = me->g_main_ref->g_sql_trace_on
          i_user_sett_sql_trace  = me->g_main_ref->g_user_settings-sql_trace
          i_user_sett_tabb_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
        CHANGING
          ic_data                = l_data
        EXCEPTIONS
          system_failure         = 1 MESSAGE l_error_message
          communication_failure  = 2 MESSAGE l_error_message
          resource_failure       = 3
          OTHERS                 = 4.

      IF sy-subrc = 0.
        CLEAR g_error_message.
        WAIT FOR ASYNCHRONOUS TASKS UNTIL g_async_calls = 0.
        IF sy-subrc <> 0 OR g_error_message IS NOT INITIAL.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
            EXPORTING
              message = g_error_message.
        ENDIF.
        IF mr_arfc_exception IS NOT INITIAL.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error EXPORTING message = CONV #( TEXT-e02 ) previous = mr_arfc_exception.
        ENDIF.
      ENDIF.

    ELSE.

      DATA: error_message TYPE string.
      CALL FUNCTION '/CADAXO/SQLCSUBROUTINEPOOL'
        EXPORTING
          i_version              = me->g_select_version
          i_trace                = me->g_main_ref->g_sql_trace_on
          i_user_sett_sql_trace  = me->g_main_ref->g_user_settings-sql_trace
          i_user_sett_tabb_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
        IMPORTING
          e_error_message        = error_message
          e_runtime              = g_tmp_result_details-runtime
          e_result_lines         = g_tmp_result_details-lines
          et_dfies               = me->gt_result_ddfields
          et_dfies_all           = me->gt_result_ddfields_all
        CHANGING
          ic_data                = l_data.
      process_subpool_result( i_data          = l_data
                              i_error_message = error_message ).
    ENDIF.

* set result details
    e_result_details-runtime = g_tmp_result_details-runtime.
    e_result_details-lines   = g_tmp_result_details-lines.

* create the field catalog
    me->create_alv_field_catalog_v_2( EXPORTING i_user_settings   = me->g_main_ref->g_user_settings
                                                i_dragdrop_handle = me->g_main_ref->dragdrop_handle ).

* add the current fieldcatalog to the main reference field catalog
    APPEND me->gt_lvc_t_fcat TO me->g_main_ref->gt_lvc_t_fcat.
  ENDMETHOD.


  METHOD execute_select_v_1.

* Marco m_execute_select
    m_execute_select.

    DATA: l_case(3) TYPE c,
          l_maxsel  TYPE i.

    DATA: l_total_rows   TYPE i,
          l_package_size TYPE i,
          l_percentage   TYPE i,
          lr_exception   TYPE REF TO cx_sy_open_sql_db,
          lr_exception2  TYPE REF TO cx_sy_conversion_error. "CDX130-018

    DATA l_result_details         TYPE /cadaxo/sqlcresult_details.
    DATA l_sql_trace_activated    TYPE c LENGTH 1.

    FIELD-SYMBOLS: <l_result_table>  TYPE STANDARD TABLE,
                   <l_result_struct> TYPE any.
    CLEAR: l_maxsel.

    IF i_user_settings IS SUPPLIED.
      g_user_settings = i_user_settings.
    ENDIF.

    IF NOT me->g_up_to_x_rows IS INITIAL.
      MOVE me->g_up_to_x_rows TO l_maxsel.
    ELSEIF NOT g_user_settings-maxsel IS INITIAL.
      MOVE g_user_settings-maxsel TO l_maxsel.
    ENDIF.

* log data
    LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax
                                     me->source_syntax
                                     me->where_syntax
                                     me->group_syntax
                                     me->having_syntax
                                     me->order_syntax
                                     me->g_select_distinct
                                     me->g_bypassing_buffer
                                     me->gs_client_handling
                                     g_user_settings.

* assign result table and result structure to local field symbols
    ASSIGN me->result_table->*     TO <l_result_table>.
    ASSIGN me->result_structure->* TO <l_result_struct>.

* clear result tables
    CLEAR <l_result_table>.

* bei dynamischer Eingabe keine '
    TRANSLATE me->dbhint_syntax USING `' `.

    TRY.
***    IF me->column_syntax EQ 'COUNT( * )' OR                       "bigld COCKPIT-100
***       me->column_syntax EQ 'COUNT(*)'   AND                      "bigld COCKPIT-100
        IF is_count_star_only( me->column_syntax ) AND                "bigld COCKPIT-100
           me->group_syntax  IS INITIAL AND
           me->subquery  IS INITIAL.

          IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
            /cadaxo/cl_sqlc_cockpit_assist=>sql_trace_on(
            EXPORTING
             i_sql_trace = me->g_main_ref->g_user_settings-sql_trace
             i_tablebuffer_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
             IMPORTING
               e_date_from = l_result_details-date_from
               e_time_from = l_result_details-time_from
               e_success   = l_sql_trace_activated ).
            COMMIT WORK.
          ENDIF.

          IF me->gs_client_handling-client_specified IS INITIAL.
            DATA(runtime) = /cadaxo/cl_sqlc_rt_measurement=>start( ).
            SELECT (me->column_syntax)
                    FROM (me->source_syntax)
                    CONNECTION (me->connection_syntax)
                    INTO <l_result_struct>
                    WHERE (me->where_syntax)
                    %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                            HDB      me->dbhint_syntax. "
              APPEND <l_result_struct> TO <l_result_table>.
            ENDSELECT.
            e_result_details-runtime = runtime->end( ).
          ELSE.
            runtime = /cadaxo/cl_sqlc_rt_measurement=>start( ).
            SELECT (me->column_syntax)
                    FROM (me->source_syntax)
                    CLIENT SPECIFIED
                    CONNECTION (me->connection_syntax)
                    INTO <l_result_struct>
                    WHERE (me->where_syntax)
                    %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011   "#EC CI_HINTS
                            DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                            ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                            HDB      me->dbhint_syntax. "
              APPEND <l_result_struct> TO <l_result_table>.
            ENDSELECT.
            e_result_details-runtime = runtime->end( ).
          ENDIF.

          e_result_details-lines = sy-dbcnt. "l_LINES.

          IF l_sql_trace_activated IS NOT INITIAL.
            /cadaxo/cl_sqlc_cockpit_assist=>sql_trace_off(
              EXPORTING
               i_sql_trace = me->g_main_ref->g_user_settings-sql_trace
               i_tablebuffer_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
             IMPORTING
               e_date_to = l_result_details-date_to
               e_time_to = l_result_details-time_to ).
            CLEAR l_sql_trace_activated.
          ENDIF.

        ELSE.

* do we need to use the subquery
          IF NOT me->subquery IS INITIAL.

            e_result_details = me->execute_select_via_subpool( i_progress_indicator = i_progress_indicator ).

            IF l_maxsel > 0 AND l_maxsel = e_result_details-lines.
              MESSAGE s044(/cadaxo/sqlc) WITH l_maxsel.
              e_result_details-restricted_lines = abap_true."CDX130-017
              e_result_details-maxsel = l_maxsel.      "CDX130-017
            ENDIF.

          ELSE.

            IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
              /cadaxo/cl_sqlc_cockpit_assist=>sql_trace_on(
                EXPORTING
                 i_sql_trace = me->g_main_ref->g_user_settings-sql_trace
                 i_tablebuffer_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
                 IMPORTING
                   e_date_from = l_result_details-date_from
                   e_time_from = l_result_details-time_from
                   e_success   = l_sql_trace_activated ).
              COMMIT WORK.
            ENDIF.

            IF NOT me->g_select_single IS INITIAL.

              IF me->gs_client_handling-client_specified IS INITIAL.
                runtime = /cadaxo/cl_sqlc_rt_measurement=>start( ).
                SELECT SINGLE (me->column_syntax)
                   FROM (me->source_syntax)
                   CONNECTION (me->connection_syntax)
                   INTO <l_result_struct>
                   WHERE (me->where_syntax)
                   GROUP BY (me->group_syntax)
                   HAVING (me->having_syntax)
                   %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011   "#EC CI_HINTS
                           DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                           HDB      me->dbhint_syntax. "
                e_result_details-runtime = runtime->end( ).
              ELSE.
                runtime = /cadaxo/cl_sqlc_rt_measurement=>start( ).
                SELECT SINGLE (me->column_syntax)
                   FROM (me->source_syntax)
                   CLIENT SPECIFIED
                   CONNECTION (me->connection_syntax)
                   INTO <l_result_struct>
                   WHERE (me->where_syntax)
                   GROUP BY (me->group_syntax)
                   HAVING (me->having_syntax)
                   %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                           ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                           HDB      me->dbhint_syntax. "
                e_result_details-runtime = runtime->end( ).
              ENDIF.

              e_result_details-lines = sy-dbcnt.

              APPEND <l_result_struct> TO <l_result_table>.

            ELSE.

              MOVE: me->g_select_distinct  TO l_case(1),
                    me->gs_client_handling-client_specified TO l_case+1(1),
                    me->g_bypassing_buffer TO l_case+2(1).

              runtime = /cadaxo/cl_sqlc_rt_measurement=>start( ).

              IF i_progress_indicator NE space.

                SELECT COUNT( * )
                        FROM (me->source_syntax)
                        CONNECTION (me->connection_syntax)
                        INTO l_total_rows
                        UP TO l_maxsel ROWS
                        WHERE (me->where_syntax)
                        %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                HDB      me->dbhint_syntax. "
                l_package_size = l_total_rows / 100 * 5.

              ENDIF.


              CASE l_case.
                WHEN space.

                  IF i_progress_indicator NE space.

                    SELECT (me->column_syntax)
                            FROM (me->source_syntax)
                            CONNECTION (me->connection_syntax)
                            UP TO l_maxsel ROWS
                            PACKAGE SIZE l_package_size
                            APPENDING TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "

                      l_percentage = l_percentage + 5.

                      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                        EXPORTING
                          percentage = l_percentage.

                    ENDSELECT.

                  ELSE.

                    SELECT (me->column_syntax)
                            FROM (me->source_syntax)
                            CONNECTION (me->connection_syntax)
                            UP TO l_maxsel ROWS
                            INTO TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "
                  ENDIF.

                WHEN 'X  '.
                  IF i_progress_indicator NE space.

                    SELECT DISTINCT (me->column_syntax)
                            FROM (me->source_syntax)
                            CONNECTION (me->connection_syntax)
                            UP TO l_maxsel ROWS
                            PACKAGE SIZE l_package_size
                            APPENDING TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "
                      l_percentage = l_percentage + 5.

                      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                        EXPORTING
                          percentage = l_percentage.

                    ENDSELECT.

                  ELSE.
                    SELECT DISTINCT (me->column_syntax)
                            FROM (me->source_syntax)
                            CONNECTION (me->connection_syntax)
                            UP TO l_maxsel ROWS
                            INTO TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "
                  ENDIF.
                WHEN ' X '.
                  IF i_progress_indicator NE space.

                    SELECT (me->column_syntax)
                            FROM (me->source_syntax)
                            CLIENT SPECIFIED
                            CONNECTION (me->connection_syntax)
                            UP TO l_maxsel ROWS
                            PACKAGE SIZE l_package_size
                            APPENDING TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "

                      l_percentage = l_percentage + 5.

                      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                        EXPORTING
                          percentage = l_percentage.

                    ENDSELECT.

                  ELSE.
                    SELECT (me->column_syntax)
                            FROM (me->source_syntax)
                            CLIENT SPECIFIED
                            CONNECTION (me->connection_syntax)
                            UP TO l_maxsel ROWS
                            INTO TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "
                  ENDIF.
                WHEN '  X'.
                  IF i_progress_indicator NE space.

                    SELECT (me->column_syntax)
                            FROM (me->source_syntax)
                            CONNECTION (me->connection_syntax)
                            BYPASSING BUFFER
                            UP TO l_maxsel ROWS
                              PACKAGE SIZE l_package_size
                              APPENDING TABLE <l_result_table>
                              WHERE (me->where_syntax)
                              GROUP BY (me->group_syntax)
                              HAVING (me->having_syntax)
                              ORDER BY (me->order_syntax)
                              %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                      DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                      DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                      AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                      INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                      ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                      ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                      HDB      me->dbhint_syntax. "

                      l_percentage = l_percentage + 5.

                      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                        EXPORTING
                          percentage = l_percentage.

                    ENDSELECT.

                  ELSE.
                    SELECT (me->column_syntax)
                            FROM (me->source_syntax)
                            CONNECTION (me->connection_syntax)
                            BYPASSING BUFFER
                            UP TO l_maxsel ROWS
                            INTO TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "
                  ENDIF.
                WHEN 'XX '.
                  IF i_progress_indicator NE space.

                    SELECT DISTINCT (me->column_syntax)
                            FROM (me->source_syntax)
                            CLIENT SPECIFIED
                            CONNECTION (me->connection_syntax)
                            UP TO l_maxsel ROWS
                            PACKAGE SIZE l_package_size
                            APPENDING TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "

                      l_percentage = l_percentage + 5.

                      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                        EXPORTING
                          percentage = l_percentage.

                    ENDSELECT.

                  ELSE.
                    SELECT DISTINCT (me->column_syntax)
                            FROM (me->source_syntax)
                            CLIENT SPECIFIED
                            CONNECTION (me->connection_syntax)
                            UP TO l_maxsel ROWS
                            INTO TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "
                  ENDIF.
                WHEN 'X X'.
                  IF i_progress_indicator NE space.

                    SELECT DISTINCT (me->column_syntax)
                            FROM (me->source_syntax)
                            CONNECTION (me->connection_syntax)
                            BYPASSING BUFFER
                            UP TO l_maxsel ROWS
                            PACKAGE SIZE l_package_size
                            APPENDING TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "

                      l_percentage = l_percentage + 5.

                      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                        EXPORTING
                          percentage = l_percentage.

                    ENDSELECT.

                  ELSE.
                    SELECT DISTINCT (me->column_syntax)
                            FROM (me->source_syntax)
                            CONNECTION (me->connection_syntax)
                            BYPASSING BUFFER
                            UP TO l_maxsel ROWS
                            INTO TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "
                  ENDIF.
                WHEN ' XX'.
                  IF i_progress_indicator NE space.

                    SELECT (me->column_syntax)
                            FROM (me->source_syntax)
                            CLIENT SPECIFIED
                            CONNECTION (me->connection_syntax)
                            BYPASSING BUFFER
                            UP TO l_maxsel ROWS
                            PACKAGE SIZE l_package_size
                            APPENDING TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "

                      l_percentage = l_percentage + 5.

                      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                        EXPORTING
                          percentage = l_percentage.

                    ENDSELECT.

                  ELSE.
                    SELECT (me->column_syntax)
                            FROM (me->source_syntax)
                            CLIENT SPECIFIED
                            CONNECTION (me->connection_syntax)
                            BYPASSING BUFFER
                            UP TO l_maxsel ROWS
                            INTO TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                    HDB      me->dbhint_syntax. "

                  ENDIF.
                WHEN 'XXX'.
                  IF i_progress_indicator NE space.

                    SELECT DISTINCT (me->column_syntax)
                                    FROM (me->source_syntax)
                                    CLIENT SPECIFIED
                                    CONNECTION (me->connection_syntax)
                                    BYPASSING BUFFER
                                    UP TO l_maxsel ROWS
                                    PACKAGE SIZE l_package_size
                                    APPENDING TABLE <l_result_table>
                                    WHERE (me->where_syntax)
                                    GROUP BY (me->group_syntax)
                                    HAVING (me->having_syntax)
                                    ORDER BY (me->order_syntax)
                                    %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                            HDB      me->dbhint_syntax. "

                      l_percentage = l_percentage + 5.

                      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                        EXPORTING
                          percentage = l_percentage.

                    ENDSELECT.

                  ELSE.
                    SELECT DISTINCT (me->column_syntax)
                                    FROM (me->source_syntax)
                                    CLIENT SPECIFIED
                                    CONNECTION (me->connection_syntax)
                                    BYPASSING BUFFER
                                    UP TO l_maxsel ROWS
                                    INTO TABLE <l_result_table>
                                    WHERE (me->where_syntax)
                                    GROUP BY (me->group_syntax)
                                    HAVING (me->having_syntax)
                                    ORDER BY (me->order_syntax)
                                    %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            INFORMIX me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                            ADABAS   me->dbhint_syntax "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                                            HDB      me->dbhint_syntax. "
                  ENDIF.
              ENDCASE.

              e_result_details-runtime = runtime->end( ).
              e_result_details-lines = sy-dbcnt. "l_LINES.

              IF e_result_details-lines > 0 AND e_result_details-lines = l_maxsel.
                MESSAGE s044(/cadaxo/sqlc) WITH l_maxsel.
                e_result_details-restricted_lines = abap_true."CDX130-017
                e_result_details-maxsel = l_maxsel.    "CDX130-017
              ENDIF.

            ENDIF.
            IF l_sql_trace_activated IS NOT INITIAL.
              /cadaxo/cl_sqlc_cockpit_assist=>sql_trace_off(
                EXPORTING
                 i_sql_trace = me->g_main_ref->g_user_settings-sql_trace
                 i_tablebuffer_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
               IMPORTING
                 e_date_to = l_result_details-date_to
                 e_time_to = l_result_details-time_to ).
              CLEAR l_sql_trace_activated.
              COMMIT WORK.
            ENDIF.
          ENDIF.
        ENDIF.

        me->result_lines = e_result_details-lines.
        me->result_runtime = e_result_details-runtime.

        e_result_details-syst    = sy-sysid.
        e_result_details-uname   = sy-uname.
        e_result_details-mandant = sy-mandt.
        GET TIME STAMP FIELD e_result_details-create_timestamp.

      CATCH cx_sy_open_sql_db INTO lr_exception.
        LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
                                   <l_result_table> me->where_syntax me->group_syntax
                                   me->having_syntax me->order_syntax.
        RAISE EXCEPTION lr_exception.
      CATCH /cadaxo/cx_sqlc_syntax_error.
        LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
                                         <l_result_table> me->where_syntax me->group_syntax
                                         me->having_syntax me->order_syntax.
        RAISE EXCEPTION TYPE cx_sy_open_sql_db.
      CATCH cx_sy_conversion_error INTO lr_exception2.        "CDX130-018
        LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel"CDX130-018
                                   <l_result_table> me->where_syntax me->group_syntax"CDX130-018
                                   me->having_syntax me->order_syntax."CDX130-018
        RAISE EXCEPTION lr_exception2. "CDX130-018

    ENDTRY.

  ENDMETHOD.


  METHOD execute_select_v_2.
    DATA l_maxsel           TYPE i.
    DATA lr_exception       TYPE REF TO cx_sy_open_sql_db.
    DATA lr_exception2      TYPE REF TO cx_sy_conversion_error.
    DATA lr_root_exception  TYPE REF TO /cadaxo/cx_sqlc_syntax_error.

    "MACRO m_execute_select_v_2

    CLEAR l_maxsel.

    IF i_user_settings IS SUPPLIED.
      g_user_settings = i_user_settings.
    ENDIF.

    IF NOT me->g_up_to_x_rows IS INITIAL.
      l_maxsel = me->g_up_to_x_rows.
    ELSEIF NOT g_user_settings-maxsel IS INITIAL.
      l_maxsel = g_user_settings-maxsel.
    ENDIF.

    LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax
                                     me->source_syntax
                                     me->where_syntax
                                     me->group_syntax
                                     me->having_syntax
                                     me->order_syntax
                                     me->g_select_distinct
                                     me->g_bypassing_buffer
                                     me->gs_client_handling
                                     g_user_settings.

    TRY.

        e_result_details = me->execute_select_via_subpool_v_2( i_progress_indicator = i_progress_indicator ).

        IF l_maxsel > 0 AND l_maxsel = e_result_details-lines.
          MESSAGE s044(/cadaxo/sqlc) WITH l_maxsel.
          e_result_details-restricted_lines = abap_true.
          e_result_details-maxsel = l_maxsel.
        ENDIF.

        me->result_lines    = e_result_details-lines.
        me->result_runtime = e_result_details-runtime.

        e_result_details-syst    = sy-sysid.
        e_result_details-uname   = sy-uname.
        e_result_details-mandant = sy-mandt.
        GET TIME STAMP FIELD e_result_details-create_timestamp.

      CATCH cx_sy_open_sql_db INTO lr_exception.
        LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
        me->where_syntax me->group_syntax
        me->having_syntax me->order_syntax.
        RAISE EXCEPTION lr_exception.

      CATCH /cadaxo/cx_sqlc_syntax_error INTO lr_root_exception.
        LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
        me->where_syntax me->group_syntax
        me->having_syntax me->order_syntax.
        RAISE EXCEPTION lr_root_exception.

      CATCH cx_sy_conversion_error INTO lr_exception2.
        LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
        me->where_syntax me->group_syntax
        me->having_syntax me->order_syntax.
        RAISE EXCEPTION lr_exception2.

    ENDTRY.
    RETURN.
  ENDMETHOD.


  METHOD format_value.
****************************************************************************************************
* Description             : Bring the value of th where_col in right format  (CDX130-018)          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Ana Lekic                Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
* 09.05.2014 | Domi Bigl            | no decimal . for P decimals 0               | RT229          *
*------------+----------------------+---------------------------------------------+----------------*
* 24.07.2014 | Rehan vd Merwe       | correct parsing of ., in timestamps         | RT139          *
*------------+----------------------+---------------------------------------------+----------------*
* 12.11.2017 | Domi Bigl            | check for table fieldname                   | COCKPIT-277    *
****************************************************************************************************

    DATA l_count    TYPE p DECIMALS 1.
    DATA l_len      TYPE i.
    DATA l_flen     TYPE i.

    DATA lo_matcher TYPE REF TO cl_abap_matcher.              " RT139
    DATA l_match   TYPE c LENGTH 1.                           " RT139

    DATA l_dref     TYPE REF TO data.                         " RT139
    FIELD-SYMBOLS: <ls> TYPE any.                             " RT139
    CREATE DATA l_dref TYPE HANDLE i_abap_type.               " RT139
    ASSIGN l_dref->* TO <ls>.                                 " RT139

    CLEAR e_added.
    CLEAR l_len.
    CLEAR l_flen.

    l_len = strlen( c_where_col-value ).                   " Replaces previous RT229 " RT139

    IF subquery = abap_true.
      FIND REGEX '\( SELECT' IN c_where_col-value.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    CASE i_abap_type->type_kind.
      WHEN 'P' OR 'F'.

        FIND ALL OCCURRENCES OF '''' IN c_where_col-value MATCH COUNT l_count.
        l_count = l_count / 2.
        IF l_count NE 0 AND frac( l_count ) EQ 0.
        ELSE.
          REPLACE ALL OCCURRENCES OF '''' IN c_where_col-value WITH ''.
          CONCATENATE '''' c_where_col-value '''' INTO c_where_col-value.
        ENDIF.

        REPLACE ALL OCCURRENCES OF '''' IN c_where_col-value WITH ''." RT139
        DATA l_char TYPE c LENGTH 5000.                         " RT139
        l_char = c_where_col-value.                           " RT139
        SHIFT l_char LEFT DELETING LEADING space.             " RT139

* if it is not in the correct format '\d*\.\d*', convert it. " RT139
        CLEAR lo_matcher.                                     " RT139
        lo_matcher = cl_abap_matcher=>create( pattern     = '\d*\.\d*'" RT139
                                              text        = l_char )." RT139
        l_match = lo_matcher->match( ).                       " RT139
        CLEAR lo_matcher.                                     " RT139
        IF l_match <> abap_true                               " RT139
           AND l_char CO ' 0987654321,.'.                     "COCKPIT-277
          TRY.                                                                                 "COCKPIT-105
              me->format_value_wo_ddic( EXPORTING iv_value = l_char CHANGING cv_value = <ls> )."COCKPIT-105
            CATCH cx_sy_conversion_no_number.                                                  "COCKPIT-105
              RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value "COCKPIT-105
                EXPORTING                                                                      "COCKPIT-105
                  value = c_where_col-value                                                    "COCKPIT-105
                  field = CONV #( c_where_col-fieldname ).                                     "COCKPIT-105
          ENDTRY.                                                                              "COCKPIT-105

          c_where_col-value = <ls>.                           " RT139
        ELSE.                                                 " RT139
          c_where_col-value = l_char.                         " RT139
        ENDIF.                                                " RT139

        IF l_char CO ' 0987654321,.'.                           "COCKPIT-277
          CONDENSE c_where_col-value.                           " RT139
          CONCATENATE '''' c_where_col-value '''' INTO c_where_col-value." RT139

          l_flen = strlen( c_where_col-value ).           " Replaces previous RT229 " RT139
          IF l_flen <> l_len.                             " Replaces previous RT229 " RT139
            ADD 1 TO e_added.                             " Replaces previous RT229 " RT139
          ENDIF.                                          " Replaces previous RT229 " RT139
        ENDIF.                                                   "COCKPIT-277
    ENDCASE.


  ENDMETHOD.


  METHOD format_value_wo_ddic.
****************************************************************************************************
* Description             : Bring the value of the where_col in right format                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 18.02.2017               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lv_subrc LIKE sy-subrc.
    DATA: lv_error TYPE rsconverr.
    DATA: lv_convert TYPE rsconvert.
    DATA: lv_int TYPE i.
    DATA: lv_deciflag.
    DATA: lv_tcurx TYPE tcurx.
    DATA: lr_field TYPE REF TO data.

    DATA: BEGIN OF ls_emask,
            prefix(2),
            convexit  TYPE rsconvert-convexit,
          END   OF ls_emask.

    DESCRIBE FIELD cv_value TYPE          lv_convert-type
                            COMPONENTS    lv_int
                            LENGTH        lv_convert-length
                            IN BYTE MODE
                            OUTPUT-LENGTH lv_convert-olength
                            DECIMALS      lv_convert-decimals
                            EDIT MASK     ls_emask.

    CALL FUNCTION 'RS_CONV_EX_2_IN_NO_DD'
      EXPORTING
        input_external  = iv_value
      IMPORTING
        output_internal = cv_value
      EXCEPTIONS
        OTHERS          = 1.
    IF sy-subrc <> 0 .
      IF ls_emask IS NOT INITIAL.
        CASE lv_convert-type.
          WHEN 'P'.
            DATA(lr_elem_handle) = cl_abap_elemdescr=>get_p( EXPORTING p_length = lv_convert-length
                                                                       p_decimals = lv_convert-decimals ).

          WHEN 'F'.
            lr_elem_handle = cl_abap_elemdescr=>get_f( ).
        ENDCASE.

        CREATE DATA lr_field TYPE HANDLE lr_elem_handle.
        ASSIGN lr_field->* TO FIELD-SYMBOL(<lv_field>).
        me->format_value_wo_ddic( EXPORTING iv_value = iv_value
                                  CHANGING  cv_value = <lv_field> ).
        cv_value = <lv_field>.
      ELSE.
        RAISE EXCEPTION TYPE cx_sy_conversion_no_number.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_abap_typedescr.
****************************************************************************************************
* Description             : Buffer CL_ABAP_TYPEDESCR                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations : To improve the performance, we use a local buffer to get the           *
*                           abap types                                                             *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA lcl_typedescr  TYPE REF TO cl_abap_typedescr.

    FIELD-SYMBOLS <l_tabtypedescr> LIKE LINE OF gt_abap_typedescr.

* can we get the type from the local buffer?
    READ TABLE gt_abap_typedescr WITH KEY typename = i_name ASSIGNING <l_tabtypedescr>.
    IF sy-subrc EQ 0.
      MOVE <l_tabtypedescr>-abap_typedescr TO r_abap_typedescr.
    ELSE.
* the given type isn't in the local buffer, so we get it from the database
      cl_abap_typedescr=>describe_by_name(
        EXPORTING
          p_name         = i_name
        RECEIVING
          p_descr_ref    = lcl_typedescr
        EXCEPTIONS
          type_not_found = 1
          OTHERS         = 2 ).
      IF sy-subrc EQ 0. "add the type description to buffer
        APPEND INITIAL LINE TO gt_abap_typedescr ASSIGNING <l_tabtypedescr>.

        MOVE: i_name        TO <l_tabtypedescr>-typename,
              lcl_typedescr TO <l_tabtypedescr>-abap_typedescr.

        MOVE <l_tabtypedescr>-abap_typedescr TO r_abap_typedescr.

      ELSE. "in this case, we have realy a problem. Should not happen ...
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_type_not_found
          EXPORTING
            type = i_name.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_bypassing_buffer.

    IF NOT me->g_bypassing_buffer IS INITIAL.
      APPEND ' BYPASSING BUFFER' TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_connection.
    DATA l_line TYPE string.

    IF NOT me->connection_syntax IS INITIAL.
      CONCATENATE ' CONNECTION' me->connection_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.
  ENDMETHOD.


  METHOD get_code_dbhints.

    DATA l_line           TYPE string.

    IF NOT me->dbhint_syntax IS INITIAL.
      CONCATENATE ' %_HINTS MSSQLNT' me->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         DB6     ' me->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         DB2     ' me->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         AS400   ' me->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         INFORMIX' me->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         ORACLE  ' me->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         ADABAS  ' me->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         HDB     ' me->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.

    ENDIF.

  ENDMETHOD.


  METHOD get_code_fields.

    DATA l_line TYPE string.

    IF NOT me->fields_syntax IS INITIAL.
      CONCATENATE ' FIELDS' me->fields_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_group_by.

    DATA l_line TYPE string.

    IF NOT me->group_syntax IS INITIAL.
      CONCATENATE ' GROUP BY' me->group_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_having.

    DATA l_line TYPE string.

    IF NOT me->having_syntax IS INITIAL.
      CONCATENATE ' HAVING' me->having_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_into.

    CASE me->g_select_version.
      WHEN c_select_version_1.
      WHEN c_select_version_2.
        IF NOT me->g_select_single IS INITIAL.
          APPEND ' INTO @DATA(LS_RESULT_EXP)' TO ct_code.
        ELSE.
          IF NOT i_progress_indicator IS INITIAL.
            APPEND ' APPENDING TABLE @DATA(TAB_RESULT_EXP)' TO ct_code.
          ELSE.
            APPEND ' INTO TABLE @DATA(TAB_RESULT_EXP)' TO ct_code.
          ENDIF.
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD get_code_offset.

    DATA l_line TYPE string.

    IF NOT me->offset_syntax IS INITIAL.
      CONCATENATE ' OFFSET' me->offset_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_order_by.

    DATA l_line TYPE string.

    IF NOT me->order_syntax IS INITIAL.
      CONCATENATE ' ORDER BY' me->order_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_trace_off.

    APPEND 'IF L_SQL_TRACE_ACTIVATED IS NOT INITIAL.' TO ct_code.
    APPEND '  /CADAXO/CL_SQLC_COCKPIT_ASSIST=>SQL_TRACE_OFF(' TO ct_code.
    APPEND '    EXPORTING' TO ct_code.
    APPEND '     I_SQL_TRACE = EXP_US_SQL_TRACE' TO ct_code.
    APPEND '     I_TABLEBUFFER_TRACE = EXP_US_TB_TRACE' TO ct_code.
    APPEND '   IMPORTING' TO ct_code.
    APPEND '     E_DATE_TO = L_RESULT_DETAILS-DATE_TO' TO ct_code.
    APPEND '     E_TIME_TO = L_RESULT_DETAILS-TIME_TO ).' TO ct_code.
    APPEND '  CLEAR L_SQL_TRACE_ACTIVATED.' TO ct_code.
    APPEND 'endif.' TO ct_code.

  ENDMETHOD.


  METHOD get_code_trace_on.

    APPEND '/CADAXO/CL_SQLC_COCKPIT_ASSIST=>SQL_TRACE_ON(' TO ct_code.
    APPEND 'EXPORTING' TO ct_code.
    APPEND ' I_SQL_TRACE = EXP_US_SQL_TRACE' TO ct_code.
    APPEND ' I_TABLEBUFFER_TRACE = EXP_US_TB_TRACE' TO ct_code.
    APPEND ' IMPORTING' TO ct_code.
    APPEND '   E_DATE_FROM = L_RESULT_DETAILS-DATE_FROM' TO ct_code.
    APPEND '   E_TIME_FROM = L_RESULT_DETAILS-TIME_FROM' TO ct_code.
    APPEND '   E_SUCCESS   = L_SQL_TRACE_ACTIVATED ).' TO ct_code.

  ENDMETHOD.


  METHOD get_code_up_to_rows.

    DATA l_line     TYPE string.
    DATA l_maxsel   TYPE c LENGTH 10.

    IF me->g_select_single IS INITIAL.

      IF NOT me->g_up_to_x_rows IS INITIAL.
        MOVE me->g_up_to_x_rows TO l_maxsel.
      ELSEIF NOT g_user_settings-maxsel IS INITIAL AND me->g_no_upto IS INITIAL.
        MOVE me->g_user_settings-maxsel TO l_maxsel.
      ENDIF.

      IF NOT l_maxsel IS INITIAL.
        CONCATENATE ' UP TO' l_maxsel 'ROWS' INTO l_line SEPARATED BY space.
        APPEND l_line TO ct_code.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_code_where.
********************************************************************************************************************************
* 21.01.2019 | Pat Patil            | Validate IN Operator for multi-value symbols in WHERE condition | Cockpit-349
********************************************************************************************************************************

    DATA l_line TYPE string.
    DATA lt_results             TYPE match_result_tab.
    DATA l_symbol_name          TYPE /cadaxo/sqlcsymbol_name.
    DATA lt_symbols             TYPE TABLE OF /cadaxo/sqlcsymbol_name.
    DATA l_from                 TYPE i.
    DATA l_length               TYPE i.
    DATA l_symbol_name_replace  TYPE string.
    DATA l_where_syntax         TYPE string.
    DATA l_symbol_value         TYPE string.
    DATA l_symbol_multivalue    TYPE string.
    DATA lv_is_multi            TYPE abap_bool.
    DATA l_symbol_value_replace TYPE string.

    FIELD-SYMBOLS: <ls_result>  LIKE LINE OF lt_results,
                   <ls_symbols> LIKE LINE OF lt_symbols.

    IF NOT me->where_syntax IS INITIAL.

      l_where_syntax = me->where_syntax.

      IF i_only_initval = abap_true.
        "       Replace Multivalue With Initial value

        /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex(
          EXPORTING
            i_where_syntax =     l_where_syntax
          IMPORTING
            e_result_tab   =     lt_results
        ).

        IF sy-subrc EQ 0.
          LOOP AT lt_results ASSIGNING <ls_result>.

            l_from = <ls_result>-offset + 1.
            l_length = <ls_result>-length - 2.

            l_symbol_name = l_where_syntax+l_from(l_length).
            APPEND l_symbol_name TO lt_symbols.

          ENDLOOP.
        ENDIF.
        LOOP AT lt_symbols ASSIGNING <ls_symbols>.

          l_symbol_name = to_upper( <ls_symbols> ).

          /cadaxo/cl_sqlc_cockpit_assist=>get_user_symbol_value(
            EXPORTING i_symbol            = l_symbol_name
            IMPORTING e_symbol_value      = l_symbol_value
                      e_symbol_multivalue = l_symbol_multivalue
                      e_is_multi          = lv_is_multi ).

          IF lv_is_multi = abap_true.

            l_symbol_name_replace = `&` && l_symbol_name && `&`.

* begin of change #349
            me->parse_sql_where_columns( ) .
            READ TABLE me->gt_sql_where_col_tab_t WITH KEY value = l_symbol_name_replace INTO DATA(ls_where).
            IF sy-subrc = 0 AND ls_where-operator <> 'IN'.
              MESSAGE e136(/cadaxo/sqlc) WITH l_symbol_name INTO DATA(l_message).
              RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
                EXPORTING
                  message = l_message.
            ENDIF.
* end of change #349

            l_symbol_value_replace = `( '` && l_symbol_multivalue && `' )`.
            REPLACE ALL OCCURRENCES OF REGEX l_symbol_name_replace IN l_where_syntax WITH l_symbol_value_replace IGNORING CASE.
          ENDIF.
        ENDLOOP.

      ENDIF.

      CONCATENATE ' WHERE' l_where_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_ddic_field_list.
****************************************************************************************************
* Description             : Get the field list in ddic format                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    r_fields_t = i_cl_abap_structdescr->get_ddic_field_list(  ).

  ENDMETHOD.


  METHOD get_multisymbol_data_table.
    DATA lt_results        TYPE match_result_tab.
    DATA l_symbol_name     TYPE string.
    DATA l_symbol_sql      TYPE string.
    DATA l_symbol_multival TYPE /cadaxo/sqlcsymbol_multivalue.
    DATA lr_symbol_value   TYPE rseloption.
    DATA l_sql             TYPE string.
    DATA l_tmp_sql         TYPE string.
    DATA l_varname         TYPE char50.
    DATA l_symbol_datatype TYPE /cadaxo/sqlcsymbol_datatype.

    l_sql = i_where_syntax.

    /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex(
      EXPORTING
        i_where_syntax =     i_where_syntax
      IMPORTING
        e_result_tab   =     lt_results
    ).
* begin of change COCKPIT-464
    IF lt_results IS INITIAL.
      SPLIT c_sql_syntax AT 'WHERE' INTO DATA(l_pre_syntax) DATA(l_post_syntax).
      CONDENSE l_post_syntax.
      /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex(
      EXPORTING
        i_where_syntax =     l_post_syntax
      IMPORTING
        e_result_tab   =     lt_results
        ).
      i_where_syntax = l_post_syntax.
    ENDIF.
* end of change COCKPIT-464

    "  FIND ALL OCCURRENCES OF REGEX '&(\w|/|-)+&' IN l_sql RESULTS lt_results.

    IF sy-subrc = 0.
      LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<l_result>).

        l_symbol_sql = i_where_syntax+<l_result>-offset(<l_result>-length).
        l_symbol_name = l_symbol_sql.
        REPLACE ALL OCCURRENCES OF '&' IN l_symbol_name WITH space.
        CONDENSE l_symbol_name NO-GAPS.
        TRANSLATE l_symbol_name TO UPPER CASE.                                 "CDX130-009

        SELECT SINGLE symbol_multivalue symbol_datatype FROM /cadaxo/sqlcusym
          INTO ( l_symbol_multival, l_symbol_datatype )
          WHERE username    = sy-uname
            AND symbol_name = l_symbol_name.

        IF sy-subrc = 0 AND l_symbol_multival IS NOT INITIAL.
          /cadaxo/cl_sqlc_cockpit_assist=>decompress_symbol_multivalue( EXPORTING i_symbol_multivalue = l_symbol_multival
                                                                        IMPORTING e_symbol_multivalue = lr_symbol_value ).
        ENDIF.

        l_varname = 'ltr_' && to_lower( l_symbol_name ).
        APPEND VALUE #( var_name = l_varname data_type = l_symbol_datatype range_table = lr_symbol_value ) TO e_symbol_variable.

        l_varname = '@ltr_' && l_symbol_name.
        REPLACE ALL OCCURRENCES OF l_symbol_sql IN l_sql WITH l_varname IGNORING CASE.
      ENDLOOP.

      i_where_syntax = l_sql.
      SORT e_symbol_variable.
      DELETE ADJACENT DUPLICATES FROM e_symbol_variable.
    ENDIF.
  ENDMETHOD.


  METHOD is_count_star_only.
****************************************************************************************************
* Description             : Check if only count(*) is requested                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations : checks also with alias name                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 26.01.2017               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    TYPES: ltr_string TYPE RANGE OF string.

    DATA(lv_fieldlist) = to_lower( condense( iv_fieldlist ) ).
    DATA(lv_fieldlist_nogabs) = condense( val = lv_fieldlist del = ` ` from = ` ` to = space ).

    ev_is_count_star_only = abap_false.

    IF lv_fieldlist_nogabs NA ','.

      IF  lv_fieldlist_nogabs IN VALUE ltr_string( sign = 'I' option = 'EQ'
                                                  ( low = 'count(*)' )
                                                  ( low = 'singlecount(*)' )
                                                  ( low = 'distinctcount(*)' ) ).
        ev_is_count_star_only = abap_true.
      ELSE.

        SPLIT lv_fieldlist AT ` as ` INTO TABLE DATA(lt_parts).

        CASE lines( lt_parts ).
          WHEN 2.
            IF lt_parts[ 2 ] NA space.
              ev_is_count_star_only = is_count_star_only( iv_fieldlist = lt_parts[ 1 ] ).
            ENDIF.
          WHEN 3.
            ev_is_count_star_only = is_count_star_only( iv_fieldlist = lt_parts[ 1 ] && lt_parts[ 2 ] ).
        ENDCASE.

      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD parse_sql_i.
    TYPES: BEGIN OF t_split,
             line TYPE c LENGTH 255,
           END OF t_split.

    TYPES: BEGIN OF ty_range,
             start TYPE i,
             end   TYPE i,
           END OF ty_range.

    DATA lt_split             TYPE TABLE OF t_split.
    DATA sql_string           TYPE string.
    DATA ls_adm_cust          TYPE /cadaxo/sqlc_admin_cust.
    DATA length               TYPE i.
    DATA l_from               TYPE i.
    DATA l_act_do             TYPE i.
    DATA l_apostrophe_open    TYPE c LENGTH 1.
    DATA l_to                 TYPE i.
    DATA l_string             TYPE string.
    DATA lt_string_sql        TYPE TABLE OF string.
    DATA parser               TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
    DATA l_section            TYPE c LENGTH 10.
    DATA matchoffset          TYPE i.
    DATA l_foff               TYPE i.
    DATA brackets_open        TYPE i.
    DATA in_subsection        TYPE abap_bool.
    DATA in_subselect         TYPE abap_bool.
    DATA l_sql_string_c       TYPE c LENGTH 100.
    DATA lv_check_sql_string  TYPE string. " COCKPIT-222
    DATA lt_match_results     TYPE TABLE OF match_result.
    DATA l_length             TYPE i.
    DATA l_message            TYPE string.
    DATA lv_spacer_string     TYPE string. " COCKPIT-222
    DATA lt_results           TYPE match_result_tab.
    DATA ls_results           TYPE match_result.
    DATA length2              TYPE i.
    DATA l_sql_string         TYPE string.
    DATA bracket_closed_index TYPE i.
    DATA l_alias              TYPE abap_bool.
    DATA subselects           TYPE TABLE OF string.
    DATA l_off_tmp            TYPE i.
    DATA matchoffset_tmp      TYPE i.
    DATA length_tmp           TYPE i.
    DATA l_maxsel             TYPE i.
    DATA union_alls           TYPE TABLE OF string.
    DATA unions               TYPE TABLE OF string.
    DATA all_unions           TYPE TABLE OF string.

    FIELD-SYMBOLS <l_match_result> TYPE match_result.
    FIELD-SYMBOLS <l_split>        LIKE LINE OF lt_split.

    DATA: BEGIN OF section_range,
            column     TYPE ty_range,
            from       TYPE ty_range,
            connection TYPE ty_range,
            subselect  TYPE ty_range,
            where      TYPE ty_range,
            order      TYPE ty_range,
            hints      TYPE ty_range,
            group      TYPE ty_range,
            fields     TYPE ty_range,
            having     TYPE ty_range,
            offset     TYPE ty_range,
          END OF section_range.

    sql_string = i_sql.
    g_role     = i_role.
    g_main_ref = i_main_ref.

    " get customizing
    /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).

    " convert sql-string to upper case
    sql_string = /cadaxo/cl_sqlc_cockpit_assist=>translate_sql_str_upper_case( sql_string ).

    SHIFT sql_string LEFT DELETING LEADING space.

    sql_string = condense( sql_string ).

    length = strlen( sql_string ).
    l_from = 0.
    DO length TIMES.
      l_act_do = sy-index - 1.
      CASE sql_string+l_act_do(1).
        WHEN '.'.
          IF l_apostrophe_open = space.
            l_to = l_act_do - l_from.
            l_string = sql_string+l_from(l_to).
            IF     l_string IS NOT INITIAL
               AND l_string <> cl_abap_char_utilities=>cr_lf
               AND l_string CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890=().'.
              APPEND l_string TO lt_string_sql.
            ENDIF.
            l_from = l_act_do + 1.
          ENDIF.
        WHEN c_apostrophe.
          TRANSLATE l_apostrophe_open USING ' XX '.
      ENDCASE.
    ENDDO.
    IF sql_string+l_from IS NOT INITIAL.
      l_string = sql_string+l_from.
      IF     l_string IS NOT INITIAL
         AND l_string <> cl_abap_char_utilities=>cr_lf
         AND l_string CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890=().'.
        APPEND l_string TO lt_string_sql.
      ENDIF.
    ENDIF.

    CLEAR e_sql_parsed[].

    LOOP AT lt_string_sql INTO sql_string.

      parser = NEW #( ).

      SHIFT sql_string LEFT DELETING LEADING space.

      TRY.
          WHILE sql_string(2) = cl_abap_char_utilities=>cr_lf.
            sql_string = sql_string+2.
            SHIFT sql_string LEFT DELETING LEADING space.
          ENDWHILE.
        CATCH cx_sy_range_out_of_bounds.
      ENDTRY.

      parser->sql_syntax = sql_string.

      " Delete CR/LF
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN sql_string WITH space.
      SHIFT sql_string LEFT DELETING LEADING space.

      " DATA(l_bytes) = strlen( sql_string ) * cl_abap_char_utilities=>charsize."COCKPIT-223
      " IF l_bytes > 57000.                                                     "COCKPIT-223
      " MESSAGE e116(/cadaxo/sqlc) INTO l_message.                            "COCKPIT-223
      " RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error                     "COCKPIT-223
      " EXPORTING                                                           "COCKPIT-223
      " message       = l_message                                         "COCKPIT-223
      " /cadaxo/msgid = '/CADAXO/SQLC'                                    "COCKPIT-223
      " /cadaxo/msgnr = '016'.                                            "COCKPIT-223
      " ENDIF.                                                                  "COCKPIT-223

      parser->sql_syntax_without_where = sql_string.     " CDX001-0029

      CLEAR:
          l_section,
          matchoffset,
          l_foff,
          section_range,
          brackets_open,
          in_subsection,
          in_subselect.

      l_sql_string_c = sql_string.

      DATA(select_pattern) = /cadaxo/cl_sqlc_special_parse=>detect_select_pattern( CONV #( l_sql_string_c ) ).

      IF select_pattern-is_select = abap_true.

        l_foff = l_foff + select_pattern-match_length.

        parser->g_select_distinct = select_pattern-is_distinct.
        parser->g_select_single   = select_pattern-is_single.

      ELSE.

        IF /cadaxo/cl_sqlc_special_parse=>may_be_datasource( sql_string ).

          IF /cadaxo/cl_sqlc_special_parse=>is_datasource( sql_string ).
            IF g_user_settings-strict_mode = abap_true.
              l_sql_string_c = |SELECT FROM { l_sql_string_c } FIELDS *|.
            ELSE.
              l_sql_string_c = |SELECT * FROM { l_sql_string_c }|.
            ENDIF.
            sql_string = l_sql_string_c.
            parser->sql_syntax_without_where = l_sql_string_c.
            parser->sql_syntax               = l_sql_string_c.
            l_foff = l_foff + 7.
          ELSE.
            RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_no_sel_at_firs
            EXPORTING textid = /cadaxo/cx_sqlc_no_sel_at_firs=>/cadaxo/cx_sqlc_no_sel_tab_1st.
          ENDIF.

        ELSE.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_no_sel_at_firs
          EXPORTING textid = /cadaxo/cx_sqlc_no_sel_at_firs=>/cadaxo/cx_sqlc_no_sel_at_firs.
        ENDIF.

      ENDIF.

      " Set initial section
      l_section = 'COLUMN'.
      section_range-column-start = l_foff.

      " Delete ending '.'
      CLEAR sy-subrc.
      WHILE sy-subrc = 0.
        FIND FIRST OCCURRENCE OF REGEX '\.$' IN sql_string MATCH OFFSET matchoffset.
        IF sy-subrc = 0.
          sql_string = sql_string(matchoffset).
        ENDIF.
      ENDWHILE.

      " extract up to x rows, bypassing buffer and client specified
      lv_check_sql_string = sql_string.

      FIND ALL OCCURRENCES OF REGEX '''[^'']*''' IN sql_string RESULTS lt_match_results.
      IF sy-subrc = 0.
        SORT lt_match_results BY offset DESCENDING.
        LOOP AT lt_match_results ASSIGNING <l_match_result>.
          lv_check_sql_string = replace( val  = lv_check_sql_string
                                         off  = <l_match_result>-offset
                                         len  = <l_match_result>-length
                                         with = repeat( val = ` `
                                                        occ = <l_match_result>-length ) ). " COCKPIT-222
        ENDLOOP.
      ENDIF.

      FIND REGEX 'UP\s+TO\s+\d+\s+ROWS' IN lv_check_sql_string MATCH OFFSET matchoffset MATCH LENGTH l_length.
      IF sy-subrc = 0.
        DATA(lv_up_to_string) = condense( val = lv_check_sql_string+matchoffset(l_length)
                                          del = ` ` ). " COCKPIT-222

        SPLIT lv_up_to_string AT space INTO TABLE lt_split.
        ASSIGN lt_split[ 3 ] TO <l_split>.
        TRY.
            parser->g_up_to_x_rows = <l_split>.
          CATCH cx_sy_conversion_overflow.

            MESSAGE e016(/cadaxo/sqlc) WITH <l_split> INTO l_message.

            RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
            EXPORTING message = l_message.
        ENDTRY.

        lv_spacer_string = repeat( val = ` `
                                   occ = l_length ).                                                         " COCKPIT-222
        lv_check_sql_string = replace( val  = lv_check_sql_string
                                       off  = matchoffset
                                       len  = l_length
                                       with = lv_spacer_string ). " COCKPIT-222
        sql_string          = replace( val  = sql_string
                                       off  = matchoffset
                                       len  = l_length
                                       with = lv_spacer_string ). " COCKPIT-222

      ENDIF.

      FIND REGEX 'BYPASSING\s+BUFFER' IN lv_check_sql_string MATCH OFFSET matchoffset MATCH LENGTH l_length.
      IF sy-subrc = 0.

        parser->g_bypassing_buffer = abap_true.
        lv_spacer_string = repeat( val = ` `
                                   occ = l_length ).                                                         " COCKPIT-222
        lv_check_sql_string = replace( val  = lv_check_sql_string
                                       off  = matchoffset
                                       len  = l_length
                                       with = lv_spacer_string ). " COCKPIT-222
        sql_string          = replace( val  = sql_string
                                       off  = matchoffset
                                       len  = l_length
                                       with = lv_spacer_string ). " COCKPIT-222

      ENDIF.

      " client specified - main select
      FIND ALL OCCURRENCES OF 'SELECT' IN lv_check_sql_string RESULTS lt_results.
      READ TABLE lt_results INDEX 2 INTO ls_results.
      IF sy-subrc = 0.
        length2 = ls_results-offset.
      ELSE.
        length2 = strlen( sql_string ).
      ENDIF.
      FIND FIRST OCCURRENCE OF REGEX 'CLIENT\s+SPECIFIED' IN SECTION OFFSET 0 LENGTH length2 OF lv_check_sql_string MATCH OFFSET matchoffset MATCH LENGTH l_length.
      IF sy-subrc = 0.
        IF ls_adm_cust-allow_cls <> abap_true.
          MESSAGE e013(/cadaxo/sqlc) INTO l_message.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
          EXPORTING message       = l_message
                    /cadaxo/msgid = '/CADAXO/SQLC'
                    /cadaxo/msgnr = '013'.
        ELSE.

          parser->gs_client_handling-client_specified = abap_true.
          lv_spacer_string = repeat( val = ` `
                                     occ = l_length ).                                                         " COCKPIT-222
          lv_check_sql_string = replace( val  = lv_check_sql_string
                                         off  = matchoffset
                                         len  = l_length
                                         with = lv_spacer_string ). " COCKPIT-222
          sql_string          = replace( val  = sql_string
                                         off  = matchoffset
                                         len  = l_length
                                         with = lv_spacer_string ). " COCKPIT-222

        ENDIF.
      ENDIF.

      " client specified - sub selects
      FIND FIRST OCCURRENCE OF REGEX '\ASELECT(.*)SELECT(.*)(CLIENT\s+SPECIFIED)' IN lv_check_sql_string.
      IF sy-subrc = 0.
        IF ls_adm_cust-allow_cls <> abap_true.
          MESSAGE e013(/cadaxo/sqlc) INTO l_message.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
          EXPORTING message       = l_message
                    /cadaxo/msgid = '/CADAXO/SQLC'
                    /cadaxo/msgnr = '013'.
        ENDIF.
      ENDIF.

      FIND FIRST OCCURRENCE OF REGEX 'USING\s+CLIENT'
           IN SECTION OFFSET 0 LENGTH length2 OF lv_check_sql_string
           MATCH OFFSET matchoffset MATCH LENGTH length.
      IF sy-subrc = 0.
        IF ls_adm_cust-allow_cls <> abap_true.
          MESSAGE e121(/cadaxo/sqlc) INTO l_message.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error " COCKPIT-225
          EXPORTING message       = l_message
                    /cadaxo/msgid = '/CADAXO/SQLC'
                    /cadaxo/msgnr = '121'.
        ELSE.
          parser->gs_client_handling-using_client = abap_true.
        ENDIF.
      ENDIF.

      " client specified - sub selects
      FIND FIRST OCCURRENCE OF REGEX '\ASELECT(.*)SELECT(.*)(USING\s+CLIENT)' IN lv_check_sql_string.
      IF sy-subrc = 0.
        IF ls_adm_cust-allow_cls <> abap_true.
          MESSAGE e121(/cadaxo/sqlc) INTO l_message.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
          EXPORTING message       = l_message
                    /cadaxo/msgid = '/CADAXO/SQLC'
                    /cadaxo/msgnr = '121'.
        ENDIF.
      ENDIF.

      REPLACE 'COUNT(*)' IN sql_string WITH 'COUNT( * )'.

* WITH PRIVILEGED ACCESS
      FIND FIRST OCCURRENCE OF REGEX 'WITH\sPRIVILEGED\sACCESS' IN lv_check_sql_string.
      IF sy-subrc = 0.
        MESSAGE e170(/cadaxo/sqlc) INTO l_message.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
        EXPORTING message       = l_message
                  /cadaxo/msgid = '/CADAXO/SQLC'
                  /cadaxo/msgnr = '170'.
      ENDIF.

* FOR ALL ENTIRIES
      FIND FIRST OCCURRENCE OF REGEX 'FOR\sALL\sENTRIES' IN lv_check_sql_string.
      IF sy-subrc = 0.
        MESSAGE e171(/cadaxo/sqlc) INTO l_message.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
        EXPORTING message       = l_message
                  /cadaxo/msgid = '/CADAXO/SQLC'
                  /cadaxo/msgnr = '171'.
      ENDIF.

* FOR ALL ENTIRIES
      FIND FIRST OCCURRENCE OF REGEX '\b(?:APPENDING|INTO)\b' IN lv_check_sql_string.
      IF sy-subrc = 0.
        MESSAGE e172(/cadaxo/sqlc) INTO l_message.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
        EXPORTING message       = l_message
                  /cadaxo/msgid = '/CADAXO/SQLC'
                  /cadaxo/msgnr = '172'.
      ENDIF.
      l_sql_string = sql_string.

      " remove strings
      /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = l_sql_string ).

      DO.
        TRY.
            FIND REGEX '\s' IN SECTION OFFSET l_foff OF l_sql_string MATCH OFFSET matchoffset.
            IF sy-subrc = 0.
              length = matchoffset - l_foff.

              IF sql_string+l_foff(length) = c_apostrophe.
                l_foff = l_foff + 1.
                FIND FIRST OCCURRENCE OF c_apostrophe
                     IN SECTION OFFSET l_foff OF sql_string MATCH OFFSET matchoffset.
                l_foff = matchoffset.
              ELSEIF sql_string+l_foff(length) CA '('.
                brackets_open = brackets_open + 1.
                IF sql_string+l_foff(length) CA ')'.
                  brackets_open = brackets_open - 1.
                  bracket_closed_index = l_foff.
                ENDIF.
              ELSEIF sql_string+l_foff(length) CA ')'.
                brackets_open = brackets_open - 1.
                bracket_closed_index = l_foff.
              ELSEIF sql_string+l_foff(length) = '.'.
                l_foff = l_foff + 1.
                l_foff = matchoffset.
              ELSE.

                IF brackets_open = 0.

                  IF l_alias = space.

                    IF in_subsection = abap_true.
                      in_subsection = abap_false.
                      IF in_subselect = abap_true.
                        in_subselect = abap_false.
                        section_range-subselect-end = bracket_closed_index - 1.
                        length2 = section_range-subselect-end - section_range-subselect-start.
                        APPEND sql_string+section_range-subselect-start(length2) TO subselects.
                        CLEAR section_range-subselect.
                      ENDIF.
                    ENDIF.

                    CASE sql_string+l_foff(length).
                      WHEN 'AS'.
                        l_alias = abap_true.
                      WHEN 'IN'.
                        in_subsection = abap_true.
                      WHEN 'FROM'.
                        IF section_range-from-start IS INITIAL.
                          section_range-column-end = l_foff - 1.
                          section_range-from-start = matchoffset + 1.
                          l_section = 'SOURCE'.
                        ENDIF.
                      WHEN 'FIELDS'.
                        IF section_range-fields-start IS INITIAL.
                          section_range-fields-start = matchoffset + 1.
                          macro_case_section.
                          l_section = 'FIELDS'.
                        ENDIF.
                      WHEN 'OFFSET'.
                        section_range-offset-start = matchoffset + 1.
                        macro_case_section.
                        l_section = 'OFFSET'.
                      WHEN 'CONNECTION'.
                        section_range-connection-start = matchoffset + 1.
                        macro_case_section.
                        l_section = 'CONNECTION'.
                      WHEN 'WHERE'.
                        IF section_range-where-start IS INITIAL. " COCKPIT-60
                          section_range-where-start = matchoffset + 1.
                          macro_case_section.
                          l_section = 'WHERE'.
                        ENDIF.
                      WHEN 'GROUP'.
                        macro_case_section.
                        section_range-group-start = matchoffset + 1.
                        l_off_tmp = matchoffset + 1.

                        FIND REGEX '^ *BY +' IN SECTION OFFSET l_off_tmp OF sql_string MATCH OFFSET matchoffset_tmp MATCH LENGTH length_tmp.
                        IF sy-subrc <> 0.
                          MESSAGE e093(/cadaxo/sqlc) INTO l_message.
                          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
                          EXPORTING message = l_message.
                        ELSE.
                          section_range-group-start = matchoffset_tmp + length_tmp.
                        ENDIF.

                        l_section = 'GROUP'.
                      WHEN 'HAVING'.
                        section_range-having-start = matchoffset + 1.
                        macro_case_section.
                        l_section = 'HAVING'.
                      WHEN 'ORDER'.
                        macro_case_section.
                        section_range-order-start = matchoffset + 3.
                        l_section = 'ORDER'.
                      WHEN '%_HINTS'.                          " CDX001-0011
                        macro_case_section.

                        matchoffset = matchoffset + 1.                   " CDX001-0011

                        FIND REGEX '\s' IN SECTION OFFSET matchoffset OF sql_string MATCH OFFSET matchoffset. " CDX001-0011

                        section_range-hints-start = matchoffset + 1.               " CDX001-0011
                        l_section = '%_HINTS'.                " CDX001-0011

                    ENDCASE.
                  ELSE.

                    " not supported alias
                    IF    sql_string+l_foff(length) = 'HAVING'
                       OR sql_string+l_foff(length) = 'WHERE'
                       OR sql_string+l_foff(length) = 'INTO'
                       OR sql_string+l_foff(length) = 'INNER'
                       OR sql_string+l_foff(length) = 'LEFT'
                       OR sql_string+l_foff(length) = 'ON'.

                      l_message = sql_string+l_foff(length).
                      MESSAGE e040(/cadaxo/sqlc) WITH l_message INTO l_message.
                      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
                      EXPORTING message = l_message.

                    ENDIF.

                    CLEAR l_alias.

                  ENDIF.
                ELSE.
                  IF in_subsection = abap_true.
                    CASE sql_string+l_foff(length).
                      WHEN 'SELECT'.
                        IF in_subselect = abap_false.
                          in_subselect = abap_true.
                          section_range-subselect-start = matchoffset - strlen( 'SELECT' ).
                        ENDIF.
                    ENDCASE.
                  ENDIF.
                ENDIF.
              ENDIF.
              l_foff = matchoffset + 1.
            ELSE.
              IF section_range-from-end IS INITIAL AND section_range-from-start IS NOT INITIAL.
                section_range-from-end = strlen( sql_string ).
              ENDIF.
              IF section_range-where-end IS INITIAL AND section_range-where-start IS NOT INITIAL.
                section_range-where-end = strlen( sql_string ).
              ENDIF.
              IF in_subselect = abap_true AND section_range-subselect-end IS INITIAL AND section_range-subselect-start IS NOT INITIAL.
                section_range-subselect-end = strlen( sql_string ) - 2. " )
              ENDIF.
              IF section_range-order-end IS INITIAL AND section_range-order-start IS NOT INITIAL.
                section_range-order-end = strlen( sql_string ).
              ENDIF.
              IF section_range-group-end IS INITIAL AND section_range-group-start IS NOT INITIAL.
                section_range-group-end = strlen( sql_string ).
              ENDIF.
              IF section_range-having-end IS INITIAL AND section_range-having-start IS NOT INITIAL.
                section_range-having-end = strlen( sql_string ).
              ENDIF.
              IF section_range-hints-end IS INITIAL AND section_range-hints-start IS NOT INITIAL.   " CDX001-0011
                section_range-hints-end = strlen( sql_string ).                     " CDX001-0011
              ENDIF.                                                  " CDX001-0011
              IF section_range-fields-end IS INITIAL AND section_range-fields-start IS NOT INITIAL. " COCKPIT-261
                section_range-fields-end = strlen( sql_string ).                    " COCKPIT-261
              ENDIF.                                                  " COCKPIT-261
              IF section_range-offset-end IS INITIAL AND section_range-offset-start IS NOT INITIAL.
                section_range-offset-end = strlen( sql_string ).
              ENDIF.
              IF section_range-connection-end IS INITIAL AND section_range-connection-start IS NOT INITIAL.
                section_range-connection-end = strlen( sql_string ).
              ENDIF.
              EXIT.
            ENDIF.

          CATCH cx_sy_range_out_of_bounds.
            EXIT.
        ENDTRY.
      ENDDO.

      length = section_range-column-end - section_range-column-start.
      IF length > 0.
        parser->column_syntax = sql_string+section_range-column-start(length).
        SHIFT parser->column_syntax RIGHT DELETING TRAILING space.                 " CDX001-0022
        SHIFT parser->column_syntax LEFT DELETING LEADING space.
      ENDIF.

      length = section_range-from-end - section_range-from-start.

      IF length > 0.

        parser->source_syntax = sql_string+section_range-from-start(length).
*      parser->source_syntax = replace( val = parser->source_syntax regex = '\( | \)' with = '' occ = 0 ). "COCKPIT-114
        parser->source_syntax = shift_left( parser->source_syntax ).                                         " COCKPIT-114
        DATA(lv_syntax_cleanup) = shift_left( val = parser->source_syntax
                                              sub = '(' ).                               " COCKPIT-114
        " COCKPIT-114
        IF lv_syntax_cleanup <> parser->source_syntax.                                                               " COCKPIT-114
          " COCKPIT-114
          parser->source_syntax = shift_left( lv_syntax_cleanup ).                                                   " COCKPIT-114
          parser->source_syntax = shift_right( parser->source_syntax ).                                      " COCKPIT-114
          parser->source_syntax = shift_right( val = parser->source_syntax
                                               sub = ')' ).                      " COCKPIT-114
          " COCKPIT-114
        ENDIF.                                                                                                               " COCKPIT-114

      ENDIF.

      " no source syntax
      IF parser->source_syntax = space.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_no_source.
      ENDIF.

      length = section_range-where-end - section_range-where-start.
      IF length > 0.
        parser->where_syntax = sql_string+section_range-where-start(length).
        SHIFT parser->where_syntax LEFT DELETING LEADING space.
      ENDIF.

      length = section_range-subselect-end - section_range-subselect-start.
      IF length > 0.
        APPEND sql_string+section_range-subselect-start(length) TO subselects.
        CLEAR section_range-subselect.
      ENDIF.

      length = section_range-order-end - section_range-order-start.
      IF length > 0.
        parser->order_syntax = sql_string+section_range-order-start(length).
        SHIFT parser->order_syntax LEFT DELETING LEADING space.
      ENDIF.

      length = section_range-group-end - section_range-group-start.
      IF length > 0.
        parser->group_syntax = sql_string+section_range-group-start(length).
        SHIFT parser->group_syntax LEFT DELETING LEADING space.
      ENDIF.

      length = section_range-having-end - section_range-having-start.
      IF length > 0.
        parser->having_syntax = sql_string+section_range-having-start(length).
        SHIFT parser->having_syntax LEFT DELETING LEADING space.
      ENDIF.

      length = section_range-hints-end - section_range-hints-start.                                       " CDX001-0011
      IF length > 0 AND sql_string+section_range-hints-start(length) <> space.              " CDX001-0011
        parser->dbhint_syntax = sql_string+section_range-hints-start(length). " CDX001-0011
        SHIFT parser->dbhint_syntax LEFT DELETING LEADING space.   " CDX001-0011
      ENDIF.                                                               " CDX001-0011

      length = section_range-fields-end - section_range-fields-start.                                     " COCKPIT-261
      IF length > 0 AND sql_string+section_range-fields-start(length) <> space.             " COCKPIT-261
        parser->fields_syntax = sql_string+section_range-fields-start(length). " COCKPIT-261
        SHIFT parser->fields_syntax LEFT DELETING LEADING space.   " COCKPIT-261
      ENDIF.                                                               " COCKPIT-261

      length = section_range-offset-end - section_range-offset-start.
      IF length > 0 AND sql_string+section_range-offset-start(length) <> space.
        parser->offset_syntax = sql_string+section_range-offset-start(length).
        SHIFT parser->offset_syntax LEFT DELETING LEADING space.
      ENDIF.

      length = section_range-connection-end - section_range-connection-start.
      IF length > 0 AND sql_string+section_range-connection-start(length) <> space.
        IF ls_adm_cust-allow_connection <> abap_true.
          MESSAGE e097(/cadaxo/sqlc) INTO l_message.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
          EXPORTING message       = l_message
                    /cadaxo/msgid = '/CADAXO/SQLC'
                    /cadaxo/msgnr = '097'.
        ENDIF.

        parser->connection_syntax = sql_string+section_range-connection-start(length).
        SHIFT parser->connection_syntax LEFT DELETING LEADING space.

      ENDIF.

      " cds views
      FIND FIRST OCCURRENCE OF REGEX '^([^(\s]+)(\(.*\).*)$' IN parser->source_syntax
           SUBMATCHES parser->source_syntax parser->cds_parameter_syntax.

      " check subqueries
      parser->subquery = check_sql_string_includes_subq( parser->where_syntax ).
      IF parser->subquery IS INITIAL AND parser->having_syntax IS NOT INITIAL.
        parser->subquery = check_sql_string_includes_subq( parser->having_syntax ).
      ENDIF.

      " check host expressions
      IF ls_adm_cust-allow_host_expressions <> abap_true.
        check_for_host_expressions( CONV #( parser->where_syntax ) ).
        check_for_host_expressions( CONV #( parser->column_syntax ) ).
        check_for_host_expressions( CONV #( parser->fields_syntax ) ).
        check_for_host_expressions( CONV #( parser->offset_syntax ) ).
        check_for_host_expressions( CONV #( parser->source_syntax ) ).
        check_for_host_expressions( CONV #( parser->cds_parameter_syntax ) ).
        check_for_host_expressions( CONV #( parser->group_syntax ) ).
        check_for_host_expressions( CONV #( parser->order_syntax ) ).
        check_for_host_expressions( CONV #( parser->dbhint_syntax ) ).
      ENDIF.

      check_for_host_expr_meth( CONV #( parser->where_syntax ) ).
      check_for_host_expr_meth( CONV #( parser->where_syntax ) ).
      check_for_host_expr_meth( CONV #( parser->column_syntax ) ).
      check_for_host_expr_meth( CONV #( parser->fields_syntax ) ).
      check_for_host_expr_meth( CONV #( parser->offset_syntax ) ).
      check_for_host_expr_meth( CONV #( parser->source_syntax ) ).
      check_for_host_expr_meth( CONV #( parser->cds_parameter_syntax ) ).
      check_for_host_expr_meth( CONV #( parser->group_syntax ) ).
      check_for_host_expr_meth( CONV #( parser->order_syntax ) ).
      check_for_host_expr_meth( CONV #( parser->dbhint_syntax ) ).

      IF i_user_settings IS SUPPLIED.
        parser->g_user_settings = i_user_settings.
      ENDIF.

      IF is_count_star_only( parser->column_syntax ).                          " COCKPIT-100
        IF parser->group_syntax IS NOT INITIAL.                                " COCKPIT-100
          MESSAGE e109(/cadaxo/sqlc) INTO l_message.                                   " COCKPIT-100
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error " COCKPIT-100
          EXPORTING message       = l_message
                    /cadaxo/msgid = '/CADAXO/SQLC'
                    /cadaxo/msgnr = '109'.
        ELSE.                                                                          " COCKPIT-100
          parser->g_select_single = abap_true.                                 " COCKPIT-100
        ENDIF.                                                                         " COCKPIT-100
      ENDIF.

      IF parser->where_syntax IS NOT INITIAL.                                  " CDX001-0029
        REPLACE FIRST OCCURRENCE OF parser->where_syntax                       " CDX001-0029
                IN parser->sql_syntax_without_where WITH '<WHEREPARAM>'.       " CDX001-0029
      ENDIF.                                                                           " CDX001-0029

      APPEND parser TO e_sql_parsed.

      IF ls_adm_cust-maxsel IS NOT INITIAL.
        l_maxsel = ls_adm_cust-maxsel.
      ELSE.
        l_maxsel = 16.
      ENDIF.

      IF sy-tabix > l_maxsel.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_to_much_resrow
        EXPORTING max_nr_of_selects = l_maxsel.
      ENDIF.

      LOOP AT subselects ASSIGNING FIELD-SYMBOL(<subselect>).

        DATA(paresedsubselects) = /cadaxo/cl_sqlc_cockpit_parse=>parse_sql_i( i_sql           = <subselect>
                                                                              i_user_settings = i_user_settings
                                                                              i_role          = i_role
                                                                              i_main_ref_id   = i_main_ref_id
                                                                              i_main_ref      = i_main_ref ).
        APPEND LINES OF paresedsubselects TO parser->subselects.

      ENDLOOP.

      DATA(sql_string_union) = parser->sql_syntax.
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN sql_string_union WITH space.
      /cadaxo/cl_sqlc_cockpit_assist=>condense( CHANGING c_string = sql_string_union ).
      /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = sql_string_union ).
      IF sql_string_union CS 'UNION'.
        SPLIT sql_string_union AT | UNION ALL| INTO TABLE union_alls.

        LOOP AT union_alls ASSIGNING FIELD-SYMBOL(<union>).
          SPLIT <union> AT | UNION | INTO TABLE unions.
          APPEND LINES OF unions TO all_unions.
        ENDLOOP.
        LOOP AT all_unions ASSIGNING <union>.

          DATA(paresedsunions) = /cadaxo/cl_sqlc_cockpit_parse=>parse_sql_i( i_sql           = <union>
                                                                             i_user_settings = i_user_settings
                                                                             i_role          = i_role
                                                                             i_main_ref_id   = i_main_ref_id
                                                                             i_main_ref      = i_main_ref ).
          APPEND LINES OF paresedsunions TO parser->unions.

        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD parse_sql_ii.

    CASE me->g_select_version.
      WHEN c_select_version_1 OR c_select_version_0.
        me->parse_sql_ii_1( ).
      WHEN c_select_version_2.
        me->parse_sql_ii_2( ).
    ENDCASE.


    LOOP AT subselects ASSIGNING FIELD-SYMBOL(<subselect>).
      <subselect>->parse_sql_ii( ).
      APPEND LINES OF <subselect>->result_source_t TO subselect_source_t.
    ENDLOOP.
    SORT subselect_source_t.
    DELETE ADJACENT DUPLICATES FROM subselect_source_t.

    LOOP AT unions ASSIGNING FIELD-SYMBOL(<union>).
      <union>->parse_sql_ii( ).
      APPEND LINES OF <union>->result_source_t TO union_source_t.
    ENDLOOP.
    SORT union_source_t.
    DELETE ADJACENT DUPLICATES FROM union_source_t.

  ENDMETHOD.


  METHOD parse_sql_ii_1.
    " ---------------------------------------------------------------------------------------------------
    "  Description             : Concatenate aggregations with fieldnames                               -
    " ---------------------------------------------------------------------------------------------------
    "  Additional informations :                                                                        -
    "                                                                                                   -
    " ---------------------------------------------------------------------------------------------------
    "  Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    -
    "  Date                    : 01.01.2010               Release    : WAS 7.00                         -
    " ---------------------------------------------------------------------------------------------------
    "  Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    -
    "  Date                    : 01.03.2010                                                             -
    " ---------------------------------------------------------------------------------------------------
    "                                                                                                   -
    " -----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S ------------
    "                                                                                                   -
    "  Date       | Developer            | Description                                 |                -
    " ------------+----------------------+---------------------------------------------+-----------------
    "  24.05.2016 | Ana Lekic            | ON clause with ()                           | COCKPIT-63     -
    "             |                      |                                             | $001           -
    " ------------+----------------------+---------------------------------------------+-----------------
    "  28.12.2016 | Domi Bigl            | INT8                                        |$002 COCKPIT-148-
    " ---------------------------------------------------------------------------------------------------

    TYPES: BEGIN OF t_tab_field,
             table       TYPE string,
             field       TYPE string,
             alias       TYPE string,
             alias_field TYPE string,
             aggr        TYPE string,
             count       TYPE c LENGTH 1,
           END OF t_tab_field.

    DATA l_skip           TYPE i.
    DATA l_tabix_next     TYPE i.
    DATA l_tab_field      TYPE t_tab_field.
    DATA lt_tab_field     TYPE TABLE OF t_tab_field.
    DATA l_field_dfies    TYPE dfies.
    DATA ls_result_field  TYPE /cadaxo/sqlcdfies.
    DATA l_tabix          TYPE i.
    DATA ls_result_source LIKE LINE OF me->result_source_t.
    DATA lcl_structtype   TYPE REF TO cl_abap_structdescr.
    DATA lcl_elemdescr    TYPE REF TO cl_abap_elemdescr.
    DATA lt_fields        TYPE ddfields.
    DATA lt_source_split  TYPE TABLE OF string.
    DATA lt_column_split  TYPE TABLE OF string.
    DATA lr_ref_data      TYPE REF TO data.
    DATA l_string         TYPE string.
    DATA l_lines          TYPE i.

    FIELD-SYMBOLS <l_source_split>      TYPE string.
    FIELD-SYMBOLS <l_source_split_next> TYPE string.
    FIELD-SYMBOLS <l_column_split>      TYPE string.
    FIELD-SYMBOLS <l_column_split_next> TYPE string.
    FIELD-SYMBOLS <l_dfies>             TYPE dfies.
    FIELD-SYMBOLS <l_result_source>     LIKE LINE OF me->result_source_t.

    CLEAR: me->gt_result_ddfields,
           me->result_source_t.

    l_string = condense( me->source_syntax ).

    SPLIT l_string AT space INTO TABLE lt_source_split.

    LOOP AT lt_source_split ASSIGNING <l_source_split>.

      IF l_skip > 0.
        l_skip = l_skip - 1.
        CONTINUE.
      ENDIF.

      IF    <l_source_split> = 'INNER'
         OR <l_source_split> = 'JOIN'
         OR <l_source_split> = 'LEFT'
         OR <l_source_split> = 'OUTER'
         OR <l_source_split> = 'RIGHT'.
        CONTINUE.
      ELSEIF    <l_source_split> = 'ON'
             OR <l_source_split> = 'AND'
             OR <l_source_split> = 'OR'.

        " find next keyword to know how long to skip
        l_tabix_next = sy-tabix + 1.
        LOOP AT lt_source_split ASSIGNING <l_source_split_next> FROM l_tabix_next.
          IF    <l_source_split_next> = 'INNER'
             OR <l_source_split_next> = 'JOIN'
             OR <l_source_split_next> = 'LEFT'
             OR <l_source_split_next> = 'OUTER'
             OR <l_source_split_next> = 'RIGHT'
             OR <l_source_split_next> = 'AND'
             OR <l_source_split_next> = 'OR'.
            EXIT.
          ENDIF.
          l_skip = l_skip + 1.
        ENDLOOP.

      ELSE.
        ls_result_source-table = <l_source_split>.

        l_tabix_next = sy-tabix + 1.
        ASSIGN lt_source_split[ l_tabix_next ] TO <l_source_split_next>.
        IF sy-subrc = 0 AND <l_source_split_next> = 'AS'.
          l_tabix_next = l_tabix_next + 1.
          ASSIGN lt_source_split[ l_tabix_next ] TO <l_source_split_next>.
          IF sy-subrc = 0.
            ls_result_source-alias = <l_source_split_next>.
            APPEND ls_result_source TO me->result_source_t.
            CLEAR ls_result_source.
            l_skip = 2.
          ENDIF.
        ELSE.
          IF ls_result_source IS NOT INITIAL.
            APPEND ls_result_source TO me->result_source_t.
            CLEAR ls_result_source.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    " no special columns selected, only one table (SELECT * FROM ... )
    IF me->column_syntax = '*'.
      " create a local data, type table
      DATA l_fieldname TYPE string.
      l_lines = lines( me->result_source_t ).
      IF l_lines > 1.
        CLEAR me->column_syntax.
        LOOP AT me->result_source_t
             ASSIGNING <l_result_source>.

          cl_abap_classdescr=>describe_by_name( EXPORTING  p_name = <l_result_source>-table
                                                EXCEPTIONS OTHERS = 1 ).
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          lcl_structtype ?= cl_abap_typedescr=>describe_by_name( <l_result_source>-table ).

          lt_fields = get_ddic_field_list( lcl_structtype ).
          LOOP AT lt_fields ASSIGNING <l_dfies>.
            CLEAR ls_result_field.
            MOVE-CORRESPONDING <l_dfies> TO ls_result_field.
            ls_result_field-colhd_fieldname = ls_result_field-fieldname.

            ls_result_field-/cadaxo/alias   = <l_result_source>-alias.

            APPEND ls_result_field TO me->gt_result_ddfields.
            IF <l_result_source>-alias IS NOT INITIAL.
              CONCATENATE <l_result_source>-alias '~' ls_result_field-fieldname INTO l_fieldname.
            ELSE.
              CONCATENATE <l_result_source>-table '~' ls_result_field-fieldname INTO l_fieldname.
            ENDIF.
            CONCATENATE me->column_syntax l_fieldname INTO me->column_syntax SEPARATED BY space.
          ENDLOOP.
        ENDLOOP.

      ELSE.                                                   " FOE999

        " get the first (and normally only) row with the table information
        ASSIGN me->result_source_t[ 1 ] TO <l_result_source>.

        " create a local data, type table
        TRY.
            CREATE DATA lr_ref_data TYPE (<l_result_source>-table).

            " create a structure type by reference of the table type

            lcl_structtype ?= cl_abap_typedescr=>describe_by_data_ref( lr_ref_data ).

            " get the fields of the structure. use local buffer method
            lt_fields = get_ddic_field_list( lcl_structtype ).

            " transfer the fields to result parameter
            LOOP AT lt_fields ASSIGNING <l_dfies>.

              CLEAR ls_result_field.

              MOVE-CORRESPONDING <l_dfies> TO ls_result_field.

              ls_result_field-colhd_fieldname = ls_result_field-fieldname.

              APPEND ls_result_field TO me->gt_result_ddfields.

            ENDLOOP.
          CATCH /cadaxo/cx_sqlc_type_not_found ##NO_HANDLER.
          CATCH cx_sy_create_data_error ##NO_HANDLER.
          CATCH cx_sy_move_cast_error ##NO_HANDLER.
        ENDTRY.
      ENDIF.

      " special columns, more tables, ...
    ELSE.

      CLEAR l_skip.
      SPLIT me->column_syntax AT space INTO TABLE lt_column_split.
      LOOP AT lt_column_split ASSIGNING <l_column_split>.

        l_tabix      = sy-tabix.
        l_tabix_next = sy-tabix.

        IF l_skip > 0.
          l_skip = l_skip - 1.
          CONTINUE.
        ENDIF.

        IF    <l_column_split> = 'DISTINCT'
           OR <l_column_split> = ')'.
          CONTINUE.
        ELSEIF    <l_column_split> = 'MAX('
               OR <l_column_split> = 'MIN('
               OR <l_column_split> = 'AVG('
               OR <l_column_split> = 'SUM('
               OR <l_column_split> = 'COUNT('.
          l_tab_field-aggr = <l_column_split>.
          l_tabix_next = l_tabix_next + 1.
          ASSIGN lt_column_split[ l_tabix_next ] TO <l_column_split_next>.
          IF sy-subrc = 0.
            l_skip = l_skip + 1.
            IF <l_column_split_next> = 'DISTINCT'.
              l_tabix_next = l_tabix_next + 1.
              ASSIGN lt_column_split[ l_tabix_next ] TO <l_column_split_next>.
              IF sy-subrc = 0.
                l_skip = l_skip + 1.
              ENDIF.
            ENDIF.

            " split the field into field, table and alias
            split_field( EXPORTING i_field = <l_column_split_next>
                         IMPORTING e_field = l_tab_field-field
                                   e_table = l_tab_field-table
                                   e_alias = l_tab_field-alias ).

            l_tabix_next = l_tabix_next + 2.
            ASSIGN lt_column_split[ l_tabix_next ] TO <l_column_split_next>.
            IF sy-subrc = 0 AND <l_column_split_next> = 'AS'.
              l_skip = l_skip + 1.
              l_tabix_next = l_tabix_next + 1.
              ASSIGN lt_column_split[ l_tabix_next ] TO <l_column_split_next>.
              IF sy-subrc = 0.
                l_skip = l_skip + 1.
                l_tab_field-alias_field = <l_column_split_next>.
              ENDIF.
            ENDIF.
            APPEND l_tab_field TO lt_tab_field.
            CLEAR l_tab_field.

            l_skip = l_skip + 1.

          ENDIF.
        ELSE.

          " split the field into field, table and alias
          split_field( EXPORTING i_field = <l_column_split>
                       IMPORTING e_field = l_tab_field-field
                                 e_table = l_tab_field-table
                                 e_alias = l_tab_field-alias ).

          l_tabix_next = l_tabix + 1.
          ASSIGN lt_column_split[ l_tabix_next ] TO <l_column_split_next>.
          IF sy-subrc = 0 AND <l_column_split_next> = 'AS'.
            l_tabix_next = l_tabix_next + 1.
            ASSIGN lt_column_split[ l_tabix_next ] TO <l_column_split_next>.
            IF sy-subrc = 0.
              l_tab_field-alias_field = <l_column_split_next>.
              l_skip = 2.
            ENDIF.
          ENDIF.

          APPEND l_tab_field TO lt_tab_field.
          CLEAR l_tab_field.

        ENDIF.

      ENDLOOP.

      FIELD-SYMBOLS <l_tab_field> TYPE t_tab_field.

      LOOP AT lt_tab_field ASSIGNING <l_tab_field>.

        CLEAR l_field_dfies.

        IF <l_tab_field>-field = '*' OR <l_tab_field>-field = 'COUNT(*)'.

          lcl_elemdescr ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( '/CADAXO/SQLCAGGRCOUNT' ). " get element type

          l_field_dfies = lcl_elemdescr->get_ddic_field( ).

          MOVE-CORRESPONDING l_field_dfies TO ls_result_field.

          ls_result_field-/cadaxo/alias       = <l_tab_field>-alias.
          ls_result_field-/cadaxo/alias_field = <l_tab_field>-alias_field.

          ls_result_field-colhd_fieldname     = 'COUNT(   * )'.
          ls_result_field-scrtext_l           = 'Count( * )'.
          ls_result_field-scrtext_m           = 'Count( * )'.
          ls_result_field-scrtext_s           = 'Count( * )'.
          ls_result_field-reptext             = 'Count( * )'.
          ls_result_field-fieldtext           = 'Count( * )'.

          APPEND ls_result_field TO me->gt_result_ddfields.

        ELSE.

          TRY.
              lcl_structtype ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( <l_tab_field>-table ). " get table type

              lt_fields = get_ddic_field_list( lcl_structtype ).            " get fields (dfies)

              ASSIGN lt_fields[ fieldname = <l_tab_field>-field ] TO <l_dfies>.
              IF sy-subrc = 0.

                MOVE-CORRESPONDING <l_dfies> TO ls_result_field.

                " change the column header texts
                IF <l_tab_field>-aggr IS NOT INITIAL.

                  ls_result_field-aggr = <l_tab_field>-aggr.

                  CASE <l_tab_field>-aggr(3).
                    WHEN 'MAX'.
                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix    = 'MAX'
                                                                              CHANGING  c_sqlcdfies = ls_result_field ).
                    WHEN 'MIN'.
                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix    = 'MIN'
                                                                              CHANGING  c_sqlcdfies = ls_result_field ).
                    WHEN 'AVG'.
                      CLEAR ls_result_field-convexit.
                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix    = 'AVG'
                                                                              CHANGING  c_sqlcdfies = ls_result_field ).
                    WHEN 'SUM'.
                      CLEAR ls_result_field-convexit.
                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix    = 'SUM'
                                                                              CHANGING  c_sqlcdfies = ls_result_field ).

                      ls_result_field-domname  = ''.
                      ls_result_field-rollname = ''.

                      CASE ls_result_field-datatype.
                        WHEN 'CURR' OR 'DEC' OR 'QUAN'.
                          ls_result_field-leng   = 31.
                          ls_result_field-intlen = 16.
                        WHEN 'INT1' OR 'INT2' OR 'INT4' OR 'INT8'.                         "$002
                          ls_result_field-datatype = 'DEC'.
                          ls_result_field-inttype  = 'P'.
                          ls_result_field-leng     = 31.
                          ls_result_field-intlen   = 16.
                          ls_result_field-decimals = 0.
                      ENDCASE.

                    WHEN 'COU'.
                      CLEAR ls_result_field-convexit.
                      ls_result_field-rollname = '/CADAXO/SQLCAGGRCOUNT'.
                      lcl_elemdescr ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( '/CADAXO/SQLCAGGRCOUNT' ). " get element type
                      l_field_dfies = lcl_elemdescr->get_ddic_field( ).

                      MOVE-CORRESPONDING l_field_dfies TO ls_result_field.

                      ls_result_field-scrtext_m = <l_dfies>-scrtext_m.
                      ls_result_field-scrtext_s = <l_dfies>-scrtext_s.
                      ls_result_field-reptext   = <l_dfies>-reptext.
                      ls_result_field-fieldtext = <l_dfies>-fieldtext.

                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix    = 'COUNT'
                                                                              CHANGING  c_sqlcdfies = ls_result_field ).
                  ENDCASE.
                ELSE.
                  ls_result_field-colhd_fieldname = ls_result_field-fieldname.
                  CLEAR ls_result_field-aggr.
                ENDIF.

                ls_result_field-/cadaxo/alias       = <l_tab_field>-alias.
                ls_result_field-/cadaxo/alias_field = <l_tab_field>-alias_field.

                " append field attributes to return table
                APPEND ls_result_field TO me->gt_result_ddfields.

              ENDIF.
            CATCH /cadaxo/cx_sqlc_type_not_found ##NO_HANDLER.
            CATCH cx_sy_create_data_error ##NO_HANDLER.
            CATCH cx_sy_move_cast_error ##NO_HANDLER.

          ENDTRY.

        ENDIF.

      ENDLOOP.

    ENDIF.
  ENDMETHOD.


  METHOD parse_sql_ii_2.

    CONSTANTS: join_alias_regex TYPE string VALUE '^([[:word:]/]+)(?:\s+AS\s+([[:word:]/]+)|[[:word:]/]+|.*).*$'.

    TYPES: BEGIN OF t_tab_field,
             table       TYPE string,
             field       TYPE string,
             alias       TYPE string,
             alias_field TYPE string,
             aggr        TYPE string,
             count(1)    TYPE c,
           END OF t_tab_field.

    TYPES: BEGIN OF typ_source_ddfields,
             table    TYPE c LENGTH 30,
             ddfields TYPE ddfields,
           END OF typ_source_ddfields.

    DATA l_skip             TYPE i.
    DATA l_tabix_next       TYPE i.
    DATA l_tab_field        TYPE t_tab_field.
    DATA lt_tab_field       TYPE TABLE OF t_tab_field.
    DATA l_field_dfies      TYPE dfies.
    DATA ls_result_field    TYPE /cadaxo/sqlcdfies.
    DATA lcl_structtype     TYPE REF TO cl_abap_structdescr.
    DATA lcl_elemdescr      TYPE REF TO cl_abap_elemdescr.
    DATA lt_fields          TYPE ddfields.
    DATA lt_column_split    TYPE TABLE OF string.
    DATA lr_ref_data        TYPE REF TO data.
    DATA sql_string         TYPE string.
    DATA l_lines            TYPE i.
    DATA l_cols             TYPE string.
    DATA lr_struct          TYPE REF TO cl_abap_structdescr.
    DATA lt_source_ddfields TYPE TABLE OF typ_source_ddfields.

    FIELD-SYMBOLS <l_source_split_next> TYPE string.
    FIELD-SYMBOLS <l_column_split>      TYPE string.
    FIELD-SYMBOLS <l_column_split_next> TYPE string.
    FIELD-SYMBOLS <l_dfies>             TYPE dfies.
    FIELD-SYMBOLS <l_result_source>     LIKE LINE OF me->result_source_t.

    CLEAR: l_skip,
           me->gt_result_ddfields,
           me->result_source_t.

    sql_string = condense( me->source_syntax ).

    /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = sql_string ).
    SPLIT sql_string AT | JOIN | INTO TABLE DATA(joins).

    LOOP AT joins ASSIGNING FIELD-SYMBOL(<join>).
      TRY.
          FIND REGEX join_alias_regex IN <join> SUBMATCHES DATA(l_table) DATA(l_alias). "FOE $002
        CATCH cx_sy_regex_too_complex INTO DATA(regex_ex).
          SPLIT <join> AT | ON | INTO DATA(table) DATA(onclause).
          IF sy-subrc <> 0.
            FIND REGEX join_alias_regex IN <join> SUBMATCHES l_table l_alias. "Exception!
          ELSE.
            FIND REGEX join_alias_regex IN table SUBMATCHES l_table l_alias.
          ENDIF.
      ENDTRY.
      IF sy-subrc = 0.
        APPEND VALUE #( table = l_table alias = l_alias ) TO me->result_source_t.
      ENDIF.
    ENDLOOP.

    LOOP AT me->result_source_t ASSIGNING FIELD-SYMBOL(<source>).
      APPEND INITIAL LINE TO lt_source_ddfields ASSIGNING FIELD-SYMBOL(<source_ddfields>).
      <source_ddfields>-table = <source>-table.
      lr_struct ?= cl_abap_structdescr=>describe_by_name( <source>-table ).
      <source_ddfields>-ddfields = lr_struct->get_ddic_field_list( ).
    ENDLOOP.

    CLEAR column_words_t.
* no special columns selected, only one table (SELECT * FROM ... )
    IF me->column_syntax EQ '*' OR me->column_syntax CS '~*'.
* create a local data, type table

      DESCRIBE TABLE me->result_source_t LINES l_lines.
      IF l_lines GT 1.
        LOOP AT me->result_source_t
             ASSIGNING <l_result_source>.

          l_cols = me->column_syntax.
          /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = l_cols ).
          SPLIT l_cols AT space INTO TABLE me->column_words_t.

          cl_abap_classdescr=>describe_by_name( EXPORTING  p_name = <l_result_source>-table
                                                EXCEPTIONS OTHERS = 1 ).
          IF sy-subrc EQ 0.

            lcl_structtype ?= cl_abap_typedescr=>describe_by_name(  <l_result_source>-table ).

            lt_fields = me->get_ddic_field_list( lcl_structtype ).
            LOOP AT lt_fields ASSIGNING <l_dfies>.
              CLEAR ls_result_field.
              MOVE-CORRESPONDING <l_dfies> TO ls_result_field.
              MOVE ls_result_field-fieldname TO ls_result_field-colhd_fieldname.

              ls_result_field-/cadaxo/alias = <l_result_source>-alias.

              APPEND ls_result_field TO me->gt_result_ddfields.
            ENDLOOP.

          ENDIF.
        ENDLOOP.

      ELSE.
        READ TABLE me->result_source_t INDEX 1 ASSIGNING <l_result_source>.

        TRY.
            CREATE DATA lr_ref_data TYPE (<l_result_source>-table).

            lcl_structtype ?= cl_abap_typedescr=>describe_by_data_ref( lr_ref_data ).

            lt_fields = me->get_ddic_field_list( lcl_structtype ).

            LOOP AT lt_fields ASSIGNING <l_dfies>.

              CLEAR ls_result_field.

              MOVE-CORRESPONDING <l_dfies> TO ls_result_field.

              MOVE ls_result_field-fieldname TO ls_result_field-colhd_fieldname.

              APPEND ls_result_field TO me->gt_result_ddfields.

            ENDLOOP.
          CATCH /cadaxo/cx_sqlc_type_not_found ##NO_HANDLER.
          CATCH cx_sy_create_data_error ##NO_HANDLER.
          CATCH cx_sy_move_cast_error ##NO_HANDLER.
        ENDTRY.
      ENDIF.

* special columns, more tables, ...
    ELSE.

      CLEAR: l_skip.

      DATA l_string_check  TYPE string.
      DATA l_string_append TYPE string.
      DATA l_pos           TYPE i.
      DATA l_on_apostrophe TYPE boolean.
      DATA l_on_bracket    TYPE i.
      l_string_check =  me->column_syntax.

      CLEAR: l_string_append,
             l_on_apostrophe,
             l_on_bracket.

      DO.

        TRY.
            l_string_check = me->column_syntax+l_pos(1).
            l_pos = l_pos + 1.
          CATCH cx_sy_range_out_of_bounds.
            IF l_string_append IS NOT INITIAL.
              SHIFT l_string_append LEFT DELETING LEADING space.
              APPEND l_string_append TO lt_column_split.
            ENDIF.
            EXIT.
        ENDTRY.

        CASE l_string_check.
          WHEN '('.
            IF l_on_apostrophe = abap_false.
              l_on_bracket = l_on_bracket + 1.
            ENDIF.
          WHEN ')'.
            IF l_on_apostrophe = abap_false.
              l_on_bracket = l_on_bracket - 1.
            ENDIF.
          WHEN '´' OR ''''.
            IF l_on_apostrophe = space.
              l_on_apostrophe = abap_true.
            ELSE.
              l_on_apostrophe = abap_false.
            ENDIF.
          WHEN ','.
            IF l_on_apostrophe = abap_false AND l_on_bracket = 0.
              SHIFT l_string_append LEFT DELETING LEADING space.
              APPEND l_string_append TO lt_column_split.
              CLEAR l_string_append.
              CONTINUE.
            ENDIF.
        ENDCASE.

        l_string_append = l_string_append && l_string_check.

      ENDDO.


      LOOP AT lt_column_split ASSIGNING <l_column_split>.

        <l_column_split> = replace( val = <l_column_split> regex = ',$' with = space ).

        l_tabix_next = sy-tabix.

        IF l_skip GT 0.
          l_skip = l_skip - 1.
          CONTINUE.
        ENDIF.

        IF <l_column_split> EQ 'DISTINCT' OR
           <l_column_split> EQ ')'.
          CONTINUE.
        ELSEIF <l_column_split> EQ 'MAX(' OR
               <l_column_split> EQ 'MIN(' OR
               <l_column_split> EQ 'AVG(' OR
               <l_column_split> EQ 'SUM(' OR
               <l_column_split> EQ 'COUNT('.
          MOVE <l_column_split> TO l_tab_field-aggr.
          l_tabix_next = l_tabix_next + 1.
          READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
          IF sy-subrc EQ 0.
            l_skip = l_skip + 1.
            IF <l_column_split_next> EQ 'DISTINCT'.
              l_tabix_next = l_tabix_next + 1.
              READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
              IF sy-subrc EQ 0.
                l_skip = l_skip + 1.
              ENDIF.
            ENDIF.

* split the field into field, table and alias
            split_field( EXPORTING i_field = <l_column_split_next>
                         IMPORTING e_field = l_tab_field-field
                                   e_table = l_tab_field-table
                                   e_alias = l_tab_field-alias ).

            l_tabix_next = l_tabix_next + 2.
            READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
            IF sy-subrc EQ 0 AND <l_column_split_next> EQ 'AS'.
              l_skip = l_skip + 1.
              l_tabix_next = l_tabix_next + 1.
              READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
              IF sy-subrc EQ 0.
                <l_column_split_next> = replace( val = <l_column_split_next> regex = ',$' with = space ).
                l_skip = l_skip + 1.
                MOVE <l_column_split_next> TO l_tab_field-alias_field.
              ENDIF.
            ENDIF.
            APPEND l_tab_field TO lt_tab_field.
            CLEAR l_tab_field.

            l_skip = l_skip + 1.

          ENDIF.
        ELSE.

          CLEAR l_tab_field.

          me->split_field_v_2(
            EXPORTING
              i_value       = <l_column_split>
            IMPORTING
              e_table       = l_tab_field-table
              e_field       = l_tab_field-field
              e_alias       = l_tab_field-alias
              e_alias_field = l_tab_field-alias_field ).

          APPEND l_tab_field TO lt_tab_field.

        ENDIF.

      ENDLOOP.

      FIELD-SYMBOLS: <l_tab_field> TYPE t_tab_field.

      LOOP AT lt_tab_field ASSIGNING <l_tab_field>.

        CLEAR l_field_dfies.
        CLEAR ls_result_field.

        IF <l_tab_field>-field EQ '*' OR <l_tab_field>-field EQ 'COUNT(*)' OR <l_tab_field>-field EQ 'COUNT( * )'.

          lcl_elemdescr ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( '/CADAXO/SQLCAGGRCOUNT' ). "get element type

          l_field_dfies = lcl_elemdescr->get_ddic_field( ).

          ls_result_field = CORRESPONDING #( l_field_dfies ).

          ls_result_field-/cadaxo/alias = <l_tab_field>-alias.
          ls_result_field-/cadaxo/alias_field = <l_tab_field>-alias_field.

          MOVE 'COUNT(   * )' TO   ls_result_field-colhd_fieldname.
          MOVE 'Count( * )' TO : ls_result_field-scrtext_l,
                                 ls_result_field-scrtext_m,
                                 ls_result_field-scrtext_s,
                                 ls_result_field-reptext,
                                 ls_result_field-fieldtext.

          APPEND ls_result_field TO me->gt_result_ddfields.

        ELSE.

          TRY.

              IF <l_tab_field>-table IS INITIAL.

                LOOP AT lt_source_ddfields ASSIGNING <source_ddfields>.

                  READ TABLE <source_ddfields>-ddfields WITH KEY fieldname = <l_tab_field>-field ASSIGNING FIELD-SYMBOL(<ddfields_field>).
                  IF sy-subrc = 0.
                    ls_result_field = CORRESPONDING #( <ddfields_field> ).
                    ls_result_field-/cadaxo/alias_field = <l_tab_field>-alias_field.
                    ls_result_field-/cadaxo/alias = <l_tab_field>-alias.
                    APPEND ls_result_field TO me->gt_result_ddfields.
                    EXIT.
                  ELSE.
                    CLEAR ls_result_field.
                    ls_result_field-/cadaxo/alias_field = <l_tab_field>-alias_field.
                    ls_result_field-/cadaxo/alias_value = <l_tab_field>-field.
                    APPEND ls_result_field TO me->gt_result_ddfields.
                    EXIT.
                  ENDIF.
                ENDLOOP.

                CONTINUE.

              ENDIF.

              lcl_structtype ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( <l_tab_field>-table ). "get table type

              lt_fields = me->get_ddic_field_list( lcl_structtype ).            "get fields (dfies)

              READ TABLE lt_fields WITH KEY fieldname = <l_tab_field>-field ASSIGNING <l_dfies>.
              IF sy-subrc EQ 0.

                MOVE-CORRESPONDING <l_dfies> TO ls_result_field.

* change the column header texts
                IF NOT <l_tab_field>-aggr IS INITIAL.

                  MOVE <l_tab_field>-aggr TO ls_result_field-aggr.

                  CASE <l_tab_field>-aggr(3).
                    WHEN 'MAX'.
                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'MAX' CHANGING c_sqlcdfies = ls_result_field ).
                    WHEN 'MIN'.
                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'MIN' CHANGING c_sqlcdfies = ls_result_field ).
                    WHEN 'AVG'.
                      CLEAR ls_result_field-convexit.
                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'AVG' CHANGING c_sqlcdfies = ls_result_field ).
                    WHEN 'SUM'.
                      CLEAR  ls_result_field-convexit.
                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'SUM' CHANGING c_sqlcdfies = ls_result_field ).

                      ls_result_field-domname = ''.
                      ls_result_field-rollname = ''.

                      CASE ls_result_field-datatype.
                        WHEN 'CURR' OR 'DEC' OR 'QUAN'.
                          ls_result_field-leng     = 31.
                          ls_result_field-intlen   = 16.
                        WHEN 'INT1' OR 'INT2' OR 'INT4' OR 'INT8'.                         "$003
                          ls_result_field-datatype  = 'DEC'.
                          ls_result_field-inttype   = 'P'.
                          ls_result_field-leng      = 31.
                          ls_result_field-intlen    = 16.
                          ls_result_field-decimals  = 0.
                      ENDCASE.

                    WHEN 'COU'.
                      CLEAR ls_result_field-convexit.
                      MOVE '/CADAXO/SQLCAGGRCOUNT' TO ls_result_field-rollname.
                      lcl_elemdescr ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( '/CADAXO/SQLCAGGRCOUNT' ). "get element type
                      l_field_dfies = lcl_elemdescr->get_ddic_field( ).

                      MOVE-CORRESPONDING l_field_dfies TO ls_result_field.

                      MOVE: <l_dfies>-scrtext_m TO ls_result_field-scrtext_m,
                            <l_dfies>-scrtext_s TO ls_result_field-scrtext_s,
                            <l_dfies>-reptext   TO ls_result_field-reptext,
                            <l_dfies>-fieldtext TO ls_result_field-fieldtext.

                      /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'COUNT' CHANGING c_sqlcdfies = ls_result_field ).
                  ENDCASE.
                ELSE.
                  MOVE ls_result_field-fieldname TO ls_result_field-colhd_fieldname.
                  CLEAR ls_result_field-aggr.
                ENDIF.

                ls_result_field-/cadaxo/alias = <l_tab_field>-alias.
                ls_result_field-/cadaxo/alias_field = <l_tab_field>-alias_field.

* append field attributes to return table
                APPEND ls_result_field TO me->gt_result_ddfields.

              ENDIF.

            CATCH /cadaxo/cx_sqlc_type_not_found ##NO_HANDLER.
            CATCH cx_sy_create_data_error ##NO_HANDLER.
            CATCH cx_sy_move_cast_error ##NO_HANDLER.

          ENDTRY.

        ENDIF.

      ENDLOOP.

    ENDIF.

    LOOP AT me->gt_result_ddfields ASSIGNING FIELD-SYMBOL(<result_ddfield_ref>) WHERE reftable IS NOT INITIAL AND reffield IS NOT INITIAL.
      READ TABLE me->gt_result_ddfields WITH KEY tabname = <result_ddfield_ref>-reftable fieldname = <result_ddfield_ref>-reffield ASSIGNING FIELD-SYMBOL(<result_ddfield>).
      IF sy-subrc = 0 AND <result_ddfield>-/cadaxo/alias_field IS NOT INITIAL.
        <result_ddfield_ref>-reffield = <result_ddfield>-/cadaxo/alias_field.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD parse_sql_where_columns.
    " ---------------------------------------------------------------------------------------------------
    "  Description             : PARSE SQL WHERE COLUMNS                                                -
    " ---------------------------------------------------------------------------------------------------
    "  Additional informations :                                                                        -
    "                                                                                                   -
    " ---------------------------------------------------------------------------------------------------
    "  Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    -
    "  Date                    : 01.01.2010               Release    : WAS 7.00                         -
    " ---------------------------------------------------------------------------------------------------
    "  Qual. Check(opt.)       : xxxxxxxxxxxx             Company    : xxxxxxxxx                        -
    "  Date                    : xx.xx.xxxx                                                             -
    " ---------------------------------------------------------------------------------------------------
    "                                                                                                   -
    " -----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S ------------
    "                                                                                                   -
    "  Date       | Developer            | Description                                 |                -
    " ------------+----------------------+---------------------------------------------+-----------------
    "  04.01.2012 | Fößleitner Johann    | add '=>, =<, ><'                            | CDX001-0031    -
    "             |                      |                                             |                -
    " ------------+----------------------+---------------------------------------------+-----------------
    "  24.05.2012 | Fößleitner Johann    | Bugfixing symbolname used in like           | "CDX130-008    -
    "             |                      |                                             |                -
    " ------------+----------------------+---------------------------------------------+-----------------
    "  01.06.2012 | Ana Lekic            |format value in where (for timestamps)       | CDX130-018     -
    "             |                      |                                             |                -
    " ------------+----------------------+---------------------------------------------+-----------------
    "  09.05.2014 | Domi Bigl            | no decimal . for P decimals 0               | RT229          -
    " ------------+----------------------+---------------------------------------------+-----------------
    "  10.06.2016 | Ana Lekic            | Fehler beim replace vom wert                | Cockpit-65     -
    " ---------------------------------------------------------------------------------------------------

    DATA l_space_string       TYPE string.
    DATA l_offset             TYPE i.
    DATA l_from               TYPE i.
    DATA l_string             TYPE string.
    DATA l_match              TYPE i.
    DATA lr_abap_type         TYPE REF TO cl_abap_elemdescr.
    DATA where_col            TYPE /cadaxo/sqlcwherecol_str.
    DATA l_wc_nr              TYPE n LENGTH 3.
    DATA l_wildcard_operator  TYPE c LENGTH 6.
    DATA l_wildcard_condition TYPE c LENGTH 6.
    DATA l_total_len          TYPE i.
    DATA lt_stringtab         TYPE stringtab.
    DATA l_symbol             TYPE /cadaxo/sqlcsymbol_name.
    DATA l_is_subsel          TYPE char1.
    DATA l_length_check       TYPE i.
    DATA l_length_check_2     TYPE i.
    DATA l_message            TYPE string.
    DATA l_from_save          TYPE i.
    DATA l_symbol_value       TYPE /cadaxo/sqlcsymbol_value.
    DATA l_spc_replaced       TYPE flag. " RT229
    DATA l_added              TYPE i.
    DATA lr_field             TYPE REF TO data.
    DATA l_fieldname          TYPE string.
    DATA l_strlen             TYPE i.
    DATA l_string2            TYPE string.
    DATA lt_result_source_tmp LIKE me->result_source_t.     " CDX3301
    DATA l_off_f              TYPE i.
    DATA l_off_w              TYPE i.
    DATA l_len                TYPE i.
    DATA l_str                TYPE string.
    DATA lt_source_split      TYPE TABLE OF string.
    DATA l_skip               TYPE i.
    DATA l_tabix_next         TYPE i.
    DATA ls_result_source     LIKE LINE OF me->result_source_t.
    DATA l_do_times           TYPE i.
    DATA l_open               TYPE c LENGTH 1.
    DATA l_open_string        TYPE c LENGTH 1.
    DATA l_open_symbol        TYPE c LENGTH 1.
    DATA l_from_symbol        TYPE i.
    DATA l_to_symbol          TYPE i.
    FIELD-SYMBOLS <l_field>             TYPE any.
    FIELD-SYMBOLS <ls_string>           TYPE string.
    FIELD-SYMBOLS <l_source_split>      TYPE string.
    FIELD-SYMBOLS <l_source_split_next> TYPE string.

    CONCATENATE '' '' INTO l_space_string SEPARATED BY space.

    CLEAR: l_from,
           me->gt_sql_where_col_tab_t,
           me->where_syntax_wildcard.

    " condense the string
    /cadaxo/cl_sqlc_cockpit_assist=>condense( CHANGING c_string = me->where_syntax ).

    l_total_len = strlen( me->where_syntax ).

    lt_result_source_tmp = me->result_source_t.             " CDX3301

    WHILE l_from < l_total_len.

      FIND FIRST OCCURRENCE OF l_space_string IN SECTION OFFSET l_from OF me->where_syntax MATCH OFFSET l_match.
      IF sy-subrc = 0.
        l_offset = l_match - l_from.
        l_string = me->where_syntax+l_from(l_offset).

        l_from_save = l_from.

        l_from = l_match + 1.

        CASE l_string.
          WHEN '=' OR 'EQ' OR '<>' OR 'NE' OR '<' OR 'LT' OR '>' OR 'GT' OR '<=' OR 'LE' OR '>=' OR 'GE' OR '=>' OR '=<' OR '><'. " CDX001-0031
            CASE l_string.
              WHEN '='.
                where_col-operator = 'EQ'.
              WHEN '<>'.
                where_col-operator = 'NE'.
              WHEN '><'.                         " CDX001-0031
                where_col-operator = 'NE'.
                REPLACE SECTION OFFSET l_from_save LENGTH l_offset OF me->where_syntax WITH '<>'.
              WHEN '<'.
                where_col-operator = 'LT'.
              WHEN '>'.
                where_col-operator = 'GT'.
              WHEN '<='.
                where_col-operator = 'LE'.
              WHEN '=<'.                         " CDX001-0031
                where_col-operator = 'LE'.
                REPLACE SECTION OFFSET l_from_save LENGTH l_offset OF me->where_syntax WITH '<='.
              WHEN '>='.
                where_col-operator = 'GE'.
              WHEN '=>'.
                where_col-operator = 'GE'.
                REPLACE SECTION OFFSET l_from_save LENGTH l_offset OF me->where_syntax WITH '>='.
              WHEN OTHERS.
                where_col-operator = l_string.
            ENDCASE.

            /cadaxo/cl_sqlc_cockpit_assist=>get_where_value_match_offset( EXPORTING i_from         = l_from
                                                                                    i_total_length = l_total_len
                                                                          CHANGING  c_where_syntax = me->where_syntax
                                                                                    c_offset       = l_match ).

            l_offset = l_match - l_from.

            IF sy-subrc = 0 AND l_offset <> 0.
              where_col-value = me->where_syntax+l_from(l_offset).
            ELSE.
              where_col-value = me->where_syntax+l_from.
            ENDIF.

            " replace SPACE with ''
            CLEAR l_spc_replaced.
            IF where_col-value = 'SPACE'.
              where_col-value = ''''''.
              l_spc_replaced = abap_true.
            ENDIF.

            " bring the value in right format CDX130-018
            IF lr_abap_type IS NOT INITIAL.
              CLEAR l_added.                                  " RT229
              format_value( EXPORTING i_abap_type = lr_abap_type           " CDX130-018 Begin
                            IMPORTING e_added     = l_added  " RT229
                            CHANGING  c_where_col = where_col ).
            ENDIF.

            IF where_col-type_kind CA 'bsI' AND where_col-value CO '-0123456789 '.
              IF    ( where_col-type_kind = 'b' AND where_col-value > 255 )
                 OR ( where_col-type_kind = 's' AND ( where_col-value > 32767      OR where_col-value < -32767 ) )
                 OR ( where_col-type_kind = 'I' AND ( where_col-value > 2147483647 OR where_col-value < -2147483648 ) ).
                RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value
                  EXPORTING
                    value = where_col-value
                    field = CONV #( where_col-fieldname ).
              ENDIF.
            ENDIF.

            " check value of "P" fields
            IF where_col-type_kind = 'P'." AND where_col-value CO '0123456789.,'''' '.
              IF subquery = abap_true.
                FIND REGEX '\( SELECT' IN where_col-value.
                IF sy-subrc = 0.
                  DATA(is_subselect) = abap_true.
                ENDIF.
              ENDIF.
              IF is_subselect = abap_false.
                CREATE DATA lr_field TYPE HANDLE lr_abap_type.
                ASSIGN lr_field->* TO <l_field>.

                l_strlen = strlen( where_col-value ) - 1.

                l_string2 = where_col-value.

                IF l_string2+l_strlen(1) = `'`.
                  l_string2 = l_string2(l_strlen).
                ENDIF.

                IF l_string2(1) = `'`.
                  l_strlen = l_strlen - 1.
                  l_string2 = l_string2+1.
                ENDIF.
                TRY.
                    <l_field> = l_string2.
                  CATCH cx_sy_conversion_no_number.
                    l_fieldname = where_col-fieldname.
                    RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value
                      EXPORTING
                        value = where_col-value
                        field = l_fieldname.
                ENDTRY.
              ENDIF.
            ENDIF.

            IF l_offset <> 0.
              REPLACE ALL OCCURRENCES OF me->where_syntax+l_from(l_offset)
                      IN SECTION OFFSET l_from LENGTH l_offset OF me->where_syntax WITH where_col-value. " cockpit-65
            ELSE.
              REPLACE ALL OCCURRENCES OF me->where_syntax+l_from
                      IN SECTION OFFSET l_from LENGTH l_offset OF me->where_syntax WITH where_col-value. " cockpit-65
            ENDIF.                                                          " CDX130-018 End

            IF l_spc_replaced = abap_true.
              l_offset = 2.
              l_match = l_match - 3.
              l_total_len = strlen( me->where_syntax ).
            ENDIF.

            IF l_added > 0.                                   " RT229
              l_offset = l_offset + l_added.                  " RT229
              l_match = l_match + l_added.                    " RT229
              l_total_len = strlen( me->where_syntax ).       " RT229
            ENDIF.                                            " RT229

            " wildcard
            l_wc_nr = l_wc_nr + 1.

            CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
            CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

            where_col-wildcard_operator  = l_wildcard_operator.
            where_col-wildcard_condition = l_wildcard_condition.

            CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

            APPEND where_col TO me->gt_sql_where_col_tab_t.
            CLEAR where_col.

            IF l_match > l_from.
              l_from = l_match + 1.
            ENDIF.

          WHEN 'NOT'. " BETWEEN, LIKE, IN, IS NULL'
*          CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
            IF where_col-fieldname = space.
              where_col-not = 'X'.
            ELSE.
              where_col-operator_pre = 'NOT'.
            ENDIF.
          WHEN 'BETWEEN'. " BETWEEN a AND b"

            where_col-operator = l_string.

            " split the string at space
            lt_stringtab = /cadaxo/cl_sqlc_cockpit_assist=>split( i_sql_string    = me->where_syntax
                                                                  i_position_from = l_from ).

            LOOP AT lt_stringtab FROM 1 TO 3 ASSIGNING <ls_string>.
              CONCATENATE where_col-value <ls_string> INTO where_col-value SEPARATED BY space.
            ENDLOOP.

            SHIFT where_col-value LEFT DELETING LEADING l_space_string.

            l_match = l_from + strlen( where_col-value ).

            l_wc_nr = l_wc_nr + 1.

            CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
            CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

            where_col-wildcard_operator  = l_wildcard_operator.
            where_col-wildcard_condition = l_wildcard_condition.

            CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

            APPEND where_col TO me->gt_sql_where_col_tab_t.
            CLEAR where_col.

            IF l_match > l_from.
              l_from = l_match + 1.
            ENDIF.

          WHEN 'LIKE'.

            where_col-operator = l_string.

            /cadaxo/cl_sqlc_cockpit_assist=>get_where_value_match_offset( EXPORTING i_from         = l_from
                                                                                    i_total_length = l_total_len
                                                                          CHANGING  c_where_syntax = me->where_syntax
                                                                                    c_offset       = l_match ).

            l_offset = l_match - l_from.

            where_col-value = me->where_syntax+l_from(l_offset).

            " get symbol value
            FIND REGEX '&(\w|/)+&' IN where_col-value.      " CDX130-008
            IF sy-subrc = 0.                                 " CDX130-008
              l_symbol = where_col-value.              " CDX130-008
              /cadaxo/cl_sqlc_cockpit_assist=>get_global_symbol_value( " CDX130-008
                                                                       EXPORTING                                   " CDX130-008
                                                                                 i_symbol       = l_symbol                " CDX130-008
                                                                                 i_field_type   = where_col-type_kind   " CDX130-008
                                                                       IMPORTING                                   " CDX130-008
                                                                                 e_symbol_value = l_symbol_value ).       " CDX130-008
              l_length_check = strlen( l_symbol_value ).      " CDX130-008

              IF l_symbol_value CP '''*'.                     " CDX130-008
                l_length_check = l_length_check - 1.          " CDX130-008
              ENDIF.                                          " CDX130-008

              IF l_symbol_value CP '*'''.                     " CDX130-008
                l_length_check = l_length_check - 1.          " CDX130-008
              ENDIF.                                          " CDX130-008

            ELSE.
              l_length_check = l_offset.

              IF where_col-value CP '''*'.
                l_length_check = l_length_check - 1.
              ENDIF.

              IF where_col-value CP '*'''.
                l_length_check = l_length_check - 1.
              ENDIF.

            ENDIF.

            l_length_check_2 = where_col-fieldlength * 2.

            IF l_length_check > l_length_check_2.
              MESSAGE e071(/cadaxo/sqlc) WITH where_col-tablefield l_length_check_2 INTO l_message.
              RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
                EXPORTING
                  message = l_message.
            ENDIF.

            " wildcard
            l_wc_nr = l_wc_nr + 1.

            CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
            CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

            where_col-wildcard_operator  = l_wildcard_operator.
            where_col-wildcard_condition = l_wildcard_condition.

            CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

            APPEND where_col TO me->gt_sql_where_col_tab_t.
            CLEAR where_col.

            IF l_match > l_from.
              l_from = l_match + 1.
            ENDIF.

          WHEN 'IN' OR 'EXISTS'.   "(x, y, ... )
            l_is_subsel = abap_false.
            FIND 'SELECT' IN SECTION OFFSET l_from OF me->where_syntax.
            IF sy-subrc = 0.
              l_is_subsel = abap_true.
            ENDIF.

            IF l_is_subsel = abap_true.

              IF where_col-operator_pre = 'NOT' OR where_col-not = 'X'.
                CONCATENATE me->where_syntax_wildcard 'NOT' l_string INTO me->where_syntax_wildcard SEPARATED BY space.
              ELSE.
                CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
              ENDIF.

              " CDX3301 Begin

              " CLEAR where_col. "DB
              " find in subselect the tables
              FIND 'FROM' IN SECTION OFFSET l_from OF me->where_syntax MATCH OFFSET l_off_f MATCH LENGTH l_len.
              IF sy-subrc = 0.
                l_off_f = l_off_f + l_len.
                FIND 'WHERE' IN SECTION OFFSET l_from OF me->where_syntax MATCH OFFSET l_off_w MATCH LENGTH l_len.
                IF sy-subrc = 0.
                  l_off_w = l_off_w - l_off_f.

                  l_str = me->where_syntax+l_off_f(l_off_w).
                  l_str = condense( l_str ).
                  SPLIT l_str AT space INTO TABLE lt_source_split.
                  LOOP AT lt_source_split ASSIGNING <l_source_split>.
                    IF l_skip > 0.
                      l_skip = l_skip - 1.
                      CONTINUE.
                    ENDIF.
                    IF    <l_source_split> = 'INNER'
                       OR <l_source_split> = 'JOIN'
                       OR <l_source_split> = 'LEFT'
                       OR <l_source_split> = 'OUTER'.
                      CONTINUE.
                    ELSEIF    <l_source_split> = 'ON'
                           OR <l_source_split> = 'AND'.
                      l_skip = 3.
                      CONTINUE.
                    ELSE.
                      ls_result_source-table = <l_source_split>.
                      " MOVE <l_source_split> TO where_col-tablename."DB
                      l_tabix_next = sy-tabix + 1.
                      ASSIGN lt_source_split[ l_tabix_next ] TO <l_source_split_next>.
                      IF sy-subrc = 0 AND <l_source_split_next> = 'AS'.
                        l_tabix_next = l_tabix_next + 1.
                        ASSIGN lt_source_split[ l_tabix_next ] TO <l_source_split_next>.
                        IF sy-subrc = 0.
                          ls_result_source-alias = <l_source_split_next>.
                          APPEND ls_result_source TO me->result_source_t.
                          CLEAR ls_result_source.
                          l_skip = 2.
                        ENDIF.
                      ELSE.
                        IF ls_result_source IS NOT INITIAL.
                          APPEND ls_result_source TO me->result_source_t.
                          CLEAR ls_result_source.
                        ENDIF.
                      ENDIF.
                    ENDIF.
                  ENDLOOP.

                  DATA l_offs TYPE i.
                  l_offs = l_off_w + l_off_f - l_from + l_len.
                  CONCATENATE me->where_syntax_wildcard me->where_syntax+l_from(l_offs) INTO me->where_syntax_wildcard SEPARATED BY space.

                ELSE. " no where condition

                ENDIF.
              ENDIF.
              " CDX3301 End
              " begin of insert-429
            ELSEIF l_string = 'IN'.
              where_col-operator = 'IN'.

              /cadaxo/cl_sqlc_cockpit_assist=>get_where_value_match_offset( EXPORTING i_from         = l_from
                                                                                      i_total_length = l_total_len
                                                                            CHANGING  c_where_syntax = me->where_syntax
                                                                                      c_offset       = l_match ).

              l_offset = l_match - l_from.

              where_col-value = me->where_syntax+l_from(l_offset).

              l_wc_nr = l_wc_nr + 1.
              CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
              CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

              where_col-wildcard_operator  = l_wildcard_operator.
              where_col-wildcard_condition = l_wildcard_condition.
              CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

              APPEND where_col TO me->gt_sql_where_col_tab_t.
              CLEAR where_col.

              IF l_match > l_from.
                l_from = l_match + 1.
              ENDIF.
              CONTINUE.
              " end   of insert-429

            ENDIF.

            where_col-operator = l_string.



            CLEAR l_open.
            CLEAR l_open_string.
            CLEAR l_open_symbol.
            CLEAR l_from_symbol.
            CLEAR l_to_symbol.

            l_do_times = l_total_len - l_from.

            l_offset = l_from.

            DO l_do_times TIMES.

              CASE me->where_syntax+l_offset(1).
                WHEN '('.
                  IF l_open_string IS INITIAL AND l_open_symbol IS INITIAL.
                    TRANSLATE l_open USING ' XX '.
                    l_offset = l_offset + 1.
                    CONTINUE.
                  ENDIF.
                WHEN ')'.
                  IF l_open_string IS INITIAL AND l_open_symbol IS INITIAL AND l_open IS NOT INITIAL.
                    TRANSLATE l_open USING ' XX '.
                    EXIT.
                  ENDIF.
                WHEN ''''.
                  TRANSLATE l_open_string USING ' XX '.
                  l_offset = l_offset + 1.
                  CONTINUE.
                WHEN '&'.
                  IF l_open_string IS INITIAL.
                    IF l_open_symbol = 'X'.
                      l_to_symbol = l_offset - l_from_symbol + 1.
                      l_symbol = me->where_syntax+l_from_symbol(l_to_symbol).

*                    /cadaxo/cl_sqlc_cockpit_assist=>replace_one_symbol_with_value(
*                      EXPORTING
*                        i_where_column = where_col
*                        i_symbol_name  = l_symbol
*                        i_from         = l_from_symbol
*                        i_length       = l_to_symbol
*                      CHANGING
*                        c_where_syntax = me->where_syntax
*                        c_offset       = l_offset
*                        c_total        = l_total_len ).

                    ELSE.
                      l_from_symbol = l_offset.
                    ENDIF.
                    TRANSLATE l_open_symbol USING ' XX '.
                    l_offset = l_offset + 1.
                    CONTINUE.
                  ENDIF.
              ENDCASE.

              l_offset = l_offset + 1.

            ENDDO.

            IF l_open IS INITIAL AND l_open_string IS INITIAL AND l_open_symbol IS INITIAL AND l_is_subsel = abap_false.
              l_offset = l_offset - l_from + 1.

              TRY.
                  where_col-value = me->where_syntax+l_from(l_offset).
                CATCH cx_sy_range_out_of_bounds.
                  where_col-value = me->where_syntax+l_from.
              ENDTRY.

              l_wc_nr = l_wc_nr + 1.

              CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
              CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

              where_col-wildcard_operator  = l_wildcard_operator.
              where_col-wildcard_condition = l_wildcard_condition.

              CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

              APPEND where_col TO me->gt_sql_where_col_tab_t.
              CLEAR where_col.

              l_from = l_from + l_offset.
            ENDIF.
            IF l_off_w > 0 AND l_off_f > 0.
              l_off_w = l_off_w + l_len + 1.                " CDX3301
              l_from = l_off_w + l_off_f.                   " CDX3301
            ENDIF.
            CLEAR: l_off_f,
                   l_off_w,
                   l_str,
                   lt_source_split,
                   ls_result_source.
          WHEN 'IS'.   " IS [NOT] NULL
            CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
          WHEN 'AND'.  " AND
            CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
            where_col-andor = 'A'.
          WHEN 'OR'.   " OR
            CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
            where_col-andor = 'O'.
          WHEN ')'.                                         " CDX3301
            CLEAR l_is_subsel.
            CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
*          l_from = l_from + 2.
          WHEN OTHERS. " Field
            " split field into field, table and alias
            DATA: tablename TYPE string.
            split_field( EXPORTING i_field  = l_string
                         IMPORTING e_field  = where_col-fieldname
                                   e_table  = tablename
                                   e_alias  = where_col-aliasname
                                   e_tabfld = where_col-tablefield ).
            where_col-tablename = tablename.
            CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.

            " get type of the tablefield
            TRY.
                lr_abap_type ?= get_abap_typedescr( i_name = where_col-tablefield ).
                where_col-type_kind   = lr_abap_type->type_kind.
                where_col-fieldlength = lr_abap_type->output_length.
                IF where_col-type_kind = 'g' AND where_col-fieldlength = 0. "SSTRING
                  where_col-fieldlength = 1333.
                ENDIF.
              CATCH /cadaxo/cx_sqlc_type_not_found.
                CLEAR lr_abap_type.
            ENDTRY.

        ENDCASE.
      ELSE.
        IF l_total_len > l_from AND me->where_syntax+l_from IS NOT INITIAL AND me->where_syntax+l_from CO ' )'.            " CDX001-0028
          CONCATENATE me->where_syntax_wildcard me->where_syntax+l_from INTO me->where_syntax_wildcard SEPARATED BY space. " CDX001-0028
        ENDIF.                                                                                                             " CDX001-0028
        EXIT.
      ENDIF.

    ENDWHILE.

    CONDENSE me->where_syntax_wildcard.

    IF lt_result_source_tmp IS NOT INITIAL.
*  IF l_is_subsel = abap_true AND lt_result_source_tmp IS NOT INITIAL.
      me->result_source_t = lt_result_source_tmp.
    ENDIF.
  ENDMETHOD.


  METHOD process_subpool_result.
****************************************************************************************************
* Description             : Subpool Result                                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 31.05.2016 | Ana Lekic            | error message from subpool                  | COCKPIT-61     *
*            |                      |                                             | $001           *
*------------+----------------------+---------------------------------------------+----------------*
* 05.10.2016 | Domi Bigl            | String,XString,DecFloat16/34                |$002 COCKPIT-117*
*------------+----------------------+---------------------------------------------+----------------*
* 28.12.2016 | Domi Bigl            | INT8                                        |$003 COCKPIT-148*
*------------+----------------------+---------------------------------------------+----------------*
* 19.02.2017 | Domi Bigl            | Runtime errors                              | COCKPIT-103    *
*------------+----------------------+---------------------------------------------+----------------*
* 20.07.2017 | Johann Fößleitner    | Bugfixing                                   | COCKPIT-236    *
*------------+----------------------+---------------------------------------------+----------------*
* 01.05.2020 | Johann Fößleitner    | Bugfixing                                   | COCKPIT-437    *
****************************************************************************************************


    DATA l_sql_abap_componentdescr  TYPE abap_componentdescr.
    DATA lt_result_ddfields         TYPE /cadaxo/sqlcdfies_t.
    DATA l_decimals                 TYPE i.
    DATA l_intlen                   TYPE i.

    FIELD-SYMBOLS: <lt_result_table> TYPE STANDARD TABLE,
                   <ls_ddfields>     TYPE /cadaxo/sqlcdfies,
                   <ls_ddfieldsg>    TYPE /cadaxo/sqlcdfies.

    IF i_error_message IS NOT INITIAL.

      CLEAR me->g_main_ref->gt_errors.
      g_error_message = me->check_runtime_error( i_error_message ).
      RETURN.
    ENDIF. "$001

    lt_result_ddfields = me->gt_result_ddfields.

    IF me->gt_result_ddfields IS INITIAL                                            "COCKPIT-236
       AND me->g_select_version = /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_1 "COCKPIT-236
      AND lt_result_ddfields IS NOT INITIAL.                                        "COCKPIT-236
      me->gt_result_ddfields = lt_result_ddfields.                                  "COCKPIT-236
    ENDIF.                                                                          "COCKPIT-236

*          IF me->gt_result_ddfields IS INITIAL.  "+COCKPIT-372
*            me->gt_result_ddfields = lt_dflies.  "+COCKPIT-372 failsafe - in case there was some scenario where gt_result_ddfield is blank and needs to be filled from rfc '/CADAXO/SQLCSUBROUTINEPOOL'
*          ENDIF.                                 "+COCKPIT-372

    LOOP AT me->gt_result_ddfields ASSIGNING <ls_ddfields>.
      UNASSIGN <ls_ddfieldsg>.
      READ TABLE lt_result_ddfields WITH KEY /cadaxo/alias_field = <ls_ddfields>-fieldname ASSIGNING <ls_ddfieldsg>.
      IF sy-subrc = 0.
        <ls_ddfields>-/cadaxo/alias_field = <ls_ddfields>-fieldname.
      ELSE.
        LOOP AT lt_result_ddfields ASSIGNING <ls_ddfieldsg> WHERE fieldname = <ls_ddfields>-fieldname AND /cadaxo/alias_field = space.
          IF <ls_ddfieldsg>-/cadaxo/alias IS NOT INITIAL.
            DATA(l_name) = <ls_ddfieldsg>-/cadaxo/alias && '~' && <ls_ddfieldsg>-fieldname && ','.
            READ TABLE me->column_words_t WITH KEY table_line = l_name TRANSPORTING NO FIELDS.
            IF sy-subrc <> 0.
              l_name = <ls_ddfieldsg>-/cadaxo/alias && '~' && <ls_ddfieldsg>-fieldname.
              READ TABLE me->column_words_t WITH KEY table_line = l_name TRANSPORTING NO FIELDS.
              IF sy-subrc <> 0.
                l_name = <ls_ddfieldsg>-/cadaxo/alias && '~*'.
                READ TABLE me->column_words_t WITH KEY table_line = l_name TRANSPORTING NO FIELDS.
              ENDIF.
            ENDIF.
            IF sy-subrc = 0.
              EXIT. "LOOP
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF <ls_ddfieldsg> IS ASSIGNED.
        <ls_ddfields>-reffield            = <ls_ddfieldsg>-reffield.
        <ls_ddfields>-datatype            = <ls_ddfieldsg>-datatype.
        <ls_ddfields>-keyflag             = <ls_ddfieldsg>-keyflag.
        <ls_ddfields>-/cadaxo/alias       = <ls_ddfieldsg>-/cadaxo/alias.
        <ls_ddfields>-/cadaxo/alias_value = <ls_ddfieldsg>-/cadaxo/alias_value.
      ENDIF.
    ENDLOOP.

    ASSIGN me->result_table->* TO <lt_result_table>.
    IF <lt_result_table> IS NOT ASSIGNED.

      CLEAR me->result_component_t.

      LOOP AT me->gt_result_ddfields ASSIGNING FIELD-SYMBOL(<l_fields>).

        IF <l_fields>-stru_name NE space.

          CLEAR l_sql_abap_componentdescr.
          l_sql_abap_componentdescr-name = <l_fields>-fieldname.
          l_sql_abap_componentdescr-as_include = <l_fields>-as_include.
          l_sql_abap_componentdescr-type ?= cl_abap_structdescr=>describe_by_name( <l_fields>-stru_name ).
          APPEND l_sql_abap_componentdescr TO me->result_component_t.

          CAST cl_abap_structdescr( l_sql_abap_componentdescr-type )->get_components( ).
        ELSE.

          CLEAR l_sql_abap_componentdescr.

          l_sql_abap_componentdescr-name = <l_fields>-fieldname.

          l_decimals = <l_fields>-decimals.
          l_intlen   = <l_fields>-intlen.

          CASE <l_fields>-inttype.
            WHEN 'P'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_p( p_length = l_intlen p_decimals = l_decimals ).
            WHEN 'I'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_i( ).
            WHEN 'T'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_t( ).
            WHEN 'D'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_d( ).
            WHEN 'N'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_n( p_length = l_intlen ).
            WHEN 'F'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_f( ).
            WHEN 'X'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_x( p_length = l_intlen ).
            WHEN 'C'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_c( p_length = l_intlen ).
            WHEN 'b'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>describe_by_name( '/CADAXO/SQLC_REFERENCE_TYPES-INT1' ).
            WHEN 's'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>describe_by_name( '/CADAXO/SQLC_REFERENCE_TYPES-INT2' ).
            WHEN 'g'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_string( ).
            WHEN 'y'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_xstring( ).
            WHEN 'a'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_decfloat16( ).
            WHEN 'e'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_decfloat34( ).
            WHEN '8'.
              CALL METHOD cl_abap_elemdescr=>('GET_INT8')
                RECEIVING
                  p_result = l_sql_abap_componentdescr-type.
            WHEN 'p'.
              CALL METHOD cl_abap_elemdescr=>('GET_UTCLONG')
                RECEIVING
                  p_result = l_sql_abap_componentdescr-type.
            WHEN OTHERS.
              mr_arfc_exception = NEW /cadaxo/cx_sqlc_type_not_found( type = CONV #( <l_fields>-inttype ) ).
          ENDCASE.

          APPEND l_sql_abap_componentdescr TO me->result_component_t.

        ENDIF.
      ENDLOOP.

      me->create_result_structures( ).

      ASSIGN me->result_table->* TO <lt_result_table>.

    ENDIF.

    IMPORT data = <lt_result_table> FROM DATA BUFFER i_data.

    DELETE me->gt_result_ddfields WHERE fieldname IS INITIAL
                                    AND rollname  <> '/CADAXO/SQLCAGGRCOUNT'. "COCKPIT-437

  ENDMETHOD.


  METHOD serialize.
    FREE result_table.
    FREE result_structure.
  ENDMETHOD.


  METHOD set_bachground_mode.
    background_mode = i_background_mode.
  ENDMETHOD.


  METHOD split_field.
    " ---------------------------------------------------------------------------------------------------
    "  Description             : Split Field into field, table and alias                                -
    " ---------------------------------------------------------------------------------------------------
    "  Additional informations : This Method splits a field into field, table and alias                 -
    "                                                                                                   -
    " ---------------------------------------------------------------------------------------------------
    "  Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    -
    "  Date                    : 01.01.2010               Release    : WAS 7.00                         -
    " ---------------------------------------------------------------------------------------------------
    "  Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    -
    "  Date                    : 01.03.2010                                                             -
    " ---------------------------------------------------------------------------------------------------
    "                                                                                                   -
    " -----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S ------------
    "                                                                                                   -
    "  Date       | Developer            | Description                                 | Correction Nr. -
    " ------------+----------------------+---------------------------------------------+-----------------
    "  03.08.2010 | Fößleitner Johann    | Try to find the right table, in case of     | CDX001-0001    -
    "             |                      | join select without alias                   |                -
    " ------------+----------------------+---------------------------------------------+-----------------
    "  29.08.2010 | Bigl Dominik         | Check, if the table name is used instead    | CDX001-0009    -
    "             |                      | of the alias name                           |                -
    " ---------------------------------------------------------------------------------------------------

    IF i_field CA '~'.         " alias~field
      SPLIT i_field AT '~' INTO e_alias e_field.
      ASSIGN me->result_source_t[ alias = e_alias ] TO FIELD-SYMBOL(<sql_source_line>).
      IF sy-subrc <> 0.
        ASSIGN me->result_source_t[ table = e_alias ] TO <sql_source_line>.
      ENDIF.
      IF sy-subrc = 0.
        e_table = <sql_source_line>-table.
      ENDIF.
    ELSEIF i_field CA '-'.     " table-field
      SPLIT i_field AT '-' INTO e_table e_field.
    ELSE.
      e_field = i_field. " only field

      IF  lines( me->result_source_t ) = 1
      AND me->union_source_t IS INITIAL.
        ASSIGN me->result_source_t[ 1 ] TO <sql_source_line>.
        IF sy-subrc = 0.
          e_table = <sql_source_line>-table.
        ENDIF.
      ELSE.
        " in other cases, try to find the right table
        DATA(result_sources) = me->result_source_t.
        APPEND LINES OF me->union_source_t TO result_sources.
        LOOP AT result_sources ASSIGNING <sql_source_line>.
          SELECT SINGLE COUNT( * ) FROM dd03l
            WHERE tabname   = <sql_source_line>-table
              AND fieldname = e_field
              AND as4local  = 'A'. "#EC CI_SROFC_NESTED "#EC CI_SEL_NESTED
          IF sy-subrc = 0.
            e_table = <sql_source_line>-table.
            RETURN.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.


    CONCATENATE e_table '-' e_field INTO e_tabfld.
  ENDMETHOD.


  METHOD split_field_v_2.

    DATA l_field TYPE string.

    FIELD-SYMBOLS: <l_sql_source_line> LIKE LINE OF me->result_source_t.

    l_field = i_value.

* get alias
    FIND REGEX '^(.+) AS ([a-zA-Z0-9_]+)[ ,]*$' IN i_value SUBMATCHES l_field e_alias_field.

* get field
    FIND REGEX '^([a-zA-Z0-9_]+)~([a-zA-Z0-9_]+)$' IN l_field SUBMATCHES e_alias e_field.
    IF sy-subrc <> 0.
      FIND REGEX '^([a-zA-Z0-9_]+)[ ,]*$' IN l_field SUBMATCHES e_field.
    ENDIF.

    IF e_alias IS NOT INITIAL.
      READ TABLE me->result_source_t WITH KEY alias = e_alias ASSIGNING <l_sql_source_line>.
      IF sy-subrc = 0.
        e_table = <l_sql_source_line>-table.
      ELSE.
        READ TABLE me->result_source_t WITH KEY table = e_alias ASSIGNING <l_sql_source_line>.
        IF sy-subrc = 0.
          e_table = <l_sql_source_line>-table.
        ENDIF.
      ENDIF.
    ELSEIF e_field IS NOT INITIAL AND lines( me->result_source_t ) = 1.
      READ TABLE me->result_source_t INDEX 1 ASSIGNING <l_sql_source_line>.
      IF sy-subrc = 0.
        e_table = <l_sql_source_line>-table.
      ENDIF.
    ENDIF.

    IF e_field IS INITIAL.
      e_field = l_field.
    ENDIF.

  ENDMETHOD.


  METHOD subpool_result.
****************************************************************************************************
* Description             : Subpool Result                                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 31.05.2016 | Ana Lekic            | error message from subpool                  | COCKPIT-61     *
*            |                      |                                             | $001           *
*------------+----------------------+---------------------------------------------+----------------*
* 05.10.2016 | Domi Bigl            | String,XString,DecFloat16/34                |$002 COCKPIT-117*
*------------+----------------------+---------------------------------------------+----------------*
* 28.12.2016 | Domi Bigl            | INT8                                        |$003 COCKPIT-148*
*------------+----------------------+---------------------------------------------+----------------*
* 19.02.2017 | Domi Bigl            | Runtime errors                              | COCKPIT-103    *
*------------+----------------------+---------------------------------------------+----------------*
* 20.07.2017 | Johann Fößleitner    | Bugfixing                                   | COCKPIT-236    *
*------------+----------------------+---------------------------------------------+----------------*
* 01.05.2020 | Johann Fößleitner    | Bugfixing                                   | COCKPIT-437    *
*------------+----------------------+---------------------------------------------+----------------*
* 01.05.2024 | Domi Bigl            | no aRFC in Background Mode + CC             | SQL-26         *
****************************************************************************************************

    DATA l_data                     TYPE xstring.
    DATA lv_sys_error_message       TYPE char128.
    DATA lv_error_message           TYPE string.

    TRY.
*        lwa_result-task = p_task.
        g_async_calls = g_async_calls - 1.
        RECEIVE RESULTS FROM FUNCTION '/CADAXO/SQLCSUBROUTINEPOOL'
           IMPORTING
             e_error_message       = lv_error_message                 "COCKPIT-103
             e_runtime             = g_tmp_result_details-runtime
             e_result_lines        = g_tmp_result_details-lines
             et_dfies              = me->gt_result_ddfields          "-COCKPIT-372
*             et_dfies              = lt_dflies                        "+COCKPIT-372
             et_dfies_all          = me->gt_result_ddfields_all
          CHANGING
             ic_data                = l_data
          EXCEPTIONS
             system_failure        = 1 MESSAGE lv_sys_error_message "$001 "COCKPIT-103
             communication_failure = 2 MESSAGE lv_sys_error_message "$001 "COCKPIT-103
             resource_failure      = 3
             OTHERS                = 4.
        IF sy-subrc <> 0 OR lv_error_message IS NOT INITIAL. "$001                "COCKPIT-103

          IF lv_sys_error_message IS NOT INITIAL.                                 "COCKPIT-103
            lv_error_message = lv_sys_error_message.                              "COCKPIT-103
          ENDIF.                                                                  "COCKPIT-103
        ENDIF. "$001

        me->process_subpool_result( i_data          = l_data
                                    i_error_message = lv_error_message
                                  ).
      CATCH cx_root INTO mr_arfc_exception.
    ENDTRY.
  ENDMETHOD.


  METHOD update_alv_field_catalog_sl.
****************************************************************************************************
* Description             : Update ALV Field Catalog - Saved Lists                                 *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo GmbH              Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2015               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_component TYPE string.

    FIELD-SYMBOLS: <l_fields>      LIKE LINE OF me->gt_result_ddfields,
                   <ls_lvc_t_fcat> TYPE lvc_s_fcat.

    LOOP AT me->gt_result_ddfields ASSIGNING <l_fields>.

      UNASSIGN <ls_lvc_t_fcat>.

      CONCATENATE <l_fields>-tabname
                  <l_fields>-fieldname
                  INTO l_component
                  SEPARATED BY '-'.

      READ TABLE c_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = <l_fields>-map_fieldname.
      IF sy-subrc NE 0.
        READ TABLE c_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = <l_fields>-fieldname.
        IF sy-subrc NE 0.
          READ TABLE c_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = l_component.
        ENDIF.
      ENDIF.

      IF <ls_lvc_t_fcat> IS ASSIGNED.

        <ls_lvc_t_fcat>-reptext   = <l_fields>-reptext.
        <ls_lvc_t_fcat>-scrtext_s = <l_fields>-scrtext_s.
        <ls_lvc_t_fcat>-scrtext_m = <l_fields>-scrtext_m.
        <ls_lvc_t_fcat>-scrtext_l = <l_fields>-scrtext_l.

        CLEAR: <ls_lvc_t_fcat>-coltext.

        IF i_user_settings-hd_fieldname EQ 'X'.
          <ls_lvc_t_fcat>-coltext     =  <l_fields>-colhd_fieldname.
          IF NOT <l_fields>-/cadaxo/alias IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
            CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-coltext   INTO <ls_lvc_t_fcat>-coltext.
          ENDIF.
        ELSE.
          IF NOT <l_fields>-/cadaxo/alias_field IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
            MOVE <l_fields>-/cadaxo/alias_field TO <ls_lvc_t_fcat>-coltext.
          ELSE.
            IF NOT <l_fields>-/cadaxo/alias IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
              IF NOT <ls_lvc_t_fcat>-scrtext_l IS INITIAL.
                CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-scrtext_l INTO <ls_lvc_t_fcat>-scrtext_l.
              ENDIF.
              IF NOT <ls_lvc_t_fcat>-scrtext_m IS INITIAL.
                CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-scrtext_m INTO <ls_lvc_t_fcat>-scrtext_m.
              ENDIF.
              IF NOT <ls_lvc_t_fcat>-scrtext_m IS INITIAL.
                CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-scrtext_s INTO <ls_lvc_t_fcat>-scrtext_s.
              ENDIF.
              IF NOT <ls_lvc_t_fcat>-reptext IS INITIAL.
                CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-reptext INTO <ls_lvc_t_fcat>-reptext.
              ENDIF.
            ENDIF.

            CASE 'X'.
              WHEN i_user_settings-hd_fieldtext_s.
                MOVE <ls_lvc_t_fcat>-scrtext_s TO <ls_lvc_t_fcat>-coltext.
              WHEN i_user_settings-hd_fieldtext_m.
                MOVE <ls_lvc_t_fcat>-scrtext_m TO <ls_lvc_t_fcat>-coltext.
              WHEN i_user_settings-hd_fieldtext_l.
                MOVE <ls_lvc_t_fcat>-scrtext_l TO <ls_lvc_t_fcat>-coltext.
            ENDCASE.
          ENDIF.

          IF <ls_lvc_t_fcat>-coltext IS INITIAL AND i_user_settings-hd_fieldtext_a IS INITIAL.
            <ls_lvc_t_fcat>-coltext = <l_fields>-fieldname.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
