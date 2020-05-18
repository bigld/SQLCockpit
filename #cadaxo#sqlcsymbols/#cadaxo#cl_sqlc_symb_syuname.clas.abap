class /CADAXO/CL_SQLC_SYMB_SYUNAME definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_SYMB_SYUNAME
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



CLASS /CADAXO/CL_SQLC_SYMB_SYUNAME IMPLEMENTATION.


METHOD /cadaxo/if_sqlc_cockpit_symbol~get_symbol_value.
  MOVE sy-uname TO e_value.

  e_value = `'` && e_value && `'`.
ENDMETHOD.
ENDCLASS.
