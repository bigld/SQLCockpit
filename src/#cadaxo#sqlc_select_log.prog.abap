REPORT /cadaxo/sqlc_select_log.
INCLUDE /cadaxo/sqlc_select_log_c01.

SELECTION-SCREEN BEGIN OF BLOCK sel WITH FRAME TITLE TEXT-t01.
*PARAMETERS puser TYPE uname.
*PARAMETERS puser TYPE /cadaxo/sqlclog-uname.
*PARAMETERS date TYPE /cadaxo/sqlclogalv-execute_date.
SELECTION-SCREEN ULINE.
DATA: puser TYPE /cadaxo/sqlclog-uname,
      date TYPE /cadaxo/sqlclogalv-execute_date,
      runtime TYPE /cadaxo/sqlclogalv-result_runtime,
      rows TYPE /cadaxo/sqlclogalv-result_rows.

SELECT-OPTIONS: sel_user FOR puser NO INTERVALS NO-EXTENSION,
                sel_date FOR date NO-EXTENSION.
*                sel_runt FOR runtime NO INTERVALS NO-EXTENSION,
*                sel_rows for rows NO-EXTENSION.
SELECTION-SCREEN ULINE.

SELECT-OPTIONS:
* sel_user FOR puser NO INTERVALS NO-EXTENSION,
*                sel_date FOR date NO-EXTENSION,
                sel_runt FOR runtime NO INTERVALS NO-EXTENSION,
                sel_rows for rows NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK sel.



START-OF-SELECTION.
NEW lcl_local_runner( )->run( i_username = puser ).
