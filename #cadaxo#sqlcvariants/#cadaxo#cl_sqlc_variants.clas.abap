CLASS /cadaxo/cl_sqlc_variants DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

*"* public components of class /CADAXO/CL_SQLC_VARIANTS
*"* do not include other source files here!!!
  PUBLIC SECTION.

    DATA g_cc_tree TYPE REF TO cl_gui_custom_container .
    DATA g_column_tree TYPE REF TO cl_gui_column_tree .
    DATA g_cc_description TYPE REF TO cl_gui_custom_container .
    DATA g_text_edit_description TYPE REF TO cl_gui_textedit .
    DATA g_cc_splitter_abap_and_vers TYPE REF TO cl_gui_custom_container .
    DATA g_splitter_abap_vers TYPE REF TO cl_gui_splitter_container .
    DATA g_cc_abap TYPE REF TO cl_gui_container .
    DATA g_cc_symbols TYPE REF TO cl_gui_container .
    DATA g_abap_editor TYPE REF TO cl_gui_abapedit .
    DATA g_abap_editor_text TYPE REF TO cl_gui_textedit .
    DATA g_symbols TYPE REF TO cl_gui_alv_grid .
    DATA gs_il_variants TYPE /cadaxo/sqlc_il_variants .
    DATA g_mode TYPE char1 .
    DATA g_description_language TYPE langu .
    DATA g_description TYPE /cadaxo/sqlcvari_descr .
    DATA g_description_changed TYPE char1 .
    DATA g_mode_variant TYPE char1 .

    METHODS free .
    METHODS set_mode
      IMPORTING
        !i_mode TYPE char1 .
    METHODS pbo_0100 .
    METHODS pbo_0200 .
    METHODS save_description .
    METHODS get_description_modif_status
      RETURNING
        VALUE(r_modified_status) TYPE i .
    METHODS set_description_modif_status
      IMPORTING
        !i_modified_status TYPE i .
    METHODS constructor .
    METHODS set_description_langu
      IMPORTING
        !i_langu TYPE langu .
    METHODS description_changed_data_lost
      RETURNING
        VALUE(r_proceed) TYPE char1 .
    METHODS insert_variant
      RETURNING
        VALUE(rrc) TYPE i .
    METHODS show_search_variant_popup .
    METHODS download_variants
      RETURNING
        VALUE(rrc) TYPE i .
    METHODS upload_variants .
  PROTECTED SECTION.
    CONSTANTS: BEGIN OF editor_type,
                 new TYPE char1 VALUE 'A' ##NO_TEXT,
                 old TYPE char1 VALUE '',
               END OF editor_type.
    TYPES:
      BEGIN OF ty_search_variant,
        uname TYPE string,
        table TYPE string,
        desc  TYPE string,
      END OF ty_search_variant .

    CLASS-DATA gt_node_vari TYPE treev_ntab .
    CLASS-DATA: gt_item_vari TYPE STANDARD TABLE OF mtreeitm WITH DEFAULT KEY.
    DATA abap_editor_type LIKE /cadaxo/cl_sqlc_variants=>editor_type-old.
    DATA gt_il_vnhd TYPE /cadaxo/sqlc_il_vn_t .
    DATA gt_il_vngr TYPE /cadaxo/sqlc_il_vngr_t .
    DATA gt_il_vntx TYPE /cadaxo/sqlc_il_vntx_t .
    DATA gt_symbols TYPE /cadaxo/sqlc_symbol_t .
    DATA g_behaviour_variant TYPE REF TO cl_dragdrop .
    DATA g_behaviour_group TYPE REF TO cl_dragdrop .
    DATA g_behaviour_favorite TYPE REF TO cl_dragdrop .
    DATA g_handle_tree_variant TYPE i .
    DATA g_handle_tree_group TYPE i .
    DATA g_handle_tree_favorite TYPE i .
    DATA g_drag_drop_object TYPE REF TO lcl_drag_object .
    DATA gt_il_vnfa TYPE /cadaxo/sqlc_il_vnfa_t .
    DATA gt_sqlcvargrpnode_keys TYPE /cadaxo/sqlcvargrpnode_keys_t .
    DATA g_node_key_pos TYPE lvc_nkey .
    CONSTANTS c_node_key_root TYPE lvc_nkey VALUE 'ROOT' ##NO_TEXT.
    CONSTANTS c_node_key_my_favorites TYPE lvc_nkey VALUE 'MY_FAVORITES' ##NO_TEXT.
    DATA gr_user_log TYPE REF TO /cadaxo/cl_sqlc_user_log .
    DATA g_varguid_focus TYPE /cadaxo/sqlc_variant_guid .
    DATA gs_variant_search TYPE ty_search_variant .
    DATA gc_tree_toolbar TYPE REF TO cl_gui_toolbar .
    DATA gc_custom_tree_toolbar TYPE REF TO cl_gui_custom_container .
    DATA gt_tree_toolbar_buttons TYPE ttb_button .
    DATA g_current_node_key TYPE tv_nodekey .

    METHODS refresh_tree_variants .
    METHODS search_variant
      IMPORTING
        !iv_variant     TYPE /cadaxo/sqlc_il_vn
        !iv_processed   TYPE i
      RETURNING
        VALUE(rv_found) TYPE abap_bool .
    METHODS search_for_desc
      IMPORTING
        !i_varguid      TYPE /cadaxo/sqlc_variant_guid
        !i_desc         TYPE string
      RETURNING
        VALUE(rv_found) TYPE abap_bool .
    METHODS search_for_table
      IMPORTING
        !i_varguid      TYPE /cadaxo/sqlc_variant_guid
        !i_table        TYPE string
      RETURNING
        VALUE(rv_found) TYPE abap_bool .
    METHODS set_variant_to_global
      IMPORTING
        !i_node_key TYPE /cadaxo/sqlc_folder_node_key .
    METHODS set_variant_to_local
      IMPORTING
        !i_node_key TYPE /cadaxo/sqlc_folder_node_key .
    METHODS delete_variant
      IMPORTING
        !i_node_key TYPE /cadaxo/sqlc_folder_node_key .
    METHODS rename_variant
      IMPORTING
        !i_node_key TYPE /cadaxo/sqlc_folder_node_key .
    METHODS tree_download_variant
      IMPORTING
        !i_node_key TYPE /cadaxo/sqlc_folder_node_key .
    METHODS transport_variant
      IMPORTING
        !i_node_key TYPE /cadaxo/sqlc_folder_node_key .
    METHODS get_vargroup_of_node_key
      IMPORTING
        !i_node_key       TYPE /cadaxo/sqlcnode_key
      RETURNING
        VALUE(r_vargroup) TYPE /cadaxo/sqlcvari_group .
    METHODS remove_favorite
      IMPORTING
        !i_node_key TYPE /cadaxo/sqlc_folder_node_key .
    METHODS share_variant
      IMPORTING
        !i_node_key TYPE /cadaxo/sqlc_folder_node_key .
    METHODS get_user_favorites .
    METHODS create_splitter_abap_and_symb .
    METHODS create_text_edit_description .
    METHODS create_tree_dragdrop_behaviour .
    METHODS create_tree_group .
    METHODS create_0100_controls .
    METHODS create_0200_controls .
    METHODS build_tree_variants .
    METHODS on_double_click_tree_vari_item
          FOR EVENT item_double_click OF cl_gui_column_tree
      IMPORTING
          !node_key
          !item_name .
    METHODS on_double_click_tree_vari_node
          FOR EVENT node_double_click OF cl_gui_column_tree
      IMPORTING
          !node_key .
    METHODS on_tree_drag
          FOR EVENT on_drag OF cl_gui_column_tree
      IMPORTING
          !node_key
          !item_name
          !drag_drop_object .
    METHODS on_tree_drop
          FOR EVENT on_drop OF cl_gui_column_tree
      IMPORTING
          !node_key
          !drag_drop_object .
    METHODS on_node_context_menu_req
          FOR EVENT node_context_menu_request OF cl_gui_column_tree
      IMPORTING
          !node_key
          !menu .
    METHODS on_item_context_menu_req
          FOR EVENT item_context_menu_request OF cl_gui_column_tree
      IMPORTING
          !node_key
          !menu .
    METHODS on_node_context_menu_sel
          FOR EVENT node_context_menu_select OF cl_gui_column_tree
      IMPORTING
          !node_key
          !fcode .
    METHODS on_item_context_menu_sel
          FOR EVENT item_context_menu_select OF cl_gui_column_tree
      IMPORTING
          !node_key
          !fcode .
    METHODS get_variants_and_groups .
    METHODS set_description .
    METHODS folder_toggle
      IMPORTING
        !iv_node_key TYPE tv_nodekey .
    METHODS create_tree_toolbar .
    METHODS on_tree_toolbar_funcsel
          FOR EVENT function_selected OF cl_gui_toolbar
      IMPORTING
          !fcode .
    METHODS on_selection_changed
          FOR EVENT selection_changed OF cl_gui_column_tree
      IMPORTING
          !node_key .
    METHODS set_tree_toolbar
      IMPORTING
        !node_key TYPE tv_nodekey .
    METHODS add_to_favorites
      IMPORTING
        !node_key TYPE tv_nodekey .
    METHODS remove_from_favorites
      IMPORTING
        !node_key TYPE tv_nodekey .
    METHODS undo_search_variant .

ENDCLASS.



