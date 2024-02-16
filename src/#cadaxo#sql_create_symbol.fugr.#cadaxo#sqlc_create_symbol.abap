FUNCTION /CADAXO/SQLC_CREATE_SYMBOL.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_ROLLNAME) TYPE  ROLLNAME
*"     REFERENCE(IT_SYMBOL_VALUES) TYPE  ANY TABLE
*"----------------------------------------------------------------------
** calculate the dynpro positions

  DATA ls_seldata TYPE rsdsselopt.
  FIELD-SYMBOLS: <ls_symbol_value> TYPE any.

  g_col = ( sy-scols / 2 ) - 50.
  g_row = ( sy-srows / 2 ) - 6.
  g_col_t = g_col + 74.
  g_row_t = g_row + 6.

  gv_rollname = iv_rollname.

  CLEAR gt_sel_data.
  LOOP AT it_symbol_values ASSIGNING <ls_symbol_value>.
    IF <ls_symbol_value> IS NOT INITIAL.
      ls_seldata-sign = 'I'.
      ls_seldata-option = 'EQ'.
      ls_seldata-low = <ls_symbol_value>.
      APPEND ls_seldata TO gt_sel_data.
    ENDIF.
  ENDLOOP.

  IF gt_sel_data IS INITIAL.
    MESSAGE i139(/cadaxo/sqlc).
    RETURN.
  ENDIF.

  SORT gt_sel_data BY low.
  DELETE ADJACENT DUPLICATES FROM gt_sel_data COMPARING low.

  CALL SCREEN 3001 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

ENDFUNCTION.
