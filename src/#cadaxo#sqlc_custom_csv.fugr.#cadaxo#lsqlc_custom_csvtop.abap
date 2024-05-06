FUNCTION-POOL /cadaxo/sqlc_custom_csv.      "MESSAGE-ID ..

DATA: g_ok_code       TYPE sy-ucomm.
DATA: g_col   TYPE i,
      g_row   TYPE i,
      g_col_t TYPE i,
      g_row_t TYPE i.

DATA: BEGIN OF rad_separated_by,
        tab        TYPE c LENGTH 1,
        comma      TYPE c LENGTH 1,
        semicolon  TYPE c LENGTH 1,
        whitespace TYPE c LENGTH 1,
        other      TYPE c LENGTH 1,
      END OF rad_separated_by.

DATA: g_csv_attr TYPE /cadaxo/sqlc_csv_cust.
DATA: appserver  TYPE flag.
DATA: dataset    TYPE c LENGTH 1024.
DATA: g_cancel   TYPE abap_bool.