CLASS /CADAXO/CL_SQLC_VARIANTS IMPLEMENTATION.


  METHOD add_to_favorites.

    DATA ls_sqlcvnfa TYPE /cadaxo/sqlcvnfa.
    DATA lt_nodes TYPE TABLE OF treev_node.
    DATA lt_items TYPE TABLE OF mtreeitm.
    DATA ls_il_vnfa LIKE LINE OF me->gt_il_vnfa.
    DATA ls_sqlcvari_alv LIKE LINE OF gt_il_vnhd.
    DATA ls_node TYPE treev_node.
    DATA ls_item TYPE mtreeitm.

    READ TABLE gt_il_vnhd ASSIGNING FIELD-SYMBOL(<l_sqlcvari_alv>) WITH KEY node_key = node_key.
    IF sy-subrc EQ 0.

      READ TABLE me->gt_il_vnhd WITH KEY varguid = <l_sqlcvari_alv>-varguid
                                         vargroup = 'MY_FAVORITES'
                                         TRANSPORTING NO FIELDS.

      IF sy-subrc = 0.
        MESSAGE s075(/cadaxo/sqlc)
                WITH <l_sqlcvari_alv>-varname
                DISPLAY LIKE 'E'.
      ELSE.

        CLEAR ls_sqlcvnfa.
        CLEAR lt_nodes.
        CLEAR lt_items.

        ls_sqlcvnfa-varguid = <l_sqlcvari_alv>-varguid.
        ls_sqlcvnfa-username = sy-uname.

        INSERT /cadaxo/sqlcvnfa FROM ls_sqlcvnfa.

        me->g_node_key_pos = me->g_node_key_pos + 1.

        CLEAR ls_il_vnfa.
        ls_il_vnfa-username = sy-uname.
        ls_il_vnfa-varguid = ls_sqlcvnfa-varguid.
        ls_il_vnfa-node_key = me->g_node_key_pos.
        APPEND ls_il_vnfa TO me->gt_il_vnfa.

        ls_sqlcvari_alv = CORRESPONDING #( <l_sqlcvari_alv> ).
        ls_sqlcvari_alv-flag_public = <l_sqlcvari_alv>-flag_public.
        ls_sqlcvari_alv-node_key = me->g_node_key_pos.
        ls_sqlcvari_alv-vargroup = 'MY_FAVORITES'.
        APPEND ls_sqlcvari_alv TO gt_il_vnhd.

        READ TABLE me->gt_node_vari WITH KEY node_key = node_key INTO ls_node.
        IF sy-subrc = 0.

          ls_node-node_key = me->g_node_key_pos.
          ls_node-relatkey = 'MY_FAVORITES'.
          ls_node-dragdropid = ''.
          APPEND ls_node TO lt_nodes.

          LOOP AT me->gt_item_vari INTO ls_item WHERE node_key = node_key.
            ls_item-node_key = me->g_node_key_pos.
            ls_item-t_image = ''.
            APPEND ls_item TO lt_items.
          ENDLOOP.

          g_column_tree->add_nodes_and_items( node_table                    = lt_nodes
                                              item_table                    = lt_items
                                              item_table_structure_name     = 'MTREEITM' ).

          g_column_tree->item_set_t_image(
            EXPORTING
              node_key          = node_key
              item_name         = '1'
              t_image           = CONV #( icon_system_favorites ) ).

        ENDIF.

      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD build_tree_variants.
****************************************************************************************************
* Description             : get variants for the current user                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
* 27.02.2018 |  Dusan Sacha         |  Search Variants Enhancement                | COCKPIT-291    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
    INCLUDE <icon>.

    DATA ls_node                TYPE treev_node.
    DATA ls_item                TYPE mtreeitm.
    DATA ls_sqlcvari_alv        TYPE /cadaxo/sqlc_il_vn.
    DATA l_nr_new(8)            TYPE n.
    DATA ls_sqlcvargrpnode_keys LIKE LINE OF me->gt_sqlcvargrpnode_keys.

    FIELD-SYMBOLS: <ls_sqlcvargrpnode_keys> LIKE LINE OF  me->gt_sqlcvargrpnode_keys,
                   <ls_il_vnfa>             LIKE LINE OF me->gt_il_vnfa,
                   <ls_il_vngr>             LIKE LINE OF me->gt_il_vngr,
                   <ls_il_vnhd>             LIKE LINE OF me->gt_il_vnhd,
                   <ls_il_vntx>             LIKE LINE OF me->gt_il_vntx.

    CLEAR: me->gt_node_vari,
           me->gt_item_vari,
           me->g_node_key_pos.

    LOOP AT me->gt_il_vnhd ASSIGNING <ls_il_vnhd> WHERE vargroup NE 'MY_FAVORITES'.

      READ TABLE me->gt_sqlcvargrpnode_keys WITH KEY vargroup = <ls_il_vnhd>-vargroup
         TRANSPORTING NO FIELDS.
      IF sy-subrc NE 0.
        CLEAR ls_sqlcvargrpnode_keys.
        ls_sqlcvargrpnode_keys-vargroup = <ls_il_vnhd>-vargroup.
        APPEND ls_sqlcvargrpnode_keys TO me->gt_sqlcvargrpnode_keys.
      ENDIF.
    ENDLOOP.

    LOOP AT me->gt_il_vngr ASSIGNING <ls_il_vngr>.
      READ TABLE me->gt_sqlcvargrpnode_keys WITH KEY vargroup = <ls_il_vngr>-vargroup
           ASSIGNING <ls_sqlcvargrpnode_keys>.
      IF sy-subrc EQ 0.
        <ls_sqlcvargrpnode_keys>-vargroup_desc = <ls_il_vngr>-vargroup_desc.
      ELSE.
        CLEAR ls_sqlcvargrpnode_keys.
        ls_sqlcvargrpnode_keys-vargroup = <ls_il_vngr>-vargroup.
        ls_sqlcvargrpnode_keys-vargroup_desc = <ls_il_vngr>-vargroup_desc.
        APPEND ls_sqlcvargrpnode_keys TO me->gt_sqlcvargrpnode_keys.
      ENDIF.
    ENDLOOP.

    SORT me->gt_sqlcvargrpnode_keys.

    LOOP AT me->gt_sqlcvargrpnode_keys ASSIGNING <ls_sqlcvargrpnode_keys>.
      l_nr_new = l_nr_new + 1.
      CONCATENATE 'GRP_' l_nr_new INTO <ls_sqlcvargrpnode_keys>-node_key.
    ENDLOOP.

    LOOP AT me->gt_sqlcvargrpnode_keys ASSIGNING <ls_sqlcvargrpnode_keys>.
      AT FIRST.
        CLEAR: ls_node,
               ls_item.
        ls_node-node_key = me->c_node_key_root.
        ls_node-isfolder = 'X'.
        APPEND ls_node TO gt_node_vari.


        ls_item-node_key  = me->c_node_key_root.
        ls_item-item_name = '1'.
        ls_item-class     = cl_gui_list_tree=>item_class_text.
        ls_item-alignment = cl_gui_list_tree=>align_auto.
        ls_item-font      = cl_gui_list_tree=>item_font_prop.
        ls_item-text      = text-011.
        APPEND ls_item TO gt_item_vari.

        CLEAR: ls_node,
               ls_item.
        ls_node-node_key = me->c_node_key_my_favorites.
        ls_node-isfolder = 'X'.
        ls_node-relatkey = me->c_node_key_root.
        ls_node-n_image   = icon_system_favorites.
        ls_node-exp_image = icon_system_favorites.
        ls_node-style     = cl_gui_list_tree=>style_emphasized_positive.
        ls_node-dragdropid = me->g_handle_tree_favorite.
        APPEND ls_node TO gt_node_vari.

        ls_item-node_key  = me->c_node_key_my_favorites.
        ls_item-item_name = '1'.
        ls_item-class     = cl_gui_list_tree=>item_class_text.
        ls_item-alignment = cl_gui_list_tree=>align_auto.
        ls_item-font      = cl_gui_list_tree=>item_font_prop.
        ls_item-text      = text-006.
        APPEND ls_item TO gt_item_vari.

      ENDAT.

      CLEAR: ls_node,
             ls_item.

      ls_node-node_key  = <ls_sqlcvargrpnode_keys>-node_key.
      ls_node-relatkey  = me->c_node_key_root.
      ls_node-isfolder  = 'X'.
      ls_node-relatship = cl_gui_list_tree=>relat_last_child.
      ls_node-dragdropid = me->g_handle_tree_group.
      APPEND ls_node TO gt_node_vari.

      IF <ls_sqlcvargrpnode_keys>-vargroup IS INITIAL.
        ls_item-text      = text-001.
      ELSE.
        ls_item-text      = <ls_sqlcvargrpnode_keys>-vargroup.
      ENDIF.

      ls_item-node_key  = ls_node-node_key.
      ls_item-item_name = '1'.
      ls_item-class     = cl_gui_list_tree=>item_class_text.
      ls_item-alignment = cl_gui_list_tree=>align_auto.
      ls_item-font      = cl_gui_list_tree=>item_font_prop.
      APPEND ls_item TO gt_item_vari.

      ls_item-item_name = '2'.
      ls_item-text = <ls_sqlcvargrpnode_keys>-vargroup_desc.
      APPEND ls_item TO gt_item_vari.

    ENDLOOP.
    IF sy-subrc NE 0.
      CLEAR: ls_node, ls_item.
      ls_node-node_key = me->c_node_key_root.
      ls_node-isfolder = abap_true.
      APPEND ls_node TO gt_node_vari.

      ls_item-node_key  = me->c_node_key_root.
      ls_item-item_name = '1'.
      ls_item-class     = cl_gui_list_tree=>item_class_text.
      ls_item-alignment = cl_gui_list_tree=>align_auto.
      ls_item-font      = cl_gui_list_tree=>item_font_prop.
      ls_item-text      = text-011.
      APPEND ls_item TO gt_item_vari.

    ENDIF.

    LOOP AT me->gt_il_vnhd ASSIGNING <ls_il_vnhd> WHERE vargroup NE 'MY_FAVORITES'.

      CLEAR: ls_sqlcvari_alv,
             ls_node,
             ls_item.

      me->g_node_key_pos = me->g_node_key_pos + 1.
      <ls_il_vnhd>-node_key = me->g_node_key_pos.

      IF gs_variant_search IS NOT INITIAL.      "COCKPIT-291

        IF NOT me->search_variant(              "COCKPIT-291
          EXPORTING                             "COCKPIT-291
            iv_variant        = <ls_il_vnhd>    "COCKPIT-291
            iv_processed      = sy-tabix        "COCKPIT-291
        ).                                      "COCKPIT-291
          CONTINUE.                             "COCKPIT-291
        ENDIF.                                  "COCKPIT-291

      ENDIF.                                    "COCKPIT-291


      MOVE-CORRESPONDING <ls_il_vnhd> TO ls_sqlcvari_alv.

* variants without user are global variants
      MOVE <ls_il_vnhd>-flag_public TO ls_sqlcvari_alv-flag_public.

      MOVE me->g_node_key_pos TO ls_sqlcvari_alv-node_key.

      CLEAR: ls_node,
             ls_item.
      ls_node-node_key = me->g_node_key_pos.

      READ TABLE me->gt_sqlcvargrpnode_keys
           ASSIGNING <ls_sqlcvargrpnode_keys>
           WITH KEY vargroup = <ls_il_vnhd>-vargroup.

      ls_node-relatkey = <ls_sqlcvargrpnode_keys>-node_key.
      IF ls_node-relatkey IS INITIAL.
        MOVE 'NONE' TO ls_node-relatkey.
      ENDIF.
      IF ls_sqlcvari_alv-flag_public = 'X'.
        ls_node-n_image   = icon_shared_position. "Global
      ELSE.
        ls_node-n_image   = icon_hr_position.
      ENDIF.
      ls_node-relatship = cl_gui_list_tree=>relat_last_child.
      ls_node-dragdropid = me->g_handle_tree_variant.
      APPEND ls_node TO gt_node_vari.

      CLEAR ls_item.
      ls_item-node_key  = me->g_node_key_pos.
      ls_item-item_name = '1'.
      ls_item-class     = cl_gui_list_tree=>item_class_text.
      ls_item-text      = <ls_il_vnhd>-varname.
      ls_item-length = 20.
      IF <ls_il_vnhd>-cruser NE sy-uname.
        ls_item-style = cl_gui_column_tree=>style_inactive.
      ENDIF.

      IF line_exists( me->gt_il_vnfa[ varguid = <ls_il_vnhd>-varguid ] ).
        ls_item-t_image = icon_system_favorites.
      ENDIF.

      APPEND ls_item TO gt_item_vari.

* Short description
      CLEAR ls_item.
      ls_item-node_key  = me->g_node_key_pos.
      ls_item-item_name = '2'.
      ls_item-class     = cl_gui_list_tree=>item_class_text.

      READ TABLE me->gt_il_vntx WITH KEY varguid = <ls_il_vnhd>-varguid langu = sy-langu ASSIGNING <ls_il_vntx>.
      IF sy-subrc EQ 0.
        ls_item-text      = <ls_il_vntx>-vardescription.
      ENDIF.
      ls_item-length = 20.
      APPEND ls_item TO gt_item_vari.

* Favorites
      LOOP AT me->gt_il_vnfa ASSIGNING <ls_il_vnfa> WHERE varguid = <ls_il_vnhd>-varguid.

        CLEAR: ls_node,
               ls_item.

        me->g_node_key_pos = me->g_node_key_pos + 1.
        <ls_il_vnfa>-node_key = me->g_node_key_pos.

        MOVE-CORRESPONDING <ls_il_vnhd> TO ls_sqlcvari_alv.
        MOVE <ls_il_vnhd>-flag_public TO ls_sqlcvari_alv-flag_public.
        MOVE me->g_node_key_pos TO ls_sqlcvari_alv-node_key.
        MOVE 'MY_FAVORITES' TO ls_sqlcvari_alv-vargroup.
        APPEND ls_sqlcvari_alv TO gt_il_vnhd.

        CLEAR: ls_node,
               ls_item.
        ls_node-node_key = me->g_node_key_pos.
        ls_node-relatkey = 'MY_FAVORITES'.
        IF ls_sqlcvari_alv-flag_public = 'X'.
          ls_node-n_image   = icon_shared_position. "Global
        ELSE.
          ls_node-n_image   = icon_hr_position.
        ENDIF.
        ls_node-relatship = cl_gui_list_tree=>relat_last_child.
        APPEND ls_node TO gt_node_vari.

        CLEAR ls_item.
        ls_item-node_key  = me->g_node_key_pos.
        ls_item-item_name = '1'.
        ls_item-class     = cl_gui_list_tree=>item_class_text.
        ls_item-text      = <ls_il_vnhd>-varname.
        ls_item-length = 20.
        IF <ls_il_vnhd>-cruser NE sy-uname.
          ls_item-style = cl_gui_column_tree=>style_inactive.
        ENDIF.
        APPEND ls_item TO gt_item_vari.

* Short description
        CLEAR ls_item.
        ls_item-node_key  = me->g_node_key_pos.
        ls_item-item_name = '2'.
        ls_item-class     = cl_gui_list_tree=>item_class_text.
        READ TABLE me->gt_il_vntx WITH KEY varguid = <ls_il_vnhd>-varguid langu = sy-langu ASSIGNING <ls_il_vntx>.
        IF sy-subrc EQ 0.
          ls_item-text      = <ls_il_vntx>-vardescription.
        ENDIF.
        ls_item-length = 20.
        APPEND ls_item TO gt_item_vari.

      ENDLOOP.

    ENDLOOP.


* sort global table
    SORT gt_il_vnhd BY varname flag_public DESCENDING.

  ENDMETHOD.


  METHOD constructor.
    DATA: is_its TYPE char1.
    CALL FUNCTION 'GUI_IS_ITS'
      IMPORTING
        return = is_its.
    IF is_its = abap_true OR cl_gui_frontend_services=>activex <> gfw_true.
      me->abap_editor_type = editor_type-old.
    ENDIF.
    me->g_description_language = sy-langu.

  ENDMETHOD.


  METHOD create_0100_controls.
****************************************************************************************************
* Description             : Create 0100 Controls                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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

    IF g_cc_tree IS INITIAL.

      me->create_tree_toolbar( ).

* create drag/drop behaviour
      me->create_tree_dragdrop_behaviour( ).

* get user's favorites
      me->get_user_favorites( ).

* get variant & groups
      me->get_variants_and_groups( ).

* build tree variants
      me->build_tree_variants( ).

* create tree
      me->create_tree_group( ).

* create splitter control (abap and symbols)
      me->create_splitter_abap_and_symb( ).

* create text edit
      me->create_text_edit_description( ).

    ENDIF.

  ENDMETHOD.


  METHOD create_0200_controls.

    "begin of COCKPIT-321 KA
    LOOP AT SCREEN.
      IF screen-name EQ 'GCL_CONTROLLER->GS_IL_VARIANTS-VARNAME'
      AND me->g_mode_variant = 'U'.
        screen-input = 0.
        CLEAR: me->g_mode_variant.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
    "end   of COCKPIT-321

  ENDMETHOD.


  METHOD create_splitter_abap_and_symb.
****************************************************************************************************
* Description             : create splitter for abap/symbols                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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

    DATA lt_lfc_t_fcat        TYPE lvc_t_fcat.
    DATA l_lvc_s_layo         TYPE lvc_s_layo.
    DATA lt_fieldcat          TYPE slis_t_fieldcat_alv.
    DATA l_lvc_s_fcat         TYPE lvc_s_fcat.

    FIELD-SYMBOLS: <l_fieldcat>         TYPE slis_fieldcat_alv.

* create custom control
    CREATE OBJECT g_cc_splitter_abap_and_vers
      EXPORTING
        container_name = 'CC_VERSION_AND_ABAP'.

* create splitter control
    CREATE OBJECT g_splitter_abap_vers
      EXPORTING
        parent  = g_cc_splitter_abap_and_vers
        rows    = 2
        columns = 1.

    g_splitter_abap_vers->set_row_height( id = 1 height = 75 ).

    g_cc_abap     = g_splitter_abap_vers->get_container( row = 1 column = 1 ).
    g_cc_symbols = g_splitter_abap_vers->get_container( row = 2 column = 1 ).


* create abap editor
    IF me->abap_editor_type = editor_type-new.
      g_abap_editor = NEW #( g_cc_abap ).
      g_abap_editor->set_statusbar_mode( 0 ).
      g_abap_editor->set_readonly_mode( 1 ).
    ELSE.
      g_abap_editor_text = NEW #( g_cc_abap ).
      g_abap_editor_text->set_statusbar_mode( 0 ).
      g_abap_editor_text->set_readonly_mode( 1 ).
    ENDIF.



    CREATE OBJECT g_symbols
      EXPORTING
        i_parent = g_cc_symbols.

    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = '/CADAXO/SQLC_SYMBOL'
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    LOOP AT lt_fieldcat ASSIGNING <l_fieldcat>.
      CLEAR: l_lvc_s_fcat.
      MOVE-CORRESPONDING <l_fieldcat> TO l_lvc_s_fcat.
      MOVE <l_fieldcat>-seltext_m TO l_lvc_s_fcat-scrtext_m.
      MOVE <l_fieldcat>-seltext_l TO l_lvc_s_fcat-scrtext_l.
      MOVE <l_fieldcat>-seltext_s TO l_lvc_s_fcat-scrtext_s.
      CASE <l_fieldcat>-fieldname.
        WHEN 'SYMBOL_NAME'.
          l_lvc_s_fcat-key = 'X'.
          l_lvc_s_fcat-outputlen = '22'.
        WHEN 'SYMBOL_VALUE'.
          l_lvc_s_fcat-outputlen = '34'.
        WHEN 'SYMBOL_DESC'.
          l_lvc_s_fcat-outputlen = '34'.
        WHEN 'TYPE'.
          l_lvc_s_fcat-no_out = 'X'.
          l_lvc_s_fcat-tech   = 'X'.
      ENDCASE.
      APPEND l_lvc_s_fcat TO lt_lfc_t_fcat.
    ENDLOOP.

    l_lvc_s_layo-zebra      = 'X'.
    l_lvc_s_layo-stylefname = 'CELL_STYLE'.
    l_lvc_s_layo-no_toolbar = 'X'.

    g_symbols->set_table_for_first_display(
      EXPORTING
        i_bypassing_buffer            = 'X'
        is_layout                     = l_lvc_s_layo
      CHANGING
        it_outtab                     = gt_symbols
        it_fieldcatalog               = lt_lfc_t_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4 ).

  ENDMETHOD.


  METHOD create_text_edit_description.
****************************************************************************************************
* Description             : create text edit for description                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxx xxxxxxx                   *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    CREATE OBJECT g_cc_description
      EXPORTING
        container_name = 'CC_DESCRIPTION'.

    CREATE OBJECT g_text_edit_description
      EXPORTING
        parent = g_cc_description.

    g_text_edit_description->set_toolbar_mode( '0' ).
    g_text_edit_description->set_statusbar_mode( '0' ).
    g_text_edit_description->set_readonly_mode( '1' ).

  ENDMETHOD.


  METHOD create_tree_dragdrop_behaviour.
****************************************************************************************************
* Description             : Create Drag/Drop Behaviour                                             *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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

* variant behaviour
    CREATE OBJECT g_behaviour_variant.

    g_behaviour_variant->add( EXPORTING flavor     = 'NODE_MOVE'
                                        dragsrc    = 'X'
                                        droptarget = ''
                                        effect     = cl_dragdrop=>move ).

* group behaviour
    CREATE OBJECT g_behaviour_group.

    g_behaviour_group->add( EXPORTING flavor     = 'NODE_MOVE'
                                      dragsrc    = ''
                                      droptarget = 'X'
                                      effect     = cl_dragdrop=>move ).

* favorite behaviour
    CREATE OBJECT g_behaviour_favorite.

    g_behaviour_favorite->add( EXPORTING flavor     = 'NODE_MOVE'
                                         dragsrc    = ' '
                                         droptarget = 'X'
                                         effect     = cl_dragdrop=>move ).

    g_behaviour_favorite->add( EXPORTING flavor     = 'NODE_FAVORITE'
                                         dragsrc    = 'X'
                                         droptarget = 'X'
                                         effect     = cl_dragdrop=>move ).

* get handles
    g_behaviour_variant->get_handle( IMPORTING handle = g_handle_tree_variant ).
    g_behaviour_group->get_handle( IMPORTING handle = g_handle_tree_group ).
    g_behaviour_favorite->get_handle( IMPORTING handle = g_handle_tree_favorite ).

  ENDMETHOD.


  METHOD create_tree_group.
****************************************************************************************************
* Description             : Create Tree                                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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

    DATA l_hierarchy_header TYPE treev_hhdr.
    DATA ls_event           TYPE cntl_simple_event.
    DATA lt_events          TYPE cntl_simple_events.

    l_hierarchy_header-heading = text-t01.
    l_hierarchy_header-width = 45.

* create custom control for tree
    CREATE OBJECT g_cc_tree
      EXPORTING
        container_name = 'CC_VARIANTS_TREE'.

* create tree
    CREATE OBJECT g_column_tree
      EXPORTING
        parent                = g_cc_tree
        node_selection_mode   = cl_gui_column_tree=>node_sel_mode_single
        item_selection        = abap_false
        hierarchy_column_name = '1'
        hierarchy_header      = l_hierarchy_header.

* add dummy column
    g_column_tree->add_column( name = '2'
                               width = 63
                               header_text = text-t03 ).

* add nodes and items
    g_column_tree->add_nodes_and_items( node_table                    = me->gt_node_vari
                                        item_table                    = me->gt_item_vari
                                        item_table_structure_name     = 'MTREEITM' ).

* open root and my history
    g_column_tree->expand_node(
       EXPORTING node_key   = me->c_node_key_root
           level_count      = '0'
           expand_subtree   = abap_false
         EXCEPTIONS OTHERS = 1 ).

    g_column_tree->expand_node(
       EXPORTING node_key   = me->c_node_key_my_favorites
           level_count      = '1'
           expand_subtree   = abap_false
         EXCEPTIONS
           OTHERS  = 1 ).

    lt_events = VALUE #( ( eventid = cl_gui_column_tree=>eventid_node_context_menu_req appl_event = abap_true )
                         ( eventid = cl_gui_column_tree=>eventid_selection_changed     appl_event = abap_true ) ).

    g_column_tree->set_registered_events( lt_events ).

    g_column_tree->set_disable_sel_change_ctx_men( abap_true ).

