DEFINE create_dynamic_select_subpool.
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
    RETURN.
  ENDMETHOD.
END-OF-DEFINITION.

DEFINE create_dynamic_select_subpool2.
    DATA lt_abap_code     TYPE /cadaxo/sqlcstring_t.
    DATA l_line           TYPE string.
    DATA l_maxsel         TYPE c LENGTH 10.
    DATA lt_result_source TYPE /cadaxo/sqlcselectsource_fla_t.
    DATA l_data           TYPE xstring.
    DATA l_error_message  TYPE char128.
    DATA l_dummy          TYPE string.

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
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error EXPORTING message = CONV #( text-e02 ) previous = mr_arfc_exception.
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
    RETURN.
  ENDMETHOD.
END-OF-DEFINITION.

DEFINE m_execute_select.
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
                            informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                            informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                           informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                           informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                      informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                            informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
                                            informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
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
    RETURN.
  ENDMETHOD.
END-OF-DEFINITION.

DEFINE m_execute_select_v_2.
    DATA l_maxsel           TYPE i.
    DATA lr_exception       TYPE REF TO cx_sy_open_sql_db.
    DATA lr_exception2      TYPE REF TO cx_sy_conversion_error.
    DATA lr_root_exception  TYPE REF TO /cadaxo/cx_sqlc_syntax_error.



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
END-OF-DEFINITION.
