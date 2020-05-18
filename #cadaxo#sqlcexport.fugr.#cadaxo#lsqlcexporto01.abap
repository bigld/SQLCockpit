*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCEXPORTO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'MAIN_0100'.
  SET TITLEBAR '0100'.

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.

  DATA lt_fieldcat_col_alv TYPE lvc_t_fcat.
  DATA ls_layout TYPE lvc_s_layo.
  DATA l_rc      TYPE i.

  IF g_csv_attr IS INITIAL.
    MOVE 'SEMICOLON' TO g_csv_attr-field_separator.
    MOVE '"'         TO g_csv_attr-col_enclosure.
    MOVE '01'        TO g_csv_attr-date_format.
    MOVE '01'        TO g_csv_attr-time_format.

* get frontend encoding
    CALL METHOD cl_gui_frontend_services=>get_saplogon_encoding
      CHANGING
        rc                            = l_rc
        file_encoding                 = g_csv_attr-encoding
      EXCEPTIONS
        cntl_error                    = 1
        error_no_gui                  = 2
        not_supported_by_gui          = 3
        cannot_initialize_globalstate = 4
        OTHERS                        = 5.

  ENDIF.

  CLEAR rad_separated_by_tab.
  CLEAR rad_separated_by_comma.
  CLEAR rad_separated_by_semicolon.
  CLEAR rad_separated_by_space.
  CLEAR rad_separated_by_other.

  CASE g_csv_attr-field_separator.
    WHEN 'TAB'.
      MOVE 'X' TO rad_separated_by_tab.
    WHEN 'COMMA'.
      MOVE 'X' TO rad_separated_by_comma.
    WHEN 'SEMICOLON'.
      MOVE 'X' TO rad_separated_by_semicolon.
    WHEN 'SPACE'.
      MOVE 'X' TO rad_separated_by_space.
    WHEN 'OTHER'.
      MOVE 'X' TO rad_separated_by_other.
  ENDCASE.

  IF g_exp_preview_container IS INITIAL.

    CREATE OBJECT g_exp_preview_container
      EXPORTING
        container_name = 'CC_EXPORT_PREVIEW'.

    CREATE OBJECT g_exp_preview_editor
      EXPORTING
        parent = g_exp_preview_container.

    g_exp_preview_editor->set_statusbar_mode( 0 ).
    g_exp_preview_editor->set_toolbar_mode( 0 ).
    g_exp_preview_editor->set_readonly_mode( 1 ).
    g_exp_preview_editor->set_font_fixed( 1 ).
    g_exp_preview_editor->set_wordwrap_behavior( EXPORTING wordwrap_mode = 0 ).

  ENDIF.



  IF g_tab_columns_container IS INITIAL.
    CREATE OBJECT g_tab_columns_container
      EXPORTING
        container_name = 'CC_TAB_COLUMNS'.
    CREATE OBJECT g_col_grid
      EXPORTING
        i_parent = g_tab_columns_container.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = '/CADAXO/SQLCEXPORTCOLALV'
      CHANGING
        ct_fieldcat            = lt_fieldcat_col_alv
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    .

    LOOP AT lt_fieldcat_col_alv ASSIGNING <ls_fcat>.
      CASE <ls_fcat>-fieldname.
        WHEN 'EXPORT_FLAG'.
          <ls_fcat>-checkbox  = 'X'.
          <ls_fcat>-outputlen = 8.
          <ls_fcat>-edit      = 'X'.
          <ls_fcat>-col_pos   = 1.
        WHEN 'EXPORT_HEX'.
          <ls_fcat>-checkbox  = 'X'.
          <ls_fcat>-outputlen = 8.
          <ls_fcat>-edit      = 'X'.
        WHEN 'FIELDNAME'.
          <ls_fcat>-outputlen = 20.
        WHEN 'SCRTEXT_S'.
        WHEN 'COL_POS'.
          <ls_fcat>-col_pos   = 2.
          <ls_fcat>-no_out    = 'X'.
      ENDCASE.
    ENDLOOP.

    ls_layout-no_toolbar = 'X'.
    ls_layout-stylefname = 'CELLTAB'.

    g_col_grid->set_ready_for_input(
       EXPORTING
         i_ready_for_input = 1 ).

*    g_col_grid->register_edit_event(
*      EXPORTING
*        i_event_id = cl_gui_alv_grid=>mc_evt_modified
*      EXCEPTIONS
*        error      = 1
*        OTHERS     = 2 ).
*
*    SET HANDLER lcl_export_cols_alv=>handle_data_changed_finished FOR g_col_grid.

    g_col_grid->set_table_for_first_display( EXPORTING i_structure_name = '/CADAXO/SQLCEXPORTCOLALV'
                                                       is_layout        = ls_layout
                                             CHANGING  it_outtab        = gt_col_alv
                                                       it_fieldcatalog  = lt_fieldcat_col_alv ).

  ENDIF.

