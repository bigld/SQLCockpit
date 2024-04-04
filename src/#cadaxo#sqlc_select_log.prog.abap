****************************************************************************************************
* Description             : show the select log                                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 07-04-2018 | Pat                  | cockpit-257                                 |                *
*            |                      | display full select query in pop-up         |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
REPORT /cadaxo/sqlc_select_log.

CLASS lcl_worker DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: ty_sqlclogs    TYPE STANDARD TABLE OF /cadaxo/sqlclog WITH DEFAULT KEY.
    TYPES: ty_sqlclogalvs TYPE STANDARD TABLE OF /cadaxo/sqlclogalv WITH DEFAULT KEY.
    CLASS-METHODS: convert_to_alv IMPORTING i_sqllogs        TYPE ty_sqlclogs
                                  RETURNING VALUE(r_sqlalvs) TYPE ty_sqlclogalvs.
ENDCLASS.

CLASS lcl_worker IMPLEMENTATION.

  METHOD convert_to_alv.
    DATA: xml_string TYPE string.
    DATA: sqllog_xml TYPE /cadaxo/sqlc_sqllog.
    DATA: sqllogalv  TYPE /cadaxo/sqlclogalv.

    LOOP AT i_sqllogs ASSIGNING FIELD-SYMBOL(<sqlclog>).

      TRY.
          cl_abap_gzip=>decompress_text( EXPORTING gzip_in = <sqlclog>-sql_log
                                         IMPORTING text_out = xml_string ).

          CALL TRANSFORMATION id
               SOURCE XML xml_string
               RESULT log = sqllog_xml.

          sqllogalv = VALUE #( uname              = <sqlclog>-uname
                               sql_string         = sqllog_xml-sql_string
                               result_rows        = sqllog_xml-result_rows
                               result_runtime     = sqllog_xml-result_runtime
                               result_status_icon = SWITCH #( sqllog_xml-result_status
                                                              WHEN '00' THEN icon_green_light
                                                              WHEN '01' THEN icon_yellow_light
                                                              WHEN '02' THEN icon_red_light
                                                              ELSE icon_green_light
                                                            )
                             ).
        CATCH cx_parameter_invalid_range
              cx_sy_buffer_overflow
              cx_sy_conversion_codepage
              cx_sy_compression_error.

          sqllogalv = VALUE #( uname              = <sqlclog>-uname
                               result_rows        = 0
                               result_runtime     = 0
                               result_status_icon = icon_red_light
                             ).
          MESSAGE e028(/cadaxo/sqlc_ulog) INTO sqllogalv-sql_string.

      ENDTRY.

      CONVERT TIME STAMP <sqlclog>-timestamp TIME ZONE sy-zonlo
              INTO DATE sqllogalv-execute_date TIME sqllogalv-execute_time.

      APPEND sqllogalv TO r_sqlalvs.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

INCLUDE: icons.

DATA: gs_sqlclog         TYPE /cadaxo/sqlclog,
      gt_sqlclog         TYPE TABLE OF /cadaxo/sqlclog,
      gt_sqlclogalv      TYPE TABLE OF /cadaxo/sqlclogalv,
      ls_sqlclogalv      TYPE /cadaxo/sqlclogalv,
      ls_slis_layout_alv TYPE slis_layout_alv.
DATA: gv_repid LIKE sy-repid. "+cockpit-257
DATA l_xml        TYPE string.
DATA l_sqllog_xml TYPE /cadaxo/sqlc_sqllog.

RANGES: gt_sel_timestamp FOR gs_sqlclog-timestamp.
DATA: rg_sel_timestamps LIKE RANGE OF gs_sqlclog-timestamp.
DATA: rg_sel_timestamp  LIKE LINE OF rg_sel_timestamps.

FIELD-SYMBOLS: <fs_sqlclog> TYPE /cadaxo/sqlclog.

*TODO
DATA lv_string            TYPE string.
DATA lv_dec(11)           TYPE p DECIMALS 7.
*END TODO

* select options
SELECTION-SCREEN BEGIN OF BLOCK sel WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: so_uname FOR  gs_sqlclog-uname DEFAULT sy-uname,
                  so_date  FOR  ls_sqlclogalv-execute_date,
                  so_runt  FOR  ls_sqlclogalv-result_runtime,
                  so_rrows FOR  ls_sqlclogalv-result_rows.
SELECTION-SCREEN END OF BLOCK sel.

START-OF-SELECTION.

  AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
  IF sy-subrc NE 0.
    MESSAGE e036(/cadaxo/sqlc).
  ENDIF.

  CLEAR: gt_sel_timestamp[].

  LOOP AT so_date.
    gt_sel_timestamp = CORRESPONDING #( so_date ).
