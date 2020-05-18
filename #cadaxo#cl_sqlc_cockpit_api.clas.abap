CLASS /cadaxo/cl_sqlc_cockpit_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS: BEGIN OF sender_typ,
                 default TYPE /cadaxo/sqlcapi_sender_typ VALUE 'US' ##NO_TEXT,
                 user    TYPE /cadaxo/sqlcapi_sender_typ VALUE 'US' ##NO_TEXT,
               END OF sender_typ.
    CONSTANTS c_default_receiver_typ TYPE /cadaxo/sqlcapi_receiver_typ VALUE 'US' ##NO_TEXT.
    CONSTANTS c_default_expiration TYPE /cadaxo/sqlcapi_expiration VALUE '14' ##NO_TEXT.
    CONSTANTS: BEGIN OF status,
                 default TYPE /cadaxo/sqlcapi_status VALUE 'U' ##NO_TEXT,
                 block   TYPE /cadaxo/sqlcapi_status VALUE 'B' ##NO_TEXT,
                 read    TYPE /cadaxo/sqlcapi_status VALUE 'R' ##NO_TEXT,
               END OF status.
    CONSTANTS:
      BEGIN OF cs_api_types,
        sql     TYPE /cadaxo/sqlcapi_position_typ VALUE 1,
        symbols TYPE /cadaxo/sqlcapi_position_typ VALUE 3,
        variant TYPE /cadaxo/sqlcapi_position_typ VALUE 5,
        saved   TYPE /cadaxo/sqlcapi_position_typ VALUE 6,
      END OF cs_api_types .

    CLASS-METHODS create_share_factory
      IMPORTING
        VALUE(iv_description)  TYPE /cadaxo/sqlcapi_description OPTIONAL
        VALUE(iv_sender)       TYPE /cadaxo/sqlcapi_sender OPTIONAL
        VALUE(iv_sender_typ)   TYPE /cadaxo/sqlcapi_sender_typ OPTIONAL
        VALUE(iv_receiver)     TYPE /cadaxo/sqlcapi_receiver OPTIONAL
        VALUE(iv_receiver_typ) TYPE /cadaxo/sqlcapi_receiver_typ OPTIONAL
        VALUE(iv_expiration)   TYPE /cadaxo/sqlcapi_expiration OPTIONAL
        VALUE(iv_rfcdest)      TYPE /cadaxo/sqlcapi_rfcdest OPTIONAL
      RETURNING
        VALUE(ro_instance)     TYPE REF TO /cadaxo/cl_sqlc_cockpit_api .
    METHODS set_status
      IMPORTING
        VALUE(iv_new_status) TYPE /cadaxo/sqlcapi_status .
    METHODS add_item
      IMPORTING
        VALUE(iv_typ)  TYPE /cadaxo/sqlcapi_position_typ
        VALUE(iv_data) TYPE any .
    METHODS get_items
      IMPORTING
        VALUE(iv_id)    TYPE /cadaxo/sqlcapi_id
      RETURNING
        VALUE(rt_items) TYPE /cadaxo/sqlcapip_t .
    METHODS get_item
      IMPORTING
        VALUE(iv_pos_line) TYPE /cadaxo/sqlcapip
      EXPORTING
        VALUE(rt_item)     TYPE ANY TABLE .
    METHODS delete_header_and_positions .
    CLASS-METHODS get_own_queue
      RETURNING
        VALUE(rt_queue) TYPE /cadaxo/sqlcapi_queue_t .
    CLASS-METHODS get_share_factory
      IMPORTING
        VALUE(iv_id)       TYPE /cadaxo/sqlcapi_id
      RETURNING
        VALUE(ro_instance) TYPE REF TO /cadaxo/cl_sqlc_cockpit_api .
    CLASS-METHODS check_own_queue
      RETURNING
        VALUE(rv_unread) TYPE boolean .
  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA gv_header_id TYPE /cadaxo/sqlcapi_id .

    METHODS create_header_db
      IMPORTING
        VALUE(iv_description)  TYPE /cadaxo/sqlcapi_description OPTIONAL
        VALUE(iv_sender)       TYPE /cadaxo/sqlcapi_sender OPTIONAL
        VALUE(iv_sender_typ)   TYPE /cadaxo/sqlcapi_sender_typ OPTIONAL
        VALUE(iv_receiver)     TYPE /cadaxo/sqlcapi_receiver OPTIONAL
        VALUE(iv_receiver_typ) TYPE /cadaxo/sqlcapi_receiver_typ OPTIONAL
        VALUE(iv_expiration)   TYPE /cadaxo/sqlcapi_expiration OPTIONAL
        VALUE(iv_rfcdest)      TYPE /cadaxo/sqlcapi_rfcdest OPTIONAL .
    METHODS create_description_db
      IMPORTING
        VALUE(iv_description) TYPE /cadaxo/sqlcapi_description .
    METHODS check_initial_value
      IMPORTING
        !iv_value       TYPE any
        !iv_default     TYPE any
      EXPORTING
        VALUE(ev_value) TYPE any .
    METHODS set_header_id
      IMPORTING
        !iv_id TYPE /cadaxo/sqlcapi_id .
