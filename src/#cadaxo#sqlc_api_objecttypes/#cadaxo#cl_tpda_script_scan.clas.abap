CLASS /cadaxo/cl_tpda_script_scan DEFINITION
  PUBLIC
  CREATE PROTECTED .

  PUBLIC SECTION.
*"* public components of class /CADAXO/CL_TPDA_SCRIPT_SCAN
*"* do not include other source files here!!!
    TYPE-POOLS abap .
    TYPE-POOLS sana .

    TYPES:
      BEGIN OF ty_scan_buffer,
        program       TYPE                   sy-repid,
        include       TYPE                   sy-repid,
        it_tokens     TYPE STANDARD TABLE OF stokesx WITH NON-UNIQUE DEFAULT KEY,
        it_statements TYPE                   stpda_script_scan_statem_it,
        it_source     TYPE STANDARD TABLE OF string WITH NON-UNIQUE DEFAULT KEY,
      END OF ty_scan_buffer .
    TYPES:
      ty_it_scan_buffer TYPE HASHED TABLE OF ty_scan_buffer WITH UNIQUE KEY program include .

    CONSTANTS c_subkey_itab TYPE char10 VALUE 'ITAB' ##NO_TEXT.
    CONSTANTS c_subkey_dbtab TYPE char10 VALUE 'DBTAB' ##NO_TEXT.

    METHODS constructor
      IMPORTING
        VALUE(it_tokens) TYPE sana_stokesx_tab
      RAISING
        cx_tpda_script_scan_canthandle .
    CLASS-METHODS class_constructor .
    CLASS-METHODS scan
      IMPORTING
        !p_program           TYPE sy-repid
        !p_include           TYPE sy-repid
        !p_line              TYPE i
        !p_subkey            TYPE clike OPTIONAL
      RETURNING
        VALUE(p_scan_object) TYPE REF TO cl_tpda_script_scan
      RAISING
        cx_tpda_script_scan .
  PROTECTED SECTION.
*"* protected components of class /CADAXO/CL_TPDA_SCRIPT_SCAN
*"* do not include other source files here!!!

    DATA it_tokens TYPE sana_stokesx_tab .

  PRIVATE SECTION.
*"* private components of class /CADAXO/CL_TPDA_SCRIPT_SCAN
*"* do not include other source files here!!!

    CLASS-DATA it_match_class_keyword TYPE ty_it_keyword_class .
    CLASS-DATA it_scan_buffer TYPE ty_it_scan_buffer .


ENDCLASS.



CLASS /cadaxo/cl_tpda_script_scan IMPLEMENTATION.


  METHOD class_constructor.
    DATA l_class_key LIKE LINE OF it_match_class_keyword.

    CLEAR l_class_key.
    l_class_key-keyword = 'SELECT'.
    l_class_key-subkey  = space.
    l_class_key-subkey2 = c_subkey_dbtab.
    l_class_key-class   = '/CADAXO/CL_TPDA_SCRIPTSCAN_SEL'.
    INSERT l_class_key INTO TABLE it_match_class_keyword.
  ENDMETHOD.


  METHOD constructor.
    me->it_tokens = it_tokens.
  ENDMETHOD.


  METHOD scan.
    DATA: l_it_source     TYPE TABLE OF   string,
          l_it_tokens     LIKE            it_tokens,
          l_it_statements TYPE            stpda_script_scan_statem_it,
          l_statement     LIKE LINE OF    l_it_statements,
          l_token         LIKE LINE OF    l_it_tokens,
          l_key_class     LIKE LINE OF    it_match_class_keyword,
          l_index         TYPE            i,
          l_buffer        LIKE LINE OF    it_scan_buffer,
          l_scanner_found TYPE             flag.

    READ TABLE it_scan_buffer INTO l_buffer WITH TABLE KEY program = p_program include = p_include .
    IF sy-subrc = 0.
      l_it_tokens     = l_buffer-it_tokens.
      l_it_statements = l_buffer-it_statements.
      l_it_source     = l_buffer-it_source.
    ELSE.

*** get sourec code of include.
      READ REPORT p_include INTO l_it_source.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE cx_tpda_script_scan.
      ENDIF.

** get tokens / statemenets of source
      SCAN ABAP-SOURCE l_it_source WITH ANALYSIS TOKENS INTO l_it_tokens STATEMENTS INTO l_it_statements.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE cx_tpda_script_scan.
      ENDIF.

***  find statement matching with p_line
      SORT  l_it_statements BY trow from.

*** store in buffer
      l_buffer-it_tokens       = l_it_tokens.
      l_buffer-it_statements   = l_it_statements.
      l_buffer-program         = p_program.
      l_buffer-include         = p_include.
      l_buffer-it_source       = l_it_source.
      INSERT l_buffer INTO TABLE it_scan_buffer.
    ENDIF.

**** unbuffered analysis

    READ TABLE l_it_statements BINARY SEARCH INTO l_statement WITH KEY trow = p_line.
    IF sy-subrc <> 0.
