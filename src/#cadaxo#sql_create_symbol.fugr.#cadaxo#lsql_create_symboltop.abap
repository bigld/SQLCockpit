FUNCTION-POOL /cadaxo/sql_create_symbol.            "MESSAGE-ID ..

DATA: g_ok_code         TYPE sy-ucomm.

DATA: g_col   TYPE i,
      g_row   TYPE i,
      g_col_t TYPE i,
      g_row_t TYPE i.

DATA gv_symbol_name TYPE /cadaxo/sqlcvnsy-symbol_name.
DATA gv_symbol_desc TYPE /cadaxo/sqlcvnsy-symbol_desc.
DATA gv_rollname    TYPE /cadaxo/sqlcvnsy-symbol_datatype.
FIELD-SYMBOLS <gt_symbol_values> TYPE ANY TABLE.
DATA gt_sel_data    TYPE rseloption.
