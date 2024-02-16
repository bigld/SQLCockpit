class /CADAXO/CX_SQLC_NO_SOURCE definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_NO_SOURCE
*"* do not include other source files here!!!
public section.

  constants /CADAXO/CX_SQLC_NO_SOURCE type SOTR_CONC value '7FD8DB4DFE1C961DE1000000C0A8010A'. "#EC NOTEXT

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



CLASS /CADAXO/CX_SQLC_NO_SOURCE IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = /CADAXO/CX_SQLC_NO_SOURCE .
 ENDIF.
endmethod.
ENDCLASS.
