class /CADAXO/CX_SQLC_AUTHCHECKS definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .
  interfaces IF_T100_DYN_MSG .

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


METHODS constructor
  IMPORTING
    textid LIKE if_t100_message=>t100key OPTIONAL
    previous LIKE previous OPTIONAL
    not_allowed_table TYPE STRING OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /CADAXO/CX_SQLC_AUTHCHECKS IMPLEMENTATION.


  METHOD CONSTRUCTOR ##ADT_SUPPRESS_GENERATION.

    SUPER->CONSTRUCTOR( PREVIOUS = PREVIOUS ).

    ME->NOT_ALLOWED_TABLE = NOT_ALLOWED_TABLE.

    CLEAR ME->TEXTID.
    IF TEXTID IS INITIAL.
      IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
    ELSE.
      IF_T100_MESSAGE~T100KEY = TEXTID.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
