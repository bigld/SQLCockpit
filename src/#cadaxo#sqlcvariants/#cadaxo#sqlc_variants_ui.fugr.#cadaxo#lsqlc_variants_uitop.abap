FUNCTION-POOL /cadaxo/sqlc_variants_ui.     "MESSAGE-ID ..

DATA ok_code            TYPE sy-ucomm.
DATA gcl_controller  TYPE REF TO /cadaxo/cl_sqlc_variants.

DATA rad_langu_e TYPE c LENGTH 1.
DATA rad_langu_d TYPE c LENGTH 1.

DATA g_description TYPE c LENGTH 40.

DATA g_vardescription_insert TYPE /cadaxo/sqlcvari_descr.

DATA lt_excluding_fcode TYPE TABLE OF fcode.
"data gt_excl_fcode_insert_var type table of fcode.
"data gt_excl_fcode_downld_var type table of fcode.
