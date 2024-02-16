class /CADAXO/CX_SQLC_DCOMP_FIELDMAP definition
  public
  inheriting from /CADAXO/CX_SQLC_DCOMP_COMPLEX
  create public .

*"* public components of class /CADAXO/CX_SQLC_DCOMP_FIELDMAP
*"* do not include other source files here!!!
public section.

  constants:
    begin of INVALID_TYPES,
      msgid type symsgid value '/CADAXO/SQLC_COMPARE',
      msgno type symsgno value '004',
      attr1 type scx_attrname value 'MV_FIELDNAME_SOURCE',
      attr2 type scx_attrname value 'IV_MSG1',
      attr3 type scx_attrname value 'MV_FIELDNAME_TARGET',
      attr4 type scx_attrname value 'IV_MSG2',
    end of INVALID_TYPES .
  constants:
    begin of MAPPING_EXISTS,
      msgid type symsgid value '/CADAXO/SQLC_COMPARE',
      msgno type symsgno value '005',
      attr1 type scx_attrname value 'IV_MSG1',
      attr2 type scx_attrname value 'IV_MSG2',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of MAPPING_EXISTS .
  constants:
    begin of INVALID_INDEX,
      msgid type symsgid value '/CADAXO/SQLC_COMPARE',
      msgno type symsgno value '006',
      attr1 type scx_attrname value 'IV_MSG2',
      attr2 type scx_attrname value 'IV_MSG1',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_INDEX .
  constants:
    begin of INVALID_FIELDNAME,
      msgid type symsgid value '/CADAXO/SQLC_COMPARE',
      msgno type symsgno value '007',
      attr1 type scx_attrname value 'IV_MSG2',
      attr2 type scx_attrname value 'IV_MSG1',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_FIELDNAME .
  data MV_FIELDNAME_SOURCE type FIELDNAME .
  data MV_FIELDNAME_TARGET type FIELDNAME .
  data IV_MSG1 type SYST_MSGV .
  data IV_MSG2 type SYST_MSGV .
  data IV_MSG3 type SYST_MSGV .
  data IV_MSG4 type SYST_MSGV .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MV_FIELDNAME_SOURCE type FIELDNAME optional
      !MV_FIELDNAME_TARGET type FIELDNAME optional
      !IV_MSG1 type SYST_MSGV optional
      !IV_MSG2 type SYST_MSGV optional
      !IV_MSG3 type SYST_MSGV optional
      !IV_MSG4 type SYST_MSGV optional .
protected section.
*"* protected components of class /CADAXO/CX_SQLC_DCOMP_FIELDMAP
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CX_SQLC_DCOMP_FIELDMAP
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CX_SQLC_DCOMP_FIELDMAP IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MV_FIELDNAME_SOURCE = MV_FIELDNAME_SOURCE .
me->MV_FIELDNAME_TARGET = MV_FIELDNAME_TARGET .
me->IV_MSG1 = IV_MSG1 .
me->IV_MSG2 = IV_MSG2 .
me->IV_MSG3 = IV_MSG3 .
me->IV_MSG4 = IV_MSG4 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
