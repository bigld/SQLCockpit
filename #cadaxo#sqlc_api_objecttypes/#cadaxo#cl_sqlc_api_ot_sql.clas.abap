class /CADAXO/CL_SQLC_API_OT_SQL definition
  public
  final
  create public .

public section.

  interfaces /CADAXO/IF_API_OBJECTTYPE .
protected section.
private section.
ENDCLASS.



CLASS /CADAXO/CL_SQLC_API_OT_SQL IMPLEMENTATION.


  method /CADAXO/IF_API_OBJECTTYPE~GET_VERSION.

    RV_VERSION = '1.0'.

  endmethod.


  METHOD /cadaxo/if_api_objecttype~prepare_export.

    DATA ls_data TYPE /cadaxo/sqlccodeline.
    DATA lt_data TYPE /cadaxo/sqlccodeline_t.

    TRY.

        cl_abap_gzip=>decompress_binary( EXPORTING gzip_in  = iv_data
                                         IMPORTING raw_out = DATA(lv_decompress) ).

        CALL TRANSFORMATION id SOURCE XML lv_decompress
                               RESULT data = lt_data.
        APPEND ls_data TO lt_data.
        rt_sql = lt_data.

      CATCH cx_xslt_format_error.
      "TODO - Errorhandling - technical error - queue record could not be read ...
    ENDTRY.

  ENDMETHOD.


  method /CADAXO/IF_API_OBJECTTYPE~PREPARE_IMPORT.

    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE data = iv_data RESULT XML json_writer.
    DATA(lv_json) = json_writer->get_output( ).

    cl_abap_gzip=>compress_binary( EXPORTING raw_in   = lv_json
                                   IMPORTING gzip_out = ev_data ).

  endmethod.
ENDCLASS.
