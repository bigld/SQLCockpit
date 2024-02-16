CLASS /cadaxo/cl_tpda_scriptscan_sel DEFINITION
  PUBLIC
  INHERITING FROM cl_tpda_script_scan_sqlread
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS for_all_entries_table
      RETURNING
        VALUE(p_foe_table) TYPE tpda_table_name .
    METHODS join
      RETURNING
        VALUE(p_join) TYPE flag .
    METHODS single
      RETURNING
        VALUE(p_single) TYPE flag .
    METHODS get_select_tokens
      EXPORTING
        VALUE(e_tokens) TYPE sana_stokesx_tab .

    METHODS db_tables
        REDEFINITION .
  PROTECTED SECTION.
    DATA: m_select_codeline TYPE string.
  PRIVATE SECTION.

ENDCLASS.



CLASS /cadaxo/cl_tpda_scriptscan_sel IMPLEMENTATION.


  METHOD db_tables.
** grammar allows:
** FROM
*1. ... dbtab [AS tabalias]
*
*2. ... join
*
*3. ... (dbtab_syntax) [AS tabalias]

*** get FROM token.

    DATA: l_from_pos TYPE i,
          l_join_pos TYPE i,
          l_db_token LIKE LINE OF it_tokens,
          l_db_table TYPE ty_db_table.

    READ TABLE it_tokens TRANSPORTING NO FIELDS WITH KEY str = 'FROM'  type = sana_tok_word.
    IF sy-subrc <> 0 .
      RAISE EXCEPTION TYPE cx_tpda_script_scan.
    ENDIF.
    l_from_pos = sy-tabix.

*** get next element
    READ TABLE it_tokens INTO l_db_token INDEX l_from_pos + 1.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_tpda_script_scan.
    ENDIF.
*** from sflight or from sflight .... inner join spfli ....

    l_db_table = me->extract_table( l_db_token ).
    INSERT l_db_table INTO TABLE p_it_db_tables.

*** Join ???
    READ TABLE it_tokens TRANSPORTING NO FIELDS WITH KEY str = 'JOIN'  type = sana_tok_word.
    IF sy-subrc = 0 .
      l_join_pos = sy-tabix.
*** get next element
      READ TABLE it_tokens INTO l_db_token INDEX l_join_pos + 1.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE cx_tpda_script_scan.
      ENDIF.

      l_db_table = me->extract_table( l_db_token ).
      INSERT l_db_table INTO TABLE p_it_db_tables.
    ENDIF.
  ENDMETHOD.


  METHOD for_all_entries_table.
    DATA: l_token LIKE LINE OF it_tokens,
          l_index TYPE i.
    CLEAR p_foe_table.
    READ TABLE it_tokens TRANSPORTING NO FIELDS WITH KEY str = 'FOR'  type = sana_tok_word.
    IF sy-subrc = 0.
      l_index = sy-tabix + 1.
      READ TABLE it_tokens INTO l_token INDEX l_index  .
      IF sy-subrc = 0 AND l_token-str = 'ALL' AND l_token-type =  sana_tok_word.
        l_index = sy-tabix + 1.
        READ TABLE it_tokens INTO l_token INDEX l_index  .
        IF sy-subrc = 0 AND l_token-str = 'ENTRIES' AND l_token-type =  sana_tok_word.
          l_index = sy-tabix + 1.
          READ TABLE it_tokens INTO l_token INDEX l_index  .
          IF sy-subrc = 0 AND l_token-str = 'IN' AND l_token-type =  sana_tok_word.
            l_index = sy-tabix + 1.
            READ TABLE it_tokens INTO l_token INDEX l_index  .
            IF sy-subrc = 0 AND  l_token-type =  sana_tok_field.
              p_foe_table = l_token-str.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_select_tokens.

    e_tokens = it_tokens.

  ENDMETHOD.


  METHOD join.

    CLEAR p_join.
    READ TABLE it_tokens TRANSPORTING NO FIELDS WITH KEY str = 'JOIN'  type = sana_tok_word.
    IF sy-subrc = 0.
      p_join = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD single.

    CLEAR p_single.
    READ TABLE it_tokens TRANSPORTING NO FIELDS WITH KEY str = 'SINGLE'  type = sana_tok_word.
    IF sy-subrc = 0.
      p_single = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
