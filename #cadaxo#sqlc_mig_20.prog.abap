****************************************************************************************************
* Description             : Migration of data from 1.2.x to 2.0.0 ff                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 05.01.2013               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 23.01.2013                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
REPORT /cadaxo/sqlc_mig_20.

DATA: gt_prot TYPE TABLE OF sprot_u.

**********************************************************************
* SELECTION-SCREEN                                                   *
**********************************************************************
SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE text-bl1.
PARAMETERS: p_admi TYPE c AS CHECKBOX DEFAULT 'X'.
PARAMETERS: p_vari TYPE c AS CHECKBOX DEFAULT 'X'.
PARAMETERS: p_jobs TYPE c AS CHECKBOX DEFAULT 'X'.
PARAMETERS: p_logs TYPE c AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: ULINE.
PARAMETERS: p_prod TYPE c AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN: END OF BLOCK bl1.

**********************************************************************
* START-OF-SELECTION                                                 *
**********************************************************************
START-OF-SELECTION.

  PERFORM tr_prot_add
              USING
                 1
                 '/CADAXO/SQLC_ULOG'
                 '010'
                 'Report /CADAXO/SQLC_MIG_20'
                 ''
                 'to'(001)
                 '3.4.0'.

  PERFORM convert_user_sql_log.
  PERFORM convert_variants.
  PERFORM convert_admin_settings.
  PERFORM convert_jobs.
  PERFORM set_rev_version.

  PERFORM tr_prot_save.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  convert_job_resultlists
*&---------------------------------------------------------------------*
FORM convert_jobs.

  DATA lt_sqlcjobs TYPE TABLE OF /cadaxo/sqlcjobs.
  DATA ls_sqlcsres TYPE /cadaxo/sqlcsres.
  DATA lt_sqlcsres TYPE TABLE OF /cadaxo/sqlcsres.
  DATA l_client    TYPE mandt.
  DATA l_rawresult TYPE /cadaxo/sqlc_result_raw.

  FIELD-SYMBOLS: <ls_sqlcjobs> TYPE /cadaxo/sqlcjobs.

  CHECK p_jobs IS NOT INITIAL.

  PERFORM tr_prot_add USING
                 2
                '/CADAXO/SQLC_ULOG'
                 '010'
                 'Job Results'
                 '(1.2.x'
                 'to'(001)
                 '2.1.0)'.

  SELECT * FROM /cadaxo/sqlcjobs CLIENT SPECIFIED INTO TABLE lt_sqlcjobs
           WHERE jobname NE space AND jobcount NE space
           ORDER BY client ASCENDING.

  CLEAR lt_sqlcsres.

  LOOP AT lt_sqlcjobs ASSIGNING <ls_sqlcjobs>.
    SELECT SINGLE COUNT( * ) FROM /cadaxo/sqlcsres CLIENT SPECIFIED
           WHERE client = <ls_sqlcjobs>-client AND list_guid = <ls_sqlcjobs>-jobguid.
    IF sy-subrc NE 0.

      CLEAR ls_sqlcsres.

      ls_sqlcsres-client            = <ls_sqlcjobs>-client.
      ls_sqlcsres-list_guid         = <ls_sqlcjobs>-jobguid.
      ls_sqlcsres-type              = 'JOB'.
      CONCATENATE 'Jobname:' <ls_sqlcjobs>-jobname INTO ls_sqlcsres-description SEPARATED BY space.
      ls_sqlcsres-jobname           = <ls_sqlcjobs>-jobname.
      ls_sqlcsres-jobcount          = <ls_sqlcjobs>-jobcount.
      ls_sqlcsres-jobstartcond      = <ls_sqlcjobs>-start_conditions.
      ls_sqlcsres-sql_string        = <ls_sqlcjobs>-sql_string.
      ls_sqlcsres-nr_of_selects     = <ls_sqlcjobs>-nr_of_selects.
      ls_sqlcsres-uname             = <ls_sqlcjobs>-uname.
      ls_sqlcsres-create_timestamp  = <ls_sqlcjobs>-create_timestamp.
      ls_sqlcsres-ress_guid         = <ls_sqlcjobs>-ress_guid.
      ls_sqlcsres-editor_sqlstring  = <ls_sqlcjobs>-editor_sqlstring.

      SELECT SINGLE rawresult FROM /cadaxo/sqlcress CLIENT SPECIFIED INTO l_rawresult
                              WHERE mandt = ls_sqlcsres-client AND ress_guid = ls_sqlcsres-ress_guid.
      IF sy-subrc EQ 0.
        ls_sqlcsres-space_cons_zip = xstrlen( l_rawresult ) / 1024.
      ENDIF.

      PERFORM tr_prot_add USING
                     3
                    '/CADAXO/SQLC_ULOG'
                     '005'
                     ls_sqlcsres-list_guid
                     ls_sqlcsres-jobname
                     ls_sqlcsres-jobcount
                     ls_sqlcsres-ress_guid.

      APPEND ls_sqlcsres TO lt_sqlcsres.
    ENDIF.
  ENDLOOP.

  IF NOT lt_sqlcsres[] IS INITIAL.
    IF p_prod IS NOT INITIAL.
      INSERT /cadaxo/sqlcsres CLIENT SPECIFIED FROM TABLE lt_sqlcsres.
      COMMIT WORK.
    ENDIF.
  ENDIF.

