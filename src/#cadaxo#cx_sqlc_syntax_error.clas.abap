class /CADAXO/CX_SQLC_SYNTAX_ERROR definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_SYNTAX_ERROR
*"* do not include other source files here!!!
public section.

  constants /CADAXO/CX_SQLC_SYNTAX_ERROR type SOTR_CONC value '00155D16011C1ED6B3A9CCE5813047FE' ##NO_TEXT.
  data MESSAGE type STRING .
  data /CADAXO/MSGID type MSGID .
  data /CADAXO/MSGNR type MSGNR .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !MESSAGE type STRING optional
      !/CADAXO/MSGID type MSGID optional
      !/CADAXO/MSGNR type MSGNR optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_SYNTAX_ERROR
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_SYNTAX_ERROR
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_SYNTAX_ERROR IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = /CADAXO/CX_SQLC_SYNTAX_ERROR .
 ENDIF.
me->MESSAGE = MESSAGE .
me->/CADAXO/MSGID = /CADAXO/MSGID .
me->/CADAXO/MSGNR = /CADAXO/MSGNR .
  endmethod.
ENDCLASS.
