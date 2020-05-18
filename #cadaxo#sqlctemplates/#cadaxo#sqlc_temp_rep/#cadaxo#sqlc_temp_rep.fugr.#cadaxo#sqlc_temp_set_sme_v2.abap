FUNCTION /cadaxo/sqlc_temp_set_sme_v2.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IR_PARSER) TYPE REF TO  /CADAXO/CL_SQLC_COCKPIT_PARSE
*"     REFERENCE(IWA_REPORT) TYPE  /CADAXO/SQLC_TEMP_REP_ATTR
*"     REFERENCE(IT_WHERE) TYPE  /CADAXO/SQLCWHERECOL_STR_T
*"----------------------------------------------------------------------
****************************************************************************************************
* Description             :                                                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Ana Lekic                Company    : CADAXO GesmbH                    *
* Date                    : 06.06.2016               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 24.04.2016 | Domi Bigl            | SQL @ im INI coding                         | COCKPIT-435    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
  DATA: lt_values             TYPE TABLE OF string.
  DATA: l_value               TYPE string.
  DATA: l_alias               TYPE string.
  DATA: l_into                TYPE string.
  DATA: l_upto_nowhere        TYPE string.
  DATA: lt_results            TYPE match_result_tab.
  DATA: l_offset              TYPE i.
  DATA: l_total               TYPE i.
  DATA: lwa_where_col         TYPE /cadaxo/sqlcwherecol_str.

  DATA lt_str TYPE TABLE OF string.
  DATA ls_str TYPE string.
  DATA l_space(200) TYPE c VALUE space.
  DATA l_hostparnam(31).

  FIELD-SYMBOLS: <lwa_result> LIKE LINE OF lt_results.
  FIELD-SYMBOLS: <l_string>   TYPE string.
  FIELD-SYMBOLS: <lwa_fcat>   TYPE lvc_s_fcat.
  FIELD-SYMBOLS: <lwa_src>    TYPE /cadaxo/sqlcselectsource.

  gs_report_attr = iwa_report.
  gsf_sql        = ir_parser->sql_syntax_without_where. "ir_parser->sql_syntax.

  gsf_where_wc   = ir_parser->where_syntax_wildcard.

  PERFORM clear_globals.

* CDX130-010 Begin
  IF gs_report_attr-authcheck IS NOT INITIAL.
    LOOP AT ir_parser->result_source_t ASSIGNING <lwa_src>.
      SELECT SINGLE cclass INTO gst_tabclasses_ac
             FROM tddat
             WHERE tabname = <lwa_src>-table.
      IF sy-subrc = 0.
        APPEND gst_tabclasses_ac.
      ENDIF.
* HF AUTH INSERT
      gst_auth_tabnames-tabname = <lwa_src>-table.
      APPEND gst_auth_tabnames TO gst_auth_tabnames.
* HF AUTH INSERT END
    ENDLOOP.
* HF AUTH INSERT
    SORT gst_tabclasses_ac.
    SORT gst_auth_tabnames.
    DELETE ADJACENT DUPLICATES FROM gst_auth_tabnames.
* HF AUTH INSERT END
    DELETE ADJACENT DUPLICATES FROM gst_tabclasses_ac.
  ENDIF.
* CDX130-010 End

  IF gs_report_attr-header_include IS NOT INITIAL.
    READ REPORT gs_report_attr-header_include INTO gst_header.
  ENDIF.

  LOOP AT it_where ASSIGNING <wa_where>.
    gss_where = CORRESPONDING #( <wa_where> ).
*COCKPIT-435 INSERT
    gss_where-value = shift_left( val = gss_where-value sub = '@' ).
*COCKPIT-435 INSERT
    gss_where-paramname = <wa_where>-wildcard_operator+2(3).
    APPEND gss_where TO gst_where.

    IF NOT gss_where-tablename IS INITIAL.
      gst_tabnames-tabname = gss_where-tablename.
      MODIFY TABLE gst_tabnames FROM gst_tabnames.
      IF sy-subrc <> 0.
        APPEND gss_where-tablename TO gst_tabnames.
      ENDIF.
    ENDIF.

    CASE gss_where-operator.
      WHEN 'IN'.
        REPLACE ')' IN gss_where-value WITH ' )'.
      WHEN 'BETWEEN'.
    ENDCASE.

    IF    NOT <wa_where>-wildcard_operator IS INITIAL
      AND NOT <wa_where>-wildcard_condition IS INITIAL.
      IF gss_where-generate_option <> '03'.
        REPLACE ALL OCCURRENCES OF   gss_where-wildcard_operator
                                IN   gsf_where_wc
                                WITH 'IN'.
        CONCATENATE 'P_' gss_where-paramname INTO gss_where-paramname.
        CONCATENATE '@' gss_where-paramname INTO l_hostparnam.
        REPLACE ALL OCCURRENCES OF   gss_where-wildcard_condition
                                IN   gsf_where_wc
                                WITH l_hostparnam. "gss_where-paramname.
      ELSE.
        IF gss_where-operator = 'EQ'."+cockpit384
          REPLACE ALL OCCURRENCES OF   gss_where-wildcard_operator
                            IN   gsf_where_wc
                            WITH gss_where-operator.
          REPLACE ALL OCCURRENCES OF   gss_where-wildcard_condition
                                  IN   gsf_where_wc
                                  WITH gss_where-value.
