class /CADAXO/CL_SQLC_ABAP_PARSER definition
  public
  final
  create public .

public section.

  types:
    begin of TS_MAX_ITEMS,
      prefix_len type i,
      max_main   type i,
      max_second type i,
    end   of TS_MAX_ITEMS .
  types:
    TT_MAX_ITEMS type sorted table of TS_MAX_ITEMS
                     with unique key prefix_len .
  types:
    begin of T_USER_SETTINGS,
      keywords_lower_case   type abap_bool,
      identifier_lower_case type abap_bool,
      func_default_actparam type abap_bool,
      func_without_others   type abap_bool,
      meth_default_actparam type abap_bool,
      meth_without_others   type abap_bool,
      meth_with_try         type abap_bool,
      meth_func_call        type abap_bool,
    end   of T_USER_SETTINGS .
  types:
    completion_results type standard table of scc_completion .

  constants PROGTYPE_CLASS type SUBC value 'K' ##NO_TEXT.
  constants PROGTYPE_INCLUDE type SUBC value 'I' ##NO_TEXT.
  constants PROGTYPE_FUGR type SUBC value 'F' ##NO_TEXT.
  constants PROGTYPE_SUBPOOL type SUBC value 'S' ##NO_TEXT.
  constants PROGTYPE_MODPOOL type SUBC value 'M' ##NO_TEXT.
  constants PROGTYPE_TYPEPOOL type SUBC value 'T' ##NO_TEXT.
  constants PROGTYPE_EXEC type SUBC value '1' ##NO_TEXT.
  data M_CONTEXT_PROVIDER type ref to IF_ABAP_CONTEXT_PROVIDER .
  constants C_ALL_COMPONENTS type I value CL_ABAP_MATH=>MAX_INT4 ##NO_TEXT.
  constants:
    begin of TOKEN_CAT,
      UNDEF              type int1 value 0,  " undefined token category
      IDENTIFIER         type int1 value 1,  " identifier
      OPERATOR           type int1 value 2,  " operator
      TOKEN_OPERATOR     type int1 value 3,  " component select operator (e.g. ~)
      WS                 type int1 value 4,  " whitespace
      COMMENT            type int1 value 5,  " comment
      LITERAL            type int1 value 6,  " literal
      MAYBE_KEYWORD      type int1 value 7,  " looks like a keyword, but might be anidentifer
      CAT_KEYWORD        type int1 value 8,  " keyword
      CAT_STRICT_KEYWORD type int1 value 9,  " definately keyword
      CAT_INCOMPLETE     type int1 value 10, " incomplete token
  end of TOKEN_CAT .

  methods CONSTRUCTOR
    importing
      value(M_MAX_ITEMS) type TT_MAX_ITEMS optional
      value(M_MAX_COMPONENTS) type I optional .
  methods CALCULATE_COMPLETION_RESULTS
    importing
      value(YPOS) type I
      value(XPOS) type I
      value(BEG_YPOS) type I
      value(BEG_XPOS) type I
      !SOURCELINE type STRING
      !INCLUDENAME type SYREPID
      !MAINPROGNAME type SYREPID optional
      !REAL_YPOS type I default -1
      !REAL_XPOS type I default -1
      !REAL_BEG_XPOS type I default -1
      !DIALOG_ALLOWED type ABAP_BOOL default ABAP_FALSE
    exporting
      !COMPL_RESULT type COMPLETION_RESULTS
    changing
      !INCL_SOURCE type SOURCETABLE optional
    exceptions
      EMPTY_MAINPROG
      SCAN_ERROR
      INVALID_POSITION
      SOURCE_NOT_INCLUDED
      INCOMPLETE_RESULT .
  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_COMPLETION_DETAILS
    importing
      !KIND type I
      !IDENTIFIER type STRING
      !MAXGRADE type I optional
    exporting
      !SHORTTEXT type STRING
      !FULLNAME type STRING
      !SUBENTITIES type SCC_COMPLETIONS
      !PATTERN type I
      !DEPENTITIES type SCC_DETAILED_COMPLETIONS .
  class-methods GET_COMPLETION_RESULT
    importing
      !PROGRAM type SYREPID
      !PROG_SRC type STRING
      !INCLUDE type SYREPID optional
      !INCL_SRC type STRING optional
      !ROW type I
      !COLUMN type I
    exporting
      !COMPL_RESULT type SCC_COMPLETIONS
      !PREFIX type STRING
      !PREFIX_LENGTH type I
      !EXTERN_REQS type SCC_REPOSITORY_REQUESTS
      !SYMTAB_NEEDED type SAP_BOOL .
  class-methods GET_TOKENS
    importing
      !SOURCE type STRING
    exporting
      !TOKENS type ABPTOKENS .
  methods HANDLE_COMPLETION_REQUEST
    for event COMPLETION of CL_GUI_SOURCEEDIT
    importing
      !CONTEXTSTRING
      !YPOS
      !XPOS
      !CONTEXTINFO
      !SENDER .
  methods HANDLE_INSERTION_REQUEST
    for event INSERT_PATTERN of CL_GUI_SOURCEEDIT
    importing
      !PATTERNKEY
      !YPOS
      !XPOS
      !DATATYPE
      !FLAGS
      !SENDER .
  methods HANDLE_QUICKINFO_REQUEST
    for event QUICK_INFO of CL_GUI_SOURCEEDIT
    importing
      !CONTEXTSTRING
      !YPOS
      !XPOS
      !DATATYPE
      !SENDER .
  class-methods QUALIFY_TOKENS
    importing
      value(INDEX_FROM) type SSTMNT-FROM
      value(INDEX_TO) type SSTMNT-TO
      value(SIMPLIFIED) type CHAR1 default ' '
      value(STATEMENT_TYPE) type SSTMNT-TYPE optional
      !OVERFLOW type C default SPACE
    changing
      !STOKESX_TAB type SANA_STOKESX_TAB optional
      !STOKEX_TAB type SANA_STOKEX_TAB optional .
  methods RESET .
  class-methods X_TABLE_TO_STRING
    importing
      !GUI_CP type CPCODEPAGE default '4103'
      !APP_CP type CPCODEPAGE
      !X_TAB type STANDARD TABLE
      !LENGTH type I
    exporting
      !SOURCE_STR type STRING
      !RC type I
      !ERRMSG type STRING .
  class-methods X_TABLE_TO_S_TABLE
    importing
      !GUI_CP type CPCODEPAGE default '4103'
      !APP_CP type CPCODEPAGE
      !X_TAB type STANDARD TABLE
      !LENGTH type I
    exporting
      !S_TAB type STANDARD TABLE
      !RC type I
      !ERRMSG type STRING .
  class-methods INTERNAL_RESET .
  class-methods GET_BASICTYPE_TEXT
    importing
      value(P_BASICTYPE_INDEX) type SCC_PROPERTY
    returning
      value(P_BASICTYPE_NAME) type SCC_IDENTIFIER .
  class-methods GET_TYPING_TEXT
    importing
      !P_DETAILS type SCC_DETAILED_COMPLETIONS
      !P_BEGIN type I
      !P_FULLNAME type STRING
    exporting
      !P_TEXT type STRING
      !P_NEXT type I .
  methods CALCULATE_QUICKINFO_RESULT
    importing
      value(KIND) type I
      value(IDENTIFIER) type STRING
    exporting
      !HELP_TEXT type STRING
      !SUCCESS type ABAP_BOOL .
  methods CALCULATE_INSERTION_RESULT
    importing
      value(KIND) type I
      value(IDENTIFIER) type STRING
      value(PATTERN) type ABAP_BOOL default ABAP_FALSE
      !SETTINGS type T_USER_SETTINGS
      !DIALOG_ALLOWED type ABAP_BOOL default ABAP_FALSE
    exporting
      !COMPL_TEXT type RSWSOURCET
      value(BEG_XPOS) type I
      value(SUCCESS) type ABAP_BOOL .
  methods GET_ELEMENT_INFO
    importing
      !KIND type I
      !IDENTIFIER type STRING
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_PROG_OBJECT .
  class-methods GET_TYPE_INFO_AS_TEXT
    importing
      !TYPE type ref to CL_ABAP_CC_TYPE
      !USEDBYDEF type ref to CL_ABAP_CC_PROG_OBJECT optional
    exporting
      !SAME_AS type STRING
    returning
      value(RESULT) type STRING .
  class-methods GET_VALUE_INFO_AS_TEXT
    importing
      !VALUE type ref to CL_ABAP_CC_VALUE
    exporting
      !SAME_AS type STRING
    returning
      value(RESULT) type STRING .
*"* protected components of class CL_ABAP_CODE_COMPLETION
*"* do not include other source files here!!!
*"* protected components of class CL_ABAP_CODE_COMPLETION
*"* do not include other source files here!!!
protected section.
*"* protected components of class CL_ABAP_CODE_COMPLETION
*"* do not include other source files here!!!
private section.

  types BASICTYPE_NAME type SCC_IDENTIFIER .
  types:
    BASICTYPE_NAMES type standard TABLE OF BASICTYPE_NAME .
  types:
    begin of TS_ABAPDOC_subentry,
           kind       type scc_kind,
           identifier type string,
           comment    type string,
         end of TS_ABAPDOC_subentry .
  types:
    tt_abapdoc_subentities type sorted table of ts_abapdoc_subentry
                                with unique key kind identifier .

  data M_REPL_SOURCE type SREPTAB .
  constants C_MAXHITS_FIRST_LEVEL type I value 10. "#EC NOTEXT
  constants C_MAXHITS_SECOND_LEVEL type I value 5. "#EC NOTEXT
  constants C_MAX_COMPONENTS type I value 30. "#EC NOTEXT
  constants C_STMT_TERMINATOR type CHAR1 value '.'. "#EC NOTEXT
  data M_INCLNAME type SYREPID .
  data M_MAINPROG type SYREPID .
  data M_PROGTYPE type SUBC .
  data M_SRCDATE type D .
  data M_SRCTIME type T .
  data M_MAINSRC type SOURCETABLE .
  data M_COMPL_RESULT type SCC_COMPLETIONS .
  data M_REPOS_REQUESTS type SCC_REPOSITORY_REQUESTS .
  class-data M_ICON_MAPPING type SCC_ICON_MAPPINGS .
  data M_YPOS type I .
  data M_XPOS type I .
  data M_BEG_XPOS type I .
  class-data M_BASICTYPE_NAMES type BASICTYPE_NAMES .
  data M_MAX_ITEMS type TT_MAX_ITEMS .
  data M_BEG_TOKEN_XPOS type I .
  data C_MAXGRADE_FOR_SHORTTEXT type I value 1. "#EC NOTEXT    .  .  .  .  . " .
  data M_CCIMP_REQUIRED type ABAP_BOOL .

  methods GET_DATA_INFO
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !MINGRADE type I default 0
    changing
      !CURRINDEX type I
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_DATA .
  methods GET_TYPE_INFO
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !MINGRADE type I default 0
    changing
      !CURRINDEX type I
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_TYPE .
  methods GET_METHOD_INFO
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !MINGRADE type I default 0
    changing
      !CURRINDEX type I
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_METHOD .
  methods GET_EVENT_INFO
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !MINGRADE type I default 0
    changing
      !CURRINDEX type I
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_EVENT .
  methods GET_VALUE_INFO
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !MINGRADE type I
    changing
      !CURRINDEX type I
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_VALUE .
  methods GET_EXCEPTION_INFO
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !MINGRADE type I default 0
    changing
      !CURRINDEX type I
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_EXCEPTION .
  methods GET_FUNCTION_INFO
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !MINGRADE type I default 0
    changing
      !CURRINDEX type I
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_FUNCTION .
  methods GET_FORM_INFO
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !MINGRADE type I default 0
    changing
      !CURRINDEX type I
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_FORM .
  methods GET_DB_PROCEDURE_INFO
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !MINGRADE type I default 0
    changing
      !CURRINDEX type I
    returning
      value(ELEMENT) type ref to CL_ABAP_CC_FUNCTION .
  methods SCAN_ABAP_DOC
    importing
      !ABAPDOC type STRING
    exporting
      !SUBENTITIES type TT_ABAPDOC_SUBENTITIES
    returning
      value(COMMENT) type STRING .
  methods PROCESS_FORM_INCLUDE
    importing
      !INCLUDE type CLIKE .
  methods PROCESS_CLASS_INCLUDES
    importing
      !INCLUDE type PROGNAME
    returning
      value(REQUIRED) type ABAP_BOOL .
  class-methods GET_IMPLEMENTATION_START
    importing
      !SOURCE type SOURCETABLE
    returning
      value(IMPLSTART) type I .
  methods COMPOSE_INCLUDES
    importing
      !PROGRAMTYPE type SUBC
      !MAINPROGRAM type PROGNAME
    changing
      !INCLUDE type PROGNAME
      !SOURCE type SOURCETABLE .
  class-methods GET_CONTEXT_INFO
    importing
      !CONTEXTINFO type STRING
    exporting
      value(BEG_YPOS) type I
      value(BEG_XPOS) type I
    exceptions
      UNABLE_TO_PROCEED .
  methods GET_NORMED_SOURCE
    importing
      !MAINSOURCE type SOURCETABLE
      !STATEMENT type STRING optional
      value(BEG_YPOS) type I optional
      value(BEG_XPOS) type I optional
      value(COMPL_YPOS) type I
      value(COMPL_XPOS) type I
    exporting
      !NORMED_SOURCE type STRING
      value(YPOS) type I
      value(XPOS) type I
    changing
      !INCLUDESOURCE type SOURCETABLE
    exceptions
      EMPTY_MAINPROG
      SCAN_ERROR
      INVALID_POSITION
      SOURCE_NOT_INCLUDED .
  class-methods GET_ROLE_TEXT
    importing
      value(ROLE) type SCC_ROLE
    returning
      value(TEXT) type STRING .
  methods INSERT_AS_PATTERN
    importing
      value(P_FLAGS) type I optional
    returning
      value(R_ACTIVATED) type ABAP_BOOL .
  class-methods MAP_COMPLETION_RESULTS
    changing
      !COMPLETION_RESULT type SCC_COMPLETIONS .
  class-methods PARSE_FORM_PARAMETERS
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !FULLNAME type STRING
      !SETTINGS type T_USER_SETTINGS optional
    exporting
      !USING_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !CHANGING_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !TABLES_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !EXCEPTIONS_LIST type IF_ABAP_CC_ATL_TYPES=>EXCEPTIONS
      !CLASS_EXCEPTIONS type ABAP_BOOL .
  class-methods PARSE_METHOD_PARAMETERS
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !FULLNAME type STRING
      !SETTINGS type T_USER_SETTINGS optional
    exporting
      !IMPORTING_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !EXPORTING_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !CHANGING_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !RETURNING_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !EXCEPTIONS_LIST type IF_ABAP_CC_ATL_TYPES=>EXCEPTIONS
      !CLASS_EXCEPTIONS type ABAP_BOOL .
  class-methods PARSE_FUNCTION_PARAMETERS
    importing
      !DETAILS type SCC_DETAILED_COMPLETIONS
      !FULLNAME type STRING
      !SETTINGS type T_USER_SETTINGS optional
    exporting
      !IMPORTING_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !EXPORTING_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !CHANGING_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !TABLE_PARAMETERS type IF_ABAP_CC_ATL_TYPES=>OBJECT_INTERFACES
      !EXCEPTIONS_LIST type IF_ABAP_CC_ATL_TYPES=>EXCEPTIONS
      !CLASS_EXCEPTIONS type ABAP_BOOL .
  methods GET_SETTINGS
    exporting
      !SETTINGS type T_USER_SETTINGS .
