FUNCTION /CADAXO/SQLC_SHARE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_EXPORT_TYPE) TYPE  /CADAXO/SQLCAPI_POSITION_TYP
*"     VALUE(IT_SYMBOLS) TYPE  /CADAXO/SQLC_SYMBOL_T OPTIONAL
*"     VALUE(IT_SQL) TYPE  /CADAXO/SQLCCODELINE_T OPTIONAL
*"     VALUE(IS_VARIANT) TYPE  /CADAXO/SQLC_IL_VARIANTS OPTIONAL
*"     VALUE(IS_SAVED_LIST) TYPE  /CADAXO/SQLC_LIST_EXP_SQLX OPTIONAL
*"----------------------------------------------------------------------
** calculate the dynpro positions
  g_col = ( sy-scols / 2 ) - 50.
  g_row = ( sy-srows / 2 ) - 6.
  g_col_t = g_col + 100.
  g_row_t = g_row + 12.

  CLEAR: g_receiver,
         gt_sql_cockpit_standard_users,
         g_rfcdest.

  IF gt_sql_cockpit_standard_users IS INITIAL.
    gt_sql_cockpit_standard_users = /cadaxo/cl_sqlc_cockpit_assist=>get_sql_cockpit_standard_users( ).
  ENDIF.

  gv_export_type = iv_export_type.
  gt_symbols     = it_symbols.
  gt_sql         = it_sql.
  gs_variant     = is_variant.
  gs_saved_list  = is_saved_list.

  CALL SCREEN 3001 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

ENDFUNCTION.