ENDFORM.                    "convert_job_resultlists

*&---------------------------------------------------------------------*
*&      Form  convert_admin_settings
*&---------------------------------------------------------------------*
FORM convert_admin_settings.

  TYPES: BEGIN OF ltyp_old_settings,
           client TYPE mandt,
           value  TYPE string,
         END OF ltyp_old_settings.

  TYPES: BEGIN OF ltyp_admin_cust,
           client TYPE mandt.
          INCLUDE STRUCTURE /cadaxo/sqlc_admin_cust.
  TYPES: END OF ltyp_admin_cust.

  DATA ls_adm_cust     TYPE ltyp_admin_cust.
  DATA ls_adm_cust_upd TYPE ltyp_admin_cust.
  DATA lt_adm_cust_upd TYPE TABLE OF ltyp_admin_cust.
  DATA l_home_use_link TYPE string.
  DATA lt_old_settings TYPE TABLE OF ltyp_old_settings.
  DATA l_date          TYPE d.
  DATA l_date_string   TYPE string.
  DATA l_xml           TYPE string.
  DATA ls_admc         TYPE /cadaxo/sqlcadmc.
  DATA ls_adm_cust_tmp TYPE /cadaxo/sqlc_admin_cust.

  FIELD-SYMBOLS: <ls_old_settings> TYPE ltyp_old_settings,
                 <ls_adm_cust_upd> TYPE ltyp_admin_cust.


  CHECK p_admi IS NOT INITIAL.

  PERFORM tr_prot_add USING
                 2
                '/CADAXO/SQLC_ULOG'
                 '010'
                 'Admin Settings'
                 '(1.2.x'
                 'to'(001)
                 '2.1.0)'.

  CLEAR lt_old_settings[].
  SELECT client parameter_value FROM /cadaxo/sqlcparv CLIENT SPECIFIED
                         INTO TABLE lt_old_settings
                         WHERE parameter_id    = 'HOME_USE_LINK'.
  LOOP AT lt_old_settings ASSIGNING <ls_old_settings>.

    CLEAR ls_adm_cust_upd.
    ls_adm_cust_upd-client        = <ls_old_settings>-client.
    IF <ls_old_settings>-value = 'TRUE'.
      ls_adm_cust_upd-home_use_link = 'X'.
    ENDIF.

    SELECT SINGLE parameter_value FROM /cadaxo/sqlcparv CLIENT SPECIFIED
                         INTO l_date_string
                         WHERE client = ls_adm_cust_upd-client
                         AND parameter_id = 'HOME_USE_LINK_DATE'.

    ls_adm_cust_upd-home_use_link_date = l_date = l_date_string.

    ls_adm_cust_upd-home_use_link_date = ls_adm_cust_upd-home_use_link_date + 1.
    ls_adm_cust_upd-home_use_link_date = ls_adm_cust_upd-home_use_link_date - 1.

    IF ls_adm_cust_upd-home_use_link_date NE l_date.
      CLEAR ls_adm_cust_upd-home_use_link.
    ENDIF.

    APPEND ls_adm_cust_upd TO lt_adm_cust_upd.

  ENDLOOP.

  LOOP AT lt_adm_cust_upd ASSIGNING <ls_adm_cust_upd>.

    CLEAR: ls_admc,
           ls_adm_cust_tmp.

    SELECT SINGLE * FROM /cadaxo/sqlcadmc CLIENT SPECIFIED
           INTO ls_admc
           WHERE mandt = <ls_adm_cust_upd>-client
             AND adm_key = 'COCKPIT'.

    IF sy-subrc EQ 0.

      cl_abap_gzip=>decompress_text(
        EXPORTING
          gzip_in  = ls_admc-settings
        IMPORTING
          text_out = l_xml ).

      CALL TRANSFORMATION id
        SOURCE XML l_xml
        RESULT result_save = ls_adm_cust_tmp.

    ELSE.
      ls_admc-mandt   = <ls_adm_cust_upd>-client.
      ls_admc-adm_key = 'COCKPIT'.
    ENDIF.

    IF ls_adm_cust_tmp-home_use_link IS INITIAL.
      ls_adm_cust_tmp-home_use_link      = <ls_adm_cust_upd>-home_use_link.
      ls_adm_cust_tmp-home_use_link_date = <ls_adm_cust_upd>-home_use_link_date.

      PERFORM tr_prot_add USING
                     3
                    '/CADAXO/SQLC_ULOG'
                     '004'
                     <ls_adm_cust_upd>-client
                     <ls_adm_cust_upd>-home_use_link
                     <ls_adm_cust_upd>-home_use_link_date
                     ''.

