*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_JOBF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DOCUMENTATION
*&---------------------------------------------------------------------*
FORM get_documentation  USING    p_docuobject TYPE swf_docu
                        CHANGING p_htmltable  TYPE htmltable.

  CALL FUNCTION 'SWF_DOCUMENTATION_AS_HTML_GET'
    EXPORTING
      docu_object = p_docuobject
    TABLES
      container   = gt_swcont
      html_lines  = p_htmltable
    EXCEPTIONS
      OTHERS      = 1.
  IF sy-subrc NE 0.
    CLEAR p_htmltable.
  ENDIF.

ENDFORM.                    " GET_DOCUMENTATION
*&---------------------------------------------------------------------*
*&      Form  LOAD_HTML
*&---------------------------------------------------------------------*
FORM load_html .

  DATA: l_merge_item    TYPE swww_t_merge_item.

  IF gcc_description IS INITIAL.

    CREATE OBJECT gcc_description
      EXPORTING
        parent         = cl_gui_container=>default_screen
        container_name = 'GCC_DESCRIPTION'
      EXCEPTIONS
        OTHERS         = 0.

    CREATE OBJECT gc_description
      EXPORTING
        parent = gcc_description
        uiflag = cl_gui_html_viewer=>uiflag_noiemenu
      EXCEPTIONS
        OTHERS = 0.

  ENDIF.

  IF gcc_roadmap IS INITIAL.

    CREATE OBJECT gcc_roadmap
      EXPORTING
        parent         = cl_gui_container=>default_screen
        container_name = 'GCC_ROADMAP'
      EXCEPTIONS
        OTHERS         = 0.

    CREATE OBJECT gc_roadmap
      EXPORTING
        parent = gcc_roadmap
        uiflag = cl_gui_html_viewer=>uiflag_noiemenu
      EXCEPTIONS
        OTHERS = 0.

    g_event-eventid = gc_roadmap->m_id_sapevent.
    g_event-appl_event = 'x'.
    APPEND g_event TO gt_events.
    CALL METHOD gc_roadmap->set_registered_events
      EXPORTING
        events = gt_events.

    CREATE OBJECT gr_receiver.

    SET HANDLER gr_receiver->on_sapevent FOR gc_roadmap.

*<!cadaxo_roadmap_steps!>
    CALL METHOD gc_roadmap->load_mime_object
      EXPORTING
        object_id  = '/CADAXO/SQLC_ROADMAP_BACKGROUND_01'
        object_url = 'CADAXO_ROADMAP_BACKGROUND'
      EXCEPTIONS
        OTHERS     = 0.

  ENDIF.

  CLEAR: l_merge_item,
         gt_merge.
  l_merge_item-name    = '<!roadmap_step_text!>'.
  l_merge_item-command = space.
  APPEND LINES OF <gs_roadmap>-step_documentation_html TO l_merge_item-html.
  APPEND l_merge_item TO gt_merge.

  CALL METHOD gc_description->load_html_document
    EXPORTING
      document_id  = '/CADAXO/SQLC_ROADMAP_HEADER'
    IMPORTING
      assigned_url = g_description_url
    CHANGING
      merge_table  = gt_merge
    EXCEPTIONS
      OTHERS       = 0.

  CALL METHOD gc_description->show_data
    EXPORTING
      url    = g_description_url
    EXCEPTIONS
      OTHERS = 0.

  DATA: l_html_string TYPE string.

  CLEAR: gt_htmllines.
  LOOP AT gt_roadmap ASSIGNING <gs_roadmap> WHERE NOT step_visible IS INITIAL.

    CLEAR l_html_string.

    IF <gs_roadmap>-step_active EQ 'X'.
      IF <gs_roadmap>-step_id = g_current_step.
        CONCATENATE '<li><a title="'
                    <gs_roadmap>-step_description '" class="current">'
                    <gs_roadmap>-step_description '</a></li>' INTO l_html_string.
      ELSE.
        CONCATENATE '<li><a href=SAPEVENT:CLICK_ON_ME?' <gs_roadmap>-step_id ' title="'
                    <gs_roadmap>-step_description '" class="done">'
                    <gs_roadmap>-step_description '</a></li>' INTO l_html_string.
      ENDIF.
    ELSE.
      CONCATENATE '<li><a title="'
                  <gs_roadmap>-step_description '" disabled="disabled">'
                  <gs_roadmap>-step_description '</a></li>' INTO l_html_string.
    ENDIF.

    MOVE l_html_string TO ls_htmllines.
    APPEND ls_htmllines TO gt_htmllines.

  ENDLOOP.


  CLEAR: l_merge_item.

  CLEAR: gt_merge.
  l_merge_item-name    = '<!cadaxo_roadmap_steps!>'.
  l_merge_item-command = space.
  APPEND LINES OF gt_htmllines TO l_merge_item-html.
  APPEND l_merge_item TO gt_merge.

  CALL METHOD gc_roadmap->load_html_document
    EXPORTING
      document_id  = '/CADAXO/SQLC_ROADMAP_TAB'
    IMPORTING
      assigned_url = g_description_url
    CHANGING
      merge_table  = gt_merge
    EXCEPTIONS
      OTHERS       = 0.

  CALL METHOD gc_roadmap->show_data
    EXPORTING
      url    = g_description_url
    EXCEPTIONS
      OTHERS = 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_ROADMAP
