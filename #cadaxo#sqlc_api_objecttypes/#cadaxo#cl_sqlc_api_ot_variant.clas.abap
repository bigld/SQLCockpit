class /CADAXO/CL_SQLC_API_OT_VARIANT definition
  public
  final
  create public .

public section.

  interfaces /CADAXO/IF_API_OBJECTTYPE .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /CADAXO/CL_SQLC_API_OT_VARIANT IMPLEMENTATION.


  METHOD /CADAXO/IF_API_OBJECTTYPE~GET_VERSION.

    rv_version = '1.0'.

  ENDMETHOD.


  METHOD /cadaxo/if_api_objecttype~prepare_export.

    DATA: ls_variant TYPE /cadaxo/sqlc_il_variants.
    DATA: lt_variant TYPE TABLE OF /cadaxo/sqlc_il_variants.

    cl_abap_gzip=>decompress_binary( EXPORTING gzip_in  = iv_data
                                     IMPORTING raw_out = DATA(lv_decompress) ).

    CALL TRANSFORMATION id SOURCE XML lv_decompress
                           RESULT data = ls_variant.
    APPEND ls_variant TO lt_variant.
    rt_sql = lt_variant.

  ENDMETHOD.


  METHOD /CADAXO/IF_API_OBJECTTYPE~PREPARE_IMPORT.


    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    CALL TRANSFORMATION id SOURCE data = iv_data
                           RESULT XML json_writer.
    DATA(lv_json) = json_writer->get_output( ).

    cl_abap_gzip=>compress_binary( EXPORTING raw_in   = lv_json
                                   IMPORTING gzip_out = ev_data ).

  ENDMETHOD.
ENDCLASS.
