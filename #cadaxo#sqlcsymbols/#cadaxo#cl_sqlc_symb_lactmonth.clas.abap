class /CADAXO/CL_SQLC_SYMB_LACTMONTH definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_SYMB_LACTMONTH
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



CLASS /CADAXO/CL_SQLC_SYMB_LACTMONTH IMPLEMENTATION.


METHOD /CADAXO/IF_SQLC_COCKPIT_SYMBOL~GET_SYMBOL_VALUE.

  DATA: l_date TYPE d,
        t_tab TYPE STANDARD TABLE OF rsintrange.

  CALL FUNCTION 'RS_VARI_V_L_ACTUAL_MONTH'
    IMPORTING
      p_date     = l_date
    TABLES
      p_intrange = t_tab.

  MOVE l_date TO e_value.

  e_value = `'` && e_value && `'`.

ENDMETHOD.
ENDCLASS.
