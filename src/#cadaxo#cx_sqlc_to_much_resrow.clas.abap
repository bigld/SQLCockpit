class /CADAXO/CX_SQLC_TO_MUCH_RESROW definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_TO_MUCH_RESROW
*"* do not include other source files here!!!
public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of /CADAXO/CX_SQLC_TO_MUCH_RESROW,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '077',
      attr1 type scx_attrname value 'MAX_NR_OF_SELECTS',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of /CADAXO/CX_SQLC_TO_MUCH_RESROW .
  data MAX_NR_OF_SELECTS type I .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MAX_NR_OF_SELECTS type I optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_TO_MUCH_RESROW
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_TO_MUCH_RESROW
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_TO_MUCH_RESROW IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MAX_NR_OF_SELECTS = MAX_NR_OF_SELECTS .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = /CADAXO/CX_SQLC_TO_MUCH_RESROW .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
