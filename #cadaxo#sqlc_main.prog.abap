****************************************************************************************************
* Description             : SQL Cockpit - Main                                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 29.08.2010 | Dominik Bigl         | Set Button inactive, if no trace is set     | CDX001-0010    *
*            |                      | in the user preferences                     |                *
*------------+----------------------+---------------------------------------------+----------------*
* 10.09.2012 | Rehan van der Merwe  | Implement new tabbed Admin screen           |                *
*            |                      | (Screen 09xx)                               |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.06.2016 | Ana Lekic            | report generator for new opensql syntax     | COCKPIT-46     *
*            |                      |                                             | $003           *
*------------+----------------------+---------------------------------------------+----------------*
* 27.06.2016 | Ana Lekic            | ATC checks                                  | COCKPIT-89     *
*            |                      |                                             | $004           *
*------------+----------------------+---------------------------------------------+----------------*
* 13.04.2017 | Domi Bigl            | Fieldcat for Templates                      | COCKPIT-168    *
*------------+----------------------+---------------------------------------------+----------------*
* 10.07.2017 | Harald Wiesinger     | Fixing Dump with report generator           | COCKPIT-19     *
*------------+----------------------+---------------------------------------------+----------------*
* 10.07.2017 | Harald Wiesinger     | Remove popup for max paralell selects       | COCKPIT-194    *
*------------+----------------------+---------------------------------------------+----------------*
* 01.08.2017 | Harald Wiesinger     | Show new API Popups                         | COCKPIT-232    *
* 01.08.2017 | Pat                  | Show new API Popups (für symbols)           | COCKPIT-274    *
****************************************************************************************************
PROGRAM  /cadaxo/sqlc_main.

TABLES: /cadaxo/sqlcusrp_dyn.

INCLUDE: <icon>.

CLASS lcl_event_handler DEFINITION DEFERRED.

DATA: g_button_sql_trace TYPE smp_dyntxt,                   "#EC NEEDED
      g_button_progress  TYPE smp_dyntxt.                   "#EC NEEDED
DATA: g_description TYPE /cadaxo/sqlcapi_description.       "COCKPIT-232
DATA: g_receiver TYPE /cadaxo/sqlcapi_receiver.             "COCKPIT-232

DATA: g_ok_code          TYPE sy-ucomm.
DATA: gd_home_link       TYPE c.
DATA: gd_home_local      TYPE c.
DATA: g_adm              TYPE c.
DATA: gs_adm_cust        TYPE /cadaxo/sqlc_admin_cust.

DATA: gt_excluding_fcode TYPE TABLE OF fcode.

DATA: g_title_version    TYPE string.
DATA: g_title_version_nr TYPE string.

DATA: lcl_controller     TYPE REF TO /cadaxo/cl_sqlc_cockpit_main.
DATA: glcl_event_handler TYPE REF TO lcl_event_handler.
DATA: g_sql_pos          TYPE i.
DATA: g_sql_hist_lines   TYPE i.

DATA: g_col   TYPE i,
      g_row   TYPE i,
      g_col_t TYPE i,
      g_row_t TYPE i.

DATA g_dynpro_text      TYPE string.
DATA g_sqlcsres         TYPE /cadaxo/sqlcsres.
DATA gt_sqlcadoc        TYPE TABLE OF /cadaxo/sqlcadoc.
DATA gt_sqlcadot        TYPE TABLE OF /cadaxo/sqlcadot.
DATA gt_sql_cockpit_standard_users TYPE /cadaxo/sqlc_user_name_t.
DATA g_sqlcadoc         TYPE /cadaxo/sqlcadoc.
DATA g_sqlcadot         TYPE /cadaxo/sqlcadot.
DATA gd_adt_info_i      TYPE icon_text.

TYPES: BEGIN OF type_dd_langu,
         spras TYPE t002c-spras,
         sptxt TYPE t002t-sptxt,
       END OF type_dd_langu.

DATA lt_langu TYPE STANDARD TABLE OF type_dd_langu WITH HEADER LINE.

* tabstrips
DATA     g_subscreen     LIKE sy-dynnr.
DATA     g_report        LIKE sy-repid.
DATA     g_tabstrip_tab4 TYPE string.
DATA     g_tabstrip_tab5 TYPE string.
DATA     g_tabstrip_tab6 TYPE string.
DATA     g_tabstrip_tab7 TYPE string.
CONTROLS admintab        TYPE TABSTRIP.

* addons
DATA gt_installed_addons TYPE /cadaxo/sqlcaddons_installed_t.
DATA gs_installed_addons TYPE /cadaxo/sqlcaddons_installed.
DATA g_addons_cust_cont  TYPE REF TO cl_gui_custom_container.
DATA g_addons_grid       TYPE REF TO cl_gui_alv_grid.
DATA gs_addons_layout    TYPE lvc_s_layo.
DATA gt_addons_fieldcat  TYPE lvc_t_fcat.

DATA: gv_share_type     TYPE /cadaxo/sqlcapi_position_typ.
DATA: gv_share_rfcdest  TYPE /cadaxo/sqlcapi_rfcdest. "cockpit-295
*----------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS: on_col_tree_double_click_item FOR EVENT item_double_click OF cl_gui_column_tree
      IMPORTING node_key item_name,
      on_addons_alv_click           FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id es_row_no.