* register handler
    SET HANDLER me->on_selection_changed               FOR g_column_tree.
    SET HANDLER me->on_double_click_tree_vari_node     FOR g_column_tree.
    SET HANDLER me->on_node_context_menu_req           FOR g_column_tree.
    SET HANDLER me->on_node_context_menu_sel           FOR g_column_tree.
    SET HANDLER me->on_double_click_tree_vari_item     FOR g_column_tree.
    SET HANDLER me->on_item_context_menu_req           FOR g_column_tree.
    SET HANDLER me->on_item_context_menu_sel           FOR g_column_tree.
    SET HANDLER me->on_tree_drag                       FOR g_column_tree.
    SET HANDLER me->on_tree_drop                       FOR g_column_tree.

  ENDMETHOD.


  METHOD create_tree_toolbar.

    DATA ls_stb_button TYPE stb_button.
    DATA lt_events TYPE cntl_simple_events.

    gc_custom_tree_toolbar = NEW #( container_name = 'TREE_TOOLBAR' ).

    gc_tree_toolbar = NEW #( parent = gc_custom_tree_toolbar
                             display_mode = cl_gui_toolbar=>m_mode_horizontal ).

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_ADD_TO_FAVORITES'.
    ls_stb_button-icon      = icon_insert_favorites.
    ls_stb_button-quickinfo = text-022.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_REMOVE_FAVORITE'.
    ls_stb_button-icon      = icon_delete_favorites.
    ls_stb_button-quickinfo = text-008.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_FILTER_VARIANT'.
    ls_stb_button-icon      = icon_filter.
    ls_stb_button-quickinfo = text-012.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_FILTER_VARIANT_UNDO'.
    ls_stb_button-icon      = icon_filter_undo.
    ls_stb_button-quickinfo = text-t07.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_MAKE_PUBLIC'.
    ls_stb_button-icon      = icon_shared_position.
    ls_stb_button-quickinfo = text-009.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_MAKE_PRIVATE'.
    ls_stb_button-icon      = icon_hr_position.
    ls_stb_button-quickinfo = text-010.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_RENAME_VARIANT'.
    ls_stb_button-icon      = icon_rename.
    ls_stb_button-quickinfo = text-t06.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_DELETE_VARIANT'.
    ls_stb_button-icon      = icon_delete.
    ls_stb_button-quickinfo = text-t02.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_ADD_TO_TRANSPORT'.
    ls_stb_button-icon      = icon_transport.
    ls_stb_button-quickinfo = text-015.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_EXPORT_VARIANT'.
    ls_stb_button-icon      = icon_export.
    ls_stb_button-quickinfo = text-020.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_IMPORT_VARIANT'.
    ls_stb_button-icon      = icon_import.
    ls_stb_button-quickinfo = text-021.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TREE_TOOLBAR_SHARE_VARIANT'.
    ls_stb_button-icon      = icon_workflow_external_event.
    ls_stb_button-quickinfo = text-019.
    ls_stb_button-butn_type = cntb_btype_button.
    ls_stb_button-disabled  = abap_true.
    APPEND ls_stb_button TO   gt_tree_toolbar_buttons.

    gc_tree_toolbar->add_button_group( gt_tree_toolbar_buttons ).

    lt_events = VALUE #( ( eventid = cl_gui_toolbar=>m_id_function_selected appl_event = abap_false ) ).

    gc_tree_toolbar->set_registered_events( events = lt_events ).

    SET HANDLER me->on_tree_toolbar_funcsel  FOR gc_tree_toolbar.

  ENDMETHOD.


  METHOD delete_variant.
