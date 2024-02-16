class /CADAXO/CX_SQLC_SYMB_NOT_FOUND definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class /CADAXO/CX_SQLC_SYMB_NOT_FOUND
*"* do not include other source files here!!!
public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of /CADAXO/CX_SQLC_SYMB_NOT_FOUND,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '127',
      attr1 type scx_attrname value 'SYMBOL',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of /CADAXO/CX_SQLC_SYMB_NOT_FOUND .
  constants:
    begin of USED_MULTIVALUES_MUST_HAVE_ONE,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '128',
      attr1 type scx_attrname value 'SYMBOL',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of USED_MULTIVALUES_MUST_HAVE_ONE .
  constants:
    begin of DATATYPE_NOT_ALLOWED,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '129',
      attr1 type scx_attrname value '/CADAXO/DATAELEMENT',
      attr2 type scx_attrname value '/CADAXO/DATATYPE',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of DATATYPE_NOT_ALLOWED .
  constants:
    begin of DATAELEMENT_NOT_FOUND,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '123',
      attr1 type scx_attrname value '/CADAXO/DATAELEMENT',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of DATAELEMENT_NOT_FOUND .
  constants:
    begin of DATAELEMENT_LONGER_THAN_45,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '130',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of DATAELEMENT_LONGER_THAN_45 .
  data SYMBOL type /CADAXO/SQLCSYMBOL_NAME .
  data /CADAXO/DATAELEMENT type STRING .
  data /CADAXO/DATATYPE type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !SYMBOL type /CADAXO/SQLCSYMBOL_NAME optional
      !/CADAXO/DATAELEMENT type STRING optional
      !/CADAXO/DATATYPE type STRING optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_SYMB_NOT_FOUND
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_SYMB_NOT_FOUND
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_SYMB_NOT_FOUND IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->SYMBOL = SYMBOL .
me->/CADAXO/DATAELEMENT = /CADAXO/DATAELEMENT .
me->/CADAXO/DATATYPE = /CADAXO/DATATYPE .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = /CADAXO/CX_SQLC_SYMB_NOT_FOUND .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
