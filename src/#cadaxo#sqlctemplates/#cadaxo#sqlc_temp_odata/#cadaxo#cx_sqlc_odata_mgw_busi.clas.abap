class /CADAXO/CX_SQLC_ODATA_MGW_BUSI definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of SQL_FILTER,
      msgid type symsgid value '/IWBEP/CM_MGW_RT',
      msgno type symsgno value '063',
      attr1 type scx_attrname value 'FILTER_PARAM',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SQL_FILTER .
  constants:
    begin of FILTER_CRITERIA,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '161',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of FILTER_CRITERIA .
  data FILTER_PARAM type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !FILTER_PARAM type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS /CADAXO/CX_SQLC_ODATA_MGW_BUSI IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->FILTER_PARAM = FILTER_PARAM .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
