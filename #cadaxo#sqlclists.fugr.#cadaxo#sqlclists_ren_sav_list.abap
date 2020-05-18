FUNCTION /cadaxo/sqlclists_ren_sav_list.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(E_RC) TYPE  CHAR1
*"  CHANGING
*"     REFERENCE(C_DESCRIPTION) TYPE  /CADAXO/SQLC_LIST_DESCRIPTION
*"----------------------------------------------------------------------

  g_sqlcsres-description = c_description.

  CALL SCREEN 0100 STARTING AT 10 10 ENDING AT 80 20.

  c_description = g_sqlcsres-description.

  e_rc = g_rc.
ENDFUNCTION.
