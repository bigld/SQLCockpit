FUNCTION /cadaxo/sqlc_sql_search .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     VALUE(CV_SEARCH_STRING) TYPE  STRING
*"----------------------------------------------------------------------
** calculate the dynpro positions
  g_col = ( sy-scols / 2 ) - 50.
  g_row = ( sy-srows / 2 ) - 6.
  g_col_t = g_col + 120.
  g_row_t = g_row + 6.

* call the template selection screen
  CALL SCREEN 3001 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

  cv_search_string = gv_search_string.

ENDFUNCTION.
