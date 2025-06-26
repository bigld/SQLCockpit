CLASS lcl_local_runner DEFINITION.

  PUBLIC SECTION.

    TYPES: date_range    TYPE RANGE OF /cadaxo/sqlclogalv-execute_date,
           runtime_range TYPE RANGE OF /cadaxo/sqlclogalv-result_runtime,
           row_range     TYPE RANGE OF /cadaxo/sqlclogalv-result_rows,
           user_name_range     TYPE RANGE OF /cadaxo/sqlclogalv-uname.

    TYPES: BEGIN OF timestamp_range,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE timestamp,
             high   TYPE timestamp,
           END OF timestamp_range.

    TYPES: timestamp_ranges TYPE STANDARD TABLE OF timestamp_range WITH DEFAULT KEY.
    TYPES: runtime_ranges TYPE RANGE OF /cadaxo/sqlclogalv-result_runtime .
    TYPES: row_ranges TYPE RANGE OF /cadaxo/sqlclogalv-result_rows .

*    TYPES: ty_output_table TYPE STANDARD TABLE OF /cadaxo/sqlclogalv WITH DEFAULT KEY.

    METHODS run
      IMPORTING i_username TYPE user_name_range OPTIONAL
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
      ty_selects   TYPE STANDARD TABLE OF /cadaxo/sqlclog WITH DEFAULT KEY.

    METHODS build_output_table
      IMPORTING
        i_selects             TYPE ty_selects
        i_input_rows          TYPE row_range
        i_input_runtime       TYPE runtime_range
      RETURNING
        VALUE(r_output_table) TYPE /cadaxo/cl_sqlc_user_hist_log=>ty_sqlclogalvs
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
                i_username       TYPE user_name_range OPTIONAL
                i_runtimes       TYPE  runtime_ranges OPTIONAL
                i_rows           TYPE row_ranges OPTIONAL
      RETURNING VALUE(r_selects) TYPE ty_selects
      RAISING   cx_sy_itab_line_not_found.

    METHODS generate_output
      CHANGING
        c_output_table TYPE /cadaxo/cl_sqlc_user_hist_log=>ty_sqlclogalvs.

ENDCLASS.


CLASS lcl_local_runner IMPLEMENTATION.
  METHOD run.
    DATA selects TYPE STANDARD TABLE OF /cadaxo/sqlclog.

    auth_check( ).

    DATA(timestamp) = conv_date_to_timestamp( i_dates ).

    selects = db_query( i_username   = i_username
                        i_timestamps = timestamp
                        i_rows       = i_rows
                        i_runtimes   = i_runtime ).

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
      output_line = CORRESPONDING #( selects_line ).
      output_line-result_rows    = line_details-result_rows.
      output_line-result_runtime = line_details-result_runtime.
      output_line-result_status  = line_details-result_status.
      output_line-sql_string     = line_details-sql_string.

      IF    ( i_input_rows    IS NOT INITIAL AND line_details-result_rows NOT    IN i_input_rows )
         OR ( i_input_runtime IS NOT INITIAL AND line_details-result_runtime NOT IN i_input_runtime ).
        CONTINUE.
      ENDIF.

      APPEND output_line TO output_lines.

      r_output_table = converter->convert_to_alv( output_lines ).

    ENDLOOP.

    SORT r_output_table BY execute_date DESCENDING
                           execute_time DESCENDING
                           result_rows DESCENDING
                           result_runtime DESCENDING.
  ENDMETHOD.

  METHOD generate_output.
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = DATA(selects_alv)
                                CHANGING  t_table      = c_output_table ).
        selects_alv->get_functions( )->set_all( abap_true ).
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

      IF date_line-low IS NOT INITIAL.
        CONVERT DATE date_line-low TIME '000000' INTO TIME STAMP temp_line-low TIME ZONE 'UTC   '.
      ENDIF.

      IF date_line-high IS NOT INITIAL.
        CONVERT DATE date_line-high TIME '235959' INTO TIME STAMP temp_line-high TIME ZONE 'UTC   '.
      ENDIF.

      APPEND temp_line TO r_timestamps.

    ENDLOOP.
  ENDMETHOD.

  METHOD db_query.

    SELECT FROM /cadaxo/sqlclog
      FIELDS *
      WHERE ( uname        IN @i_username   )
        AND ( timestamp    IN @i_timestamps )
      INTO TABLE @r_selects.

  ENDMETHOD.

*  METHOD conv_timestamp_in_date.
*    CONVERT TIME STAMP i_timestamp TIME ZONE 'UTC   ' INTO DATE e_date TIME e_time.
*  ENDMETHOD.
ENDCLASS.
