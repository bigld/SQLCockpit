****************************************************************************************************
* Description             : SQL Cockpit - Authorizations                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃ¶ÃŸleitner        Company    : CADAXO GesmbH                    *
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
* 06.07.14   | Harald Wiesinger     | set role as default                         | CDX22-013,RT31 *
*------------+----------------------+---------------------------------------------+----------------*
* 03.07.2017 | Domi Bigl            | redesign log entries                        | COCKPIT-213    *
*------------+----------------------+---------------------------------------------+----------------*
* 11.07.2017 | Harald Wiesinger     | user was able to assign not existing roles  | COCKPIT-226    *
*------------+----------------------+---------------------------------------------+----------------*
* 31.08.2017 | Domi Bigl            | Search USer; Cleanup                        | COCKPIT-248    *
*------------+----------------------+---------------------------------------------+----------------*
* 31.08.2017 | Domi Bigl            | Refuser                                     | COCKPIT-172    *
****************************************************************************************************

REPORT  /cadaxo/sqlc_authorization.

**********************************************************************
* Types
**********************************************************************
TYPES: item_table_type TYPE STANDARD TABLE OF mtreeitm WITH DEFAULT KEY.
TYPES: BEGIN OF gts_role.
         INCLUDE TYPE /cadaxo/sqlcrole.
TYPES:   node_key TYPE mtreesnode-node_key,
       END OF gts_role.

TYPES: BEGIN OF gts_rolr.
         INCLUDE TYPE /cadaxo/sqlcrolr.
TYPES:
         node_key TYPE mtreesnode-node_key,
       END OF gts_rolr.

*----------------------------------------------------------------------*
*       CLASS lcl_application DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_application DEFINITION DEFERRED.
TYPES: BEGIN OF gts_control,
         tab             TYPE syucomm,
         gui_data        TYPE /cadaxo/sqlcroled_tab_uim_t,
         auth_table_name TYPE fieldname,
         auth_table      TYPE REF TO /cadaxo/sqlcroletab_t,
         alv             TYPE REF TO cl_gui_alv_grid,
         alv_prot        TYPE REF TO cl_alv_changed_data_protocol,
         handler         TYPE REF TO lcl_application,
       END OF gts_control.

**********************************************************************
* Constants
**********************************************************************
CONSTANTS: BEGIN OF c_tabs,
             tab1 TYPE syucomm VALUE 'TABS_FC1',
             tab2 TYPE syucomm VALUE 'TABS_FC2',
           END OF c_tabs.
CONSTANTS: c_mode_upd(3)               TYPE c VALUE 'UPD'.
CONSTANTS: c_mode_dis(3)               TYPE c VALUE 'DIS'.
CONSTANTS: c_mode_new(3)               TYPE c VALUE 'NEW'.
CONSTANTS: c_false                     TYPE c VALUE space.
CONSTANTS: c_true                      TYPE c VALUE 'X'.
CONSTANTS: BEGIN OF c_column,
             col1 TYPE tv_itmname VALUE 'KEY',              "#EC NOTEXT
             col2 TYPE tv_itmname VALUE 'DES',              "#EC NOTEXT
           END OF c_column.
CONSTANTS: c_object                   TYPE /cadaxo/sqlc_ulog_object VALUE 'COCKPIT'.
CONSTANTS: c_object_key               TYPE /cadaxo/sqlc_ulgo_object_key VALUE 'SQLC_ROLE'.
CONSTANTS: BEGIN OF cs_nodekey,       "COCKPIT-248
             root     TYPE tv_nodekey VALUE 'ROOT'     ##NO_TEXT,
             role     TYPE tv_nodekey VALUE 'ROLE'     ##NO_TEXT,
             employee TYPE tv_nodekey VALUE 'EMPLOYEE' ##NO_TEXT,
             delete   TYPE tv_nodekey VALUE 'DETELE'   ##NO_TEXT,
           END OF cs_nodekey.

**********************************************************************
* Controls
**********************************************************************
CONTROLS: gd_tabs                      TYPE TABSTRIP.
DATA: tabs_tab1                        TYPE char25.
DATA: tabs_tab2                        TYPE char25.

**********************************************************************
* References
**********************************************************************
DATA: gr_drag_behaviour                TYPE REF TO cl_dragdrop.
DATA: gr_drop_behaviour                TYPE REF TO cl_dragdrop.
DATA: gr_drdr_behaviour                TYPE REF TO cl_dragdrop.
DATA: gr_docking_container             TYPE REF TO cl_gui_docking_container.
DATA: gr_tree                          TYPE REF TO cl_gui_column_tree.
DATA: gr_main_container                TYPE REF TO cl_gui_custom_container.
DATA: gr_splitter_container            TYPE REF TO cl_gui_splitter_container.
DATA: gr_alv_container                 TYPE REF TO cl_gui_simple_container.
DATA: gr_messages                      TYPE REF TO cl_gui_simple_container.
DATA lr_log                            TYPE REF TO /cadaxo/cl_sqlc_user_log.

**********************************************************************
* Tables
**********************************************************************
DATA: gt_events                        TYPE cntl_simple_events.
DATA: gt_node_table                    TYPE treev_ntab.
DATA: gt_item_table                    TYPE item_table_type.
DATA: gt_role                          TYPE TABLE OF gts_role.
DATA: gt_rolu                          TYPE TABLE OF /cadaxo/sqlcrolu.
DATA: gt_rolr                          TYPE TABLE OF gts_rolr.
DATA: gt_controls                      TYPE TABLE OF gts_control.
DATA: gtd_exallfcodes                  TYPE TABLE OF sy-ucomm.
DATA: gtd_exfcodes                     TYPE TABLE OF sy-ucomm.
DATA: gt_log                           TYPE /cadaxo/sqlculog_api_t.

**********************************************************************
* Workareas
**********************************************************************
DATA: BEGIN OF gwa_tabs,
        subscreen      TYPE sydynnr VALUE 110,
        prog           TYPE syrepid VALUE '/CADAXO/SQLC_AUTHORIZATION',
        pressed_tab    TYPE syucomm VALUE c_tabs-tab1,
        container_name TYPE char20  VALUE 'GC_TABLE',
        auth_tab_name  TYPE fieldname,
      END OF gwa_tabs.

DATA: wa_event                         TYPE cntl_simple_event.
DATA: wa_auth                          TYPE /cadaxo/sqlcrole_auth_xml.
DATA: wa_sqlcrole                      TYPE /cadaxo/sqlcrole.
DATA: BEGIN OF wa_node_key,
        object(2)  TYPE c,
        number(10) TYPE n,
      END OF wa_node_key.
DATA: wa_rolu                          LIKE LINE OF gt_rolu.
DATA: wa_tree_header                   TYPE treev_hhdr.
DATA: BEGIN OF gs_user_search,  "COCKPIT-248
        uname TYPE string,
        name  TYPE string,
      END OF gs_user_search.

**********************************************************************
* Fields
**********************************************************************
DATA: g_ok_code                        TYPE syucomm.
DATA: g_mode(3)                        TYPE c VALUE c_mode_dis.
DATA: g_rc(1)                          TYPE c.
DATA: g_data_changed                   TYPE flag.
DATA: g_handle_drag                    TYPE i.
DATA: g_handle_drop                    TYPE i.
DATA: g_handle_drdr                    TYPE i.
DATA: g_mtext                          TYPE mtext_d.

**********************************************************************
* Fieldsymbols
**********************************************************************
FIELD-SYMBOLS: <wa_table_ui>           TYPE /cadaxo/sqlcroled_tab_uim.
FIELD-SYMBOLS: <wa_node>               TYPE treev_node.
FIELD-SYMBOLS: <wa_item>               TYPE mtreeitm.
FIELD-SYMBOLS: <wa_role>               LIKE LINE OF gt_role.
FIELD-SYMBOLS: <wa_rolu>               LIKE LINE OF gt_rolu.
FIELD-SYMBOLS: <wa_rolr>               LIKE LINE OF gt_rolr.
FIELD-SYMBOLS: <wa_controls>           TYPE gts_control.
FIELD-SYMBOLS: <gt_auth_table>         TYPE /cadaxo/sqlcroletab_t.
FIELD-SYMBOLS: <gs_log>                TYPE /cadaxo/sqlculog_api.

*----------------------------------------------------------------------*
*       CLASS LCL_APPLICATION DEFINITION
*----------------------------------------------------------------------*

