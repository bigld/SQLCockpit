FUNCTION /cadaxo/sqlctippsandtricks.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EV_RELEASE_TYPE) TYPE  /CADAXO/SQLCRELEASE_TYPE
*"  EXCEPTIONS
*"      CANCEL_BY_USER
*"----------------------------------------------------------------------

  DATA(lv_col) = ( sy-scols / 2 ) - 40.
  DATA(lv_row) = 1.
  DATA(lv_col_t) = lv_col + 78.
  DATA(lv_row_t) = lv_row + 25.

  CALL SCREEN 100 STARTING AT lv_col lv_row ENDING AT lv_col_t lv_row_t.

  ev_release_type = gv_release_type.

ENDFUNCTION.
