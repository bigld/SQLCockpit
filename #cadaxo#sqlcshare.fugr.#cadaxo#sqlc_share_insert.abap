FUNCTION /cadaxo/sqlc_share_insert.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_SENDER) TYPE  /CADAXO/SQLCAPI_SENDER OPTIONAL
*"     VALUE(IV_SENDER_TYP) TYPE  /CADAXO/SQLCAPI_SENDER_TYP OPTIONAL
*"     VALUE(IV_RECEIVER) TYPE  /CADAXO/SQLCAPI_RECEIVER OPTIONAL
*"     VALUE(IV_RECEIVER_TYP) TYPE  /CADAXO/SQLCAPI_RECEIVER_TYP
*"       OPTIONAL
*"     VALUE(IV_EXPIRATION) TYPE  /CADAXO/SQLCAPI_EXPIRATION OPTIONAL
*"     VALUE(IV_EXPORT_TYPE) TYPE  /CADAXO/SQLCAPI_POSITION_TYP
*"       OPTIONAL
*"     VALUE(IV_DESCRIPTION) TYPE  STRING OPTIONAL
*"     VALUE(IT_SYMBOLS) TYPE  /CADAXO/SQLC_SYMBOL_T OPTIONAL
*"     VALUE(IT_SQL) TYPE  /CADAXO/SQLCCODELINE_T OPTIONAL
*"     VALUE(IS_VARIANT) TYPE  /CADAXO/SQLC_IL_VARIANTS OPTIONAL
*"     VALUE(IV_RFCDEST) TYPE  /CADAXO/SQLCAPI_RFCDEST OPTIONAL
*"     VALUE(IV_RFCSENDER) TYPE  /CADAXO/SQLCAPI_RFCSENDER OPTIONAL
*"     VALUE(IS_SAVED_LIST) TYPE  /CADAXO/SQLC_LIST_EXP_SQLX OPTIONAL
*"----------------------------------------------------------------------


  DATA(ro_api) = /cadaxo/cl_sqlc_cockpit_api=>create_share_factory( EXPORTING iv_description  = iv_description
                                                                              iv_sender       = iv_sender
                                                                              iv_sender_typ   = iv_sender_typ
                                                                              iv_receiver     = iv_receiver
                                                                              iv_receiver_typ = iv_receiver_typ
                                                                              iv_expiration   = iv_expiration
                                                                              iv_rfcdest      = iv_rfcdest ).

  IF iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-sql.
    ro_api->add_item( EXPORTING iv_typ = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-sql iv_data = it_sql ).

  ELSEIF iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-symbols.
    ro_api->add_item( EXPORTING iv_typ = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-symbols iv_data = it_symbols ).

  ELSEIF iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-variant.
    ro_api->add_item( EXPORTING iv_typ = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-variant iv_data = is_variant ).

  ELSEIF iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-saved."#Cockpit-401
    is_saved_list-uname = iv_receiver.
    ro_api->add_item( EXPORTING iv_typ = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-saved iv_data = is_saved_list ).

  ENDIF.


ENDFUNCTION.