CLASS lcl_application DEFINITION.
  PUBLIC SECTION.

    METHODS: constructor
      IMPORTING i_initiator TYPE syucomm,
      handle_node_double_click
        FOR EVENT node_double_click
        OF cl_gui_column_tree
        IMPORTING node_key,
      handle_item_double_click
        FOR EVENT item_double_click
        OF cl_gui_column_tree
        IMPORTING node_key,
      handle_node_context_menu_req
        FOR EVENT node_context_menu_request
        OF cl_gui_column_tree
        IMPORTING node_key menu,
      handle_item_context_menu_req
        FOR EVENT item_context_menu_request
        OF cl_gui_column_tree
        IMPORTING node_key menu,
      handle_node_context_menu_sel
        FOR EVENT node_context_menu_select
        OF cl_gui_column_tree
        IMPORTING node_key fcode,
      handle_item_context_menu_sel
        FOR EVENT item_context_menu_select
        OF cl_gui_column_tree
        IMPORTING node_key fcode,
      flavor_select
        FOR EVENT on_drop_get_flavor
        OF cl_gui_column_tree
        IMPORTING node_key drag_drop_object,                "#EC NEEDED
      on_drag
        FOR EVENT on_drag
        OF cl_gui_column_tree
        IMPORTING node_key drag_drop_object,
      on_drop
        FOR EVENT on_drop
        OF cl_gui_column_tree
        IMPORTING node_key drag_drop_object,
      on_drop_complete
        FOR EVENT on_drop_complete
        OF cl_gui_column_tree
        IMPORTING node_key drag_drop_object,                "#EC NEEDED
      on_data_changed
        FOR EVENT data_changed
        OF cl_gui_alv_grid
        IMPORTING er_data_changed e_onf4 e_onf4_before e_onf4_after e_ucomm, "#EC NEEDED
      on_data_changed_finished
        FOR EVENT data_changed_finished
        OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells,                 "#EC NEEDED
      set_cleanup_errors
        IMPORTING i_cleanup TYPE c,
      on_link_click
        FOR EVENT link_click
        OF cl_gui_column_tree
        IMPORTING node_key item_name.
  PROTECTED SECTION.
    DATA: wa_rolr_db TYPE /cadaxo/sqlcrolr.
    DATA: g_disabled_deldef(1) TYPE c.
    DATA: g_disabled_setdef(1) TYPE c.
    DATA: g_also_ins_or_del    TYPE c.
    DATA: g_initiator          TYPE syucomm.
    DATA: g_cleanup_errors     TYPE c.
    METHODS:
      add_role_to_user IMPORTING i_role TYPE any
                                 i_user TYPE uname,
      remove_role_from_user IMPORTING node_key TYPE mtreesnode-node_key,
      remove_user IMPORTING node_key TYPE mtreesnode-node_key,
      delete_role IMPORTING node_key TYPE mtreesnode-node_key
                            i_type   TYPE symsgty,
      append_to_gt_log
        IMPORTING
          i_tabname TYPE tabname.
ENDCLASS.                    "LCL_APPLICATION DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_drag_object DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_drag_object DEFINITION.
  PUBLIC SECTION.
    DATA node_key TYPE STANDARD TABLE OF mtreesnode-node_key.
ENDCLASS.                    "lcl_drag_object DEFINITION


*----------------------------------------------------------------------*
*       CLASS LCL_APPLICATION IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_application IMPLEMENTATION.

  METHOD constructor.
    g_initiator = i_initiator.
  ENDMETHOD.                    "constructor
  METHOD  handle_node_double_click.

    DATA: l_cancel TYPE c.

    PERFORM check_save CHANGING l_cancel.
    IF l_cancel = c_true.
      RETURN.
    ENDIF.

    READ TABLE gt_role WITH KEY node_key = node_key ASSIGNING <wa_role>.
    IF sy-subrc EQ 0 AND <wa_role>-role <> wa_sqlcrole-role.

      CLEAR wa_auth.

      CALL TRANSFORMATION id
            SOURCE XML <wa_role>-auth_xml
            RESULT auth = wa_auth.

      PERFORM fill_auth_data.

      IF NOT wa_sqlcrole-role IS INITIAL.
        PERFORM dequeue USING wa_sqlcrole-role.
      ENDIF.
      CLEAR wa_sqlcrole.
      MOVE-CORRESPONDING <wa_role> TO wa_sqlcrole.
      PERFORM enqueue USING   wa_sqlcrole-role
                              c_true
                     CHANGING sy-subrc.

      IF sy-subrc EQ 0.
        g_mode = c_mode_upd.
      ELSE.
        g_mode = c_mode_dis.
      ENDIF.

    ENDIF.
  ENDMETHOD.                    "HANDLE_NODE_DOUBLE_CLICK
  METHOD  handle_item_double_click.
    handle_node_double_click( node_key = node_key ).
  ENDMETHOD.                    "handle_item_double_click
  METHOD handle_node_context_menu_req.
    CASE node_key.
      WHEN cs_nodekey-root.
      WHEN cs_nodekey-delete.
      WHEN cs_nodekey-employee.
        menu->add_function( EXPORTING text  = TEXT-007
                                      fcode = 'ADDUSER' ).
      WHEN cs_nodekey-role.
        menu->add_function( EXPORTING text  = TEXT-008
                                      fcode = 'CRROLE' ).
      WHEN OTHERS.
        IF node_key(2) EQ 'RL'.

          READ TABLE gt_role WITH KEY node_key = node_key ASSIGNING <wa_role>.
          IF sy-subrc EQ 0.
            IF <wa_role>-role_default IS INITIAL.
              g_disabled_deldef = abap_true.
              g_disabled_setdef = space.
            ELSE.
              g_disabled_setdef = abap_true.
              g_disabled_deldef = space.
            ENDIF.

            menu->add_function( EXPORTING text     = TEXT-003
                                          disabled = g_disabled_setdef
                                          fcode    = 'SETDEF' ).

            menu->add_function( EXPORTING text     = TEXT-004
                                          disabled = g_disabled_deldef
                                          fcode    = 'DELDEF' ).

            menu->add_separator( ).

            IF <wa_role>-role_default IS INITIAL.
              menu->add_function( EXPORTING text  = TEXT-001
                                            fcode = 'DELETE' ).
            ELSE.
              menu->add_function( EXPORTING text     = TEXT-001
                                            disabled = 'X'
                                            fcode    = 'DELETE' ).
            ENDIF.
            menu->add_separator( ).
            menu->add_function(  EXPORTING text  = TEXT-002
                                           fcode = 'TRANSPORT' ).
          ENDIF.
        ELSEIF node_key(2) EQ 'RU'.
          menu->add_function( EXPORTING text  = TEXT-011
                                        fcode = 'REMOVEROLE' ).
        ELSE.
          menu->add_function( EXPORTING text  = TEXT-012
                                        fcode = 'ADDROLETOUSER' ).
          menu->add_separator( ).
          menu->add_function( EXPORTING text  = TEXT-010
                                        fcode = 'REMOVEUSER' ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.                    "handle_node_context_menu_req
  METHOD handle_item_context_menu_req.

    handle_node_context_menu_req( menu = menu node_key = node_key ).

  ENDMETHOD.                    "handle_item_context_menu_req
  METHOD handle_node_context_menu_sel.

    DATA: lt_fields           TYPE TABLE OF sval.
    DATA: ls_fields           TYPE sval.
    DATA: l_return(1)         TYPE c.                       "#EC NEEDED
    DATA: l_rc                TYPE i.

    DATA lr_log            TYPE REF TO /cadaxo/cl_sqlc_user_log.
    DATA ls_log            TYPE /cadaxo/sqlculog_api.

    FIELD-SYMBOLS: <lwa_role> LIKE LINE OF gt_role.

    CASE fcode.
      WHEN 'ADDROLETOUSER'.

        CLEAR: ls_fields,
        lt_fields.

        ls_fields-tabname = '/CADAXO/SQLCROLE'.
        ls_fields-fieldname = 'ROLE'.
        ls_fields-fieldtext = TEXT-005.

        APPEND ls_fields TO lt_fields.

        CALL FUNCTION 'POPUP_GET_VALUES'
          EXPORTING
            popup_title     = TEXT-t05
          IMPORTING
            returncode      = l_return
          TABLES
            fields          = lt_fields
          EXCEPTIONS
            error_in_fields = 1
            OTHERS          = 2.
        IF sy-subrc EQ 0.
          IF l_return = 'A'.
            MESSAGE s042(/cadaxo/sqlc).
*   Canceled by user
          ELSE.
            READ TABLE lt_fields INDEX 1 INTO ls_fields.
            IF sy-subrc EQ 0 AND NOT ls_fields-value IS INITIAL.
              IF line_exists( gt_role[ role = ls_fields-value ] ).  "COCKPIT-226
                add_role_to_user( i_user = node_key
                                  i_role = ls_fields-value ).
              ELSE.                                                 "COCKPIT-226
                MESSAGE e119(/cadaxo/sqlc) WITH ls_fields-value.    "COCKPIT-226
              ENDIF.                                                "COCKPIT-226
            ENDIF.
          ENDIF.
        ENDIF.

      WHEN 'REMOVEROLE'.
        remove_role_from_user( node_key = node_key ).
      WHEN 'REMOVEUSER'.
        remove_user( node_key = node_key ).
      WHEN 'CRROLE'.
        PERFORM role_create.
      WHEN 'ADDUSER'.
        PERFORM adduser.


      WHEN 'SETDEF'.
        READ TABLE gt_role WITH KEY node_key = node_key ASSIGNING <wa_role>.
        IF sy-subrc EQ 0.
          PERFORM enqueue USING <wa_role>-role c_true CHANGING l_rc.
          IF l_rc = 0.
            READ TABLE gt_role WITH KEY role_default = c_true ASSIGNING <lwa_role>.
            IF sy-subrc = 0.
              <lwa_role>-role_default = c_false.
            ENDIF.
            <wa_role>-role_default = c_true.
            UPDATE /cadaxo/sqlcrole SET role_default = c_false WHERE role_default NE space.
            UPDATE /cadaxo/sqlcrole SET role_default = c_true  WHERE role = <wa_role>-role.
            PERFORM build_role_tree.
            IF wa_sqlcrole-role <> <wa_role>-role.
              PERFORM dequeue USING <wa_role>-role.
            ENDIF.
          ENDIF.
        ENDIF.
      WHEN 'DELDEF'.
        READ TABLE gt_role WITH KEY node_key = node_key role_default = c_true ASSIGNING <wa_role>.
        IF sy-subrc EQ 0.
          PERFORM enqueue USING <wa_role>-role c_true CHANGING l_rc.
          IF l_rc = 0.
            UPDATE /cadaxo/sqlcrole SET role_default = c_false WHERE role = <wa_role>-role.
            <wa_role>-role_default = c_false.
            PERFORM build_role_tree.
            IF wa_sqlcrole-role <> <wa_role>-role.
              PERFORM dequeue USING <wa_role>-role.
            ENDIF.
          ENDIF.
        ENDIF.
      WHEN 'DELETE'.
        delete_role( node_key = node_key i_type = 'E').
      WHEN 'TRANSPORT'.
        READ TABLE gt_role WITH KEY node_key = node_key ASSIGNING <wa_role>.
        IF sy-subrc EQ 0.
          PERFORM transport USING <wa_role>-role.
        ENDIF.
    ENDCASE.
  ENDMETHOD.                    "handle_node_context_menu_sel
  METHOD handle_item_context_menu_sel.

    handle_node_context_menu_sel( node_key = node_key fcode = fcode ).

  ENDMETHOD.                    "handle_item_context_menu_sel
  METHOD flavor_select.                                     "#EC NEEDED
  ENDMETHOD.                    "flavor_select
  METHOD on_drag.

    DATA: lr_drag_object TYPE REF TO lcl_drag_object.

    CREATE OBJECT lr_drag_object.

    APPEND node_key TO lr_drag_object->node_key.

    drag_drop_object->object = lr_drag_object.

  ENDMETHOD.                    "on_drag

  METHOD on_drop.
    DATA: lr_drag_object TYPE REF TO lcl_drag_object.
    DATA: l_node_key     TYPE node_str-node_key.

    lr_drag_object ?= drag_drop_object->object.
    LOOP AT lr_drag_object->node_key INTO l_node_key.
      IF node_key = cs_nodekey-delete.
        delete_role( node_key = l_node_key i_type = 'S' ).
        remove_role_from_user( node_key = l_node_key ).
        remove_user( node_key = l_node_key ).
      ELSE.
        READ TABLE gt_role WITH KEY node_key = l_node_key ASSIGNING <wa_role>.
        IF sy-subrc EQ 0.
          add_role_to_user( i_role = <wa_role>-role
                            i_user = node_key ).
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.                    "on_drop
  METHOD on_drop_complete.                                  "#EC NEEDED

  ENDMETHOD.                    "on_drop_complete
  METHOD on_link_click.                                     "#EC NEEDED

    IF node_key = cs_nodekey-employee AND item_name = 'DES'.

      cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'SEARCHUSER' ).

    ENDIF.

  ENDMETHOD.
  METHOD add_role_to_user.

    DATA lr_log            TYPE REF TO /cadaxo/cl_sqlc_user_log.
    DATA ls_log            TYPE /cadaxo/sqlculog_api.

    READ TABLE gt_rolr ASSIGNING <wa_rolr> WITH KEY uname = i_user  role = i_role.
    IF sy-subrc NE 0.
      CLEAR: wa_rolr_db.
      MOVE: i_user         TO wa_rolr_db-uname,
      i_role         TO wa_rolr_db-role.
      INSERT /cadaxo/sqlcrolr FROM wa_rolr_db.
      IF sy-subrc EQ 0.
        PERFORM build_node_table TABLES gt_node_table gt_item_table.
        PERFORM build_role_tree.

