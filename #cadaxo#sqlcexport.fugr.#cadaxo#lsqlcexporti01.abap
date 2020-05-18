*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCEXPORTI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA l_filename TYPE string.
  DATA l_path     TYPE string.
  DATA l_fullpath TYPE string.

  CASE g_ok_code.
    WHEN 'BUT_CSV'.
      g_export_type = 'BCS'.
    WHEN 'BUT_ASXML'.
      g_export_type = 'BAX'.
    WHEN 'EXECUTE_PREVIEW'.
      lcl_export_cols_alv=>refresh_preview( ).
    WHEN 'EXPORT'.

    g_col_grid->check_changed_data( ).

      cl_gui_frontend_services=>file_save_dialog(
*         EXPORTING
*           window_title         = text-t01
*          default_extension    = default_extension
*          default_file_name    = default_file_name
*          with_encoding        = with_encoding
*          file_filter          = file_filter
*          initial_directory    = initial_directory
*          prompt_on_overwrite  = 'X'
        CHANGING
          filename             = l_filename
          path                 = l_path
          fullpath             = l_fullpath
*          user_action          = user_action
*          file_encoding        = file_encoding
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
             ).
      IF sy-subrc <> 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      cl_gui_frontend_services=>gui_download(
        EXPORTING
*          bin_filesize              = bin_filesize
          filename                  = l_filename
*          filetype                  = 'ASC'
*          append                    = SPACE
*          write_field_separator     = SPACE
*          header                    = '00'
*          trunc_trailing_blanks     = SPACE
*          write_lf                  = 'X'
*          col_select                = SPACE
*          col_select_mask           = SPACE
*          dat_mode                  = SPACE
*          confirm_overwrite         = SPACE
*          no_auth_check             = SPACE
           codepage                  = g_csv_attr-encoding
*          ignore_cerr               = ABAP_TRUE
*          replacement               = '#'
*          write_bom                 = SPACE
*          trunc_trailing_blanks_eol = 'X'
*          wk1_n_format              = SPACE
*          wk1_n_size                = SPACE
*          wk1_t_format              = SPACE
*          wk1_t_size                = SPACE
*        IMPORTING
*          filelength                = filelength
        CHANGING
          data_tab                  = gt_data_csv
*        EXCEPTIONS
*          file_write_error          = 1
*          no_batch                  = 2
*          gui_refuse_filetransfer   = 3
*          invalid_type              = 4
*          no_authority              = 5
*          unknown_error             = 6
*          header_not_allowed        = 7
*          separator_not_allowed     = 8
*          filesize_not_allowed      = 9
*          header_too_long           = 10
*          dp_error_create           = 11
*          dp_error_send             = 12
*          dp_error_write            = 13
*          unknown_dp_error          = 14
*          access_denied             = 15
*          dp_out_of_memory          = 16
*          disk_full                 = 17
*          dp_timeout                = 18
*          file_not_found            = 19
*          dataprovider_exception    = 20
*          control_flush_error       = 21
*          not_supported_by_gui      = 22
*          error_no_gui              = 23
             ).
      IF sy-subrc <> 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.



    WHEN 'CANCEL'.

      CLEAR g_tab_columns_container.
      CLEAR g_col_grid.

      IF g_col_grid IS BOUND.
        g_col_grid->free( ).
      ENDIF.

      FREE g_tab_columns_container.
      FREE g_col_grid.

      FREE gt_col_alv.

      SET SCREEN 0.
      LEAVE SCREEN.

    WHEN 'COL_SEP_CHANGED'. "Col Sep Changed

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0100 INPUT.
  CASE 'X'.
    WHEN rad_separated_by_tab.
      MOVE 'TAB' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_comma.
      MOVE 'COMMA' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_semicolon.
      MOVE 'SEMICOLON' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_space.
      MOVE 'SPACE' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_other.
      MOVE 'OTHER' TO g_csv_attr-field_separator.
  ENDCASE.
ENDMODULE.                 " PAI_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAU_FIELD_SEP_CHANGED  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pau_field_sep_changed INPUT.
  IF g_csv_attr-field_separator_other NE space.
    g_csv_attr-field_separator = 'OTHER'.
  ENDIF.
ENDMODULE.                 " PAU_FIELD_SEP_CHANGED  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0110 INPUT.
  CASE 'X'.
    WHEN rad_separated_by_tab.
      MOVE 'TAB' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_comma.
      MOVE 'COMMA' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_semicolon.
      MOVE 'SEMICOLON' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_space.
      MOVE 'SPACE' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_other.
      MOVE 'OTHER' TO g_csv_attr-field_separator.
  ENDCASE.
ENDMODULE.                 " PAI_0110  INPUT