****************************************************************************************************
* Description             : Delete a variant                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxx xxxxxxx                   *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_answer    TYPE c.
    DATA l_row_index TYPE i.
    DATA ls_il_vnfa  LIKE LINE OF me->gt_il_vnfa.
    DATA lr_cx_sql_variant TYPE REF TO /cadaxo/cx_sqlc_variant.
    DATA l_error_message TYPE string.

    FIELD-SYMBOLS: <ls_variant> LIKE LINE OF me->gt_il_vnhd.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = i_node_key ASSIGNING <ls_variant>.
    IF sy-subrc EQ 0.

      l_row_index = sy-tabix.

* are you sure?
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = text-t02 "Delete Variant
          icon_button_1         = 'ICON_CHECKED'
          text_question         = text-q02 "Do you realy want to delete the variant
          text_button_2         = text-b06
          icon_button_2         = 'ICON_INCOMPLETE'
          default_button        = '2'
          display_cancel_button = ''
        IMPORTING
          answer                = l_answer.
      IF l_answer EQ '1'.

        TRY.
            /cadaxo/cl_sqlc_variant=>delete_variant( i_varguid = <ls_variant>-varguid ).

            g_column_tree->delete_node( i_node_key ).

            READ TABLE me->gt_il_vnfa WITH KEY varguid = <ls_variant>-varguid
                                      INTO ls_il_vnfa.
            IF sy-subrc EQ 0.

              DELETE me->gt_il_vnfa WHERE varguid = <ls_variant>-varguid.

              g_column_tree->delete_node( ls_il_vnfa-node_key ).

            ENDIF.

            DELETE me->gt_il_vntx WHERE varguid = <ls_variant>-varguid.

            IF <ls_variant>-flag_public IS INITIAL.
              MESSAGE s004(/cadaxo/sqlcvariants) WITH <ls_variant>-varname.
            ELSE.
              MESSAGE s003(/cadaxo/sqlcvariants) WITH <ls_variant>-varname.
            ENDIF.

            READ TABLE me->gt_sqlcvargrpnode_keys WITH KEY vargroup = <ls_variant>-vargroup ASSIGNING FIELD-SYMBOL(<group_key>).
            IF sy-subrc = 0.
              g_column_tree->set_selected_node( node_key = <group_key>-node_key ).
            ENDIF.

            DELETE me->gt_il_vnhd INDEX l_row_index.

          CATCH /cadaxo/cx_sqlc_variant INTO lr_cx_sql_variant.
            l_error_message = lr_cx_sql_variant->get_text( ).
            MESSAGE l_error_message TYPE 'S' DISPLAY LIKE 'E'.
        ENDTRY.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD description_changed_data_lost.
    DATA l_description_modif_status TYPE i.
    DATA l_answer TYPE c LENGTH 1.

    l_description_modif_status = me->get_description_modif_status( ).

    IF l_description_modif_status EQ 1 OR me->g_description_changed = abap_true.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = text-t04
          icon_button_1         = 'ICON_CHECKED'
          text_question         = text-q03
          icon_button_2         = 'ICON_INCOMPLETE'
          default_button        = '2'
          display_cancel_button = ''
        IMPORTING
          answer                = l_answer.
      IF l_answer EQ '1'.
        r_proceed = abap_true.
      ELSE.
        r_proceed = abap_false.
      ENDIF.
    ELSE.
      r_proceed = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD download_variants.

    DATA l_mtext   TYPE mtext_d.

* check namespace
    SELECT SINGLE mtext FROM t000 INTO l_mtext WHERE mandt = sy-mandt.
    IF strlen( me->gs_il_variants-varname ) >= 8 AND me->gs_il_variants-varname(8) EQ '/CADAXO/'.
      IF l_mtext NE 'CADAXO'.
        MESSAGE e017(/cadaxo/sqlc).
      ELSE.
        MESSAGE w017(/cadaxo/sqlc).
      ENDIF.
    ENDIF.

* check authorization for global variants
    IF me->gs_il_variants-flag_public NE space.
      AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        MESSAGE e032(/cadaxo/sqlc).
      ENDIF.
    ENDIF.

* check empty name
    IF me->gs_il_variants-varname EQ space.
      MESSAGE e032(/cadaxo/sqlc).
    ENDIF.

    TRY.
        /cadaxo/cl_sqlc_variant=>download_variant(
        EXPORTING
          i_il_variant = me->gs_il_variants ).
        rrc = 0.
      CATCH /cadaxo/cx_sqlc_variant.
        rrc = 1.
    ENDTRY.

  ENDMETHOD.


  METHOD folder_toggle.
    DATA lt_nodes TYPE treev_nks.
    g_column_tree->get_expanded_nodes( CHANGING   node_key_table = lt_nodes
                                       EXCEPTIONS OTHERS         = 1 ).

    IF line_exists( lt_nodes[ table_line = iv_node_key ] ).

      g_column_tree->collapse_nodes( EXPORTING node_key_table = VALUE #( ( iv_node_key ) )
                                     EXCEPTIONS OTHERS        = 5 ).


    ELSE.

      g_column_tree->expand_node( EXPORTING  node_key = iv_node_key
                                  EXCEPTIONS OTHERS   = 6 ).
    ENDIF.
  ENDMETHOD.


  METHOD free.

    IF NOT g_cc_tree IS INITIAL.
      g_cc_tree->free( ).
    ENDIF.

    IF NOT g_cc_description IS INITIAL.
      g_cc_description->free( ).
    ENDIF.

    IF NOT g_cc_splitter_abap_and_vers IS INITIAL.
      g_cc_splitter_abap_and_vers->free( ).
    ENDIF.

    IF NOT gc_custom_tree_toolbar IS INITIAL.
      gc_custom_tree_toolbar->free( ).
    ENDIF.

    FREE: g_abap_editor,
          g_abap_editor_text,
          g_symbols,
          g_text_edit_description,
          g_column_tree,
          g_drag_drop_object,
          g_cc_abap,
          g_cc_symbols,
          g_splitter_abap_vers,
          g_cc_tree,
          g_cc_description,
          gc_tree_toolbar.

  ENDMETHOD.


  METHOD get_description_modif_status.
    IF NOT g_text_edit_description IS INITIAL.
      g_text_edit_description->get_textmodified_status( IMPORTING status = r_modified_status ).
    ENDIF.
  ENDMETHOD.


  METHOD get_user_favorites.
****************************************************************************************************
* Description             : get user's favorites                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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

* clear local table
    CLEAR: me->gt_il_vnfa.

* user favorites
    SELECT * FROM /cadaxo/sqlcvnfa
             INTO CORRESPONDING FIELDS OF TABLE me->gt_il_vnfa
             WHERE username EQ sy-uname.

  ENDMETHOD.


  METHOD get_vargroup_of_node_key.
****************************************************************************************************
* Description             : get vargroup of node key                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxx xxxxxxx                   *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
    FIELD-SYMBOLS: <ls_sqlcvargrpnode_keys> LIKE LINE OF me->gt_sqlcvargrpnode_keys.

    READ TABLE me->gt_sqlcvargrpnode_keys WITH KEY node_key = i_node_key
          ASSIGNING <ls_sqlcvargrpnode_keys>.
    IF sy-subrc EQ 0.
      r_vargroup = <ls_sqlcvargrpnode_keys>-vargroup.
    ENDIF.
  ENDMETHOD.


  METHOD get_variants_and_groups.
****************************************************************************************************
* Description             : get variants and groups                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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
    CLEAR: me->gt_il_vnhd,
           me->gt_il_vngr,
           me->gt_il_vntx.

* get variants
    /cadaxo/cl_sqlc_variant=>get_variants( EXPORTING i_cruser = sy-uname
                                           IMPORTING et_variants = me->gt_il_vnhd
                                                     et_variants_desc = me->gt_il_vntx ).

* get variant groups
    me->gt_il_vngr = /cadaxo/cl_sqlc_variant=>get_groups( ).

  ENDMETHOD.


  METHOD insert_variant.
****************************************************************************************************
* Description             : insert variant                                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.09.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 30.11.2010                                                             *
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

    DATA l_varguid TYPE /cadaxo/sqlc_variant_guid.
    DATA l_answer  TYPE c LENGTH 1.
    DATA l_mtext   TYPE mtext_d.

* check namespace
    SELECT SINGLE mtext FROM t000 INTO l_mtext WHERE mandt = sy-mandt.
    IF strlen( me->gs_il_variants-varname ) >= 8 AND me->gs_il_variants-varname(8) EQ '/CADAXO/'.
      IF l_mtext NE 'CADAXO'.
        MESSAGE e017(/cadaxo/sqlc).
      ELSE.
        MESSAGE w017(/cadaxo/sqlc).
      ENDIF.
    ENDIF.

* check authorization for global variants
    IF me->gs_il_variants-flag_public NE space.
      AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        MESSAGE e032(/cadaxo/sqlc).
      ENDIF.
    ENDIF.

* check empty name
    IF me->gs_il_variants-varname EQ space.
      MESSAGE e032(/cadaxo/sqlc).
    ENDIF.

    IF NOT me->gs_il_variants-varguid IS INITIAL.
      SELECT SINGLE varguid FROM /cadaxo/sqlcvnhd INTO l_varguid WHERE varguid = me->gs_il_variants-varguid.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = text-t05
            icon_button_1         = 'ICON_CHECKED'
            text_question         = text-q04
            text_button_2         = text-b07
            icon_button_2         = 'ICON_CREATE'
            default_button        = '1'
            display_cancel_button = 'X'
          IMPORTING
            answer                = l_answer.
        CASE l_answer.
          WHEN '1'. "overwrite

          WHEN '2'. "new
            CLEAR me->gs_il_variants-varguid.
          WHEN OTHERS.
            RETURN.
        ENDCASE.
      ENDIF.
    ENDIF.

    TRY.
        /cadaxo/cl_sqlc_variant=>insert_variant(
        EXPORTING
          i_il_variant = me->gs_il_variants ).
        rrc = 0.
      CATCH /cadaxo/cx_sqlc_variant.
        rrc = 1.
    ENDTRY.

  ENDMETHOD.


  METHOD on_double_click_tree_vari_item.
    me->on_double_click_tree_vari_node( node_key = node_key ).
  ENDMETHOD.


  METHOD on_double_click_tree_vari_node.
    DATA lt_text              TYPE STANDARD TABLE OF text255.
    DATA l_readonly_mode      TYPE i.
    DATA l_descr_modif_status TYPE i.
    DATA l_tmp_il_variants    LIKE me->gs_il_variants.
    DATA lr_exception         TYPE REF TO /cadaxo/cx_sqlc_variant.
    DATA l_message            TYPE string.

    FIELD-SYMBOLS: <l_sqlcvari_alv> TYPE /cadaxo/sqlc_il_vn.

    CLEAR l_descr_modif_status.

    IF me->description_changed_data_lost( ) EQ abap_false.
      RETURN.
    ENDIF.

    IF NOT me->gs_il_variants-varguid IS INITIAL.
      /cadaxo/cl_sqlc_variant=>unlock_variant( me->gs_il_variants-varguid ).
    ENDIF.

