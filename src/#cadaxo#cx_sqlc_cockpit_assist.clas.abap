class /CADAXO/CX_SQLC_COCKPIT_ASSIST definition
  public
  inheriting from CX_NO_CHECK
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of DRAGDROPDOUBLECLICK_NOT_SUPPOR,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '006',
      attr1 type scx_attrname value '/CADAXO/GV_TYP',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of DRAGDROPDOUBLECLICK_NOT_SUPPOR .
  data /CADAXO/GV_TYP type CHAR1 .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !/CADAXO/GV_TYP type CHAR1 optional .
protected section.
private section.
ENDCLASS.



CLASS /CADAXO/CX_SQLC_COCKPIT_ASSIST IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->/CADAXO/GV_TYP = /CADAXO/GV_TYP .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