* transform the data into xml
      CALL TRANSFORMATION id
        SOURCE result_save = ls_adm_cust_tmp
        RESULT XML l_xml.

      CALL METHOD cl_abap_gzip=>compress_text
        EXPORTING
          text_in  = l_xml
        IMPORTING
          gzip_out = ls_admc-settings.
      IF p_prod IS NOT INITIAL.
        MODIFY /cadaxo/sqlcadmc CLIENT SPECIFIED FROM ls_admc.
        COMMIT WORK.
      ENDIF.

    ENDIF.
  ENDLOOP.

**********************************************************************
  PERFORM tr_prot_add USING
                   2
                  '/CADAXO/SQLC_ULOG'
                   '010'
                   'Admin Settings'
                   '(3.0.x'
                   'to'(001)
                   '3.1.0)'.

  CLEAR lt_old_settings[].
  SELECT client parameter_value FROM /cadaxo/sqlcparv CLIENT SPECIFIED
                         INTO TABLE lt_old_settings
                         WHERE parameter_id    = 'CADAXO_REV_VERSION'.

  LOOP AT lt_old_settings ASSIGNING <ls_old_settings> WHERE value = '3.1.0'.
    SELECT SINGLE * FROM /cadaxo/sqlcadmc CLIENT SPECIFIED
           INTO ls_admc
           WHERE mandt   = <ls_old_settings>-client
             AND adm_key = 'COCKPIT'.

    IF sy-subrc EQ 0.

      cl_abap_gzip=>decompress_text(
        EXPORTING
          gzip_in  = ls_admc-settings
        IMPORTING
          text_out = l_xml ).

      CALL TRANSFORMATION id
        SOURCE XML l_xml
        RESULT result_save = ls_adm_cust_tmp.

    ELSE.
      ls_admc-mandt   = <ls_old_settings>-client.
      ls_admc-adm_key = 'COCKPIT'.
    ENDIF.

    ls_adm_cust_tmp-show_element_info = abap_true.
    PERFORM tr_prot_add USING
                   3
                  '/CADAXO/SQLC_ULOG'
                   '004'
                   <ls_old_settings>-client
                   'SHOW_ELEMENT_INFO'
                   abap_true
                   ''.

