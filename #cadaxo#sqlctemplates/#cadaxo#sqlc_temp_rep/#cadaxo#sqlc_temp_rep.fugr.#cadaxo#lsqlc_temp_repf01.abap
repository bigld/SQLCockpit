*&---------------------------------------------------------------------*
*&      Form  INIT_ROADMAP
*&---------------------------------------------------------------------*
FORM init_roadmap .

  DATA: l_params TYPE i.

  CLEAR: gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'START'.
  ls_roadmap-step_description   = text-s01.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_REP_START'.
  ls_roadmap-step_active        = 'X'.
  ls_roadmap-step_subdynpro     = '0110'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'I'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'REPORT'.
  ls_roadmap-step_description   = text-s02.
  CASE g_templ_name.
    WHEN '/CADAXO/REPORT_S'.
      ls_roadmap-step_subdynpro     = '0125'.
      ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_REP_REP_S'.
    WHEN '/CADAXO/REPORT_A'.
      ls_roadmap-step_subdynpro     = '0120'.
      ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_REP_REP_A'.
  ENDCASE.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  DESCRIBE TABLE gt_selopt LINES l_params.
  IF l_params > 1.
    CLEAR ls_roadmap.
    ls_roadmap-step_id            = 'SELSCR'.
    ls_roadmap-step_description   = text-s03.
    ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_REP_SELSCR'.
    ls_roadmap-step_subdynpro     = '0130'.
    ls_roadmap-step_visible       = 'X'.
    ls_roadmap-step_type          = 'E'.
    APPEND ls_roadmap TO gt_roadmap.
  ENDIF.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'SCHEME'.
  ls_roadmap-step_description   = text-s04.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_REP_SCHEME'.
  ls_roadmap-step_subdynpro     = '0140'.
  ls_roadmap-step_visible       = ''.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CASE g_templ_name.
    WHEN '/CADAXO/REPORT_A'.
      "CDX130-023 Begin
      CLEAR ls_roadmap.
      ls_roadmap-step_id            = 'EVENTS'.
      ls_roadmap-step_description   = text-s05.
      ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_REP_EVENTS'.
      ls_roadmap-step_subdynpro     = '0145'.
      ls_roadmap-step_visible       = 'X'.
      ls_roadmap-step_type          = 'E'.
      APPEND ls_roadmap TO gt_roadmap.
      "CDX130-023 End
  ENDCASE.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'FINISH'.
  ls_roadmap-step_description   = text-s99.
  CASE g_templ_name.
    WHEN '/CADAXO/REPORT_S'.
      ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_REP_END_S'.
    WHEN '/CADAXO/REPORT_A'.
      ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_REP_END_A'.
  ENDCASE.
  ls_roadmap-step_subdynpro     = '0150'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'I'.
  APPEND ls_roadmap TO gt_roadmap.

  g_current_step = 'START'.

ENDFORM.                    "INIT_ROADMAP
*&---------------------------------------------------------------------*
*&      Form  GET_DOCUMENTATION
*&---------------------------------------------------------------------*
FORM get_documentation  USING    p_docuobject TYPE swf_docu
                        CHANGING p_htmltable  TYPE htmltable.

  DATA: l_merge_item    TYPE swww_t_merge_item.
  DATA: lt_html         TYPE swww_t_html_table.
  DATA: l_html_string   TYPE string.
  DATA: lr_structdescr TYPE REF TO cl_abap_structdescr.

  DATA: lt_comp   TYPE cl_abap_structdescr=>component_table.
  FIELD-SYMBOLS: <fs_comp> LIKE LINE OF lt_comp,
                 <wa>   TYPE ANY,
                 <comp> TYPE ANY.

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

  FIND '&lt;!PARAMS!&gt;' IN TABLE p_htmltable.
  IF sy-subrc = 0.
    REPLACE '&lt;!PARAMS!&gt;' IN TABLE p_htmltable WITH '<!PARAMS!>'.
    CLEAR: l_merge_item,
           gt_merge.
    l_merge_item-name    = '<!PARAMS!>'.
    l_merge_item-command = space.
    LOOP AT gt_selopt ASSIGNING <wa_selopt>.
      CONCATENATE '<TR><TD><B>' <wa_selopt>-field '</B></TD><TD> </TD><TD>' INTO l_html_string.
      CASE icon_radiobutton.
        WHEN <wa_selopt>-selopt_with_default.
          CONCATENATE l_html_string text-so1 INTO l_html_string.
        WHEN <wa_selopt>-selopt_without_default.
          CONCATENATE l_html_string text-so2 INTO l_html_string.
        WHEN <wa_selopt>-hardcoded.
          CONCATENATE l_html_string text-so3 INTO l_html_string.
      ENDCASE.

      CONCATENATE l_html_string '</TD></TR>' INTO l_html_string.
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

* CDX130-023 Begin
  FIND '&lt;!EVENTS!&gt;' IN TABLE p_htmltable.
  IF sy-subrc = 0.
    REPLACE '&lt;!EVENTS!&gt;' IN TABLE p_htmltable WITH '<!EVENTS!>'.
    CLEAR: l_merge_item,
           gt_merge.
    l_merge_item-name    = '<!EVENTS!>'.
    l_merge_item-command = space.

    lr_structdescr ?= cl_abap_structdescr=>describe_by_data(
        p_data         = gs_evt ).
    lt_comp = lr_structdescr->get_components( ).

    LOOP AT lt_comp ASSIGNING <fs_comp>.
      ASSIGN COMPONENT <fs_comp>-name OF STRUCTURE gs_evt TO <comp>.
      IF NOT <comp> IS INITIAL.
        CONCATENATE '<TR><TD><B>' <fs_comp>-name '</B></TD><TD> </TD><TD>' INTO l_html_string.
        CONCATENATE l_html_string <comp> INTO l_html_string.
        CONCATENATE l_html_string '</TD></TR>' INTO l_html_string.
        APPEND l_html_string TO l_merge_item-html.
      ENDIF.
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
* CDX130-023 End

ENDFORM.                    " GET_DOCUMENTATION
*&---------------------------------------------------------------------*
*&      Form  load_html
*&---------------------------------------------------------------------*
*       text
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
ENDFORM.                    "load_html
