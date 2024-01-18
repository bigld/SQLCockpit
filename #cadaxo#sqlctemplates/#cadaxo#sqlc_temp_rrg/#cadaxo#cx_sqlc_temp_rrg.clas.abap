CLASS /cadaxo/cx_sqlc_temp_rrg DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .

    CONSTANTS:
      BEGIN OF process_canceled,
        msgid TYPE symsgid VALUE '/CADAXO/SQLC',
        msgno TYPE symsgno VALUE '042',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF process_canceled .
    CONSTANTS:
      BEGIN OF system_error,
        msgid TYPE symsgid VALUE '/CADAXO/SQLC_UPDATE',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF system_error .

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL .
    CLASS-METHODS raise_t100
      IMPORTING
        VALUE(iv_msgid) TYPE symsgid DEFAULT sy-msgid
        VALUE(iv_msgno) TYPE symsgno DEFAULT sy-msgno
        VALUE(iv_msgv1) TYPE symsgv DEFAULT sy-msgv1
        VALUE(iv_msgv2) TYPE symsgv DEFAULT sy-msgv2
        VALUE(iv_msgv3) TYPE symsgv DEFAULT sy-msgv3
        VALUE(iv_msgv4) TYPE symsgv DEFAULT sy-msgv4
      RAISING
        /cadaxo/cx_sqlc_odata_gen .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /cadaxo/cx_sqlc_temp_rrg IMPLEMENTATION.


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