ENDCLASS.



CLASS /CADAXO/CL_SQLC_COCKPIT_API IMPLEMENTATION.


  METHOD add_item.
****************************************************************************************************
* Description             : Add Item                                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Adds an API Item                                                                                 *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*26.01.2017  | Pat                  | export symbols                              | COCKPIT-294    *
*08.10.2019  | Pat                  | export results                              | COCKPIT-401    *
****************************************************************************************************

    DATA ls_pos TYPE /cadaxo/sqlcapip.
    DATA lv_sql_data TYPE string.

    TRY.
        ls_pos-id = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_uuid_error.
    ENDTRY.

    ls_pos-id_hdr = gv_header_id.
    ls_pos-typ    = iv_typ.

    CASE iv_typ.
      WHEN cs_api_types-sql.

        ls_pos-version = /cadaxo/cl_sqlc_api_ot_sql=>/cadaxo/if_api_objecttype~get_version( ).
        /cadaxo/cl_sqlc_api_ot_sql=>/cadaxo/if_api_objecttype~prepare_import( EXPORTING iv_data = iv_data
                                                                              IMPORTING ev_data = DATA(lv_data) ).

      WHEN cs_api_types-symbols.

        ls_pos-version = /cadaxo/cl_sqlc_api_ot_symbol=>/cadaxo/if_api_objecttype~get_version( ).                           "COCKPIT-294
        /cadaxo/cl_sqlc_api_ot_symbol=>/cadaxo/if_api_objecttype~prepare_import( EXPORTING iv_data = iv_data                "COCKPIT-294
                                                                                 IMPORTING ev_data = lv_data ).             "COCKPIT-294

      WHEN cs_api_types-variant.
        ls_pos-version = /cadaxo/cl_sqlc_api_ot_sql=>/cadaxo/if_api_objecttype~get_version( ).
        /cadaxo/cl_sqlc_api_ot_variant=>/cadaxo/if_api_objecttype~prepare_import( EXPORTING iv_data = iv_data
                                                                                  IMPORTING ev_data = lv_data ).

      WHEN cs_api_types-saved.
        ls_pos-version = /cadaxo/cl_sqlc_api_ot_saved=>/cadaxo/if_api_objecttype~get_version( ).
        /cadaxo/cl_sqlc_api_ot_saved=>/cadaxo/if_api_objecttype~prepare_import( EXPORTING iv_data = iv_data
                                                                                IMPORTING ev_data = lv_data ).
      WHEN OTHERS.
        RETURN.
    ENDCASE.

    ls_pos-data = lv_data.
    INSERT INTO /cadaxo/sqlcapip VALUES ls_pos.

  ENDMETHOD.


  METHOD check_initial_value.
****************************************************************************************************
* Description             : Check for initial value                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Check if an value is given, else use default value                                               *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    IF iv_value IS NOT INITIAL.
      ev_value      = iv_value.
    ELSE.
      ev_value      = iv_default.
    ENDIF.

  ENDMETHOD.


  METHOD check_own_queue.

    DATA(lv_user) = cl_abap_syst=>get_user_name( ).

    SELECT SINGLE @abap_true
        FROM /cadaxo/sqlcapih
          WHERE receiver_typ = @c_default_receiver_typ
            AND receiver = @lv_user
            AND status = @status-default
          INTO @DATA(lv_true).
    IF sy-subrc = 0.
      rv_unread = abap_true.
    ELSE.
      rv_unread = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD create_description_db.
****************************************************************************************************
* Description             : Create description DB                                                  *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Creates new line in API texttable for an given description                                       *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    DATA ls_text   TYPE /cadaxo/sqlcapit.

    ls_text-id = gv_header_id.
    ls_text-langu = cl_abap_syst=>get_language( ).
    ls_text-description = iv_description.
    INSERT INTO /cadaxo/sqlcapit VALUES ls_text.

  ENDMETHOD.


  METHOD create_header_db.