ENDCLASS.



CLASS /CADAXO/CL_SQLC_ABAP_PARSER IMPLEMENTATION.


method CALCULATE_COMPLETION_RESULTS.

* init
  refresh m_compl_result.

* save completion position for later insertion
  if real_ypos <> -1 and real_xpos <> -1 and real_beg_xpos <> -1.
    m_ypos = real_ypos.
    m_xpos = real_xpos.
    m_beg_xpos = real_beg_xpos.
  else.
    m_ypos = ypos.
    m_xpos = xpos.
    m_beg_xpos = beg_xpos.
  endif.

* calculate completion position for current statement
  data compl_ypos type i.
  data compl_xpos type i.

  compl_ypos = ypos - beg_ypos + 1.
  if compl_ypos = 1.
    compl_xpos = xpos - beg_xpos + 1.
  else.
    compl_xpos = xpos.
  endif.

* call short-cut code completion
* in order to deliver a quick result for all argument position in statements
* that refers only to repositories like function module repository or
* messages
  data symbtab_needed type abap_bool value abap_true.

  if incl_source is not supplied.
    get_completion_result(
      exporting
        program       = space
        prog_src      = sourceline
        row           = compl_ypos
        column        = compl_xpos
      importing
        compl_result  = m_compl_result
        extern_reqs   = m_repos_requests
        symtab_needed = symbtab_needed
    ).
  endif.

  if symbtab_needed = abap_true.
    if incl_source is not supplied.
      raise incomplete_result.
    else.
*     detailed analysis necessary since completion position refers to symbol table
      data: read_prog_properties type abap_bool value abap_false,
            newmainprog          type syrepid.

      if includename is initial.
*       edit control has no include name => must be WebDynpro, BSP or something else
        if m_inclname is initial.
*         pseudo main source was not yet provided => build up context
          if m_context_provider is not initial.
            m_context_provider->get_context(
              importing
                includename   = m_inclname
                contextsource = m_mainsrc
            ).
          endif.
        endif.
      elseif m_mainprog is initial      or
             m_mainprog <> mainprogname or
             m_inclname <> includename.
*       read properties of mainprogram if still undetermined or
*                                      include/program has changed
        m_inclname = includename.

        data mainprogs type table of progname.

        if mainprogname is supplied and
           mainprogname is not initial.
          newmainprog = mainprogname.
        else.
*         RS_GET_MAINPROGRAMS is wrong/inefficient for type-pools, interface-pools
          if includename(3) = '%_C'.
            newmainprog = includename.
          elseif includename+30(2) = 'IU'.
            concatenate includename(31) 'P' into newmainprog.
          else.
            call function 'RS_GET_MAINPROGRAMS'
              exporting
                dialog       = dialog_allowed
                name         = includename
              tables
                mainprograms = mainprogs
              exceptions
                others       = 1.
            if sy-subrc <> 0 or lines( mainprogs ) = 0.
*           main program cannot be determined
*           => run completion just on current include
              newmainprog = includename.
            else.
              newmainprog = mainprogs[ 1 ].
            endif.
          endif.
        endif.
        read_prog_properties = abap_true.
        if m_mainprog is not initial and m_mainprog <> newmainprog.
          internal_reset( ).
        endif.
        m_mainprog = newmainprog.
      else.
*       validate main program is up-to-date by checking timestamp
*       TODO
      endif.

*     read program properties
      if read_prog_properties = abap_true.
        clear: m_srcdate, m_srctime, m_ccimp_required.

        data: lastdate type d,
              lasttime type t.
*       select I and A entry, take maximum
        select subc udat utime from reposrc
               into (m_progtype, lastdate, lasttime)
               where progname = m_mainprog.
          if lastdate > m_srcdate.
            m_srcdate = lastdate.
          endif.
          if lasttime > m_srctime.
            m_srctime = lasttime.
          endif.
        endselect.

        if m_mainprog <> m_inclname.
*         read source of main program
          read report m_mainprog into m_mainsrc.
        endif.
*       compose main program
        me->compose_includes(
          exporting
            programtype = m_progtype
            mainprogram = m_mainprog
          changing
            include     = m_inclname
            source      = m_mainsrc
        ).
      endif. " main program determined

*     for source-based class builder or AiE class source ...
      if m_progtype = progtype_class and m_inclname+30 = 'CS' and
         m_ccimp_required = abap_true.
*       ... add INCLUDE statement for CCIMP include
        data(implstart) = get_implementation_start( incl_source ).
        if implstart > 0.
          assign incl_source[ implstart - 1 ] to field-symbol(<implline>).
          <implline> = |{ <implline> } INCLUDE { m_inclname(30) }CCIMP.|.
        endif.
      endif.

*     compose single source code
      get_normed_source(
        exporting
          mainsource          = m_mainsrc
          statement           = sourceline
          beg_ypos            = beg_ypos
          beg_xpos            = beg_xpos
          compl_ypos          = ypos
          compl_xpos          = xpos
        importing
          normed_source       = data(normed_source)
          ypos                = compl_ypos
          xpos                = compl_xpos
        changing
          includesource       = incl_source
        exceptions
          empty_mainprog      = 1
          scan_error          = 2
          invalid_position    = 3
          source_not_included = 4
      ).

      if sy-subrc = 0.
*       call detailed code completion
        get_completion_result(
          exporting
            program      = m_mainprog
            prog_src     = normed_source
            row          = compl_ypos
            column       = compl_xpos
          importing
            compl_result = m_compl_result
            extern_reqs  = m_repos_requests
        ).

*       set begin of expression
        data(prev_space_pos) = find( val = sourceline sub = ` ` occ = -1 ).
        if prev_space_pos >= 0.
          m_beg_token_xpos = compl_xpos - ( strlen( sourceline ) - prev_space_pos ) + 1.
        else.
          m_beg_token_xpos = m_beg_xpos.
        endif.
      endif.
    endif.
  endif.

* add entries from repositories
  lcl_repository_requests=>get_repository_result(
    exporting
      extern_reqs  = m_repos_requests
      max_items    = m_max_items
    changing
      compl_result = m_compl_result
  ).

* add display attributes
  map_completion_results(
    changing
      completion_result = m_compl_result
  ).

* convert result set into standard table
* assignment is fast due to table sharing
  compl_result = m_compl_result.

endmethod.


METHOD CALCULATE_INSERTION_RESULT.

* init success state
  success = abap_false.
  CLEAR compl_text.

* find entry in result set
  READ TABLE m_compl_result WITH TABLE KEY  ##WARN_OK
                              kind       = kind
                              identifier = identifier
                            INTO DATA(compl_item).

  if sy-subrc <> 0 or compl_item-grade = 2. " not found or insert is not allowed
    return.
  endif.

* handle F4 request
  IF compl_item-is_meta = sccmp_f4_meta.
*   find corresponding completion request
    ASSIGN m_repos_requests[ compl_item-prop1 ] TO FIELD-SYMBOL(<request>).
    IF sy-subrc = 0 and dialog_allowed = abap_true.
      lcl_repository_requests=>call_f4_help(
                                  EXPORTING
                                    role   = compl_item-role
                                    prefix = <request>-prefix
                                  IMPORTING
                                    result = compl_item-identifier
                                  EXCEPTIONS
                                    OTHERS = 1 ).

      IF sy-subrc <> 0.
        RETURN. " request canceled
      ENDIF.
      identifier = compl_item-identifier.
      compl_item-prefixlength = strlen( <request>-prefix ).
      compl_item-syntcntxt = <request>-syntcntxt.
    else.
      return. " not found or no dialog possible
    ENDIF.
  ENDIF.

* create insertion pattern
  beg_xpos = m_xpos - compl_item-prefixlength.

  IF compl_item-syntcntxt <> SCCMP_CXT_NONE AND
     ( compl_item-is_meta = sccmp_insert_meta OR pattern = abap_true ).
*   adapt begin column for method calls as expression
    if compl_item-syntcntxt = SCCMP_CXT_CALL_METH_FUNC and
       m_beg_token_xpos > 0.
      m_beg_xpos = m_beg_token_xpos.
    endif.

*   call sophisticated insertion pattern
    lcl_enhanced_code_insertion=>get_insertion_string(
      EXPORTING
       datatype   = kind
       patternkey = identifier
       beg_xpos   = m_beg_xpos
       settings   = settings
       sycontext  = CONV #( compl_item-syntcntxt )
      CHANGING
       compl_text = compl_text
    ).
  ELSE.
*   handle simple identifier insert or insert of keywords
    if compl_item-kind = sccmp_cat_keyword.
      if dialog_allowed = abap_true.
        CASE compl_item-identifier.
          WHEN 'TYPES'.
            CALL FUNCTION 'SRCC_TYPE_DIALOG'
              IMPORTING
                source = compl_text.
          WHEN 'MESSAGE'.
            CALL FUNCTION 'SRCC_MESSAGE_DIALOG'
              IMPORTING
                source = compl_text.
          WHEN 'WRITE' OR 'WRITE /'.
            CALL FUNCTION 'CREATE_WRITE_STATEMENT'
              TABLES
                buffer    = compl_text
              EXCEPTIONS
                cancelled = 0.
        ENDCASE.
      endif.

      IF compl_text IS INITIAL.
*       simple keyword
        if settings-keywords_lower_case = abap_true.
          TRANSLATE compl_item-identifier TO LOWER CASE.
        endif.
*       add to result
        APPEND compl_item-identifier TO compl_text.
        return.
      ENDIF.
    else.
*     handle rest (simple identifiers)
      if settings-identifier_lower_case = abap_true and
         compl_item-kind <> sccmp_cat_function. " function module name remains in upper case
        TRANSLATE compl_item-identifier TO LOWER CASE.
      endif.
*     add to result
      APPEND compl_item-identifier TO compl_text.
    endif.
  ENDIF.

* set success
  success = abap_true.

ENDMETHOD.


METHOD CALCULATE_QUICKINFO_RESULT.

* init success state
  success = abap_false.
  CLEAR help_text.

  TRY.
    DATA(compl_item) = m_compl_result[ kind = kind identifier = identifier ] ##WARN_OK.
  CATCH cx_sy_itab_line_not_found.
    return.  " entry not found
  ENDTRY.

  IF compl_item-is_meta = sccmp_true.
*   fill quick info for search meta entry
    DATA(len) = STRLEN( compl_item-identifier ) - 5.
    IF len > 0.
      help_text = |\\b { text-300 }:\\b0 { text-301 }| &
                  | { compl_item-identifier+1(len) }|.
    ENDIF.
  ELSE.
*   fill quick info for entity
    lcl_enhanced_quick_info=>get_quickinfo_string(
      exporting
         compl_item     = compl_item
      receiving
         help_text      = help_text ).
  ENDIF.

* set success
  success = abap_true.

ENDMETHOD.


METHOD CLASS_CONSTRUCTOR.

  m_icon_mapping = value #(
* Fields
    imageindex = sccmp_eccompletionimgvariable
  ( role = sccmp_role_field           )
  ( role = sccmp_role_fieldsymbol     )
  ( role = sccmp_role_dataref         )
  ( role = sccmp_role_objref          )
  ( role = sccmp_role_exceptionobjref )
  ( role = sccmp_role_itab            )
  ( role = sccmp_role_selparam        )
  ( role = sccmp_role_selopt          )
  ( role = sccmp_role_rangestab       )
  ( role = sccmp_role_parameter       )
  ( role = sccmp_role_attralias       )
  ( role = sccmp_role_statics         )
  ( role = sccmp_role_component       )
  " only used for search context:
  " sccmp_role_selcrit
  " sccmp_role_fieldsimple
* Constants
    imageindex = sccmp_eccompletionimgconstant
  ( role = sccmp_role_constant )