* read the variant from the global table
    READ TABLE gt_il_vnhd ASSIGNING <l_sqlcvari_alv> WITH KEY node_key = node_key.
    IF sy-subrc EQ 0.

* lock variant
      IF me->g_mode EQ 'R'.
        me->g_mode = 'G'.
      ENDIF.

      TRY.
          /cadaxo/cl_sqlc_variant=>lock_variant( <l_sqlcvari_alv>-varguid ).
        CATCH /cadaxo/cx_sqlc_variant INTO lr_exception.
          l_message = lr_exception->get_text( ).

          MESSAGE l_message TYPE 'S' DISPLAY LIKE 'E'.

          IF me->g_mode = 'I'.
            RETURN.
          ELSE.
            me->g_mode = 'R'.
          ENDIF.

      ENDTRY.

* get variant details
      IF me->g_mode EQ 'I'.
        l_tmp_il_variants = me->gs_il_variants.
      ENDIF.

      /cadaxo/cl_sqlc_variant=>get_variant( EXPORTING i_varguid      = <l_sqlcvari_alv>-varguid
                                            IMPORTING es_sqlcvari_il = gs_il_variants ).

      IF me->g_mode EQ 'I'.
        me->gs_il_variants-t_sql    = l_tmp_il_variants-t_sql.
        me->gs_il_variants-t_symbol = l_tmp_il_variants-t_symbol.
      ENDIF.

* set focus object
      me->g_varguid_focus = <l_sqlcvari_alv>-varguid.

* set abap editor
      IF me->g_mode EQ 'G' OR me->g_mode EQ 'R'.
        IF g_abap_editor IS BOUND.
          g_abap_editor->set_text( EXPORTING  table  = gs_il_variants-t_sql
                                   EXCEPTIONS OTHERS = 1 ).
        ELSEIF g_abap_editor_text IS BOUND.
          g_abap_editor_text->set_text_as_r3table( EXPORTING  table  = gs_il_variants-t_sql
                                                   EXCEPTIONS OTHERS = 1 ).
        ENDIF.

* set symbols
        me->gt_symbols = gs_il_variants-t_symbol.

* set description
        me->set_description( ).

        IF <l_sqlcvari_alv>-cruser EQ sy-uname.
          l_readonly_mode = 0.
        ELSE.
          AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '02'. "Change
          IF sy-subrc NE 0.
            l_readonly_mode = 1.
          ELSE.
            l_readonly_mode = 0.
          ENDIF.
        ENDIF.

        IF me->g_mode EQ 'R'.
          l_readonly_mode = 1.
        ENDIF.

        IF NOT g_text_edit_description IS INITIAL.
          g_text_edit_description->set_readonly_mode( l_readonly_mode ).
        ENDIF.
* set table symbols
        IF NOT me->g_symbols IS INITIAL.
          me->g_symbols->refresh_table_display( ).
        ENDIF.

* clear change flag
        me->g_description_changed = space.

      ELSE.
        cl_gui_cfw=>set_new_ok_code( new_code = 'VARI_SEL' ).
      ENDIF.
    ELSE.

      CLEAR me->gs_il_variants.
      CLEAR me->gt_symbols.
      IF g_abap_editor IS BOUND.
        g_abap_editor->delete_text( from_line = 1
                                    from_pos  = 1
                                    to_line   = 999
                                    to_pos    = 999 ).
      ELSEIF g_abap_editor_text IS BOUND.
        g_abap_editor_text->delete_text(  ).
      ENDIF.

      me->g_symbols->refresh_table_display( ).
      g_text_edit_description->set_readonly_mode( 1 ).
      g_text_edit_description->delete_text( ).
      me->g_description = space.
      " folder_toggle( iv_node_key = node_key ).
    ENDIF.

    me->set_tree_toolbar( node_key ).
  ENDMETHOD.


  METHOD on_item_context_menu_req.
    me->on_node_context_menu_req( node_key = node_key menu = menu ).
  ENDMETHOD.


  METHOD on_item_context_menu_sel.
    me->on_node_context_menu_sel( node_key = node_key fcode = fcode ).
  ENDMETHOD.


  METHOD on_node_context_menu_req.

    DATA l_add_favorite_disabled TYPE abap_bool.
    DATA l_remove_favorite_disabled TYPE abap_bool.
    DATA l_transport_variant_disabled TYPE abap_bool.
    DATA l_delete_variant_disabled TYPE abap_bool.
    DATA l_to_global_variant_disabled TYPE abap_bool.
    DATA l_to_local_variant_disabled TYPE abap_bool.

    IF me->g_mode NE 'G' AND me->g_mode NE 'R'.
      RETURN.
    ENDIF.

    DATA l_disabled(1).

    FIELD-SYMBOLS: <ls_variant>  LIKE LINE OF me->gt_il_vnhd.

    IF node_key CO ' 0123456789'.
      READ TABLE me->gt_il_vnhd WITH KEY node_key = node_key ASSIGNING <ls_variant>.
      IF sy-subrc EQ 0.

        IF <ls_variant>-vargroup EQ 'MY_FAVORITES'.
          l_add_favorite_disabled = abap_true.
        ELSE.

          IF line_exists( me->gt_il_vnhd[ varguid = <ls_variant>-varguid vargroup = 'MY_FAVORITES' ] ).
            l_add_favorite_disabled = abap_true.
          ELSE.
            l_remove_favorite_disabled = abap_true.
          ENDIF.

        ENDIF.

* change variant
        IF <ls_variant>-cruser EQ sy-uname.
          l_to_global_variant_disabled = space.
          l_to_local_variant_disabled = space.
        ELSE.
          AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '02'. "Change
          IF sy-subrc NE 0.
            l_to_global_variant_disabled = abap_true.
            l_to_local_variant_disabled = abap_true.
          ENDIF.
        ENDIF.

        IF <ls_variant>-flag_public EQ abap_true.
          l_to_global_variant_disabled = abap_true.

        ELSE.
          l_to_local_variant_disabled = abap_true.

        ENDIF.

* delete variant
        IF <ls_variant>-cruser EQ sy-uname.
          l_delete_variant_disabled = space.
        ELSE.
          AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '06'. "Delete
          IF sy-subrc NE 0.
            l_delete_variant_disabled = abap_true.
          ENDIF.
        ENDIF.


* add variant to transport request
        IF <ls_variant>-cruser EQ sy-uname.
          l_transport_variant_disabled = space.
        ELSE.
          AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '21'. "Delete
          IF sy-subrc NE 0.
            l_transport_variant_disabled = abap_true.
          ENDIF.
        ENDIF.

        menu->add_function( text = text-022 fcode = 'ADD_FAVORITE' disabled = l_add_favorite_disabled ).

        menu->add_function( text = text-008 fcode = 'REMOVE_FAVORITE' disabled = l_remove_favorite_disabled ).

        menu->add_separator( ).

        menu->add_function( text = text-010 fcode = 'SET_GO_LOCAL' disabled = l_to_local_variant_disabled  ) .

        menu->add_function( text = text-009 fcode = 'SET_GO_GLOBAL' disabled = l_to_global_variant_disabled ) .

        menu->add_separator( ).

        menu->add_function( text = text-023 fcode = 'RENAME_VARIANT' disabled = l_delete_variant_disabled ).

        menu->add_function( text = text-007 fcode = 'DELETE_VARIANT' disabled = l_delete_variant_disabled ).

        menu->add_separator( ).

        menu->add_function( text = text-015 fcode = 'TRANSPORT_VARIANT' disabled = l_transport_variant_disabled ).

        menu->add_function( text = text-020 fcode = 'DOWNLOAD' disabled = abap_false ).

        menu->add_function( text = text-019 fcode = 'SHARE_VARIANT' disabled = abap_false ).

      ENDIF.

      g_column_tree->set_selected_node(
        EXPORTING
          node_key = node_key ).

      on_selection_changed( node_key ).

    ENDIF.
  ENDMETHOD.


  METHOD on_node_context_menu_sel.

    CASE fcode.
      WHEN 'REMOVE_FAVORITE'.
        me->remove_from_favorites( node_key ).
      WHEN 'ADD_FAVORITE'.
        me->add_to_favorites( node_key ).
        me->on_selection_changed( node_key = node_key ).
      WHEN 'DELETE_VARIANT'.
        me->delete_variant( node_key ).
      WHEN 'RENAME_VARIANT'.
        me->rename_variant( node_key ).
        me->on_selection_changed( node_key = node_key ).
      WHEN 'TRANSPORT_VARIANT'.
        me->transport_variant( node_key ).
      WHEN 'SET_GO_LOCAL'.
        me->set_variant_to_local( node_key ).
        me->on_selection_changed( node_key = node_key ).
      WHEN 'SET_GO_GLOBAL'.
        me->set_variant_to_global( node_key ).
        me->on_selection_changed( node_key = node_key ).
      WHEN 'SHARE_VARIANT'.
        me->share_variant( node_key ).
        me->on_selection_changed( node_key = node_key ).
      WHEN 'DOWNLOAD'.
        me->tree_download_variant( node_key ).
        me->on_selection_changed( node_key = node_key ).
      WHEN 'UPLOAD'. "+381
        me->upload_variants( ).
    ENDCASE.

    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
      EXPORTING
        functioncode = '0'.

  ENDMETHOD.


  METHOD on_selection_changed.

    me->g_current_node_key = node_key.

    me->on_double_click_tree_vari_node( node_key = node_key ).

    me->set_tree_toolbar( node_key ).

  ENDMETHOD.


  METHOD on_tree_drag.
****************************************************************************************************
* Description             : on tree drag                                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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

    FIELD-SYMBOLS: <ls_variant> LIKE LINE OF me->gt_il_vnhd.

    CREATE OBJECT g_drag_drop_object.

    g_drag_drop_object->node_key = node_key.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = node_key ASSIGNING <ls_variant>.
    IF sy-subrc EQ 0.
      g_drag_drop_object->node_key_parent = <ls_variant>-vargroup.
    ENDIF.
    drag_drop_object->object = g_drag_drop_object.

  ENDMETHOD.


  METHOD on_tree_drop.

    DATA lr_drag_drop_object TYPE REF TO lcl_drag_object.
    DATA ls_node_vari   LIKE LINE OF me->gt_node_vari.
    DATA ls_sqlcvnfa TYPE /cadaxo/sqlcvnfa.
    DATA ls_node             TYPE treev_node.
    DATA lt_nodes            TYPE TABLE OF treev_node.
    DATA ls_item             TYPE mtreeitm.
    DATA lt_items            TYPE TABLE OF mtreeitm.
    DATA ls_sqlcvari_alv     LIKE LINE OF gt_il_vnhd.
    DATA l_vargroup          TYPE /cadaxo/sqlcvari_group.
    DATA ls_il_vnfa          LIKE LINE OF me->gt_il_vnfa.
    DATA lr_exception        TYPE REF TO /cadaxo/cx_sqlc_variant.
    DATA l_message           TYPE string.

    FIELD-SYMBOLS: "<ls_sqlcvari> LIKE LINE OF me->gt_sqlcvari,
                   <ls_variant>  LIKE LINE OF me->gt_il_vnhd.

    lr_drag_drop_object ?= drag_drop_object->object.

    IF NOT lr_drag_drop_object->node_key IS INITIAL AND NOT node_key IS INITIAL.

      READ TABLE me->gt_il_vnhd WITH KEY node_key = lr_drag_drop_object->node_key ASSIGNING <ls_variant>.
      IF sy-subrc EQ 0 AND node_key NE <ls_variant>-vargroup.