****************************************************************************************************
* Description             : Create Header line for API                                             *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Creates an new header line on DB                                                                 *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA ls_header TYPE /cadaxo/sqlcapih.

    "Get new API Header ID
    TRY.
        ls_header-id = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_uuid_error.
    ENDTRY.
    set_header_id( EXPORTING iv_id = ls_header-id ).
    "Sender
    check_initial_value(
        EXPORTING
            iv_value = iv_sender
            iv_default = cl_abap_syst=>get_user_name( )
        IMPORTING
            ev_value = ls_header-sender ).
    "Sender Type
    check_initial_value(
        EXPORTING
            iv_value = iv_sender_typ
            iv_default = sender_typ-default
        IMPORTING
            ev_value = ls_header-sender_typ ).
    "Receiver
    check_initial_value(
        EXPORTING
            iv_value = iv_receiver
            iv_default = cl_abap_syst=>get_user_name( )
        IMPORTING
            ev_value = ls_header-receiver ).
    "Receiver Type
    check_initial_value(
        EXPORTING
            iv_value = iv_receiver_typ
            iv_default = c_default_receiver_typ
        IMPORTING
            ev_value = ls_header-receiver_typ ).
    "Created Timestamp
    CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP ls_header-created TIME ZONE 'UTC'.
    "Expiration
    check_initial_value(
        EXPORTING
            iv_value = iv_expiration
            iv_default = c_default_expiration
        IMPORTING
            ev_value = ls_header-expiration ).
    "Initial Status
    ls_header-status        = status-default.

    ls_header-rfcdest = iv_rfcdest. "+cockpit-295

    INSERT INTO /cadaxo/sqlcapih VALUES ls_header.

  ENDMETHOD.


  METHOD create_share_factory.
****************************************************************************************************
* Description             : Create Share Factory                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Creates and returns an instance for new API call                                                 *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 08.10.2018 |Pat                   |Share Result                                 |COCKPIT-401     *
****************************************************************************************************
    ro_instance = NEW #( ).

    ro_instance->create_header_db(
        EXPORTING
            iv_sender = iv_sender
            iv_sender_typ = iv_sender_typ
            iv_receiver = iv_receiver
            iv_receiver_typ = iv_receiver_typ
            iv_expiration = iv_expiration
            iv_rfcdest  = iv_rfcdest "+cockpit-295
    ).

    IF iv_description IS NOT INITIAL.
      ro_instance->create_description_db(
          EXPORTING
              iv_description = iv_description
      ).
    ENDIF.

  ENDMETHOD.


  METHOD delete_header_and_positions.

    DELETE FROM /cadaxo/sqlcapih WHERE id = gv_header_id AND status <> status-block. "#EC CI_IMUD_NESTED
    IF sy-subrc = 0.
      DELETE FROM /cadaxo/sqlcapip WHERE id_hdr = gv_header_id. "#EC CI_NOFIRST "#EC CI_IMUD_NESTED
      DELETE FROM /cadaxo/sqlcapit WHERE id = gv_header_id. "#EC CI_IMUD_NESTED
      CLEAR gv_header_id.
    ENDIF.

  ENDMETHOD.


  METHOD get_item.
****************************************************************************************************
* Description             : Get Item                                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Gets item for an position id                                                                     *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
* 26.01.2018 |Pat                   |select symbols for export                    |COCKPIT-294     *
* 08.10.2019 |Pat                   |export results                              | COCKPIT-401    *
****************************************************************************************************

    CASE iv_pos_line-typ.
      WHEN cs_api_types-sql.
* begin of change COCKPIT-294
*     rt_item = /cadaxo/cl_sqlc_api_ot_sql=>/cadaxo/if_api_objecttype~prepare_export(  ).
        /cadaxo/cl_sqlc_api_ot_sql=>/cadaxo/if_api_objecttype~prepare_export( EXPORTING iv_data = iv_pos_line-data
                                                                              IMPORTING rt_sql  = rt_item ).

      WHEN cs_api_types-symbols.
        /cadaxo/cl_sqlc_api_ot_symbol=>/cadaxo/if_api_objecttype~prepare_export( EXPORTING iv_data = iv_pos_line-data
                                                                                 IMPORTING rt_sql  = rt_item ).

      WHEN cs_api_types-variant.
        /cadaxo/cl_sqlc_api_ot_variant=>/cadaxo/if_api_objecttype~prepare_export( EXPORTING iv_data = iv_pos_line-data
                                                                                  IMPORTING rt_sql  = rt_item ).
