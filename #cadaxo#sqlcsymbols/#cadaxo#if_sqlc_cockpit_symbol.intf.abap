*"* components of interface /CADAXO/IF_SQLC_COCKPIT_SYMBOL
interface /CADAXO/IF_SQLC_COCKPIT_SYMBOL
  public .


  class-methods GET_SYMBOL_VALUE
    importing
      !I_SYMBOL type /CADAXO/SQLCSYMBOL_NAME optional
    exporting
      !E_VALUE type ANY .
endinterface.
