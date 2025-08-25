CLASS /cadaxo/cl_sqlc_sql_syntax DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS: BEGIN OF cc_select_version,
                 v0 TYPE /cadaxo/sqlc_select_version VALUE 0 ##NO_TEXT,
                 v1 TYPE /cadaxo/sqlc_select_version VALUE 1 ##NO_TEXT,
                 v2 TYPE /cadaxo/sqlc_select_version VALUE 2 ##NO_TEXT,
               END OF cc_select_version.

    CLASS-METHODS check_sql_syntax
      IMPORTING i_sql_parsed     TYPE /cadaxo/sqlc_cl_cockpit_parset
                i_select_version TYPE /cadaxo/sqlc_select_version DEFAULT /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1
      EXPORTING et_rest          TYPE scit_rest
                e_select_version TYPE /cadaxo/sqlc_select_version
      RAISING   /cadaxo/cx_sqlc_syntax_error.

    CLASS-METHODS build_abap_code
      IMPORTING i_cl_cockpit_parse TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse
                i_select_version   TYPE /cadaxo/sqlc_select_version DEFAULT /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1
      EXPORTING e_abap_code        TYPE /cadaxo/sqlcstring_t
                e_abap_code_data   TYPE /cadaxo/sqlcstring_t.

    CLASS-METHODS format_abap_code
      IMPORTING i_columns    TYPE i OPTIONAL
      CHANGING  ct_abap_code TYPE /cadaxo/sqlcstring_t.
ENDCLASS.


CLASS /cadaxo/cl_sqlc_sql_syntax IMPLEMENTATION.
  METHOD check_sql_syntax.
    " TODO: parameter E_SELECT_VERSION is never cleared or assigned (ABAP cleaner)

    DATA lt_line               TYPE sedi_source.
    DATA check_message                TYPE edmessage.                   " string,                                 "#EC NEEDED
    DATA check_line                 TYPE i.                           "#EC NEEDED
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA check_word                 TYPE tdbaustein.                  " string,                         "#EC NEEDED
    DATA check_tadir                 TYPE trdir.                       "#EC NEEDED
    DATA lt_abap_code_data     TYPE /cadaxo/sqlcstring_t.
    DATA lt_abap_code_prog     TYPE /cadaxo/sqlcstring_t.
    DATA lr_cl_ci_check_result TYPE REF TO cl_ci_check_result.
    DATA lr_cl_ci_inspection   TYPE REF TO cl_ci_inspection.
    DATA lt_rest               TYPE scit_rest.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lr_cl_ci_test_root    TYPE REF TO cl_ci_test_root.
    DATA ls_adm_cust           TYPE /cadaxo/sqlc_admin_cust.
    DATA message_detail               TYPE trmsg_key.
    DATA lt_results            TYPE match_result_tab.            " COCKPIT-214
    DATA lv_select_version     TYPE /cadaxo/sqlc_select_version. " COCKPIT-214

    FIELD-SYMBOLS <l_cl_sql_parse> TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.

    LOOP AT i_sql_parsed ASSIGNING <l_cl_sql_parse>.

      lv_select_version = i_select_version.                         " COCKPIT-214

      IF lv_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1.                    " COCKPIT-214
        /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex(          " COCKPIT-214
                                                           EXPORTING i_where_syntax = <l_cl_sql_parse>->where_syntax " COCKPIT-214
                                                           IMPORTING e_result_tab   = lt_results ).                 " COCKPIT-214

        IF lt_results IS NOT INITIAL.                               " COCKPIT-214
          lv_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1.                   " COCKPIT-214
        ENDIF.                                                      " COCKPIT-214
      ENDIF.                                                        " COCKPIT-214

      " create main abap code.
      CLEAR lt_abap_code_data.
      CLEAR lt_abap_code_prog.
      CLEAR lt_line.

      APPEND 'PROGRAM SYNTAX_CHECK.' TO lt_line.
      APPEND 'FORM UNTER TABLES TAB_RESULT.' TO lt_line.

      " create main abap code.
      build_abap_code( EXPORTING i_cl_cockpit_parse = <l_cl_sql_parse>
                                 i_select_version   = lv_select_version
                       IMPORTING e_abap_code        = lt_abap_code_prog
                                 e_abap_code_data   = lt_abap_code_data ).

      format_abap_code( EXPORTING i_columns    = 254                   " COCKPIT-223
                        CHANGING  ct_abap_code = lt_abap_code_prog ).  " COCKPIT-223

      SORT lt_abap_code_data.
      DELETE ADJACENT DUPLICATES FROM lt_abap_code_data.

      APPEND LINES OF lt_abap_code_data TO lt_line.
      APPEND LINES OF lt_abap_code_prog TO lt_line.

      APPEND 'ENDFORM.' TO lt_line.

      check_tadir-uccheck = abap_true.
      check_tadir-fixpt   = abap_true.

      " do the check syntax
      SYNTAX-CHECK FOR lt_line MESSAGE check_message LINE check_line WORD check_word DIRECTORY ENTRY check_tadir MESSAGE-ID message_detail.

      IF    message_detail-keyword = 'SELECT'  AND (    lv_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1 AND (    message_detail-msgnumber = '484'
                                                                                                                            OR message_detail-msgnumber = '487'
                                                                                                                            OR message_detail-msgnumber = '541'
                                                                                                                            OR message_detail-msgnumber = '544' )
                                              OR lv_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v2 AND ( message_detail-msgnumber = '547' ) )
         OR message_detail-keyword = 'MESSAGE' AND (    lv_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1 AND message_detail-msgnumber = 'G2F' )
         OR message_detail-keyword = 'MESSAGE' AND (    lv_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1 AND message_detail-msgnumber = 'GF5' ).

        IF lv_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v2 AND ( message_detail-msgnumber = '547' ).
          IF <l_cl_sql_parse>->g_no_upto IS INITIAL.
            <l_cl_sql_parse>->g_no_upto = abap_true.
          ELSE.
            DATA(lv_loop) = abap_true.
          ENDIF.

        ENDIF.
        IF lv_loop IS INITIAL.
          check_sql_syntax( EXPORTING i_sql_parsed     = VALUE #( ( <l_cl_sql_parse> ) )
                                      i_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v2
                            IMPORTING et_rest          = et_rest
                                      e_select_version = <l_cl_sql_parse>->g_select_version ).
          CLEAR check_message.
          CLEAR message_detail.
        ENDIF.
      ELSE.
        <l_cl_sql_parse>->g_select_version = lv_select_version.
      ENDIF.

      " show popup-message, if there is an error
      IF check_message IS NOT INITIAL.
        IF    ( message_detail-keyword = 'MESSAGE'           AND message_detail-msgnumber = 'GAN' )
           OR ( message_detail-keyword = 'SYS$$INCOMPLETE$$' AND message_detail-msgnumber = '000' ).
          " The length of the current statement is greater that the allowed maximum length of 28 kilobytes.
          " The last statement is not complete (period missing).
          check_message = check_message && ' ' && TEXT-e04.
        ENDIF.