ENDCLASS.                    "lcl_event_handler DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_addons_alv_click.

    DATA ls_log        TYPE /cadaxo/sqlculog_api.

    READ TABLE gt_installed_addons INDEX es_row_no-row_id INTO gs_installed_addons.
    IF sy-subrc EQ 0.

      CLEAR ls_log.

      IF gs_installed_addons-active = abap_true.
        UPDATE /cadaxo/sqlcadoc SET active = abap_false WHERE addon = gs_installed_addons-addon AND delivery = space.

        ls_log-object     = 'ADDONS'.
        ls_log-object_key = gs_installed_addons-addon.
        ls_log-type       = 'S'.
        ls_log-id         = '/CADAXO/SQLC'.
        ls_log-number     = '091'.
        ls_log-message_v1 = gs_installed_addons-addon.
        IF 1 = 2. MESSAGE s091(/cadaxo/sqlc). ENDIF.

      ELSE.
        UPDATE /cadaxo/sqlcadoc SET active = abap_true WHERE addon = gs_installed_addons-addon AND delivery = space.

        ls_log-object     = 'ADDONS'.
        ls_log-object_key = gs_installed_addons-addon.
        ls_log-type       = 'S'.
        ls_log-id         = '/CADAXO/SQLC'.
        ls_log-number     = '090'.
        ls_log-message_v1 = gs_installed_addons-addon.
        IF 1 = 2. MESSAGE s090(/cadaxo/sqlc). ENDIF.

      ENDIF.
      PERFORM get_installed_addons.
      CALL METHOD g_addons_grid->refresh_table_display.

      lcl_controller->gr_user_log->add_ulog(
          i_log_message = ls_log ).

    ENDIF.



    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'.

  ENDMETHOD.                    "on_addons_alv_click

  METHOD on_col_tree_double_click_item.
  ENDMETHOD.                    "on_col_tree_double_click_item
ENDCLASS.                    "lcl_event_handler IMPLEMENTATION


START-OF-SELECTION.

  CREATE OBJECT lcl_controller.

  CREATE OBJECT glcl_event_handler.

  CALL SCREEN 0100.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  GET_SQL_VARIANT
*&---------------------------------------------------------------------*
*FORM get_sql_variant .
*
*  g_col = ( sy-scols / 2 ) - 65. " 160 / 2 = 80 - 60 = 20
*  g_row = ( sy-srows / 2 ) - 15.
*  g_col_t = g_col + 130.
*  g_row_t = g_row + 20.
*
*  CALL SCREEN 200 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.
*
*ENDFORM.                    " GET_SQL_VARIANT

*&---------------------------------------------------------------------*
*&      Module  PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.

  INCLUDE <icon>.

  CLEAR: gt_excluding_fcode.

  g_sql_pos = lcl_controller->g_sql_pos. "GET_SQL_POS( ).
  g_sql_hist_lines = lcl_controller->get_sql_hist_lines( ).

* Exclude SQL Navigation Functions
  IF g_sql_pos LE 1.
    APPEND 'SQL_BACK' TO gt_excluding_fcode.
  ENDIF.

  IF g_sql_pos GE g_sql_hist_lines.
    APPEND 'SQL_FORW' TO gt_excluding_fcode.
  ENDIF.

  IF lcl_controller->check_admin_auth( ) IS INITIAL.
    APPEND 'ADMIN' TO gt_excluding_fcode.
  ENDIF.

  IF lcl_controller->is_result_filled( ) IS INITIAL.
    APPEND 'SAVE_LISTS' TO gt_excluding_fcode.
  ENDIF.

* Fill dynamic SQL Button - With Trace
  MOVE text-b01 TO g_button_sql_trace-text.
  MOVE text-b01 TO g_button_sql_trace-icon_text.

  IF lcl_controller->g_sql_trace_on IS INITIAL.
    MOVE icon_led_inactive TO g_button_sql_trace-icon_id.
    MOVE text-bi1 TO g_button_sql_trace-quickinfo.
    IF  lcl_controller->g_user_settings-sql_trace IS INITIAL          "CDX001-0010
    AND lcl_controller->g_user_settings-tablebuffer_trace IS INITIAL. "CDX001-0010
      APPEND 'TRACETOGGL' TO gt_excluding_fcode.                      "CDX001-0010
    ENDIF.                                                            "CDX001-0010
  ELSE.
    MOVE icon_led_green TO  g_button_sql_trace-icon_id.
    MOVE text-bi2 TO g_button_sql_trace-quickinfo.
  ENDIF.

