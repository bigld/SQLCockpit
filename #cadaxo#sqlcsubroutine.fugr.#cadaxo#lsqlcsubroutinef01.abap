*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCSUBROUTINEF01.
*----------------------------------------------------------------------*
****************************************************************************************************
* Description             : Generate and Execute Subroutine Pool for Subselects                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.11.2015               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 04.01.2016                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 22.03.2016 | Domi Bigl            | V1 COUNT * with SubPool                     | COCKPIT-43     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 01.06.2016 | Ana Lekic            | activate the trace later                    | $002 COCKPIT-59*
****************************************************************************************************
*&---------------------------------------------------------------------*
*&      Form  PROCESS_VERSION_1
*&---------------------------------------------------------------------*
FORM process_version_1 CHANGING e_error_message TYPE string
                                e_runtime       TYPE int4
                                e_result_lines  TYPE int4
                                et_result       TYPE xstring
                                et_dfies        TYPE /cadaxo/sqlcdfies_t
                                ic_data         TYPE xstring.
  m_process_version_1.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_VERSION_2
*&---------------------------------------------------------------------*
****************************************************************************************************
* Description             : Generate and Execute Subroutine Pool for Subselects                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.11.2015               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 04.01.2016                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 01.06.2016 | Ana Lekic            | activate the trace later                    | $001 COCKPIT-59*
*------------+----------------------+---------------------------------------------+----------------*
* 05.10.2016 | Domi Bigl            | non Unicode                                 |$002 COCKPIT-116*
****************************************************************************************************
FORM process_version_2 CHANGING e_error_message TYPE string
                                e_runtime       TYPE int4
                                e_result_lines  TYPE int4
                                et_result       TYPE xstring
                                et_dfies        TYPE /cadaxo/sqlcdfies_t
                                et_dfies_all    TYPE /cadaxo/sqlcdfies_t
                                ic_data         TYPE xstring.

  m_process_version_2.

