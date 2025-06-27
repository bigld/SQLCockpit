CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA c_output_table TYPE /cadaxo/cl_sqlc_user_hist_log=>ty_sqlclogalvs.
    METHODS handle_event FOR EVENT double_click OF cl_salv_events_table IMPORTING row column.

ENDCLASS.

CLASS lcl_local_runner DEFINITION.

  PUBLIC SECTION.
    TYPES date_range      TYPE RANGE OF /cadaxo/sqlclogalv-execute_date.
    TYPES runtime_range   TYPE RANGE OF /cadaxo/sqlclogalv-result_runtime.
    TYPES row_range       TYPE RANGE OF /cadaxo/sqlclogalv-result_rows.
    TYPES user_name_range TYPE RANGE OF /cadaxo/sqlclogalv-uname.
    TYPES date_line_type TYPE LINE OF date_range.

    TYPES: BEGIN OF timestamp_range,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE timestamp,
             high   TYPE timestamp,
           END OF timestamp_range.

    TYPES timestamp_ranges TYPE STANDARD TABLE OF timestamp_range WITH DEFAULT KEY.
    TYPES runtime_ranges   TYPE RANGE OF /cadaxo/sqlclogalv-result_runtime.
    TYPES row_ranges       TYPE RANGE OF /cadaxo/sqlclogalv-result_rows.


    METHODS run
      IMPORTING i_username TYPE user_name_range OPTIONAL
                i_dates    TYPE date_range      OPTIONAL
                i_runtime  TYPE runtime_range   OPTIONAL
                i_rows     TYPE row_range       OPTIONAL
      RAISING   cx_parameter_invalid_range
                cx_sy_buffer_overflow
                cx_sy_conversion_codepage
                cx_sy_compression_error
                cx_salv_msg.

  PRIVATE SECTION.
    TYPES ty_selects TYPE STANDARD TABLE OF /cadaxo/sqlclog WITH DEFAULT KEY.

    DATA selects_alv TYPE REF TO cl_salv_table.

    METHODS build_output_table
      IMPORTING i_selects             TYPE ty_selects
                i_input_rows          TYPE row_range
                i_input_runtime       TYPE runtime_range
      RETURNING VALUE(r_output_table) TYPE /cadaxo/cl_sqlc_user_hist_log=>ty_sqlclogalvs
      RAISING   cx_parameter_invalid_range
                cx_sy_buffer_overflow
                cx_sy_compression_error
                cx_sy_conversion_codepage.

    METHODS auth_check.

    METHODS conv_date_to_timestamp
      IMPORTING i_dates             TYPE date_range
      RETURNING VALUE(r_timestamps) TYPE timestamp_ranges
      RAISING
                cx_abap_invalid_value.

    METHODS db_query
      IMPORTING i_timestamps     TYPE timestamp_ranges OPTIONAL
                i_username       TYPE user_name_range  OPTIONAL
      RETURNING VALUE(r_selects) TYPE ty_selects
      RAISING   cx_sy_itab_line_not_found.

    METHODS generate_output
      CHANGING c_output_table TYPE /cadaxo/cl_sqlc_user_hist_log=>ty_sqlclogalvs.


    METHODS get_start_of_day_timestamp
      IMPORTING i_date          TYPE d
      RETURNING VALUE(r_ts_low) TYPE timestamp.

    METHODS get_end_of_day_timestamp
      IMPORTING i_date           TYPE d
      RETURNING VALUE(r_ts_high) TYPE timestamp.

    METHODS on_double_click
      IMPORTING
        e_row    TYPE string
        e_column TYPE string.

ENDCLASS.