*    RAISE syntax_error.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
          EXPORTING message = CONV #( check_message ).
      ELSE.

        CLEAR lt_rest.

        /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).
        IF ls_adm_cust-sci_chkv <> space.

          CALL FUNCTION 'PRETTY_PRINTER'
            EXPORTING inctoo = space
            TABLES    ntext  = lt_line
                      otext  = lt_line.

          TRY.

              TRY.

                  DATA(parmas_old) = VALUE abap_parmbind_tab( ( name  = 'P_VARIANT'
                                                                kind  = cl_abap_objectdescr=>exporting
                                                                value = REF #( ls_adm_cust-sci_chkv ) )
                                                              ( name  = 'P_CODE'
                                                                kind  = cl_abap_objectdescr=>exporting
                                                                value = REF #( lt_line ) )
                                                              ( name  = 'P_RESULT'
                                                                kind  = cl_abap_objectdescr=>importing
                                                                value = REF #( lr_cl_ci_check_result ) ) ).

                  CALL METHOD cl_ci_check=>('SOURCE_CODE') PARAMETER-TABLE parmas_old.
                CATCH cx_sy_dyn_call_error.
                  TRY.
                      DATA(program_guid) = cl_system_uuid=>create_uuid_c22_static( ).
                      TRANSLATE program_guid USING '{_}_'.
                    CATCH cx_uuid_error.    "
                  ENDTRY.
                  DATA(program_name) = CONV program( 'ZCDXCI' && to_upper( program_guid ) ).
                  INSERT REPORT program_name FROM lt_line.
                  DATA(parmas_new) = VALUE abap_parmbind_tab( ( name  = 'P_VARIANT'
                                                                kind  = cl_abap_objectdescr=>exporting
                                                                value = REF #( ls_adm_cust-sci_chkv ) )
                                                              ( name  = 'P_PROGRAM'
                                                                kind  = cl_abap_objectdescr=>exporting
                                                                value = REF #( program_name ) )
                                                              ( name  = 'P_RESULT'
                                                                kind  = cl_abap_objectdescr=>importing
                                                                value = REF #( lr_cl_ci_check_result ) ) ).

                  CALL METHOD cl_ci_check=>('SOURCE_CODE') PARAMETER-TABLE parmas_new.

                  CALL FUNCTION 'RS_DELETE_PROGRAM'
                    EXPORTING  program         = program_name
                               suppress_checks = abap_true
                               suppress_popup  = abap_true
                    EXCEPTIONS OTHERS          = 1.

              ENDTRY.
              " COCKPIT-502 replace end

              lr_cl_ci_inspection = lr_cl_ci_check_result->get_inspection( ).
              lt_rest = lr_cl_ci_inspection->scirestps.

              DELETE lt_rest WHERE kind <> 'E' AND kind <> 'W'.
              DELETE lt_rest WHERE test = 'CL_CI_TEST_EXTENDED_CHECK'.

              et_rest = lt_rest.

            CATCH cx_ci_invalid_variant
                  cx_ci_check_error
                  cx_ci_invalid_object
                  cx_root ##NO_HANLDER.
              IF program_name IS NOT INITIAL.
                CALL FUNCTION 'RS_DELETE_PROGRAM'
                  EXPORTING  program         = program_name
                             suppress_checks = abap_true
                             suppress_popup  = abap_true
                  EXCEPTIONS OTHERS          = 1.
              ENDIF.
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD build_abap_code.
    DATA l_line  LIKE LINE OF e_abap_code.
    DATA l_dummy TYPE string.

    CLEAR e_abap_code[].

    IF i_cl_cockpit_parse->g_select_single IS NOT INITIAL.
      APPEND 'FIELD-SYMBOLS: <FS_STR_RESULT> TYPE ANY.' TO e_abap_code_data.
      APPEND 'APPEND INITIAL LINE TO TAB_RESULT ASSIGNING <fs_str_result>.' TO e_abap_code.
      CONCATENATE ' SELECT SINGLE' i_cl_cockpit_parse->column_syntax INTO l_line SEPARATED BY space.
    ELSE.
      IF i_cl_cockpit_parse->g_select_distinct IS NOT INITIAL.
        CONCATENATE ' SELECT DISTINCT' i_cl_cockpit_parse->column_syntax INTO l_line SEPARATED BY space.
      ELSE.
        CONCATENATE ' SELECT' i_cl_cockpit_parse->column_syntax INTO l_line SEPARATED BY space.
      ENDIF.
    ENDIF.

    APPEND l_line TO e_abap_code.

    l_dummy = i_cl_cockpit_parse->source_syntax && i_cl_cockpit_parse->cds_parameter_syntax.
    CONCATENATE ' FROM' l_dummy INTO l_line SEPARATED BY space.

    " ----
    " ENHANCEMENT-SECTION /cadaxo/sqlc_ehn_s_cls_se_002 SPOTS /cadaxo/sqlc_ehnsp_cls_se_001.
    " ...
    " END-ENHANCEMENT-SECTION.
    " $*$-Start: /CADAXO/SQLC_EHN_S_CLS_SE_002-------------------------------------------------------$*$-
    " ENHANCEMENT 2  /CADAXO/SQLC_EHNIMP_CLS_PE_3.    "active version
    " ...
    " ---
    " CASE abap_true.
    " WHEN i_cl_cockpit_parse->gs_client_handling-client_specified.
    " CONCATENATE l_line 'CLIENT SPECIFIED' INTO l_line SEPARATED BY space.
    " WHEN i_cl_cockpit_parse->gs_client_handling-using_client.
    " CONCATENATE l_line 'USING CLIENT' INTO l_line SEPARATED BY space.
    " ENDCASE.
    " ---
    " ENDENHANCEMENT.
    " $*$-End:   /CADAXO/SQLC_EHN_S_CLS_SE_002-------------------------------------------------------$*$-

    ENHANCEMENT-SECTION /cadaxo/sqlc_ehn_s_cls_se_002 SPOTS /cadaxo/sqlc_ehnsp_cls_se_001.
      " ...
    END-ENHANCEMENT-SECTION.

    APPEND l_line TO e_abap_code.

    IF    i_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1
       OR i_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v0.

      IF i_cl_cockpit_parse->fields_syntax IS INITIAL.
        i_cl_cockpit_parse->get_code_up_to_rows( CHANGING ct_code = e_abap_code ).

        i_cl_cockpit_parse->get_code_bypassing_buffer( CHANGING ct_code = e_abap_code ).

        i_cl_cockpit_parse->get_code_connection( CHANGING ct_code = e_abap_code ).

      ELSE.
        i_cl_cockpit_parse->get_code_fields( CHANGING ct_code = e_abap_code ).
      ENDIF.

      IF i_cl_cockpit_parse->g_select_single IS NOT INITIAL.
        APPEND ' INTO <fs_str_result>' TO e_abap_code.
      ELSE.
        APPEND ' INTO TABLE TAB_RESULT' TO e_abap_code.
      ENDIF.
    ELSEIF i_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v2.
      i_cl_cockpit_parse->get_code_fields( CHANGING ct_code = e_abap_code ).
    ENDIF.

    i_cl_cockpit_parse->get_code_where( EXPORTING i_only_initval = abap_true
                                        CHANGING  ct_code        = e_abap_code ).
    IF i_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v2.
      i_cl_cockpit_parse->get_code_dbhints( CHANGING ct_code = e_abap_code ).
    ENDIF.

    i_cl_cockpit_parse->get_code_group_by( CHANGING ct_code = e_abap_code ).

    i_cl_cockpit_parse->get_code_having( CHANGING ct_code = e_abap_code ).

    i_cl_cockpit_parse->get_code_order_by( CHANGING ct_code = e_abap_code ).

    IF i_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v2.
      IF i_cl_cockpit_parse->g_select_single IS NOT INITIAL.
        APPEND ' INTO @DATA(LS_RESULTDATA)' TO e_abap_code.
      ELSE.
        APPEND ' INTO TABLE @DATA(TAB_RESULTDATA)' TO e_abap_code.
      ENDIF.

      i_cl_cockpit_parse->get_code_offset( CHANGING ct_code = e_abap_code ).

      i_cl_cockpit_parse->get_code_up_to_rows( CHANGING ct_code = e_abap_code ).

      i_cl_cockpit_parse->get_code_bypassing_buffer( CHANGING ct_code = e_abap_code ).

      i_cl_cockpit_parse->get_code_connection( CHANGING ct_code = e_abap_code ).

    ELSEIF i_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1.

      i_cl_cockpit_parse->get_code_offset( CHANGING ct_code = e_abap_code ).

      IF i_cl_cockpit_parse->fields_syntax IS NOT INITIAL.

        i_cl_cockpit_parse->get_code_up_to_rows( CHANGING ct_code = e_abap_code ).

        i_cl_cockpit_parse->get_code_bypassing_buffer( CHANGING ct_code = e_abap_code ).

        i_cl_cockpit_parse->get_code_connection( CHANGING ct_code = e_abap_code ).

      ENDIF.

    ENDIF.

    IF i_select_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1.
      i_cl_cockpit_parse->get_code_dbhints( CHANGING ct_code = e_abap_code ).
    ENDIF.

    APPEND '.' TO e_abap_code.
  ENDMETHOD.

  METHOD format_abap_code.
    DATA lt_abap_code TYPE /cadaxo/sqlcstring_t.
    DATA ls_abap_code LIKE LINE OF lt_abap_code.
    DATA l_pos_from   TYPE i.
    DATA l_pos_to     TYPE i.
    DATA l_len        TYPE i.
    DATA l_count      TYPE p LENGTH 8 DECIMALS 1.
    DATA l_space      TYPE string.

    FIELD-SYMBOLS <l_abap_code> LIKE LINE OF lt_abap_code.

    CONCATENATE '' '' INTO l_space SEPARATED BY space.

    lt_abap_code[] = ct_abap_code[].

    CLEAR ct_abap_code.

    l_pos_to = i_columns.
*  l_pos_from = 0.                               "CDX001-0011

    LOOP AT lt_abap_code ASSIGNING <l_abap_code>.
      l_pos_from = 0.                              " CDX001-0011
      IF strlen( <l_abap_code> ) <= l_pos_to.
        APPEND shift_left( <l_abap_code> ) TO ct_abap_code.
      ELSE.
        ls_abap_code = <l_abap_code>.
        DATA(lv_line_length) = strlen( ls_abap_code ).
        WHILE l_pos_to <= lv_line_length. " ls_abap_code+l_pos_to NE l_space.

          DO.
            IF ls_abap_code+l_pos_to(1) = l_space.
              FIND ALL OCCURRENCES OF '''' IN SECTION OFFSET l_pos_to OF ls_abap_code MATCH COUNT l_count.
              IF sy-subrc = 0.
                l_count = l_count / 2.
                IF frac( l_count ) = 0.
                  l_pos_to = l_pos_to - 1.
                  EXIT.
                ENDIF.
              ELSE.
                l_pos_to = l_pos_to - 1.
                EXIT.
              ENDIF.
            ENDIF.
            l_pos_to = l_pos_to - 1.
          ENDDO.

          l_len = ( l_pos_to - l_pos_from ) + 1.

          APPEND shift_left( ls_abap_code+l_pos_from(l_len) ) TO ct_abap_code.

          l_pos_from = l_pos_to + 1.
          l_pos_to = l_pos_from + i_columns.

          IF l_pos_to > lv_line_length.
            APPEND shift_left( ls_abap_code+l_pos_from ) TO ct_abap_code.
            EXIT.
          ENDIF.

        ENDWHILE.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
