class /CADAXO/CL_SQLC_DCOMP_GRID definition
  public
  inheriting from CL_GUI_ALV_GRID
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_DCOMP_GRID
*"* do not include other source files here!!!
public section.

  methods /CADAXO/SET_FIXED_ROWS_PUBLIC
    importing
      !I_ROWS type I .
protected section.
*"* protected components of class /CADAXO/CL_SQLC_DCOMP_GRID
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CL_SQLC_DCOMP_GRID
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CL_SQLC_DCOMP_GRID IMPLEMENTATION.


METHOD /cadaxo/set_fixed_rows_public.
  CALL METHOD me->set_fixed_rows
    EXPORTING
      rows   = i_rows
    EXCEPTIONS
      error  = 1
      OTHERS = 2.
ENDMETHOD.
ENDCLASS.