*       log changes
        FREE lr_log.
        lr_log = NEW #( ).
        lr_log->add_ulog( i_log_message = VALUE #( object     = c_object                  "COCKPIT-213
                                                   object_key = c_object_key
                                                   type       = 'I'
                                                   id         = '/CADAXO/SQLC_ULOG'
                                                   number     = '020'
                                                   message_v1 = i_user
                                                   message_v2 = i_role ) ).

      ENDIF.
    ELSE.
      MESSAGE i037(/cadaxo/sqlc) WITH i_user i_role.
    ENDIF.
  ENDMETHOD.                    "add_role_to_user
  METHOD remove_role_from_user.
    CLEAR: g_rc.

    DATA lr_log            TYPE REF TO /cadaxo/cl_sqlc_user_log.
    DATA ls_log            TYPE /cadaxo/sqlculog_api.

    READ TABLE gt_rolr WITH KEY node_key = node_key ASSIGNING <wa_rolr>.
    IF sy-subrc EQ 0.

      CALL FUNCTION 'POPUP_TO_CONFIRM'                      "#EC *
        EXPORTING
          titlebar              = TEXT-t04
          text_question         = TEXT-q03
          icon_button_1         = '@01@'
          icon_button_2         = '@02@'
          default_button        = '2'
          display_cancel_button = ''
        IMPORTING
          answer                = g_rc
        EXCEPTIONS
          OTHERS                = 1.
      IF g_rc = '1'.
        ls_log = VALUE #( object     = c_object                  "COCKPIT-213
                          object_key = c_object_key
                          type       = 'I'
                          id         = '/CADAXO/SQLC_ULOG'
                          number     = '021'
                          message_v1 = <wa_rolr>-uname
                          message_v2 = <wa_rolr>-role ).
        DELETE FROM /cadaxo/sqlcrolr WHERE uname = <wa_rolr>-uname
                                       AND role  = <wa_rolr>-role.

        IF sy-subrc = 0.

          PERFORM build_role_tree.

          FREE lr_log.
          lr_log = NEW #( ).
          lr_log->add_ulog( i_log_message = ls_log ).

        ENDIF.

      ENDIF.

    ENDIF.
  ENDMETHOD.                    "remove_role_from_user
  METHOD remove_user.

    DATA l_uname           TYPE /cadaxo/sqlcuser.
    DATA lr_log            TYPE REF TO /cadaxo/cl_sqlc_user_log.
    DATA ls_log            TYPE /cadaxo/sqlculog_api.

    CLEAR: g_rc.

    SELECT SINGLE uname INTO l_uname FROM /cadaxo/sqlcrolu WHERE uname = node_key.
    IF sy-subrc = 0.
      CALL FUNCTION 'POPUP_TO_CONFIRM'                      "#EC *
        EXPORTING
          titlebar              = TEXT-t03
          text_question         = TEXT-q02
          icon_button_1         = '@01@'
          icon_button_2         = '@02@'
          default_button        = '2'
          display_cancel_button = ''
        IMPORTING
          answer                = g_rc
        EXCEPTIONS
          OTHERS                = 1.
      IF g_rc EQ '1'.

        DELETE FROM /cadaxo/sqlcrolu WHERE uname = node_key.
        DELETE FROM /cadaxo/sqlcrolr WHERE uname = node_key.

        PERFORM build_node_table TABLES gt_node_table gt_item_table.
        PERFORM build_role_tree.

        ls_log = VALUE #( object     = c_object
                          object_key = c_object_key
                          type       = 'I'
                          id         = '/CADAXO/SQLC_ULOG'
                          number     = '023'
                          message_v1 = l_uname ).

        FREE lr_log.
        lr_log = NEW #( ).
        lr_log->add_ulog( i_log_message = ls_log ).

      ENDIF.
    ENDIF.
  ENDMETHOD.                    "remove_user
  METHOD delete_role.

    DATA l_rc              TYPE i.
    DATA lr_log            TYPE REF TO /cadaxo/cl_sqlc_user_log.
    DATA ls_log            TYPE /cadaxo/sqlculog_api.

    READ TABLE gt_role WITH KEY node_key = node_key ASSIGNING <wa_role>.
    IF sy-subrc EQ 0.

      READ TABLE gt_rolr WITH KEY role = <wa_role>-role TRANSPORTING NO FIELDS.
      IF sy-subrc EQ 0.
        MESSAGE ID '/CADAXO/SQLC' TYPE i_type NUMBER 25 DISPLAY LIKE 'E'.
        RETURN.
      ELSE.

        PERFORM enqueue USING    <wa_role>-role
                                 c_true
                        CHANGING l_rc.
        IF l_rc = 0.

          CALL FUNCTION 'POPUP_TO_CONFIRM'                  "#EC *
            EXPORTING
              titlebar              = TEXT-t01
              text_question         = TEXT-q01
              icon_button_1         = '@01@'
              icon_button_2         = '@02@'
              default_button        = '2'
              display_cancel_button = ''
            IMPORTING
              answer                = g_rc
            EXCEPTIONS
              OTHERS                = 1.
          IF g_rc EQ '1'.

            DELETE FROM /cadaxo/sqlcrole WHERE role = <wa_role>-role.
            IF sy-subrc EQ 0.
              MESSAGE s023(/cadaxo/sqlc) WITH <wa_role>-role.
              PERFORM dequeue USING <wa_role>-role.
              DELETE gt_role WHERE role EQ <wa_role>-role.
              PERFORM build_role_tree.
              LOOP AT gt_controls ASSIGNING <wa_controls>.
                CLEAR <wa_controls>-gui_data.
              ENDLOOP.
              CLEAR wa_sqlcrole.
              CLEAR wa_auth.
              g_mode = c_mode_dis.
              cl_gui_cfw=>set_new_ok_code( EXPORTING new_code = 'DLROLE' ).

              ls_log = VALUE #( object     = c_object
                                object_key = c_object_key
                                type       = 'I'
                                id         = '/CADAXO/SQLC_ULOG'
                                number     = '025'
                                message_v1 = <wa_role>-role ).
              FREE lr_log.
              lr_log = NEW #( ).
              lr_log->add_ulog( i_log_message = ls_log ).

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.                    "delete_role
  METHOD set_cleanup_errors.

    g_cleanup_errors = i_cleanup.

  ENDMETHOD.                    "set_cleanup_errors
  METHOD on_data_changed.

    DATA: l_tabname TYPE tabname.
    DATA: l_error   TYPE i.
    DATA: l_height  TYPE i.
    FIELD-SYMBOLS: <lwa_mod_cells>  TYPE lvc_s_modi.

    IF NOT er_data_changed->mt_inserted_rows IS INITIAL
    OR NOT er_data_changed->mt_deleted_rows IS INITIAL.
      g_also_ins_or_del = c_true.
    ENDIF.

    LOOP AT er_data_changed->mt_mod_cells ASSIGNING <lwa_mod_cells> WHERE fieldname = 'TABLE_AUTH'.
      READ TABLE er_data_changed->mt_inserted_rows WITH KEY row_id = <lwa_mod_cells>-row_id TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        CONTINUE.
      ENDIF.
      READ TABLE er_data_changed->mt_deleted_rows WITH KEY row_id = <lwa_mod_cells>-row_id TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        CONTINUE.
      ENDIF.

      TRANSLATE <lwa_mod_cells>-value TO UPPER CASE.      "#EC SYNTCHAR
      FIND '*' IN <lwa_mod_cells>-value.
      IF sy-subrc = 0.
        l_tabname = <lwa_mod_cells>-value.
        TRANSLATE l_tabname USING '*%'.
        SELECT SINGLE tabname FROM dd02l INTO l_tabname WHERE tabname LIKE l_tabname AND as4local = 'A' AND as4vers = space. "#EC *
        IF sy-subrc <> 0.
