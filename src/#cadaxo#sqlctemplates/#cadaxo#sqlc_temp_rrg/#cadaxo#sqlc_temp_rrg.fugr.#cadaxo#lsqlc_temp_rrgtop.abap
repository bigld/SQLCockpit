FUNCTION-POOL /cadaxo/sqlc_temp_rrg.        "MESSAGE-ID ..

TABLES: /cadaxo/sqlc_temp_rrg_attr.

* Types
TYPES: BEGIN OF typ_roadmap_step,
         step_id(12),
         step_description(30),
         step_documentation      TYPE swf_docu,
         step_documentation_html TYPE htmltable,
         step_active(1),
         step_prog               TYPE sy-repid,
         step_subdynpro(4),
         step_visible(1),
         step_type(1),
       END OF typ_roadmap_step.

DATA: gs_temp_attr        TYPE /cadaxo/sqlc_temp_rrg_attr.

* References
DATA: gr_cont               TYPE REF TO cl_gui_custom_container.
DATA: gr_grid               TYPE REF TO cl_gui_alv_grid.

DEFINE build_symbols.

  ASSIGN gt_swcont[ element = 'CDX&1' ] TO <fs_swcont>.
  IF sy-subrc <> 0.
     APPEND INITIAL LINE TO gt_swcont ASSIGNING <fs_swcont>.
  ENDIF.
  <fs_swcont>-element = 'CDX&1'.
  <fs_swcont>-type = 'C'.
  <fs_swcont>-value = &2.
  <fs_swcont>-elemlength = strlen( <fs_swcont>-value ).

END-OF-DEFINITION.

* Wizard Data
DATA: gt_htmllines         TYPE htmltable.
DATA: ls_htmllines         TYPE htmlline.
DATA: gt_swcont            TYPE TABLE OF swcont.
DATA: gt_roadmap           TYPE TABLE OF typ_roadmap_step.
DATA: ok_code              TYPE sy-ucomm.
DATA: g_current_step(12).
DATA: g_current_subdynpro(4) TYPE n.
DATA: g_current_prog         TYPE sy-repid.
DATA: g_current_step_index   TYPE i.
DATA: g_total_steps          TYPE i.
DATA: g_main_subscreen(4)    TYPE n.
DATA: gt_merge               TYPE swww_t_merge_table.
DATA: go_rrg_wiz           TYPE REF TO /cadaxo/cl_sqlc_temp_rrg.
DATA: gcc_description        TYPE REF TO cl_gui_custom_container.
DATA: gcc_roadmap            TYPE REF TO cl_gui_custom_container.
DATA: g_event                TYPE cntl_simple_event.
DATA: gt_events              TYPE cntl_simple_events.
DATA: gc_description         TYPE REF TO cl_gui_html_viewer.
DATA: gc_roadmap             TYPE REF TO cl_gui_html_viewer.
DATA: g_description_url(4096).
CLASS lcl_event_handler_html_viewer    DEFINITION DEFERRED.
DATA: gr_receiver          TYPE REF TO lcl_event_handler_html_viewer .
CLASS lcl_event_handler_alv            DEFINITION DEFERRED.
DATA: gr_handler           TYPE REF TO lcl_event_handler_alv.

FIELD-SYMBOLS: <gs_roadmap>  TYPE typ_roadmap_step.



*----------------------------------------------------------------------*
*       CLASS lcl_event_handler_html_viewer DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler_html_viewer DEFINITION.

  PUBLIC SECTION.
    METHODS: on_sapevent FOR EVENT sapevent OF cl_gui_html_viewer
      IMPORTING action getdata.

ENDCLASS.                    "lcl_event_handler_html_viewer DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler_html_viewer IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_handler_html_viewer IMPLEMENTATION.

  METHOD on_sapevent.

    g_current_step = getdata.

  ENDMETHOD.                    "on_sapevent

ENDCLASS.

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler_alv DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event_handler_alv  DEFINITION.

  PUBLIC SECTION.
    METHODS:
      hdl_rb_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id
                  e_column_id
                  es_row_no.

ENDCLASS.                    "lcl_event_handler_alv DEFINITION
*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_event_handler_alv
*&---------------------------------------------------------------------*
CLASS lcl_event_handler_alv IMPLEMENTATION.

  METHOD hdl_rb_click.

    DATA: ls_stable TYPE lvc_s_stbl.

    "  READ TABLE go_odata_wiz->gt_selopt ASSIGNING FIELD-SYMBOL(<ls_selopt>) INDEX e_row_id-index.
    "  IF sy-subrc <> 0.
    "    RETURN.
    "  ENDIF.

    "  ASSIGN COMPONENT e_column_id-fieldname OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<l_field>).
    "  IF sy-subrc = 0.
    "     IF <l_field> EQ abap_true.
    "       <l_field> = abap_false.
    "     ELSE.
    "       <l_field> = abap_true.
    "     ENDIF.
    "   ENDIF.

    ls_stable-row = abap_true.
    ls_stable-col = abap_true.
    gr_grid->refresh_table_display( is_stable = ls_stable ).

  ENDMETHOD.

ENDCLASS.
