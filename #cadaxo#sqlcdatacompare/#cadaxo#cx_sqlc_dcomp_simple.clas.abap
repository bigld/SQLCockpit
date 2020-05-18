class /CADAXO/CX_SQLC_DCOMP_SIMPLE definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_DCOMP_SIMPLE
*"* do not include other source files here!!!
public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of ALL_KEY_FIELDS_REQUIRED,
      msgid type symsgid value '/CADAXO/SQLC_COMPARE',
      msgno type symsgno value '001',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ALL_KEY_FIELDS_REQUIRED .
  constants:
    begin of NO_JOINS_ALLOWED,
      msgid type symsgid value '/CADAXO/SQLC_COMPARE',
      msgno type symsgno value '002',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_JOINS_ALLOWED .
  constants:
    begin of SAME_KEY_FIELDS_REQUIRED,
      msgid type symsgid value '/CADAXO/SQLC_COMPARE',
      msgno type symsgno value '003',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SAME_KEY_FIELDS_REQUIRED .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_DCOMP_SIMPLE
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_DCOMP_SIMPLE
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_DCOMP_SIMPLE IMPLEMENTATION.


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