* Fill dynamic SQL Button - With Progress
  MOVE text-b02 TO g_button_progress-text.
  MOVE text-b02 TO g_button_progress-icon_text.
  MOVE text-bi2 TO g_button_progress-quickinfo.
  IF lcl_controller->g_sql_progress_on IS INITIAL.
    MOVE icon_led_inactive TO g_button_progress-icon_id.
    MOVE text-bi1 TO g_button_progress-quickinfo.
  ELSE.
    MOVE icon_led_green TO g_button_progress-icon_id.
    MOVE text-bi2 TO g_button_progress-quickinfo.
  ENDIF.

  SET PF-STATUS 'MAIN_0100' EXCLUDING gt_excluding_fcode. "cockpit-416

  IF g_title_version IS INITIAL.
    /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value(
        EXPORTING
          i_parameter_id      = /cadaxo/cl_sqlc_cockpit_assist=>c_param_version
       RECEIVING
         r_parameter_value   = g_title_version_nr
        EXCEPTIONS
          OTHERS              = 2
             ).
  ENDIF.
  IF NOT g_title_version_nr IS INITIAL.
    g_title_version = text-v00.
  ENDIF.
  SET TITLEBAR '0100' WITH g_title_version_nr g_title_version.

  lcl_controller->pbo_0100( ).

  IF g_sql_pos <= 1.
    lcl_controller->gc_splitter_top_toolbar->set_button_state( enabled = abap_false fcode =  'SQL_BACK' ).
  ELSE.
    lcl_controller->gc_splitter_top_toolbar->set_button_state( enabled = abap_true fcode =  'SQL_BACK' ).
  ENDIF.

  IF g_sql_pos GE g_sql_hist_lines.
    lcl_controller->gc_splitter_top_toolbar->set_button_state( enabled = abap_false fcode =  'SQL_FORW' ).
  ELSE.
    lcl_controller->gc_splitter_top_toolbar->set_button_state( enabled = abap_true fcode =  'SQL_FORW' ).
  ENDIF.

  IF lcl_controller->check_admin_auth( ) IS INITIAL.
    lcl_controller->gc_splitter_top_toolbar->set_button_state( enabled = abap_false fcode =  'ADMIN' ).
  ELSE.
    lcl_controller->gc_splitter_top_toolbar->set_button_state( enabled = abap_true fcode =  'ADMIN' ).
  ENDIF.

  IF lcl_controller->is_result_filled( ) IS INITIAL OR lcl_controller->mv_toolbar_result_active <> lcl_controller->c_cmd_show_result_table.
    lcl_controller->gc_splitter_top_toolbar->set_button_state( enabled = abap_false fcode =  'SAVE_LISTS' ).
  ELSE.
    lcl_controller->gc_splitter_top_toolbar->set_button_state( enabled = abap_true fcode =  'SAVE_LISTS' ).
  ENDIF.

  IF /cadaxo/cl_sqlc_cockpit_api=>check_own_queue( ) = abap_true.                               "COCKPIT-233
    lcl_controller->gc_splitter_top_toolbar->set_button_info( fcode = 'QUEUE' icon = '@J1@').   "COCKPIT-233
  ELSE.                                                                                         "COCKPIT-233
    lcl_controller->gc_splitter_top_toolbar->set_button_info( fcode = 'QUEUE' icon = '@J8@').   "COCKPIT-233
  ENDIF.                                                                                        "COCKPIT-233

ENDMODULE.                 " PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0100  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0100 INPUT.

  /cadaxo/cl_sqlc_functrace=>add_trace( |MAIN-PAI_0100:| && g_ok_code ).

  lcl_controller->save_clipboard( ).

  CASE g_ok_code.
    WHEN 'ADMIN'.
      PERFORM admin_settings.
    WHEN 'PERSPREF'.
      PERFORM personal_settings.
    WHEN 'GENERATE'.
      PERFORM generate_template.
    WHEN 'SQL_SHARE'.
      PERFORM share_sql_area
      USING space space.                     "cockpit-420
    WHEN 'SQL_SHR_ME'.                       "cockpit-420
      DATA lv_uname TYPE /cadaxo/sqlcapi_receiver. "cockpit-420
      lv_uname = sy-uname.                   "cockpit-420
      PERFORM share_sql_area USING lv_uname text-002. "cockpit-420
    WHEN 'QUEUE'.
      PERFORM show_api_queue.
    WHEN 'SAVE_LISTS'.
      PERFORM save_lists.
        WHEN OTHERS.
      lcl_controller->pai_0100( EXPORTING i_ok_code = g_ok_code ).
  ENDCASE.

  CLEAR: g_ok_code.

ENDMODULE.                 " PAI_0100  INPUT
*&---------------------------------------------------------------------*
*&      Form  PERSONAL_SETTINGS
*&---------------------------------------------------------------------*
FORM personal_settings .

  /cadaxo/sqlcusrp_dyn = lcl_controller->g_user_settings.

  g_col = ( sy-scols / 2 ) - 54.
  g_row = ( sy-srows / 2 ) - 12.
  g_col_t = g_col + 108.
  g_row_t = g_row + 21.

  CALL SCREEN 500 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.
ENDFORM.                    " PERSONAL_SETTINGS
*&---------------------------------------------------------------------*
*&      Module  PBO_0500  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_0500 OUTPUT.
  SET PF-STATUS 'MAIN_0500'.

  LOOP AT SCREEN.
    IF screen-group1 EQ 'FTL'.
      IF NOT /cadaxo/sqlcusrp_dyn-hd_fieldname IS INITIAL.
        screen-input = 0.
      ELSE.
        screen-input = 1.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
  IF gd_adt_info_i IS INITIAL.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name       = icon_message_warning
        info       = space
        add_stdinf = space
      IMPORTING
        result     = gd_adt_info_i
      EXCEPTIONS
        OTHERS     = 1.
  ENDIF.

