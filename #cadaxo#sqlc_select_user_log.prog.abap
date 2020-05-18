REPORT  /cadaxo/sqlc_select_user_log.
****************************************************************************************************
* Description             : show the user log                                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*  23.9.14   | Rene Rammer          | Enhancement of Search                       |    CT#249      *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 17.06.2016 | Dieter Schadler      | Bugfix Zeitraumsuche/Selektion neu          | Jira COCKPIT-44*
*            |                      |                                             |                *
****************************************************************************************************
TYPE-POOLS: slis.

INCLUDE: icons.

DATA gs_sqlculog          TYPE /cadaxo/sqlculog.
DATA gt_sqlculog          TYPE TABLE OF /cadaxo/sqlculog.
DATA gt_sqlculogalv       TYPE TABLE OF /cadaxo/sqlculogalv.
DATA gs_slis_layout_alv   TYPE slis_layout_alv.
DATA gv_xml               TYPE string.
DATA gs_log_xml           TYPE /cadaxo/sqlculog_xml.
RANGES: gt_sel_timestamp  FOR gs_sqlculog-timestamp.
DATA gv_time              TYPE sy-uzeit.

SELECTION-SCREEN BEGIN OF BLOCK sel WITH FRAME TITLE text-t01.
SELECT-OPTIONS: so_uname FOR  gs_sqlculog-uname DEFAULT sy-uname,
                so_date  FOR  sy-datum.
SELECTION-SCREEN END OF BLOCK sel.

FIELD-SYMBOLS: <gs_sqlculog> TYPE /cadaxo/sqlculog.
FIELD-SYMBOLS: <gs_sqlculogalv> TYPE /cadaxo/sqlculogalv.

START-OF-SELECTION.

  AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
  IF sy-subrc NE 0.
    MESSAGE e036(/cadaxo/sqlc).
  ENDIF.

  CLEAR: gt_sel_timestamp[].

  LOOP AT so_date.
    MOVE-CORRESPONDING so_date TO gt_sel_timestamp.
    IF so_date-low IS NOT INITIAL.
      gv_time = '000000'.
      CONVERT DATE so_date-low TIME gv_time INTO TIME STAMP gt_sel_timestamp-low TIME ZONE sy-zonlo.
    ENDIF.

    IF so_date-high IS NOT INITIAL.
      gv_time = '235959'.
      CONVERT DATE so_date-high TIME gv_time INTO TIME STAMP gt_sel_timestamp-high TIME ZONE sy-zonlo.
    ENDIF.
    APPEND gt_sel_timestamp.
  ENDLOOP.

  SELECT * FROM /cadaxo/sqlculog PACKAGE SIZE 1000
         INTO TABLE gt_sqlculog  WHERE uname   IN so_uname
                                 AND timestamp IN gt_sel_timestamp.

    LOOP AT gt_sqlculog ASSIGNING <gs_sqlculog>.

      APPEND INITIAL LINE TO gt_sqlculogalv ASSIGNING <gs_sqlculogalv>.
      MOVE-CORRESPONDING <gs_sqlculog> TO <gs_sqlculogalv>.

      "unzip log data
      cl_abap_gzip=>decompress_text( EXPORTING gzip_in  = <gs_sqlculog>-log_message
                                     IMPORTING text_out = gv_xml ).

      "convert log data into xml
      CALL TRANSFORMATION id
         SOURCE XML gv_xml
         RESULT log = gs_log_xml.

      MOVE gs_log_xml TO <gs_sqlculogalv>-logxml.

      "convert the timestamp into date/time
      CONVERT TIME STAMP <gs_sqlculog>-timestamp TIME ZONE sy-zonlo
              INTO DATE <gs_sqlculogalv>-ulog_date TIME <gs_sqlculogalv>-ulog_time.

      "message text
      MESSAGE ID <gs_sqlculogalv>-id
              TYPE <gs_sqlculogalv>-type
              NUMBER <gs_sqlculogalv>-number
              WITH <gs_sqlculogalv>-message_v1
                   <gs_sqlculogalv>-message_v2
                   <gs_sqlculogalv>-message_v3
                   <gs_sqlculogalv>-message_v4
              INTO <gs_sqlculogalv>-message.

      "icon
      CASE <gs_sqlculogalv>-type.
        WHEN 'I' OR 'S'.
          MOVE icon_message_information_small TO <gs_sqlculogalv>-icon.
        WHEN 'W'.
          MOVE icon_message_warning_small     TO <gs_sqlculogalv>-icon.
        WHEN 'E'.
          MOVE icon_message_error_small       TO <gs_sqlculogalv>-icon.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

  ENDSELECT.

* sort the table by date/time descending
  SORT gt_sqlculogalv BY ulog_date DESCENDING ulog_time DESCENDING.

END-OF-SELECTION.

* set layout
  gs_slis_layout_alv-zebra   = 'X'.
  gs_slis_layout_alv-colwidth_optimize = 'X'.

* show the data
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_structure_name = '/CADAXO/SQLCULOGALV'
      is_layout        = gs_slis_layout_alv
    TABLES
      t_outtab         = gt_sqlculogalv
    EXCEPTIONS
      program_error    = 1
      OTHERS           = 2.
