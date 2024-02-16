class /CADAXO/CX_SQLC_INVALID_VALUE definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_INVALID_VALUE
*"* do not include other source files here!!!
public section.

  constants /CADAXO/CX_SQLC_INVALID_VALUE type SOTR_CONC value 'E29D030E4A2BAEF19FB300155D160106' ##NO_TEXT.
  constants OPEN_LITERAL type SOTR_CONC value 'E3D7BEACD1DDF8F1994B00155D160106' ##NO_TEXT.
  constants TOO_MUCH_LITERALS type SOTR_CONC value '00155D16011C1EE79EB758DB9AAF56F6' ##NO_TEXT.
  data VALUE type STRING .
  data FIELD type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !VALUE type STRING optional
      !FIELD type STRING optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_TYPE_NOT_FOUND
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_INVALID_VALUE
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_INVALID_VALUE IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = /CADAXO/CX_SQLC_INVALID_VALUE .
 ENDIF.
me->VALUE = VALUE .
me->FIELD = FIELD .
  endmethod.
ENDCLASS.
