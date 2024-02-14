CLASS /cadaxo/cl_sqlc_functrace DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    CLASS-METHODS add_trace IMPORTING iv_commit      TYPE boolean DEFAULT abap_true
                                      iv_function_id TYPE /cadaxo/sqlc_function_id.
  PROTECTED SECTION.
  PRIVATE SECTION.


    CONSTANTS c_2nd_connection TYPE char30 VALUE 'R/3*SAP_2TH_CONNECT_APPL_LOG' ##NO_TEXT.

    CLASS-DATA gr_trace TYPE REF TO /cadaxo/cl_sqlc_functrace.
    CLASS-METHODS _get_instance
      RETURNING
        VALUE(er_trace) TYPE REF TO /cadaxo/cl_sqlc_functrace.


ENDCLASS.



CLASS /CADAXO/CL_SQLC_FUNCTRACE IMPLEMENTATION.


  METHOD add_trace.

    IF iv_function_id <> 'ENTER'.

      TRY.
          UPDATE /cadaxo/sqlcfutr CONNECTION (c_2nd_connection)
                                  SET last_used = sy-datum
                                      use_count = use_count + 1
                                  WHERE function = iv_function_id.
          IF sy-subrc <> 0.
            DATA(ls_function_trace) = VALUE /cadaxo/sqlcfutr( last_used = sy-datum
                                                              use_count = 1
                                                              function = iv_function_id ).

            INSERT /cadaxo/sqlcfutr CONNECTION (c_2nd_connection) FROM @ls_function_trace.

          ENDIF.

          IF sy-subrc = 0 AND iv_commit = abap_true.
            COMMIT CONNECTION (c_2nd_connection).
          ENDIF.

        CATCH cx_sy_sql_error INTO DATA(lo_ex).
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD _get_instance.

    IF gr_trace IS NOT BOUND.
      CREATE OBJECT gr_trace.
    ENDIF.

    er_trace = gr_trace.

  ENDMETHOD.
ENDCLASS.
