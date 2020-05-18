*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_/CADAXO/SQLCHECL
*   generation date: 30.10.2019 at 23:46:31
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_/CADAXO/SQLCHECL   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
