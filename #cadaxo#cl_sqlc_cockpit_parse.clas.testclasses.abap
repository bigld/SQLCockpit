CLASS /cadaxo/tc_sqlc_cockpit_parse DEFINITION DEFERRED.
CLASS /cadaxo/cl_sqlc_cockpit_parse DEFINITION LOCAL FRIENDS /cadaxo/tc_sqlc_cockpit_parse.

CLASS /cadaxo/tc_sqlc_cockpit_parse DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>/cadaxo/tc_Sqlc_Cockpit_Parse
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>/CADAXO/CL_SQLC_COCKPIT_PARSE
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
      f_cut TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.  "class under test

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: is_count_star_only FOR TESTING.
    METHODS: is_not_count_star_only FOR TESTING.
    METHODS: parse_sql_i FOR TESTING.
    METHODS: parse_sql_i_2 FOR TESTING.
    METHODS: blacklist_check_tables FOR TESTING.

ENDCLASS.       "/cadaxo/tc_Sqlc_Cockpit_Parse


CLASS /cadaxo/tc_sqlc_cockpit_parse IMPLEMENTATION.

  METHOD class_setup.



  ENDMETHOD.


  METHOD class_teardown.



  ENDMETHOD.


  METHOD setup.

    DATA i_main_ref_id TYPE i.

    CREATE OBJECT f_cut
      EXPORTING
        i_main_ref_id = 1.
  ENDMETHOD.


  METHOD teardown.



  ENDMETHOD.


  METHOD is_count_star_only.

    TYPES: lty_t_string TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    LOOP AT VALUE lty_t_string( ( `  count( * ) ` )
                                ( `     count(*) ` )
                                ( `  DISTINCT   count(*) ` )
                                ( `  SINGLE   COUNT(*) ` )
                                ( `  count( * ) as cnt  ` )
                                ( `  count(*)   as cnt ` )
                                ( `  DIstinct   count(*)   as cnt ` )
                                ( `  single   count(*)   as cnt ` )
                                ( `  count(*) as as ` )
                               ) ASSIGNING FIELD-SYMBOL(<lv_fieldlist>).
      cl_abap_unit_assert=>assert_equals(
         act   = /cadaxo/cl_sqlc_cockpit_parse=>is_count_star_only( <lv_fieldlist> )
         exp   = abap_true
         msg   = |Testing value ev_Is_Count_Star_Only: { <lv_fieldlist> }|
         quit  = if_aunit_constants=>quit-no
       ).
    ENDLOOP.


  ENDMETHOD.

  METHOD is_not_count_star_only.

    TYPES: lty_t_string TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    LOOP AT VALUE lty_t_string( ( `  count( TYPE ) ` )
                                ( `     count(*), type ` )
                                ( `  DISTINCT COUNT( DISTINCT TYPE ) ` )
                                ( `  DISTINCT COUNT(  TYPE ) ` )
                                ( `  count( * ) as cnt, type as herbert  ` )
                                ( `  type as count ` )
                                ( `  count(*) as as type ` )
                                ( `  count(*) as as, type ` )
                                ( `  count(*), type ` )
*                                ( `  single   count(*)   as cnt ` )
                               ) ASSIGNING FIELD-SYMBOL(<lv_fieldlist>).
      cl_abap_unit_assert=>assert_equals(
         act   = /cadaxo/cl_sqlc_cockpit_parse=>is_count_star_only( <lv_fieldlist> )
         exp   = abap_false
         msg   = |Testing value ev_Is_Count_Star_Only: { <lv_fieldlist> }|
         quit  = if_aunit_constants=>quit-no
       ).
    ENDLOOP.


  ENDMETHOD.



  METHOD parse_sql_i_2.

    TYPES: BEGIN OF lty_s_strings,
             field TYPE string,
             value TYPE string,
           END OF lty_s_strings,
           lty_t_strings TYPE STANDARD TABLE OF lty_s_strings WITH DEFAULT KEY.
    DATA: lt_parsed TYPE /cadaxo/sqlc_cl_cockpit_parset.
    DATA: lv_attibute TYPE string.

    FIELD-SYMBOLS: <any_field> TYPE any.


    f_cut->parse_sql_i(
      EXPORTING
        i_sql                          = `SELECT DISTINCT ID1~PARTNER FROM BUT0ID AS ID1` &&
                                         ` INNER JOIN BUT050 AS BUT` &&
                                         `         ON ID1~PARTNER = BUT~PARTNER1` &&
                                         ` AND BUT~RELTYP  = 'ZBSALO'` &&
                                         `         AND BUT~XDFREL = 'X'` &&
                                         `      INNER JOIN BUT0ID AS ID2` &&
                                         `        ON BUT~PARTNER2 = ID2~PARTNER` &&
                                         `        AND ID2~TYPE = 'ZR3VKO'` &&
                                         `      UP     TO     5656    ROWS` &&
                                              ` WHERE ID1~TYPE = 'ZCRSCP'` &&
                                         `        AND  NOT ID2~IDNUMBER IN ('1580', '1620' )` &&
                                         `        AND ID1~IDNUMBER IN (` &&
                                         `   '1110043618',` &&
                                          ` '1030199116',` &&
                                          ` '1030229954',` &&
                                          ` '1030238172' ).`
      IMPORTING
        e_sql_parsed                   = lt_parsed
    ).

    DATA(lr_parsed) = CAST /cadaxo/cl_sqlc_cockpit_parse( lt_parsed[ 1 ] ).

    LOOP AT VALUE lty_t_strings(
    ( field = 'where_syntax' value = `ID1~TYPE = 'ZCRSCP'        AND  NOT ID2~IDNUMBER IN ('1580', '1620' )        AND ID1~IDNUMBER IN (` &&
                                     `   '1110043618', '1030199116', '1030229954', '1030238172' )`  )
    ( field = 'SQL_SYNTAX' value = `SELECT DISTINCT ID1~PARTNER FROM BUT0ID AS ID1 INNER JOIN BUT050 AS BUT         ON` &&
                                   ` ID1~PARTNER = BUT~PARTNER1 AND BUT~RELTYP  = 'ZBSALO'         AND BUT~XDFREL = 'X'` &&
                                   `      INNER JOIN BUT0ID AS ID2        ON BUT~PARTNER2 = ID2~PARTNER        AND ID2~TYPE = 'ZR3VKO'` &&
                                   `      UP     TO     5656    ROWS WHERE ID1~TYPE = 'ZCRSCP'        AND  NOT ID2~IDNUMBER IN ('1580', '1620' )` &&
                                   `        AND ID1~IDNUMBER IN (   '1110043618', '1030199116', '1030229954', '1030238172' )`  )
    ( field = 'SQL_SYNTAX_WITHOUT_WHERE' value = `SELECT DISTINCT ID1~PARTNER FROM BUT0ID AS ID1 INNER JOIN BUT050 AS BUT         ON ID1~PARTNER = BUT~PARTNER1 AND BUT~RELTYP  = 'ZBSALO'         AND BUT~XDFREL = 'X'      INNER JOIN BUT0ID AS ID2` &&
                                                 `        ON BUT~PARTNER2 = ID2~PARTNER        AND ID2~TYPE = 'ZR3VKO'      UP     TO     5656    ROWS WHERE <WHEREPARAM>`  )
    ( field = 'G_UP_TO_X_ROWS' value = `5656`  )
    ( field = 'G_SELECT_DISTINCT' value = abap_true  )
    ( field = 'sql_string' value = `SELECT DISTINCT ID1~PARTNER FROM BUT0ID AS ID1 INNER JOIN BUT050 AS BUT         ON` &&
                                   ` ID1~PARTNER = BUT~PARTNER1 AND BUT~RELTYP  = 'ZBSALO'         AND BUT~XDFREL = 'X'` &&
                                   `      INNER JOIN BUT0ID AS ID2        ON BUT~PARTNER2 = ID2~PARTNER        AND ID2~TYPE` &&
                                   ` = 'ZR3VKO'                                 WHERE ID1~TYPE = 'ZCRSCP'        AND  NOT ID2~IDNUMBER` &&
                                   ` IN ('1580', '1620' )        AND ID1~IDNUMBER IN (   '1110043618', '1030199116',` &&
                                   ` '1030229954', '1030238172' )`  )

                                  ) ASSIGNING FIELD-SYMBOL(<exp_value>).
      lv_attibute = |lr_parsed->{ <exp_value>-field } |.
      UNASSIGN <any_field>.
      ASSIGN (lv_attibute) TO <any_field>.
      cl_abap_unit_assert=>assert_equals(
         act   = <any_field>
         exp   = <exp_value>-value
         msg   = |Attribute: lr_parsed->{ <exp_value>-field }|
         quit  = if_aunit_constants=>quit-no
       ).


    ENDLOOP.


  ENDMETHOD.
  METHOD parse_sql_i.

    TYPES: BEGIN OF lty_s_strings,
             field TYPE string,
             value TYPE string,
           END OF lty_s_strings,
           lty_t_strings TYPE STANDARD TABLE OF lty_s_strings WITH DEFAULT KEY.
    DATA: lt_parsed TYPE /cadaxo/sqlc_cl_cockpit_parset.
    DATA: lv_attibute TYPE string.

    FIELD-SYMBOLS: <any_field> TYPE any.


    f_cut->parse_sql_i(
      EXPORTING
        i_sql                          = `select DISTINCT * from but000 UP     TO 3       ROWS where partner = '''dodo'.`
      IMPORTING
        e_sql_parsed                   = lt_parsed
    ).

    DATA(lr_parsed) = CAST /cadaxo/cl_sqlc_cockpit_parse( lt_parsed[ 1 ] ).

    LOOP AT VALUE lty_t_strings( ( field = 'where_syntax' value = `PARTNER = '''dodo'`  )
    ( field = 'SQL_SYNTAX' value = `SELECT DISTINCT * FROM BUT000 UP     TO 3       ROWS WHERE PARTNER = '''dodo'`  )
    ( field = 'SQL_SYNTAX_WITHOUT_WHERE' value = `SELECT DISTINCT * FROM BUT000 UP     TO 3       ROWS WHERE <WHEREPARAM>`  )
    ( field = 'G_UP_TO_X_ROWS' value = `3`  )
    ( field = 'G_SELECT_DISTINCT' value = 'X'  )
    ( field = 'sql_string' value = `SELECT DISTINCT * FROM BUT000                        WHERE PARTNER = '''dodo'`  )

                                  ) ASSIGNING FIELD-SYMBOL(<exp_value>).
      lv_attibute = |lr_parsed->{ <exp_value>-field } |.
      UNASSIGN <any_field>.
      ASSIGN (lv_attibute) TO <any_field>.
      cl_abap_unit_assert=>assert_equals(
         act   = <any_field>
         exp   = <exp_value>-value
         msg   = |Attribute: lr_parsed->{ <exp_value>-field }|
         quit  = if_aunit_constants=>quit-no
       ).


    ENDLOOP.


  ENDMETHOD.

  METHOD BLACKLIST_CHECK_TABLES.

    f_cut->BLACKLIST_CHECK_TABLES(

    ).

  ENDMETHOD.

ENDCLASS.
