CLASS lcl_local_runner DEFINITION.

  PUBLIC SECTION.

    TYPES: date_range    TYPE RANGE OF /cadaxo/sqlclogalv-execute_date,
           runtime_range TYPE RANGE OF /cadaxo/sqlclogalv-result_runtime,
           row_range     TYPE RANGE OF /cadaxo/sqlclogalv-result_rows,
           user_name     TYPE  /cadaxo/sqlclog-uname.

    TYPES: BEGIN OF timestamp_range,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE timestamp,
             high   TYPE timestamp,
           END OF timestamp_range.

    TYPES: timestamp_ranges TYPE STANDARD TABLE OF timestamp_range WITH DEFAULT KEY.
    TYPES: runtime_ranges TYPE RANGE OF /cadaxo/sqlclogalv-result_runtime .
    TYPES: row_ranges TYPE RANGE OF /cadaxo/sqlclogalv-result_rows .

    TYPES: BEGIN OF ty_output_line,
             include        TYPE /cadaxo/sqlclog,
             result_rows    TYPE /cadaxo/sqlc_sqllog-result_rows,
             result_runtime TYPE /cadaxo/sqlc_sqllog-result_runtime,
           END OF ty_output_line.
    TYPES: ty_output_table TYPE STANDARD TABLE OF ty_output_line.

    METHODS run
      IMPORTING i_username TYPE user_name DEFAULT sy-uname "OPTIONAL
                i_dates    TYPE date_range OPTIONAL
                i_runtime  TYPE runtime_range OPTIONAL
                i_rows     TYPE row_range OPTIONAL
      RAISING
                cx_parameter_invalid_range
                cx_sy_buffer_overflow
                cx_sy_conversion_codepage
                cx_sy_compression_error
                cx_salv_msg.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      ty_selects   TYPE STANDARD TABLE OF /cadaxo/sqlclog WITH DEFAULT KEY,
      ty_selects_1 TYPE STANDARD TABLE OF /cadaxo/sqlclog WITH DEFAULT KEY.

    METHODS build_output_table
      IMPORTING
        i_selects             TYPE ty_selects_1
        i_input_rows          TYPE row_range
        i_input_runtime       TYPE runtime_range
      RETURNING
        VALUE(r_output_table) TYPE lcl_local_runner=>ty_selects
      RAISING
        cx_parameter_invalid_range
        cx_sy_buffer_overflow
        cx_sy_compression_error
        cx_sy_conversion_codepage.


    METHODS auth_check.

    METHODS conv_date_to_timestamp
      IMPORTING i_dates             TYPE date_range
      RETURNING VALUE(r_timestamps) TYPE timestamp_ranges.

    METHODS db_query
      IMPORTING i_timestamps     TYPE timestamp_ranges OPTIONAL
                i_username       TYPE /cadaxo/sqlcuser OPTIONAL
                i_runtimes       TYPE  runtime_ranges OPTIONAL
                i_rows           TYPE row_ranges OPTIONAL
      RETURNING VALUE(r_selects) TYPE ty_selects
      RAISING   cx_sy_itab_line_not_found.
    METHODS generate_output
      CHANGING
        c_output_table TYPE lcl_local_runner=>ty_selects.



ENDCLASS.


CLASS lcl_local_runner IMPLEMENTATION.
  METHOD run.
    DATA selects TYPE STANDARD TABLE OF /cadaxo/sqlclog.

    auth_check( ).

    DATA(test) = conv_date_to_timestamp( i_dates ).

    TRY.
        selects = db_query( i_username   = i_username
                            i_timestamps = test
                            i_rows       = i_rows
                            i_runtimes   = i_runtime ).
      CATCH cx_sy_itab_line_not_found.
        WRITE / 'NO ENTRIES FOUND'.
    ENDTRY.

    DATA output_table TYPE lcl_local_runner=>ty_selects.

    output_table = build_output_table( i_selects = selects i_input_rows = i_rows i_input_runtime = i_runtime ).

    generate_output( CHANGING c_output_table = output_table ).
  ENDMETHOD.

  METHOD build_output_table.
    DATA output_line LIKE LINE OF r_output_table.

    LOOP AT i_selects INTO DATA(selects_line).

      cl_abap_gzip=>decompress_text( EXPORTING gzip_in  = selects_line-sql_log
                                     IMPORTING text_out = DATA(line_sql_xml) ).

      DATA line_details TYPE /cadaxo/sqlc_sqllog.

      CALL TRANSFORMATION id SOURCE XML line_sql_xml RESULT log = line_details.

      CLEAR output_line.
      MOVE-CORRESPONDING selects_line TO output_line.
      output_line-result_rows    = line_details-result_rows.
      output_line-result_runtime = line_details-result_runtime.

      IF i_input_rows IS NOT INITIAL AND line_details-result_rows NOT IN i_input_rows.
        CONTINUE.
      ENDIF.

      IF i_input_runtime IS NOT INITIAL AND line_details-result_runtime NOT IN i_input_runtime.
        CONTINUE.
      ENDIF.


      APPEND output_line TO r_output_table.

    ENDLOOP.

    SORT r_output_table BY timestamp DESCENDING result_rows DESCENDING result_runtime DESCENDING .
  ENDMETHOD.

  METHOD generate_output.
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = DATA(selects_alv)
                                CHANGING  t_table      = c_output_table ).
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
    DATA date_line TYPE LINE OF date_range.
    DATA temp_line TYPE timestamp_range.
    DATA ts_ranges TYPE timestamp_ranges.

    LOOP AT i_dates INTO date_line.

      CLEAR temp_line.

      temp_line-sign   = date_line-sign.
      temp_line-option = date_line-option.

      IF date_line-low IS NOT INITIAL.
        temp_line-low = |{ date_line-low }000000|.
      ENDIF.

      IF date_line-high IS NOT INITIAL.
        temp_line-high = |{ date_line-high }235959|.
      ENDIF.

      APPEND temp_line TO ts_ranges.

    ENDLOOP.

    r_timestamps = ts_ranges.
  ENDMETHOD.

  METHOD db_query.
    DATA uname_search_pattern TYPE string.

    IF i_username IS INITIAL.
      uname_search_pattern = '%'.
    ELSE.
      uname_search_pattern = |{ i_username }%|.
    ENDIF.

    IF i_rows IS NOT INITIAL AND i_runtimes IS NOT INITIAL.

      TRY.
          SELECT FROM /cadaxo/sqlclog
            FIELDS *
            WHERE ( uname        LIKE @uname_search_pattern   )
              AND ( timestamp    IN @i_timestamps )
  AND ( result_runtime = 0 ) "weil in /cadaxo/sqlclog result_runtime & result_row immer mit Wert 0 gespeichert werden
  AND ( result_rows = 0 )
            INTO TABLE @r_selects.
        CATCH cx_sy_itab_line_not_found.
          WRITE / 'No Entries found'.
      ENDTRY.

    ELSE.
      TRY.
          SELECT FROM /cadaxo/sqlclog
            FIELDS *
            WHERE ( uname        LIKE @uname_search_pattern   )
              AND ( timestamp    IN @i_timestamps )
            INTO TABLE @r_selects.
        CATCH cx_sy_itab_line_not_found.
          WRITE / 'No Entries found'.
      ENDTRY.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
