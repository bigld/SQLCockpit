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
      APPEND LINES OF /cadaxo/cl_sqlc_user_hist_log=>convert_to_alv( gt_sqlclog ) TO gt_sqlclogalv.
    ENDSELECT.

  ELSEIF gt_sel_timestamp-option IS INITIAL.
    SELECT * FROM /cadaxo/sqlclog PACKAGE SIZE 1000
       INTO TABLE gt_sqlclog WHERE uname IN so_uname
                               AND result_runtime IN so_runt
                               AND result_rows    IN so_rrows.
      APPEND LINES OF /cadaxo/cl_sqlc_user_hist_log=>convert_to_alv( gt_sqlclog ) TO gt_sqlclogalv.
    ENDSELECT.

  ELSE.
    MOVE 'BT' TO gt_sel_timestamp-option.
    SELECT * FROM /cadaxo/sqlclog PACKAGE SIZE 1000
       INTO TABLE gt_sqlclog WHERE uname IN so_uname
                               AND timestamp      BETWEEN gt_sel_timestamp-low AND gt_sel_timestamp-high
                               AND result_runtime IN so_runt
                               AND result_rows    IN so_rrows.
      APPEND LINES OF /cadaxo/cl_sqlc_user_hist_log=>convert_to_alv( gt_sqlclog ) TO gt_sqlclogalv.
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
