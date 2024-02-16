CLASS tc_tpda_script_class DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
  PRIVATE SECTION.
    METHODS: setup.
    METHODS: teardown.
    METHODS: get_cockpit_sql FOR TESTING.
    METHODS: get_cockpit_sql1 FOR TESTING.
    METHODS: get_cockpit_sql2 FOR TESTING.
    METHODS: get_field_symbols FOR TESTING.
ENDCLASS.       "tc_Tpda_Script_Class


CLASS tc_tpda_script_class IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.


  METHOD teardown.
  ENDMETHOD.


  METHOD get_cockpit_sql.

    DATA select_tokens TYPE sana_stokesx_tab.
    DATA cockpit_sql TYPE string.
    DATA into_clause TYPE string.

    APPEND VALUE #( str = 'SELECT'        type = /cadaxo/cl_tpda_script_class=>token_type-keyword ) TO select_tokens.
    APPEND VALUE #( str = '*'             type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'FROM'          type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'BUT000'        type = /cadaxo/cl_tpda_script_class=>token_type-type ) TO select_tokens.
    APPEND VALUE #( str = 'INTO'          type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'CORRESPONDING' type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'FIELDS'        type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'OF'            type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.
    APPEND VALUE #( str = 'TABLE'         type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = '@but000s'      type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.
    APPEND VALUE #( str = 'WHERE'         type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'PARTNER'       type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.
    APPEND VALUE #( str = '='             type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'p_partner'     type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.

    /cadaxo/cl_tpda_script_class=>get_cockpit_sql( EXPORTING i_select_tokens = select_tokens
                                                   IMPORTING e_cockpit_sql   = cockpit_sql
                                                             e_into_clause   = into_clause ).

    cl_abap_unit_assert=>assert_equals( act   = cockpit_sql
                                        exp   = | SELECT * FROM BUT000 WHERE PARTNER = p_partner| ).
    cl_abap_unit_assert=>assert_equals( act   = into_clause
                                        exp   = ' INTO CORRESPONDING FIELDS OF TABLE @but000s' ).
  ENDMETHOD.

  METHOD get_cockpit_sql2.

    DATA select_tokens TYPE sana_stokesx_tab.
    DATA cockpit_sql TYPE string.
    DATA into_clause TYPE string.

    APPEND VALUE #( str = 'SELECT'         type = /cadaxo/cl_tpda_script_class=>token_type-keyword ) TO select_tokens.
    APPEND VALUE #( str = '*'              type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'FROM'           type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'BUT000'         type = /cadaxo/cl_tpda_script_class=>token_type-type ) TO select_tokens.
    APPEND VALUE #( str = 'INTO'           type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'TABLE'          type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = '@data(but000s)' type = /cadaxo/cl_tpda_script_class=>token_type-type ) TO select_tokens.
    APPEND VALUE #( str = 'WHERE'          type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'PARTNER'        type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.
    APPEND VALUE #( str = '='              type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'p_partner'      type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.

    /cadaxo/cl_tpda_script_class=>get_cockpit_sql( EXPORTING i_select_tokens = select_tokens
                                                   IMPORTING e_cockpit_sql   = cockpit_sql
                                                             e_into_clause   = into_clause ).

    cl_abap_unit_assert=>assert_equals( act   = cockpit_sql
                                        exp   = | SELECT * FROM BUT000 WHERE PARTNER = p_partner| ).
    cl_abap_unit_assert=>assert_equals( act   = into_clause
                                        exp   = ' INTO TABLE @data(but000s)' ).
  ENDMETHOD.


METHOD get_cockpit_sql1.

    DATA select_tokens TYPE sana_stokesx_tab.
    DATA cockpit_sql TYPE string.
    DATA into_clause TYPE string.

    APPEND VALUE #( str = 'SELECT'         type = /cadaxo/cl_tpda_script_class=>token_type-keyword ) TO select_tokens.
    APPEND VALUE #( str = '*'              type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'FROM'           type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'BUT000'         type = /cadaxo/cl_tpda_script_class=>token_type-type ) TO select_tokens.
    APPEND VALUE #( str = 'INTO'           type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'CORRESPONDING'  type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'FIELDS'         type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'OF'             type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.
    APPEND VALUE #( str = 'TABLE'          type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = '@data(but000s)' type = /cadaxo/cl_tpda_script_class=>token_type-type ) TO select_tokens.
    APPEND VALUE #( str = 'WHERE'          type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'PARTNER'        type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.
    APPEND VALUE #( str = '='              type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'p_partner'      type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.

    /cadaxo/cl_tpda_script_class=>get_cockpit_sql( EXPORTING i_select_tokens = select_tokens
                                                   IMPORTING e_cockpit_sql   = cockpit_sql
                                                             e_into_clause   = into_clause ).

    cl_abap_unit_assert=>assert_equals( act   = cockpit_sql
                                        exp   = | SELECT * FROM BUT000 WHERE PARTNER = p_partner| ).
    cl_abap_unit_assert=>assert_equals( act   = into_clause
                                        exp   = ' INTO CORRESPONDING FIELDS OF TABLE @data(but000s)' ).
  ENDMETHOD.
  METHOD get_field_symbols.

    DATA select_tokens TYPE sana_stokesx_tab.
    DATA symbols TYPE /cadaxo/sqlc_symbol_t.

    APPEND VALUE #( str = 'SELECT'        type = /cadaxo/cl_tpda_script_class=>token_type-keyword ) TO select_tokens.
    APPEND VALUE #( str = '*'             type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'FROM'          type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'BUT000'        type = /cadaxo/cl_tpda_script_class=>token_type-type ) TO select_tokens.
    APPEND VALUE #( str = 'INTO'          type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'CORRESPONDING' type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'FIELDS'        type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'OF'            type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.
    APPEND VALUE #( str = 'TABLE'         type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = '@but000s'      type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.
    APPEND VALUE #( str = 'WHERE'         type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'PARTNER'       type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.
    APPEND VALUE #( str = '='             type = /cadaxo/cl_tpda_script_class=>token_type-word ) TO select_tokens.
    APPEND VALUE #( str = 'p_partner'     type = /cadaxo/cl_tpda_script_class=>token_type-field ) TO select_tokens.

    symbols = /cadaxo/cl_tpda_script_class=>get_field_symbols( select_tokens ).

    cl_abap_unit_assert=>assert_equals( act   = symbols
                                        exp   = VALUE /cadaxo/sqlc_symbol_t( ) ).

  ENDMETHOD.




ENDCLASS.
