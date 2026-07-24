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
      test_two_runtime_elements FOR TESTING,
      test_split_error_text FOR TESTING.
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


  METHOD test_split_error_text.
    TYPES: BEGIN OF test_error_s,
             error   TYPE /cadaxo/sqlcsyntaxerror,
             error_t TYPE /cadaxo/sqlcsyntaxerror_t,
             expect  TYPE /cadaxo/sqlcsyntaxerror_t,
           END OF test_error_s,
           test_errors_s TYPE STANDARD TABLE OF test_error_s WITH DEFAULT KEY.

    LOOP AT VALUE test_errors_s(
             (
               error   = VALUE #(
                     text = |space at pos 123: The quick brown fox jumps over the lazy dog while | &&
                            |a gentle breeze moves through the trees and carries the scent of | &&
                            |rain across the quiet valley near the riverbank.| )
               error_t = VALUE #( )
               expect  = VALUE #(
                   ( text = |space at pos 123: The quick brown fox jumps over the lazy dog while | &&
                            |a gentle breeze moves through the trees and carries the| )
                   ( text = |scent of rain across the quiet valley near the riverbank.| ) )
             )

             (
               error   = VALUE #(
                     text = |space at pos 123&249: A team of engineers reviewed the design | &&
                            |proposal and identified several opportunities for improvement | &&
                            |before presenting the updated plan to stakeholders during the | &&
                            |quarterly meeting, ensuring all requirements were addressed and | &&
                            |documented before final approval.| )
               error_t = VALUE #( )
               expect  = VALUE #(
                   ( text = |space at pos 123&249: A team of engineers reviewed the design | &&
                            |proposal and identified several opportunities for improvement| )
                   ( text = |before presenting the updated plan to stakeholders during the | &&
                            |quarterly meeting, ensuring all requirements were addressed and| )
                   ( text = |documented before final approval.| ) )
             )

             (
               error   = VALUE #(
                     text = |space at pos 127: Bright stars appeared above the horizon as | &&
                            |travelers continued their journey through the countryside, sharing | &&
                            |stories and observations while following the winding road toward | &&
                            |a distant town.| )
               error_t = VALUE #( )
               expect  = VALUE #(
                   ( text = |space at pos 127: Bright stars appeared above the horizon as | &&
                            |travelers continued their journey through the countryside, sharing| )
                   ( text = |stories and observations while following the winding road toward | &&
                            |a distant town.| ) )
             )

             (
               error   = VALUE #(
                     text = |noSpaceAtAllABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz| &&
                            |0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01| &&
                            |23456789ABCDE| )
               error_t = VALUE #( )
               expect  = VALUE #(
                   ( text = |noSpaceAtAllABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz| &&
                            |0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0| )
                   ( text = |123456789ABCDE| ) )
             )

           ) ASSIGNING FIELD-SYMBOL(<error>).

      f_cut->_split_error_text( EXPORTING is_error  = <error>-error
                                CHANGING  ct_errors = <error>-error_t ).

      cl_abap_unit_assert=>assert_equals(
         act   = <error>-error_t
         exp   = <error>-expect
         msg   = |Testing _split_error_text, errortext: { <error>-error-text }|
         quit  = if_aunit_constants=>quit-no ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
