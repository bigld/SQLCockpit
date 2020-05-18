FUNCTION-POOL /cadaxo/sqlcshare.            "MESSAGE-ID ..

DATA: g_sql_pos          TYPE i.
DATA: g_sql_hist_lines   TYPE i.

DATA: g_col   TYPE i,
      g_row   TYPE i,
      g_col_t TYPE i,
      g_row_t TYPE i.

DATA: BEGIN OF ls_data,
        value TYPE rfcdest,
      END OF ls_data,
      gt_rfcdest LIKE STANDARD TABLE OF ls_data.

DATA: g_dynpro_text      TYPE string.
DATA: g_sqlcsres         TYPE /cadaxo/sqlcsres.
DATA: gt_sqlcadoc        TYPE TABLE OF /cadaxo/sqlcadoc.
DATA: gt_sqlcadot        TYPE TABLE OF /cadaxo/sqlcadot.
DATA: gt_sql_cockpit_standard_users TYPE /cadaxo/sqlc_user_name_t.
DATA: gt_sql_cockpit_rfc_dest       TYPE /cadaxo/sqlcapi_rfc_t. "COCKPIT-295
DATA: g_sqlcadoc         TYPE /cadaxo/sqlcadoc.
DATA: g_sqlcadot         TYPE /cadaxo/sqlcadot.
DATA: gd_adt_info_i      TYPE icon_text.
DATA: gr_text_share_3001 TYPE REF TO cl_gui_textedit .
DATA: gr_cont_text_share_descr TYPE REF TO cl_gui_custom_container .
DATA: g_ok_code         TYPE sy-ucomm.
DATA: g_receiver        TYPE /cadaxo/sqlcapi_receiver.             "COCKPIT-232
DATA: g_rfcdest         TYPE /cadaxo/sqlcapi_rfcdest .             "COCKPIT-295
DATA: gv_export_type    TYPE /cadaxo/sqlcapi_position_typ.
DATA: gt_sql            TYPE /cadaxo/sqlccodeline_t.
DATA: gt_symbols        TYPE /cadaxo/sqlc_symbol_t.
DATA: gs_variant        TYPE /cadaxo/sqlc_il_variants.
DATA: gs_saved_list     TYPE /cadaxo/sqlc_list_exp_sqlx.