*         begin of +cockpit384
*        WIP
        ELSE.
          DATA lt_selopt2 TYPE rseloption.
          SHIFT gss_where-value RIGHT DELETING TRAILING'& '.
          SHIFT gss_where-value LEFT DELETING LEADING ' &'.
          REPLACE ALL OCCURRENCES OF   gss_where-wildcard_operator
                            IN   gsf_where_wc
                            WITH gss_where-operator.
          REPLACE ALL OCCURRENCES OF   gss_where-wildcard_condition
                                  IN   gsf_where_wc
                                  WITH |@{ gss_where-value }|.
          SELECT SINGLE symbol_multivalue FROM /cadaxo/sqlcusym
            INTO @DATA(l_symbol_multival)
            WHERE username    = @sy-uname
              AND symbol_name = @gss_where-value.
          /cadaxo/cl_sqlc_cockpit_assist=>decompress_symbol_multivalue(
            EXPORTING
              i_symbol_multivalue =   l_symbol_multival
            IMPORTING
              e_symbol_multivalue =   lt_selopt2
          ).
          LOOP AT lt_selopt2 INTO DATA(ls_selopt2).
            gss_where-paramname = gss_where-value.
            gss_where-value = |'{ ls_selopt2-low }'|.
            gss_where-highvalue = |'{ ls_selopt2-high }'|.
            gss_where-operator = ls_selopt2-option.
            APPEND gss_where TO gst_init.
          ENDLOOP.
        ENDIF.
*         end   of +cockpit384
      ENDIF.
    ENDIF.

    IF gss_where-generate_option = '01'.
      CASE gss_where-operator.
        WHEN 'IN'.
          IF gss_where-operator_pre = 'NOT'.
            gss_where-operator = 'NE'.
          ELSE.
            gss_where-operator = 'EQ'.
          ENDIF.
          SHIFT gss_where-value RIGHT DELETING TRAILING ') '.
          SHIFT gss_where-value LEFT DELETING LEADING ' ('.
* begin of comment -cockpit384
*         SPLIT gss_where-value AT ',' INTO TABLE lt_values.
*          LOOP AT lt_values ASSIGNING <l_string>.
*            gss_where-value = <l_string>.
*            APPEND gss_where TO gst_init.
*          ENDLOOP.
* end of comment -cockpit384
*         begin of +cockpit384
          DATA lt_selopt TYPE rseloption.
          SHIFT gss_where-value RIGHT DELETING TRAILING'& '.
          SHIFT gss_where-value LEFT DELETING LEADING ' &'.
          SELECT SINGLE symbol_multivalue FROM /cadaxo/sqlcusym
            INTO @DATA(l_symbol_multival2)
            WHERE username    = @sy-uname
              AND symbol_name = @gss_where-value.
          /cadaxo/cl_sqlc_cockpit_assist=>decompress_symbol_multivalue(
            EXPORTING
              i_symbol_multivalue =   l_symbol_multival2
            IMPORTING
              e_symbol_multivalue =   lt_selopt
          ).
          LOOP AT lt_selopt INTO DATA(ls_selopt).
            gss_where-value = |'{ ls_selopt-low }'|.
            gss_where-highvalue = |'{ ls_selopt-high }'|.
            gss_where-operator = ls_selopt-option.
            APPEND gss_where TO gst_init.
          ENDLOOP.
*         end   of +cockpit384
        WHEN 'BETWEEN'.
          IF gss_where-operator_pre = 'NOT'.
            gss_where-operator = 'NB'.
          ELSE.
            gss_where-operator = 'BT'.
          ENDIF.
          SPLIT gss_where-value AT ' AND ' INTO gss_where-value gss_where-highvalue.
*COCKPIT-435 INSERT
    gss_where-highvalue = shift_left( val = gss_where-highvalue sub = '@' ).
