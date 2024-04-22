CLASS /cadaxo/cl_sqlc_user_hist_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: ty_sql_logs TYPE TABLE OF /cadaxo/sqlclog WITH DEFAULT KEY.

    CLASS-METHODS get_default_timestamp_to RETURNING VALUE(r_timestamp_to) TYPE timestamp.
    CLASS-METHODS get_default_timestamp_from IMPORTING VALUE(i_days_back)      TYPE /cadaxo/sqlcshowhistoryxlines DEFAULT '01'
                                             RETURNING VALUE(r_timestamp_from) TYPE timestampl.
    CLASS-METHODS delete_log .
    CLASS-METHODS select_LOG IMPORTING i_user            TYPE syuname DEFAULT sy-uname
                                       i_timestamp_from  TYPE timestamp
                                       i_timestamp_to    TYPE timestamp
                             RETURNING VALUE(r_sql_logs) TYPE ty_sql_logs.
    TYPES: ty_sqlclogs    TYPE STANDARD TABLE OF /cadaxo/sqlclog WITH DEFAULT KEY.
    TYPES: ty_sqlclogalvs TYPE STANDARD TABLE OF /cadaxo/sqlclogalv WITH DEFAULT KEY.
    CLASS-METHODS: convert_to_alv IMPORTING i_sqllogs        TYPE ty_sqlclogs
                                  RETURNING VALUE(r_sqlalvs) TYPE ty_sqlclogalvs.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /cadaxo/cl_sqlc_user_hist_log IMPLEMENTATION.
  METHOD delete_log.

    DATA l_rc(1).

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = TEXT-t13
        text_question         = TEXT-q25
        text_button_1         = TEXT-x03
        icon_button_1         = 'ICON_OKAY'
        text_button_2         = TEXT-x04
        icon_button_2         = 'ICON_CANCEL'
        default_button        = '2'
        display_cancel_button = abap_false
      IMPORTING
        answer                = l_rc.
    IF l_rc = '1'.
      DELETE FROM /cadaxo/sqlclog WHERE uname = sy-uname.
      IF sy-subrc = 0.
        COMMIT WORK.
        MESSAGE s092(/cadaxo/sqlc) WITH sy-dbcnt.

*        me->show_log( ).

      ELSE.
        ROLLBACK WORK.
        MESSAGE s001(/cadaxo/sqlc) DISPLAY LIKE 'E'.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD select_log.

    SELECT * FROM /cadaxo/sqlclog
           WHERE uname     = @i_user
             AND timestamp BETWEEN @i_timestamp_from AND @i_timestamp_to
           INTO TABLE @r_sql_logs.

    DELETE r_sql_logs WHERE sql_log IS INITIAL.

  ENDMETHOD.

  METHOD get_default_timestamp_to.

    CONVERT DATE sy-datum TIME '235959' INTO TIME STAMP r_timestamp_to TIME ZONE 'UTC   '.

  ENDMETHOD.
  METHOD get_default_timestamp_from.

    IF i_days_back IS INITIAL.
      i_days_back = '01'.
    ENDIF.

    DATA(fromdate) = CONV dats( sy-datum - ( i_days_back - 1 ) ).
    CONVERT DATE fromdate TIME 0 INTO TIME STAMP r_timestamp_from TIME ZONE 'UTC   '.

  ENDMETHOD.


  METHOD convert_to_alv.
    DATA: xml_string TYPE string.
    DATA: sqllog_xml TYPE /cadaxo/sqlc_sqllog.
    DATA: sqllogalv  TYPE /cadaxo/sqlclogalv.

    LOOP AT i_sqllogs ASSIGNING FIELD-SYMBOL(<sqlclog>).

      TRY.
          cl_abap_gzip=>decompress_text( EXPORTING gzip_in = <sqlclog>-sql_log
                                         IMPORTING text_out = xml_string ).

          CALL TRANSFORMATION id
               SOURCE XML xml_string
               RESULT log = sqllog_xml.

          sqllogalv = VALUE #( uname               = <sqlclog>-uname
                               sql_string          = sqllog_xml-sql_string
                               result_rows         = sqllog_xml-result_rows
                               result_runtime      = sqllog_xml-result_runtime
                               result_runtime_unit = SWITCH #( sqllog_xml-result_runtime_unit
                                                              WHEN '' THEN /cadaxo/cl_sqlc_rt_measurement=>c_unit-microsecond
                                                              ELSE sqllog_xml-result_runtime_unit )
                               result_status_icon = SWITCH #( sqllog_xml-result_status
                                                              WHEN '00' THEN icon_green_light
                                                              WHEN '01' THEN icon_yellow_light
                                                              WHEN '02' THEN icon_red_light
                                                              ELSE icon_green_light
                                                            )
                                sql_mode_icon      = SWITCH #( sqllog_xml-sql_mode
                                                               WHEN '01' OR space THEN icon_gis_pan
                                                               WHEN '02' THEN icon_background_job
                                                               ELSE icon_dummy
                                                             )
                             ).
        CATCH cx_parameter_invalid_range
              cx_sy_buffer_overflow
              cx_sy_conversion_codepage
              cx_sy_compression_error.

          sqllogalv = VALUE #( uname               = <sqlclog>-uname
                               result_rows         = 0
                               result_runtime      = 0
                               result_runtime_unit = ''
                               result_status_icon  = icon_red_light
                             ).
          MESSAGE e028(/cadaxo/sqlc_ulog) INTO sqllogalv-sql_string.

      ENDTRY.

      CONVERT TIME STAMP <sqlclog>-timestamp TIME ZONE sy-zonlo
              INTO DATE sqllogalv-execute_date TIME sqllogalv-execute_time.

      APPEND sqllogalv TO r_sqlalvs.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
