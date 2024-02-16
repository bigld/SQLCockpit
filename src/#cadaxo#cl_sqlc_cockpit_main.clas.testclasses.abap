CLASS /cadaxo/tc_sqlc_cockpit_main DEFINITION DEFERRED.
CLASS /cadaxo/cl_sqlc_cockpit_main DEFINITION LOCAL FRIENDS /cadaxo/tc_sqlc_cockpit_main.

CLASS /cadaxo/tc_sqlc_cockpit_main DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>/cadaxo/tc_Sqlc_Cockpit_Main
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>/CADAXO/CL_SQLC_COCKPIT_MAIN
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE>X
*?</GENERATE_CLASS_FIXTURE>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO /cadaxo/cl_sqlc_cockpit_main.  "class under test

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: get_link FOR TESTING.
    METHODS: check_symbol_value_valid FOR TESTING.
    METHODS: check_symbol_value_unvalid FOR TESTING.
ENDCLASS.       "/cadaxo/tc_Sqlc_Cockpit_Main


CLASS /cadaxo/tc_sqlc_cockpit_main IMPLEMENTATION.

  METHOD class_setup.



  ENDMETHOD.


  METHOD class_teardown.



  ENDMETHOD.


  METHOD setup.


    CREATE OBJECT f_cut.
  ENDMETHOD.


  METHOD teardown.



  ENDMETHOD.


  METHOD get_link.

    DATA i_html_id TYPE /cadaxo/sqlcparameter_id VALUE 'HTML_STARTUP'.
    DATA e_url TYPE c.
    DATA ct_cache TYPE /cadaxo/cl_sqlc_cockpit_main=>gtt_char255.

    f_cut->get_link(
      EXPORTING
        i_html_id = i_html_id
      IMPORTING
        e_url = e_url
      CHANGING
        ct_cache = ct_cache ).

    cl_abap_unit_assert=>assert_equals(
      act   = e_url
      exp   = 'h'          "<--- please adapt expected value
      msg   = 'Testing value e_Url'
*     level =
    ).

  ENDMETHOD.

  METHOD check_symbol_value_valid.

    TYPES: lty_t_string TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    DATA ls_symbol_line TYPE /cadaxo/sqlc_symbol.

    LOOP AT VALUE lty_t_string( ( `'irgendeinstring'` )                                       "normaler String
                                ( `partner as FELD1, name_first as FELD2` )                   "Feldliste getrennt mit Beistrich
                                ( `COUNT( * )` ) ( `MAX( value )` ) ( `AVG( value )` )        "Aggregat funktionen #1
                                ( `MIN( value )` ) ( `SUM( value )` )                         "Aggregat funktionen #2
                                ( `UPDATE~partner` )                                          "Feld mit bösem Alias
                                ( `a~partner` )                                               "Feld mit normalem Alias
                                ( `@partner` )                                                "Feld escape
                                ( `partner` )                                                 "normaler Feldname
                                ( `DISTINCT partner` )                                        "DISTINCT
                                ( `'FOR ALL ENTRIES IN'` )                                    "FOR ALL ENTRIES als String
                                ( `FOR` ) ( `ALL` ) ( `ENTRIES` ) ( `IN` )                    "FOR ALL ENTRIES zerlegt
                                ( `FROM` ) ( `SELECT` ) ( `WHERE` ) ( `HAVING` )              "Diverse Schlüsselwörter
                                ( `INTO` ) ( `INNER` ) ( `JOIN` ) ( `OUTER` )                 "Diverse Schlüsselwörter
                                ( `LEFT` ) ( `RIGHT` ) ( `FETCH` ) ( `WITH` )                 "Diverse Schlüsselwörter
                                ( `CORRESPONDING` ) ( `TABLE` ) ( `EXISTS` )                  "Diverse Schlüsselwörter
                                ( `ORDER` ) ( `GROUP` ) ( `BY` ) ( `AS` )                     "Diverse Schlüsselwörter
                                ( `*` ) ( `(` ) ( `)` ) ( ` ` ) ( `-` ) ( `_` ) ( `~` )       "Diverse Symbole
                                ( `&&` ) ( `[` ) ( `]` )                                      "Diverse Symbole
                                ( `CASE` ) ( `WHEN` ) ( `TYPE` ) ( `THEN` ) ( `ELSE` )        "Erweiterte SQL
                                ( `UNION ALL` ) ( `COALESCE` ) ( `CEIL` ) ( `FLOOR`)          "Erweiterte SQL
                                ( `CAST` ) ( `AND` ) ( `CONCAT` ) ( `LPAD` )                  "Erweiterte SQL
                                ( `INSERT` ) ( `UPDATE` ) ( `MODIFY` ) ( `DELETE` )           "Ganz böses zeug, aber für Symbole ok
                                ( `TRUNCATE` ) ( `DROP` )                                     "Ganz böses zeug, aber für Symbole ok

                              ) ASSIGNING FIELD-SYMBOL(<lv_fieldlist>).
      ls_symbol_line-symbol_value = <lv_fieldlist>.

      TRY.
          f_cut->check_symbol_value_valid( ls_symbol_line ).

        CATCH /cadaxo/cx_sqlc_invalid_value.

          cl_abap_unit_assert=>fail(
            EXPORTING
              msg    = 'Symbol Value Should be OK!'
              quit   =   if_aunit_constants=>no
              detail = ls_symbol_line-symbol_value ).

      ENDTRY.
    ENDLOOP.

  ENDMETHOD.

  METHOD check_symbol_value_unvalid.

    TYPES: lty_t_string TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    DATA ls_symbol_line TYPE /cadaxo/sqlc_symbol.
    DATA lv_error TYPE boolean.

    LOOP AT VALUE lty_t_string( ( `'0000000101'.SELECT * FROM BUT000` )                       "Literal geschlossen, anschließendes SELECT
                                ( `'0000000101' OR partner <> 1` )                            "Literal geschlossen mit folgendem aushebeln
                                ( `0000000101' OR partner <> 1` )                             "offenes Literal
                                ( `INNER JOIN but050 as b ON a~partner = b~partner` )         "INNER JOIN liest zusätzliche Daten die möglicherweise unberechtigt sind
                                ( `OUTER JOIN but050 as b ON a~partner = b~partner` )         "OUTER JOIN liest ebenfalls Daten dazu
                                ( `LEFT JOIN but050 as b ON a~partner = b~partner` )          "LEFT JOIN auch
                                ( `LEFT OUTER JOIN but050 as b ON a~partner = b~partner` )    "LEFT OUTER JOIN auch
                                ( `RIGHT JOIN but050 as b ON a~partner = b~partner` )         "RIGHT JOIN auch
                                ( `RIGHT OUTER JOIN but050 as b ON a~partner = b~partner` )   "RIGHT OUTER JOIN auch
                                ( `UNION SELECT * from but050` )                              "UNION auch
                                ( `'irgendeinstring'.'SELECT * FROM BUT000'` )                "2 normale Strings getrennt mit Punkt

                              ) ASSIGNING FIELD-SYMBOL(<lv_fieldlist>).
      ls_symbol_line-symbol_value = <lv_fieldlist>.

      TRY.
          f_cut->check_symbol_value_valid( ls_symbol_line ).

          cl_abap_unit_assert=>fail(
            EXPORTING
              msg    = 'Symbol Value Should NOT be ok!'
              quit   =   if_aunit_constants=>no
              detail = ls_symbol_line-symbol_value ).

        CATCH /cadaxo/cx_sqlc_invalid_value.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
