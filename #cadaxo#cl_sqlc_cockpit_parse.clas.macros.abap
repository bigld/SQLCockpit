*"* use this source file for any macro definitions you need
*"* in the implementation part of the class

ENHANCEMENT-SECTION /cadaxo/sqlc_ehn_s_cls_se_003 SPOTS /cadaxo/sqlc_ehnsp_cls_se_001 STATIC .
*...

DEFINE cls_cdss.

END-OF-DEFINITION.

END-ENHANCEMENT-SECTION.

DEFINE create_dynamic_select_subpool.
  CLEAR: lt_abap_code.

  APPEND 'REPORT SUBQUERY.' TO lt_abap_code.

  APPEND 'DATA: L_ROWS         TYPE I,' TO lt_abap_code.
  APPEND '      L_PERCENTAGE   TYPE I,' TO lt_abap_code.
  APPEND '      L_PACKAGE_SIZE TYPE I.' TO lt_abap_code.

  if not me->g_main_ref->g_sql_trace_on is INITIAL.
    APPEND 'DATA l_result_details         TYPE /cadaxo/sqlcresult_details.' TO lt_abap_code.
    APPEND 'DATA l_sql_trace_activated    TYPE c LENGTH 1.' TO lt_abap_code.
  endif.

  APPEND 'FORM FORM TABLES TAB_RESULT USING EXP_TAB_RESULT_EXP EXP_TAB_RESULT EXP_US_SQL_TRACE EXP_US_TB_TRACE CHANGING UCX_ROOT TYPE REF TO CX_ROOT.' TO lt_abap_code.
  APPEND 'TRY.' TO lt_abap_code.

  if not me->g_main_ref->g_sql_trace_on is INITIAL.
    me->get_code_trace_on( CHANGING ct_code = lt_abap_code ).
  endif.

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

  cls_cdss.

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

  if not me->g_main_ref->g_sql_trace_on is INITIAL.
    me->get_code_trace_off( CHANGING ct_code = lt_abap_code ).
  endif.

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

***
  GET RUN TIME FIELD l_from.

  g_async_calls = g_async_calls + 1.

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

END-OF-DEFINITION.

DEFINE create_dynamic_select_subpool2.

    APPEND 'REPORT SUBQUERY.' TO lt_abap_code.

    DATA lt_symbol_variable TYPE gtt_symbol_variable.

    me->get_multisymbol_data_table( IMPORTING e_symbol_variable = lt_symbol_variable
                                    CHANGING  i_where_syntax    = me->where_syntax ).


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

    cls_cdss.

    me->get_code_fields( CHANGING ct_code = lt_abap_code ).

    me->get_code_where(
      EXPORTING i_only_initval = abap_false
      CHANGING ct_code = lt_abap_code
    ).

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

    me->get_code_dbhints( CHANGING ct_code = lt_abap_code ).

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

    EXPORT dfies          = me->gt_result_ddfields
           result_source  = lt_result_source
           column_syntax  = me->column_syntax
           source_syntax  = me->source_syntax
           code           = lt_abap_code
           range_tables   = lt_symbol_variable
           user_settings  = me->g_main_ref->g_user_settings TO DATA BUFFER l_data.


END-OF-DEFINITION.

DEFINE m_execute_select.
" Method EXECUTE_SELECT_V_1


END-OF-DEFINITION.

DEFINE m_execute_select_v_2.
" Method EXECUTE_SELECT_V_2

END-OF-DEFINITION.
