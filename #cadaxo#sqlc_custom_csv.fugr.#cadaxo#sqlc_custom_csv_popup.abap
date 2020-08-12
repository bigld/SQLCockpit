FUNCTION /cadaxo/sqlc_custom_csv_popup.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     REFERENCE(CS_CSV_ATTR) TYPE  /CADAXO/SQLC_CSV_CUST
*"  EXPORTING
*"     REFERENCE(EV_CANCEL) TYPE  ABAP_BOOL
*"----------------------------------------------------------------------

  CALL SCREEN 0500 STARTING AT 40 4." ENDING AT 150 7.
  cs_csv_attr = g_csv_attr.
  ev_cancel = g_cancel.
  PERFORM free.
ENDFUNCTION.
