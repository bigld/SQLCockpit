****************************************************************************************************
* Description             : Reorg JobLog/JobList                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Ana Lekic                Company    : CADAXO GesmbH                    *
* Date                    : 29.05.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 17.03.2017 | Domi Bigl            | CC-Cleanup                                  |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

REPORT  /cadaxo/sqlc_reorg_jobs.

TYPE-POOLS: slis.

INCLUDE: icons.

DATA gs_slis_layout_alv TYPE slis_layout_alv.
DATA gt_sqlcjobsalv     TYPE TABLE OF /cadaxo/sqlcjobsreorgalv.
DATA gs_sqlcjobsalv     TYPE /cadaxo/sqlcjobsreorgalv.
DATA gt_fieldcat        TYPE slis_t_fieldcat_alv.
DATA gs_fieldcat        TYPE slis_fieldcat_alv.
DATA gt_listheader      TYPE slis_t_listheader.
DATA gs_listheader      TYPE slis_listheader.

DATA ls_log          TYPE /cadaxo/sqlculog_api.
DATA lr_user_log     TYPE REF TO /cadaxo/cl_sqlc_user_log.
DATA ls_objkey       TYPE string.
DATA gs_tbtco        TYPE tbtco.
DATA gt_jobs         TYPE TABLE OF /cadaxo/sqlcjobs.
DATA gs_jobs         TYPE /cadaxo/sqlcjobs.
DATA gt_ress         TYPE TABLE OF /cadaxo/sqlcress.

RANGES: gt_sel_timestamp FOR gs_jobs-create_timestamp.

FIELD-SYMBOLS: <gs_ress> TYPE /cadaxo/sqlcress.
FIELD-SYMBOLS: <gs_job>  TYPE /cadaxo/sqlcjobs.



SELECTION-SCREEN BEGIN OF BLOCK sel WITH FRAME TITLE text-t01.
SELECT-OPTIONS: so_date   FOR  gs_sqlcjobsalv-create_date OBLIGATORY.
SELECTION-SCREEN SKIP.
PARAMETERS p_job          AS CHECKBOX DEFAULT 'X'.
PARAMETERS p_list         AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN SKIP.
PARAMETERS p_test         AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK sel.


START-OF-SELECTION.

  AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
  IF sy-subrc NE 0.
    MESSAGE e036(/cadaxo/sqlc).
  ENDIF.

  PERFORM get_timestamp.

  PERFORM select_data.

* job/jobinfo
  LOOP AT gt_jobs ASSIGNING <gs_job>.

    MOVE-CORRESPONDING <gs_job> TO gs_sqlcjobsalv.

    CONVERT TIME STAMP <gs_job>-create_timestamp TIME ZONE sy-zonlo
       INTO DATE gs_sqlcjobsalv-create_date
            TIME gs_sqlcjobsalv-create_time.

    READ TABLE gt_ress ASSIGNING <gs_ress> WITH KEY ress_guid = <gs_job>-ress_guid.
    IF sy-subrc = 0.
      gs_sqlcjobsalv-space_consuming = <gs_ress>-space_cons_zip.
    ELSE.
      SELECT SINGLE space_cons_zip INTO gs_sqlcjobsalv-space_consuming
             FROM /cadaxo/sqlcress WHERE ress_guid = <gs_job>-ress_guid.
    ENDIF.

    IF p_test IS INITIAL.
      PERFORM delete_jobinfo USING <gs_job>-jobguid CHANGING gs_sqlcjobsalv-result_status_icon.
    ENDIF.

    SELECT SINGLE enddate, endtime, status FROM tbtco INTO CORRESPONDING FIELDS OF @gs_tbtco
                                           WHERE jobname  = @<gs_job>-jobname
                                             AND jobcount = @<gs_job>-jobcount.

    IF sy-subrc EQ 0 AND p_test IS INITIAL.
      PERFORM delete_job USING <gs_job>-jobcount <gs_job>-jobname
                         CHANGING gs_sqlcjobsalv.
    ENDIF.

    gs_sqlcjobsalv-end_date = gs_tbtco-enddate.
    gs_sqlcjobsalv-end_time = gs_tbtco-endtime.

    CASE gs_tbtco-status.
      WHEN 'F'. "Finished
        MOVE text-stf TO gs_sqlcjobsalv-jobstatus.
      WHEN 'P'. "Scheduled
        MOVE text-stp TO gs_sqlcjobsalv-jobstatus.
      WHEN 'S'. "Released
        MOVE text-sts TO gs_sqlcjobsalv-jobstatus.
      WHEN 'R'. "Running
        MOVE text-str TO gs_sqlcjobsalv-jobstatus.
      WHEN 'A'. "Canceled
        MOVE text-stc TO gs_sqlcjobsalv-jobstatus.
      WHEN OTHERS.
        MOVE text-stu TO gs_sqlcjobsalv-jobstatus.
    ENDCASE.

    IF gs_sqlcjobsalv-result_status_icon IS INITIAL.
      gs_sqlcjobsalv-result_status_icon = icon_yellow_light. "test run
    ENDIF.

    APPEND gs_sqlcjobsalv TO gt_sqlcjobsalv.
  ENDLOOP.

