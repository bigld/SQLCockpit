*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 24.02.2021 at 09:04:48
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: /CADAXO/SQLCJCPO................................*
DATA:  BEGIN OF STATUS_/CADAXO/SQLCJCPO              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/CADAXO/SQLCJCPO              .
CONTROLS: TCTRL_/CADAXO/SQLCJCPO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */CADAXO/SQLCJCPO              .
TABLES: /CADAXO/SQLCJCPO               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
