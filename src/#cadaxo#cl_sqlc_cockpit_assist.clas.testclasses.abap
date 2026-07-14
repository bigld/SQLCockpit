CLASS /cadaxo/tc_sqlc_cockpit_assist DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.

  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO /cadaxo/cl_sqlc_cockpit_assist.  "class under test

    METHODS: encloding_apostrophe_remove FOR TESTING.
    METHODS: encloding_apostrophe_set FOR TESTING.
    METHODS: replace_all_symbols_with_value FOR TESTING.
    METHODS: replace_apostrophes_with_space FOR TESTING.
    METHODS: replace_symbols_with_values FOR TESTING.
    METHODS: format_with_space FOR TESTING.
    METHODS: condense FOR TESTING.
ENDCLASS.       "/cadaxo/tc_Sqlc_Cockpit_Assist


CLASS /cadaxo/tc_sqlc_cockpit_assist IMPLEMENTATION.

  METHOD encloding_apostrophe_remove.

    TYPES: BEGIN OF lty_s_check_values,
             value           TYPE string,
             expect          TYPE string,
             apostrophe_char TYPE char1,
           END OF lty_s_check_values,
           lty_t_check_values TYPE STANDARD TABLE OF lty_s_check_values WITH DEFAULT KEY.

    DATA lv_apostrophe_char TYPE char1.

    LOOP AT VALUE lty_t_check_values( ( value = |'demo'| expect = |demo| apostrophe_char = |'| )
                                      ( value = |'demo| expect = |'demo| apostrophe_char = || )
                                      ( value = |demo'| expect = |demo'| apostrophe_char = || )
                                      ( value = |`demo`| expect = |demo| apostrophe_char = |`| )
                                      ( value = |`demo| expect = |`demo| apostrophe_char = || )
                                    ) ASSIGNING FIELD-SYMBOL(<ls_checks>).

      cl_abap_unit_assert=>assert_equals(
        act   = /cadaxo/cl_sqlc_cockpit_assist=>encloding_apostrophe_remove( CHANGING ev_symbol_value = <ls_checks>-value )
        exp   = <ls_checks>-apostrophe_char
        quit  = if_aunit_constants=>no ).
      cl_abap_unit_assert=>assert_equals(
        act   = <ls_checks>-value
        exp   = <ls_checks>-expect
        quit  = if_aunit_constants=>no ).

    ENDLOOP.

  ENDMETHOD.


  METHOD encloding_apostrophe_set.

    TYPES: BEGIN OF lty_s_check_values,
             value           TYPE string,
             expect          TYPE string,
             apostrophe_char TYPE char1,
           END OF lty_s_check_values,
           lty_t_check_values TYPE STANDARD TABLE OF lty_s_check_values WITH DEFAULT KEY.

    DATA lv_apostrophe_char TYPE char1.

    LOOP AT VALUE lty_t_check_values( ( value = |'demo'| expect = |`demo`| apostrophe_char = |`| )
                                      ( value = |'demo| expect = |`'demo`| apostrophe_char = |`| )
                                      ( value = |`demo`| expect = |'demo'| apostrophe_char = |'| )
                                    ) ASSIGNING FIELD-SYMBOL(<ls_checks>).

      /cadaxo/cl_sqlc_cockpit_assist=>encloding_apostrophe_set( EXPORTING iv_apostrophe_char = <ls_checks>-apostrophe_char CHANGING ev_symbol_value = <ls_checks>-value ).

      cl_abap_unit_assert=>assert_equals(
        act   = <ls_checks>-value
        exp   = <ls_checks>-expect
        quit  = if_aunit_constants=>no  ).

    ENDLOOP.
  ENDMETHOD.


  METHOD replace_all_symbols_with_value.

    DATA c_string TYPE string.

    /cadaxo/cl_sqlc_cockpit_assist=>replace_all_symbols_with_value(
      CHANGING
        c_string = c_string ).

    cl_abap_unit_assert=>assert_equals(
      act   = c_string
      exp   = c_string          "<--- please adapt expected value
    " msg   = 'Testing value c_String'
*     level =
    ).
  ENDMETHOD.


  METHOD replace_apostrophes_with_space.

   data(given_sql) = |SELECT  FROM      BUT000| && cl_abap_char_utilities=>cr_lf  && | FIELSD PARTNER WHERE PARTNER = '12345    | && cl_abap_char_utilities=>cr_lf && |'|.
    data(actual_sql) = given_sql.

    /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = actual_sql ).

   DATA(expected_sql) = |SELECT  FROM      BUT000| && cl_abap_char_utilities=>cr_lf  && | FIELSD PARTNER WHERE PARTNER = '           '|.

    cl_abap_unit_assert=>assert_equals(
      act   = actual_sql
      exp   = expected_sql
      quit  = 0
    ).
  ENDMETHOD.



  METHOD replace_symbols_with_values.

    DATA i_where_column TYPE /cadaxo/sqlcwherecol_str.
    DATA i_from TYPE i.
    DATA i_length TYPE i.
    DATA c_where_syntax TYPE /cadaxo/sqlcselectwheresyntax.
    DATA c_offset TYPE i.
    DATA c_total TYPE i.

    /cadaxo/cl_sqlc_cockpit_assist=>replace_symbols_with_values(
      EXPORTING
        i_where_column = i_where_column
        i_from = i_from
*       I_LENGTH = i_Length
      CHANGING
        c_where_syntax = c_where_syntax
        c_offset = c_offset
        c_total = c_total ).

    cl_abap_unit_assert=>assert_equals(
      act   = c_where_syntax
      exp   = c_where_syntax          "<--- please adapt expected value
    " msg   = 'Testing value c_Where_Syntax'
*     level =
    ).
    cl_abap_unit_assert=>assert_equals(
      act   = c_offset
      exp   = c_offset          "<--- please adapt expected value
    " msg   = 'Testing value c_Offset'
*     level =
    ).
    cl_abap_unit_assert=>assert_equals(
      act   = c_total
      exp   = c_total          "<--- please adapt expected value
    " msg   = 'Testing value c_Total'
*     level =
    ).
  ENDMETHOD.

  METHOD format_with_space.

    TYPES: BEGIN OF tys_teststring,
             input  TYPE string,
             result TYPE string,
           END OF tys_teststring,
           tyt_teststring TYPE STANDARD TABLE OF tys_teststring WITH DEFAULT KEY.

    FIELD-SYMBOLS <ls_teststring> TYPE tys_teststring.

    DATA(lt_teststring) = VALUE tyt_teststring( ( input = |'sdf`d,o`', 'd'| result = |'sdf`d,o`', 'd'| )
                                                ( input = `'sdf'',sdf'` result = |'sdf'',sdf'| )
                                                ( input = `'sdf'',sdf')` result = |'sdf'',sdf')| )
                                                ( input = `'sdf'',)sdf'` result = |'sdf'',)sdf'| )
                                                ( input = `'sdf'')sdf'` result = |'sdf'')sdf'| )
                                                ( input = `'sdf'')sdf','d'` result = |'sdf'')sdf', 'd'| )
                                                ( input = |'sdf`)sdf','d'| result = |'sdf`)sdf', 'd'| )
                                                ( input = |'sdf``)sdf','d'| result = |'sdf``)sdf', 'd'| )
                                                ( input = |'sdf', 'd'| result = |'sdf', 'd'| )
                                                 ).

    APPEND INITIAL LINE TO lt_teststring ASSIGNING <ls_teststring>.
    <ls_teststring>-input = |('sdfsdf')|.
    <ls_teststring>-result = |( 'sdfsdf')|.
    APPEND INITIAL LINE TO lt_teststring ASSIGNING <ls_teststring>.
    <ls_teststring>-input = |('sdfsdf','jklö')|.
    <ls_teststring>-result = |( 'sdfsdf', 'jklö')|.
    APPEND INITIAL LINE TO lt_teststring ASSIGNING <ls_teststring>.
    <ls_teststring>-input = |'as','bc'|.
    <ls_teststring>-result = |'as', 'bc'|.
    APPEND INITIAL LINE TO lt_teststring ASSIGNING <ls_teststring>.
    <ls_teststring>-input = |`'sad','d'`|.
    <ls_teststring>-result = |`'sad','d'`|.

    LOOP AT lt_teststring ASSIGNING <ls_teststring>.

      DATA(lv_res) = /cadaxo/cl_sqlc_cockpit_assist=>format_with_space( <ls_teststring>-input ).

      cl_abap_unit_assert=>assert_equals(
        act   = lv_res
        exp   = <ls_teststring>-result
        quit  = 0 ).

    ENDLOOP.

  ENDMETHOD.

  METHOD condense.
    data(given_sql) = |SELECT  FROM      BUT000| && cl_abap_char_utilities=>cr_lf  && | FIELSD PARTNER WHERE PARTNER = '12345    | && cl_abap_char_utilities=>cr_lf && |'|.
    data(actual_sql) = given_sql.
    /cadaxo/cl_sqlc_cockpit_assist=>condense( changing c_string = actual_sql ).

    DATA(expected_sql) = |SELECT FROM BUT000| && cl_abap_char_utilities=>cr_lf  && | FIELSD PARTNER WHERE PARTNER = '12345    | && cl_abap_char_utilities=>cr_lf && |'|.
    cl_abap_unit_assert=>assert_equals(
      act  = actual_sql
      exp  = expected_sql
      quit = 0 ).

  ENDMETHOD.

