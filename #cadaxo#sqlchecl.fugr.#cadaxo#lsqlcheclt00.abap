*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 30.10.2019 at 23:46:31
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: /CADAXO/SQLCHECL................................*
DATA:  BEGIN OF STATUS_/CADAXO/SQLCHECL              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/CADAXO/SQLCHECL              .
CONTROLS: TCTRL_/CADAXO/SQLCHECL
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: */CADAXO/SQLCHECL              .
TABLES: /CADAXO/SQLCHECL               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