* lock variant
        TRY.
            /cadaxo/cl_sqlc_variant=>lock_variant( <ls_variant>-varguid ).
          CATCH /cadaxo/cx_sqlc_variant INTO lr_exception.
            l_message = lr_exception->get_text( ).
            MESSAGE l_message TYPE 'S' DISPLAY LIKE 'E'.
            RETURN.
        ENDTRY.

        IF node_key EQ 'MY_FAVORITES'.

          me->add_to_favorites( lr_drag_drop_object->node_key ).

        ELSE.

          IF <ls_variant>-cruser EQ sy-uname.

            l_vargroup = me->get_vargroup_of_node_key( node_key ).

            /cadaxo/cl_sqlc_variant=>change_group_of_variant( i_varguid = <ls_variant>-varguid
                                                              i_vargroup = l_vargroup ).

            <ls_variant>-vargroup = node_key.

            READ TABLE me->gt_node_vari
                       WITH KEY node_key = lr_drag_drop_object->node_key
                       INTO ls_node_vari.

            g_column_tree->move_node( node_key  = lr_drag_drop_object->node_key
                                       relatkey  = node_key
                                       relatship = cl_gui_list_tree=>relat_last_child ).

*
*        UPDATE /cadaxo/sqlcvari SET vargroup = l_vargroup
*               WHERE varname     = <ls_sqlcvari>-varname
*                 AND username    = <ls_sqlcvari>-cruser
*                 AND flag_global = <ls_sqlcvari>-flag_global.
*        IF sy-subrc EQ 0.
*          MOVE node_key TO <ls_sqlcvari>-vargroup.
*

*
*          g_column_tree->move_node( node_key  = lr_drag_drop_object->node_key
*                                    relatkey  = node_key
*                                    relatship = cl_gui_list_tree=>relat_last_child ).

*        ENDIF.
          ELSE.

          ENDIF.
        ENDIF.
        /cadaxo/cl_sqlc_variant=>unlock_variant( <ls_variant>-varguid ).
      ELSE.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD on_tree_toolbar_funcsel.

    CASE fcode.
      WHEN 'TREE_TOOLBAR_ADD_TO_FAVORITES'.
        me->add_to_favorites( g_current_node_key ).
        me->on_selection_changed( node_key = g_current_node_key ).
      WHEN 'TREE_TOOLBAR_REMOVE_FAVORITE'.
        me->remove_from_favorites( g_current_node_key ).
      WHEN 'TREE_TOOLBAR_EXPORT_VARIANT'.
        me->tree_download_variant( g_current_node_key ).
        me->on_selection_changed( node_key = g_current_node_key ).
      WHEN 'TREE_TOOLBAR_SHARE_VARIANT'.
        me->share_variant( g_current_node_key ).
        me->on_selection_changed( node_key = g_current_node_key ).
      WHEN 'TREE_TOOLBAR_MAKE_PUBLIC'.
        me->set_variant_to_global( g_current_node_key ).
        me->on_selection_changed( node_key = g_current_node_key ).
      WHEN 'TREE_TOOLBAR_MAKE_PRIVATE'.
        me->set_variant_to_local( g_current_node_key ).
        me->on_selection_changed( node_key = g_current_node_key ).
      WHEN 'TREE_TOOLBAR_DELETE_VARIANT'.
        me->delete_variant( g_current_node_key ).
      WHEN 'TREE_TOOLBAR_RENAME_VARIANT'.
        me->rename_variant( g_current_node_key ).
        me->on_selection_changed( node_key = g_current_node_key ).
      WHEN 'TREE_TOOLBAR_ADD_TO_TRANSPORT'.
        me->transport_variant( g_current_node_key ).
        me->on_selection_changed( node_key = g_current_node_key ).
      WHEN 'TREE_TOOLBAR_FILTER_VARIANT'.
        me->show_search_variant_popup( ).
        me->on_selection_changed( node_key = g_current_node_key ).
      WHEN 'TREE_TOOLBAR_FILTER_VARIANT_UNDO'.
        me->undo_search_variant( ).
        me->on_selection_changed( node_key = g_current_node_key ).
      WHEN 'TREE_TOOLBAR_IMPORT_VARIANT'. "+381
        me->upload_variants( ).
    ENDCASE.



    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
      EXPORTING
        functioncode = '0'.

  ENDMETHOD.


  METHOD pbo_0100.
****************************************************************************************************
* Description             : PBO 0100                                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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

* initialize and create ui controls
    me->create_0100_controls( ).

* create user log object
    IF gr_user_log IS INITIAL.
      CREATE OBJECT gr_user_log.
    ENDIF.

  ENDMETHOD.


  METHOD pbo_0200.
****************************************************************************************************
* Description             : PBO 0200                                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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

* initialize and create ui controls
    me->create_0200_controls( ).

* create user log object
    IF gr_user_log IS INITIAL.
      CREATE OBJECT gr_user_log.
    ENDIF.

  ENDMETHOD.


  METHOD refresh_tree_variants.
    me->build_tree_variants( ).

    g_column_tree->delete_all_nodes( ).

    g_column_tree->add_nodes_and_items(
      EXPORTING
        node_table                     = gt_node_vari
        item_table                     = gt_item_vari
        item_table_structure_name      = 'MTREEITM'
      EXCEPTIONS
        OTHERS                         = 1
           ).

    g_column_tree->expand_root_nodes( EXPORTING level_count = 2 ).

  ENDMETHOD.


  METHOD remove_favorite.
****************************************************************************************************
* Description             : remove favorite                                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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
    DATA ls_sqlcvnfa TYPE /cadaxo/sqlcvnfa.

    MESSAGE x000(00). "???

    FIELD-SYMBOLS: <ls_variant>  LIKE LINE OF me->gt_il_vnhd.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = i_node_key ASSIGNING <ls_variant>.
    IF sy-subrc EQ 0.

* lock favorite
      SELECT SINGLE FOR UPDATE * FROM /cadaxo/sqlcvnfa INTO ls_sqlcvnfa
                                 WHERE username = sy-uname
                                   AND varguid = <ls_variant>-varguid.
      IF sy-subrc EQ 0.

* delete favorite
        DELETE /cadaxo/sqlcvnfa FROM ls_sqlcvnfa.
        IF sy-subrc EQ 0.

          COMMIT WORK.

          DELETE me->gt_il_vnfa WHERE username = sy-uname
                                  AND varguid = <ls_variant>-varguid.

          DELETE me->gt_il_vnhd WHERE node_key = i_node_key.

          g_column_tree->delete_node( i_node_key ).

        ELSE.
          ROLLBACK WORK.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD remove_from_favorites.

    DATA ls_sqlcvnfa TYPE /cadaxo/sqlcvnfa.
    DATA l_varguid TYPE /cadaxo/sqlc_variant_guid.

    FIELD-SYMBOLS: <ls_variant>  LIKE LINE OF me->gt_il_vnhd.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = node_key ASSIGNING <ls_variant>.
    IF sy-subrc EQ 0.

      l_varguid = <ls_variant>-varguid.

      SELECT SINGLE FOR UPDATE * FROM /cadaxo/sqlcvnfa INTO ls_sqlcvnfa
                                 WHERE username = sy-uname
                                   AND varguid = <ls_variant>-varguid.
      IF sy-subrc EQ 0.

        DELETE /cadaxo/sqlcvnfa FROM ls_sqlcvnfa.
        IF sy-subrc EQ 0.

          COMMIT WORK.

          DELETE me->gt_il_vnfa WHERE username = sy-uname
                                  AND varguid = <ls_variant>-varguid.

          IF <ls_variant>-vargroup = 'MY_FAVORITES'.

            g_column_tree->delete_node( node_key ).
            DELETE me->gt_il_vnhd WHERE node_key = node_key.

            LOOP AT me->gt_il_vnhd ASSIGNING FIELD-SYMBOL(<variant_vndh>) WHERE varguid = l_varguid AND vargroup <> 'MY_FAVORITES'.
              g_column_tree->item_set_t_image(
                EXPORTING
                  node_key          = <variant_vndh>-node_key
                  item_name         = '1'
                  t_image           = CONV #( icon_space )
              ).

              g_column_tree->set_selected_node( <variant_vndh>-node_key ).

            ENDLOOP.

          ELSE.
            READ TABLE me->gt_il_vnhd WITH KEY varguid = l_varguid vargroup = 'MY_FAVORITES' ASSIGNING FIELD-SYMBOL(<ls_variant_favorites>).
            IF sy-subrc = 0.

              g_column_tree->delete_node( <ls_variant_favorites>-node_key ).
              DELETE me->gt_il_vnhd WHERE node_key = <ls_variant_favorites>-node_key.

              g_column_tree->item_set_t_image(
                EXPORTING
                  node_key          = node_key
                  item_name         = '1'
                  t_image           = CONV #( icon_space )
              ).

            ENDIF.

          ENDIF.

        ELSE.
          ROLLBACK WORK.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD rename_variant.

    DATA fields TYPE TABLE OF sval.
    DATA l_answer TYPE c.
    DATA l_error_message TYPE string.
    DATA lr_cx_sql_variant TYPE REF TO /cadaxo/cx_sqlc_variant.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = i_node_key ASSIGNING FIELD-SYMBOL(<ls_variant>).
    IF sy-subrc EQ 0.

      fields[] = VALUE #( ( tabname = '/CADAXO/SQLCVNHD'
                            fieldname = 'VARNAME'
                            value = <ls_variant>-varname
                            field_obl = abap_true ) ).

      CALL FUNCTION 'POPUP_GET_VALUES'
        EXPORTING
          popup_title     = text-t06