ENDMODULE.                 " PBO_0500  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0500  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0500 INPUT.
  CASE g_ok_code.
    WHEN 'CANCEL'.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN 'SAVE'.
      lcl_controller->set_user_settings( EXPORTING i_settings = /cadaxo/sqlcusrp_dyn ).
      lcl_controller->set_symbol_alv( ).
      SET SCREEN 0. LEAVE SCREEN.
  ENDCASE.
  CLEAR g_ok_code.
ENDMODULE.                 " PAI_0500  INPUT

*&---------------------------------------------------------------------*
*&      Module  PBO_2000  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_2000 OUTPUT.
  SET PF-STATUS 'MAIN_2000'.
  SET TITLEBAR '2000'.

  lcl_controller->pbo_2000( ).
ENDMODULE.                 " PBO_2000  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  PAI_2000  INPUT
*&---------------------------------------------------------------------*
MODULE pai_2000 INPUT.
  lcl_controller->pai_2000(
    EXPORTING
      i_ok_code = g_ok_code ).

  CLEAR g_ok_code.
ENDMODULE.                 " PAI_2000  INPUT

*&---------------------------------------------------------------------*
*&      Module  PBO_3000  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_3000 OUTPUT.
  SET PF-STATUS 'MAIN_3000'.
  SET TITLEBAR '3000'.

  lcl_controller->pbo_3000( ).
ENDMODULE.                 " PBO_2000  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  PAI_3000  INPUT
*&---------------------------------------------------------------------*
MODULE pai_3000 INPUT.
  lcl_controller->pai_3000( g_ok_code ).

  CLEAR g_ok_code.
ENDMODULE.                 " PAI_3000  INPUT




*&---------------------------------------------------------------------*
*&      Form  SHOW_API_QUEUE
*&---------------------------------------------------------------------*
*       Show the API Queue Popup
*----------------------------------------------------------------------*
FORM show_api_queue.

* calculate the dynpro positions
  g_col = ( sy-scols / 2 ) - 50.
  g_row = ( sy-srows / 2 ) - 8.
  g_col_t = g_col + 110.
  g_row_t = g_row + 15.

* call the template selection screen
  CALL SCREEN 3000 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SHARE_SQL_AREA
*&---------------------------------------------------------------------*
*       Show the API Queue Popup
*----------------------------------------------------------------------*
FORM share_sql_area
  USING iv_receiver TYPE /cadaxo/sqlcapi_receiver "+Cockpit-420
        iv_text     TYPE /CADAXO/SQLC_CHAR_1024. "+Cockpit-420
  DATA(lt_sql) = lcl_controller->get_sql_area_lt_code( ).                     "COCKPIT-295
  DATA l_message TYPE string.                                                 "COCKPIT-269
  DATA lr_exception             TYPE REF TO cx_root.                          "COCKPIT-269
  TRY.                                                                        "COCKPIT-269
      IF lt_sql IS INITIAL.                                                   "COCKPIT-269
        MESSAGE e103(/cadaxo/sqlc) INTO l_message.                            "COCKPIT-269
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error                     "COCKPIT-269
          EXPORTING                                                           "COCKPIT-269
            message       = l_message                                         "COCKPIT-269
            /cadaxo/msgid = '/CADAXO/SQLC'                                    "COCKPIT-269
            /cadaxo/msgnr = '103'.                                            "COCKPIT-269
      ELSE.                                                                   "COCKPIT-269
        CALL FUNCTION '/CADAXO/SQLC_SHARE'                                    "COCKPIT-295
          EXPORTING                                                           "COCKPIT-295
            iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-sql    "COCKPIT-295
            it_sql         = lt_sql                                          "COCKPIT-295
            iv_receiver    = iv_receiver                                      "Cockpit-420
            iv_text        = iv_text    .                                     "Cockpit-420
      ENDIF.                                                                  "COCKPIT-269
    CATCH /cadaxo/cx_sqlc_syntax_error INTO lr_exception.                     "COCKPIT-269
      l_message = lr_exception->get_text( ).                                  "COCKPIT-269
      IF l_message IS INITIAL.                                                "COCKPIT-269
        l_message = 'EXC!'.                                                   "COCKPIT-269
      ENDIF.                                                                  "COCKPIT-269
      lcl_controller->handle_msg_exception( EXPORTING i_msg = l_message       "COCKPIT-269
                                                      i_exception = lr_exception"COCKPIT-269
      ).                                                                      "COCKPIT-269
    CLEANUP.                                                                  "COCKPIT-269
  ENDTRY.                                                                     "COCKPIT-269

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GENERATE_TEMPLATE
*&---------------------------------------------------------------------*
*       Execute the wizard template generator
*----------------------------------------------------------------------*
FORM generate_template.

  DATA l_lines          TYPE i.
  DATA dref TYPE REF TO data.

  FIELD-SYMBOLS: <lr_cl_sql_parse> TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse,
*                 <lt_result_table> TYPE STANDARD TABLE, "COCKPIT-19
                 <lr_lvc_t_fcat>   TYPE lvc_t_fcat.

  TRY.

      DATA(lt_parser_before) = lcl_controller->gt_cl_sql_parse.                          "COCKPIT-168

      lcl_controller->check_sql_syntax( ).

