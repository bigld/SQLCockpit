*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCSUBROUTINEM01.
*----------------------------------------------------------------------*
DEFINE m_process_version_2.

"!!!TODO


END-OF-DEFINITION.

DEFINE m_process_version_1.

  DATA: BEGIN OF ls_syn_msg,
          l1(72),
          l2(72),
          l3(72),
        END OF ls_syn_msg.

  DATA lr_parser          TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
  DATA lt_result_source   TYPE /cadaxo/sqlcselectsource_fla_t.
  DATA lt_code            TYPE /cadaxo/sqlcstring_t.
  DATA l_pool_name        LIKE sy-repid.
  DATA l_syn_lin          TYPE i.
  DATA l_syn_wrd          TYPE c LENGTH 30.
  DATA l_from             TYPE i.
  DATA l_to               TYPE i.
  DATA lr_result          TYPE REF TO data.
  DATA lr_tab_result_exp  TYPE REF TO cl_abap_tabledescr.
  DATA lrx_root           TYPE REF TO cx_root.
  DATA l_user_settings    TYPE /cadaxo/sqlcusrp_dyn. "$002
  FIELD-SYMBOLS: <lt_result_table> TYPE STANDARD TABLE.

  CREATE OBJECT lr_parser.

  IMPORT dfies = lr_parser->gt_result_ddfields
         result_source = lt_result_source
         source_syntax = lr_parser->source_syntax
         column_syntax = lr_parser->column_syntax
         code          = lt_code
         user_settings = l_user_settings "$002
         FROM DATA BUFFER ic_data.

  MOVE-CORRESPONDING lt_result_source TO lr_parser->result_source_t.

  IF lines( lr_parser->gt_result_ddfields ) = 1 AND lr_parser->gt_result_ddfields[ 1 ]-fieldname IS INITIAL.
    IF lr_parser->column_syntax NP 'COUNT( *'.         "bigld COCKPIT-246
      lr_parser->column_syntax = '*'.
    ENDIF.                                            "bigld COCKPIT-43
  ENDIF.

  lr_parser->create_alv_field_catalog_v_1( ).
  lr_parser->create_result_structures( ).

  ASSIGN lr_parser->result_table->* TO <lt_result_table>.

* generate the subroutine pool
  GENERATE SUBROUTINE POOL lt_code NAME l_pool_name
                                MESSAGE ls_syn_msg
                                   LINE l_syn_lin
                                   WORD l_syn_wrd.

  IF ls_syn_msg IS INITIAL.

    GET RUN TIME FIELD l_from.

    CREATE DATA lr_result TYPE c.

    PERFORM form  IN PROGRAM (l_pool_name) TABLES   <lt_result_table>
                                           USING    lr_tab_result_exp
                                                    lr_result
                                                    l_user_settings-sql_trace "$002
                                                    l_user_settings-tablebuffer_trace "$002
                                           CHANGING lrx_root.

    GET RUN TIME FIELD l_to.

    e_runtime = l_to - l_from.
    e_result_lines = sy-dbcnt.

  ELSE.
    e_error_message = ls_syn_msg.
  ENDIF.

  CLEAR ic_data.

  EXPORT data = <lt_result_table> TO DATA BUFFER ic_data.

END-OF-DEFINITION.
