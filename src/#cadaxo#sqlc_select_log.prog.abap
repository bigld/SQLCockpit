REPORT /cadaxo/sqlc_select_log.
INCLUDE /cadaxo/sqlc_select_log_c01.

*DATA: puser   TYPE /cadaxo/sqlclog-uname,
*      date    TYPE /cadaxo/sqlclogalv-execute_date,
*      runtime TYPE /cadaxo/sqlclogalv-result_runtime,
*      rows    TYPE /cadaxo/sqlclogalv-result_rows.
*
*RANGES: date_ranges FOR date.

DATA: selected_user    TYPE /cadaxo/sqlclog,
      output_table     TYPE TABLE OF /cadaxo/sqlclog,
      output_table_alv TYPE TABLE OF /cadaxo/sqlclogalv,
      select_params    TYPE /cadaxo/sqlclogalv,
      alv_layout       TYPE slis_layout_alv.






SELECTION-SCREEN BEGIN OF BLOCK sel WITH FRAME TITLE TEXT-t01.
  SELECTION-SCREEN ULINE.

  SELECT-OPTIONS: sel_user FOR selected_user-uname NO INTERVALS NO-EXTENSION, "besser Parameters, google: abap select options einschränken
                  sel_date FOR select_params-execute_date NO-EXTENSION.
  SELECTION-SCREEN ULINE.

  SELECT-OPTIONS: sel_runt FOR select_params-result_runtime NO-EXTENSION,
                  sel_rows FOR select_params-result_rows NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK sel.



START-OF-SELECTION.
 DATA(l_username) = VALUE /cadaxo/sqlclog-uname( ).

  IF sel_user[] IS NOT INITIAL.
    l_username = sel_user[ 1 ]-low.
  ENDIF.
    TRY.
  NEW lcl_local_runner( )->run( i_username = l_username i_dates = sel_date[] i_runtime = sel_runt[] i_rows = sel_rows[] ).
  CATCH cx_salv_msg INTO DATA(e1).
    WRITE: / 'Error (ALV):', e1->get_text( ).
  CATCH cx_parameter_invalid_range INTO DATA(e2).
    WRITE: / 'Error (Parameter):', e2->get_text( ).
  CATCH cx_sy_buffer_overflow INTO DATA(e3).
    WRITE: / 'Error (Buffer Overflow):', e3->get_text( ).
  CATCH cx_sy_conversion_codepage INTO DATA(e4).
    WRITE: / 'Error (Codepage Conversion):', e4->get_text( ).
  CATCH cx_sy_compression_error INTO DATA(e5).
    WRITE: / 'Error (Compression):', e5->get_text( ).
ENDTRY.
