*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 19.02.2013 at 10:49:53 by user CADAXO
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: /CADAXO/SQLCTEMT................................*
DATA:  BEGIN OF STATUS_/CADAXO/SQLCTEMT              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_/CADAXO/SQLCTEMT              .
CONTROLS: TCTRL_/CADAXO/SQLCTEMT
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: /CADAXO/SQLCTEMV................................*
TABLES: /CADAXO/SQLCTEMV, */CADAXO/SQLCTEMV. "view work areas
CONTROLS: TCTRL_/CADAXO/SQLCTEMV
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_/CADAXO/SQLCTEMV. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/CADAXO/SQLCTEMV.
* Table for entries selected to show on screen
DATA: BEGIN OF /CADAXO/SQLCTEMV_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /CADAXO/SQLCTEMV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /CADAXO/SQLCTEMV_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /CADAXO/SQLCTEMV_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /CADAXO/SQLCTEMV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /CADAXO/SQLCTEMV_TOTAL.

*.........table declarations:.................................*
TABLES: */CADAXO/SQLCTEMT              .
TABLES: /CADAXO/SQLCTEMP               .
TABLES: /CADAXO/SQLCTEMT               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