* end   of change COCKPIT-294
      WHEN cs_api_types-saved.
        /cadaxo/cl_sqlc_api_ot_saved=>/cadaxo/if_api_objecttype~prepare_export( EXPORTING iv_data = iv_pos_line-data
                                                                                IMPORTING rt_sql  = rt_item ).
    ENDCASE.

  ENDMETHOD.


  METHOD get_items.
****************************************************************************************************
* Description             : Get Items                                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Gets all Items for an Header ID                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 04-03-2018 | Pat                  | set read status separately                  |                *
****************************************************************************************************

    SELECT *
       FROM /cadaxo/sqlcapip
       INTO TABLE rt_items
         WHERE id_hdr = gv_header_id.
    IF sy-subrc = 0.
*      me->set_status( 'R' ). "-cockpit-294
    ENDIF.

  ENDMETHOD.


  METHOD get_own_queue.
****************************************************************************************************
* Description             : Get own queue                                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Gets own queue                                                                                   *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    DATA(lv_user)  = cl_abap_syst=>get_user_name( ).
    DATA(lv_langu) = cl_abap_syst=>get_language( ).

    DATA: lt_ddo7 TYPE STANDARD TABLE OF dd07v WITH DEFAULT KEY.

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname   = '/CADAXO/SQLCAPI_POSITION_TYP'
        text      = abap_true
      TABLES
        dd07v_tab = lt_ddo7
      EXCEPTIONS
        OTHERS    = 1.

    SELECT *
        FROM /cadaxo/sqlcapih
        INTO CORRESPONDING FIELDS OF TABLE rt_queue
          WHERE receiver_typ = c_default_receiver_typ
            AND receiver = lv_user
      ORDER BY created DESCENDING.

    LOOP AT rt_queue ASSIGNING FIELD-SYMBOL(<ls_queue>).

      SELECT SINGLE description
        FROM /cadaxo/sqlcapit
        INTO <ls_queue>-description
          WHERE id    = <ls_queue>-id
            AND langu = lv_langu. "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED
      IF sy-subrc <> 0.
        SELECT SINGLE description
          FROM /cadaxo/sqlcapit
          INTO <ls_queue>-description
            WHERE id    = <ls_queue>-id. "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED
      ENDIF.

      " Convert timestamp
      CONVERT TIME STAMP <ls_queue>-created TIME ZONE 'UTC' INTO DATE <ls_queue>-dat TIME <ls_queue>-tim.

    ENDLOOP.

    LOOP AT rt_queue ASSIGNING <ls_queue>.
*      Logic to populate item type                                                                        "COCKPIT-294
      IF <ls_queue>-position_typ IS INITIAL.                                                              "COCKPIT-294
        DATA(lr_api_position_type) = /cadaxo/cl_sqlc_cockpit_api=>get_share_factory( <ls_queue>-id ).     "COCKPIT-294

        IF lr_api_position_type IS BOUND.                                                                 "COCKPIT-294
          DATA(lt_items) = lr_api_position_type->get_items( <ls_queue>-id ).                              "COCKPIT-294
          LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>).                                             "COCKPIT-294
            IF sy-tabix = 1.                                                                              "COCKPIT-294
              <ls_queue>-position_typ = <ls_item>-typ.                                                    "COCKPIT-294
            ELSEIF sy-tabix > 1.                                                                          "COCKPIT-294
              APPEND <ls_queue> TO rt_queue.                                                              "COCKPIT-294
              <ls_queue>-position_typ = <ls_item>-typ.                                                    "COCKPIT-294
            ENDIF.                                                                                        "COCKPIT-294
          ENDLOOP.                                                                                        "COCKPIT-294
        ENDIF.                                                                                            "COCKPIT-294

      ENDIF.

      IF <ls_queue>-position_typ IS NOT INITIAL.
        TRY.
            <ls_queue>-position_typ_text = lt_ddo7[ valpos = <ls_queue>-position_typ ]-ddtext.
          CATCH cx_sy_itab_line_not_found.
            <ls_queue>-position_typ_text = <ls_queue>-position_typ.
        ENDTRY.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_share_factory.
****************************************************************************************************
* Description             : Create Share Factory                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Creates and returns an instance for new API call                                                 *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    CREATE OBJECT ro_instance.

    ro_instance->set_header_id( EXPORTING iv_id = iv_id ).

  ENDMETHOD.


  METHOD set_header_id.
****************************************************************************************************
* Description             : Set Header ID                                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Sets header ID to instance                                                                       *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    gv_header_id = iv_id.

  ENDMETHOD.


  METHOD set_status.

    UPDATE /cadaxo/sqlcapih SET status = iv_new_status WHERE id = gv_header_id.

  ENDMETHOD.
ENDCLASS.
