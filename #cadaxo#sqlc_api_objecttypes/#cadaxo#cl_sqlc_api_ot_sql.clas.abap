CLASS /cadaxo/cl_sqlc_api_ot_sql DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /cadaxo/if_api_objecttype .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /cadaxo/cl_sqlc_api_ot_sql IMPLEMENTATION.


  METHOD /cadaxo/if_api_objecttype~get_version.

    rv_version = '1.0'.

  ENDMETHOD.


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


  METHOD /cadaxo/if_api_objecttype~prepare_import.

    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE data = iv_data RESULT XML json_writer.
    DATA(lv_json) = json_writer->get_output( ).

    cl_abap_gzip=>compress_binary( EXPORTING raw_in   = lv_json
                                   IMPORTING gzip_out = ev_data ).

  ENDMETHOD.

  METHOD /cadaxo/if_api_objecttype~get_ui_icon.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = 'ICON_SPOOL_REQUEST'
        info   = 'SQL'
      IMPORTING
        result = e_icon_quickinfo
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc <> 0.
      CLEAR e_icon_quickinfo.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