* how many selects
      DESCRIBE TABLE lcl_controller->gt_cl_sql_parse LINES l_lines.
      IF l_lines > 1.
        MESSAGE e039(/cadaxo/sqlc).
      ENDIF.

      READ TABLE lcl_controller->gt_cl_sql_parse INDEX 1 ASSIGNING <lr_cl_sql_parse>.
      IF sy-subrc EQ 0.
***        IF <lr_cl_sql_parse>->g_select_version = <lr_cl_sql_parse>->c_select_version_2. "$003
***          MESSAGE e107(/cadaxo/sqlc).
***        ENDIF.

        IF <lr_cl_sql_parse>->g_select_version = <lr_cl_sql_parse>->c_select_version_1 OR
          <lr_cl_sql_parse>->g_select_version = <lr_cl_sql_parse>->c_select_version_0. "$003
          <lr_cl_sql_parse>->create_alv_field_catalog(
                              EXPORTING i_user_settings = lcl_controller->g_user_settings
                                        i_dragdrop_handle = lcl_controller->dragdrop_handle ).

* create result structures
          <lr_cl_sql_parse>->create_result_structures( ).

*          APPEND <lr_cl_sql_parse>->result_table TO lcl_controller->dref_result_tab_t.  "COCKPIT-19
*          ASSIGN <lr_cl_sql_parse>->result_table->* TO <lt_result_table>.               "COCKPIT-19

        ELSEIF <lr_cl_sql_parse>->g_select_version = <lr_cl_sql_parse>->c_select_version_2.
          IF <lr_cl_sql_parse>->gt_lvc_t_fcat IS INITIAL.                                "COCKPIT-168
            LOOP AT lt_parser_before ASSIGNING FIELD-SYMBOL(<ls_parser_before>).         "COCKPIT-168
              IF <ls_parser_before>->sql_syntax = <lr_cl_sql_parse>->sql_syntax.         "COCKPIT-168
                <lr_cl_sql_parse>->gt_lvc_t_fcat = <ls_parser_before>->gt_lvc_t_fcat.    "COCKPIT-168
                EXIT. "Loop                                                              "COCKPIT-168
              ENDIF.                                                                     "COCKPIT-168
            ENDLOOP.                                                                     "COCKPIT-168
          ENDIF.                                                                         "COCKPIT-168
          IF <lr_cl_sql_parse>->gt_lvc_t_fcat IS INITIAL.                                "COCKPIT-168
            MESSAGE e114(/cadaxo/sqlc).                                                  "COCKPIT-168
          ENDIF.                                                                         "COCKPIT-168

        ENDIF."$003


* calculate the dynpro positions
        g_col = ( sy-scols / 2 ) - 50.
        g_row = ( sy-srows / 2 ) - 6.
        g_col_t = g_col + 100.
        g_row_t = g_row + 12.

* call the template selection screen
        CALL SCREEN 2000 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

      ENDIF.

    CATCH /cadaxo/cx_sqlc_syntax_error /cadaxo/cx_sqlc_invalid_value.
  ENDTRY.

ENDFORM.                    " GENERATE_TEMPLATE
*&---------------------------------------------------------------------*
*&      Form  ADMIN_SETTINGS
*&---------------------------------------------------------------------*
FORM admin_settings .
  g_col = ( sy-scols / 2 ) - 55.
  g_row = 2.
  g_col_t = g_col + 110.
  g_row_t = g_row + 25.

  CALL SCREEN 900 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

ENDFORM.                    " ADMIN_SETTINGS
*&---------------------------------------------------------------------*
*&      Form  confirm_symbol_overwrite
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM confirm_symbol_overwrite.

  g_col = 10.
  g_row = ( sy-srows / 2 ) - 10.
  g_col_t = g_col + 119.
  g_row_t = g_row + 11.
* begin of change cockpit274
  IF g_col LT 1.
    g_col = 1.
  ENDIF.
  IF g_row LT 1.
    g_row = 1.
  ENDIF.
* end   of change cockpit274
  CALL SCREEN 700 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

ENDFORM.                    "confirm_symbol_overwrite
*----------------------------------------------------------------------*
*  MODULE pbo_0700 OUTPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE pbo_0700 OUTPUT.

  SET PF-STATUS 'MAIN_0700'.
  SET TITLEBAR '0700'.

  g_dynpro_text = text-q03.
  lcl_controller->pbo_0700(  ).
ENDMODULE.                    "pbo_0700 OUTPUT
*----------------------------------------------------------------------*
*  MODULE pai_0700 INPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE pai_0700 INPUT.

  lcl_controller->pai_0700(
    EXPORTING
      i_ok_code = g_ok_code ).

  CLEAR g_ok_code.
ENDMODULE.                    "pai_0700 INPUT
*&---------------------------------------------------------------------*
*&      Form  SAVE_LISTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_lists .

  DATA lt_saved_lists TYPE /cadaxo/sqlcsresalv_t.
  DATA l_free_space_kb TYPE int4.

* Check if max_space_kb is not exceeded
* get saved lists
  /cadaxo/cl_sqlc_cockpit_lists=>get_saved_lists( EXPORTING i_uname = sy-uname
                                                  IMPORTING e_saved_lists = lt_saved_lists
                                                            e_free_space_kb = l_free_space_kb ).
