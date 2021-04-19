*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 14.04.2021 at 11:30:18
*   view maintenance generator version: #001407#
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