*         START_COLUMN    = '5'
*         START_ROW       = '5'
        IMPORTING
          returncode      = l_answer
        TABLES
          fields          = fields
        EXCEPTIONS
          error_in_fields = 1
          OTHERS          = 2.

      IF sy-subrc = 0 AND l_answer = space.
        TRY.
            /cadaxo/cl_sqlc_variant=>rename_variant( i_varguid = <ls_variant>-varguid
                                                     i_varname = CONV #( fields[ 1 ]-value ) ).

*            READ TABLE me->gt_il_vnhd WITH KEY varguid = <ls_variant>-varguid ASSIGNING FIELD-SYMBOL(<vnhd>)."-Cockpit-443
*            IF sy-subrc EQ 0."-Cockpit-443
            LOOP AT me->gt_il_vnhd ASSIGNING FIELD-SYMBOL(<vnhd>) WHERE varguid = <ls_variant>-varguid. "+Cockpit-443 "also select from favourite

              <vnhd>-varname = CONV #( fields[ 1 ]-value ).

              g_column_tree->item_set_text(
                EXPORTING
                  node_key          = <vnhd>-node_key
                  item_name         = '1'
                  text              = <vnhd>-varname
                EXCEPTIONS
                  failed            = 1
                  node_not_found    = 2
                  item_not_found    = 3
                  cntl_system_error = 4
                  OTHERS            = 5
              ).

              me->gs_il_variants-varname = <vnhd>-varname.
            ENDLOOP.  "+Cockpit-443
*            ENDIF.

          CATCH /cadaxo/cx_sqlc_variant INTO lr_cx_sql_variant.
            l_error_message = lr_cx_sql_variant->get_text( ).
            MESSAGE l_error_message TYPE 'S' DISPLAY LIKE 'E'.
        ENDTRY.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD save_description.
    DATA lt_text            TYPE STANDARD TABLE OF text255.
    DATA l_stringx_longtext TYPE /cadaxo/sqlclongtext_raw.
    DATA ls_sqlc_il_vntx    TYPE /cadaxo/sqlc_il_vntx.
    DATA lt_sqlc_il_vntx    TYPE /cadaxo/sqlc_il_vntx_t.

    FIELD-SYMBOLS: <ls_il_vnhd> LIKE LINE OF me->gt_il_vnhd.

* get current text
    g_text_edit_description->get_text_as_stream(
      IMPORTING
        text                   = lt_text
      EXCEPTIONS
        error_dp               = 1
        error_cntl_call_method = 2
        OTHERS                 = 3 ).

    EXPORT description FROM lt_text[] TO DATA BUFFER l_stringx_longtext.

    cl_abap_gzip=>compress_binary(
      EXPORTING
        raw_in   = l_stringx_longtext
      IMPORTING
        gzip_out = l_stringx_longtext ).

    ls_sqlc_il_vntx-langu       = me->g_description_language.
    ls_sqlc_il_vntx-longtext    = l_stringx_longtext.
    ls_sqlc_il_vntx-varguid     = me->g_varguid_focus.
    ls_sqlc_il_vntx-vardescription = me->g_description.

    APPEND ls_sqlc_il_vntx TO lt_sqlc_il_vntx.

* modify description
    /cadaxo/cl_sqlc_variant=>modify_description( EXPORTING it_description = lt_sqlc_il_vntx ).

* refresh variant details
    /cadaxo/cl_sqlc_variant=>get_variant( EXPORTING i_varguid      = me->g_varguid_focus
                                          IMPORTING es_sqlcvari_il = me->gs_il_variants ).


* refresh tree
    IF me->g_description_language EQ sy-langu.
      READ TABLE me->gt_il_vnhd WITH KEY varguid = me->g_varguid_focus ASSIGNING <ls_il_vnhd>.
      IF sy-subrc EQ 0.
        g_column_tree->item_set_text( node_key = <ls_il_vnhd>-node_key
                                      item_name  = '2'
                                      text       = ls_sqlc_il_vntx-vardescription ).
      ENDIF.
    ENDIF.

    CLEAR me->g_description_changed.

  ENDMETHOD.


  METHOD search_for_desc.
****************************************************************************************************
* Description             : Search in variant description according to search conditions           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dusan Sacha              Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2018               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    DATA text_table       TYPE /cadaxo/sqlccodeline_t.
    DATA stringx_longtext TYPE /cadaxo/sqlclongtext_raw.


    rv_found = abap_false.

    SELECT varname, vardescription, longtext
           FROM /cadaxo/sqlcvnhd AS header
           INNER JOIN /cadaxo/sqlcvntx AS text
              ON text~varguid = header~varguid
           INTO TABLE @DATA(texts)
           WHERE header~varguid = @i_varguid.

    IF sy-subrc = 0.

      LOOP AT texts ASSIGNING FIELD-SYMBOL(<text>).

        IF <text>-vardescription CP i_desc OR
           <text>-varname        CP i_desc.
          rv_found = abap_true.
          EXIT. "LOOP
        ELSE.
          IF <text>-longtext IS NOT INITIAL.

            cl_abap_gzip=>decompress_binary( EXPORTING gzip_in = <text>-longtext
                                             IMPORTING raw_out = stringx_longtext ).

            IMPORT description TO text_table FROM DATA BUFFER stringx_longtext.

            LOOP AT text_table TRANSPORTING NO FIELDS WHERE table_line CP i_desc.
              rv_found = abap_true.
              EXIT. "LOOP
            ENDLOOP.
          ENDIF.
        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD search_for_table.
****************************************************************************************************
* Description             : Search in variant SQL Statement according to search conditions         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dusan Sacha              Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2018               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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

    DATA lv_found TYPE abap_bool.
    DATA lv_varsql TYPE /cadaxo/sqlcvari_sql.
    DATA lt_table        TYPE /cadaxo/sqlccodeline_t.

    SELECT SINGLE varsql FROM /cadaxo/sqlcvnhd INTO lv_varsql
           WHERE varguid = i_varguid.
    IF sy-subrc <> 0.
      lv_found = abap_false.
    ELSE.

      IMPORT code TO lt_table FROM DATA BUFFER lv_varsql.

      LOOP AT lt_table ASSIGNING FIELD-SYMBOL(<lv_line>).
        IF <lv_line> CP i_table.
          lv_found = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

    ENDIF.

    rv_found = lv_found.

  ENDMETHOD.


  METHOD search_variant.
****************************************************************************************************
* Description             : Search imported variants in all variants according to search conditions*
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dusan Sacha              Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2018               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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

    cl_progress_indicator=>progress_indicate(
       i_text               = text-018
       i_processed          = iv_processed
       i_total              = lines( gt_il_vnhd )
       i_output_immediately = abap_false ).

    " Search Username
    IF gs_variant_search-uname IS NOT INITIAL.
      IF iv_variant-cruser CP gs_variant_search-uname.
        rv_found = abap_true.
      ENDIF.
    ENDIF.

    " Search in Table names
    IF gs_variant_search-table IS NOT INITIAL.
      rv_found = search_for_table(
        i_varguid = iv_variant-varguid
        i_table = gs_variant_search-table
      ).
    ENDIF.

    " Search in Descriptions
    IF gs_variant_search-desc IS NOT INITIAL.
      rv_found = search_for_desc(
        i_varguid = iv_variant-varguid
        i_desc = gs_variant_search-desc
      ).
    ENDIF.

  ENDMETHOD.


  METHOD set_description.

    DATA l_stringx_longtext TYPE /cadaxo/sqlclongtext_raw.
    DATA lt_text            TYPE STANDARD TABLE OF text255.

    FIELD-SYMBOLS: <ls_description> TYPE /cadaxo/sqlc_il_vntx.

    CLEAR lt_text.

    IF g_text_edit_description IS INITIAL.
      RETURN.
    ENDIF.

    READ TABLE gs_il_variants-t_description ASSIGNING <ls_description> WITH KEY langu = me->g_description_language.
    IF sy-subrc EQ 0.

      me->g_description = <ls_description>-vardescription.

      IF NOT <ls_description>-longtext IS INITIAL.

        cl_abap_gzip=>decompress_binary(
          EXPORTING
            gzip_in  = <ls_description>-longtext
          IMPORTING
            raw_out  = l_stringx_longtext ).

        IMPORT description TO lt_text FROM DATA BUFFER l_stringx_longtext.

      ENDIF.

    ENDIF.

    g_text_edit_description->set_text_as_stream( lt_text ).

    me->g_description_changed = space.

  ENDMETHOD.


  METHOD set_description_langu.
****************************************************************************************************
* Description             : Set Description Language                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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

    me->g_description_language = i_langu.

    me->set_description( ).

  ENDMETHOD.


  METHOD set_description_modif_status.
    g_text_edit_description->set_textmodified_status( EXPORTING status = i_modified_status ).
  ENDMETHOD.


  METHOD set_mode.
****************************************************************************************************
* Description             : Set UI Mode                                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.10.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxx xxxxxx                    *
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

* G = GET VARIANT
* S = SAVE VARIANT
* R = READ ONLY MODE - GET VARIANT

    me->g_mode = i_mode.

  ENDMETHOD.


  METHOD set_tree_toolbar.

    DATA l_button_state TYPE abap_bool.
    DATA l_button_public_state TYPE abap_bool.
    DATA l_button_private_state TYPE abap_bool.
    DATA l_button_add_favorite_state TYPE abap_bool.
    DATA l_button_delete_favorite TYPE abap_bool.

    READ TABLE gt_il_vnhd ASSIGNING FIELD-SYMBOL(<l_sqlcvari_alv>) WITH KEY node_key = node_key.
    IF sy-subrc EQ 0.
      l_button_state = abap_true.

      IF <l_sqlcvari_alv>-flag_public = abap_true.
        l_button_public_state = abap_false.
        l_button_private_state = abap_true.
      ELSE.
        l_button_public_state = abap_true.
        l_button_private_state = abap_false.
      ENDIF.

*      IF <l_sqlcvari_alv>-vargroup = 'MY_FAVORITES'.
*        l_button_state = abap_false.
*        l_button_public_state = abap_false.
*        l_button_private_state = abap_false.
*      ELSE.
      IF line_exists( me->gt_il_vnhd[ varguid = <l_sqlcvari_alv>-varguid vargroup = 'MY_FAVORITES' ] ).
        l_button_add_favorite_state = abap_false.
        l_button_delete_favorite = abap_true.
      ELSE.
        l_button_add_favorite_state = abap_true.
        l_button_delete_favorite = abap_false.
      ENDIF.
      "  ENDIF.

    ELSE.
      l_button_state = abap_false.
      l_button_public_state = abap_false.
      l_button_private_state = abap_false.
    ENDIF.

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_ADD_TO_FAVORITES'
        enabled = l_button_add_favorite_state ).

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_REMOVE_FAVORITE'
        enabled = l_button_delete_favorite ).

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_DELETE_VARIANT'
        enabled = l_button_state ).

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_RENAME_VARIANT'
        enabled = l_button_state ).

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_ADD_TO_TRANSPORT'
        enabled = l_button_state ).

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_EXPORT_VARIANT'
        enabled = l_button_state ).

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_SHARE_VARIANT'
        enabled = l_button_state ).

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_MAKE_PUBLIC'
        enabled = l_button_public_state ).

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_MAKE_PRIVATE'
        enabled = l_button_private_state ).

  ENDMETHOD.


  METHOD set_variant_to_global.
****************************************************************************************************
* Description             : Set Variant to Public                                                  *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    DATA l_image      TYPE tv_image.
    DATA lr_exception TYPE REF TO /cadaxo/cx_sqlc_variant.
    DATA l_message    TYPE string.

    FIELD-SYMBOLS: <ls_variant> LIKE LINE OF me->gt_il_vnhd,
                   <ls_il_vnfa> LIKE LINE OF me->gt_il_vnfa.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = i_node_key ASSIGNING <ls_variant>.
    IF sy-subrc EQ 0.

      TRY.
          /cadaxo/cl_sqlc_variant=>lock_variant( <ls_variant>-varguid ).


          /cadaxo/cl_sqlc_variant=>globalize_variant( i_varguid  = <ls_variant>-varguid ).

* set new icon
          l_image = icon_shared_position.
          g_column_tree->node_set_n_image( node_key = i_node_key
                                           n_image  = l_image ).

* set flag public
          <ls_variant>-flag_public = 'X'.

          READ TABLE me->gt_il_vnfa WITH KEY varguid = <ls_variant>-varguid ASSIGNING <ls_il_vnfa>.
          IF sy-subrc EQ 0.
            g_column_tree->node_set_n_image( node_key = <ls_il_vnfa>-node_key
                                             n_image  = l_image ).
          ENDIF.

        CATCH /cadaxo/cx_sqlc_variant INTO lr_exception.
          l_message = lr_exception->get_text( ).
          MESSAGE l_message TYPE 'S' DISPLAY LIKE 'E'.
          RETURN.
      ENDTRY.

    ENDIF.
  ENDMETHOD.


  METHOD set_variant_to_local.
****************************************************************************************************
* Description             : Set Variant to private                                                 *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    DATA l_image TYPE tv_image.
    DATA lr_exception TYPE REF TO /cadaxo/cx_sqlc_variant.
    DATA l_message    TYPE string.

    FIELD-SYMBOLS: <ls_variant> LIKE LINE OF me->gt_il_vnhd,
                   <ls_il_vnfa> LIKE LINE OF me->gt_il_vnfa.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = i_node_key ASSIGNING <ls_variant>.
    IF sy-subrc EQ 0.

      TRY.
          /cadaxo/cl_sqlc_variant=>lock_variant( <ls_variant>-varguid ).

          /cadaxo/cl_sqlc_variant=>localize_variant( i_varguid  = <ls_variant>-varguid ).

          l_image = icon_hr_position.

          g_column_tree->node_set_n_image( node_key = i_node_key
                                           n_image  = l_image ).

          <ls_variant>-flag_public = ''.

          READ TABLE me->gt_il_vnfa WITH KEY varguid = <ls_variant>-varguid ASSIGNING <ls_il_vnfa>.
          IF sy-subrc EQ 0.
            g_column_tree->node_set_n_image( node_key = <ls_il_vnfa>-node_key
                                             n_image  = l_image ).
          ENDIF.

        CATCH /cadaxo/cx_sqlc_variant INTO lr_exception.
          l_message = lr_exception->get_text( ).
          MESSAGE l_message TYPE 'S' DISPLAY LIKE 'E'.
          RETURN.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD share_variant.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = i_node_key ASSIGNING FIELD-SYMBOL(<ls_variant>).
    IF sy-subrc EQ 0.

      /cadaxo/cl_sqlc_variant=>get_variant( EXPORTING i_varguid      = <ls_variant>-varguid
                                            IMPORTING es_sqlcvari_il = DATA(ls_sqlcvari_il) ).

      CALL FUNCTION '/CADAXO/SQLC_SHARE'
        EXPORTING
          iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-variant
          is_variant     = ls_sqlcvari_il.

    ENDIF.

  ENDMETHOD.


  METHOD show_search_variant_popup.
