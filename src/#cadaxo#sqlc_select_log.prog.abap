REPORT /cadaxo/sqlc_select_log.

SELECTION-SCREEN BEGIN OF BLOCK sel WITH FRAME TITLE TEXT-t01.
PARAMETERS puser TYPE uname.
SELECTION-SCREEN END OF BLOCK sel.

START-OF-SELECTION.
AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
IF sy-subrc <> 0.
MESSAGE e036(/cadaxo/sqlc).
ENDIF.

*SELECT * FROM /cadaxo/sqlclog PACKAGE SIZE 1000
*       INTO TABLE gt_sqlclog WHERE uname IN so_uname
*                               AND timestamp      NOT BETWEEN gt_sel_timestamp-low AND gt_sel_timestamp-high
*                               AND result_runtime IN so_runt
*                               AND result_rows    IN so_rrows.
*      APPEND LINES OF /cadaxo/cl_sqlc_user_hist_log=>convert_to_alv( gt_sqlclog ) TO gt_sqlclogalv.
*    ENDSELECT.

SELECT FROM /cadaxo/sqlclog FIELDS * WHERE uname = @puser INTO TABLE @DATA(selects).

cl_salv_table=>factory(
*  EXPORTING
*    list_display   = if_salv_c_bool_sap=>false
*    r_container    =
*    container_name =
  IMPORTING
    r_salv_table   = DATA(selects_alv)
  CHANGING
    t_table        = selects
).
*CATCH cx_salv_msg.

selects_alv->display( ).
