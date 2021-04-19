*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_/CADAXO/SQLCJCHE
*   generation date: 08.03.2021 at 14:04:22
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_/CADAXO/SQLCJCHE   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
