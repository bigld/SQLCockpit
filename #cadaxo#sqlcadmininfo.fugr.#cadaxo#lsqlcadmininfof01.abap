*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCADMININFOF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_0100
*&---------------------------------------------------------------------*
FORM user_command_0100  USING u_okcode.

  CASE u_okcode.
    WHEN 'CANCEL'.
      gr_html->close_document( ).
      gr_html->free( ).
      CLEAR gr_html.
      gr_cont->free( ).
      CLEAR gr_cont.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'SETLINK'.
      PERFORM set_link_usage USING g_button.
      gr_html->close_document( ).
      gr_html->free( ).
      CLEAR gr_html.
      gr_cont->free( ).
      CLEAR gr_cont.
      SET SCREEN 0.
      LEAVE SCREEN.
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
        i_html_id      = 'ADMININFOHOME'
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

  DATA: lt_paramids                   TYPE TABLE OF /cadaxo/sqlcparameter_id.
  DATA: lt_result                     TYPE match_result_tab.
  DATA: lt_param                      TYPE TABLE OF /cadaxo/sqlcparameter_val.
  DATA: lwa_param                     TYPE /cadaxo/sqlcparameter_val.
  DATA: l_regex                       TYPE string.
  DATA: l_link_table                  TYPE string.
  DATA: l_btn_link                    TYPE string.
  DATA: l_btn_local                   TYPE string.
  FIELD-SYMBOLS: <lwa_param>          TYPE /cadaxo/sqlcparameter_val.
  FIELD-SYMBOLS: <lwa_paramids>       TYPE /cadaxo/sqlcparameter_id.



  CLEAR ct_html.
* All current links
  SELECT DISTINCT parameter_id FROM /cadaxo/sqlcparv INTO TABLE lt_paramids WHERE parameter_id LIKE 'HTML_STARTUP_LINK%'.
  LOOP AT lt_paramids ASSIGNING <lwa_paramids>.
    /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value(
    EXPORTING
      i_parameter_id      = <lwa_paramids>
      RECEIVING
      r_parameter_value   = lwa_param
    EXCEPTIONS
      parameter_not_found = 1
         ).
    gr_main->param_replace_tags( CHANGING data = lwa_param ).
    APPEND lwa_param TO lt_param.
  ENDLOOP.

  SORT lt_param.
  DELETE ADJACENT DUPLICATES FROM lt_param.


  LOOP AT lt_param ASSIGNING <lwa_param>.
    CONCATENATE l_link_table '<tr><td><a href="' <lwa_param> '" target="_blank">' <lwa_param> '</a><td><tr>' INTO l_link_table.
  ENDLOOP.
  l_regex = '<PARMLINKTABLE/>'.
  REPLACE ALL OCCURRENCES OF REGEX l_regex IN u_html WITH l_link_table.

* buttons
  CASE g_use_link.
    WHEN abap_true.
      l_btn_link  = 'Keep link usage'(q01).
      l_btn_local = 'Set local usage'(q02).
    WHEN abap_false.
      l_btn_link  = 'Set link usage'(q03).
      l_btn_local = 'Keep local usage'(q04).
    WHEN OTHERS.
      l_btn_link  = 'Set link usage'(q03).
      l_btn_local = 'Set local usage'(q02).
  ENDCASE.
  l_regex = '<BTNLOCAL/>'.
  REPLACE ALL OCCURRENCES OF REGEX l_regex IN u_html WITH l_btn_local.
  l_regex = '<BTNLINK/>'.
  REPLACE ALL OCCURRENCES OF REGEX l_regex IN u_html WITH l_btn_link.


  WHILE STRLEN( u_html ) GE 255.
    APPEND u_html(255) TO ct_html.
    u_html = u_html+255.
  ENDWHILE.

  IF STRLEN( u_html ) > 0.
    APPEND u_html TO ct_html.
  ENDIF.
ENDFORM.                    " PREPARE_HTML
*&---------------------------------------------------------------------*
*&      Form  SET_LINK_USAGE
*&---------------------------------------------------------------------*
FORM set_link_usage  USING    u_button.
  DATA l_date      TYPE /cadaxo/sqlcparameter_val.
  DATA l_value     TYPE /cadaxo/sqlcparameter_val.
  DATA ls_log      TYPE /cadaxo/sqlculog_api.
  DATA lr_user_log TYPE REF TO /cadaxo/cl_sqlc_user_log.
  DATA ls_adm_cust  TYPE /cadaxo/sqlc_admin_cust.

  /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).

  CASE u_button.
    WHEN c_btn_local.
      ls_adm_cust-home_use_link = abap_false.
    WHEN c_btn_link.
      ls_adm_cust-home_use_link = abap_true.
  ENDCASE.

  ls_adm_cust-home_use_link_date = sy-datum.

  /cadaxo/cl_sqlc_cockpit_assist=>set_adm_customizing( EXPORTING i_customizing = ls_adm_cust ).

  CLEAR ls_log.
  ls_log-object     = /cadaxo/cl_sqlc_user_log=>con_obj_hl. "'HOMELINK'.          "CDX130-020
  ls_log-object_key = /cadaxo/cl_sqlc_user_log=>con_obj_key_hl. "'HOME_USE_LINK'. "CDX130-020
  ls_log-type       = 'I'.
  ls_log-id         = '/CADAXO/SQLC'.
  ls_log-number     = '072'.
  ls_log-message_v1 = sy-uname.
  ls_log-message_v2 = l_value.
  IF 1 = 2. MESSAGE i072(/cadaxo/sqlc). ENDIF.

  CREATE OBJECT lr_user_log.

  lr_user_log->add_ulog( i_log_message = ls_log ).

ENDFORM.                    " SET_LINK_USAGE
