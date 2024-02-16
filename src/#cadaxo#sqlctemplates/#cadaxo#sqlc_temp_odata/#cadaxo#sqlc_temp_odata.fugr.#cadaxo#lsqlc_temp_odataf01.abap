*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_ODATAF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  LOAD_HTML
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM load_html .

  DATA: l_merge_item    TYPE swww_t_merge_item.
  DATA: l_html_string   TYPE string.

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

ENDFORM.              "load_html
*&---------------------------------------------------------------------*
*&      Form  INIT_ROADMAP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_roadmap .

  DATA ls_roadmap           TYPE typ_roadmap_step.

  CLEAR: gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'START'.
  ls_roadmap-step_description   = text-s01.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_ODAT_START'.
  ls_roadmap-step_active        = 'X'.
  ls_roadmap-step_subdynpro     = '0110'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'I'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'REPORT'.
  ls_roadmap-step_description   = text-s02.
  ls_roadmap-step_subdynpro     = '0120'.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_ODATA_ATTR'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'SELSCR'.
  ls_roadmap-step_description   = text-s03.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_ODAT_SELSC'.
  ls_roadmap-step_subdynpro     = '0130'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'GENERATE'.
  ls_roadmap-step_description   = text-s99.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_ODATA_END'.
  ls_roadmap-step_subdynpro     = '0140'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'I'.
  APPEND ls_roadmap TO gt_roadmap.

  g_current_step = 'START'.

ENDFORM.
FORM get_documentation  USING    p_docuobject TYPE swf_docu
                        CHANGING p_htmltable  TYPE htmltable.

  DATA: l_merge_item    TYPE swww_t_merge_item.
  DATA: lt_html         TYPE swww_t_html_table.
  DATA: l_html_string   TYPE string.

  CALL FUNCTION 'SWF_DOCUMENTATION_AS_HTML_GET'
    EXPORTING
      docu_object             = p_docuobject
    TABLES
      container               = gt_swcont
      html_lines              = p_htmltable
    EXCEPTIONS
      documentation_not_found = 1
      OTHERS                  = 2.
  IF sy-subrc NE 0.
    CLEAR p_htmltable.
  ENDIF.

  FIND '&lt;!KEYS!&gt;' IN TABLE p_htmltable.
  IF sy-subrc = 0.
    REPLACE '&lt;!KEYS!&gt;' IN TABLE p_htmltable WITH '<!KEYS!>'.
    CLEAR: l_merge_item,
           gt_merge.
    l_merge_item-name    = '<!KEYS!>'.
    l_merge_item-command = space.
    LOOP AT go_odata_wiz->gt_selopt ASSIGNING FIELD-SYMBOL(<wa_selopt>) WHERE is_key = abap_true.
      CONCATENATE '<TR><TD><B>' 'Key field' '</B></TD><TD> </TD><TD>' INTO l_html_string.
      CONCATENATE l_html_string <wa_selopt>-node_name'</TD></TR>' INTO l_html_string.
      APPEND l_html_string TO l_merge_item-html.
    ENDLOOP.
    APPEND l_merge_item TO gt_merge.

    lt_html = p_htmltable.
    CALL FUNCTION 'WWW_HTML_MERGER'
      EXPORTING
        template           = ''
        template_table     = lt_html
      IMPORTING
        html_table         = lt_html
      CHANGING
        merge_table        = gt_merge
      EXCEPTIONS
        template_not_found = 1
        OTHERS             = 2.
    p_htmltable = lt_html.
  ENDIF.

ENDFORM.                    " GET_DOCUMENTATION
*&---------------------------------------------------------------------*
*&      Form  CONTAINER_130
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM container_130 .
  DATA: lwa_layout             TYPE lvc_s_layo.
  DATA: lt_fcat                TYPE lvc_t_fcat.
  DATA: lwa_stable_ref         TYPE lvc_s_stbl.
  FIELD-SYMBOLS: <lwa_fcat>    TYPE lvc_s_fcat.

  IF gr_cont IS INITIAL.
    CREATE OBJECT gr_cont
      EXPORTING
        container_name = 'CC_SELSCR'
      EXCEPTIONS
        OTHERS         = 1.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT gr_grid
      EXPORTING
        i_parent      = gr_cont
        i_appl_events = abap_false
      EXCEPTIONS
        OTHERS        = 1.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = '/CADAXO/SQLC_TEMP_ODATA_SELSTR'
      CHANGING
        ct_fieldcat      = lt_fcat.

    LOOP AT lt_fcat ASSIGNING <lwa_fcat>.
      CASE <lwa_fcat>-fieldname.
        WHEN  'NODE_NAME'.
          <lwa_fcat>-outputlen = 25.
        WHEN 'IS_KEY'
          OR 'FILTERABLE'
          OR 'HARDCODED'.
          <lwa_fcat>-checkbox = abap_true.
          <lwa_fcat>-edit     = abap_true.
          <lwa_fcat>-hotspot  = abap_true.
          <lwa_fcat>-outputlen = 10.
          IF <lwa_fcat>-fieldname EQ 'FILTERABLE'
          OR <lwa_fcat>-fieldname EQ 'HARDCODED'.
            <lwa_fcat>-no_out = abap_true.
          ENDIF.
        WHEN  'EDM_CORE_TYPE'.
          <lwa_fcat>-edit     = abap_false.
          <lwa_fcat>-outputlen = 25.
        WHEN  'ABAP_FIELD'.
          <lwa_fcat>-outputlen = 25.
          <lwa_fcat>-edit     = abap_false.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    lwa_layout-no_toolbar = abap_true.
    lwa_layout-no_rowmark = abap_true.
    lwa_layout-stylefname = 'STYLE'.

    CREATE OBJECT gr_handler.
    SET HANDLER gr_handler->hdl_rb_click FOR gr_grid.

    gr_grid->set_table_for_first_display( EXPORTING is_layout       = lwa_layout
                                          CHANGING  it_outtab       = go_odata_wiz->gt_selopt
                                                    it_fieldcatalog = lt_fcat ).
  ELSE.
    lwa_stable_ref-row = abap_true.
    lwa_stable_ref-col = abap_true.
    gr_grid->refresh_table_display( is_stable = lwa_stable_ref ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_SELOPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_selopt .

  IF NOT gr_handler IS INITIAL.
    FREE gr_handler.
  ENDIF.

  IF NOT gr_grid IS INITIAL.
    gr_grid->free( ).
    FREE gr_grid.
  ENDIF.

  IF NOT gr_cont IS INITIAL.
    gr_cont->free( ).
    FREE gr_cont.
  ENDIF.

  go_odata_wiz->fill_selopt( IMPORTING et_selopt = go_odata_wiz->gt_selopt ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  PROJECT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE package INPUT.

  go_odata_wiz->validate_package(
    EXPORTING
      iv_package      = gs_report_attr-package
      iv_project_name = gs_report_attr-project_name ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PROJECT_NAME  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE project_name INPUT.

  go_odata_wiz->validate_project_name(
    EXPORTING
      iv_project_name = gs_report_attr-project_name ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  CLEAR_GLOBAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DELETE_CC .

  gcc_description->free( ).
  gcc_roadmap->free( ).

ENDFORM.