* begin of change +cockpit426
          SELECT SINGLE @abap_true FROM ddldependency INTO @DATA(lv_valid_partial) WHERE ddlname LIKE @l_tabname.
          IF sy-subrc <> 0.
* end  of change +cockpit426

            READ TABLE gt_controls ASSIGNING <wa_controls> WITH KEY tab = g_initiator.
            IF sy-subrc = 0.
              IF g_cleanup_errors = c_true.
                <wa_controls>-alv_prot->modify_cell(
                    i_row_id    = <lwa_mod_cells>-row_id
                    i_tabix     = <lwa_mod_cells>-tabix
                    i_fieldname = <lwa_mod_cells>-fieldname
                    i_value     = space
                       ).

              ELSE.
                <lwa_mod_cells>-error = c_true.
                ADD 1 TO l_error .
                er_data_changed->add_protocol_entry( i_msgid     = '/CADAXO/SQLC'
                                                     i_msgty     = 'E'
                                                     i_msgno     = '029'
                                                     i_msgv1     = <lwa_mod_cells>-value
                                                     i_fieldname = <lwa_mod_cells>-fieldname
                                                     i_row_id    = <lwa_mod_cells>-row_id
                                                    ).
                <wa_controls>-alv_prot = er_data_changed.
              ENDIF.
            ENDIF.
* begin of change +cockpit426
          ELSE.
*         make log entry
            append_to_gt_log( l_tabname ).
          ENDIF.
* end  of change +cockpit426

        ELSE.
*         make log entry
          APPEND INITIAL LINE TO gt_log ASSIGNING <gs_log>.
          MOVE c_object              TO <gs_log>-object.
          MOVE c_object_key          TO <gs_log>-object_key.
          MOVE 'I'                    TO <gs_log>-type.
          MOVE '/CADAXO/SQLC_ULOG'    TO <gs_log>-id.
          MOVE '027'                  TO <gs_log>-number.
          MOVE l_tabname              TO <gs_log>-message_v1.
          MOVE wa_sqlcrole-role       TO <gs_log>-message_v2.
        ENDIF.
      ELSE. " no * within Tablename
        SELECT SINGLE tabname FROM dd02l INTO l_tabname WHERE tabname = <lwa_mod_cells>-value AND as4local = 'A' AND as4vers = space.
        IF sy-subrc <> 0.
* begin of change +cockpit426
          SELECT SINGLE @abap_true FROM ddldependency INTO @DATA(lv_valid) WHERE ddlname = @<lwa_mod_cells>-value.
          IF sy-subrc <> 0.
* end  of change +cockpit426
            READ TABLE gt_controls ASSIGNING <wa_controls> WITH KEY tab = g_initiator.
            IF sy-subrc = 0.
              IF g_cleanup_errors = c_true.
                <wa_controls>-alv_prot->modify_cell( i_row_id    = <lwa_mod_cells>-row_id
                                                     i_tabix     = <lwa_mod_cells>-tabix
                                                     i_fieldname = <lwa_mod_cells>-fieldname
                                                     i_value     = space
                                                    ).

              ELSE.
                <lwa_mod_cells>-error = c_true.
                ADD 1 TO l_error .
                er_data_changed->add_protocol_entry( i_msgid     = '/CADAXO/SQLC'
                                                     i_msgty     = 'E'
                                                     i_msgno     = '021'
                                                     i_msgv1     = <lwa_mod_cells>-value
                                                     i_fieldname = <lwa_mod_cells>-fieldname
                                                     i_row_id    = <lwa_mod_cells>-row_id
                                                    ).
                <wa_controls>-alv_prot = er_data_changed.
              ENDIF.
            ENDIF.
* begin of change +cockpit426
          ELSE.
*         make log entry
            append_to_gt_log( l_tabname ).
          ENDIF.
* end  of change +cockpit426
        ELSE.
*         make log entry
          APPEND INITIAL LINE TO gt_log ASSIGNING <gs_log>.
          MOVE c_object              TO <gs_log>-object.
          MOVE c_object_key          TO <gs_log>-object_key.
          MOVE 'I'                    TO <gs_log>-type.
          MOVE '/CADAXO/SQLC_ULOG'    TO <gs_log>-id.
          MOVE '027'                  TO <gs_log>-number.
          MOVE l_tabname              TO <gs_log>-message_v1.
          MOVE wa_sqlcrole-role       TO <gs_log>-message_v2.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF NOT l_error IS INITIAL.

      er_data_changed->display_protocol( i_container        = gr_messages
                                         i_display_toolbar  = c_false
                                         i_optimize_columns = c_true
                                        ).
      l_height = l_error * 5 + 5.
    ENDIF.
    gr_splitter_container->set_row_height( EXPORTING  id                = 2
                                                      height            = l_height
                                           EXCEPTIONS OTHERS            = 1 ).

    CLEAR g_cleanup_errors.

  ENDMETHOD.                    "on_data_changed
  METHOD on_data_changed_finished.
    DATA: lwa_stable TYPE lvc_s_stbl.

    IF e_modified = c_true.
      g_data_changed = c_true.

      READ TABLE gt_controls ASSIGNING <wa_controls> WITH KEY tab = g_initiator.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
      CLEAR: wa_auth-specialfields[].
      CLEAR <wa_controls>-auth_table->*.

      LOOP AT <wa_controls>-gui_data ASSIGNING <wa_table_ui>.
        APPEND <wa_table_ui>-table_auth TO <wa_controls>-auth_table->*.
      ENDLOOP.

      PERFORM build_display_table USING    g_also_ins_or_del
                                  CHANGING <wa_controls>-gui_data
                                           <wa_controls>-auth_table->*.

      lwa_stable-row = c_true.
      lwa_stable-col = c_true.
      IF <wa_controls>-alv IS BOUND.
        <wa_controls>-alv->refresh_table_display(
        EXPORTING
          is_stable      = lwa_stable
          i_soft_refresh = c_true
        EXCEPTIONS
          finished       = 1
          OTHERS         = 2
          ).
      ENDIF.
    ENDIF.
    CLEAR g_also_ins_or_del.
  ENDMETHOD.                    "on_data_changed_finished

  METHOD append_to_gt_log.

    APPEND INITIAL LINE TO gt_log ASSIGNING <gs_log>.
    MOVE c_object              TO <gs_log>-object.
    MOVE c_object_key          TO <gs_log>-object_key.
    MOVE 'I'                    TO <gs_log>-type.
    MOVE '/CADAXO/SQLC_ULOG'    TO <gs_log>-id.
    MOVE '027'                  TO <gs_log>-number.
    MOVE i_tabname              TO <gs_log>-message_v1.
    MOVE wa_sqlcrole-role       TO <gs_log>-message_v2.

  ENDMETHOD.

ENDCLASS.                    "LCL_APPLICATION IMPLEMENTATION

DATA gr_tree_hdl TYPE REF TO lcl_application.


START-OF-SELECTION.

  AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
  IF sy-subrc NE 0.
    MESSAGE e036(/cadaxo/sqlc).
  ENDIF.

  CALL SCREEN 100.

END-OF-SELECTION.

*----------------------------------------------------------------------*
*  MODULE TABS_ACTIVE_TAB_SET OUTPUT
*----------------------------------------------------------------------*
MODULE tabs_active_tab_set OUTPUT.
  gd_tabs-activetab = gwa_tabs-pressed_tab.
  CASE gwa_tabs-pressed_tab.
    WHEN c_tabs-tab1.
      gwa_tabs-auth_tab_name = 'INCLUDED'.
    WHEN c_tabs-tab2.
      gwa_tabs-auth_tab_name = 'EXCLUDED'.
    WHEN OTHERS.
  ENDCASE.

  tabs_tab1 = '@01@ Included DB-Tables'(t06).
  tabs_tab2 = '@02@ Excluded DB-Tables'(t07).
ENDMODULE.                    "TABS_ACTIVE_TAB_SET OUTPUT

*----------------------------------------------------------------------*
*  MODULE TABS_ACTIVE_TAB_GET INPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE tabs_active_tab_get INPUT.
  g_ok_code = sy-ucomm.
  CASE g_ok_code.
    WHEN c_tabs-tab1 OR c_tabs-tab2.
      gwa_tabs-pressed_tab = g_ok_code.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                    "TABS_ACTIVE_TAB_GET INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  IF gtd_exallfcodes IS INITIAL.
    APPEND 'SAVE' TO gtd_exallfcodes.
  ENDIF.
  gtd_exfcodes = gtd_exallfcodes.
  IF wa_sqlcrole-role IS INITIAL.
    APPEND 'SWEDIT' TO gtd_exfcodes.
  ENDIF.
  CASE g_mode.
    WHEN c_mode_dis.
      SET PF-STATUS 'MAIN_0100' EXCLUDING gtd_exfcodes.
    WHEN OTHERS.
      SET PF-STATUS 'MAIN_0100'.
  ENDCASE.

  SET TITLEBAR '0100'.

  LOOP AT gt_controls ASSIGNING <wa_controls>.
    SORT <wa_controls>-gui_data.
  ENDLOOP.

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