* MACRO START
  DATA: BEGIN OF ls_syn_msg,
          l1(72),
          l2(72),
          l3(72),
        END OF ls_syn_msg.

  DATA lr_parser          TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
  DATA lt_code            TYPE /cadaxo/sqlcstring_t.
  DATA lt_result_source   TYPE /cadaxo/sqlcselectsource_fla_t.
  DATA lt_result          TYPE TABLE OF c.
  DATA l_pool_name        LIKE sy-repid.
  DATA l_syn_lin          TYPE i.
  DATA l_syn_wrd          TYPE c LENGTH 30.
  DATA l_from             TYPE i.
  DATA l_to               TYPE i.
  DATA lr_result          TYPE REF TO data.
  DATA lr_tab_result_exp  TYPE REF TO cl_abap_tabledescr.
  DATA lrx_root           TYPE REF TO cx_root.
  DATA lr_typedescr       TYPE REF TO cl_abap_typedescr.
  DATA lr_tabledescr      TYPE REF TO cl_abap_tabledescr.
  DATA lr_strucdescr      TYPE REF TO cl_abap_structdescr.
  DATA lr_strucdescr_main TYPE REF TO cl_abap_structdescr.
  DATA lt_components      TYPE cl_abap_structdescr=>component_table.
  DATA lr_element         TYPE REF TO cl_abap_elemdescr.
  DATA lsqlc_dfies        TYPE /cadaxo/sqlcdfies.
  DATA l_dfies            TYPE dfies.
  DATA lt_incl_view       TYPE cl_abap_structdescr=>included_view.
  DATA l_user_settings    TYPE /cadaxo/sqlcusrp_dyn.
  DATA lt_symbol_ranges   TYPE /cadaxo/cl_sqlc_cockpit_parse=>gtt_symbol_variable.
  FIELD-SYMBOLS: <lt_result_table> TYPE STANDARD TABLE.
  FIELD-SYMBOLS: <et_dfies>        LIKE et_dfies.

  CREATE OBJECT lr_parser.

  IMPORT code = lt_code FROM DATA BUFFER ic_data.
  IMPORT user_settings = l_user_settings FROM DATA BUFFER ic_data. "$001
  IMPORT range_tables = lt_symbol_ranges FROM DATA BUFFER ic_data.

  ASSIGN lt_result TO <lt_result_table>.

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
                                                    l_user_settings-sql_trace "$001
                                                    l_user_settings-tablebuffer_trace "$001
                                                    lt_symbol_ranges
                                           CHANGING lrx_root.

    GET RUN TIME FIELD l_to.

    e_runtime = l_to - l_from.
    e_result_lines = sy-dbcnt.

  ELSE.
    e_error_message = ls_syn_msg.
  ENDIF.

  IF e_error_message IS INITIAL.

    lr_parser->result_table = lr_result.

    lr_tabledescr ?= cl_abap_tabledescr=>describe_by_data_ref( EXPORTING p_data_ref = lr_result ).
    lr_typedescr ?= lr_tabledescr->get_table_line_type( ).

    CASE lr_typedescr->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        lr_strucdescr_main ?= lr_typedescr.
        lt_components = lr_strucdescr_main->get_components( ).

      WHEN cl_abap_typedescr=>kind_elem.
        lr_element ?= lr_typedescr.
        APPEND INITIAL LINE TO lt_components ASSIGNING FIELD-SYMBOL(<ls_component2>).
        <ls_component2>-name = 'LINE'.
        <ls_component2>-type = lr_element.
    ENDCASE.

    CLEAR lr_parser->gt_result_ddfields.

    ASSIGN et_dfies TO <et_dfies>.
    DO 2 TIMES.
      LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<ls_component>).
        CLEAR lsqlc_dfies.

        GET REFERENCE OF <ls_component>-type INTO DATA(ltest).

        CASE <ls_component>-type->kind.
          WHEN cl_abap_typedescr=>kind_struct.

            lr_strucdescr          ?= <ls_component>-type.
            lsqlc_dfies-stru_name  = lr_strucdescr->get_relative_name( ).
            lsqlc_dfies-fieldname  = <ls_component>-name.
            lsqlc_dfies-as_include = <ls_component>-as_include.

          WHEN cl_abap_typedescr=>kind_elem.

            lr_element                  ?= <ls_component>-type.
            lsqlc_dfies-fieldname       = <ls_component>-name.
            lsqlc_dfies-colhd_fieldname = <ls_component>-name.
            lsqlc_dfies-inttype         = lr_element->type_kind.
            lsqlc_dfies-decimals        = lr_element->decimals.
            lsqlc_dfies-outputlen       = lr_element->output_length.

            IF cl_abap_char_utilities=>charsize = 1.                                               "$002
              lsqlc_dfies-intlen    = lr_element->length.                                          "$002
            ELSE.                                                                                  "$002
              CASE lsqlc_dfies-inttype.
                WHEN 'P' OR 'I' OR 'X' OR 'F'.
                  lsqlc_dfies-intlen    = lr_element->length.
                WHEN OTHERS.
                  lsqlc_dfies-intlen    = lr_element->length / cl_abap_char_utilities=>charsize.   "$002
              ENDCASE.
            ENDIF.                                                                                 "$002
            lsqlc_dfies-leng            = lsqlc_dfies-intlen.

            IF lr_element->is_ddic_type( ) = abap_true.

              l_dfies = lr_element->get_ddic_field( ).

              lsqlc_dfies-scrtext_s   = l_dfies-scrtext_s.
              lsqlc_dfies-scrtext_m   = l_dfies-scrtext_m.
              lsqlc_dfies-scrtext_l   = l_dfies-scrtext_l.
              lsqlc_dfies-domname     = l_dfies-domname.
              lsqlc_dfies-rollname    = l_dfies-rollname.
              lsqlc_dfies-checktable  = l_dfies-checktable.
              lsqlc_dfies-precfield   = l_dfies-precfield.
              lsqlc_dfies-convexit    = l_dfies-convexit.
              lsqlc_dfies-fieldtext   = l_dfies-fieldtext.
              lsqlc_dfies-reptext     = l_dfies-reptext.
              lsqlc_dfies-f4availabl  = l_dfies-f4availabl.

            ENDIF.
        ENDCASE.

        APPEND lsqlc_dfies TO <et_dfies>.

      ENDLOOP.
      IF lr_strucdescr_main IS NOT BOUND.
        EXIT. "DO.
      ELSE.

        lt_incl_view = lr_strucdescr_main->get_included_view( ).
        MOVE-CORRESPONDING lt_incl_view TO lt_components.

        ASSIGN et_dfies_all TO <et_dfies>.
      ENDIF.
    ENDDO.

    ASSIGN lr_parser->result_table->* TO <lt_result_table>.
    CLEAR ic_data.

    EXPORT data = <lt_result_table> TO DATA BUFFER ic_data.

  ENDIF.

* MACRO END
ENDFORM.