*COCKPIT-435 INSERT
          APPEND gss_where TO gst_init.
        WHEN 'LIKE'.                                                             "CDX001-0029
          l_value = gss_where-value.                                             "CDX001-0029
          TRANSLATE gss_where-value USING '%*_+'.                                "CDX001-0029
          IF l_value <> gss_where-value.                                         "CDX001-0029
            IF gss_where-operator_pre = 'NOT'.                                   "CDX001-0029
              gss_where-operator = 'NP'.                                         "CDX001-0029
            ELSE.                                                                "CDX001-0029
              gss_where-operator = 'CP'.                                         "CDX001-0029
            ENDIF.                                                               "CDX001-0029
          ELSE.                                                                  "CDX001-0029
            IF gss_where-operator_pre = 'NOT'.                                   "CDX001-0029
              gss_where-operator = 'NE'.                                         "CDX001-0029
            ELSE.                                                                "CDX001-0029
              gss_where-operator = 'EQ'.                                         "CDX001-0029
            ENDIF.                                                               "CDX001-0029
          ENDIF.                                                                 "CDX001-0029
          APPEND gss_where TO gst_init.                                          "CDX001-0029
        WHEN OTHERS.
          APPEND gss_where TO gst_init.
      ENDCASE.
    ENDIF.
  ENDLOOP.

  IF ir_parser->g_select_single = abap_true.
    DELETE gst_where WHERE paramname = 'UPT'.
  ENDIF.

* HF AUTH INSERT
  CLEAR gst_auth_tabnames.
  SPLIT ir_parser->source_syntax AT space INTO gst_auth_tabnames l_alias.
  MODIFY TABLE gst_auth_tabnames FROM gst_auth_tabnames.
  IF sy-subrc <> 0.
    APPEND gst_auth_tabnames TO gst_auth_tabnames.
  ENDIF.
* HF AUTH INSERT END
  IF NOT gsf_where_wc IS INITIAL.
    CONCATENATE gsf_where_wc space INTO gsf_where_wc RESPECTING BLANKS.
  ENDIF.


  REPLACE FIRST OCCURRENCE OF   '<WHEREPARAM>'
                           IN   gsf_sql
                           WITH gsf_where_wc.


  IF ir_parser->column_syntax EQ 'COUNT( * )' OR
     ir_parser->column_syntax EQ 'COUNT(*)'.
    CONCATENATE ir_parser->column_syntax ' AS /CADAXO/SQLCAGGRCOUNT' INTO l_value.
    REPLACE FIRST OCCURRENCE OF 'COUNT( * )' IN gsf_sql WITH l_value.
    IF sy-subrc <> 0.
      REPLACE FIRST OCCURRENCE OF 'COUNT(*)' IN gsf_sql WITH l_value.
    ENDIF.
    l_into = ' CORRESPONDING FIELDS OF <gwa_table>'.
  ELSE.
    IF ir_parser->g_select_single IS INITIAL.
      l_into = ' TABLE @DATA(TAB_RESULT)'.
      l_upto_nowhere = ' UP TO @P_UPT ROWS INTO'.
    ELSE.
      l_into = ' @DATA(tab_line)'. "l_into = ' <gwa_table>'.
      l_upto_nowhere = ' INTO'.
      g_select_single = abap_true.
    ENDIF.
  ENDIF.

  IF NOT ir_parser->g_up_to_x_rows IS INITIAL.
    l_value = ir_parser->g_up_to_x_rows.
    CONCATENATE 'UP TO' l_value 'ROWS' INTO l_value SEPARATED BY space.
    CONDENSE l_value.
    REPLACE FIRST OCCURRENCE OF   l_value
                             IN   gsf_sql
                             WITH space.
  ENDIF.
*  CASE ir_parser->g_select_version.                                                   "COCKPIT-46
*    WHEN ir_parser->c_select_version_0 OR ir_parser->c_select_version_1.              "COCKPIT-46
*      IF ir_parser->g_select_single IS INITIAL.                                       "COCKPIT-46
*        CONCATENATE 'UP TO @P_UPT ROWS INTO' l_into 'WHERE' INTO l_value SEPARATED BY space. "COCKPIT-46
*      ELSE.                                                                           "COCKPIT-46
*        CONCATENATE 'INTO' l_into 'WHERE' INTO l_value SEPARATED BY space.            "COCKPIT-46
*      ENDIF.
*      REPLACE FIRST OCCURRENCE OF   'WHERE'                                            "COCKPIT-46
*                               IN   gsf_sql                                            "COCKPIT-46
*                               WITH l_value.                                           "COCKPIT-46
*    WHEN ir_parser->c_select_version_2.                                                "COCKPIT-46
  IF ir_parser->g_select_single IS INITIAL.                                        "COCKPIT-46
    CONCATENATE 'INTO' l_into 'UP TO @P_UPT ROWS' INTO l_value SEPARATED BY space. "COCKPIT-46
  ELSE.                                                                            "COCKPIT-46
    CONCATENATE 'INTO' l_into INTO l_value SEPARATED BY space.                     "COCKPIT-46
  ENDIF.                                                                           "COCKPIT-46
  gsf_sql = gsf_sql && ` ` && l_value.                                             "COCKPIT-46
