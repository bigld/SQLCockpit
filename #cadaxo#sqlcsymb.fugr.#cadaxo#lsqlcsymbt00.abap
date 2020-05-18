*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 10.10.2012 at 19:38:32 by user CADAXO
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: /CADAXO/SQLCSYMB................................*
DATA:  BEGIN OF STATUS_/CADAXO/SQLCSYMB              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/CADAXO/SQLCSYMB              .
CONTROLS: TCTRL_/CADAXO/SQLCSYMB
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: */CADAXO/SQLCSYMB              .
TABLES: /CADAXO/SQLCSYMB               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