* Structures
    imageindex = sccmp_eccompletionimgstructure
  ( role = sccmp_role_struct   )
* Subroutines non OO
    imageindex = sccmp_eccompletionimgfunction
  ( role = sccmp_role_function more_button_text = text-260 )
  ( role = sccmp_role_form               )
  ( role = sccmp_role_db_procedure       )
* Method
    imageindex = sccmp_eccompletionimgmethod
  ( role = sccmp_role_method             )
  ( role = sccmp_role_classmethod        )
  ( role = sccmp_role_constructor        )
  ( role = sccmp_role_classconstructor   )
  ( role = sccmp_role_eventhandlermethod )
  ( role = sccmp_role_eventhandlerstatic )
  ( role = sccmp_role_badimethod         )
  ( role = sccmp_role_methodalias        )
  ( role = sccmp_role_testmethod         )
* Event
    imageindex = sccmp_eccompletionimgevent
  ( role = sccmp_role_event       )
  ( role = sccmp_role_classevent  )
  ( role = sccmp_role_eventalias  )
  ( role = sccmp_role_exception       more_button_text = text-265 )
* Types non class
    imageindex = sccmp_eccompletionimgtype
  ( role = sccmp_role_type        )
  ( role = sccmp_role_structtype      more_button_text = text-205 )
  ( role = sccmp_role_itabtype        more_button_text = text-210 )
  ( role = sccmp_role_datareftype )
  ( role = sccmp_role_typealias       more_button_text = text-231 )
    imageindex = sccmp_eccompletionimgtable
  ( role = sccmp_role_database        more_button_text = text-305 )
  ( role = sccmp_role_db_table        more_button_text = text-305 )
  ( role = sccmp_role_db_view         more_button_text = text-320 )
* OO Types
    imageindex = sccmp_eccompletionimgclass
  ( role = sccmp_role_objtype         more_button_text = text-325 )
  ( role = sccmp_role_classtype       more_button_text = text-220 )
  ( role = sccmp_role_intftype        more_button_text = text-225 )
  ( role = sccmp_role_classexception  more_button_text = text-230 )
  ( role = sccmp_role_testclasstype   more_button_text = text-221 )
 ).

* basic type names
  m_basictype_names = value #(
    ( 'C' )
    ( 'D' )
    ( 'P' )
    ( 'T' )
    ( 'X' )
    ( 'N' )
    ( 'F' )
    ( 'I' )
    ( 'SHORT' )
    ( 'BYTE' )
    ( 'W' )
    ( '1' )
    ( '2' )
    ( 'STRING' )
    ( 'XSTRING' )
    ( 'DECFLOAT16' )
    ( 'DECFLOAT34' )
    ( 'INT8' )
    ( 'DTDAY' )
    ( 'TSECOND' )
    ( 'UTCLONG' )
    ( 'UTCSECOND' )
    ( 'UTCMINUTE' )
    ( 'TMINUTE' )
    ( 'DTMONTH' )
    ( 'DTWEEK' )
    ( 'CDAY' )
  ).

ENDMETHOD.


method COMPOSE_INCLUDES.

  data: l_t_tokens                 type table of stokes,
        l_t_statements             type table of sstmnt,
        l_statement                type sstmnt,
        l_incl_included            type abap_bool value abap_false.

  data(l_t_filter_include) = value keywordtable( ( 'INCLUDE' ) ).  " for SCAN

  field-symbols: <l_line>  type string,
                 <l_token> type stokes.

* reset all pre-processed sources
  clear M_REPL_SOURCE.

* determine and pre-process relevant source code
  case programtype.
    when progtype_class.
      if mainprogram = include or include+30 = 'CS'.
*       AiE or source-based class builder
        source = value #(
          ( `CLASS-POOL.` )
          ( |INCLUDE { include(30) }CCDEF.| )
          ( |INCLUDE { include(30) }CCMAC.| )
        ).
        m_ccimp_required = me->process_class_includes( include ).
        append |INCLUDE { include(30) }CS.| to source.
*       need to change include name, otherwise SCAN won't scan
        include+30 = 'CS'.  " ==CP -> ==CS
      else.
*       form-based class builder
        loop at source assigning <l_line>.
*         INCLUDE METHODS to be deleted
          find 'INCLUDE METHODS' in <l_line> ignoring case.
          if sy-subrc = 0.
            if include+31(1) = 'M' or include+31(1) = 'm'.
*             current include is method implementation include
              <l_line> = |INCLUDE { include } .|.
              l_incl_included = abap_true.
            else.
*             methods' implementation not needed
              delete source.
            endif.
            continue.
          endif.
*         do not include CCAU include (abap unit tests)
          find 'CCAU.' in <l_line> ignoring case.
          if sy-subrc = 0.
            if include+32(5) = 'AU'.
              l_incl_included = abap_true.
            else.
              delete source.
            endif.
            continue.
          endif.
*         process the local class implementation include
        endloop.
        if include+30(5) <> 'CCIMP'.
          me->process_class_includes( include ).
        endif.
        if l_incl_included = abap_false.
*         non-standard class include, just include as-is
          append |INCLUDE { include } .| to source.
        endif.
      endif.

    when progtype_fugr or progtype_exec or progtype_modpool or progtype_subpool.
*     remove all includes that are neither the top include (nor a system include)
*     nor a form include (e.g. ...F01)
      scan abap-source source
           tokens      into l_t_tokens
           statements  into l_t_statements
           keywords from l_t_filter_include.

      loop at l_t_statements into l_statement.
        assign l_t_tokens[ l_statement-from + 1 ] to <l_token>.
        if sy-subrc <> 0.
          continue.
        else.
          " SCAN deliveres token content in upper case
          data(length) = strlen( <l_token>-str ).
          if length >= 3.
            data(suffixoffset) = length - 3.
            data(suffix) = <l_token>-str+suffixoffset.
            if suffix = 'TOP' or <l_token>-str(1) = '<' and suffix+2(1) = '>'.
              continue.
            elseif suffix(1) = 'F' and
                   suffix+1(1) >= '0' and suffix+1(1) <= '9' and
                   suffix+2(1) >= '0' and suffix+2(1) <= '9' and
                   include <> <l_token>-str.
*             remove operative code of all the form implementations
              me->process_form_include( include = <l_token>-str ).
              continue.
            endif.
          endif.
        endif.
        assign source[ <l_token>-row ] to <l_line>.
        if sy-subrc = 0.
          clear <l_line>.
        endif.
      endloop.

*     append include statement for current sourcetext always at end of mainsource
      if  mainprogram <> include.
        append |INCLUDE { include }. | to source.
      endif.

  endcase.

endmethod.


method CONSTRUCTOR.

  if m_max_components is supplied.
    lcl_enhanced_quick_info=>m_max_components = m_max_components.
  else.
    lcl_enhanced_quick_info=>m_max_components = c_max_components.
  endif.

  if m_max_items is supplied and m_max_items is not initial.
    me->m_max_items = m_max_items.
  else.
*   no prefix
    insert value #( ) into table me->m_max_items.
*   prefix 5 characters
    insert value #( prefix_len = 5 max_main = 5 ) into table me->m_max_items.
*   long prefix
    insert value #( prefix_len = 1000 max_main = c_MAXHITS_FIRST_LEVEL
                    max_second = c_MAXHITS_second_LEVEL ) into table me->m_max_items.
  endif.
endmethod.


method GET_BASICTYPE_TEXT.

* read from basic type table (filled in class constructor)
  check p_basictype_index between 1 and lines( m_basictype_names ).
  p_basictype_name = m_basictype_names[ p_basictype_index ].

endmethod.


method GET_COMPLETION_DETAILS BY KERNEL MODULE ab_km_get_completion_details ignore.
endmethod.


method GET_COMPLETION_RESULT BY KERNEL MODULE ab_km_get_completion_result ignore.
endmethod.


method GET_CONTEXT_INFO.

  data: l_version type c length 10,
        l_row     type c length 10,
        l_column  type c length 10.

  if contextinfo is initial.
    raise unable_to_proceed.
  endif.

* format is: version # row # column
  split contextinfo at '#' into l_version l_row l_column.
  if l_version is initial or
     l_row     is initial or
     l_column  is initial.
    raise unable_to_proceed.
  endif.

* copy results
  beg_ypos = l_row.
  beg_xpos = l_column.

endmethod.


  METHOD GET_DATA_INFO.

*   read current entry
    assign details[ currindex ] to field-symbol(<entry>).
    check sy-subrc = 0.
    if <entry>-grade >= mingrade and
       <entry>-kind = sccmp_cat_field.
      if <entry>-role = sccmp_role_attralias.
*       read original attribute
        add 1 to currindex.
        data(orgindex) = currindex.
        data(orgdata) = get_data_info( exporting details   = details
                                                 mingrade  = mingrade
                                       changing  currindex = currindex ).
        if orgdata is not initial.
          element = orgdata.
          element->identifier = <entry>-identifier.
          element->visibility = <entry>-visibility.
          element->role       = sccmp_role_attralias.
        else.
*         default data without details
          element = new #( entry = <entry> ).
          currindex = orgindex.
        endif.
        return.
      elseif <entry>-role = sccmp_role_parameter.
*       create parameter
        element = new cl_abap_cc_parameter( entry = <entry> ).
      else.
*       create instance for data
        element  = new #( entry = <entry> ).
        element->abapdoc = scan_abap_doc( <entry>-commenttext ).
      endif.
      add 1 to currindex.

*     read short text (only up to a certain depth)
      if <entry>-grade <= c_maxgrade_for_shorttext.
        lcl_short_text=>get_text( exporting fullname  = <entry>-fullname
                                  importing shorttext = element->shorttext ).
      endif.

*     read type
      assign details[ currindex ] to <entry>.
      if sy-subrc = 0 and <entry>-grade > mingrade and
        <entry>-kind = sccmp_cat_type.
        element->type  = get_type_info( exporting details   = details
                                                  mingrade  = mingrade + 1
                                        changing  currindex = currindex ).
      endif.

*     read value
      assign details[ currindex ] to <entry>.
      if sy-subrc = 0 and <entry>-grade > mingrade and
         <entry>-kind = sccmp_cat_value.
        element->value = get_value_info( exporting details   = details
                                                   mingrade  = mingrade + 1
                                         changing  currindex = currindex ).
      endif.
    endif.

  ENDMETHOD.


  METHOD GET_DB_PROCEDURE_INFO.
    data:
      param   type ref to cl_abap_cc_parameter,
      excep   type ref to cl_abap_cc_exception,
      subdocs type tt_abapdoc_subentities.
    field-symbols:
      <subdoc> type ts_abapdoc_subentry,
      <entry>  like line of details.

*   read current entry
    read table details index currindex assigning <entry>.
    if sy-subrc = 0 and <entry>-grade >= mingrade and
       <entry>-kind = sccmp_cat_db_procedure.
*     create instance for database procedure
      create object element exporting entry = <entry>.
      add 1 to currindex.

*     read abap doc
      element->abapdoc = scan_abap_doc( exporting abapdoc     = <entry>-commenttext
                                        importing subentities = subdocs ).

*     read short text (only up to a certain depth)
      if <entry>-grade <= c_maxgrade_for_shorttext.
        lcl_short_text=>get_text( exporting fullname  = <entry>-fullname
                                  importing shorttext = element->shorttext ).
      endif.

*     read signature
      while currindex <= lines( details ).
        read table details index currindex assigning <entry>.
        if <entry>-grade <= mingrade.
          exit.
        endif.

        if <entry>-kind = sccmp_cat_field.
*         read parameter
          param ?= get_data_info( EXPORTING details   = details
                                            mingrade  = mingrade + 1
                                  CHANGING  currindex = currindex ).

*         assign abap doc
          read table subdocs with table key kind       = sccmp_cat_field
                                            identifier = param->identifier
                             ASSIGNING <subdoc>.
          if sy-subrc = 0.
            param->abapdoc = <subdoc>-comment.
          endif.

          case param->param_kind.
            when sccmp_par_importing.
              append param to element->importing_parameters.
            when sccmp_par_exporting.
              append param to element->exporting_parameters.
          endcase.
        elseif <entry>-kind = sccmp_cat_classexception.
*         read exception
          excep = get_exception_info( EXPORTING details   = details
                                                mingrade  = mingrade + 1
                                      CHANGING  currindex = currindex ).

*         assign abap doc
          read table subdocs with table key kind       = sccmp_cat_exception
                                            identifier = excep->identifier
                             ASSIGNING <subdoc>.
          if sy-subrc = 0.
            excep->abapdoc = <subdoc>-comment.
          endif.

          append excep to element->exception_list.
          element->is_raising = sccmp_true.
        else.
*         something unexpected
          exit.
        endif.
      endwhile.
    endif.
  ENDMETHOD.


  METHOD GET_ELEMENT_INFO.

*   get details from symbol table
    cl_abap_parser=>get_completion_details(
      exporting
        maxgrade    = 8
        kind        = kind
        identifier  = identifier
      importing
        depentities = data(details)
    ).

    check details is not initial.

*   start with current element
    data currindex type i value 1.
    case details[ currindex ]-kind.
      when sccmp_cat_field.
        element = get_data_info( exporting details   = details
                                 changing  currindex = currindex ).
      when sccmp_cat_type.
        element = get_type_info( exporting details   = details
                                 changing  currindex = currindex ).
      when sccmp_cat_method.
        element = get_method_info( exporting details   = details
                                   changing  currindex = currindex ).
      when sccmp_cat_event.
        element = get_event_info( exporting details   = details
                                  changing  currindex = currindex ).
      when sccmp_cat_form.
        element = get_form_info( exporting details   = details
                                 changing  currindex = currindex ).
      when sccmp_cat_function.
        element = get_function_info( exporting details   = details
                                     changing  currindex = currindex ).
      when sccmp_cat_exception.
        element = get_exception_info( exporting details   = details
                                      changing  currindex = currindex ).
      when sccmp_cat_db_procedure.
        element = get_db_procedure_info( exporting details   = details
                                         changing  currindex = currindex ).
    endcase.

  endmethod.


  METHOD GET_EVENT_INFO.
    field-symbols <subdoc> type ts_abapdoc_subentry.

