*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_/CADAXO/SQLCJCPO
*   generation date: 24.02.2021 at 09:04:48
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_/CADAXO/SQLCJCPO   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