* Get data into itab
  PERFORM get_alv_data.

  CASE g_ok_code.
    WHEN 'CANCEL' OR 'BACK' OR 'LEAVE'.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN 'TRANSPORT'.
      PERFORM transport USING space.
    WHEN 'CRROLE'.
      PERFORM role_create.
    WHEN 'DLROLE'.
      CLEAR wa_sqlcrole.
    WHEN 'SAVE'.
      PERFORM data_save.
    WHEN 'SWEDIT'.
      PERFORM switch_edit.
    WHEN 'SEARCHUSER'.
      PERFORM searchuser.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
MODULE modify_screen OUTPUT.

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN '001'.
        IF g_mode EQ c_mode_new.
          screen-input = 1.
        ELSE.
          screen-input = 0.
        ENDIF.
      WHEN '002'.
        IF g_mode EQ c_mode_dis.
          screen-input = 0.
        ELSE.
          screen-input = 1.
        ENDIF.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.                 " MODIFY_SCREEN  OUTPUT

*----------------------------------------------------------------------*
*  MODULE init_tree_control OUTPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE init_tree_control OUTPUT.

  IF gr_tree_hdl IS INITIAL.
    CREATE OBJECT gr_tree_hdl
      EXPORTING
        i_initiator = 'TREE'.
  ENDIF.

  IF gr_tree IS INITIAL.

    CALL FUNCTION '/CADAXO/SQLCADMININFOHTML'.

    CREATE OBJECT gr_docking_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gr_docking_container->dock_at_left
        extension = 400.


    wa_tree_header-heading = ''.
    wa_tree_header-width = 45.
    CREATE OBJECT gr_tree
      EXPORTING
        parent                = gr_docking_container
        node_selection_mode   = cl_gui_column_tree=>node_sel_mode_single
        item_selection        = c_true
        hierarchy_column_name = c_column-col1
        hierarchy_header      = wa_tree_header
      EXCEPTIONS
        OTHERS                = 1.

    gr_tree->add_column( EXPORTING
                          name        = c_column-col2
                          width       = 30
                          header_text = 'Descriptiom'(co2)
                        EXCEPTIONS
                          OTHERS      = 1 ).

    wa_event-eventid = cl_gui_column_tree=>eventid_node_double_click.
    wa_event-appl_event = c_true.
    APPEND wa_event TO gt_events.
    wa_event-eventid = cl_gui_column_tree=>eventid_item_double_click.
    wa_event-appl_event = c_true.
    APPEND wa_event TO gt_events.
    wa_event-eventid = cl_gui_column_tree=>eventid_link_click. "COCKPIT-248
    wa_event-appl_event = c_false.                             "COCKPIT-248
    APPEND wa_event TO gt_events.                              "COCKPIT-248
    wa_event-eventid = cl_gui_column_tree=>eventid_node_context_menu_req.
    wa_event-appl_event = c_false.
    APPEND wa_event TO gt_events.
    wa_event-eventid = cl_gui_column_tree=>eventid_item_context_menu_req.
    wa_event-appl_event = c_false.
    APPEND wa_event TO gt_events.



    gr_tree->set_ctx_menu_select_event_appl( EXPORTING appl_event = 'X' ).

    gr_tree->set_registered_events( EXPORTING events = gt_events
                                    EXCEPTIONS OTHERS = 1 ).

* assign event handlers in the application class to each desired event
    SET HANDLER gr_tree_hdl->handle_node_double_click     FOR gr_tree.
    SET HANDLER gr_tree_hdl->handle_node_context_menu_req FOR gr_tree.
    SET HANDLER gr_tree_hdl->handle_node_context_menu_sel FOR gr_tree.
    SET HANDLER gr_tree_hdl->handle_item_double_click     FOR gr_tree.
    SET HANDLER gr_tree_hdl->handle_item_context_menu_req FOR gr_tree.
    SET HANDLER gr_tree_hdl->handle_item_context_menu_sel FOR gr_tree.
    SET HANDLER gr_tree_hdl->flavor_select                FOR gr_tree.
    SET HANDLER gr_tree_hdl->on_drag                      FOR gr_tree.
    SET HANDLER gr_tree_hdl->on_drop                      FOR gr_tree.
    SET HANDLER gr_tree_hdl->on_drop_complete             FOR gr_tree.
    SET HANDLER gr_tree_hdl->on_link_click                FOR gr_tree. "COCKPIT-248

    PERFORM build_role_tree.

  ENDIF.
ENDMODULE.                    "init_tree_control OUTPUT
*&---------------------------------------------------------------------*
*&      Form  BUILD_NODE_TABLE
*&---------------------------------------------------------------------*
FORM build_node_table  TABLES    p_node_table TYPE treev_ntab
                                 p_item_table TYPE item_table_type.

  DATA: ls_address    TYPE bapiaddr3.
  DATA: ls_logondata  TYPE bapilogond.
  DATA: ls_refuser    TYPE bapirefus.
  DATA: lt_return     TYPE bapiret2_t.

  IF gt_role IS INITIAL.
    SELECT * FROM /cadaxo/sqlcrole INTO CORRESPONDING FIELDS OF TABLE gt_role.
  ENDIF.

  CLEAR: p_node_table[].
  CLEAR: p_item_table[].

  IF gr_drag_behaviour IS INITIAL.
    CREATE OBJECT gr_drag_behaviour.
    gr_drag_behaviour->add(
    EXPORTING
      flavor     = 'Tree_move'                              "#EC NOTEXT
      dragsrc    = 'X'
      droptarget = ' '
      effect     = cl_dragdrop=>copy ).

    CREATE OBJECT gr_drop_behaviour.
    gr_drop_behaviour->add(
    EXPORTING
      flavor     = 'Tree_move'                              "#EC NOTEXT
      dragsrc    = ' '
      droptarget = 'X'
      effect     = cl_dragdrop=>copy ).

    CREATE OBJECT gr_drdr_behaviour.
    gr_drdr_behaviour->add(
    EXPORTING
      flavor     = 'Tree_move'                              "#EC NOTEXT
      dragsrc    = 'X'
      droptarget = 'X'
      effect     = cl_dragdrop=>copy ).

    gr_drag_behaviour->get_handle(
    IMPORTING
      handle = g_handle_drag ).
    gr_drop_behaviour->get_handle(
    IMPORTING
      handle = g_handle_drop ).
    gr_drdr_behaviour->get_handle(
    IMPORTING
      handle = g_handle_drdr ).
  ENDIF.

  APPEND INITIAL LINE TO p_node_table ASSIGNING <wa_node>.
  <wa_node>-node_key = cs_nodekey-root.
  <wa_node>-isfolder = abap_true.
  APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
  MOVE-CORRESPONDING <wa_node> TO <wa_item>.
  <wa_item>-item_name = c_column-col1.
  <wa_item>-text      = TEXT-013.

  APPEND INITIAL LINE TO p_node_table ASSIGNING <wa_node>.
  <wa_node>-node_key  = cs_nodekey-role.
  <wa_node>-isfolder  = abap_true.
  <wa_node>-relatkey  = cs_nodekey-root.
  APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
  MOVE-CORRESPONDING <wa_node> TO <wa_item>.
  <wa_item>-item_name = c_column-col1.
  <wa_item>-text      = TEXT-005.

  APPEND INITIAL LINE TO p_node_table ASSIGNING <wa_node>.
  <wa_node>-node_key  = cs_nodekey-employee.
  <wa_node>-isfolder  = abap_true.
  <wa_node>-relatkey  = cs_nodekey-root.
  APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
  MOVE-CORRESPONDING <wa_node> TO <wa_item>.
  <wa_item>-item_name = c_column-col1.
  <wa_item>-text      = TEXT-006.

  APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.     "COCKPIT-248
  MOVE-CORRESPONDING <wa_node> TO <wa_item>.                   "COCKPIT-248
  <wa_item>-item_name = c_column-col2.                         "COCKPIT-248
  <wa_item>-class     = cl_gui_column_tree=>item_class_link.   "COCKPIT-248
  IF gs_user_search IS INITIAL.                                "COCKPIT-248
    <wa_item>-t_image   = icon_filter.                         "COCKPIT-248
    <wa_item>-text      = TEXT-015.                            "COCKPIT-248
  ELSE.                                                        "COCKPIT-248
    <wa_item>-t_image   = icon_filter_undo.                    "COCKPIT-248
    <wa_item>-text      = TEXT-016.                            "COCKPIT-248
  ENDIF.                                                       "COCKPIT-248
  <wa_item>-style     = cl_gui_column_tree=>style_emphasized.  "COCKPIT-248

  APPEND INITIAL LINE TO p_node_table ASSIGNING <wa_node>.
  <wa_node>-node_key   = cs_nodekey-delete.
  <wa_node>-isfolder   = abap_true.
  <wa_node>-n_image    = icon_delete.
  <wa_node>-dragdropid = g_handle_drop.
  APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
  MOVE-CORRESPONDING <wa_node> TO <wa_item>.
  <wa_item>-item_name = c_column-col1.
  <wa_item>-text      = TEXT-014.


  LOOP AT gt_role ASSIGNING <wa_role>.

    IF <wa_role>-node_key IS INITIAL.
      MOVE 'RL' TO wa_node_key-object.
      ADD 1 TO wa_node_key-number.

      MOVE wa_node_key TO <wa_role>-node_key.
    ENDIF.
    APPEND INITIAL LINE TO p_node_table ASSIGNING <wa_node>.
    <wa_node>-node_key = <wa_role>-node_key.
    <wa_node>-relatkey = cs_nodekey-role.
    <wa_node>-dragdropid = g_handle_drag.
    APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
    MOVE-CORRESPONDING <wa_node> TO <wa_item>.
    <wa_item>-item_name = c_column-col1.
    <wa_item>-text      = <wa_role>-role.
    APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
    MOVE-CORRESPONDING <wa_node> TO <wa_item>.
    <wa_item>-item_name = c_column-col2.
    <wa_item>-class     = cl_gui_column_tree=>item_class_text.
    <wa_item>-text      = <wa_role>-role_description.

    IF NOT <wa_role>-role_default IS INITIAL.
      <wa_node>-n_image = icon_oo_inst_attribute.     "default role
    ELSE.
      <wa_node>-n_image = icon_oo_object.      "normal role
    ENDIF.

  ENDLOOP.

  SELECT * FROM /cadaxo/sqlcrolu INTO CORRESPONDING FIELDS OF TABLE gt_rolu.
  SELECT * FROM /cadaxo/sqlcrolr INTO CORRESPONDING FIELDS OF TABLE gt_rolr.

  SORT gt_rolu BY uname.


  LOOP AT gt_rolu ASSIGNING <wa_rolu>.

    IF gs_user_search-uname IS NOT INITIAL.          "COCKPIT-248
      IF <wa_rolu>-uname NP gs_user_search-uname.    "COCKPIT-248
        CONTINUE.                                    "COCKPIT-248
      ENDIF.                                         "COCKPIT-248
    ENDIF.                                           "COCKPIT-248

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username  = <wa_rolu>-uname
      IMPORTING
        address   = ls_address
        logondata = ls_logondata                     "COCKPIT-172
        ref_user  = ls_refuser                       "COCKPIT-172
      TABLES
        return    = lt_return.

    IF gs_user_search-name IS NOT INITIAL.           "COCKPIT-248
      IF ls_address-fullname NP gs_user_search-name. "COCKPIT-248
        CONTINUE.                                    "COCKPIT-248
      ENDIF.                                         "COCKPIT-248
    ENDIF.                                           "COCKPIT-248

    APPEND INITIAL LINE TO p_node_table ASSIGNING <wa_node>.
    <wa_node>-node_key   = <wa_rolu>-uname.
    <wa_node>-relatkey   = cs_nodekey-employee.
    <wa_node>-isfolder   = abap_true.
    IF ls_logondata-ustyp = 'L'.                     "COCKPIT-172
      <wa_node>-n_image    = icon_manager.           "COCKPIT-172
      <wa_node>-exp_image  = icon_manager.           "COCKPIT-172
    ELSE.                                            "COCKPIT-172
      <wa_node>-n_image    = icon_customer.
      <wa_node>-exp_image  = icon_customer.
    ENDIF.
    <wa_node>-dragdropid = g_handle_drdr.
    APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
    MOVE-CORRESPONDING <wa_node> TO <wa_item>.
    <wa_item>-item_name = c_column-col1.
    <wa_item>-text      = <wa_rolu>-uname.
    APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
    MOVE-CORRESPONDING <wa_node> TO <wa_item>.
    <wa_item>-item_name = c_column-col2.
    <wa_item>-text      = ls_address-fullname.

    IF ls_refuser-ref_user IS NOT INITIAL.                     "COCKPIT-172
      DATA: lv_refuser_key TYPE tv_nodekey.                    "COCKPIT-172
      ADD 1 TO lv_refuser_key.
      APPEND INITIAL LINE TO p_node_table ASSIGNING <wa_node>.
      <wa_node>-node_key   = lv_refuser_key.
      <wa_node>-relatkey   = <wa_rolu>-uname.
      <wa_node>-isfolder   = abap_false.
      <wa_node>-n_image    = icon_manager.
      <wa_node>-exp_image  = icon_manager.
      APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
      MOVE-CORRESPONDING <wa_node> TO <wa_item>.
      <wa_item>-item_name = c_column-col1.
      <wa_item>-text      = ls_refuser-ref_user.
    ENDIF.

    LOOP AT gt_rolr ASSIGNING <wa_rolr> WHERE uname = <wa_rolu>-uname.

      MOVE 'RU' TO wa_node_key-object.
      ADD 1 TO wa_node_key-number.

      MOVE wa_node_key TO <wa_rolr>-node_key.
