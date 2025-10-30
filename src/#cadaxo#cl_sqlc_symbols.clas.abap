CLASS /cadaxo/cl_sqlc_symbols DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_popup_size,
        column    TYPE i,
        row       TYPE i,
        column_to TYPE i,
        row_to    TYPE i,
      END OF ty_popup_size .
    TYPES:
      t_symbol_db TYPE TABLE OF /cadaxo/sqlcusym .

    CONSTANTS:
      BEGIN OF cs_symbol_type,
        user    TYPE char1 VALUE 'U' ##NO_TEXT,
        program TYPE char1 VALUE 'P' ##NO_TEXT,
        variant TYPE char1 VALUE 'V' ##NO_TEXT,
        create  TYPE char1 VALUE 'C' ##NO_TEXT,
        modify  TYPE char1 VALUE 'M' ##NO_TEXT,
      END OF cs_symbol_type .
    CONSTANTS c_okcode_symbols TYPE syucomm VALUE 'SYMBOL' ##NO_TEXT.
    CONSTANTS:
      BEGIN OF c_program_symbols,
        hide TYPE flag VALUE abap_false,
        show TYPE flag VALUE abap_true,
      END OF c_program_symbols .

    METHODS constructor
      IMPORTING
        !i_user_settings TYPE REF TO /cadaxo/sqlcusrp_dyn
        !i_main          TYPE REF TO /cadaxo/cl_sqlc_cockpit_main .
    METHODS create_symbol_ui_control
      IMPORTING
        !i_container        TYPE REF TO cl_gui_container
        i_appllog_container TYPE REF TO cl_gui_container .
    METHODS check_changed_data .
    METHODS get_user_symbol_from_sql
      IMPORTING
        !i_varguid TYPE /cadaxo/sqlc_variant_guid OPTIONAL
        !i_sql     TYPE /cadaxo/sqlccodeline_t
        !i_type    TYPE char1
      EXPORTING
        !e_symbols TYPE /cadaxo/sqlc_symbol_t .
    METHODS merge_symbols
      IMPORTING
        !i_symbols TYPE /cadaxo/sqlc_symbol_t .
    METHODS create_symbol_from_result
      IMPORTING
        !i_result_data     TYPE REF TO data
        !i_result_fieldcat TYPE lvc_t_fcat .
    METHODS pbo_0700 .
    METHODS pai_0700
      IMPORTING
        !i_ok_code TYPE sy-ucomm .
    METHODS create_symbol_db
      IMPORTING
        !it_symbol_create TYPE t_symbol_db
      RETURNING
        VALUE(rv_success) TYPE boolean .
  PROTECTED SECTION.

    DATA g_symbol_toolbar_excluding TYPE ui_functions .
    DATA dragdrop_behaviour_symbol TYPE REF TO cl_dragdrop .
    DATA gcont_grid_symbol_t TYPE /cadaxo/sqlcclguicontainer_t .
    DATA dragdrop_handle_symbol TYPE i .
    DATA g_curr_col TYPE lvc_fname .
    DATA g_curr_row TYPE /cadaxo/sqlcsymbol_name .
    DATA gt_symbol TYPE /cadaxo/sqlc_symbol_t .
    DATA gt_symbol_delete TYPE /cadaxo/sqlc_symbol_t .
    DATA gt_symbol_selected TYPE /cadaxo/sqlc_symbol_t .
    DATA main_controller TYPE REF TO /cadaxo/cl_sqlc_cockpit_main .
    DATA gcont_symbol TYPE REF TO cl_gui_container .
    DATA gcont_symbol_toolbar TYPE REF TO cl_gui_container .
    DATA gcont_symbol_toolbar_btns TYPE REF TO cl_gui_container .
    DATA gcont_symbol_toolbar_img TYPE REF TO cl_gui_container .
    DATA gs_splitter_symbol TYPE REF TO cl_gui_splitter_container .
    DATA gs_splitter_symbol_toolbar TYPE REF TO cl_gui_splitter_container .
    DATA gc_symbol_alv TYPE REF TO cl_gui_alv_grid .
    DATA gc_symbol_toolbar TYPE REF TO cl_gui_toolbar .
    DATA gc_symbol_toolbar_img TYPE REF TO cl_gui_picture .
    DATA user_settings TYPE REF TO /cadaxo/sqlcusrp_dyn .
    DATA gt_symbol_ow TYPE /cadaxo/sqlc_symbol_ow_t .
    DATA gr_alv_symb_ow TYPE REF TO cl_gui_alv_grid .
    DATA gr_cc_alv_symb_ow TYPE REF TO cl_gui_custom_container .
    CLASS-DATA gt_used_symbols TYPE /cadaxo/sqlcusedsymbols_t .

    METHODS set_symbol_alv .
    METHODS save_symbols
      EXPORTING
        !e_success TYPE boolean .
    METHODS get_symbols_selected
      EXPORTING
        VALUE(e_success) TYPE boolean .
    METHODS focus_symbol_alv_cell
      IMPORTING
        !i_row_id     TYPE lvc_index
        !i_field_name TYPE lvc_fname .
    METHODS on_toolbar_function_selected
      FOR EVENT function_selected OF cl_gui_toolbar
      IMPORTING
        !fcode .
    METHODS confirm_symbol_overwrite .
    METHODS on_symbol_button_variant
      FOR EVENT button_click OF cl_gui_alv_grid
      IMPORTING
        !es_col_id
        !es_row_no .
    METHODS on_handle_varsym_click
      FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
        !e_row_id
        !e_column_id
        !es_row_no .
    METHODS show_symbolmulti_dialog
      IMPORTING
        !i_symbol_multivalue  TYPE /cadaxo/sqlcsymbol_multivalue
        !i_symbol_datatype    TYPE /cadaxo/sqlcsymbol_datatype
        !i_symbol_name        TYPE /cadaxo/sqlcsymbol_name
      RETURNING
        VALUE(r_symbol_value) TYPE rseloption
      RAISING
        /cadaxo/cx_sqlc_symb_not_found .
    METHODS on_symbol_button_click
      FOR EVENT button_click OF cl_gui_alv_grid
      IMPORTING
        !es_col_id
        !es_row_no .
    METHODS delete_symbols
      EXPORTING
        !e_success TYPE boolean .
    METHODS delete_symbol_db
      RETURNING
        VALUE(rv_success) TYPE boolean .
    METHODS update_symbol_db
      IMPORTING
        VALUE(it_symbol_update) TYPE t_symbol_db
      RETURNING
        VALUE(rv_success)       TYPE boolean .
    METHODS check_symbol_value_valid
      IMPORTING
        !is_symbol_line TYPE /cadaxo/sqlc_symbol
      RAISING
        /cadaxo/cx_sqlc_invalid_value .
    METHODS get_user_symbol_count
      IMPORTING
        !i_symbol_multivalue TYPE /cadaxo/sqlcsymbol_multivalue
      RETURNING
        VALUE(r_count)       TYPE i .
    METHODS get_symbols .
    METHODS on_symbol_menu_button
      FOR EVENT menu_button OF cl_gui_alv_grid
      IMPORTING
        !e_object
        !e_ucomm .
    METHODS on_symbol_drag
      FOR EVENT ondrag OF cl_gui_alv_grid
      IMPORTING
        !e_row
        !e_column
        !es_row_no
        !e_dragdropobj .
    METHODS on_symbol_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
        !e_row
        !e_column
        !es_row_no .
    METHODS on_symbol_alv_toolbar
      FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
        !e_object
        !e_interactive .
    METHODS on_symbol_alv_data_change
      FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING
        !er_data_changed
        !e_onf4
        !e_onf4_before
        !e_onf4_after
        !e_ucomm .
    METHODS on_symbol_alv_data_changed_fin
      FOR EVENT data_changed_finished OF cl_gui_alv_grid
      IMPORTING
        !e_modified
        !et_good_cells .
    METHODS fill_used_symbols
      RETURNING
        VALUE(rt_symbols) TYPE /cadaxo/sqlcusedsymbols_t .
    METHODS get_symbol_datatype_desc
      IMPORTING
        !i_datatype   TYPE /cadaxo/sqlcsymbol_datatype
      RETURNING
        VALUE(r_desc) TYPE as4text .
    METHODS get_symbol_datatype_info
      IMPORTING
        !i_datatype   TYPE /cadaxo/sqlcsymbol_datatype
      RETURNING
        VALUE(r_info) TYPE /cadaxo/sqlcsymbol_datainfo .
    METHODS check_symbol_datatype
      IMPORTING
        !i_value TYPE lvc_value
      RAISING
        /cadaxo/cx_sqlc_symb_not_found .
    METHODS on_symbol_alv_user_command
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
        !e_ucomm .
    METHODS create_symbol_multival_tab_dyn
      IMPORTING
        !i_symbol_datatype TYPE /cadaxo/sqlcsymbol_datatype
      EXPORTING
        !e_data            TYPE data
        !e_data_struct     TYPE data .
    METHODS refresh_symbol_alv .
    METHODS mark_cell_when_error
      IMPORTING
                i_row_id             TYPE int4
                i_fieldname          TYPE lvc_fname
                i_msgid              TYPE symsgid
                i_msgno              TYPE symsgno
                i_msgty              TYPE symsgty
                i_msgv1              TYPE any OPTIONAL
                i_msgv2              TYPE any OPTIONAL
                i_msgv3              TYPE any OPTIONAL
                i_msgv4              TYPE any OPTIONAL
      CHANGING  VALUE(ct_cell_style) TYPE lvc_t_styl.
    METHODS mark_symbol_alv_cell_error
      IMPORTING
        i_row_id     TYPE lvc_index
        i_field_name TYPE lvc_fname
        i_msgid      TYPE symsgid
        i_msgno      TYPE symsgno
        i_msgty      TYPE symsgty
        i_msgv1      TYPE any OPTIONAL
      CHANGING
        ct_cell_msg  TYPE lvc_t_msg.


    CONSTANTS: BEGIN OF functions,
                 symbol_delete TYPE string VALUE 'SYMBOL_DELETE',
               END OF functions.
    DATA: symbol_alv_error TYPE bapiret2.
ENDCLASS.