* get maxspace
  /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = gs_adm_cust ).

  IF gs_adm_cust-maxspace GT 0 AND l_free_space_kb LT 0.
    MESSAGE e083(/cadaxo/sqlc) WITH gs_adm_cust-maxspace.
  ENDIF.

  g_col = ( sy-scols / 2 ) - 30.
  g_row = ( sy-srows / 2 ) - 3.
  g_col_t = g_col + 60.
  g_row_t = g_row + 3.

  CLEAR g_sqlcsres.

  CALL SCREEN 800 STARTING AT g_col g_row ENDING AT g_col_t g_row_t.

ENDFORM.                    " SAVE_LISTS
*&---------------------------------------------------------------------*
*&      Module  PBO_0800  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0800 OUTPUT.

  SET PF-STATUS 'MAIN_0800'.
  SET TITLEBAR '0800'.

  lcl_controller->pbo_0800( ).

ENDMODULE.                 " PBO_0800  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0800  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0800 INPUT.

  lcl_controller->pai_0800(
    EXPORTING
      i_ok_code = g_ok_code
      i_sqlcsres = g_sqlcsres ).

  CLEAR g_ok_code.

ENDMODULE.                 " PAI_0800  INPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0900  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0900 OUTPUT.

  DATA l_icon TYPE string.

  FIELD-SYMBOLS: <ls_tabstrip>.

  SET PF-STATUS 'MAIN_0900' .
  SET TITLEBAR '0900'.
  IF admintab-activetab IS INITIAL.
    MOVE 'MAIN' TO admintab-activetab.
  ENDIF.

  SELECT * FROM /cadaxo/sqlcadoc INTO TABLE gt_sqlcadoc WHERE delivery = space ORDER BY addon.
  SELECT * FROM /cadaxo/sqlcadot INTO TABLE gt_sqlcadot WHERE language = sy-langu ORDER BY addon.

  LOOP AT gt_sqlcadoc INTO g_sqlcadoc.

    CASE sy-tabix.
      WHEN 1.
        ASSIGN g_tabstrip_tab4 TO <ls_tabstrip>.
      WHEN 2.
        ASSIGN g_tabstrip_tab5 TO <ls_tabstrip>.
      WHEN 3.
        ASSIGN g_tabstrip_tab6 TO <ls_tabstrip>.
      WHEN 4.
        ASSIGN g_tabstrip_tab7 TO <ls_tabstrip>.
    ENDCASE.

    READ TABLE gt_sqlcadot WITH KEY addon = g_sqlcadoc-addon INTO g_sqlcadot.
    IF sy-subrc EQ 0.
      MOVE g_sqlcadot-addon_desc TO g_tabstrip_tab4.
    ELSE.
      MOVE g_sqlcadoc-addon TO g_tabstrip_tab4.
    ENDIF.

    IF g_sqlcadoc-active IS INITIAL.
      MOVE 'ICON_LED_RED' TO l_icon.
    ELSE.
      MOVE 'ICON_LED_GREEN'  TO l_icon.
    ENDIF.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = l_icon
        text   = g_tabstrip_tab4
      IMPORTING
        result = g_tabstrip_tab4.

  ENDLOOP.

  CASE admintab-activetab.
    WHEN 'MAIN'.
      MOVE sy-repid TO g_report.
      MOVE '0910' TO g_subscreen.
    WHEN 'ROLES'.
      MOVE sy-repid TO g_report.
      MOVE '0920' TO g_subscreen.
    WHEN 'LOGS'.
      MOVE sy-repid TO g_report.
      MOVE '0930' TO g_subscreen.
    WHEN 'TAB4'.
      READ TABLE gt_sqlcadoc INDEX 1 INTO g_sqlcadoc.
      IF sy-subrc EQ 0.
        MOVE g_sqlcadoc-cust_dynpro TO g_subscreen.
        MOVE g_sqlcadoc-cust_report TO g_report.
      ENDIF.
    WHEN 'TAB5'.
      READ TABLE gt_sqlcadoc INDEX 2 INTO g_sqlcadoc.
      IF sy-subrc EQ 0.
        MOVE g_sqlcadoc-cust_dynpro TO g_subscreen.
        MOVE g_sqlcadoc-cust_report TO g_report.
      ENDIF.
    WHEN 'TAB6'.
      READ TABLE gt_sqlcadoc INDEX 3 INTO g_sqlcadoc.
      IF sy-subrc EQ 0.
        MOVE g_sqlcadoc-cust_dynpro TO g_subscreen.
        MOVE g_sqlcadoc-cust_report TO g_report.
      ENDIF.
    WHEN 'TAB7'.
      READ TABLE gt_sqlcadoc INDEX 4 INTO g_sqlcadoc.
      IF sy-subrc EQ 0.
        MOVE g_sqlcadoc-cust_dynpro TO g_subscreen.
        MOVE g_sqlcadoc-cust_report TO g_report.
      ENDIF.
    WHEN 'TAB8'.
      READ TABLE gt_sqlcadoc INDEX 5 INTO g_sqlcadoc.
      IF sy-subrc EQ 0.
        MOVE g_sqlcadoc-cust_dynpro TO g_subscreen.
        MOVE g_sqlcadoc-cust_report TO g_report.
      ENDIF.
  ENDCASE.