*  ENDCASE.

  IF sy-subrc <> 0.
    REPLACE FIRST OCCURRENCE OF   'GROUP BY'
                             IN   gsf_sql
                             WITH 'UP TO @P_UPT ROWS INTO TABLE @DATA(TAB_RESULT) GROUP BY'.
    IF sy-subrc <> 0.
      REPLACE FIRST OCCURRENCE OF   'HAVING'                                             "22-012
                               IN   gsf_sql                                              "22-012
                               WITH 'UP TO @P_UPT ROWS INTO TABLE @DATA(TAB_RESULT) HAVING'.     "22-012
      IF sy-subrc <> 0.                                                                  "22-012
        REPLACE FIRST OCCURRENCE OF   'ORDER BY'                                         "22-012
                                 IN   gsf_sql                                            "22-012
                                 WITH 'UP TO @P_UPT ROWS INTO TABLE @DATA(TAB_RESULT) ORDER BY'. "22-012
      ENDIF.                                                                             "22-012
    ENDIF.                                                                               "22-012
    IF sy-subrc <> 0.                                                                    "22-012
      SHIFT gsf_sql RIGHT DELETING TRAILING '.'.
      CONCATENATE gsf_sql l_upto_nowhere l_into INTO gsf_sql.
    ENDIF.
  ENDIF.

***  IF ir_parser->column_syntax EQ '*'.
***    SPLIT ir_parser->source_syntax AT space INTO gs_use_table l_alias.
***  ELSE.
  CLEAR gs_use_table.

  gst_fcat[]     = ir_parser->gt_lvc_t_fcat.
  LOOP AT gst_fcat ASSIGNING <lwa_fcat> WHERE ref_table = '/CADAXO/SQLCAGGRCOUNT'.
    CLEAR <lwa_fcat>-ref_table.
  ENDLOOP.
  CLEAR gss_fcat.
  IF lines( gst_fcat ) = 1.
    gss_fcat = gst_fcat[ 1 ].
  ENDIF.
***  ENDIF.
**
**** Format SQL statement "CDX130-022 Begin

  CLEAR gst_sql[].
  /cadaxo/cl_sqlc_cockpit_assist=>condense( CHANGING c_string = gsf_sql ).

  lt_str = /cadaxo/cl_sqlc_cockpit_assist=>split( EXPORTING i_sql_string = gsf_sql ).

*   Keywords select
  IF gst_keyw IS INITIAL.
    APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
    <wa_keyw>-keyw = 'FROM'.
    <wa_keyw>-line_feed = abap_true.
    <wa_keyw>-spaces = '7'.
    APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
    <wa_keyw>-keyw = 'WHERE'.
    <wa_keyw>-line_feed = abap_true.
    <wa_keyw>-spaces = '7'.
    APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
    <wa_keyw>-keyw = 'INTO'.
    <wa_keyw>-line_feed = abap_true.
    <wa_keyw>-spaces = '7'.
    APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
    <wa_keyw>-keyw = 'GROUP'.
    <wa_keyw>-line_feed = abap_true.
    <wa_keyw>-spaces = '7'.
    APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
    <wa_keyw>-keyw = 'CASE'.
    <wa_keyw>-line_feed = abap_true.
    <wa_keyw>-spaces = '7'.
    APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
    <wa_keyw>-keyw = 'COALESCE('.
    <wa_keyw>-line_feed = abap_true.
    <wa_keyw>-spaces = '7'.
  ENDIF.

  CLEAR gsf_sql.
  LOOP AT lt_str INTO ls_str.
    READ TABLE gst_keyw ASSIGNING <wa_keyw> WITH KEY keyw = ls_str
                                                     line_feed = abap_true.
    IF sy-subrc = 0.
      MOVE gsf_sql TO gst_sql-line.
      APPEND gst_sql.
      CLEAR gsf_sql.
      CONCATENATE l_space(<wa_keyw>-spaces) ls_str INTO ls_str RESPECTING BLANKS.
    ENDIF.
    CONCATENATE gsf_sql ls_str INTO gsf_sql SEPARATED BY space.
  ENDLOOP.
  IF gsf_sql IS NOT INITIAL.
    MOVE gsf_sql TO gst_sql-line.
    APPEND gst_sql.
  ENDIF.
*** "CDX130-022 End
ENDFUNCTION.
