CLASS ltcl_ DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS detect_select_pattern FOR TESTING.
ENDCLASS.


CLASS ltcl_ IMPLEMENTATION.
  METHOD detect_select_pattern.
    TYPES: BEGIN OF lty_case,
             sql          TYPE string,
             exp_len      TYPE i,
             exp_distinct TYPE abap_bool,
             exp_single   TYPE abap_bool,
           END OF lty_case.

    DATA cases TYPE STANDARD TABLE OF lty_case WITH EMPTY KEY.

    DATA(tab) = cl_abap_char_utilities=>horizontal_tab.
    DATA(newline) = cl_abap_char_utilities=>newline.
    DATA(crlf) = cl_abap_char_utilities=>cr_lf.

    cases = VALUE #(
        ( sql = `SELECT * FROM but000`                                                exp_len = 7  exp_distinct = abap_false exp_single = abap_false )
        ( sql = `SELECT DISTINCT * FROM but000`                                       exp_len = 16 exp_distinct = abap_true  exp_single = abap_false )
        ( sql = ` SELECT SINGLE * FROM but000`                                        exp_len = 14 exp_distinct = abap_false exp_single = abap_true  )
        ( sql = `SELECT DISTINCT SINGLE * FROM but000`                                exp_len = 23 exp_distinct = abap_true  exp_single = abap_true  )
        ( sql = | SELECT    DISTINCT  * FROM but000 |                                 exp_len = 16 exp_distinct = abap_true  exp_single = abap_false )
        ( sql = |SELECT { tab } { tab } { tab }SINGLE  * FROM but000|                 exp_len = 19 exp_distinct = abap_false exp_single = abap_true  )
        ( sql = |SELECT { tab } { crlf } { tab }SINGLE  * FROM but000|                exp_len = 20 exp_distinct = abap_false exp_single = abap_true  )
        ( sql = |SELECT { newline }    { newline }    DISTINCT SINGLE * FROM but000|  exp_len = 27 exp_distinct = abap_true  exp_single = abap_true  ) ).

    LOOP AT cases INTO DATA(case).

      DATA(select_pattern) = /cadaxo/cl_sqlc_special_parse=>detect_select_pattern( case-sql ).

      cl_abap_unit_assert=>assert_true( act  = select_pattern-is_select
                                        msg  = |Expected SELECT detected for: { case-sql }|
                                        quit = if_abap_unit_constant=>quit-no ).

      cl_abap_unit_assert=>assert_equals( exp  = case-exp_len
                                          act  = select_pattern-match_length
                                          msg  = |Match length mismatch for: { case-sql }|
                                          quit = if_abap_unit_constant=>quit-no ).

      cl_abap_unit_assert=>assert_equals( exp  = case-exp_distinct
                                          act  = select_pattern-is_distinct
                                          msg  = |DISTINCT flag mismatch for: { case-sql }|
                                          quit = if_abap_unit_constant=>quit-no ).

      cl_abap_unit_assert=>assert_equals( exp  = case-exp_single
                                          act  = select_pattern-is_single
                                          msg  = |SINGLE flag mismatch for: { case-sql }|
                                          quit = if_abap_unit_constant=>quit-no ).

      cl_abap_unit_assert=>assert_equals( exp  = 0
                                          act  = select_pattern-match_offset
                                          msg  = |Wrong match offset for: { case-sql }|
                                          quit = if_abap_unit_constant=>quit-no ).

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
