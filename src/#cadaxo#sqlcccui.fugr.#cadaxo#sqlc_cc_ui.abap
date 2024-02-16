FUNCTION /cadaxo/sqlc_cc_ui.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_ABAPEDIT) TYPE REF TO  /CADAXO/CL_SQLC_GUI_ABAPEDIT
*"  EXPORTING
*"     REFERENCE(E_STRING) TYPE  STRING
*"----------------------------------------------------------------------

* Import ABAP Editor object
  go_abapedit = i_abapedit.

* Call screen
  CALL SCREEN 0100 STARTING AT 20 2 ENDING AT 140 23.

* Insert the result string
  IF g_ins EQ abap_true.
    e_string = go_join->gv_result.
    g_ins = abap_false.
  ENDIF.

  CLEAR: go_join.

ENDFUNCTION.
