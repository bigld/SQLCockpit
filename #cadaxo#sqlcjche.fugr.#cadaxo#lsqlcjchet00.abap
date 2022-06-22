*---------------------------------------------------------------------*
*    view related data declarations
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
