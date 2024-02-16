*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCADMININFOF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_0100
*&---------------------------------------------------------------------*
FORM user_command_0100  USING u_okcode.
  DATA: lt_clipboard TYPE /cadaxo/cl_sqlc_cockpit_main=>gtt_char255.
  DATA: l_data       TYPE string.
  DATA: l_rc         TYPE i.

  CASE u_okcode.
    WHEN 'CANCEL'.
      SET HANDLER gr_handler->on_sapevent FOR gr_html ACTIVATION space.
      gr_html->close_document( ).
      gr_html->free( ).
      gr_cont->free( ).
      FREE gr_html.
      FREE gr_cont.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'COPY'.
      l_data = g_data.
      WHILE STRLEN( l_data ) GE 255.
        APPEND l_data(255) TO lt_clipboard.
        l_data = l_data+255.
      ENDWHILE.

      IF STRLEN( l_data ) > 0.
        APPEND l_data TO lt_clipboard.
      ENDIF.
      cl_gui_frontend_services=>clipboard_export(
        IMPORTING
          data                 = lt_clipboard
        CHANGING
          rc                   = l_rc
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
          OTHERS               = 4 ).
  ENDCASE.
ENDFORM.                    " USER_COMMAND_0100
*&---------------------------------------------------------------------*
*&      Form  INIT_CONTROLS
*&---------------------------------------------------------------------*
FORM init_controls .
  DATA: lt_cache         TYPE /cadaxo/cl_sqlc_cockpit_main=>gtt_char255.
  DATA: l_doc_url(80)    TYPE c.
  DATA: l_html           TYPE string.
  DATA: lt_event         TYPE cntl_simple_events.
  DATA: lwa_event        TYPE cntl_simple_event.


  IF gr_cont IS INITIAL.
    CREATE OBJECT gr_cont
      EXPORTING
        container_name = 'GD_CONT_HTML'
      EXCEPTIONS
        OTHERS         = 1.

    CREATE OBJECT gr_html
      EXPORTING
        parent = gr_cont
      EXCEPTIONS
        OTHERS = 1.

    lwa_event-eventid = gr_html->m_id_sapevent.
    lwa_event-appl_event = abap_true.
    APPEND lwa_event TO lt_event.
    gr_html->set_registered_events( EXPORTING events = lt_event ).

    CREATE OBJECT gr_handler.
    SET HANDLER gr_handler->on_sapevent FOR gr_html.


    IF gr_main IS INITIAL.
      CREATE OBJECT gr_main.
    ENDIF.

    gr_main->get_content(
      EXPORTING
        i_html_id      = 'MAILINFO'
      IMPORTING
        e_html_string  = l_html
           ).
    IF NOT l_html IS INITIAL.
* prepare html
      PERFORM prepare_html USING    l_html
                           CHANGING lt_cache.
* load the html data
      gr_html->load_data( IMPORTING assigned_url = l_doc_url
                          CHANGING  data_table   = lt_cache ).

* show the html document
      gr_html->show_url( url = l_doc_url ).
    ELSE.
      MESSAGE i101(/cadaxo/sqlc). "no html startup-document found
    ENDIF.
  ENDIF.
ENDFORM.                    " INIT_CONTROLS
*&---------------------------------------------------------------------*
*&      Form  PREPARE_HTML
*&---------------------------------------------------------------------*
FORM prepare_html  USING    value(u_html) TYPE string
                   CHANGING ct_html       TYPE /cadaxo/cl_sqlc_cockpit_main=>gtt_char255.

  DATA: l_regex                       TYPE string.
  DATA: l_string                      TYPE string.
  CLEAR ct_html.

* Select
  CONCATENATE '<SELECT>' g_sql '</SELECT>' INTO l_string.
  CONCATENATE g_data cl_abap_char_utilities=>cr_lf  l_string INTO g_data.
  CALL METHOD cl_http_utility=>escape_html
    EXPORTING
      unescaped = l_string
    RECEIVING
      escaped   = l_string.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN l_string WITH '<br />'.
  CONCATENATE g_data_html l_string INTO g_data_html.

  CONCATENATE '<MESSAGE>' g_msg '</MESSAGE>' INTO l_string.
  CONCATENATE g_data cl_abap_char_utilities=>cr_lf l_string INTO g_data.
  CALL METHOD cl_http_utility=>escape_html
    EXPORTING
      unescaped = l_string
    RECEIVING
      escaped   = l_string.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN l_string WITH '<br />'.
  CONCATENATE g_data_html '<br />' l_string INTO g_data_html.

  CONCATENATE '<SQLCOMPONENTS>' g_cockpit '</SQLCOMPONENTS>' INTO l_string.
  CONCATENATE g_data cl_abap_char_utilities=>cr_lf l_string INTO g_data.
  CALL METHOD cl_http_utility=>escape_html
    EXPORTING
      unescaped = l_string
    RECEIVING
      escaped   = l_string.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN l_string WITH '<br />'.
  CONCATENATE g_data_html '<br />' l_string INTO g_data_html.

  CONCATENATE '<SAPCOMPONENTS>' g_sapcomp '</SAPCOMPONENTS>' INTO l_string.
  CONCATENATE g_data cl_abap_char_utilities=>cr_lf l_string INTO g_data.
  CALL METHOD cl_http_utility=>escape_html
    EXPORTING
      unescaped = l_string
    RECEIVING
      escaped   = l_string.
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN l_string WITH '<br />'.
  CONCATENATE g_data_html '<br />' l_string INTO g_data_html.

  l_regex = '<SUPPORTINFO/>'.
  REPLACE ALL OCCURRENCES OF REGEX l_regex IN u_html WITH g_data_html.


  WHILE STRLEN( u_html ) GE 255.
    APPEND u_html(255) TO ct_html.
    u_html = u_html+255.
  ENDWHILE.

  IF STRLEN( u_html ) > 0.
    APPEND u_html TO ct_html.
  ENDIF.
ENDFORM.                    " PREPARE_HTML
