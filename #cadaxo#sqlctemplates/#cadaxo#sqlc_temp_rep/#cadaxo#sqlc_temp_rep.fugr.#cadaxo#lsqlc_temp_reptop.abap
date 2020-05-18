FUNCTION-POOL /cadaxo/sqlc_temp_rep.        "MESSAGE-ID ..

TYPE-POOLS: swww, cntl, cnht.

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

* Constants
CONSTANTS: c_true           TYPE c VALUE 'X'.
CONSTANTS: c_false          TYPE c VALUE space.

* Tables
DATA: gt_selopt             TYPE /cadaxo/sqlc_temp_rep_sel_strt.
DATA: gt_where              TYPE /cadaxo/sqlcwherecol_str_t.

* Template name
DATA: g_templ_name          TYPE /cadaxo/sqlctempl_name.

* Workareas
DATA: gs_report_attr        TYPE /cadaxo/sqlc_temp_rep_attr.
DATA: gs_evt                TYPE /cadaxo/sqlc_temp_rep_salv_evt.
DATA: gs_evt_new            TYPE /cadaxo/sqlc_temp_rep_salv_evt.
DATA: g_sett_loaded         TYPE flag.
DATA: BEGIN OF wa_checked,
                  report         TYPE progname,
                  header_include TYPE progname,
                  enh_include    TYPE progname,
  END OF wa_checked.
DATA: wa_locked             LIKE wa_checked.

* Fieldsymbols
FIELD-SYMBOLS: <wa_where>   TYPE /cadaxo/sqlcwherecol_str.
FIELD-SYMBOLS: <wa_selopt>  TYPE /cadaxo/sqlc_temp_rep_sel_str.

* References
DATA: gr_cont               TYPE REF TO cl_gui_custom_container.
DATA: gr_grid               TYPE REF TO cl_gui_alv_grid.

* Scheme DATA
DATA: BEGIN OF gss_where.
INCLUDE         TYPE /cadaxo/sqlcwherecol_str.
DATA: paramname TYPE fieldname,
      highvalue TYPE string,
      END OF gss_where.
DATA: gst_where              LIKE TABLE OF gss_where  WITH HEADER LINE.
DATA: gst_init               LIKE TABLE OF gss_where  WITH HEADER LINE.
DATA: gst_fcat               TYPE lvc_t_fcat          WITH HEADER LINE.
DATA: gss_fcat               TYPE lvc_s_fcat.
DATA: BEGIN OF gss_header,
      line TYPE char255,
      END OF gss_header.
DATA: gst_header             LIKE TABLE OF gss_header WITH HEADER LINE.

DATA: BEGIN OF gss_tabnames,
      tabname TYPE tabname16,
      END OF gss_tabnames.
DATA: gst_tabnames          LIKE TABLE OF gss_tabnames WITH HEADER LINE.
DATA: gst_auth_tabnames     LIKE TABLE OF gss_tabnames WITH HEADER LINE.
DATA: gsf_sql               TYPE string.
DATA: BEGIN OF gss_string,                                  "CDX130-022
      line TYPE string,                                     "CDX130-022
      END OF gss_string.                                    "CDX130-022
DATA: gst_sql               LIKE TABLE OF gss_string WITH HEADER LINE."CDX130-022
DATA: BEGIN OF gss_keyw,                                    "CDX130-022
      keyw TYPE string,                                     "CDX130-022
      line_feed(1),
      spaces TYPE i,
      END OF gss_keyw.                                      "CDX130-022
DATA: gst_keyw              LIKE TABLE OF gss_keyw WITH HEADER LINE."CDX130-022
FIELD-SYMBOLS: <wa_keyw>    LIKE gss_keyw.

DATA: gsf_where_wc          TYPE string.
DATA: gs_use_table          TYPE tabname.
DATA: g_select_single(1).
* CDX130-010 Begin
DATA: BEGIN OF gss_tabclasses,
      cclass TYPE brgru,
      END OF gss_tabclasses.
DATA: gst_tabclasses_ac      LIKE TABLE OF gss_tabclasses WITH HEADER LINE.
* CDX130-010 End
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



* Wizard Data *****************************************************************
DATA: gt_htmllines         TYPE htmltable.
DATA: ls_htmllines         TYPE htmlline.
DATA: gt_roadmap           TYPE TABLE OF typ_roadmap_step.
DATA: ls_roadmap           TYPE typ_roadmap_step.
DATA: ok_code              TYPE sy-ucomm.
DATA: g_event              TYPE cntl_simple_event.
DATA: gt_events            TYPE cntl_simple_events.
CLASS lcl_event_handler    DEFINITION DEFERRED.
DATA: gr_receiver          TYPE REF TO lcl_event_handler.
CLASS lcl_event_handler2   DEFINITION DEFERRED.
DATA: gr_handler           TYPE REF TO lcl_event_handler2.
DATA: edurl(2048).
DATA: edframe(255).
DATA: edaction(256).
DATA: edgetdata(2048).
DATA: edpostdataline(1024).
DATA: postdata_tab           TYPE cnht_post_data_tab.
DATA: edquery_table          TYPE cnht_query_table.
DATA: g_current_step(12).
DATA: gt_excluding           LIKE sy-ucomm OCCURS 0 WITH HEADER LINE.
DATA: g_total_steps          TYPE i.
DATA: g_current_step_index   TYPE i.
DATA: g_current_subdynpro(4) TYPE n.
DATA: g_main_subscreen(4)    TYPE n.
DATA: gcc_description        TYPE REF TO cl_gui_custom_container.
DATA: gcc_roadmap            TYPE REF TO cl_gui_custom_container.
DATA: gc_description         TYPE REF TO cl_gui_html_viewer.
DATA: gc_roadmap             TYPE REF TO cl_gui_html_viewer.
DATA: g_description_url(4096).
DATA: gt_merge               TYPE swww_t_merge_table.
DATA: gt_swcont              TYPE TABLE OF swcont.
DATA: g_swcont               TYPE swcont.
FIELD-SYMBOLS: <gs_roadmap>  TYPE typ_roadmap_step.
