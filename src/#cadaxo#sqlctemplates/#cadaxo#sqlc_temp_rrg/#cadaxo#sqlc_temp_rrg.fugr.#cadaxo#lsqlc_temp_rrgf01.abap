*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_RRGF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_roadmap
*&---------------------------------------------------------------------*
FORM init_roadmap .

  DATA ls_roadmap           TYPE typ_roadmap_step.

  CLEAR: gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'START'.
  ls_roadmap-step_description   = TEXT-s01.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_RRG_START'.
  ls_roadmap-step_active        = 'X'.
  ls_roadmap-step_subdynpro     = '0110'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'I'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'OBJECTS'.
  ls_roadmap-step_description   = TEXT-s02.
  ls_roadmap-step_subdynpro     = '0120'.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_RRG_OBJ'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'DICT'.
  ls_roadmap-step_description   = TEXT-s03.
  ls_roadmap-step_subdynpro     = '0130'.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_RRG_STRUC'.
  ls_roadmap-step_visible       = ''.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'CLASS'.
  ls_roadmap-step_description   = TEXT-s04.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_RRG_CLASS'.
  ls_roadmap-step_subdynpro     = '0140'.
  ls_roadmap-step_visible       = ''.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'RRGCUST'.
  ls_roadmap-step_description   = TEXT-s05.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_RRG_CUST'.
  ls_roadmap-step_subdynpro     = '0150'.
  ls_roadmap-step_visible       = ''.
  ls_roadmap-step_type          = 'E'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'GENERATE'.
  ls_roadmap-step_description   = TEXT-s98.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_RRG_END'.
  ls_roadmap-step_subdynpro     = '0160'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'I'.
  APPEND ls_roadmap TO gt_roadmap.

  CLEAR ls_roadmap.
  ls_roadmap-step_id            = 'LOGS'.
  ls_roadmap-step_description   = TEXT-s99.
  ls_roadmap-step_documentation = '/CADAXO/SQLC_TEMP_RRG_LOGS'.
  ls_roadmap-step_subdynpro     = '0101'.
  ls_roadmap-step_prog          = 'SAPLSBAL_DISPLAY'.
  ls_roadmap-step_visible       = 'X'.
  ls_roadmap-step_type          = 'F'.
  APPEND ls_roadmap TO gt_roadmap.

  g_current_step = 'START'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form init_selopt
*&---------------------------------------------------------------------*
FORM init_selopt .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_documentation
*&---------------------------------------------------------------------*
FORM get_documentation  USING    p_docuobject TYPE swf_docu
                        CHANGING p_htmltable  TYPE htmltable.

  DATA l_merge_item    TYPE swww_t_merge_item.
  DATA lt_html         TYPE swww_t_html_table.
  DATA l_html_string   TYPE string.

  CALL FUNCTION '/CADAXO/SQLC_DOCU_AS_HTML'
    EXPORTING
      i_docu_id               = 'TX'
      i_docu_object           = p_docuobject
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
*& Form load_html
*&---------------------------------------------------------------------*
FORM load_html .


  DATA: l_merge_item    TYPE swww_t_merge_item.
  DATA: l_html_string   TYPE string.

  IF gcc_description IS INITIAL.

    gcc_description = NEW #(
      parent         = cl_gui_container=>default_screen
      container_name = 'GCC_DESCRIPTION'
      lifetime       = 1 ).

    gc_description = NEW #(
      parent = gcc_description
      uiflag = cl_gui_html_viewer=>uiflag_noiemenu ).

  ENDIF.

  IF gcc_roadmap IS INITIAL.

    gcc_roadmap = NEW #(
      parent         = cl_gui_container=>default_screen
      container_name = 'GCC_ROADMAP'
      lifetime       = 1 ).

    gc_roadmap = NEW #(
      parent = gcc_roadmap
      uiflag = cl_gui_html_viewer=>uiflag_noiemenu ).

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

ENDFORM.
