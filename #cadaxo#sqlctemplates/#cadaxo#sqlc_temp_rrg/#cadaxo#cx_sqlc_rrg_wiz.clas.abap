class /CADAXO/CX_SQLC_RRG_WIZ definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  constants:
    BEGIN OF wiz_checks,
        msgid TYPE symsgid VALUE '/CADAXO/SQLC_RRG',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF wiz_checks .
  constants:
    begin of SYMBOLS_NOT_SUPPORTED,
      msgid type symsgid value '/CADAXO/SQLC_RRG',
      msgno type symsgno value '010',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SYMBOLS_NOT_SUPPORTED .
  constants:
    begin of PARAMETERS_NOT_SUPPORED,
      msgid type symsgid value '/CADAXO/SQLC_RRG',
      msgno type symsgno value '009',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of PARAMETERS_NOT_SUPPORED .
  constants:
    begin of OLD_SYNTAX_NOT_SUPPORTED,
      msgid type symsgid value '/CADAXO/SQLC_RRG',
      msgno type symsgno value '008',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of OLD_SYNTAX_NOT_SUPPORTED .
  constants:
    begin of SELECT_STAR_NOT_SUPPORTED,
      msgid type symsgid value '/CADAXO/SQLC_RRG',
      msgno type symsgno value '007',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SELECT_STAR_NOT_SUPPORTED .
  constants:
    begin of SELECT_SINGLE_NOT_SUPPORTED,
      msgid type symsgid value '/CADAXO/SQLC_RRG',
      msgno type symsgno value '006',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SELECT_SINGLE_NOT_SUPPORTED .
  constants:
    begin of FILEDS_NOT_SUPPORTED,
      msgid type symsgid value '/CADAXO/SQLC_RRG',
      msgno type symsgno value '005',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of FILEDS_NOT_SUPPORTED .
  constants:
    begin of OBJECT_GENERATION_NOT_POSSIBLE,
      msgid type symsgid value '/CADAXO/SQLC_RRG',
      msgno type symsgno value '003',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of OBJECT_GENERATION_NOT_POSSIBLE .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional .
  class-methods RAISE_T100
    importing
      value(IV_MSGID) type SYMSGID default SY-MSGID
      value(IV_MSGNO) type SYMSGNO default SY-MSGNO
      value(IV_MSGV1) type SYMSGV default SY-MSGV1
      value(IV_MSGV2) type SYMSGV default SY-MSGV2
      value(IV_MSGV3) type SYMSGV default SY-MSGV3
      value(IV_MSGV4) type SYMSGV default SY-MSGV4
    raising
      /CADAXO/CX_SQLC_TEMP_RRG .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /CADAXO/CX_SQLC_RRG_WIZ IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.


  METHOD raise_t100.

    DATA: ls_t100_key TYPE scx_t100key.

    ls_t100_key-msgid = iv_msgid.
    ls_t100_key-msgno = iv_msgno.
    ls_t100_key-attr1 = iv_msgv1.
    ls_t100_key-attr2 = iv_msgv2.
    ls_t100_key-attr3 = iv_msgv3.
    ls_t100_key-attr4 = iv_msgv4.

    IF iv_msgid IS INITIAL.
      CLEAR ls_t100_key.
    ENDIF.

    RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rrg
      EXPORTING
        textid = ls_t100_key.

  ENDMETHOD.
ENDCLASS.