* transform the data into xml
    CALL TRANSFORMATION id
      SOURCE result_save = ls_adm_cust_tmp
      RESULT XML l_xml.

    CALL METHOD cl_abap_gzip=>compress_text
      EXPORTING
        text_in  = l_xml
      IMPORTING
        gzip_out = ls_admc-settings.
    IF p_prod IS NOT INITIAL.
      MODIFY /cadaxo/sqlcadmc CLIENT SPECIFIED FROM ls_admc.
      COMMIT WORK.
    ENDIF.
  ENDLOOP.
ENDFORM.                    "convert_admin_settings

*&---------------------------------------------------------------------*
*&      Form  convert_variants
*&---------------------------------------------------------------------*
*       Migrate variants from old tables to new one
*----------------------------------------------------------------------*
FORM convert_variants.

  DATA: lt_var_old    TYPE TABLE OF /cadaxo/sqlcvari.
  DATA: lt_varsym_old TYPE TABLE OF /cadaxo/sqlcvasy.
  DATA: lt_varsym_new TYPE TABLE OF /cadaxo/sqlcvnsy.
  DATA: lt_text_new   TYPE TABLE OF /cadaxo/sqlcvntx.

  DATA: ls_var_new   TYPE /cadaxo/sqlcvnhd.
  DATA: ls_text_new  TYPE /cadaxo/sqlcvntx.

  FIELD-SYMBOLS: <lwa_var_old>    TYPE /cadaxo/sqlcvari.
  FIELD-SYMBOLS: <lwa_varsym_old> TYPE /cadaxo/sqlcvasy.
  FIELD-SYMBOLS: <lwa_varsym_new> TYPE /cadaxo/sqlcvnsy.


  CHECK p_vari = abap_true.

  PERFORM tr_prot_add USING
                 2
                '/CADAXO/SQLC_ULOG'
                 '010'
                 'Variants'
                 '(1.2.x'
                 'to'(001)
                 '2.1.0)'.

*get all variants from old table
  SELECT * FROM /cadaxo/sqlcvari CLIENT SPECIFIED
           INTO TABLE lt_var_old
           WHERE varname NOT LIKE '/CADAXO/DEMO%'
           ORDER BY mandt.

  LOOP AT lt_var_old ASSIGNING <lwa_var_old>.
    SELECT SINGLE @abap_true FROM /cadaxo/sqlcvnhd CLIENT SPECIFIED
                             INTO @DATA(lv_exists) WHERE mandt       = @<lwa_var_old>-mandt
                                                     AND varname     = @<lwa_var_old>-varname
                                                     AND flag_public = @<lwa_var_old>-flag_global
                                                     AND cruser      = @<lwa_var_old>-username.

    IF sy-subrc = 0.
* Variant allready exits
      PERFORM tr_prot_add USING
                     3
                    '/CADAXO/SQLC_ULOG'
                     '011'
                     <lwa_var_old>-varname
                     <lwa_var_old>-mandt
                     <lwa_var_old>-username
                     <lwa_var_old>-flag_global.
      CONTINUE.
    ENDIF.

    PERFORM tr_prot_add USING
                   3
                  '/CADAXO/SQLC_ULOG'
                   '010'
                   <lwa_var_old>-mandt
                   <lwa_var_old>-varname
                   <lwa_var_old>-username
                   <lwa_var_old>-flag_global.

