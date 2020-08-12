FUNCTION-POOL /cadaxo/sqlc_custom_csv.      "MESSAGE-ID ..

DATA: g_ok_code       TYPE sy-ucomm.
DATA: g_col   TYPE i,
      g_row   TYPE i,
      g_col_t TYPE i,
      g_row_t TYPE i.

DATA rad_separated_by_tab       TYPE c LENGTH 1.
DATA rad_separated_by_comma     TYPE c LENGTH 1.
DATA rad_separated_by_semicolon TYPE c LENGTH 1.
DATA rad_separated_by_space     TYPE c LENGTH 1.
DATA rad_separated_by_other     TYPE c LENGTH 1.

DATA: g_csv_attr TYPE /cadaxo/sqlc_csv_cust.
DATA: g_cancel TYPE abap_bool.
