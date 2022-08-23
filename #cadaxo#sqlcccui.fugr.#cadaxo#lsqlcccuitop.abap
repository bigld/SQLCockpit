FUNCTION-POOL /CADAXO/SQLCCCUI.             "MESSAGE-ID ..

* INCLUDE /CADAXO/LSQLCCCUID...
DATA: go_join         TYPE REF TO /cadaxo/cl_sqlc_join_complet.
DATA: go_abapedit     TYPE REF TO /cadaxo/cl_sqlc_gui_abapedit.
DATA: g_ok_code       TYPE sy-ucomm.
DATA: g_col           TYPE i.
DATA: g_row           TYPE i.
DATA: g_col_t         TYPE i.
DATA: g_row_t         TYPE i.
DATA: g_ins           TYPE abap_bool.
DATA  g_sql           TYPE string.             " Local class definition