ENDMODULE.                 " PBO_0900  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0900  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0900 INPUT.
  CASE g_ok_code.
    WHEN 'MAIN'.
      admintab-activetab = 'MAIN'.
    WHEN 'ROLES'.
      admintab-activetab = 'ROLES'.
    WHEN 'LOGS'.
      admintab-activetab = 'LOGS'.
    WHEN 'TAB4'.
      admintab-activetab = 'TAB4'.
    WHEN 'TAB5'.
      admintab-activetab = 'TAB5'.
    WHEN 'TAB6'.
      admintab-activetab = 'TAB6'.
    WHEN 'TAB7'.
      admintab-activetab = 'TAB7'.
    WHEN 'TAB8'.
      admintab-activetab = 'TAB8'.

    WHEN 'OK' OR 'CANC' OR 'BACK'.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.

  lcl_controller->pai_0100( EXPORTING i_ok_code = g_ok_code ).

  CLEAR g_ok_code.

ENDMODULE.                 " PAI_0900  INPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0910  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0910 OUTPUT.
  DATA ls_lvc_s_styl       TYPE lvc_s_styl.

  FIELD-SYMBOLS: <ls_addons_fieldcat>  TYPE lvc_s_fcat,
                 <ls_installed_addons> LIKE LINE OF gt_installed_addons.

* get installed addons
  PERFORM get_installed_addons.

  IF g_addons_cust_cont IS INITIAL.

    gs_addons_layout-no_toolbar = 'X'.
    gs_addons_layout-stylefname = 'CT'.

* build fieldcatalog
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = '/CADAXO/SQLCADDONS_INSTALLED'
      CHANGING
        ct_fieldcat      = gt_addons_fieldcat.

    LOOP AT gt_addons_fieldcat ASSIGNING <ls_addons_fieldcat>.
      CASE <ls_addons_fieldcat>-fieldname.
        WHEN 'ACTIVE'.
          <ls_addons_fieldcat>-no_out = 'X'.
        WHEN 'ACTIVE_BUTTON'.
          <ls_addons_fieldcat>-outputlen = 15.
        WHEN 'ADDON_RELEASE'.
          <ls_addons_fieldcat>-outputlen = 10.
        WHEN 'ADDON_DESC'.
          <ls_addons_fieldcat>-outputlen = 45.
      ENDCASE.
    ENDLOOP.

    CREATE OBJECT g_addons_cust_cont
      EXPORTING
        container_name = 'G_ADDONS_CUST_CONT'.

    CREATE OBJECT g_addons_grid
      EXPORTING
        i_parent = g_addons_cust_cont.

    CALL METHOD g_addons_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = '/CADAXO/SQLCADDONS_INSTALLED'
        is_layout        = gs_addons_layout
      CHANGING
        it_outtab        = gt_installed_addons
        it_fieldcatalog  = gt_addons_fieldcat.

    SET HANDLER glcl_event_handler->on_addons_alv_click FOR g_addons_grid.

  ELSE.

    CALL METHOD g_addons_grid->refresh_table_display.

  ENDIF.

  LOOP AT SCREEN.
    IF g_adm = 'X' AND screen-group1 = 'ADM'.
      screen-invisible = '0'.
      screen-active    = '1'.
    ELSEIF screen-group1 = 'ADM'.
      screen-invisible = '1'.
      screen-active    = '0'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

* get admin customizing
  /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = gs_adm_cust ).

  gd_home_link  = abap_true.
  gd_home_local = abap_false.

  gs_adm_cust-show_element_info = abap_true.

* max selects
  IF gs_adm_cust-maxsel IS INITIAL.
    gs_adm_cust-maxsel = 99.                         "COCKPIT-194
  ENDIF.

ENHANCEMENT-SECTION /cadaxo/sqlc_ehn_s_cls_se_005 SPOTS /cadaxo/sqlc_ehnsp_cls_se_002 .
  LOOP AT SCREEN.
    IF screen-group1 = 'CLS'.
      screen-invisible = '1'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
END-ENHANCEMENT-SECTION.


ENDMODULE.                 " PBO_0910  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0910  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0910 INPUT.

  CASE g_ok_code.
    WHEN 'OK' OR 'ENT'.

*      IF gs_adm_cust-maxsel GE 1 AND gs_adm_cust-maxsel LE 30.   "COCKPIT-194
*        IF gs_adm_cust-maxsel GT 16.                             "COCKPIT-194
*          MESSAGE i087(/cadaxo/sqlc).                            "COCKPIT-194
*        ENDIF.                                                   "COCKPIT-194
*      ELSE.                                                      "COCKPIT-194
*        MESSAGE i088(/cadaxo/sqlc).                              "COCKPIT-194
*      ENDIF.                                                     "COCKPIT-194

      CASE 'X'.
        WHEN gd_home_link.
          gs_adm_cust-home_use_link = abap_true.
        WHEN gd_home_local.
          gs_adm_cust-home_use_link = abap_false.
      ENDCASE.

      gs_adm_cust-show_element_info = abap_true.

      /cadaxo/cl_sqlc_cockpit_assist=>set_adm_customizing( i_customizing = gs_adm_cust ).

  ENDCASE.

