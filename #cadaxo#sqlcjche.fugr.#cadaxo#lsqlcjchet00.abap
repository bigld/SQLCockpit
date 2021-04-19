*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 08.03.2021 at 14:04:22
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: /CADAXO/SQLCJCHE................................*
DATA:  BEGIN OF STATUS_/CADAXO/SQLCJCHE              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/CADAXO/SQLCJCHE              .
CONTROLS: TCTRL_/CADAXO/SQLCJCHE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */CADAXO/SQLCJCHE              .
TABLES: /CADAXO/SQLCJCHE               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