****************************************************************************************************
* Description             : Call Popup and get search variant values                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dusan Sacha              Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2018               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    DATA: lt_fields           TYPE TABLE OF sval.
    DATA: l_return(1)         TYPE c.                       "#EC NEEDED

    FIND REGEX '\*(.*)\*' IN gs_variant_search-uname SUBMATCHES gs_variant_search-uname.
    FIND REGEX '\*(.*)\*' IN gs_variant_search-table SUBMATCHES gs_variant_search-table.
    FIND REGEX '\*(.*)\*' IN gs_variant_search-desc SUBMATCHES gs_variant_search-desc.

    lt_fields = VALUE #( ( tabname   = '/CADAXO/SQLCROLU'
                    fieldname = 'UNAME'
                    fieldtext = text-014
                    value = gs_variant_search-uname )
                    ( tabname   = 'RSRD1'
                    fieldname = 'TBMA_VAL'
                    fieldtext = text-016
                    value = gs_variant_search-table )
                    ( tabname   = '/CADAXO/SQLCVNTX'
                    fieldname = 'VARDESCRIPTION'
                    fieldtext = text-017
                    value = gs_variant_search-desc )
                    ).

    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
        popup_title = text-012
      IMPORTING
        returncode  = l_return
      TABLES
        fields      = lt_fields
      EXCEPTIONS
        OTHERS      = 1.
    IF sy-subrc EQ 0 AND l_return <> 'A'.
      CLEAR gs_variant_search.

      ASSIGN lt_fields[ fieldname = 'UNAME' ] TO FIELD-SYMBOL(<ls_fields>).
      IF sy-subrc EQ 0 AND <ls_fields>-value IS NOT INITIAL.
        gs_variant_search-uname = '*' && <ls_fields>-value && '*'.
      ENDIF.
      ASSIGN lt_fields[ fieldname = 'TBMA_VAL' ] TO <ls_fields>.
      IF sy-subrc EQ 0 AND <ls_fields>-value IS NOT INITIAL.
        gs_variant_search-table = '*' && <ls_fields>-value && '*'.
      ENDIF.
      ASSIGN lt_fields[ fieldname = 'VARDESCRIPTION' ] TO <ls_fields>.
      IF sy-subrc EQ 0 AND <ls_fields>-value IS NOT INITIAL.
        gs_variant_search-desc = '*' && <ls_fields>-value && '*'.
      ENDIF.

      IF gs_variant_search IS NOT INITIAL.
        me->refresh_tree_variants( ).
        gc_tree_toolbar->set_button_state(
           EXPORTING
             fcode = 'TREE_TOOLBAR_FILTER_VARIANT_UNDO'
             enabled = abap_true ).
      ELSE.
        me->undo_search_variant( ).
      ENDIF.

    ENDIF.
    "ENDIF.
  ENDMETHOD.


  METHOD transport_variant.
****************************************************************************************************
* Description             : Transport Variant                                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    DATA l_row_index TYPE i.
    DATA ls_il_vnfa  LIKE LINE OF me->gt_il_vnfa.
    DATA l_trkorr    TYPE trkorr.
    DATA trtask      TYPE trkorr.
    DATA lt_e071     TYPE TABLE OF e071.
    DATA lt_e071k    TYPE TABLE OF e071k.
    DATA ls_e071     TYPE e071.
    DATA ls_e071k    TYPE e071k.
    DATA l_user      LIKE sy-uname.
    DATA l_varguid(32) TYPE c.

    FIELD-SYMBOLS: <ls_variant> LIKE LINE OF me->gt_il_vnhd.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = i_node_key ASSIGNING <ls_variant>.
    IF sy-subrc EQ 0.
      IF NOT <ls_variant>-flag_public IS INITIAL AND <ls_variant>-cruser NE sy-uname.
        AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '21'. "Delete
        IF sy-subrc NE 0.
          MESSAGE e034(/cadaxo/sqlc).
        ENDIF.
      ENDIF.

      l_row_index = sy-tabix.

* select the transport request
      CALL FUNCTION 'TR_ORDER_CHOICE_CORRECTION'
        EXPORTING
          iv_category = 'CUST'  "Customizing
          iv_cli_dep  = abap_true
        IMPORTING
          ev_order    = l_trkorr
          ev_task     = trtask
        EXCEPTIONS
          OTHERS      = 3.
      IF sy-subrc EQ 0.

* lock the transport request
        CALL FUNCTION 'ENQUEUE_E_TRKORR'
          EXPORTING
            trkorr       = l_trkorr
          EXCEPTIONS
            foreign_lock = 1
            OTHERS       = 3.
        IF sy-subrc  =    1.
          l_user = sy-msgv1.
          MESSAGE e009(/cadaxo/sqlc) WITH l_trkorr l_user.
        ELSE.

* fill the e071/e071k structures
          CLEAR: ls_e071, ls_e071k.
          MOVE: trtask             TO ls_e071-trkorr,
                'R3TR'             TO ls_e071-pgmid,
                'TABU'             TO ls_e071-object,
                '/CADAXO/SQLCVNHD' TO ls_e071-obj_name,
                'K'                TO ls_e071-objfunc.
          APPEND ls_e071 TO lt_e071.

          MOVE: trtask             TO ls_e071k-trkorr,
                'R3TR'             TO ls_e071k-pgmid,
                'TABU'             TO ls_e071k-object,
                '/CADAXO/SQLCVNHD' TO ls_e071k-objname,
                '/CADAXO/SQLCVNHD' TO ls_e071k-mastername,
                'TABU'             TO ls_e071k-mastertype.

* build the table key
          l_varguid = <ls_variant>-varguid.
          CONCATENATE sy-mandt l_varguid INTO ls_e071k-tabkey RESPECTING BLANKS.

          APPEND ls_e071k TO lt_e071k.


* symbols
          CLEAR ls_e071.
          MOVE: trtask             TO ls_e071-trkorr,
                'R3TR'             TO ls_e071-pgmid,
                'TABU'             TO ls_e071-object,
                '/CADAXO/SQLCVNSY' TO ls_e071-obj_name,
                'K'                TO ls_e071-objfunc.
          APPEND ls_e071 TO lt_e071.

          CLEAR ls_e071k.

          MOVE: trtask             TO ls_e071k-trkorr,
                'R3TR'             TO ls_e071k-pgmid,
                'TABU'             TO ls_e071k-object,
                '/CADAXO/SQLCVNSY' TO ls_e071k-objname,
                '/CADAXO/SQLCVNSY' TO ls_e071k-mastername,
                'TABU'             TO ls_e071k-mastertype.

          CONCATENATE sy-mandt l_varguid '*' INTO ls_e071k-tabkey RESPECTING BLANKS.

          APPEND ls_e071k TO lt_e071k.

* texts
          CLEAR ls_e071.
          MOVE: trtask             TO ls_e071-trkorr,
                'R3TR'             TO ls_e071-pgmid,
                'TABU'             TO ls_e071-object,
                '/CADAXO/SQLCVNTX' TO ls_e071-obj_name,
                'K'                TO ls_e071-objfunc.
          APPEND ls_e071 TO lt_e071.

          CLEAR ls_e071k.

          MOVE: trtask             TO ls_e071k-trkorr,
                'R3TR'             TO ls_e071k-pgmid,
                'TABU'             TO ls_e071k-object,
                '/CADAXO/SQLCVNTX' TO ls_e071k-objname,
                '/CADAXO/SQLCVNTX' TO ls_e071k-mastername,
                'TABU'             TO ls_e071k-mastertype.

          CONCATENATE sy-mandt l_varguid '*' INTO ls_e071k-tabkey RESPECTING BLANKS.

          APPEND ls_e071k TO lt_e071k.

* add the objects to the transport request
          CALL FUNCTION 'TRINT_APPEND_COMM'
            EXPORTING
              wi_sel_e071  = abap_true
              wi_sel_e071k = abap_true
              wi_trkorr    = trtask
            TABLES
              wt_e071      = lt_e071
              wt_e071k     = lt_e071k
            EXCEPTIONS
              OTHERS       = 1.
          IF sy-subrc EQ 0.
* unlock the transport request
            CALL FUNCTION 'DEQUEUE_E_TRKORR'
              EXPORTING
                trkorr = l_trkorr.

            MESSAGE s002(/cadaxo/sqlcvariants) WITH l_trkorr.
          ELSE.

            MESSAGE e100(/cadaxo/sqlc).

          ENDIF.
        ENDIF.
      ELSEIF sy-subrc EQ 2.

        MESSAGE s012(/cadaxo/sqlc). "No transport request selected

      ELSE.

        MESSAGE e100(/cadaxo/sqlc).

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD tree_download_variant.

    DATA l_variants TYPE /cadaxo/sqlc_il_variants.

    FIELD-SYMBOLS: <ls_variant> LIKE LINE OF me->gt_il_vnhd.

    READ TABLE me->gt_il_vnhd WITH KEY node_key = i_node_key ASSIGNING <ls_variant>.
    IF sy-subrc EQ 0.

      " TODO - Check CADAXO namespaces

* check authorization for global variants
      IF <ls_variant>-flag_public NE space.
        AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '01'.
        IF sy-subrc NE 0.
          MESSAGE e032(/cadaxo/sqlc).
        ENDIF.
      ENDIF.

      TRY.

          /cadaxo/cl_sqlc_variant=>get_variant( EXPORTING i_varguid = <ls_variant>-varguid
                                                IMPORTING es_sqlcvari_il = l_variants ).

          /cadaxo/cl_sqlc_variant=>download_variant(
            EXPORTING
              i_il_variant = l_variants ).

        CATCH /cadaxo/cx_sqlc_variant.

      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD undo_search_variant.

    CLEAR gs_variant_search.

    me->refresh_tree_variants( ).

    gc_tree_toolbar->set_button_state(
      EXPORTING
        fcode = 'TREE_TOOLBAR_FILTER_VARIANT_UNDO'
        enabled = abap_false ).

  ENDMETHOD.


  METHOD upload_variants.

    DATA varguid TYPE /cadaxo/sqlcvnhd-varguid.

    varguid = /cadaxo/cl_sqlc_variant=>upload_variant( ).

    IF varguid IS NOT INITIAL.

      CALL METHOD me->refresh_tree_variants.

      /cadaxo/cl_sqlc_variant=>get_variant( EXPORTING i_varguid      = varguid
                                            IMPORTING es_sqlcvari_il = gs_il_variants ).

      IF g_abap_editor IS BOUND.
        g_abap_editor->set_text( EXPORTING  table  = gs_il_variants-t_sql
                                 EXCEPTIONS OTHERS = 1 ).
      ELSEIF g_abap_editor_text IS BOUND.
        g_abap_editor_text->set_text_as_r3table( EXPORTING  table  = gs_il_variants-t_sql
                                                 EXCEPTIONS OTHERS = 1 ).
      ENDIF.

      me->gt_symbols = gs_il_variants-t_symbol.
      me->set_description( ).

      IF NOT me->g_symbols IS INITIAL.
        me->g_symbols->refresh_table_display( ).
      ENDIF.

      IF gs_il_variants-flag_public IS INITIAL.
        MESSAGE s011(/cadaxo/sqlcvariants) WITH gs_il_variants-varname.
      ELSE.
        MESSAGE s010(/cadaxo/sqlcvariants) WITH gs_il_variants-varname.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