*  lcl_export_cols_alv=>refresh_preview( ).

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'BCS'.
        IF g_export_type = 'BCS'.
          screen-input = 0.
        ENDIF.
      WHEN 'BAX'.
        IF g_export_type = 'BAX'.
          screen-input = 0.
        ENDIF.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

  CASE g_export_type.
    WHEN 'BCS'.
      g_export_frame_text = text-e01.
      g_sub_dynpro = '0110'.
    WHEN 'BAX'.
      g_export_frame_text = text-e02.
      g_sub_dynpro = '0120'.
  ENDCASE.


ENDMODULE.                 " PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0110  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0110 OUTPUT.

*  DATA lt_fieldcat_col_alv TYPE lvc_t_fcat.
*  DATA ls_layout TYPE lvc_s_layo.
*  DATA l_rc      TYPE i.

  IF g_csv_attr IS INITIAL.

    MOVE 'SEMICOLON' TO g_csv_attr-field_separator.
    MOVE '"'         TO g_csv_attr-col_enclosure.
    MOVE '01'        TO g_csv_attr-date_format.
    MOVE '01'        TO g_csv_attr-time_format.

* get frontend encoding
    CALL METHOD cl_gui_frontend_services=>get_saplogon_encoding
      CHANGING
        rc                            = l_rc
        file_encoding                 = g_csv_attr-encoding
      EXCEPTIONS
        cntl_error                    = 1
        error_no_gui                  = 2
        not_supported_by_gui          = 3
        cannot_initialize_globalstate = 4
        OTHERS                        = 5.

  ENDIF.

  CLEAR rad_separated_by_tab.
  CLEAR rad_separated_by_comma.
  CLEAR rad_separated_by_semicolon.
  CLEAR rad_separated_by_space.
  CLEAR rad_separated_by_other.

  CASE g_csv_attr-field_separator.
    WHEN 'TAB'.
      MOVE 'X' TO rad_separated_by_tab.
    WHEN 'COMMA'.
      MOVE 'X' TO rad_separated_by_comma.
    WHEN 'SEMICOLON'.
      MOVE 'X' TO rad_separated_by_semicolon.
    WHEN 'SPACE'.
      MOVE 'X' TO rad_separated_by_space.
    WHEN 'OTHER'.
      MOVE 'X' TO rad_separated_by_other.
  ENDCASE.

  IF g_exp_preview_container IS INITIAL.

    CREATE OBJECT g_exp_preview_container
      EXPORTING
        container_name = 'CC_EXPORT_PREVIEW'.

    CREATE OBJECT g_exp_preview_editor
      EXPORTING
        parent = g_exp_preview_container.

    g_exp_preview_editor->set_statusbar_mode( 0 ).
    g_exp_preview_editor->set_toolbar_mode( 0 ).
    g_exp_preview_editor->set_readonly_mode( 1 ).
    g_exp_preview_editor->set_font_fixed( 1 ).
    g_exp_preview_editor->set_wordwrap_behavior( EXPORTING wordwrap_mode = 0 ).

  ENDIF.

  IF g_tab_columns_container IS INITIAL.

    CREATE OBJECT g_tab_columns_container
      EXPORTING
        container_name = 'CC_TAB_COLUMNS'.
    CREATE OBJECT g_col_grid
      EXPORTING
        i_parent = g_tab_columns_container.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = '/CADAXO/SQLCEXPORTCOLALV'
      CHANGING
        ct_fieldcat            = lt_fieldcat_col_alv
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    LOOP AT lt_fieldcat_col_alv ASSIGNING <ls_fcat>.
      CASE <ls_fcat>-fieldname.
        WHEN 'EXPORT_FLAG'.
          <ls_fcat>-checkbox  = 'X'.
          <ls_fcat>-outputlen = 8.
          <ls_fcat>-edit      = 'X'.
          <ls_fcat>-col_pos   = 1.
        WHEN 'EXPORT_HEX'.
          <ls_fcat>-checkbox  = 'X'.
          <ls_fcat>-outputlen = 8.
          <ls_fcat>-edit      = 'X'.
        WHEN 'FIELDNAME'.
          <ls_fcat>-outputlen = 20.
        WHEN 'SCRTEXT_S'.
        WHEN 'COL_POS'.
          <ls_fcat>-col_pos   = 2.
          <ls_fcat>-no_out    = 'X'.
      ENDCASE.
    ENDLOOP.

    ls_layout-no_toolbar = 'X'.
    ls_layout-stylefname = 'CELLTAB'.

    g_col_grid->set_ready_for_input(
       EXPORTING
         i_ready_for_input = 1 ).

    g_col_grid->set_table_for_first_display( EXPORTING i_structure_name = '/CADAXO/SQLCEXPORTCOLALV'
                                                       is_layout        = ls_layout
                                             CHANGING  it_outtab        = gt_col_alv
                                                       it_fieldcatalog  = lt_fieldcat_col_alv ).

  ENDIF.

ENDMODULE.                 " PBO_0110  OUTPUT