*&---------------------------------------------------------------------*
FORM init_roadmap .

  DATA: lt_smtp             TYPE TABLE OF bapiadsmtp.
  DATA: lt_return           TYPE bapiret2_tab.
  FIELD-SYMBOLS: <lwa_smtp> TYPE bapiadsmtp.

  CLEAR gt_roadmap.
  CLEAR /cadaxo/sqlc_jobwiz_fields.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'START'.
  ls_roadmap-step_description   = text-s01.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_JOB_START_INFO'.
  ls_roadmap-step_active        = 'X'.
  ls_roadmap-step_subdynpro     = '0110'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'I'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'GENJOB'.
  ls_roadmap-step_description   = text-s02.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_JOB_GENERAL_INF'.
  ls_roadmap-step_subdynpro     = '0120'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'STARTCOND'.
  ls_roadmap-step_description   = text-s03.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_JOB_START_COND'.
  ls_roadmap-step_subdynpro     = '0130'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'CONDPLANNED'.
  ls_roadmap-step_description   = text-s04.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_JOB_START_DATE'.
  ls_roadmap-step_subdynpro     = '0140'.
  ls_roadmap-step_visible       = ''.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'RESTRICTIONS'.
  ls_roadmap-step_description   = text-s06.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_JOB_RESTRICTIONS'.
  ls_roadmap-step_subdynpro     = '0145'.
  ls_roadmap-step_visible       = ''.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'NOTIFICATION'.
  ls_roadmap-step_description   = text-s05.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_JOB_MAIL_NOTIF'.
  ls_roadmap-step_subdynpro     = '0150'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'FINISH'.
  ls_roadmap-step_description   = text-s99.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_JOB_END'.
  ls_roadmap-step_subdynpro     = '0160'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'I'.
  APPEND ls_roadmap TO gt_roadmap.

  g_current_step = 'START'.

  /cadaxo/sqlc_jobwiz_fields-notification_sap_mail = sy-uname.
  CALL FUNCTION 'BAPI_USER_GET_DETAIL'
    EXPORTING
      username = sy-uname
    TABLES
      return   = lt_return
      addsmtp  = lt_smtp.
  ASSIGN lt_smtp[ std_recip = abap_true ] TO <lwa_smtp>.
  IF sy-subrc <> 0.
    ASSIGN lt_smtp[ 1 ] TO <lwa_smtp>.
  ENDIF.
  IF sy-subrc = 0.
    /cadaxo/sqlc_jobwiz_fields-notification_email1 = <lwa_smtp>-e_mail.
  ENDIF.

ENDFORM.
FORM check_email_address USING
*                              uv_email_flag TYPE flag                 "COCKPIT-298 -Cocjpit451
                               uv_email      TYPE so_name.             "COCKPIT-298

  DATA: lt_email_string TYPE TABLE OF string.

  IF
*    uv_email_flag <> space AND "Cockpit-451
     uv_email <> space.
    SPLIT uv_email AT ';' INTO TABLE lt_email_string.                  "COCKPIT-298
    LOOP AT lt_email_string ASSIGNING FIELD-SYMBOL(<ls_email_string>). "COCKPIT-298
      FIND REGEX '^[a-z0-9\-\.]{2,63}@[a-z0-9\-\.]{2,63}\.[a-z]{2,4}$'
         IN shift_left( <ls_email_string> ) IGNORING CASE.
      IF sy-subrc <> 0.
        MESSAGE e060(/cadaxo/sqlc) WITH <ls_email_string>.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
