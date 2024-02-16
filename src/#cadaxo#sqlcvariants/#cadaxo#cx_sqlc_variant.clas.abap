class /CADAXO/CX_SQLC_VARIANT definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_VARIANT
*"* do not include other source files here!!!
public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of VARIANT_NOT_FOUND,
      msgid type symsgid value '/CADAXO/SQLCVARIANTS',
      msgno type symsgno value '001',
      attr1 type scx_attrname value 'VARIANT',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of VARIANT_NOT_FOUND .
  constants:
    begin of NO_AUTH_TO_DEL_GLOB_VARIANT,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '033',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_AUTH_TO_DEL_GLOB_VARIANT .
  constants:
    begin of VARIANT_IS_LOCKED,
      msgid type symsgid value '/CADAXO/SQLCVARIANTS',
      msgno type symsgno value '007',
      attr1 type scx_attrname value 'USERID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of VARIANT_IS_LOCKED .
  constants:
    begin of NO_AUTH_TO_RENAME_GLOB_VARI,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '032',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_AUTH_TO_RENAME_GLOB_VARI .
  constants:
    begin of NO_AUTH_TO_SET_VAR_TO_PUBLIC,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '032',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_AUTH_TO_SET_VAR_TO_PUBLIC .
  data VARIANT type /CADAXO/SQLC_VARIANT_GUID .
  data USERID type UNAME .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !VARIANT type /CADAXO/SQLC_VARIANT_GUID optional
      !USERID type UNAME optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_VARIANT
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_VARIANT
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_VARIANT IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->VARIANT = VARIANT .
me->USERID = USERID .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