ENDCLASS.

CLASS /CADAXO/tc_split_text_in_lines DEFINITION
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS:
      text_shorter_than_limit FOR TESTING,
      text_exactly_at_limit FOR TESTING,
      split_at_space FOR TESTING,
      split_without_space FOR TESTING,
      multiple_recursive_splits FOR TESTING,
      no_leading_space_in_fllwng_lin FOR TESTING.

ENDCLASS.


CLASS /CADAXO/tc_split_text_in_lines IMPLEMENTATION.

  METHOD text_shorter_than_limit.

    DATA(lt_result) =
      /CADAXO/CL_SQLC_COCKPIT_ASSIST=>split_text_into_lines(
        iv_text        = 'Hello'
        iv_line_length = 10 ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_result )
      exp = 1 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 1 ]
      exp = 'Hello' ).

  ENDMETHOD.


  METHOD text_exactly_at_limit.

    DATA(lt_result) =
      /CADAXO/CL_SQLC_COCKPIT_ASSIST=>split_text_into_lines(
        iv_text        = '12345'
        iv_line_length = 5 ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_result )
      exp = 1 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 1 ]
      exp = '12345' ).

  ENDMETHOD.


  METHOD split_at_space.

    DATA(lt_result) =
      /CADAXO/CL_SQLC_COCKPIT_ASSIST=>split_text_into_lines(
        iv_text        = 'Hello World'
        iv_line_length = 5 ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_result )
      exp = 2 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 1 ]
      exp = 'Hello' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 2 ]
      exp = 'World' ).

  ENDMETHOD.


  METHOD split_without_space.

    DATA(lt_result) =
      /CADAXO/CL_SQLC_COCKPIT_ASSIST=>split_text_into_lines(
        iv_text        = 'ABCDEFGHIJK'
        iv_line_length = 5 ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_result )
      exp = 3 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 1 ]
      exp = 'ABCDE' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 2 ]
      exp = 'FGHIJ' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 3 ]
      exp = 'K' ).

  ENDMETHOD.


  METHOD multiple_recursive_splits.

    DATA(lt_result) =
      /CADAXO/CL_SQLC_COCKPIT_ASSIST=>split_text_into_lines(
        iv_text        = 'One Two Three Four Five'
        iv_line_length = 8 ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_result )
      exp = 4 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 1 ]
      exp = 'One Two' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 2 ]
      exp = 'Three' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 3 ]
      exp = 'Four' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 4 ]
      exp = 'Five' ).

  ENDMETHOD.


  METHOD no_leading_space_in_fllwng_lin.

    DATA(lt_result) =
      /CADAXO/CL_SQLC_COCKPIT_ASSIST=>split_text_into_lines(
        iv_text        = 'ABC DEF'
        iv_line_length = 3 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 1 ]
      exp = 'ABC' ).

    cl_abap_unit_assert=>assert_not_initial(
      act = lt_result[ 2 ] ).

    cl_abap_unit_assert=>assert_differs(
      act = lt_result[ 2 ]
      exp = ' DEF' ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_result[ 2 ]
      exp = 'DEF' ).

  ENDMETHOD.

ENDCLASS.
