*---------------------------------------------------------------------*
*    view related data declarations
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
