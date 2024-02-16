*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: /CADAXO/SQLCVGRV................................*
TABLES: /CADAXO/SQLCVGRV, */CADAXO/SQLCVGRV. "view work areas
CONTROLS: TCTRL_/CADAXO/SQLCVGRV
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_/CADAXO/SQLCVGRV. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_/CADAXO/SQLCVGRV.
* Table for entries selected to show on screen
DATA: BEGIN OF /CADAXO/SQLCVGRV_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE /CADAXO/SQLCVGRV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /CADAXO/SQLCVGRV_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF /CADAXO/SQLCVGRV_TOTAL OCCURS 0010.
INCLUDE STRUCTURE /CADAXO/SQLCVGRV.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF /CADAXO/SQLCVGRV_TOTAL.

*.........table declarations:.................................*
TABLES: /CADAXO/SQLCVGRP               .
TABLES: /CADAXO/SQLCVGRT               .
