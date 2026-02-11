class /CADAXO/CL_SQLC_BACKGROUND definition
  public
  final
  create public .

public section.

  class-methods EXECUTE_SQL_BACKGROUND
    importing
      !I_LIST_GUID type /CADAXO/SQLC_LISTGUID
    raising
      CX_STATIC_CHECK .
  class-methods ADD_RECORD_NEXT_JOB
    importing
      !IS_SQLCSRES type /CADAXO/SQLCSRES
      !I_BTCJOB type BTCJOB
      !I_BTCJOBCNT type BTCJOBCNT .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /CADAXO/CL_SQLC_BACKGROUND IMPLEMENTATION.


  METHOD add_record_next_job.

    DATA variant TYPE btcvariant.
    DATA tbtco   TYPE tbtco.

    SELECT SINGLE variant FROM tbtcp INTO variant WHERE jobname = i_btcjob AND jobcount = i_btcjobcnt.
    IF sy-subrc = 0.
*   check for open periodic job -> create new initial line in sqlcsres
      SELECT SINGLE a~jobcount
        FROM tbtco AS a
        INNER JOIN tbtcp AS b
        ON a~jobname = b~jobname
        AND a~jobcount = b~jobcount
        INTO CORRESPONDING FIELDS OF tbtco
          WHERE a~jobname = i_btcjob
            AND b~variant = variant
            AND ( strtdate = '' OR strttime = '' ).
      IF sy-subrc = 0.
        DATA(initial_guid) =  VALUE guid_16( ).
        SELECT SINGLE @abap_true
               FROM /cadaxo/sqlcsres
               WHERE jobname        = @i_btcjob
                 AND jobcount       = @tbtco-jobcount
                 AND root_list_guid = @is_sqlcsres-root_list_guid
                 AND ress_guid      = @initial_guid
               INTO @DATA(exists).
        IF exists = abap_false.
          DATA(ls_sqlcsres_tmp) = is_sqlcsres.
          CLEAR ls_sqlcsres_tmp-ress_guid.
          CLEAR ls_sqlcsres_tmp-space_cons_zip.
          ls_sqlcsres_tmp-jobcount       = tbtco-jobcount.
          ls_sqlcsres_tmp-list_guid      = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          ls_sqlcsres_tmp-prev_list_guid = is_sqlcsres-list_guid.
          GET TIME STAMP FIELD ls_sqlcsres_tmp-create_timestamp.
          INSERT INTO /cadaxo/sqlcsres VALUES ls_sqlcsres_tmp.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD execute_sql_background.

    DATA: lcl_sqlc_cockpit   TYPE REF TO /cadaxo/cl_sqlc_cockpit_main,
          result_details     TYPE /cadaxo/sqlcresult_details,
          lt_result_details  TYPE TABLE OF /cadaxo/sqlcresult_details,
          ls_sqlcresult_ref  TYPE /cadaxo/sqlcresult_ref,
          lt_cl_sql_parse    TYPE /cadaxo/sqlc_cl_cockpit_parset,
          ls_sqlcsres        TYPE /cadaxo/sqlcsres,
          l_sql_string       TYPE string,
          ls_sqlcresultsave  TYPE /cadaxo/sqlcresultsave,
          lt_sqlcresultsave  TYPE TABLE OF /cadaxo/sqlcresultsave,
          ls_sqlcress        TYPE /cadaxo/sqlcress,
          lt_code            TYPE /cadaxo/sqlccodeline_t,
          l_xml              TYPE string,
          lt_result_list_raw TYPE TABLE OF xstring,
          ls_result_list_raw TYPE xstring,
          l_timestamp        TYPE timestampl.

    DATA ls_tbtco            TYPE tbtco.
    DATA lt_lvc_t_fcat       TYPE lvc_t_fcat.
    DATA l_btcjob            TYPE btcjob.
    DATA l_btcjobcnt         TYPE btcjobcnt.

    FIELD-SYMBOLS <lr_cl_sql_parse> TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
    FIELD-SYMBOLS <ls_t>            TYPE ANY TABLE.

    CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
      IMPORTING
        jobcount = l_btcjobcnt
        jobname  = l_btcjob
      EXCEPTIONS
        OTHERS   = 1.

    IF l_btcjob IS NOT INITIAL.
      SELECT SINGLE *
             FROM /cadaxo/sqlcsres
             WHERE jobcount       = @l_btcjobcnt
               AND jobname        = @l_btcjob
               AND root_list_guid = @i_list_guid
             INTO @ls_sqlcsres.
    ENDIF.
    IF sy-subrc <> 0 OR l_btcjobcnt IS INITIAL.
      SELECT *
             FROM /cadaxo/sqlcsres
             WHERE root_list_guid = @i_list_guid OR list_guid = @i_list_guid
             ORDER BY ress_guid
             into table @DATA(all_sqlcsres).
      IF sy-subrc <> 0.
        IF sy-batch IS NOT INITIAL.
          MESSAGE e143(/cadaxo/sqlc) WITH i_list_guid.
        ENDIF.
        MESSAGE x143(/cadaxo/sqlc) WITH i_list_guid.
      ENDIF.
      ls_sqlcsres = all_sqlcsres[ 1 ].
      IF l_btcjobcnt IS INITIAL.
        l_btcjobcnt = ls_sqlcsres-jobcount.
        l_btcjob    = ls_sqlcsres-jobname.
      ENDIF.
    ENDIF.

    add_record_next_job( is_sqlcsres = ls_sqlcsres
                         i_btcjob    = l_btcjob
                         i_btcjobcnt = l_btcjobcnt ).
    COMMIT WORK.

    cl_abap_gzip=>decompress_text( EXPORTING gzip_in  = ls_sqlcsres-sql_string
                                   IMPORTING text_out = l_sql_string ).

    lcl_sqlc_cockpit = NEW #( ).

    TRY.

