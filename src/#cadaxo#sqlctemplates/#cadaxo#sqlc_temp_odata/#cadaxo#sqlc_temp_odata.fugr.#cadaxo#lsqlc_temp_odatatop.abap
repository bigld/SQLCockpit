FUNCTION-POOL /cadaxo/sqlc_temp_odata.      "MESSAGE-ID ..

* Types
TYPES: BEGIN OF typ_roadmap_step,
         step_id(12),
         step_description(30),
         step_documentation      TYPE swf_docu,
         step_documentation_html TYPE htmltable,
         step_active(1),
         step_subdynpro(4),
         step_visible(1),
         step_type(1),
       END OF typ_roadmap_step.

* Workareas
DATA: gs_report_attr        TYPE /cadaxo/sqlc_temp_odata_attr.

* References
DATA: gr_cont               TYPE REF TO cl_gui_custom_container.
DATA: gr_grid               TYPE REF TO cl_gui_alv_grid.

DEFINE build_symbols.
* &1  Name
* &2  field

  read table gt_swcont with key element = 'CDX&1' assigning <fs_swcont>.
  if sy-subrc ne 0.
    append initial line to gt_swcont assigning <fs_swcont>.
  endif.
  move: 'CDX&1'                             to <fs_swcont>-element.
  move: 'C'                                 to <fs_swcont>-type.
  move: &2                                  to <fs_swcont>-value.
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
DATA: g_main_subscreen(4)    TYPE n.
DATA: gt_merge               TYPE swww_t_merge_table.
DATA: go_odata_wiz           TYPE REF TO /cadaxo/cl_sqlc_odata_gen.
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

INCLUDE /cadaxo/lsqlc_temp_odatap02.