*
      APPEND INITIAL LINE TO p_node_table ASSIGNING <wa_node>.
      <wa_node>-node_key   = <wa_rolr>-node_key.
      <wa_node>-relatkey   = <wa_rolr>-uname.
      <wa_node>-dragdropid = g_handle_drag.
      <wa_node>-n_image    = icon_oo_class.      "normal role
      APPEND INITIAL LINE TO p_item_table ASSIGNING <wa_item>.
      MOVE-CORRESPONDING <wa_node> TO <wa_item>.
      <wa_item>-item_name = c_column-col1.
      <wa_item>-text      = <wa_rolr>-role.
    ENDLOOP.
  ENDLOOP.

ENDFORM.                    " BUILD_NODE_TABLE
*&---------------------------------------------------------------------*
*&      Form  BUILD_ROLE_TREE
*&---------------------------------------------------------------------*
FORM build_role_tree .

  PERFORM build_node_table TABLES gt_node_table gt_item_table.

  gr_tree->delete_all_nodes( ).

  gr_tree->add_nodes_and_items(
    EXPORTING
      node_table                     = gt_node_table
      item_table                     = gt_item_table
      item_table_structure_name      = 'MTREEITM'
    EXCEPTIONS
      OTHERS                         = 1
         ).

  gr_tree->expand_root_nodes( EXPORTING level_count = 2 ).


ENDFORM.                    " BUILD_ROLE_TREE
*&---------------------------------------------------------------------*
*&      Form  enqueue
*&---------------------------------------------------------------------*
FORM enqueue USING    u_role  TYPE /cadaxo/sqlcrole_id
                      u_force TYPE c
             CHANGING uc_rc   TYPE i.

  DATA: l_name TYPE string.

  CLEAR uc_rc.

  IF g_mode <> c_mode_dis OR u_force = c_true.
    CALL FUNCTION 'ENQUEUE_/CADAXO/SQLCROLE'
      EXPORTING
        mode_/cadaxo/sqlcrole = 'E'
        client                = sy-mandt
        role                  = u_role
      EXCEPTIONS
        foreign_lock          = 1
        system_failure        = 2
        OTHERS                = 3.
    uc_rc = sy-subrc.                                       "#EC *
    l_name = sy-msgv1.
    IF l_name = sy-uname.                                   "#EC *
      l_name = TEXT-you.
    ENDIF.
    IF uc_rc <> 0.                                          "#EC *
      MESSAGE s026(/cadaxo/sqlc) WITH l_name DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.                   "enqueue
*&---------------------------------------------------------------------*
*&      Form  dequeue
*&---------------------------------------------------------------------*
FORM dequeue USING u_role TYPE /cadaxo/sqlcrole_id.

  CALL FUNCTION 'DEQUEUE_/CADAXO/SQLCROLE'
    EXPORTING
      mode_/cadaxo/sqlcrole = 'E'
      client                = sy-mandt
      role                  = u_role.

ENDFORM.                    "dequeue
DEFINE check_namespace.

  SELECT SINGLE mtext FROM t000 INTO g_mtext WHERE mandt = sy-mandt.
  IF wa_sqlcrole-role(8) EQ '/CADAXO/'.
    IF g_mtext NE 'CADAXO'.
      MESSAGE e017(/cadaxo/sqlc).
    ELSE.
      MESSAGE w017(/cadaxo/sqlc).
    ENDIF.
  ENDIF.
END-OF-DEFINITION.

*&---------------------------------------------------------------------*
*&      Module  CHECK_ROLE  INPUT
*&---------------------------------------------------------------------*
*       Check new role id
*----------------------------------------------------------------------*
MODULE check_role INPUT.

* check role
  SELECT SINGLE COUNT( * ) FROM /cadaxo/sqlcrole WHERE role = wa_sqlcrole-role.
  IF sy-subrc EQ 0.
    MESSAGE e024(/cadaxo/sqlc).
  ENDIF.

* check namespace
  check_namespace.

* make log entry
  APPEND INITIAL LINE TO gt_log ASSIGNING <gs_log>.
  MOVE c_object               TO <gs_log>-object.
  MOVE  c_object_key          TO <gs_log>-object_key.
  MOVE 'I'                    TO <gs_log>-type.
  MOVE '/CADAXO/SQLC_ULOG'    TO <gs_log>-id.
  MOVE '024'                  TO <gs_log>-number.
  MOVE wa_sqlcrole-role       TO <gs_log>-message_v1.

ENDMODULE.                 " CHECK_ROLE  INPUT
*----------------------------------------------------------------------*
*  MODULE check_roledes INPUT
*----------------------------------------------------------------------*
MODULE check_roledes INPUT.

*  FIELD-SYMBOLS <fs_log> TYPE /cadaxo/sqlculog_api.

  g_data_changed = c_true.

* make log entry
  APPEND INITIAL LINE TO gt_log ASSIGNING <gs_log>.
  MOVE c_object                     TO <gs_log>-object.
  MOVE c_object_key                 TO <gs_log>-object_key.
  MOVE 'I'                          TO <gs_log>-type.
  MOVE '/CADAXO/SQLC_ULOG'          TO <gs_log>-id.
  MOVE '026'                        TO <gs_log>-number.
  MOVE wa_sqlcrole-role             TO <gs_log>-message_v1.
  MOVE wa_sqlcrole-role_description TO <gs_log>-message_v2.

