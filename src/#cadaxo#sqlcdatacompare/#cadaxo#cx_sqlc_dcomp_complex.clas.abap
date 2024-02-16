class /CADAXO/CX_SQLC_DCOMP_COMPLEX definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

*"* public components of class /CADAXO/CX_SQLC_DCOMP_COMPLEX
*"* do not include other source files here!!!
public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of NO_FURTHER_DIFFERNCE,
      msgid type symsgid value '/CADAXO/SQLC_COMPARE',
      msgno type symsgno value '008',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_FURTHER_DIFFERNCE .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_DCOMP_COMPLEX
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_DCOMP_COMPLEX
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_DCOMP_COMPLEX IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
