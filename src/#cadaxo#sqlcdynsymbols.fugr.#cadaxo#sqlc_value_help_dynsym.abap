FUNCTION /cadaxo/sqlc_value_help_dynsym.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(E_SYMBOL_NAME) TYPE  /CADAXO/SQLCSYMBOL_NAME
*"     REFERENCE(E_SYMBOL_VALUE) TYPE  /CADAXO/SQLCSYMBOL_VALUE
*"  EXCEPTIONS
*"      NO_SYMBOL_SELECTED
*"----------------------------------------------------------------------

  CALL SCREEN 0100 STARTING AT 25 5 ENDING AT 106 20.

  g_symbol_name = e_symbol_name.

ENDFUNCTION.