*   read current entry
    assign details[ currindex ] to field-symbol(<entry>).
    check sy-subrc = 0.
    if <entry>-grade >= mingrade and
       <entry>-kind = sccmp_cat_event.

      if <entry>-role = sccmp_role_eventalias.
*       create event alias
        add 1 to currindex.
        data(orgindex) = currindex.
        data(orgevent) = get_event_info( exporting details   = details
                                                   mingrade  = mingrade
                                         changing  currindex = currindex ).
        if orgevent is not initial.
          element = orgevent.
          element->identifier = <entry>-identifier.
          element->visibility = <entry>-visibility.
          element->role       = <entry>-role.
        else.
*         default method without details
          element = new #( entry = <entry> ).
          currindex = orgindex.
        endif.
        return.
      endif.

*     create instance for event
      element = new #( entry = <entry> ).
      add 1 to currindex.

*     read abap doc
      scan_abap_doc( exporting abapdoc     = <entry>-commenttext
                     importing subentities = data(subdocs)
                     receiving comment     = element->abapdoc ).

*     read short text (only up to a certain depth)
      if <entry>-grade <= c_maxgrade_for_shorttext.
        lcl_short_text=>get_text( exporting fullname  = <entry>-fullname
                                  importing shorttext = element->shorttext ).
      endif.

*     read signature
      while currindex <= lines( details ).
        assign details[ currindex ] to <entry>.
        if <entry>-grade <= mingrade.
          exit.
        endif.

        if <entry>-kind = sccmp_cat_field.
*         read parameter
          data(param) = cast cl_abap_cc_parameter(
            get_data_info( exporting details   = details
                                     mingrade  = mingrade + 1
                           changing  currindex = currindex ) ).
*         assign abap doc
          assign subdocs[ kind = sccmp_cat_field identifier = param->identifier ]
            to <subdoc>.
          if sy-subrc = 0.
            param->abapdoc = <subdoc>-comment.
          endif.

          append param to element->exporting_parameters.
        else.
*         something unexpected
          exit.
        endif.
      endwhile.
    endif.
  ENDMETHOD.


  METHOD GET_EXCEPTION_INFO.
*   read current entry
    assign details[ currindex ] to field-symbol(<entry>).
    check sy-subrc = 0.
    if <entry>-grade >= mingrade.
      if <entry>-kind = sccmp_cat_classexception.
*       create instance for classbased exception
        element = new #( entry = <entry> ).
        add 1 to currindex.

*       read exception class
        element->classtype ?= get_type_info( exporting details   = details
                                                       mingrade  = mingrade + 1
                                             changing  currindex = currindex ).

      elseif <entry>-kind = sccmp_cat_exception.
*       create instance for return-code exception
        element = new #( entry = <entry> ).
        add 1 to currindex.

*       read short text (only up to a certain depth)
        if <entry>-grade <= c_maxgrade_for_shorttext.
          lcl_short_text=>get_text( exporting fullname  = <entry>-fullname
                                    importing shorttext = element->shorttext ).
        endif.
      endif.
    endif.
  ENDMETHOD.


  method GET_FORM_INFO.
    field-symbols <subdoc> type ts_abapdoc_subentry.

*   read current entry
    assign details[ currindex ] to field-symbol(<entry>).
    check sy-subrc = 0.
    if <entry>-grade >= mingrade and
       <entry>-kind = sccmp_cat_form.
*     create instance for form
      element = new #( entry = <entry> ).
      add 1 to currindex.

*     read abap doc
      scan_abap_doc( exporting abapdoc     = <entry>-commenttext
                     importing subentities = data(subdocs)
                     receiving comment     = element->abapdoc ).

*     read short text (only up to a certain depth)
      if <entry>-grade <= c_maxgrade_for_shorttext.
        lcl_short_text=>get_text( exporting fullname  = <entry>-fullname
                                  importing shorttext = element->shorttext ).
      endif.

*     read signature
      while currindex <= lines( details ).
        assign details[ currindex ] to <entry>.
        if <entry>-grade <= mingrade.
          exit.
        endif.

        if <entry>-kind = sccmp_cat_field.
*         read parameter
          data(param) = cast cl_abap_cc_parameter(
            get_data_info( exporting details   = details
                                     mingrade  = mingrade + 1
                           changing  currindex = currindex ) ).

*         assign abap doc
          assign subdocs[ kind = sccmp_cat_field identifier = param->identifier ]
            to <subdoc>.
          if sy-subrc = 0.
            param->abapdoc = <subdoc>-comment.
          endif.

          case param->param_kind.
            when sccmp_par_using.
              append param to element->using_parameters.
            when sccmp_par_changing.
              append param to element->changing_parameters.
            when sccmp_par_tables.
              append param to element->tables_parameters.
          endcase.
        elseif <entry>-kind = sccmp_cat_classexception or <entry>-kind = sccmp_cat_exception.
*         read exception
          data(excep) = get_exception_info( exporting details   = details
                                                      mingrade  = mingrade + 1
                                            changing  currindex = currindex ).

*         assign abap doc
          assign subdocs[ kind = sccmp_cat_exception identifier = excep->identifier ]
            to <subdoc>.
          if sy-subrc = 0.
            excep->abapdoc = <subdoc>-comment.
          endif.

          append excep to element->exception_list.
          if excep->kind = sccmp_cat_exception.
            element->is_raising = sccmp_false.
          else.
            element->is_raising = sccmp_true.
          endif.
        else.
*         something unexpected
          exit.
        endif.
      endwhile.
    endif.
  endmethod.


  METHOD GET_FUNCTION_INFO.
    field-symbols: <subdoc> type ts_abapdoc_subentry.

*   read current entry
    assign details[ currindex ] to field-symbol(<entry>).
    check sy-subrc = 0.
    if <entry>-grade >= mingrade and
       <entry>-kind = sccmp_cat_function.
*     create instance for function module
      element = new #( entry = <entry> ).
      add 1 to currindex.

*     read abap doc
      scan_abap_doc( exporting abapdoc     = <entry>-commenttext
                     importing subentities = data(subdocs)
                     receiving comment     = element->abapdoc ).

*     read short text (only up to a certain depth)
      if <entry>-grade <= c_maxgrade_for_shorttext.
        lcl_short_text=>get_text( exporting fullname  = <entry>-fullname
                                  importing shorttext = element->shorttext ).
      endif.

*     read signature
      while currindex <= lines( details ).
        assign details[ currindex ] to <entry>.
        if <entry>-grade <= mingrade.
          exit.
        endif.

        if <entry>-kind = sccmp_cat_field.
*         read parameter
          data(param) = cast cl_abap_cc_parameter(
            get_data_info( exporting details   = details
                                     mingrade  = mingrade + 1
                           changing  currindex = currindex ) ).

*         assign abap doc
          assign subdocs[ kind = sccmp_cat_field identifier = param->identifier ]
            to <subdoc>.
          if sy-subrc = 0.
            param->abapdoc = <subdoc>-comment.
          endif.

          case param->param_kind.
            when sccmp_par_importing.
              append param to element->importing_parameters.
            when sccmp_par_exporting.
              append param to element->exporting_parameters.
            when sccmp_par_changing.
              append param to element->changing_parameters.
            when sccmp_par_tables.
              append param to element->tables_parameters.
          endcase.
        elseif <entry>-kind = sccmp_cat_classexception or <entry>-kind = sccmp_cat_exception.
*         read exception
          data(excep) = get_exception_info( EXPORTING details   = details
                                                      mingrade  = mingrade + 1
                                            CHANGING  currindex = currindex ).

*         assign abap doc
          assign subdocs[ kind = sccmp_cat_exception identifier = excep->identifier ]
            to <subdoc>.
          if sy-subrc = 0.
            excep->abapdoc = <subdoc>-comment.
          endif.

          append excep to element->exception_list.
          if excep->kind = sccmp_cat_exception.
            element->is_raising = sccmp_false.
          else.
            element->is_raising = sccmp_true.
          endif.
        else.
*         something unexpected
          exit.
        endif.
      endwhile.
    endif.
  ENDMETHOD.


method GET_IMPLEMENTATION_START.
  data l_t_tokens  type standard table of STOKES with non-unique default key.
  data l_t_stmn    type standard table of SSTMNT with non-unique default key ##NEEDED.

* Tokenize all the class statements
  data(l_t_filter) = value keywordtable( ( 'CLASS' ) ).
  scan abap-source   source
    statements  into l_t_stmn
    tokens      into l_t_tokens
    keywords    from l_t_filter.

* search for first occurrence of class ... implementation
  loop at l_t_tokens assigning field-symbol(<l_s_token>)
    where type = SCAN_TOKEN_TYPE-identifier and STR = 'CLASS'.
*   ensure that the current class statement is a class implementation
    assign l_t_tokens[ sy-tabix + 2 ] to field-symbol(<l_s_impl_token>).
    if sy-subrc = 0 and <L_S_IMPL_TOKEN>-TYPE = SCAN_TOKEN_TYPE-identifier and
                        <l_s_impl_token>-str  = 'IMPLEMENTATION'.
      IMPLSTART = <l_s_token>-row.
      exit.
    endif.
  endloop.

endmethod.


  METHOD GET_METHOD_INFO.
    field-symbols <subdoc> type ts_abapdoc_subentry.

*   read current entry
    assign details[ currindex ] to field-symbol(<entry>).
    check sy-subrc = 0.
    if <entry>-grade >= mingrade and
       <entry>-kind = sccmp_cat_method.
      if <entry>-role = sccmp_role_methodalias.
*       create method alias
        add 1 to currindex.
        data(orgindex) = currindex.
        data(orgmeth) = get_method_info( exporting details   = details
                                                   mingrade  = mingrade
                                         changing  currindex = currindex ).
        if orgmeth is not initial.
          element = orgmeth.
          element->identifier = <entry>-identifier.
          element->visibility = <entry>-visibility.
          element->role       = <entry>-role.
        else.
*         default method without details
          element = new #( entry = <entry> ).
          currindex = orgindex.
        endif.
        return.
      endif.

*     create instance for method
      element = new #( entry = <entry> ).
      add 1 to currindex.

*     read abap doc
      scan_abap_doc( exporting abapdoc     = <entry>-commenttext
                     importing subentities = data(subdocs)
                     receiving comment     = element->abapdoc ).

*     read short text (only up to a certain depth)
      if <entry>-grade <= c_maxgrade_for_shorttext.
        lcl_short_text=>get_text( exporting fullname  = <entry>-fullname
                                  importing shorttext = element->shorttext ).
      endif.

      if element->is_handler = sccmp_true.
*       read event of event handler
        element->for_event = get_event_info( EXPORTING details   = details
                                                       mingrade  = mingrade + 1
                                             CHANGING  currindex = currindex ).
      endif.

*     read signature
      while currindex <= lines( details ).
        assign details[ currindex ] to <entry>.
        if <entry>-grade <= mingrade.
          exit.
        endif.

        if <entry>-kind = sccmp_cat_field.
*         read parameter
          data(param) = cast cl_abap_cc_parameter(
            get_data_info( EXPORTING details   = details
                                     mingrade  = mingrade + 1
                           CHANGING  currindex = currindex ) ).
*         assign abap doc
          assign subdocs[ kind = sccmp_cat_field identifier = param->identifier ]
            to <subdoc>.
          if sy-subrc = 0.
            param->abapdoc = <subdoc>-comment.
          endif.

          case param->param_kind.
            when sccmp_par_importing.
              append param to element->importing_parameters.
            when sccmp_par_exporting.
              append param to element->exporting_parameters.
            when sccmp_par_changing.
              append param to element->changing_parameters.
            when sccmp_par_returning.
            element->returning_parameter = param.
          endcase.
        elseif <entry>-kind = sccmp_cat_exception or
               <entry>-kind = sccmp_cat_classexception.
*         read exception
          data(excep) = get_exception_info( exporting details   = details
                                                      mingrade  = mingrade + 1
                                            changing  currindex = currindex ).
*         assign abap doc
          assign subdocs[ kind = sccmp_cat_exception identifier = excep->identifier ]
            to <subdoc>.
          if sy-subrc = 0.
            excep->abapdoc = <subdoc>-comment.
          endif.

          append excep to element->exception_list.
          if excep->kind = sccmp_cat_exception.
            element->is_raising = sccmp_false.
          else.
            element->is_raising = sccmp_true.
          endif.
        else.
*         something unexpected
          exit.
        endif.
      endwhile.
    endif.
  ENDMETHOD.


METHOD GET_NORMED_SOURCE.

* cut input source
  data srcline type string.
  subtract 1 from beg_xpos.
  if beg_ypos between 1 and lines( includesource ).
    assign includesource[ beg_ypos ] to field-symbol(<line>).
    if beg_xpos > 0 and strlen( <line> ) >= beg_xpos.
      srcline = <line>(beg_xpos).
    endif.
    delete includesource from beg_ypos.
  endif.
  append srcline to includesource.

* tokenize program source
  DATA: l_statements TYPE STANDARD TABLE OF sstmnt INITIAL SIZE 1000,
        l_tokens     TYPE STANDARD TABLE OF stokes INITIAL SIZE 3000,
        l_levels     type standard table of slevel,
        l_stmtendidx type i,
        l_nlcnt      type i.

  FIELD-SYMBOLS:
        <scantoken>  like line of l_tokens.