CLASS /cadaxo/cl_sqlc_symbols IMPLEMENTATION.


  METHOD check_changed_data.
    gc_symbol_alv->check_changed_data(  ).
  ENDMETHOD.


  METHOD check_symbol_datatype.

    DATA ls_dd04l TYPE dd04l.

    SELECT SINGLE datatype, leng FROM dd04l
      INTO CORRESPONDING FIELDS OF @ls_dd04l
      WHERE rollname = @i_value. "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED

    IF sy-subrc = 0.

      IF ls_dd04l-datatype = 'FLTP' OR
         ls_dd04l-datatype = 'STRG' OR
         ls_dd04l-datatype = 'RAWSTRING'.

        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found
          EXPORTING
            textid              = /cadaxo/cx_sqlc_symb_not_found=>datatype_not_allowed
            /cadaxo/datatype    = CONV #( ls_dd04l-datatype )
            /cadaxo/dataelement = CONV #( i_value ).

      ENDIF.

      IF ls_dd04l-leng > 45.

        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found
          EXPORTING
            textid = /cadaxo/cx_sqlc_symb_not_found=>dataelement_longer_than_45.

      ENDIF.

    ELSE.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found
        EXPORTING
          textid              = /cadaxo/cx_sqlc_symb_not_found=>dataelement_not_found
          /cadaxo/dataelement = CONV #( i_value ).

    ENDIF.

  ENDMETHOD.


  METHOD check_symbol_value_valid.

    CONSTANTS: lc_allowed TYPE string VALUE ''' `Ã‚Â´'.
    DATA(lv_symbol_value) = CONV string( is_symbol_line-symbol_value ).
    /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = lv_symbol_value ).

    IF /cadaxo/cl_sqlc_cockpit_assist=>has_code_open_literal( iv_abap_code = lv_symbol_value ).

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value
        EXPORTING
          textid = /cadaxo/cx_sqlc_invalid_value=>open_literal.

    ENDIF.

    IF lv_symbol_value CN lc_allowed AND is_symbol_line-symbol_multivalue IS INITIAL.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value
        EXPORTING
          textid = /cadaxo/cx_sqlc_invalid_value=>too_much_literals.

    ENDIF.

  ENDMETHOD.


  METHOD confirm_symbol_overwrite.
    DATA: popup_size TYPE ty_popup_size.
    popup_size-column = 10.
    popup_size-row = ( sy-srows / 2 ) - 10.
    popup_size-column_to = popup_size-column + 119.
    popup_size-row_to = popup_size-row + 11.

    IF popup_size-column < 1.
      popup_size-column = 1.
    ENDIF.
    IF popup_size-row < 1.
      popup_size-row = 1.
    ENDIF.

    PERFORM confirm_symbol_overwrite
            IN PROGRAM /cadaxo/sqlc_main
            USING popup_size
            IF FOUND.

  ENDMETHOD.


  METHOD constructor.
    me->user_settings = i_user_settings.
    me->main_controller = i_main.
  ENDMETHOD.


  METHOD create_symbol_db.

    IF NOT it_symbol_create IS INITIAL.

      INSERT /cadaxo/sqlcusym FROM TABLE it_symbol_create.
      IF sy-subrc = 0.

        rv_success = 'X'.

      ELSE.

        ROLLBACK WORK.
        MESSAGE s055(/cadaxo/sqlc) WITH TEXT-dec.                      "CDX001-0020
        RETURN.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD create_symbol_from_result.
    DATA gui_control     TYPE REF TO cl_gui_control.
    DATA gui_alv_grid    TYPE REF TO cl_gui_alv_grid.
    DATA selected_col    TYPE lvc_s_col.
    DATA dref_field      TYPE REF TO data.
    DATA sel_field_val_string TYPE string.

    FIELD-SYMBOLS:
      <result_tab>         TYPE STANDARD TABLE,
      <result_line>        TYPE any,
      <selected_field_val> TYPE any,
      <selected_field_tab> TYPE STANDARD TABLE,
*      <dref_line>          TYPE REF TO data,
      <result_field>       TYPE any.

    cl_gui_alv_grid=>get_focus( IMPORTING control = gui_control ).

    TRY.
        gui_alv_grid ?= gui_control.
        gui_alv_grid->get_current_cell( IMPORTING es_col_id = selected_col ).
      CATCH cx_sy_move_cast_error.
    ENDTRY.

    ASSIGN i_result_data->* TO <result_tab>.

    TRY.
        DATA(result_ddfield) = i_result_fieldcat[ fieldname = selected_col-fieldname ].
      CATCH cx_sy_itab_line_not_found.
        MESSAGE i142(/cadaxo/sqlc).
        RETURN.
    ENDTRY.
    IF result_ddfield-rollname IS INITIAL.
      MESSAGE i141(/cadaxo/sqlc).
      RETURN.
    ENDIF.
    CREATE DATA dref_field TYPE TABLE OF (result_ddfield-rollname).
    ASSIGN dref_field->* TO <selected_field_tab>.

    LOOP AT <result_tab> ASSIGNING <result_line>.
      ASSIGN COMPONENT selected_col-fieldname OF STRUCTURE <result_line> TO <selected_field_val>.
      sel_field_val_string = <selected_field_val>.
      IF strlen( sel_field_val_string ) > 45.
        MESSAGE i148(/cadaxo/sqlc).
        RETURN.
      ENDIF.
      APPEND <selected_field_val> TO <selected_field_tab>.
    ENDLOOP.

    CALL FUNCTION '/CADAXO/SQLC_CREATE_SYMBOL'
      EXPORTING
        iv_rollname      = result_ddfield-rollname
        it_symbol_values = <selected_field_tab>.

    me->get_symbols( ).
    me->refresh_symbol_alv( ).

  ENDMETHOD.


  METHOD create_symbol_multival_tab_dyn.
    DATA lt_comp TYPE abap_component_tab.
    DATA ls_comp TYPE abap_componentdescr.
    DATA lr_abap_elem TYPE REF TO cl_abap_elemdescr.
    DATA lr_struct TYPE REF TO cl_abap_structdescr.
    DATA lr_table TYPE REF TO cl_abap_tabledescr.

    lr_abap_elem ?= cl_abap_elemdescr=>describe_by_name(
      EXPORTING
        p_name         = 'TVARV_SIGN'
    ).
    ls_comp-name = 'SIGN'.
    ls_comp-type = lr_abap_elem.
    APPEND ls_comp TO lt_comp.

    lr_abap_elem ?= cl_abap_elemdescr=>describe_by_name(
      EXPORTING
        p_name         = 'TVARV_OPTI'
    ).
    ls_comp-name = 'OPTION'.
    ls_comp-type = lr_abap_elem.
    APPEND ls_comp TO lt_comp.

    lr_abap_elem ?= cl_abap_elemdescr=>describe_by_name(
      EXPORTING
        p_name         = i_symbol_datatype
    ).

    ls_comp-name = 'LOW'.
    ls_comp-type = lr_abap_elem.
    APPEND ls_comp TO lt_comp.

    ls_comp-name = 'HIGH'.
    ls_comp-type = lr_abap_elem.
    APPEND ls_comp TO lt_comp.

    cl_abap_structdescr=>create(
      EXPORTING
        p_components          = lt_comp
      RECEIVING
        p_result              = lr_struct
    ).

    lr_table = cl_abap_tabledescr=>create(
      EXPORTING
        p_line_type          = lr_struct ).

    CREATE DATA e_data_struct TYPE HANDLE lr_struct.
    CREATE DATA e_data TYPE HANDLE lr_table.
  ENDMETHOD.


  METHOD create_symbol_ui_control.
****************************************************************************************************
* Description             : Create symbol ui control                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | Sort global/user                            | CDX001-0020    *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Move Symbol Window to hide Editor Area      | CR22-033       *
*            |                      | (for Auditors)                              | Clocking4720   *
*------------+----------------------+---------------------------------------------+----------------*
* 01.02.2017 | Dusan Sacha          | Added new splitter + vertical image         |                *
*------------+----------------------+---------------------------------------------+----------------*
* 31.07.2017 | Dusan Sacha          |  Symbol Multi Value                         | COCKPIT-240    *
****************************************************************************************************


    DATA lt_events TYPE cntl_simple_events.
    DATA ls_button_data TYPE stb_button.
    DATA ls_lvc_layo TYPE lvc_s_layo.
    DATA lt_fieldcat TYPE slis_t_fieldcat_alv.
    DATA lt_lvc_fcat TYPE lvc_t_fcat.
    DATA ls_lvc_fcat TYPE lvc_s_fcat.
    DATA lv_image_url(255).
    DATA query_table TYPE TABLE OF w3query.
    DATA s_query_table LIKE LINE OF query_table.
    DATA html_table TYPE TABLE OF w3html.
    DATA return_code TYPE w3param-ret_code.
    DATA content_type TYPE  w3param-cont_type.
    DATA content_length TYPE  w3param-cont_len.
    DATA pic_data TYPE TABLE OF w3mime.
    DATA pic_size TYPE i.

    FIELD-SYMBOLS: <l_fieldcat>    TYPE slis_fieldcat_alv,
                   <l_cont_symbol> TYPE /cadaxo/sqlcclguicontainer.

* get symbol container
    gcont_symbol = i_container.
    gcont_symbol->set_name( 'GCONT_SYMBOL' ).

* create splitter (ALV & toolbar)
    gs_splitter_symbol = NEW #( parent  = gcont_symbol
                                rows    = 1
                                columns = 2 ).
    gs_splitter_symbol->set_name( 'GS_SPLITTER_SYMBOL' ).
    gs_splitter_symbol->set_column_mode( 0 ).
    gs_splitter_symbol->set_column_width( id = 1 width = /cadaxo/cl_sqlc_cockpit_main=>toolbar_col_width ).
    gs_splitter_symbol->set_column_sash( id = 1 type = 1 value = gs_splitter_symbol->false  ).

    gcont_symbol_toolbar = gs_splitter_symbol->get_container( row = 1 column = 1 ).

    DATA(parent_splitter) = CAST cl_gui_splitter_container( gcont_symbol->parent ).
    parent_splitter->set_column_mode( 0 ).

* If User has no change rights in editor (e.g. is an auditor) symbol window is "hiding" editor area
    AUTHORITY-CHECK OBJECT 'ZCADXOSQ01' ID 'ACTVT' FIELD '16'.                       "CR22-033
    IF sy-subrc = 0.                                                                "CR22-033
      AUTHORITY-CHECK OBJECT 'ZCADXOSQ01' ID 'ACTVT' FIELD '23'.                     "CR22-033
      IF sy-subrc = 4.                                                              "CR22-033
        parent_splitter->set_column_width( id = 2 width = 3000 ).                    "CR22-033
      ELSE.                                                                          "CR22-033
        IF me->user_settings->symbols_show = abap_true.                             "CDX001-0020
          parent_splitter->set_column_width( id = 2 width = /cadaxo/cl_sqlc_cockpit_main=>c_width_right_symbols ). "Default open
        ELSE.                                                                        "CDX001-0020
          parent_splitter->set_column_width( id = 2 width = /cadaxo/cl_sqlc_cockpit_main=>toolbar_col_width )."Default closed     "CDX001-0020
        ENDIF.                                                                       "CDX001-0020
      ENDIF.
    ENDIF.

* splitter in toolbar
    gs_splitter_symbol_toolbar = NEW #( parent  = gcont_symbol_toolbar
                                        rows    = 2
                                        columns = 1 ).

    gs_splitter_symbol_toolbar->set_row_height( EXPORTING  id     = 1
                                                           height = /cadaxo/cl_sqlc_cockpit_main=>toolbar_row_height
                                                EXCEPTIONS OTHERS = 1 ).

    gs_splitter_symbol_toolbar->set_row_sash(
      id    = 1
      type  = gs_splitter_symbol_toolbar->type_movable
      value = gs_splitter_symbol_toolbar->false ).

    gs_splitter_symbol_toolbar->set_row_sash(
      id    = 1
      type  = gs_splitter_symbol_toolbar->type_sashvisible
      value = gs_splitter_symbol_toolbar->false ).

    gcont_symbol_toolbar_btns = gs_splitter_symbol_toolbar->get_container( row = 1 column = 1 ).
    gcont_symbol_toolbar_img = gs_splitter_symbol_toolbar->get_container( row = 2 column = 1 ).

    gc_symbol_toolbar = NEW #( parent       = gcont_symbol_toolbar_btns
                               display_mode = cl_gui_toolbar=>m_mode_vertical ).

* create control toolbar img
    gc_symbol_toolbar_img = NEW #( parent = gcont_symbol_toolbar_img ).

* load sidebar image
    s_query_table-name = '_OBJECT_ID'.

    IF ( sy-langu = 'D' ).
      s_query_table-value = '/CADAXO/SQLC_SIDEBAR_IMG_SYMBOLS_DE'.
    ELSE.
      s_query_table-value = '/CADAXO/SQLC_SIDEBAR_IMG_SYMBOLS'.
    ENDIF.

    APPEND s_query_table TO query_table.

* load sidebar image data
    CALL FUNCTION 'WWW_GET_MIME_OBJECT'
      TABLES
        query_string   = query_table
        html           = html_table
        mime           = pic_data
      CHANGING
        return_code    = return_code
        content_type   = content_type
        content_length = content_length
      EXCEPTIONS
        OTHERS         = 3.
    IF sy-subrc = 0.
      pic_size = content_length.
    ENDIF.

* create sidebar image url
    CLEAR lv_image_url.
    CALL FUNCTION 'DP_CREATE_URL'
      EXPORTING
        ##NO_TEXT
        type     = 'image'
        subtype  = cndp_sap_tab_unknown
        size     = pic_size
        lifetime = cndp_lifetime_transaction
      TABLES
        data     = pic_data
      CHANGING
        url      = lv_image_url
      EXCEPTIONS
        OTHERS   = 1.

* insert picture url to toolbar
    gc_symbol_toolbar_img->load_picture_from_url( lv_image_url ).

    lt_events = VALUE #( ( eventid = cl_gui_toolbar=>m_id_function_selected appl_event = abap_false ) ).

    gc_symbol_toolbar->set_registered_events( lt_events ).
    SET HANDLER me->on_toolbar_function_selected FOR gc_symbol_toolbar.

* add button symbols show/hide
    gc_symbol_toolbar->add_button_group( VALUE #( ( function = c_okcode_symbols
                                                    butn_type = cntb_btype_button ) ) ).
    set_symbol_alv( ).

    IF dragdrop_behaviour_symbol IS INITIAL.
*   create drag/drop behaviour
      dragdrop_behaviour_symbol = NEW #( ).
      dragdrop_behaviour_symbol->add( flavor     = 'SYMBOL_TO_EDITOR'
                                      dragsrc    = abap_true
                                      droptarget = abap_false
                                      effect     = cl_dragdrop=>copy ).
      dragdrop_behaviour_symbol->get_handle( IMPORTING handle = dragdrop_handle_symbol ).

    ENDIF.


    ls_lvc_layo = VALUE #( zebra      = abap_true
                           cwidth_opt = abap_true
                           sel_mode   = 'A'
                           stylefname = 'CELL_STYLE'
                            ).

* build field catalog
    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = '/CADAXO/SQLC_SYMBOL'
      CHANGING
        ct_fieldcat      = lt_fieldcat
      EXCEPTIONS
        OTHERS           = 1.
    IF sy-subrc = 0.
      LOOP AT lt_fieldcat ASSIGNING <l_fieldcat>.
        CLEAR: ls_lvc_fcat.
        ls_lvc_fcat = CORRESPONDING #( <l_fieldcat> MAPPING scrtext_m = seltext_m scrtext_l = seltext_l scrtext_s = seltext_s ).
        CASE <l_fieldcat>-fieldname.
          WHEN 'SYMBOL_NAME'.
            ls_lvc_fcat-key = abap_true.
            ls_lvc_fcat-dragdropid = dragdrop_handle_symbol.
          WHEN 'SYMBOL_MULTIVALUE'.                                "COCKPIT-240
            ls_lvc_fcat-no_out = abap_true.                        "COCKPIT-240
            ls_lvc_fcat-tech   = abap_true.                        "COCKPIT-240
          WHEN 'TYPE' OR 'USED_IN_EDITOR'.                         "CR22-033
            ls_lvc_fcat-no_out = abap_true.
            ls_lvc_fcat-tech   = abap_true.
          WHEN 'SYMBOL_ICON'.
            ls_lvc_fcat-key     = abap_true.                       "COCKPIT-240
            ls_lvc_fcat-col_pos = 1.                               "CDX001-0020   COCKPIT-240
          WHEN 'SYMBOL_DATATYPE'.
            ls_lvc_fcat-f4availabl = abap_true.                    "COCKPIT-240
            ls_lvc_fcat-ref_table  = 'DD04L'.                      "COCKPIT-240
            ls_lvc_fcat-ref_field  = 'ROLLNAME'.                   "COCKPIT-240
        ENDCASE.
        APPEND ls_lvc_fcat TO lt_lvc_fcat.
      ENDLOOP.
    ELSE.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.

* Create container and grid
    APPEND INITIAL LINE TO gcont_grid_symbol_t ASSIGNING <l_cont_symbol>.

    <l_cont_symbol>-gui_container = gs_splitter_symbol->get_container( EXPORTING row = 1 column = 2 ).

    <l_cont_symbol>-gui_container->set_name( 'CONTAINER_SYMBOL' ).

    gc_symbol_alv = NEW #( i_parent = <l_cont_symbol>-gui_container i_applogparent = i_appllog_container ).

    gc_symbol_alv->set_ready_for_input( i_ready_for_input = 1 ). "CDX PERFORMANCE

* Exlcude Symbol Toolbar Buttons
    IF me->g_symbol_toolbar_excluding IS INITIAL.

      APPEND cl_gui_alv_grid=>mc_mb_variant           TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_mb_subtot            TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_mb_sum               TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_print             TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_views             TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_mb_export            TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_graph             TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_info              TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_help              TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_check             TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row    TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_refresh           TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_append_row    TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_copy          TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row      TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_cut           TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row    TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row    TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_move_row      TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_paste         TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_undo          TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_sort              TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_sort_asc          TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_sort_dsc          TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_detail            TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_find              TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_find_more         TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_filter            TO me->g_symbol_toolbar_excluding.
    ENDIF.

* Get user and program symbols
    me->get_symbols( ).
* Set handler
    SET HANDLER: me->on_symbol_drag               FOR gc_symbol_alv.
    SET HANDLER: me->on_symbol_button_click       FOR gc_symbol_alv.     "COCKPIT-204
    SET HANDLER: me->on_symbol_double_click       FOR gc_symbol_alv.
    SET HANDLER: me->on_symbol_alv_data_change    FOR gc_symbol_alv.
    SET HANDLER: me->on_symbol_alv_toolbar        FOR gc_symbol_alv.
    SET HANDLER: me->on_symbol_alv_user_command   FOR gc_symbol_alv.
    SET HANDLER  me->on_symbol_alv_data_changed_fin FOR gc_symbol_alv.                "CDX001-0020
    SET HANDLER  me->on_symbol_menu_button        FOR gc_symbol_alv.  "+  Cockpit-420
    gc_symbol_alv->register_edit_event( i_event_id = gc_symbol_alv->mc_evt_modified )."CDX001-0020

    gc_symbol_alv->set_table_for_first_display( EXPORTING  i_bypassing_buffer   = abap_true "abap_false
                                                           is_layout            = ls_lvc_layo
                                                           it_toolbar_excluding = me->g_symbol_toolbar_excluding
                                                CHANGING   it_outtab            = gt_symbol
                                                           it_fieldcatalog      = lt_lvc_fcat
                                                EXCEPTIONS OTHERS               = 1 ).
    IF sy-subrc <> 0.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.

    "    gc_symbol_alv->set_ready_for_input( i_ready_for_input = 1 ). "CDX PERFORMANCE

  ENDMETHOD.


  METHOD delete_symbols.
****************************************************************************************************
* Description             : delete user symbols                                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | I18N Messages                               | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lt_index_rows TYPE lvc_t_row,
          ls_index_row  LIKE LINE OF lt_index_rows.

    DATA ls_symbol LIKE LINE OF gt_symbol.
    DATA: lt_delete_rows_index TYPE TABLE OF i,
          ld_index             TYPE i.

* get selected records
    gc_symbol_alv->get_selected_rows( IMPORTING et_index_rows = lt_index_rows ).
    LOOP AT lt_index_rows INTO ls_index_row.

      READ TABLE gt_symbol INDEX ls_index_row-index
                           INTO ls_symbol
                           TRANSPORTING symbol_name
                                        type.
      IF sy-subrc = 0.
*     delete program symbol not allowed
        IF ls_symbol-type = cs_symbol_type-program.

          REFRESH gt_symbol_delete.
*       focus the record
          me->focus_symbol_alv_cell( i_row_id     = ls_index_row-index
                                     i_field_name = 'SYMBOL_NAME' ).

          MESSAGE s057(/cadaxo/sqlc) DISPLAY LIKE 'E'.               "CDX001-0020
          RETURN.

        ENDIF.
*     Exclude create symbols
        IF NOT ls_symbol-type = cs_symbol_type-create.
          APPEND ls_symbol TO gt_symbol_delete.
        ENDIF.

        ld_index = ls_index_row-index.
        APPEND ld_index TO lt_delete_rows_index.

      ENDIF.

    ENDLOOP.

* delete records on ALV
    SORT lt_delete_rows_index DESCENDING.
    LOOP AT lt_delete_rows_index INTO ld_index.

      DELETE gt_symbol INDEX ld_index.

    ENDLOOP.

    e_success = abap_true.

    me->on_symbol_alv_user_command( e_ucomm = 'SYMBOL_SAVE' ).                   "CDX001-0020


  ENDMETHOD.


  METHOD delete_symbol_db.

    DATA lt_symbol_db_delete TYPE TABLE OF /cadaxo/sqlcusym.

    DATA l_symbol    LIKE LINE OF gt_symbol[].
    DATA l_symbol_db LIKE LINE OF lt_symbol_db_delete.

    IF NOT gt_symbol_delete IS INITIAL.

      LOOP AT gt_symbol_delete INTO l_symbol.

        MOVE-CORRESPONDING l_symbol TO l_symbol_db.
        l_symbol_db-username = sy-uname.
        APPEND l_symbol_db TO lt_symbol_db_delete.

      ENDLOOP.

      REFRESH gt_symbol_delete.

      DELETE /cadaxo/sqlcusym FROM TABLE lt_symbol_db_delete.
      IF sy-subrc = 0.

        rv_success = abap_true.

      ELSE.

        ROLLBACK WORK.
        MESSAGE s055(/cadaxo/sqlc) WITH TEXT-ded DISPLAY LIKE 'E'."CDX001-0020
        RETURN.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_used_symbols.

    DATA: lt_results    TYPE match_result_tab.
    FIELD-SYMBOLS: <ls_result> LIKE LINE OF lt_results.

    DATA(lv_sql_string) = main_controller->get_sql_area(  ).

    /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex( EXPORTING i_where_syntax = lv_sql_string
                                                       IMPORTING e_result_tab   = lt_results ).

    LOOP AT lt_results ASSIGNING <ls_result>.

      DATA(l_from) = <ls_result>-offset + 1.
      DATA(l_length) = <ls_result>-length - 2.

      DATA(l_symbol_name) = lv_sql_string+l_from(l_length).
      APPEND to_upper( l_symbol_name ) TO rt_symbols.

    ENDLOOP.

  ENDMETHOD.


  METHOD focus_symbol_alv_cell.
****************************************************************************************************
* Description             : focus symbol alv cell                                                  *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_row_id    TYPE lvc_s_row,
          l_column_id TYPE lvc_s_col,
          l_row_no    TYPE lvc_s_roid.

    l_row_id-index        = i_row_id.
    l_column_id-fieldname = i_field_name.
    l_row_no-row_id       = i_row_id.

    CALL METHOD gc_symbol_alv->set_current_cell_via_id
      EXPORTING
        is_row_id    = l_row_id
        is_column_id = l_column_id
        is_row_no    = l_row_no.


  ENDMETHOD.


  METHOD get_symbols.
****************************************************************************************************
* Description             : Get symbols                                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | Sort global/user                            | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
*------------+----------------------+---------------------------------------------+----------------*
* 31.07.2017 | Dusan Sacha          | Symbol Multi Value                          | COCKPIT-240    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA ls_symbol LIKE LINE OF gt_symbol.
    DATA lt_program_symbol TYPE TABLE OF /cadaxo/sqlcsymb.
    DATA ls_celltab TYPE lvc_s_styl.
    DATA lt_user_symbol LIKE gt_symbol[].
    DATA lv_tabix TYPE i.
    DATA: i_values_count TYPE i.           "COCKPIT-240
    DATA: lv_symbol_enabled TYPE raw4.     "COCKPIT-240
    DATA: lv_datatype_enabled TYPE raw4.   "COCKPIT-240

    FIELD-SYMBOLS <ls_user_symbol> LIKE LINE OF lt_user_symbol.

* For Used Symbols
    " DATA lt_symbol       LIKE gt_symbol.                      "CR22-002

    REFRESH gt_symbol.

* Get user symbols(user dependent)
    SELECT symbol_name
           symbol_value
           symbol_desc
           symbol_multivalue                                              "COCKPIT-240
           symbol_datatype                                                "COCKPIT-240
           FROM /cadaxo/sqlcusym
             INTO CORRESPONDING FIELDS OF TABLE lt_user_symbol
             WHERE username = sy-uname.
*             ORDER BY symbol_name.                                          "COCKPIT-240 "COCKPIT-403
    IF sy-subrc = 0.
      SORT lt_user_symbol BY symbol_name."COCKPIT-403
      LOOP AT lt_user_symbol ASSIGNING <ls_user_symbol>.

        "     Get Multi Values Count
        i_values_count = get_user_symbol_count( i_symbol_multivalue = <ls_user_symbol>-symbol_multivalue ). "COCKPIT-240
        lv_datatype_enabled = cl_gui_alv_grid=>mc_style_enabled.                                            "COCKPIT-240
        "     Get Icon
        IF ( <ls_user_symbol>-symbol_multivalue IS NOT INITIAL ).                    "COCKPIT-240
          <ls_user_symbol>-symbol_icon = '@3W@'.                                     "COCKPIT-240
          lv_symbol_enabled = cl_gui_alv_grid=>mc_style_disabled.                    "COCKPIT-240
          <ls_user_symbol>-symbol_value = '<' && i_values_count &&' VALUES' && '>'.  "COCKPIT-240
          IF i_values_count > 0.                                                     "COCKPIT-240
            lv_datatype_enabled = cl_gui_alv_grid=>mc_style_disabled.                "COCKPIT-240
          ENDIF.                                                                     "COCKPIT-240
        ELSE.                                                                        "COCKPIT-240
          <ls_user_symbol>-symbol_icon = '@7L@'.                                     "COCKPIT-240
          lv_symbol_enabled = cl_gui_alv_grid=>mc_style_enabled.                     "COCKPIT-240
        ENDIF.                                                                       "COCKPIT-240

        "     Get Data Element Info
        IF ( <ls_user_symbol>-symbol_datatype IS NOT INITIAL ).
          <ls_user_symbol>-symbol_datadesc = me->get_symbol_datatype_desc( i_datatype = <ls_user_symbol>-symbol_datatype ).
          <ls_user_symbol>-symbol_datainfo = me->get_symbol_datatype_info( i_datatype = <ls_user_symbol>-symbol_datatype ).
        ENDIF.

        <ls_user_symbol>-type = cs_symbol_type-user.
*     Editable for fields value and desc.
        ls_celltab-fieldname = 'SYMBOL_NAME'.
        ls_celltab-style = cl_gui_alv_grid=>mc_style_disabled.
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.
        ls_celltab-fieldname = 'SYMBOL_ICON'.                         "COCKPIT-240
        ls_celltab-style = cl_gui_alv_grid=>mc_style_button.          "COCKPIT-240
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.     "COCKPIT-240
        ls_celltab-fieldname = 'SYMBOL_VALUE'.                        "COCKPIT-240
        ls_celltab-style = lv_symbol_enabled.                         "COCKPIT-240
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.
        ls_celltab-fieldname = 'SYMBOL_DESC'.
        ls_celltab-style = cl_gui_alv_grid=>mc_style_enabled.
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.
        ls_celltab-fieldname = 'SYMBOL_DATATYPE'.                     "COCKPIT-240
        ls_celltab-style = lv_datatype_enabled.                       "COCKPIT-240
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.     "COCKPIT-240

      ENDLOOP.

      APPEND LINES OF lt_user_symbol TO gt_symbol.

    ENDIF.


    IF me->user_settings->symbols_program_show = c_program_symbols-show.
      TRY.
*     Get program symbols
          SELECT symbol symbol_descr
                 FROM /cadaxo/sqlcsymb
                 INTO CORRESPONDING FIELDS OF TABLE lt_program_symbol.
          LOOP AT lt_program_symbol ASSIGNING FIELD-SYMBOL(<ls_program_symbol>).

            ls_symbol-symbol_name = <ls_program_symbol>-symbol.

            /cadaxo/cl_sqlc_cockpit_assist=>get_global_symbol_value( EXPORTING i_symbol       = <ls_program_symbol>-symbol
                                                                     IMPORTING e_symbol_value = ls_symbol-symbol_value ).
            ls_symbol-symbol_desc = <ls_program_symbol>-symbol_descr.
            ls_symbol-type = cs_symbol_type-program.

            ls_celltab-fieldname = 'SYMBOL_NAME'.
            ls_celltab-style = cl_gui_alv_grid=>mc_style_disabled.
            INSERT ls_celltab INTO TABLE ls_symbol-cell_style.
            ls_celltab-fieldname = 'SYMBOL_VALUE'.
            ls_celltab-style = cl_gui_alv_grid=>mc_style_disabled.
            INSERT ls_celltab INTO TABLE ls_symbol-cell_style.
            ls_celltab-fieldname = 'SYMBOL_DESC'.
            ls_celltab-style = cl_gui_alv_grid=>mc_style_disabled.
            INSERT ls_celltab INTO TABLE ls_symbol-cell_style.

            APPEND ls_symbol TO gt_symbol.

            CLEAR ls_symbol.

          ENDLOOP.

        CATCH /cadaxo/cx_sqlc_symb_not_found .

      ENDTRY.
    ENDIF.                                                             "CDX001-0020

    IF me->user_settings->only_used_symbols = abap_true.               "CR22-002
      IF   gt_used_symbols IS NOT INITIAL.
        DATA(lt_used_symbols) = gt_used_symbols.
      ELSE.
        lt_used_symbols = me->fill_used_symbols( ).
      ENDIF.
      SORT lt_used_symbols.
* end of insert Cockpit-431
      LOOP AT gt_symbol INTO ls_symbol.                       "CR22-002
        lv_tabix = sy-tabix.                                  "CR22-002
        READ TABLE lt_used_symbols FROM ls_symbol-symbol_name TRANSPORTING NO FIELDS. "CR22-002"+Cockpit-431
        IF sy-subrc <> 0.                                     "CR22-002
          DELETE gt_symbol INDEX lv_tabix.                    "CR22-002
        ENDIF.                                                "CR22-002
      ENDLOOP.                                                "CR22-002
    ENDIF.                                                    "CR22-002

  ENDMETHOD.


  METHOD get_symbols_selected.
****************************************************************************************************
* Description             : get_symbols_selected                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Pat Patil                Company    : CADAXO GesmbH                    *
* Date                    : 26.01.2018               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 26.01.2018 |Pat                   |select symbols for export                    |COCKPIT-294     *
*------------+----------------------+---------------------------------------------+----------------*
* 22.10.2019 |Pat                   |Symbol Sharing should work exactly for one   |COCKPIT-418     *
*                                    selection                                                     *
*------------+----------------------+---------------------------------------------+----------------*

    CLEAR gt_symbol_selected.

* get selected records
    gc_symbol_alv->get_selected_rows( IMPORTING et_index_rows = DATA(lt_index_rows) ).
    IF lines( lt_index_rows ) > 1."cockpit-418
      MESSAGE s131(/cadaxo/sqlc) DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    IF lt_index_rows IS INITIAL.
      gc_symbol_alv->get_current_cell( IMPORTING es_row_id = DATA(ls_row_info) ).
      APPEND ls_row_info TO lt_index_rows.
    ENDIF.
    LOOP AT lt_index_rows ASSIGNING FIELD-SYMBOL(<index_row>).

      READ TABLE gt_symbol INDEX <index_row>-index
                           ASSIGNING FIELD-SYMBOL(<symbol>).
      IF sy-subrc = 0.

*     program symbol not allowed
        IF <symbol>-type = cs_symbol_type-program.

*       focus the record
          me->focus_symbol_alv_cell( i_row_id     = <index_row>-index
                                     i_field_name = 'SYMBOL_NAME' ).

          MESSAGE s132(/cadaxo/sqlc) DISPLAY LIKE 'E'.               "CDX001-0020
          RETURN.

        ENDIF.

        APPEND <symbol> TO gt_symbol_selected.
      ENDIF.

    ENDLOOP.

    IF gt_symbol_selected IS NOT INITIAL.
      e_success = abap_true.
    ELSE.
      MESSAGE s131(/cadaxo/sqlc) DISPLAY LIKE 'E'.               "CDX001-0020
    ENDIF.


  ENDMETHOD.


  METHOD get_symbol_datatype_desc.

    SELECT SINGLE ddtext FROM dd04t
      INTO r_desc
      WHERE rollname   = i_datatype AND
            ddlanguage = sy-langu AND
            as4local   = 'A'.   "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED

  ENDMETHOD.


  METHOD get_symbol_datatype_info.

    DATA: ls_datatype_info TYPE dd04v.
    DATA: lv_info          LIKE r_info.

    CALL FUNCTION 'DDIF_DTEL_GET'
      EXPORTING
        name          = i_datatype
        state         = 'A'
        langu         = sy-langu
      IMPORTING
        dd04v_wa      = ls_datatype_info
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
    ENDIF.

    IF ls_datatype_info-leng IS INITIAL.
      lv_info = to_lower( ls_datatype_info-datatype  ).
    ELSEIF ls_datatype_info-decimals IS INITIAL.
      lv_info = to_lower( ls_datatype_info-datatype  ) && '(' && shift_left( val = ls_datatype_info-leng sub = '0' ) && ')'.
    ELSE.
      lv_info = to_lower( ls_datatype_info-datatype ) && '(' && shift_left( val = ls_datatype_info-leng sub = '0' )
                                                                         && ',' && shift_left( val = ls_datatype_info-decimals sub = '0' ) && ')'.
    ENDIF.

    r_info = lv_info.
  ENDMETHOD.


  METHOD get_user_symbol_count.
    DATA: lt_symbol_value TYPE rseloption.

    IF i_symbol_multivalue IS NOT INITIAL.
      /cadaxo/cl_sqlc_cockpit_assist=>decompress_symbol_multivalue( EXPORTING i_symbol_multivalue = i_symbol_multivalue
                                                                    IMPORTING e_symbol_multivalue = lt_symbol_value       ).
    ENDIF.

    r_count = lines( lt_symbol_value ).

  ENDMETHOD.


  METHOD get_user_symbol_from_sql.
****************************************************************************************************
* Description             : get user symbols from SQL                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 22.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.11.2010 | Domi Bigl            | Symbols for global variant                  | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.05.2012 | Johann Fößleitner    | translate symbolname to upper case          | CDX130-009     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
*------------+----------------------+---------------------------------------------+----------------*
* 20.02.2018 | Dusan Sacha          | Symbol Multivalue Upgrade                   | Cadaxo-288     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA l_symbol LIKE LINE OF e_symbols.

    DATA lt_results TYPE match_result_tab.

    DATA: lt_sql LIKE i_sql[],
          l_sql  LIKE LINE OF lt_sql.

    DATA  l_symbol_name TYPE string.

    DATA  l_count TYPE i.


    FIELD-SYMBOLS: <l_result> LIKE LINE OF lt_results,
                   <l_symbol> LIKE l_symbol.

    REFRESH e_symbols.

    lt_sql[] = i_sql[].
* delete blank line
    DELETE lt_sql WHERE table_line IS INITIAL.

    CLEAR gt_used_symbols.                     "CR22-002

    LOOP AT lt_sql INTO l_sql.

      CLEAR lt_results.

      FIND ALL OCCURRENCES OF REGEX '&(\w|/)+&' IN l_sql RESULTS lt_results.
      IF sy-subrc = 0.

        LOOP AT lt_results ASSIGNING <l_result>.

          MOVE l_sql+<l_result>-offset(<l_result>-length) TO l_symbol_name.
*       delete leading and ending '&'
          REPLACE ALL OCCURRENCES OF '&' IN l_symbol_name WITH space.
          CONDENSE l_symbol_name NO-GAPS.
          TRANSLATE l_symbol_name TO UPPER CASE.                                 "CDX130-009
          l_symbol-symbol_name = l_symbol_name.

* creates list of user_symbols used in the Editor
          APPEND l_symbol_name TO gt_used_symbols.                               "CR22-002

          IF i_type = cs_symbol_type-variant OR i_type IS INITIAL.
            SELECT SINGLE COUNT(*) FROM /cadaxo/sqlcvnsy
                                   INTO l_count
                                   WHERE varguid = i_varguid
                                     AND symbol_name = l_symbol_name.

          ELSE.

            SELECT SINGLE COUNT(*) FROM /cadaxo/sqlcusym
                                  INTO l_count
                                  WHERE symbol_name = l_symbol_name
                                    AND username = sy-uname. "#EC CI_BYPASS

          ENDIF.

          IF l_count = 1.

            CLEAR l_count.

            APPEND l_symbol TO e_symbols.

          ENDIF.

        ENDLOOP.

*     get distinct user symbols
        SORT e_symbols BY symbol_name.
        DELETE ADJACENT DUPLICATES FROM e_symbols COMPARING symbol_name.         "CDX001-0020

        LOOP AT e_symbols ASSIGNING <l_symbol>.

          IF NOT i_type IS INITIAL."If initial, no need to get value and desc

            CASE i_type.

              WHEN cs_symbol_type-variant."Get symbol value and desc from variant
                SELECT SINGLE
                  symbol_value
                  symbol_desc
                  symbol_multivalue
                  symbol_datatype
                  FROM /cadaxo/sqlcvnsy
                    INTO CORRESPONDING FIELDS OF <l_symbol>
                    WHERE varguid = i_varguid
                      AND symbol_name = <l_symbol>-symbol_name.

              WHEN cs_symbol_type-user."Get current symbol value and desc from variant
*             get current user symbol value

                SELECT SINGLE
                  symbol_value
                  symbol_desc
                  symbol_multivalue                                              "COCKPIT-240
                  symbol_datatype                                                "COCKPIT-240
                  FROM /cadaxo/sqlcusym
                    INTO CORRESPONDING FIELDS OF <l_symbol>
                    WHERE username = sy-uname
                     AND symbol_name = <l_symbol>-symbol_name.                                          "COCKPIT-240
            ENDCASE.

            "     Get Data Element Info
            IF ( <l_symbol>-symbol_datatype IS NOT INITIAL ).
              <l_symbol>-symbol_datadesc = me->get_symbol_datatype_desc( i_datatype = <l_symbol>-symbol_datatype ).
              <l_symbol>-symbol_datainfo = me->get_symbol_datatype_info( i_datatype = <l_symbol>-symbol_datatype ).
            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDLOOP.

* Delete Duplicate entries in GT_USED_SYMBOLS
    SORT gt_used_symbols.                             "CR22-002
    DELETE ADJACENT DUPLICATES FROM gt_used_symbols.  "CR22-002

  ENDMETHOD.


  METHOD merge_symbols.
    DATA: sqlcusyms     TYPE TABLE OF /cadaxo/sqlcusym.
    DATA sqlcusyms_upd TYPE TABLE OF /cadaxo/sqlcusym.
    CHECK i_symbols IS NOT INITIAL.

    SELECT * FROM /cadaxo/sqlcusym
           INTO TABLE sqlcusyms FOR ALL ENTRIES IN i_symbols
           WHERE symbol_name = i_symbols-symbol_name
             AND username    = sy-uname.

    CLEAR gt_symbol_ow.

    LOOP AT i_symbols ASSIGNING FIELD-SYMBOL(<ls_symbols>).
      READ TABLE sqlcusyms
      WITH KEY symbol_name = <ls_symbols>-symbol_name
      INTO DATA(l_sqlcusym).

      IF     sy-subrc = 0
      AND (   l_sqlcusym-symbol_value      <> <ls_symbols>-symbol_value
           OR l_sqlcusym-symbol_desc       <> <ls_symbols>-symbol_desc
           OR l_sqlcusym-symbol_multivalue <> <ls_symbols>-symbol_multivalue ).

        APPEND VALUE #( symbol_name       = <ls_symbols>-symbol_name
                        symbol_value_user = l_sqlcusym-symbol_value
                        symbol_desc_user  = l_sqlcusym-symbol_desc
                        symbol_value_var  = <ls_symbols>-symbol_value
                        symbol_var        = <ls_symbols>-symbol_desc
                        var               = icon_wd_radio_button_empty
                        own               = icon_radiobutton
                        symbol_type_icon_var = COND #( WHEN <ls_symbols>-symbol_multivalue IS NOT INITIAL THEN '@3W@' ELSE '@7L@' )
                        symbol_type_icon_user = COND #( WHEN l_sqlcusym-symbol_multivalue IS NOT INITIAL THEN '@3W@' ELSE '@7L@' )
                        symbol_multivalue_var = <ls_symbols>-symbol_multivalue
                        symbol_datatype_var   = <ls_symbols>-symbol_datatype
                        symbol_multivalue_user  = l_sqlcusym-symbol_multivalue
                        symbol_datatype_user    = l_sqlcusym-symbol_datatype
                      ) TO gt_symbol_ow.

      ENDIF.
    ENDLOOP.

    IF NOT gt_symbol_ow IS INITIAL.
      confirm_symbol_overwrite( ).
    ENDIF.

    LOOP AT i_symbols ASSIGNING FIELD-SYMBOL(<ls_symbols_upd>).

      READ TABLE gt_symbol_ow
      ASSIGNING FIELD-SYMBOL(<ls_symbol_ow>)
      WITH KEY symbol_name = <ls_symbols_upd>-symbol_name.
      IF sy-subrc = 0 AND <ls_symbol_ow>-var <> icon_radiobutton.
        CONTINUE.
      ENDIF.

      MOVE-CORRESPONDING <ls_symbols_upd> TO l_sqlcusym.
      l_sqlcusym-username = sy-uname.
      APPEND l_sqlcusym TO sqlcusyms_upd.
      CLEAR l_sqlcusym.

    ENDLOOP.

    IF sqlcusyms_upd IS NOT INITIAL.
      MODIFY /cadaxo/sqlcusym FROM TABLE sqlcusyms_upd.

      me->get_symbols( ).
      me->refresh_symbol_alv( ).

    ENDIF.
  ENDMETHOD.


  METHOD on_handle_varsym_click.

    ASSIGN gt_symbol_ow[ e_row_id-index ] TO FIELD-SYMBOL(<symbol_ow>).
    IF sy-subrc = 0.

      CASE e_column_id-fieldname.
        WHEN 'OWN'.
          <symbol_ow>-var = icon_wd_radio_button_empty.
          <symbol_ow>-own = icon_radiobutton.
        WHEN 'VAR'.
          <symbol_ow>-var = icon_radiobutton.
          <symbol_ow>-own = icon_wd_radio_button_empty.
        WHEN OTHERS.
          RETURN.
      ENDCASE.

      gr_alv_symb_ow->refresh_table_display( EXPORTING  is_stable      =  VALUE lvc_s_stbl( row = abap_true col = abap_true )
                                                        i_soft_refresh = abap_true
                                             EXCEPTIONS OTHERS         = 1 ).
    ENDIF.
  ENDMETHOD.


  METHOD on_symbol_alv_data_change.
****************************************************************************************************
* Description             : on alv symbol data change                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_mod_cell  TYPE lvc_s_modi.
    DATA lt_mod_cell LIKE TABLE OF l_mod_cell.

    FIELD-SYMBOLS <l_symbol> LIKE LINE OF gt_symbol.
    FIELD-SYMBOLS <mod_cell> LIKE LINE OF lt_mod_cell.

    lt_mod_cell = er_data_changed->mt_mod_cells.

    IF lt_mod_cell IS NOT INITIAL.
      " get distinct records by rowid
      SORT lt_mod_cell BY row_id.
      DELETE ADJACENT DUPLICATES FROM lt_mod_cell
             COMPARING row_id.
      LOOP AT lt_mod_cell INTO l_mod_cell.

*      "Check Symbol Datatype

        IF l_mod_cell-fieldname = 'SYMBOL_DATATYPE'.
          IF l_mod_cell-value IS INITIAL.
            ASSIGN gt_symbol[ l_mod_cell-row_id ] TO <l_symbol>.
            IF <l_symbol>-symbol_multivalue IS NOT INITIAL.
              MESSAGE s122(/cadaxo/sqlc) WITH <l_symbol>-symbol_name DISPLAY LIKE 'E'.
              RETURN.
            ENDIF.
          ELSE.
            l_mod_cell-value = to_upper( val = l_mod_cell-value ).
            TRY.
                check_symbol_datatype( i_value = l_mod_cell-value ).

              CATCH /cadaxo/cx_sqlc_symb_not_found INTO DATA(lr_exception).

                MESSAGE lr_exception->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.

                RETURN.

            ENDTRY.
          ENDIF.
        ENDIF.

        ASSIGN gt_symbol[ l_mod_cell-row_id ] TO <l_symbol>.
        IF sy-subrc = 0.
          IF <l_symbol>-type = cs_symbol_type-user.
            " mark modify type
            <l_symbol>-type = cs_symbol_type-modify.

          ENDIF.
        ENDIF.

      ENDLOOP.

    ENDIF.

    "     IF e_ucomm <> functions-symbol_delete.
    " Wenn dieser Check aktiv ist, wird im Falle eines nocht nicht gespeicherten
    " Symbol-Duplikats und dem Versuch gleichzeitig ein Symbol zu löschen,
    " versucht das Duplikat zu persistieren -> Dump

    " Prüfen ob Dublette innerhalb ModCells oder innerhalb GT_SYMBOL
    LOOP AT gt_symbol ASSIGNING <l_symbol>.

      IF to_upper( <l_symbol>-symbol_name ) = to_upper( l_mod_cell-value ).
        me->mark_cell_when_error( EXPORTING i_row_id      = l_mod_cell-row_id
                                            i_fieldname   = 'SYMBOL_NAME'
                                            i_msgid       = '/CADAXO/SQLC'
                                            i_msgno       = '054'
                                            i_msgty       = 'E'
                                            i_msgv1       = <l_symbol>-symbol_name
                                  CHANGING  ct_cell_style = <l_symbol>-cell_style ).
        EXIT.
      ELSE.
        CLEAR symbol_alv_error.
      ENDIF.
    ENDLOOP.

    DATA lv_count TYPE i VALUE 0.
    " Für spätere Entwicklung, wenn mehrere Symbole auf einmal hinzugefügt werden können, bevor persistiert wird. Im Moment noch nicht möglich.
    LOOP AT lt_mod_cell ASSIGNING <mod_cell>.
      IF to_upper( <mod_cell>-value ) <> to_upper( l_mod_cell-value ).
        CONTINUE.
      ENDIF.

      lv_count += 1.

      IF lv_count > 1.
        me->mark_cell_when_error( EXPORTING i_row_id      = <mod_cell>-row_id
                                            i_fieldname   = 'SYMBOL_NAME'
                                            i_msgid       = '/CADAXO/SQLC'
                                            i_msgno       = '054'
                                            i_msgty       = 'E'
                                            i_msgv1       = <mod_cell>-value
                                  CHANGING  ct_cell_style = <l_symbol>-cell_style ).
        EXIT.
      ENDIF.
    ENDLOOP.

    IF symbol_alv_error IS NOT INITIAL.
      DATA lv_row_id TYPE lvc_index.
      WRITE symbol_alv_error-row TO lv_row_id.

      me->focus_symbol_alv_cell( i_row_id     = lv_row_id
                                 i_field_name = 'SYMBOL_NAME' ).

      er_data_changed->add_protocol_entry( i_msgid     = symbol_alv_error-id
                                           i_msgty     = symbol_alv_error-type
                                           i_msgno     = symbol_alv_error-number
                                           i_fieldname = symbol_alv_error-field
                                           i_row_id    = symbol_alv_error-row ).
    ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD on_symbol_alv_data_changed_fin.
****************************************************************************************************
* Description             : Build the result grit title                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 01.11.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    IF e_modified = abap_true.
      me->on_symbol_alv_user_command( e_ucomm = 'SYMBOL_SAVE' ).
    ENDIF.

  ENDMETHOD.


  METHOD on_symbol_alv_toolbar.
****************************************************************************************************
* Description             : Add buttons to symbol list functions                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | Sort global/user                            | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
* 27.02.2018 | Pat                  | Symbol export                               | Cockpit-294    *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA: l_button TYPE stb_button.
    FIELD-SYMBOLS: <lwa_symbol> TYPE /cadaxo/sqlc_symbol.                "CDX001-0020
    DATA: l_sh_disabled TYPE c.                                          "CDX001-0020

* add buttons

    LOOP AT gt_symbol_delete ASSIGNING <lwa_symbol>.                     "CDX001-0020
      EXIT.                                                              "CDX001-0020
    ENDLOOP.                                                             "CDX001-0020
    IF sy-subrc = 0.                                                     "CDX001-0020
      l_sh_disabled = 'X'.                                               "CDX001-0020
    ENDIF.                                                               "CDX001-0020
    LOOP AT gt_symbol ASSIGNING <lwa_symbol>                             "CDX001-0020
                      WHERE type <> cs_symbol_type-program
                        AND type <> cs_symbol_type-user.                  "CDX001-0020
      EXIT.                                                              "CDX001-0020
    ENDLOOP.                                                             "CDX001-0020
    IF sy-subrc = 0.                                                     "CDX001-0020
      l_sh_disabled = 'X'.                                               "CDX001-0020
    ENDIF.                                                               "CDX001-0020
    IF me->user_settings->symbols_program_show = c_program_symbols-hide.                      "CDX001-0020
* show program symbols                                                 "CDX001-0020
      CLEAR l_button.                                                    "CDX001-0020
      MOVE: 'SYMBOL_P_SHOW'  TO l_button-function,                       "CDX001-0020
          icon_expand        TO l_button-icon,                           "CDX001-0020
          TEXT-q18           TO l_button-quickinfo,                      "CDX001-0020
          0                  TO l_button-butn_type,                      "CDX001-0020
          l_sh_disabled      TO l_button-disabled.                       "CDX001-0020
      APPEND l_button TO e_object->mt_toolbar.                           "CDX001-0020
    ELSE.                                                                "CDX001-0020
* hide program symbols                                                 "CDX001-0020
      CLEAR l_button.                                                    "CDX001-0020
      MOVE: 'SYMBOL_P_HIDE'  TO l_button-function,                       "CDX001-0020
          icon_collapse      TO l_button-icon,                           "CDX001-0020
          TEXT-q19           TO l_button-quickinfo,                      "CDX001-0020
          0                  TO l_button-butn_type,                      "CDX001-0020
          l_sh_disabled      TO l_button-disabled.                       "CDX001-0020
      APPEND l_button TO e_object->mt_toolbar.                           "CDX001-0020
    ENDIF.                                                               "CDX001-0020

* separator                                                            "CDX001-0020
    CLEAR l_button.                                                      "CDX001-0020
    MOVE: 3                TO l_button-butn_type,                        "CDX001-0020
        space              TO l_button-disabled.                         "CDX001-0020
    APPEND l_button TO e_object->mt_toolbar.                             "CDX001-0020

* show only symbols that are used in the editor
    IF me->user_settings->only_used_symbols = space.
      CLEAR l_button.
      MOVE: 'SYMBOLS_EDITOR_ONLY'    TO l_button-function,
          icon_filter                TO l_button-icon,
          TEXT-q32                   TO l_button-quickinfo,
          0                          TO l_button-butn_type,
          space                      TO l_button-disabled.
      APPEND l_button TO e_object->mt_toolbar.
    ELSE.
      CLEAR l_button.
      l_button-checked = abap_true.
      MOVE: 'SYMBOLS_ALL'            TO l_button-function,
          icon_filter                TO l_button-icon,
          TEXT-q33                   TO l_button-quickinfo,
          0                          TO l_button-butn_type,
          space                      TO l_button-disabled.
      APPEND l_button TO e_object->mt_toolbar.
    ENDIF.

* separator                                                            "CDX001-0020
    CLEAR l_button.                                                      "CDX001-0020
    MOVE: 3                TO l_button-butn_type,                        "CDX001-0020
        space              TO l_button-disabled.                         "CDX001-0020
    APPEND l_button TO e_object->mt_toolbar.

* create
    CLEAR l_button.
    MOVE: 'SYMBOL_CREATE'    TO l_button-function,
        icon_create        TO l_button-icon,
        TEXT-q15           TO l_button-quickinfo,
        0                  TO l_button-butn_type,
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.

* begin of insert cockpit-294

* separator
    CLEAR l_button.
    MOVE: 3                TO l_button-butn_type,
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.

    CLEAR l_button.
    MOVE: 'SYMBOL_SHARE'    TO l_button-function,
        icon_workflow_external_event TO l_button-icon,
        TEXT-b42           TO l_button-quickinfo,
*        cntb_btype_button  TO l_button-butn_type, "-Cockpit-420
*        cntb_btype_menu TO l_button-butn_type, "-Cockpit-420
        cntb_btype_dropdown TO l_button-butn_type, "+Cockpit-420 KA
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.

* separator
    CLEAR l_button.
    MOVE: 3                TO l_button-butn_type,
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.
* end   of insert cockpit-294

* delete
    MOVE: functions-symbol_delete    TO l_button-function,
        icon_delete        TO l_button-icon,
        TEXT-q16           TO l_button-quickinfo,
        0                  TO l_button-butn_type,
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.
* save
*  CLEAR l_button.                                                     "CDX001-0020
*  MOVE: 'SYMBOL_SAVE'    TO l_button-function,                        "CDX001-0020
*      icon_system_save TO l_button-icon,                              "CDX001-0020
*      text-q17           TO l_button-quickinfo,                       "CDX001-0020
*      0                  TO l_button-butn_type,                       "CDX001-0020
*      space              TO l_button-disabled.                        "CDX001-0020
*  APPEND l_button TO e_object->mt_toolbar.                            "CDX001-0020

  ENDMETHOD.


  METHOD on_symbol_alv_user_command.
****************************************************************************************************
* Description             : on alv symbol user command                                             *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | Sort global/user                            | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
*------------+----------------------+---------------------------------------------+----------------*
* 28.02.2018 | Pat Patil            | Symbol Export                               | Cockpit-294    *
*------------+----------------------+---------------------------------------------+----------------*
* 16.11.2020 | Attila Kajtar        | Sharing: sharing with same user / system!   | Cockpit-420    *
****************************************************************************************************
    DATA  l_symbol LIKE LINE OF gt_symbol.

    DATA  l_celltab LIKE LINE OF l_symbol-cell_style.

    DATA  l_refresh TYPE boolean.

    DATA: l_itab_count TYPE i,
          l_row_id     TYPE lvc_index.

    DATA: lwa_layout      TYPE lvc_s_layo.                                       "CDX001-0020

    DATA: lcl_controller  TYPE REF TO /cadaxo/cl_sqlc_cockpit_main.               """""
    "  DATA: l_sqlcusrp_dyn  TYPE /cadaxo/sqlcusrp_dyn.                              """""

    CREATE OBJECT lcl_controller. """""

    /cadaxo/cl_sqlc_functrace=>add_trace( |ON_SYMBOL_ALV_USER_COMMAND:| && e_ucomm ).

    CASE e_ucomm.

      WHEN 'SYMBOL_CREATE'.
* Show ALL Symbols Mode, before creating new symbol
*        me->user_settings->only_used_symbols = space.        "CR22-002
        me->user_settings->only_used_symbols = space.
        me->get_symbols(  ).                                   "CR22-002

        l_symbol-type = cs_symbol_type-create.
*     ALL fields Editable
        l_celltab-fieldname = 'SYMBOL_NAME'.
        l_celltab-style = cl_gui_alv_grid=>mc_style_enabled.
        INSERT l_celltab INTO TABLE l_symbol-cell_style.
        l_celltab-fieldname = 'SYMBOL_VALUE'.
        l_celltab-style = cl_gui_alv_grid=>mc_style_enabled.
        INSERT l_celltab INTO TABLE l_symbol-cell_style.
        l_celltab-fieldname = 'SYMBOL_DESC'.
        l_celltab-style = cl_gui_alv_grid=>mc_style_enabled.
        INSERT l_celltab INTO TABLE l_symbol-cell_style.
        APPEND l_symbol TO gt_symbol.
*     focus new record
        DESCRIBE TABLE gt_symbol LINES l_itab_count.
        l_row_id = l_itab_count.

        l_refresh = abap_true.

      WHEN functions-symbol_delete.
        me->delete_symbols( IMPORTING e_success = l_refresh ).

      WHEN 'SYMBOL_SAVE'.
        me->save_symbols( IMPORTING e_success = l_refresh ).
        IF NOT l_refresh IS INITIAL.                                             "CDX001-0020
          me->get_symbols( ).                                                    "CDX001-0020
        ENDIF.                                                                   "CDX001-0020

      WHEN 'SYMBOL_P_HIDE'.                                                      "CDX001-0020
        me->user_settings->symbols_program_show = c_program_symbols-hide.       "CDX001-0020
*       refresh symbol ALV                                                     "CDX001-0020
        me->get_symbols( ).                                                      "CDX001-0020
        l_refresh = abap_true.
*        me->set_user_settings( EXPORTING i_settings = me->g_user_settings )."CR22-002
      WHEN 'SYMBOL_P_SHOW'.                                                      "CDX001-0020
        me->user_settings->symbols_program_show = c_program_symbols-show.       "CDX001-0020
*       refresh symbol ALV                                                     "CDX001-0020
        me->get_symbols( ).                                                      "CDX001-0020
        l_refresh = abap_true.
*        me->set_user_settings( EXPORTING i_settings = me->g_user_settings ). "CR22-002                                                       "CDX001-0020
* Only symbols used in Editor
      WHEN 'SYMBOLS_EDITOR_ONLY'.                             "CR22-002
        me->user_settings->only_used_symbols = abap_true.          "CR22-002
        me->get_symbols( ).                                   "CR22-002
        l_refresh = abap_true.                                      "CR22-002
*        me->set_user_settings( EXPORTING i_settings = me->g_user_settings )."CR22-002
      WHEN 'SYMBOLS_ALL'.                                     "CR22-002
        me->user_settings->only_used_symbols = space.        "CR22-002
        me->get_symbols( ).                                   "CR22-002
        l_refresh = abap_true.                                      "CR22-002
*        me->set_user_settings( EXPORTING i_settings = me->g_user_settings )."CR22-002

* begin of changes cockpit-294
      WHEN 'SYMBOL_EXPORT'
        OR 'SYMBOL_SHARE'. "Cockpit-420 KA
        me->get_symbols_selected( IMPORTING e_success = l_refresh ).
        IF NOT l_refresh IS INITIAL.
          CALL FUNCTION '/CADAXO/SQLC_SHARE'
            EXPORTING
              iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-symbols
              it_symbols     = gt_symbol_selected.
        ENDIF.
* end   of changes cockpit-294
* begin of insert cockpit-420
      WHEN 'SYMBOL_EXPORT_ME'.
        me->get_symbols_selected( IMPORTING e_success = l_refresh ).
        IF NOT l_refresh IS INITIAL.
          CALL FUNCTION '/CADAXO/SQLC_SHARE'
            EXPORTING
              iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-symbols
              it_symbols     = gt_symbol_selected
              iv_receiver    = CONV /cadaxo/sqlcapi_receiver( sy-uname )
              iv_text        = TEXT-012.
        ENDIF.
* end   of insert cockpit-420
    ENDCASE.

    IF l_refresh = abap_true.

      me->refresh_symbol_alv( ).

      IF e_ucomm = 'SYMBOL_CREATE'.
*     focus new record
        CALL METHOD me->focus_symbol_alv_cell
          EXPORTING
            i_row_id     = l_row_id
            i_field_name = 'SYMBOL_NAME'.
      ELSEIF NOT g_curr_col IS INITIAL.                                          "CDX001-0020
        READ TABLE gt_symbol WITH KEY symbol_name = g_curr_row                   "CDX001-0020
                             TRANSPORTING NO FIELDS.                             "CDX001-0020
        l_row_id = sy-tabix.                                                     "CDX001-0020
        CALL METHOD me->focus_symbol_alv_cell                                    "CDX001-0020
          EXPORTING                                                              "CDX001-0020
            i_row_id     = l_row_id                                              "CDX001-0020
            i_field_name = g_curr_col.                                           "CDX001-0020
        CLEAR g_curr_col.                                                        "CDX001-0020
        CLEAR g_curr_row.                                                        "CDX001-0020
      ENDIF.
      CLEAR l_refresh.
    ENDIF.
  ENDMETHOD.


  METHOD on_symbol_button_click.

    DATA: r_symbol_value TYPE rseloption.

    FIELD-SYMBOLS <l_symbol> LIKE LINE OF gt_symbol.

    READ TABLE gt_symbol INDEX es_row_no-row_id ASSIGNING <l_symbol>.
    TRY.
        me->check_symbol_datatype( i_value = CONV #( <l_symbol>-symbol_datatype ) ).

      CATCH /cadaxo/cx_sqlc_symb_not_found INTO DATA(lr_exception).

        MESSAGE lr_exception->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.

        RETURN.

    ENDTRY.

    TRY.
        r_symbol_value = me->show_symbolmulti_dialog( EXPORTING i_symbol_multivalue = <l_symbol>-symbol_multivalue
                                                                i_symbol_datatype   = <l_symbol>-symbol_datatype
                                                                i_symbol_name       = <l_symbol>-symbol_name ).

        " Compress symbol multivalue
        /cadaxo/cl_sqlc_cockpit_assist=>compress_symbol_multivalue( EXPORTING i_symbol_multivalue = r_symbol_value
                                                                    IMPORTING e_data = DATA(lv_data) ).

        <l_symbol>-symbol_multivalue = lv_data.
        <l_symbol>-type = cs_symbol_type-modify.
        me->on_symbol_alv_user_command( e_ucomm = 'SYMBOL_SAVE' ).

      CATCH /cadaxo/cx_sqlc_symb_not_found ##no_handler.
    ENDTRY.
    "ENDIF.
  ENDMETHOD.


  METHOD on_symbol_button_variant.

    DATA: symbol_value TYPE rseloption.

    TRY.
        DATA(ls_symbol_ow) = gt_symbol_ow[ es_row_no-row_id ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lr_exception).
        MESSAGE s100(/cadaxo/sqlc) WITH lr_exception->get_text( ) DISPLAY LIKE 'E'.
        RETURN.
    ENDTRY.

    TRY.
        IF es_col_id = 'SYMBOL_TYPE_ICON_VAR' AND ls_symbol_ow-symbol_multivalue_var IS NOT INITIAL.

          symbol_value = me->show_symbolmulti_dialog( i_symbol_multivalue = ls_symbol_ow-symbol_multivalue_var
                                                      i_symbol_datatype   = ls_symbol_ow-symbol_datatype_var
                                                      i_symbol_name       = ls_symbol_ow-symbol_name ).

        ELSEIF es_col_id = 'SYMBOL_TYPE_ICON_USER' AND ls_symbol_ow-symbol_multivalue_user IS NOT INITIAL.

          symbol_value = me->show_symbolmulti_dialog( i_symbol_multivalue = ls_symbol_ow-symbol_multivalue_user
                                                      i_symbol_datatype   = ls_symbol_ow-symbol_datatype_user
                                                      i_symbol_name       = ls_symbol_ow-symbol_name ).

        ENDIF.
      CATCH /cadaxo/cx_sqlc_symb_not_found.
    ENDTRY.
  ENDMETHOD.


  METHOD on_symbol_double_click.
****************************************************************************************************
* Description             : on symbol double click                                                 *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_fieldvalue TYPE string,
          l_from_line  TYPE i,
          l_from_pos   TYPE i,
          l_to_line    TYPE i,
          l_to_pos     TYPE i.

    DATA: l_symbol LIKE LINE OF gt_symbol.

    IF main_controller->g_abap_editor_type <> /cadaxo/cl_sqlc_cockpit_main=>editor_type-new.
      MESSAGE i041(/cadaxo/sqlc).
      EXIT.
    ENDIF.

    READ TABLE gt_symbol INDEX e_row-index
                         INTO l_symbol
                         TRANSPORTING symbol_name
                                      type.
    IF sy-subrc = 0.
*   only saved symbols can be double clicked
      CHECK l_symbol-type = cs_symbol_type-program OR l_symbol-type = cs_symbol_type-user.

      CONCATENATE '&'
                  l_symbol-symbol_name
                  '&'
                  INTO l_fieldvalue.

      main_controller->insert_codeblock_currpos_nosel( l_fieldvalue ).

    ENDIF.

  ENDMETHOD.


  METHOD on_symbol_drag.

    DATA  l_fieldvalue TYPE string.

    ASSIGN gt_symbol[ e_row-index ] TO FIELD-SYMBOL(<symbol>).
    IF sy-subrc = 0
    AND ( <symbol>-type = cs_symbol_type-program OR <symbol>-type = cs_symbol_type-user ).

      e_dragdropobj->object = NEW lcl_drag_object( |&{ <symbol>-symbol_name }&| ).

    ENDIF.

  ENDMETHOD.


  METHOD on_symbol_menu_button.

    IF e_ucomm = 'SYMBOL_SHARE'.

      DATA(lr_menu) = NEW cl_ctmenu( ).

      lr_menu->add_function(
        EXPORTING
          fcode = 'SYMBOL_EXPORT'
          text  = TEXT-b47
          icon  = icon_workflow_external_event
          insert_at_the_top = abap_true
          checked           = abap_true "Cockpit-420 KA
          ).
      lr_menu->add_function(
         EXPORTING
          fcode = 'SYMBOL_EXPORT_ME'
           text = TEXT-b44
          icon  = icon_workflow_internal_event ).

      CALL METHOD e_object->add_menu
        EXPORTING
          menu = lr_menu.

    ENDIF.

  ENDMETHOD.


  METHOD on_toolbar_function_selected.
****************************************************************************************************
* Description             : Selection of Toolbar Function                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 03.02.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 11.10.2010 | David Ren            | Add symbol ALV(including user symbols)      | Usersymbols    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    /cadaxo/cl_sqlc_functrace=>add_trace( |ON_TOOLBAR_FUNCTION_SELECTED:| && fcode ).

    CASE fcode.
      WHEN c_okcode_symbols.
        me->user_settings->symbols_show = SWITCH #( me->user_settings->symbols_show WHEN abap_true THEN abap_false ELSE abap_true ).

        main_controller->set_user_settings( me->user_settings->* ).
        set_symbol_alv( ).

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD pai_0700.

    CASE i_ok_code.
      WHEN 'SAVE'.
        gr_alv_symb_ow->free( EXCEPTIONS OTHERS = 1 ).
        gr_cc_alv_symb_ow->free( EXCEPTIONS OTHERS = 1 ).
        CLEAR gr_alv_symb_ow.
        CLEAR gr_cc_alv_symb_ow.
        SET SCREEN 0.
        LEAVE SCREEN.
      WHEN 'ESC'.
        "nothing
    ENDCASE.

  ENDMETHOD.


  METHOD pbo_0700.

    DATA: lt_fieldcat TYPE lvc_t_fcat.
    DATA: lwa_layout  TYPE lvc_s_layo.

    IF gr_cc_alv_symb_ow IS INITIAL.

      gr_cc_alv_symb_ow = NEW #( container_name = 'GCONT_ALV_SYMB_OW' ).
      gr_alv_symb_ow = NEW #( i_parent = gr_cc_alv_symb_ow ).
      SET HANDLER me->on_handle_varsym_click FOR gr_alv_symb_ow ACTIVATION abap_true.
      SET HANDLER me->on_symbol_button_variant FOR gr_alv_symb_ow  ACTIVATION abap_true. "+cockpit-294
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name   = '/CADAXO/SQLC_SYMBOL_OW'
          i_bypassing_buffer = abap_true
        CHANGING
          ct_fieldcat        = lt_fieldcat
        EXCEPTIONS
          OTHERS             = 1.

      LOOP AT lt_fieldcat ASSIGNING FIELD-SYMBOL(<lwa_fieldcat>).
        CASE <lwa_fieldcat>-fieldname. "#3497 begin
          WHEN 'VAR'.
            <lwa_fieldcat>-icon       = abap_true.
            <lwa_fieldcat>-hotspot    = abap_true.
            <lwa_fieldcat>-outputlen  = 14.
            <lwa_fieldcat>-fix_column = abap_true.
          WHEN 'OWN'.
            <lwa_fieldcat>-icon       = abap_true.
            <lwa_fieldcat>-hotspot    = abap_true.
            <lwa_fieldcat>-outputlen  = 14.
            <lwa_fieldcat>-fix_column = abap_true.
          WHEN 'SYMBOL_NAME'.
            <lwa_fieldcat>-outputlen  = 16.
            <lwa_fieldcat>-key       = abap_true.
          WHEN 'SYMBOL_VALUE_USER'.
            <lwa_fieldcat>-coltext   = TEXT-a01.
            <lwa_fieldcat>-outputlen  = 20.
          WHEN 'SYMBOL_DESC_USER'.
            <lwa_fieldcat>-coltext   = TEXT-a02.
            <lwa_fieldcat>-key       = abap_true.
            <lwa_fieldcat>-outputlen  = 14.
          WHEN 'SYMBOL_VALUE_VAR'.
            <lwa_fieldcat>-coltext   = TEXT-a03.
            <lwa_fieldcat>-outputlen  = 20.
          WHEN 'SYMBOL_VAR'.
            <lwa_fieldcat>-coltext   = TEXT-a04.
            <lwa_fieldcat>-key       = abap_true.
            <lwa_fieldcat>-outputlen  = 14.
*            begin of insert cockpit-294
          WHEN 'SYMBOL_TYPE_ICON_USER'.
            <lwa_fieldcat>-coltext   = TEXT-a05.
            <lwa_fieldcat>-outputlen  = 4.
            <lwa_fieldcat>-style = cl_gui_alv_grid=>mc_style_button.
          WHEN 'SYMBOL_DATATYPE_USER'.
            <lwa_fieldcat>-coltext   = TEXT-a06.
          WHEN 'SYMBOL_DATATYPE_VAR'.
            <lwa_fieldcat>-coltext   = TEXT-a07.
          WHEN 'SYMBOL_TYPE_ICON_VAR'.
            <lwa_fieldcat>-coltext   = TEXT-a05.
            <lwa_fieldcat>-outputlen  = 4.
            <lwa_fieldcat>-style = cl_gui_alv_grid=>mc_style_button.
*            end   of insert cockpit-294
        ENDCASE.
      ENDLOOP.                                              ""#3497 end

      lwa_layout-zebra      = abap_false.
      lwa_layout-sel_mode   = 'N'.
      lwa_layout-no_toolbar = abap_true.
      lwa_layout-cwidth_opt = abap_true.
      lwa_layout-stylefname = 'CELL_STYLE'. "Dävid

      gr_alv_symb_ow->set_table_for_first_display( EXPORTING  i_bypassing_buffer = abap_true
                                                              is_layout          = lwa_layout
                                                   CHANGING   it_outtab          = gt_symbol_ow
                                                              it_fieldcatalog    = lt_fieldcat
                                                   EXCEPTIONS OTHERS             = 1 ).

    ENDIF.
  ENDMETHOD.


  METHOD refresh_symbol_alv.

    gc_symbol_alv->refresh_table_display( EXPORTING  i_soft_refresh = abap_true
                                          EXCEPTIONS OTHERS         = 1 ).
    gc_symbol_alv->get_frontend_layout( IMPORTING es_layout = DATA(layout) ).
    IF layout-cwidth_opt <> abap_true.
      layout-cwidth_opt = abap_true.
      gc_symbol_alv->set_frontend_layout( layout ).
    ENDIF.

  ENDMETHOD.


  METHOD save_symbols.
****************************************************************************************************
* Description             : save symbols                                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | I18N Messages                               | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 17.07.2017 | Harald Wiesinger     | Symbole prÃƒÂ¼fen vor dem speichern            | COCKPIT-204    *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_symbol LIKE LINE OF gt_symbol[].
    DATA lt_symbol_create_compare LIKE TABLE OF l_symbol-symbol_name.
    DATA l_tabix TYPE lvc_index.
    DATA lt_symbol_db_create TYPE TABLE OF /cadaxo/sqlcusym.
    DATA lt_symbol_db_update LIKE lt_symbol_db_create.
    DATA l_symbol_db LIKE LINE OF lt_symbol_db_create.
    DATA l_db_commit TYPE boolean.
    DATA l_count TYPE i.
    DATA l_curr_row TYPE i.                                          "CDX001-0020
    DATA l_curr_col_id TYPE lvc_s_col.                                  "CDX001-0020
    DATA l_values_count TYPE i.

    FIELD-SYMBOLS: <l_symbol>     LIKE LINE OF gt_symbol,
                   <l_cell_style> LIKE LINE OF <l_symbol>-cell_style.


    gc_symbol_alv->get_current_cell( IMPORTING e_row     = l_curr_row            "CDX001-0020
                                               es_col_id = l_curr_col_id ).      "CDX001-0020
    READ TABLE gt_symbol ASSIGNING <l_symbol> INDEX l_curr_row.                  "CDX001-0020
    IF sy-subrc = 0.                                                             "CDX001-0020
      g_curr_col = l_curr_col_id-fieldname.                                      "CDX001-0020
      g_curr_row = <l_symbol>-symbol_name.                                       "CDX001-0020
    ENDIF.                                                                       "CDX001-0020

* get each itab record by type
* exclude program symbols
    LOOP AT gt_symbol INTO l_symbol WHERE NOT type = cs_symbol_type-program.

      l_tabix = sy-tabix.
*   only dealed user symbols consider
      CASE l_symbol-type.
        WHEN cs_symbol_type-create.

          MOVE-CORRESPONDING l_symbol TO l_symbol_db.
          l_symbol_db-username = sy-uname.

          APPEND l_symbol_db TO lt_symbol_db_create.
          CLEAR l_symbol_db.

        WHEN cs_symbol_type-modify.
*       check wheter symbol value is empty
          IF l_symbol-symbol_value IS INITIAL.
            MESSAGE s051(/cadaxo/sqlc) DISPLAY LIKE 'W'.
          ENDIF.

          IF l_symbol-symbol_multivalue IS NOT INITIAL.
            l_values_count = get_user_symbol_count( i_symbol_multivalue = l_symbol-symbol_multivalue ).
            l_symbol-symbol_value = '<' && l_values_count &&' VALUES' && '>'.
          ENDIF.

          MOVE-CORRESPONDING l_symbol TO l_symbol_db.
          l_symbol_db-username = sy-uname.

          APPEND l_symbol_db TO lt_symbol_db_update.
          CLEAR l_symbol_db.

      ENDCASE.

    ENDLOOP.

* start db change
* delete
    DATA(l_db_commit_del) = me->delete_symbol_db( ).                                                        "COCKPIT-204
* update
    DATA(l_db_commit_upd) = me->update_symbol_db( EXPORTING it_symbol_update = lt_symbol_db_update ).       "COCKPIT-204
* create
    DATA(l_db_commit_cre) = me->create_symbol_db( EXPORTING it_symbol_create = lt_symbol_db_create ).       "COCKPIT-204
    IF l_db_commit_del IS NOT INITIAL OR l_db_commit_upd IS NOT INITIAL OR l_db_commit_cre IS NOT INITIAL.  "COCKPIT-204
      l_db_commit = abap_true.                                                                              "COCKPIT-204
    ENDIF.                                                                                                  "COCKPIT-204

    IF l_db_commit = abap_true.
*   change type of gt_symbol records
      LOOP AT gt_symbol ASSIGNING <l_symbol> WHERE type = cs_symbol_type-create
                                                OR type = cs_symbol_type-modify.

        IF <l_symbol>-type = cs_symbol_type-create.
*       change SYMBOL_NAME non-editable
          READ TABLE <l_symbol>-cell_style WITH KEY fieldname = 'SYMBOL_NAME'
                                            ASSIGNING <l_cell_style>.
          IF sy-subrc = 0.
            IF <l_cell_style>-style = 1.
              <l_cell_style>-style = cl_gui_alv_grid=>mc_style_enabled.
            ENDIF.

          ENDIF.

        ENDIF.

        <l_symbol>-type = cs_symbol_type-user.

      ENDLOOP.
*   show successful message
      MESSAGE s056(/cadaxo/sqlc).
      e_success = abap_true.

    ELSE.
      CLEAR e_success.
    ENDIF.

  ENDMETHOD.


  METHOD set_symbol_alv.

    DATA: l_width TYPE i.

    CASE me->user_settings->symbols_show.
      WHEN abap_false.
        l_width = main_controller->toolbar_col_width.

        gc_symbol_toolbar->set_button_info( EXPORTING  fcode     = c_okcode_symbols
                                                       icon      = '@K1@'
                                                       quickinfo = TEXT-ssh
                                            EXCEPTIONS OTHERS    = 1 ).

      WHEN abap_true.
        l_width = main_controller->c_width_right_symbols.

        gc_symbol_toolbar->set_button_info( EXPORTING  fcode     = c_okcode_symbols
                                                       icon      = '@K2@'
                                                       quickinfo = TEXT-shi
                                            EXCEPTIONS OTHERS    = 1 ).

    ENDCASE.

    CAST cl_gui_splitter_container( gcont_symbol->parent )->set_column_width( id = 2 width = l_width ).

    cl_gui_cfw=>flush( ).

  ENDMETHOD.


  METHOD show_symbolmulti_dialog.
****************************************************************************************************
* Description             : Show Smybol Multivalue Dialog                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dusan Sacha              Company    : CADAXO GesmbH                    *
* Date                    : 31.07.2017               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 15.03.2018 | Dusan Sacha          | Multivalue Include Ranges                   | COCKPIT-214    *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA ls_exl_opt TYPE rsoptions.
    DATA popup_title TYPE syst_title.


    " Load Multivalue Data
    IF i_symbol_multivalue IS NOT INITIAL.
      /cadaxo/cl_sqlc_cockpit_assist=>decompress_symbol_multivalue(
        EXPORTING
          i_symbol_multivalue = i_symbol_multivalue
        IMPORTING
          e_symbol_multivalue = r_symbol_value
      ).
    ENDIF.


*"     Exclude select options
*    MOVE: abap_true TO ls_exl_opt-bt ,
*          abap_true TO ls_exl_opt-cp ,
*          abap_true TO ls_exl_opt-ge ,
*          abap_true TO ls_exl_opt-gt ,
*          abap_true TO ls_exl_opt-le ,
*          abap_true TO ls_exl_opt-lt ,
*          abap_true TO ls_exl_opt-nb ,
*          abap_true TO ls_exl_opt-np ,
*          abap_true TO ls_exl_opt-ne .
*

    " Prepare Data Structure Dynamically
    DATA lr_data_struct TYPE REF TO data.
    DATA lr_data TYPE REF TO data.

    me->create_symbol_multival_tab_dyn(
      EXPORTING i_symbol_datatype = i_symbol_datatype
      IMPORTING e_data_struct     = lr_data_struct
                e_data            = lr_data
    ).


    FIELD-SYMBOLS <ls_table> TYPE STANDARD TABLE.
    ASSIGN lr_data_struct->* TO FIELD-SYMBOL(<ls_struct>).
    ASSIGN lr_data->* TO <ls_table>.
    ASSIGN ('<ls_struct>-low') TO FIELD-SYMBOL(<low>).
    ASSIGN ('<ls_struct>-high') TO FIELD-SYMBOL(<high>).
    ASSIGN ('<ls_struct>-sign') TO FIELD-SYMBOL(<sign>).
    ASSIGN ('<ls_struct>-option') TO FIELD-SYMBOL(<option>).


    LOOP AT r_symbol_value ASSIGNING FIELD-SYMBOL(<rs_symbol_value>).
      <low>    = <rs_symbol_value>-low.
      <high>   = <rs_symbol_value>-high.
      <sign>   = <rs_symbol_value>-sign.
      <option> = <rs_symbol_value>-option.
      APPEND <ls_struct> TO <ls_table>.
    ENDLOOP.


      popup_title = |{ TEXT-q54 } { i_symbol_name }|.


    " Show Multivalue Dialog
    CALL FUNCTION 'COMPLEX_SELECTIONS_DIALOG'
      EXPORTING
        title             = popup_title
        text              = TEXT-q55
        no_interval_check = abap_true
        excluded_options  = ls_exl_opt
        lower_case        = abap_true "
      TABLES
        range             = <ls_table>
      EXCEPTIONS
        no_range_tab      = 1
        cancelled         = 2
        internal_error    = 3
        invalid_fieldname = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found.
    ELSE.
      r_symbol_value = CORRESPONDING #( <ls_table> ).
    ENDIF.

  ENDMETHOD.


  METHOD update_symbol_db.

    IF NOT it_symbol_update IS INITIAL.

      UPDATE /cadaxo/sqlcusym FROM TABLE it_symbol_update.
      IF sy-subrc = 0.

        rv_success = 'X'.

      ELSE.

        ROLLBACK WORK.
        MESSAGE s055(/cadaxo/sqlc) WITH TEXT-deu DISPLAY LIKE 'E'.                      "CDX001-0020
        RETURN.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD mark_cell_when_error.

    symbol_alv_error = VALUE #(
    type = i_msgty
    id   = I_msgid
    number   = i_msgno
*message
*log_no
*log_msg_no
    message_v1 = i_msgv1
    message_v2 = i_msgv2
    message_v3 = i_msgv3
    message_v4 = i_msgv4

    row  = i_row_id
    field   = i_fieldname ).
*    FIELD-SYMBOLS: <ls_cell_style> LIKE LINE OF ct_cell_style.
*
*    READ TABLE ct_cell_style ASSIGNING <ls_cell_style> WITH KEY fieldname = i_fieldname.
*    IF sy-subrc <> 0.
*      DATA(ls_cell_style) = VALUE lvc_s_styl(
*        fieldname = i_fieldname
*        style     = alv_style_color_negative
*      ).
*      INSERT ls_cell_style INTO TABLE ct_cell_style.
*    ELSE.
*      <ls_cell_style>-style = alv_style_color_negative.
*    ENDIF.
*
*
*    me->refresh_symbol_alv( ).

    MESSAGE ID i_msgid TYPE 'S' NUMBER i_msgno
            WITH i_msgv1 i_msgv2 i_msgv3 i_msgv4 DISPLAY LIKE i_msgty.

  ENDMETHOD.

  METHOD mark_symbol_alv_cell_error.

    DATA ls_cell_msg TYPE lvc_s_msg.
    DATA ls_cell_style TYPE lvc_s_styl.

    ls_cell_msg-row_id    = i_row_id.
    ls_cell_msg-fieldname = i_field_name.
    ls_cell_msg-messageid     = i_msgid.
    ls_cell_msg-messagenr    = i_msgno.
    ls_cell_msg-msgty     = i_msgty.
    ls_cell_msg-msgv1     = i_msgv1.

    APPEND ls_cell_msg TO ct_cell_msg.

    ls_cell_style-fieldname = i_field_name.
    ls_cell_style-style     = '1'.

    ASSIGN gt_symbol[ sy-tabix + i_row_id - 1 ] TO FIELD-SYMBOL(<fs_symbol_row>).
    IF sy-subrc = 0.
      IF <fs_symbol_row>-cell_style IS INITIAL.
        CLEAR <fs_symbol_row>-cell_style.
      ENDIF.
      APPEND ls_cell_style TO <fs_symbol_row>-cell_style.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