CLASS lcl_local_runner IMPLEMENTATION.
  METHOD run.
    DATA selects TYPE STANDARD TABLE OF /cadaxo/sqlclog.

    auth_check( ).

    TRY.
        DATA(timestamp) = conv_date_to_timestamp( i_dates ).
      CATCH cx_abap_invalid_value.

    ENDTRY.

    selects = db_query( i_username   = i_username
                        i_timestamps = timestamp ).

    DATA(real_output_table) = build_output_table( i_selects       = selects
                                                  i_input_rows    = i_rows
                                                  i_input_runtime = i_runtime ).

    generate_output( CHANGING c_output_table = real_output_table ).
  ENDMETHOD.

  METHOD build_output_table.
    DATA output_line  LIKE LINE OF i_selects.
    DATA output_lines TYPE STANDARD TABLE OF /cadaxo/sqlclog.

    DATA(converter) = NEW /cadaxo/cl_sqlc_user_hist_log( ).

    LOOP AT i_selects INTO DATA(selects_line).

      cl_abap_gzip=>decompress_text( EXPORTING gzip_in  = selects_line-sql_log
                                     IMPORTING text_out = DATA(line_sql_xml) ).

      DATA line_details TYPE /cadaxo/sqlc_sqllog.

      CALL TRANSFORMATION id SOURCE XML line_sql_xml RESULT log = line_details.

      CLEAR output_line.
      output_line = CORRESPONDING #( BASE ( selects_line ) line_details ). " base auschecken

      IF     ( line_details-result_rows    IN i_input_rows )
         AND ( line_details-result_runtime IN i_input_runtime ).

        APPEND output_line TO output_lines.
        r_output_table = converter->convert_to_alv( output_lines ).

      ENDIF.

    ENDLOOP.

    SORT r_output_table BY execute_date DESCENDING
                           execute_time DESCENDING
                           result_rows DESCENDING
                           result_runtime DESCENDING.
  ENDMETHOD.

  METHOD generate_output.

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = selects_alv
                                CHANGING  t_table      = c_output_table ).
        selects_alv->get_functions( )->set_all( abap_true ).

        DATA(event) = selects_alv->get_event( ).

        DATA(local_handler) = NEW lcl_event_handler( ).
        SET HANDLER local_handler->handle_event FOR event.

        lcl_event_handler=>c_output_table = c_output_table.
        selects_alv->display( ).
      CATCH cx_salv_msg INTO DATA(exception_salv).
        MESSAGE exception_salv->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

  METHOD auth_check.
    AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
    IF sy-subrc <> 0.
      MESSAGE e036(/cadaxo/sqlc).
    ENDIF.
  ENDMETHOD.

  METHOD conv_date_to_timestamp.
    DATA temp_line TYPE timestamp_range.

    LOOP AT i_dates INTO DATA(date_line).

      CLEAR temp_line.
      temp_line-sign   = date_line-sign.
      temp_line-option = date_line-option.

      CASE date_line-option.
        WHEN 'GE'.
          temp_line-option = 'GE'.
          temp_line-low    = get_start_of_day_timestamp( date_line-low ).
          CLEAR temp_line-high.

        WHEN 'LE'.
          temp_line-option = 'LE'.
          temp_line-low    = get_end_of_day_timestamp( date_line-low ).
          CLEAR temp_line-high.

        WHEN 'BT'.
          temp_line-option = 'BT'.
          temp_line-low    = get_start_of_day_timestamp( date_line-low ).
          temp_line-high   = get_end_of_day_timestamp( date_line-high ).

        WHEN 'EQ'.
          temp_line-low    = get_start_of_day_timestamp( date_line-low ).
          temp_line-high   = get_end_of_day_timestamp( date_line-low ).
          temp_line-option = 'BT'.

        WHEN OTHERS.
          RAISE EXCEPTION NEW cx_abap_invalid_value( ).
      ENDCASE.

      APPEND temp_line TO r_timestamps.

    ENDLOOP.
  ENDMETHOD.

  METHOD db_query.
    SELECT FROM /cadaxo/sqlclog
      FIELDS *
      WHERE uname     IN @i_username
        AND timestamp IN @i_timestamps
      INTO TABLE @r_selects.
  ENDMETHOD.

  METHOD get_start_of_day_timestamp.
    CONVERT DATE i_date TIME '000000'
            INTO TIME STAMP r_ts_low
            TIME ZONE 'UTC   '.
  ENDMETHOD.

  METHOD get_end_of_day_timestamp.
    CONVERT DATE i_date TIME '235959'
            INTO TIME STAMP r_ts_high
            TIME ZONE 'UTC   '.
  ENDMETHOD.

  METHOD on_double_click.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_event.
    TRY.
        DATA(output_line) = c_output_table[ row ].

        CASE column.
          WHEN 'SQL_STRING' .
            IF output_line-sql_string IS NOT INITIAL.
              CALL FUNCTION '/CADAXO/SQLC_UT_VALUE_POPUP'
                CHANGING
                  cv_value = output_line-sql_string.
            ENDIF.

        ENDCASE.
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.


  ENDMETHOD.

ENDCLASS.
