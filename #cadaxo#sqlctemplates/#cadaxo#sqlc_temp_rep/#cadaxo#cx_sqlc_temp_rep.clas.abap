class /CADAXO/CX_SQLC_TEMP_REP definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

*"* public components of class /CADAXO/CX_SQLC_TEMP_REP
*"* do not include other source files here!!!
public section.

  constants /CADAXO/CX_SQLC_TEMP_REP type SOTR_CONC value 'B9FEEE4DCBCF331FE1000000C0A8010A'. "#EC NOTEXT
  constants CANCEL type SOTR_CONC value 'E2FEEE4DCBCF331FE1000000C0A8010A'. "#EC NOTEXT
  constants INSERT_REPORT type SOTR_CONC value 'E3FEEE4DCBCF331FE1000000C0A8010A'. "#EC NOTEXT
  constants INTERNAL_ERROR type SOTR_CONC value 'B0FFEE4DCBCF331FE1000000C0A8010A'. "#EC NOTEXT
  constants INSERT_INCLUDE type SOTR_CONC value 'E1DBBD3EF61A1FF1BA9F00155D160106'. "#EC NOTEXT
  constants SAVE_SETTINGS type SOTR_CONC value 'E1DEEEEF777FCCF1BA9F00155D160106'. "#EC NOTEXT

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_TEMP_REP
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_TEMP_REP
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_TEMP_REP IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = /CADAXO/CX_SQLC_TEMP_REP .
 ENDIF.
endmethod.
ENDCLASS.