* joblist
  LOOP AT gt_ress ASSIGNING <gs_ress>.
    READ TABLE gt_sqlcjobsalv INTO gs_sqlcjobsalv WITH KEY ress_guid = <gs_ress>-ress_guid. "if both checked
    IF sy-subrc = 0.
      CHECK gs_sqlcjobsalv-result_status_icon NE icon_red_light. "only if job deleted ok

      IF p_test IS INITIAL.
        PERFORM delete_ress USING <gs_ress>-ress_guid CHANGING gs_sqlcjobsalv-result_status_icon.
      ENDIF.
      MODIFY gt_sqlcjobsalv FROM gs_sqlcjobsalv INDEX sy-tabix TRANSPORTING result_status_icon.
    ELSE. "only delete list not job
      IF p_test IS INITIAL.
        PERFORM delete_ress USING <gs_ress>-ress_guid CHANGING gs_sqlcjobsalv-result_status_icon.
      ELSE.
        gs_sqlcjobsalv-result_status_icon = icon_yellow_light. "test run
      ENDIF.
      gs_sqlcjobsalv-ress_guid = <gs_ress>-ress_guid.
      gs_sqlcjobsalv-space_consuming = <gs_ress>-space_cons_zip.
      APPEND gs_sqlcjobsalv TO gt_sqlcjobsalv.
    ENDIF.
  ENDLOOP.

  IF p_test IS INITIAL.
    PERFORM add_userlog. "entry in userlog
  ENDIF.

  PERFORM alv_result. " display result

*&---------------------------------------------------------------------*
*&      Form  alv_top_of_page
*&---------------------------------------------------------------------*
*       Listüberschrift
*----------------------------------------------------------------------*
FORM alv_top_of_page.

  gs_listheader-typ = 'H'.
  IF p_test IS INITIAL.
    gs_listheader-info = text-h01.
  ELSE.
    gs_listheader-info = text-h02.
  ENDIF.
  APPEND gs_listheader TO gt_listheader.

  IF NOT p_job IS INITIAL.
    CLEAR gs_listheader.
    gs_listheader-typ = 'S'.
    gs_listheader-info = text-h03.
    APPEND gs_listheader TO gt_listheader.
  ENDIF.

  IF NOT p_list IS INITIAL.
    CLEAR gs_listheader.
    gs_listheader-typ = 'S'.
    gs_listheader-info = text-h04.
    APPEND gs_listheader TO gt_listheader.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = gt_listheader.

ENDFORM.                    "ALV_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  GET_TIMESTAMP
*&---------------------------------------------------------------------*
FORM get_timestamp .

  CLEAR: gt_sel_timestamp[].

  LOOP AT so_date.
    MOVE-CORRESPONDING so_date TO gt_sel_timestamp.

    CONVERT DATE so_date-low TIME '000000' INTO TIME STAMP gt_sel_timestamp-low TIME ZONE sy-zonlo.

    IF so_date-high CN ' 0'.
      CONVERT DATE so_date-high TIME '235959' INTO TIME STAMP gt_sel_timestamp-high TIME ZONE sy-zonlo.
    ELSE.
      MOVE 'BT' TO gt_sel_timestamp-option.
      CONVERT DATE so_date-low  TIME '235959' INTO TIME STAMP gt_sel_timestamp-high TIME ZONE sy-zonlo.
    ENDIF.

    APPEND gt_sel_timestamp.
  ENDLOOP.

ENDFORM.                    " GET_TIMESTAMP
*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .

* jobinfo
  IF p_job IS NOT INITIAL.
    SELECT * FROM /cadaxo/sqlcjobs
           INTO TABLE gt_jobs
           WHERE create_timestamp IN gt_sel_timestamp.
  ENDIF.

* joblist
  IF p_list IS NOT INITIAL.
    SELECT b~ress_guid b~space_cons_zip
            FROM /cadaxo/sqlcjobs AS a
            JOIN /cadaxo/sqlcress AS b
              ON a~ress_guid = b~ress_guid
            INTO CORRESPONDING FIELDS OF TABLE gt_ress
            WHERE a~create_timestamp IN gt_sel_timestamp.
  ENDIF.

ENDFORM.                    " SELECT_DATA
*&---------------------------------------------------------------------*
*&      Form  DELETE_JOBINFO
*&---------------------------------------------------------------------*
FORM delete_jobinfo  USING    p_jobguid TYPE /cadaxo/sqlc_jobguid
                     CHANGING p_result_status_icon TYPE /cadaxo/sqlcresult_status_icon.

  DELETE FROM /cadaxo/sqlcjobs WHERE jobguid = p_jobguid.
  IF sy-subrc <> 0.
    p_result_status_icon = icon_red_light.
  ENDIF.