**********************************************************************
* The kernel-defined SCAN additions WITH DECLARATIONS and WITH BLOCKS
* replace the former ABAP-defined filter (KEYWORDS FROM).
* The list of DECLARATIVE and BLOCK-BUILDING statements has to be
* maintained in ab_jscan().
**********************************************************************

  if mainsource is initial.
*   scan current include
    SCAN ABAP-SOURCE  includesource
              TOKENS      INTO         l_tokens
              STATEMENTS  INTO         l_statements
              INCLUDE     PROGRAM FROM m_inclname
              FRAME       PROGRAM FROM m_mainprog
              with comments
              WITH DECLARATIONS
              WITH BLOCKS
              WITH INCLUDES.

    IF sy-subrc <> 0 AND sy-subrc <> 1.
      RAISE scan_error.
    ENDIF.
    l_stmtendidx = lines( l_statements ).

  else.
*   scan frame program and replace current include within

*   set replacing source
    DATA(edit_include_tab) = VALUE sreptab(
      ( LINES OF me->m_repl_source )
      ( name = m_inclname source = REF #( includesource ) ) ).

    SCAN ABAP-SOURCE  mainsource
              TOKENS      INTO l_tokens
              LEVELS      INTO l_levels
              STATEMENTS  INTO l_statements
              REPLACING   edit_include_tab
              INCLUDE PROGRAM FROM m_mainprog
              FRAME   PROGRAM FROM m_mainprog
              with comments
              WITH DECLARATIONS
              WITH BLOCKS
              WITH INCLUDES.

    IF sy-subrc <> 0 and sy-subrc <> 1.
      RAISE scan_error.
    ENDIF.

*   determine last statement of current include
    TRY.
      l_stmtendidx = l_levels[ name = m_inclname type = 'P' ]-to.
    CATCH cx_sy_itab_line_not_found.
      RAISE source_not_included.
    ENDTRY.

  ENDIF.

* assemble program source code
  normed_source = c_stmt_terminator. " enable foremost ABAP doc comment
  LOOP AT l_statements assigning FIELD-SYMBOL(<statement>) to l_stmtendidx.
    case <statement>-type.
      when SCAN_STMNT_TYPE-include. " skip include statements

      when SCAN_STMNT_TYPE-comment.
        LOOP AT l_tokens ASSIGNING <scantoken> FROM <statement>-from TO <statement>-to.
          if strlen( <scantoken>-str ) < 2 or <scantoken>-str(2) <> '"!'.
*           condense non-ABAP-Doc comments to newline
            CONCATENATE normed_source cl_abap_char_utilities=>newline INTO normed_source.
          else.
            CONCATENATE normed_source <scantoken>-str cl_abap_char_utilities=>newline INTO normed_source.
          endif.
          add 1 to l_nlcnt.
        ENDLOOP.

      when SCAN_STMNT_TYPE-comment_in_stmnt.
*       support ABAPC doc in chained statements (SCAN does not indicate this, thus take all)
        LOOP AT l_tokens ASSIGNING <scantoken> FROM <statement>-from TO <statement>-to.
          if strlen( <scantoken>-str ) >= 2 and <scantoken>-str(2) = '"!'.
            CONCATENATE normed_source <scantoken>-str cl_abap_char_utilities=>newline INTO normed_source.
            add 1 to l_nlcnt.
          endif.
        ENDLOOP.

      when others.
        LOOP AT l_tokens ASSIGNING <scantoken> FROM <statement>-from TO <statement>-to
                                               where type <> SCAN_TOKEN_TYPE-comment.
          CONCATENATE normed_source <scantoken>-str INTO normed_source SEPARATED BY space.
        ENDLOOP.
        CONCATENATE normed_source c_stmt_terminator into normed_source.
    endcase.
  ENDLOOP.

* new completion position is end of input string
  ypos = compl_ypos - beg_ypos + 1 + l_nlcnt + 1.  " extra +1 for newline between normed src and stmnt
  if compl_ypos = beg_ypos.
    xpos = compl_xpos - beg_xpos.                  " statement in same line; blanks at the beginning skipped
  else.
    xpos = compl_xpos.                             " several lines; blanks kept
  endif.

* append current statement
  concatenate normed_source cl_abap_char_utilities=>newline statement into normed_source.

ENDMETHOD.


method GET_ROLE_TEXT.

  case role.
*  fields
   when sccmp_role_field.
     text = text-100.
   when sccmp_role_constant.
     text = text-110.
   when sccmp_role_struct.
     text = text-125.
   when sccmp_role_fieldsymbol.
     text = text-130.
   when sccmp_role_dataref.
     text = text-135.
   when sccmp_role_objref.
     text = text-140.
   when sccmp_role_exceptionobjref.
     text = text-145.
   when sccmp_role_itab.
     text = text-150.
   when sccmp_role_selparam.
     text = text-155.
   when sccmp_role_selopt.
     text = text-160.
   when sccmp_role_rangestab.
     text = text-165.
   when sccmp_role_parameter.
     text = text-169.
   when sccmp_role_attralias.
     text = text-166.
   when sccmp_role_statics.
     text = text-167.
   when sccmp_role_component.
     text = text-161.
   " only used for search context:
   " sccmp_role_selcrit.
   " sccmp_role_fieldsimple.

*  types
   when sccmp_role_type.
     text = text-200.
   when sccmp_role_ref_to_type.
     text = text-203.
   when sccmp_role_structtype.
     text = text-205.
   when sccmp_role_itabtype.
     text = text-210.
   when sccmp_role_datareftype.
     text = text-215.
   when sccmp_role_objreftype.
     text = text-215.
   when sccmp_role_objtype.
     text = text-218.
   when sccmp_role_classtype.
     text = text-220.
   when sccmp_role_intftype.
     text = text-225.
   when sccmp_role_classexception.
     text = text-230.
   when sccmp_role_implintf.
     text = text-232.
   when sccmp_role_database.
     text = text-233.
   when sccmp_role_db_table.
     text = text-234.
   when sccmp_role_db_view.
     text = text-235.
   when sccmp_role_typealias.
     text = text-231.
   when sccmp_ROLE_TESTCLASSTYPE.
     text = text-221.
*  methods
   when sccmp_role_method.
     text = text-236.
   when sccmp_role_classmethod.
     text = text-240.
   when sccmp_role_constructor.
     text = text-241.
   when sccmp_role_classconstructor.
     text = text-242.
   when sccmp_role_eventhandlermethod.
     text = text-243.
   when sccmp_role_badimethod.
     text = text-237.
   when sccmp_role_methodalias.
     text = text-244.
   when sccmp_ROLE_EVENTHANDLERSTATIC.
     text = text-238.
   when sccmp_ROLE_TESTMETHOD.
     text = text-239.
*  events
   when sccmp_role_event.
     text = text-245.
   when sccmp_role_classevent.
     text = text-250.
   when sccmp_role_eventalias.
     text = text-251.
*  forms
   when sccmp_role_form.
     text = text-255.
*  functions
   when sccmp_role_function.
     text = text-260.
*  return code exceptions
   when sccmp_role_exception.
     text = text-265.
*  programs
   when sccmp_role_program.
     text = text-270.
*  database procedures
   when sccmp_role_db_procedure.
     text = text-290.
  endcase.

endmethod.


method GET_SETTINGS.

*   read workbench formatting settings
    DATA wb_setting TYPE rseumod.
    CALL FUNCTION 'RS_WORKBENCH_CUSTOMIZING'
      EXPORTING
        suppress_dialog = 'X'
      IMPORTING
        setting         = wb_setting.

*   evaluate user settings
    settings = VALUE #(
      func_default_actparam = wb_setting-formal_eq_actual
      func_without_others   = wb_setting-exc_wo_others
      meth_default_actparam = wb_setting-seoform_eq_act
      meth_without_others   = wb_setting-seoexc_wo_others
      meth_with_try         = wb_setting-seowith_tryendtr
      meth_func_call        = wb_setting-seofunc_call
      keywords_lower_case   = abap_false
      identifier_lower_case = abap_false ).

    IF wb_setting-style IS NOT INITIAL.
*     use the case style settings as customized in pretty print settings of WB
      CASE  wb_setting-lowercase.
        WHEN space.    " all upper case
*          settings-keywords_lower_case   = abap_false.
*          settings-identifier_lower_case = abap_false.
        WHEN 'X'.      " all lower case
          settings-keywords_lower_case   = abap_true.
          settings-identifier_lower_case = abap_true.
        WHEN 'L'.   " keyword lower case
          settings-keywords_lower_case   = abap_true.
*          settings-identifier_lower_case = abap_false.
        WHEN 'G'.   " keyword upper case
*          settings-keywords_lower_case   = abap_false.
          settings-identifier_lower_case = abap_true.
      ENDCASE.
    ENDIF.

endmethod.


method GET_TOKENS by kernel module ab_km_get_tokens ignore.
endmethod.


  METHOD GET_TYPE_INFO.

    FIELD-SYMBOLS <component> like line of details.

*   read current entry
    assign details[ currindex ] to field-symbol(<entry>).
    check sy-subrc = 0.
    if <entry>-grade >= mingrade and
       <entry>-kind = sccmp_cat_type.
      add 1 to currindex.

      case <entry>-role.
        when sccmp_role_structtype or " structure type
             sccmp_role_database   or " database entity (table or view)
             sccmp_role_db_table   or " database table
             sccmp_role_db_view.      " database view
*         create instance for structure type
          data(structtype) = new cl_abap_cc_structure_type( entry = <entry> ).
          while currindex <= lines( details ).
            assign details[ currindex ] to <component>.
            if <component>-grade <= mingrade.
              exit. " no components anymore
            endif.
            data(component) = get_data_info( exporting details   = details
                                                       mingrade  = mingrade + 1
                                             changing  currindex = currindex ).
            if component is initial.
              exit.
            elseif lines( structtype->components ) < structtype->number_of_components.
              append component to structtype->components.
            endif.
          endwhile.
          element = structtype.

        when sccmp_role_itabtype.
*         create instance for table type
          data(tabletype) = new cl_abap_cc_table_type( entry = <entry> ).
          tabletype->linetype = get_type_info( exporting details   = details
                                                         mingrade  = mingrade + 1
                                               changing  currindex = currindex ).
          element = tabletype.

        when sccmp_role_datareftype or
             sccmp_role_objreftype.
*         create instance for structure type
          data(reftype) = new cl_abap_cc_reference_type( entry = <entry> ).
          reftype->reftype = get_type_info( exporting details   = details
                                                      mingrade  = mingrade + 1
                                            changing  currindex = currindex ).
          element = reftype.

        when sccmp_role_objtype   or
             sccmp_role_classtype or sccmp_role_classexception or sccmp_ROLE_TESTCLASSTYPE or
             sccmp_role_intftype  or sccmp_role_implintf.
*         create instance for object type (class or interface)
          data(objtype) = new cl_abap_cc_object_type( entry = <entry> ).
          while currindex <= lines( details ).
            assign details[ currindex ] to <component>.
            if <component>-grade <= mingrade.
              exit. " no components anymore
            endif.
            if <component>-role = sccmp_role_objtype or
               <component>-role = sccmp_role_classtype or
               <component>-role = sccmp_ROLE_TESTCLASSTYPE or
               <component>-role = sccmp_role_intftype.
*             read super class and super interfaces
              data(superobjtype) = cast cl_abap_cc_object_type(
                get_type_info( exporting details   = details
                                         mingrade  = mingrade + 1
                               changing  currindex = currindex ) ).
              if superobjtype->is_class = sccmp_true.
                objtype->superclass = superobjtype.
              else.
                append superobjtype to objtype->interfaces.
              endif.
            else.
*             read class/interface members
              data member type ref to cl_abap_cc_prog_object.
              case <component>-kind.
                when sccmp_cat_field.
                  member = get_data_info( exporting details   = details
                                                    mingrade  = mingrade + 1
                                          changing  currindex = currindex ).
                when sccmp_cat_type.
                  member = get_type_info( exporting details   = details
                                                    mingrade  = mingrade + 1
                                          changing  currindex = currindex ).
                when sccmp_cat_method.
                  member = get_method_info( exporting details   = details
                                                      mingrade  = mingrade + 1
                                            changing  currindex = currindex ).
                when sccmp_cat_event.
                  member = get_event_info( exporting details   = details
                                                     mingrade  = mingrade + 1
                                           changing  currindex = currindex ).
              endcase.
              if member is initial.
                exit.
              endif.
*             add to public members
              append member to objtype->public_members.
            endif.
          endwhile.
          element = objtype.

        when sccmp_role_typealias.
*         create type alias
          if <entry>-prop2 = sccmp_false. " not an alias from interface implementation
            data(aliastype) = new cl_abap_cc_type_alias( entry = <entry> ).
            aliastype->orgtype = get_type_info( exporting details   = details
                                                          mingrade  = mingrade + 1
                                                changing  currindex = currindex ).
            element = aliastype.
          else.
*           read original type
            data(orgindex) = currindex.
            data(orgtype) = get_type_info( exporting details   = details
                                                     mingrade  = mingrade
                                           changing  currindex = currindex ).
            if orgtype is not initial.
              element = orgtype.
              element->identifier = <entry>-identifier.
              element->visibility = <entry>-visibility.
              element->role       = <entry>-role.
            else.
*             create default instance for type
              element = new #( entry = <entry> type_kind = sccmp_type_unknown ).
              currindex = orgindex.
            endif.
            return.
          endif.

        when sccmp_role_type.
          if <entry>-prop1 is not initial. " basic type
*           create instance for elementary type
            element = new cl_abap_cc_elementary_type( entry = <entry> ).
          else.
*           create default instance for type
            element = new #( entry = <entry> type_kind = sccmp_type_unknown ).
          endif.
      endcase.

*     read ABAP doc
      element->abapdoc = scan_abap_doc( <entry>-commenttext ).

*     read short text (only up to a certain depth)
      if <entry>-grade <= c_maxgrade_for_shorttext.
        lcl_short_text=>get_text( exporting fullname  = <entry>-fullname
                                  importing shorttext = element->shorttext ).
      endif.
    endif.
  ENDMETHOD.


method GET_TYPE_INFO_AS_TEXT.
  data: l_typename type string,
        l_fullname type string,
        l_next     type abap_bool.

  FIELD-SYMBOLS <result> type string.

  if type is initial.
    return.
  endif.

  if type->identifier is not initial and type <> usedbydef.
*   type property with name
    l_typename = type->fullname.
    if same_as is supplied.
      assign same_as to <result>.
    endif.
  else.
*   anonymous type
    assign result to <result>.
  endif.

  if <result> is ASSIGNED.
    case type->type_kind.
      when SCCMP_TYPE_ELEMENTARY.
        data(elementary_type) = cast CL_ABAP_CC_ELEMENTARY_TYPE( type ).
        <result> = get_basictype_text( p_basictype_index = elementary_type->basic_type ).
        case elementary_type->basic_type.
          when SCCMP_BTYP_P.
            <result> = <result> && | LENGTH { elementary_type->length }| &
                                   | DECIMALS { elementary_type->decimals }|.
          when SCCMP_BTYP_C or SCCMP_BTYP_X or SCCMP_BTYP_NUM.
            <result> = <result> && | LENGTH { elementary_type->length }|.
        endcase.

      when SCCMP_TYPE_TABLE.
        data(table_type) = cast CL_ABAP_CC_TABLE_TYPE( type ).
        if table_type->is_range_table = sccmp_true.
          <result> = `RANGE`.
        else.
          <result> = |{ switch string( table_type->itabkind " table kind
            when SCCMP_ITAB_NONE or SCCMP_ITAB_STANDARD then `STANDARD `
            when SCCMP_ITAB_SORTED                      then `SORTED `
            when SCCMP_ITAB_HASHED                      then `HASHED `
            when SCCMP_ITAB_ANY                         then `ANY ` ) }TABLE|.
        endif.
        <result> = <result> && ` OF ` && GET_TYPE_INFO_AS_TEXT( type = table_type->linetype usedbydef = usedbydef ).
        if table_type->is_header_table = sccmp_true. " with header line?
          <result> = <result> && ` WITH HEADER LINE`.
        endif.

      when SCCMP_TYPE_REFERENCE.
        <result> = |REF TO { GET_TYPE_INFO_AS_TEXT( type = cast CL_ABAP_CC_REFERENCE_TYPE( type )->reftype usedbydef = usedbydef ) }|.

      when SCCMP_TYPE_ALIAS.
        <result> = GET_TYPE_INFO_AS_TEXT( type = cast CL_ABAP_CC_TYPE_ALIAS( type )->orgtype usedbydef = usedbydef ).

      when others.
*       all other types (and also anonym structures) are identified by their fullname
        l_typename = type->fullname.
    endcase.
  endif.

  if l_typename is initial.
    return.
  endif.

* resolve type name
  IF type->location = sccmp_loc_internal.
    result = text-302. " unknown type name
  elseif type->location = sccmp_loc_predefined.
    result = type->IDENTIFIER.
  else.
*   resolve fullname of type
    if usedbydef is not initial.
      l_fullname = usedbydef->fullname.
    else.
      l_fullname = type->fullname.
    endif.
    do.
      DATA(l_srch) = l_typename+4.
      SPLIT l_srch AT '\' INTO DATA(l_head) DATA(l_tail).
      DATA(l_len) = 4 + strlen( l_head ).
      if l_tail is not initial        and
         strlen( l_fullname ) > l_len and
         l_fullname(l_len) = l_typename(l_len).
*       skip this part because it is redundant
        l_fullname = l_fullname+l_len.
        l_typename = l_typename+l_len.
        CONTINUE.
      endif.
      CASE l_typename+1(2).
        when sccmp_tag_class.
          if l_tail is initial.
            concatenate result l_head into result.
          else.
            concatenate result l_head '=>' into result.
            l_next = abap_true.
          endif.

        when sccmp_tag_interface.
          if l_tail is initial.
            concatenate result l_head into result.
          else.
            if l_next = abap_true.
              concatenate result l_head '~' into result.
            else.
              concatenate result l_head '=>' into result.
              l_next = abap_true.
            endif.
          endif.

        when sccmp_tag_type OR sccmp_tag_data.
          if l_tail is initial.
            concatenate result l_head into result.
          else.
            concatenate result l_head '-' into result.
          endif.
      endcase.
      if l_tail is initial.
        exit.
      else.
        CONCATENATE '\' l_tail into l_typename.
      endif.
    enddo.
  endif.

endmethod.


method GET_TYPING_TEXT.
  constants: c_sep type c length 1 value ','.
  FIELD-SYMBOLS: <details> like line of p_details,
                 <subtype> like line of p_details.
  data: l_typeoperation   type string,
        l_postfix         type string,
        l_fullname        type string,
        l_typename        type string,
        l_typename_result type string,
        l_basictype_text  type scc_identifier,
        l_length          type c length 10,
        l_decimals        type c length 10,
        l_srch            TYPE string,
        l_head            TYPE scc_identifier,
        l_tail            TYPE string,
        l_len             type i,
        l_grade           type i,
        l_next            type abap_bool,
        l_unknown         type abap_bool value abap_true,
        l_has_subtypes    type abap_bool.

* reset result
  clear p_text.
  p_next = p_begin.
  l_typeoperation = text-500.

* evaluate type entries
  loop at p_details FROM p_begin assigning <details>.
    if sy-tabix = p_begin.
      l_grade = <details>-grade. " first entry => save grade
    endif.
    if <details>-kind <> sccmp_cat_type or <details>-grade < l_grade.
*     only consecutive types are relevant
      p_next = sy-tabix.
      exit.
    endif.
    p_next = sy-tabix + 1.
    if <DETAILS>-IDENTIFIER is not initial and <details>-grade <> 0.
*     last type entry to be evaluated
      l_unknown = abap_false.
      l_typename = <details>-fullname.
      exit.
    endif.
*   resolve anonym types
    case <details>-role.
      when sccmp_role_structtype.
*       anonym structures are identified with fullname
        l_typename = <details>-fullname.
        l_unknown = abap_false.
      when sccmp_role_itabtype.
        case <details>-prop1. " table kind
          when SCCMP_ITAB_STANDARD.
            concatenate p_text 'STANDARD TABLE OF' into p_text separated by space.
          when SCCMP_ITAB_SORTED.
            concatenate p_text 'SORTED TABLE OF' into p_text separated by space.
          when SCCMP_ITAB_HASHED.
            concatenate p_text 'HASHED TABLE OF' into p_text separated by space.
          when SCCMP_ITAB_INDEX.
            concatenate p_text 'INDEX TABLE OF' into p_text separated by space.
          when SCCMP_ITAB_ANY.
            concatenate p_text 'ANY TABLE OF' into p_text separated by space.
          when others.
            concatenate p_text 'TABLE OF' into p_text separated by space.
        endcase.
        if <details>-prop2 is not initial. " with header line?
          concatenate l_postfix 'WITH HEADERLINE' into l_postfix separated by space.
        endif.
        if <details>-prop3 is not initial. " initial size
          l_length = <details>-prop3.
          concatenate l_postfix 'INITIAL SIZE' l_length into l_postfix separated by space.
        endif.

      when sccmp_role_datareftype or sccmp_role_objreftype.
        concatenate p_text 'REF TO' into p_text separated by space.

      when sccmp_role_objtype  or sccmp_role_classtype or
           sccmp_role_intftype or sccmp_role_classexception or
           sccmp_role_implintf or sccmp_ROLE_TESTCLASSTYPE.
*       all consecutive type entries are superclass and implemented/nested interfaces
        p_next = sy-tabix + 1.
        loop at p_details FROM p_next assigning <subtype>.
          if <subtype>-kind = sccmp_cat_type.
            if l_has_subtypes = abap_true.
              concatenate p_text c_sep <subtype>-identifier into p_text separated by space.
            else.
              concatenate p_text <subtype>-identifier into p_text separated by space.
            endif.
            p_next = sy-tabix + 1.
            l_has_subtypes = abap_true.
          else.
            exit. " stop loop
          endif.
        endloop.
        if l_has_subtypes = abap_true.
          concatenate text-502 p_text into p_text separated by space.
          condense p_text.
        endif.
        return.

      when sccmp_role_typealias.
        l_typeoperation = text-501.

      when sccmp_role_type.
        if <details>-prop1 is not initial. " basic type
          l_basictype_text = GET_BASICTYPE_TEXT( <details>-prop1 ).
          concatenate p_text l_basictype_text into p_text separated by space.
          l_unknown = abap_false.
          case <details>-prop1. " basic type
            when SCCMP_BTYP_P.
             l_length   = <details>-prop2.
             l_decimals = <details>-prop3.
             concatenate p_text 'LENGTH'   l_length
                                'DECIMALS' l_decimals into p_text separated by space.
           when SCCMP_BTYP_C or SCCMP_BTYP_X or SCCMP_BTYP_NUM.
             l_length   = <details>-prop2 + <details>-prop3 * 256.
             concatenate p_text 'LENGTH' l_length into p_text separated by space.
          endcase.
        endif.
        exit. " last type entry
    endcase.
  endloop.

* get type name
  IF sy-subrc <> 0 or l_unknown = abap_true or <details>-location = sccmp_loc_internal.
      l_typename_result = text-302. " unknown type name
  elseif <details>-grade = 0.
    clear l_typename_result.
  elseif l_typename is initial or
     <details>-location = sccmp_loc_predefined.
    l_typename_result = <details>-IDENTIFIER.
  else.
*   resolve fullname of type
    l_fullname = p_fullname.
    do.
      l_srch = l_typename+4.
      SPLIT l_srch AT '\' INTO l_head l_tail.
      l_len = 4 + strlen( l_head ).
      if l_tail is not initial        and
         strlen( l_fullname ) > l_len and
         l_fullname(l_len) = l_typename(l_len).
*       skip this part because it is redundant
        l_fullname = l_fullname+l_len.
        l_typename = l_typename+l_len.
        CONTINUE.
      endif.
      CASE l_typename+1(2).
        when sccmp_tag_class.
          if l_tail is initial.
            concatenate l_typename_result l_head into l_typename_result.
          else.
            concatenate l_typename_result l_head '=>' into l_typename_result.
            l_next = abap_true.
          endif.

        when sccmp_tag_interface.
          if l_tail is initial.
            concatenate l_typename_result l_head into l_typename_result.
          else.
            if l_next = abap_true.
              concatenate l_typename_result l_head '~' into l_typename_result.
            else.
              concatenate l_typename_result l_head '=>' into l_typename_result.
              l_next = abap_true.
            endif.
          endif.

        when sccmp_tag_type OR sccmp_tag_data.
          if l_tail is initial.
            concatenate l_typename_result l_head into l_typename_result.
          else.
            concatenate l_typename_result l_head '-' into l_typename_result.
          endif.
      endcase.
      if l_tail is initial.
        exit.
      else.
        CONCATENATE '\' l_tail into l_typename.
      endif.
    enddo.
  endif.

* build result
  concatenate l_typeoperation p_text l_typename_result l_postfix into p_text separated by space.
  condense p_text.

endmethod.


  METHOD GET_VALUE_INFO.
*   read current entry
    assign details[ currindex ] to field-symbol(<entry>).
    if sy-subrc = 0 and <entry>-grade >= mingrade and
       <entry>-kind = sccmp_cat_value.
*     create instance for value
      element = new #( entry = <entry> ).
      add 1 to currindex.
    endif.
  ENDMETHOD.


method GET_VALUE_INFO_AS_TEXT.

  if value is initial.
    return.
  endif.

  result = cond #( when value->is_initial = sccmp_true then `IS INITIAL` else value->sourcetext ).
  same_as = value->value.
endmethod.


method HANDLE_COMPLETION_REQUEST.

* extract additional parameters from context infos
  data: incl_source    type table of string,
        compl_result   type standard table of scc_completion.

  get_context_info(
    exporting  contextinfo       = contextinfo
    importing  beg_ypos          = data(beg_ypos)
               beg_xpos          = data(beg_xpos)
    exceptions unable_to_proceed = 1
               others            = 2 ).

* context information cannot be evaluated
  if sy-subrc <> 0.
    return. " stop code completion
  endif.

* get include name
  sender->get_actual_name( importing p_name = data(includename) ).

* call code completion (local evaluation)
  calculate_completion_results(
    exporting
      ypos                = ypos            " Completion position: line
      xpos                = xpos            " Completion position: column
      beg_ypos            = beg_ypos        " Begin of current statement: line
      beg_xpos            = beg_xpos        " Begin of current statement: column
      sourceline          = contextstring   " Current ABAP sentence for completion
      includename         = includename     " Current include in editor
      dialog_allowed      = abap_true       " called in GUI context
    importing
      compl_result        = compl_result    " Completion result
    exceptions
      incomplete_result   = 1
      others              = 2 ).

  if sy-subrc <> 0.
*   get source code from edit control
    sender->get_text( importing table = incl_source ).

*   call code completion (complete evaluation)
    calculate_completion_results(
      exporting
        ypos                = ypos            " Completion position: line
        xpos                = xpos            " Completion position: column
        beg_ypos            = beg_ypos        " Begin of current statement: line
        beg_xpos            = beg_xpos        " Begin of current statement: column
        sourceline          = contextstring   " Current ABAP sentence for completion
        includename         = includename     " Current include in editor
        dialog_allowed      = abap_true       " called in GUI context
      importing
        compl_result        = compl_result    " Completion result
      changing
        incl_source         = incl_source     " ABAP source of current include
      exceptions
        empty_mainprog      = 1
        scan_error          = 2
        invalid_position    = 3
        source_not_included = 4
        others              = 5
    ).
  endif.

  if sy-subrc = 0.
*   display completion result
    sender->show_completion_results( completion_results = compl_result  version = 1 ).
  endif.

endmethod.


METHOD HANDLE_INSERTION_REQUEST.

* read workbench formatting settings
  get_settings( IMPORTING settings = DATA(settings) ).

* get insertion text
  calculate_insertion_result(
    EXPORTING kind           = datatype
              identifier     = patternkey
              pattern        = insert_as_pattern( flags )
              settings       = settings
              dialog_allowed = abap_true " called in GUI context
    IMPORTING compl_text     = DATA(compl_text)
              beg_xpos       = DATA(beg_xpos)
              success        = DATA(success) ).

  if success = abap_true.
*   Set insertion position and mark selection
    sender->select_range(
      EXPORTING from_line = m_ypos
                from_pos  = beg_xpos
                to_line   = ypos
                to_pos    = xpos
      EXCEPTIONS OTHERS   = 1 ).

*   Replace selection by new entry
    sender->set_selected_text_as_table( EXPORTING table = compl_text ).

*   Refocus editor window (req'd for 710 GUI)
    sender->set_focus( EXPORTING control = sender ).
  ENDIF.

ENDMETHOD.


METHOD HANDLE_QUICKINFO_REQUEST.

* get insertion text
  calculate_quickinfo_result(
    EXPORTING kind       = datatype
              identifier = contextstring
    IMPORTING help_text  = DATA(help_text) ).

* method should be called even with empty string
  sender->show_quick_info(
    EXPORTING  info_string = help_text
    EXCEPTIONS OTHERS      = 1 ).

ENDMETHOD.


METHOD INSERT_AS_PATTERN.
constants:
  SHIFT_PRESSED type x length 1 value '04' ##NEEDED , "#EC NEEDED
  CTRL_PRESSED  type x length 1 value '08' ##NEEDED , "#EC NEEDED
  ALT_PRESSED   type x length 1 value '10' ##NEEDED . "#EC NEEDED

data:
  flags type x length 1.

  r_activated = abap_false.
*  IF sy-uname = 'JUNGTH' or      "#EC USER_OK
*     sy-uname = 'MUELLERMATH' or "#EC USER_OK
*     sy-uname = 'BERTELSMEIER'.  "#EC USER_OK
*    r_activated = abap_true.
*  ENDIF.

* insert pattern on SHIFT-TAB, SHIFT-ENTER, SHIFT-Double Click
  flags = p_flags.
  flags = flags bit-and SHIFT_PRESSED.
  if flags is not initial.
    r_activated = abap_true.
  endif.

ENDMETHOD.


method INTERNAL_RESET BY KERNEL MODULE ab_km_parser_reset ignore.
endmethod.


method MAP_COMPLETION_RESULTS.

  loop at completion_result assigning field-symbol(<compl_res>).
*   Is Identifier empty ?
    if <compl_res>-identifier is initial.
       delete completion_result.
       continue.
    endif.

*   Is result a keword ?
    if <compl_res>-kind = sccmp_cat_keyword.
      <compl_res>-icon = sccmp_ecCompletionImgKeyword.
      <compl_res>-bold = sccmp_true.
*     reset event handler flag for keywords (not handled at backend) - Changed by JUNGTH
*     to be handled at backend so that we can support quickinfo Help and
*     a few keyword "wizards".
      <compl_res>-quickinfo_event = sccmp_true.
      <compl_res>-insert_event    = sccmp_true.
      continue.
    endif.

*   determine icon
    try.
      <compl_res>-icon = m_icon_mapping[ role = <compl_res>-role ]-imageindex.
    catch cx_sy_itab_line_not_found.
      <compl_res>-icon = sccmp_ecCompletionImgDefault.
    endtry.

*   determine sub-icon
    case <compl_res>-visibility.
       when sccmp_visibility_public.
         <compl_res>-subicon = sccmp_ecCompletionImgPublic.
       when sccmp_visibility_protected.
         <compl_res>-subicon = sccmp_ecCompletionImgProtected.
       when sccmp_visibility_private.
         <compl_res>-subicon = sccmp_ecCompletionImgPrivate.
       when others.
         <compl_res>-subicon = sccmp_ecCompletionImgDefault.
    endcase.

*   use "bold" for first class results
    if <compl_res>-grade = 0.
      <compl_res>-bold = sccmp_true.
    else.
      <compl_res>-bold = sccmp_false.
    endif.

*   set event flag for backend handling
    <compl_res>-quickinfo_event = sccmp_true.
    <compl_res>-insert_event    = sccmp_true.

*   set "inserted as pattern" flag
    if <compl_res>-SYNTCNTXT <> sccmp_cxt_none        and
       <compl_res>-SYNTCNTXT <> sccmp_cxt_method_impl and " not yet supported
       strlen( <compl_res>-identifier ) = <compl_res>-prefixlength.
      <compl_res>-is_meta = sccmp_insert_meta.
    endif.

  endloop.

endmethod.


METHOD PARSE_FORM_PARAMETERS.
  FIELD-SYMBOLS: <wa_param>    LIKE LINE OF using_parameters,
                 <wa_except>   LIKE LINE OF exceptions_list.

  DATA: max_length  TYPE i,
        l_length    TYPE i,
        l_shorttext TYPE scc_shorttext.

  CLEAR: using_parameters, changing_parameters, tables_parameters,
         exceptions_list, class_exceptions.

  LOOP AT details ASSIGNING FIELD-SYMBOL(<wa_detail>) WHERE grade = 1.
    DATA(l_index)      = sy-tabix.
    DATA(l_identifier) = <wa_detail>-identifier.
    IF l_identifier CP '!*'.
      SHIFT l_identifier BY 1 PLACES LEFT IN CHARACTER MODE.
    ENDIF.
    CASE <wa_detail>-role.
      WHEN sccmp_role_parameter.
        CASE <wa_detail>-prop1.
          WHEN sccmp_par_using.
            APPEND INITIAL LINE TO using_parameters    ASSIGNING <wa_param>.
          WHEN sccmp_par_changing.
            APPEND INITIAL LINE TO changing_parameters ASSIGNING <wa_param>.
          WHEN sccmp_par_tables.
            APPEND INITIAL LINE TO tables_parameters   ASSIGNING <wa_param>.
        ENDCASE.
        <wa_param>-name = l_identifier.
        conv_ident_case <wa_param>-name.
        set_max_length max_length l_identifier.

***Short Text not supported for Forms

        IF <wa_detail>-prop3 = 0.
          <wa_param>-by_value = abap_true.
        ENDIF.
        get_typing_text(
          EXPORTING
            p_details  = details
            p_begin    = l_index + 1
            p_fullname = fullname
          IMPORTING
            p_text     = <wa_param>-type ).

      WHEN sccmp_role_classexception .
        class_exceptions = abap_true.
        APPEND INITIAL LINE TO exceptions_list ASSIGNING <wa_except>.
        <wa_except>-name = l_identifier.
        conv_ident_case <wa_except>-name.
*        set_max_length max_length l_identifier.  " no spacer setting?
        CLEAR l_shorttext.
        lcl_short_text=>get_text(
          EXPORTING fullname  = <wa_detail>-fullname
          IMPORTING shorttext = l_shorttext ).
        <wa_except>-desc = l_shorttext.

    ENDCASE.
  ENDLOOP.

  LOOP AT using_parameters ASSIGNING <wa_param>.
    set_spacer <wa_param> max_length.
  ENDLOOP.
  LOOP AT changing_parameters ASSIGNING <wa_param>.
    set_spacer <wa_param> max_length.
  ENDLOOP.
  LOOP AT tables_parameters ASSIGNING <wa_param>.
    set_spacer <wa_param> max_length.
  ENDLOOP.

ENDMETHOD.


METHOD PARSE_FUNCTION_PARAMETERS.
  FIELD-SYMBOLS: <wa_param>    LIKE LINE OF importing_parameters,
                 <wa_except>   LIKE LINE OF exceptions_list.
  DATA: max_length  TYPE i,
        l_length    TYPE i,
        l_shorttext TYPE scc_shorttext.

  CLEAR: importing_parameters, exporting_parameters, changing_parameters,
         table_parameters, exceptions_list, class_exceptions.

  LOOP AT details ASSIGNING FIELD-SYMBOL(<wa_detail>) WHERE grade = 1.
    DATA(l_index)      = sy-tabix.
    DATA(l_identifier) = <wa_detail>-identifier.
    IF l_identifier CP '!*'.
      SHIFT l_identifier BY 1 PLACES LEFT IN CHARACTER MODE.
    ENDIF.
    CASE <wa_detail>-role.
      WHEN sccmp_role_parameter.
        CASE <wa_detail>-prop1.
          WHEN sccmp_par_importing.
            APPEND INITIAL LINE TO importing_parameters ASSIGNING <wa_param>.
          WHEN sccmp_par_exporting.
            APPEND INITIAL LINE TO exporting_parameters ASSIGNING <wa_param>.
          WHEN sccmp_par_changing.
            APPEND INITIAL LINE TO changing_parameters  ASSIGNING <wa_param>.
          WHEN sccmp_par_tables.
            APPEND INITIAL LINE TO table_parameters     ASSIGNING <wa_param>.
        ENDCASE.

*       get name
        <wa_param>-name = l_identifier.
        conv_ident_case <wa_param>-name.
        set_max_length max_length l_identifier.

*       get short text according fullname
        lcl_short_text=>get_text(
          EXPORTING fullname  = <wa_detail>-fullname
          IMPORTING shorttext = l_shorttext ).
        <wa_param>-desc = l_shorttext.

        IF <wa_detail>-prop2 IS not INITIAL.
          <wa_param>-optional = abap_true.
        ENDIF.
        IF <wa_detail>-prop3 = 0.
          <wa_param>-by_value = abap_true.
        ENDIF.

        get_typing_text(
          EXPORTING
            p_details  = details
            p_begin    = l_index + 1
            p_fullname = fullname
          IMPORTING
            p_text     = <wa_param>-type
            p_next     = DATA(l_next) ).

*       fill name of actual parameter with name of formal parameter
        if settings-func_default_actparam <> abap_false.
          <wa_param>-actname = <wa_param>-name.
          conv_ident_case <wa_param>-actname.
        endif.

****    Default Values
        if l_next is not initial.
          assign details[ l_next ] to field-symbol(<wa_value>).
          if sy-subrc = 0.
            if <wa_value>-grade = 2.
              <wa_param>-default = <wa_value>-fullname.
              if <wa_value>-kind = sccmp_cat_field.
                conv_ident_case <wa_param>-default.
              endif.
*             fill name of actual parameter with default value
              if settings-func_default_actparam = abap_false.
                <wa_param>-actname = <wa_param>-default.
              endif.
              if <wa_value>-valuetext is not initial and
                 <wa_value>-valuetext <> <wa_value>-fullname.
                concatenate <wa_param>-default ` = ` <wa_value>-valuetext
                  into <wa_param>-default.
              endif.
            endif.
          endif.
        endif.

      WHEN sccmp_role_classexception.
        class_exceptions = abap_true.
        APPEND INITIAL LINE TO exceptions_list ASSIGNING <wa_except>.
        <wa_except>-name = l_identifier.
        conv_ident_case <wa_except>-name.
        set_max_length max_length l_identifier.
        CLEAR l_shorttext.
        lcl_short_text=>get_text(
          EXPORTING fullname  = <wa_detail>-fullname
          IMPORTING shorttext = l_shorttext ).
        <wa_except>-desc = l_shorttext.

      WHEN sccmp_role_exception.
        class_exceptions = abap_false.
        APPEND INITIAL LINE TO exceptions_list ASSIGNING <wa_except>.
        <wa_except>-name = l_identifier.
        conv_ident_case <wa_except>-name.
        set_max_length max_length l_identifier.
    ENDCASE.
  ENDLOOP.

  IF class_exceptions = abap_false AND
     lines( exceptions_list ) > 0  AND
     settings IS SUPPLIED          AND
     settings-func_without_others = abap_false.
    APPEND INITIAL LINE TO exceptions_list ASSIGNING <wa_except>.
    <wa_except>-name = 'OTHERS'.
    conv_ident_case <wa_except>-name.
    set_max_length max_length 'OTHERS'.
  endif.

  LOOP AT importing_parameters ASSIGNING <wa_param>.
    set_spacer <wa_param> max_length.
  ENDLOOP.
  LOOP AT exporting_parameters ASSIGNING <wa_param>.
    set_spacer <wa_param> max_length.
  ENDLOOP.
  LOOP AT changing_parameters ASSIGNING <wa_param>.
    set_spacer <wa_param> max_length.
  ENDLOOP.
  LOOP AT table_parameters ASSIGNING <wa_param>.
    set_spacer <wa_param> max_length.
  ENDLOOP.
  LOOP AT exceptions_list ASSIGNING <wa_except>.
    <wa_except>-counter = sy-tabix.
    set_spacer <wa_except> max_length.
  ENDLOOP.

ENDMETHOD.


method PARSE_METHOD_PARAMETERS.
  field-symbols: <wa_param>    like line of importing_parameters,
                 <wa_except>   like line of exceptions_list.

  data: max_length  type i,
        l_length    type i,
        l_shorttext type scc_shorttext,
        l_grade     type i value 1,
        l_role      type scc_role.

  clear: importing_parameters, exporting_parameters, changing_parameters,
         returning_parameters, exceptions_list, class_exceptions.

* for aliases start one level deeper
  l_role = details[ 1 ]-role.
  if l_role = sccmp_role_methodalias or l_role = sccmp_role_eventalias.
    add 1 to l_grade.
  endif.

* extract parameters
  loop at details assigning field-symbol(<wa_detail>) where grade = l_grade.
    data(l_index)      = sy-tabix.
    data(l_identifier) = <wa_detail>-identifier.
    if l_identifier cp '!*'.
      shift l_identifier by 1 places left in character mode.
    endif.
    case <wa_detail>-role.
      when sccmp_role_parameter.
        case <wa_detail>-prop1.
          when sccmp_par_importing.
            append initial line to importing_parameters assigning <wa_param>.
          when sccmp_par_exporting.
            append initial line to exporting_parameters assigning <wa_param>.
          when sccmp_par_changing.
            append initial line to changing_parameters  assigning <wa_param>.
          when sccmp_par_returning.
            append initial line to returning_parameters assigning <wa_param>.
        endcase.
*       get name
        <wa_param>-name = l_identifier.
        conv_ident_case <wa_param>-name.
        set_max_length max_length l_identifier.

*       get short text according fullname
        clear l_shorttext.
        lcl_short_text=>get_text(
          exporting fullname  = <wa_detail>-fullname
          importing shorttext = l_shorttext ).
        <wa_param>-desc = l_shorttext.

        if <wa_detail>-prop2 is not initial.
          <wa_param>-optional = abap_true.
        endif.
        if <wa_detail>-prop3 = 0.
          <wa_param>-by_value = abap_true.
        endif.

        get_typing_text(
         exporting
           p_details  = details
           p_begin    = l_index + 1
           p_fullname = fullname
         importing
           p_text     = <wa_param>-type
           p_next     = data(l_next) ).

*       fill name of actual parameter with name of formal parameter
        if settings-meth_default_actparam <> abap_false.
          <wa_param>-actname = <wa_param>-name.
          conv_ident_case <wa_param>-actname.
        endif.

****    Default Values
        if l_next is not initial.
          assign details[ l_next ] to field-symbol(<wa_value>).
          if sy-subrc = 0.
            if <wa_value>-grade = l_grade + 1.
              <wa_param>-default = <wa_value>-fullname.
              if <wa_value>-kind = sccmp_cat_field.
                conv_ident_case <wa_param>-default.
              endif.
*             fill name of actual parameter with default value
              if settings-meth_default_actparam = abap_false.
                <wa_param>-actname = <wa_param>-default.
              endif.
              if <wa_value>-valuetext is not initial and
                 <wa_value>-valuetext <> <wa_value>-fullname.
                <wa_param>-default = |{ <wa_param>-default } = { <wa_value>-valuetext }|.
              endif.
            endif.
          endif.
        endif.

      when sccmp_role_classexception.
        class_exceptions = abap_true.
        append initial line to exceptions_list assigning <wa_except>.
        <wa_except>-name = l_identifier.
        set_max_length max_length l_identifier.
        conv_ident_case <wa_except>-name.
        clear l_shorttext.
        lcl_short_text=>get_text(
          exporting fullname  = <wa_detail>-fullname
          importing shorttext = l_shorttext ).
        <wa_except>-desc = l_shorttext.

      when sccmp_role_exception.
        class_exceptions = abap_false.
        append initial line to exceptions_list assigning <wa_except>.
        <wa_except>-name = l_identifier.
        conv_ident_case <wa_except>-name.
        set_max_length max_length l_identifier.

    endcase.
  endloop.

  if class_exceptions = abap_false and
     lines( exceptions_list ) > 0  and
     settings is supplied          and
     settings-meth_without_others = abap_false.
    append initial line to exceptions_list assigning <wa_except>.
    <wa_except>-name = 'OTHERS'.
    conv_ident_case <wa_except>-name.
    set_max_length max_length 'OTHERS'.
  endif.

  loop at importing_parameters assigning <wa_param>.
    set_spacer <wa_param> max_length.
  endloop.
  loop at exporting_parameters assigning <wa_param>.
    set_spacer <wa_param> max_length.
  endloop.
  loop at changing_parameters assigning <wa_param>.
    set_spacer <wa_param> max_length.
  endloop.
  loop at returning_parameters assigning <wa_param>.
    set_spacer <wa_param> max_length.
  endloop.
  loop at exceptions_list assigning <wa_except>.
    <wa_except>-counter = sy-tabix.
    set_spacer <wa_except> max_length.
  endloop.

endmethod.


method PROCESS_CLASS_INCLUDES.

  constants c_tokenlen_endclass type i value 8. "=strlen('ENDCLASS')

  data l_t_tokens         type standard table of STOKES with non-unique default key.
  data l_t_stmnts         type standard table of SSTMNT with non-unique default key ##NEEDED.
  data l_line             type string.

  field-symbols <l_s_line> type string.

* This method eliminates all the code between the lines of a
* "CLASS <classname> IMPLEMENTATION." and the corresponding "ENDCLASS." statement.
* This code is operational code and not relevant for code completion.

  required = abap_false.

* Read the report
  data(l_s_source) = value sreptabln( name = |{ include(30) }CCIMP| source = new #( ) ).
  read report l_s_source-name into l_s_source-source->*.
  if sy-subrc <> 0.
    return.
  endif.
  append l_s_source to me->m_repl_source.

* Tokenize all the class / endclass statements
  data(l_t_filter) = value keywordtable( ( 'CLASS' )     ( 'ENDCLASS' )
                                         ( 'INTERFACE' ) ( 'ENDINTERFACE' )
                                         ( 'TYPES' )     ( 'CONSTANTS' ) ).
  scan abap-source   l_s_source-source->*
    statements  into l_t_stmnts
    tokens      into l_t_tokens
    keywords    from l_t_filter.

  if l_t_stmnts is initial.
    return.
  endif.

* contains declarative statements
  required = abap_true.

* Remove the lines between class ... implementation and endclass.
  loop at l_t_tokens assigning field-symbol(<l_s_token>)
    where type = SCAN_TOKEN_TYPE-identifier and STR = 'CLASS'.
*   Ensure that the current class statement is a class implementation
    assign l_t_tokens[ sy-tabix + 2 ] to field-symbol(<l_s_impl_token>).
    if sy-subrc <> 0 or not ( <L_S_IMPL_TOKEN>-TYPE = SCAN_TOKEN_TYPE-identifier and <l_s_impl_token>-str = 'IMPLEMENTATION' ) .
      continue.
    endif.

*   Search for the corresponding endclass statement
    loop at l_t_tokens assigning field-symbol(<l_s_endclass>) from sy-tabix + 1
      where type = SCAN_TOKEN_TYPE-identifier and str = 'ENDCLASS'.
      exit.
    endloop.

*   If found clear the lines between those statements.
    if <l_s_endclass> is assigned.
      "If class xxx implementation and endclass is in one line, skip it
      check <l_s_endclass>-row > <l_s_token>-row.

*     Process the line that contains class.
      assign l_s_source-source->*[ <l_s_token>-row ] to <l_s_line>.
      assert sy-subrc = 0.
      data(l_position) = <l_s_token>-col.
      if l_position = 0.
        clear <l_s_line>.
      else.
        l_line     = <l_s_line>(l_position).
        <l_s_Line> = l_line.
      endif.
*     Delete all lines between class and endclass.
      loop at l_s_source-source->* assigning <l_s_line> from <l_s_token>-row  + 1 to <l_s_endclass>-row - 1.
        clear <l_s_line>.
      endloop.

*     Process the line that contains endclass.
      assign l_s_source-source->*[ <l_s_endclass>-row ] to <l_s_line>.
      assert sy-subrc = 0.
      l_position = <l_s_endclass>-col + c_tokenlen_endclass.
      if l_position <= strlen( <l_s_line> ).
*       The line contains more then only an endclass
        l_line = |{ space width = l_position - 1 } { <l_s_line>+l_position }|.
        <l_s_line> = l_line.
      else.
*       The line contains only endclass.
        clear <l_s_line>.
      endif.
    endif.
  endloop.

endmethod.


method PROCESS_FORM_INCLUDE.
  types: begin of t_s_form_begin,
          row type i,
          col type i,
          open type abap_bool,
        end of t_s_form_begin.
  data l_t_token      type table of stokes.
  data l_t_statement  type table of sstmnt.
  data l_t_src        type SCR_INCLUDE.
  data l_opco_removed type abap_bool value abap_false.

* Get the source
  data(l_progname) = conv progname( include ).
  read report l_progname into l_t_src.
  if sy-subrc <> 0.
    return.
  endif.

* Scan all the statements in the source
  scan abap-source l_t_src
           tokens      into l_t_token
           statements  into l_t_statement.
  loop at l_t_statement assigning field-symbol(<l_s_statement>).
    data(l_stmt_index) = sy-tabix.
    if <l_s_statement>-from > <l_s_statement>-to. continue. endif. " empty stmt
    assign l_t_token[ <l_s_statement>-from ] to field-symbol(<l_s_token>).
    assert sy-subrc = 0.

*   Determine if the statement is a form declaration, and in this case the position of the first operative token in the form
    if <l_s_token>-TYPE = SCAN_TOKEN_TYPE-identifier and <l_s_token>-str = 'FORM'.
      assign l_t_statement[ l_stmt_index + 1 ] to field-symbol(<l_s_form_follow_st>).
      if sy-subrc <> 0.
        continue.
      endif.
      assign l_t_token[ <l_s_form_follow_st>-from ] to field-symbol(<l_s_form_follow_tk>).
      if sy-subrc <> 0.
        continue.
      endif.
      data(l_s_form_begin) = value t_s_form_begin( open = abap_true
                                                   row  = <l_s_form_follow_tk>-row
                                                   col  = <l_s_form_follow_tk>-col ).

*   Determine if the statement is the end of a form, and if so remove the operative code.
    elseif <l_s_token>-TYPE = SCAN_TOKEN_TYPE-identifier and <l_s_token>-str = 'ENDFORM' and l_s_form_begin-open = abap_true.
      l_s_form_begin-open = abap_false.
*     Remove the operative code
      loop at l_t_src assigning field-symbol(<l_line>) from l_s_form_begin-row to <l_s_token>-row - 1.
        clear <l_line>.
      endloop.
      if sy-subrc eq 0.
        l_opco_removed = abap_true.
      endif.

*   Determine if the statement is an INCLUDE statement and if so process if recursively.
    elseif <l_s_token>-TYPE = SCAN_TOKEN_TYPE-IDENTIFIER and <l_s_token>-str = 'INCLUDE'.
*     Process include
      process_form_include( l_t_token[ <l_s_statement>-from + 1 ]-str ).
    endif.
  endloop.

* Append the include source to the modified_source in case something was removed
  if l_opco_removed = abap_true.
    append value #( name = include  source = new #( l_t_src ) ) to me->m_repl_source.
  endif.

endmethod.


method QUALIFY_TOKENS by kernel module ab_km_qualify_tokens ignore.
endmethod.


method RESET.
  clear M_INCLNAME.
  clear M_MAINPROG.
  clear M_PROGTYPE.
  clear M_SRCDATE.
  clear M_SRCTIME.
  clear M_MAINSRC.
  clear M_COMPL_RESULT.
  clear M_REPOS_REQUESTS.
  clear M_YPOS.
  clear M_XPOS.
endmethod.


method SCAN_ABAP_DOC.

  DATA: tokens    TYPE CL_ABAP_DOC_SCANNER=>tt_token,
        entry     type ts_abapdoc_subentry.
  field-symbols:
        <token>   like line of tokens,
        <comment> type string.

  if abapdoc is initial.
    return.
  endif.

* tokenize ABAP doc
  CL_ABAP_DOC_SCANNER=>TOKENIZE(
    EXPORTING
      comment = abapdoc
    importing
      tokens  = tokens
  ).

* analyze ABAP doc
  assign comment to <comment>.
  loop at tokens assigning <token>.
    case <token>-type.
      when CL_ABAP_DOC_SCANNER=>ABAP_DOC_SYMBOL.
        case <token>-str.
          when '@'.
            if entry is not initial.
              insert entry into table subentities.
              clear entry.
            endif.
          when '|'.
            assign entry-comment to <comment>.
        endcase.
      when CL_ABAP_DOC_SCANNER=>ABAP_DOC_KEYWORD.
        case <token>-str.
          when 'parameter'.
            entry-kind = sccmp_cat_field.
          when 'raising' or 'exception'.
            entry-kind = sccmp_cat_exception.
        endcase.
      when CL_ABAP_DOC_SCANNER=>ABAP_DOC_ARGUMENT.
        entry-identifier = to_upper( <token>-str ).
      when CL_ABAP_DOC_SCANNER=>ABAP_DOC_TEXT.
        data(addcomm) = condense( val = <token>-str del = ` ` ).
        if <comment> is initial.
          <comment> = addcomm.
        elseif addcomm is not initial.
          concatenate <comment> addcomm into <comment> SEPARATED BY space.
        endif.
    endcase.
  endloop.
  if entry is not initial.
    insert entry into table subentities.
  endif.

endmethod.


method X_TABLE_TO_STRING by kernel module ab_km_xtab2string fail.
endmethod.


method X_TABLE_TO_S_TABLE by kernel module ab_km_xtab2stab fail.
endmethod.
ENDCLASS.
