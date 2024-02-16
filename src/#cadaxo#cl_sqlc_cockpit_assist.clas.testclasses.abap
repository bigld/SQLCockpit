*"* use this source file for your ABAP unit test classes

CLASS /cadaxo/tc_sqlc_cockpit_assist DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>/cadaxo/tc_Sqlc_Cockpit_Assist
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>/CADAXO/CL_SQLC_COCKPIT_ASSIST
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE/>
*?<GENERATE_CLASS_FIXTURE/>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO /cadaxo/cl_sqlc_cockpit_assist.  "class under test

    METHODS: encloding_apostrophe_remove FOR TESTING.
    METHODS: encloding_apostrophe_set FOR TESTING.
    METHODS: replace_all_symbols_with_value FOR TESTING.
    METHODS: replace_apostrophes_with_space FOR TESTING.
    METHODS: replace_symbols_with_values FOR TESTING.
    METHODS: format_with_space FOR TESTING.
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

    DATA c_string TYPE string.

    /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space(
      CHANGING
        c_string = c_string ).

    cl_abap_unit_assert=>assert_equals(
      act   = c_string
      exp   = c_string          "<--- please adapt expected value
    " msg   = 'Testing value c_String'
*     level =
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

ENDCLASS.