ENDFORM.                    " DELETE_JOBINFO
*&---------------------------------------------------------------------*
*&      Form  DELETE_JOB
*&---------------------------------------------------------------------*
FORM delete_job  USING    p_jobcount TYPE btcjobcnt
                          p_jobname TYPE btcjob
                 CHANGING p_sqlcjobsalv TYPE /cadaxo/sqlcjobsreorgalv.


  CALL FUNCTION 'BP_JOB_DELETE'
    EXPORTING
      jobcount                 = p_jobcount
      jobname                  = p_jobname
      forcedmode               = 'X'
      commitmode               = ' '
    EXCEPTIONS
      cant_delete_event_entry  = 1
      cant_delete_job          = 2
      cant_delete_joblog       = 3
      cant_delete_steps        = 4
      cant_delete_time_entry   = 5
      cant_derelease_successor = 6
      cant_enq_predecessor     = 7
      cant_enq_successor       = 8
      cant_enq_tbtco_entry     = 9
      cant_update_predecessor  = 10
      cant_update_successor    = 11
      commit_failed            = 12
      jobcount_missing         = 13
      jobname_missing          = 14
      job_does_not_exist       = 15
      job_is_already_running   = 16
      no_delete_authority      = 17
      OTHERS                   = 18.

  IF sy-subrc NE 0.
    p_sqlcjobsalv-type       = sy-msgty.
    p_sqlcjobsalv-id         = sy-msgid.
    p_sqlcjobsalv-number     = sy-msgno.
    p_sqlcjobsalv-message_v1 = sy-msgv1.
    p_sqlcjobsalv-message_v2 = sy-msgv2.
    p_sqlcjobsalv-message_v3 = sy-msgv3.
    p_sqlcjobsalv-message_v4 = sy-msgv4.
    p_sqlcjobsalv-result_status_icon = icon_red_light.
  ELSE.
    p_sqlcjobsalv-result_status_icon = icon_green_light.
  ENDIF.

ENDFORM.                    " DELETE_JOB
*&---------------------------------------------------------------------*
*&      Form  DELETE_RESS
*&---------------------------------------------------------------------*
FORM delete_ress  USING    p_ress_guid TYPE guid_16
                  CHANGING p_result_status_icon TYPE /cadaxo/sqlcresult_status_icon.

  DELETE FROM /cadaxo/sqlcress WHERE ress_guid = p_ress_guid.
  IF sy-subrc = 0.
    p_result_status_icon = icon_green_light.
  ELSE.
    p_result_status_icon = icon_red_light.
  ENDIF.
ENDFORM.                    " DELETE_RESS
*&---------------------------------------------------------------------*
*&      Form  ADD_USERLOG
*&---------------------------------------------------------------------*
FORM add_userlog .

  CREATE OBJECT lr_user_log.
  CLEAR ls_log.
  CONCATENATE so_date p_job p_list INTO ls_objkey SEPARATED BY ','.

  ls_log-object     =  lr_user_log->con_obj_jr. "'JOBREORG'.
  ls_log-object_key = ls_objkey.
  ls_log-type       = 'S'.
  ls_log-id         = '/CADAXO/SQLC'.
  ls_log-number     = '076'.
  ls_log-message_v1 = sy-uname.
  ls_log-message_v2 = ls_objkey.

  lr_user_log->add_ulog(
      i_log_message = ls_log ).
ENDFORM.                    " ADD_USERLOG
*&---------------------------------------------------------------------*
*&      Form  ALV_RESULT
*&---------------------------------------------------------------------*
FORM alv_result .

  SORT gt_sqlcjobsalv BY create_date DESCENDING create_time DESCENDING.

  CLEAR: gt_fieldcat[].
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = '/CADAXO/SQLCJOBSREORGALV'
      i_bypassing_buffer     = abap_true
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT gt_fieldcat INTO gs_fieldcat.
    CASE gs_fieldcat-fieldname.
      WHEN 'SPACE_CONSUMING'.
        gs_fieldcat-do_sum = abap_true.
      WHEN 'RESULT_STATUS_ICON'.
        gs_fieldcat-icon = abap_true.
        gs_fieldcat-col_pos = 1.
      WHEN 'JOBGUID'.
        gs_fieldcat-col_pos = 2.
    ENDCASE.
    MODIFY gt_fieldcat FROM gs_fieldcat.
  ENDLOOP.

* set layout
  gs_slis_layout_alv-zebra             = abap_true.
  gs_slis_layout_alv-colwidth_optimize = abap_true.

* show the data
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'ALV_TOP_OF_PAGE'
      i_structure_name       = '/CADAXO/SQLCJOBSREORGALV'
      is_layout              = gs_slis_layout_alv
      it_fieldcat            = gt_fieldcat
    TABLES
      t_outtab               = gt_sqlcjobsalv
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.

ENDFORM.                    " ALV_RESULT