* get variant symbols
    CLEAR lt_varsym_old.
    SELECT * FROM /cadaxo/sqlcvasy CLIENT SPECIFIED
             INTO TABLE lt_varsym_old WHERE mandt       = <lwa_var_old>-mandt
                                        AND varname     = <lwa_var_old>-varname
                                        AND flag_global = <lwa_var_old>-flag_global
                                        AND username    = <lwa_var_old>-username.

* migrate header
    CLEAR ls_var_new.
    ls_var_new-mandt       = <lwa_var_old>-mandt.
    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        ev_guid_32 = ls_var_new-varguid.
    ls_var_new-varname     = <lwa_var_old>-varname.
    ls_var_new-flag_public = <lwa_var_old>-flag_global.
    ls_var_new-vargroup    = <lwa_var_old>-vargroup.
    ls_var_new-varsql      = <lwa_var_old>-varsql.
    ls_var_new-cruser      = <lwa_var_old>-cruser.
    CONVERT DATE <lwa_var_old>-crdate INTO TIME STAMP ls_var_new-crtimestamp TIME ZONE sy-zonlo.
    GET TIME STAMP FIELD  ls_var_new-chtimestamp.
    ls_var_new-chuser      = 'XPRAMIG'.

* migrate description
    CLEAR lt_text_new.
    IF <lwa_var_old>-vardescription IS NOT INITIAL.
      CLEAR ls_text_new.
      ls_text_new-mandt          = <lwa_var_old>-mandt.
      ls_text_new-varguid        = ls_var_new-varguid.
      ls_text_new-langu          = 'DE'.
      ls_text_new-vardescription = <lwa_var_old>-vardescription.
      APPEND ls_text_new TO lt_text_new.
      ls_text_new-langu          = 'EN'.
      APPEND ls_text_new TO lt_text_new.
    ENDIF.

* migrate symbols
    CLEAR lt_varsym_new.
    LOOP AT lt_varsym_old ASSIGNING <lwa_varsym_old>.
      APPEND INITIAL LINE TO lt_varsym_new ASSIGNING <lwa_varsym_new>.
      MOVE-CORRESPONDING <lwa_varsym_old> TO <lwa_varsym_new>.
      <lwa_varsym_new>-varguid = ls_var_new-varguid.
    ENDLOOP.

* db update
    IF p_prod IS NOT INITIAL.
      INSERT /cadaxo/sqlcvnhd CLIENT SPECIFIED FROM ls_var_new.
      IF lt_text_new IS NOT INITIAL.
        INSERT /cadaxo/sqlcvntx CLIENT SPECIFIED FROM TABLE lt_text_new.
      ENDIF.
      IF lt_varsym_new IS NOT INITIAL.
        INSERT /cadaxo/sqlcvnsy CLIENT SPECIFIED FROM TABLE lt_varsym_new.
      ENDIF.
      COMMIT WORK.
    ENDIF.
  ENDLOOP.

ENDFORM.                    "convert_variants


*&---------------------------------------------------------------------*
*&      Form  convert_user_sql_log
*&---------------------------------------------------------------------*
FORM convert_user_sql_log .

  DATA lt_sqlclog   TYPE TABLE OF /cadaxo/sqlclog.
  DATA l_sqlclog    TYPE /cadaxo/sqlclog.
  DATA l_sqllog_xml TYPE /cadaxo/sqlc_sqllog.
  DATA l_xml        TYPE string.
  DATA l_done       TYPE i.
  DATA l_error      TYPE i.

  FIELD-SYMBOLS: <ls_sqlclog> LIKE LINE OF lt_sqlclog.

  CHECK p_logs = abap_true.

  PERFORM tr_prot_add USING
                 2
                '/CADAXO/SQLC_ULOG'
                 '010'
                 'User Logs'
                 '(1.2.x'
                 'to'(001)
                 '2.1.0)'.

