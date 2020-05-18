FUNCTION-POOL /cadaxo/sqlc_job.             "MESSAGE-ID ..

TABLES: /cadaxo/sqlc_jobwiz_fields.

TYPES: BEGIN OF typ_roadmap_step,
          step_id(12),
          step_description(30),
          step_documentation TYPE swf_docu,
          step_documentation_html TYPE htmltable,
          step_active(1),
          step_subdynpro(4),
          step_visible(1),
          step_type(1),
       END OF typ_roadmap_step.

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.
    METHODS: on_sapevent
               FOR EVENT sapevent OF cl_gui_html_viewer
                 IMPORTING action getdata.

ENDCLASS.                    "lcl_event_handler DEFINITION



DATA: gt_htmllines TYPE htmltable,
      ls_htmllines TYPE htmlline,
      gt_roadmap TYPE TABLE OF typ_roadmap_step,
      ls_roadmap TYPE typ_roadmap_step,
      g_current_step(12),
      gt_excluding LIKE sy-ucomm OCCURS 0 WITH HEADER LINE,
      g_total_steps TYPE i,
      g_current_step_index TYPE i,
      g_current_subdynpro(4) TYPE n,
      g_main_subscreen(4) TYPE n,
      gt_swcont TYPE TABLE OF swcont,
      g_swcont TYPE swcont.

DATA: gcc_description TYPE REF TO cl_gui_custom_container,
      gcc_roadmap     TYPE REF TO cl_gui_custom_container,
      gc_description  TYPE REF TO cl_gui_html_viewer,
      gc_roadmap      TYPE REF TO cl_gui_html_viewer,
      g_description_url(4096),
      gt_merge TYPE swww_t_merge_table,
      ok_code TYPE sy-ucomm.

DATA: g_event TYPE cntl_simple_event,
      gt_events TYPE cntl_simple_events,
      gr_receiver TYPE REF TO lcl_event_handler,

      edurl(2048),
      edframe(255),
      edaction(256),
      edgetdata(2048),
      edpostdataline(1024),
      postdata_tab TYPE cnht_post_data_tab,
      edquery_table TYPE cnht_query_table.                  "#EC NEEDED

FIELD-SYMBOLS: <gs_roadmap> TYPE typ_roadmap_step.

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_sapevent.
    g_current_step = getdata.
  ENDMETHOD.                    "on_sapevent

ENDCLASS.                    "lcl_event_handler IMPLEMENTATION
