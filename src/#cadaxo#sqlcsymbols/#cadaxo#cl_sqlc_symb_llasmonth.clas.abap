class /CADAXO/CL_SQLC_SYMB_LLASMONTH definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_SYMB_LLASMONTH
*"* do not include other source files here!!!
public section.

  interfaces /CADAXO/IF_SQLC_COCKPIT_SYMBOL .
protected section.
*"* protected components of class /CADAXO/SQLC_CL_SYMB_SYUNAME
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/SQLC_CL_SYMB_SYUNAME
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CL_SQLC_SYMB_LLASMONTH IMPLEMENTATION.


METHOD /CADAXO/IF_SQLC_COCKPIT_SYMBOL~GET_SYMBOL_VALUE.

  DATA: l_date LIKE sy-datum.

  l_date = sy-datlo.

  l_date+6(2) = '01'.
  l_date = l_date - 1.

  e_value = l_date.

  e_value = `'` && e_value && `'`.

ENDMETHOD.
ENDCLASS.
