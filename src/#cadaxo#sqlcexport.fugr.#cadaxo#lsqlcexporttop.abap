FUNCTION-POOL /cadaxo/sqlcexport.           "MESSAGE-ID ..

*CLASS lcl_export_cols_alv DEFINITION DEFERRED.

DATA g_ok_code                  TYPE sy-ucomm.

DATA rad_separated_by_tab       TYPE c LENGTH 1.
DATA rad_separated_by_comma     TYPE c LENGTH 1.
DATA rad_separated_by_semicolon TYPE c LENGTH 1.
DATA rad_separated_by_space     TYPE c LENGTH 1.
DATA rad_separated_by_other     TYPE c LENGTH 1.

DATA g_csv_attr                 TYPE /cadaxo/sqlcexportcsvattr.

DATA g_exp_preview_container    TYPE REF TO cl_gui_custom_container.
DATA g_exp_preview_editor       TYPE REF TO cl_gui_textedit.
DATA g_tab_columns_container    TYPE REF TO cl_gui_custom_container.
DATA g_col_grid                 TYPE REF TO cl_gui_alv_grid.
DATA g_export_type              TYPE c LENGTH 3 VALUE 'BCS'.
DATA g_export_frame_text        TYPE c LENGTH 30.
DATA g_sub_dynpro               TYPE c LENGTH 4.

DATA gt_col_alv TYPE TABLE OF /cadaxo/sqlcexportcolalv.
DATA ls_col_alv TYPE /cadaxo/sqlcexportcolalv.

FIELD-SYMBOLS: <gt_table> TYPE ANY TABLE.
FIELD-SYMBOLS: <gt_fcat>  TYPE lvc_t_fcat.
FIELD-SYMBOLS: <ls_fcat>  TYPE lvc_s_fcat.

DATA gt_data_csv TYPE TABLE OF string.
DATA gt_data_csv_text TYPE STANDARD TABLE OF /cadaxo/sqlc_char_1024.

*lcl_export_cols_alv

CLASS lcl_export_cols_alv DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
    handle_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid,
    refresh_preview.
ENDCLASS.                    "lcl_export_cols_alv DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_export_cols_alv IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_export_cols_alv IMPLEMENTATION.
  METHOD handle_data_changed_finished.
    lcl_export_cols_alv=>refresh_preview( ).
  ENDMETHOD.                    "handle_user_command
  METHOD refresh_preview.

    g_col_grid->check_changed_data( ).

    data lr_csv_export type ref to /CADAXO/CL_SQLC_COCKPIT_EXPCSV.

    create object lr_csv_export.

    lr_csv_export->set_attributes( g_csv_attr ).

    lr_csv_export->set_columns( gt_col_alv ).

    lr_csv_export->convert_data( exporting it_data = <gt_table>
                                 importing et_data = gt_data_csv ).


*    /cadaxo/cl_sqlc_cockpit_assist=>convert_data_to_csv( EXPORTING i_csv_attr = g_csv_attr
*                                                                   it_data    = <gt_table>
*                                                                   it_col_alv = gt_col_alv
*                                                         IMPORTING et_data    = gt_data_csv ).
    CLEAR gt_data_csv_text.
    APPEND LINES OF gt_data_csv FROM 1 TO 20 TO gt_data_csv_text.

    g_exp_preview_editor->set_text_as_r3table(
      EXPORTING
        table    = gt_data_csv_text
      EXCEPTIONS
        error_dp = 1
        error_dp_create = 2 ).
  ENDMETHOD.                    "refresh_preview
ENDCLASS.                    "lcl_export_cols_alv IMPLEMENTATION
