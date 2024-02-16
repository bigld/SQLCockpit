*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /CADAXO/SQLCRELI................................*
DATA:  BEGIN OF STATUS_/CADAXO/SQLCRELI              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/CADAXO/SQLCRELI              .
CONTROLS: TCTRL_/CADAXO/SQLCRELI
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: */CADAXO/SQLCRELI              .
TABLES: /CADAXO/SQLCRELI               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
