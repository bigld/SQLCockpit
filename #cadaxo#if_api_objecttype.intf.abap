interface /CADAXO/IF_API_OBJECTTYPE
  public .


  class-methods PREPARE_IMPORT
    importing
      value(IV_DATA) type ANY
    exporting
      value(EV_DATA) type XSEQUENCE .
  class-methods GET_VERSION
    returning
      value(RV_VERSION) type /CADAXO/SQLCAPI_VERSION .
  class-methods PREPARE_EXPORT
    importing
      value(IV_DATA) type XSTRING
    exporting
      value(RT_SQL) type ANY TABLE .
endinterface.
