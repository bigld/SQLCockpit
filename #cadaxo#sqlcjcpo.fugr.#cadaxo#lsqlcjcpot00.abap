*---------------------------------------------------------------------*
*    view related data declarations
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
