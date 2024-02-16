class /CADAXO/CL_SQLC_SYMB_YESTERDAY definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_SYMB_YESTERDAY
*"* do not include other source files here!!!
public section.

  interfaces /CADAXO/IF_SQLC_COCKPIT_SYMBOL .
protected section.
*"* protected components of class /CADAXO/CL_SQCL_SYMB_LASTDAY
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CL_SQCL_SYMB_LASTDAY
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CL_SQLC_SYMB_YESTERDAY IMPLEMENTATION.


METHOD /cadaxo/if_sqlc_cockpit_symbol~get_symbol_value.
  DATA: l_date LIKE sy-datum.

  l_date = sy-datlo - 1.

  MOVE:  l_date TO e_value.

  e_value = `'` && e_value && `'`.

ENDMETHOD.
ENDCLASS.
