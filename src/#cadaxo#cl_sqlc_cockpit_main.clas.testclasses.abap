CLASS /cadaxo/tc_sqlc_cockpit_main DEFINITION DEFERRED.
CLASS /cadaxo/cl_sqlc_cockpit_main DEFINITION LOCAL FRIENDS /cadaxo/tc_sqlc_cockpit_main.

CLASS /cadaxo/tc_sqlc_cockpit_main DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .
  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO /cadaxo/cl_sqlc_cockpit_main.

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: get_link FOR TESTING.
    METHODS:
      test_no_runtime_element FOR TESTING,
      test_one_runtime_element FOR TESTING,
      test_two_runtime_elements FOR TESTING.
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

  METHOD test_no_runtime_element.
    DATA xml TYPE string.
    xml = '<root><OTHER>abc</OTHER></root>'.

    f_cut->replace_old_runtime_structure( CHANGING xml = xml ).

    cl_abap_unit_assert=>assert_equals( exp = '<root><OTHER>abc</OTHER></root>'
                                        act = xml
                                        msg = 'XML stays same witout changes' ).
  ENDMETHOD.

  METHOD test_one_runtime_element.
    DATA xml TYPE string.
    xml = '<root><RUNTIME>123</RUNTIME></root>'.
    DATA(expected) = '<root><RUNTIME><RUNTIME>123</RUNTIME><UNIT>µs</UNIT></RUNTIME></root>'.

    f_cut->replace_old_runtime_structure( CHANGING xml = xml ).

    cl_abap_unit_assert=>assert_equals(
      act = xml
      exp = expected
      msg = '<RUNTIME> was replaced correctly'
    ).
  ENDMETHOD.

  METHOD test_two_runtime_elements.
    DATA xml TYPE string.
    xml = '<root><RUNTIME>111</RUNTIME><DATA>x</DATA><RUNTIME>222</RUNTIME></root>'.
    DATA(expected) = '<root><RUNTIME><RUNTIME>111</RUNTIME><UNIT>µs</UNIT></RUNTIME><DATA>x</DATA><RUNTIME><RUNTIME>222</RUNTIME><UNIT>µs</UNIT></RUNTIME></root>'.

    f_cut->replace_old_runtime_structure( CHANGING xml = xml ).

    cl_abap_unit_assert=>assert_equals(
      act = xml
      exp = expected
      msg = 'Both different <RUNTIME> were replaced correctly.'
    ).
  ENDMETHOD.


ENDCLASS.
