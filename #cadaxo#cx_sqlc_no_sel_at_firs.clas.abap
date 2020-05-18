class /CADAXO/CX_SQLC_NO_SEL_AT_FIRS definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_NO_SEL_AT_FIRS
*"* do not include other source files here!!!
public section.

  constants /CADAXO/CX_SQLC_NO_SEL_AT_FIRS type SOTR_CONC value 'B9F04F4CA5F3071FE1000000C0A8010A'. "#EC NOTEXT

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_NO_SEL_AT_FIRS
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_NO_SEL_AT_FIRS
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_NO_SEL_AT_FIRS IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = /CADAXO/CX_SQLC_NO_SEL_AT_FIRS .
 ENDIF.
endmethod.
ENDCLASS.