ENDMODULE.                 " PAI_0910  INPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0920  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_0920 OUTPUT.
ENDMODULE.                 " PBO_0920  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0920  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0920 INPUT.
ENDMODULE.                 " PAI_0920  INPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0930  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_0930 OUTPUT.
ENDMODULE.                 " PBO_0930  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0930  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0930 INPUT.
ENDMODULE.                 " PAI_0930  INPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0940  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_0940 OUTPUT.
ENDMODULE.                 " PBO_0940  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0940  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0940 INPUT.
ENDMODULE.                 " PAI_0940  INPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0950  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_0950 OUTPUT.
ENDMODULE.                 " PBO_0950  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0950  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0950 INPUT.
ENDMODULE.                 " PAI_0950  INPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0960  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_0960 OUTPUT.
ENDMODULE.                 " PBO_0960  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0960  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0960 INPUT.
ENDMODULE.                 " PAI_0960  INPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0970  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_0970 OUTPUT.
ENDMODULE.                 " PBO_0970  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0970  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0970 INPUT.
ENDMODULE.                 " PAI_0970  INPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0980  OUTPUT
*&---------------------------------------------------------------------*
MODULE pbo_0980 OUTPUT.
ENDMODULE.                 " PBO_0980  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0980  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0980 INPUT.
ENDMODULE.                 " PAI_0980  INPUT
*&---------------------------------------------------------------------*
*&      Module  HIDE_TAB  OUTPUT
*&---------------------------------------------------------------------*
*       Define which Tabs in the new Adminscreen (900) are visible
*----------------------------------------------------------------------*
MODULE hide_tab OUTPUT.
  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'G_TABSTRIP_TAB4'.
        READ TABLE gt_sqlcadoc INDEX 1 TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          screen-active = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.
        ENDIF.
      WHEN 'G_TABSTRIP_TAB5'.
        READ TABLE gt_sqlcadoc INDEX 2 TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          screen-active = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.
        ENDIF.
      WHEN 'G_TABSTRIP_TAB6'.
        READ TABLE gt_sqlcadoc INDEX 3 TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          screen-active = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.
        ENDIF.
      WHEN 'G_TABSTRIP_TAB7'.
        READ TABLE gt_sqlcadoc INDEX 4 TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          screen-active = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.
        ENDIF.
      WHEN 'G_TABSTRIP_TAB8'.
        READ TABLE gt_sqlcadoc INDEX 5 TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          screen-active = '0'.
          screen-invisible = '1'.
          MODIFY SCREEN.
        ENDIF.
    ENDCASE.
  ENDLOOP.
ENDMODULE.                 " HIDE_TAB  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  GET_INSTALLED_ADDONS
*&---------------------------------------------------------------------*
FORM get_installed_addons.

* get addons from database
  CLEAR gt_installed_addons.

  SELECT a~addon
         a~addon_release
         a~active
         b~addon_desc
         FROM /cadaxo/sqlcadoc AS a
         LEFT OUTER JOIN /cadaxo/sqlcadot AS b
         ON b~addon = a~addon
         AND b~language = sy-langu
         INTO CORRESPONDING FIELDS OF TABLE gt_installed_addons
         WHERE delivery = space.

  LOOP AT gt_installed_addons ASSIGNING <ls_installed_addons>.
    IF <ls_installed_addons>-active IS INITIAL.
      MOVE icon_led_red TO <ls_installed_addons>-active_button.
    ELSE.
      MOVE icon_led_green TO <ls_installed_addons>-active_button.
    ENDIF.
    ls_lvc_s_styl-fieldname = 'ACTIVE_BUTTON'.
    ls_lvc_s_styl-style     = cl_gui_alv_grid=>mc_style_button.
    APPEND ls_lvc_s_styl TO <ls_installed_addons>-ct.
  ENDLOOP.

ENDFORM.                    " GET_INSTALLED_ADDONS
*&---------------------------------------------------------------------*
*&      Module  HELP_RECEIVER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE help_receiver INPUT.

  DATA lt_dynpfields TYPE TABLE OF dynpread.
  DATA lt_return TYPE TABLE OF ddshretval.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'UNAME'
      value_org       = 'S'
    TABLES
      value_tab       = gt_sql_cockpit_standard_users
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
    APPEND INITIAL LINE TO lt_dynpfields ASSIGNING FIELD-SYMBOL(<ls_dynpfields>).
    <ls_dynpfields>-fieldname  = 'G_RECEIVER'.
    <ls_dynpfields>-fieldvalue = <ls_return>-fieldval.
  ENDLOOP.

  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname     = '/CADAXO/SQLC_MAIN'
      dynumb     = '3001'
    TABLES
      dynpfields = lt_dynpfields
    EXCEPTIONS
      OTHERS     = 0.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_RECEIVER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_receiver INPUT.

  READ TABLE gt_sql_cockpit_standard_users TRANSPORTING NO FIELDS WITH KEY uname = g_receiver.
  IF sy-subrc <> 0.
    MESSAGE e125(/cadaxo/sqlc) WITH g_receiver.
  ENDIF.

ENDMODULE.
