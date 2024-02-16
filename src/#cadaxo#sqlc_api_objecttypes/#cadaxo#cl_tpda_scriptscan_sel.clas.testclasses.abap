* ----------------------------------------------------------------------
CLASS lcl_test_script_scan_sql_sel DEFINITION FOR TESTING  DURATION MEDIUM
  RISK LEVEL HARMLESS
.
*?#<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>Lcl_Test_Script_Scan_Sql_Sel
*?</TEST_CLASS>
*?<OBJECT_UNDER_TEST>CL_TPDA_SCRIPT_SCAN_SQL_SEL
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
* ----------------------------------------------------------------------

  PRIVATE SECTION.
* ================
    CONSTANTS c_program TYPE sy-repid VALUE 'RSTPDA_SCRIPT_SCAN_TEST'.
    DATA:
      m_ref TYPE REF TO cl_tpda_script_scan_sql_sel.

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: db_tables FOR TESTING RAISING cx_tpda_script_scan ,
             for_all_entries_table FOR TESTING RAISING cx_tpda_script_scan ,
             join                  FOR TESTING RAISING cx_tpda_script_scan,
             single                FOR TESTING RAISING cx_tpda_script_scan.
ENDCLASS.       "Lcl_Test_Script_Scan_Sql_Sel
* ----------------------------------------------------------------------
CLASS lcl_test_script_scan_sql_sel IMPLEMENTATION.
* ----------------------------------------------------------------------

* ----------------------------------------------------------------------
  METHOD class_setup.
* ----------------------------------------------------------------------


  ENDMETHOD.       "Class_Setup

* ----------------------------------------------------------------------
  METHOD class_teardown.
* ----------------------------------------------------------------------


  ENDMETHOD.       "Class_Teardown

* ----------------------------------------------------------------------
  METHOD setup.
* ----------------------------------------------------------------------


  ENDMETHOD.       "Setup

* ----------------------------------------------------------------------
  METHOD teardown.
* ----------------------------------------------------------------------


  ENDMETHOD.       "Teardown

* ----------------------------------------------------------------------
  METHOD db_tables.
* ----------------------------------------------------------------------
    DATA: line TYPE i,
          act_db_tables   TYPE cl_tpda_script_scan_sql_sel=>ty_it_db_tables,
          exp_db_tables   TYPE cl_tpda_script_scan_sql_sel=>ty_it_db_tables,
          db_table        LIKE LINE OF exp_db_tables.

    " simple static select
    line = 10.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    act_db_tables = m_ref->db_tables(  ).
    CLEAR exp_db_tables.
    db_table-dynamic = space.
    db_table-name    = 'TADIR'.
    APPEND db_table TO exp_db_tables.


    cl_aunit_assert=>assert_equals(
      act   = act_db_tables
      exp   = exp_db_tables                              "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: SELECT'
*     level =
    ).


    " dynamic select

    line = 11.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    act_db_tables = m_ref->db_tables(  ).
    CLEAR exp_db_tables.
    db_table-dynamic = 'X'.
    db_table-name    = 'TABNAME'.
    APPEND db_table TO exp_db_tables.


    cl_aunit_assert=>assert_equals(
      act   = act_db_tables
      exp   = exp_db_tables                              "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: SELECT'
*     level =
    ).

    " static select with field list

    line = 12.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    act_db_tables = m_ref->db_tables(  ).
    CLEAR exp_db_tables.
    db_table-dynamic = space.
    db_table-name    = 'TADIR'.
    APPEND db_table TO exp_db_tables.


    cl_aunit_assert=>assert_equals(
      act   = act_db_tables
      exp   = exp_db_tables                              "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: SELECT'
*     level =
    ).

    " simple static select (mixed from into)
    line = 13.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    act_db_tables = m_ref->db_tables(  ).
    CLEAR exp_db_tables.
    db_table-dynamic = space.
    db_table-name    = 'TADIR'.
    APPEND db_table TO exp_db_tables.


    cl_aunit_assert=>assert_equals(
      act   = act_db_tables
      exp   = exp_db_tables                              "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: SELECT'
*     level =
    ).

    " Join
    line = 14.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    act_db_tables = m_ref->db_tables(  ).
    CLEAR exp_db_tables.
    db_table-dynamic = space.
    db_table-name    = 'TADIR'.
    APPEND db_table TO exp_db_tables.

    db_table-dynamic = space.
    db_table-name    = 'TRDIR'.
    APPEND db_table TO exp_db_tables.


    cl_aunit_assert=>assert_equals(
      act   = act_db_tables
      exp   = exp_db_tables                              "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: SELECT'
*     level =
    ).

    " select single
    line = 15.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    act_db_tables = m_ref->db_tables(  ).
    CLEAR exp_db_tables.
    db_table-dynamic = space.
    db_table-name    = 'TADIR'.
    APPEND db_table TO exp_db_tables.




    cl_aunit_assert=>assert_equals(
      act   = act_db_tables
      exp   = exp_db_tables                              "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: SELECT'
*     level =
    ).
  ENDMETHOD.       "Db_Tables
  METHOD join.
    " select single - expect no
    DATA: return_value TYPE flag,
          line TYPE i.
    line = 15.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    return_value = m_ref->join(  ).

    cl_aunit_assert=>assert_equals(
      act   = return_value
      exp   = space                             "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: SELECT-JOIN'
*     level =
    ).

    " JOIN - expect yes
    line = 14.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    return_value = m_ref->join(  ).

    cl_aunit_assert=>assert_equals(
      act   = return_value
      exp   = 'X'                             "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: SELECT-JOIN'
*     level =
    ).
  ENDMETHOD.                    "join

  METHOD single.
    " select single - expect yes
    DATA: return_value TYPE flag,
          line TYPE i.
    line = 15.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    return_value = m_ref->single(  ).

    cl_aunit_assert=>assert_equals(
      act   = return_value
      exp   = 'X'                             "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: SELECT-SINGLE'
*     level =
    ).

    " JOIN - expect no
    line = 14.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    return_value = m_ref->single(  ).

    cl_aunit_assert=>assert_equals(
  act   = return_value
  exp   = ''                             "<--- @todo: adapt expected value
  msg   = 'TPDA-Script: Scan source: SELECT-SINGLE'
*     level =
).

  ENDMETHOD.                    "single

  METHOD for_all_entries_table.

    DATA: line TYPE i,
             act_itab   TYPE tpda_table_name.


    " for all entries
    line = 23.
    m_ref ?= cl_tpda_script_scan=>scan(
        p_program     = c_program
        p_include     = c_program
        p_line        = line
           ).
    act_itab = m_ref->for_all_entries_table(  ).

    cl_aunit_assert=>assert_equals(
      act   = act_itab
      exp   = 'ITAB'                              "<--- @todo: adapt expected value
      msg   = 'TPDA-Script: Scan source: for all entries'
*     level =
    ).
  ENDMETHOD.                    "for_all_entries_table
ENDCLASS.       "Lcl_Test_Script_Scan_Sql_Sel
