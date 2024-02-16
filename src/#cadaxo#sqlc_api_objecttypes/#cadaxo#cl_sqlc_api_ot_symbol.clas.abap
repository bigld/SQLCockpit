CLASS /cadaxo/cl_sqlc_api_ot_symbol DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /cadaxo/if_api_objecttype .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /cadaxo/cl_sqlc_api_ot_symbol IMPLEMENTATION.


  METHOD /cadaxo/if_api_objecttype~get_ui_icon.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = 'ICON_CONVERT'
        info   = 'Symbols'
      IMPORTING
        result = e_icon_quickinfo
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc <> 0.
      CLEAR e_icon_quickinfo.
    ENDIF.

  ENDMETHOD.


  METHOD /cadaxo/if_api_objecttype~get_version.

    rv_version = '1.0'.

  ENDMETHOD.


  METHOD /cadaxo/if_api_objecttype~prepare_export.

* TODO: check the type of ev_data

    DATA: lt_symbol_data TYPE /cadaxo/sqlc_symbol_t.

    cl_abap_gzip=>decompress_binary( EXPORTING gzip_in  = iv_data
                                     IMPORTING raw_out = DATA(lv_decompress) ).

    CALL TRANSFORMATION id SOURCE XML lv_decompress
                           RESULT data = lt_symbol_data.

    rt_sql = lt_symbol_data.

  ENDMETHOD.


  METHOD /cadaxo/if_api_objecttype~prepare_import.


    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    CALL TRANSFORMATION id SOURCE data = iv_data
                           RESULT XML json_writer.
    DATA(lv_json) = json_writer->get_output( ).

    cl_abap_gzip=>compress_binary( EXPORTING raw_in   = lv_json
                                   IMPORTING gzip_out = ev_data ).

  ENDMETHOD.
ENDCLASS.
