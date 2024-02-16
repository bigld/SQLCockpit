class /CADAXO/CL_SQLC_USER_LOG definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_USER_LOG
*"* do not include other source files here!!!
public section.

  constants CON_INSERT type /CADAXO/SQLC_UPDATE_FLAG value 'I'. "#EC NOTEXT
  constants CON_UPDATE type /CADAXO/SQLC_UPDATE_FLAG value 'U'. "#EC NOTEXT
  constants CON_DELETE type /CADAXO/SQLC_UPDATE_FLAG value 'D'. "#EC NOTEXT
  constants CON_MODIFY type /CADAXO/SQLC_UPDATE_FLAG value 'M'. "#EC NOTEXT
  constants CON_OBJ_HL type /CADAXO/SQLC_ULOG_OBJECT value 'HOMELINK'. "#EC NOTEXT
  constants CON_OBJ_KEY_HL type /CADAXO/SQLC_ULGO_OBJECT_KEY value 'HOME_USE_LINK'. "#EC NOTEXT
  constants CON_OBJ_VAR type /CADAXO/SQLC_ULOG_OBJECT value 'VARIANT'. "#EC NOTEXT
  constants CON_OBJ_JR type /CADAXO/SQLC_ULOG_OBJECT value 'JOBREORG'. "#EC NOTEXT
  constants CON_ADM_USRSPC type /CADAXO/SQLC_ULOG_OBJECT value 'ADMUSERSPACE'. "#EC NOTEXT

  methods ADD_ULOG
    importing
      !I_LOG_MESSAGE type /CADAXO/SQLCULOG_API
      !I_UPDATE_TASK type /CADAXO/SQLCUPDATETASK optional .
  methods CONSTRUCTOR .
  methods GET_ULOG_USER
    importing
      !I_UNAME type UNAME
    exporting
      !E_LOG_MESSAGES type /CADAXO/SQLCULOG_API_T .
protected section.
*"* protected components of class /CADAXO/CL_SQLC_USER_LOG
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CL_SQLC_USER_LOG
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CL_SQLC_USER_LOG IMPLEMENTATION.


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

* get new timestamp
  GET TIME STAMP FIELD lv_timestamp.                                           "#247
  DO.
    GET TIME STAMP FIELD ls_ulog_db-timestamp.
**    SELECT SINGLE timestamp                                                  "#247
**      FROM /cadaxo/sqlculog                                                  "#247
**      INTO lv_timestamp                                                      "#247
**        WHERE timestamp = ls_ulog_db-timestamp.                              "#247
**    IF sy-subrc <> 0.                                                        "#247
    IF ls_ulog_db-timestamp <> lv_timestamp.                                   "#247
      EXIT. "DO
    ENDIF.
  ENDDO.

* convert log data into xml
  CALL TRANSFORMATION id
     SOURCE log = i_log_message-logxml
     RESULT XML l_xml .

* zip data
  CALL METHOD cl_abap_gzip=>compress_text
    EXPORTING
      text_in  = l_xml
    IMPORTING
      gzip_out = ls_ulog_db-log_message.

  APPEND ls_ulog_db TO lt_ulog_db.

* insert log to database
  CALL FUNCTION '/CADAXO/SQLCULOG_UPDATE'
    EXPORTING
      i_update_task = i_update_task
      it_log        = lt_ulog_db.

ENDMETHOD.


method CONSTRUCTOR.
endmethod.


method GET_ULOG_USER.
endmethod.
ENDCLASS.
