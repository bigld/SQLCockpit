CLASS /cadaxo/tc_sqlc_symbols DEFINITION DEFERRED.
CLASS /cadaxo/cl_sqlc_symbols DEFINITION LOCAL FRIENDS /cadaxo/tc_sqlc_symbols.

CLASS /cadaxo/tc_sqlc_symbols DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
    cut TYPE REF TO /cadaxo/cl_sqlc_symbols.

    METHODS: check_symbol_value_valid FOR TESTING.
    METHODS: check_symbol_value_unvalid FOR TESTING.
    METHODS: setup.
ENDCLASS.


CLASS /cadaxo/tc_sqlc_symbols IMPLEMENTATION.

  METHOD setup.


    cut = NEW #( i_user_settings = VALUE #( )
                 i_main          =  NEW #( ) ).
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
          cut->check_symbol_value_valid( ls_symbol_line ).

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
          cut->check_symbol_value_valid( ls_symbol_line ).

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
