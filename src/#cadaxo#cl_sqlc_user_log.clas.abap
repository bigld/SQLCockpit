CLASS /cadaxo/cl_sqlc_user_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS con_insert TYPE /cadaxo/sqlc_update_flag VALUE 'I'. "#EC NOTEXT
    CONSTANTS con_update TYPE /cadaxo/sqlc_update_flag VALUE 'U'. "#EC NOTEXT
    CONSTANTS con_delete TYPE /cadaxo/sqlc_update_flag VALUE 'D'. "#EC NOTEXT
    CONSTANTS con_modify TYPE /cadaxo/sqlc_update_flag VALUE 'M'. "#EC NOTEXT
    CONSTANTS con_obj_hl TYPE /cadaxo/sqlc_ulog_object VALUE 'HOMELINK'. "#EC NOTEXT
    CONSTANTS con_obj_key_hl TYPE /cadaxo/sqlc_ulgo_object_key VALUE 'HOME_USE_LINK'. "#EC NOTEXT
    CONSTANTS con_obj_var TYPE /cadaxo/sqlc_ulog_object VALUE 'VARIANT'. "#EC NOTEXT
    CONSTANTS con_obj_jr TYPE /cadaxo/sqlc_ulog_object VALUE 'JOBREORG'. "#EC NOTEXT
    CONSTANTS con_adm_usrspc TYPE /cadaxo/sqlc_ulog_object VALUE 'ADMUSERSPACE'. "#EC NOTEXT

    METHODS add_ulog
      IMPORTING
        !i_log_message TYPE /cadaxo/sqlculog_api
        !i_update_task TYPE /cadaxo/sqlcupdatetask OPTIONAL .
    METHODS constructor .
    METHODS get_ulog_user
      IMPORTING
        !i_uname        TYPE uname
      EXPORTING
        !e_log_messages TYPE /cadaxo/sqlculog_api_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /cadaxo/cl_sqlc_user_log IMPLEMENTATION.


  METHOD add_ulog.
****************************************************************************************************
* Description             :                                                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : xx                       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2014                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 03.09.2014 | Domi Bigl            | unique timestamps                           | #247           *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* xx.xx.2014 |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
    DATA ls_ulog_db   TYPE /cadaxo/sqlculog_db.
    DATA lt_ulog_db   TYPE /cadaxo/sqlculog_db_t.
    DATA l_xml        TYPE string.
    DATA lv_timestamp TYPE timestampl.

    CLEAR ls_ulog_db.

    MOVE: i_log_message-object     TO ls_ulog_db-object,
          i_log_message-object_key TO ls_ulog_db-object_key,
          sy-uname                 TO ls_ulog_db-uname,
          con_insert               TO ls_ulog_db-update_flag.

    GET TIME STAMP FIELD lv_timestamp.                                           "#247
    DO.
      GET TIME STAMP FIELD ls_ulog_db-timestamp.
      IF ls_ulog_db-timestamp <> lv_timestamp.                                   "#247
        EXIT. "DO
      ENDIF.
    ENDDO.

    CALL TRANSFORMATION id
      SOURCE log = i_log_message-logxml
      RESULT XML l_xml .

    cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                                 IMPORTING gzip_out = ls_ulog_db-log_message ).

    APPEND ls_ulog_db TO lt_ulog_db.

    CALL FUNCTION '/CADAXO/SQLCULOG_UPDATE'
      EXPORTING
        i_update_task = i_update_task
        it_log        = lt_ulog_db.

  ENDMETHOD.


  METHOD constructor.
  ENDMETHOD.


  METHOD get_ulog_user.
  ENDMETHOD.
ENDCLASS.
