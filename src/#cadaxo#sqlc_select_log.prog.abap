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

  SELECT-OPTIONS: sel_user FOR selected_user-uname NO INTERVALS NO-EXTENSION,
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

  NEW lcl_local_runner( )->run( i_username = l_username i_dates = sel_date[] i_runtime = sel_runt[] i_rows = sel_rows[] ).
