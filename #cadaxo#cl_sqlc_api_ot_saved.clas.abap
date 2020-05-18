class /CADAXO/CL_SQLC_API_OT_SAVED definition
  public
  final
  create public .

public section.

  interfaces /CADAXO/IF_API_OBJECTTYPE .
protected section.
private section.
ENDCLASS.



CLASS /CADAXO/CL_SQLC_API_OT_SAVED IMPLEMENTATION.


  method /CADAXO/IF_API_OBJECTTYPE~GET_VERSION.

    RV_VERSION = '1.0'.

  endmethod.


  METHOD /cadaxo/if_api_objecttype~prepare_export.

****************************************************************************************************
* Description             : prepare export                                                         *
*--------------------------------------------------------------------------------------------------*
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*08.10.2019  |Pat                   | cockpit-401                                 |                *
****************************************************************************************************

    DATA ls_data TYPE /cadaxo/sqlc_list_exp_sqlx.
    DATA lt_data TYPE /cadaxo/sqlc_list_exp_sqlx_t.

    cl_abap_gzip=>decompress_binary( EXPORTING gzip_in  = iv_data
                                     IMPORTING raw_out = DATA(lv_decompress) ).

    CALL TRANSFORMATION id SOURCE XML lv_decompress
                           RESULT data = ls_data.
    APPEND ls_data TO lt_data.
    rt_sql = lt_data.

  ENDMETHOD.


  method /CADAXO/IF_API_OBJECTTYPE~PREPARE_IMPORT.

    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE data = iv_data RESULT XML json_writer.
    DATA(lv_json) = json_writer->get_output( ).

    cl_abap_gzip=>compress_binary( EXPORTING raw_in   = lv_json
                                   IMPORTING gzip_out = ev_data ).

  endmethod.
ENDCLASS.