* get all sql logs
  SELECT * FROM /cadaxo/sqlclog CLIENT SPECIFIED INTO TABLE lt_sqlclog. "#EC CI_NOWHERE

* remove new logs or migrated logs
  DELETE lt_sqlclog WHERE NOT sql_log IS INITIAL.

  LOOP AT lt_sqlclog ASSIGNING <ls_sqlclog>.

    CLEAR: l_sqlclog,
           l_sqllog_xml,
           l_xml.

    l_sqlclog-mandt     = <ls_sqlclog>-mandt.
    l_sqlclog-uname     = <ls_sqlclog>-uname.
    l_sqlclog-timestamp = <ls_sqlclog>-timestamp.

    CLEAR l_sqllog_xml.

    l_sqllog_xml-sql_string     = <ls_sqlclog>-sql_string.
    l_sqllog_xml-result_status  = <ls_sqlclog>-result_status.
    l_sqllog_xml-sql_mode       = <ls_sqlclog>-sql_mode.
    l_sqllog_xml-result_rows    = <ls_sqlclog>-result_rows.
    l_sqllog_xml-result_runtime = <ls_sqlclog>-result_runtime.

    CALL TRANSFORMATION id
       SOURCE log = l_sqllog_xml
       RESULT XML l_xml .

    cl_abap_gzip=>compress_text(
      EXPORTING
        text_in  = l_xml
      IMPORTING
        gzip_out = l_sqlclog-sql_log ).

    CLEAR: l_sqlclog-sql_string,
           l_sqlclog-result_status,
           l_sqlclog-sql_mode,
           l_sqlclog-result_rows,
           l_sqlclog-result_runtime.

* insert record to database
    IF NOT l_sqlclog-sql_log IS INITIAL.
      IF p_prod IS NOT INITIAL.
        UPDATE /cadaxo/sqlclog CLIENT SPECIFIED FROM l_sqlclog.
      ENDIF.
      l_done = l_done + 1.

      COMMIT WORK.
    ENDIF.

  ENDLOOP.

ENDFORM.                    " MIGRATE_USER_SQL_LOG

FORM set_rev_version.

  PERFORM tr_prot_add USING
                   2
                  '/CADAXO/SQLC_ULOG'
                   '010'
                   'Revision'
                   '3.4.0'
                   ''
                   ''.

  UPDATE /cadaxo/sqlcparv CLIENT SPECIFIED
                          SET parameter_value = '3.4.0'
                          WHERE parameter_id    = 'CADAXO_REV_VERSION'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  tr_prot
*&---------------------------------------------------------------------*
FORM tr_prot_add USING u_level
                       u_ag
                       u_msgnr
                       u_var1
                       u_var2
                       u_var3
                       u_var4.

  DATA: lwa_prot TYPE sprot_u.

* Append the protocol messages
  lwa_prot-level     = u_level.
  lwa_prot-severity  = space.        "Information
  lwa_prot-langu     = sy-langu.
  lwa_prot-ag        = u_ag.
  lwa_prot-msgnr     = u_msgnr.
  lwa_prot-var1      = u_var1.
  lwa_prot-var2      = u_var2.
  lwa_prot-var3      = u_var3.
  lwa_prot-var4      = u_var4.
  APPEND lwa_prot TO gt_prot.

ENDFORM.                    "tr_prot

*&---------------------------------------------------------------------*
*&      Form  tr_prot_save
*&---------------------------------------------------------------------*
FORM tr_prot_save.
  CHECK gt_prot IS NOT INITIAL.

  CALL FUNCTION 'TR_APPEND_LOG'
    TABLES
      xmsg   = gt_prot
    EXCEPTIONS
      OTHERS = 1.
  IF sy-subrc = 0.
    CALL FUNCTION 'TR_FLUSH_LOG'.

  ENDIF.
ENDFORM.                    "tr_prot_save
