class /CADAXO/CX_SQLC_TEMP_RRG definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  constants:
    BEGIN OF process_canceled,
        msgid TYPE symsgid VALUE '/CADAXO/SQLC',
        msgno TYPE symsgno VALUE '042',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF process_canceled .
  constants:
    BEGIN OF system_error,
        msgid TYPE symsgid VALUE '/CADAXO/SQLC_UPDATE',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF system_error .

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
      /CADAXO/CX_SQLC_ODATA_GEN .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /CADAXO/CX_SQLC_TEMP_RRG IMPLEMENTATION.


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

    RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_odata_gen
      EXPORTING
        textid = ls_t100_key.

  ENDMETHOD.
ENDCLASS.
