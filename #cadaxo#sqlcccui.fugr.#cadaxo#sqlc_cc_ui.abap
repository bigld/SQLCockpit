FUNCTION /cadaxo/sqlc_cc_ui.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_ABAPEDIT) TYPE REF TO  /CADAXO/CL_SQLC_GUI_ABAPEDIT
*"  EXPORTING
*"     REFERENCE(E_STRING) TYPE  STRING
*"----------------------------------------------------------------------

* Calculate the dynpro positions
  g_col = ( sy-scols / 2 ) - 92.
  g_row = 1.
  g_col_t = g_col + 125.
  g_row_t = g_row + 20.

* Import ABAP Editor object
  go_abapedit = i_abapedit.

* Call screen
  CALL SCREEN 0100 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

* Insert the result string
  IF g_ins EQ abap_true.
    e_string = go_join->gv_result.
    g_ins = abap_false.
  ENDIF.

  CLEAR: go_join.

ENDFUNCTION.
