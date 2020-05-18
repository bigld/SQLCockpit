class /CADAXO/CX_SQLC_TYPE_NOT_FOUND definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_TYPE_NOT_FOUND
*"* do not include other source files here!!!
public section.

  constants /CADAXO/CX_SQLC_TYPE_NOT_FOUND type SOTR_CONC value '5CD8DB4DFE1C961DE1000000C0A8010A'. "#EC NOTEXT
  data TYPE type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !TYPE type STRING optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_TYPE_NOT_FOUND
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_TYPE_NOT_FOUND
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_TYPE_NOT_FOUND IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = /CADAXO/CX_SQLC_TYPE_NOT_FOUND .
 ENDIF.
me->TYPE = TYPE .
endmethod.
ENDCLASS.
