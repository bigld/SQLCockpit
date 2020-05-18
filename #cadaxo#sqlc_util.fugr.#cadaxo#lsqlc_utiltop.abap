FUNCTION-POOL /cadaxo/sqlc_util.            "MESSAGE-ID ..

* INCLUDE /CADAXO/LSQLC_UTILD...             " Local class definition

DATA: g_col   TYPE i,
      g_row   TYPE i,
      g_col_t TYPE i,
      g_row_t TYPE i.

CONSTANTS gc_ok_code    TYPE sy-ucomm VALUE 'OK'.
CONSTANTS gc_cancl_code TYPE sy-ucomm VALUE 'CANCEL'.
CONSTANTS gc_true       TYPE i VALUE 1.
CONSTANTS gc_false      TYPE i VALUE 0.

DATA gv_code          TYPE sy-ucomm.
DATA gv_edit          TYPE abap_bool.
DATA gv_changed       TYPE abap_bool.
DATA gv_value         TYPE string.
DATA gr_datadescr TYPE REF TO cl_abap_datadescr.
DATA gv_valid         TYPE abap_bool.

DATA: gcont_value_textarea TYPE REF TO cl_gui_custom_container.
DATA: gc_value_textarea    TYPE REF TO cl_gui_textedit.