ENDMODULE.                    "check_roledes INPUT
*----------------------------------------------------------------------*
*  MODULE init_controls OUTPUT
*----------------------------------------------------------------------*
MODULE init_controls OUTPUT.

  READ TABLE gt_controls ASSIGNING <wa_controls> WITH KEY tab = gwa_tabs-pressed_tab.
  IF sy-subrc <> 0.
    APPEND INITIAL LINE TO gt_controls ASSIGNING <wa_controls>.
    <wa_controls>-tab             = gwa_tabs-pressed_tab.
    <wa_controls>-auth_table_name = gwa_tabs-auth_tab_name.
    PERFORM fill_auth_data.
  ENDIF.
  PERFORM init_alv USING    gwa_tabs-container_name
                            <wa_controls>.

ENDMODULE.                    "init_controls OUTPUT
*&---------------------------------------------------------------------*
*&      Form  init_alv
*&---------------------------------------------------------------------*
FORM init_alv USING    u_containername TYPE any
                       uwa_control     TYPE gts_control.

  DATA: lt_toolbar_excluded              TYPE ui_functions.
  DATA: lt_fieldcat                      TYPE lvc_t_fcat.

  DATA: lwa_layout                       TYPE lvc_s_layo.

  FIELD-SYMBOLS: <wa_fcat>               TYPE lvc_s_fcat.

  SORT uwa_control-gui_data.

  IF uwa_control-alv IS INITIAL.

    IF gr_main_container IS INITIAL.
      CREATE OBJECT gr_main_container
        EXPORTING
          container_name = u_containername.

      CREATE OBJECT gr_splitter_container
        EXPORTING
          height  = 0
          rows    = 2
          columns = 1
          parent  = gr_main_container
        EXCEPTIONS
          OTHERS  = 1.

      gr_alv_container ?= gr_splitter_container->get_container( row       = 1
                                                                column    = 1
                                                              ).

      gr_messages ?= gr_splitter_container->get_container( row       = 2
                                                           column    = 1
                                                         ).
      gr_splitter_container->set_row_height(
        EXPORTING
          id                = 2
          height            = 0
        EXCEPTIONS
          cntl_error        = 1
          cntl_system_error = 2
          OTHERS            = 3
             ).

    ENDIF.

    CREATE OBJECT uwa_control-alv
      EXPORTING
        i_parent = gr_alv_container
      EXCEPTIONS
        OTHERS   = 1.

    CREATE OBJECT <wa_controls>-handler
      EXPORTING
        i_initiator = <wa_controls>-tab.


    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = '/CADAXO/SQLCROLED_TAB_UIM'
      CHANGING
        ct_fieldcat      = lt_fieldcat.
    READ TABLE lt_fieldcat ASSIGNING <wa_fcat> WITH KEY fieldname = 'TABLE_AUTH'.
    IF sy-subrc = 0.
      <wa_fcat>-edit = 'X'.
    ENDIF.

    APPEND cl_gui_alv_grid=>mc_fc_help     TO lt_toolbar_excluded.
    APPEND cl_gui_alv_grid=>mc_fc_graph    TO lt_toolbar_excluded.
    APPEND cl_gui_alv_grid=>mc_fc_info     TO lt_toolbar_excluded.
    APPEND cl_gui_alv_grid=>mc_fc_sum      TO lt_toolbar_excluded.
    APPEND cl_gui_alv_grid=>mc_fc_subtot   TO lt_toolbar_excluded.

    uwa_control-alv->register_edit_event( EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_modified
                                          EXCEPTIONS OTHERS     = 1 ).
    uwa_control-alv->register_edit_event( EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_enter
                                          EXCEPTIONS OTHERS     = 1 ).


    SET HANDLER uwa_control-handler->on_data_changed          FOR uwa_control-alv.
    SET HANDLER uwa_control-handler->on_data_changed_finished FOR uwa_control-alv.

    uwa_control-alv->set_table_for_first_display(
    EXPORTING
      i_bypassing_buffer   = abap_true
      is_layout            = lwa_layout
      it_toolbar_excluding = lt_toolbar_excluded
    CHANGING
      it_outtab            = uwa_control-gui_data
      it_fieldcatalog      = lt_fieldcat ).

  ELSE.

    CALL METHOD uwa_control-alv->refresh_table_display.

  ENDIF.

  IF g_mode EQ c_mode_dis OR wa_sqlcrole-role IS INITIAL.
    CALL METHOD uwa_control-alv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 0.
  ELSE.
    CALL METHOD uwa_control-alv->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.
  ENDIF.

  LOOP AT gt_controls ASSIGNING <wa_controls> WHERE alv <> uwa_control-alv. "#EC *
    <wa_controls>-alv->set_visible( EXPORTING visible = cl_gui_control=>visible_false
                                    EXCEPTIONS OTHERS = 1
                                  ).
  ENDLOOP.
  uwa_control-alv->set_visible( EXPORTING visible  = cl_gui_control=>visible_true
                                EXCEPTIONS OTHERS  = 1
                              ).

ENDFORM.                    " init_alv
*&---------------------------------------------------------------------*
*&      Form  DATA_SAVE
*&---------------------------------------------------------------------*
FORM data_save .

  FIELD-SYMBOLS <lwa_role> TYPE gts_role.

* Get data into itab
  PERFORM get_alv_data.

  IF NOT wa_sqlcrole-role IS INITIAL.

    CALL TRANSFORMATION id
                        SOURCE auth = wa_auth
                        RESULT XML wa_sqlcrole-auth_xml.

    IF  wa_sqlcrole-cruser IS INITIAL.
      wa_sqlcrole-cruser = sy-uname.
      wa_sqlcrole-crdate = sy-datum.
    ENDIF.
    wa_sqlcrole-chuser = sy-uname.
    wa_sqlcrole-chdate = sy-datum.

* 22-013 Begin, RT31
*   check for changed default role
    READ TABLE gt_role ASSIGNING <lwa_role> WITH KEY role = wa_sqlcrole-role.
    IF sy-subrc = 0.
      MOVE <lwa_role>-role_default TO wa_sqlcrole-role_default.
    ENDIF.
* 22-013 End, RT31

    MODIFY /cadaxo/sqlcrole FROM wa_sqlcrole.
    IF sy-subrc = 0.
*     log changes
      FREE lr_log.
      lr_log = NEW #( ).
      LOOP AT gt_log ASSIGNING <gs_log>.
        lr_log->add_ulog(
            i_log_message = <gs_log> ).
      ENDLOOP.
      CLEAR gt_log.
    ENDIF.

    READ TABLE gt_role ASSIGNING <wa_role> WITH KEY role = wa_sqlcrole-role.
    IF sy-subrc <> 0.
      APPEND INITIAL LINE TO gt_role ASSIGNING <wa_role>.
    ENDIF.
    MOVE-CORRESPONDING wa_sqlcrole TO <wa_role>.

    CLEAR g_data_changed.
    g_mode = c_mode_upd.

    PERFORM build_role_tree.

  ENDIF.
ENDFORM.                    " DATA_SAVE
*&---------------------------------------------------------------------*
*&      Form  get_alv_data
*&---------------------------------------------------------------------*
FORM get_alv_data.
* Get data into itab
  LOOP AT gt_controls ASSIGNING <wa_controls> WHERE alv IS BOUND.
    <wa_controls>-handler->set_cleanup_errors( c_true ).
    <wa_controls>-alv->check_changed_data( ).
  ENDLOOP.
* Cleanup empty table entries
  LOOP AT gt_controls ASSIGNING <wa_controls>.
    DELETE <wa_controls>-gui_data WHERE table_auth EQ space.
  ENDLOOP.
ENDFORM.                    "get_alv_data
*&---------------------------------------------------------------------*
*&      Form  BUILD_DISPLAY_TABLE
*&---------------------------------------------------------------------*
FORM build_display_table USING    u_accept_space TYPE c
                         CHANGING uct_table      TYPE /cadaxo/sqlcroled_tab_uim_t
                                  ut_auth_tab    TYPE /cadaxo/sqlcroletab_t.

  DATA: lwa_table_ui                      TYPE /cadaxo/sqlcroled_tab_uim.
  FIELD-SYMBOLS: <lwa_sqlcdtable_auth>    TYPE /cadaxo/sqlctable_auth.

  CLEAR: uct_table.

  IF u_accept_space IS INITIAL.
    SORT ut_auth_tab.
  ENDIF.

  LOOP AT ut_auth_tab ASSIGNING <lwa_sqlcdtable_auth>.
    CLEAR: lwa_table_ui.
    IF <lwa_sqlcdtable_auth> IS INITIAL AND u_accept_space IS INITIAL.
      CONTINUE.
    ENDIF.

    lwa_table_ui-table_auth = <lwa_sqlcdtable_auth>.

    FIND '*' IN lwa_table_ui-table_auth.
    IF sy-subrc = 0.
      IF lwa_table_ui-table_auth CO '* '.
        MESSAGE i028(/cadaxo/sqlc) INTO lwa_table_ui-table_description.
      ELSE.
        MESSAGE i020(/cadaxo/sqlc) INTO lwa_table_ui-table_description WITH lwa_table_ui-table_auth.
      ENDIF.
    ELSEIF NOT lwa_table_ui-table_auth IS INITIAL.
      SELECT SINGLE ddtext FROM dd02t INTO lwa_table_ui-table_description
                                      WHERE tabname    = lwa_table_ui-table_auth
                                        AND ddlanguage = sy-langu
                                        AND as4local   = 'A'
                                        AND as4vers    = space. "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED
      IF sy-subrc <> 0.
        SELECT SINGLE ddtext FROM ddddlsrct INTO lwa_table_ui-table_description
                                            WHERE ddlname    = lwa_table_ui-table_auth
                                              AND ddlanguage = sy-langu
                                              AND as4local   = 'A'.
        IF sy-subrc <> 0.
          MESSAGE i021(/cadaxo/sqlc) INTO lwa_table_ui-table_description WITH lwa_table_ui-table_auth.
        ENDIF.
      ENDIF.
    ENDIF.

    APPEND lwa_table_ui TO uct_table.
  ENDLOOP.

  IF NOT wa_sqlcrole-role IS INITIAL AND uct_table IS INITIAL.
    CLEAR lwa_table_ui.
    APPEND lwa_table_ui TO uct_table.
  ENDIF.
