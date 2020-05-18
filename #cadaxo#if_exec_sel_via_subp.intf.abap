*"* components of interface /CADAXO/IF_EXEC_SEL_VIA_SUBP
interface /CADAXO/IF_EXEC_SEL_VIA_SUBP
  public .


  interfaces IF_BADI_INTERFACE .

  methods EXECUTE_SELECT_VIA_SUBPOOL
    importing
      !I_PROGRESS_INDICATOR type CHAR1
      !I_RESULT_STRUCT type ANY
    exporting
      !E_RESULT_TABLE type STANDARD TABLE
      !E_RESULT_DETAILS type /CADAXO/SQLCRESULT_DETAILS
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
endinterface.
