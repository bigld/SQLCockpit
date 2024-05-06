FUNCTION /cadaxo/sqlc_custom_csv_popup.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_ON_APPSERVER) TYPE  FLAG
*"  EXPORTING
*"     REFERENCE(EV_CANCEL) TYPE  ABAP_BOOL
*"  CHANGING
*"     REFERENCE(CS_CSV_ATTR) TYPE  /CADAXO/SQLC_CSV_CUST
*"----------------------------------------------------------------------
  CLEAR: g_cancel.
  CLEAR: rad_separated_by.
  CLEAR: g_csv_attr.

  appserver = i_on_appserver.
  g_csv_attr = cs_csv_attr.

  CALL SCREEN 0500 STARTING AT 40 4.

  cs_csv_attr = g_csv_attr.
  ev_cancel   = g_cancel.

  PERFORM free.

ENDFUNCTION.