ENDFORM.                    " BUILD_DISPLAY_TABLE

*&---------------------------------------------------------------------*
*&      Form  check_save
*&---------------------------------------------------------------------*
FORM check_save CHANGING u_cancel TYPE c.
  DATA: l_answer TYPE c.

  u_cancel = c_false.

  IF g_data_changed = c_true.
    CALL FUNCTION 'POPUP_TO_CONFIRM'                        "#EC *
      EXPORTING
        titlebar              = TEXT-p00
        text_question         = TEXT-p01
        text_button_1         = TEXT-p02
        text_button_2         = TEXT-p03
        display_cancel_button = c_true
      IMPORTING
        answer                = l_answer
      EXCEPTIONS
        OTHERS                = 1.

    CASE l_answer.
      WHEN '1'. "SAVE
        PERFORM data_save.
      WHEN '2'. "DONT SAVE
        CLEAR gt_log.
      WHEN 'A'. "CANCEL
        u_cancel = c_true.
    ENDCASE.
  ENDIF.

ENDFORM.                    "check_save


*&---------------------------------------------------------------------*
*&      Form  fill_auth_data
*&---------------------------------------------------------------------*
FORM fill_auth_data .
  LOOP AT gt_controls ASSIGNING <wa_controls>.
    ASSIGN COMPONENT <wa_controls>-auth_table_name OF STRUCTURE wa_auth TO <gt_auth_table>.
    GET REFERENCE OF <gt_auth_table> INTO <wa_controls>-auth_table.
    PERFORM build_display_table USING    c_false
                                CHANGING <wa_controls>-gui_data
                                         <wa_controls>-auth_table->*.
    IF NOT <wa_controls>-alv_prot IS INITIAL.
      <wa_controls>-alv_prot->refresh_protocol( ).
      gr_splitter_container->set_row_height(
      EXPORTING
        id                = 2
        height            = 0
      EXCEPTIONS
        OTHERS            = 1 ).
    ENDIF.
  ENDLOOP.
ENDFORM.                    "fill_auth_data

*&---------------------------------------------------------------------*
*&      Form  transport
*&---------------------------------------------------------------------*
FORM transport USING VALUE(u_role) TYPE /cadaxo/sqlcrole_id.

  DATA: lt_ko200  TYPE TABLE OF ko200.
  DATA: lt_e071k  TYPE TABLE OF e071k.
  DATA: lwa_order TYPE trkorr.                              "#EC NEEDED
  DATA: lwa_task  TYPE trkorr.                              "#EC NEEDED

  FIELD-SYMBOLS: <lwa_ko200> TYPE ko200.
  FIELD-SYMBOLS: <lwa_e071k> TYPE e071k.


* KO200
  APPEND INITIAL LINE TO lt_ko200 ASSIGNING <lwa_ko200>.
  <lwa_ko200>-pgmid    = 'R3TR'.
  <lwa_ko200>-object   = 'TABU'.
  <lwa_ko200>-obj_name = '/CADAXO/SQLCROLE'.
  <lwa_ko200>-objfunc  = 'K'.

* E071K
  APPEND INITIAL LINE TO lt_e071k ASSIGNING <lwa_e071k>.
  <lwa_e071k>-pgmid      = 'R3TR'.
  <lwa_e071k>-object     = 'TABU'.
  <lwa_e071k>-objname    = '/CADAXO/SQLCROLE'.
  <lwa_e071k>-mastertype = 'TABU'.
  <lwa_e071k>-mastername = '/CADAXO/SQLCROLE'.
  IF u_role = space.
    u_role = '*'.
  ENDIF.
  CONCATENATE sy-mandt u_role INTO <lwa_e071k>-tabkey.

  <lwa_e071k>-sortflag   = '2'.

  CALL FUNCTION 'TR_OBJECTS_CHECK'
    TABLES
      wt_ko200                = lt_ko200
      wt_e071k                = lt_e071k
    EXCEPTIONS
      cancel_edit_other_error = 1
      show_only_other_error   = 2
      OTHERS                  = 3.

  IF sy-subrc <> 0.
    MESSAGE e241(57) WITH TEXT-006 sy-subrc.
  ENDIF.

  CALL FUNCTION 'TR_OBJECTS_INSERT'
    IMPORTING
      we_order = lwa_order
      we_task  = lwa_task
    TABLES
      wt_ko200 = lt_ko200
      wt_e071k = lt_e071k
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc <> 0.
    MESSAGE e241(57) WITH TEXT-005 sy-subrc.
  ENDIF.
ENDFORM.                    "transport
*&---------------------------------------------------------------------*
*&      Form  role_create
*&---------------------------------------------------------------------*
FORM role_create .

  DATA: l_cancel            TYPE c.

  PERFORM check_save CHANGING l_cancel.
  IF l_cancel = c_true.
    RETURN.
  ENDIF.

  CLEAR: wa_sqlcrole.
  LOOP AT gt_controls ASSIGNING <wa_controls>.
    CLEAR <wa_controls>-gui_data.
  ENDLOOP.

  MOVE c_mode_new TO g_mode.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  switch_edit
*&---------------------------------------------------------------------*
FORM switch_edit .

  DATA: l_chancel TYPE c.
  DATA: l_rc      TYPE i.

  CASE g_mode.
    WHEN c_mode_dis.
      PERFORM enqueue USING    wa_sqlcrole-role
                               c_true
                      CHANGING l_rc.
      IF l_rc IS INITIAL.
        g_mode = c_mode_upd.
      ELSE.
        g_mode = c_mode_dis.
      ENDIF.
    WHEN c_mode_new OR c_mode_upd.
      PERFORM check_save CHANGING l_chancel.
      IF l_chancel <> c_true.
        g_mode = c_mode_dis.
        PERFORM dequeue USING wa_sqlcrole-role.
      ENDIF.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  searchuser
*&---------------------------------------------------------------------*
FORM searchuser. "COCKPIT-248

  DATA: lt_fields           TYPE TABLE OF sval.
  DATA: l_return(1)         TYPE c.                         "#EC NEEDED

  IF gs_user_search IS NOT INITIAL.
    CLEAR gs_user_search.

    PERFORM build_role_tree.

  ELSE.

    APPEND VALUE #( tabname   = '/CADAXO/SQLCROLU'
                    fieldname = 'UNAME'
                    fieldtext = TEXT-009 ) TO lt_fields.
    APPEND VALUE #( tabname   = 'BAPIADDR3'
                    fieldname = 'FULLNAME'
                    fieldtext = TEXT-017 ) TO lt_fields.

    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
        popup_title = TEXT-t02
      IMPORTING
        returncode  = l_return
      TABLES
        fields      = lt_fields
      EXCEPTIONS
        OTHERS      = 1.
    IF sy-subrc EQ 0 AND l_return <> 'A'.
      CLEAR gs_user_search.

      ASSIGN lt_fields[ fieldname = 'UNAME' ] TO FIELD-SYMBOL(<ls_fields>).
      IF sy-subrc EQ 0 AND <ls_fields>-value IS NOT INITIAL.
        gs_user_search-uname = '*' && <ls_fields>-value && '*'.
      ENDIF.
      ASSIGN lt_fields[ fieldname = 'FULLNAME' ] TO <ls_fields>.
      IF sy-subrc EQ 0 AND <ls_fields>-value IS NOT INITIAL.
        gs_user_search-name = '*' && <ls_fields>-value && '*'.
      ENDIF.

      IF gs_user_search IS NOT INITIAL.
        PERFORM build_role_tree.
      ENDIF.

    ENDIF.
  ENDIF.



ENDFORM.

FORM adduser.

  DATA: lt_fields           TYPE TABLE OF sval.
  DATA: l_return(1)         TYPE c.                         "#EC NEEDED

  APPEND VALUE #( tabname   = '/CADAXO/SQLCROLU'
                  fieldname = 'UNAME'
                  fieldtext = TEXT-009 ) TO lt_fields.
  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      popup_title = TEXT-t02
    IMPORTING
      returncode  = l_return
    TABLES
      fields      = lt_fields
    EXCEPTIONS
      OTHERS      = 1.
  IF sy-subrc = 0 AND l_return <> 'A'.
    ASSIGN lt_fields[ 1 ] TO FIELD-SYMBOL(<ls_fields>).
    IF sy-subrc EQ 0.
      CLEAR: wa_rolu.
      wa_rolu-uname = <ls_fields>-value.

      SELECT SINGLE @abap_true AS true INTO @DATA(l_true) FROM usr01 WHERE bname = @wa_rolu-uname.
      IF sy-subrc EQ 0.
        INSERT /cadaxo/sqlcrolu FROM wa_rolu.
        IF sy-subrc EQ 0.

          PERFORM build_role_tree.

          FREE lr_log.
          lr_log = NEW #( ).
          lr_log->add_ulog(  i_log_message = VALUE #( object     = c_object                  "COCKPIT-213
                                                      object_key = c_object_key
                                                      type       = 'I'
                                                      id         = '/CADAXO/SQLC_ULOG'
                                                      number     = '022'
                                                      message_v1 = wa_rolu-uname ) ).

        ENDIF.
      ELSE.
        MESSAGE e018(/cadaxo/sqlc) WITH wa_rolu-uname.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