*TODO
    IF gt_sel_timestamp-option = 'LT'.
      CONCATENATE '19000101' '000000' '.' '0000001' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-low = lv_dec.

      CONCATENATE so_date-low '000000' '.' '0000000' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-high = lv_dec.

    ELSEIF gt_sel_timestamp-option = 'LE'.
      CONCATENATE '19000101' '000000' '.' '0000001' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-low = lv_dec.

      CONCATENATE so_date-low '235959' '.' '9999999' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-high = lv_dec.

    ELSEIF gt_sel_timestamp-option = 'GT'.
      CONCATENATE so_date-low '235959' '.' '9999999' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-low = lv_dec.

      CONCATENATE '29991231' '235959' '.' '9999999' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-high = lv_dec.

    ELSEIF  gt_sel_timestamp-option = 'GE'.
      CONCATENATE so_date-low '000000' '.' '0000000' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-low = lv_dec.

      CONCATENATE '29991231' '235959' '.' '9999999' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-high = lv_dec.

    ELSEIF  gt_sel_timestamp-option = 'NE'.
      CONCATENATE so_date-low '000000' '.' '0000000' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-low = lv_dec.

      CONCATENATE so_date-low '235959' '.' '9999999' INTO lv_string.
      lv_dec = lv_string.
      gt_sel_timestamp-high = lv_dec.

    ELSEIF gt_sel_timestamp-option = 'EQ' OR gt_sel_timestamp-option IS INITIAL.
*END TODO
      CONVERT DATE so_date-low TIME '000000' INTO TIME STAMP gt_sel_timestamp-low TIME ZONE sy-zonlo.

      IF so_date-high CN ' 0'.
        CONVERT DATE so_date-high TIME '235959' INTO TIME STAMP gt_sel_timestamp-high TIME ZONE sy-zonlo.
      ELSE.
        MOVE 'BT' TO gt_sel_timestamp-option.
        CONVERT DATE so_date-low  TIME '235959' INTO TIME STAMP gt_sel_timestamp-high TIME ZONE sy-zonlo.
      ENDIF.

      APPEND gt_sel_timestamp.
    ENDIF.

*rg_sel_timestamp = CORRESPONDING #( so_date ).
*case rg_sel_timestamp-option.
*when 'EQ'.
  ENDLOOP.

* select the data
  IF gt_sel_timestamp-option = 'NE'.
    SELECT * FROM /cadaxo/sqlclog PACKAGE SIZE 1000
       INTO TABLE gt_sqlclog WHERE uname IN so_uname
                               AND timestamp      NOT BETWEEN gt_sel_timestamp-low AND gt_sel_timestamp-high
                               AND result_runtime IN so_runt
                               AND result_rows    IN so_rrows.
      APPEND LINES OF lcl_worker=>convert_to_alv( gt_sqlclog ) TO gt_sqlclogalv.
    ENDSELECT.

  ELSEIF gt_sel_timestamp-option IS INITIAL.
    SELECT * FROM /cadaxo/sqlclog PACKAGE SIZE 1000
       INTO TABLE gt_sqlclog WHERE uname IN so_uname
                               AND result_runtime IN so_runt
                               AND result_rows    IN so_rrows.
      APPEND LINES OF lcl_worker=>convert_to_alv( gt_sqlclog ) TO gt_sqlclogalv.
    ENDSELECT.

  ELSE.
    MOVE 'BT' TO gt_sel_timestamp-option.
    SELECT * FROM /cadaxo/sqlclog PACKAGE SIZE 1000
       INTO TABLE gt_sqlclog WHERE uname IN so_uname
                               AND timestamp      BETWEEN gt_sel_timestamp-low AND gt_sel_timestamp-high
                               AND result_runtime IN so_runt
                               AND result_rows    IN so_rrows.
      APPEND LINES OF lcl_worker=>convert_to_alv( gt_sqlclog ) TO gt_sqlclogalv.
    ENDSELECT.
  ENDIF.



  SORT gt_sqlclogalv BY execute_date DESCENDING execute_time DESCENDING.

  ls_slis_layout_alv-zebra   = abap_true.
  ls_slis_layout_alv-colwidth_optimize = abap_true.

  gv_repid = sy-repid. "+COCKPIT-257

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = gv_repid    "+COCKPIT-257
      i_callback_user_command = 'USER_COMMAND' "+COCKPIT-257
      i_structure_name        = '/CADAXO/SQLCLOGALV'
      is_layout               = ls_slis_layout_alv
    TABLES
      t_outtab                = gt_sqlclogalv
    EXCEPTIONS
      OTHERS                  = 1.

END-OF-SELECTION.
* begin of insert cockpit257
FORM user_command USING command LIKE sy-ucomm
                       selfield TYPE slis_selfield.
  CASE command.
    WHEN '&IC1'.
      TRY.
          DATA(ls_sqlclogalv) = gt_sqlclogalv[ selfield-tabindex ] .
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
      CASE selfield-fieldname.
        WHEN 'SQL_STRING'.
          IF ls_sqlclogalv-sql_string IS NOT INITIAL.
* call FM to display pop.up
            CALL FUNCTION '/CADAXO/SQLC_UT_VALUE_POPUP'
              CHANGING
                cv_value = ls_sqlclogalv-sql_string.
          ENDIF.
      ENDCASE.
  ENDCASE.
ENDFORM.
* end of insert cockpit257
