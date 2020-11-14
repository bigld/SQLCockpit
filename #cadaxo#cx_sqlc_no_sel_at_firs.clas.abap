class /CADAXO/CX_SQLC_NO_SEL_AT_FIRS definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_NO_SEL_AT_FIRS
*"* do not include other source files here!!!
public section.

  constants /CADAXO/CX_SQLC_NO_SEL_AT_FIRS type SOTR_CONC value '00155D16011C1EDB89CDB94F848B5F2D' ##NO_TEXT.
  constants /CADAXO/CX_SQLC_NO_SEL_TAB_1ST type SOTR_CONC value '00155D16011C1EDB89CDB94F848B7F2D' ##NO_TEXT.

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