* replace all symbols
        /cadaxo/cl_sqlc_cockpit_assist=>replace_all_symbols_with_value( CHANGING c_string = l_sql_string ).

        CLEAR lcl_sqlc_cockpit->ms_user_settings_xml-maxsel.

* parse the sql string
        lt_cl_sql_parse = /cadaxo/cl_sqlc_cockpit_parse=>parse_sql_i( i_sql           = l_sql_string
                                                                      i_user_settings = lcl_sqlc_cockpit->ms_user_settings_xml
                                                                      i_role          = lcl_sqlc_cockpit->authcheck->get_cockpitrole( ) ).
        IF lcl_sqlc_cockpit->ms_user_settings_xml-strict_mode = abap_true.
          DATA(start_sql_version) = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v2.
        ELSE.
          start_sql_version = /cadaxo/cl_sqlc_sql_syntax=>cc_select_version-v1.
        ENDIF.

* check the sql syntax
        /cadaxo/cl_sqlc_sql_syntax=>check_sql_syntax( i_sql_parsed = lt_cl_sql_parse i_select_version = start_sql_version ).

        LOOP AT lt_cl_sql_parse ASSIGNING <lr_cl_sql_parse>.
          <lr_cl_sql_parse>->parse_sql_ii( ).
          lcl_sqlc_cockpit->authcheck->blacklist_check_tables( <lr_cl_sql_parse>->result_source_t  ).
          <lr_cl_sql_parse>->parse_sql_where_columns( ).
          <lr_cl_sql_parse>->g_main_ref = lcl_sqlc_cockpit.
          <lr_cl_sql_parse>->set_bachground_mode( abap_true ).
        ENDLOOP.

        LOOP AT lt_cl_sql_parse ASSIGNING <lr_cl_sql_parse>.

          IF <lr_cl_sql_parse>->g_select_version = <lr_cl_sql_parse>->c_select_version_1.
            <lr_cl_sql_parse>->create_alv_field_catalog( i_user_settings = lcl_sqlc_cockpit->g_user_settings
                                                         i_dragdrop_handle = 0 ).
            <lr_cl_sql_parse>->create_result_structures( ).
          ENDIF.

          l_timestamp = /cadaxo/cl_sqlc_log=>insert_sql_to_log( i_sql_string = <lr_cl_sql_parse>->sql_syntax
                                                                i_sql_mode   = '02' ).

          <lr_cl_sql_parse>->execute_select( EXPORTING i_user_settings  = lcl_sqlc_cockpit->ms_user_settings_xml
                                             IMPORTING e_result_details = result_details ).

          IF <lr_cl_sql_parse>->g_select_version EQ /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_2.
            IF <lr_cl_sql_parse>->g_main_ref->g_user_settings-domaintext EQ abap_true.
              <lr_cl_sql_parse>->add_domain_value( ).
              CLEAR <lr_cl_sql_parse>->gt_result_ddfields.
              LOOP AT <lr_cl_sql_parse>->gt_lvc_t_fcat REFERENCE INTO DATA(fcat).

                read table <lr_cl_sql_parse>->gt_result_ddfields_all with key fieldname = fcat->fieldname ASSIGNING field-symbol(<ddfield_all>).
                if sy-subrc = 0 and <ddfield_all>-intlen <> fcat->intlen.
                   fcat->intlen = <ddfield_all>-intlen.
                endif.

                APPEND CORRESPONDING #( fcat->* ) TO <lr_cl_sql_parse>->gt_result_ddfields REFERENCE INTO DATA(field).
                field->leng = fcat->intlen.

                field->colhd_fieldname = field->fieldname.
                IF field->leng = 0 AND field->intlen > 0.
                  field->leng = field->intlen.
                ENDIF.

              ENDLOOP.
            ENDIF.
          ENDIF.

          APPEND result_details TO lt_result_details.

          /cadaxo/cl_sqlc_log=>update_sql_to_log( i_timestamp      = l_timestamp
                                                  i_sql_string     = <lr_cl_sql_parse>->sql_syntax
                                                  i_result_runtime = result_details-runtime
                                                  i_result_lines   = result_details-lines
                                                  i_sql_mode       = '02'  ).

          CLEAR ls_sqlcresult_ref.

          ls_sqlcresult_ref-table_dref = <lr_cl_sql_parse>->result_table.

        ENDLOOP.

        ls_sqlcress-ress_guid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        ls_sqlcsres-ress_guid = ls_sqlcress-ress_guid.

        LOOP AT lt_cl_sql_parse ASSIGNING <lr_cl_sql_parse>.

          ls_sqlcresultsave-main-result_details = lt_result_details[ sy-tabix ].

          IF <lr_cl_sql_parse>->g_select_version = <lr_cl_sql_parse>->c_select_version_1.
            lt_lvc_t_fcat = <lr_cl_sql_parse>->create_alv_field_catalog( i_user_settings = lcl_sqlc_cockpit->g_user_settings
                                                                         i_dragdrop_handle = 0 ).
          ENDIF.

          ls_sqlcresultsave-parse-column_syntax            = <lr_cl_sql_parse>->column_syntax.
          ls_sqlcresultsave-parse-source_syntax            = <lr_cl_sql_parse>->source_syntax.
          ls_sqlcresultsave-parse-where_syntax             = <lr_cl_sql_parse>->where_syntax.
          ls_sqlcresultsave-parse-group_syntax             = <lr_cl_sql_parse>->group_syntax.
          ls_sqlcresultsave-parse-having_syntax            = <lr_cl_sql_parse>->having_syntax.
          ls_sqlcresultsave-parse-order_syntax             = <lr_cl_sql_parse>->order_syntax.
          ls_sqlcresultsave-parse-dbhint_syntax            = <lr_cl_sql_parse>->dbhint_syntax.
          ls_sqlcresultsave-parse-connection_syntax        = <lr_cl_sql_parse>->connection_syntax.
          ls_sqlcresultsave-parse-sql_syntax               = <lr_cl_sql_parse>->sql_syntax.
