FUNCTION /CADAXO/SQLC_UT_VALUE_POPUP.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_EDIT) TYPE  ABAP_BOOL OPTIONAL
*"  EXPORTING
*"     REFERENCE(EV_CHANGED) TYPE  ABAP_BOOL
*"  CHANGING
*"     REFERENCE(CV_VALUE) TYPE  ANY
*"----------------------------------------------------------------------
** calculate the dynpro positions

  g_col   = ( sy-scols / 4 ).
  g_row   = ( sy-srows / 10 ).
  g_col_t = g_col + 113.
  g_row_t = g_row + 17.

  gv_edit       = iv_edit.
  gv_changed    = ev_changed.
  gv_value      = cv_value.
  gr_datadescr ?= cl_abap_datadescr=>describe_by_data( p_data = cv_value ).

* call the template selection screen
  CALL SCREEN 100 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

  IF ( gv_changed = abap_true ).
    cv_value   = gv_value.
    ev_changed = gv_changed.
  ENDIF.

ENDFUNCTION.
