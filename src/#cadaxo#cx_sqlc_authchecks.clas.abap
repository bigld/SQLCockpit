class /CADAXO/CX_SQLC_AUTHCHECKS definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of NO_TABLE_AUTH,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '010',
      attr1 type scx_attrname value 'NOT_ALLOWED_TABLE',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_TABLE_AUTH .
  data NOT_ALLOWED_TABLE type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !NOT_ALLOWED_TABLE type STRING optional .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /CADAXO/CX_SQLC_AUTHCHECKS IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->NOT_ALLOWED_TABLE = NOT_ALLOWED_TABLE .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