*          ls_sqlcresultsave-parse-result_ddfields          = <lr_cl_sql_parse>->gt_result_ddfields.
          IF lines( <lr_cl_sql_parse>->gt_result_ddfields_all ) > lines( <lr_cl_sql_parse>->gt_result_ddfields ).
            ls_sqlcresultsave-parse-result_ddfields = <lr_cl_sql_parse>->gt_result_ddfields_all.
          ELSE.
            ls_sqlcresultsave-parse-result_ddfields = <lr_cl_sql_parse>->gt_result_ddfields.
          ENDIF.
          ls_sqlcresultsave-parse-result_source            = <lr_cl_sql_parse>->result_source_t.
          ls_sqlcresultsave-parse-up_to_x_rows             = <lr_cl_sql_parse>->g_up_to_x_rows.
          ls_sqlcresultsave-parse-select_single            = <lr_cl_sql_parse>->g_select_single.
          ls_sqlcresultsave-parse-sql_syntax_without_where = <lr_cl_sql_parse>->sql_syntax_without_where.
          ls_sqlcresultsave-parse-client_specified         = <lr_cl_sql_parse>->gs_client_handling-client_specified.
          ls_sqlcresultsave-parse-using_client             = <lr_cl_sql_parse>->gs_client_handling-using_client.
          ls_sqlcresultsave-parse-bypassing_buffer         = <lr_cl_sql_parse>->g_bypassing_buffer.
          ls_sqlcresultsave-parse-subquery                 = <lr_cl_sql_parse>->subquery.

          CASE <lr_cl_sql_parse>->g_select_version.                                            "COCKPIT-375
            WHEN /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_1.
              ls_sqlcresultsave-parse-result_fieldcatalog = lt_lvc_t_fcat.
            WHEN /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_2.
              ls_sqlcresultsave-parse-result_fieldcatalog = <lr_cl_sql_parse>->gt_lvc_t_fcat.
          ENDCASE.

          ls_sqlcresult_ref-table_dref = <lr_cl_sql_parse>->result_table.

          ASSIGN ls_sqlcresult_ref-table_dref->* TO <ls_t>.

          EXPORT result FROM <ls_t> TO DATA BUFFER ls_result_list_raw.

          cl_abap_gzip=>compress_binary( EXPORTING raw_in   = ls_result_list_raw
                                         IMPORTING gzip_out = ls_result_list_raw ).


          APPEND ls_sqlcresultsave  TO lt_sqlcresultsave.
          APPEND ls_result_list_raw TO lt_result_list_raw.

        ENDLOOP.


        CALL TRANSFORMATION id SOURCE result_save = lt_sqlcresultsave
                               RESULT XML l_xml.
        cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                                     IMPORTING gzip_out = ls_sqlcress-rawdata ).

        ls_sqlcress-uname = cl_abap_syst=>get_user_name( ).

        ls_sqlcress-editor_sqlstring = ls_sqlcsres-editor_sqlstring.

        EXPORT result FROM lt_result_list_raw TO DATA BUFFER ls_sqlcress-rawresult.

        ls_sqlcsres-space_cons_zip = xstrlen( ls_sqlcress-rawresult ) / 1024.
        ls_sqlcsres-syst           = sy-sysid. "$002
        ls_sqlcsres-mandant        = sy-mandt. "$002

        ls_sqlcsres-nr_of_selects = lines( lt_cl_sql_parse ).

        IF ls_sqlcsres-jobcount <> l_btcjobcnt.
          ls_sqlcsres-list_guid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          ls_sqlcsres-jobcount  = l_btcjobcnt.
          GET TIME STAMP FIELD ls_sqlcsres-create_timestamp.
        ENDIF.

        MODIFY /cadaxo/sqlcress FROM ls_sqlcress.
        MODIFY /cadaxo/sqlcsres FROM ls_sqlcsres.

* catch exceptions
      CATCH /cadaxo/cx_sqlc_symb_not_found
            /cadaxo/cx_sqlc_no_sel_at_firs
            /cadaxo/cx_sqlc_syntax_error
            /cadaxo/cx_sqlc_no_source
            /cadaxo/cx_sqlc_to_much_resrow
            cx_sy_open_sql_db  INTO DATA(exception).

    ENDTRY.

    CALL FUNCTION 'BP_EVENT_RAISE'
      EXPORTING
        eventid         = '/CADAXO/MAIL_NOTIF'
        eventparm       = i_list_guid
        target_instance = ' '
      EXCEPTIONS
        OTHERS          = 1.
    IF sy-subrc <> 0.
    ENDIF.

    IF exception IS BOUND.
      RAISE EXCEPTION exception.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
