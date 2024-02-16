INTERFACE /cadaxo/if_api_objecttype
  PUBLIC .

  METHODS prepare_import IMPORTING VALUE(iv_data) TYPE any
                         EXPORTING VALUE(ev_data) TYPE xsequence.
  METHODS get_version RETURNING VALUE(rv_version) TYPE /cadaxo/sqlcapi_version.
  METHODS prepare_export IMPORTING VALUE(iv_data) TYPE xstring
                         EXPORTING VALUE(rt_sql)  TYPE ANY TABLE.
  METHODS get_ui_icon RETURNING VALUE(e_icon_quickinfo) TYPE /cadaxo/sqlcapi_position_typic.

ENDINTERFACE.