***     perhaps p_line is at the end or in the middle of a statement
***     trow = last line of statement
      LOOP AT l_it_statements INTO l_statement WHERE trow >= p_line.
        l_index = sy-tabix.
        IF l_index > 0.
          READ TABLE l_it_statements INTO l_statement INDEX l_index .
          IF sy-subrc <> 0.
            CLEAR l_statement.
          ENDIF.
        ENDIF.
        EXIT.
      ENDLOOP.
      IF sy-subrc <> 0 OR l_statement IS INITIAL.
        RAISE EXCEPTION TYPE cx_tpda_script_scan.
      ENDIF.
    ENDIF.


*** qualify tokens
    CALL FUNCTION 'RS_QUALIFY_ABAP_TOKENS_STR'
      EXPORTING
        statement_type        = l_statement-type
        index_from            = l_statement-from
        index_to              = l_statement-to
      CHANGING
        stokesx_tab           = l_it_tokens
      EXCEPTIONS
        error_load_pattern    = 1
        unknown_keyword       = 2
        no_matching_statement = 3
        meaningless_statement = 4
        OTHERS                = 5.
    IF sy-subrc <> 0.
      IF sy-subrc = 4. "in most cases due to a macro
        RAISE EXCEPTION TYPE cx_tpda_script_scan_macro.
      ELSE.
        RAISE EXCEPTION TYPE cx_tpda_script_scan.
      ENDIF.
    ENDIF.


*** get rid of environment of our statement
    IF l_statement-to < lines( l_it_tokens ) .
      DELETE l_it_tokens FROM l_statement-to + 1.
    ENDIF.
    IF l_statement-from > 1.
      DELETE l_it_tokens FROM 1 TO l_statement-from - 1.
    ENDIF.


*** get leading keyword of statement
    SORT l_it_tokens BY row col.

    DATA l_index_subkey TYPE i.
    DATA l_token_subkey LIKE l_token.

    LOOP AT l_it_tokens INTO l_token WHERE type = sana_tok_keyword.
      l_index_subkey = sy-tabix + 1.
      READ TABLE l_it_tokens INTO l_token_subkey  INDEX l_index_subkey .
      IF sy-subrc <> 0 OR l_token_subkey-type <>  sana_tok_word.
        CLEAR l_token_subkey.
      ENDIF.
      EXIT.
    ENDLOOP.

    IF sy-subrc <> 0 .
      READ TABLE l_it_tokens TRANSPORTING NO FIELDS WITH KEY type = sana_tok_macro.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE cx_tpda_script_scan.
      ELSE.
        RAISE EXCEPTION TYPE cx_tpda_script_scan_macro.
      ENDIF.
    ENDIF.


*** find scan class for keyword + subkeyword ( delete from)
    CLEAR l_scanner_found.
    IF NOT l_token_subkey-str IS INITIAL.
      IF p_subkey IS INITIAL.
        LOOP AT it_match_class_keyword INTO l_key_class WHERE keyword = l_token-str AND subkey = l_token_subkey-str .
          TRY.
              CREATE OBJECT p_scan_object TYPE (l_key_class-class)
                EXPORTING
                  it_tokens = l_it_tokens.

              l_scanner_found = abap_true.
              EXIT.
            CATCH cx_tpda_script_scan_canthandle.
              CONTINUE.
            CATCH cx_root.
              RAISE EXCEPTION TYPE cx_tpda_script_scan.
          ENDTRY.
        ENDLOOP.
      ELSE.
        LOOP AT it_match_class_keyword INTO l_key_class WHERE keyword = l_token-str AND subkey = l_token_subkey-str AND subkey2 = p_subkey .
          TRY.
              CREATE OBJECT p_scan_object TYPE (l_key_class-class)
                EXPORTING
                  it_tokens = l_it_tokens.

              l_scanner_found = abap_true.
              EXIT.
            CATCH cx_tpda_script_scan_canthandle.
              CONTINUE.
            CATCH cx_root.
              RAISE EXCEPTION TYPE cx_tpda_script_scan.
          ENDTRY.


        ENDLOOP.
      ENDIF.
    ENDIF.
*** not found ->find scan class for keyword + subkeyword = space MODIFFY itab/dbtab
    IF l_scanner_found IS INITIAL .
      IF p_subkey IS INITIAL.
        LOOP AT it_match_class_keyword INTO l_key_class WHERE keyword = l_token-str AND subkey = space .
          TRY.
              CREATE OBJECT p_scan_object TYPE (l_key_class-class)
                EXPORTING
                  it_tokens = l_it_tokens.
              l_scanner_found = abap_true.
              EXIT.
            CATCH cx_tpda_script_scan_canthandle.
              CONTINUE.
            CATCH cx_root.
              RAISE EXCEPTION TYPE cx_tpda_script_scan.
          ENDTRY.
        ENDLOOP.
      ELSE.
        LOOP AT it_match_class_keyword INTO l_key_class WHERE keyword = l_token-str AND subkey = space AND subkey2 = p_subkey.
          TRY.
              CREATE OBJECT p_scan_object TYPE (l_key_class-class)
                EXPORTING
                  it_tokens = l_it_tokens.
              l_scanner_found = abap_true.
              EXIT.
            CATCH cx_tpda_script_scan_canthandle.
              CONTINUE.
            CATCH cx_root.
              RAISE EXCEPTION TYPE cx_tpda_script_scan.
          ENDTRY.
        ENDLOOP.

      ENDIF.
    ENDIF.
    IF  l_scanner_found  IS INITIAL.
      RAISE EXCEPTION TYPE cx_tpda_script_scan_no_scanner.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
