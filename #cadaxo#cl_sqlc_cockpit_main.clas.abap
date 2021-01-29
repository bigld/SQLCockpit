class /CADAXO/CL_SQLC_COCKPIT_MAIN definition
  public
  create public .

public section.

  types:
    t_symbol_db TYPE TABLE OF /cadaxo/sqlcusym .
  types:
    gtt_char255 TYPE TABLE OF char255 .
  types:
    t_string    TYPE TABLE OF string .

  constants C_CMD_CREATE_SYMBOL type UI_FUNC value 'CREATE_SYMBOL' ##NO_TEXT.
  constants C_CMD_HOME type UI_FUNC value 'HOME' ##NO_TEXT.
  constants C_CMD_INSERT_CDS_ENTITY type UI_FUNC value 'INSERT_CDS_ENTITY' ##NO_TEXT.
  constants C_CMD_INSERT_SY_FIELD type UI_FUNC value 'INSERT_SY_FIELD' ##NO_TEXT.
  constants C_CMD_INSERT_TABLE type UI_FUNC value 'INSERT_TABLE' ##NO_TEXT.
  constants C_CMD_JOBMONITOR type UI_FUNC value 'JOBMONITOR' ##NO_TEXT.
  constants C_CMD_PP type UI_FUNC value 'PP' ##NO_TEXT.
  constants C_CMD_RESULT_FOOTER_HIDE type UI_FUNC value 'HIDE_FOOTER' ##NO_TEXT.
  constants C_CMD_RESULT_FOOTER_SHOW type UI_FUNC value 'SHOW_FOOTER' ##NO_TEXT.
  constants C_CMD_RESULT_TOOLBAR_HIDE type UI_FUNC value 'HIDE_RESULT_TOOLBAR' ##NO_TEXT.
  constants C_CMD_RESULT_TOOLBAR_SHOW type UI_FUNC value 'SHOW_RESULT_TOOLBAR' ##NO_TEXT.
  constants C_CMD_SHOW_FULL_VALUE type UI_FUNC value 'SHOW_FULL_VALUE' ##NO_TEXT.
  constants C_CMD_SHOW_RESULT_TABLE type UI_FUNC value 'SHOW_RESULT_TABLE' ##NO_TEXT.
  constants C_CMD_SHOW_SAVED_LISTS type UI_FUNC value 'SHOW_SAVED_LISTS' ##NO_TEXT.
  constants C_CMD_SHOW_VALUE_AS type UI_FUNC value 'SHOW_VALUE_AS' ##NO_TEXT.
  constants C_CMD_SHOW_VALUE_AS_HTML_BROW type UI_FUNC value 'SHOW_VALUE_AS_HTML_BROW' ##NO_TEXT.
  constants C_CMD_SHOW_VALUE_AS_XML_BROW type UI_FUNC value 'SHOW_VALUE_AS_XML_BROW' ##NO_TEXT.
  constants C_OKCODE_CLIPBOARD type SYUCOMM value 'CLIPBOARD' ##NO_TEXT.
  constants C_OKCODE_SYMBOLS type SYUCOMM value 'SYMBOL' ##NO_TEXT.
  constants C_SAVED_LIST_SHARE type STB_BUTTON-FUNCTION value 'SAVED_LIST_SHARE' ##NO_TEXT.
  constants C_SAVED_LIST_SHARE_OTH type STB_BUTTON-FUNCTION value 'SAVED_LIST_SHARE_OTH' ##NO_TEXT. "+COCKPIT420
  constants C_SAVED_LIST_SHARE_ME type STB_BUTTON-FUNCTION value 'SAVED_LIST_SHARE_ME' ##NO_TEXT. "+COCKPIT420
  constants C_SQLEDITOR_NAME type STRING value 'CADAXO_SQL_EDITOR' ##NO_TEXT.
  constants GC_SAVED_LIST_SHARED type /CADAXO/SQLC_LIST_TYPE value 'SHR' ##NO_TEXT.
  constants GC_SAVED_LIST_JOB type /CADAXO/SQLC_LIST_TYPE value 'JOB' ##NO_TEXT.
  constants GC_SAVED_LIST_MANUALLY type /CADAXO/SQLC_LIST_TYPE value 'MAN' ##NO_TEXT.
  constants GC_SYMBOL_SEPARATOR type CHAR3 value '###' ##NO_TEXT.
  class-data GT_USED_SYMBOLS type /CADAXO/SQLCUSEDSYMBOLS_T .
  class-data TOOLBAR_COL_WIDTH type INT4 read-only .
  class-data TOOLBAR_ROW_HEIGHT type INT4 read-only .
  data DRAGDROP_HANDLE type I .
  data DREF_RESULT_TAB_T type /CADAXO/SQLC_DREF_RESULT_TAB_T .
  data GC_ABAP_PARSER type ref to CL_ABAP_PARSER .
  data GC_SPLITTER_TOP_TOOLBAR type ref to CL_GUI_TOOLBAR .
  data GR_USER_LOG type ref to /CADAXO/CL_SQLC_USER_LOG .
  data GT_CL_SQL_PARSE type /CADAXO/SQLC_CL_COCKPIT_PARSET .
  data GT_CL_SQL_PARSE_HOLD type /CADAXO/SQLC_CL_COCKPIT_PARSET .
  data GT_ERRORS type /CADAXO/SQLCSYNTAXERROR_T .
  data GT_LVC_T_FCAT type FIELDCAT1 .
  data GT_LVC_T_FCAT_HOLD like GT_LVC_T_FCAT .
  data GT_RESULT_DETAILS type /CADAXO/SQLCRESULT_DETAILS_T .
  data GT_RESULT_DETAILS_HOLD like GT_RESULT_DETAILS .
  data GT_RESULT_TAB_HOLD like DREF_RESULT_TAB_T .
  data G_AUTH type /CADAXO/SQLCROLE_AUTH_XML .
  data G_MY_MAIN_ID type I read-only .
  data G_SQL_POS type I .
  data G_SQL_PROGRESS_ON type BOOLEAN .
  data G_SQL_TRACE_ON type BOOLEAN .
  data G_USER_SETTINGS type /CADAXO/SQLCUSRP_DYN .
  data MS_USER_SETTINGS_XML type /CADAXO/SQLCUSRP_XML read-only .
  data MV_TOOLBAR_RESULT_ACTIVE type UI_FUNC read-only value C_CMD_HOME ##NO_TEXT.
  data G_TRSTART_UZEIT type SYST_UZEIT .
  data G_TRSTART_DATUM type SYST_DATUM .
  data GT_CL_SQL_PARSE_BEFTEMPGEN type /CADAXO/SQLC_CL_COCKPIT_PARSET .

  events SETTINGS_CHANGED_UPTO
    exporting
      value(I_NEW_UPTO) type /CADAXO/SQLCMAXSEL .

  class-methods CALCULATE_HEIGHT_FOR_BUTTON
    returning
      value(E_HEIGHT) type INT4 .
  class-methods CALCULATE_WIDTH_FOR_BUTTON
    returning
      value(E_WIDTH) type INT4 .
  class-methods API_EXECUTE_SQL
    importing
      !I_SQL_STRING type /CADAXO/SQLCSQL_STRING
    exporting
      !ET_TABLE_REF type /CADAXO/SQLCRESULT_REF_T .
  class-methods CHECK_ADMIN_AUTH
    returning
      value(R_TRUE) type CHAR1 .
  class-methods CLASS_CONSTRUCTOR .
  class-methods EXECUTE_SQL_BACKGROUND
    importing
      !I_LIST_GUID type /CADAXO/SQLC_LISTGUID .
  class-methods MATCH_SAVED_FIELDCAT_ORIG
    importing
      !IT_FCAT type LVC_T_FCAT
      !I_TABNAME type TABNAME
      !IT_RESULT_TABLE type ANY
    returning
      value(RT_FCAT) type LVC_T_FCAT .
  class-methods MATCH_SAVED_FILTER
    importing
      !IT_FILTER type LVC_T_FILT
      !I_TABNAME type TABNAME
      !IT_RESULT_TABLE type ANY
    returning
      value(RT_FILTER) type LVC_T_FILT .
  class-methods MATCH_SAVED_SORT
    importing
      !IT_SORT type LVC_T_SORT
      !I_TABNAME type TABNAME
      !IT_RESULT_TABLE type ANY
    returning
      value(RT_SORT) type LVC_T_SORT .
  class-methods SET_GT_USED_SYMBOLS
    importing
      !I_USED_SYMBOLS type /CADAXO/SQLCUSEDSYMBOLS_T .
  class-methods TRIGGER_HTML
    importing
      !I_HTML_ID type /CADAXO/SQLCPARAMETER_ID default 'HTML_STARTUP'
      !I_MAIN_REF_ID type I .
  methods CHECK_SQL_SYNTAX
    importing
      !I_USE_LOCAL_PARSER type CHAR1 optional
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR
      /CADAXO/CX_SQLC_INVALID_VALUE .
  methods CONSTRUCTOR .
  methods GET_CONTENT
    importing
      !I_HTML_ID type /CADAXO/SQLCPARAMETER_ID default 'HTML_STARTUP'
      !I_VIEWER type ref to CL_GUI_HTML_VIEWER optional
      !I_MIME type FLAG default SPACE
    exporting
      !ET_CONTENT type GTT_CHAR255
      !E_SIZE type INT4
      !E_ASSIGEND_URL type C
      !E_HTML_STRING type STRING .
  methods GET_SQL_AREA
    exporting
      !E_CODE_STRING type STRING
      !E_CODE_STRING_CR type STRING
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
  methods GET_SQL_HIST_LINES
    returning
      value(R_SQL_HIST_LINES) type I .
  methods IS_RESULT_FILLED
    returning
      value(R_FILLED) type ABAP_BOOL .
  methods PAI_0100
    importing
      !I_OK_CODE type SY-UCOMM .
  methods PAI_0700
    importing
      !I_OK_CODE type SY-UCOMM .
  methods PAI_0800
    importing
      !I_OK_CODE type SY-UCOMM
      !I_SQLCSRES type /CADAXO/SQLCSRES .
  methods PAI_3000
    importing
      !I_OK_CODE type SY-UCOMM .
  methods PAI_2000
    importing
      !I_OK_CODE type SY-UCOMM .
  methods PARAM_REPLACE_TAGS
    changing
      !DATA type STRING .
  methods PBO_0100 .
  methods PBO_0700 .
  methods PBO_0800 .
  methods PBO_3000 .
    "! PBO for Dynpro 2000
  methods PBO_2000 .
  methods SAVE_CLIPBOARD .
  methods SET_CLIPBOARD_ALV .
    "! get sql area
    "! @parameter planetype | Type of plane
  methods GET_SQL_AREA_LT_CODE
    returning
      value(R_LT_CODE) type /CADAXO/SQLCCODELINE_T .
  methods SET_SYMBOL_ALV .
  methods SET_USER_SETTINGS
    importing
      !I_SETTINGS type /CADAXO/SQLCUSRP_DYN .
  methods HANDLE_MSG_EXCEPTION
    importing
      !I_MSG type STRING
      !I_EXCEPTION type ref to CX_ROOT .
  methods PREPARE_RESULT_TABLE
    importing
      !IS_SQLCSRES type /CADAXO/SQLCSRES
      !IS_SQLCRESS type /CADAXO/SQLCRESS .
  methods GET_CSV_FROM_INT_TAB
    importing
      !IT_TABLE type ANY TABLE
      !I_GRID_I type I
    exporting
      !EV_OUTPUT_CSV type T_STRING .
  methods GET_CSV_LINE_FROM_TAB
    importing
      !IT_CSV_TAB type T_STRING
    returning
      value(RV_CSV_LINE) type STRING .
  methods CREATE_SYMBOL_DB
    importing
      !IT_SYMBOL_CREATE type T_SYMBOL_DB
    returning
      value(RV_SUCCESS) type BOOLEAN .
  methods GET_CSV_FROM_INT_TAB_CUST
    importing
      !IT_TABLE type ANY TABLE
      !I_GRID_I type I
    exporting
      !EV_OUTPUT_CSV type T_STRING
      !EV_CANCEL type ABAP_BOOL .
protected section.

  data G_TRSTART_TIMESTAMP type TIMESTAMP .
  class-data GCONT_SPLITTER_TOP_TOOLBAR type ref to CL_GUI_CONTAINER .
  class-data:
    gt_item_vari               TYPE STANDARD TABLE OF mtreeitm WITH DEFAULT KEY .
  class-data GT_NODE_VARI type TREEV_NTAB .
  data DRAGDROP_BEHAVIOUR_ALV type ref to CL_DRAGDROP .
  data DRAGDROP_BEHAVIOUR_CLIPBOARD type ref to CL_DRAGDROP .
  data DRAGDROP_BEHAVIOUR_EDITOR type ref to CL_DRAGDROP .
  data DRAGDROP_BEHAVIOUR_ELEMENTINFO type ref to CL_DRAGDROP .
  data DRAGDROP_BEHAVIOUR_LOG type ref to CL_DRAGDROP .
  data DRAGDROP_BEHAVIOUR_SYMBOL type ref to CL_DRAGDROP .
  data DRAGDROP_HANDLE_ELEMENTINFO type I .
  data DRAGDROP_HANDLE_LOG type I .
  data DRAGDROP_HANDLE_SYMBOL type I .
  data GCONT_ABAP_EDITOR type ref to CL_GUI_CONTAINER .
  data GCONT_ABAP_ERROR type ref to CL_GUI_CONTAINER .
  data GCONT_ABAP_SPLITTER type ref to CL_GUI_CONTAINER .
  data GCONT_ALV_QUEUE type ref to CL_GUI_CUSTOM_CONTAINER .
  data GCONT_ALV_TEMPLATE type ref to CL_GUI_CUSTOM_CONTAINER .
  data GCONT_CLIPBOARD type ref to CL_GUI_CONTAINER .
  data GCONT_CLIPBOARD_TEXTEDIT type ref to CL_GUI_CONTAINER .
  data GCONT_CLIPBOARD_TOOLBAR type ref to CL_GUI_CONTAINER .
  data GCONT_CLIPBOARD_TOOLBAR_BTNS type ref to CL_GUI_CONTAINER .
  data GCONT_CLIPBOARD_TOOLBAR_IMG type ref to CL_GUI_CONTAINER .
  data GCONT_ELEMENTINFO type ref to CL_GUI_CONTAINER .
  data GCONT_GRID_ELEMENTINFO_T type /CADAXO/SQLCCLGUICONTAINER_T .
  data GCONT_GRID_RESULTS type ref to CL_GUI_CONTAINER .
  data GCONT_GRID_RESULT_T type /CADAXO/SQLCCLGUICONTAINER_T .
  data GCONT_GRID_SYMBOL_T type /CADAXO/SQLCCLGUICONTAINER_T .
  data GCONT_RESULT_BOTTOM type ref to CL_GUI_CONTAINER .
  data GCONT_RESULT_TOOLBAR type ref to CL_GUI_CONTAINER .
  data GCONT_SPLITTER_BOTTOM type ref to CL_GUI_CONTAINER .
  data GCONT_SPLITTER_TOP type ref to CL_GUI_CONTAINER .
  data GCONT_SYMBOL type ref to CL_GUI_CONTAINER .
  data GCONT_SYMBOL_TOOLBAR type ref to CL_GUI_CONTAINER .
  data GCONT_SYMBOL_TOOLBAR_BTNS type ref to CL_GUI_CONTAINER .
  data GCONT_SYMBOL_TOOLBAR_IMG type ref to CL_GUI_CONTAINER .
  data GCONT_TOOLBAR_ELEMENTINFO type ref to CL_GUI_CONTAINER .
  data GC_ABAP_EDITOR type ref to /CADAXO/CL_SQLC_GUI_ABAPEDIT .
  data GC_ABAP_EDITOR_TEXT type ref to CL_GUI_TEXTEDIT .
  data GC_ABAP_ERROR type ref to CL_GUI_ALV_GRID .
  data GC_ALV_QUEUE_3000 type ref to CL_GUI_ALV_GRID .
  data GC_ALV_TEMPLATE_2000 type ref to CL_GUI_ALV_GRID .
  data GC_CLIPBOARD_TEXTEDIT type ref to CL_GUI_TEXTEDIT .
  data GC_CLIPBOARD_TOOLBAR type ref to CL_GUI_TOOLBAR .
  data GC_CLIPBOARD_TOOLBAR_IMG type ref to CL_GUI_PICTURE .
  data GC_ELEMENTINFO_ALV type ref to CL_GUI_ALV_GRID .
  data GC_HTML_VIEWER type ref to CL_GUI_HTML_VIEWER .
  data GC_RESULT_TOOLBAR type ref to CL_GUI_TOOLBAR .
  data GC_SPLITTER type ref to CL_GUI_SPLITTER_CONTAINER .
  data GC_SYMBOL_ALV type ref to CL_GUI_ALV_GRID .
  data GC_SYMBOL_TOOLBAR type ref to CL_GUI_TOOLBAR .
  data GC_SYMBOL_TOOLBAR_IMG type ref to CL_GUI_PICTURE .
  data GS_SPLITTER_BOTTOM type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_CLIPBOARD type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_EDITOR type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_LVL0 type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_RESULTS type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_RESULTS_TAB type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_RESULTS_TABDAT type ref to CL_GUI_SPLITTER_CONTAINER .
  data GR_RESULTS_TAB_TOOLBAR type ref to CL_GUI_TOOLBAR .
  data GS_SPLITTER_RES_BUTTON type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_SYMBOL type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_SYMBOL_TOOLBAR type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_TOOLBAR type ref to CL_GUI_SPLITTER_CONTAINER .
  data GS_SPLITTER_TOP type ref to CL_GUI_SPLITTER_CONTAINER .
  data GT_CLIPBOARD type /CADAXO/SQLCCLIPBOARD_T .
  data GT_QUEUE type /CADAXO/SQLCAPI_QUEUE_T .
  data GT_SOURCE_RUNTIME_BEFORE type /CADAXO/SQLCCODELINE_T .
  data GT_SQL_HIST type /CADAXO/SQLCHISTLINE_T .
  data:
    gt_sql_log TYPE TABLE OF /cadaxo/sqlclog .
  data GT_TEMPLATES type /CADAXO/SQLCTEMP_ALV_T .
  data GT_TOOLBUTTONS_TOP type TTB_BUTTON .
  data GT_VARIANT type /CADAXO/SQLCVARI_ALV_T .
  data GV_EXPORT_TYPE type /CADAXO/SQLCAPI_POSITION_TYP .
  data G_CLIENT_CATEGORY type CCCATEGORY .
  data G_CLIENT_LOGSYS type LOGSYS .
  data G_CONT_PERS_PREFERENCES type CHAR1 .
  data G_HEIGHT type I .
  data G_HISTORY_TOOLBAR_EXCLUDING type UI_FUNCTIONS .
  data G_JOBMONITOR_TOOLBAR_EX type UI_FUNCTIONS .
  data G_RESULT_LAYOUT type LVC_S_LAYO .
  data G_RESULT_TOOLBAR_EXCLUDING type UI_FUNCTIONS .
  data G_SHOW_CLIPBOARD type BOOLEAN .
  data GS_SEL_VARIANT type /CADAXO/SQLC_IL_VARIANTS . "Cockpit-321
  data:
    BEGIN OF ms_additional_functions,                 "COCKPIT-48
        uptomenu TYPE REF TO /cadaxo/cl_sqlc_uptomenu,  "COCKPIT-48
      END OF ms_additional_functions .
  data GT_SAVED_LIST_FIELDCAT type LVC_T_FCAT .
  data G_SAVED_LIST_GUI_CONTAINER type ref to CL_GUI_CUSTOM_CONTAINER .
  data G_ACTIVE_LIST_TAB type I .

  methods CHECK_DBTABLE_MODIFICATION
    returning
      value(R_ANSWER) type CHAR1 .
  methods CREATE_SYMBOL_MULTIVAL_TAB_DYN
    importing
      !I_SYMBOL_DATATYPE type /CADAXO/SQLCSYMBOL_DATATYPE
    exporting
      !E_DATA type DATA
      !E_DATA_STRUCT type DATA .
  methods GET_SYMBOL_DATATYPE_DESC
    importing
      !I_DATATYPE type /CADAXO/SQLCSYMBOL_DATATYPE
    returning
      value(R_DESC) type AS4TEXT .
  methods GET_SYMBOL_DATATYPE_INFO
    importing
      !I_DATATYPE type /CADAXO/SQLCSYMBOL_DATATYPE
    returning
      value(R_INFO) type /CADAXO/SQLCSYMBOL_DATAINFO .
  methods CHECK_SYMBOL_DATATYPE
    importing
      !I_VALUE type LVC_VALUE
    raising
      /CADAXO/CX_SQLC_SYMB_NOT_FOUND .
  methods SHOW_SYMBOLMULTI_DIALOG
    importing
      !I_SYMBOL_MULTIVALUE type /CADAXO/SQLCSYMBOL_MULTIVALUE
      !I_SYMBOL_DATATYPE type /CADAXO/SQLCSYMBOL_DATATYPE
    returning
      value(R_SYMBOL_VALUE) type RSELOPTION
    raising
      /CADAXO/CX_SQLC_SYMB_NOT_FOUND .
  methods ON_SYMBOL_BUTTON_CLICK
    for event BUTTON_CLICK of CL_GUI_ALV_GRID
    importing
      !ES_COL_ID
      !ES_ROW_NO .
  methods GET_USER_SYMBOL_COUNT
    importing
      !I_SYMBOL_MULTIVALUE type /CADAXO/SQLCSYMBOL_MULTIVALUE
    returning
      value(R_COUNT) type I .
  methods ERROR_CALC_HEIGHT
    importing
      !IV_ERRORS type I
    returning
      value(EV_HEIGHT) type I .
  class-methods BUILD_RESULT_GRID_FOOTER
    importing
      !IV_SYST type SYSYSID
      !IV_MANDANT type /CADAXO/SQLC_MANDT
      !IV_UNAME type UNAME
      !IV_CREATE_TIMESTAMP type TIMESTAMPL
    returning
      value(R_GRID_FOOTER) type /CADAXO/SQLCRESULT_FOOTER .
  class-methods BUILD_RESULT_GRID_TITLE
    importing
      !I_RUNTIME type I
      !I_LINES type I
      !I_MESSAGE type STRING optional
    returning
      value(R_GRID_TITLE) type LVC_TITLE .
  methods INSERT_SAVED_LIST
    importing
      !IT_SAVED_LIST type /CADAXO/SQLC_LIST_EXP_SQLX_T
    returning
      value(EV_UPDATE_OK) type ABAP_BOOL .
  methods CALC_RESULT_ROWS_AND_COLS
    importing
      !I_LINES type I
    exporting
      !E_ROWS type I
      !E_COLS type I .
  methods CONFIRM_SYMBOL_OVERWRITE .
  methods CREATE_CLIPBOARD_UI_CONTROL .
  methods CREATE_CONTROLS .
  methods CREATE_DYN_DOCUMENT
    importing
      !I_PARENT type ref to CL_GUI_CONTAINER
      value(I_SQL) type STRING
      !I_HEADER_TEXT type CHAR255 optional
    changing
      !IC_DOCUMENT type ref to CL_DD_DOCUMENT .
  methods CREATE_EDITOR_UI_CONTROL .
  methods CREATE_PRIMARY_UI_CONTROLS .
  methods CREATE_RESULT_UI_CONTROLS .
  methods CREATE_ELEMENTINFO_UI_CONTROL .
  methods CREATE_SYMBOL_UI_CONTROL .
  methods CREATE_VARIANT .
  methods DELETE_LOG .
  methods DELETE_SYMBOLS
    exporting
      !E_SUCCESS type BOOLEAN .
  methods EXECUTE_SQL
    importing
      !I_PROGRESS_INDICATOR type CHAR1 optional
    preferred parameter I_PROGRESS_INDICATOR
    raising
      /CADAXO/CX_SQLC_TO_MUCH_RESROW
      /CADAXO/CX_SQLC_INVALID_VALUE
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
  methods EXECUTE_SQL_BACKGROUND_WIZ .
  methods FOCUS_SYMBOL_ALV_CELL
    importing
      !I_ROW_ID type LVC_INDEX
      !I_FIELD_NAME type LVC_FNAME .
  methods FREE_RESULT_CONTROLS .
  methods GET_LINK
    importing
      !I_HTML_ID type /CADAXO/SQLCPARAMETER_ID
    exporting
      !E_URL type C
    changing
      !CT_CACHE type GTT_CHAR255 .
  methods GET_SAVED_RESULTS
    importing
      !I_RESS_GUID type /CADAXO/SQLC_RESS_GUID_T optional
      !I_CLEAR_OLD_ALVS type FLAG optional
    preferred parameter I_RESS_GUID .
  methods GET_SYMBOLS_SELECTED
    exporting
      value(E_SUCCESS) type BOOLEAN .
  methods GET_SYMBOLS .
  methods GET_USER_SYMBOL_FROM_SQL
    importing
      !I_VARGUID type /CADAXO/SQLC_VARIANT_GUID optional
      !I_SQL type /CADAXO/SQLCCODELINE_T
      !I_TYPE type CHAR1
    exporting
      !E_SYMBOLS type /CADAXO/SQLC_SYMBOL_T .
  methods GET_VARIANT .
  methods HANDLE_RESULT_COMMAND_EXP_CSV
    importing
      !I_GRID_I type I .
  methods HANDLE_COMMAND_SHOW_FULL_VALUE
    importing
      !I_GRID_I type I optional
      !I_LOG type ABAP_BOOL optional .
  methods HANDLE_COMMAND_SHOW_HTML_BROW
    importing
      !I_GRID_I type I optional
      !I_LOG type ABAP_BOOL optional .
  methods HANDLE_COMMAND_SHOW_XML_BROW
    importing
      !I_GRID_I type I optional
      !I_LOG type ABAP_BOOL optional .
  methods HANDLE_RESULT_COMMAND_CDXEXP
    importing
      !I_GRID_I type I .
  methods HANDLE_RESULT_COMMAND_CLOSE
    importing
      !I_GRID_I type I .
  methods HANDLE_RESULT_COMMAND_COMPARE
    importing
      !I_SOURCE type I
      !I_TARGET type I .
  methods HANDLE_RESULT_COMMAND_HOLD
    importing
      !I_GRID_I type I .
  methods HANDLE_RESULT_COMMAND_KEYFIX
    importing
      !I_GRID_I type I .
  methods HANDLE_RESULT_COMMAND_REFRLST
    importing
      !I_GRID_I type I .
  methods HANDLE_RESULT_COMMAND_FULLDISP
    importing
      !I_GRID_I type I .
  methods INSERT_CODEBLOCK_AT_POSITION
    importing
      !IV_LINE type I
      !IV_POS type I
      !IV_SQLSTRING type /CADAXO/SQLCSTRING
      !I_SET_FOCUS type ABAP_BOOL default ABAP_FALSE .
  methods INSERT_TABLE_TO_EDITOR
    importing
      !I_STRING type STRING .
  methods LOAD_HOME_HTML .
  methods MOVE_BACK_TO_SQL .
  methods MOVE_FORW_TO_SQL .
  methods ON_ABAP_ERROR_HOTSPOT_CLICK
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW_ID
      !E_COLUMN_ID
      !ES_ROW_NO .
  methods ON_ALV_DRAG
    for event ONDRAG of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO
      !E_DRAGDROPOBJ .
  methods ON_ALV_RESULT_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods ON_ALV_QUEUE_DOUBLE_CLICK_3000
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods ON_ALV_TEMPL_DOUBLE_CLICK_2000
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods ON_CLIPBOARD_DROP
    for event ON_DROP of CL_GUI_TEXTEDIT
    importing
      !INDEX
      !LINE
      !DRAGDROP_OBJECT .
  methods ON_EDITOR_CONTEXT_MENU
    for event CONTEXT_MENU of CL_GUI_ABAPEDIT
    importing
      !MENU
      !MENU_TYPE .
  methods ON_EDITOR_CONTEXT_MENU_SEL
    for event CONTEXT_MENU_SELECTED of CL_GUI_ABAPEDIT
    importing
      !FCODE .
  methods ON_EDITOR_DBLCLICK
    for event DBLCLICK of CL_GUI_ABAPEDIT .
  methods ON_EDITOR_DROP
    for event ON_DROP of CL_GUI_ABAPEDIT
    importing
      !INDEX
      !LINE
      !POS
      !DRAGDROP_OBJECT .
  methods ON_EDITOR_TEXT_DROP
    for event ON_DROP of CL_GUI_TEXTEDIT
    importing
      !INDEX
      !LINE
      !POS
      !DRAGDROP_OBJECT .
  methods ON_HANDLE_JOB_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
  methods ON_HANDLE_JOB_USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  methods ON_LOG_ALV_CONTEXT_MENU
    for event CONTEXT_MENU_REQUEST of CL_GUI_ALV_GRID
    importing
      !E_OBJECT .
  methods ON_HANDLE_RESULT_CONTEXT_MENU
    for event CONTEXT_MENU_REQUEST of CL_GUI_ALV_GRID
    importing
      !E_OBJECT .
  methods ON_HANDLE_RESULT_END_OF_PAGE
    for event PRINT_END_OF_PAGE of CL_GUI_ALV_GRID .
  methods ON_HANDLE_RESULT_MENU_BUTTON
    for event MENU_BUTTON of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_UCOMM .
  methods ON_HANDLE_RESULT_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
  methods ON_HANDLE_RESULT_USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  methods ON_HANDLE_SAVEDLISTS_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
  methods ON_HANDLE_SAVEDLISTS_USRCOMMND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  methods ON_HANDLE_VARSYM_CLICK
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW_ID
      !E_COLUMN_ID
      !ES_ROW_NO .
  methods ON_HOME_SAPEVENT
    for event SAPEVENT of CL_GUI_HTML_VIEWER
    importing
      !ACTION
      !FRAME
      !GETDATA
      !POSTDATA
      !QUERY_TABLE .
  methods ON_JOB_ALV_CLICK
    for event BUTTON_CLICK of CL_GUI_ALV_GRID
    importing
      !ES_COL_ID
      !ES_ROW_NO .
  methods ON_JOB_ALV_HOTSPOT_CLICK
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW_ID
      !E_COLUMN_ID
      !ES_ROW_NO .
  methods ON_LOG_ALV_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods ON_LOG_ALV_DRAG
    for event ONDRAG of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO
      !E_DRAGDROPOBJ .
  methods ON_LOG_ALV_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
  methods ON_LOG_ALV_USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  methods ON_RESULT_TOOLBAR_DROPDOWN
    for event DROPDOWN_CLICKED of CL_GUI_TOOLBAR
    importing
      !FCODE
      !POSX
      !POSY .
  methods ON_RESULT_TOOLBAR_FUNCSEL
    for event FUNCTION_SELECTED of CL_GUI_TOOLBAR
    importing
      !FCODE .
  methods ON_TABBAR_TOOLBAR_FUNCSEL
    for event FUNCTION_SELECTED of CL_GUI_TOOLBAR
    importing
      !FCODE .
  methods ON_SAVED_LIST_SELECT_LINE
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods ON_SYMBOL_ALV_DATA_CHANGE
    for event DATA_CHANGED of CL_GUI_ALV_GRID
    importing
      !ER_DATA_CHANGED
      !E_ONF4
      !E_ONF4_BEFORE
      !E_ONF4_AFTER
      !E_UCOMM .
  methods ON_SYMBOL_ALV_DATA_CHANGED_FIN
    for event DATA_CHANGED_FINISHED of CL_GUI_ALV_GRID
    importing
      !E_MODIFIED
      !ET_GOOD_CELLS .
  methods ON_SYMBOL_ALV_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
  methods ON_SYMBOL_ALV_USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  methods ON_ELEMENTINFO_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods ON_SYMBOL_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods ON_ELEMENTINFO_HOTSPOT_DE
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW_ID
      !E_COLUMN_ID
      !ES_ROW_NO .
  methods ON_ELEMENTINFO_DRAG
    for event ONDRAG of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO
      !E_DRAGDROPOBJ .
  methods ON_SYMBOL_DRAG
    for event ONDRAG of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO
      !E_DRAGDROPOBJ .
  methods ON_TOOLBAR_FUNCTION_SELECTED
    for event FUNCTION_SELECTED of CL_GUI_TOOLBAR
    importing
      !FCODE .
  methods ON_TOP_TOOLBAR_DROPDOWN
    for event DROPDOWN_CLICKED of CL_GUI_TOOLBAR
    importing
      !FCODE
      !POSX
      !POSY .
  methods ON_TOP_TOOLBAR_FUNCSEL
    for event FUNCTION_SELECTED of CL_GUI_TOOLBAR
    importing
      !FCODE
      !SENDER .
  methods SAVE_SYMBOLS
    exporting
      !E_SUCCESS type BOOLEAN .
  methods SELECT_JOBDATA .
  methods SEND_SQL_VIA_MAIL .
  methods SET_INITIAL_DATE_HISTORY .
  methods SET_INITIAL_DATE_JOBMONITOR .
  methods SET_RESULT_TOOLBAR_ACTIVE
    importing
      !I_FCODE type UI_FUNC .
  methods SET_SQL_AREA
    importing
      !I_CODELINES_T type /CADAXO/SQLCCODELINE_T .
  methods SHOW_ADMHELP .
  methods SHOW_HTML
    importing
      !I_HTML_ID type /CADAXO/SQLCPARAMETER_ID default 'HTML_STARTUP' .
  methods SHOW_JOBMONITOR .
  methods SHOW_LOG .
  methods SHOW_RESULT .
  methods SHOW_SAVED_LISTS .
  methods STORE_SQL_TO_HIST
    importing
      !I_CODELINES_T type /CADAXO/SQLCCODELINE_T optional .
  methods UPDATE_FIELD_CATALOG_ALV .
  methods USR_ACTION_CLEAR_SQL_AREA .
  methods USR_ACTION_LEAVE_SQL_COCKPIT .
  methods USR_ACTION_PRETTY_PRINTER .
  methods USR_ACTION_SHOW_ABAP_DOCU .
  methods USR_ACTION_SQL_TRACE_ONOFF .
  methods ON_EDITOR_QUICK_INFO
    for event QUICK_INFO of CL_GUI_ABAPEDIT
    importing
      !CONTEXTSTRING
      !DATATYPE
      !XPOS
      !YPOS
      !SENDER .
  methods GET_CURRENT_GRID_NUMBER
    returning
      value(R_GRID_NUMBER) type I .
  methods SAVE_HOLD_LISTS .
  methods ADD_HOLD_LISTS .
  methods DELETE_SYMBOL_DB
    returning
      value(RV_SUCCESS) type BOOLEAN .
  methods UPDATE_SYMBOL_DB
    importing
      value(IT_SYMBOL_UPDATE) type T_SYMBOL_DB
    returning
      value(RV_SUCCESS) type BOOLEAN .
  methods CHECK_SYMBOL_VALUE_VALID
    importing
      !IS_SYMBOL_LINE type /CADAXO/SQLC_SYMBOL
    raising
      /CADAXO/CX_SQLC_INVALID_VALUE .
  methods ON_SYMBOL_BUTTON_VARIANT
    for event BUTTON_CLICK of CL_GUI_ALV_GRID
    importing
      !ES_COL_ID
      !ES_ROW_NO .
  methods SQL_SEARCH .
  methods SQL_SEARCH_NEXT .
  methods LOG_ALV_LINE_SELECTION .
  methods HANDLE_COMMAND_CREATE_SYMBOL
    importing
      !I_GRID_I type I optional .
  methods API_SAVED_LIST_IMPORT
    importing
      !IR_API type ref to /CADAXO/CL_SQLC_COCKPIT_API
      !IS_ITEMS type /CADAXO/SQLCAPIP .
  methods SHARE_SAVED_LIST
    importing
      !IV_RECEIVER type /CADAXO/SQLCAPI_RECEIVER optional   "+cockpit-420
      !IV_TEXT type /CADAXO/SQLC_CHAR_1024 optional .       "+cockpit-420
  methods POPULATE_SAVED_LIST
    importing
      !IV_LIST_GUID type /CADAXO/SQLC_LIST_EXP_SQLX-LIST_GUID
      !IV_SAVED_LIST_SHARED type /CADAXO/SQLC_LIST_EXP_SQLX-TYPE
    returning
      value(RS_SAVED_LIST) type /CADAXO/SQLC_LIST_EXP_SQLX .
  methods GET_SELECTED_ELEM_INF_FLDS
    importing
      !I_INDEX type LVC_INDEX
    returning
      value(R_FIELDS) type STRING .
  methods GET_SAVED_LIST_FIELDCAT
    returning
      value(R_SAVED_LIST_FIELDCAT) type LVC_T_FCAT .
  methods HANDLE_DELETE_SAVED_LISTS .
  methods HANDLE_EXPORT_SAVED_LIST .
  methods ON_SYMBOL_MENU_BUTTON
    for event MENU_BUTTON of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_UCOMM .
  methods ON_SAVED_LIST_MENU_CLICK
    for event MENU_BUTTON of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_UCOMM .
  methods UPDATE_VARIANT .
  methods FILL_USED_SYMBOLS
    returning
      value(RT_SYMBOLS) type /CADAXO/SQLCUSEDSYMBOLS_T .
  methods SHOW_RESULT_TAB .
  methods SHOW_RESULT_TABLE
    importing
      !I_RESULT_DREF type ref to DATA
      !I_TABIX type SY-TABIX .
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF cs_symbol_type,
        user    TYPE char1 VALUE 'U' ##NO_TEXT,
        program TYPE char1 VALUE 'P' ##NO_TEXT,
        create  TYPE char1 VALUE 'C' ##NO_TEXT,
        modify  TYPE char1 VALUE 'M' ##NO_TEXT,
      END OF cs_symbol_type .
    CONSTANTS:
      BEGIN OF cs_windowresolution,
        horizontal TYPE /cadaxo/sqlcreswindorientation VALUE 'H' ##NO_TEXT,
        vertical   TYPE /cadaxo/sqlcreswindorientation VALUE 'V' ##NO_TEXT,
        matrix     TYPE /cadaxo/sqlcreswindorientation VALUE 'M' ##NO_TEXT,
        tab        type /cadaxo/sqlcreswindorientation value 'T' ##NO_TEXT,
      END OF cs_windowresolution .
    CONSTANTS c_cmd_show_log TYPE string VALUE 'SHOW_LOG ' ##NO_TEXT.
    CONSTANTS c_program_symbols_hide TYPE flag VALUE space ##NO_TEXT.
    CONSTANTS c_program_symbols_show TYPE flag VALUE 'X' ##NO_TEXT.
    CONSTANTS c_symbol_type TYPE /cadaxo/sqlcapi_position_typ VALUE '3' ##NO_TEXT.
    CONSTANTS c_width_right_clipboard TYPE i VALUE 500 ##NO_TEXT.
    CONSTANTS c_width_right_symbols TYPE i VALUE 500 ##NO_TEXT.
    CONSTANTS c_width_right_window TYPE i VALUE 500 ##NO_TEXT.
    CONSTANTS gc_fcode_csv TYPE ui_func VALUE 'EXPORT_CSV' ##NO_TEXT.
    CLASS-DATA gt_main_classes TYPE gtt_main_classes .
    CLASS-DATA g_main_counter TYPE i .
    DATA gcont_html_viewer TYPE REF TO cl_gui_container .
    DATA gr_alv_symb_ow TYPE REF TO cl_gui_alv_grid .
    DATA gr_cc_alv_symb_ow TYPE REF TO cl_gui_custom_container .
    DATA gt_elementinfo TYPE /cadaxo/sqlc_elementinfo_t .
    DATA gt_headerlines TYPE /cadaxo/sqlcheaderlines_t .
    DATA gt_history_log TYPE /cadaxo/sqlclogalv_t .
    " DATA gt_html_demoversion TYPE gtt_char255 .
    " DATA gt_html_html_startup TYPE gtt_char255 .
    DATA gt_jobs TYPE /cadaxo/sqlcjobsalv_t .
    DATA gt_lvc_s_layo TYPE /cadaxo/sqlc_t_lvc_s_filt .
    DATA gt_lvc_t_filt TYPE /cadaxo/sqlc_t_lvc_t_filt .
    DATA gt_lvc_t_sort TYPE /cadaxo/sqlc_t_lvc_t_sort .
    DATA gt_saved_lists TYPE /cadaxo/sqlcsresalv_t .
    DATA gt_selected_disp TYPE lvc_t_row .
    DATA gt_selected_rows TYPE lvc_t_row .
    DATA gt_symbol TYPE /cadaxo/sqlc_symbol_t .
    DATA gt_symbol_delete TYPE /cadaxo/sqlc_symbol_t .
    DATA gt_symbol_ow TYPE /cadaxo/sqlc_symbol_ow_t .
    DATA gt_symbol_selected TYPE /cadaxo/sqlc_symbol_t .
    DATA gt_toolbuttons_clipboard TYPE ttb_button .
    DATA gt_toolbuttons_result TYPE ttb_button .
    DATA gt_toolbuttons_symbol TYPE ttb_button .
    DATA gv_selected_counter TYPE sy-tabix .
    DATA gv_selected_total TYPE sy-tabix .
    DATA g_abap_editor_type TYPE char1 VALUE 'A' ##NO_TEXT.
    DATA g_auth_sql_cockpit_actvt TYPE activ_auth .
    DATA g_curr_col TYPE lvc_fname .
    DATA g_curr_row TYPE /cadaxo/sqlcsymbol_name .
    DATA g_free_space_kb TYPE int4 .
    DATA g_html_request TYPE c .
    DATA g_is_its TYPE char1 VALUE space ##NO_TEXT.
    DATA g_progress_indicator_msg TYPE string .
    DATA g_sel_hist_timestamp_from TYPE timestamp .
    DATA g_sel_hist_timestamp_to TYPE timestamp .
    DATA g_sel_job_timestamp_from TYPE timestamp .
    DATA g_sel_job_timestamp_to TYPE timestamp .
    DATA g_symbol_toolbar_excluding TYPE ui_functions .
    DATA g_version_nr TYPE string VALUE '3.4' ##NO_TEXT.

    METHODS call_admin .
    METHODS _split_error_text
      IMPORTING
        !is_error  TYPE /cadaxo/sqlcsyntaxerror
      CHANGING
        !ct_errors TYPE /cadaxo/sqlcsyntaxerror_t .
ENDCLASS.



CLASS /CADAXO/CL_SQLC_COCKPIT_MAIN IMPLEMENTATION.


  METHOD add_hold_lists.

    IF lines( gt_cl_sql_parse_hold ) > 0.

      APPEND LINES OF gt_cl_sql_parse TO gt_cl_sql_parse_hold.
      gt_cl_sql_parse = gt_cl_sql_parse_hold.
      APPEND LINES OF dref_result_tab_t TO gt_result_tab_hold.
      dref_result_tab_t = gt_result_tab_hold.
      APPEND LINES OF gt_lvc_t_fcat TO gt_lvc_t_fcat_hold.
      gt_lvc_t_fcat = gt_lvc_t_fcat_hold.
      APPEND LINES OF gt_result_details TO gt_result_details_hold.
      gt_result_details = gt_result_details_hold.

      FREE: gt_cl_sql_parse_hold,
            gt_result_tab_hold,
            gt_lvc_t_fcat_hold,
            gt_result_details_hold.

    ENDIF.

  ENDMETHOD.


  METHOD api_execute_sql.

    DATA: lcl_sqlc_cockpit  TYPE REF TO /cadaxo/cl_sqlc_cockpit_main,
          l_result_details  TYPE /cadaxo/sqlcresult_details,
          ls_sqlcresult_ref TYPE /cadaxo/sqlcresult_ref,
          lt_cl_sql_parse   TYPE /cadaxo/sqlc_cl_cockpit_parset,
          lr_exception      TYPE REF TO cx_static_check.

*    FIELD-SYMBOLS: <l_cl_sql_parse>     TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.

    CREATE OBJECT lcl_sqlc_cockpit.

    TRY.

* parse the sql string
        /cadaxo/cl_sqlc_cockpit_parse=>parse_sql_i(
          EXPORTING
            i_sql           = i_sql_string
            i_user_settings = lcl_sqlc_cockpit->ms_user_settings_xml
            i_role          = lcl_sqlc_cockpit->g_auth
          IMPORTING
            e_sql_parsed    = lt_cl_sql_parse ).

* INSERT SERILIZATION
        DATA: l_xml TYPE string.
        DATA: lr_sql_parse     TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
        IMPORT xml = l_xml FROM MEMORY ID 'ZPARSEXML'.
        IF sy-subrc = 0.
          CALL TRANSFORMATION id
     SOURCE XML l_xml
     RESULT parse = lr_sql_parse.
          APPEND lr_sql_parse TO lt_cl_sql_parse.
        ENDIF.
* INSERT SERILIZATION END
        LOOP AT lt_cl_sql_parse ASSIGNING FIELD-SYMBOL(<lr_cl_sql_parse>).
* INSERT SERILIZATION
          IF <lr_cl_sql_parse>->source_syntax = 'BUT000'.
            CALL TRANSFORMATION id
            SOURCE parse = <lr_cl_sql_parse>
            RESULT XML l_xml.
            EXPORT xml = l_xml TO MEMORY ID 'ZPARSEXML'.
          ENDIF.
* INSERT SERILIZATION END

          <lr_cl_sql_parse>->parse_sql_ii( ).
          <lr_cl_sql_parse>->blacklist_check_tables( ).
          <lr_cl_sql_parse>->parse_sql_where_columns( ).

        ENDLOOP.

        /cadaxo/cl_sqlc_cockpit_parse=>check_sql_syntax( i_sql_parsed = lt_cl_sql_parse ).

        LOOP AT lt_cl_sql_parse ASSIGNING <lr_cl_sql_parse>.

          <lr_cl_sql_parse>->create_alv_field_catalog( i_user_settings   = lcl_sqlc_cockpit->g_user_settings
                                                       i_dragdrop_handle = 0 ).

          <lr_cl_sql_parse>->create_result_structures( ).

          <lr_cl_sql_parse>->execute_select( EXPORTING i_user_settings  = lcl_sqlc_cockpit->ms_user_settings_xml
                                             IMPORTING e_result_details = l_result_details ).

          CLEAR ls_sqlcresult_ref.

          ls_sqlcresult_ref-table_dref = <lr_cl_sql_parse>->result_table.

          APPEND ls_sqlcresult_ref TO et_table_ref.

        ENDLOOP.

* catch exceptions
      CATCH /cadaxo/cx_sqlc_symb_not_found INTO lr_exception.
      CATCH /cadaxo/cx_sqlc_no_sel_at_firs INTO lr_exception.
      CATCH /cadaxo/cx_sqlc_syntax_error INTO lr_exception.
      CATCH /cadaxo/cx_sqlc_no_source INTO lr_exception.
      CATCH cx_sy_open_sql_db.
    ENDTRY.

  ENDMETHOD.


  METHOD api_saved_list_import.

    DATA lt_saved_list TYPE /cadaxo/sqlc_list_exp_sqlx_t.
    ir_api->get_item(
      EXPORTING
        iv_pos_line = is_items
      IMPORTING
        rt_item     = lt_saved_list ).

    DATA(update_ok) =  insert_saved_list( lt_saved_list ).

    IF update_ok = abap_true.
      COMMIT WORK.
      MESSAGE s150(/cadaxo/sqlc) WITH lt_saved_list[ 1 ]-description. "The list &1 has been saved successfully
      me->set_result_toolbar_active( i_fcode = c_cmd_show_saved_lists ).
      me->show_saved_lists( ).
    ELSE.
      ROLLBACK WORK.
      MESSAGE e151(/cadaxo/sqlc) WITH lt_saved_list[ 1 ]-description."Failed to save the list &1.
    ENDIF.

  ENDMETHOD.


  METHOD build_result_grid_footer.
****************************************************************************************************
* Description             : Build the result grid title                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 10.12.2013               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 19.04.2016 | Ana Lekic            | change footer length from 70 to 255         | Jira COCKPIT-4 *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA lv_timestamp             TYPE timestamp.
    DATA lv_date                  TYPE sy-datum.
    DATA lv_time                  TYPE sy-uzeit.
    DATA lv_date_out              TYPE c LENGTH 10.
    DATA lv_time_out              TYPE c LENGTH 8.

    IF iv_syst IS NOT INITIAL.
      CONCATENATE r_grid_footer 'System:'(f02) iv_syst INTO r_grid_footer SEPARATED BY space.
    ENDIF.
    IF iv_mandant IS NOT INITIAL.
      CONCATENATE r_grid_footer 'Client:'(f01) iv_mandant INTO r_grid_footer SEPARATED BY space.
    ENDIF.
    IF iv_uname IS NOT INITIAL.
      CONCATENATE r_grid_footer 'User:'(f05) iv_uname INTO r_grid_footer SEPARATED BY space.
    ENDIF.

    IF iv_create_timestamp IS NOT INITIAL.
      MOVE iv_create_timestamp TO lv_timestamp.
      CONVERT TIME STAMP lv_timestamp TIME ZONE sy-zonlo INTO DATE lv_date TIME lv_time.
      WRITE lv_date TO lv_date_out.
      WRITE lv_time TO lv_time_out.
      CONCATENATE r_grid_footer 'Date:'(f03) lv_date_out 'Time:'(f04) lv_time_out INTO r_grid_footer SEPARATED BY space.
    ENDIF.

    IF r_grid_footer IS INITIAL.
      GET TIME STAMP FIELD lv_timestamp.
      CONVERT TIME STAMP lv_timestamp TIME ZONE sy-zonlo INTO DATE lv_date TIME lv_time.
      WRITE lv_date TO lv_date_out.
      WRITE lv_time TO lv_time_out.

      CONCATENATE 'System:'(f02) sy-sysid 'Client:'(f01) sy-mandt
                  'Date:'(f03) lv_date_out 'Time:'(f04) lv_time_out INTO r_grid_footer SEPARATED BY space.
    ENDIF.

    FREE: lv_timestamp, lv_date, lv_time, lv_date_out, lv_time_out.

  ENDMETHOD.


  METHOD build_result_grid_title.
****************************************************************************************************
* Description             : Build the result grit title                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

* some data definitions
    DATA: l_runtime_str(20).

* build the header: x records ( y microseconds )
    IF i_lines GT 0.
      WRITE i_lines TO r_grid_title.
      SHIFT r_grid_title LEFT DELETING LEADING space.
      CONCATENATE r_grid_title text-i01  INTO r_grid_title SEPARATED BY space.
    ELSE.
      MOVE text-i02 TO r_grid_title. "No records found
    ENDIF.

    WRITE i_runtime TO l_runtime_str.
    CONCATENATE r_grid_title '(' l_runtime_str text-001 ')' INTO r_grid_title SEPARATED BY space.

* add a message to the header
    IF i_message IS SUPPLIED AND NOT i_message IS INITIAL.
      CONCATENATE r_grid_title '-' i_message INTO r_grid_title RESPECTING BLANKS.
    ENDIF.

    CONDENSE r_grid_title.

  ENDMETHOD.


  METHOD calculate_height_for_button.

    e_height = cl_gui_cfw=>compute_metric_from_dynp( metric = cl_gui_control=>metric_pixel x_or_y = 'Y' in = 1 ) + 4.
    IF e_height < 20.
      e_height = 20.
    ENDIF.

  ENDMETHOD.


  METHOD calculate_width_for_button.

    e_width = cl_gui_cfw=>compute_metric_from_dynp( metric = cl_gui_control=>metric_pixel x_or_y = 'X' in = 3 ).

    IF e_width < 30.
      e_width = 30.
    ENDIF.

  ENDMETHOD.


  METHOD calc_result_rows_and_cols.
****************************************************************************************************
* Description             : Calculate result rows/cols                                             *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 04.08.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Defaultvalue 'V' for Result Views           | CDX001-0002    *
*------------+----------------------+---------------------------------------------+----------------*
* 16.07.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | New calculation of rows/columns in matrix   | CDX130-011     *
*------------+----------------------+---------------------------------------------+----------------*
* 17.04.2017 | Domi Bigl            | max row/col for splitter                    | COCKPIT-185    *
****************************************************************************************************


    CONSTANTS: lc_max_rowcol TYPE i VALUE 15.
    DATA: l_calc TYPE p DECIMALS 2.

    IF i_lines > lc_max_rowcol.
      ms_user_settings_xml-reswindoworientation = cs_windowresolution-matrix.
    ENDIF.

    CASE ms_user_settings_xml-reswindoworientation.
      WHEN cs_windowresolution-horizontal.
        e_rows = 1.
        e_cols = i_lines.
      WHEN cs_windowresolution-vertical.
        e_rows = i_lines.
        e_cols = 1.
      WHEN OTHERS.

        l_calc = sqrt( i_lines ).

        CALL FUNCTION 'ROUND'
          EXPORTING
            input  = l_calc
            sign   = 'X'
          IMPORTING
            output = e_rows.

        CALL FUNCTION 'ROUND'
          EXPORTING
            input  = l_calc
            sign   = '+'
          IMPORTING
            output = e_cols.
    ENDCASE.

  ENDMETHOD.


  METHOD call_admin.
    FIELD-SYMBOLS: <l_adm> TYPE any.
    ASSIGN ('(/CADAXO/SQLC_MAIN)G_ADM') TO <l_adm>.
    IF <l_adm> IS ASSIGNED.
      <l_adm> = 'X'.
    ENDIF.

    PERFORM ('ADMIN_SETTINGS') IN PROGRAM /cadaxo/sqlc_main.

  ENDMETHOD.


  METHOD check_admin_auth.
    AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
    IF sy-subrc = 0.
      r_true = 'X'.
    ELSE.
      r_true = space.
    ENDIF.
  ENDMETHOD.


  METHOD check_dbtable_modification.
    DATA lt_tables TYPE TABLE OF string.
    DATA lt_restab TYPE TABLE OF string.
    DATA timestamp TYPE timestamp.

    LOOP AT me->gt_cl_sql_parse INTO DATA(ls_cl_sql_parse).
      IF count( val   = ls_cl_sql_parse->source_syntax
                regex = `(\s\S|^\S)` ) = 1.
        APPEND ls_cl_sql_parse->source_syntax TO lt_tables.
      ELSE.
        SPLIT ls_cl_sql_parse->source_syntax AT space INTO TABLE DATA(itab).
        READ TABLE itab INDEX 1 INTO DATA(lv_first).
        APPEND lv_first TO lt_tables.
        LOOP AT itab INTO DATA(str).
          TRANSLATE str TO UPPER CASE.
          CHECK str EQ 'JOIN'.
          READ TABLE itab INDEX sy-tabix + 1 INTO DATA(tmp).
          TRANSLATE tmp TO UPPER CASE.
          APPEND tmp TO lt_tables.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

    CHECK lt_tables IS NOT INITIAL.
    SORT lt_tables.
    DELETE ADJACENT DUPLICATES FROM lt_tables.

    LOOP AT lt_tables ASSIGNING FIELD-SYMBOL(<table>).

      cl_abap_typedescr=>describe_by_name( EXPORTING p_name = CONV tabname( <table> )
                                           RECEIVING p_descr_ref = DATA(tabletype)
                                           EXCEPTIONS OTHERS = 1 ).
      IF sy-subrc = 0.
        tabletype->get_ddic_header( RECEIVING p_header = DATA(ddic_header)
                                    EXCEPTIONS OTHERS = 2 ).

        IF sy-subrc = 0 and ddic_header-crstamp IS NOT INITIAL.

          timestamp = ddic_header-crstamp.

          CONVERT TIME STAMP timestamp TIME ZONE 'UTC  ' INTO DATE DATA(tmp_date) TIME DATA(tmp_time).
          CONVERT DATE tmp_date TIME tmp_time INTO TIME STAMP timestamp TIME ZONE sy-zonlo.

          IF sy-subrc = 0 AND ( timestamp > me->g_trstart_timestamp ).

            MESSAGE s159(/cadaxo/sqlc) WITH <table> INTO DATA(message).

            RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
              EXPORTING
                textid        = /cadaxo/cx_sqlc_syntax_error=>/cadaxo/cx_sqlc_syntax_error
                message       = message.

          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD check_sql_syntax.
****************************************************************************************************
* Description             : Check SQL Syntax                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 02.05.2011 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Check empty SQL string                      | FOE02052011    *
*------------+----------------------+---------------------------------------------+----------------*
* 22.10.2013 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Check Authorization after syntax check!     | RT164          *
*------------+----------------------+---------------------------------------------+----------------*
* 09.05.2014 | Domi Bigl            | Check prev message on cx_root catch         | RT229          *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002, RT235*
*------------+----------------------+---------------------------------------------+----------------*
* 05.08.2017 | Domi Bigl            | Empty Editor Check expanded                 | COCKPIT-235    *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA lt_cl_sql_parse        TYPE /cadaxo/sqlc_cl_cockpit_parset.
    DATA lt_rest                TYPE scit_rest.
    DATA lr_cl_ci_test_root     TYPE REF TO cl_ci_test_root.

* some data definitions / field symbols
    DATA: l_sql_string              TYPE string,
          l_message                 TYPE string,
          l_message_long            TYPE string,
          l_scx_t100key             TYPE scx_t100key,
          ls_error                  TYPE /cadaxo/sqlcsyntaxerror,
          lr_exception              TYPE REF TO cx_root,
          lr_exception_t100         TYPE REF TO /cadaxo/cx_sqlc_to_much_resrow,
          lr_exception_syntax_error TYPE REF TO /cadaxo/cx_sqlc_syntax_error.

    DATA lt_fieldcat TYPE lvc_t_fcat.

    FIELD-SYMBOLS: <l_cl_sql_parse>  TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse,
                   <lt_cl_sql_parse> TYPE /cadaxo/sqlc_cl_cockpit_parset,
                   <ls_fieldcat>     TYPE LINE OF lvc_t_fcat,
                   <ls_scirestps>    TYPE scir_rest.

    IF i_use_local_parser = abap_true.
      ASSIGN lt_cl_sql_parse TO <lt_cl_sql_parse>.
    ELSE.
      lt_cl_sql_parse = gt_cl_sql_parse.
      ASSIGN gt_cl_sql_parse TO <lt_cl_sql_parse>.
    ENDIF.

* clear slq paraser
    CLEAR <lt_cl_sql_parse>.

* get sql string from editor control
    me->get_sql_area( IMPORTING e_code_string    = l_sql_string ).

    CLEAR: l_message,
           l_message_long,           "CDX
           l_scx_t100key.            "CDX

    TRY.

        IF NOT l_sql_string IS INITIAL
           AND l_sql_string CN cl_abap_char_utilities=>get_simple_spaces_for_cur_cp( ). "COCKPIT-235

          /cadaxo/cl_sqlc_cockpit_assist=>clear_used_symbols_table( ).
          CLEAR gt_used_symbols.

          /cadaxo/cl_sqlc_cockpit_assist=>replace_all_symbols_with_value( CHANGING c_string = l_sql_string ).

          /cadaxo/cl_sqlc_cockpit_parse=>parse_sql_i(
            EXPORTING
              i_sql                       = l_sql_string
              i_user_settings             = me->ms_user_settings_xml
              i_role                      = me->g_auth
              i_main_ref_id               = g_my_main_id
              i_main_ref                  = me
            IMPORTING
              e_sql_parsed                = <lt_cl_sql_parse> ).

          /cadaxo/cl_sqlc_cockpit_parse=>check_sql_syntax(
            EXPORTING
              i_sql_parsed = <lt_cl_sql_parse>
            IMPORTING
              et_rest      = lt_rest ).

          LOOP AT <lt_cl_sql_parse> ASSIGNING <l_cl_sql_parse>.
            <l_cl_sql_parse>->parse_sql_ii( ).
            <l_cl_sql_parse>->parse_sql_where_columns( ).
            <l_cl_sql_parse>->blacklist_check_tables( ).
          ENDLOOP.

        ELSE.
          MESSAGE e103(/cadaxo/sqlc) INTO l_message.

          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
            EXPORTING
              message       = l_message
              /cadaxo/msgid = '/CADAXO/SQLC'
              /cadaxo/msgnr = '103'.
        ENDIF.
* catch exceptions
      CATCH /cadaxo/cx_sqlc_to_much_resrow INTO lr_exception_t100.
        l_message = lr_exception_t100->get_text( ).
        l_message_long = lr_exception_t100->get_longtext( ). "CDX
        l_scx_t100key = lr_exception_t100->if_t100_message~t100key.
        IF l_message IS INITIAL.
          l_message = text-e01.
        ENDIF.
      CATCH /cadaxo/cx_sqlc_syntax_error INTO lr_exception_syntax_error.
        l_message = lr_exception_syntax_error->get_text( ).
        l_message_long = lr_exception_syntax_error->get_longtext( ). "CDX
        l_scx_t100key-msgno = lr_exception_syntax_error->/cadaxo/msgnr.
        l_scx_t100key-msgid = lr_exception_syntax_error->/cadaxo/msgid.
        IF l_message IS INITIAL.
          l_message = text-e01.
        ENDIF.
      CATCH cx_root INTO lr_exception.
        IF lr_exception->previous IS BOUND.                   "RT229
          l_message = lr_exception->previous->get_text( ).              "RT229
          l_message_long = lr_exception->previous->get_longtext( ).     "RT229
        ENDIF.                                                "RT229
        IF l_message IS INITIAL.
          l_message = lr_exception->get_text( ).
          l_message_long = lr_exception->get_longtext( ). "CDX
          IF l_message IS INITIAL.
            l_message = text-e01.
          ENDIF.
        ENDIF.
    ENDTRY.

* clear error table
    CLEAR gt_errors.

    IF NOT l_message IS INITIAL.

      ls_error-text = l_message.
      ls_error-msgtype = icon_red_light.

      IF NOT l_message_long IS INITIAL.
        ls_error-longtext = icon_system_help.
      ENDIF.

      IF NOT l_scx_t100key IS INITIAL.
        ls_error-msgno = l_scx_t100key-msgno.
        ls_error-msgid = l_scx_t100key-msgid.
        ls_error-longtext = icon_display_text.
      ENDIF.

      TRY.
          IF strlen( ls_error-text ) >= 127.

            _split_error_text( EXPORTING is_error  = ls_error
                               CHANGING  ct_errors = gt_errors ).
          ELSE.
            INSERT ls_error INTO TABLE gt_errors.
          ENDIF.

        CATCH cx_sy_range_out_of_bounds.
          APPEND ls_error TO gt_errors.
      ENDTRY.

      gc_abap_error->get_frontend_fieldcatalog( IMPORTING et_fieldcatalog = lt_fieldcat ).
      ASSIGN lt_fieldcat[ fieldname = 'LONGTEXT' ] TO <ls_fieldcat>.
      IF sy-subrc = 0.
        IF ls_error-longtext IS INITIAL.
          <ls_fieldcat>-no_out  = abap_true.
        ELSE.
          <ls_fieldcat>-no_out  = abap_false.
        ENDIF.
        gc_abap_error->set_frontend_fieldcatalog( EXPORTING it_fieldcatalog = lt_fieldcat ).
      ENDIF.

      gc_abap_error->refresh_table_display( ).

      gs_splitter_editor->set_row_height( id = 2 height = toolbar_row_height * 3 ).

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
        EXPORTING
          message = l_message.
    ELSE.

      LOOP AT lt_rest ASSIGNING <ls_scirestps>.

        CLEAR ls_error.

        CREATE OBJECT lr_cl_ci_test_root TYPE (<ls_scirestps>-test).

        CALL METHOD lr_cl_ci_test_root->get_message_text( EXPORTING p_test = <ls_scirestps>-test p_code = <ls_scirestps>-code IMPORTING p_text = l_message ).

        REPLACE '&1' WITH <ls_scirestps>-param1 INTO l_message.
        REPLACE '&2' WITH <ls_scirestps>-param2 INTO l_message.
        REPLACE '&3' WITH <ls_scirestps>-param3 INTO l_message.
        REPLACE '&4' WITH <ls_scirestps>-param4 INTO l_message.

        MOVE l_message TO ls_error-text.
        MOVE icon_yellow_light    TO ls_error-msgtype.

        MOVE icon_display_text     TO ls_error-longtext.

        MOVE <ls_scirestps>-code  TO ls_error-ci_code.
        MOVE <ls_scirestps>-test  TO ls_error-ci_test.

        APPEND ls_error TO gt_errors.

      ENDLOOP.

* refresh table display and set the height to 0
      gc_abap_error->refresh_table_display( ).

      IF lt_rest IS INITIAL.
        gs_splitter_editor->set_row_height( id = 2 height = 0 ).
      ELSE.
        gs_splitter_editor->set_row_height( id = 2 height = toolbar_row_height * 3 ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD check_symbol_datatype.

    DATA ls_dd04l TYPE dd04l.

    SELECT SINGLE datatype, leng FROM dd04l
      INTO CORRESPONDING FIELDS OF @ls_dd04l
      WHERE rollname = @i_value. "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED

    IF sy-subrc = 0.

      IF ls_dd04l-datatype = 'FLTP' OR
         ls_dd04l-datatype = 'STRG' OR
         ls_dd04l-datatype = 'RAWSTRING'.

        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found
          EXPORTING
            textid              = /cadaxo/cx_sqlc_symb_not_found=>datatype_not_allowed
            /cadaxo/datatype    = CONV #( ls_dd04l-datatype )
            /cadaxo/dataelement = CONV #( i_value ).

      ENDIF.

      IF ls_dd04l-leng > 45.

        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found
          EXPORTING
            textid = /cadaxo/cx_sqlc_symb_not_found=>dataelement_longer_than_45.

      ENDIF.

    ELSE.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found
        EXPORTING
          textid              = /cadaxo/cx_sqlc_symb_not_found=>dataelement_not_found
          /cadaxo/dataelement = CONV #( i_value ).

    ENDIF.

  ENDMETHOD.


  METHOD check_symbol_value_valid.

    CONSTANTS: lc_allowed TYPE string VALUE ''' `Ã‚Â´'.
    DATA(lv_symbol_value) = CONV string( is_symbol_line-symbol_value ).
    /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = lv_symbol_value ).

    IF /cadaxo/cl_sqlc_cockpit_assist=>has_code_open_literal( iv_abap_code = lv_symbol_value ).

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value
        EXPORTING
          textid = /cadaxo/cx_sqlc_invalid_value=>open_literal.

    ENDIF.

    IF lv_symbol_value CN lc_allowed AND is_symbol_line-symbol_multivalue IS INITIAL.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value
        EXPORTING
          textid = /cadaxo/cx_sqlc_invalid_value=>too_much_literals.

    ENDIF.

  ENDMETHOD.


  METHOD class_constructor.

    toolbar_row_height = calculate_height_for_button( ).
    toolbar_col_width = calculate_width_for_button( ).

  ENDMETHOD.


  METHOD confirm_symbol_overwrite.
****************************************************************************************************
* Description             : Delete a variant                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 01.11.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 10.11.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    PERFORM confirm_symbol_overwrite IN PROGRAM /cadaxo/sqlc_main IF FOUND.

  ENDMETHOD.


  METHOD constructor.
****************************************************************************************************
* Description             : Constructor                                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 03.02.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 04.08.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Defaultvalue 'V' for Result Views           | CDX001-0002    *
*------------+----------------------+---------------------------------------------+----------------*
* 29.08.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Use the trace user settings                 | CDX001-0008    *
*------------+----------------------+---------------------------------------------+----------------*
* 01.06.2011 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Defautlvalue 2 for Job and Hiostry Days     | CDX001-0023    *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Editor type (new, old or like se80 setting) | CDX130-005     *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
*------------+----------------------+---------------------------------------------+----------------*
* 28.03.2017 | Domi Bigl            | Role Auth Bug                               |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.07.2017 | Harald Wiesinger     | Check reference user for roles              | COCKPIT-172    *
****************************************************************************************************

    DATA: l_sqlcusrp  TYPE /cadaxo/sqlcusrp,
          ls_auth     TYPE /cadaxo/sqlcrole_auth_xml,
          ls_table_ui TYPE /cadaxo/sqlcroled_tab_ui,
          l_xml       TYPE string,
          lt_roles    TYPE TABLE OF /cadaxo/sqlcrole INITIAL SIZE 0.
    DATA: l_rseumod          TYPE rseumod.

    DATA: lwa_main           LIKE LINE OF gt_main_classes.

    DATA ls_refuser TYPE bapirefus.                     "COCKPIT-172
    DATA lt_return  TYPE TABLE OF bapiret2.             "COCKPIT-172
    DATA l_user     TYPE xubname.                       "COCKPIT-172

    FIELD-SYMBOLS: <ls_roles> LIKE LINE OF lt_roles.

    FIELD-SYMBOLS: <l_sqlcdtable_auth>     TYPE /cadaxo/sqlctable_auth.

* get client information
    SELECT SINGLE logsys cccategory
                  FROM t000 INTO (me->g_client_logsys,
                                  me->g_client_category) WHERE mandt = sy-mandt.

* get wizard templates
    SELECT a~template_name b~template_desc
           FROM /cadaxo/sqlctemp AS a LEFT OUTER JOIN
                /cadaxo/sqlctemt AS b ON  b~template_name = a~template_name
                                      AND b~language = sy-langu
                                      INTO TABLE gt_templates
                                      WHERE a~flag_active = abap_true. "#EC CI_BUFFJOIN

* get user preferences
    SELECT SINGLE * FROM /cadaxo/sqlcusrp INTO l_sqlcusrp WHERE uname = sy-uname.
    IF sy-subrc = 0.

      TRY.
          cl_abap_gzip=>decompress_text( EXPORTING gzip_in  = l_sqlcusrp-usrpref
                                         IMPORTING text_out = l_xml ).
        CATCH cx_parameter_invalid_range
              cx_sy_buffer_overflow
              cx_sy_conversion_codepage
              cx_sy_compression_error .                 "#EC NO_HANDLER
      ENDTRY.

* call simple transformation DB -> XML
      TRY.
          CALL TRANSFORMATION id
             SOURCE XML l_xml
             RESULT settings = me->ms_user_settings_xml.

          MOVE: me->ms_user_settings_xml-use_convexit         TO me->g_user_settings-use_convexit,        "Convers Routine
                me->ms_user_settings_xml-show_footer          TO me->g_user_settings-show_footer,         "Show ALV Footer #4093
                me->ms_user_settings_xml-maxsel               TO me->g_user_settings-maxsel,              "Max Rows
                me->ms_user_settings_xml-result_buttons       TO me->g_user_settings-result_buttons,      "Show Result Buttons
                me->ms_user_settings_xml-save_clipboard       TO me->g_user_settings-save_clipboard,      "Save Clipboard
                me->ms_user_settings_xml-result_doubleclick   TO me->g_user_settings-result_doubleclick,  "Result Doubleclick
                me->ms_user_settings_xml-sql_trace            TO me->g_user_settings-sql_trace,           "SQL Trace           "CDX001-0008
                me->ms_user_settings_xml-tablebuffer_trace    TO me->g_user_settings-tablebuffer_trace,   "Tablebuffer Trace   "CDX001-0008
                me->ms_user_settings_xml-symbols_show         TO me->g_user_settings-symbols_show,        "Symbols ALV "CDX001-0020
                me->ms_user_settings_xml-symbols_program_show TO me->g_user_settings-symbols_program_show,"Programsymbols show "CDX001-0020
                me->ms_user_settings_xml-only_used_symbols    TO me->g_user_settings-only_used_symbols,   "CR22-002
                me->ms_user_settings_xml-history_last_x_days  TO me->g_user_settings-history_last_x_days,
                me->ms_user_settings_xml-job_last_x_days      TO me->g_user_settings-job_last_x_days,
                me->ms_user_settings_xml-hd_show_alias        TO me->g_user_settings-hd_show_alias,        "Show alias in header
                me->ms_user_settings_xml-hd_fieldtext_s       TO me->g_user_settings-hd_fieldtext_l,
                me->ms_user_settings_xml-hd_fieldtext_m       TO me->g_user_settings-hd_fieldtext_m,
                me->ms_user_settings_xml-hd_fieldtext_l       TO me->g_user_settings-hd_fieldtext_l,
                me->ms_user_settings_xml-hd_fieldtext_a       TO me->g_user_settings-hd_fieldtext_a,
                me->ms_user_settings_xml-editor_type          TO me->g_user_settings-editor_type,
                me->ms_user_settings_xml-forwnavddleclipse    TO me->g_user_settings-forwnavddleclipse,
                me->ms_user_settings_xml-forwnavdicteclipse   TO me->g_user_settings-forwnavdicteclipse,
                me->ms_user_settings_xml-domaintext           TO me->g_user_settings-domaintext.            "COCKPIT-458

* Column Header - Fieldname or Fieldtext
          CASE me->ms_user_settings_xml-colhd_type.
            WHEN '1' OR space.
              MOVE abap_true TO me->g_user_settings-hd_fieldname.
            WHEN '2'.
              MOVE abap_true TO me->g_user_settings-hd_fieldtext.
          ENDCASE.

* Result Window Orientation
          CASE me->ms_user_settings_xml-reswindoworientation.
            WHEN cs_windowresolution-vertical OR space.
              me->g_user_settings-result_window_vertical   = abap_true.
            WHEN cs_windowresolution-horizontal.
              me->g_user_settings-result_window_horizontal = abap_true.
            when cs_windowresolution-tab.
              me->g_user_settings-result_window_tab = abap_true.
            WHEN OTHERS.
              me->g_user_settings-result_window_matrix     = abap_true.
          ENDCASE.

        CATCH cx_xslt_runtime_error.
* fill default values
          MOVE: abap_true  TO me->g_user_settings-use_convexit,          "Convers Routine
                200        TO me->g_user_settings-maxsel,                "Max Rows
                200        TO me->ms_user_settings_xml-maxsel,            "Max Rows
                abap_true  TO me->g_user_settings-result_buttons,        "Show Result Buttons
                abap_true  TO me->g_user_settings-hd_fieldname,          "Column Header Fieldname
                abap_true  TO me->g_user_settings-result_window_vertical,"Result Views Vertical            "CDX001-0002
                abap_true  TO me->g_user_settings-sql_trace,             "SQL Trace.                       "CDX001-0008
                abap_false TO me->g_user_settings-symbols_show,          "SymbolALV show                   "CDX001-0020
                abap_true  TO me->g_user_settings-symbols_program_show,  "Show Program symbols             "CDX001-0020
                abap_false TO me->g_user_settings-only_used_symbols,     "Show only symbols used in Editor "CR22-002
                abap_true  TO me->g_user_settings-hd_fieldtext_a,
                2          TO me->g_user_settings-history_last_x_days,                                     "CDX001-0023
                2          TO me->g_user_settings-job_last_x_days,                                         "CDX001-0023
                space      TO me->g_user_settings-editor_type.                                             "CDX130-005
      ENDTRY.
    ELSE.
* fill default values
      MOVE: abap_true  TO me->g_user_settings-use_convexit,          "Convers Routine
            200        TO me->g_user_settings-maxsel,                "Max Rows
            200        TO me->ms_user_settings_xml-maxsel,            "Max Rows
            abap_true  TO me->g_user_settings-result_buttons,        "Show Result Buttons
            abap_true  TO me->g_user_settings-hd_fieldname,          "Column Header Fieldname
            abap_true  TO me->g_user_settings-result_window_vertical,"Result Views Vertical       "CDX001-0002
            cs_windowresolution-vertical        TO me->ms_user_settings_xml-reswindoworientation,
            abap_true  TO me->g_user_settings-sql_trace,             "SQL Trace.                  "CDX001-0008
            abap_false TO me->g_user_settings-symbols_show,          "SymbolALV show           "CDX001-0020
            abap_true  TO me->g_user_settings-symbols_program_show,  "Show Program symbols     "CDX001-0020
            abap_false TO me->g_user_settings-only_used_symbols,     "Show only symbols used in Editor "CR22-002
            abap_true  TO me->g_user_settings-hd_fieldtext_a,
            2          TO me->g_user_settings-history_last_x_days,                             "CDX001-0023
            2          TO me->g_user_settings-job_last_x_days,                                 "CDX001-0023
            space      TO me->g_user_settings-editor_type.    "CDX130-005
    ENDIF.

* Special logic editor
    IF me->g_user_settings-editor_type <> space AND
       me->g_user_settings-editor_type <> '01' AND
      me->g_user_settings-editor_type  <> '02'.
      me->g_user_settings-editor_type = space.
    ENDIF.

* set result layout parameters
    IF me->g_user_settings-result_buttons = space.
      me->g_result_layout-no_toolbar = abap_true.
    ELSE.
      me->g_result_layout-no_toolbar = abap_false.
    ENDIF.

* Set default values for result layout (alv)
    me->g_result_layout-cwidth_opt = abap_true.
    me->g_result_layout-sel_mode   = 'D'.
    me->g_result_layout-smalltitle = abap_true.
    me->g_result_layout-detailinit = abap_true.

* Clipboard Off
    me->g_show_clipboard = ' '.

    APPEND cl_gui_alv_grid=>mc_mb_variant    TO me->g_result_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_view_excel TO me->g_result_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_mb_export     TO me->g_result_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_view_lotus TO me->g_result_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_help       TO me->g_result_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_info       TO me->g_result_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_url_copy_to_clipboard TO me->g_result_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_call_abc   TO me->g_result_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_graph      TO me->g_result_toolbar_excluding.

    APPEND cl_gui_alv_grid=>mc_mb_variant    TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_view_excel TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_view_lotus TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_help       TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_info       TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_mb_sum        TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_mb_subtot     TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_graph      TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_detail     TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_mb_view       TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_print      TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_mb_export     TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_find       TO me->g_history_toolbar_excluding.
    APPEND cl_gui_alv_grid=>mc_fc_find_more  TO me->g_history_toolbar_excluding.

    APPEND cl_gui_alv_grid=>mc_mb_variant    TO me->g_jobmonitor_toolbar_ex.
    APPEND cl_gui_alv_grid=>mc_fc_info       TO me->g_jobmonitor_toolbar_ex.
    APPEND cl_gui_alv_grid=>mc_mb_sum        TO me->g_jobmonitor_toolbar_ex.
    APPEND cl_gui_alv_grid=>mc_mb_subtot     TO me->g_jobmonitor_toolbar_ex.
    APPEND cl_gui_alv_grid=>mc_mb_export     TO me->g_jobmonitor_toolbar_ex.
    APPEND cl_gui_alv_grid=>mc_fc_graph      TO me->g_jobmonitor_toolbar_ex.
    APPEND cl_gui_alv_grid=>mc_fc_detail     TO me->g_jobmonitor_toolbar_ex.
    APPEND cl_gui_alv_grid=>mc_mb_view       TO me->g_jobmonitor_toolbar_ex.
    APPEND cl_gui_alv_grid=>mc_fc_print      TO me->g_jobmonitor_toolbar_ex.

* authority checks
    AUTHORITY-CHECK OBJECT 'ZCADXOSQ01' ID 'ACTVT' FIELD '23'.
    IF sy-subrc = 0.
      me->g_auth_sql_cockpit_actvt = '02'. "Change.
    ELSE.
      AUTHORITY-CHECK OBJECT 'ZCADXOSQ01' ID 'ACTVT' FIELD '16'.
      IF sy-subrc = 0.
        me->g_auth_sql_cockpit_actvt = '03'. "Display
        MESSAGE s031(/cadaxo/sqlc).
      ELSE.
        MESSAGE s030(/cadaxo/sqlc).          "No authorization
        SET SCREEN 0. LEAVE SCREEN.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'                    "COCKPIT-172
      EXPORTING                                             "COCKPIT-172
        username = cl_abap_syst=>get_user_name( )           "COCKPIT-172
      IMPORTING                                             "COCKPIT-172
        ref_user = ls_refuser                               "COCKPIT-172
      TABLES                                                "COCKPIT-172
        return   = lt_return.                               "COCKPIT-172

    l_user = cl_abap_syst=>get_user_name( ).
    SELECT b~role b~auth_xml INTO CORRESPONDING FIELDS OF TABLE lt_roles
           FROM /cadaxo/sqlcrolr AS a
                INNER JOIN /cadaxo/sqlcrole AS b
                ON b~role = a~role
           WHERE ( a~uname = l_user OR a~uname = ls_refuser-ref_user ). "#EC CI_BYPASS  "COCKPIT-172
    IF sy-subrc <> 0.
      SELECT * FROM /cadaxo/sqlcrole INTO CORRESPONDING FIELDS OF TABLE lt_roles WHERE role_default <> space.
    ENDIF.

    LOOP AT lt_roles ASSIGNING <ls_roles>.
      CLEAR ls_auth.
      TRY.
          CALL TRANSFORMATION id
             SOURCE XML <ls_roles>-auth_xml
             RESULT auth = ls_auth.

          LOOP AT ls_auth-included ASSIGNING <l_sqlcdtable_auth>.
            CLEAR ls_table_ui.
            MOVE <l_sqlcdtable_auth> TO ls_table_ui-table_auth.
            APPEND ls_table_ui-table_auth TO me->g_auth-included.
          ENDLOOP.
          LOOP AT ls_auth-excluded ASSIGNING <l_sqlcdtable_auth>.
            CLEAR ls_table_ui.
            MOVE <l_sqlcdtable_auth> TO ls_table_ui-table_auth.
            APPEND ls_table_ui-table_auth TO me->g_auth-excluded.
          ENDLOOP.
        CATCH cx_transformation_error.                  "#EC NO_HANDLER
      ENDTRY.
    ENDLOOP.

    SORT me->g_auth-included.
    SORT me->g_auth-excluded.

    DELETE ADJACENT DUPLICATES FROM me->g_auth-included.
    DELETE ADJACENT DUPLICATES FROM me->g_auth-excluded.

    CASE me->g_user_settings-editor_type.
      WHEN space.
* get abap editor type
        CALL FUNCTION 'RS_WORKBENCH_CUSTOMIZING_RESET'.

        CALL FUNCTION 'RS_WORKBENCH_CUSTOMIZING'
          EXPORTING
            choice          = 'WB'
            suppress_dialog = 'X'
          IMPORTING
            setting         = l_rseumod.

        IF l_rseumod-editcntrl <> 'A'.
          me->g_abap_editor_type = ' '.
        ENDIF.
      WHEN '01'.
        me->g_abap_editor_type = 'A'.
      WHEN '02'.
        me->g_abap_editor_type = ' '.
      WHEN OTHERS.
        me->g_abap_editor_type = 'A'.
    ENDCASE.


    ADD 1 TO g_main_counter.
    lwa_main-nr  = g_main_counter.
    lwa_main-ref = me.
    g_my_main_id = g_main_counter.
    APPEND lwa_main TO gt_main_classes.

* set initial dates
    me->set_initial_date_history( ).
    me->set_initial_date_jobmonitor( ).

* Version number
    /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value(
        EXPORTING
          i_parameter_id      = /cadaxo/cl_sqlc_cockpit_assist=>c_param_version
       RECEIVING
         r_parameter_value    = g_version_nr
        EXCEPTIONS
          OTHERS              = 2
             ).


    gr_user_log = NEW #( ).

    ms_additional_functions-uptomenu = NEW #( me->ms_user_settings_xml-maxsel ).
    SET HANDLER ms_additional_functions-uptomenu->on_usersettings_changed FOR me.

*   begin of COCKPIT-371
    me->g_trstart_uzeit = sy-uzeit.
    me->g_trstart_datum = sy-datum.
    get TIME STAMP FIELD me->g_trstart_timestamp.
*   end   of COCKPIT-371

  ENDMETHOD.


  METHOD create_clipboard_ui_control.
****************************************************************************************************
* Description             : create clipboard ui control                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 01.02.2017 | Dusan Sacha          |  Add new splitter to sidebar                |                *
*            |                      |  + image Element Info                       |                *
*------------+----------------------+---------------------------------------------+----------------*
* 28.03.2017 | Domi Bigl            | Clear Clipboard initial hidden              |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

* types, data & field symbols
    DATA: lt_events     TYPE cntl_simple_events,
          l_button_data TYPE stb_button,
          l_stringx     TYPE xstring,
          l_string      TYPE string,
          lt_text       TYPE TABLE OF text255,
          lcl_convin    TYPE REF TO cl_abap_conv_in_ce,
          l_len         TYPE i.
    DATA: lo_splitter_text TYPE REF TO  cl_gui_splitter_container.

* Sidebar image data
    DATA url(255).
    DATA query_table TYPE TABLE OF w3query.
    DATA s_query_table LIKE LINE OF query_table.
    DATA html_table TYPE TABLE OF w3html.
    DATA return_code TYPE w3param-ret_code.
    DATA content_type TYPE  w3param-cont_type.
    DATA content_length TYPE  w3param-cont_len.
    DATA pic_data TYPE TABLE OF w3mime.
    DATA pic_size TYPE i.

* get clipboard container
    gcont_clipboard = gs_splitter_bottom->get_container( row = 1 column = 2 ).
    gcont_clipboard->set_name( 'SP_CCONT_B' ).
* create splitter (textedit & toolbar)
    CREATE OBJECT gs_splitter_clipboard
      EXPORTING
        parent  = gcont_clipboard
        rows    = 1
        columns = 2.

    gs_splitter_clipboard->set_name( 'SP_CB' ).
    DATA(lo_element) =  gs_splitter_clipboard->get_container( row = 1 column = 2 ).
    lo_element->set_name( 'SP_OPTIONS_SP' ).


    DATA ls_adm_cust TYPE /cadaxo/sqlc_admin_cust.
    /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).
*  IF ls_adm_cust-show_element_info = abap_true.
    CREATE OBJECT lo_splitter_text
      EXPORTING
        parent  = lo_element
        rows    = 2
        columns = 1.
    lo_splitter_text->set_name( 'SP_OPTIONS' ).
    gcont_clipboard_textedit = lo_splitter_text->get_container( row = 1 column = 1 ).

    gcont_elementinfo = lo_splitter_text->get_container( row = 2 column = 1 ).
    lo_splitter_text->set_row_height( EXPORTING  id     = 1
                                                 height = toolbar_row_height
                                      EXCEPTIONS OTHERS = 1 ).
*  ELSE.
*    gcont_clipboard_textedit = lo_element.
*  ENDIF.

    gcont_clipboard_toolbar  = gs_splitter_clipboard->get_container( row = 1 column = 1 ).

    gs_splitter_clipboard->set_column_mode( cl_gui_splitter_container=>mode_absolute ).
    gs_splitter_clipboard->set_column_width( id = 1 width = toolbar_col_width ).
    gs_splitter_clipboard->set_column_sash( id = 1 type = 1 value = gs_splitter_clipboard->false  ).

    gs_splitter_bottom->set_column_mode( cl_gui_splitter_container=>mode_absolute ).
    gs_splitter_bottom->set_column_width( id = 2 width = toolbar_col_width ).

* add splitter to toolbar
    CREATE OBJECT gs_splitter_toolbar
      EXPORTING
        parent  = gcont_clipboard_toolbar
        rows    = 2
        columns = 1.

    gs_splitter_toolbar->set_row_sash( id    = 1
                                       type  = gs_splitter_toolbar->type_movable
                                       value = gs_splitter_toolbar->false ).

    gs_splitter_toolbar->set_row_sash( id    = 1
                                       type  = gs_splitter_toolbar->type_sashvisible
                                       value = gs_splitter_toolbar->false ).


    gs_splitter_toolbar->set_row_height( EXPORTING  id     = 1
                                                    height = toolbar_row_height
                                         EXCEPTIONS OTHERS = 1 ).

    gcont_clipboard_toolbar_btns = gs_splitter_toolbar->get_container( row = 1 column = 1 ).
    gcont_clipboard_toolbar_img = gs_splitter_toolbar->get_container( row = 2 column = 1 ).

* load image
    s_query_table-name = '_OBJECT_ID'.
    s_query_table-value = '/CADAXO/SQLC_SIDEBAR_IMG_EL_INFO'.
    APPEND s_query_table TO query_table.

* get image data
    CALL FUNCTION 'WWW_GET_MIME_OBJECT'
      TABLES
        query_string   = query_table
        html           = html_table
        mime           = pic_data
      CHANGING
        return_code    = return_code
        content_type   = content_type
        content_length = content_length
      EXCEPTIONS
        OTHERS         = 3.
    IF sy-subrc = 0.
      pic_size = content_length.
    ENDIF.

* create image url
    CALL FUNCTION 'DP_CREATE_URL'
      EXPORTING
        type     = 'image' ##NO_TEXT
        subtype  = cndp_sap_tab_unknown
        size     = pic_size
        lifetime = cndp_lifetime_transaction
      TABLES
        data     = pic_data
      CHANGING
        url      = url
        ##FM_SUBRC_OK
      EXCEPTIONS
        OTHERS   = 1.

* create control toolbar img
    CREATE OBJECT gc_clipboard_toolbar_img
      EXPORTING
        parent = gcont_clipboard_toolbar_img.

    gc_clipboard_toolbar_img->load_picture_from_url( EXPORTING url = url ).

* create control toolbar clipboard
    CREATE OBJECT gc_clipboard_toolbar
      EXPORTING
        parent       = gcont_clipboard_toolbar_btns
        display_mode = cl_gui_toolbar=>m_mode_vertical.

* add button clipboard show/hide
    l_button_data-function  = c_okcode_clipboard.
    l_button_data-icon      = '@K1@'.
    l_button_data-quickinfo = text-q03.
    l_button_data-butn_type = cntb_btype_button.
    APPEND l_button_data TO gt_toolbuttons_clipboard.

* add a toolbar separator
    l_button_data-function  = 'CLIPBOARD_SEP'.
    l_button_data-butn_type = cntb_btype_sep.
    APPEND l_button_data TO gt_toolbuttons_clipboard.

* add button clipboard clear
    l_button_data-function  = 'CLEAR_CLIPBOARD'.
    l_button_data-icon      = icon_delete.
    l_button_data-quickinfo = text-q04.
    l_button_data-butn_type = cntb_btype_button.
    APPEND l_button_data TO gt_toolbuttons_clipboard.

    lt_events = VALUE #( ( eventid    = cl_gui_toolbar=>m_id_function_selected
                           appl_event = ' ' ) ).
    gc_clipboard_toolbar->set_registered_events( EXPORTING events = lt_events ).

    SET HANDLER me->on_toolbar_function_selected FOR gc_clipboard_toolbar.

* add the buttons to the toolbar
    gc_clipboard_toolbar->add_button_group( EXPORTING data_table = gt_toolbuttons_clipboard ).
    gc_clipboard_toolbar->set_button_visible( EXPORTING visible = ' ' fcode = 'CLEAR_CLIPBOARD' ).


* create clipboard text control
    CREATE OBJECT gc_clipboard_textedit
      EXPORTING
        parent = gcont_clipboard_textedit.

* set toolbar mode to '0'
    gc_clipboard_textedit->set_toolbar_mode( 0 ).

* get the clipboard content from database
    SELECT SINGLE clipboard FROM /cadaxo/sqlcusrp INTO l_stringx WHERE uname = sy-uname.
    IF sy-subrc = 0 AND NOT l_stringx IS INITIAL.
      TRY.
          cl_abap_gzip=>decompress_binary(
            EXPORTING
              gzip_in = l_stringx
            IMPORTING
              raw_out = l_stringx ).
        CATCH cx_parameter_invalid_range cx_sy_buffer_overflow . "#EC NO_HANDLER
      ENDTRY.

* convert stringx to string
      cl_abap_conv_in_ce=>create( RECEIVING conv = lcl_convin ).

      lcl_convin->convert( EXPORTING input = l_stringx
                           IMPORTING data  = l_string ).

* convert string to internal tab (reg. text control)
      DO.
        l_len = strlen( l_string ).
        IF l_len GT 255.
          APPEND l_string(255) TO lt_text.
        ELSE.
          APPEND l_string TO lt_text.
          EXIT.
        ENDIF.
        SHIFT l_string BY 255 PLACES LEFT.
      ENDDO.

      gc_clipboard_textedit->set_text_as_stream( EXPORTING  text   = lt_text
                                                 EXCEPTIONS OTHERS = 1 ).

      me->gt_clipboard[] = lt_text[].

    ENDIF.

* set clipboard font mode
    gc_clipboard_textedit->set_font_fixed( mode = 1 ).

* create drag/drop behaviour
    CREATE OBJECT dragdrop_behaviour_clipboard.

    dragdrop_behaviour_clipboard->add(
      EXPORTING
        flavor     = 'ALV_TO_CLIPBOARD'
        dragsrc    = ' '
        droptarget = 'X'
        effect     = cl_dragdrop=>copy ).

    gc_clipboard_textedit->set_dragdrop( EXPORTING dragdrop = dragdrop_behaviour_clipboard ).

    SET HANDLER me->on_clipboard_drop FOR gc_clipboard_textedit.

  ENDMETHOD.


  METHOD create_controls.
****************************************************************************************************
* Description             : Create main controls                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 03.02.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 11.10.2010 | David Ren            | Add symbol ALV(including user symbols)      | Usersymbols    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    IF gc_splitter IS INITIAL.

      CALL FUNCTION 'GUI_IS_ITS'
        IMPORTING
          return = g_is_its.
      IF g_is_its = abap_true OR cl_gui_frontend_services=>activex <> gfw_true.
        CLEAR me->g_abap_editor_type.
      ENDIF.

      me->create_primary_ui_controls( ).

      me->create_result_ui_controls( ).

      me->create_symbol_ui_control( ).

      me->create_editor_ui_control( ).

      me->create_clipboard_ui_control( ).

      me->create_elementinfo_ui_control( ).

* set focus on abap control (or the abap text control)
      IF NOT gc_abap_editor IS INITIAL.
        gc_abap_editor->set_focus( control = gcont_abap_editor ).
      ELSEIF NOT gc_abap_editor_text IS INITIAL.
        gc_abap_editor_text->set_focus( control = gcont_abap_editor ).
      ENDIF.

* clear sql area
      me->usr_action_clear_sql_area( ).

      me->show_html( ).

      me->set_result_toolbar_active( i_fcode = c_cmd_home ).

    ENDIF.

  ENDMETHOD.


  METHOD create_dyn_document.
****************************************************************************************************
* Description             : create_dyn_document                                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO GesmbH            Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Set headerline in Result ALV                | CR22-034       *
*            |                      |                                             | Clocking4721   *
*------------+----------------------+---------------------------------------------+----------------*
* 11.09.2014 | RenÃƒÂ© Rammer          | Bug Fix Text in ALV Header too long         | CR22-035       *
*            |                      |                                             | RT259          *
****************************************************************************************************

    CONSTANTS: lc_length TYPE i VALUE 255.
    DATA: lt_text  TYPE sdydo_text_table.
    DATA: lwa_text TYPE sdydo_text_element.
    DATA: l_length TYPE i.
    DATA: l_reuse  TYPE flag.

    DO.
      l_length = strlen( i_sql ).
      lwa_text = i_sql+0(l_length).
      APPEND lwa_text TO lt_text.
      IF l_length <= lc_length.
        EXIT. "DO
      ENDIF.
      i_sql = i_sql+lc_length.
    ENDDO.

    IF ic_document IS INITIAL.
      CREATE OBJECT ic_document
        EXPORTING
          style      = 'ALV_GRID'
          no_margins = gfw_true.
      l_reuse = abap_false.
    ELSE.
      ic_document->initialize_document(
          style            = 'ALV_GRID'
          no_margins       = abap_true ).
      l_reuse = abap_true.
    ENDIF.

* For Header Line
    IF i_header_text IS NOT INITIAL.                          "CR22-034
      CLEAR lt_text.                                          "CR22-034
      APPEND i_header_text TO lt_text.                        "CR22-034
    ENDIF.                                                    "CR22-034

    LOOP AT lt_text INTO lwa_text.                            "CR22-035
      ic_document->add_text(                                  "CR22-035
       EXPORTING                                              "CR22-035
         text          = lwa_text                             "CR22-035
       CHANGING                                               "CR22-035
         document      =  ic_document ).                      "CR22-035
    ENDLOOP.                                                  "CR22-035

    IF l_reuse = abap_true.
      ic_document->display_document( EXPORTING reuse_control = l_reuse ).
    ELSE.
      ic_document->display_document( EXPORTING parent = i_parent ).
    ENDIF.

  ENDMETHOD.


  METHOD create_editor_ui_control.
****************************************************************************************************
* Description             : create editor ui control                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 03.02.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 11.10.2010 | David Ren            | Symbols drag&drop with editor               | Usersymbols    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: ls_lvc_s_layo TYPE lvc_s_layo,
          lt_fieldcat   TYPE lvc_t_fcat.
    DATA shellstyle TYPE i.
    shellstyle = cl_gui_container=>ws_visible + cl_gui_container=>ws_child.

    FIELD-SYMBOLS: <ls_fieldcat> TYPE lvc_s_fcat.

* create splitter control
    CREATE OBJECT gs_splitter_editor
      EXPORTING
        parent     = gcont_abap_splitter
        rows       = 2
        columns    = 1
        shellstyle = shellstyle.

    gs_splitter_editor->set_name( c_sqleditor_name && '_SP' ).
    gs_splitter_editor->set_row_mode( gs_splitter_editor->mode_absolute ).

    gcont_abap_editor = gs_splitter_editor->get_container( row = 1 column = 1 ).
    gcont_abap_editor->set_name( c_sqleditor_name && '_ED' ).
    gcont_abap_error  = gs_splitter_editor->get_container( row = 2 column = 1 ).
    gcont_abap_error->set_name( c_sqleditor_name && '_ER' ).

    gs_splitter_editor->set_row_height( id = 2 height = 0 ).
    gs_splitter_editor->set_row_sash( id = 2 type = 1 value = gs_splitter_editor->false   ).

    IF me->g_abap_editor_type = 'A' AND g_is_its IS INITIAL.
      CREATE OBJECT gc_abap_editor
        EXPORTING
          parent = gcont_abap_editor.

      gc_abap_editor->upload_properties( EXCEPTIONS OTHERS = 4 ).
      gc_abap_editor->init_event_registration( EXCEPTIONS OTHERS = 2 ).
      gc_abap_editor->set_name( c_sqleditor_name ).
      gc_abap_editor->set_statusbar_mode( statusbar_mode = 0 ).
      gc_abap_editor->set_readonly_mode( 0 ).
      gc_abap_editor->set_limit_text( 255 ).
      gc_abap_editor->set_source_type('ABAP').

* set the editor to read only mode, if the user does not have the authorization
      IF me->g_auth_sql_cockpit_actvt <> '02'.
        gc_abap_editor->set_readonly_mode( 1 ).
      ENDIF.

* create the drag/drop object
      CREATE OBJECT dragdrop_behaviour_editor.

      dragdrop_behaviour_editor->add(
        EXPORTING
          flavor     = 'ALV_TO_EDITOR'
          dragsrc    = ' '
          droptarget = 'X'
          effect     = cl_dragdrop=>copy ).

      dragdrop_behaviour_editor->add(
        EXPORTING
          flavor     = 'LOG_TO_EDITOR'
          dragsrc    = ' '
          droptarget = 'X'
          effect     = cl_dragdrop=>copy ).

      dragdrop_behaviour_editor->add(
        EXPORTING
          flavor     = 'SYMBOL_TO_EDITOR'
          dragsrc    = ' '
          droptarget = 'X'
          effect     = cl_dragdrop=>copy ).

      dragdrop_behaviour_editor->add(
        EXPORTING
          flavor     = 'ELEMENTINFO_TO_EDITOR'
          dragsrc    = ' '
          droptarget = 'X'
          effect     = cl_dragdrop=>copy ).

      gc_abap_editor->set_dragdrop(
        EXPORTING
          dragdrop = dragdrop_behaviour_editor ).

* register the event
      gc_abap_editor->register_event_dblclick(
        EXPORTING
          navigate_on_dblclick = 1
        EXCEPTIONS
          error_regist_event   = 1
          error_unregist_event = 2 ).

* context menu
      gc_abap_editor->register_event_context_menu(
        EXPORTING
          register                 = 1
          appl_event               = space
          local_entries            = 1
        EXCEPTIONS
          OTHERS                   = 6 ).

* code completion - start
      TRY.
          gc_abap_editor->init_completer( ).
          gc_abap_parser = gc_abap_editor->get_completer( ).
          gc_abap_editor->register_event_completion( EXPORTING appl_event = ' '
                                                     EXCEPTIONS
                                                       OTHERS     = 1 ).
          IF sy-subrc = 0.
            SET HANDLER gc_abap_parser->handle_completion_request FOR gc_abap_editor.
          ENDIF.
          gc_abap_editor->register_event_insert_pattern( EXPORTING appl_event = ' '
                                                         EXCEPTIONS
                                                           OTHERS     = 1 ).
          IF sy-subrc = 0.
            SET HANDLER gc_abap_parser->handle_insertion_request FOR gc_abap_editor.
          ENDIF.

        CATCH cx_root.
      ENDTRY.

      SET HANDLER: me->on_editor_drop                 FOR gc_abap_editor,
                   me->on_editor_dblclick             FOR gc_abap_editor,
                   me->on_editor_context_menu         FOR gc_abap_editor,
                   me->on_editor_context_menu_sel     FOR gc_abap_editor.


    ELSE.
      CREATE OBJECT gc_abap_editor_text
        EXPORTING
          parent            = gcont_abap_editor
          wordwrap_mode     = 2
          wordwrap_position = 132.

      IF me->g_auth_sql_cockpit_actvt <> '02'.
        gc_abap_editor_text->set_readonly_mode( 1 ).
      ENDIF.

      gc_abap_editor_text->set_highlight_comments_mode( 1 ) .
      gc_abap_editor_text->set_comments_string( ) .

* create the drag/drop object
      CREATE OBJECT dragdrop_behaviour_editor.

      dragdrop_behaviour_editor->add(
        EXPORTING
          flavor     = 'ALV_TO_EDITOR_OLD'
          dragsrc    = ' '
          droptarget = 'X'
          effect     = cl_dragdrop=>copy ).

      gc_abap_editor_text->set_dragdrop(
        EXPORTING
          dragdrop = dragdrop_behaviour_editor ).

      SET HANDLER: me->on_editor_text_drop                 FOR gc_abap_editor_text.

    ENDIF.

* create abap error control
    CREATE OBJECT gc_abap_error
      EXPORTING
        i_parent = gcont_abap_error.

* show error table
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = '/CADAXO/SQLCSYNTAXERROR'
      CHANGING
        ct_fieldcat      = lt_fieldcat.

    LOOP AT lt_fieldcat ASSIGNING <ls_fieldcat>.
      CASE <ls_fieldcat>-fieldname.
        WHEN 'TEXT'.
          <ls_fieldcat>-col_opt = 'A'.
          <ls_fieldcat>-col_pos = 2.
        WHEN 'MSGTYPE'.
          <ls_fieldcat>-icon    = abap_true.
          <ls_fieldcat>-col_pos = 1.
        WHEN 'LONGTEXT'.
          <ls_fieldcat>-icon    = abap_true.
          <ls_fieldcat>-hotspot = abap_true.
          <ls_fieldcat>-col_pos = 3.
        WHEN OTHERS.
          <ls_fieldcat>-no_out  = abap_true.
      ENDCASE.
    ENDLOOP.

    ls_lvc_s_layo-no_toolbar  = abap_true.

    gc_abap_error->set_table_for_first_display(
      EXPORTING
        i_bypassing_buffer            = abap_true
        is_layout                     = ls_lvc_s_layo
      CHANGING
        it_outtab                     = gt_errors
        it_fieldcatalog               = lt_fieldcat
      EXCEPTIONS
        OTHERS                        = 1 ).

    SET HANDLER me->on_abap_error_hotspot_click     FOR gc_abap_error.

* Free
    FREE lt_fieldcat.

  ENDMETHOD.


  METHOD create_elementinfo_ui_control.
****************************************************************************************************
* Description             : Create element info ui control                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : cadaxo GmbH                      *
* Date                    : 29.06.2016               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA ls_lvc_layo TYPE lvc_s_layo.
    DATA lt_fieldcat TYPE slis_t_fieldcat_alv.
    DATA lt_lfc_fcat TYPE lvc_t_fcat.
    DATA ls_lvc_fcat TYPE lvc_s_fcat.

    IF gcont_elementinfo IS INITIAL.
      RETURN.
    ENDIF.

    gcont_elementinfo->set_name( 'GCONT_ELEMENTINFO_MAIN' ).

    IF dragdrop_behaviour_elementinfo IS INITIAL.
      CREATE OBJECT dragdrop_behaviour_elementinfo.
      dragdrop_behaviour_elementinfo->add( EXPORTING flavor     = 'ELEMENTINFO_TO_EDITOR'
                                                     dragsrc    = abap_true
                                                     droptarget = abap_false
                                                     effect     = cl_dragdrop=>copy ).
      dragdrop_behaviour_elementinfo->get_handle( IMPORTING handle = dragdrop_handle_elementinfo ).

    ENDIF.

    ls_lvc_layo-cwidth_opt = abap_true.
    ls_lvc_layo-sel_mode   = 'C'. "
    ls_lvc_layo-no_toolbar = abap_true.
    ls_lvc_layo-info_fname = 'LINE_COLOR'.

* build field catalog
    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = '/CADAXO/SQLC_ELEMENTINFO'
      CHANGING
        ct_fieldcat      = lt_fieldcat
      EXCEPTIONS
        OTHERS           = 3.
    IF sy-subrc = 0.
      LOOP AT lt_fieldcat ASSIGNING FIELD-SYMBOL(<ls_fieldcat>).
        ls_lvc_fcat = CORRESPONDING #( <ls_fieldcat> MAPPING scrtext_m = seltext_m
                                                             scrtext_l = seltext_l
                                                             scrtext_s = seltext_s ).

        CASE <ls_fieldcat>-fieldname.
          WHEN 'DATA_TYPE'.
          WHEN 'ICON'.
            ls_lvc_fcat-icon = abap_true.
            ls_lvc_fcat-outputlen = 4.
          WHEN 'FIELDNAME'.
            ls_lvc_fcat-dragdropid = dragdrop_handle_elementinfo.
            ls_lvc_fcat-col_opt = abap_true.
            ls_lvc_fcat-key = abap_true.
          WHEN 'FIELDTEXT'.
            ls_lvc_fcat-dragdropid = dragdrop_handle_elementinfo.
            ls_lvc_fcat-col_opt = abap_true.
            ls_lvc_fcat-outputlen = 40.
          WHEN 'TABLE' OR 'LINE_COLOR'.
            ls_lvc_fcat-no_out = 'X'.
            ls_lvc_fcat-tech   = 'X'.
          WHEN 'ROLLNAME'.
            ls_lvc_fcat-hotspot = abap_true.
          WHEN OTHERS.
            ls_lvc_fcat-no_out = abap_true.
        ENDCASE.
        APPEND ls_lvc_fcat TO lt_lfc_fcat.
      ENDLOOP.
    ELSE.
      MESSAGE e100(/cadaxo/sqlc) WITH 'CREATE_EMELENTINFO_UI_CONTROL' 'FIELDCAT' '' ''.
    ENDIF.

* Create container and grid
    APPEND INITIAL LINE TO gcont_grid_elementinfo_t ASSIGNING FIELD-SYMBOL(<ls_cont_element>).

    <ls_cont_element>-gui_container = gcont_elementinfo.
*    begin of change cockpit415
    IF me->g_user_settings-show_footer = abap_true.
      CREATE OBJECT <ls_cont_element>-gui_splitter
        EXPORTING
          parent  = <ls_cont_element>-gui_container
          rows    = 2
          columns = 1.
      <ls_cont_element>-gui_splitter->set_name( 'SPLIT' ).
      <ls_cont_element>-gui_splitter->set_border( EXPORTING border = abap_false ).
      <ls_cont_element>-gui_splitter->set_mode( <ls_cont_element>-gui_splitter->mode_run ).
      <ls_cont_element>-gui_splitter->set_row_mode( cl_gui_splitter_container=>mode_absolute ).
      <ls_cont_element>-gui_splitter->set_row_height( id = 2 height = toolbar_row_height ).
      <ls_cont_element>-gui_splitter->set_row_sash( id = 2 type = 1 value = cl_gui_splitter_container=>false  ).

      <ls_cont_element>-gui_splitter->get_container( EXPORTING row       = 1
                                                               column    = 1
                                                     RECEIVING container = DATA(lr_cont_main) ).
      lr_cont_main->set_name( 'MAIN' ).

      DATA(parent_container) = lr_cont_main.
    ELSE.
*    end of change cockpit415
      <ls_cont_element>-gui_container->set_name( 'CONTAINER_ELEMENTINFO' ).

*    begin of change cockpit415
      parent_container = <ls_cont_element>-gui_container.
    ENDIF.
*    end of change cockpit415

    CREATE OBJECT gc_elementinfo_alv
      EXPORTING
        i_parent = parent_container.                "++cockpit415
*       i_parent = <ls_cont_element>-gui_container. "--cockpit415

* Set handler
    SET HANDLER: me->on_elementinfo_drag               FOR gc_elementinfo_alv,
                 me->on_elementinfo_double_click       FOR gc_elementinfo_alv.
    SET HANDLER: me->on_elementinfo_hotspot_de         FOR gc_elementinfo_alv.
    SET HANDLER: me->on_handle_result_user_command     FOR gc_elementinfo_alv.

    gc_elementinfo_alv->set_table_for_first_display( EXPORTING  i_bypassing_buffer            = abap_false
                                                                is_layout                     = ls_lvc_layo
                                                     CHANGING   it_outtab                     = gt_elementinfo
                                                                it_fieldcatalog               = lt_lfc_fcat
                                                     EXCEPTIONS OTHERS                        = 1 ).
    IF sy-subrc <> 0.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.
    gc_elementinfo_alv->set_gridtitle( i_gridtitle =  'Element Info' ).
* QuickInfo
    TRY.
        gc_abap_editor->register_event_quick_info( EXPORTING appl_event = space
                                                   EXCEPTIONS OTHERS = 1 ).
        IF sy-subrc = 0.
          SET HANDLER me->on_editor_quick_info FOR gc_abap_editor.
          gc_abap_editor->create_document( EXPORTING name     = 'CADAXO_SQL_EDITOR'
                                           EXCEPTIONS OTHERS   = 2 ).
        ENDIF.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD create_primary_ui_controls.
****************************************************************************************************
* Description             : create primary ui controls                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 11.10.2010 | David Ren            | Add symbol ALV(including user symbols)      | Usersymbols    *
*------------+----------------------+---------------------------------------------+----------------*
* 03.03.2018 | Domi Bigl            | CC Refactoring                              | COCKPIT-48     *
*------------+----------------------+---------------------------------------------+----------------*
* 25.11.2020 | Attila Kajtar        | Feedback/Support 3.3.0                      | COCKPIT-321    *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: ls_stb_button TYPE stb_button.
    DATA: lt_events     TYPE cntl_simple_events.
*
*    gc_docking = NEW #( repid     = '/CADAXO/SQLC_MAIN'
*                        dynnr     = '0100'
*                        side      = cl_gui_docking_container=>dock_at_bottom
*                        extension = 1000 ).
*
*    gc_docking->set_name( 'GC_DOCKING' ).

    gc_splitter = NEW #(  parent     = cl_gui_container=>screen0 "gc_docking
                          rows       = 3
                          columns    = 1
                          shellstyle = cl_gui_container=>ws_visible + cl_gui_container=>ws_child ).

    gc_splitter->set_name( 'GC_SPLITTER' ).

    gc_splitter->set_border( cl_gui_cfw=>false ).

    gc_splitter->set_row_height( id = 1 height = toolbar_row_height ).

    gc_splitter->set_row_sash( id = 1 type = 0 value = gc_splitter->false  ).
    gcont_splitter_top_toolbar = gc_splitter->get_container( row = 1 column = 1 ).
    gcont_splitter_top_toolbar->set_name( 'GCONT_SPLITTER_TOP_TOOLBAR' ).
    gc_splitter_top_toolbar = NEW #( parent       = gcont_splitter_top_toolbar
                                     display_mode = cl_gui_toolbar=>m_mode_horizontal ).

* Toolbar
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'SQL_BACK'.
    ls_stb_button-icon      = icon_arrow_left.
    ls_stb_button-quickinfo = text-q35.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'SQL_FORW'.
    ls_stb_button-icon      = icon_arrow_right.
    ls_stb_button-quickinfo = text-q36.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'SYNTCHECK'.
    ls_stb_button-icon      = icon_check.
    ls_stb_button-quickinfo = text-q37.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'EXECUTE'.
    ls_stb_button-icon      = icon_execute_object.
    ls_stb_button-quickinfo = text-q38.
    ls_stb_button-butn_type = cntb_btype_dropdown.
    APPEND ls_stb_button TO gt_toolbuttons_top.

    APPEND LINES OF ms_additional_functions-uptomenu->get_toolbar_function( gc_splitter_top_toolbar ) "COCKPIT-48
                 TO gt_toolbuttons_top.                                                               "COCKPIT-48

    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'SAVE_LISTS'.
    ls_stb_button-icon      = icon_system_save.
    ls_stb_button-quickinfo = text-q39.
    ls_stb_button-text      = text-b32.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'TRACETOGGL'.
    ls_stb_button-text      = text-b33.
    ls_stb_button-butn_type = cntb_btype_check.
    ls_stb_button-icon      = icon_dummy.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'SQLVARGET'.
    ls_stb_button-icon      = icon_alv_variant_choose.
    ls_stb_button-quickinfo = text-q41.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'SQLVARSET'.
    ls_stb_button-icon      = icon_alv_variant_save.
    ls_stb_button-quickinfo = text-q40.
*    ls_stb_button-butn_type = cntb_btype_button.   "-Cockpit-321
    ls_stb_button-butn_type = cntb_btype_dropdown.  "+Cockpit-321
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.                                            "COCKPIT-233
    ls_stb_button-function  = 'SQL_SHARE'.                          "COCKPIT-233
    ls_stb_button-icon      = icon_workflow_external_event.         "COCKPIT-233
    ls_stb_button-quickinfo = text-b41.                             "COCKPIT-233
*    ls_stb_button-butn_type = cntb_btype_button.                    "COCKPIT-233 +Cockpit420
    ls_stb_button-butn_type = cntb_btype_dropdown.                    "+Cockpit420
    APPEND ls_stb_button TO gt_toolbuttons_top.                     "COCKPIT-233
    CLEAR ls_stb_button.                                            "COCKPIT-233

    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.

    ls_stb_button-function  = 'QUEUE'.                              "COCKPIT-233
    IF /cadaxo/cl_sqlc_cockpit_api=>check_own_queue( ) = abap_true. "COCKPIT-233
      ls_stb_button-icon      = icon_msg.                           "COCKPIT-233
    ELSE.                                                           "COCKPIT-233
      ls_stb_button-icon      = icon_eml.                           "COCKPIT-233
    ENDIF.                                                          "COCKPIT-233
    ls_stb_button-quickinfo = text-b40.                             "COCKPIT-233
    ls_stb_button-butn_type = cntb_btype_button.                    "COCKPIT-233
    APPEND ls_stb_button TO gt_toolbuttons_top.                     "COCKPIT-233
    CLEAR ls_stb_button.                                            "COCKPIT-233
    ls_stb_button-butn_type = cntb_btype_sep.                       "COCKPIT-233
    APPEND ls_stb_button TO gt_toolbuttons_top.                     "COCKPIT-233
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'GENERATE'.
    ls_stb_button-icon      = icon_wizard.
    ls_stb_button-quickinfo = text-q42.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'PERSPREF'.
    ls_stb_button-icon      = icon_personal_settings.
    ls_stb_button-quickinfo = text-q43.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'ADMIN'.
    ls_stb_button-icon      = icon_system_administrator.
    ls_stb_button-quickinfo = text-q44.
    ls_stb_button-butn_type = cntb_btype_button.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-butn_type = cntb_btype_sep.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'MAIL'.
    ls_stb_button-icon      = icon_mail.
    ls_stb_button-quickinfo = text-q45.
    ls_stb_button-butn_type = cntb_btype_outlookbutton.
    APPEND ls_stb_button TO gt_toolbuttons_top.
    CLEAR ls_stb_button.
    ls_stb_button-function  = 'HELP'.
    ls_stb_button-icon      = icon_system_help.
    ls_stb_button-quickinfo = text-q46.
    ls_stb_button-butn_type = cntb_btype_outlookbutton.
    APPEND ls_stb_button TO gt_toolbuttons_top.
*  CLEAR ls_stb_button.                                                  "COCKPIT-233
*  ls_stb_button-function  = 'PP'.                                       "COCKPIT-233
*  ls_stb_button-text      = text-b34.                                   "COCKPIT-233
*  ls_stb_button-butn_type = cntb_btype_button.                          "COCKPIT-233
*  APPEND ls_stb_button TO gt_toolbuttons_top.                           "COCKPIT-233
    gc_splitter_top_toolbar->add_button_group( gt_toolbuttons_top ).     "COCKPIT-233

    DATA(l_ctmenu) = NEW cl_ctmenu( ).

* add submenues
    l_ctmenu->add_function( EXPORTING fcode = 'EXECUTE'     text = text-b35 checked = abap_true icon = icon_execute_object ).
    l_ctmenu->add_function( EXPORTING fcode = 'EXECUTEJOB'  text = text-b37 ).
    gc_splitter_top_toolbar->set_static_ctxmenu( EXPORTING fcode = 'EXECUTE' ctxmenu = l_ctmenu ).

* begin of change 420
    DATA(l_ctmenu2) = NEW cl_ctmenu( ).
    l_ctmenu2->add_function( EXPORTING fcode = 'SQL_SHARE'   text = text-b41 checked = abap_true icon = icon_workflow_external_event ).
    l_ctmenu2->add_function( EXPORTING fcode = 'SQL_SHR_ME'  text = text-b44 ).
    gc_splitter_top_toolbar->set_static_ctxmenu( EXPORTING fcode = 'SQL_SHARE' ctxmenu = l_ctmenu2 ).
* end   of change 420

* begin of change 321
    DATA(l_ctmenu3) = NEW cl_ctmenu( ).
    l_ctmenu3->add_function( EXPORTING fcode = 'SQLVARSET' text = text-q40 checked = abap_true icon = icon_alv_variant_save ).
    l_ctmenu3->add_function( EXPORTING fcode = 'SQLVARSET_UPD' text = conv #( text-b46 )
                                                               disabled = abap_true ).
    gc_splitter_top_toolbar->set_static_ctxmenu( EXPORTING fcode = 'SQLVARSET' ctxmenu = l_ctmenu3 ).
* end   of change 321

    ms_additional_functions-uptomenu->set_static_menu( ). "COCKPIT-48

    lt_events = VALUE #( ( eventid = cl_gui_toolbar=>m_id_function_selected appl_event = abap_false )
                         ( eventid = cl_gui_toolbar=>m_id_dropdown_clicked  appl_event = abap_false ) ).

    gc_splitter_top_toolbar->set_registered_events( events = lt_events ).

    SET HANDLER me->on_top_toolbar_funcsel  FOR gc_splitter_top_toolbar.
    SET HANDLER me->on_top_toolbar_dropdown FOR gc_splitter_top_toolbar.

    gc_splitter->set_row_mode( gc_splitter->mode_absolute ).
    gc_splitter->set_row_height( id = 2 height = toolbar_row_height * 10 ).
    gc_splitter->set_row_sash( id = 2 type = 1 value = gc_splitter->true  ).

*  gcont_abap_editor = gc_splitter->get_container( row = 1 column = 1 ).

* Add By David Ren on 2010.10.11
* To do: add top splitter container
* Get top splitter container
    gcont_splitter_top = gc_splitter->get_container( row = 2 column = 1 ).
    gcont_splitter_top->set_name( 'GCONT_SPLITTER_TOP' ).
    gs_splitter_top = NEW #( parent  = gcont_splitter_top
                             rows    = 1
                             columns = 2 ).
    gs_splitter_top->set_name( 'GS_SPLITTER_TOP' ).
* End Add

* Modify By David Ren on 2010.10.11
* To do: change container
*  gcont_abap_splitter = gc_splitter->get_container( row = 1 column = 1 ).
    gcont_abap_splitter = gs_splitter_top->get_container( row = 1 column = 1 ).
* End Modify
    gcont_abap_splitter->set_name( 'GCONT_ABAP_SPLITTER' ).

* get middle splitter container
*  gcont_abap_error = gc_splitter->get_container( row = 2 column = 1 ).
*  gc_splitter->set_row_height( id = 2 height = 100 ).

* get bottom splitter container
    gcont_splitter_bottom = gc_splitter->get_container( row = 3 column = 1 ). "3
    gcont_splitter_bottom->set_name( 'GCONT_SPLITTER_BOTTOM' ).

    gs_splitter_bottom = NEW #( parent  = gcont_splitter_bottom
                                rows    = 1
                                columns = 2 ).

    gs_splitter_bottom->set_name( 'GS_SPLITTER_BOTTOM' ).

    gcont_grid_results = gs_splitter_bottom->get_container( row = 1 column = 1 ).
    gcont_grid_results->set_name( 'GCONT_GRID_RESULTS' ).

  ENDMETHOD.


  METHOD create_result_ui_controls.
****************************************************************************************************
* Description             : create result ui conrols                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

* Events & Buttons
    DATA: l_events      TYPE cntl_simple_events,
          l_event       TYPE cntl_simple_event,
          ls_stb_button TYPE stb_button.

*  FIELD-SYMBOLS: <l_button_data> TYPE stb_button.
    DATA shellstyle TYPE i.
    shellstyle = cl_gui_container=>ws_visible + cl_gui_container=>ws_child.

* Result Controls
    CREATE OBJECT gs_splitter_res_button
      EXPORTING
        parent     = gcont_grid_results
        rows       = 2
        columns    = 1
        shellstyle = shellstyle.

    gs_splitter_res_button->set_name( 'GS_SPLITTER_RES_BUTTON' ).
    gs_splitter_res_button->set_border( cl_gui_cfw=>false ).
    gs_splitter_res_button->set_row_mode( 0 ).
    gs_splitter_res_button->set_row_height( id = 1 height = toolbar_row_height ). "(24 instead of 20?)
    gs_splitter_res_button->set_row_sash( id = 1 type = 1 value = gs_splitter_res_button->false  ).

    gcont_result_toolbar = gs_splitter_res_button->get_container( row = 1 column = 1 ).
    gcont_result_bottom  = gs_splitter_res_button->get_container( row = 2 column = 1 ).
    gcont_result_bottom->set_name( 'GCONT_RESULT_BOTTOM' ).

* TODO RR:
    IF gc_result_toolbar IS INITIAL.
      CREATE OBJECT gc_result_toolbar
        EXPORTING
          parent       = gcont_result_toolbar
          display_mode = cl_gui_toolbar=>m_mode_horizontal.
    ENDIF.

* Toolbar - Home, Result Table, Log
    CLEAR: ls_stb_button.
    ls_stb_button-function = c_cmd_home.
    ls_stb_button-icon = icon_connection_object.
    ls_stb_button-quickinfo = text-q08.
    ls_stb_button-text      = text-b03.
    ls_stb_button-butn_type = cntb_btype_check.
    APPEND ls_stb_button TO gt_toolbuttons_result.

    CLEAR: ls_stb_button.
    ls_stb_button-function = c_cmd_show_result_table.
    ls_stb_button-icon = icon_list.
    ls_stb_button-quickinfo = text-q06.
    ls_stb_button-text      = text-b01.
    ls_stb_button-butn_type = cntb_btype_dropdown.
    APPEND ls_stb_button TO gt_toolbuttons_result.

    CLEAR: ls_stb_button.
    ls_stb_button-function = 'SHOW_LOG'.
    ls_stb_button-icon = icon_history.
    ls_stb_button-quickinfo = text-q07.
    ls_stb_button-text      = text-b02.
    ls_stb_button-butn_type = cntb_btype_check.
    APPEND ls_stb_button TO gt_toolbuttons_result.

    CLEAR: ls_stb_button.
    ls_stb_button-function = c_cmd_jobmonitor.
    ls_stb_button-icon = icon_background_job.
    ls_stb_button-quickinfo = text-q20.
    ls_stb_button-text      = text-b15.
    ls_stb_button-butn_type = cntb_btype_check.
    APPEND ls_stb_button TO gt_toolbuttons_result.

    CLEAR: ls_stb_button.
    ls_stb_button-function = c_cmd_show_saved_lists.
    ls_stb_button-icon = icon_read_file.
    ls_stb_button-quickinfo = text-q22.
    ls_stb_button-text      = text-b21.
    ls_stb_button-butn_type = cntb_btype_check.
    APPEND ls_stb_button TO gt_toolbuttons_result.

    gc_result_toolbar->add_button_group( EXPORTING data_table = gt_toolbuttons_result ).

    CLEAR l_events[].
    l_event-eventid = cl_gui_toolbar=>m_id_function_selected.
    l_event-appl_event = ' '.
    APPEND l_event TO l_events.
    l_event-eventid = cl_gui_toolbar=>m_id_dropdown_clicked.
    l_event-appl_event = ' '.
    APPEND l_event TO l_events.

    gc_result_toolbar->set_registered_events( EXPORTING events = l_events ).

    SET HANDLER me->on_result_toolbar_funcsel  FOR gc_result_toolbar.
    SET HANDLER me->on_result_toolbar_dropdown FOR gc_result_toolbar.

    CREATE OBJECT gs_splitter_results
      EXPORTING
        parent  = gcont_result_bottom
        rows    = 1
        columns = 1.

    gs_splitter_results->set_name( 'GS_SPLITTER_RESULTS' ).
    gs_splitter_results->set_border( cl_gui_cfw=>false ).
    gs_splitter_results->set_column_mode( mode = gs_splitter_results->mode_relative ).
    gs_splitter_results->set_row_sash( id = 1 type = 1 value = gs_splitter_results->false  ).
    gs_splitter_results->set_column_width( id = 1 width = 80 ).

    me->g_cont_pers_preferences = 'X'.

    CREATE OBJECT dragdrop_behaviour_alv.

    IF me->g_abap_editor_type = 'A'.

      dragdrop_behaviour_alv->add( flavor = 'ALV_TO_EDITOR'
                                   dragsrc = 'X' droptarget = ' '
                                   effect = cl_dragdrop=>copy ).
    ELSE.
      dragdrop_behaviour_alv->add( flavor = 'ALV_TO_EDITOR_OLD'
                                   dragsrc = 'X' droptarget = ' '
                                   effect = cl_dragdrop=>copy ).
    ENDIF.

    dragdrop_behaviour_alv->add( flavor = 'ALV_TO_CLIPBOARD'
                                 dragsrc = 'X' droptarget = ' '
                                 effect = cl_dragdrop=>copy ).

    dragdrop_behaviour_alv->get_handle( IMPORTING handle = dragdrop_handle ).

  ENDMETHOD.


  METHOD create_symbol_db.

    IF NOT it_symbol_create IS INITIAL.

      INSERT /cadaxo/sqlcusym FROM TABLE it_symbol_create.
      IF sy-subrc = 0.

        rv_success = 'X'.

      ELSE.

        ROLLBACK WORK.
        MESSAGE s055(/cadaxo/sqlc) WITH text-dec.                      "CDX001-0020
        RETURN.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD create_symbol_multival_tab_dyn.
    DATA lt_comp TYPE abap_component_tab.
    DATA ls_comp TYPE abap_componentdescr.
    DATA lr_abap_elem TYPE REF TO cl_abap_elemdescr.
    DATA lr_struct TYPE REF TO cl_abap_structdescr.
    DATA lr_table TYPE REF TO cl_abap_tabledescr.

    lr_abap_elem ?= cl_abap_elemdescr=>describe_by_name(
      EXPORTING
        p_name         = 'TVARV_SIGN'
    ).
    ls_comp-name = 'SIGN'.
    ls_comp-type = lr_abap_elem.
    APPEND ls_comp TO lt_comp.

    lr_abap_elem ?= cl_abap_elemdescr=>describe_by_name(
      EXPORTING
        p_name         = 'TVARV_OPTI'
    ).
    ls_comp-name = 'OPTION'.
    ls_comp-type = lr_abap_elem.
    APPEND ls_comp TO lt_comp.

    lr_abap_elem ?= cl_abap_elemdescr=>describe_by_name(
      EXPORTING
        p_name         = i_symbol_datatype
    ).

    ls_comp-name = 'LOW'.
    ls_comp-type = lr_abap_elem.
    APPEND ls_comp TO lt_comp.

    ls_comp-name = 'HIGH'.
    ls_comp-type = lr_abap_elem.
    APPEND ls_comp TO lt_comp.

    cl_abap_structdescr=>create(
      EXPORTING
        p_components          = lt_comp
      RECEIVING
        p_result              = lr_struct
    ).

    lr_table = cl_abap_tabledescr=>create(
      EXPORTING
        p_line_type          = lr_struct ).

    CREATE DATA e_data_struct TYPE HANDLE lr_struct.
    CREATE DATA e_data TYPE HANDLE lr_table.
  ENDMETHOD.


  METHOD create_symbol_ui_control.
****************************************************************************************************
* Description             : Create symbol ui control                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | Sort global/user                            | CDX001-0020    *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Move Symbol Window to hide Editor Area      | CR22-033       *
*            |                      | (for Auditors)                              | Clocking4720   *
*------------+----------------------+---------------------------------------------+----------------*
* 01.02.2017 | Dusan Sacha          | Added new splitter + vertical image         |                *
*------------+----------------------+---------------------------------------------+----------------*
* 31.07.2017 | Dusan Sacha          |  Symbol Multi Value                         | COCKPIT-240    *
****************************************************************************************************


    DATA lt_events TYPE cntl_simple_events.
    DATA ls_button_data TYPE stb_button.
    DATA ls_lvc_layo TYPE lvc_s_layo.
    DATA lt_fieldcat TYPE slis_t_fieldcat_alv.
    DATA lt_lvc_fcat TYPE lvc_t_fcat.
    DATA ls_lvc_fcat TYPE lvc_s_fcat.
    DATA lv_image_url(255).
    DATA query_table TYPE TABLE OF w3query.
    DATA s_query_table LIKE LINE OF query_table.
    DATA html_table TYPE TABLE OF w3html.
    DATA return_code TYPE w3param-ret_code.
    DATA content_type TYPE  w3param-cont_type.
    DATA content_length TYPE  w3param-cont_len.
    DATA pic_data TYPE TABLE OF w3mime.
    DATA pic_size TYPE i.

    FIELD-SYMBOLS: <l_fieldcat>    TYPE slis_fieldcat_alv,
                   <l_cont_symbol> TYPE /cadaxo/sqlcclguicontainer.

* get symbol container
    gcont_symbol = gs_splitter_top->get_container( row = 1 column = 2 ).
    gcont_symbol->set_name( 'GCONT_SYMBOL' ).

* create splitter (ALV & toolbar)
    gs_splitter_symbol = NEW #( parent  = gcont_symbol
                                rows    = 1
                                columns = 2 ).
    gs_splitter_symbol->set_name( 'GS_SPLITTER_SYMBOL' ).
    gs_splitter_symbol->set_column_mode( 0 ).
    gs_splitter_symbol->set_column_width( id = 1 width = toolbar_col_width ).
    gs_splitter_symbol->set_column_sash( id = 1 type = 1 value = gs_splitter_symbol->false  ).

    gcont_symbol_toolbar = gs_splitter_symbol->get_container( row = 1 column = 1 ).

    gs_splitter_top->set_column_mode( 0 ).

* If User has no change rights in editor (e.g. is an auditor) symbol window is "hiding" editor area
    AUTHORITY-CHECK OBJECT 'ZCADXOSQ01' ID 'ACTVT' FIELD '16'.                       "CR22-033
    IF sy-subrc = 0.                                                                "CR22-033
      AUTHORITY-CHECK OBJECT 'ZCADXOSQ01' ID 'ACTVT' FIELD '23'.                     "CR22-033
      IF sy-subrc = 4.                                                              "CR22-033
        gs_splitter_top->set_column_width( id = 2 width = 3000 ).                    "CR22-033
      ELSE.                                                                          "CR22-033
        IF me->g_user_settings-symbols_show = abap_true.                             "CDX001-0020
          gs_splitter_top->set_column_width( id = 2 width = c_width_right_symbols ). "Default open
        ELSE.                                                                        "CDX001-0020
          gs_splitter_top->set_column_width( id = 2 width = toolbar_col_width )."Default closed     "CDX001-0020
        ENDIF.                                                                       "CDX001-0020
      ENDIF.
    ENDIF.

* splitter in toolbar
    gs_splitter_symbol_toolbar = NEW #( parent  = gcont_symbol_toolbar
                                        rows    = 2
                                        columns = 1 ).

    gs_splitter_symbol_toolbar->set_row_height( EXPORTING  id     = 1
                                                           height = toolbar_row_height
                                                EXCEPTIONS OTHERS = 1 ).

    gs_splitter_symbol_toolbar->set_row_sash(
      id    = 1
      type  = gs_splitter_symbol_toolbar->type_movable
      value = gs_splitter_symbol_toolbar->false ).

    gs_splitter_symbol_toolbar->set_row_sash(
      id    = 1
      type  = gs_splitter_symbol_toolbar->type_sashvisible
      value = gs_splitter_symbol_toolbar->false ).

    gcont_symbol_toolbar_btns = gs_splitter_symbol_toolbar->get_container( row = 1 column = 1 ).
    gcont_symbol_toolbar_img = gs_splitter_symbol_toolbar->get_container( row = 2 column = 1 ).

    gc_symbol_toolbar = NEW #(  parent       = gcont_symbol_toolbar_btns
                                display_mode = cl_gui_toolbar=>m_mode_vertical ).

* create control toolbar img
    gc_symbol_toolbar_img = NEW #( parent = gcont_symbol_toolbar_img ).

* load sidebar image
    s_query_table-name = '_OBJECT_ID'.

    IF ( sy-langu = 'D' ).
      s_query_table-value = '/CADAXO/SQLC_SIDEBAR_IMG_SYMBOLS_DE'.
    ELSE.
      s_query_table-value = '/CADAXO/SQLC_SIDEBAR_IMG_SYMBOLS'.
    ENDIF.

    APPEND s_query_table TO query_table.

* load sidebar image data
    CALL FUNCTION 'WWW_GET_MIME_OBJECT'
      TABLES
        query_string   = query_table
        html           = html_table
        mime           = pic_data
      CHANGING
        return_code    = return_code
        content_type   = content_type
        content_length = content_length
      EXCEPTIONS
        OTHERS         = 3.
    IF sy-subrc = 0.
      pic_size = content_length.
    ENDIF.

* create sidebar image url
    CLEAR lv_image_url.
    CALL FUNCTION 'DP_CREATE_URL'
      EXPORTING
        ##NO_TEXT
        type     = 'image'
        subtype  = cndp_sap_tab_unknown
        size     = pic_size
        lifetime = cndp_lifetime_transaction
      TABLES
        data     = pic_data
      CHANGING
        url      = lv_image_url
      EXCEPTIONS
        OTHERS   = 1.

* insert picture url to toolbar
    gc_symbol_toolbar_img->load_picture_from_url( lv_image_url ).


* add button symbols show/hide
    ls_button_data-function = c_okcode_symbols.
    IF me->g_user_settings-symbols_show = abap_true.                             "CDX001-0020
      ls_button_data-icon = '@K2@'.                                              "CDX001-0020
      ls_button_data-quickinfo = text-q11.                                       "CDX001-0020
    ELSE.                                                                        "CDX001-0020
      ls_button_data-icon = '@K1@'.
      ls_button_data-quickinfo = text-q10.
    ENDIF.                                                                       "CDX001-0020

    ls_button_data-butn_type = cntb_btype_button.

    APPEND ls_button_data TO gt_toolbuttons_symbol.


    lt_events = VALUE #( ( eventid = cl_gui_toolbar=>m_id_function_selected appl_event = abap_false ) ).

    gc_symbol_toolbar->set_registered_events( EXPORTING events = lt_events ).
    SET HANDLER me->on_toolbar_function_selected FOR gc_symbol_toolbar.

* add the buttons to the toolbar
    gc_symbol_toolbar->add_button_group( EXPORTING data_table = gt_toolbuttons_symbol ).

    IF dragdrop_behaviour_symbol IS INITIAL.
*   create drag/drop behaviour
      dragdrop_behaviour_symbol = NEW #( ).
      dragdrop_behaviour_symbol->add( flavor     = 'SYMBOL_TO_EDITOR'
                                      dragsrc    = abap_true
                                      droptarget = abap_false
                                      effect     = cl_dragdrop=>copy ).
      dragdrop_behaviour_symbol->get_handle( IMPORTING handle = dragdrop_handle_symbol ).

    ENDIF.


    ls_lvc_layo = VALUE #( zebra      = abap_true
                           cwidth_opt = abap_true
                           sel_mode   = 'A'
                           stylefname = 'CELL_STYLE'
                            ).

* build field catalog
    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = '/CADAXO/SQLC_SYMBOL'
      CHANGING
        ct_fieldcat      = lt_fieldcat
      EXCEPTIONS
        OTHERS           = 1.
    IF sy-subrc = 0.
      LOOP AT lt_fieldcat ASSIGNING <l_fieldcat>.
        CLEAR: ls_lvc_fcat.
        ls_lvc_fcat = CORRESPONDING #( <l_fieldcat> MAPPING scrtext_m = seltext_m scrtext_l = seltext_l scrtext_s = seltext_s ).
        CASE <l_fieldcat>-fieldname.
          WHEN 'SYMBOL_NAME'.
            ls_lvc_fcat-key = abap_true.
            ls_lvc_fcat-dragdropid = dragdrop_handle_symbol.
          WHEN 'SYMBOL_MULTIVALUE'.                                "COCKPIT-240
            ls_lvc_fcat-no_out = abap_true.                        "COCKPIT-240
            ls_lvc_fcat-tech   = abap_true.                        "COCKPIT-240
          WHEN 'TYPE' OR 'USED_IN_EDITOR'.                         "CR22-033
            ls_lvc_fcat-no_out = abap_true.
            ls_lvc_fcat-tech   = abap_true.
          WHEN 'SYMBOL_ICON'.
            ls_lvc_fcat-key     = abap_true.                       "COCKPIT-240
            ls_lvc_fcat-col_pos = 1.                               "CDX001-0020   COCKPIT-240
          WHEN 'SYMBOL_DATATYPE'.
            ls_lvc_fcat-f4availabl = abap_true.                    "COCKPIT-240
            ls_lvc_fcat-ref_table  = 'DD04L'.                      "COCKPIT-240
            ls_lvc_fcat-ref_field  = 'ROLLNAME'.                   "COCKPIT-240
        ENDCASE.
        APPEND ls_lvc_fcat TO lt_lvc_fcat.
      ENDLOOP.
    ELSE.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.

* Create container and grid
    APPEND INITIAL LINE TO gcont_grid_symbol_t ASSIGNING <l_cont_symbol>.

    <l_cont_symbol>-gui_container = gs_splitter_symbol->get_container( EXPORTING row = 1 column = 2 ).

    <l_cont_symbol>-gui_container->set_name( 'CONTAINER_SYMBOL' ).

    gc_symbol_alv = NEW #( i_parent = <l_cont_symbol>-gui_container ).

    gc_symbol_alv->set_ready_for_input( i_ready_for_input = 1 ). "CDX PERFORMANCE

* Exlcude Symbol Toolbar Buttons
    IF me->g_symbol_toolbar_excluding IS INITIAL.

      APPEND cl_gui_alv_grid=>mc_mb_variant           TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_mb_subtot            TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_mb_sum               TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_print             TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_views             TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_mb_export            TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_graph             TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_info              TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_help              TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_check             TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row    TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_refresh           TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_append_row    TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_copy          TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row      TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_cut           TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row    TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row    TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_move_row      TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_paste         TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_loc_undo          TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_sort              TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_sort_asc          TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_sort_dsc          TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_detail            TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_find              TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_find_more         TO me->g_symbol_toolbar_excluding.
      APPEND cl_gui_alv_grid=>mc_fc_filter            TO me->g_symbol_toolbar_excluding.
    ENDIF.

* Get user and program symbols
    me->get_symbols( ).
* Set handler
    SET HANDLER: me->on_symbol_drag               FOR gc_symbol_alv,
                 me->on_symbol_button_click       FOR gc_symbol_alv,     "COCKPIT-204
*                 me->on_row_click_select          FOR gc_symbol_alv,     "Cockpit-418
                 me->on_symbol_double_click       FOR gc_symbol_alv,
                 me->on_symbol_alv_data_change    FOR gc_symbol_alv,
                 me->on_symbol_alv_toolbar        FOR gc_symbol_alv,
                 me->on_symbol_alv_user_command   FOR gc_symbol_alv.
    SET HANDLER  me->on_symbol_alv_data_changed_fin FOR gc_symbol_alv.                "CDX001-0020
    SET HANDLER  me->on_symbol_menu_button        FOR gc_symbol_alv.  "+  Cockpit-420
    gc_symbol_alv->register_edit_event( i_event_id = gc_symbol_alv->mc_evt_modified )."CDX001-0020


    gc_symbol_alv->set_table_for_first_display( EXPORTING  i_bypassing_buffer   = abap_true "abap_false
                                                           is_layout            = ls_lvc_layo
                                                           it_toolbar_excluding = me->g_symbol_toolbar_excluding
                                                CHANGING   it_outtab            = gt_symbol
                                                           it_fieldcatalog      = lt_lvc_fcat
                                                EXCEPTIONS OTHERS               = 1 ).
    IF sy-subrc <> 0.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.

    "    gc_symbol_alv->set_ready_for_input( i_ready_for_input = 1 ). "CDX PERFORMANCE

  ENDMETHOD.


  METHOD create_variant.
****************************************************************************************************
* Description             : Save Variant Method                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               :                          Company    : Cadaxo GmbH                          *
* Date                    :                          Release    :                                  *

*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 20.2.2018  | Dusan Sacha          | Symbols Multi Value Upgrade                 | Cadaxo-288     *
*------------+----------------------+---------------------------------------------+----------------*
* 25.11.2020 | Attila Kajtar        | Feedback/Support 3.3.0                      | COCKPIT-321    *
****************************************************************************************************
    DATA: ls_variant    TYPE /cadaxo/sqlc_il_variants.
    DATA: l_string      TYPE string.
    DATA: lt_symbols     TYPE /cadaxo/sqlc_symbol_t.           "COCKPIT-288 Insert
    DATA: lv_variant_created TYPE /cadaxo/sqlcvari_name.       "COCKPIT-321 KA
* get editor
    me->get_sql_area( IMPORTING e_code_string = l_string ).

    IF NOT l_string IS INITIAL.

      ls_variant-t_sql     = me->get_sql_area_lt_code( ).

      me->get_user_symbol_from_sql(
        EXPORTING
          i_sql      = ls_variant-t_sql
          i_type     = 'U'
        IMPORTING
          e_symbols  = lt_symbols ).

      LOOP AT lt_symbols ASSIGNING FIELD-SYMBOL(<ls_symbol>).

        APPEND CORRESPONDING #( <ls_symbol> ) TO ls_variant-t_symbol. "COCKPIT-288 Insert

      ENDLOOP.

* execute create variant popup
      CALL FUNCTION '/CADAXO/SQLC_CREATE_VARIANT_UI'
        EXPORTING
          i_mode     = 'I'
          il_variant = ls_variant
        CHANGING
          c_vari_name = lv_variant_created. "COCKPIT-321 KA

      "begin of COCKPIT-321
      IF lv_variant_created IS NOT INITIAL.
        gs_sel_variant-varname = lv_variant_created.
        DATA(l_ctmenu3) = NEW cl_ctmenu( ).
        l_ctmenu3->add_function( EXPORTING fcode = 'SQLVARSET' text = text-q40 checked = abap_true icon = icon_alv_variant_save ).
        l_ctmenu3->add_function( EXPORTING fcode = 'SQLVARSET_UPD' text = CONV #( |{ text-b46 } { lv_variant_created }| )
                                                                   disabled = abap_false ).

        gc_splitter_top_toolbar->set_static_ctxmenu(
          EXPORTING
            fcode                = 'SQLVARSET'
            ctxmenu              = l_ctmenu3
        ).

      ENDIF.
      "end of COCKPIT-321

    ELSE.
      MESSAGE e048(/cadaxo/sqlc).
    ENDIF.

  ENDMETHOD.


  METHOD delete_log.

    DATA l_rc(1).

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = text-t13
        text_question         = text-q25
        text_button_1         = text-x03
        icon_button_1         = 'ICON_OKAY'
        text_button_2         = text-x04
        icon_button_2         = 'ICON_CANCEL'
        default_button        = '2'
        display_cancel_button = abap_false
      IMPORTING
        answer                = l_rc.
    IF l_rc = '1'.
      DELETE FROM /cadaxo/sqlclog WHERE uname = sy-uname.
      IF sy-subrc = 0.
        COMMIT WORK.
        MESSAGE s092(/cadaxo/sqlc) WITH sy-dbcnt.

        me->show_log( ).

      ELSE.
        ROLLBACK WORK.
        MESSAGE s001(/cadaxo/sqlc) DISPLAY LIKE 'E'.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD delete_symbols.
****************************************************************************************************
* Description             : delete user symbols                                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | I18N Messages                               | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lt_index_rows TYPE lvc_t_row,
          ls_index_row  LIKE LINE OF lt_index_rows.

    DATA ls_symbol LIKE LINE OF gt_symbol.
    DATA: lt_delete_rows_index TYPE TABLE OF i,
          ld_index             TYPE i.

* get selected records
    gc_symbol_alv->get_selected_rows( IMPORTING et_index_rows = lt_index_rows ).
    LOOP AT lt_index_rows INTO ls_index_row.

      READ TABLE gt_symbol INDEX ls_index_row-index
                           INTO ls_symbol
                           TRANSPORTING symbol_name
                                        type.
      IF sy-subrc = 0.
*     delete program symbol not allowed
        IF ls_symbol-type = cs_symbol_type-program.

          REFRESH gt_symbol_delete.
*       focus the record
          me->focus_symbol_alv_cell( i_row_id     = ls_index_row-index
                                     i_field_name = 'SYMBOL_NAME' ).

          MESSAGE s057(/cadaxo/sqlc) DISPLAY LIKE 'E'.               "CDX001-0020
          RETURN.

        ENDIF.
*     Exclude create symbols
        IF NOT ls_symbol-type = cs_symbol_type-create.
          APPEND ls_symbol TO gt_symbol_delete.
        ENDIF.

        ld_index = ls_index_row-index.
        APPEND ld_index TO lt_delete_rows_index.

      ENDIF.

    ENDLOOP.

* delete records on ALV
    SORT lt_delete_rows_index DESCENDING.
    LOOP AT lt_delete_rows_index INTO ld_index.

      DELETE gt_symbol INDEX ld_index.

    ENDLOOP.

    e_success = abap_true.

    me->on_symbol_alv_user_command( e_ucomm = 'SYMBOL_SAVE' ).                   "CDX001-0020


  ENDMETHOD.


  METHOD delete_symbol_db.

    DATA lt_symbol_db_delete TYPE TABLE OF /cadaxo/sqlcusym.

    DATA l_symbol    LIKE LINE OF gt_symbol[].
    DATA l_symbol_db LIKE LINE OF lt_symbol_db_delete.

    IF NOT gt_symbol_delete IS INITIAL.

      LOOP AT gt_symbol_delete INTO l_symbol.

        MOVE-CORRESPONDING l_symbol TO l_symbol_db.
        l_symbol_db-username = sy-uname.
        APPEND l_symbol_db TO lt_symbol_db_delete.

      ENDLOOP.

      REFRESH gt_symbol_delete.

      DELETE /cadaxo/sqlcusym FROM TABLE lt_symbol_db_delete.
      IF sy-subrc = 0.

        rv_success = abap_true.

      ELSE.

        ROLLBACK WORK.
        MESSAGE s055(/cadaxo/sqlc) WITH text-ded DISPLAY LIKE 'E'."CDX001-0020
        RETURN.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD error_calc_height.
    ev_height = toolbar_row_height * 3.

    IF iv_errors <= 2.
      ev_height = toolbar_row_height * 3.
    ELSEIF iv_errors <= 4.
      ev_height = toolbar_row_height * 5.
    ENDIF.
  ENDMETHOD.


  METHOD execute_sql.
****************************************************************************************************
* Description             : Execute Select Statements                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2015               Release    : WAS 7.40 SP8                     *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 29.08.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Use the trace user settings                 | CDX001-0008    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.04.2016 | Ana Lekic            | activate the trace later                    | $002 COCKPIT-59*
*------------+----------------------+---------------------------------------------+----------------*
* 31.05.2016 | Ana Lekic            | error message from subpool                  | COCKPIT-61     *
*            |                      |                                             | $001           *^
*------------+----------------------+---------------------------------------------+----------------*
* 19.02.2017 | Domi Bigl            | Runtime errors                              | COCKPIT-103    *
*------------+----------------------+---------------------------------------------+----------------*
* 19.10.2020 | Kajtar Attila        | Add domain values                           | COCKPIT-458    *
****************************************************************************************************

    DATA l_result_details         TYPE /cadaxo/sqlcresult_details.
    DATA l_error_message          TYPE string.
    DATA lt_lvc_t_fcat            TYPE lvc_t_fcat.
    DATA lr_exception             TYPE REF TO cx_root.
    DATA l_message                TYPE string.
    DATA l_index_sql              TYPE i.
    DATA l_header_text            TYPE /cadaxo/sqlcheaderline.

    FIELD-SYMBOLS: <lr_cl_sql_parse>   TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.

    TRY.

        me->save_hold_lists( ).

        me->check_sql_syntax( ).

        me->check_dbtable_modification( ).

        me->free_result_controls( ).

        CLEAR: dref_result_tab_t[],
               gt_lvc_t_fcat[],
               gt_lvc_t_sort[],
               gt_lvc_t_filt[],
               gt_lvc_s_layo[],
               gt_result_details[],
               g_active_list_tab.

        CLEAR gt_errors.                                                            "COCKPIT-103

* loop over the sql
        LOOP AT gt_cl_sql_parse ASSIGNING <lr_cl_sql_parse>.

          l_index_sql = sy-tabix.

          IF <lr_cl_sql_parse>->g_hold_result <> space.
            CONTINUE.
          ENDIF.

          CLEAR: l_result_details,
                 l_error_message.

          <lr_cl_sql_parse>->g_main_ref = me.

* create fieldcatalog
          IF <lr_cl_sql_parse>->g_select_version = <lr_cl_sql_parse>->c_select_version_1.
            lt_lvc_t_fcat = <lr_cl_sql_parse>->create_alv_field_catalog( i_user_settings   = me->g_user_settings
                                                                         i_dragdrop_handle = dragdrop_handle ).
* create result structures
            <lr_cl_sql_parse>->create_result_structures( ).
            APPEND <lr_cl_sql_parse>->gt_lvc_t_fcat TO gt_lvc_t_fcat.
          ENDIF.

          CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
            EXPORTING
              text = text-p01.

          DATA: l_timestamp TYPE timestampl.

          /cadaxo/cl_sqlc_cockpit_parse=>insert_sql_to_log( EXPORTING i_sql_string = <lr_cl_sql_parse>->sql_syntax
                                                            IMPORTING e_timestamp  = l_timestamp ).

          <lr_cl_sql_parse>->execute_select( EXPORTING i_user_settings      = me->ms_user_settings_xml
                                                       i_progress_indicator = i_progress_indicator
                                             IMPORTING e_result_details     = l_result_details ).

          "COCKPIT-458 BEGIN
          IF <lr_cl_sql_parse>->g_select_version EQ /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_2.
            IF <lr_cl_sql_parse>->g_main_ref->g_user_settings-domaintext EQ abap_true.
              <lr_cl_sql_parse>->add_domain_value( ).
              me->gt_lvc_t_fcat[ l_index_sql ] = <lr_cl_sql_parse>->gt_lvc_t_fcat.
            ENDIF.
          ENDIF.
          "COCKPIT-458 END

          APPEND <lr_cl_sql_parse>->result_table TO dref_result_tab_t.

          /cadaxo/cl_sqlc_cockpit_parse=>update_sql_to_log( EXPORTING i_timestamp      = l_timestamp
                                                                      i_sql_string     = <lr_cl_sql_parse>->sql_syntax
                                                                      i_result_runtime = l_result_details-runtime
                                                                      i_result_lines   = l_result_details-lines ).

          CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
            EXPORTING
              text = text-p02. "The data are formatted for output

          IF l_error_message IS INITIAL.
            me->g_result_layout-grid_title = /cadaxo/cl_sqlc_cockpit_main=>build_result_grid_title( i_runtime = l_result_details-runtime
                                                                                                    i_lines   = l_result_details-lines ).
          ELSE.
            me->g_result_layout-grid_title = l_error_message.

          ENDIF.

          l_result_details-mandant = cl_abap_syst=>get_client( ).
          l_result_details-uname   = cl_abap_syst=>get_user_name( ).
          GET TIME STAMP FIELD l_result_details-create_timestamp.

* get header text
          READ TABLE me->gt_headerlines WITH KEY alv_no = l_index_sql INTO l_header_text.
          IF sy-subrc = 0 AND l_header_text-text <> space.
            l_result_details-header_line_text = l_header_text-text.
          ENDIF.

          APPEND l_result_details TO gt_result_details.

* set buttons
          IF me->mv_toolbar_result_active <> c_cmd_show_result_table.
            me->set_result_toolbar_active( i_fcode = c_cmd_show_result_table ).
          ENDIF.
        ENDLOOP.

        me->add_hold_lists( ).

      CATCH cx_sy_generate_subpool_full.
        MESSAGE i038(/cadaxo/sqlc).
      CATCH /cadaxo/cx_sqlc_syntax_error INTO lr_exception.
        l_message = lr_exception->get_text( ).
        IF l_message IS INITIAL.
          l_message = text-e02.     "+Cockpit-374
*          l_message = 'EXC!'.      "-Cockpit-374
        ENDIF.
      CATCH cx_sy_no_handler INTO lr_exception.
        lr_exception = lr_exception->previous.
        l_message = lr_exception->get_text( ).
        IF l_message IS INITIAL.
          l_message = 'EXC!'.
        ENDIF.
      CATCH cx_root INTO lr_exception.
        l_message = lr_exception->get_text( ).
        IF l_message IS INITIAL.
          l_message = 'EXC!'.
        ENDIF.
      CLEANUP.
    ENDTRY.

    IF l_message IS INITIAL.
      me->show_result( ). "SHOW_RESULT
    ENDIF.

    IF NOT l_message IS INITIAL.

      handle_msg_exception(                  "COCKPIT-269
       EXPORTING i_msg = l_message           "COCKPIT-269
                 i_exception = lr_exception  "COCKPIT-269
      ).                                     "COCKPIT-269

    ELSE.

* refresh table display and set the height to 0
*    gc_abap_error->is_valid( IMPORTING result =  DATA(lv_valid) ).  " 0: Not Valid; 1: Valid "COCKPIT-185
*    IF gc_abap_error->is_alive( ) AND lv_valid = 1.
      gc_abap_error->refresh_table_display( ).
      gs_splitter_editor->set_row_height( id = 2 height = 0 ).
*    ENDIF.

    ENDIF.

    FREE: lt_lvc_t_fcat.
  ENDMETHOD.


  METHOD execute_sql_background.
****************************************************************************************************
* Description             : SQL Cockpit - Backgroundjob for SQL Cockpit                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 16.04.2011                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 19.09.2014 | Wiesinger            | show released line for periodic job         |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.04.2016 | Ana Lekic            | save system/client with job                 | $002 COCKPIT-4 *
*------------+----------------------+---------------------------------------------+----------------*
* 13.05.2019 | Domi Bigl            | Dump at open list when V1 and V2 SQL is used| COCKPIT-375    *
*------------+----------------------+---------------------------------------------+----------------*
* 01.06.2019 | Domi Bigl            | Manuell planned Jobs                        | COCKPIT-348    *
****************************************************************************************************

*...

    DATA: lcl_sqlc_cockpit   TYPE REF TO /cadaxo/cl_sqlc_cockpit_main,
          result_details     TYPE /cadaxo/sqlcresult_details,
          lt_result_details  TYPE TABLE OF /cadaxo/sqlcresult_details,
          ls_sqlcresult_ref  TYPE /cadaxo/sqlcresult_ref,
          lt_cl_sql_parse    TYPE /cadaxo/sqlc_cl_cockpit_parset,
          lr_exception       TYPE REF TO cx_static_check,
          ls_sqlcsres        TYPE /cadaxo/sqlcsres,
          ls_sqlcsres_tmp    TYPE /cadaxo/sqlcsres,
          l_sql_string       TYPE string,
          ls_sqlcresultsave  TYPE /cadaxo/sqlcresultsave,
          lt_sqlcresultsave  TYPE TABLE OF /cadaxo/sqlcresultsave,
          ls_sqlcress        TYPE /cadaxo/sqlcress,
          lt_code            TYPE /cadaxo/sqlccodeline_t,
          l_xml              TYPE string,
          lt_result_list_raw TYPE TABLE OF xstring,
          ls_result_list_raw TYPE xstring,
          l_timestamp        TYPE timestampl,
          lv_variant         TYPE btcvariant.

    DATA ls_tbtco            TYPE tbtco.
    DATA lt_lvc_t_fcat       TYPE lvc_t_fcat.
    DATA l_btcjob            TYPE btcjob.
    DATA l_btcjobcnt         TYPE btcjobcnt.

    FIELD-SYMBOLS: <lr_cl_sql_parse> TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
    FIELD-SYMBOLS: <ls_t>            TYPE ANY TABLE.

    CLEAR l_btcjob.
    CLEAR l_btcjobcnt.

    CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
      IMPORTING
        jobcount        = l_btcjobcnt
        jobname         = l_btcjob
      EXCEPTIONS
        no_runtime_info = 1
        OTHERS          = 2.

*# 4660 - 20140919
    IF l_btcjob IS NOT INITIAL.
      SELECT SINGLE * FROM /cadaxo/sqlcsres INTO ls_sqlcsres WHERE jobcount = l_btcjobcnt AND jobname = l_btcjob.
    ENDIF.
    IF sy-subrc <> 0 OR l_btcjob IS INITIAL.
      SELECT SINGLE * FROM /cadaxo/sqlcsres INTO ls_sqlcsres WHERE list_guid = i_list_guid.
      IF sy-subrc <> 0.
        IF sy-batch IS NOT INITIAL.
          MESSAGE e143(/cadaxo/sqlc) WITH i_list_guid.
        ENDIF.
        MESSAGE x143(/cadaxo/sqlc) WITH i_list_guid.
      ENDIF.
    ENDIF.

* get variant
    SELECT SINGLE variant FROM tbtcp INTO lv_variant WHERE jobname = l_btcjob AND jobcount = l_btcjobcnt.
    IF sy-subrc = 0.
*   check for open periodic job -> create new initial line in sqlcsres
      SELECT SINGLE *
        FROM tbtco AS a
        INNER JOIN tbtcp AS b
        ON a~jobname = b~jobname
        AND a~jobcount = b~jobcount
        INTO CORRESPONDING FIELDS OF ls_tbtco
          WHERE a~jobname = l_btcjob
            AND b~variant = lv_variant
            AND ( strtdate = '' OR strttime = '' ).
      IF sy-subrc = 0.
        CLEAR ls_sqlcsres_tmp.
        ls_sqlcsres_tmp = ls_sqlcsres.
        CLEAR ls_sqlcsres_tmp-ress_guid.
        ls_sqlcsres_tmp-jobcount  = ls_tbtco-jobcount.
        ls_sqlcsres_tmp-list_guid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        GET TIME STAMP FIELD ls_sqlcsres_tmp-create_timestamp.
        INSERT INTO /cadaxo/sqlcsres VALUES ls_sqlcsres_tmp.
      ENDIF.
    ENDIF.
*# 4660 - 20140919

    cl_abap_gzip=>decompress_text( EXPORTING  gzip_in  = ls_sqlcsres-sql_string
                                   IMPORTING text_out = l_sql_string ).

    lcl_sqlc_cockpit = NEW #( ).

    TRY.

* replace all symbols
        /cadaxo/cl_sqlc_cockpit_assist=>replace_all_symbols_with_value( CHANGING c_string = l_sql_string ).

        CLEAR lcl_sqlc_cockpit->ms_user_settings_xml-maxsel. "#Cockpit-338

* parse the sql string
        /cadaxo/cl_sqlc_cockpit_parse=>parse_sql_i(
          EXPORTING
            i_sql                       = l_sql_string
            i_user_settings             = lcl_sqlc_cockpit->ms_user_settings_xml
            i_role                      = lcl_sqlc_cockpit->g_auth
          IMPORTING
            e_sql_parsed                = lt_cl_sql_parse ).

* check the sql syntax
        /cadaxo/cl_sqlc_cockpit_parse=>check_sql_syntax( lt_cl_sql_parse ).

        LOOP AT lt_cl_sql_parse ASSIGNING <lr_cl_sql_parse>.
          <lr_cl_sql_parse>->parse_sql_ii( ).
          <lr_cl_sql_parse>->blacklist_check_tables( ).
          <lr_cl_sql_parse>->parse_sql_where_columns( ).
          <lr_cl_sql_parse>->g_main_ref = lcl_sqlc_cockpit.
        ENDLOOP.

        LOOP AT lt_cl_sql_parse ASSIGNING <lr_cl_sql_parse>.

          IF <lr_cl_sql_parse>->g_select_version = <lr_cl_sql_parse>->c_select_version_1.
            <lr_cl_sql_parse>->create_alv_field_catalog( i_user_settings = lcl_sqlc_cockpit->g_user_settings
                                                         i_dragdrop_handle = 0 ).
            <lr_cl_sql_parse>->create_result_structures( ).
          ENDIF.

          /cadaxo/cl_sqlc_cockpit_parse=>insert_sql_to_log( EXPORTING i_sql_string = <lr_cl_sql_parse>->sql_syntax
                                                                      i_sql_mode   = '02'
                                                            IMPORTING e_timestamp  = l_timestamp ).

          <lr_cl_sql_parse>->execute_select( EXPORTING i_user_settings  = lcl_sqlc_cockpit->ms_user_settings_xml
                                             IMPORTING e_result_details = result_details ).

          APPEND result_details TO lt_result_details.

          /cadaxo/cl_sqlc_cockpit_parse=>update_sql_to_log( EXPORTING i_timestamp      = l_timestamp
                                                                      i_sql_string     = <lr_cl_sql_parse>->sql_syntax
                                                                      i_result_runtime = result_details-runtime
                                                                      i_result_lines   = result_details-lines
                                                                      i_sql_mode       = '02'  ).

          CLEAR ls_sqlcresult_ref.

          ls_sqlcresult_ref-table_dref = <lr_cl_sql_parse>->result_table.

        ENDLOOP.

        ls_sqlcress-ress_guid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).

        ls_sqlcsres-ress_guid = ls_sqlcress-ress_guid.

        LOOP AT lt_cl_sql_parse ASSIGNING <lr_cl_sql_parse>.

          ls_sqlcresultsave-main-result_details = lt_result_details[ sy-tabix ].

          IF <lr_cl_sql_parse>->g_select_version = <lr_cl_sql_parse>->c_select_version_1.
            lt_lvc_t_fcat = <lr_cl_sql_parse>->create_alv_field_catalog( i_user_settings = lcl_sqlc_cockpit->g_user_settings
                                                                         i_dragdrop_handle = 0 ).
          ENDIF.

          ls_sqlcresultsave-parse-column_syntax            = <lr_cl_sql_parse>->column_syntax.
          ls_sqlcresultsave-parse-source_syntax            = <lr_cl_sql_parse>->source_syntax.
          ls_sqlcresultsave-parse-where_syntax             = <lr_cl_sql_parse>->where_syntax.
          ls_sqlcresultsave-parse-group_syntax             = <lr_cl_sql_parse>->group_syntax.
          ls_sqlcresultsave-parse-having_syntax            = <lr_cl_sql_parse>->having_syntax.
          ls_sqlcresultsave-parse-order_syntax             = <lr_cl_sql_parse>->order_syntax.
          ls_sqlcresultsave-parse-dbhint_syntax            = <lr_cl_sql_parse>->dbhint_syntax.
          ls_sqlcresultsave-parse-connection_syntax        = <lr_cl_sql_parse>->connection_syntax.
          ls_sqlcresultsave-parse-sql_syntax               = <lr_cl_sql_parse>->sql_syntax.
          ls_sqlcresultsave-parse-result_ddfields          = <lr_cl_sql_parse>->gt_result_ddfields.
          ls_sqlcresultsave-parse-result_source            = <lr_cl_sql_parse>->result_source_t.
          ls_sqlcresultsave-parse-up_to_x_rows             = <lr_cl_sql_parse>->g_up_to_x_rows.
          ls_sqlcresultsave-parse-select_single            = <lr_cl_sql_parse>->g_select_single.
          ls_sqlcresultsave-parse-sql_syntax_without_where = <lr_cl_sql_parse>->sql_syntax_without_where.
          ls_sqlcresultsave-parse-client_specified         = <lr_cl_sql_parse>->gs_client_handling-client_specified.
          ls_sqlcresultsave-parse-using_client             = <lr_cl_sql_parse>->gs_client_handling-using_client.
          ls_sqlcresultsave-parse-bypassing_buffer         = <lr_cl_sql_parse>->g_bypassing_buffer.
          ls_sqlcresultsave-parse-subquery                 = <lr_cl_sql_parse>->subquery.

          CASE <lr_cl_sql_parse>->g_select_version.                                            "COCKPIT-375
            WHEN /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_1.
              ls_sqlcresultsave-parse-result_fieldcatalog = lt_lvc_t_fcat.
            WHEN /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_2.
              ls_sqlcresultsave-parse-result_fieldcatalog = <lr_cl_sql_parse>->gt_lvc_t_fcat.
          ENDCASE.

          ls_sqlcresult_ref-table_dref = <lr_cl_sql_parse>->result_table.

          ASSIGN ls_sqlcresult_ref-table_dref->* TO <ls_t>.

          EXPORT result FROM <ls_t> TO DATA BUFFER ls_result_list_raw.

          cl_abap_gzip=>compress_binary( EXPORTING raw_in   = ls_result_list_raw
                                         IMPORTING gzip_out = ls_result_list_raw ).


          APPEND ls_sqlcresultsave  TO lt_sqlcresultsave.
          APPEND ls_result_list_raw TO lt_result_list_raw.

        ENDLOOP.


        CALL TRANSFORMATION id SOURCE result_save = lt_sqlcresultsave
                               RESULT XML l_xml.
        cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                                     IMPORTING gzip_out = ls_sqlcress-rawdata ).

        ls_sqlcress-uname = sy-uname.

        ls_sqlcress-editor_sqlstring = ls_sqlcsres-editor_sqlstring.

        EXPORT result FROM lt_result_list_raw TO DATA BUFFER ls_sqlcress-rawresult.

        ls_sqlcsres-space_cons_zip = xstrlen( ls_sqlcress-rawresult ) / 1024.
        ls_sqlcsres-syst        = sy-sysid. "$002
        ls_sqlcsres-mandant     = sy-mandt. "$002

        ls_sqlcsres-nr_of_selects = lines( lt_cl_sql_parse ).

        IF ls_sqlcsres-jobcount <> l_btcjobcnt.
          ls_sqlcsres-list_guid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).

          ls_sqlcsres-jobcount = l_btcjobcnt.
        ENDIF.

        MODIFY /cadaxo/sqlcress FROM ls_sqlcress.
        MODIFY /cadaxo/sqlcsres FROM ls_sqlcsres.

* catch exceptions
      CATCH /cadaxo/cx_sqlc_symb_not_found
            /cadaxo/cx_sqlc_no_sel_at_firs
            /cadaxo/cx_sqlc_syntax_error
            /cadaxo/cx_sqlc_no_source
            /cadaxo/cx_sqlc_to_much_resrow INTO lr_exception.
      CATCH cx_sy_open_sql_db.
    ENDTRY.

    CALL FUNCTION 'BP_EVENT_RAISE'
      EXPORTING
        eventid         = '/CADAXO/MAIL_NOTIF'
        eventparm       = i_list_guid
        target_instance = ' '
      EXCEPTIONS
        OTHERS          = 1.
    IF sy-subrc <> 0.
    ENDIF.

    FREE: ls_sqlcress,
          ls_sqlcsres,
          lt_code.

  ENDMETHOD.


  METHOD execute_sql_background_wiz.
****************************************************************************************************
* Description             : SQL Cockpit - Execute Job Wizard                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 16.04.2011                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add nr. of selects to jobmonitor            | CDX130-004     *
*------------+----------------------+---------------------------------------------+----------------*
* 28.10.2016 | Domi Bigl            | Jobs with old Editor                        | COCKPIT-7      *
*------------+----------------------+---------------------------------------------+----------------*
* 16.05-2017 | Harald Wiesinger     | DATA LOSS Dump with periodic Jobs           | COCKPIT-205    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_lines                TYPE i,
          lr_exception           TYPE REF TO cx_root,
          l_message              TYPE string,
          l_sql_string           TYPE string,
          ls_jobstart_conditions TYPE /cadaxo/sqlc_jobwiz_fields,
          l_xml                  TYPE string,
          ls_sqlcsres            TYPE /cadaxo/sqlcsres,
          l_btcjob_notif         TYPE btcjob,
          l_btcjobcnt_notif      TYPE btcjobcnt,
          lt_code                TYPE /cadaxo/sqlccodeline_t,
          l_jobgroup(1),
          ls_sqlcsres_tmp        TYPE /cadaxo/sqlcsres.

    DATA lt_saved_lists   TYPE /cadaxo/sqlcsresalv_t.
    DATA l_free_space_kb  TYPE int4.
    DATA ls_adm_cust      TYPE /cadaxo/sqlc_admin_cust.
    DATA ls_tbtcjob       TYPE tbtcjob.
    DATA l_event_param    TYPE btcevtparm.
    DATA l_event_periodic TYPE c LENGTH 1.

* check job release authorization

    AUTHORITY-CHECK
      OBJECT 'S_BTCH_JOB'
          ID 'JOBGROUP'  FIELD l_jobgroup
          ID 'JOBACTION' FIELD 'RELE'.
    IF sy-subrc <> 0.
      AUTHORITY-CHECK
        OBJECT 'S_BTCH_ADM'
            ID 'BTCADMIN' FIELD 'Y'.
      IF sy-subrc <> 0.
        MESSAGE e115(/cadaxo/sqlc) WITH 'S_BTCH_ADM' 'S_BTCH_JOB' '' ''.
      ENDIF.
    ENDIF.

    TRY.

        CLEAR: l_btcjob_notif,
               l_btcjobcnt_notif,
               ls_tbtcjob,
               l_event_param,
               l_event_periodic.

* check sql syntax
        me->check_sql_syntax( i_use_local_parser = abap_true ).

* check free space for the job
        /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).

        IF ls_adm_cust-maxspace GT 0.
          /cadaxo/cl_sqlc_cockpit_lists=>get_saved_lists( EXPORTING i_uname = sy-uname
                                                          IMPORTING e_saved_lists = lt_saved_lists
                                                                    e_free_space_kb = l_free_space_kb ).
          IF l_free_space_kb LT 0.
            MESSAGE e085(/cadaxo/sqlc) WITH ls_adm_cust-maxspace.
          ENDIF.
        ENDIF.

* how many sql selects does the user execute
        l_lines = lines( gt_cl_sql_parse ).
        MOVE l_lines TO ls_sqlcsres-nr_of_selects.            "CDX130-004

* get sql string from editor control
        me->get_sql_area( IMPORTING e_code_string = l_sql_string ).

* get source code from sql editor
        IF me->gc_abap_editor IS BOUND.                                                    "COCKPIT-7
          me->gc_abap_editor->get_text( IMPORTING table = lt_code ).
        ELSE.                                                                              "COCKPIT-7
          me->gc_abap_editor_text->get_text_as_r3table( IMPORTING table = lt_code ).       "COCKPIT-7
        ENDIF.                                                                             "COCKPIT-7

* export the code into databuffer
        EXPORT code FROM lt_code[] TO DATA BUFFER ls_sqlcsres-editor_sqlstring.

* check if i_sql_String is not initial

* call wizard dialog
        CALL FUNCTION '/CADAXO/SQLC_JOB_SCHEDULING'
          IMPORTING
            e_start_conditions = ls_jobstart_conditions
          EXCEPTIONS
            cancel_by_user     = 1
            OTHERS             = 2.
        IF sy-subrc = 0.

          CALL TRANSFORMATION id
             SOURCE settings = ls_jobstart_conditions
             RESULT XML l_xml.

          cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                                       IMPORTING gzip_out = ls_sqlcsres-jobstartcond ).

          cl_abap_gzip=>compress_text( EXPORTING text_in  = l_sql_string
                                       IMPORTING gzip_out = ls_sqlcsres-sql_string ).

          CALL FUNCTION 'GUID_CREATE'
            IMPORTING
              ev_guid_16 = ls_sqlcsres-list_guid.

          GET TIME STAMP FIELD ls_sqlcsres-create_timestamp.

* Insert Jobdefinition to DB
          CALL FUNCTION 'JOB_OPEN'
            EXPORTING
              jobname          = ls_jobstart_conditions-jobname
              jobclass         = ls_jobstart_conditions-jobclass
            IMPORTING
              jobcount         = ls_sqlcsres-jobcount
            EXCEPTIONS
              cant_create_job  = 1
              invalid_job_data = 2
              jobname_missing  = 3
              OTHERS           = 4.

          ls_sqlcsres-uname   = sy-uname.
          ls_sqlcsres-jobname = ls_jobstart_conditions-jobname.
          ls_sqlcsres-type    = 'JOB'.

          CONCATENATE 'Jobname:' ls_jobstart_conditions-jobname INTO ls_sqlcsres-description SEPARATED BY space.

          INSERT /cadaxo/sqlcsres FROM ls_sqlcsres.

          COMMIT WORK.

          SUBMIT /cadaxo/sqlc_batch_execute
                 WITH pjobguid = ls_sqlcsres-list_guid
                 VIA JOB ls_jobstart_conditions-jobname
                 NUMBER ls_sqlcsres-jobcount
              AND RETURN.
          CASE abap_true.
            WHEN ls_jobstart_conditions-periodic_minutely.
              MOVE 1 TO ls_tbtcjob-prdmins.
              l_event_periodic = abap_true.
            WHEN ls_jobstart_conditions-periodic_hourly.
              MOVE 1 TO ls_tbtcjob-prdhours.
              l_event_periodic = abap_true.
            WHEN ls_jobstart_conditions-periodic_daily.
              MOVE 1 TO ls_tbtcjob-prddays.
              l_event_periodic = abap_true.
            WHEN ls_jobstart_conditions-periodic_weekly.
              MOVE 1 TO ls_tbtcjob-prdweeks.
              l_event_periodic = abap_true.
            WHEN ls_jobstart_conditions-periodic_monthly.
              MOVE 1 TO ls_tbtcjob-prdmonths.
              l_event_periodic = abap_true.
          ENDCASE.

          IF ls_jobstart_conditions-notification_email1 IS NOT INITIAL
          OR ls_jobstart_conditions-notification_email2 IS NOT INITIAL
          OR ls_jobstart_conditions-notification_sap_mail IS NOT INITIAL.

            l_btcjob_notif = '/CADAXO/MAIL_NOTIF'.
            l_event_param  = ls_sqlcsres-list_guid.

            CALL FUNCTION 'JOB_OPEN'
              EXPORTING
                jobname  = l_btcjob_notif
                jobclass = 'C'
              IMPORTING
                jobcount = l_btcjobcnt_notif
              EXCEPTIONS
                OTHERS   = 1.

            SUBMIT /cadaxo/sqlc_batch_executemail
                   WITH pjobguid = ls_sqlcsres-list_guid
                   VIA JOB l_btcjob_notif
                   NUMBER l_btcjobcnt_notif
                   AND RETURN.

            CALL FUNCTION 'JOB_CLOSE'
              EXPORTING
                jobcount       = l_btcjobcnt_notif
                jobname        = l_btcjob_notif
                event_id       = '/CADAXO/MAIL_NOTIF'
                event_param    = l_event_param
                event_periodic = l_event_periodic
              EXCEPTIONS
                OTHERS         = 9.
          ENDIF.

          CASE abap_true.
            WHEN ls_jobstart_conditions-immediately.
              CALL FUNCTION 'JOB_CLOSE'
                EXPORTING
                  jobcount  = ls_sqlcsres-jobcount
                  jobname   = ls_jobstart_conditions-jobname
                  strtimmed = ls_jobstart_conditions-immediately
                  prdmins   = ls_tbtcjob-prdmins
                  prddays   = ls_tbtcjob-prddays
                  prdhours  = ls_tbtcjob-prdhours
                  prdmonths = ls_tbtcjob-prdmonths
                  prdweeks  = ls_tbtcjob-prdweeks
                EXCEPTIONS
                  OTHERS    = 9.

              COMMIT WORK AND WAIT.

              IF l_event_periodic = abap_true.

                SELECT SINGLE @abap_true FROM tbtco WHERE jobname = @ls_jobstart_conditions-jobname
                                                      AND (    strtdate = '00000000' OR strtdate IS NULL
                                                            OR strttime = '000000'   OR strttime IS NULL )   "COCKPIT-205
                                                    INTO @DATA(lv_exists).
                IF sy-subrc = 0.
*             create initial csres line
                  CLEAR ls_sqlcsres_tmp.
                  ls_sqlcsres_tmp = ls_sqlcsres.
                  CLEAR ls_sqlcsres_tmp-ress_guid.

                  CALL FUNCTION 'GUID_CREATE'
                    IMPORTING
                      ev_guid_16 = ls_sqlcsres_tmp-list_guid.
                  INSERT INTO /cadaxo/sqlcsres VALUES ls_sqlcsres_tmp.
                ENDIF.
              ENDIF.

            WHEN ls_jobstart_conditions-planned.
              CALL FUNCTION 'JOB_CLOSE'
                EXPORTING
                  jobcount   = ls_sqlcsres-jobcount
                  jobname    = ls_jobstart_conditions-jobname
                  laststrtdt = ls_jobstart_conditions-laststrtdt
                  laststrttm = ls_jobstart_conditions-laststrttm
                  sdlstrtdt  = ls_jobstart_conditions-sdlstrtdt
                  sdlstrttm  = ls_jobstart_conditions-sdlstrttm
                  prdmins    = ls_tbtcjob-prdmins
                  prddays    = ls_tbtcjob-prddays
                  prdhours   = ls_tbtcjob-prdhours
                  prdmonths  = ls_tbtcjob-prdmonths
                  prdweeks   = ls_tbtcjob-prdweeks
                EXCEPTIONS
                  OTHERS     = 9.
            WHEN ls_jobstart_conditions-scheduled.
              CALL FUNCTION 'JOB_CLOSE'
                EXPORTING
                  jobcount = ls_sqlcsres-jobcount
                  jobname  = ls_jobstart_conditions-jobname
                EXCEPTIONS
                  OTHERS   = 9.
          ENDCASE.

          MESSAGE s155(/cadaxo/sqlc)  DISPLAY LIKE 'S'.
          me->show_jobmonitor( ).

        ELSEIF sy-subrc = 1.
          MESSAGE s042(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
        ENDIF.

      CATCH cx_sy_generate_subpool_full.
        MESSAGE i038(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
      CATCH cx_root INTO lr_exception.
        l_message = lr_exception->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD FILL_USED_SYMBOLS.

  DATA: lv_sql_string TYPE string.
  DATA: lt_results    TYPE match_result_tab.
  FIELD-SYMBOLS: <ls_result> LIKE LINE OF lt_results.

    IF gc_abap_editor IS INITIAL AND gc_abap_editor_text IS INITIAL.
      RETURN.
    ENDIF.
    me->get_sql_area( IMPORTING e_code_string    = lv_sql_string ).

    /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex(
      EXPORTING
        i_where_syntax =     lv_sql_string
      IMPORTING
        e_result_tab   =     lt_results
    ).

      LOOP AT lt_results ASSIGNING <ls_result>.

        DATA(l_from) = <ls_result>-offset + 1.
        DATA(l_length) = <ls_result>-length - 2.

        DATA(l_symbol_name) = lv_sql_string+l_from(l_length).
        APPEND to_upper( l_symbol_name ) TO rt_symbols.

      ENDLOOP.

  ENDMETHOD.


  METHOD focus_symbol_alv_cell.
****************************************************************************************************
* Description             : focus symbol alv cell                                                  *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_row_id    TYPE lvc_s_row,
          l_column_id TYPE lvc_s_col,
          l_row_no    TYPE lvc_s_roid.

    l_row_id-index        = i_row_id.
    l_column_id-fieldname = i_field_name.
    l_row_no-row_id       = i_row_id.

    CALL METHOD gc_symbol_alv->set_current_cell_via_id
      EXPORTING
        is_row_id    = l_row_id
        is_column_id = l_column_id
        is_row_no    = l_row_no.


  ENDMETHOD.


  METHOD free_result_controls.
****************************************************************************************************
* Description             : free result controls                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_index TYPE i.

    FIELD-SYMBOLS: <l_cont_gui_container> TYPE /cadaxo/sqlcclguicontainer.

* call free methods for each splitter contrainer/alv_grid
    LOOP AT gcont_grid_result_t ASSIGNING <l_cont_gui_container>.

      l_index = sy-tabix.

      IF <l_cont_gui_container>-gui_alv_grid IS BOUND.
        <l_cont_gui_container>-gui_alv_grid->free( EXCEPTIONS OTHERS = 1 ).
        IF sy-subrc <> 0. "should never happen
          MESSAGE e100(/cadaxo/sqlc) WITH '/CADAXO/SQLC_CL_COCKPIT_MAIN' 'FREE_RESULT_CONTROLS' '1. SY-SUBRC' sy-subrc.
        ELSE.
          FREE <l_cont_gui_container>-gui_alv_grid.
        ENDIF.
      ENDIF.

      FREE <l_cont_gui_container>-cl_document_header.
      FREE <l_cont_gui_container>-cl_document_footer.

      IF <l_cont_gui_container>-gui_document IS BOUND.
        <l_cont_gui_container>-gui_document->free( EXCEPTIONS OTHERS = 1 ).
        IF sy-subrc <> 0. "should never happen
          MESSAGE e100(/cadaxo/sqlc) WITH '/CADAXO/SQLC_CL_COCKPIT_MAIN' 'FREE_RESULT_CONTROLS' '2. SY-SUBRC' sy-subrc.
        ELSE.
          FREE <l_cont_gui_container>-gui_document.
        ENDIF.
      ENDIF.

      IF <l_cont_gui_container>-gui_splitter IS BOUND.
        <l_cont_gui_container>-gui_splitter->free( EXCEPTIONS OTHERS = 1 ).
        IF sy-subrc <> 0. "should never happen
          MESSAGE e100(/cadaxo/sqlc) WITH '/CADAXO/SQLC_CL_COCKPIT_MAIN' 'FREE_RESULT_CONTROLS' '3. SY-SUBRC' sy-subrc.
        ELSE.
          FREE <l_cont_gui_container>-gui_splitter.
        ENDIF.
      ENDIF.

      IF <l_cont_gui_container>-gui_container IS BOUND.
        <l_cont_gui_container>-gui_container->free( EXCEPTIONS OTHERS = 1 ).
        IF sy-subrc <> 0. "should never happen
          MESSAGE e100(/cadaxo/sqlc) WITH '/CADAXO/SQLC_CL_COCKPIT_MAIN' 'FREE_RESULT_CONTROLS' '4. SY-SUBRC' sy-subrc.
        ELSE.
          FREE <l_cont_gui_container>-gui_container.
        ENDIF.
      ENDIF.

      DELETE gcont_grid_result_t INDEX l_index.

    ENDLOOP.

* free memory
    FREE gcont_grid_result_t[].
  ENDMETHOD.


  METHOD get_content.
****************************************************************************************************
* Description             : Show home screen                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 16.04.2011               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_par_value       TYPE string.
    DATA: l_html            TYPE string.
    DATA: l_html_cache      TYPE string.
    DATA: l_html_id         TYPE /cadaxo/sqlcparameter_id.
    DATA: l_html_id_langu   TYPE /cadaxo/sqlcparameter_id.
    DATA: l_html_objid      TYPE char80.
    DATA: l_html_objid_langu TYPE char80.
    DATA: lt_cache          TYPE TABLE OF char255.
    DATA: lt_subhtml        TYPE TABLE OF char255.
    DATA: l_regex           TYPE string.
    DATA: lt_result         TYPE match_result_tab.
    DATA: lt_results        TYPE match_result_tab.
    DATA: l_subhtml         TYPE string.
    DATA: l_doc_url(80)     TYPE c.
    DATA: l_size            TYPE i.
    DATA: l_mime            TYPE flag.
    DATA: l_match           TYPE string.
    DATA: l_extension       TYPE w3_qvalue.

    FIELD-SYMBOLS: <lwa_result>    TYPE match_result.
    FIELD-SYMBOLS: <lwa_sub>       TYPE submatch_result.
    FIELD-SYMBOLS: <lt_html_cache> TYPE STANDARD TABLE.

    l_html_id = i_html_id.
    IF l_html_id IS INITIAL.
      l_html_id = 'HTML_STARTUP'.
    ENDIF.


* get the document
    CONCATENATE 'ME->GT_HTML_' l_html_id INTO l_html_cache.
    ASSIGN (l_html_cache) TO <lt_html_cache>.
    IF sy-subrc <> 0.
      ASSIGN lt_cache TO <lt_html_cache>.
    ENDIF.

    IF <lt_html_cache> IS INITIAL.
* check language
      CONCATENATE l_html_id '_' sy-langu INTO l_html_id_langu.
      /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value(
        EXPORTING
          i_parameter_id      = l_html_id_langu
        RECEIVING
          r_parameter_value   = l_par_value
        EXCEPTIONS
          parameter_not_found = 1
          OTHERS              = 2 ).
      IF sy-subrc <> 0.
        /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value(
        EXPORTING
          i_parameter_id      = l_html_id
        RECEIVING
          r_parameter_value   = l_par_value
        EXCEPTIONS
          parameter_not_found = 1
          OTHERS              = 2 ).
        IF sy-subrc <> 0 AND i_viewer IS SUPPLIED AND i_viewer IS BOUND.
          CONCATENATE '/CADAXO/SQLC_' l_html_id INTO l_html_objid.
          CONCATENATE '/CADAXO/SQLC_' l_html_id_langu INTO l_html_objid_langu.

          SELECT SINGLE value FROM wwwparams INTO l_extension WHERE relid = 'MI'
                                                                AND objid = l_html_objid_langu
                                                                AND name  = 'fileextension'. "#EC CI_SEL_NESTED

          IF sy-subrc <> 0.
            l_extension = '.PDF'.
          ENDIF.
          CONCATENATE l_html_id_langu l_extension INTO l_doc_url.
          i_viewer->load_mime_object(
            EXPORTING
              object_id            = l_html_objid_langu
              object_url           = l_doc_url
            IMPORTING
              assigned_url         = l_doc_url
            EXCEPTIONS
              OTHERS               = 1
                 ).
          IF sy-subrc <> 0.
            SELECT SINGLE value FROM wwwparams INTO l_extension WHERE relid = 'MI'
                                                                  AND objid = l_html_objid
                                                                  AND name  = 'fileextension'. "#EC CI_SEL_NESTED
            IF sy-subrc <> 0.
              l_extension = '.PDF'.
            ENDIF.
            CONCATENATE l_html_id l_extension INTO l_doc_url.
            i_viewer->load_mime_object(
            EXPORTING
              object_id            = l_html_objid
              object_url           = l_doc_url
            IMPORTING
              assigned_url         = l_doc_url
            EXCEPTIONS
              OTHERS               = 1
                 ).
          ENDIF.
        ENDIF.
      ENDIF.
      IF sy-subrc = 0.

        me->param_replace_tags( CHANGING data = l_par_value ).

        l_html = l_par_value.

*get Inline Data
        l_regex = '<MIMELINK>(.*)</MIMELINK>'.
        FIND ALL OCCURRENCES OF REGEX l_regex
                                IN l_par_value
                                RESULTS lt_result.
        IF sy-subrc = 0.
          LOOP AT lt_result ASSIGNING <lwa_result>.
            <lwa_result>-line = 1. "indicated mime
          ENDLOOP.
          APPEND LINES OF lt_result TO lt_results.
        ENDIF.

        l_regex = '<HTMLLINK>(.*)</HTMLLINK>'.
        FIND ALL OCCURRENCES OF REGEX l_regex
                                IN l_par_value
                                RESULTS lt_result.
        IF sy-subrc = 0.
          LOOP AT lt_result ASSIGNING <lwa_result>.
            <lwa_result>-line = 2. "indicated html
          ENDLOOP.
          APPEND LINES OF lt_result TO lt_results.
        ENDIF.
        LOOP AT lt_results ASSIGNING <lwa_result>.
          LOOP AT <lwa_result>-submatches ASSIGNING <lwa_sub> WHERE offset > 0 AND length > 0.
            l_subhtml = l_par_value+<lwa_sub>-offset(<lwa_sub>-length).
            l_html_id = l_subhtml.
            IF l_doc_url IS INITIAL.
              IF <lwa_result>-line = 1.
                l_mime = abap_true.
              ELSE.
                CLEAR l_mime.
              ENDIF.
              me->get_content(
                EXPORTING
                  i_html_id      = l_html_id
                  i_viewer       = i_viewer
                  i_mime         = l_mime
                IMPORTING
                  et_content     = lt_subhtml
                  e_size         = l_size
                  e_assigend_url = l_doc_url
                     ).
              IF l_doc_url IS INITIAL.
                gc_html_viewer->load_data( EXPORTING "type         = lc_mime_type
                                                     "subtype      = lc_mime_subtype
                                                     size         = l_size
                                           IMPORTING assigned_url = l_doc_url
                                           CHANGING  data_table   = lt_subhtml ).
              ENDIF.
            ENDIF.
            l_match = l_par_value+<lwa_result>-offset(<lwa_result>-length).
            REPLACE ALL OCCURRENCES OF l_match IN l_html WITH l_doc_url.
            CLEAR l_doc_url.
          ENDLOOP.
        ENDLOOP.


        e_size = strlen( l_html ).
        e_assigend_url = l_doc_url.

        e_html_string = l_html.
        WHILE strlen( l_html ) GE 255.
          APPEND l_html(255) TO <lt_html_cache>.
          l_html = l_html+255.
        ENDWHILE.

        IF strlen( l_html ) > 0.
          APPEND l_html TO <lt_html_cache>.
        ENDIF.

      ENDIF.

    ENDIF.

    et_content =  <lt_html_cache>.

  ENDMETHOD.


  METHOD get_csv_from_int_tab.

    DATA lv_output_line  TYPE string.
    DATA lv_tmp_dats     TYPE char30.
    DATA lv_tmp_out      TYPE string.

    ASSIGN gt_lvc_t_fcat[ i_grid_i ] TO FIELD-SYMBOL(<lt_fields>).

    LOOP AT <lt_fields> ASSIGNING FIELD-SYMBOL(<ls_field>).
      lv_output_line = lv_output_line && ';' && <ls_field>-fieldname.
    ENDLOOP.

    SHIFT lv_output_line BY 1 PLACES.
    APPEND lv_output_line TO ev_output_csv.

    LOOP AT it_table ASSIGNING FIELD-SYMBOL(<ls_result>).

      CLEAR lv_output_line.

      LOOP AT <lt_fields> ASSIGNING <ls_field>.
        ASSIGN COMPONENT <ls_field>-fieldname OF STRUCTURE <ls_result> TO FIELD-SYMBOL(<ls_line>).

        IF <ls_field>-inttype = 'D' OR <ls_field>-inttype = 'T'.
          " Export Date and Time in user format
          WRITE <ls_line> TO lv_tmp_dats.
          lv_output_line = lv_output_line && ';' && lv_tmp_dats.
        ELSEIF <ls_field>-inttype = 'C' AND ( <ls_line> CP '*;*' OR <ls_line> CP '*"*' ).
          " If Separator or Single Quotes are in Field Then Do same behavior as Excel -> CSV
          lv_tmp_out = <ls_line>.
          REPLACE ALL OCCURRENCES OF '"' IN lv_tmp_out WITH '""'.
          lv_tmp_out = '"' && lv_tmp_out && '"'.
          lv_output_line = lv_output_line && ';' && lv_tmp_out.
        ELSE.
          lv_output_line = lv_output_line && ';' && <ls_line>.
        ENDIF.
      ENDLOOP.

      SHIFT lv_output_line BY 1 PLACES.
      APPEND lv_output_line TO ev_output_csv.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_csv_from_int_tab_cust.

    DATA lv_output_line  TYPE string.
    DATA lv_tmp_dats     TYPE char30.
    DATA lv_tmp_out      TYPE string.
    DATA ls_csv_attr TYPE /cadaxo/sqlc_csv_cust.

    DATA lv_cancel TYPE abap_bool.
    CALL FUNCTION '/CADAXO/SQLC_CUSTOM_CSV_POPUP'
      IMPORTING
        ev_cancel   = lv_cancel
      CHANGING
        cs_csv_attr = ls_csv_attr.

    IF lv_cancel = abap_true.
      ev_cancel = abap_true.
      RETURN.
    ENDIF.

    DATA(lv_separator) =   /cadaxo/cl_sqlc_csv_cust_util=>get_separator( EXPORTING i_separator_setting =  ls_csv_attr-field_separator
                                                                                   i_separator_others  =  ls_csv_attr-field_separator_other ).

    ASSIGN gt_lvc_t_fcat[ i_grid_i ] TO FIELD-SYMBOL(<lt_fields>).

    IF ls_csv_attr-add_header = abap_true.
      LOOP AT <lt_fields> ASSIGNING FIELD-SYMBOL(<ls_field>).
        lv_output_line = lv_output_line && lv_separator && <ls_field>-fieldname.
      ENDLOOP.

      SHIFT lv_output_line BY 1 PLACES.
      APPEND lv_output_line TO ev_output_csv.
    ENDIF.

    LOOP AT it_table ASSIGNING FIELD-SYMBOL(<ls_result>).
      CLEAR lv_output_line.

      LOOP AT <lt_fields> ASSIGNING <ls_field>.
        ASSIGN COMPONENT <ls_field>-fieldname OF STRUCTURE <ls_result> TO FIELD-SYMBOL(<ls_line>).

        IF  <ls_field>-inttype = 'T'.
          " Export Date and Time in user format
          lv_tmp_dats = /cadaxo/cl_sqlc_csv_cust_util=>convert_time(
                            EXPORTING
                              i_time_type       = ls_csv_attr-time_format
                              i_time_int        = <ls_line> ).
          lv_output_line = lv_output_line && lv_separator && lv_tmp_dats.
        ELSEIF <ls_field>-inttype = 'D'.
          lv_tmp_dats = /cadaxo/cl_sqlc_csv_cust_util=>convert_date(
                            EXPORTING
                              i_date_type       = ls_csv_attr-date_format
                              i_date            = <ls_line> ).
          lv_output_line = lv_output_line && lv_separator && lv_tmp_dats.
        ELSEIF <ls_field>-inttype = 'C' AND ( <ls_line> CP |*{ lv_separator }*| OR <ls_line> CP '*"*' ).
          " If Separator or Single Quotes are in Field Then Do same behavior as Excel -> CSV
          lv_tmp_out = <ls_line>.
          REPLACE ALL OCCURRENCES OF '"' IN lv_tmp_out WITH '""'.
          lv_tmp_out = '"' && lv_tmp_out && '"'.
          lv_output_line = lv_output_line && lv_separator && lv_tmp_out.
        ELSE.
          lv_output_line = lv_output_line && lv_separator && <ls_line>.
        ENDIF.
      ENDLOOP.

      SHIFT lv_output_line BY 1 PLACES.
      APPEND lv_output_line TO ev_output_csv.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_csv_line_from_tab.

    LOOP AT it_csv_tab INTO DATA(ls_tab_line).
      IF sy-tabix = 1.
        rv_csv_line = ls_tab_line.
      ELSE.
        rv_csv_line = rv_csv_line && cl_abap_char_utilities=>cr_lf && ls_tab_line.
      ENDIF.
      CLEAR ls_tab_line.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_current_grid_number.

    DATA lcl_gui_control TYPE REF TO cl_gui_control.
    DATA l_grid_name TYPE string.

    CLEAR r_grid_number.

    TRY.
        IMPORT grid_name TO l_grid_name FROM MEMORY ID 'GRID_NAME'.
        IF l_grid_name+15 CO '1234567890'.
          r_grid_number = l_grid_name+15.
        ENDIF.
      CATCH cx_sy_range_out_of_bounds.
    ENDTRY.

    IF r_grid_number IS INITIAL.
      cl_gui_alv_grid=>get_focus(
         IMPORTING control = lcl_gui_control
         EXCEPTIONS cntl_error = 1 ).
      IF sy-subrc = 0.
        l_grid_name = lcl_gui_control->get_name( ).
        IF l_grid_name+15 CO '1234567890'.
          r_grid_number = l_grid_name+15.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_link.

    DATA l_html_link_name TYPE /cadaxo/sqlcparameter_id.
    DATA l_html_link TYPE /cadaxo/sqlcparameter_val.
    DATA ls_adm_cust TYPE /cadaxo/sqlc_admin_cust.

    READ TABLE ct_cache INTO e_url INDEX 1.
    IF sy-subrc = 0.
      IF strlen( e_url ) > 4 AND e_url+0(4) CS 'HTTP'.
        FREE ct_cache.
      ELSE.
        CLEAR e_url.
      ENDIF.
      IF i_html_id <> 'HTML_STARTUP' AND i_html_id <> 'DEMOVERSION'.
        RETURN.
      ENDIF.
    ENDIF.

    /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).

    IF ls_adm_cust-home_use_link_date CO ' 0'.
      ls_adm_cust-home_use_link = 'X'.
    ENDIF.

    IF ls_adm_cust-home_use_link = abap_true.
      CONCATENATE i_html_id '_LINK_' sy-langu INTO l_html_link_name.
      CONDENSE l_html_link_name NO-GAPS.
      /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value( EXPORTING  i_parameter_id      = l_html_link_name
                                                           RECEIVING  r_parameter_value   = l_html_link
                                                           EXCEPTIONS parameter_not_found = 1 ).
      IF sy-subrc <> 0.
        CONCATENATE i_html_id '_LINK' INTO l_html_link_name.
        CONDENSE l_html_link_name NO-GAPS.
        /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value( EXPORTING  i_parameter_id      = l_html_link_name
                                                             RECEIVING  r_parameter_value   = l_html_link
                                                             EXCEPTIONS parameter_not_found = 1 ).
      ENDIF.
      IF sy-subrc = 0.
        e_url = l_html_link.
        CLEAR ct_cache.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_saved_list_fieldcat.

    DATA lt_fieldcat TYPE slis_t_fieldcat_alv.
    DATA l_lvc_s_fcat TYPE lvc_s_fcat.

    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = '/CADAXO/SQLCSRESALV'
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc = 0.

      LOOP AT lt_fieldcat ASSIGNING FIELD-SYMBOL(<l_fieldcat>).

        l_lvc_s_fcat = CORRESPONDING #( <l_fieldcat> ).

        MOVE: <l_fieldcat>-seltext_m TO l_lvc_s_fcat-scrtext_m,
              <l_fieldcat>-seltext_l TO l_lvc_s_fcat-scrtext_l,
              <l_fieldcat>-seltext_s TO l_lvc_s_fcat-scrtext_s.

        CASE <l_fieldcat>-fieldname.
          WHEN 'DESCRIPTION'.
            l_lvc_s_fcat-key = 'X'.
            l_lvc_s_fcat-fix_column = 'X'.
          WHEN 'LIST_GUID' OR 'RESS_GUID'.
            l_lvc_s_fcat-no_out = 'X'.
          WHEN 'CRDATE'.
            l_lvc_s_fcat-outputlen = 10.
          WHEN 'CRTIME'.
            l_lvc_s_fcat-outputlen = 10.
          WHEN 'OWNER'.
            l_lvc_s_fcat-outputlen = 12.
          WHEN 'NR_OF_SELECTS'.
            l_lvc_s_fcat-outputlen  = 12.
          WHEN 'SPACE_CONSUMING'.
            l_lvc_s_fcat-outputlen  = 12.
            l_lvc_s_fcat-do_sum = 'X'.
          WHEN 'TYPE'.
            l_lvc_s_fcat-no_out = 'X'.
          WHEN 'TYPE_ICON'.
            l_lvc_s_fcat-just = 'C'.
            l_lvc_s_fcat-outputlen  = 10.
          WHEN 'SOURCE_ICON'.
            l_lvc_s_fcat-no_out = 'X'.
          WHEN 'SOURCE'.
            l_lvc_s_fcat-no_out = 'X'.
          WHEN 'MANDT'.
            l_lvc_s_fcat-outputlen  = 6.
        ENDCASE.
        APPEND l_lvc_s_fcat TO r_saved_list_fieldcat.
      ENDLOOP.
    ELSE.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.

  ENDMETHOD.


  METHOD get_saved_results.
****************************************************************************************************
* Description             : SQL Cockpit - Show saved result list                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Ana Lekic                Company    : CADAXO GesmbH                    *
* Date                    : 06.11.2014                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 23.10.2013 | Wiesinger Harald     | gespeicherter Feldkatalakog mit original    | #4092          *
*            |                      | vergleichen                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 15.11.2013 | Wiesinger Harald     | gespeicherte Listen kÃƒÂ¶nnen wenn gewÃƒÂ¼nscht   | #4091          *
*            |                      | hinzugefÃƒÂ¼gt werden ohne die vorhanden       |                *
*            |                      | ALVs zu lÃƒÂ¶schen                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.07.2014 | Dieter Schadler      | Job Aggregatsfunktion                       | 22-005,#138    *
*------------+----------------------+---------------------------------------------+----------------*
* 05.08.2013 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Sum Overflow                                | RT145          *
*------------+----------------------+---------------------------------------------+----------------*
* 14.11.2014 | Ana Lekic            | show result from saved list, without        | RT244          *
*            |                      | the refresh-button                          |                *
*------------+----------------------+---------------------------------------------+----------------*
* 20.07.2015 | Ana Lekic            | fieldnames GT 30 have a guid as fieldname   | RT377          *
*            |                      | match the fieldcat                          |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.04.2016 | Ana Lekic            | don't save the layout of the save list      | $004 COCKPIT-20*
*------------+----------------------+---------------------------------------------+----------------*
* 01.02.2019 | Pratik Patil         | refactored this method into                 | $004 COCKPIT-20*
*                                     PREPARE_RESULT_TABLE for reuse                               *
****************************************************************************************************

    DATA ls_sqlcress              TYPE /cadaxo/sqlcress.
    DATA ls_sqlcsres              TYPE /cadaxo/sqlcsres.
    DATA l_xml                    TYPE string.
    DATA lt_result_list_raw       TYPE TABLE OF xstring.
    DATA ls_result_list_raw       TYPE xstring.
    DATA ls_ress_guid             TYPE guid_16.

    me->save_hold_lists( ).

* INS BEGIN #4091 - 20131210
    IF i_clear_old_alvs IS INITIAL.
* initializations
      CLEAR: dref_result_tab_t[],
             gt_cl_sql_parse,
             gt_lvc_t_fcat,
             gt_lvc_t_sort,
             gt_lvc_t_filt,
             gt_lvc_s_layo,                                   "RT239
             gt_result_details[].

* free/clear the "old" result controls
      free_result_controls( ).
    ENDIF.
* INS END #4091 - 20131210

    LOOP AT i_ress_guid INTO ls_ress_guid.

      SELECT SINGLE * FROM /cadaxo/sqlcress INTO ls_sqlcress WHERE ress_guid = ls_ress_guid.
      SELECT SINGLE * FROM /cadaxo/sqlcsres INTO ls_sqlcsres WHERE ress_guid = ls_ress_guid.

      IF sy-subrc = 0.
        CALL METHOD me->prepare_result_table
          EXPORTING
            is_sqlcsres = ls_sqlcsres
            is_sqlcress = ls_sqlcress.
      ELSE.
        MESSAGE e100(/cadaxo/sqlc) WITH 'GET_SAVED_RESULT' 'RESS_GUID_NOT_FOUND' ls_ress_guid.
      ENDIF.
    ENDLOOP.

    IF sy-subrc = 0.

      me->add_hold_lists( ).

* set buttons
      IF me->mv_toolbar_result_active <> c_cmd_show_result_table.
        me->set_result_toolbar_active( i_fcode = c_cmd_show_result_table ).
      ENDIF.

      FREE: l_xml,
            ls_result_list_raw,
            lt_result_list_raw.

      me->show_result( ).

      cl_gui_cfw=>set_new_ok_code( new_code = 'ENTER' ).
    ENDIF.

  ENDMETHOD.


  METHOD get_selected_elem_inf_flds.

    DATA l_fieldvalue TYPE string.

    me->gc_elementinfo_alv->get_selected_rows(
       IMPORTING
         et_index_rows = DATA(selected_rows) ).

    IF lines( selected_rows ) > 0.
      LOOP AT selected_rows ASSIGNING FIELD-SYMBOL(<selected_row>).
        READ TABLE gt_elementinfo INDEX <selected_row>-index ASSIGNING FIELD-SYMBOL(<ls_elementinfo>).
        IF sy-subrc = 0.
          IF <ls_elementinfo>-alias IS INITIAL.
            l_fieldvalue = <ls_elementinfo>-fieldname.
          ELSE.
            l_fieldvalue = <ls_elementinfo>-alias && '~' && <ls_elementinfo>-fieldname.
          ENDIF.

          IF r_fields IS INITIAL.
            r_fields = l_fieldvalue.
          ELSE.
            r_fields = r_fields && `, ` && l_fieldvalue.
          ENDIF.

        ENDIF.
      ENDLOOP.
    ELSE.

      READ TABLE gt_elementinfo INDEX i_index
                                ASSIGNING <ls_elementinfo>.
      IF sy-subrc = 0.
        IF <ls_elementinfo>-alias IS INITIAL.
          r_fields = <ls_elementinfo>-fieldname.
        ELSE.
          r_fields = <ls_elementinfo>-alias && '~' && <ls_elementinfo>-fieldname.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_sql_area.
****************************************************************************************************
* Description             : get sql from editor control                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    |                                             | CDX001-0011    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 16.07.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Support also selected areas in old editor   | CDX130-028     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Set headerline in Result ALV                | CR22-034       *
*            |                      |                                             | Clocking4721   *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA: l_lf       TYPE i,
          l_lt       TYPE i,
          l_pf       TYPE i,
          l_pt       TYPE i,
          lt_code    TYPE /cadaxo/sqlccodeline_t,
          l_code     TYPE /cadaxo/sqlccodeline,
          l_match    TYPE i,
          lt_results TYPE match_result_tab,
          l_offset   TYPE i,
          l_length   TYPE i.

    FIELD-SYMBOLS: <l_code>    LIKE LINE OF lt_code,
                   <l_code2>   LIKE LINE OF lt_code,
                   <l_results> LIKE LINE OF lt_results.

    FIELD-SYMBOLS <headerline>  TYPE /cadaxo/sqlcheaderline.

* old or new editor ?
    IF NOT gc_abap_editor IS INITIAL.

* get the current selection
      gc_abap_editor->get_selection_pos(
        IMPORTING
          from_line              = l_lf
          from_pos               = l_pf
          to_line                = l_lt
          to_pos                 = l_pt
        EXCEPTIONS
          error_cntl_call_method = 1
          OTHERS                 = 2 ).

* if there is a special selection, get the actual selection
      IF l_lf <> l_lt OR l_pf <> l_pt.
        gc_abap_editor->get_selected_text_as_table(
          IMPORTING
            table    = lt_code
          EXCEPTIONS
            error_dp = 1
            OTHERS   = 2 ).
      ELSE.
* no selection, get the whole text
        gc_abap_editor->get_text( IMPORTING table = lt_code ).
      ENDIF.
    ELSE.

* get the current selection
      gc_abap_editor_text->get_selection_pos(
        IMPORTING
          from_line              = l_lf
          from_pos               = l_pf
          to_line                = l_lt
          to_pos                 = l_pt
        EXCEPTIONS
          error_cntl_call_method = 1
          OTHERS                 = 2 ).

      IF l_lf <> l_lt OR l_pf <> l_pt.
        gc_abap_editor_text->get_selected_text_as_r3table(
          IMPORTING
            table    = lt_code
          EXCEPTIONS
            error_dp = 1
            OTHERS   = 2 ).
      ELSE.
        gc_abap_editor_text->get_text_as_r3table(
           IMPORTING
              table                  = lt_code ).
      ENDIF.
    ENDIF.

* Search for Header Line Comment
    CLEAR gt_headerlines.                                     "CR22-034

*** Test Ana Begin
    DATA l_idx TYPE i.
    DATA l_selnum TYPE i.
    DATA l_off TYPE i.

    LOOP AT lt_code ASSIGNING <l_code> WHERE table_line CS 'SELECT'.
**  check if there is no subselect begin
      FIND 'SELECT' IN <l_code> MATCH OFFSET l_off.
      IF sy-subrc = 0.
        l_off = l_off - 2.
        IF l_off GE 0.
          IF <l_code>+l_off(2) = '( '.
            CONTINUE.
          ENDIF.
        ENDIF.
      ENDIF.
**  check if there is no subselect end
      ADD 1 TO l_selnum.
      l_idx = sy-tabix - 1.
      READ TABLE lt_code ASSIGNING <l_code2> INDEX l_idx. "if the row above contains the header
      IF sy-subrc = 0.
        IF <l_code2> CS '&%HEADER'.
          APPEND INITIAL LINE TO gt_headerlines ASSIGNING <headerline>.
          <headerline>-alv_no = l_selnum.
          MOVE <l_code2>+9(*) TO <headerline>-text.
          CONDENSE <headerline>-text.
        ENDIF.
      ENDIF.
    ENDLOOP.
**** Test Ana End

***  LOOP AT lt_code ASSIGNING <l_code> WHERE table_line(11) CS '&%HEADER_'."CR22-034
***    l_string = <l_code>.                                    "CR22-034
***    ls_headerline-alv_no = l_string+10(2). "Provides the number           "CR22-034
***    l_string = l_string+13.                "Takes Header_XY: text, and Header_XY:text (without space in between) "CR22-034
***    CONDENSE l_string.                                      "CR22-034
***    ls_headerline-text   = l_string.    "Provides the header text         "CR22-034
***
***    APPEND ls_headerline TO gt_headerlines.                 "CR22-034
***
***  ENDLOOP.                                                  "CR22-034
***
**** Check if Header Line Number is used twice (or more times)
***  lt_headerline_e = gt_headerlines.                         "CR22-034
***
***  SORT gt_headerlines  ASCENDING.                           "CR22-034
***  SORT lt_headerline_e ASCENDING.                           "CR22-034
***
***  DELETE ADJACENT DUPLICATES FROM gt_headerlines.           "CR22-034
***
***  IF NOT gt_headerlines = lt_headerline_e.                  "CR22-034
***    MESSAGE e106(/cadaxo/sqlc) INTO l_message.              "CR22-034
***
***    RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error       "CR22-034
***       EXPORTING                                            "CR22-034
***         message = l_message.                               "CR22-034
***  ENDIF.                                                    "CR22-034


* remove comments * or "
    LOOP AT lt_code ASSIGNING <l_code> WHERE table_line(1) <> '*' AND table_line(1) <> '"'. "CDX001-0011
      TRY.
          l_code = <l_code>.

          CLEAR l_match.

* Replace all '...' by space so that we can find all " - we can not use replace/regex     "CDX001-0011
* because we need the spaces                                                              "CDX001-0011
          FIND ALL OCCURRENCES OF REGEX '.''.[^'']*.?''' IN l_code RESULTS lt_results.      "CDX001-0011
          LOOP AT lt_results ASSIGNING <l_results>.                                         "CDX001-0011
            l_offset = <l_results>-offset + 1.                                              "CDX001-0011
            l_length = <l_results>-length - 1.                                              "CDX001-0011
            MOVE space TO  l_code+l_offset(l_length).                                       "CDX001-0011
          ENDLOOP.                                                                          "CDX001-0011
          IF sy-subrc = 0.                                                                 "CDX001-0011
            FIND FIRST OCCURRENCE OF '"' IN l_code MATCH OFFSET l_match.                    "CDX001-0011
          ELSE.                                                                             "CDX001-0011
            FIND FIRST OCCURRENCE OF '"' IN <l_code> MATCH OFFSET l_match.
          ENDIF.                                                                            "CDX001-0011

* add a CR/LF, if a new line is added
          IF e_code_string <> space.                                                        "CDX001-0011
            CONCATENATE e_code_string cl_abap_char_utilities=>cr_lf INTO e_code_string.     "CDX001-0011
          ENDIF.                                                                            "CDX001-0011

          IF l_match <> 0.
            CONCATENATE e_code_string <l_code>(l_match)  INTO e_code_string SEPARATED BY space.
          ELSE.
            CONCATENATE e_code_string <l_code>  INTO e_code_string SEPARATED BY space.
          ENDIF.

        CATCH cx_sy_range_out_of_bounds.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_sql_area_lt_code.
****************************************************************************************************
* Description             : SQL Cockpit - Get SQL Area (old or new editor!)                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxx                Company    : xxxxxxxxxxxxx                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*05.03.2018  |Pat                   |changed method from protected to public      |                *
*            |                      |                                             |                *
****************************************************************************************************

* get source code from sql editor
    IF NOT gc_abap_editor IS INITIAL.

      gc_abap_editor->get_text(
        IMPORTING
          table = r_lt_code
        EXCEPTIONS
          error_dp               = 1
          error_cntl_call_method = 2 ).

    ELSE.

      gc_abap_editor_text->get_text_as_r3table(
        IMPORTING
          table                  = r_lt_code
        EXCEPTIONS
          error_dp               = 1
          error_cntl_call_method = 2
          error_dp_create        = 3
          potential_data_loss    = 4
          OTHERS                 = 5 ).

    ENDIF.
  ENDMETHOD.


  METHOD get_sql_hist_lines.
    DESCRIBE TABLE gt_sql_hist LINES r_sql_hist_lines.
  ENDMETHOD.


  METHOD get_symbols.
****************************************************************************************************
* Description             : Get symbols                                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | Sort global/user                            | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
*------------+----------------------+---------------------------------------------+----------------*
* 31.07.2017 | Dusan Sacha          | Symbol Multi Value                          | COCKPIT-240    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA ls_symbol LIKE LINE OF gt_symbol.
    DATA lt_program_symbol TYPE TABLE OF /cadaxo/sqlcsymb.
    DATA ls_celltab TYPE lvc_s_styl.
    DATA lt_user_symbol LIKE gt_symbol[].
    DATA lv_tabix TYPE i.
    DATA: i_values_count TYPE i.           "COCKPIT-240
    DATA: lv_symbol_enabled TYPE raw4.     "COCKPIT-240
    DATA: lv_datatype_enabled TYPE raw4.   "COCKPIT-240

    FIELD-SYMBOLS <ls_user_symbol> LIKE LINE OF lt_user_symbol.

* For Used Symbols
    " DATA lt_symbol       LIKE gt_symbol.                      "CR22-002

    REFRESH gt_symbol.

* Get user symbols(user dependent)
    SELECT symbol_name
           symbol_value
           symbol_desc
           symbol_multivalue                                              "COCKPIT-240
           symbol_datatype                                                "COCKPIT-240
           FROM /cadaxo/sqlcusym
             INTO CORRESPONDING FIELDS OF TABLE lt_user_symbol
             WHERE username = sy-uname
           ORDER BY symbol_name.                                          "COCKPIT-240
    IF sy-subrc = 0.

      LOOP AT lt_user_symbol ASSIGNING <ls_user_symbol>.

        "     Get Multi Values Count
        i_values_count = get_user_symbol_count( i_symbol_multivalue = <ls_user_symbol>-symbol_multivalue ). "COCKPIT-240
        lv_datatype_enabled = cl_gui_alv_grid=>mc_style_enabled.                                            "COCKPIT-240
        "     Get Icon
        IF ( <ls_user_symbol>-symbol_multivalue IS NOT INITIAL ).                    "COCKPIT-240
          <ls_user_symbol>-symbol_icon = '@3W@'.                                     "COCKPIT-240
          lv_symbol_enabled = cl_gui_alv_grid=>mc_style_disabled.                    "COCKPIT-240
          <ls_user_symbol>-symbol_value = '<' && i_values_count &&' VALUES' && '>'.  "COCKPIT-240
          IF i_values_count > 0.                                                     "COCKPIT-240
            lv_datatype_enabled = cl_gui_alv_grid=>mc_style_disabled.                "COCKPIT-240
          ENDIF.                                                                     "COCKPIT-240
        ELSE.                                                                        "COCKPIT-240
          <ls_user_symbol>-symbol_icon = '@7L@'.                                     "COCKPIT-240
          lv_symbol_enabled = cl_gui_alv_grid=>mc_style_enabled.                     "COCKPIT-240
        ENDIF.                                                                       "COCKPIT-240

        "     Get Data Element Info
        IF ( <ls_user_symbol>-symbol_datatype IS NOT INITIAL ).
          <ls_user_symbol>-symbol_datadesc = me->get_symbol_datatype_desc( i_datatype = <ls_user_symbol>-symbol_datatype ).
          <ls_user_symbol>-symbol_datainfo = me->get_symbol_datatype_info( i_datatype = <ls_user_symbol>-symbol_datatype ).
        ENDIF.

        <ls_user_symbol>-type = cs_symbol_type-user.
*     Editable for fields value and desc.
        ls_celltab-fieldname = 'SYMBOL_NAME'.
        ls_celltab-style = cl_gui_alv_grid=>mc_style_disabled.
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.
        ls_celltab-fieldname = 'SYMBOL_ICON'.                         "COCKPIT-240
        ls_celltab-style = cl_gui_alv_grid=>mc_style_button.          "COCKPIT-240
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.     "COCKPIT-240
        ls_celltab-fieldname = 'SYMBOL_VALUE'.                        "COCKPIT-240
        ls_celltab-style = lv_symbol_enabled.                         "COCKPIT-240
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.
        ls_celltab-fieldname = 'SYMBOL_DESC'.
        ls_celltab-style = cl_gui_alv_grid=>mc_style_enabled.
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.
        ls_celltab-fieldname = 'SYMBOL_DATATYPE'.                     "COCKPIT-240
        ls_celltab-style = lv_datatype_enabled.                       "COCKPIT-240
        INSERT ls_celltab INTO TABLE <ls_user_symbol>-cell_style.     "COCKPIT-240

      ENDLOOP.

      APPEND LINES OF lt_user_symbol TO gt_symbol.

    ENDIF.


    IF me->g_user_settings-symbols_program_show = c_program_symbols_show.                   "CDX001-0020
      TRY.
*     Get program symbols
          SELECT symbol symbol_descr
                 FROM /cadaxo/sqlcsymb
                 INTO CORRESPONDING FIELDS OF TABLE lt_program_symbol.
          LOOP AT lt_program_symbol ASSIGNING FIELD-SYMBOL(<ls_program_symbol>).

            ls_symbol-symbol_name = <ls_program_symbol>-symbol.

            /cadaxo/cl_sqlc_cockpit_assist=>get_global_symbol_value( EXPORTING i_symbol       = <ls_program_symbol>-symbol
                                                                     IMPORTING e_symbol_value = ls_symbol-symbol_value ).
            ls_symbol-symbol_desc = <ls_program_symbol>-symbol_descr.
            ls_symbol-type = cs_symbol_type-program.

            ls_celltab-fieldname = 'SYMBOL_NAME'.
            ls_celltab-style = cl_gui_alv_grid=>mc_style_disabled.
            INSERT ls_celltab INTO TABLE ls_symbol-cell_style.
            ls_celltab-fieldname = 'SYMBOL_VALUE'.
            ls_celltab-style = cl_gui_alv_grid=>mc_style_disabled.
            INSERT ls_celltab INTO TABLE ls_symbol-cell_style.
            ls_celltab-fieldname = 'SYMBOL_DESC'.
            ls_celltab-style = cl_gui_alv_grid=>mc_style_disabled.
            INSERT ls_celltab INTO TABLE ls_symbol-cell_style.

            APPEND ls_symbol TO gt_symbol.

            CLEAR ls_symbol.

          ENDLOOP.

        CATCH /cadaxo/cx_sqlc_symb_not_found .

      ENDTRY.
    ENDIF.                                                             "CDX001-0020

* If Flag is on, e.g. g_user_settings-only_used_symbols = 'X', or button is clicked
    IF g_user_settings-only_used_symbols = 'X'.               "CR22-002
*      SORT gt_used_symbols.                                   "CR22-002 "*-Cockpit-431
* begin of insert Cockpit-431
    IF   gt_used_symbols IS NOT INITIAL.
     DATA(lt_used_symbols) = gt_used_symbols.
    ELSE.
     lt_used_symbols = me->fill_used_symbols( ).
    ENDIF.
    SORT lt_used_symbols.
* end of insert Cockpit-431
      LOOP AT gt_symbol INTO ls_symbol.                       "CR22-002
        lv_tabix = sy-tabix.                                  "CR22-002
*       READ TABLE gt_used_symbols FROM ls_symbol-symbol_name TRANSPORTING NO FIELDS. "CR22-002"-Cockpit-431
        READ TABLE lt_used_symbols FROM ls_symbol-symbol_name TRANSPORTING NO FIELDS. "CR22-002"+Cockpit-431
        IF sy-subrc <> 0.                                     "CR22-002
          DELETE gt_symbol INDEX lv_tabix.                    "CR22-002
        ENDIF.                                                "CR22-002
      ENDLOOP.                                                "CR22-002
    ENDIF.                                                    "CR22-002

  ENDMETHOD.


  METHOD get_symbols_selected.
****************************************************************************************************
* Description             : get_symbols_selected                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Pat Patil                Company    : CADAXO GesmbH                    *
* Date                    : 26.01.2018               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 26.01.2018 |Pat                   |select symbols for export                    |COCKPIT-294     *
*------------+----------------------+---------------------------------------------+----------------*
* 22.10.2019 |Pat                   |Symbol Sharing should work exactly for one   |COCKPIT-418     *
*                                    selection                                                     *
*------------+----------------------+---------------------------------------------+----------------*

    CLEAR gt_symbol_selected.

* get selected records
    gc_symbol_alv->get_selected_rows( IMPORTING et_index_rows = DATA(lt_index_rows) ).
    IF lines( lt_index_rows ) > 1."cockpit-418
      MESSAGE s131(/cadaxo/sqlc) DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    IF lt_index_rows IS INITIAL.
      gc_symbol_alv->get_current_cell( IMPORTING es_row_id = DATA(ls_row_info) ).
      APPEND ls_row_info TO lt_index_rows.
    ENDIF.
    LOOP AT lt_index_rows ASSIGNING FIELD-SYMBOL(<index_row>).

      READ TABLE gt_symbol INDEX <index_row>-index
                           ASSIGNING FIELD-SYMBOL(<symbol>).
      IF sy-subrc = 0.

*     program symbol not allowed
        IF <symbol>-type = cs_symbol_type-program.

*       focus the record
          me->focus_symbol_alv_cell( i_row_id     = <index_row>-index
                                     i_field_name = 'SYMBOL_NAME' ).

          MESSAGE s132(/cadaxo/sqlc) DISPLAY LIKE 'E'.               "CDX001-0020
          RETURN.

        ENDIF.

        APPEND <symbol> TO gt_symbol_selected.
      ENDIF.

    ENDLOOP.

    IF gt_symbol_selected IS NOT INITIAL.
      e_success = abap_true.
    ELSE.
      MESSAGE s131(/cadaxo/sqlc) DISPLAY LIKE 'E'.               "CDX001-0020
    ENDIF.


  ENDMETHOD.


  METHOD get_symbol_datatype_desc.

    SELECT SINGLE ddtext FROM dd04t
      INTO r_desc
      WHERE rollname   = i_datatype AND
            ddlanguage = sy-langu AND
            as4local   = 'A'.   "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED

  ENDMETHOD.


  METHOD get_symbol_datatype_info.

    DATA: ls_datatype_info TYPE dd04v.
    DATA: lv_info          LIKE r_info.

    CALL FUNCTION 'DDIF_DTEL_GET'
      EXPORTING
        name          = i_datatype
        state         = 'A'
        langu         = sy-langu
      IMPORTING
        dd04v_wa      = ls_datatype_info
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
    ENDIF.

    IF ls_datatype_info-leng IS INITIAL.
      lv_info = to_lower( ls_datatype_info-datatype  ).
    ELSEIF ls_datatype_info-decimals IS INITIAL.
      lv_info = to_lower( ls_datatype_info-datatype  ) && '(' && shift_left( val = ls_datatype_info-leng sub = '0' ) && ')'.
    ELSE.
      lv_info = to_lower( ls_datatype_info-datatype ) && '(' && shift_left( val = ls_datatype_info-leng sub = '0' )
                                                                         && ',' && shift_left( val = ls_datatype_info-decimals sub = '0' ) && ')'.
    ENDIF.

    r_info = lv_info.
  ENDMETHOD.


  METHOD get_user_symbol_count.
    DATA: lt_symbol_value TYPE rseloption.

    IF i_symbol_multivalue IS NOT INITIAL.
      /cadaxo/cl_sqlc_cockpit_assist=>decompress_symbol_multivalue(
        EXPORTING
          i_symbol_multivalue = i_symbol_multivalue
        IMPORTING
          e_symbol_multivalue = lt_symbol_value
      ).
    ENDIF.

    DESCRIBE TABLE lt_symbol_value LINES r_count.

  ENDMETHOD.


  METHOD get_user_symbol_from_sql.
****************************************************************************************************
* Description             : get user symbols from SQL                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 22.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.11.2010 | Domi Bigl            | Symbols for global variant                  | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.05.2012 | Johann FÃƒÂ¶ÃƒÅ¸leitner    | translate symbolname to upper case          | CDX130-009     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
*------------+----------------------+---------------------------------------------+----------------*
* 20.02.2018 | Dusan Sacha          | Symbol Multivalue Upgrade                   | Cadaxo-288     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA l_symbol LIKE LINE OF e_symbols.

    DATA lt_results TYPE match_result_tab.

    DATA: lt_sql LIKE i_sql[],
          l_sql  LIKE LINE OF lt_sql.

    DATA  l_symbol_name TYPE string.

    DATA  l_count TYPE i.


    FIELD-SYMBOLS: <l_result> LIKE LINE OF lt_results,
                   <l_symbol> LIKE l_symbol.

    REFRESH e_symbols.

    lt_sql[] = i_sql[].
* delete blank line
    DELETE lt_sql WHERE table_line IS INITIAL.

    CLEAR gt_used_symbols.                     "CR22-002

    LOOP AT lt_sql INTO l_sql.

      CLEAR lt_results.

      FIND ALL OCCURRENCES OF REGEX '&(\w|/)+&' IN l_sql RESULTS lt_results.
      IF sy-subrc = 0.

        LOOP AT lt_results ASSIGNING <l_result>.

          MOVE l_sql+<l_result>-offset(<l_result>-length) TO l_symbol_name.
*       delete leading and ending '&'
          REPLACE ALL OCCURRENCES OF '&' IN l_symbol_name WITH space.
          CONDENSE l_symbol_name NO-GAPS.
          TRANSLATE l_symbol_name TO UPPER CASE.                                 "CDX130-009
          l_symbol-symbol_name = l_symbol_name.

* creates list of user_symbols used in the Editor
          APPEND l_symbol_name TO gt_used_symbols.                               "CR22-002

          IF i_type = cs_windowresolution-vertical OR i_type IS INITIAL.
            SELECT SINGLE COUNT(*) FROM /cadaxo/sqlcvnsy
                                   INTO l_count
                                   WHERE varguid = i_varguid
                                     AND symbol_name = l_symbol_name.

          ELSE.

            SELECT SINGLE COUNT(*) FROM /cadaxo/sqlcusym
                                  INTO l_count
                                  WHERE symbol_name = l_symbol_name
                                    AND username = sy-uname. "#EC CI_BYPASS

          ENDIF.

          IF l_count = 1.

            CLEAR l_count.

            APPEND l_symbol TO e_symbols.

          ENDIF.

        ENDLOOP.

*     get distinct user symbols
        SORT e_symbols BY symbol_name.
        DELETE ADJACENT DUPLICATES FROM e_symbols COMPARING symbol_name.         "CDX001-0020

        LOOP AT e_symbols ASSIGNING <l_symbol>.

          IF NOT i_type IS INITIAL."If initial, no need to get value and desc

            CASE i_type.

              WHEN 'V'."Get symbol value and desc from variant
                SELECT SINGLE
                  symbol_value
                  symbol_desc
                  symbol_multivalue
                  symbol_datatype
                  FROM /cadaxo/sqlcvnsy
                    INTO CORRESPONDING FIELDS OF <l_symbol>
                    WHERE varguid = i_varguid
                      AND symbol_name = <l_symbol>-symbol_name.

              WHEN 'U'."Get current symbol value and desc from variant
*             get current user symbol value

                SELECT SINGLE
                  symbol_value
                  symbol_desc
                  symbol_multivalue                                              "COCKPIT-240
                  symbol_datatype                                                "COCKPIT-240
                  FROM /cadaxo/sqlcusym
                    INTO CORRESPONDING FIELDS OF <l_symbol>
                    WHERE username = sy-uname
                     AND symbol_name = <l_symbol>-symbol_name.                                          "COCKPIT-240
            ENDCASE.

            "     Get Data Element Info
            IF ( <l_symbol>-symbol_datatype IS NOT INITIAL ).
              <l_symbol>-symbol_datadesc = me->get_symbol_datatype_desc( i_datatype = <l_symbol>-symbol_datatype ).
              <l_symbol>-symbol_datainfo = me->get_symbol_datatype_info( i_datatype = <l_symbol>-symbol_datatype ).
            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDLOOP.

* Delete Duplicate entries in GT_USED_SYMBOLS
    SORT gt_used_symbols.                             "CR22-002
    DELETE ADJACENT DUPLICATES FROM gt_used_symbols.  "CR22-002

  ENDMETHOD.


  METHOD get_variant.

    DATA l_sqlcvari    TYPE /cadaxo/sqlcvari.
    DATA lt_sqlcusym   TYPE TABLE OF /cadaxo/sqlcusym.
    DATA l_sqlcusym    LIKE LINE OF lt_sqlcusym.
    DATA ls_symbol_ow  TYPE /cadaxo/sqlc_symbol_ow.
    DATA ls_layout     TYPE lvc_s_layo.
*  DATA lt_symbols    TYPE /cadaxo/sqlc_il_variants_symbt.  " Cockpit-288 Delete
    DATA lt_symbols    TYPE /cadaxo/sqlc_symbol_t.           " Cockpit-288 Insert

    FIELD-SYMBOLS: <ls_symbol_ow> TYPE /cadaxo/sqlc_symbol_ow,
                   <ls_symbols>   LIKE LINE OF lt_symbols.

    CLEAR : gs_sel_variant.
    CALL FUNCTION '/CADAXO/SQLC_MAINTAINT_VAR_UI'
      EXPORTING
        i_mode       = 'G'
      IMPORTING
        e_il_variant = gs_sel_variant.

    IF NOT gs_sel_variant IS INITIAL.

* set sql editor lines
      me->set_sql_area( i_codelines_t =  gs_sel_variant-t_sql  ).

      MOVE-CORRESPONDING gs_sel_variant TO l_sqlcvari.

      l_sqlcvari-username = gs_sel_variant-cruser.

      me->get_user_symbol_from_sql( EXPORTING i_varguid = gs_sel_variant-varguid
                                              i_sql     = gs_sel_variant-t_sql
                                              i_type    = 'V'
                                    IMPORTING e_symbols = lt_symbols ).
      IF NOT lt_symbols IS INITIAL.

        DATA(lv_username) = cl_abap_syst=>get_user_name( ).
        SELECT *
               FROM /cadaxo/sqlcusym
               INTO TABLE lt_sqlcusym
               FOR ALL ENTRIES IN lt_symbols
               WHERE symbol_name = lt_symbols-symbol_name
                 AND username    = lv_username
               .

        CLEAR gt_symbol_ow.

        LOOP AT lt_symbols ASSIGNING <ls_symbols>.

          READ TABLE lt_sqlcusym
          WITH KEY symbol_name = <ls_symbols>-symbol_name
          INTO l_sqlcusym.

          IF     sy-subrc = 0
          AND ( l_sqlcusym-symbol_value <> <ls_symbols>-symbol_value
          OR  l_sqlcusym-symbol_desc <> <ls_symbols>-symbol_desc ).
            ls_symbol_ow-symbol_name       = <ls_symbols>-symbol_name.
            ls_symbol_ow-symbol_value_user = l_sqlcusym-symbol_value.
            ls_symbol_ow-symbol_desc_user  = l_sqlcusym-symbol_desc.
            ls_symbol_ow-symbol_value_var  = <ls_symbols>-symbol_value.
            ls_symbol_ow-symbol_var        = <ls_symbols>-symbol_desc.
            ls_symbol_ow-var               = icon_wd_radio_button_empty.
            ls_symbol_ow-own               = icon_radiobutton.
            APPEND ls_symbol_ow TO gt_symbol_ow.
          ENDIF.

        ENDLOOP.

        IF NOT gt_symbol_ow IS INITIAL.
          confirm_symbol_overwrite( ).
        ENDIF.

        LOOP AT lt_symbols ASSIGNING <ls_symbols>.

          READ TABLE gt_symbol_ow                                              "CDX001-0020
          ASSIGNING <ls_symbol_ow>                                             "CDX001-0020
          WITH KEY symbol_name = <ls_symbols>-symbol_name.                     "CDX001-0020
          IF sy-subrc = 0 AND <ls_symbol_ow>-var <> icon_radiobutton.          "CDX001-0020
            CONTINUE.                                                          "CDX001-0020
          ENDIF.                                                               "CDX001-0020

          MOVE-CORRESPONDING <ls_symbols> TO l_sqlcusym.
          l_sqlcusym-username = sy-uname.
          APPEND l_sqlcusym TO lt_sqlcusym.
          CLEAR l_sqlcusym.

        ENDLOOP.

        MODIFY /cadaxo/sqlcusym FROM TABLE lt_sqlcusym.

      ENDIF.

      me->get_symbols( ).

      gc_symbol_alv->get_frontend_layout( IMPORTING es_layout = ls_layout ).
      IF ls_layout-cwidth_opt <> abap_true.
        ls_layout-cwidth_opt = abap_true.
        gc_symbol_alv->set_frontend_layout( ls_layout ).
      ENDIF.

    DATA(l_ctmenu3) = NEW cl_ctmenu( ).
    l_ctmenu3->add_function( EXPORTING fcode = 'SQLVARSET' text = text-q40 checked = abap_true icon = icon_alv_variant_save ).
    l_ctmenu3->add_function( EXPORTING fcode = 'SQLVARSET_UPD' text = conv #( |{ text-b46 } { gs_sel_variant-varname }| )
                                                               disabled = abap_false ).

      gc_splitter_top_toolbar->set_static_ctxmenu(
        EXPORTING
          fcode                = 'SQLVARSET'
          ctxmenu              = l_ctmenu3
      ).

    else.

    l_ctmenu3 = NEW cl_ctmenu( ).
    l_ctmenu3->add_function( EXPORTING fcode = 'SQLVARSET' text = text-q40 checked = abap_true icon = icon_alv_variant_save ).
    l_ctmenu3->add_function( EXPORTING fcode = 'SQLVARSET_UPD' text = conv #( |{ text-b46 } | )
                                                               disabled = abap_true ).

      gc_splitter_top_toolbar->set_static_ctxmenu(
        EXPORTING
          fcode                = 'SQLVARSET'
          ctxmenu              = l_ctmenu3
      ).


    ENDIF.




  ENDMETHOD.


  METHOD handle_command_create_symbol.
****************************************************************************************************
* Description             : Handle Show Full Value                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Pratik Patil             Company    : CADAXO GesmbH                    *
* Date                    : 26.02.2019               Release    : 3.5                              *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxxxxx                 *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    DATA gui_control     TYPE REF TO cl_gui_control.
    DATA gui_alv_grid    TYPE REF TO cl_gui_alv_grid.
    DATA selected_col    TYPE lvc_s_col.
    DATA dref_field      TYPE REF TO data.
    DATA sel_field_val_string TYPE string.

    FIELD-SYMBOLS:
      <result_tab>         TYPE STANDARD TABLE,
      <result_line>        TYPE any,
      <selected_field_val> TYPE any,
      <selected_field_tab> TYPE STANDARD TABLE,
      <dref_line>          TYPE REF TO data,
      <result_field>       TYPE any.

    cl_gui_alv_grid=>get_focus( IMPORTING control = gui_control ).

    TRY.
        gui_alv_grid ?= gui_control.
        gui_alv_grid->get_current_cell( IMPORTING es_col_id = selected_col ).
      CATCH cx_sy_move_cast_error.
    ENDTRY.

    ASSIGN dref_result_tab_t[ i_grid_i ] TO <dref_line>.
    ASSIGN <dref_line>->* TO <result_tab>.

    DATA(lr_cl_sql_parse) = gt_cl_sql_parse[ i_grid_i ].
    TRY.
        DATA(result_ddfield) = lr_cl_sql_parse->gt_lvc_t_fcat[ fieldname = selected_col-fieldname ].
      CATCH cx_sy_itab_line_not_found.
        MESSAGE i142(/cadaxo/sqlc).
        RETURN.
    ENDTRY.
    IF result_ddfield-rollname IS INITIAL.
      MESSAGE i141(/cadaxo/sqlc).
      RETURN.
    ENDIF.
    CREATE DATA dref_field TYPE TABLE OF (result_ddfield-rollname).
    ASSIGN dref_field->* TO <selected_field_tab>.

    LOOP AT <result_tab> ASSIGNING <result_line>.
      ASSIGN COMPONENT selected_col-fieldname OF STRUCTURE <result_line> TO <selected_field_val>.
      sel_field_val_string = <selected_field_val>.
      IF strlen( sel_field_val_string ) > 45.
        MESSAGE i148(/cadaxo/sqlc).
        RETURN.
      ENDIF.
      APPEND <selected_field_val> TO <selected_field_tab>.
    ENDLOOP.

    CALL FUNCTION '/CADAXO/SQLC_CREATE_SYMBOL'
      EXPORTING
        iv_rollname      = result_ddfield-rollname
        it_symbol_values = <selected_field_tab>.

    me->get_symbols( ).
    gc_symbol_alv->refresh_table_display( i_soft_refresh = abap_true ).

  ENDMETHOD.


  METHOD handle_command_show_full_value.
****************************************************************************************************
* Description             : Handle Show Full Value                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dusan Sacha              Company    : CADAXO GesmbH                    *
* Date                    : 20.01.2019               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxxxxx                 *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    DATA gui_control     TYPE REF TO cl_gui_control.
    DATA gui_alv_grid    TYPE REF TO cl_gui_alv_grid.
    DATA selected_row    TYPE lvc_s_row.
    DATA selected_col    TYPE lvc_s_col.

    FIELD-SYMBOLS: <result_tab>   TYPE STANDARD TABLE,
                   <result_line>  TYPE any,
                   <result_field> TYPE any,
                   <dref_line>    TYPE REF TO data.

    cl_gui_alv_grid=>get_focus( IMPORTING control = gui_control ).

    TRY.
        gui_alv_grid ?= gui_control.
        gui_alv_grid->get_current_cell( IMPORTING es_row_id = selected_row es_col_id = selected_col ).
      CATCH cx_sy_move_cast_error ##no_handler.
    ENDTRY.

    IF i_log = abap_true.
      READ TABLE gt_history_log INDEX selected_row-index ASSIGNING <result_line>.
    ELSE.
      READ TABLE dref_result_tab_t INDEX i_grid_i ASSIGNING <dref_line>.

      ASSIGN <dref_line>->* TO <result_tab>.
      READ TABLE <result_tab> INDEX selected_row-index ASSIGNING <result_line>.
    ENDIF.
    IF sy-subrc = 0.
      ASSIGN COMPONENT selected_col-fieldname OF STRUCTURE <result_line> TO <result_field>.
      CALL FUNCTION '/CADAXO/SQLC_UT_VALUE_POPUP'
        EXPORTING
          iv_edit  = abap_false
        CHANGING
          cv_value = <result_field>.
    ENDIF.

  ENDMETHOD.


  METHOD handle_command_show_html_brow.

    DATA gui_control     TYPE REF TO cl_gui_control.
    DATA gui_alv_grid    TYPE REF TO cl_gui_alv_grid.
    DATA selected_row    TYPE lvc_s_row.
    DATA selected_col    TYPE lvc_s_col.

    FIELD-SYMBOLS: <result_tab>   TYPE STANDARD TABLE,
                   <result_line>  TYPE any,
                   <result_field> TYPE any,
                   <dref_line>    TYPE REF TO data.

    cl_gui_alv_grid=>get_focus( IMPORTING control = gui_control ).

    TRY.
        gui_alv_grid ?= gui_control.
        gui_alv_grid->get_current_cell( IMPORTING es_row_id = selected_row es_col_id = selected_col ).
      CATCH cx_sy_move_cast_error ##no_handler.
    ENDTRY.

    IF i_log = abap_true.
      READ TABLE gt_history_log INDEX selected_row-index ASSIGNING <result_line>.
    ELSE.
      READ TABLE dref_result_tab_t INDEX i_grid_i ASSIGNING <dref_line>.

      ASSIGN <dref_line>->* TO <result_tab>.
      READ TABLE <result_tab> INDEX selected_row-index ASSIGNING <result_line>.
    ENDIF.
    IF sy-subrc = 0.

      ASSIGN COMPONENT selected_col-fieldname OF STRUCTURE <result_line> TO <result_field>.

      IF <result_field> IS ASSIGNED.

        cl_abap_browser=>show_html(
          EXPORTING
            title        = text-t15
            size         = cl_abap_browser=>large
            modal        = abap_true
            html_string  = CONV #( <result_field> )
            printing     = abap_true
            buttons      = abap_true
            context_menu = abap_true
            check_html   = abap_true
        ).

      ENDIF.

*      CL_ABAP_BROWSER=>show_xml(
**        EXPORTING
*           xml_string   = conv #( <result_field> )
**          xml_xstring  =     " XML in XString
*          title        = text-t15
*           size         = CL_ABAP_BROWSER=>LARGE    " Size (S,M.L,XL)
**          modal        = ABAP_TRUE    " Display as Modal Dialog Box
*            printing     = ABAP_true
*            buttons      = abap_true  " Navigation Keys navigate_...
**          format       = CL_ABAP_BROWSER=>LANDSCAPE    " Landscape/portrait format
**          position     = CL_ABAP_BROWSER=>TOPLEFT    " Position
*            context_menu = ABAP_true   " Display context menu in browser
**          container    =
*           check_xml    = ABAP_false    " Validation of XML File
*      ).

    ENDIF.

  ENDMETHOD.


  METHOD handle_command_show_xml_brow.

    DATA gui_control     TYPE REF TO cl_gui_control.
    DATA gui_alv_grid    TYPE REF TO cl_gui_alv_grid.
    DATA selected_row    TYPE lvc_s_row.
    DATA selected_col    TYPE lvc_s_col.

    FIELD-SYMBOLS: <result_tab>   TYPE STANDARD TABLE,
                   <result_line>  TYPE any,
                   <result_field> TYPE any,
                   <dref_line>    TYPE REF TO data.

    cl_gui_alv_grid=>get_focus( IMPORTING control = gui_control ).

    TRY.
        gui_alv_grid ?= gui_control.
        gui_alv_grid->get_current_cell( IMPORTING es_row_id = selected_row es_col_id = selected_col ).
      CATCH cx_sy_move_cast_error ##no_handler.
    ENDTRY.

    IF i_log = abap_true.
      READ TABLE gt_history_log INDEX selected_row-index ASSIGNING <result_line>.
    ELSE.
      READ TABLE dref_result_tab_t INDEX i_grid_i ASSIGNING <dref_line>.

      ASSIGN <dref_line>->* TO <result_tab>.
      READ TABLE <result_tab> INDEX selected_row-index ASSIGNING <result_line>.
    ENDIF.
    IF sy-subrc = 0.

      ASSIGN COMPONENT selected_col-fieldname OF STRUCTURE <result_line> TO <result_field>.

      IF <result_field> IS ASSIGNED.

        cl_abap_browser=>show_xml(
           EXPORTING
              xml_string   = CONV #( <result_field> )
              title        = text-t16
              size         = cl_abap_browser=>large
              modal        = abap_true
              printing     = abap_true
              buttons      = abap_true
              context_menu = abap_true
              check_xml    = abap_true
         ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD handle_delete_saved_lists.

    DATA l_rc TYPE c   LENGTH 1.
    DATA lt_lvc_t_roid TYPE lvc_t_roid.
    DATA l_message TYPE string.

    READ TABLE gcont_grid_result_t INDEX 1 ASSIGNING FIELD-SYMBOL(<l_cont_grid_result>).
    IF sy-subrc = 0.

      <l_cont_grid_result>-gui_alv_grid->get_selected_rows(
        IMPORTING
           et_row_no      =   lt_lvc_t_roid ).

      IF NOT lt_lvc_t_roid[] IS INITIAL.

        IF lines( lt_lvc_t_roid ) > 1.
          l_message = text-q23.
        ELSE.
          l_message = text-q59.
        ENDIF.

        CALL FUNCTION 'POPUP_TO_CONFIRM'                 "Cockpit-203 Popup harmonized
          EXPORTING
            titlebar              = text-t12
            text_question         = l_message
            text_button_1         = text-x03
            icon_button_1         = 'ICON_OKAY'
            text_button_2         = text-x04
            icon_button_2         = 'ICON_CANCEL'
            default_button        = '2'
            display_cancel_button = abap_false
          IMPORTING
            answer                = l_rc
          EXCEPTIONS
            text_not_found        = 1
            OTHERS                = 2.

        IF l_rc = '1'.

          LOOP AT lt_lvc_t_roid ASSIGNING FIELD-SYMBOL(<l_lvc_s_roid>).
            READ TABLE me->gt_saved_lists INDEX <l_lvc_s_roid>-row_id ASSIGNING FIELD-SYMBOL(<ls_saved_lists>).
            IF sy-subrc = 0.
              /cadaxo/cl_sqlc_cockpit_lists=>delete_list( EXPORTING i_list_guid = <ls_saved_lists>-list_guid
                                                                    i_jobcount  = <ls_saved_lists>-jobcount
                                                                    i_type      = <ls_saved_lists>-type ).
            ENDIF.
          ENDLOOP.

          MESSAGE s082(/cadaxo/sqlc).

          /cadaxo/cl_sqlc_cockpit_lists=>get_saved_lists( EXPORTING i_uname = sy-uname
                                                          IMPORTING e_saved_lists = me->gt_saved_lists ).

          <l_cont_grid_result>-gui_alv_grid->refresh_table_display( ).
        ELSE.
          MESSAGE s042(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE s079(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD handle_export_saved_list.

    DATA lt_lvc_t_roid TYPE lvc_t_roid.
    DATA l_lines TYPE i.

    READ TABLE gcont_grid_result_t INDEX 1 ASSIGNING FIELD-SYMBOL(<l_cont_grid_result>).
    IF sy-subrc = 0.

      <l_cont_grid_result>-gui_alv_grid->get_selected_rows(
        IMPORTING
           et_row_no      =   lt_lvc_t_roid ).

      DESCRIBE TABLE lt_lvc_t_roid LINES l_lines.

      IF l_lines = 1.
        READ TABLE lt_lvc_t_roid INDEX 1 ASSIGNING FIELD-SYMBOL(<l_lvc_s_roid>).
        IF sy-subrc = 0.
          READ TABLE me->gt_saved_lists INDEX <l_lvc_s_roid>-row_id ASSIGNING FIELD-SYMBOL(<ls_saved_lists>).
          IF sy-subrc = 0.
            /cadaxo/cl_sqlc_cockpit_lists=>export_list( EXPORTING i_list_guid = <ls_saved_lists>-list_guid ).
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD handle_msg_exception.
    DATA lt_errors TYPE /cadaxo/sqlcsyntaxerror_t.
    DATA l_message TYPE string.
    DATA lr_exception             TYPE REF TO cx_root.
    DATA ls_error                 TYPE /cadaxo/sqlcsyntaxerror.

    l_message = i_msg.
    lr_exception = i_exception.

    ls_error-text    = l_message.
    ls_error-msgtype = icon_red_light.

    IF strlen( ls_error-text ) >= 127.

      _split_error_text( EXPORTING is_error  = ls_error
                         CHANGING  ct_errors = lt_errors ).
    ELSE.
      INSERT ls_error INTO TABLE lt_errors.
    ENDIF.

    IF lines( gt_errors ) > 0.                                                   "COCKPIT-103
      IF gt_errors[ lines( gt_errors ) ]-text <> lt_errors[ lines( lt_errors ) ]-text.                  "COCKPIT-103
        INSERT LINES OF lt_errors INTO TABLE gt_errors.
      ENDIF.                                                                     "COCKPIT-103
    ELSE.
      INSERT LINES OF lt_errors INTO TABLE gt_errors.
    ENDIF.

    WHILE lr_exception->previous IS BOUND.
      lr_exception ?= lr_exception->previous.
      l_message = lr_exception->get_text( ).
      IF l_message IS NOT INITIAL.
        ls_error-text    = l_message.
        ls_error-msgtype = icon_red_light.
        INSERT ls_error INTO TABLE gt_errors.
      ENDIF.
    ENDWHILE.

    DELETE ADJACENT DUPLICATES FROM gt_errors.
    gc_abap_error->refresh_table_display( ).
    gs_splitter_editor->set_row_height( id = 2 height = me->error_calc_height( lines( gt_errors ) ) ).

  ENDMETHOD.


  METHOD handle_result_command_cdxexp.

* function is still in development and not released in the current release - Cadaxo 1.1.2014/Rel 2.1

*  data l_index type i.
*  data ET_LVC_DATA type LVC_T_DATA.
*  field-symbols: <lr_dref>      like line of dref_result_tab_t,
*                 <l_lvc_t_fcat> like line of gt_lvc_t_fcat,
*                 <lt_result>    type standard table.
*
*  READ TABLE dref_result_tab_t INDEX i_grid_i ASSIGNING <lr_dref>.
*  IF sy-subrc = 0.
*    l_index = sy-tabix.
*    ASSIGN <lr_dref>->* TO <lt_result>.
*    READ TABLE gt_lvc_t_fcat INDEX l_index ASSIGNING <l_lvc_t_fcat>.
*    IF sy-subrc = 0.
*
*CALL FUNCTION 'LVC_GET_INFO_DATA_TABLE'
*  EXPORTING
**   I_VIEW                      = I_VIEW
**   I_GUI_TYPE                  = I_GUI_TYPE
*    it_fieldcat                 = <l_lvc_t_fcat>
**   IT_FILTER_INDEX             = IT_FILTER_INDEX
**   IS_TOTAL_OPTIONS            = IS_TOTAL_OPTIONS
**   IS_LAYOUT                   = IS_LAYOUT
**    I_GRID                      = I_GRID
**   IT_SORT                     = IT_SORT
**   IT_FILTER                   = IT_FILTER
*  IMPORTING
*    ET_LVC_DATA                 = ET_LVC_DATA
**   ET_LVC_INFO                 = ET_LVC_INFO
**   ET_IDPO                     = ET_IDPO
**   ET_POID                     = ET_POID
**   ET_ROID                     = ET_ROID
**   ET_FIELDCAT_LOCAL           = ET_FIELDCAT_LOCAL
**   ES_LAYOUT_LOCAL             = ES_LAYOUT_LOCAL
**   ET_START_INDEX              = ET_START_INDEX
**   E_COLUMNS                   = E_COLUMNS
**   E_LINES                     = E_LINES
*  TABLES
*    it_data                     = <lt_result>
**   IT_COLLECT00                = IT_COLLECT00
**   IT_COLLECT01                = IT_COLLECT01
**   IT_COLLECT02                = IT_COLLECT02
**   IT_COLLECT03                = IT_COLLECT03
**   IT_COLLECT04                = IT_COLLECT04
**   IT_COLLECT05                = IT_COLLECT05
**   IT_COLLECT06                = IT_COLLECT06
**   IT_COLLECT07                = IT_COLLECT07
**   IT_COLLECT08                = IT_COLLECT08
**   IT_COLLECT09                = IT_COLLECT09
** CHANGING
**   CT_GROUPLEVELS              = CT_GROUPLEVELS
** EXCEPTIONS
**   FIELDCAT_NOT_COMPLETE       = 1
**   OTHERS                      = 2
*          .
*IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*ENDIF.
*
*
*      /cadaxo/cl_sqlc_cockpit_assist=>export_data( EXPORTING i_export_type = 'CSV'
*                                                             it_fcat       = <l_lvc_t_fcat>
*                                                             it_data       = <lt_result> ).
*    ENDIF.
*  ENDIF.
  ENDMETHOD.


  METHOD handle_result_command_close.
****************************************************************************************************
* Description             : handle result command CLOSE                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO GmbH              Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    FIELD-SYMBOLS: <lr_grid> LIKE LINE OF gcont_grid_result_t.

    ASSIGN gcont_grid_result_t[ i_grid_i ]  TO <lr_grid>.
    IF sy-subrc = 0.
      DELETE gcont_grid_result_t INDEX i_grid_i.
      DELETE gt_cl_sql_parse     INDEX i_grid_i.
      DELETE dref_result_tab_t   INDEX i_grid_i.
      DELETE gt_lvc_t_fcat       INDEX i_grid_i.
      DELETE gt_lvc_t_sort       INDEX i_grid_i.
      DELETE gt_lvc_t_filt       INDEX i_grid_i.
      DELETE gt_result_details   INDEX i_grid_i.
    ENDIF.
    IF NOT gcont_grid_result_t[] IS INITIAL.
      me->show_result( ).
    ELSE.
      me->set_result_toolbar_active( i_fcode = c_cmd_home ).
      me->show_html( ).
    ENDIF.
  ENDMETHOD.


  METHOD handle_result_command_compare.

    DATA l_stable       TYPE ddobjname.
    DATA l_ttable       TYPE ddobjname.
    DATA lr_exception   TYPE REF TO /cadaxo/cx_sqlc_dcomp_simple.
    DATA lt_row_no      TYPE lvc_t_roid.
    DATA lv_source_type TYPE i.
    DATA lv_target_type TYPE i.

    FIELD-SYMBOLS: <lr_source>        TYPE REF TO data.
    FIELD-SYMBOLS: <lr_target>        TYPE REF TO data.
    FIELD-SYMBOLS: <lt_source>        TYPE ANY TABLE.
    FIELD-SYMBOLS: <lt_target>        TYPE ANY TABLE.
    FIELD-SYMBOLS: <ls_sql_parse_s>   TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
    FIELD-SYMBOLS: <ls_sql_parse_t>   TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
    FIELD-SYMBOLS: <ls_result_dfies>  TYPE /cadaxo/sqlcdfies.
    FIELD-SYMBOLS: <ls_result_source> TYPE /cadaxo/sqlcselectsource.
    FIELD-SYMBOLS: <ls_dd03p>         TYPE dd03p.
    FIELD-SYMBOLS: <l_grid>           LIKE LINE OF me->gcont_grid_result_t.

    READ TABLE me->dref_result_tab_t INDEX i_source ASSIGNING <lr_source>.
    READ TABLE me->dref_result_tab_t INDEX i_target ASSIGNING <lr_target>.

    ASSIGN <lr_source>->* TO <lt_source>.
    ASSIGN <lr_target>->* TO <lt_target>.

    READ TABLE me->gt_cl_sql_parse INDEX i_source ASSIGNING <ls_sql_parse_s>.
    READ TABLE me->gt_cl_sql_parse INDEX i_target ASSIGNING <ls_sql_parse_t>.

    LOOP AT <ls_sql_parse_s>->result_source_t ASSIGNING FIELD-SYMBOL(<ls_source>).
      IF l_stable IS INITIAL.
        l_stable = <ls_source>-table.
      ELSE.
        l_stable = l_stable && ', ' && <ls_source>-table.
      ENDIF.
    ENDLOOP.

    LOOP AT <ls_sql_parse_t>->result_source_t ASSIGNING FIELD-SYMBOL(<ls_target>).
      IF l_ttable IS INITIAL.
        l_ttable = <ls_target>-table.
      ELSE.
        l_ttable = l_ttable && ', ' && <ls_target>-table.
      ENDIF.
    ENDLOOP.

    IF <ls_sql_parse_s>->column_syntax = '*' AND <ls_sql_parse_s>->g_saved_list IS INITIAL.
      lv_source_type = 1.
    ENDIF.

    IF <ls_sql_parse_t>->column_syntax = '*' AND <ls_sql_parse_t>->g_saved_list IS INITIAL.
      lv_target_type = 1.
    ENDIF.

    CALL FUNCTION '/CADAXO/SQLCDCOMPCOMPLEX'
      EXPORTING
        it_source             = <lt_source>
        it_target             = <lt_target>
        i_source_number       = i_source
        i_target_number       = i_target
        it_source_dfies       = <ls_sql_parse_s>->gt_result_ddfields
        it_target_dfies       = <ls_sql_parse_t>->gt_result_ddfields
        iv_source_select_type = lv_source_type
        iv_target_select_type = lv_target_type
        i_source_name         = l_stable
        i_target_name         = l_ttable
        i_user_settings       = me->g_user_settings
        it_result_details     = me->gt_result_details.

*    IF l_srow > 0 AND l_trow > 0.
*      READ TABLE me->gcont_grid_result_t INDEX i_source ASSIGNING <l_grid>.
*      IF sy-subrc = 0.
*        CLEAR lt_row_no.
*        ls_row_no-row_id = l_srow.
*        APPEND ls_row_no TO lt_row_no.
*        CALL METHOD <l_grid>-gui_alv_grid->set_selected_rows
*          EXPORTING
*            it_row_no = lt_row_no.
*      ENDIF.
*
*      READ TABLE me->gcont_grid_result_t INDEX i_target ASSIGNING <l_grid>.
*      IF sy-subrc = 0.
*        CLEAR lt_row_no.
*        ls_row_no-row_id = l_trow.
*        APPEND ls_row_no TO lt_row_no.
*        CALL METHOD <l_grid>-gui_alv_grid->set_selected_rows
*          EXPORTING
*            it_row_no = lt_row_no.
*      ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD handle_result_command_exp_csv.
****************************************************************************************************
* Description             : Handle Export to CSV                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dusan Sacha              Company    : CADAXO GesmbH                    *
* Date                    : 12.03.2018               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxxxxx                 *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA lv_filename     TYPE string.
    DATA lv_path         TYPE string.
    DATA lv_fullpath     TYPE string.
    DATA lv_user_action  TYPE i.
    DATA iv_output_table TYPE TABLE OF string .
    DATA lv_tmp_dats     TYPE char30.
    DATA lv_tmp_out      TYPE string.

    FIELD-SYMBOLS: <lt_result> TYPE STANDARD TABLE.

    ASSIGN dref_result_tab_t[ i_grid_i ] TO FIELD-SYMBOL(<lr_dref>).
    ASSIGN gt_lvc_t_fcat[ i_grid_i ] TO FIELD-SYMBOL(<lt_fields>).
    ASSIGN <lr_dref>->* TO <lt_result>.

    IF <lt_result> IS NOT INITIAL.

*Begin of Insert Cockpit-398
      CALL METHOD me->get_csv_from_int_tab_cust
        EXPORTING
          it_table      = <lt_result>
          i_grid_i      = i_grid_i
        IMPORTING
          ev_output_csv = iv_output_table
          ev_cancel     = DATA(lv_cancel).
      IF lv_cancel = abap_true.
        RETURN.
      ENDIF.
*End   of Insert Cockpit-398

*Begin of Comments Cockpit-398
*      CALL METHOD me->get_csv_from_int_tab
*        EXPORTING
*          it_table      = <lt_result>
*          i_grid_i      = i_grid_i
*        IMPORTING
*          ev_output_csv = iv_output_table.
*End   of Comments Cockpit-398

      cl_gui_frontend_services=>file_save_dialog(
        EXPORTING
          default_extension    = 'csv'
          file_filter          = '.csv'
        CHANGING
          filename             = lv_filename
          path                 = lv_path
          fullpath             = lv_fullpath
          user_action          = lv_user_action
        EXCEPTIONS
          OTHERS               = 1
      ).

      IF sy-subrc EQ 0 AND lv_user_action EQ 0.

        cl_gui_frontend_services=>gui_download(
            EXPORTING
                filename = lv_fullpath
            CHANGING
                data_tab = iv_output_table
            EXCEPTIONS
                OTHERS = 1
        ).
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD handle_result_command_fulldisp.
****************************************************************************************************
* Description             : Open ALV in Fullscreen Mode                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxxxxx                 *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | Convertion Exits and Fieldnames             | COCKPIT-105    *
*------------+----------------------+---------------------------------------------+----------------*
* 13.07.2017 | Pratik Patil         | Fieldnames Fix                              | COCKPIT-324    *
****************************************************************************************************
    DATA: lr_salv_table       TYPE REF TO cl_salv_table.
    DATA: lr_functions        TYPE REF TO cl_salv_functions.
    DATA: lr_columns          TYPE REF TO cl_salv_columns_table.
    DATA: lt_salv_s_ui_func   TYPE TABLE OF salv_s_ui_func.
    DATA: lt_columns          TYPE salv_t_column_ref.
    DATA: lr_display_settings TYPE REF TO cl_salv_display_settings.
    DATA: ls_layout           TYPE lvc_s_layo.

    FIELD-SYMBOLS: <lt_result_tab> TYPE STANDARD TABLE,
                   <ls_fcat_main>  TYPE lvc_s_fcat.

    READ TABLE dref_result_tab_t INDEX i_grid_i ASSIGNING FIELD-SYMBOL(<lr_dref>).
    IF sy-subrc = 0.
      READ TABLE gt_cl_sql_parse INDEX i_grid_i ASSIGNING FIELD-SYMBOL(<lr_parser>). "COCKPIT-105

      ASSIGN <lr_dref>->* TO <lt_result_tab>.

      IF <lt_result_tab> IS ASSIGNED.
        TRY.

* create alv object
            cl_salv_table=>factory( IMPORTING r_salv_table = lr_salv_table
                                    CHANGING  t_table      = <lt_result_tab> ).

          CATCH cx_salv_msg.

        ENDTRY.

        lr_functions = lr_salv_table->get_functions( ).

        lt_salv_s_ui_func = lr_functions->get_functions( ).

        lr_functions->set_all( abap_true ).

        LOOP AT lt_salv_s_ui_func ASSIGNING FIELD-SYMBOL(<l_salv_s_ui_func>).
          CASE <l_salv_s_ui_func>-r_function->get_name( ).
            WHEN '&VGRID' OR '&VEXCEL' OR '&VLOTUS' OR '&OL0' OR '&ABC'
              OR '&MAINTAIN' OR '&SAVE' OR '&LOAD'.
              <l_salv_s_ui_func>-r_function->set_visible( abap_false ).
          ENDCASE.
        ENDLOOP.

        ASSIGN me->gt_lvc_t_fcat[ i_grid_i ] TO FIELD-SYMBOL(<lt_fcat_main>).

* get the columns
        lr_columns = lr_salv_table->get_columns( ).
        lt_columns = lr_columns->get( ).

        LOOP AT lt_columns ASSIGNING FIELD-SYMBOL(<ls_columns>).
          ASSIGN <lt_fcat_main>[ sy-tabix ] TO <ls_fcat_main>.

          <ls_columns>-r_column->set_short_text( CONV #( <ls_fcat_main>-scrtext_s ) ).
          <ls_columns>-r_column->set_medium_text( CONV #( <ls_fcat_main>-scrtext_m ) ).
          <ls_columns>-r_column->set_long_text( <ls_fcat_main>-scrtext_l ).

          IF <ls_fcat_main>-convexit IS NOT INITIAL.
            <ls_columns>-r_column->set_edit_mask( value = CONV #( |=={ <ls_fcat_main>-convexit }| ) ).
          ELSEIF <ls_fcat_main>-edit_mask IS NOT INITIAL.
            <ls_columns>-r_column->set_edit_mask( value = <ls_fcat_main>-edit_mask ).
          ENDIF.
          IF <ls_fcat_main>-parameter0 = abap_true.
            <ls_columns>-r_column->set_leading_spaces( if_salv_c_bool_sap=>true ).
          ELSE.
            <ls_columns>-r_column->set_leading_spaces( if_salv_c_bool_sap=>false ).
          ENDIF.

        ENDLOOP.

        lr_columns->set_optimize( 'X' ).

        lr_display_settings = lr_salv_table->get_display_settings( ).

* get the list header
        READ TABLE gcont_grid_result_t INDEX i_grid_i ASSIGNING FIELD-SYMBOL(<lr_grid>).
        IF sy-subrc = 0.

          <lr_grid>-gui_alv_grid->get_frontend_layout( IMPORTING es_layout = ls_layout ).

          lr_display_settings->set_list_header( EXPORTING value = ls_layout-grid_title ).

        ENDIF.

* display the result table
        lr_salv_table->display( ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD handle_result_command_hold.
****************************************************************************************************
* Description             : handle result command HOLD                                             *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO GmbH              Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_index TYPE i.

    FIELD-SYMBOLS: <lr_dref>            TYPE REF TO data,
                   <lr_sql>             LIKE LINE OF gt_cl_sql_parse,
                   <l_cont_grid_result> LIKE LINE OF me->gcont_grid_result_t.

    READ TABLE dref_result_tab_t INDEX i_grid_i ASSIGNING <lr_dref>.
    IF sy-subrc = 0.

      l_index = sy-tabix.

* set hold flag in parser class.
      READ TABLE gt_cl_sql_parse ASSIGNING <lr_sql> INDEX l_index.
      IF sy-subrc = 0.
        IF <lr_sql>->g_hold_result IS INITIAL.
          <lr_sql>->g_hold_result = 'X'.
        ELSE.
          <lr_sql>->g_hold_result = space.
        ENDIF.
      ENDIF.

* set hold flag in result class
      READ TABLE me->gcont_grid_result_t INDEX l_index ASSIGNING <l_cont_grid_result>.
      IF sy-subrc = 0.
        <l_cont_grid_result>-hold = <lr_sql>->g_hold_result.
        <l_cont_grid_result>-gui_alv_grid->set_toolbar_interactive( ).
      ENDIF.

* send success message
      IF  <lr_sql>->g_hold_result = abap_true.
        MESSAGE s098(/cadaxo/sqlc).
      ELSE.
        MESSAGE s099(/cadaxo/sqlc).
      ENDIF.

    ENDIF.

    UNASSIGN: <lr_dref>,
              <lr_sql>,
              <l_cont_grid_result>.

    FREE l_index.

  ENDMETHOD.


  METHOD handle_result_command_keyfix.
****************************************************************************************************
* Description             : handle result command KEYFIX                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO GmbH              Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_index       TYPE i.
    DATA ls_layout_tmp TYPE lvc_s_layo.
    DATA lt_lvc_t_sort TYPE lvc_t_sort.
    DATA lt_lvc_t_filt TYPE lvc_t_filt.

    FIELD-SYMBOLS: <lr_dref>            TYPE REF TO data,
                   <lr_sql>             LIKE LINE OF gt_cl_sql_parse,
                   <l_cont_grid_result> LIKE LINE OF me->gcont_grid_result_t,
                   <l_lvc_t_fcat>       LIKE LINE OF gt_lvc_t_fcat,
                   <lt_result>          TYPE STANDARD TABLE.

    READ TABLE dref_result_tab_t INDEX i_grid_i ASSIGNING <lr_dref>.
    IF sy-subrc = 0.
      l_index = sy-tabix.
      READ TABLE me->gcont_grid_result_t INDEX l_index ASSIGNING <l_cont_grid_result>.
      IF sy-subrc = 0.
        <l_cont_grid_result>-gui_alv_grid->get_frontend_layout( IMPORTING es_layout = ls_layout_tmp ).
        IF ls_layout_tmp-no_keyfix = abap_true.
          ls_layout_tmp-no_keyfix = abap_false.
        ELSE.
          ls_layout_tmp-no_keyfix = abap_true.
        ENDIF.

        READ TABLE gt_cl_sql_parse ASSIGNING <lr_sql> INDEX l_index.
        IF sy-subrc = 0.
          READ TABLE gt_lvc_t_fcat INDEX l_index ASSIGNING <l_lvc_t_fcat>.
          IF sy-subrc = 0.

            READ TABLE gt_lvc_t_sort INDEX l_index INTO lt_lvc_t_sort.

            READ TABLE gt_lvc_t_filt INDEX l_index INTO lt_lvc_t_filt.

            ASSIGN <lr_dref>->* TO <lt_result>.

* show result table
            <l_cont_grid_result>-gui_alv_grid->set_table_for_first_display(
              EXPORTING
                i_bypassing_buffer            = 'X'
                is_layout                     = ls_layout_tmp
                it_toolbar_excluding          = me->g_result_toolbar_excluding
              CHANGING
                it_fieldcatalog               = <l_lvc_t_fcat>
                it_outtab                     = <lt_result>
                it_sort                       = lt_lvc_t_sort
                it_filter                     = lt_lvc_t_filt
              EXCEPTIONS
                invalid_parameter_combination = 1
                program_error                 = 2
                too_many_lines                = 3
                OTHERS                        = 4 ).

          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.

    UNASSIGN: <lr_dref>,
              <lr_sql>,
              <l_cont_grid_result>,
              <l_lvc_t_fcat>,
              <lt_result>.

    FREE: l_index,
          ls_layout_tmp,
          lt_lvc_t_sort,
          lt_lvc_t_filt.

  ENDMETHOD.


  METHOD handle_result_command_refrlst.
****************************************************************************************************
* Description             : handle result command REFRESH_LIST                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO GmbH              Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 19.09.2014 | RenÃƒÂ© Rammer          | Bug Fix: ALV Refresh Sum                    | CR22-032       *
*            |                      |                                             | RT#244         *
*------------+----------------------+---------------------------------------------+----------------*
* 20.03.2015 | Bigl Domi            | Bug Fix: List refresh                       | RT#314         *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_index            TYPE i.
    DATA l_result_details   TYPE /cadaxo/sqlcresult_details.
    DATA ls_row_no          TYPE lvc_s_roid.
    DATA ls_row_info        TYPE lvc_s_row.
    DATA ls_col_info        TYPE lvc_s_col.
    DATA ls_layout_tmp      TYPE lvc_s_layo.
    DATA ls_layout          TYPE lvc_s_layo.
    DATA lv_footer          TYPE string.

    FIELD-SYMBOLS: <lr_dref>            LIKE LINE OF dref_result_tab_t,
                   <lr_cl_sql_parse>    LIKE LINE OF gt_cl_sql_parse,
                   <ls_result_details>  LIKE LINE OF me->gt_result_details,
                   <l_cont_grid_result> LIKE LINE OF me->gcont_grid_result_t.

    FIELD-SYMBOLS: <lt_result_tab>    TYPE STANDARD TABLE.
    FIELD-SYMBOLS <lt_result_old> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <lt_result_new> TYPE STANDARD TABLE.
    "  FIELD-SYMBOLS <fcat> LIKE LINE OF gt_lvc_t_fcat.


    READ TABLE dref_result_tab_t INDEX i_grid_i ASSIGNING <lr_dref>.
    IF sy-subrc = 0.
      l_index = sy-tabix.
      READ TABLE gt_cl_sql_parse INDEX l_index ASSIGNING <lr_cl_sql_parse>.
      IF sy-subrc = 0.

        <lr_cl_sql_parse>->create_result_structures( ).

* execute select
        <lr_cl_sql_parse>->execute_select( EXPORTING i_user_settings  = me->ms_user_settings_xml
                                           IMPORTING e_result_details = l_result_details ).

* get result details
        READ TABLE me->gt_result_details INDEX l_index ASSIGNING <ls_result_details>.
        IF sy-subrc = 0.
          MOVE l_result_details TO <ls_result_details>.

          READ TABLE me->gcont_grid_result_t INDEX l_index ASSIGNING <l_cont_grid_result>.
          IF sy-subrc = 0.

* get current position in alv
            <l_cont_grid_result>-gui_alv_grid->get_scroll_info_via_id( IMPORTING es_row_no = ls_row_no
                                                                                 es_row_info = ls_row_info
                                                                                 es_col_info = ls_col_info ).

* update frontend layout (title)
            <l_cont_grid_result>-gui_alv_grid->get_frontend_layout( IMPORTING es_layout = ls_layout_tmp ).

            ls_layout            = me->g_result_layout.
            ls_layout-frontend   = ls_layout_tmp-frontend.
            ls_layout-grid_title = /cadaxo/cl_sqlc_cockpit_main=>build_result_grid_title( i_runtime = <ls_result_details>-runtime
                                                                                          i_lines   = <ls_result_details>-lines ).

            lv_footer = /cadaxo/cl_sqlc_cockpit_main=>build_result_grid_footer( iv_mandant           = <ls_result_details>-mandant
                                                                                iv_syst              = <ls_result_details>-syst
                                                                                iv_create_timestamp  = <ls_result_details>-create_timestamp
                                                                                iv_uname             = <ls_result_details>-uname ).

* refresh footer
            IF <l_cont_grid_result>-cl_document_footer IS BOUND.
              create_dyn_document(
                EXPORTING
                  i_parent    = <l_cont_grid_result>-cl_document_footer->custom_container
                  i_sql       = lv_footer
                CHANGING
                  ic_document = <l_cont_grid_result>-cl_document_footer ).
            ENDIF.

            <l_cont_grid_result>-gui_alv_grid->set_frontend_layout( is_layout = ls_layout ).

* refresh display
* gets the new (refreshed) values from <lr_cl_sql_parse>->result_table and writes it (ultimately) into mt_outtab of <l_cont_grid_result>-gui_alv_grid
            ASSIGN <lr_dref>->* TO <lt_result_old>.           "CR22-032
            ASSIGN <lr_cl_sql_parse>->result_table->* TO <lt_result_new>."CR22-032
            <lr_cl_sql_parse>->result_table = <lr_dref>.       "COCKPIT-464
*            <lt_result_old> = <lt_result_new>.                "CR22-032

            <l_cont_grid_result>-gui_alv_grid->refresh_table_display( ).

*RT#314 DELETE
**** set new frontend field catalog
***          CALL METHOD <l_cont_grid_result>-gui_alv_grid->set_frontend_fieldcatalog "frontend_fieldcatalog
***            EXPORTING
***              it_fieldcatalog = lt_lvc_t_fcat.
*RT#314 DELETE END

* set current position in alv
            <l_cont_grid_result>-gui_alv_grid->set_scroll_info_via_id( EXPORTING is_row_no = ls_row_no is_row_info = ls_row_info is_col_info = ls_col_info ).

          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.

    FREE: l_index,
          l_result_details,
          ls_row_no,
          ls_row_info,
          ls_col_info,
          ls_layout_tmp,
          ls_layout,
          lv_footer.

  ENDMETHOD.


  METHOD insert_codeblock_at_position.
****************************************************************************************************
* Description             : Insert a codeblock at a specific position                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxxxxx                 *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 04.08.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | After the insert, set the cursor to the     | CDX001-0006    *
*            |                      | new position                                |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Split String at CR/LF                       | CDX001-0014    *
*------------+----------------------+---------------------------------------------+----------------*
* 08.03.2011 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add '~'                                     | CDX001-0022    *
*------------+----------------------+---------------------------------------------+----------------*
* 24.02.2018 | Domi Bigl            | Insert after/between ' or `                 | COCKPIT-308    *
*------------+----------------------+---------------------------------------------+----------------*
* 14.03.2018 | Dusan Sacha          | Split insert longer than 220 characters     | COCKPIT-315    *
*            |                      | to prevent dump by 255                      |                *
****************************************************************************************************

    DATA: lv_codeline   TYPE /cadaxo/sqlccodeline.
    DATA: lv_pos        TYPE i.
    DATA: lv_string     TYPE string.
    DATA: lt_string     TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA: lv_line       TYPE i.  "COCKPIT-315

    lv_line = iv_line.   "COCKPIT-315

    lv_string = iv_sqlstring.

    gc_abap_editor->get_line_text( EXPORTING line_number = lv_line
                                   IMPORTING text        = lv_codeline ).

    IF iv_pos <> 1.
      lv_pos = iv_pos - 2.
    ENDIF.

    IF lv_pos GE 1.
* is there a leading space? if not, add a space
      IF lv_codeline+lv_pos(1) CN ' /"(~`'''.                             "CDX001-0022 "COCKPIT-308 '`
        CONCATENATE ' ' lv_string INTO lv_string RESPECTING BLANKS.
      ENDIF.
    ENDIF.

    IF iv_pos <> 1.                                                     "CDX001-0006
      lv_pos = iv_pos - 1.                                              "CDX001-0006
    ENDIF.                                                              "CDX001-0006

    IF lv_pos GE 1.                                                     "CDX001-0006
      IF lv_codeline+lv_pos(1) CN ' /")~`'''.                           "CDX001-0006
        CONCATENATE lv_string ' ' INTO lv_string RESPECTING BLANKS.     "CDX001-0006 "COCKPIT-308 '`
      ENDIF.                                                            "CDX001-0006
    ENDIF.                                                              "CDX001-0006

    IF lv_pos GE 220.                                                     "COCKPIT-315
      lv_string = space && cl_abap_char_utilities=>cr_lf && lv_string.    "COCKPIT-315
    ENDIF.                                                                "COCKPIT-315

* split the string at cr/lf into table
    SPLIT lv_string AT cl_abap_char_utilities=>cr_lf INTO TABLE lt_string. "CDX001-0014

* insert the sql string
    gc_abap_editor->insert_block_at_position( EXPORTING  line     = lv_line
                                                         pos      = iv_pos
                                                         text_tab = lt_string
                                              EXCEPTIONS OTHERS   = 1 ).
    IF sy-subrc <> 0.
      MESSAGE e100(/cadaxo/sqlc) WITH 'SY-SUBRC' sy-subrc.
    ENDIF.

    gc_abap_editor->select_lines( EXPORTING  from_line = 0
                                             to_line   = 0
                                  EXCEPTIONS OTHERS    = 2 ).

    IF lv_pos GE 220.                       "COCKPIT-315
      lv_pos = strlen( iv_sqlstring ) + 1.  "COCKPIT-315
      lv_line = lv_line + 1.                "COCKPIT-315
    ELSE.                                   "COCKPIT-315
      lv_pos = iv_pos + strlen( iv_sqlstring ) + 1.           "CDX001-0006
    ENDIF.                                  "COCKPIT-315


    gc_abap_editor->set_selection_pos_in_line( EXPORTING line = lv_line                                   "CDX001-0006
                                                         pos  = lv_pos ).                                 "CDX001-0006

    IF i_set_focus = abap_true.
      gc_abap_editor->set_focus(
         control = gc_abap_editor ).
    ENDIF.

    FREE lt_string[].

  ENDMETHOD.


  METHOD insert_saved_list.

    DATA ls_sqlcress TYPE /cadaxo/sqlcress.
    DATA ls_sqlcsres TYPE /cadaxo/sqlcsres.

    IF it_saved_list IS NOT INITIAL.

      DATA(ls_saved_list)  = it_saved_list[ 1 ].

      ls_sqlcress = CORRESPONDING #( ls_saved_list ).
      CALL FUNCTION 'GUID_CREATE'
        IMPORTING
          ev_guid_16 = ls_sqlcress-ress_guid.

      ls_sqlcsres = CORRESPONDING #( ls_saved_list ).
      ls_sqlcsres-ress_guid = ls_sqlcress-ress_guid.
      CALL FUNCTION 'GUID_CREATE'
        IMPORTING
          ev_guid_16 = ls_sqlcsres-list_guid.

      INSERT /cadaxo/sqlcress FROM ls_sqlcress.
      IF sy-subrc EQ 0.
        INSERT /cadaxo/sqlcsres FROM ls_sqlcsres.
        IF sy-subrc = 0.
          ev_update_ok = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD insert_table_to_editor.
****************************************************************************************************
* Description             : insert table to editor                                                 *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_from_line TYPE i,
          l_from_pos  TYPE i,
          l_to_line   TYPE i,
          l_to_pos    TYPE i.

* get the actual selection
    gc_abap_editor->get_selection_pos(
      IMPORTING
        from_line              = l_from_line
        from_pos               = l_from_pos
        to_line                = l_to_line
        to_pos                 = l_to_pos
      EXCEPTIONS
        error_cntl_call_method = 1
        OTHERS                 = 2 ).

    IF sy-subrc = 0.

      IF l_from_line <> l_to_line OR
         l_from_pos  <> l_to_pos.

        MESSAGE i005(/cadaxo/sqlc).

      ELSE.

        me->insert_codeblock_at_position(
            iv_line = l_from_line
            iv_pos = l_from_pos
            iv_sqlstring = i_string
            i_set_focus = abap_true ).

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD is_result_filled.
    IF NOT dref_result_tab_t[] IS INITIAL.
      r_filled = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD load_home_html.
****************************************************************************************************
* Description             : Load Home HTML                                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lt_file           TYPE TABLE OF string,
          l_parameter_val   TYPE /cadaxo/sqlcparameter_val,
          lt_file_name      TYPE filetable,
          l_rc              TYPE i,
          l_title           TYPE string,
          l_user_action     TYPE i,
          l_filename_string TYPE string.
    DATA: l_param_id        TYPE /cadaxo/sqlcparameter_id.

    FIELD-SYMBOLS: <l_file_name> TYPE file_table,
                   <l_file>      TYPE string.

    MOVE text-t04 TO l_title.

* call file open dialog
    cl_gui_frontend_services=>file_open_dialog(
      EXPORTING
        window_title            = l_title
        default_extension       = '*.htm'
        file_filter             = 'HTML Files (*.HTM;*.HTML)|*.HTM;*.HTML'
      CHANGING
        file_table              = lt_file_name
        rc                      = l_rc
        user_action             = l_user_action
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5 ).
    IF sy-subrc = 0.
      CASE l_user_action.
        WHEN 9. "Canceld by user
        WHEN 0. "File selected
          READ TABLE lt_file_name ASSIGNING <l_file_name> INDEX 1.
          IF sy-subrc = 0.
            MOVE <l_file_name>-filename TO l_filename_string.

* call gui upload dialog
            cl_gui_frontend_services=>gui_upload(
              EXPORTING
                filename                = l_filename_string
              CHANGING
                data_tab                = lt_file
              EXCEPTIONS
                file_open_error         = 1
                file_read_error         = 2
                no_batch                = 3
                gui_refuse_filetransfer = 4
                invalid_type            = 5
                no_authority            = 6
                unknown_error           = 7
                bad_data_format         = 8
                header_not_allowed      = 9
                separator_not_allowed   = 10
                header_too_long         = 11
                unknown_dp_error        = 12
                access_denied           = 13
                dp_out_of_memory        = 14
                disk_full               = 15
                dp_timeout              = 16
                not_supported_by_gui    = 17
                error_no_gui            = 18
                OTHERS                  = 19 ).
            IF sy-subrc = 0.

              LOOP AT lt_file ASSIGNING <l_file>.
                CONCATENATE l_parameter_val <l_file> INTO l_parameter_val.
              ENDLOOP.

* save the html document to sql-cockpit parameter table
              l_param_id = 'HTML_STARTUP'.
              /cadaxo/cl_sqlc_cockpit_assist=>set_parameter_value(
                EXPORTING
                  i_parameter_id    = l_param_id
                  i_parameter_value = l_parameter_val ).
              CONCATENATE 'HTML_STARTUP_' sy-langu INTO l_param_id.
              /cadaxo/cl_sqlc_cockpit_assist=>set_parameter_value(
                EXPORTING
                  i_parameter_id    = l_param_id
                  i_parameter_value = l_parameter_val ).

            ELSE.
              MESSAGE e100(/cadaxo/sqlc) WITH 'SY-SUBRC' sy-subrc.
            ENDIF.
          ELSE.
            MESSAGE e100(/cadaxo/sqlc) WITH 'SY-SUBRC' sy-subrc.
          ENDIF.
      ENDCASE.
    ELSE.
      MESSAGE e100(/cadaxo/sqlc) WITH 'SY-SUBRC' sy-subrc.
    ENDIF.

  ENDMETHOD.


  METHOD log_alv_line_selection.

    DATA gui_control     TYPE REF TO cl_gui_control.
    DATA gui_alv_grid    TYPE REF TO cl_gui_alv_grid.

    cl_gui_alv_grid=>get_focus( IMPORTING control = gui_control ).
    gui_alv_grid ?= gui_control.

    CALL METHOD gui_alv_grid->refresh_table_display
      EXPORTING
        i_soft_refresh = abap_true
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.

    IF gt_selected_rows IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_first_row) = gt_selected_rows[ 1 ].
    APPEND ls_first_row TO gt_selected_disp.
    SORT gt_selected_disp DESCENDING.
    DELETE gt_selected_rows INDEX 1.
    gv_selected_counter = gv_selected_counter + 1.

    TRY.
        CALL METHOD gui_alv_grid->set_selected_rows
          EXPORTING
            it_index_rows            = gt_selected_disp
            is_keep_other_selections = abap_true.
        MESSAGE s137(/cadaxo/sqlc) WITH gv_selected_counter gv_selected_total.
        IF gt_selected_rows IS INITIAL.
          CLEAR: gv_selected_counter, gv_selected_total.
        ENDIF.

      CATCH cx_sy_move_cast_error ##no_handler.
    ENDTRY.

  ENDMETHOD.


  METHOD match_saved_fieldcat_orig.
****************************************************************************************************
* Description             : match saved fieldcat with original                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations : #4092                                                                  *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 23.10.2013               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Ana Lekic                Company    : CADAXO GesmbH                    *
* Date                    : 06.11.2014                                                             *
*--------------------------------------------------------------------------------------------------*
* Compare FCAT-values of fields with DDIC-reference between saved and actual (DDIC) values.        *
* If values unchanged in datatype and length, take the actual FCAT-values from DDIC, otherwise keep*
* the saved FCAT-Values                                                                            *
*                                                                                                  *
* For downwardscompatibilty reasons (saved lists from older releases) adjust in itab rt_fcat the   *
* value of field "FIELDNAME", if necessary. Field catalog must fit to alv-itab.                    *
* In older releases the value of field "FIELDNAME" was in some cases just the fieldname e.g. MATNR *
* Now the value of field "FIELDNAME" is always tabname-fieldname e.g. MARA-MATNR                   *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 11.09.2014 | Dieter Schadler      | Method completly rewritten                  | ticket #138    *
*------------+----------------------+---------------------------------------------+----------------*
* 06.08.2015 | Ana Lekic            | no output from the 100th field -  supress   | RT340          *
*------------+----------------------+---------------------------------------------+----------------*
* 15.04.2018 | Domi Bigl            | different tablename in FCat                 | COCKPIT-317    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    TYPES: BEGIN OF lty_tabledetails,
             tabname      TYPE tabname,
             it_fcat_ddic TYPE lvc_t_fcat.
    TYPES: END OF lty_tabledetails.

    FIELD-SYMBOLS <fs_fcat>         TYPE LINE OF lvc_t_fcat.
    FIELD-SYMBOLS <fs_fcat_ddic>    TYPE LINE OF lvc_t_fcat.
    DATA lt_tabledetails            TYPE TABLE OF lty_tabledetails.
    FIELD-SYMBOLS <ls_tabledetails> LIKE LINE OF lt_tabledetails.
    DATA lv_tabname                 TYPE tabname.
    DATA lv_fieldname               TYPE string.
    DATA lv_component TYPE string.
    DATA lt_fcat LIKE it_fcat.
    FIELD-SYMBOLS <component> TYPE any.
    DATA lr_dref TYPE REF TO data.
    FIELD-SYMBOLS <ft_result_table> TYPE ANY TABLE.
    FIELD-SYMBOLS <fs_result_table> TYPE any.

    CLEAR rt_fcat[].
    lt_fcat[] = it_fcat[].

    ASSIGN it_result_table TO <ft_result_table>.
    CREATE DATA lr_dref LIKE LINE OF <ft_result_table>.
    ASSIGN lr_dref->* TO <fs_result_table>.

    LOOP AT lt_fcat ASSIGNING <fs_fcat>.

      CLEAR: lv_tabname,
             lv_fieldname.
      SPLIT <fs_fcat>-fieldname AT '-' INTO lv_tabname lv_fieldname.

      IF lv_tabname IS INITIAL OR lv_fieldname IS INITIAL.

        CONCATENATE i_tabname
                    <fs_fcat>-fieldname
               INTO lv_component
               SEPARATED BY '-'.

        ASSIGN COMPONENT lv_component OF STRUCTURE <fs_result_table> TO <component>.
        IF sy-subrc = 0.
          <fs_fcat>-fieldname = lv_component.
          SPLIT <fs_fcat>-fieldname AT '-' INTO lv_tabname lv_fieldname.
        ELSE.
          "Fields with no relation to DDIC-tablefields
          APPEND <fs_fcat> TO rt_fcat. "keep saved FCAT value
          CONTINUE.
        ENDIF.
      ENDIF.

      READ TABLE lt_tabledetails ASSIGNING <ls_tabledetails>
                                  WITH KEY tabname = lv_tabname.
      IF sy-subrc <> 0.
        APPEND INITIAL LINE TO lt_tabledetails ASSIGNING <ls_tabledetails>.
        <ls_tabledetails>-tabname = lv_tabname.
        CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
          EXPORTING
            i_structure_name       = lv_tabname
            i_client_never_display = abap_false
            i_bypassing_buffer     = abap_true
          CHANGING
            ct_fieldcat            = <ls_tabledetails>-it_fcat_ddic
          EXCEPTIONS
            inconsistent_interface = 1
            program_error          = 2
            OTHERS                 = 3.
        IF sy-subrc <> 0.
          APPEND <fs_fcat> TO rt_fcat. "keep save FCAT value
          CONTINUE.
        ENDIF.
      ENDIF.

      READ TABLE <ls_tabledetails>-it_fcat_ddic ASSIGNING <fs_fcat_ddic>
                                                WITH KEY fieldname = lv_fieldname.
      IF sy-subrc <> 0.
        "field not available (deleted or renamed)
        APPEND <fs_fcat> TO rt_fcat. "keep saved FCAT value
        CONTINUE.
      ENDIF.

      "check if fielddetails changed
      IF <fs_fcat>-datatype <> <fs_fcat_ddic>-datatype
      OR <fs_fcat>-inttype  <> <fs_fcat_ddic>-inttype
      OR <fs_fcat>-intlen   <> <fs_fcat_ddic>-intlen.
        APPEND <fs_fcat> TO rt_fcat. "keep saved FCAT value
      ELSE.
        <fs_fcat_ddic>-fieldname = <fs_fcat>-fieldname.
        <fs_fcat_ddic>-col_pos   = <fs_fcat>-col_pos.
        CLEAR <fs_fcat_ddic>-no_out.      "RT340
        APPEND <fs_fcat_ddic> TO rt_fcat. "take actual DDIC FCAT value
      ENDIF.

    ENDLOOP.

    ASSIGN rt_fcat[ 1 ] TO FIELD-SYMBOL(<ls_1st_fcatline>).                                         "COCKPIT-317
    IF sy-subrc = 0.                                                                                "COCKPIT-317
      LOOP AT rt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>) WHERE tabname <> <ls_1st_fcatline>-tabname. "COCKPIT-317
        <ls_fcat>-tabname = <ls_1st_fcatline>-tabname.                                              "COCKPIT-317
      ENDLOOP.                                                                                      "COCKPIT-317
    ENDIF.                                                                                          "COCKPIT-317
  ENDMETHOD.


  METHOD match_saved_filter.
****************************************************************************************************
* Description             : match saved filterfields                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations : ticket #138                                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.09.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Ana Lekic                Company    : CADAXO GesmbH                    *
* Date                    : 06.11.2014                                                             *
*--------------------------------------------------------------------------------------------------*
* For downwardscompatibilty reasons (saved lists from older releases) adjust in itab rt_filter the
* value of field "FIELDNAME", if necessary. Filterfields must fit to alv-itab (IT_RESULT_TABLE).
* In older releases the value of field "FIELDNAME" was in some cases just the fieldname e.g. MATNR
* Now the value of field "FIELDNAME" is always tabname-fieldname e.g. MARA-MATNR
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA lt_filter TYPE lvc_t_filt.
    FIELD-SYMBOLS <ls_filter> LIKE LINE OF lt_filter.
    FIELD-SYMBOLS <lt_result_table> TYPE ANY TABLE.
    FIELD-SYMBOLS <ls_result_table> TYPE any.
    DATA lr_dref TYPE REF TO data.
    DATA lv_component TYPE string.
    FIELD-SYMBOLS <lv_component> TYPE any.

    CLEAR rt_filter[].
    lt_filter[] = it_filter[].

    ASSIGN it_result_table TO <lt_result_table>.
    CREATE DATA lr_dref LIKE LINE OF <lt_result_table>.
    ASSIGN lr_dref->* TO <ls_result_table>.

    LOOP AT lt_filter ASSIGNING <ls_filter>.
      "check if filter field fits into result-table
      lv_component = <ls_filter>-fieldname.
      ASSIGN COMPONENT lv_component OF STRUCTURE <ls_result_table> TO <lv_component>.
      IF sy-subrc = 0.
        APPEND <ls_filter> TO rt_filter.
      ELSE.
        CONCATENATE i_tabname
                    '-'
                    lv_component
               INTO lv_component.
        ASSIGN COMPONENT lv_component OF STRUCTURE <ls_result_table> TO <lv_component>.
        IF sy-subrc = 0.
          <ls_filter>-fieldname = lv_component.
          APPEND <ls_filter> TO rt_filter.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD match_saved_sort.
****************************************************************************************************
* Description             : match saved sortfields                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations : ticket #138                                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.09.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Ana Lekic                Company    : CADAXO GesmbH                    *
* Date                    : 06.11.2014                                                             *
*--------------------------------------------------------------------------------------------------*
* For downwardscompatibilty reasons (saved lists from older releases) adjust in itab rt_sort the   *
* value of field "FIELDNAME", if necessary. Sortfields must fit to alv-itab (IT_RESULT_TABLE).     *
* In older releases the value of field "FIELDNAME" was in some cases just the fieldname e.g. MATNR *
* Now the value of field "FIELDNAME" is always tabname-fieldname e.g. MARA-MATNR                   *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA lt_sort TYPE lvc_t_sort.
    FIELD-SYMBOLS <ls_sort> LIKE LINE OF lt_sort.
    FIELD-SYMBOLS <lt_result_table> TYPE ANY TABLE.
    FIELD-SYMBOLS <ls_result_table> TYPE any.
    DATA lr_dref TYPE REF TO data.
    DATA lv_component TYPE string.
    FIELD-SYMBOLS <lv_component> TYPE any.

    CLEAR rt_sort[].
    lt_sort[] = it_sort[].

    ASSIGN it_result_table TO <lt_result_table>.
    CREATE DATA lr_dref LIKE LINE OF <lt_result_table>.
    ASSIGN lr_dref->* TO <ls_result_table>.

    LOOP AT lt_sort ASSIGNING <ls_sort>.
      "check if sort field fits into result-table
      lv_component = <ls_sort>-fieldname.
      ASSIGN COMPONENT lv_component OF STRUCTURE <ls_result_table> TO <lv_component>.
      IF sy-subrc = 0.
        APPEND <ls_sort> TO rt_sort.
      ELSE.
        CONCATENATE i_tabname
                    '-'
                    lv_component
               INTO lv_component.
        ASSIGN COMPONENT lv_component OF STRUCTURE <ls_result_table> TO <lv_component>.
        IF sy-subrc = 0.
          <ls_sort>-fieldname = lv_component.
          APPEND <ls_sort> TO rt_sort.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD move_back_to_sql.
****************************************************************************************************
* Description             : move back to sql                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    FIELD-SYMBOLS: <l_sqlchistline> TYPE /cadaxo/sqlchistline.

    IF NOT gt_sql_hist[] IS INITIAL.

      g_sql_pos = g_sql_pos - 1.

      READ TABLE gt_sql_hist INDEX g_sql_pos ASSIGNING <l_sqlchistline>.
      IF sy-subrc = 0.

        me->usr_action_clear_sql_area( ).

        me->set_sql_area( i_codelines_t =  <l_sqlchistline>-lines[]  ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD move_forw_to_sql.
****************************************************************************************************
* Description             : move back to sql                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    FIELD-SYMBOLS: <l_sqlchistline> TYPE /cadaxo/sqlchistline.

    DATA: l_sql_pos TYPE i.

    IF NOT gt_sql_hist[] IS INITIAL.

      l_sql_pos = me->g_sql_pos + 1.

      READ TABLE gt_sql_hist INDEX l_sql_pos ASSIGNING <l_sqlchistline>.
      IF sy-subrc = 0.

        me->usr_action_clear_sql_area( ).

        me->set_sql_area( i_codelines_t =  <l_sqlchistline>-lines[]  ).

        me->g_sql_pos = l_sql_pos.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD on_abap_error_hotspot_click.
****************************************************************************************************
* Description             : on alv error double click                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxx             Company    : xxxxxxxxx                        *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA ls_help_info TYPE help_info.
    DATA lt_dselc TYPE TABLE OF dselc.
    DATA lt_dval  TYPE TABLE OF dval.
    DATA l_object TYPE dokhl-object.

    FIELD-SYMBOLS: <ls_error> LIKE LINE OF gt_errors.

    READ TABLE gt_errors INDEX e_row_id ASSIGNING <ls_error>.
    IF sy-subrc = 0.

      IF <ls_error>-ci_code <> space AND <ls_error>-ci_test <> space.

        CLEAR l_object.

        l_object(30) = <ls_error>-ci_test.
        l_object+30  = <ls_error>-ci_code.

        CALL FUNCTION 'DOCU_CALL'
          EXPORTING
            displ      = 'X'
            displ_mode = 2
            id         = 'CA'
            langu      = sy-langu
            object     = l_object
          EXCEPTIONS
            wrong_name = 1.
        IF sy-subrc <> 0.
          MESSAGE s100(/cadaxo/sqlc) DISPLAY LIKE 'E' WITH 'ON_ABAP_ERROR_HOTSPOT_CLICK' 'DOCU_CALL' sy-subrc.
        ENDIF.

      ELSE.

        ls_help_info-call         = 'D'.
        ls_help_info-spras        = sy-langu.
        ls_help_info-messageid    = <ls_error>-msgid.
        ls_help_info-messagenr    = <ls_error>-msgno.
        ls_help_info-title        = 'Langtext'.
        ls_help_info-docuid       = 'NA'.
        ls_help_info-msgv1        = <ls_error>-attr1.
        ls_help_info-msgv2        = <ls_error>-attr2.
        ls_help_info-msgv3        = <ls_error>-attr3.
        ls_help_info-msgv4        = <ls_error>-attr4.

        CALL FUNCTION 'HELP_START'
          EXPORTING
            help_infos   = ls_help_info
          TABLES
            dynpselect   = lt_dselc
            dynpvaluetab = lt_dval.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD on_alv_drag.
****************************************************************************************************
* Description             : on alv result list drag                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Bugfix Drag/Drop Dec fields with comma      | CDX130-006     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Bugfix Drag/Drop INT1 field                 | CR22-008       *
*            |                      |                                             | RT143          *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | Leading Spaces in Char Fields               | COCKPIT-125    *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA: lr_drag_object      TYPE REF TO lcl_drag_object,
          l_typ(1)            TYPE c,
          l_fieldvalue        TYPE string,
          l_fieldvaluec(150)  TYPE c,
          lr_cl_gui_control   TYPE REF TO cl_gui_control,
          l_grid_name         TYPE string,
          l_grid_name_i       TYPE i,
          l_fieldname_txt(30) TYPE c.

    FIELD-SYMBOLS: <lt_result_tab>   TYPE STANDARD TABLE,
                   <l_result_line>   TYPE any,
                   <l_result_field>  TYPE any,
                   <lr_dref>         TYPE REF TO data,
                   <lr_cl_sql_parse> TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse,
                   <ls_sql_dfies>    TYPE /cadaxo/sqlcdfies.

    lr_cl_gui_control ?= e_dragdropobj->dragsourcectrl.
    l_grid_name = lr_cl_gui_control->get_name( ).

    MOVE l_grid_name+15 TO l_grid_name_i.

    READ TABLE dref_result_tab_t INDEX l_grid_name_i ASSIGNING <lr_dref>.

* should never happen
    ASSERT ID /cadaxo/sqlc FIELDS l_grid_name_i sy-subrc CONDITION sy-subrc = 0.

    ASSIGN <lr_dref>->* TO <lt_result_tab>.
    IF sy-subrc = 0.

      READ TABLE <lt_result_tab> INDEX e_row-index ASSIGNING <l_result_line>.
      IF sy-subrc = 0.

        ASSIGN COMPONENT e_column-fieldname OF STRUCTURE <l_result_line> TO <l_result_field>.

        DESCRIBE FIELD <l_result_field> TYPE l_typ.

        CLEAR: l_fieldname_txt.                                       "CDX001-0026
        READ TABLE me->gt_cl_sql_parse INDEX l_grid_name_i            "CDX001-0026
              ASSIGNING <lr_cl_sql_parse>.                            "CDX001-0026
        IF sy-subrc = 0.                                             "CDX001-0026
          UNASSIGN <ls_sql_dfies>.                                    "CDX001-0026
          READ TABLE <lr_cl_sql_parse>->gt_result_ddfields            "CDX001-0026
               WITH KEY map_fieldname = e_column-fieldname            "CDX001-0026
               ASSIGNING <ls_sql_dfies>.                              "CDX001-0026
          IF sy-subrc <> 0.                                           "CDX001-0026
            READ TABLE <lr_cl_sql_parse>->gt_result_ddfields          "CDX001-0026
                 WITH KEY fieldname = e_column-fieldname              "CDX001-0026
                 ASSIGNING <ls_sql_dfies>.                            "CDX001-0026
          ENDIF.                                                      "CDX001-0026
          IF <ls_sql_dfies> IS ASSIGNED.                              "CDX001-0026
            IF <ls_sql_dfies>-tabname IS NOT INITIAL AND <ls_sql_dfies>-fieldname IS NOT INITIAL.
              CONCATENATE <ls_sql_dfies>-tabname                        "CDX001-0026
                          '-'                                           "CDX001-0026
                          <ls_sql_dfies>-fieldname                      "CDX001-0026
                          INTO l_fieldname_txt.                         "CDX001-0026
            ELSEIF <ls_sql_dfies>-tabname IS NOT INITIAL.
              l_fieldname_txt = <ls_sql_dfies>-tabname.
            ELSE.
              l_fieldname_txt = <ls_sql_dfies>-fieldname.
            ENDIF.
          ENDIF.                                                      "CDX001-0026
        ENDIF.                                                        "CDX001-0026

        IF l_fieldname_txt IS INITIAL.                                "CDX001-0026
          MOVE e_column-fieldname TO l_fieldname_txt.                 "CDX001-0026
        ENDIF.                                                        "CDX001-0026

        CREATE OBJECT lr_drag_object.
        CASE e_dragdropobj->flavor.
          WHEN 'ALV_TO_CLIPBOARD'.
            IF strlen( l_fieldname_txt ) < 19.
              CONCATENATE l_fieldname_txt ' ...................' INTO l_fieldvaluec.
              MOVE space TO l_fieldvaluec+19.
              IF l_typ CA 'FIP'.
                WRITE <l_result_field> TO l_fieldvaluec+20 LEFT-JUSTIFIED.
              ELSE.
                MOVE <l_result_field> TO l_fieldvaluec+20.
              ENDIF.
              MOVE l_fieldvaluec TO l_fieldvalue.
            ELSE.
              IF l_typ CA 'FIP'.
                WRITE <l_result_field> TO l_fieldvaluec LEFT-JUSTIFIED.
                MOVE l_fieldvaluec TO l_fieldvalue.
              ELSE.
                MOVE <l_result_field> TO l_fieldvalue.
              ENDIF.
              CONCATENATE l_fieldname_txt ' ... ' l_fieldvalue INTO l_fieldvalue.
            ENDIF.
          WHEN 'ALV_TO_EDITOR'.

            TRY.
                /cadaxo/cl_sqlc_cockpit_assist=>convert_value_int_to_editor(
                  EXPORTING
                    iv_typ                 = l_typ
                    iv_fieldvalue_internal = <l_result_field>
                   RECEIVING
                     rv_fieldvalue_editor   = l_fieldvalue
                ).
              CATCH /cadaxo/cx_sqlc_cockpit_assist INTO DATA(lr_sqlc_exception).
                MESSAGE i006(/cadaxo/sqlc) WITH l_typ. "Drag/drop/doubleclick for this fieldtype is not supported
                RETURN.
            ENDTRY.

        ENDCASE.
        lr_drag_object->fieldvalue = l_fieldvalue.
        e_dragdropobj->object = lr_drag_object.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD on_alv_queue_double_click_3000.
****************************************************************************************************
* Description             : ALV_QUEUE_DOUBLE_CLICK                                                 *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* will be triggered when user selects a api line in the queue popup                                *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 01.08.2017               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 26.01.2018 |Pat                   |select symbols for export                    |COCKPIT-294     *
* 28.01.2019 |Pat                   |select variant for export                    |COCKPIT-258     *
* 09.10.2019 |Pat                   |select variant for result                    |COCKPIT-401     *
* 11.11.2020 |Attila Kajtar         |Meine Queue - get SQL                        |COCKPIT-383     *
****************************************************************************************************

    DATA lt_sql TYPE /cadaxo/sqlccodeline_t.

* begin of change COCKPIT-294
    DATA: lt_symbols      TYPE /cadaxo/sqlc_symbol_t,
          ls_user_symbol  TYPE /cadaxo/sqlcusym,
          lt_sqlcusym     TYPE TABLE OF /cadaxo/sqlcusym,
          lt_sqlcusym_upd TYPE TABLE OF /cadaxo/sqlcusym,
          ls_symbol_ow    TYPE /cadaxo/sqlc_symbol_ow,
          ls_layout       TYPE lvc_s_layo.
* end   of change COCKPIT-294
    DATA lt_variant TYPE TABLE OF /cadaxo/sqlc_il_variants.

    DATA l_rc(1).                            "COCKPIT-383

* read selected template
    READ TABLE gt_queue INDEX e_row-index ASSIGNING FIELD-SYMBOL(<ls_queue_alv>).
    IF sy-subrc = 0.

      DATA(lr_api) = /cadaxo/cl_sqlc_cockpit_api=>get_share_factory( <ls_queue_alv>-id ).

      IF lr_api IS BOUND.
        DATA(lt_items) = lr_api->get_items( <ls_queue_alv>-id ).
        lr_api->set_status( /cadaxo/cl_sqlc_cockpit_api=>status-read ).
      ENDIF.

      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_items>).

* begin of change COCKPIT-294

        IF <ls_items>-typ = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-sql.


          lr_api->get_item( EXPORTING iv_pos_line = <ls_items>
                            IMPORTING rt_item     = lt_sql ).


        ELSEIF <ls_items>-typ = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-symbols.

          lr_api->get_item( EXPORTING iv_pos_line = <ls_items>
                            IMPORTING rt_item     = lt_symbols ).

          IF NOT lt_symbols IS INITIAL. " check symbols and give pop-up if identical data exists

            SELECT * FROM /cadaxo/sqlcusym
            INTO TABLE lt_sqlcusym FOR ALL ENTRIES IN lt_symbols
            WHERE symbol_name = lt_symbols-symbol_name
            AND username    = sy-uname.

            CLEAR gt_symbol_ow.

            LOOP AT lt_symbols ASSIGNING FIELD-SYMBOL(<ls_symbols>).
              READ TABLE lt_sqlcusym
              WITH KEY symbol_name = <ls_symbols>-symbol_name
              INTO DATA(l_sqlcusym).

              IF     sy-subrc = 0
              AND ( l_sqlcusym-symbol_value <> <ls_symbols>-symbol_value
              OR    l_sqlcusym-symbol_desc  <> <ls_symbols>-symbol_desc
              OR l_sqlcusym-symbol_multivalue <> <ls_symbols>-symbol_multivalue ).

                ls_symbol_ow-symbol_name       = <ls_symbols>-symbol_name.
                ls_symbol_ow-symbol_value_user = l_sqlcusym-symbol_value.
                ls_symbol_ow-symbol_desc_user  = l_sqlcusym-symbol_desc.
                ls_symbol_ow-symbol_value_var  = <ls_symbols>-symbol_value.
                ls_symbol_ow-symbol_var        = <ls_symbols>-symbol_desc.
                ls_symbol_ow-var               = icon_wd_radio_button_empty.
                ls_symbol_ow-own               = icon_radiobutton.

                IF ( <ls_symbols>-symbol_multivalue IS NOT INITIAL ).
                  ls_symbol_ow-symbol_type_icon_var = '@3W@'.
                ELSE.
                  ls_symbol_ow-symbol_type_icon_var = '@7L@'.
                ENDIF.

                IF ( l_sqlcusym-symbol_multivalue IS NOT INITIAL ).
                  ls_symbol_ow-symbol_type_icon_user = '@3W@'.
                ELSE.
                  ls_symbol_ow-symbol_type_icon_user = '@7L@'.
                ENDIF.

                ls_symbol_ow-symbol_multivalue_var = <ls_symbols>-symbol_multivalue.
                ls_symbol_ow-symbol_datatype_var   = <ls_symbols>-symbol_datatype.
                ls_symbol_ow-symbol_multivalue_user  = l_sqlcusym-symbol_multivalue.
                ls_symbol_ow-symbol_datatype_user    = l_sqlcusym-symbol_datatype.

                APPEND ls_symbol_ow TO gt_symbol_ow.
              ENDIF.
            ENDLOOP.

            IF NOT gt_symbol_ow IS INITIAL.
              confirm_symbol_overwrite( ).
            ENDIF.

            LOOP AT lt_symbols ASSIGNING FIELD-SYMBOL(<ls_symbols_upd>).

              READ TABLE gt_symbol_ow
              ASSIGNING FIELD-SYMBOL(<ls_symbol_ow>)
              WITH KEY symbol_name = <ls_symbols_upd>-symbol_name.
              IF sy-subrc = 0 AND <ls_symbol_ow>-var <> icon_radiobutton.
                CONTINUE.
              ENDIF.

              MOVE-CORRESPONDING <ls_symbols_upd> TO l_sqlcusym.
              l_sqlcusym-username = sy-uname.
              APPEND l_sqlcusym TO lt_sqlcusym_upd.
              CLEAR l_sqlcusym.

            ENDLOOP.

            IF lt_sqlcusym_upd IS NOT INITIAL.
              MODIFY /cadaxo/sqlcusym FROM TABLE lt_sqlcusym_upd.
            ENDIF.

          ENDIF.
* end   of change COCKPIT-294

        ELSEIF <ls_items>-typ = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-variant.
          lr_api->get_item( EXPORTING iv_pos_line = <ls_items>
                            IMPORTING rt_item     = lt_variant ).
          IF lt_variant IS NOT INITIAL.
            DATA(ls_variant) = lt_variant[ 1 ].
            CALL FUNCTION '/CADAXO/SQLC_CREATE_VARIANT_UI'
              EXPORTING
                i_mode     = 'I'
                il_variant = ls_variant.
          ENDIF.

        ELSEIF <ls_items>-typ = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-savedlist.
          api_saved_list_import( ir_api   = lr_api   is_items = <ls_items> ).     "cockpit-401

        ENDIF.

      ENDLOOP.

* begin of change COCKPIT-294
      me->get_symbols( )  .
      gc_symbol_alv->get_frontend_layout( IMPORTING es_layout = ls_layout ).
      IF ls_layout-cwidth_opt <> abap_true.
        ls_layout-cwidth_opt = abap_true.
        gc_symbol_alv->set_frontend_layout( EXPORTING is_layout = ls_layout ).
      ENDIF.
      gc_symbol_alv->refresh_table_display( EXPORTING i_soft_refresh = abap_true ).

      IF lt_sql IS NOT INITIAL.
* end   of change COCKPIT-294
* begin of change COCKPIT-383
        DATA(lt_sql_area) =  me->get_sql_area_lt_code( ).
        IF <ls_queue_alv>-position_typsql EQ /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-sql
        AND lt_sql_area IS NOT INITIAL.
          CALL FUNCTION 'POPUP_TO_CONFIRM'
            EXPORTING
              titlebar              = text-t17
              text_question         = text-q63
              text_button_1         = text-x05
              icon_button_1         = 'ICON_OKAY'
              text_button_2         = text-x06
              icon_button_2         = 'ICON_CHANGE'
              default_button        = 'A'
              display_cancel_button = abap_true
            IMPORTING
              answer                = l_rc
            EXCEPTIONS
              text_not_found        = 1
              OTHERS                = 2.
          CASE l_rc.
            WHEN '1'.
              APPEND LINES OF lt_sql TO lt_sql_area.
              me->set_sql_area( lt_sql_area ).
            WHEN '2'.
              me->set_sql_area( lt_sql ).
            WHEN OTHERS.
          ENDCASE.
* end of change COCKPIT-383
        ELSE.
          me->set_sql_area( lt_sql ).
        ENDIF.
      ENDIF.      " +COCKPIT-294
    ENDIF.

    SET SCREEN 0. LEAVE SCREEN.

  ENDMETHOD.


  METHOD on_alv_result_double_click.
****************************************************************************************************
* Description             : on alv result double click                                             *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxx             Company    : xxxxxxxxx                        *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 04.08.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Double-Click at column now possible         | CDX001-0006    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 29.01.2011 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Send Infomessage if doubleclick at result   | FOE28012011    *
*            |                      | list is not activated                       |                *
*------------+----------------------+---------------------------------------------+----------------*
* 08.03.2011 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Extrakt fieldvalue from header fieldname    | CDX001-0022    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 08.11.2011 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add Alias to fieldname                      | CDX001-0026    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Bugfix drag/drop dec-fields with comma      | CDX130-006     *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | Leading Spaces in Char Fields               | COCKPIT-125    *
****************************************************************************************************

* CHECK NOT g_user_settings-result_doubleclick IS INITIAL.                         "FOE28012011

    DATA: l_typ(1),
          l_fieldvalue TYPE string,
          l_from_line  TYPE i,
          l_from_pos   TYPE i,
          l_to_line    TYPE i,
          l_to_pos     TYPE i,
          l_dummy      TYPE c.

    FIELD-SYMBOLS: <lt_result_tab>   TYPE STANDARD TABLE,
                   <l_result_line>   TYPE any,
                   <l_result_field>  TYPE any,
                   <lr_dref>         TYPE REF TO data,
                   <lr_cl_sql_parse> TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse,
                   <ls_sql_dfies>    TYPE /cadaxo/sqlcdfies.

    DATA: l_cl_gui_control TYPE REF TO cl_gui_control,
          l_grid_name      TYPE string,
          l_grid_name_i    TYPE i.

    DATA: l_compare_guid   TYPE string.

* Is the function activated                                           "FOE29012011
    IF g_user_settings-result_doubleclick IS INITIAL.                   "FOE29012011
      MESSAGE s045(/cadaxo/sqlc).                                      "FOE29012011
      EXIT.                                                            "FOE29012011
    ENDIF.                                                              "FOE29012011

* this function is only available with the new frontend editor
    IF me->g_abap_editor_type <> 'A'.
      MESSAGE i041(/cadaxo/sqlc).
      EXIT.
    ENDIF.

    CALL METHOD cl_gui_alv_grid=>get_focus( IMPORTING control = l_cl_gui_control ).
    l_grid_name = l_cl_gui_control->get_name( ).

    IF e_column-fieldname = '&&MARK&&'.
      EXIT.
    ENDIF.

    MOVE l_grid_name+15 TO l_grid_name_i.

    READ TABLE dref_result_tab_t INDEX l_grid_name_i ASSIGNING <lr_dref>.

    ASSIGN <lr_dref>->* TO <lt_result_tab>.
    IF sy-subrc = 0.
      IF e_row-index = 0.                                    "CDX001-0006
* get the selected sql string
        CALL METHOD gc_abap_editor->get_selection_pos
          IMPORTING
            from_line              = l_from_line
            from_pos               = l_from_pos
            to_line                = l_to_line
            to_pos                 = l_to_pos
          EXCEPTIONS
            error_cntl_call_method = 1
            OTHERS                 = 2.
        IF sy-subrc = 0.

          IF l_from_line <> l_to_line OR
             l_from_pos  <> l_to_pos.

            MESSAGE i005(/cadaxo/sqlc).

          ELSE.

            IF e_column-fieldname CA '-'.
              SPLIT e_column-fieldname AT '-' INTO l_dummy l_fieldvalue.
            ELSEIF e_column-fieldname CA '~'.
              SPLIT e_column-fieldname AT '~' INTO l_dummy l_fieldvalue.
            ELSE.
              l_fieldvalue = e_column-fieldname.
            ENDIF.

            READ TABLE me->gt_cl_sql_parse INDEX l_grid_name_i ASSIGNING <lr_cl_sql_parse>.
            IF sy-subrc = 0.
              CASE <lr_cl_sql_parse>->g_select_version.
                WHEN <lr_cl_sql_parse>->c_select_version_0 OR <lr_cl_sql_parse>->c_select_version_1.

                  READ TABLE <lr_cl_sql_parse>->gt_result_ddfields
                       WITH KEY map_fieldname = e_column-fieldname
                       ASSIGNING <ls_sql_dfies>.
                  IF sy-subrc = 0 AND <ls_sql_dfies>-/cadaxo/alias IS NOT INITIAL.
                    CONCATENATE <ls_sql_dfies>-/cadaxo/alias '~' <ls_sql_dfies>-fieldname
                               INTO l_fieldvalue.
                  ENDIF.

                  IF <ls_sql_dfies> IS ASSIGNED.
                    CONCATENATE sy-abcde '0123456789' INTO l_compare_guid.
                    IF l_fieldvalue CO l_compare_guid AND <ls_sql_dfies>-fieldname <> space.
                      MOVE <ls_sql_dfies>-fieldname TO l_fieldvalue.
                    ENDIF.
                  ENDIF.

                WHEN <lr_cl_sql_parse>->c_select_version_2.

                  READ TABLE <lr_cl_sql_parse>->gt_result_ddfields WITH KEY fieldname = l_dummy TRANSPORTING NO FIELDS.
                  IF sy-subrc = 0.
                    l_fieldvalue = l_dummy && '~' && l_fieldvalue.
                  ELSE.
                    IF l_fieldvalue IS INITIAL.
                      l_fieldvalue = l_dummy.
                    ENDIF.
                    READ TABLE <lr_cl_sql_parse>->gt_result_ddfields WITH KEY fieldname = l_fieldvalue ASSIGNING <ls_sql_dfies>.
                    IF sy-subrc = 0 AND <ls_sql_dfies>-/cadaxo/alias_field <> space AND <ls_sql_dfies>-/cadaxo/alias_field <> l_fieldvalue.
                      l_fieldvalue = <ls_sql_dfies>-/cadaxo/alias && '~' && l_fieldvalue.
                    ELSEIF sy-subrc = 0 AND <ls_sql_dfies>-/cadaxo/alias IS NOT INITIAL AND <ls_sql_dfies>-/cadaxo/alias_field IS INITIAL.
                      l_fieldvalue = <ls_sql_dfies>-/cadaxo/alias && '~' && l_fieldvalue.
                    ENDIF.
                  ENDIF.

              ENDCASE.
            ENDIF.

            me->insert_codeblock_at_position(
               iv_line = l_from_line
               iv_pos = l_from_pos
               iv_sqlstring = l_fieldvalue
               i_set_focus = abap_true
            ).

          ENDIF.
        ELSE.

          MESSAGE e100(/cadaxo/sqlc).

        ENDIF.
      ELSE.                                                   "CDX001-0006
        READ TABLE <lt_result_tab> INDEX e_row-index ASSIGNING <l_result_line>.
        IF sy-subrc = 0.
          ASSIGN COMPONENT e_column-fieldname OF STRUCTURE <l_result_line> TO <l_result_field>.
          DESCRIBE FIELD <l_result_field> TYPE l_typ.

          TRY.
              /cadaxo/cl_sqlc_cockpit_assist=>convert_value_int_to_editor(
                EXPORTING
                  iv_typ                 = l_typ
                  iv_fieldvalue_internal = <l_result_field>
                 RECEIVING
                   rv_fieldvalue_editor   = l_fieldvalue
              ).
            CATCH /cadaxo/cx_sqlc_cockpit_assist INTO DATA(lr_sqlc_exception).
              MESSAGE i006(/cadaxo/sqlc) WITH l_typ. "Drag/drop/doubleclick for this fieldtype is not supported
              RETURN.
          ENDTRY.

          gc_abap_editor->get_selection_pos( IMPORTING  from_line = l_from_line
                                                        from_pos  = l_from_pos
                                                        to_line   = l_to_line
                                                        to_pos    = l_to_pos
                                             EXCEPTIONS OTHERS    = 2 ).
          IF sy-subrc = 0.

            IF l_from_line <> l_to_line OR
               l_from_pos  <> l_to_pos.

              MESSAGE i005(/cadaxo/sqlc).

            ELSE.

              me->insert_codeblock_at_position(
                 iv_line = l_from_line
                 iv_pos = l_from_pos
                 iv_sqlstring = l_fieldvalue
                 i_set_focus = abap_true
              ).


            ENDIF.
          ELSE.
            MESSAGE e100(/cadaxo/sqlc).

          ENDIF.
        ENDIF.
      ENDIF.                                                  "CDX001-0006
    ENDIF.
  ENDMETHOD.


  METHOD on_alv_templ_double_click_2000.

* data definitions & field symbols
    DATA: l_sqlctemp_class   TYPE /cadaxo/sqlctempl_class.
    DATA: lcl_template_class TYPE REF TO /cadaxo/cl_sqlc_template.

    FIELD-SYMBOLS: <l_sql_template_alv> TYPE /cadaxo/sqlctemp_alv,
                   <l_cl_sql_parse>     LIKE LINE OF gt_cl_sql_parse.

* read selected template
    READ TABLE gt_templates INDEX e_row-index ASSIGNING <l_sql_template_alv>.
    IF sy-subrc = 0.

* get template class from database
      SELECT SINGLE template_class FROM /cadaxo/sqlctemp INTO l_sqlctemp_class WHERE template_name = <l_sql_template_alv>-template_name.
      IF sy-subrc = 0.

        READ TABLE gt_cl_sql_parse INDEX 1 ASSIGNING <l_cl_sql_parse>.
        IF sy-subrc = 0.

          <l_cl_sql_parse>->parse_sql_ii( ).

          <l_cl_sql_parse>->parse_sql_where_columns( ).

          CREATE OBJECT lcl_template_class
                 TYPE (l_sqlctemp_class)
                 EXPORTING i_cl_sql_parse = <l_cl_sql_parse>
                           i_templ_name   = <l_sql_template_alv>-template_name.

          lcl_template_class->execute_template_generation( ).

          "COCKPIT-274 BEGIN
          IF lines( <l_cl_sql_parse>->g_main_ref->gt_cl_sql_parse_beftempgen ) > 1.
            me->gt_cl_sql_parse = <l_cl_sql_parse>->g_main_ref->gt_cl_sql_parse_beftempgen. "me->gt_cl_sql_parse_beftempgen.
          ENDIF.
          "COCKPIT-274 END

          cl_gui_cfw=>set_new_ok_code( new_code = 'CANCEL' ).

        ELSE.
          MESSAGE e100(/cadaxo/sqlc).
        ENDIF.
      ELSE.
        MESSAGE e100(/cadaxo/sqlc).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD on_clipboard_drop.
    DATA lr_drag_object     TYPE REF TO lcl_drag_object.
    DATA l_text_line(256)   TYPE c.
    DATA l_text_string       TYPE string.

    CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
      lr_drag_object ?= dragdrop_object->object.

      gc_clipboard_textedit->get_textstream( IMPORTING text = l_text_string ).

      cl_gui_cfw=>flush( ).

      l_text_line = lr_drag_object->fieldvalue.

      CONCATENATE l_text_string(index) l_text_line l_text_string+index INTO l_text_string.

      gc_clipboard_textedit->set_textstream( EXPORTING text = l_text_string ).

    ENDCATCH.

  ENDMETHOD.


  METHOD on_editor_context_menu.
****************************************************************************************************
* Description             : on editor - context menu                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations : this method is called by the "right mouse" function of the abap editor *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.01.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add SY-FIELDs to Context Menu               | CDX25012010    *
*------------+----------------------+---------------------------------------------+----------------*
* 18.09.2017 | Harald Wiesinger     | Add Pretty Printer to Context Menu          | COCKPIT-260    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lr_submenu         TYPE REF TO cl_ctmenu,
          lr_submenu_symbols TYPE REF TO cl_ctmenu.

    menu->add_function( fcode = c_cmd_insert_table      text  = text-b04 ).
    menu->add_function( fcode = c_cmd_insert_cds_entity text = text-b38 ).
    menu->add_function( fcode = c_cmd_insert_sy_field   text  = text-b05 ). "CDX25012010
    menu->add_function( fcode = c_cmd_pp                text = text-b34 ).  "COCKPIT-260

    lr_submenu_symbols = NEW #( ).

    menu->add_submenu( menu = lr_submenu_symbols text = text-b11 ).

    lr_submenu_symbols->add_function( fcode = 'INSERT_DYN_SYMB' text = text-b12 ).
    lr_submenu_symbols->add_function( fcode = 'INSERT_USR_SYMB' text = text-b13 disabled = 'X' ).

    lr_submenu = NEW #( ).

    menu->add_submenu( menu = lr_submenu text        = text-b10 ).

    lr_submenu->add_function( fcode = 'COPY_TO_X_BUFFER' text = text-b07 ).
    lr_submenu->add_function( fcode = 'COPY_TO_Y_BUFFER' text = text-b08 ).
    lr_submenu->add_function( fcode = 'COPY_TO_Z_BUFFER' text = text-b09 ).

  ENDMETHOD.


  METHOD on_editor_context_menu_sel.
****************************************************************************************************
* Description             : Build the result grit title                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.01.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Insert SY-Fields                            | CDX25012010    *
*------------+----------------------+---------------------------------------------+----------------*
* 18.09.2017 | Harald Wiesinger     | Add Pretty Printer to Context Menu          | COCKPIT-260    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_tabname        TYPE tabname,
          l_string         TYPE string,
          l_buffer_key(22) TYPE c,
          lt_code          TYPE /cadaxo/sqlccodeline_t,
          lt_buffer        TYPE STANDARD TABLE OF string.

    FIELD-SYMBOLS: <ls_code>   LIKE LINE OF lt_code,
                   <ls_buffer> LIKE LINE OF lt_buffer.

    CLEAR: l_string,
           l_tabname.

    CASE fcode.
      WHEN c_cmd_insert_cds_entity. " CDS Views
        /cadaxo/cl_sqlc_cockpit_assist=>value_help_cds_views(
          IMPORTING
            e_cds_view = l_string ).
        IF sy-subrc = 0 AND NOT l_string IS INITIAL.
          me->insert_table_to_editor( EXPORTING i_string = l_string ).
        ENDIF.
      WHEN 'INSERT_DYN_SYMB'. "dynamic symbols
        /cadaxo/cl_sqlc_cockpit_assist=>value_help_dyn_symbols(
          IMPORTING
            e_symbol_name = l_string ).
        IF sy-subrc = 0 AND NOT l_string IS INITIAL.
          CONCATENATE '&' l_string '&' INTO l_string.
          me->insert_table_to_editor( EXPORTING i_string = l_string ).
        ENDIF.
      WHEN c_cmd_insert_table.    "insert table
        /cadaxo/cl_sqlc_cockpit_assist=>value_help_dd_table(
                          IMPORTING e_tabname = l_tabname
                          EXCEPTIONS no_table_selected = 1 ).
        IF sy-subrc = 0.
          MOVE l_tabname TO l_string.
          me->insert_table_to_editor( EXPORTING i_string = l_string ).
        ENDIF.
      WHEN c_cmd_insert_sy_field. "insert system fields                    "CDX25012010
        /cadaxo/cl_sqlc_cockpit_assist=>value_help_sy_fields(          "CDX25012010
                          IMPORTING e_fieldname = l_string             "CDX25012010
                          EXCEPTIONS no_table_selected = 1 ).          "CDX25012010
        IF sy-subrc = 0.                                              "CDX25012010
          me->insert_table_to_editor( EXPORTING i_string = l_string ). "CDX25012010
        ENDIF.                                                         "CDX25012010

      WHEN 'COPY_TO_X_BUFFER' OR "copy code to buffer
           'COPY_TO_Y_BUFFER' OR
           'COPY_TO_Z_BUFFER'.

        CLEAR: l_buffer_key,
               lt_buffer.

* get the selected code
        gc_abap_editor->get_selected_text_as_table(
          IMPORTING
            table    = lt_code
          EXCEPTIONS
            error_dp = 1
            OTHERS   = 2 ).

* move code to buffer table
        LOOP AT lt_code ASSIGNING <ls_code>.
          APPEND INITIAL LINE TO lt_buffer ASSIGNING <ls_buffer>.
          MOVE <ls_code> TO <ls_buffer>.
        ENDLOOP.

        CASE fcode.
          WHEN 'COPY_TO_X_BUFFER'.
            MOVE 'X' TO l_buffer_key(1).
          WHEN 'COPY_TO_Y_BUFFER'.
            MOVE 'Y' TO l_buffer_key(1).
          WHEN 'COPY_TO_Z_BUFFER'.
            MOVE 'Z' TO l_buffer_key(1).
        ENDCASE.

* add the user name to the buffer key
        MOVE sy-uname TO l_buffer_key+2(12).

* export the code to the buffer
        EXPORT buffer FROM lt_buffer TO DATABASE indx(bf) ID l_buffer_key.
      WHEN c_cmd_pp.
        me->usr_action_pretty_printer( ).
    ENDCASE.
  ENDMETHOD.


  METHOD on_editor_dblclick.
* show dictionary object

    DATA: l_from_line TYPE i,
          l_from_pos  TYPE i,
          l_to_pos    TYPE i,
          lt_code     TYPE /cadaxo/sqlccodeline_t,
          l_stringc   TYPE char255,
          l_len       TYPE i,
          l_ddobjname TYPE rsedd0-ddobjname.

    DATA l_row        TYPE i.
    DATA l_col        TYPE i.
    DATA l_first_line TYPE i.
    DATA l_ddtypekind TYPE ddtypekind.
    DATA l_ddlname TYPE ddlname.

    FIELD-SYMBOLS: <l_code> LIKE LINE OF lt_code.

    gc_abap_editor->get_selection_pos(
      IMPORTING
        from_line = l_from_line
        from_pos  = l_from_pos
        to_pos    = l_to_pos ).

    gc_abap_editor->get_text( IMPORTING table = lt_code ).

    l_from_pos = l_from_pos - 1.
    l_to_pos = l_to_pos - 1.

    READ TABLE lt_code INDEX l_from_line ASSIGNING <l_code>.
    IF sy-subrc = 0.
      MOVE <l_code> TO l_stringc.
      IF l_stringc+l_from_pos <> space.
        WHILE l_from_pos <> 0 AND l_stringc+l_from_pos(1) <> space.
          l_from_pos = l_from_pos - 1.
        ENDWHILE.
        l_from_pos = l_from_pos + 1.
        WHILE l_to_pos <> 0 AND l_stringc+l_to_pos(1) <> space AND l_stringc+l_to_pos(1) <> '(' AND l_stringc+l_to_pos(1) <> '.'.
          l_to_pos = l_to_pos + 1.
        ENDWHILE.
      ENDIF.

      l_len = l_to_pos - l_from_pos.
      IF l_len GT 0.

        l_ddobjname = to_upper( l_stringc+l_from_pos(l_len) ).

        IF l_ddobjname CA '\'.
          SPLIT l_ddobjname AT '\' INTO TABLE DATA(lt_views).
          l_ddobjname = lt_views[ 1 ].
        ENDIF.

        CLEAR l_ddtypekind.

        CALL FUNCTION 'DDIF_TYPEINFO_GET'
          EXPORTING
            typename = l_ddobjname
          IMPORTING
            typekind = l_ddtypekind.

        IF l_ddtypekind <> space.
          CASE l_ddtypekind.
            WHEN 'STOB'.
              IF g_user_settings-forwnavddleclipse = abap_true.
                /cadaxo/cl_sqlc_cockpit_assist=>foreward_navigation_adt_stob( i_ddobjname = l_ddobjname ).
              ELSE.

                gc_abap_editor->get_first_visible_line( IMPORTING line = l_first_line ).

                l_row = l_from_line - l_first_line.
                l_col = l_from_pos.
                l_ddlname = l_ddobjname.

                CALL FUNCTION '/CADAXO/SQLC_CDS_VIEW_DISPLAY'
                  EXPORTING
                    i_ddlname = l_ddlname
                    i_col     = l_col
                    i_row     = l_row.

              ENDIF.
            WHEN space.
            WHEN OTHERS.
              IF g_user_settings-forwnavdicteclipse = abap_true.
                /cadaxo/cl_sqlc_cockpit_assist=>foreward_navigation_adt_others( i_ddobjname = l_ddobjname ).
              ELSE.
                CALL FUNCTION 'RS_DD_SHOW'
                  EXPORTING
                    objname              = l_ddobjname
                    objtype              = 'T'
                  EXCEPTIONS
                    object_not_found     = 1
                    object_not_specified = 2
                    permission_failure   = 3
                    type_not_valid       = 4
                    OTHERS               = 5.
              ENDIF.
          ENDCASE.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD on_editor_drop.
****************************************************************************************************
* Description             : on editor drop                                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lr_drag_object  TYPE REF TO lcl_drag_object.

    lr_drag_object ?= dragdrop_object->object.

    me->insert_codeblock_at_position(
       iv_line = line
       iv_pos = pos
       iv_sqlstring = lr_drag_object->fieldvalue
       i_set_focus = abap_true
    ).

  ENDMETHOD.


  METHOD on_editor_quick_info.
****************************************************************************************************
*Description             : on editor - quick info                                                  *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
*Developer               : Domi Bigl                Company    : CADAXO GesmbH                     *
*Date                    : 25.06.2016               Release    : WAS 7.40                          *
*--------------------------------------------------------------------------------------------------*
*Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                     *
*Date                    : 01.03.2010                                                              *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 16.05.2017 | Harald Wiesinger     | DATA LOSS Dump with periodic Jobs           | COCKPIT-206    *
*------------+----------------------+---------------------------------------------+----------------*
* 28.07.2020 | Pat                  | Table quickinfo fix                         | 433            *
****************************************************************************************************

    DATA l_xpos       TYPE i.
    DATA l_from       TYPE i.
    DATA l_to         TYPE i.
    DATA l_len        TYPE i.
    DATA lr_parser    TYPE REF TO cl_abap_parser.
    DATA lt_source    TYPE sourcetable.
    DATA lt_dfies     TYPE ddfields.
    DATA ld_color(1)  TYPE c.
    DATA lr_handler TYPE REF TO cl_dd_ddl_handler.
    DATA g_viewname TYPE viewname.
    DATA g_entityname TYPE ddstrucobjname.
    DATA lr_sobject TYPE REF TO if_dd_sobject.
    DATA lt_sobjnames TYPE if_dd_sobject_types=>ty_t_sobjnames.
    DATA lt_dd03ndvtab TYPE dd03ndvtab.
    DATA lt_ddnames TYPE if_dd_ddl_types=>ty_t_ddobj.
    DATA ls_ddnames TYPE if_dd_ddl_types=>ty_s_ddobj.
    DATA g_ddlname TYPE ddlname.
    DATA lt_entity TYPE if_dd_ddl_types=>ty_t_entity_of_view.
    DATA ls_element_info TYPE /cadaxo/sqlc_elementinfo.
    DATA lv_entity TYPE string.
    DATA lv_typekind TYPE c LENGTH 1.
*begin of change+cockpit415
    DATA lv_footer TYPE char255.
    FIELD-SYMBOLS <ls_cont_element> TYPE /cadaxo/sqlcclguicontainer.
*end of change+cockpit415

    lr_parser = NEW #( m_max_components = 30 ).
    sender->get_text( IMPORTING table = lt_source ).

    lr_parser->calculate_completion_results(
      EXPORTING
        ypos                = ypos
        xpos                = xpos
        beg_ypos            = ypos
        beg_xpos            = 1
        sourceline          = contextstring
        includename         = ''
        dialog_allowed      = abap_true
      CHANGING
        incl_source         = lt_source
      EXCEPTIONS
        OTHERS              = 1 ).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    l_to = strlen( contextstring ).


    IF xpos < l_to AND contextstring+xpos(1) <> space.
      l_xpos = xpos.
      WHILE l_xpos > 1.
        IF contextstring+l_xpos(1) = ` `.
          l_xpos = l_xpos + 1. "+cockpit433
          EXIT.
        ENDIF.
        l_xpos = l_xpos - 1.
      ENDWHILE.

*     l_from = l_xpos + 1.  "-cockpit433
      l_from = l_xpos - 1.  "+cockpit433
      l_xpos = xpos.

      WHILE l_xpos < l_to.
        IF contextstring+l_xpos(1) = ` ` OR contextstring+l_xpos(1) = '.'.
          EXIT.
        ENDIF.
        l_xpos = l_xpos + 1.
      ENDWHILE.

      l_len = l_xpos - l_from.
      IF l_len < 1.
        RETURN.
      ENDIF.

      DATA(original) = to_upper( contextstring ).

      contextstring = to_upper( contextstring+l_from(l_len) ).

      IF contextstring CA '()+'.
        RETURN.
      ENDIF.

      TRY.
          FIND REGEX contextstring && '\s*AS\s*(\S*)\s*' IN SECTION OFFSET l_from OF original SUBMATCHES DATA(l_alias).
        CATCH cx_sy_invalid_regex.
      ENDTRY.

      REPLACE ALL OCCURRENCES OF REGEX '[^a-zA-Z0-9_\\]' IN contextstring WITH space.

      IF contextstring CA '\'.
        /cadaxo/cl_sqlc_cockpit_assist=>get_cds_view_of_association(
          EXPORTING
            iv_association = contextstring
          IMPORTING
            ev_entity      = lv_entity
            ev_typekind    = lv_typekind ).
      ENDIF.

      IF lv_typekind IS INITIAL.
        IF strlen( contextstring ) <= 30.
          SELECT SINGLE @abap_true FROM dd02l WHERE tabname = @contextstring INTO @DATA(l_exists).
          IF sy-subrc = 0.
            lv_typekind = 'T'.
            lv_entity = contextstring.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_entity IS INITIAL.
        lv_entity = contextstring.
      ENDIF.

      IF lv_typekind IS INITIAL.
        IF strlen( contextstring ) <= 30.       "COCKPIT-206
          SELECT SINGLE * FROM ddldependency INTO @DATA(ls_ddldependency) WHERE objectname = @contextstring.
          IF sy-subrc = 0.
            CASE ls_ddldependency-objecttype.
              WHEN 'STOB'.
                lv_typekind = 'B'.
              WHEN 'VIEW'.
                lv_typekind = 'T'.
            ENDCASE.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_typekind = 'T'.

        CALL FUNCTION 'DDIF_FIELDINFO_GET'
          EXPORTING
            tabname   = CONV tabname( lv_entity )
          TABLES
            dfies_tab = lt_dfies
          EXCEPTIONS
            OTHERS    = 1.

        gt_elementinfo = CORRESPONDING #( lt_dfies  ).

        ld_color = 3.
        LOOP AT gt_elementinfo ASSIGNING FIELD-SYMBOL(<ls_elemet_info>).

          CONCATENATE 'C' ld_color '00' INTO <ls_elemet_info>-line_color.

          IF <ls_elemet_info>-leng IS INITIAL.
            <ls_elemet_info>-data_type = to_lower( <ls_elemet_info>-datatype  ).
          ELSEIF <ls_elemet_info>-decimals IS INITIAL.
            <ls_elemet_info>-data_type = to_lower( <ls_elemet_info>-datatype  ) && '(' && shift_left( val = <ls_elemet_info>-leng sub = '0' ) && ')'.
          ELSE.
            <ls_elemet_info>-data_type = to_lower( <ls_elemet_info>-datatype ) && '(' && shift_left( val = <ls_elemet_info>-leng sub = '0' )
                                                                               && ',' && shift_left( val = <ls_elemet_info>-decimals sub = '0' ) && ')'.
          ENDIF.

          IF <ls_elemet_info>-keyflag IS NOT INITIAL.
            <ls_elemet_info>-icon = icon_foreign_key.
          ENDIF.

          <ls_elemet_info>-alias = l_alias.

        ENDLOOP.

        gc_elementinfo_alv->set_gridtitle( i_gridtitle = |Element Info: { text-tab } { contextstring }| ).

*begin of change+cockpit415
        IF me->g_user_settings-show_footer = abap_true AND gcont_grid_elementinfo_t[] IS NOT INITIAL.

          ASSIGN gcont_grid_elementinfo_t[ 1 ] TO <ls_cont_element>.
          <ls_cont_element>-gui_splitter->get_container( EXPORTING row       = 2
                                                                   column    = 1
                                                         RECEIVING container = DATA(lr_cont_footer) ).

          SELECT SINGLE contflag FROM dd02l INTO @DATA(lv_contflag) WHERE tabname = @lv_entity.
          IF lv_contflag IS NOT INITIAL.
            DATA(lt_domain_text) = cl_domain=>get_fixed_values( 'CONTFLAG' ).
            DATA(delivery_class_description) = lt_domain_text[ value = lv_contflag ]-description.
            lv_footer = |{ lv_contflag } / { delivery_class_description }|.
          ENDIF.

          lr_cont_footer->set_name( 'SPLIT_F' ).
          create_dyn_document(
             EXPORTING
               i_parent      = lr_cont_footer
               i_sql         = space
               i_header_text = lv_footer
             CHANGING
               ic_document = <ls_cont_element>-cl_document_footer ).
        ENDIF.
*end of change+cockpit415

        gc_elementinfo_alv->refresh_table_display( ).

        DATA(lv_ucomm) =  CONV syucomm( '&OPT' ).
        gc_elementinfo_alv->set_function_code( CHANGING c_ucomm = lv_ucomm ).

        sender->show_quick_info( EXPORTING  info_string = CONV #( text-eif )
                                 EXCEPTIONS OTHERS      = 1 ).

        IF g_show_clipboard = ' '.
          set_clipboard_alv( ).
        ENDIF.

      ELSEIF lv_typekind = 'B'.

        lr_handler ?= cl_dd_ddl_handler_factory=>create( ).

        CLEAR lt_ddnames.
        ls_ddnames-name = CONV #( lv_entity ).
        APPEND ls_ddnames TO lt_ddnames.

        lr_handler->if_dd_ddl_handler~get_viewname_from_entityname( EXPORTING ddnames = lt_ddnames
                                                                    IMPORTING view_of_entity = lt_entity ).
        IF lines( lt_entity ) > 0.

          g_ddlname = lt_entity[ 1 ]-ddlname.

          lr_handler->if_dd_ddl_handler~get_ddl_content_object_names(
            EXPORTING
              ddlname        = g_ddlname
            IMPORTING
              viewname       = g_viewname
              entityname     = g_entityname ).

          lr_sobject = cl_dd_sobject_factory=>create( ).
          APPEND g_entityname TO lt_sobjnames.

          lr_sobject->read(
            EXPORTING
              get_state      = 'M'
              sobjnames      = lt_sobjnames
            IMPORTING
              dd03ndv_tab    = lt_dd03ndvtab ).

          CLEAR gt_elementinfo.

          LOOP AT lt_dd03ndvtab ASSIGNING FIELD-SYMBOL(<dd03>).

            CLEAR ls_element_info. "750

            ls_element_info-fieldname = <dd03>-fieldname.
            ls_element_info-datatype  = <dd03>-datatype .
            ls_element_info-rollname  = <dd03>-rollname .

            IF <dd03>-leng IS INITIAL.
              ls_element_info-data_type = to_lower( <dd03>-datatype  ).
            ELSEIF <dd03>-decimals IS INITIAL.
              ls_element_info-data_type = to_lower( <dd03>-datatype  ) && '(' && shift_left( val = <dd03>-leng sub = '0' ) && ')'.
            ELSE.
              ls_element_info-data_type = to_lower( <dd03>-datatype ) && '(' && shift_left( val = <dd03>-leng sub = '0' )
                                                                                 && ',' && shift_left( val = <dd03>-decimals sub = '0' ) && ')'.
            ENDIF.

            IF <dd03>-keyflag IS NOT INITIAL.
              ls_element_info-icon = icon_foreign_key.
            ENDIF.

            ls_element_info-outputlen = <dd03>-leng.
            ls_element_info-decimals = <dd03>-decimals.
            ls_element_info-fieldtext = <dd03>-ddtext.
            APPEND ls_element_info TO gt_elementinfo.
          ENDLOOP.

          ld_color = 3.
          LOOP AT gt_elementinfo ASSIGNING <ls_elemet_info>.
            CONCATENATE 'C' ld_color '00' INTO <ls_elemet_info>-line_color.
          ENDLOOP.

          gc_elementinfo_alv->set_gridtitle( i_gridtitle = |Element Info: { text-ddl } { contextstring }| ).

          gc_elementinfo_alv->refresh_table_display( ).
          lv_ucomm =  CONV syucomm( '&OPT' ).
          gc_elementinfo_alv->set_function_code( CHANGING c_ucomm = lv_ucomm ).

          sender->show_quick_info( EXPORTING  info_string = CONV #( text-eif )
                                   EXCEPTIONS OTHERS      = 1 ).

        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD on_editor_text_drop.
****************************************************************************************************
* Description             : on editor text drop                                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

* this function is only available with the new frontend editor
    MESSAGE i041(/cadaxo/sqlc).

  ENDMETHOD.


  METHOD on_elementinfo_double_click.
****************************************************************************************************
* Description             : on element info double click                                                 *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : Cadaxo GmbH                      *
* Date                    : 10.07.2016               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

* Consider the double click in user settings
    CHECK NOT g_user_settings-result_doubleclick IS INITIAL.

    DATA: l_fields    TYPE string,
          l_from_line TYPE i,
          l_from_pos  TYPE i,
          l_to_line   TYPE i,
          l_to_pos    TYPE i.

* this function is only available with the new frontend editor
    IF me->g_abap_editor_type <> 'A'.
      MESSAGE i041(/cadaxo/sqlc).
      EXIT.
    ENDIF.

    l_fields = get_selected_elem_inf_flds( EXPORTING i_index = e_row-index ).

    IF l_fields IS NOT INITIAL.

      gc_abap_editor->get_selection_pos( IMPORTING  from_line              = l_from_line
                                                    from_pos               = l_from_pos
                                                    to_line                = l_to_line
                                                    to_pos                 = l_to_pos
                                         EXCEPTIONS OTHERS                 = 1 ).
      IF sy-subrc = 0.
        IF l_from_line <> l_to_line OR
          l_from_pos  <> l_to_pos.
          MESSAGE i005(/cadaxo/sqlc).
        ELSE.

          me->insert_codeblock_at_position(
             iv_line = l_from_line
             iv_pos = l_from_pos
             iv_sqlstring = l_fields
             i_set_focus = abap_true ).

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD on_elementinfo_drag.

    DATA lr_drag_object TYPE REF TO lcl_drag_object.
    DATA l_fields TYPE string.

    l_fields = get_selected_elem_inf_flds( EXPORTING i_index = e_row-index ).

    me->gc_elementinfo_alv->get_selected_rows(
      IMPORTING
        et_index_rows = DATA(selected_rows) ).

    IF l_fields IS NOT INITIAL.

      CREATE OBJECT lr_drag_object.

      lr_drag_object->fieldvalue = l_fields.
      e_dragdropobj->object = lr_drag_object.

    ENDIF.

  ENDMETHOD.


  METHOD on_elementinfo_hotspot_de.

    CALL FUNCTION 'RS_DD_SHOW'
      EXPORTING
        objname              = gt_elementinfo[ e_row_id ]-rollname
        objtype              = 'E'
      EXCEPTIONS
        object_not_found     = 1
        object_not_specified = 2
        permission_failure   = 3
        type_not_valid       = 4
        OTHERS               = 5.

  ENDMETHOD.


  METHOD on_handle_job_toolbar.
****************************************************************************************************
* Description             : Add buttons to job monitor alv                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2011               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 16.04.2011                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add STOP Function to cancel background jobs | CDX130-001     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: ls_button TYPE stb_button.

    CLEAR ls_button.
    ls_button-function = 'REFRESH'.
    ls_button-icon = icon_refresh.
    ls_button-quickinfo = text-b16.
    ls_button-butn_type = 0.
    ls_button-disabled = space.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 1.

    CLEAR ls_button.
    ls_button-function = 'SELDATE'.
    ls_button-icon = icon_date.
    ls_button-quickinfo = text-b18.
    ls_button-butn_type = 0.
    ls_button-disabled = space.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 2.

    CLEAR ls_button.
    ls_button-butn_type = 3.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 3.

* release button
    CLEAR ls_button.
    MOVE: 'RELEASE'     TO ls_button-function,
          icon_release  TO ls_button-icon,
          text-b27      TO ls_button-quickinfo,
          0             TO ls_button-butn_type,
          space         TO ls_button-disabled.
    APPEND ls_button TO e_object->mt_toolbar.

* delete button
    CLEAR ls_button.
    MOVE: 'DELETE'      TO ls_button-function,
          icon_delete   TO ls_button-icon,
          0             TO ls_button-butn_type,
          text-b17      TO ls_button-quickinfo,
          space         TO ls_button-disabled.
    APPEND ls_button TO e_object->mt_toolbar.

* abort button
    CLEAR ls_button.
    MOVE: 'ABORT'         TO ls_button-function,
          icon_breakpoint TO ls_button-icon,
          0               TO ls_button-butn_type,
          text-b20        TO ls_button-quickinfo,
          space           TO ls_button-disabled.
    APPEND ls_button TO e_object->mt_toolbar.

  ENDMETHOD.


  METHOD on_handle_job_user_command.
****************************************************************************************************
* Description             : on handle job user command                                             *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2011               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2011                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add STOP Button to cancel Background Job    | CDX130-001     *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lt_lvc_t_roid TYPE lvc_t_roid,
          l_ress_guid   TYPE /cadaxo/sqlcress-ress_guid,
          l_rc(1),
          l_cnt         TYPE i,
          l_total       TYPE i,
          l_perc        TYPE p DECIMALS 2,
          l_error,
          l_status      TYPE tbtco-status.
    "   ls_tbtco        TYPE tbtco.

    DATA lt_new_step_list TYPE TABLE OF tbtcstep.

    FIELD-SYMBOLS: <l_cont_grid_result> TYPE /cadaxo/sqlcclguicontainer,
                   <l_lvc_s_roid>       TYPE lvc_s_roid,
                   <l_jobs>             LIKE LINE OF gt_jobs.

    /cadaxo/cl_sqlc_functrace=>add_trace( |ON_HANDLE_JOB_USER_COMMAND:| && e_ucomm ).

    CASE e_ucomm.
      WHEN 'SELDATE'.
        CALL FUNCTION '/CADAXO/SQLCGETDATEFROMTO'
          CHANGING
            c_timestamp_from = g_sel_job_timestamp_from
            c_timestamp_to   = g_sel_job_timestamp_to
          EXCEPTIONS
            cancel_by_user   = 1
            OTHERS           = 2.
        CASE sy-subrc.
          WHEN 0.
            me->show_jobmonitor( ).
          WHEN 1.
            MESSAGE s042(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
          WHEN OTHERS.
        ENDCASE.

      WHEN 'RELEASE'.

        READ TABLE gcont_grid_result_t INDEX 1 ASSIGNING <l_cont_grid_result>.
        IF sy-subrc = 0.

          <l_cont_grid_result>-gui_alv_grid->get_selected_rows(
            IMPORTING
               et_row_no      =   lt_lvc_t_roid ).

          LOOP AT lt_lvc_t_roid ASSIGNING <l_lvc_s_roid>.
            READ TABLE gt_jobs INDEX <l_lvc_s_roid>-row_id ASSIGNING <l_jobs>.
            IF sy-subrc = 0.
              SELECT SINGLE status FROM tbtco INTO l_status WHERE jobname = <l_jobs>-jobname
                                                              AND jobcount = <l_jobs>-jobcount.
              IF sy-subrc = 0 AND l_status = 'P'.
                CALL FUNCTION 'BP_JOB_MODIFY'
                  EXPORTING
                    jobname       = <l_jobs>-jobname
                    jobcount      = <l_jobs>-jobcount
                    dialog        = 'Y'
                    opcode        = 17 "Release job
                  TABLES
                    new_steplist  = lt_new_step_list
                  EXCEPTIONS
                    nothing_to_do = 1
                    OTHERS        = 99.
              ENDIF.
            ENDIF.
          ENDLOOP.

          me->select_jobdata( ).

          <l_cont_grid_result>-gui_alv_grid->refresh_table_display(
            EXPORTING
              i_soft_refresh = 'X' ).

        ENDIF.

      WHEN 'DELETE'.

        CLEAR: l_rc,
               l_cnt,
               l_error,
               l_total.

        READ TABLE gcont_grid_result_t INDEX 1 ASSIGNING <l_cont_grid_result>.
        IF sy-subrc = 0.

          <l_cont_grid_result>-gui_alv_grid->get_selected_rows(
            IMPORTING
               et_row_no      =   lt_lvc_t_roid ).

          IF NOT lt_lvc_t_roid[] IS INITIAL.

            CALL FUNCTION 'POPUP_TO_CONFIRM'            "Cockpit-203 Popup harmonized
              EXPORTING
                titlebar              = text-t11
                text_question         = text-q21
                text_button_1         = text-x03
                icon_button_1         = 'ICON_OKAY'
                text_button_2         = text-x04
                icon_button_2         = 'ICON_CANCEL'
                default_button        = '2'
                display_cancel_button = abap_false
              IMPORTING
                answer                = l_rc
              EXCEPTIONS
                text_not_found        = 1
                OTHERS                = 2.

            IF l_rc = '1'.

              DESCRIBE TABLE lt_lvc_t_roid LINES l_total.

              LOOP AT lt_lvc_t_roid ASSIGNING <l_lvc_s_roid>.
                READ TABLE gt_jobs INDEX <l_lvc_s_roid>-row_id ASSIGNING <l_jobs>.
                IF sy-subrc = 0.
                  SELECT SINGLE ress_guid FROM /cadaxo/sqlcsres INTO l_ress_guid WHERE list_guid = <l_jobs>-list_guid. "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED
                  IF sy-subrc = 0.
                    DELETE FROM /cadaxo/sqlcress WHERE ress_guid = l_ress_guid.
                  ENDIF.
                  DELETE FROM /cadaxo/sqlcsres WHERE list_guid = <l_jobs>-list_guid.
                  IF sy-subrc = 0.

                    SELECT SINGLE @abap_true FROM tbtco INTO @DATA(l_true) WHERE jobname = @<l_jobs>-jobname
                                                                            AND jobcount = @<l_jobs>-jobcount. "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED
                    IF sy-subrc = 0.

                      CALL FUNCTION 'BP_JOB_DELETE'
                        EXPORTING
                          jobcount                 = <l_jobs>-jobcount
                          jobname                  = <l_jobs>-jobname
                          forcedmode               = 'X'
                          commitmode               = ' '
                        EXCEPTIONS
                          cant_delete_event_entry  = 1
                          cant_delete_job          = 2
                          cant_delete_joblog       = 3
                          cant_delete_steps        = 4
                          cant_delete_time_entry   = 5
                          cant_derelease_successor = 6
                          cant_enq_predecessor     = 7
                          cant_enq_successor       = 8
                          cant_enq_tbtco_entry     = 9
                          cant_update_predecessor  = 10
                          cant_update_successor    = 11
                          commit_failed            = 12
                          jobcount_missing         = 13
                          jobname_missing          = 14
                          job_does_not_exist       = 15
                          job_is_already_running   = 16
                          no_delete_authority      = 17
                          OTHERS                   = 18.
                      IF sy-subrc <> 0.
                        l_error = 'X'.
                      ELSE.
                        ADD 1 TO l_cnt.
                      ENDIF.
                    ELSE.
                      ADD 1 TO l_cnt.
                    ENDIF.
                  ELSE.
                    l_error = 'X'.
                  ENDIF.
                ENDIF.

                IF l_error = space.
                  l_perc = 100 / l_total * l_cnt.
                  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                    EXPORTING
                      percentage = l_perc
                      text       = text-s01.
                ENDIF.

              ENDLOOP.

              IF l_error = space.
                COMMIT WORK.
                MESSAGE s059(/cadaxo/sqlc) WITH l_cnt.
              ELSE.
                ROLLBACK WORK.
                MESSAGE s068(/cadaxo/sqlc) DISPLAY LIKE 'E'.
              ENDIF.

              me->select_jobdata( ).

              <l_cont_grid_result>-gui_alv_grid->refresh_table_display(
                EXPORTING
                  i_soft_refresh = 'X' ).
            ELSE.
              MESSAGE s042(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
            ENDIF.
          ELSE.
            MESSAGE s061(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
          ENDIF.

        ENDIF.

* CDX130-001 - begin
      WHEN 'ABORT'.

        CLEAR: l_rc,
               l_cnt,
               l_error.
        READ TABLE gcont_grid_result_t INDEX 1 ASSIGNING <l_cont_grid_result>.
        IF sy-subrc = 0.

          <l_cont_grid_result>-gui_alv_grid->get_selected_rows(
            IMPORTING
               et_row_no      =   lt_lvc_t_roid ).
          IF NOT lt_lvc_t_roid[] IS INITIAL.
            LOOP AT lt_lvc_t_roid ASSIGNING <l_lvc_s_roid>.
              READ TABLE gt_jobs INDEX <l_lvc_s_roid>-row_id ASSIGNING <l_jobs>.
              IF sy-subrc = 0.
                SELECT SINGLE @abap_true FROM tbtco INTO @l_true WHERE jobname = @<l_jobs>-jobname
                                                                   AND jobcount = @<l_jobs>-jobcount.
                IF sy-subrc = 0.
                  CALL FUNCTION 'BP_JOB_ABORT'
                    EXPORTING
                      jobcount                   = <l_jobs>-jobcount
                      jobname                    = <l_jobs>-jobname
                    EXCEPTIONS
                      checking_of_job_has_failed = 1
                      job_abort_has_failed       = 2
                      job_does_not_exist         = 3
                      job_is_not_active          = 4
                      no_abort_privilege_given   = 5.
                  IF sy-subrc <> 0.
                    l_error = 'X'.
                  ELSE.
                    ADD 1 TO l_cnt.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDLOOP.
            IF l_error = space.
              COMMIT WORK.
              MESSAGE s073(/cadaxo/sqlc) WITH l_cnt.
            ELSE.
              ROLLBACK WORK.
              MESSAGE s074(/cadaxo/sqlc) DISPLAY LIKE 'E'.
            ENDIF.

            me->select_jobdata( ).

            <l_cont_grid_result>-gui_alv_grid->refresh_table_display(
              EXPORTING
                i_soft_refresh = 'X' ).
          ELSE.
            MESSAGE s061(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
          ENDIF.
        ELSE.
          MESSAGE s061(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
        ENDIF.
* CDX130-001 - end

      WHEN 'REFRESH'.

        me->show_jobmonitor( ).

    ENDCASE.

  ENDMETHOD.


  METHOD on_handle_result_context_menu.
****************************************************************************************************
* Description             : Result List Context Menu                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2013               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 08.12.2014 | Ana Lekic            | No Update-Popup for saved lists             | RT281          *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA lr_badi TYPE REF TO /cadaxo/sqlc_badi_res_ctxm.
    DATA lcl_gui_control TYPE REF TO cl_gui_control.
    DATA l_grid_name TYPE string.
    DATA lcl_cl_gui_alv_grid TYPE REF TO cl_gui_alv_grid.
    DATA ls_row TYPE lvc_s_row.
    DATA ls_col TYPE lvc_s_col.
    DATA lt_lvc_t_row TYPE lvc_t_row.
    DATA length  TYPE i.
    DATA l_grid_name_i TYPE i.
    DATA l_index TYPE i.
    DATA l_show_as_submenu TYPE REF TO cl_ctmenu.

    FIELD-SYMBOLS <lr_dref>         TYPE any. "RT281
    FIELD-SYMBOLS <lr_cl_sql_parse> LIKE LINE OF gt_cl_sql_parse. "RT281
    FIELD-SYMBOLS: <lt_result_tab>  TYPE STANDARD TABLE,
                   <l_result_line>  TYPE any,
                   <l_result_field> TYPE any.

    cl_gui_alv_grid=>get_focus( IMPORTING control = lcl_gui_control ).
    l_grid_name = lcl_gui_control->get_name( ).

    TRY.

        lcl_cl_gui_alv_grid ?= lcl_gui_control.

        lcl_cl_gui_alv_grid->get_current_cell( IMPORTING es_row_id = ls_row es_col_id = ls_col ).

        lcl_cl_gui_alv_grid->get_selected_rows( IMPORTING et_index_rows = lt_lvc_t_row ).

      CATCH cx_sy_move_cast_error ##no_handler.
    ENDTRY.

    IF ls_col-fieldname IS NOT INITIAL. "cockpit-454

    l_grid_name_i = l_grid_name+15.

    READ TABLE dref_result_tab_t INDEX l_grid_name_i ASSIGNING <lr_dref>.
    ASSIGN <lr_dref>->* TO <lt_result_tab>.
    READ TABLE <lt_result_tab> INDEX ls_row-index ASSIGNING <l_result_line>.

    IF sy-subrc = 0.
      ASSIGN COMPONENT ls_col-fieldname OF STRUCTURE <l_result_line> TO <l_result_field>.
      DESCRIBE FIELD <l_result_field> TYPE DATA(l_typ).
      IF l_typ = 'g' OR l_typ = 'C'.
        length = strlen( <l_result_field> ).
        IF length >= 128.
          e_object->add_separator( ).
          e_object->add_function( fcode = c_cmd_show_full_value text = text-q56 ).
        ENDIF.
      ENDIF.
    ENDIF.


    l_show_as_submenu = NEW cl_ctmenu( ).

    l_show_as_submenu->add_function(
      EXPORTING
        fcode             = c_cmd_show_value_as_html_brow
        text              = text-q61
    ).
    l_show_as_submenu->add_function(
      EXPORTING
        fcode             = c_cmd_show_value_as_xml_brow
        text              = text-q62
    ).

    e_object->add_submenu(
      EXPORTING
        menu        = l_show_as_submenu
        text        = text-q60
    ).

    e_object->add_separator( ).
    e_object->add_function( fcode = c_cmd_create_symbol text = 'Create Symbols'(002) ).
    e_object->add_separator( ).

* RT281 Begin
    IF strlen( l_grid_name ) > 15.
      l_grid_name_i = l_grid_name+15.
      ASSIGN dref_result_tab_t[ l_grid_name_i ] TO <lr_dref>. "get reference of the partse
      IF sy-subrc = 0.
        l_index = sy-tabix.
        READ TABLE gt_cl_sql_parse INDEX l_index ASSIGNING <lr_cl_sql_parse>.
        IF sy-subrc = 0 AND <lr_cl_sql_parse>->g_saved_list = abap_true. "if it is a saved list, no edit function
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
* RR281 End

    GET BADI lr_badi.

    CALL BADI lr_badi->create
      EXPORTING
        i_object     = e_object
        it_lvc_t_row = lt_lvc_t_row
        i_row        = ls_row
        i_col        = ls_col.

  ENDIF. "+ cockpit-454

  ENDMETHOD.


  METHOD on_handle_result_end_of_page.

    BREAK-POINT.
*    CALL METHOD cl_gui_alv_grid=>get_focus( IMPORTING control = lcl_gui_control ).
*    DATA(l_grid_name) = lcl_gui_control->get_name( ).
    WRITE: 'end of page testing"!'.
  ENDMETHOD.


  METHOD on_handle_result_menu_button.
****************************************************************************************************
* Description             : handle result menu button                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : Cadaxo GmbH                      *
* Date                    :                          Release    :                                  *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.05.2016 | Lekic                | only same keys fields necessary             | $001           *
*            |                      |                                             | COCKPIT-62     *
*------------+----------------------+---------------------------------------------+----------------*
* 12.03.2018 |  Dusan Sacha         | Add CSV Export                              | COCKPIT-271    *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_name         TYPE abap_abstypename.
    DATA lt_table       TYPE HASHED TABLE OF textpool WITH UNIQUE KEY id key.
    DATA l_progname(32) VALUE '==============================CP'.
    DATA l_length       TYPE i.

    DATA l_grid_name TYPE string.
    DATA l_grid_name_i TYPE i.
    DATA l_result_nr(2) TYPE n.
    DATA l_fcode TYPE ui_func.
    DATA l_text  TYPE gui_text.

    DATA l_lines_source TYPE i.
    DATA l_lines_target TYPE i.
    DATA l_compare_able TYPE c.

    DATA: lcl_gui_control   TYPE REF TO cl_gui_control.

* get focus object
    cl_gui_alv_grid=>get_focus( IMPORTING control = lcl_gui_control ).
    l_grid_name = lcl_gui_control->get_name( ).
    MOVE l_grid_name+15 TO l_grid_name_i.

    FIELD-SYMBOLS: <ls_table>       TYPE textpool,
                   <lr_dref>        TYPE REF TO data,
                   <lt_fcat_source> TYPE lvc_t_fcat,
                   <ls_fcat_source> TYPE lvc_s_fcat,
                   <lt_fcat_target> TYPE lvc_t_fcat,
                   <ls_fcat_target> TYPE lvc_s_fcat.

    CASE e_ucomm.
      WHEN 'ADD_FUNCTIONS'.
        DATA lr_menu TYPE REF TO cl_ctmenu.
        DATA lr_menu_export TYPE REF TO cl_ctmenu.

        lr_menu = NEW cl_ctmenu( ).
        lr_menu_export = NEW cl_ctmenu( ).

        lr_menu_export->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_call_xxl
            text  = text-f07 ).

        lr_menu_export->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_word_processor
            text  = text-f08 ).

        lr_menu_export->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_pc_file
            text  = text-f09 ).

        lr_menu_export->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_send
            text  = text-f10 ).

        lr_menu_export->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_to_office
            text  = text-f11 ).

        lr_menu_export->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_html
            text  = text-f12 ).

        lr_menu_export->add_function(        "COCKPIT-271
          EXPORTING                          "COCKPIT-271
            fcode = gc_fcode_csv             "COCKPIT-271
            text  = text-f15 ).              "COCKPIT-271

*      lr_menu->add_function(
*        EXPORTING
*          fcode = cl_gui_alv_grid=>mc_fc_print
*          text  = text-f14 ).

        lr_menu->add_separator( ).

        lr_menu->add_submenu(
          EXPORTING
            menu = lr_menu_export
            text = text-f06 ).

        lr_menu->add_separator( ).

        lr_menu->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_graph
            text  = text-f13 ).

        CALL METHOD e_object->add_menu
          EXPORTING
            menu = lr_menu.

      WHEN 'COMPARE_RESULT'.

        READ TABLE gt_lvc_t_fcat INDEX l_grid_name_i ASSIGNING <lt_fcat_source>.
        IF sy-subrc = 0.

          LOOP AT dref_result_tab_t ASSIGNING <lr_dref>.

            IF l_grid_name_i = sy-tabix.
              CONTINUE.
            ENDIF.

            READ TABLE gt_lvc_t_fcat INDEX sy-tabix ASSIGNING <lt_fcat_target>.
            IF sy-subrc = 0.

              l_result_nr = sy-tabix.
              l_compare_able = abap_true.

              DESCRIBE TABLE <lt_fcat_source> LINES l_lines_source.
              DESCRIBE TABLE <lt_fcat_target> LINES l_lines_target.

*            IF l_lines_source <> l_lines_target.                 "$001
*              l_compare_able = abap_false.                       "$001
*            ELSE.                                                "$001
              LOOP AT <lt_fcat_source> ASSIGNING <ls_fcat_source> WHERE key <> space. "$001
                READ TABLE <lt_fcat_target> ASSIGNING <ls_fcat_target> INDEX sy-tabix.
                IF sy-subrc <> 0.
                  l_compare_able = abap_false.
                  EXIT.
                ELSE.

                  IF <ls_fcat_source>-row_pos  <> <ls_fcat_source>-row_pos OR
                     <ls_fcat_source>-col_pos  <> <ls_fcat_source>-col_pos OR
                     <ls_fcat_source>-datatype <> <ls_fcat_source>-datatype OR
                     <ls_fcat_source>-inttype  <> <ls_fcat_source>-inttype OR
                     <ls_fcat_source>-intlen   <> <ls_fcat_source>-intlen.
                    l_compare_able = abap_false.
                    EXIT.
                  ENDIF.
                ENDIF.
              ENDLOOP.
*            ENDIF.   "$001

              IF l_compare_able = abap_true.



                CONCATENATE 'COMPARE_WITH_' l_result_nr INTO l_fcode.
                CONCATENATE '#' l_result_nr INTO l_text SEPARATED BY space.

                e_object->add_function(
                  EXPORTING
                    fcode = l_fcode
                    text  = l_text ).

              ENDIF.
            ENDIF.

          ENDLOOP.

        ENDIF.

      WHEN 'EXPORT'.

        IF lt_table IS INITIAL.
          l_name = cl_abap_classdescr=>get_class_name( me ).
          SPLIT l_name AT '=' INTO l_name l_name.
          l_length = strlen( l_name ).
          l_progname(l_length) = l_name.
          READ TEXTPOOL l_progname INTO lt_table LANGUAGE sy-langu.
        ENDIF.

        READ TABLE lt_table ASSIGNING <ls_table> WITH TABLE KEY id = 'I' key = text-032.
* to be implemented

        e_object->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_call_xxl
            text  = 'Spreadsheet' ).

        e_object->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_word_processor
            text  = 'Word Processing' ).

        e_object->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_pc_file
            text  = 'Local File' ).

        e_object->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_send
            text  = 'Send' ).

        e_object->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_to_office
            text  = 'Office' ).

        e_object->add_function(
          EXPORTING
            fcode = cl_gui_alv_grid=>mc_fc_html
             text  = 'HTML File' ).

    ENDCASE.
  ENDMETHOD.


  METHOD on_handle_result_toolbar.
****************************************************************************************************
* Description             : Add button to result list functions                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 26.07.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add Refresh Button                          |                *
*------------+----------------------+---------------------------------------------+----------------*
* 16.10.2016 | Domi Bigl            | code cleanup                                | COCKPIT-109    *
****************************************************************************************************

    DATA: ls_button     TYPE stb_button.
    DATA: lt_buttons    TYPE ttb_button.
    DATA: lr_badi       TYPE REF TO /cadaxo/sqlc_badi_res_ctxm.
    DATA: l_icon        TYPE iconname.
    DATA: l_checked     TYPE boolean.
    DATA: l_index       TYPE i.
    DATA: lr_sql_parse  TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
    DATA: l_iconname    TYPE iconname.
    DATA: l_grid_name_i TYPE i.

    FIELD-SYMBOLS: <lr_dref>         TYPE REF TO data.
    FIELD-SYMBOLS: <lr_cl_sql_parse> TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.

    l_grid_name_i = me->get_current_grid_number( ).

    IF l_grid_name_i IS INITIAL.
      EXIT.
    ENDIF.

    READ TABLE dref_result_tab_t INDEX l_grid_name_i TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      l_index = sy-tabix.
      READ TABLE gt_cl_sql_parse INDEX l_index INTO lr_sql_parse.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
    ELSE.
      EXIT.
    ENDIF.

* append separator
    CLEAR ls_button.

    MOVE 3 TO ls_button-butn_type.
    APPEND ls_button TO e_object->mt_toolbar.

* Key fix
    CLEAR ls_button.
    IF l_icon IS INITIAL.
      MOVE icon_fix_column TO l_icon.
      MOVE abap_false      TO l_checked.
    ENDIF.
    MOVE: 'KEYFIX'           TO ls_button-function,
          l_icon             TO ls_button-icon,
          0                  TO ls_button-butn_type,
          text-q31           TO ls_button-quickinfo,
          space              TO ls_button-disabled,
          l_checked          TO ls_button-checked.
    APPEND ls_button TO e_object->mt_toolbar.



* show result table on full screen
    CLEAR ls_button.

    MOVE: 'RESFULLDISP'      TO ls_button-function,
          icon_view_maximize TO ls_button-icon,
          text-q27           TO ls_button-quickinfo,
          0                  TO ls_button-butn_type,
          space              TO ls_button-disabled.

    APPEND ls_button TO e_object->mt_toolbar.

* Compare result table
    CLEAR ls_button.
*  IF lr_sql_parse->g_select_version = lr_sql_parse->c_select_version_1.
    ls_button-disabled = abap_false.
    ls_button-quickinfo = text-q34.
*  ELSE.
*    ls_button-disabled  = abap_true.
*    ls_button-quickinfo = text-q47.
*  ENDIF.
    ls_button-function  = 'COMPARE_RESULT'.
    ls_button-icon      = icon_compare.
    ls_button-quickinfo = text-q34.
    ls_button-butn_type = 2.
    APPEND ls_button TO e_object->mt_toolbar.

* Compare result table
    CLEAR ls_button.
    " CONCATENATE '#' l_grid_name+15 INTO ls_button-text SEPARATED BY space.

    ls_button-text = '#' && l_grid_name_i.
    MOVE: 'DUMMY_LIST_NR'    TO ls_button-function,
          text-q34           TO ls_button-quickinfo,
          0                  TO ls_button-butn_type,
          abap_true          TO ls_button-disabled.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 1.


    CLEAR ls_button.
    ls_button-butn_type = 3.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 2.

* append separator
    CLEAR ls_button.
    ls_button-butn_type = 3.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 4.

    IF lr_sql_parse->g_saved_list IS INITIAL.
* badi add result toolbar
      CLEAR lt_buttons.
      GET BADI lr_badi.
      CALL BADI lr_badi->add_result_toolbar
        CHANGING
          ct_buttons = lt_buttons.
      IF lt_buttons[] IS NOT INITIAL.

        APPEND LINES OF lt_buttons TO e_object->mt_toolbar.

      ENDIF.

    ENDIF.

    CLEAR ls_button.
    ls_button-butn_type = 3.
    APPEND ls_button TO e_object->mt_toolbar.

    CLEAR l_checked.
    READ TABLE dref_result_tab_t INDEX l_grid_name_i ASSIGNING <lr_dref>.
    IF sy-subrc = 0.
      l_index = sy-tabix.
      READ TABLE gt_cl_sql_parse INDEX l_index ASSIGNING <lr_cl_sql_parse>.
      IF sy-subrc = 0 AND <lr_cl_sql_parse>->g_hold_result <> space.
        l_checked = abap_true.
      ENDIF.
    ENDIF.

    IF l_checked = abap_false.
      l_iconname = icon_hold.
    ELSE.
      l_iconname = icon_hold_undo.
    ENDIF.

* refresh list
    IF lr_sql_parse->g_saved_list IS INITIAL.
      INSERT VALUE #( function  = 'REFRESHLIST'
                      icon      = icon_refresh
                      butn_type = 0
                      quickinfo = text-q24
                      disabled  = space ) INTO e_object->mt_toolbar INDEX 4.
    ENDIF.

    INSERT VALUE #( function  = 'HOLD'
                    icon      = l_iconname
                    butn_type = 5
                    quickinfo = text-q30
                    disabled  = space
                    checked   = l_checked ) INTO e_object->mt_toolbar INDEX 2.

    INSERT VALUE #( function  = 'ADD_FUNCTIONS'
                    icon      = icon_previous_value "ON_ADD_ROW
                    butn_type = 2
                    quickinfo = text-q53
                    disabled = space ) INTO TABLE e_object->mt_toolbar.

    INSERT VALUE #( butn_type = 3 ) INTO TABLE e_object->mt_toolbar.

    INSERT VALUE #( function  = 'CLOSE'
                    icon      = icon_close
                    butn_type = 0
                    quickinfo = text-q52
                    disabled  = space ) INTO TABLE e_object->mt_toolbar.
  ENDMETHOD.


  METHOD on_handle_result_user_command.
****************************************************************************************************
* Description             :                                                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               :                          Company    : CADAXO GesmbH                    *
* Date                    :                          Release    :                                  *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.04.2016 | Ana Lekic            | check result_struc assigned                 | COCKPIT-30     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 12.03.2018 | Dusan Sacha          | Add CSV Export                              | COCKPIT-271    *
*------------+----------------------+---------------------------------------------+----------------*
* 08.10.2019 | Pat                  | Result share                                | Cockpit-401    *
*------------+----------------------+---------------------------------------------+----------------*

    DATA lcl_gui_control TYPE REF TO cl_gui_control.
    DATA lcl_cl_gui_alv_grid TYPE REF TO cl_gui_alv_grid.
    DATA l_grid_name TYPE string.
    DATA l_grid_name_i TYPE i.
    DATA ls_layout TYPE lvc_s_layo.
    DATA ls_layout_tmp TYPE lvc_s_layo.
    DATA l_result_details TYPE /cadaxo/sqlcresult_details.
    DATA l_index TYPE i.
    DATA ls_row_no TYPE lvc_s_roid.
    DATA ls_row_info TYPE lvc_s_row.
    DATA ls_col_info TYPE lvc_s_col.
    DATA l_refresh_list TYPE c LENGTH 1.
    DATA l_result_compare_with TYPE i.

    FIELD-SYMBOLS: "<lt_result_tab>      TYPE STANDARD TABLE,
      <ls_result_line>     TYPE any,
      <ls_result_details>  LIKE LINE OF me->gt_result_details,
      <l_cont_grid_result> TYPE /cadaxo/sqlcclguicontainer.

* get focus object
    CALL METHOD cl_gui_alv_grid=>get_focus( IMPORTING control = lcl_gui_control ).
    l_grid_name = lcl_gui_control->get_name( ).

* get gui control
    lcl_cl_gui_alv_grid ?= lcl_gui_control.

    l_grid_name_i = l_grid_name+15.

    /cadaxo/cl_sqlc_functrace=>add_trace( |ON_HANDLE_RESULT_USER_COMMAND:| && e_ucomm ).

    IF e_ucomm(13) = 'COMPARE_WITH_'.
      MOVE e_ucomm+13 TO l_result_compare_with.

      me->handle_result_command_compare( EXPORTING i_source = l_grid_name_i
                                                   i_target = l_result_compare_with ).
    ELSE.
      CASE e_ucomm.
*    WHEN 'CADAXO_EXPORT'.
* function is still in development and not released in the current release - Cadaxo 1.1.2014/Rel 2.1
*      me->handle_result_command_cdxexp( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN 'REFRESHLIST'.
          me->handle_result_command_refrlst( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN 'CLOSE'.
          me->handle_result_command_close( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN 'HOLD'.
          me->handle_result_command_hold( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN 'KEYFIX'.
          me->handle_result_command_keyfix( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN 'RESFULLDISP'.
          me->handle_result_command_fulldisp( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN gc_fcode_csv.                                                             "COCKPIT-271
          me->handle_result_command_exp_csv( EXPORTING i_grid_i = l_grid_name_i ).     "COCKPIT-271
        WHEN c_cmd_show_full_value.
          me->handle_command_show_full_value( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN c_cmd_create_symbol.
          me->handle_command_create_symbol( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN c_cmd_show_value_as_html_brow.
          me->handle_command_show_html_brow( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN c_cmd_show_value_as_xml_brow.
          me->handle_command_show_xml_brow( EXPORTING i_grid_i = l_grid_name_i ).
        WHEN OTHERS.

          DATA lr_badi            TYPE REF TO /cadaxo/sqlc_badi_res_ctxm.
          DATA l_dref_result_tab  TYPE REF TO data.
          DATA lr_cl_sql_parse    TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
          DATA ls_row    TYPE lvc_s_row.
          DATA ls_col    TYPE lvc_s_col.
          DATA lt_lvc_t_fcat TYPE lvc_t_fcat.

*     field-symbols: <ls_result_line> type any.

          IF e_ucomm = 'EDIT'.
            SELECT SINGLE @abap_true FROM nriv INTO @DATA(lv_nr_exists) WHERE object = '/CADAXO/01'.
              IF sy-subrc NE 0.
               MESSAGE text-003 TYPE 'I'.
               RETURN.
              ENDIF.
          ENDIF.

          READ TABLE dref_result_tab_t INTO l_dref_result_tab INDEX l_grid_name_i.
          IF sy-subrc = 0.
            l_index = sy-tabix.
            READ TABLE gt_cl_sql_parse INTO lr_cl_sql_parse INDEX l_grid_name_i.
            IF sy-subrc = 0.
              ASSIGN lr_cl_sql_parse->result_structure->* TO <ls_result_line>.
              IF <ls_result_line> IS ASSIGNED.
                READ TABLE gt_lvc_t_fcat INTO lt_lvc_t_fcat INDEX l_grid_name_i.
* get current cell/line

                CALL METHOD lcl_cl_gui_alv_grid->get_current_cell
                  IMPORTING
                    es_row_id = ls_row
                    es_col_id = ls_col.

                DATA lt_lvc_t_row TYPE lvc_t_row.

                CLEAR lt_lvc_t_row.

                lcl_cl_gui_alv_grid->get_selected_rows( IMPORTING et_index_rows = lt_lvc_t_row ).
                IF lt_lvc_t_row IS INITIAL.

                  lcl_cl_gui_alv_grid->get_current_cell( IMPORTING es_row_id = ls_row_info ).
                  APPEND ls_row_info TO lt_lvc_t_row.

                ENDIF.


                GET BADI lr_badi.

                CALL BADI lr_badi->execute
                  EXPORTING
                    i_ucomm              = e_ucomm
                    i_dref_result_tab    = l_dref_result_tab
                    is_current_row       = ls_row
                    is_current_col       = ls_col
                    is_result_line       = <ls_result_line>
                    it_result_components = lr_cl_sql_parse->result_component_t
                    it_result_ddfields   = lr_cl_sql_parse->gt_result_ddfields
                    i_column_syntax      = lr_cl_sql_parse->column_syntax
                    i_connection_syntax  = lr_cl_sql_parse->connection_syntax
                    it_result_source     = lr_cl_sql_parse->result_source_t
                    ir_result_structure  = lr_cl_sql_parse->result_structure
                    it_lvc_t_fcat        = lt_lvc_t_fcat
                    it_lvc_t_row         = lt_lvc_t_row
                    iv_client_handling   = lr_cl_sql_parse->gs_client_handling
                    i_select_version     = lr_cl_sql_parse->g_select_version
                  CHANGING
                    c_refresh_list       = l_refresh_list.

                IF l_refresh_list <> space.

                  lr_cl_sql_parse->execute_select( EXPORTING i_user_settings  = me->ms_user_settings_xml
                                                   IMPORTING e_result_details = l_result_details ).

                  READ TABLE me->gt_result_details INDEX l_index ASSIGNING <ls_result_details>.
                  IF sy-subrc = 0.

                    <ls_result_details> = l_result_details.

                    READ TABLE me->gcont_grid_result_t INDEX l_index ASSIGNING <l_cont_grid_result>.
                    IF sy-subrc = 0.

                      <l_cont_grid_result>-gui_alv_grid->get_scroll_info_via_id( IMPORTING es_row_no = ls_row_no es_row_info = ls_row_info es_col_info = ls_col_info ).

                      <l_cont_grid_result>-gui_alv_grid->get_frontend_layout( IMPORTING es_layout = ls_layout_tmp ).

                      ls_layout            = me->g_result_layout.
                      ls_layout-frontend   = ls_layout_tmp-frontend.
                      ls_layout-grid_title = /cadaxo/cl_sqlc_cockpit_main=>build_result_grid_title(
                                                                         i_runtime = <ls_result_details>-runtime
                                                                         i_lines   = <ls_result_details>-lines ).

                      <l_cont_grid_result>-gui_alv_grid->set_frontend_layout( is_layout = ls_layout ).

                      <l_cont_grid_result>-gui_alv_grid->refresh_table_display( i_soft_refresh = abap_true ).

                      <l_cont_grid_result>-gui_alv_grid->set_scroll_info_via_id( EXPORTING is_row_no = ls_row_no is_row_info = ls_row_info is_col_info = ls_col_info ).

                    ENDIF.

                  ENDIF.

                ENDIF.

              ELSE.                                                                                  "COCKPIT-30
                MESSAGE i108(/cadaxo/sqlc).                                                          "COCKPIT-30
              ENDIF.                                                                                 "COCKPIT-30
            ELSE.                                                                                    "COCKPIT-30
              MESSAGE i108(/cadaxo/sqlc).                                                            "COCKPIT-30
            ENDIF.
          ENDIF.

      ENDCASE.
    ENDIF.



  ENDMETHOD.


  METHOD on_handle_savedlists_toolbar.
****************************************************************************************************
* Description             : Add buttons to saved lists alv                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxx                Company    : xxxxxxxxxxxxx                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 08.10.2019 | Pat                  | Result share                                | Cockpit-401    *
*------------+----------------------+---------------------------------------------+----------------*
* 16.11.2020 | Attila Kajtar        | Sharing: sharing with same user / system!   | Cockpit-420    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: ls_button TYPE stb_button.

    INSERT VALUE #( function = 'REFRESH'
                    icon = icon_refresh
                    quickinfo = text-b23 ) INTO e_object->mt_toolbar INDEX 1.

    INSERT VALUE #( function = 'SELECT'
                    icon = icon_unassign
                    quickinfo = text-b26 ) INTO e_object->mt_toolbar INDEX 2.

* refresh button
    CLEAR ls_button.
    MOVE: 'RENAME'      TO ls_button-function,
          icon_rename   TO ls_button-icon,
          text-b30      TO ls_button-quickinfo,
          0             TO ls_button-butn_type,
          space         TO ls_button-disabled.
    APPEND ls_button TO e_object->mt_toolbar.

* delete button
    CLEAR ls_button.
    MOVE: 'DELETE'      TO ls_button-function,
          icon_delete   TO ls_button-icon,
          0             TO ls_button-butn_type,
          text-b24      TO ls_button-quickinfo,
          space         TO ls_button-disabled.
    APPEND ls_button TO e_object->mt_toolbar.

* import button
    CLEAR ls_button.
    MOVE: 'IMPORT_SQLX' TO ls_button-function,
          icon_import   TO ls_button-icon,
          0             TO ls_button-butn_type,
          space         TO ls_button-disabled,
          text-b29      TO ls_button-quickinfo.
    APPEND ls_button TO e_object->mt_toolbar.

* export button
    CLEAR ls_button.
    MOVE: 'EXPORT_SQLX' TO ls_button-function,
          icon_export   TO ls_button-icon,
          0             TO ls_button-butn_type,
          space         TO ls_button-disabled,
          text-b28      TO ls_button-quickinfo.
    APPEND ls_button TO e_object->mt_toolbar.

    INSERT VALUE #( butn_type = 3 ) INTO TABLE e_object->mt_toolbar.
    INSERT VALUE #( function  = c_saved_list_share
                    icon      = icon_workflow_external_event
*                   butn_type = 0 "-Cockpit-420
*                   butn_type = 2 "-Cockpit-420
                    butn_type = 1 "+Cockpit-420 KA
                    quickinfo = text-q58
                    disabled  = space ) INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.


  METHOD on_handle_savedlists_usrcommnd.
****************************************************************************************************
* Description             : on handle savedlists user command                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx                   Company    : xxxxxxxxxxxxxx                   *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 16.10.2019 | Pat                  | Saved Lists Share                            | Cockpit-401   *
*------------+----------------------+---------------------------------------------+----------------*
* 16.11.2020 | Attila Kajtar        | Sharing: sharing with same user / system!    | Cockpit-420   *
****************************************************************************************************

    DATA lt_lvc_t_roid   TYPE lvc_t_roid.
    DATA l_rc            TYPE c   LENGTH 1.
    DATA l_free_space_kb TYPE int4.
    DATA lt_ress_guid TYPE /cadaxo/sqlc_ress_guid_t.
    DATA l_description   TYPE /cadaxo/sqlc_list_description.
    DATA lt_cells TYPE lvc_t_cell.

    FIELD-SYMBOLS: <l_cont_grid_result> TYPE /cadaxo/sqlcclguicontainer,
                   <l_lvc_s_roid>       TYPE lvc_s_roid,
                   <ls_saved_lists>     LIKE LINE OF me->gt_saved_lists.

    /cadaxo/cl_sqlc_functrace=>add_trace( |ON_HANDLE_SAVEDLISTS_USRCOMMND:| && e_ucomm ).

    CASE e_ucomm.
      WHEN 'SELECT'.

        CLEAR: l_rc.

        READ TABLE gcont_grid_result_t INDEX 1 ASSIGNING <l_cont_grid_result>.
        IF sy-subrc = 0.

          <l_cont_grid_result>-gui_alv_grid->get_selected_rows(
            IMPORTING
               et_row_no      =   lt_lvc_t_roid ).

          IF NOT lt_lvc_t_roid[] IS INITIAL.
            CLEAR lt_ress_guid.
            LOOP AT lt_lvc_t_roid ASSIGNING <l_lvc_s_roid>.
              READ TABLE me->gt_saved_lists INDEX <l_lvc_s_roid>-row_id ASSIGNING <ls_saved_lists>.
              IF sy-subrc = 0.
                APPEND <ls_saved_lists>-ress_guid TO lt_ress_guid.
              ENDIF.
            ENDLOOP.
          ELSE.
            <l_cont_grid_result>-gui_alv_grid->get_selected_cells( IMPORTING et_cell = lt_cells ).
            IF lines( lt_cells ) > 0.
              LOOP AT lt_cells ASSIGNING FIELD-SYMBOL(<ls_cell>).
                READ TABLE me->gt_saved_lists INDEX <ls_cell>-row_id-index ASSIGNING <ls_saved_lists>.
                IF sy-subrc = 0.
                  APPEND <ls_saved_lists>-ress_guid TO lt_ress_guid.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.

          IF lines( lt_ress_guid ) > 0.
            me->get_saved_results( lt_ress_guid ).
          ENDIF.

        ENDIF.

      WHEN 'REFRESH'.
        READ TABLE gcont_grid_result_t INDEX 1 ASSIGNING <l_cont_grid_result>.
        IF sy-subrc = 0.

          /cadaxo/cl_sqlc_cockpit_lists=>get_saved_lists( EXPORTING i_uname = sy-uname
                                                          IMPORTING e_saved_lists = me->gt_saved_lists
                                                                    e_free_space_kb = l_free_space_kb ).

          <l_cont_grid_result>-gui_alv_grid->refresh_table_display( ).

        ENDIF.
      WHEN 'RENAME'.
        READ TABLE gcont_grid_result_t INDEX 1 ASSIGNING <l_cont_grid_result>.
        IF sy-subrc = 0.

          <l_cont_grid_result>-gui_alv_grid->get_selected_rows(
            IMPORTING
               et_row_no      =   lt_lvc_t_roid ).

          LOOP AT lt_lvc_t_roid ASSIGNING <l_lvc_s_roid>.
            READ TABLE me->gt_saved_lists INDEX <l_lvc_s_roid>-row_id ASSIGNING <ls_saved_lists>.
            IF sy-subrc = 0.

              l_description = <ls_saved_lists>-description.

              CALL FUNCTION '/CADAXO/SQLCLISTS_REN_SAV_LIST'
                IMPORTING
                  e_rc          = l_rc
                CHANGING
                  c_description = l_description.

              IF l_description <> <ls_saved_lists>-description AND l_rc = 'O'.
                /cadaxo/cl_sqlc_cockpit_lists=>rename_list( EXPORTING i_list_guid = <ls_saved_lists>-list_guid
                                                                      i_jobcount  = <ls_saved_lists>-jobcount
                                                                      i_description = l_description ).
              ENDIF.
            ENDIF.
          ENDLOOP.

          /cadaxo/cl_sqlc_cockpit_lists=>get_saved_lists( EXPORTING i_uname = sy-uname
                                                          IMPORTING e_saved_lists = me->gt_saved_lists
                                                                    e_free_space_kb = l_free_space_kb ).

          <l_cont_grid_result>-gui_alv_grid->refresh_table_display( ).

        ENDIF.
      WHEN 'DELETE'.

        handle_delete_saved_lists( ).

      WHEN 'EXPORT_SQLX'.

        handle_export_saved_list( ).

      WHEN 'IMPORT_SQLX'.
        READ TABLE gcont_grid_result_t INDEX 1 ASSIGNING <l_cont_grid_result>.
        IF sy-subrc = 0.
          /cadaxo/cl_sqlc_cockpit_lists=>import_list(  ).
          /cadaxo/cl_sqlc_cockpit_lists=>get_saved_lists( EXPORTING i_uname = sy-uname
                                                          IMPORTING e_saved_lists = me->gt_saved_lists
                                                                    e_free_space_kb = l_free_space_kb ).
          <l_cont_grid_result>-gui_alv_grid->refresh_table_display( ).
        ENDIF.

*      WHEN c_saved_list_share. "cockpit-401    "-cockpit-420
      WHEN c_saved_list_share_oth  "cockpit-401 "+cockpit-420
        OR c_saved_list_share. "Cockpit-420 KA
        share_saved_list( ).

*begin of insert +cockpit-420
      WHEN c_saved_list_share_me.

        share_saved_list( EXPORTING iv_receiver = CONV /cadaxo/sqlcapi_receiver( sy-uname ) iv_text = text-012 ).
*end   of insert +cockpit-420

    ENDCASE.

  ENDMETHOD.


  METHOD on_handle_varsym_click.
****************************************************************************************************
* Description             : handle hotspot variant symbol overwrite                                *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 01.09.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 30.11.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    FIELD-SYMBOLS: <lwa_symbol_ow> TYPE /cadaxo/sqlc_symbol_ow.
    DATA: lwa_stable               TYPE lvc_s_stbl.

    READ TABLE gt_symbol_ow ASSIGNING <lwa_symbol_ow> INDEX e_row_id-index.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    CASE e_column_id-fieldname.
      WHEN 'OWN'.
        <lwa_symbol_ow>-var = icon_wd_radio_button_empty.
        <lwa_symbol_ow>-own = icon_radiobutton.
      WHEN 'VAR'.
        <lwa_symbol_ow>-var = icon_radiobutton.
        <lwa_symbol_ow>-own = icon_wd_radio_button_empty.
      WHEN OTHERS.
        RETURN.
    ENDCASE.

    lwa_stable-row = abap_true.
    lwa_stable-col = abap_true.
    gr_alv_symb_ow->refresh_table_display( EXPORTING  is_stable      = lwa_stable
                                                      i_soft_refresh = abap_true
                                           EXCEPTIONS OTHERS         = 1 ).
  ENDMETHOD.


  METHOD on_home_sapevent.
    DATA: l_html_id TYPE /cadaxo/sqlcparameter_id.

    IF action <> 'HTML'. RETURN. ENDIF.
    l_html_id = getdata.
    show_html( l_html_id ).

  ENDMETHOD.


  METHOD on_job_alv_click.


    DATA lt_ress_guid TYPE /cadaxo/sqlc_ress_guid_t.

    FIELD-SYMBOLS: <ls_jobs> LIKE LINE OF gt_jobs.

    READ TABLE gt_jobs INDEX es_row_no-row_id ASSIGNING <ls_jobs>.
    IF sy-subrc = 0.

      /cadaxo/cl_sqlc_functrace=>add_trace( |ON_JOB_ALV_CLICK| ).

      CLEAR lt_ress_guid.
      APPEND <ls_jobs>-ress_guid TO lt_ress_guid.
      me->get_saved_results( lt_ress_guid ).
    ENDIF.

  ENDMETHOD.


  METHOD on_job_alv_hotspot_click.

    DATA: lt_tbtcjob TYPE TABLE OF tbtcjob.

    FIELD-SYMBOLS: <ls_jobs> LIKE LINE OF gt_jobs.

    READ TABLE gt_jobs INDEX es_row_no-row_id ASSIGNING <ls_jobs>.
    IF sy-subrc = 0.

      PERFORM show_job_sm37b IN PROGRAM saplbtch
                               TABLES lt_tbtcjob
                               USING <ls_jobs>-jobname
                                     <ls_jobs>-jobcount
                               IF FOUND.

    ENDIF.
  ENDMETHOD.


  METHOD on_log_alv_context_menu.
****************************************************************************************************
* Description             : History Log Context Menu                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dusan Sacha              Company    : CADAXO GesmbH                    *
* Date                    : 20.01.2019               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |          *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************


    DATA gui_alv_grid TYPE REF TO cl_gui_alv_grid.
    DATA row          TYPE lvc_s_row.
    DATA col          TYPE lvc_s_col.
    DATA length       TYPE i.

    TRY.
        gui_alv_grid = gcont_grid_result_t[ 1 ]-gui_alv_grid.
        gui_alv_grid->get_current_cell( IMPORTING es_row_id = row es_col_id = col ).
        ASSIGN gt_history_log[ row-index ] TO FIELD-SYMBOL(<history_log>).
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    length = strlen( <history_log>-sql_string ).
    IF length >= 128 AND col-fieldname = 'SQL_STRING'.
      e_object->add_separator( ).
      e_object->add_function( fcode = c_cmd_show_full_value text = text-q56 ).
    ENDIF.

  ENDMETHOD.


  METHOD on_log_alv_double_click.

    DATA: l_from_line     TYPE i,
          l_from_pos      TYPE i,
          l_to_line       TYPE i,
          l_to_pos        TYPE i,
          lt_string_block TYPE TABLE OF string,
          l_sql_string    TYPE string.

    FIELD-SYMBOLS: <l_history_log> TYPE /cadaxo/sqlclogalv.

* this function is only available with the new frontend editor
    IF me->g_abap_editor_type <> 'A'.
      MESSAGE i041(/cadaxo/sqlc).
      EXIT.
    ENDIF.

    IF e_column-fieldname = 'SQL_STRING'.
      READ TABLE gt_history_log INDEX e_row-index ASSIGNING <l_history_log>.
      IF sy-subrc = 0.
        gc_abap_editor->get_selection_pos( IMPORTING  from_line = l_from_line
                                                      from_pos  = l_from_pos
                                                      to_line   = l_to_line
                                                      to_pos    = l_to_pos
                                           EXCEPTIONS OTHERS    = 1 ).
        IF sy-subrc = 0.
          IF l_from_line <> l_to_line OR
             l_from_pos  <> l_to_pos.
            MESSAGE i005(/cadaxo/sqlc).
          ELSE.

            CONCATENATE <l_history_log>-sql_string '.' INTO l_sql_string.

            SPLIT l_sql_string AT cl_abap_char_utilities=>cr_lf INTO TABLE lt_string_block.

            gc_abap_editor->insert_block_at_position( EXPORTING  line     = l_from_line
                                                                 pos      = l_from_pos
                                                                 text_tab = lt_string_block
                                                      EXCEPTIONS OTHERS   = 1 ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD on_log_alv_drag.
****************************************************************************************************
* Description             : Drag log entry                                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 03.02.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA lr_drag_object  TYPE REF TO lcl_drag_object.
    DATA lv_string_value TYPE string.

    FIELD-SYMBOLS: <lv_result_field> TYPE any.

* read sql log entry from history table
    READ TABLE gt_history_log INDEX e_row-index ASSIGNING FIELD-SYMBOL(<ls_history_log>).
    IF <ls_history_log> IS ASSIGNED.

      ASSIGN COMPONENT e_column-fieldname OF STRUCTURE <ls_history_log> TO <lv_result_field>.
      IF <lv_result_field> IS ASSIGNED.

        IF e_column-fieldname = 'SQL_STRING'.
          CONCATENATE <lv_result_field> '.' INTO lv_string_value.
        ELSE.
          lv_string_value = <lv_result_field>.
        ENDIF.

* create drag/drop object
        lr_drag_object = NEW #( ).
        lr_drag_object->fieldvalue = lv_string_value.
        e_dragdropobj->object = lr_drag_object.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD on_log_alv_toolbar.
****************************************************************************************************
* Description             : Add button to result list functions                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 18.04.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | New Buttons to select date/time and refresh | FOE18042010    *
* 10.02.2018 | Pratik Patil         | Extended SQL Search  cockpit-359            |                *
****************************************************************************************************

    DATA: ls_button TYPE stb_button.
    CONSTANTS : lc_separator TYPE tb_btype VALUE 3.

* append separator
    CLEAR ls_button.
    MOVE lc_separator TO ls_button-butn_type.
    APPEND ls_button TO e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'REFRESH'.
    ls_button-icon = icon_refresh.
    ls_button-quickinfo = text-b19.
    ls_button-butn_type = 0.
    ls_button-disabled = space.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 1.

    CLEAR ls_button.
    ls_button-function = 'SELDATE'.
    ls_button-icon = icon_date.
    ls_button-quickinfo = text-b18.
    ls_button-butn_type = 0.
    ls_button-disabled = space.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 2.

* delete my history
    CLEAR ls_button.
    MOVE: 'DELHIST'     TO ls_button-function,
          icon_delete   TO ls_button-icon,
          text-b25      TO ls_button-quickinfo,
          0             TO ls_button-butn_type,
          space         TO ls_button-disabled.
    APPEND ls_button TO e_object->mt_toolbar.

    CLEAR ls_button.
    MOVE lc_separator TO ls_button-butn_type.
    APPEND ls_button TO e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'SQL_SEARCH'.
    ls_button-icon = icon_search.
    ls_button-quickinfo = text-b43.
    ls_button-butn_type = 0.
    ls_button-disabled = space.
    ls_button-text = text-b43.
    APPEND ls_button TO e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'SQL_SEARCH_NEXT'.
    ls_button-icon = icon_search_next.
    ls_button-quickinfo = text-b43.
    ls_button-butn_type = 0.
    IF gt_selected_rows IS INITIAL.
      ls_button-disabled = abap_true.
    ELSE.
      ls_button-disabled = space.
    ENDIF.
    ls_button-text = text-b43.
    APPEND ls_button TO e_object->mt_toolbar.



  ENDMETHOD.


  METHOD on_log_alv_user_command.
****************************************************************************************************
* Description             : on alv log user command                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 12.09.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Set ICON Status                             | CDX001-0016    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    /cadaxo/cl_sqlc_functrace=>add_trace( |ON_LOG_ALV_USER_COMMAND:| && e_ucomm ).

    CASE e_ucomm.
      WHEN 'SELDATE'.
        CALL FUNCTION '/CADAXO/SQLCGETDATEFROMTO'
          CHANGING
            c_timestamp_from = g_sel_hist_timestamp_from
            c_timestamp_to   = g_sel_hist_timestamp_to
          EXCEPTIONS
            cancel_by_user   = 1
            OTHERS           = 2.
        CASE sy-subrc.
          WHEN 0.
            me->show_log( ).
          WHEN 1.
            MESSAGE s042(/cadaxo/sqlc) DISPLAY LIKE 'E'.
          WHEN OTHERS.
        ENDCASE.
      WHEN 'REFRESH'.
        me->show_log( ).

      WHEN 'DELHIST'.
        me->delete_log( ).

      WHEN 'SQL_SEARCH'.
        me->sql_search( ).

      WHEN 'SQL_SEARCH_NEXT'.
        me->sql_search_next( ).

      WHEN c_cmd_show_full_value.
        me->handle_command_show_full_value( i_log = abap_true ).

    ENDCASE.

  ENDMETHOD.


  METHOD on_result_toolbar_dropdown.

    DATA lr_alv_options        TYPE REF TO cl_ctmenu.
    DATA lr_alv_options_window TYPE REF TO cl_ctmenu.
    DATA l_disabled            TYPE cua_active.
    DATA lv_no_toolbar         TYPE cua_active.

    lr_alv_options = NEW #( ).

    CLEAR l_disabled.
    IF mv_toolbar_result_active <> c_cmd_show_result_table.
      lv_no_toolbar = abap_true.
    ENDIF.

    IF me->g_result_layout-no_toolbar = abap_true.
      lr_alv_options->add_function(  EXPORTING fcode    = c_cmd_result_toolbar_show
                                               disabled = lv_no_toolbar
                                               text     = text-m04 ).
    ELSE.
      lr_alv_options->add_function(  EXPORTING fcode    = c_cmd_result_toolbar_hide
                                               disabled = lv_no_toolbar
                                               text     = text-m03 ).
    ENDIF.


    IF me->g_user_settings-show_footer = abap_true.
      lr_alv_options->add_function(  EXPORTING fcode    = c_cmd_result_footer_hide
                                               disabled = lv_no_toolbar
                                               text     = text-m05 ).
    ELSE.
      lr_alv_options->add_function(  EXPORTING fcode    = c_cmd_result_footer_show
                                               disabled = lv_no_toolbar
                                               text     = text-m06 ).
    ENDIF.

    lr_alv_options_window = NEW #( ).
    IF lv_no_toolbar = abap_false.

      IF me->g_user_settings-result_window_vertical <> space.
        l_disabled = abap_true.
      ELSE.
        l_disabled = abap_false.
      ENDIF.
    ELSE.
      l_disabled = abap_false.
    ENDIF.

    lr_alv_options_window->add_function(  EXPORTING fcode    = 'WINDOW_VERTICAL'
                                                    disabled = l_disabled
                                                    text     = text-m08 ).
    IF lv_no_toolbar = abap_false.
      IF me->g_user_settings-result_window_horizontal <> space.
        l_disabled = abap_true.
      ELSE.
        l_disabled = abap_false.
      ENDIF.
    ELSE.
      l_disabled = abap_false.
    ENDIF.
    lr_alv_options_window->add_function(  EXPORTING fcode = 'WINDOW_HORIZONTAL'
                                  disabled = l_disabled
                                   text  = text-m09 ).
    IF lv_no_toolbar = abap_false.
      IF me->g_user_settings-result_window_matrix <> space.
        l_disabled = abap_true.
      ELSE.
        l_disabled = abap_false.
      ENDIF.
    ELSE.
      l_disabled = abap_false.
    ENDIF.
    lr_alv_options_window->add_function(  EXPORTING fcode = 'WINDOW_MATRIX'
                                  disabled = l_disabled
                                   text  = text-m10 ).

    IF lv_no_toolbar = abap_false.
      IF me->g_user_settings-result_window_tab <> space.
        l_disabled = abap_true.
      ELSE.
        l_disabled = abap_false.
      ENDIF.
    ELSE.
      l_disabled = abap_false.
    ENDIF.
    lr_alv_options_window->add_function(  EXPORTING fcode = 'WINDOW_TAB'
                                  disabled = l_disabled
                                   text  = text-m11 ).


    lr_alv_options->add_submenu(  EXPORTING menu = lr_alv_options_window
                                   disabled = lv_no_toolbar
                                   text  = text-m07 ).

    gc_result_toolbar->track_context_menu(  EXPORTING context_menu = lr_alv_options
                                                      posx         = posx
                                                      posy         = posy ).

  ENDMETHOD.


  METHOD on_result_toolbar_funcsel.
****************************************************************************************************
* Description             : on result toolbar function selection                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxx             Company    : xxxxxxxxx                        *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 17.07.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Show saved lists                            | CDX130-030     *
*------------+----------------------+---------------------------------------------+----------------*
* 24.02.2018 | Domi Bigl            | Show/Hide toolbar from Menu button          | COCKPIT-275    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    IF fcode = c_cmd_show_saved_lists OR fcode =  c_cmd_jobmonitor OR fcode = c_cmd_home OR fcode = c_cmd_show_result_table OR fcode = c_cmd_show_log.
      me->set_result_toolbar_active( i_fcode = fcode ).
    ENDIF.

    DATA ls_layout TYPE lvc_s_layo.
    FIELD-SYMBOLS: <ls_cont_grid_result> LIKE LINE OF gcont_grid_result_t.

    CLEAR g_html_request.

    /cadaxo/cl_sqlc_functrace=>add_trace( |ON_RESULT_TOOLBAR_FUNCSEL:| && fcode ).

    CASE fcode.
      WHEN c_cmd_result_toolbar_hide OR c_cmd_result_toolbar_show.

        IF me->g_user_settings-result_buttons <> abap_true.
          me->g_user_settings-result_buttons      =
          me->ms_user_settings_xml-result_buttons = abap_true.
          me->g_result_layout-no_toolbar          = abap_false.
        ELSE.
          me->g_user_settings-result_buttons      =
          me->ms_user_settings_xml-result_buttons = abap_false.
          me->g_result_layout-no_toolbar          = abap_true.
        ENDIF.

        LOOP AT gcont_grid_result_t ASSIGNING <ls_cont_grid_result>.
          <ls_cont_grid_result>-gui_alv_grid->get_frontend_layout( IMPORTING es_layout = ls_layout ).
          ls_layout-no_toolbar = me->g_result_layout-no_toolbar.
          DATA(lv_grid_name) = <ls_cont_grid_result>-gui_alv_grid->get_name( ).   "COCKPIT-275
          EXPORT grid_name FROM lv_grid_name TO MEMORY ID 'GRID_NAME'.            "COCKPIT-275
          <ls_cont_grid_result>-gui_alv_grid->set_frontend_layout( EXPORTING is_layout = ls_layout ).
        ENDLOOP.

      WHEN 'WINDOW_VERTICAL'.
        me->ms_user_settings_xml-reswindoworientation  = cs_windowresolution-vertical.
        me->g_user_settings-result_window_horizontal   = space.
        me->g_user_settings-result_window_vertical     = abap_true.
        me->g_user_settings-result_window_matrix       = space.
        me->g_user_settings-result_window_tab          = space.
        me->show_result( ).
      WHEN 'WINDOW_HORIZONTAL'.
        me->ms_user_settings_xml-reswindoworientation  = cs_windowresolution-horizontal.
        me->g_user_settings-result_window_horizontal   = abap_true.
        me->g_user_settings-result_window_vertical     = space.
        me->g_user_settings-result_window_matrix       = space.
        me->g_user_settings-result_window_tab          = space.
        me->show_result( ).
      WHEN 'WINDOW_MATRIX'.
        me->ms_user_settings_xml-reswindoworientation  = cs_windowresolution-matrix.
        me->g_user_settings-result_window_horizontal   = space.
        me->g_user_settings-result_window_vertical     = space.
        me->g_user_settings-result_window_matrix       = abap_true.
        me->g_user_settings-result_window_tab          = space.
        me->show_result( ).
      WHEN 'WINDOW_TAB'.
        me->ms_user_settings_xml-reswindoworientation  = cs_windowresolution-tab.
        me->g_user_settings-result_window_horizontal   = space.
        me->g_user_settings-result_window_vertical     = space.
        me->g_user_settings-result_window_matrix       = space.
        me->g_user_settings-result_window_tab          = abap_true.
        me->show_result( ).

      WHEN c_cmd_result_footer_hide.
        me->ms_user_settings_xml-show_footer = abap_false.
        me->g_user_settings-show_footer      = abap_false.
        me->show_result( ).
      WHEN c_cmd_result_footer_show.
        me->ms_user_settings_xml-show_footer = abap_true.
        me->g_user_settings-show_footer      = abap_true.
        me->show_result( ).
      WHEN c_cmd_show_saved_lists.
        me->show_saved_lists( ).
      WHEN c_cmd_jobmonitor.
        me->show_jobmonitor( ).
      WHEN c_cmd_home.
        me->show_html( ).
      WHEN c_cmd_show_result_table.
        me->show_result( ).
      WHEN c_cmd_show_log.
        me->show_log( ).
    ENDCASE.

  ENDMETHOD.


  METHOD ON_SAVED_LIST_MENU_CLICK.

    IF e_ucomm = c_saved_list_share.

    DATA(lr_menu) = NEW cl_ctmenu( ).

    lr_menu->add_function(
      EXPORTING
        fcode = c_saved_list_share_oth
        text  = text-b48
        icon  = icon_workflow_external_event
        insert_at_the_top = abap_true
        checked           = abap_true "Cockpit-420 KA
        ).
    lr_menu->add_function(
       EXPORTING
        fcode = c_saved_list_share_me
         text = text-b44
        icon  = icon_workflow_internal_event ).

    CALL METHOD e_object->add_menu
      EXPORTING
        menu = lr_menu.

    ENDIF.

  ENDMETHOD.


  METHOD on_saved_list_select_line.
****************************************************************************************************
* Description             : On saved lists - select line                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxx                Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
    FIELD-SYMBOLS: <ls_saved_lists> LIKE LINE OF gt_saved_lists.

    DATA lt_ress_guid TYPE /cadaxo/sqlc_ress_guid_t.

    READ TABLE me->gt_saved_lists INDEX es_row_no-row_id ASSIGNING <ls_saved_lists>.
    IF sy-subrc = 0.
      CLEAR lt_ress_guid.
      APPEND <ls_saved_lists>-ress_guid TO lt_ress_guid.
      me->get_saved_results( lt_ress_guid ).
    ENDIF.

  ENDMETHOD.


  METHOD on_symbol_alv_data_change.
****************************************************************************************************
* Description             : on alv symbol data change                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_mod_cell  TYPE lvc_s_modi,
          lt_mod_cell LIKE TABLE OF l_mod_cell.

    FIELD-SYMBOLS <l_symbol> LIKE LINE OF gt_symbol.

    lt_mod_cell = er_data_changed->mt_mod_cells.

    IF NOT lt_mod_cell IS INITIAL.
*   get distinct records by rowid
      SORT lt_mod_cell BY row_id.
      DELETE ADJACENT DUPLICATES FROM lt_mod_cell
                                 COMPARING row_id.
      LOOP AT lt_mod_cell INTO l_mod_cell.

*      "Check Symbol Datatype


        IF l_mod_cell-fieldname = 'SYMBOL_DATATYPE'.
          IF l_mod_cell-value IS INITIAL.
            READ TABLE gt_symbol INDEX l_mod_cell-row_id
                             ASSIGNING <l_symbol>.
            IF <l_symbol>-symbol_multivalue IS NOT INITIAL.
              MESSAGE s122(/cadaxo/sqlc) WITH <l_symbol>-symbol_name DISPLAY LIKE 'E'.
              RETURN.
            ENDIF.
          ELSE.
            l_mod_cell-value = to_upper( val = l_mod_cell-value ).
            TRY.
                me->check_symbol_datatype( i_value = l_mod_cell-value ).

              CATCH /cadaxo/cx_sqlc_symb_not_found INTO DATA(lr_exception).

                MESSAGE lr_exception->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.

                RETURN.

            ENDTRY.
          ENDIF.
        ENDIF.

        READ TABLE gt_symbol INDEX l_mod_cell-row_id
                             ASSIGNING <l_symbol>.
        IF sy-subrc = 0.
          IF <l_symbol>-type = cs_symbol_type-user.
*         mark modify type
            <l_symbol>-type = cs_symbol_type-modify.

          ENDIF.
        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD on_symbol_alv_data_changed_fin.
****************************************************************************************************
* Description             : Build the result grit title                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 01.11.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    IF e_modified = 'X'.
      me->on_symbol_alv_user_command( e_ucomm = 'SYMBOL_SAVE' ).
    ENDIF.

  ENDMETHOD.


  METHOD on_symbol_alv_toolbar.
****************************************************************************************************
* Description             : Add buttons to symbol list functions                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | Sort global/user                            | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
* 27.02.2018 | Pat                  | Symbol export                               | Cockpit-294    *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA: l_button TYPE stb_button.
    FIELD-SYMBOLS: <lwa_symbol> TYPE /cadaxo/sqlc_symbol.                "CDX001-0020
    DATA: l_sh_disabled TYPE c.                                          "CDX001-0020

* add buttons

    LOOP AT gt_symbol_delete ASSIGNING <lwa_symbol>.                     "CDX001-0020
      EXIT.                                                              "CDX001-0020
    ENDLOOP.                                                             "CDX001-0020
    IF sy-subrc = 0.                                                     "CDX001-0020
      l_sh_disabled = 'X'.                                               "CDX001-0020
    ENDIF.                                                               "CDX001-0020
    LOOP AT gt_symbol ASSIGNING <lwa_symbol>                             "CDX001-0020
                      WHERE type <> cs_symbol_type-program
                        AND type <> cs_symbol_type-user.                  "CDX001-0020
      EXIT.                                                              "CDX001-0020
    ENDLOOP.                                                             "CDX001-0020
    IF sy-subrc = 0.                                                     "CDX001-0020
      l_sh_disabled = 'X'.                                               "CDX001-0020
    ENDIF.                                                               "CDX001-0020
    IF me->g_user_settings-symbols_program_show = c_program_symbols_hide.                      "CDX001-0020
* show program symbols                                                 "CDX001-0020
      CLEAR l_button.                                                    "CDX001-0020
      MOVE: 'SYMBOL_P_SHOW'  TO l_button-function,                       "CDX001-0020
          icon_expand        TO l_button-icon,                           "CDX001-0020
          text-q18           TO l_button-quickinfo,                      "CDX001-0020
          0                  TO l_button-butn_type,                      "CDX001-0020
          l_sh_disabled      TO l_button-disabled.                       "CDX001-0020
      APPEND l_button TO e_object->mt_toolbar.                           "CDX001-0020
    ELSE.                                                                "CDX001-0020
* hide program symbols                                                 "CDX001-0020
      CLEAR l_button.                                                    "CDX001-0020
      MOVE: 'SYMBOL_P_HIDE'  TO l_button-function,                       "CDX001-0020
          icon_collapse      TO l_button-icon,                           "CDX001-0020
          text-q19           TO l_button-quickinfo,                      "CDX001-0020
          0                  TO l_button-butn_type,                      "CDX001-0020
          l_sh_disabled      TO l_button-disabled.                       "CDX001-0020
      APPEND l_button TO e_object->mt_toolbar.                           "CDX001-0020
    ENDIF.                                                               "CDX001-0020

* separator                                                            "CDX001-0020
    CLEAR l_button.                                                      "CDX001-0020
    MOVE: 3                TO l_button-butn_type,                        "CDX001-0020
        space              TO l_button-disabled.                         "CDX001-0020
    APPEND l_button TO e_object->mt_toolbar.                             "CDX001-0020

* show only symbols that are used in the editor
    IF me->g_user_settings-only_used_symbols = space.
      CLEAR l_button.
      MOVE: 'SYMBOLS_EDITOR_ONLY'    TO l_button-function,
          icon_filter                TO l_button-icon,
          text-q32                   TO l_button-quickinfo,
          0                          TO l_button-butn_type,
          space                      TO l_button-disabled.
      APPEND l_button TO e_object->mt_toolbar.
    ELSE.
      CLEAR l_button.
      l_button-checked = abap_true.
      MOVE: 'SYMBOLS_ALL'            TO l_button-function,
          icon_filter                TO l_button-icon,
          text-q33                   TO l_button-quickinfo,
          0                          TO l_button-butn_type,
          space                      TO l_button-disabled.
      APPEND l_button TO e_object->mt_toolbar.
    ENDIF.

* separator                                                            "CDX001-0020
    CLEAR l_button.                                                      "CDX001-0020
    MOVE: 3                TO l_button-butn_type,                        "CDX001-0020
        space              TO l_button-disabled.                         "CDX001-0020
    APPEND l_button TO e_object->mt_toolbar.

* create
    CLEAR l_button.
    MOVE: 'SYMBOL_CREATE'    TO l_button-function,
        icon_create        TO l_button-icon,
        text-q15           TO l_button-quickinfo,
        0                  TO l_button-butn_type,
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.

* begin of insert cockpit-294

* separator
    CLEAR l_button.
    MOVE: 3                TO l_button-butn_type,
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.

    CLEAR l_button.
    MOVE: 'SYMBOL_SHARE'    TO l_button-function,
        icon_workflow_external_event TO l_button-icon,
        text-b42           TO l_button-quickinfo,
*        cntb_btype_button  TO l_button-butn_type, "-Cockpit-420
*        cntb_btype_menu TO l_button-butn_type, "-Cockpit-420
        cntb_btype_dropdown TO l_button-butn_type, "+Cockpit-420 KA
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.

* separator
    CLEAR l_button.
    MOVE: 3                TO l_button-butn_type,
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.
* end   of insert cockpit-294

* delete
    MOVE: 'SYMBOL_DELETE'    TO l_button-function,
        icon_delete        TO l_button-icon,
        text-q16           TO l_button-quickinfo,
        0                  TO l_button-butn_type,
        space              TO l_button-disabled.
    APPEND l_button TO e_object->mt_toolbar.
* save
*  CLEAR l_button.                                                     "CDX001-0020
*  MOVE: 'SYMBOL_SAVE'    TO l_button-function,                        "CDX001-0020
*      icon_system_save TO l_button-icon,                              "CDX001-0020
*      text-q17           TO l_button-quickinfo,                       "CDX001-0020
*      0                  TO l_button-butn_type,                       "CDX001-0020
*      space              TO l_button-disabled.                        "CDX001-0020
*  APPEND l_button TO e_object->mt_toolbar.                            "CDX001-0020

  ENDMETHOD.


  METHOD on_symbol_alv_user_command.
****************************************************************************************************
* Description             : on alv symbol user command                                             *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | Sort global/user                            | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
*------------+----------------------+---------------------------------------------+----------------*
* 28.02.2018 | Pat Patil            | Symbol Export                               | Cockpit-294    *
*------------+----------------------+---------------------------------------------+----------------*
* 16.11.2020 | Attila Kajtar        | Sharing: sharing with same user / system!   | Cockpit-420    *
****************************************************************************************************
    DATA  l_symbol LIKE LINE OF gt_symbol.

    DATA  l_celltab LIKE LINE OF l_symbol-cell_style.

    DATA  l_refresh TYPE boolean.

    DATA: l_itab_count TYPE i,
          l_row_id     TYPE lvc_index.

    DATA: lwa_layout      TYPE lvc_s_layo.                                       "CDX001-0020

    DATA: lcl_controller  TYPE REF TO /cadaxo/cl_sqlc_cockpit_main.               """""
    "  DATA: l_sqlcusrp_dyn  TYPE /cadaxo/sqlcusrp_dyn.                              """""

    CREATE OBJECT lcl_controller. """""

    /cadaxo/cl_sqlc_functrace=>add_trace( |ON_SYMBOL_ALV_USER_COMMAND:| && e_ucomm ).

    CASE e_ucomm.

      WHEN 'SYMBOL_CREATE'.
* Show ALL Symbols Mode, before creating new symbol
        me->g_user_settings-only_used_symbols = space.        "CR22-002
        me->get_symbols( ).                                   "CR22-002

        l_symbol-type = cs_symbol_type-create.
*     ALL fields Editable
        l_celltab-fieldname = 'SYMBOL_NAME'.
        l_celltab-style = cl_gui_alv_grid=>mc_style_enabled.
        INSERT l_celltab INTO TABLE l_symbol-cell_style.
        l_celltab-fieldname = 'SYMBOL_VALUE'.
        l_celltab-style = cl_gui_alv_grid=>mc_style_enabled.
        INSERT l_celltab INTO TABLE l_symbol-cell_style.
        l_celltab-fieldname = 'SYMBOL_DESC'.
        l_celltab-style = cl_gui_alv_grid=>mc_style_enabled.
        INSERT l_celltab INTO TABLE l_symbol-cell_style.
        APPEND l_symbol TO gt_symbol.
*     focus new record
        DESCRIBE TABLE gt_symbol LINES l_itab_count.
        l_row_id = l_itab_count.

        l_refresh = abap_true.

      WHEN 'SYMBOL_DELETE'.
        me->delete_symbols( IMPORTING e_success = l_refresh ).

      WHEN 'SYMBOL_SAVE'.
        me->save_symbols( IMPORTING e_success = l_refresh ).
        IF NOT l_refresh IS INITIAL.                                             "CDX001-0020
          me->get_symbols( ).                                                    "CDX001-0020
        ENDIF.                                                                   "CDX001-0020

      WHEN 'SYMBOL_P_HIDE'.                                                      "CDX001-0020
        me->g_user_settings-symbols_program_show = c_program_symbols_hide.       "CDX001-0020
*       refresh symbol ALV                                                     "CDX001-0020
        me->get_symbols( ).                                                      "CDX001-0020
        l_refresh = abap_true.
        me->set_user_settings( EXPORTING i_settings = me->g_user_settings )."CR22-002
      WHEN 'SYMBOL_P_SHOW'.                                                      "CDX001-0020
        me->g_user_settings-symbols_program_show = c_program_symbols_show.       "CDX001-0020
*       refresh symbol ALV                                                     "CDX001-0020
        me->get_symbols( ).                                                      "CDX001-0020
        l_refresh = abap_true.
        me->set_user_settings( EXPORTING i_settings = me->g_user_settings ). "CR22-002                                                       "CDX001-0020
* Only symbols used in Editor
      WHEN 'SYMBOLS_EDITOR_ONLY'.                             "CR22-002
        me->g_user_settings-only_used_symbols = abap_true.          "CR22-002
        me->get_symbols( ).                                   "CR22-002
        l_refresh = abap_true.                                      "CR22-002
        me->set_user_settings( EXPORTING i_settings = me->g_user_settings )."CR22-002
      WHEN 'SYMBOLS_ALL'.                                     "CR22-002
        me->g_user_settings-only_used_symbols = space.        "CR22-002
        me->get_symbols( ).                                   "CR22-002
        l_refresh = abap_true.                                      "CR22-002
        me->set_user_settings( EXPORTING i_settings = me->g_user_settings )."CR22-002

* begin of changes cockpit-294
      WHEN 'SYMBOL_EXPORT'
        OR 'SYMBOL_SHARE'. "Cockpit-420 KA
        me->get_symbols_selected( IMPORTING e_success = l_refresh ).
        IF NOT l_refresh IS INITIAL.
          CALL FUNCTION '/CADAXO/SQLC_SHARE'
            EXPORTING
              iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-symbols
              it_symbols     = gt_symbol_selected.
        ENDIF.
* end   of changes cockpit-294
* begin of insert cockpit-420
      WHEN 'SYMBOL_EXPORT_ME'.
        me->get_symbols_selected( IMPORTING e_success = l_refresh ).
        IF NOT l_refresh IS INITIAL.
          CALL FUNCTION '/CADAXO/SQLC_SHARE'
            EXPORTING
              iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-symbols
              it_symbols     = gt_symbol_selected
              iv_receiver    = CONV /cadaxo/sqlcapi_receiver( sy-uname )
              iv_text        = TEXT-012.
        ENDIF.
* end   of insert cockpit-420
    ENDCASE.

    IF l_refresh = abap_true.

      gc_symbol_alv->get_frontend_layout( IMPORTING es_layout = lwa_layout ).    "CDX001-0020
      lwa_layout-cwidth_opt = 'X'.                                               "CDX001-0020
      gc_symbol_alv->set_frontend_layout( EXPORTING is_layout = lwa_layout ).    "CDX001-0020

      gc_symbol_alv->refresh_table_display(
                       EXPORTING
                         i_soft_refresh = 'X' ).

      IF e_ucomm = 'SYMBOL_CREATE'.
*     focus new record
        CALL METHOD me->focus_symbol_alv_cell
          EXPORTING
            i_row_id     = l_row_id
            i_field_name = 'SYMBOL_NAME'.
      ELSEIF NOT g_curr_col IS INITIAL.                                          "CDX001-0020
        READ TABLE gt_symbol WITH KEY symbol_name = g_curr_row                   "CDX001-0020
                             TRANSPORTING NO FIELDS.                             "CDX001-0020
        l_row_id = sy-tabix.                                                     "CDX001-0020
        CALL METHOD me->focus_symbol_alv_cell                                    "CDX001-0020
          EXPORTING                                                              "CDX001-0020
            i_row_id     = l_row_id                                              "CDX001-0020
            i_field_name = g_curr_col.                                           "CDX001-0020
        CLEAR g_curr_col.                                                        "CDX001-0020
        CLEAR g_curr_row.                                                        "CDX001-0020
      ENDIF.
      CLEAR l_refresh.
    ENDIF.
  ENDMETHOD.


  METHOD on_symbol_button_click.

    DATA: r_symbol_value TYPE rseloption.

    FIELD-SYMBOLS <l_symbol> LIKE LINE OF gt_symbol.

    READ TABLE gt_symbol INDEX es_row_no-row_id ASSIGNING <l_symbol>.

    TRY.
        me->check_symbol_datatype( i_value = CONV #( <l_symbol>-symbol_datatype ) ).

      CATCH /cadaxo/cx_sqlc_symb_not_found INTO DATA(lr_exception).

        MESSAGE lr_exception->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.

        RETURN.

    ENDTRY.

    TRY.
        r_symbol_value = me->show_symbolmulti_dialog( EXPORTING i_symbol_multivalue = <l_symbol>-symbol_multivalue
                                                                i_symbol_datatype   = <l_symbol>-symbol_datatype ).

        " Compress symbol multivalue
        /cadaxo/cl_sqlc_cockpit_assist=>compress_symbol_multivalue( EXPORTING i_symbol_multivalue = r_symbol_value
                                                                    IMPORTING e_data = DATA(lv_data) ).

        <l_symbol>-symbol_multivalue = lv_data.
        <l_symbol>-type = cs_symbol_type-modify.
        me->on_symbol_alv_user_command( e_ucomm = 'SYMBOL_SAVE' ).

      CATCH /cadaxo/cx_sqlc_symb_not_found ##no_handler.
    ENDTRY.
    "ENDIF.
  ENDMETHOD.


  METHOD on_symbol_button_variant.

    DATA: r_symbol_value TYPE rseloption.

    TRY.
        DATA(ls_symbol_ow) = gt_symbol_ow[ es_row_no-row_id ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lr_exception).
        MESSAGE s100(/cadaxo/sqlc) WITH lr_exception->get_text( ) DISPLAY LIKE 'E'.
        RETURN.
    ENDTRY.

    TRY.
        IF es_col_id = 'SYMBOL_TYPE_ICON_VAR' AND ls_symbol_ow-symbol_multivalue_var IS NOT INITIAL.

          r_symbol_value = me->show_symbolmulti_dialog( EXPORTING i_symbol_multivalue = ls_symbol_ow-symbol_multivalue_var
                                                                  i_symbol_datatype   = ls_symbol_ow-symbol_datatype_var ).

        ELSEIF es_col_id = 'SYMBOL_TYPE_ICON_USER' AND ls_symbol_ow-symbol_multivalue_user IS NOT INITIAL.

          r_symbol_value = me->show_symbolmulti_dialog( EXPORTING i_symbol_multivalue = ls_symbol_ow-symbol_multivalue_user
                                                                  i_symbol_datatype   = ls_symbol_ow-symbol_datatype_user ).

        ENDIF.
      CATCH /cadaxo/cx_sqlc_symb_not_found.
    ENDTRY.

  ENDMETHOD.


  METHOD on_symbol_double_click.
****************************************************************************************************
* Description             : on symbol double click                                                 *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_fieldvalue TYPE string,
          l_from_line  TYPE i,
          l_from_pos   TYPE i,
          l_to_line    TYPE i,
          l_to_pos     TYPE i.

    DATA: l_symbol LIKE LINE OF gt_symbol.

    IF me->g_abap_editor_type <> 'A'.
      MESSAGE i041(/cadaxo/sqlc).
      EXIT.
    ENDIF.

    READ TABLE gt_symbol INDEX e_row-index
                         INTO l_symbol
                         TRANSPORTING symbol_name
                                      type.
    IF sy-subrc = 0.
*   only saved symbols can be double clicked
      CHECK l_symbol-type = cs_symbol_type-program OR l_symbol-type = cs_symbol_type-user.

      CONCATENATE '&'
                  l_symbol-symbol_name
                  '&'
                  INTO l_fieldvalue.

      gc_abap_editor->get_selection_pos(  IMPORTING  from_line = l_from_line
                                                     from_pos  = l_from_pos
                                                     to_line   = l_to_line
                                                     to_pos    = l_to_pos
                                          EXCEPTIONS OTHERS    = 1 ).
      IF sy-subrc = 0.

        IF l_from_line <> l_to_line OR
           l_from_pos  <> l_to_pos.

          MESSAGE i005(/cadaxo/sqlc).

        ELSE.

          me->insert_codeblock_at_position(
             iv_line = l_from_line
             iv_pos = l_from_pos
             iv_sqlstring = l_fieldvalue
             i_set_focus = abap_true
          ).

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD on_symbol_drag.
****************************************************************************************************
* Description             : on symbol alv drag                                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lr_drag_object         TYPE REF TO lcl_drag_object.

    DATA  l_fieldvalue TYPE string.

    DATA  l_symbol LIKE LINE OF gt_symbol.

    READ TABLE gt_symbol INDEX e_row-index
                         INTO l_symbol
                         TRANSPORTING symbol_name
                                      type.
    IF sy-subrc = 0.
*   only saved symbols can be dragged
      CHECK l_symbol-type = cs_symbol_type-program OR l_symbol-type = cs_symbol_type-user.

      CONCATENATE '&'
                  l_symbol-symbol_name
                  '&'
             INTO l_fieldvalue.
      CREATE OBJECT lr_drag_object.
      lr_drag_object->fieldvalue = l_fieldvalue.
      e_dragdropobj->object = lr_drag_object.

    ENDIF.

  ENDMETHOD.


  METHOD on_symbol_menu_button.

    IF e_ucomm = 'SYMBOL_SHARE'.

    DATA(lr_menu) = NEW cl_ctmenu( ).

    lr_menu->add_function(
      EXPORTING
        fcode = 'SYMBOL_EXPORT'
        text  = text-b47
        icon  = icon_workflow_external_event
        insert_at_the_top = abap_true
        checked           = abap_true "Cockpit-420 KA
        ).
    lr_menu->add_function(
       EXPORTING
        fcode = 'SYMBOL_EXPORT_ME'
         text = text-b44
        icon  = icon_workflow_internal_event ).

    CALL METHOD e_object->add_menu
      EXPORTING
        menu = lr_menu.

    ENDIF.

  ENDMETHOD.


  METHOD ON_TABBAR_TOOLBAR_FUNCSEL.

    data code type string.
    data number type n length 2.

    split fcode at '_' into code number.

    me->g_active_list_tab = number.

    me->show_result( ).

  ENDMETHOD.


  METHOD on_toolbar_function_selected.
****************************************************************************************************
* Description             : Selection of Toolbar Function                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 03.02.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 11.10.2010 | David Ren            | Add symbol ALV(including user symbols)      | Usersymbols    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    CLEAR g_html_request.

    /cadaxo/cl_sqlc_functrace=>add_trace( |ON_TOOLBAR_FUNCTION_SELECTED:| && fcode ).

    CASE fcode.
      WHEN c_okcode_clipboard.
        set_clipboard_alv( ).

      WHEN 'CLEAR_CLIPBOARD'.
        gc_clipboard_textedit->delete_text( ).

      WHEN c_okcode_symbols.
        CASE me->g_user_settings-symbols_show.
          WHEN abap_true.
            me->g_user_settings-symbols_show = abap_false.
          WHEN abap_false.
            me->g_user_settings-symbols_show = abap_true.
        ENDCASE.
        me->set_user_settings( EXPORTING i_settings = me->g_user_settings )."CR22-002
        set_symbol_alv( ).

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD on_top_toolbar_dropdown.
*static menus only
  ENDMETHOD.


  METHOD on_top_toolbar_funcsel.
****************************************************************************************************
* Description             : on result toolbar function selection                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : Cadaxo GmbH                      *
* Date                    : 03.03.2018                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    IF fcode CS ms_additional_functions-uptomenu->c_cmd_set_upto.                                             "COCKPIT-48

      ms_additional_functions-uptomenu->on_user_command( EXPORTING iv_fcode         = fcode                   "COCKPIT-48
                                                         CHANGING  es_user_settings = ms_user_settings_xml ). "COCKPIT-48

    ELSE.                                                                                                     "COCKPIT-48

      cl_gui_cfw=>set_new_ok_code( fcode ).

    ENDIF.


  ENDMETHOD.


  METHOD pai_0100.

    DATA: lt_table TYPE /cadaxo/sqlccodeline_t.
    DATA: lv_rc    TYPE c  LENGTH 1.

    gc_symbol_alv->check_changed_data(  ).

    CLEAR g_html_request.

    CASE i_ok_code.
      WHEN 'SQLVARSET'.
        me->create_variant( ).
      WHEN 'SQLVARSET_UPD'.                             "Cockpit-321
        me->update_variant( ).                       "Cockpit-321
      WHEN 'SQLVARGET'.
        me->get_variant( ).
*    WHEN 'QUEUE'.       "Show Users Queue           "COCKPIT-233
*      me->usr_action_queue( ).                      "COCKPIT-233
*    WHEN 'SHARE'.                                   "COCKPIT-233
*      me->usr_action_share( ).                      "COCKPIT-233
      WHEN c_cmd_pp.          "Call Pretty Printer
        me->usr_action_pretty_printer( ).
      WHEN 'LEAVE'.       "Leave SQL Cockpit :-(
        me->usr_action_leave_sql_cockpit( ).
      WHEN 'CANCEL'.      "Clear SQL Area
        lt_table = me->get_sql_area_lt_code( ).
        IF NOT lt_table[] IS INITIAL.
          CALL FUNCTION 'POPUP_TO_CONFIRM'
            EXPORTING
              text_question = text-q26
            IMPORTING
              answer        = lv_rc.
          IF lv_rc = '1'.
            me->usr_action_clear_sql_area( ).
          ENDIF.
        ENDIF.
      WHEN 'EXECUTEJOB'.
        me->store_sql_to_hist( ).
        me->execute_sql_background_wiz( ).
      WHEN 'EXECUTE'.
        me->store_sql_to_hist( ).
        me->execute_sql( ).
      WHEN 'SQL_BACK'.    "Go Back
        me->move_back_to_sql( ).
      WHEN 'SQL_FORW'.    "Go Next
        me->move_forw_to_sql( ).
      WHEN 'SYNTCHECK'.   "Syntaxcheck
        TRY.
            me->check_sql_syntax( i_use_local_parser = abap_true ).

            MESSAGE s002(/cadaxo/sqlc).

          CATCH /cadaxo/cx_sqlc_syntax_error.
        ENDTRY.
      WHEN 'HELP'.        "Show Online Documentation
        me->usr_action_show_abap_docu( ).
      WHEN 'MAIL'.        "Send SQL Syntax via Mail
        me->send_sql_via_mail( ).
      WHEN 'PROGRTOOGL'.
        IF g_sql_progress_on IS INITIAL.
          MOVE abap_true TO g_sql_progress_on.
        ELSE.
          CLEAR g_sql_progress_on.
        ENDIF.
      WHEN 'TRACETOGGL'. "Switch SQL Trace ON/OFF
        me->usr_action_sql_trace_onoff( ).
      WHEN 'T_SM30VGRP'. "Edit Variant Groups
        IF NOT me->check_admin_auth( ) IS INITIAL.
          CALL TRANSACTION '/CADAXO/SQLCVGRV'.
        ELSE.
          MESSAGE e036(/cadaxo/sqlc).
        ENDIF.
      WHEN 'T_SM30TEMP'. "Edit Templates
        IF NOT me->check_admin_auth( ) IS INITIAL.
          CALL TRANSACTION '/CADAXO/SQLCTEMV'.
        ELSE.
          MESSAGE e036(/cadaxo/sqlc).
        ENDIF.
      WHEN 'TADMIN'.
        me->call_admin( ).
      WHEN 'T_SE38SHLG'.
        IF NOT me->check_admin_auth( ) IS INITIAL.
          SUBMIT /cadaxo/sqlc_select_log VIA SELECTION-SCREEN AND RETURN.
        ELSE.
          MESSAGE e036(/cadaxo/sqlc).
        ENDIF.
      WHEN 'T_SE38USLG'.
        IF NOT me->check_admin_auth( ) IS INITIAL.
          SUBMIT /cadaxo/sqlc_select_user_log VIA SELECTION-SCREEN AND RETURN.
        ELSE.
          MESSAGE e036(/cadaxo/sqlc).
        ENDIF.
      WHEN 'T_SE38ADMSP'.
        IF NOT me->check_admin_auth( ) IS INITIAL.
          SUBMIT /cadaxo/sqlc_adm_userspacecons VIA SELECTION-SCREEN AND RETURN.
        ELSE.
          MESSAGE e036(/cadaxo/sqlc).
        ENDIF.
      WHEN 'T_DYNSYMB'.
        IF NOT me->check_admin_auth( ) IS INITIAL.
          CALL TRANSACTION '/CADAXO/SQLCDSYM'.
        ELSE.
          MESSAGE e036(/cadaxo/sqlc).
        ENDIF.
      WHEN 'T_HOSTMETH'.
        IF NOT me->check_admin_auth( ) IS INITIAL.
          CALL TRANSACTION '/CADAXO/SQLCHECL'.
        ELSE.
          MESSAGE e036(/cadaxo/sqlc).
        ENDIF.
      WHEN 'T_ROLES'.
        IF NOT me->check_admin_auth( ) IS INITIAL.
          CALL TRANSACTION '/CADAXO/SQLCROLES'.
        ELSE.
          MESSAGE e036(/cadaxo/sqlc).
        ENDIF.
      WHEN 'TCD_ST05'.
* check the authorization of st05
        CALL FUNCTION 'AUTHORITY_CHECK_TCODE'
          EXPORTING
            tcode  = 'ST05'
          EXCEPTIONS
            ok     = 1
            not_ok = 2
            OTHERS = 3.
        CASE sy-subrc.
          WHEN 1.
            CALL TRANSACTION 'ST05'. "#EC CI_CALLTA "call the transaction
          WHEN 2.
            MESSAGE e007(/cadaxo/sqlc).
          WHEN OTHERS.
            MESSAGE e100(/cadaxo/sqlc).
        ENDCASE.
      WHEN 'LOADHOME'. "load home-screen html
        IF NOT me->check_admin_auth( ) IS INITIAL.
          me->load_home_html( ).
        ELSE.
          MESSAGE e036(/cadaxo/sqlc).
        ENDIF.
      WHEN 'ADM_LINK'.
        me->show_admhelp( ).
    ENDCASE.
  ENDMETHOD.


  METHOD pai_0700.
****************************************************************************************************
* Description ....... PAI Module of Dynpro 0700                                                    *
* Developer ......... Domi Bigl                      Date .... 01.11.2010                          *
* Status ............ xxxxxxxxx                                                                    *
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
****************************************************************************************************
* Date       | User              | Description                                       |             *
*------------+-------------------+---------------------------------------------------+-------------*
* <date>     | <developer name>  | <short description>                               |             *
*------------+-------------------+---------------------------------------------------+-------------*
*            |                   |                                                   |             *
*------------+-------------------+---------------------------------------------------+-------------*
*            |                   |                                                   |             *
*------------+-------------------+---------------------------------------------------+-------------*
*            |                   |                                                   |             *
****************************************************************************************************

    CLEAR g_html_request.

    CASE i_ok_code.
*    WHEN 'OVERWRITE'. "Task #3497
*      gr_alv_symb_ow->get_selected_rows( IMPORTING et_row_no = lt_row_no ).
*      LOOP AT lt_row_no ASSIGNING <lwa_row_no>.
*        READ TABLE gt_symbol_ow ASSIGNING <lwa_symbol_ow> INDEX <lwa_row_no>-row_id.
*        IF sy-subrc = 0.
**          <lwa_symbol_ow>-mark = 'X'.
*        ENDIF.
*      ENDLOOP.
*      gr_alv_symb_ow->free( EXCEPTIONS OTHERS = 1 ).
*      gr_cc_alv_symb_ow->free( EXCEPTIONS OTHERS = 1 ).
*      CLEAR gr_alv_symb_ow.
*      CLEAR gr_cc_alv_symb_ow.
*
*      SET SCREEN 0.
*      LEAVE SCREEN.
*    WHEN 'KEEP'. "Task #3497
*      SET SCREEN 0. LEAVE SCREEN.
      WHEN 'SAVE'.
        gr_alv_symb_ow->free( EXCEPTIONS OTHERS = 1 ).
        gr_cc_alv_symb_ow->free( EXCEPTIONS OTHERS = 1 ).
        CLEAR gr_alv_symb_ow.
        CLEAR gr_cc_alv_symb_ow.

        SET SCREEN 0.
        LEAVE SCREEN.
*                ls_symbol_ow-var               = icon_wd_radio_button_empty.
*          ls_symbol_ow-own               = icon_radiobutton.
    ENDCASE.

  ENDMETHOD.


  METHOD pai_0800.
****************************************************************************************************
* Description             : SQL Cockpit - PAI Module for Dynpro 0800                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2015               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxx xxxxx               Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    CASE i_ok_code.
      WHEN 'OK'.

        /cadaxo/cl_sqlc_cockpit_lists=>save_list(
          EXPORTING
            i_cl_sql_parse    = me->gt_cl_sql_parse
            it_result_details = gt_result_details
            it_grid_results   = me->gcont_grid_result_t
            i_sqlcsres        = i_sqlcsres ).

        LEAVE TO SCREEN 0.

      WHEN 'CANC'.

        LEAVE TO SCREEN 0.

    ENDCASE.

  ENDMETHOD.


  METHOD pai_2000.
****************************************************************************************************
* Description             : pai 2000                                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    CLEAR g_html_request.

    CASE i_ok_code.
      WHEN 'OK'.
        SET SCREEN 0. LEAVE SCREEN.
      WHEN 'CANCEL'.
        SET SCREEN 0. LEAVE SCREEN.
    ENDCASE.

  ENDMETHOD.


  METHOD pai_3000.
****************************************************************************************************
* Description             : pai 3000                                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA lv_answer TYPE boolean.
    DATA count TYPE i.

    CLEAR g_html_request.

    CASE i_ok_code.
      WHEN 'OK'.
        SET SCREEN 0. LEAVE SCREEN.
      WHEN 'CANCEL'.
        SET SCREEN 0. LEAVE SCREEN.
      WHEN 'SETTOREAD'.
        gc_alv_queue_3000->get_selected_rows( IMPORTING et_index_rows = DATA(lt_rows) ).
        IF lines( lt_rows ) = 0.
          MESSAGE e144(/cadaxo/sqlc).
        ELSE.
          LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<ls_rows>).
            READ TABLE gt_queue ASSIGNING FIELD-SYMBOL(<ls_queue>) INDEX <ls_rows>-index.
            IF sy-subrc = 0.
              IF <ls_queue>-status = 'R'.
                MESSAGE s147(/cadaxo/sqlc).
              ELSE.
                DATA(lr_api) = /cadaxo/cl_sqlc_cockpit_api=>get_share_factory( iv_id = <ls_queue>-id ).
                lr_api->set_status( iv_new_status = 'R'  ).
                MESSAGE s146(/cadaxo/sqlc).
              ENDIF.
            ENDIF.
          ENDLOOP.

        ENDIF.
      WHEN 'TRASH'.
        gc_alv_queue_3000->get_selected_rows( IMPORTING et_index_rows = lt_rows ).

        IF lines( lt_rows ) = 0.
          MESSAGE e144(/cadaxo/sqlc).
        ELSE.

          CALL FUNCTION 'POPUP_TO_CONFIRM'
            EXPORTING
              titlebar              = text-x02
              text_question         = text-x01
              text_button_1         = text-x03
              icon_button_1         = 'ICON_OKAY'
              text_button_2         = text-x04
              icon_button_2         = 'ICON_CANCEL'
              default_button        = '2'
              display_cancel_button = abap_false
            IMPORTING
              answer                = lv_answer
            EXCEPTIONS
              text_not_found        = 1
              OTHERS                = 2.

          IF lv_answer = 1.

            LOOP AT lt_rows ASSIGNING <ls_rows>.
              READ TABLE gt_queue ASSIGNING <ls_queue> INDEX <ls_rows>-index.
              IF sy-subrc = 0.
                lr_api = /cadaxo/cl_sqlc_cockpit_api=>get_share_factory( iv_id = <ls_queue>-id ).
                lr_api->delete_header_and_positions( ).
                count = count + 1.
              ENDIF.
            ENDLOOP.

            MESSAGE s153(/cadaxo/sqlc) WITH count.
          ENDIF.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD param_replace_tags.
****************************************************************************************************
* Description             : Replace some known tags in data                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_regex           TYPE string.
    DATA: l_langu           TYPE laiso.

* set Version Number
*<VERSIONNR>1.0</VERSIONNR>

    l_regex = '<VERSIONNR>(.*)</VERSIONNR>'.
    REPLACE ALL OCCURRENCES OF REGEX l_regex IN data WITH g_version_nr.

*<VERSIONNR>1.0</VERSIONNR>
    l_regex = '<LANGUAGE>(.*)</LANGUAGE>'.
    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = l_langu.
    REPLACE ALL OCCURRENCES OF REGEX l_regex IN data WITH l_langu.

  ENDMETHOD.


  METHOD pbo_0100.
****************************************************************************************************
* Description             : PBO module of dynpro 0100                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 03.02.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxx             Company    : xxxxxxxxx                        *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

* Create UI Controls
    me->create_controls( ).

  ENDMETHOD.


  METHOD pbo_0700.
****************************************************************************************************
* Description             : pbo 0700                                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 01.11.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lt_fieldcat       TYPE lvc_t_fcat.
    DATA: lwa_layout        TYPE lvc_s_layo.

    FIELD-SYMBOLS: <lwa_fieldcat>       TYPE lvc_s_fcat.

    IF gr_cc_alv_symb_ow IS INITIAL.
* create alv controls
      gr_cc_alv_symb_ow = NEW #( container_name = 'GCONT_ALV_SYMB_OW' ).
      gr_alv_symb_ow = NEW #( i_parent = gr_cc_alv_symb_ow ).
      SET HANDLER me->on_handle_varsym_click FOR gr_alv_symb_ow ACTIVATION abap_true.
      SET HANDLER me->on_symbol_button_variant FOR gr_alv_symb_ow  ACTIVATION abap_true. "+cockpit-294
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name   = '/CADAXO/SQLC_SYMBOL_OW'
          i_bypassing_buffer = abap_true
        CHANGING
          ct_fieldcat        = lt_fieldcat
        EXCEPTIONS
          OTHERS             = 1.

      LOOP AT lt_fieldcat ASSIGNING <lwa_fieldcat>.
        CASE <lwa_fieldcat>-fieldname. "#3497 begin
          WHEN 'VAR'.
            <lwa_fieldcat>-icon       = abap_true.
            <lwa_fieldcat>-hotspot    = abap_true.
            <lwa_fieldcat>-outputlen  = 14.
            <lwa_fieldcat>-fix_column = abap_true.
          WHEN 'OWN'.
            <lwa_fieldcat>-icon       = abap_true.
            <lwa_fieldcat>-hotspot    = abap_true.
            <lwa_fieldcat>-outputlen  = 14.
            <lwa_fieldcat>-fix_column = abap_true.
          WHEN 'SYMBOL_NAME'.
            <lwa_fieldcat>-outputlen  = 16.
            <lwa_fieldcat>-key       = abap_true.
          WHEN 'SYMBOL_VALUE_USER'.
            <lwa_fieldcat>-coltext   = text-a01.
            <lwa_fieldcat>-outputlen  = 20.
          WHEN 'SYMBOL_DESC_USER'.
            <lwa_fieldcat>-coltext   = text-a02.
            <lwa_fieldcat>-key       = abap_true.
            <lwa_fieldcat>-outputlen  = 14.
          WHEN 'SYMBOL_VALUE_VAR'.
            <lwa_fieldcat>-coltext   = text-a03.
            <lwa_fieldcat>-outputlen  = 20.
          WHEN 'SYMBOL_VAR'.
            <lwa_fieldcat>-coltext   = text-a04.
            <lwa_fieldcat>-key       = abap_true.
            <lwa_fieldcat>-outputlen  = 14.
*            begin of insert cockpit-294
          WHEN 'SYMBOL_TYPE_ICON_USER'.
            <lwa_fieldcat>-coltext   = text-a05.
            <lwa_fieldcat>-outputlen  = 4.
            <lwa_fieldcat>-style = cl_gui_alv_grid=>mc_style_button.
          WHEN 'SYMBOL_DATATYPE_USER'.
            <lwa_fieldcat>-coltext   = text-a06.
          WHEN 'SYMBOL_DATATYPE_VAR'.
            <lwa_fieldcat>-coltext   = text-a07.
          WHEN 'SYMBOL_TYPE_ICON_VAR'.
            <lwa_fieldcat>-coltext   = text-a05.
            <lwa_fieldcat>-outputlen  = 4.
            <lwa_fieldcat>-style = cl_gui_alv_grid=>mc_style_button.
*            end   of insert cockpit-294
        ENDCASE.
      ENDLOOP.                                              ""#3497 end

      lwa_layout-zebra      = abap_false.
      lwa_layout-sel_mode   = 'N'.
      lwa_layout-no_toolbar = abap_true.
      lwa_layout-cwidth_opt = abap_true.

      gr_alv_symb_ow->set_table_for_first_display( EXPORTING  i_bypassing_buffer = abap_true
                                                              is_layout          = lwa_layout
                                                   CHANGING   it_outtab          = gt_symbol_ow
                                                              it_fieldcatalog    = lt_fieldcat
                                                   EXCEPTIONS OTHERS             = 1 ).

    ENDIF.
  ENDMETHOD.


  METHOD pbo_0800.

  ENDMETHOD.


  METHOD pbo_2000.

    DATA: lt_fieldcat  TYPE lvc_t_fcat,
          l_lvc_s_layo TYPE lvc_s_layo.

    FIELD-SYMBOLS: <l_fieldcat> TYPE LINE OF lvc_t_fcat.

    IF gcont_alv_template IS INITIAL.

* create template container
      CREATE OBJECT gcont_alv_template
        EXPORTING
          container_name = 'GCONT_ALV_TEMPLATE'.

      CREATE OBJECT gc_alv_template_2000
        EXPORTING
          i_parent = gcont_alv_template.

* create field catalog
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name       = '/CADAXO/SQLCTEMP_ALV'
          i_client_never_display = 'X'
        CHANGING
          ct_fieldcat            = lt_fieldcat[]
        EXCEPTIONS
          inconsistent_interface = 1
          program_error          = 2
          OTHERS                 = 3.
      IF sy-subrc = 0.

* change fieldcatalog
        LOOP AT lt_fieldcat ASSIGNING <l_fieldcat>.
          CASE <l_fieldcat>-fieldname.
            WHEN 'TEMPLATE_NAME'.
              <l_fieldcat>-key        = abap_true.
              <l_fieldcat>-fix_column = abap_true.
          ENDCASE.
        ENDLOOP.

* set alv layout
        CLEAR: l_lvc_s_layo.
        l_lvc_s_layo-no_toolbar = abap_true.
        l_lvc_s_layo-zebra      = abap_true.

* show template alv table
        CALL METHOD gc_alv_template_2000->set_table_for_first_display
          EXPORTING
            i_bypassing_buffer = abap_true
            is_layout          = l_lvc_s_layo
          CHANGING
            it_outtab          = gt_templates
            it_fieldcatalog    = lt_fieldcat
          EXCEPTIONS
            OTHERS             = 4.
        IF sy-subrc = 0.

          SET HANDLER me->on_alv_templ_double_click_2000 FOR gc_alv_template_2000.

        ELSE.
          MESSAGE e100(/cadaxo/sqlc).
        ENDIF.

      ELSE.
        CALL METHOD gc_alv_template_2000->refresh_table_display.
      ENDIF.
    ENDIF.

* save memory
    FREE: lt_fieldcat.

  ENDMETHOD.


  METHOD pbo_3000.
    CONSTANTS lc_style_bold TYPE lvc_style VALUE '00000121'.

    DATA: fieldcats  TYPE lvc_t_fcat.
    DATA: display_fieldcats  TYPE lvc_t_fcat.

* Get own queue
    gt_queue = /cadaxo/cl_sqlc_cockpit_api=>get_own_queue( ).
    "COCKPIT-294
*    SORT gt_queue BY date time DESCENDING.                                                           "COCKPIT-294
    SORT gt_queue BY created DESCENDING.                                                           "COCKPIT-465

    LOOP AT gt_queue ASSIGNING FIELD-SYMBOL(<ls_queue>) WHERE status = /cadaxo/cl_sqlc_cockpit_api=>status-default.
      APPEND INITIAL LINE TO <ls_queue>-celltab ASSIGNING FIELD-SYMBOL(<ls_celltab>).
      <ls_celltab>-style = lc_style_bold.
    ENDLOOP.

    IF gcont_alv_queue IS INITIAL.

      "create template container
      gcont_alv_queue = NEW #( container_name = 'GCONT_ALV_QUEUE' ).

      gc_alv_queue_3000 = NEW #( i_parent = gcont_alv_queue ).

      "create field catalog
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name       = '/CADAXO/SQLCAPI_QUEUE'
          i_client_never_display = abap_true
          i_bypassing_buffer     = abap_true
        CHANGING
          ct_fieldcat            = fieldcats
        EXCEPTIONS
          OTHERS                 = 1.
      IF sy-subrc = 0.

        LOOP AT fieldcats ASSIGNING FIELD-SYMBOL(<fieldcat>).

          IF <fieldcat>-fieldname CS 'POSITION_TYP_I' OR "Icons only
             <fieldcat>-fieldname =  'DESCRIPTION' OR
             <fieldcat>-fieldname =  'DATE' OR
             <fieldcat>-fieldname =  'TIME' OR
             <fieldcat>-fieldname =  'SENDER'.


            IF <fieldcat>-fieldname CS 'POSITION_TYP_ICON'.
              <fieldcat>-icon = abap_true.
            ENDIF.

            "COCKPIT-465
            CASE <fieldcat>-fieldname.
              WHEN 'SENDER'.
                <fieldcat>-outputlen = 10.
              WHEN 'POSITION_TYP_ICONSQL'
                OR 'POSITION_TYP_ICONSYM'
                OR 'POSITION_TYP_ICONVAR'
                OR 'POSITION_TYP_ICONSAL'.
                <fieldcat>-outputlen = 6.
              WHEN 'DESCRIPTION'.
                <fieldcat>-outputlen = 35.
              WHEN 'DATE'.
                <fieldcat>-outputlen = 9.
              WHEN 'TIME'.
                <fieldcat>-outputlen = 7.
              WHEN OTHERS.
            ENDCASE.
            "COCKPIT-465

            APPEND <fieldcat> TO display_fieldcats.

          ENDIF.

        ENDLOOP.

        DATA(alv_layout) = VALUE lvc_s_layo( no_toolbar = abap_true
                                             zebra      = abap_true
*                                             cwidth_opt = abap_true "COCKPIT-465
                                             sel_mode   = 'C'
                                             stylefname = 'CELLTAB' ).

        gc_alv_queue_3000->set_table_for_first_display(
          EXPORTING
            i_bypassing_buffer            = abap_true
            is_layout                     = alv_layout
          CHANGING
            it_outtab                     = gt_queue
            it_fieldcatalog               = display_fieldcats
          EXCEPTIONS
            OTHERS                        = 4 ).

        IF sy-subrc = 0.
          SET HANDLER me->on_alv_queue_double_click_3000 FOR gc_alv_queue_3000.
        ELSE.
          MESSAGE e100(/cadaxo/sqlc).
        ENDIF.

      ELSE.
        gc_alv_queue_3000->refresh_table_display( EXPORTING is_stable = VALUE lvc_s_stbl( row = abap_true col = abap_true  )
                                                            i_soft_refresh = abap_true ).
      ENDIF.

    ELSE.
      gc_alv_queue_3000->refresh_table_display( EXPORTING is_stable = VALUE lvc_s_stbl( row = abap_true col = abap_true  )
                                                          i_soft_refresh = abap_true ).
    ENDIF.

    "save memory
    FREE: fieldcats.

  ENDMETHOD.


  METHOD populate_saved_list.

    SELECT SINGLE *
    FROM /cadaxo/sqlcsres
      INTO @DATA(ls_sqlcsres)
      WHERE list_guid = @iv_list_guid.
    IF sy-subrc EQ 0.

      SELECT SINGLE *
      FROM /cadaxo/sqlcress
        INTO @DATA(ls_sqlcress)
        WHERE ress_guid = @ls_sqlcsres-ress_guid.

      rs_saved_list      = CORRESPONDING #( ls_sqlcress ).
      rs_saved_list      = CORRESPONDING #( BASE ( rs_saved_list ) ls_sqlcsres ).
      rs_saved_list-type = iv_saved_list_shared.

    ENDIF.

  ENDMETHOD.


  METHOD prepare_result_table.

    DATA lr_sqlc_cl_cockpit_parse TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.
    DATA lt_lvc_t_fcat            TYPE lvc_t_fcat.
    DATA l_xml                    TYPE string.
    DATA ls_sqlcresultsave        TYPE /cadaxo/sqlcresultsave.
    DATA lt_sqlcresultsave        TYPE TABLE OF /cadaxo/sqlcresultsave.
    DATA lt_code                  TYPE /cadaxo/sqlccodeline_t.
    DATA ls_result_details        TYPE /cadaxo/sqlcresult_details.
    DATA lt_result_list_raw       TYPE TABLE OF xstring.
    DATA ls_result_list_raw       TYPE xstring.
    DATA lt_saved_lvc_t_fcat      TYPE lvc_t_fcat.
    DATA lt_saved_lvc_t_sort      TYPE lvc_t_sort.
    DATA lt_saved_lvc_t_filt      TYPE lvc_t_filt.
    DATA ls_saved_lvc_s_layo      TYPE lvc_s_layo.
    DATA lv_decimals              TYPE i.
    DATA lv_guid22(22)            TYPE c.
    DATA lv_component             TYPE string.
    DATA l_string                 TYPE string.
    DATA lt_components_domval     TYPE /cadaxo/sqlcparsecomponent_t. "COCKPIT-468
    DATA lt_comp                  TYPE /cadaxo/sqlc_compdesc_t.      "COCKPIT-468
    DATA lt_domval                TYPE /cadaxo/sqlc_domval_t.        "COCKPIT-468
    FIELD-SYMBOLS: <lt_result_table> TYPE ANY TABLE, "STANDARD TABLE.
                   <ls_lvc_t_fcat>   TYPE LINE OF lvc_t_fcat.

    cl_abap_gzip=>decompress_text( EXPORTING gzip_in  = is_sqlcress-rawdata
                                   IMPORTING text_out = l_xml ).

    IF NOT is_sqlcress-editor_sqlstring IS INITIAL.

      IMPORT code TO lt_code FROM DATA BUFFER is_sqlcress-editor_sqlstring.

      me->set_sql_area( i_codelines_t =  lt_code[]  ).

    ENDIF.

    CALL TRANSFORMATION id
      SOURCE XML l_xml
      RESULT result_save = lt_sqlcresultsave.

    FREE: l_xml.

    IMPORT result TO lt_result_list_raw FROM DATA BUFFER is_sqlcress-rawresult.

    LOOP AT lt_sqlcresultsave INTO ls_sqlcresultsave.

      READ TABLE lt_result_list_raw INDEX sy-tabix INTO ls_result_list_raw.

      CREATE OBJECT lr_sqlc_cl_cockpit_parse.


      MOVE: ls_sqlcresultsave-parse-result_ddfields             TO lr_sqlc_cl_cockpit_parse->gt_result_ddfields,
            ls_sqlcresultsave-parse-column_syntax               TO lr_sqlc_cl_cockpit_parse->column_syntax,
            ls_sqlcresultsave-parse-source_syntax               TO lr_sqlc_cl_cockpit_parse->source_syntax,
            ls_sqlcresultsave-parse-where_syntax                TO lr_sqlc_cl_cockpit_parse->where_syntax,
            ls_sqlcresultsave-parse-group_syntax                TO lr_sqlc_cl_cockpit_parse->group_syntax,
            ls_sqlcresultsave-parse-having_syntax               TO lr_sqlc_cl_cockpit_parse->having_syntax,
            ls_sqlcresultsave-parse-order_syntax                TO lr_sqlc_cl_cockpit_parse->order_syntax,
            ls_sqlcresultsave-parse-dbhint_syntax               TO lr_sqlc_cl_cockpit_parse->dbhint_syntax,
            ls_sqlcresultsave-parse-result_source               TO lr_sqlc_cl_cockpit_parse->result_source_t,
            ls_sqlcresultsave-parse-sql_syntax                  TO lr_sqlc_cl_cockpit_parse->sql_syntax,
            ls_sqlcresultsave-parse-connection_syntax           TO lr_sqlc_cl_cockpit_parse->connection_syntax,
            ls_sqlcresultsave-parse-up_to_x_rows                TO lr_sqlc_cl_cockpit_parse->g_up_to_x_rows,
            ls_sqlcresultsave-parse-subquery                    TO lr_sqlc_cl_cockpit_parse->subquery,
            ls_sqlcresultsave-parse-bypassing_buffer            TO lr_sqlc_cl_cockpit_parse->g_bypassing_buffer,
            ls_sqlcresultsave-parse-sql_syntax_without_where    TO lr_sqlc_cl_cockpit_parse->sql_syntax_without_where,
            ls_sqlcresultsave-parse-select_single               TO lr_sqlc_cl_cockpit_parse->g_select_single,
            ls_sqlcresultsave-parse-client_specified            TO lr_sqlc_cl_cockpit_parse->gs_client_handling-client_specified,
            ls_sqlcresultsave-parse-using_client                TO lr_sqlc_cl_cockpit_parse->gs_client_handling-using_client,
            ls_sqlcresultsave-parse-result_fieldcatalog         TO lt_saved_lvc_t_fcat,
            ls_sqlcresultsave-parse-result_sort                 TO lt_saved_lvc_t_sort,
            ls_sqlcresultsave-parse-result_filt                 TO lt_saved_lvc_t_filt,
            ls_sqlcresultsave-parse-result_layo                 TO ls_saved_lvc_s_layo, "#4170
            ls_sqlcresultsave-parse-components_domval           TO lt_components_domval, "COCKPIT-468
            ls_sqlcresultsave-parse-comp                        TO lt_comp,              "COCKPIT-468
            ls_sqlcresultsave-parse-domval                      TO lt_domval.            "COCKPIT-468
      MOVE abap_true TO lr_sqlc_cl_cockpit_parse->g_saved_list.

* NEW Start
      DATA l_result_ddfields LIKE LINE OF ls_sqlcresultsave-parse-result_ddfields.
      DATA lr_data TYPE REF TO data.
      DATA: l_sql_abap_componentdescr TYPE abap_componentdescr.
      DATA(tabix) = 1.                                            "COCKPIT-468

      LOOP AT ls_sqlcresultsave-parse-result_ddfields INTO l_result_ddfields.

        CLEAR lr_data.

        l_result_ddfields-inttype = to_lower(  l_result_ddfields-inttype ).

* Begin RT145
        IF l_result_ddfields-aggr = 'SUM('.
          CASE l_result_ddfields-datatype.
            WHEN 'CURR' OR 'DEC' OR 'QUAN'.
              lv_decimals = l_result_ddfields-decimals.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_p( p_length = 16 p_decimals = lv_decimals ).
            WHEN 'INT1' OR 'INT2' OR 'INT4'.
              l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_i( ).
            WHEN OTHERS.
              l_sql_abap_componentdescr-type ?= cl_abap_typedescr=>describe_by_name( l_sql_abap_componentdescr-name ).
          ENDCASE.
        ELSE.
* End RT145
          "COCKPIT-468
          lr_data = /cadaxo/cl_sqlc_cockpit_assist=>create_data_reference(
            EXPORTING
              iv_inttype           = l_result_ddfields-inttype
              iv_leng              = l_result_ddfields-leng
              iv_decimals          = l_result_ddfields-decimals
              iv_intlen            = l_result_ddfields-intlen
              iv_stru_name         = l_result_ddfields-stru_name
              iv_tabix             = tabix
              iv_domaintext        = me->g_user_settings-domaintext
              it_components_domval = lt_components_domval
              it_comp              = lt_comp
              it_domval            = lt_domval  ).
          "COCKPIT-468
          IF lr_data IS NOT INITIAL.
            l_sql_abap_componentdescr-type ?= cl_abap_typedescr=>describe_by_data_ref( lr_data )."RT145
          ENDIF.
        ENDIF.

        IF l_result_ddfields-tabname <> space AND l_result_ddfields-fieldname <> space."CDX-RT138
          CONCATENATE l_result_ddfields-tabname '-'
                      l_result_ddfields-fieldname
                      INTO l_sql_abap_componentdescr-name.
        ELSEIF l_result_ddfields-tabname <> space.        "CDX-RT138
          MOVE l_result_ddfields-tabname TO l_sql_abap_componentdescr-name."CDX-RT138
        ELSE.                                             "CDX-RT138
          MOVE l_result_ddfields-fieldname TO l_sql_abap_componentdescr-name."CDX-RT138
        ENDIF.                                            "CDX-RT138

        READ TABLE lr_sqlc_cl_cockpit_parse->result_component_t
             WITH KEY name = l_sql_abap_componentdescr-name TRANSPORTING NO FIELDS.
        IF sy-subrc = 0 OR strlen( l_sql_abap_componentdescr-name ) GT 30.
          IF l_result_ddfields-map_fieldname IS INITIAL.  "RT377
            DO.
              TRY.
                  CALL METHOD ('CL_SYSTEM_UUID')=>('CREATE_UUID_C22_STATIC')
                    RECEIVING
                      uuid = lv_guid22.
                CATCH cx_root.
                  CALL FUNCTION 'GUID_CREATE'
                    IMPORTING
                      ev_guid_22 = lv_guid22.
              ENDTRY.
              TRANSLATE lv_guid22 TO UPPER CASE.
              REPLACE ALL OCCURRENCES OF '}' IN lv_guid22 WITH 'A'.
              REPLACE ALL OCCURRENCES OF '{' IN lv_guid22 WITH 'B'.
* check for existing "GUID" caused by case-sensetivity of CHAR22 GUIDs
              IF NOT line_exists( lr_sqlc_cl_cockpit_parse->result_component_t[ name = lv_guid22 ] ).
                EXIT.
              ENDIF.
            ENDDO.

            "RT337 BEGIN
            READ TABLE lt_saved_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = l_sql_abap_componentdescr-name."RT377
            IF sy-subrc = 0.                              "RT377
              <ls_lvc_t_fcat>-fieldname = lv_guid22.      "RT377
            ELSE.                                         "RT377
              SPLIT l_sql_abap_componentdescr-name AT '-' INTO l_string l_sql_abap_componentdescr-name."RT377
              READ TABLE lt_saved_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = l_sql_abap_componentdescr-name."RT377
              IF sy-subrc = 0.                            "RT377
                <ls_lvc_t_fcat>-fieldname = lv_guid22.    "RT377
              ENDIF.                                      "RT377
            ENDIF.

            l_sql_abap_componentdescr-name = lv_guid22.

          ELSE.                                           "RT377

            l_sql_abap_componentdescr-name = l_result_ddfields-map_fieldname."RT377

          ENDIF.

        ENDIF.

        APPEND l_sql_abap_componentdescr TO lr_sqlc_cl_cockpit_parse->result_component_t.
        "COCKPIT-468
        tabix = tabix + 1.
        DATA lr_data_domval TYPE REF TO data.
        IF me->g_user_settings-domaintext EQ abap_true.
          READ TABLE lt_domval WITH KEY name = l_sql_abap_componentdescr-name INTO DATA(ls_domval).
          IF sy-subrc EQ 0.
            l_sql_abap_componentdescr-name = ls_domval-name_desc.
            CREATE DATA lr_data_domval TYPE c LENGTH 60.
            IF lr_data_domval IS NOT INITIAL.
              l_sql_abap_componentdescr-type ?= cl_abap_typedescr=>describe_by_data_ref( lr_data_domval ).
            ENDIF.
            APPEND l_sql_abap_componentdescr TO lr_sqlc_cl_cockpit_parse->result_component_t.
            tabix = tabix + 1.
          ENDIF.
        ENDIF.
        "COCKPIT-468
      ENDLOOP.

* NEW End


* create fieldcatalog
      IF lt_saved_lvc_t_fcat[] IS INITIAL.
        lr_sqlc_cl_cockpit_parse->create_alv_field_catalog(
                            EXPORTING i_user_settings = me->g_user_settings
                                      i_dragdrop_handle = dragdrop_handle
                            RECEIVING r_lvc_t_fcat = lt_lvc_t_fcat ).
      ELSE.
        lt_lvc_t_fcat = lt_saved_lvc_t_fcat.
      ENDIF.

      "CDX-RT138...insert begin
      "creation alv-itab for results (just the empty itab)

      lr_sqlc_cl_cockpit_parse->create_result_structures( EXPORTING i_mode = 'S' ). "S = Saved Lists

      ASSIGN lr_sqlc_cl_cockpit_parse->result_table->* TO <lt_result_table>.

      IF lt_saved_lvc_t_sort IS NOT INITIAL.
        lt_saved_lvc_t_sort = /cadaxo/cl_sqlc_cockpit_main=>match_saved_sort( it_sort    = lt_saved_lvc_t_sort
                                                                              i_tabname  = l_result_ddfields-tabname
                                                                              it_result_table = <lt_result_table> ).
      ENDIF.

      IF lt_saved_lvc_t_filt IS NOT INITIAL.
        lt_saved_lvc_t_filt = /cadaxo/cl_sqlc_cockpit_main=>match_saved_filter( it_filter    = lt_saved_lvc_t_filt
                                                                                i_tabname  = l_result_ddfields-tabname
                                                                                it_result_table = <lt_result_table> ).

      ENDIF.
      "CDX-RT138...insert end

* INS #4092 - BEGIN "20131024
      IF lt_lvc_t_fcat IS NOT INITIAL.
        lt_lvc_t_fcat = /cadaxo/cl_sqlc_cockpit_main=>match_saved_fieldcat_orig( it_fcat    = lt_lvc_t_fcat
                                                                                 i_tabname  = l_result_ddfields-tabname
                                                                                 it_result_table = <lt_result_table> ).
      ENDIF.
* INS #4092 - END "20131024

* update fieldcatalog - header (based on user settings)
      IF lt_lvc_t_fcat IS NOT INITIAL.
        LOOP AT ls_sqlcresultsave-parse-result_ddfields INTO l_result_ddfields.
          UNASSIGN <ls_lvc_t_fcat>.

          IF l_result_ddfields-tabname IS NOT INITIAL AND l_result_ddfields-fieldname IS NOT INITIAL.
            CONCATENATE l_result_ddfields-tabname
                        l_result_ddfields-fieldname
                   INTO lv_component
                   SEPARATED BY '-'.
          ELSEIF l_result_ddfields-tabname IS NOT INITIAL.
            lv_component = l_result_ddfields-tabname.
          ELSE.
            lv_component = l_result_ddfields-fieldname.
          ENDIF.

          READ TABLE lt_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = l_result_ddfields-map_fieldname.
          IF sy-subrc <> 0.
            READ TABLE lt_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = l_result_ddfields-fieldname.
            IF sy-subrc <> 0.
              READ TABLE lt_lvc_t_fcat  ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = lv_component.
            ENDIF.
          ENDIF.

          IF <ls_lvc_t_fcat> IS ASSIGNED.

            /cadaxo/cl_sqlc_cockpit_assist=>map_ddfields_descr_to_fcat(
              EXPORTING
                is_dfies         = l_result_ddfields
                is_user_settings = g_user_settings
              CHANGING
                cs_fcat          = <ls_lvc_t_fcat> ).

          ENDIF.

        ENDLOOP.
      ENDIF.

* dragdrop_handle
      LOOP AT lt_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WHERE dragdropid IS INITIAL.
        <ls_lvc_t_fcat>-dragdropid = dragdrop_handle.
      ENDLOOP.

* set the use of the convertion exit
      IF g_user_settings-use_convexit IS INITIAL.
        LOOP AT lt_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat>.
          MOVE 'X' TO <ls_lvc_t_fcat>-no_convext.
        ENDLOOP.
      ENDIF.

      "CDX-RT138...delete begin
*        lr_sqlc_cl_cockpit_parse->create_result_structures( EXPORTING i_mode = 'S' ). "S = Saved Lists
*
*        ASSIGN lr_sqlc_cl_cockpit_parse->result_table->* TO <lt_result_table>.
      "CDX-RT138...delete end

*    IMPORT result TO <lt_result_table> FROM DATA BUFFER ls_sqlcresultsave-main-result_list.

      cl_abap_gzip=>decompress_binary( EXPORTING gzip_in = ls_result_list_raw
                                       IMPORTING raw_out = ls_result_list_raw ).
      TRY.
          IMPORT result TO <lt_result_table>[] FROM DATA BUFFER ls_result_list_raw IGNORING STRUCTURE BOUNDARIES.
*        CATCH cx_sy_import_mismatch_error.
        CATCH cx_sy_import_mismatch_error INTO DATA(ref). "COCKPIT-468
          DATA(err_telo) = ref->get_longtext( ).          "COCKPIT-468
          DATA(err_text) = ref->get_text( ).              "COCKPIT-468
      ENDTRY.

      FREE: ls_result_list_raw.

      IF lr_sqlc_cl_cockpit_parse->gt_lvc_t_fcat IS INITIAL.
        APPEND LINES OF lt_lvc_t_fcat TO lr_sqlc_cl_cockpit_parse->gt_lvc_t_fcat.
      ENDIF.

      APPEND lr_sqlc_cl_cockpit_parse TO gt_cl_sql_parse.
      APPEND lt_lvc_t_fcat TO gt_lvc_t_fcat.
      APPEND lt_saved_lvc_t_sort TO gt_lvc_t_sort.
      APPEND lt_saved_lvc_t_filt TO gt_lvc_t_filt.
      "APPEND ls_saved_lvc_s_layo TO gt_lvc_s_layo.        "#4170 "$004
      APPEND lr_sqlc_cl_cockpit_parse->result_table TO dref_result_tab_t.

      MOVE: ls_sqlcresultsave-main-result_details TO ls_result_details.
      MOVE-CORRESPONDING: is_sqlcsres TO ls_result_details.
      ls_result_details-saved_list = abap_true.           "RT244
      APPEND ls_result_details TO me->gt_result_details.

    ENDLOOP.

  ENDMETHOD.


  METHOD save_clipboard.
****************************************************************************************************
* Description ....... Save the content of the clipboard                                            *
* Developer ......... Johann FÃƒÂ¶ÃƒÅ¸leitner       Date .... 03.02.2010                                 *
* Status ............ xxxxxxxxx                                                                    *                                                                                                  *
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2010                                                             *
****************************************************************************************************
* Date       | User              | Description                                       |             *
*------------+-------------------+---------------------------------------------------+-------------*
* <date>     | <developer name>  | <short description>                               |             *
*------------+-------------------+---------------------------------------------------+-------------*
*            |                   |                                                   |             *
*------------+-------------------+---------------------------------------------------+-------------*
*            |                   |                                                   |             *
*------------+-------------------+---------------------------------------------------+-------------*
*            |                   |                                                   |             *
****************************************************************************************************
    DATA: lt_text       TYPE STANDARD TABLE OF text255,
          l_string      TYPE string,
          l_stringx     TYPE xstring,
          l_sql_usrpref TYPE /cadaxo/sqlcusrp,
          lr_convout    TYPE REF TO cl_abap_conv_out_ce.

    DATA l_text_modified TYPE i.

    FIELD-SYMBOLS: <l_text_line> TYPE any.

    gc_clipboard_textedit->get_textmodified_status(
      IMPORTING
        status                 = l_text_modified
      EXCEPTIONS
        error_cntl_call_method = 1
        OTHERS                 = 2 ).

    IF sy-subrc = 0 AND l_text_modified = 1.

* get the text as stream
      gc_clipboard_textedit->get_text_as_stream(
        IMPORTING
          text                   = lt_text
        EXCEPTIONS
          error_dp               = 1
          error_cntl_call_method = 2
          OTHERS                 = 3 ).

      IF sy-subrc = 0 AND me->gt_clipboard[] <> lt_text[].

* convert the table into string
        LOOP AT lt_text ASSIGNING <l_text_line>.
          SHIFT <l_text_line> LEFT DELETING LEADING space.
          CONCATENATE l_string <l_text_line> cl_abap_char_utilities=>cr_lf INTO l_string.
        ENDLOOP.

        lr_convout = cl_abap_conv_out_ce=>create( ).
        lr_convout->convert( EXPORTING data   = l_string
                             IMPORTING buffer = l_stringx ).

* zip the data
        TRY.
            cl_abap_gzip=>compress_binary( EXPORTING raw_in   = l_stringx
                                           IMPORTING gzip_out = l_stringx ).
          CATCH cx_parameter_invalid_range .
          CATCH cx_sy_buffer_overflow .
        ENDTRY.

        SELECT SINGLE * FROM /cadaxo/sqlcusrp INTO l_sql_usrpref WHERE uname = sy-uname.
        IF sy-subrc = 0.

          l_sql_usrpref-clipboard = l_stringx.
          UPDATE /cadaxo/sqlcusrp SET clipboard = l_sql_usrpref-clipboard WHERE uname = sy-uname.

        ELSE.

          l_sql_usrpref-uname     = sy-uname.
          l_sql_usrpref-clipboard = l_stringx.

          INSERT  /cadaxo/sqlcusrp FROM l_sql_usrpref.

        ENDIF.

        gc_clipboard_textedit->set_textmodified_status( EXPORTING status = 0 ).

        me->gt_clipboard[] = lt_text[].
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD save_hold_lists.

    DATA l_index TYPE i.

    CLEAR gt_cl_sql_parse_hold.
    CLEAR gt_result_tab_hold.
    CLEAR gt_lvc_t_fcat_hold.
    CLEAR gt_result_details_hold.

    LOOP AT gt_cl_sql_parse ASSIGNING FIELD-SYMBOL(<lr_cl_sql_parse>).
      l_index = sy-tabix.
      IF <lr_cl_sql_parse>->g_hold_result <> ''.
        APPEND <lr_cl_sql_parse> TO gt_cl_sql_parse_hold.
        READ TABLE dref_result_tab_t INDEX l_index ASSIGNING FIELD-SYMBOL(<ls_result_tab>).
        IF sy-subrc = 0.
          APPEND <ls_result_tab> TO gt_result_tab_hold.
        ENDIF.
        READ TABLE gt_lvc_t_fcat INDEX l_index ASSIGNING FIELD-SYMBOL(<ls_lvc_s_fcat>).
        IF sy-subrc = 0.
          APPEND <ls_lvc_s_fcat> TO gt_lvc_t_fcat_hold.
        ENDIF.
        READ TABLE gt_result_details INDEX l_index ASSIGNING FIELD-SYMBOL(<ls_result_details>).
        IF sy-subrc = 0.
          APPEND <ls_result_details> TO gt_result_details_hold.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD save_symbols.
****************************************************************************************************
* Description             : save symbols                                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : David Ren                Company    : MDL                              *
* Date                    : 11.10.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.11.2010 | Domi Bigl            | I18N Messages                               | CDX001-0020    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 17.07.2017 | Harald Wiesinger     | Symbole prÃƒÂ¼fen vor dem speichern            | COCKPIT-204    *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_symbol LIKE LINE OF gt_symbol[].
    DATA lt_symbol_create_compare LIKE TABLE OF l_symbol-symbol_name.
    DATA l_tabix TYPE lvc_index.
    DATA lt_symbol_db_create TYPE TABLE OF /cadaxo/sqlcusym.
    DATA lt_symbol_db_update LIKE lt_symbol_db_create.
    DATA l_symbol_db LIKE LINE OF lt_symbol_db_create.
    DATA l_db_commit TYPE boolean.
    DATA l_count TYPE i.
    DATA l_curr_row TYPE i.                                          "CDX001-0020
    DATA l_curr_col_id TYPE lvc_s_col.                                  "CDX001-0020
    DATA l_values_count TYPE i.

    FIELD-SYMBOLS: <l_symbol>     LIKE LINE OF gt_symbol,
                   <l_cell_style> LIKE LINE OF <l_symbol>-cell_style.


    gc_symbol_alv->get_current_cell( IMPORTING e_row     = l_curr_row            "CDX001-0020
                                               es_col_id = l_curr_col_id ).      "CDX001-0020
    READ TABLE gt_symbol ASSIGNING <l_symbol> INDEX l_curr_row.                  "CDX001-0020
    IF sy-subrc = 0.                                                             "CDX001-0020
      g_curr_col = l_curr_col_id-fieldname.                                      "CDX001-0020
      g_curr_row = <l_symbol>-symbol_name.                                       "CDX001-0020
    ENDIF.                                                                       "CDX001-0020

* get each itab record by type
* exclude program symbols
    LOOP AT gt_symbol INTO l_symbol WHERE NOT type = cs_symbol_type-program.

      l_tabix = sy-tabix.
*   only dealed user symbols consider
      CASE l_symbol-type.
        WHEN cs_symbol_type-create.
*       create check(4 point)
*       1. obligatory check(symbol name and symbol value)
*       symbol name
          IF l_symbol-symbol_name IS INITIAL.
*         focus the record
            me->focus_symbol_alv_cell( i_row_id     = l_tabix
                                       i_field_name = 'SYMBOL_NAME' ).

            MESSAGE s050(/cadaxo/sqlc) DISPLAY LIKE 'E'.               "CDX001-0020
            RETURN.
          ENDIF.
*       symbol value
          IF l_symbol-symbol_value IS INITIAL.
            MESSAGE s051(/cadaxo/sqlc) DISPLAY LIKE 'W'.
          ENDIF.
*       2. same name in create symbols check
          READ TABLE lt_symbol_create_compare WITH KEY table_line = l_symbol-symbol_name
                                              TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
*         focus the record
            CALL METHOD me->focus_symbol_alv_cell
              EXPORTING
                i_row_id     = l_tabix
                i_field_name = 'SYMBOL_NAME'.

            MESSAGE s052(/cadaxo/sqlc) WITH l_symbol-symbol_name DISPLAY LIKE 'E'."CDX001-0020

            RETURN.

          ENDIF.

          APPEND l_symbol-symbol_name TO lt_symbol_create_compare.
*       3. same name in delete symbols
          READ TABLE gt_symbol_delete WITH KEY symbol_name = l_symbol-symbol_name
                                      TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
*         focus the record
            CALL METHOD me->focus_symbol_alv_cell
              EXPORTING
                i_row_id     = l_tabix
                i_field_name = 'SYMBOL_NAME'.

            MESSAGE s053(/cadaxo/sqlc) WITH l_symbol-symbol_name DISPLAY LIKE 'E'."CDX001-0020

            RETURN.

          ENDIF.
*       4. same name in exist symbols check( check backup )
*       first check program symbol
          SELECT SINGLE COUNT(*) FROM /cadaxo/sqlcsymb
                                 INTO l_count
                                 WHERE symbol = l_symbol-symbol_name . "#EC CI_BYPASS "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED
          IF l_count = 1.

            CLEAR l_count.
*         focus the record
            CALL METHOD me->focus_symbol_alv_cell
              EXPORTING
                i_row_id     = l_tabix
                i_field_name = 'SYMBOL_NAME'.

            MESSAGE s054(/cadaxo/sqlc) WITH l_symbol-symbol_name DISPLAY LIKE 'E'."CDX001-0020

            RETURN.

          ELSE.
*         then check user symbol with username
            SELECT SINGLE COUNT(*) FROM /cadaxo/sqlcusym
                                 INTO l_count
                                 WHERE symbol_name = l_symbol-symbol_name
                                   AND username = sy-uname. "#EC CI_BYPASS "#EC CI_SEL_NESTED "#EC CI_SROFC_NESTED
            IF l_count = 1.

              CLEAR l_count.
*           focus the record
              CALL METHOD me->focus_symbol_alv_cell
                EXPORTING
                  i_row_id     = l_tabix
                  i_field_name = 'SYMBOL_NAME'.

              MESSAGE s054(/cadaxo/sqlc) WITH l_symbol-symbol_name DISPLAY LIKE 'E'."CDX001-0020

              RETURN.

            ENDIF.

          ENDIF.

          MOVE-CORRESPONDING l_symbol TO l_symbol_db.
          l_symbol_db-username = sy-uname.

          APPEND l_symbol_db TO lt_symbol_db_create.
          CLEAR l_symbol_db.

        WHEN cs_symbol_type-modify.
*       check wheter symbol value is empty
          IF l_symbol-symbol_value IS INITIAL.
            MESSAGE s051(/cadaxo/sqlc) DISPLAY LIKE 'W'.
          ENDIF.

          IF l_symbol-symbol_multivalue IS NOT INITIAL.
            l_values_count = get_user_symbol_count( i_symbol_multivalue = l_symbol-symbol_multivalue ).
            l_symbol-symbol_value = '<' && l_values_count &&' VALUES' && '>'.
          ENDIF.

          MOVE-CORRESPONDING l_symbol TO l_symbol_db.
          l_symbol_db-username = sy-uname.

          APPEND l_symbol_db TO lt_symbol_db_update.
          CLEAR l_symbol_db.

      ENDCASE.

    ENDLOOP.

* start db change
* delete
    DATA(l_db_commit_del) = me->delete_symbol_db( ).                                                        "COCKPIT-204
* update
    DATA(l_db_commit_upd) = me->update_symbol_db( EXPORTING it_symbol_update = lt_symbol_db_update ).       "COCKPIT-204
* create
    DATA(l_db_commit_cre) = me->create_symbol_db( EXPORTING it_symbol_create = lt_symbol_db_create ).       "COCKPIT-204
    IF l_db_commit_del IS NOT INITIAL OR l_db_commit_upd IS NOT INITIAL OR l_db_commit_cre IS NOT INITIAL.  "COCKPIT-204
      l_db_commit = abap_true.                                                                              "COCKPIT-204
    ENDIF.                                                                                                  "COCKPIT-204

    IF l_db_commit = 'X'.
*   change type of gt_symbol records
      LOOP AT gt_symbol ASSIGNING <l_symbol> WHERE type = cs_symbol_type-create
                                                OR type = cs_symbol_type-modify.

        IF <l_symbol>-type = cs_symbol_type-create.
*       change SYMBOL_NAME non-editable
          READ TABLE <l_symbol>-cell_style WITH KEY fieldname = 'SYMBOL_NAME'
                                            ASSIGNING <l_cell_style>.
          IF sy-subrc = 0.

            <l_cell_style>-style = cl_gui_alv_grid=>mc_style_disabled.

          ENDIF.

        ENDIF.

        <l_symbol>-type = cs_symbol_type-user.

      ENDLOOP.
*   show successful message
      MESSAGE s056(/cadaxo/sqlc).
      e_success = abap_true.

    ELSE.
      CLEAR e_success.
    ENDIF.

  ENDMETHOD.


  METHOD select_jobdata.
****************************************************************************************************
* Description             : SQL Cockpit - Select the jobs of the user                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 16.04.2011                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 24.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add EndTime & EndDate to Jobmonitor         | CDX130-002     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Bugfix - create date/time timestampconvers. | CDX130-003     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add nr. of selects to monitor             . | CDX130-004     *
*------------+----------------------+---------------------------------------------+----------------*
* 19.09.2014 | Harald Wiesinger     | Jobmonitor                                  |CDX22-003,CL4660*
*            |                      |                                             |                *
****************************************************************************************************

    DATA lt_sql_sres            TYPE TABLE OF /cadaxo/sqlcsres.
    DATA l_sqlcjobsalv          TYPE /cadaxo/sqlcjobsalv.
    DATA ls_tbtco               TYPE tbtco.
    DATA ls_lvc_s_styl          TYPE lvc_s_styl.
    DATA ls_lvc_s_scol          TYPE lvc_s_scol.
    DATA l_syst_timezone        TYPE tznzonesys.
    DATA l_timestamp            TYPE timestamp.
    CLEAR: gt_jobs.

    MESSAGE s065(/cadaxo/sqlc) INTO g_progress_indicator_msg.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        text = g_progress_indicator_msg.

* select the (userspecific) jobs from database
    SELECT * FROM /cadaxo/sqlcsres INTO TABLE lt_sql_sres WHERE uname = sy-uname
             AND create_timestamp BETWEEN g_sel_job_timestamp_from AND g_sel_job_timestamp_to
             AND type = 'JOB'.

    LOOP AT lt_sql_sres ASSIGNING FIELD-SYMBOL(<l_sqlcsres>).

      CLEAR: l_sqlcjobsalv.

      MOVE: <l_sqlcsres>-uname            TO l_sqlcjobsalv-uname,
            <l_sqlcsres>-jobname          TO l_sqlcjobsalv-jobname,
            <l_sqlcsres>-jobcount         TO l_sqlcjobsalv-jobcount,
            <l_sqlcsres>-list_guid        TO l_sqlcjobsalv-list_guid,
            <l_sqlcsres>-ress_guid        TO l_sqlcjobsalv-ress_guid,
            <l_sqlcsres>-nr_of_selects    TO l_sqlcjobsalv-nr_of_selects."CDX130-004

* convert timestamp to output format
      CONVERT TIME STAMP <l_sqlcsres>-create_timestamp TIME ZONE sy-zonlo"CDX130-003
              INTO DATE l_sqlcjobsalv-create_date TIME l_sqlcjobsalv-create_time.

* get jobdetails
      SELECT SINGLE enddate, endtime, status
         FROM tbtco INTO CORRESPONDING FIELDS OF @ls_tbtco
            WHERE jobname = @l_sqlcjobsalv-jobname
              AND jobcount = @l_sqlcjobsalv-jobcount.
      IF sy-subrc = 0.

        MOVE: ls_tbtco-enddate TO l_sqlcjobsalv-end_date,     "CDX130-002
              ls_tbtco-endtime TO l_sqlcjobsalv-end_time.     "CDX130-002

* convert timestamp to output format
        SELECT SINGLE tzonesys FROM ttzcu INTO l_syst_timezone.
        IF sy-subrc = 0.
          CONVERT DATE ls_tbtco-enddate
                  TIME ls_tbtco-endtime INTO TIME STAMP l_timestamp TIME ZONE l_syst_timezone.

          CONVERT TIME STAMP l_timestamp TIME ZONE sy-zonlo INTO DATE l_sqlcjobsalv-end_date
                                                                 TIME l_sqlcjobsalv-end_time.
        ENDIF.

        CASE ls_tbtco-status.
          WHEN 'F'. "Finished
            MOVE text-stf TO l_sqlcjobsalv-jobstatus.
            ls_lvc_s_scol-fname = 'JOBSTATUS'.
            ls_lvc_s_scol-color-col = '5'.
            APPEND ls_lvc_s_scol TO l_sqlcjobsalv-ct_col.
          WHEN 'P'. "Scheduled
            CLEAR: l_sqlcjobsalv-end_date, l_sqlcjobsalv-end_time. "# 4660 - 20140919
            MOVE text-stp TO l_sqlcjobsalv-jobstatus.
          WHEN 'S'. "Released
            CLEAR: l_sqlcjobsalv-end_date, l_sqlcjobsalv-end_time. "# 4660 - 20140919
            MOVE text-sts TO l_sqlcjobsalv-jobstatus.
          WHEN 'R'. "Running
            CLEAR: l_sqlcjobsalv-end_date, l_sqlcjobsalv-end_time. "# 4660 - 20140919
            MOVE text-str TO l_sqlcjobsalv-jobstatus.
            ls_lvc_s_scol-fname = 'JOBSTATUS'.
            ls_lvc_s_scol-color-col = '5'.
            APPEND ls_lvc_s_scol TO l_sqlcjobsalv-ct_col.
          WHEN 'A'. "Canceled
            MOVE text-stc TO l_sqlcjobsalv-jobstatus.
            ls_lvc_s_scol-fname = 'JOBSTATUS'.
            ls_lvc_s_scol-color-col = '6'.
            APPEND ls_lvc_s_scol TO l_sqlcjobsalv-ct_col.
          WHEN OTHERS.
        ENDCASE.

        ls_lvc_s_styl-fieldname = 'JOBNAME'.
        ls_lvc_s_styl-style     = cl_gui_alv_grid=>mc_style_hotspot.
        APPEND ls_lvc_s_styl TO l_sqlcjobsalv-ct.

      ELSE.
        MOVE text-stu TO l_sqlcjobsalv-jobstatus.
        ls_lvc_s_scol-fname = 'JOBSTATUS'.
        ls_lvc_s_scol-color-col = '7'.
        APPEND ls_lvc_s_scol TO l_sqlcjobsalv-ct_col.
      ENDIF.

      IF NOT l_sqlcjobsalv-ress_guid IS INITIAL.
        MOVE    '@3W@'                        TO l_sqlcjobsalv-jobresult.
        ls_lvc_s_styl-fieldname = 'JOBRESULT'.
        ls_lvc_s_styl-style     = cl_gui_alv_grid=>mc_style_button.
        APPEND ls_lvc_s_styl TO l_sqlcjobsalv-ct.
      ENDIF.

      l_sqlcjobsalv-space_consuming = <l_sqlcsres>-space_cons_zip.

      APPEND l_sqlcjobsalv TO gt_jobs.
    ENDLOOP.

    IF sy-subrc <> 0.
      MESSAGE s067(/cadaxo/sqlc).
*   No jobs found
    ENDIF.

* sort logtable by date descending
    SORT gt_jobs BY create_date DESCENDING create_time DESCENDING.

    FREE: lt_sql_sres.
  ENDMETHOD.


  METHOD send_sql_via_mail.
****************************************************************************************************
* Description             : send sql via mail                                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_sql_string     TYPE string.
    DATA l_version        TYPE /cadaxo/sqlcparameter_val.
    DATA l_subject        TYPE string.
    DATA l_body           TYPE string.
    DATA l_error_string   TYPE string.
    DATA l_sap_components TYPE string.
    DATA l_sql_components TYPE string.

    FIELD-SYMBOLS: <ls_error> TYPE /cadaxo/sqlcsyntaxerror.

* get the sql content
    me->get_sql_area( IMPORTING e_code_string = l_sql_string ).

    /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value(
      EXPORTING
        i_parameter_id      = 'CADAXO_REV_VERSION'
      RECEIVING
        r_parameter_value = l_version
      EXCEPTIONS
        parameter_not_found = 1
           ).
    IF sy-subrc <> 0.
      /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value(
        EXPORTING
          i_parameter_id      = 'CADAXO_VERSION'
        RECEIVING
          r_parameter_value = l_version
        EXCEPTIONS
          parameter_not_found = 1
             ).
    ENDIF.

* Subject
    l_subject = text-t10.
    CONCATENATE l_subject l_version INTO l_subject SEPARATED BY space.

* Body
    l_body = text-t14.

* Error Messages
    CLEAR l_error_string.
    LOOP AT me->gt_errors ASSIGNING <ls_error>.
      CONCATENATE l_error_string <ls_error>-text cl_abap_char_utilities=>cr_lf INTO l_error_string SEPARATED BY space.
    ENDLOOP.

* Components
    /cadaxo/cl_sqlc_cockpit_assist=>create_components_xml( IMPORTING e_sap_components = l_sap_components
                                                                     e_sql_components = l_sql_components ).
* call frontend mail
    /cadaxo/cl_sqlc_cockpit_assist=>create_frontend_mail(
        i_mailto  = 'support@cadaxo.com'
        i_subject = l_subject
        i_body    = l_body ).

    CALL FUNCTION '/CADAXO/SQLCMAILINFOHTML'
      EXPORTING
*       IR_MAIN   =
        i_sql     = l_sql_string
        i_msg     = l_error_string
        i_cockpit = l_sql_components
        i_sapcomp = l_sap_components.



  ENDMETHOD.


  METHOD set_clipboard_alv.
    DATA: l_width TYPE i.

    CASE g_show_clipboard.
      WHEN 'R'.
        g_show_clipboard = ' '.
        l_width = toolbar_col_width.

        gc_clipboard_toolbar->set_button_info( EXPORTING fcode     = c_okcode_clipboard
                                                         icon      = '@K1@'
                                                         quickinfo = text-q03 ).

        gc_clipboard_toolbar->set_button_visible(  EXPORTING visible = ' '
                                                             fcode   = 'CLEAR_CLIPBOARD' ).

      WHEN space.
        g_show_clipboard = 'R'.
        l_width = c_width_right_clipboard.

        gc_clipboard_toolbar->set_button_info( EXPORTING fcode     = c_okcode_clipboard
                                                         icon      = '@K2@'
                                                         quickinfo = text-q05 ).

        gc_clipboard_toolbar->set_button_visible(  EXPORTING visible = abap_true
                                                             fcode   = 'CLEAR_CLIPBOARD' ).

        gc_clipboard_toolbar->set_button_info( EXPORTING fcode     = 'CLEAR_CLIPBOARD'
                                                         quickinfo = text-q04 ).
        gc_clipboard_toolbar->get_height( IMPORTING height = DATA(lv_tb_height) ).
        cl_gui_cfw=>flush( ).
        gc_clipboard_toolbar->set_height( lv_tb_height ).

    ENDCASE.
    gs_splitter_bottom->set_column_mode( 0 ).

    gs_splitter_bottom->set_column_width( EXPORTING id    = 2
                                                    width = l_width ).

    cl_gui_cfw=>flush( ).


  ENDMETHOD.


  METHOD set_gt_used_symbols.
    gt_used_symbols = i_used_symbols.
  ENDMETHOD.


  METHOD set_initial_date_history.

    DATA l_date TYPE dats.

    CONVERT DATE sy-datum TIME '235959' INTO TIME STAMP g_sel_hist_timestamp_to TIME ZONE 'UTC   '.
    IF me->g_user_settings-history_last_x_days IS INITIAL.
      CONVERT DATE sy-datum TIME 0 INTO TIME STAMP g_sel_hist_timestamp_from   TIME ZONE 'UTC   '.
    ELSE.
      l_date = sy-datum - ( me->g_user_settings-history_last_x_days - 1 ).
      CONVERT DATE l_date TIME 0 INTO TIME STAMP g_sel_hist_timestamp_from   TIME ZONE 'UTC   '.
    ENDIF.

  ENDMETHOD.


  METHOD set_initial_date_jobmonitor.

    DATA l_date TYPE dats.

    CONVERT DATE sy-datum TIME '235959' INTO TIME STAMP g_sel_job_timestamp_to TIME ZONE 'UTC   '.
    IF me->g_user_settings-job_last_x_days IS INITIAL.
      CONVERT DATE sy-datum TIME 0 INTO TIME STAMP g_sel_job_timestamp_from   TIME ZONE 'UTC   '.
    ELSE.
      l_date = sy-datum - ( me->g_user_settings-job_last_x_days - 1 ).
      CONVERT DATE l_date TIME 0 INTO TIME STAMP g_sel_job_timestamp_from   TIME ZONE 'UTC   '.
    ENDIF.

  ENDMETHOD.


  METHOD set_result_toolbar_active.
****************************************************************************************************
* Description             : set result toolbar active                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 17.07.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add "Saved Lists" Area                      | CDX130-030     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    IF i_fcode <> 'SHOW_RESULT_OPTIONS'.

      mv_toolbar_result_active = i_fcode.

* special handling for result
      IF dref_result_tab_t[] IS INITIAL.
        gc_result_toolbar->set_button_state( enabled = ' ' fcode = c_cmd_show_result_table ).
      ELSE.
        gc_result_toolbar->set_button_state( enabled = 'X' fcode = c_cmd_show_result_table ).
        gc_result_toolbar->set_button_state( checked = ''  fcode = c_cmd_show_result_table ).
      ENDIF.

* set checked no - home and show_log
      gc_result_toolbar->set_button_state( checked = ''  fcode = c_cmd_home ).
      gc_result_toolbar->set_button_state( checked = ''  fcode = 'SHOW_LOG' ).
      gc_result_toolbar->set_button_state( checked = ''  fcode = c_cmd_jobmonitor ).
      gc_result_toolbar->set_button_state( checked = ''  fcode = c_cmd_show_saved_lists )."CDX130-030

* set checked yes
      gc_result_toolbar->set_button_state( checked = 'X'  fcode = mv_toolbar_result_active ).

* save list button
      IF me->is_result_filled( ) IS INITIAL OR me->mv_toolbar_result_active <> c_cmd_show_result_table.
        me->gc_splitter_top_toolbar->set_button_state( enabled = abap_false fcode =  'SAVE_LISTS' ).
      ELSE.
        me->gc_splitter_top_toolbar->set_button_state( enabled = abap_true fcode =  'SAVE_LISTS' ).
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD set_sql_area.
****************************************************************************************************
* Description             : set sql area                                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

* set sql editor
    IF me->g_abap_editor_type = 'A'.
      IF gc_abap_editor IS BOUND.
        gc_abap_editor->set_text(
          EXPORTING
            table    = i_codelines_t
          EXCEPTIONS
            error_dp = 1
            OTHERS   = 2 ).
      ENDIF.
    ELSE.
      IF gc_abap_editor_text IS BOUND.
        gc_abap_editor_text->set_text_as_r3table(
          EXPORTING
            table           = i_codelines_t
          EXCEPTIONS
            error_dp        = 1
            error_dp_create = 2
            OTHERS          = 3 ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD set_symbol_alv.

    DATA: l_width TYPE i.

    CASE me->g_user_settings-symbols_show.
      WHEN abap_false.
        gs_splitter_top->set_column_mode( 0 ).
        me->g_user_settings-symbols_show = ' '.
        l_width = toolbar_col_width.

        gc_symbol_toolbar->set_button_info( EXPORTING  fcode            = c_okcode_symbols
                                                       icon             = '@K1@'
                                                       quickinfo        = text-q10
                                            EXCEPTIONS OTHERS           = 1 ).

      WHEN abap_true.
        gs_splitter_top->set_column_mode( 0 ).
        me->g_user_settings-symbols_show = abap_true.
        l_width = c_width_right_symbols.

        gc_symbol_toolbar->set_button_info( EXPORTING  fcode            = c_okcode_symbols
                                                       icon             = '@K2@'
                                                       quickinfo        = text-q11
                                            EXCEPTIONS OTHERS           = 3 ).

    ENDCASE.

    gs_splitter_top->set_column_width( EXPORTING id    = 2
                                                 width = l_width ).

    cl_gui_cfw=>flush( ).

  ENDMETHOD.


  METHOD set_user_settings.
****************************************************************************************************
* Description             : set user settings                                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 29.08.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Use the trace user settings                 | CDX001-0008    *
*------------+----------------------+---------------------------------------------+----------------*
* 17.07.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Show "Restart Message"                      | CDX130-029     *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | RenÃƒÂ© Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
*------------+----------------------+---------------------------------------------+----------------*
* 25.07.2018 | Domi Bigl            | UP TO event, CC                             | COCKPIT-326    *
*------------+----------------------+---------------------------------------------+----------------*
* 06.10.2020 | Attila Kajtar        | Domain Text  checkbox                       | COCKPIT-458    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_sqlcusrp         TYPE /cadaxo/sqlcusrp.
    DATA: l_settings         TYPE /cadaxo/sqlcusrp_dyn.
    DATA: l_xml              TYPE string.
    DATA: lr_exception       TYPE REF TO cx_root.
    DATA: l_message          TYPE string.
    DATA l_restart_message   TYPE c    LENGTH 1.

    CLEAR l_restart_message.

    l_settings = me->g_user_settings.

    l_sqlcusrp-uname = cl_abap_syst=>get_user_name( ).

    IF i_settings-editor_type <> ms_user_settings_xml-editor_type.
      l_restart_message = abap_true.
    ENDIF.

    ms_user_settings_xml-maxsel               = i_settings-maxsel.
    ms_user_settings_xml-show_footer          = i_settings-show_footer.           "Show Footer #4093
    ms_user_settings_xml-result_buttons       = i_settings-result_buttons.
    ms_user_settings_xml-save_clipboard       = i_settings-save_clipboard.
    ms_user_settings_xml-result_doubleclick   = i_settings-result_doubleclick.
    ms_user_settings_xml-use_convexit         = i_settings-use_convexit.
    ms_user_settings_xml-sql_trace            = i_settings-sql_trace.             "CDX001-0008
    ms_user_settings_xml-tablebuffer_trace    = i_settings-tablebuffer_trace.     "CDX001-0008
    ms_user_settings_xml-symbols_show         = i_settings-symbols_show.          "CDX001-0020
    ms_user_settings_xml-symbols_program_show = i_settings-symbols_program_show.  "CDX001-0020
    ms_user_settings_xml-only_used_symbols    = i_settings-only_used_symbols.     "CR22-002
    ms_user_settings_xml-history_last_x_days  = i_settings-history_last_x_days.
    ms_user_settings_xml-job_last_x_days      = i_settings-job_last_x_days.
    ms_user_settings_xml-hd_show_alias        = i_settings-hd_show_alias.
    ms_user_settings_xml-hd_fieldtext_s       = i_settings-hd_fieldtext_s.
    ms_user_settings_xml-hd_fieldtext_m       = i_settings-hd_fieldtext_m.
    ms_user_settings_xml-hd_fieldtext_l       = i_settings-hd_fieldtext_l.
    ms_user_settings_xml-hd_fieldtext_a       = i_settings-hd_fieldtext_a.
    ms_user_settings_xml-editor_type          = i_settings-editor_type.
    ms_user_settings_xml-forwnavddleclipse    = i_settings-forwnavddleclipse.
    ms_user_settings_xml-forwnavdicteclipse   = i_settings-forwnavdicteclipse.
    ms_user_settings_xml-domaintext           = i_settings-domaintext.             "COCKPIT-458

    CASE abap_true.
      WHEN i_settings-hd_fieldname.
        ms_user_settings_xml-colhd_type = '1'.
      WHEN i_settings-hd_fieldtext.
        ms_user_settings_xml-colhd_type = '2'.
    ENDCASE.

    CASE abap_true.
      WHEN i_settings-result_window_horizontal.
        ms_user_settings_xml-reswindoworientation = cs_windowresolution-horizontal.
      WHEN i_settings-result_window_vertical.
        ms_user_settings_xml-reswindoworientation = cs_windowresolution-vertical.
      when i_settings-result_window_tab.
        ms_user_settings_xml-reswindoworientation = cs_windowresolution-tab.
      WHEN OTHERS.
        ms_user_settings_xml-reswindoworientation = cs_windowresolution-matrix.
    ENDCASE.

* convert usersettings to xml
    CALL TRANSFORMATION id
       SOURCE settings = me->ms_user_settings_xml
       RESULT XML l_xml .

    TRY.
        cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                                     IMPORTING gzip_out = l_sqlcusrp-usrpref ).
      CATCH cx_parameter_invalid_range cx_sy_buffer_overflow cx_sy_conversion_codepage INTO lr_exception.
        l_message = lr_exception->get_text( ).
        MESSAGE e027(/cadaxo/sqlc) WITH l_message.
    ENDTRY.

* store usersetings to database
    SELECT SINGLE clipboard FROM /cadaxo/sqlcusrp INTO l_sqlcusrp-clipboard WHERE uname = sy-uname.
    IF sy-subrc = 0.
      UPDATE /cadaxo/sqlcusrp FROM l_sqlcusrp.
    ELSE.
      INSERT /cadaxo/sqlcusrp FROM l_sqlcusrp.
    ENDIF.

* show restart message
    IF NOT l_restart_message IS INITIAL.
      MESSAGE i078(/cadaxo/sqlc).
    ENDIF.

* refresh result list
    IF sy-subrc = 0.

      gc_result_toolbar->set_button_state( checked = ''  fcode = c_cmd_show_result_table ).

      me->g_user_settings = i_settings.

      IF me->g_user_settings-result_buttons = space.
        me->g_result_layout-no_toolbar = abap_true.
      ELSE.
        me->g_result_layout-no_toolbar = abap_false.
      ENDIF.

      IF l_settings-maxsel <> me->g_user_settings-maxsel.                                    "COCKPIT-326
        RAISE EVENT settings_changed_upto EXPORTING i_new_upto = me->g_user_settings-maxsel. "COCKPIT-326
      ENDIF.                                                                                 "COCKPIT-326

* update the field catalog
      IF ( l_settings-hd_fieldname   <> me->g_user_settings-hd_fieldname OR
           l_settings-result_buttons <> me->g_user_settings-result_buttons OR
           l_settings-use_convexit   <> me->g_user_settings-use_convexit  OR
           l_settings-hd_show_alias  <> me->g_user_settings-hd_show_alias OR
           l_settings-hd_fieldtext_a <> me->g_user_settings-hd_fieldtext_a OR
           l_settings-hd_fieldtext_l <> me->g_user_settings-hd_fieldtext_l OR
           l_settings-hd_fieldtext_m <> me->g_user_settings-hd_fieldtext_m OR
           l_settings-hd_fieldtext_s <> me->g_user_settings-hd_fieldtext_s ).

        me->update_field_catalog_alv( ).

      ENDIF.

* refresh result list, if the user changed the window orientation
      IF l_settings-result_window_horizontal <> me->g_user_settings-result_window_horizontal OR
         l_settings-result_window_vertical   <> me->g_user_settings-result_window_vertical OR
         l_settings-result_window_matrix     <> me->g_user_settings-result_window_matrix or
         l_settings-result_window_tab        <> me->g_user_settings-result_window_tab.
        me->show_result( ).
      ENDIF.

      IF l_settings-history_last_x_days <> me->g_user_settings-history_last_x_days.
        me->set_initial_date_history( ).
        IF me->mv_toolbar_result_active = 'SHOW_LOG'.
          me->show_log( ).
        ENDIF.
      ENDIF.

      IF l_settings-job_last_x_days <> me->g_user_settings-job_last_x_days.
        me->set_initial_date_jobmonitor( ).
        IF me->mv_toolbar_result_active = c_cmd_jobmonitor.
          me->show_jobmonitor( ).
        ENDIF.
      ENDIF.

* refresh user symbols
      IF l_settings-symbols_program_show <> me->g_user_settings-symbols_program_show.
        IF NOT me->g_user_settings-symbols_program_show IS INITIAL.
          me->g_user_settings-symbols_program_show = c_program_symbols_show.
          me->get_symbols( ).
        ELSE.
          me->g_user_settings-symbols_program_show = c_program_symbols_hide.
          me->get_symbols( ).
        ENDIF.
        IF gc_symbol_alv IS BOUND.
          gc_symbol_alv->refresh_table_display( EXPORTING i_soft_refresh = abap_true ).
        ENDIF.

      ENDIF.

* Only used symbols
      IF l_settings-only_used_symbols <> me->g_user_settings-only_used_symbols."CR22-002
        IF NOT me->g_user_settings-only_used_symbols IS INITIAL."CR22-002
          me->g_user_settings-only_used_symbols = abap_true.  "CR22-002
          me->get_symbols( ).                                 "CR22-002
        ELSE.                                                 "CR22-002
          me->g_user_settings-only_used_symbols = space.      "CR22-002
          me->get_symbols( ).                                 "CR22-002
        ENDIF.                                                "CR22-002

        IF gc_symbol_alv IS BOUND.
          gc_symbol_alv->refresh_table_display( EXPORTING i_soft_refresh = abap_true ).
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD share_saved_list.

    ASSIGN gcont_grid_result_t[ 1 ] TO FIELD-SYMBOL(<ls_cont_grid_result>) .
    IF sy-subrc = 0.

      <ls_cont_grid_result>-gui_alv_grid->get_selected_rows(
        IMPORTING
           et_row_no      =   DATA(lt_lvc_roid) ).

      IF lines( lt_lvc_roid ) > 1.

        MESSAGE s154(/cadaxo/sqlc)  DISPLAY LIKE 'E'.

      ELSE.

        ASSIGN lt_lvc_roid[ 1 ] TO FIELD-SYMBOL(<ls_lvc_s_roid>).
        IF sy-subrc = 0.

          DATA(saved_list_for_sharing) = populate_saved_list( iv_list_guid         = me->gt_saved_lists[ <ls_lvc_s_roid>-row_id ]-list_guid
                                                              iv_saved_list_shared = gc_saved_list_shared ).
          CALL FUNCTION '/CADAXO/SQLC_SHARE'
            EXPORTING
              iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-savedList
              is_saved_list  = saved_list_for_sharing
              iv_receiver    = iv_receiver "cockpit-420
              iv_text        = iv_text.    "cockpit-420

        ELSE.
          MESSAGE i149(/cadaxo/sqlc) DISPLAY LIKE 'E'. "select list for sharing

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD show_admhelp.
****************************************************************************************************
* Description             : SQL Cockpit - Show saved result list                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 16.01.2012                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
***************************************************************************************************
    CALL FUNCTION '/CADAXO/SQLCADMININFOHTML'
      EXPORTING
        ir_main = me
        i_force = abap_true.

  ENDMETHOD.


  METHOD show_html.
****************************************************************************************************
* Description             : Show home screen                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 03.02.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 12.09.2010 | Fößleitner Johann    | Information message instead of warning      | CDX001-0016    *
*            |                      | because if the warning appears a second time|                *
*            |                      | the System dumps.                           |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_doc_url        TYPE cnht_url.
    DATA: l_doc_url_s      TYPE string.
    DATA: l_html_id        TYPE /cadaxo/sqlcparameter_id.
    DATA: lt_cache         TYPE gtt_char255.
    DATA: lt_event         TYPE cntl_simple_events.
    DATA: lwa_event        TYPE cntl_simple_event.

* Show some HTML
    IF g_html_request = abap_true.
      RETURN.
    ENDIF.

    IF g_is_its IS INITIAL.
      gs_splitter_results->set_grid( EXPORTING rows = 1 columns = 1 ).
    ENDIF.

* Clear Splitter/ALV Controls
    free_result_controls( ).

    gcont_html_viewer = gs_splitter_results->get_container( row = 1 column = 1 ).
    gcont_html_viewer->set_name( 'CONTAINER' ).

* create the html control
    CREATE OBJECT gc_html_viewer
      EXPORTING
        parent = gcont_html_viewer.

    SET HANDLER on_home_sapevent FOR gc_html_viewer.
    lwa_event-eventid = gc_html_viewer->m_id_sapevent.
    lwa_event-appl_event = 'X'.
    APPEND lwa_event TO lt_event.
    CALL METHOD gc_html_viewer->set_registered_events
      EXPORTING
        events = lt_event.

    l_html_id = i_html_id.
    IF l_html_id IS INITIAL.
      l_html_id = 'HTML_STARTUP'.
    ENDIF.

    me->get_content(
      EXPORTING
        i_html_id      = l_html_id
        i_viewer       = gc_html_viewer
      IMPORTING
        et_content     = lt_cache
        e_assigend_url = l_doc_url
           ).

* local or link home screen
    me->get_link( EXPORTING i_html_id = l_html_id
                  IMPORTING e_url     = l_doc_url
                  CHANGING  ct_cache  = lt_cache ).

    l_doc_url_s = l_doc_url.
    me->param_replace_tags( CHANGING data = l_doc_url_s ).
    l_doc_url = l_doc_url_s.

    IF NOT lt_cache IS INITIAL.
* load the html data
      gc_html_viewer->load_data( IMPORTING assigned_url = l_doc_url
                                 CHANGING  data_table   = lt_cache ).

* show the html document
      gc_html_viewer->show_url( url = l_doc_url ).
    ELSEIF NOT l_doc_url IS INITIAL.
      gc_html_viewer->show_url( url = l_doc_url ).
    ELSE.
      MESSAGE i101(/cadaxo/sqlc). "no html startup-document found       "CDX001-0016
    ENDIF.

    IF i_html_id IS SUPPLIED.
      g_html_request = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD show_jobmonitor.
****************************************************************************************************
* Description             : SQL Cockpit - Jobmonitor                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 16.04.2011                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add end date & end time to jobmonitor       | CDX130-002     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.03.2012 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Add nr. of selects to jobmonitor            | CDX130-003     *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_lvc_s_layo  TYPE lvc_s_layo,
          lt_fieldcat   TYPE slis_t_fieldcat_alv,
          lt_lfc_t_fcat TYPE lvc_t_fcat,
          l_lvc_s_fcat  TYPE lvc_s_fcat.

    FIELD-SYMBOLS: <l_fieldcat>         TYPE slis_fieldcat_alv,
                   <l_cont_grid_result> TYPE /cadaxo/sqlcclguicontainer.

* Show some HTML
    IF g_html_request = abap_true.
      RETURN.
    ENDIF.

* clear alv controls
    free_result_controls( ).

    me->select_jobdata( ).

    CLEAR: l_lvc_s_layo.

* set layout
    l_lvc_s_layo-zebra      = 'X'.
    l_lvc_s_layo-sel_mode   = 'A'.
    l_lvc_s_layo-smalltitle = 'X'.
    l_lvc_s_layo-stylefname = 'CT'.
    l_lvc_s_layo-ctab_fname = 'CT_COL'.

    l_lvc_s_layo-grid_title = /cadaxo/cl_sqlc_cockpit_assist=>create_alv_date_header( i_timestamp_from = g_sel_job_timestamp_from
                                                                                      i_timestamp_to = g_sel_job_timestamp_to ).

    IF lt_lfc_t_fcat IS INITIAL.

* build field catalog
      CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name       = '/CADAXO/SQLCJOBSALV'
        CHANGING
          ct_fieldcat            = lt_fieldcat
        EXCEPTIONS
          inconsistent_interface = 1
          program_error          = 2
          OTHERS                 = 3.
      IF sy-subrc = 0.
        LOOP AT lt_fieldcat ASSIGNING <l_fieldcat>.
          CLEAR: l_lvc_s_fcat.
          MOVE-CORRESPONDING <l_fieldcat> TO l_lvc_s_fcat.
          MOVE: <l_fieldcat>-seltext_m TO l_lvc_s_fcat-scrtext_m,
                <l_fieldcat>-seltext_l TO l_lvc_s_fcat-scrtext_l,
                <l_fieldcat>-seltext_s TO l_lvc_s_fcat-scrtext_s.
          CASE <l_fieldcat>-fieldname.
            WHEN 'JOBNAME'.
              l_lvc_s_fcat-key = 'X'.
              l_lvc_s_fcat-fix_column = 'X'.
*            l_lvc_s_fcat-HOTSPOT = 'X'.
            WHEN 'JOBRESULT'.
              l_lvc_s_fcat-icon = 'X'.
            WHEN 'CREATE_DATE' OR 'END_DATE'. "CDX130-002
              l_lvc_s_fcat-outputlen  = 10.
            WHEN 'CREATE_TIME' OR 'END_TIME'. "CDX130-002
              l_lvc_s_fcat-outputlen  = 10.
            WHEN 'JOBGUID' OR 'RESS_GUID' OR 'LIST_GUID'.
              l_lvc_s_fcat-no_out = 'X'.
            WHEN 'NR_OF_SELECTS'.             "CDX130-003
              l_lvc_s_fcat-outputlen  = 12.   "CDX130-003
          ENDCASE.
          APPEND l_lvc_s_fcat TO lt_lfc_t_fcat.
        ENDLOOP.
      ELSE.
        MESSAGE e100(/cadaxo/sqlc).
      ENDIF.
    ENDIF.

    IF g_is_its IS INITIAL.
      gs_splitter_results->set_grid( EXPORTING rows = 1 columns = 1 ).
    ENDIF.

* create container and grid
    APPEND INITIAL LINE TO gcont_grid_result_t ASSIGNING <l_cont_grid_result>.

    gs_splitter_results->get_container( EXPORTING row = 1 column = 1
                                        RECEIVING container =  <l_cont_grid_result>-gui_container ).

    <l_cont_grid_result>-gui_container->set_name( 'CONTAINER' ).

    CREATE OBJECT <l_cont_grid_result>-gui_alv_grid
      EXPORTING
        i_parent = <l_cont_grid_result>-gui_container.

    SET HANDLER: me->on_job_alv_click               FOR <l_cont_grid_result>-gui_alv_grid,
                 me->on_handle_job_toolbar          FOR <l_cont_grid_result>-gui_alv_grid,
                 me->on_handle_job_user_command     FOR <l_cont_grid_result>-gui_alv_grid,
                 me->on_job_alv_hotspot_click       FOR <l_cont_grid_result>-gui_alv_grid.

    CALL METHOD <l_cont_grid_result>-gui_alv_grid->set_table_for_first_display
      EXPORTING
        i_bypassing_buffer            = 'X'
        is_layout                     = l_lvc_s_layo
        it_toolbar_excluding          = me->g_jobmonitor_toolbar_ex
      CHANGING
        it_outtab                     = gt_jobs
        it_fieldcatalog               = lt_lfc_t_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.

    FREE: lt_lfc_t_fcat,
          lt_fieldcat.

  ENDMETHOD.


  METHOD show_log.
****************************************************************************************************
* Description             : show sql history log                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************


    DATA: l_lvc_s_layo  TYPE lvc_s_layo,
          lt_sql_log    TYPE TABLE OF /cadaxo/sqlclog,
          l_sqlclogalv  TYPE /cadaxo/sqlclogalv,
          lt_fieldcat   TYPE slis_t_fieldcat_alv,
          lt_lfc_t_fcat TYPE lvc_t_fcat,
          l_lvc_s_fcat  TYPE lvc_s_fcat.

    DATA l_sqllog_xml TYPE /cadaxo/sqlc_sqllog.
    DATA l_xml        TYPE string.

    FIELD-SYMBOLS: <l_fieldcat>         TYPE slis_fieldcat_alv,
                   <l_cont_grid_result> TYPE /cadaxo/sqlcclguicontainer,
                   <l_sqlclog>          TYPE /cadaxo/sqlclog.

* Show some HTML
    IF g_html_request = abap_true.
      RETURN.
    ENDIF.

    free_result_controls( ).

* create dragdrop behaviour
    IF me->g_abap_editor_type = 'A' AND dragdrop_behaviour_log IS INITIAL.
      CREATE OBJECT dragdrop_behaviour_log.
      dragdrop_behaviour_log->add( flavor = 'LOG_TO_EDITOR'
                                   dragsrc = 'X' droptarget = ' '
                                   effect = cl_dragdrop=>copy ).
      dragdrop_behaviour_log->get_handle( IMPORTING handle = dragdrop_handle_log ).
    ENDIF.

    MESSAGE s066(/cadaxo/sqlc) INTO g_progress_indicator_msg.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        text = g_progress_indicator_msg.

* select the (userspecific) log from database
    SELECT * FROM /cadaxo/sqlclog INTO TABLE lt_sql_log WHERE uname     = sy-uname
                                                          AND timestamp BETWEEN g_sel_hist_timestamp_from AND g_sel_hist_timestamp_to.
* delete old log entries
    DELETE lt_sql_log WHERE sql_log IS INITIAL.

    CLEAR: gt_history_log.

    LOOP AT lt_sql_log ASSIGNING <l_sqlclog>.

      CLEAR: l_sqlclogalv,
             l_sqllog_xml,
             l_xml.

      cl_abap_gzip=>decompress_text(
        EXPORTING
          gzip_in = <l_sqlclog>-sql_log
        IMPORTING
          text_out = l_xml ).

      CALL TRANSFORMATION id
         SOURCE XML l_xml
         RESULT log = l_sqllog_xml.

      MOVE: <l_sqlclog>-uname           TO l_sqlclogalv-uname,
            l_sqllog_xml-sql_string     TO l_sqlclogalv-sql_string,
            l_sqllog_xml-result_rows    TO l_sqlclogalv-result_rows,
            l_sqllog_xml-result_runtime TO l_sqlclogalv-result_runtime.

      CASE l_sqllog_xml-result_status.
        WHEN '00'.
          MOVE icon_green_light TO l_sqlclogalv-result_status_icon.
        WHEN '01'.
          MOVE icon_yellow_light TO l_sqlclogalv-result_status_icon.
        WHEN '02'.
          MOVE icon_red_light TO l_sqlclogalv-result_status_icon.
        WHEN OTHERS.
          MOVE icon_green_light TO l_sqlclogalv-result_status_icon.
      ENDCASE.

      CASE l_sqllog_xml-sql_mode.
        WHEN '01' OR space.
          MOVE icon_gis_pan        TO l_sqlclogalv-sql_mode_icon.
        WHEN '02'.
          MOVE icon_background_job TO l_sqlclogalv-sql_mode_icon.
        WHEN OTHERS.
          MOVE icon_dummy          TO l_sqlclogalv-sql_mode_icon.
      ENDCASE.

      CONVERT TIME STAMP <l_sqlclog>-timestamp TIME ZONE sy-zonlo
              INTO DATE l_sqlclogalv-execute_date TIME l_sqlclogalv-execute_time.

      APPEND l_sqlclogalv TO gt_history_log.
    ENDLOOP.

* sort logtable by date descending
    SORT gt_history_log BY execute_date DESCENDING execute_time DESCENDING.

* set layout (zebra look, single select mode, optimize width)
    l_lvc_s_layo-zebra      = 'X'.
    l_lvc_s_layo-cwidth_opt = 'X'.
    l_lvc_s_layo-sel_mode   = 'X'.
    l_lvc_s_layo-smalltitle = 'X'.

    l_lvc_s_layo-grid_title = /cadaxo/cl_sqlc_cockpit_assist=>create_alv_date_header( i_timestamp_from = g_sel_hist_timestamp_from
                                                                                      i_timestamp_to = g_sel_hist_timestamp_to ).

    IF lt_lfc_t_fcat IS INITIAL.

* build field catalog
      CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name       = '/CADAXO/SQLCLOGALV'
        CHANGING
          ct_fieldcat            = lt_fieldcat
        EXCEPTIONS
          inconsistent_interface = 1
          program_error          = 2
          OTHERS                 = 3.
      IF sy-subrc = 0.
        LOOP AT lt_fieldcat ASSIGNING <l_fieldcat>.
          CLEAR: l_lvc_s_fcat.
          MOVE-CORRESPONDING <l_fieldcat> TO l_lvc_s_fcat.
          MOVE <l_fieldcat>-seltext_m TO l_lvc_s_fcat-scrtext_m.
          MOVE <l_fieldcat>-seltext_l TO l_lvc_s_fcat-scrtext_l.
          MOVE <l_fieldcat>-seltext_s TO l_lvc_s_fcat-scrtext_s.
          CASE <l_fieldcat>-fieldname.
            WHEN 'SQL_STRING'.
              l_lvc_s_fcat-dragdropid = dragdrop_handle_log.
            WHEN 'UNAME'.
              l_lvc_s_fcat-no_out = 'X'.
            WHEN 'EXECUTE_DATE'.
              l_lvc_s_fcat-outputlen = 12.
              l_lvc_s_fcat-key = 'X'.
            WHEN 'EXECUTE_TIME'.
              l_lvc_s_fcat-outputlen = 12.
              l_lvc_s_fcat-key = 'X'.
            WHEN 'RESULT_STATUS_ICON'.
              l_lvc_s_fcat-icon = 'X'.
            WHEN 'SQL_MODE_ICON'.
              l_lvc_s_fcat-outputlen = 12.
              l_lvc_s_fcat-icon = 'X'.
              l_lvc_s_fcat-just = 'C'.
          ENDCASE.
          APPEND l_lvc_s_fcat TO lt_lfc_t_fcat.
        ENDLOOP.
      ELSE.
        MESSAGE e100(/cadaxo/sqlc).
      ENDIF.
    ENDIF.

    IF g_is_its IS INITIAL.
      gs_splitter_results->set_grid( EXPORTING rows = 1 columns = 1 ).
    ENDIF.

* create container and grid
    APPEND INITIAL LINE TO gcont_grid_result_t ASSIGNING <l_cont_grid_result>.

    gs_splitter_results->get_container( EXPORTING row = 1 column = 1
                                        RECEIVING container =  <l_cont_grid_result>-gui_container ).

    <l_cont_grid_result>-gui_container->set_name( 'CONTAINER' ).

    CREATE OBJECT <l_cont_grid_result>-gui_alv_grid
      EXPORTING
        i_parent = <l_cont_grid_result>-gui_container.

    SET HANDLER me->on_log_alv_drag               FOR <l_cont_grid_result>-gui_alv_grid.
    SET HANDLER me->on_log_alv_double_click       FOR <l_cont_grid_result>-gui_alv_grid.
    SET HANDLER me->on_log_alv_toolbar            FOR <l_cont_grid_result>-gui_alv_grid.
    SET HANDLER me->on_log_alv_context_menu       FOR <l_cont_grid_result>-gui_alv_grid.
    SET HANDLER me->on_log_alv_user_command       FOR <l_cont_grid_result>-gui_alv_grid.

    <l_cont_grid_result>-gui_alv_grid->set_table_for_first_display(
      EXPORTING
        i_bypassing_buffer            = 'X'
        is_layout                     = l_lvc_s_layo
        it_toolbar_excluding          = me->g_history_toolbar_excluding
      CHANGING
        it_outtab                     = gt_history_log
        it_fieldcatalog               = lt_lfc_t_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4 ).
    IF sy-subrc <> 0.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.

* save memory
    FREE: lt_lfc_t_fcat,
          lt_sql_log,
          lt_fieldcat,
          l_xml,
          l_sqllog_xml.

  ENDMETHOD.


  METHOD show_result.
****************************************************************************************************
* Description             : show results                                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Ana Lekic                Company    : CADAXO GesmbH                    *
* Date                    : 06.11.2014                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 29.05.2012 | Ana Lekic            | restricted lines info - jobs                | CDX130-017     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 10.07.2014 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | bugfixing layout saved lists                | RT239          *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 14.11.2014 | Ana Lekic            | no refresh button for a saved list          | RT244          *
*            |                      |                                             |                *
****************************************************************************************************

* data definition
    DATA: l_lines     TYPE i,
          l_grid_name TYPE string,
          l_cont_name TYPE string,
          l_tabix     TYPE i,
          l_num2(2)   TYPE n,
          l_rows      TYPE i,
          l_cols      TYPE i,
          lv_alv_rows TYPE i,
          l_act_col   TYPE i,
          l_act_row   TYPE i,
          lr_cont     TYPE REF TO cl_gui_container,
          lr_cont1    TYPE REF TO cl_gui_container,
          lv_footer   TYPE string.

    DATA  l_show_message_restr_lines TYPE i.                  "CDX130-017

    DATA lt_lvc_t_sort       TYPE lvc_t_sort.
    DATA lt_lvc_t_filt       TYPE lvc_t_filt.
    DATA l_result_layout     LIKE g_result_layout.            "RT239

* field symbols
    FIELD-SYMBOLS: <l_cont_grid_result> TYPE /cadaxo/sqlcclguicontainer,
                   <lr_dref_result>     TYPE REF TO data,
                   <lr_sql>             TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse,
                   <lt_result>          TYPE STANDARD TABLE,
                   <lt_result_tmp>      TYPE STANDARD TABLE,
                   <l_lvc_t_fcat>       TYPE lvc_t_fcat,
                   <l_result_details>   TYPE /cadaxo/sqlcresult_details.


* Show some HTML
    IF g_html_request = abap_true.
      RETURN.
    ENDIF.

* clear alv controls
    free_result_controls( ).

    IF ms_user_settings_xml-reswindoworientation = cs_windowresolution-tab.
      show_result_tab( ).
    ELSE.

* create splitter rows
      DESCRIBE TABLE gt_cl_sql_parse LINES l_lines.

* set rows & columns
      me->calc_result_rows_and_cols( EXPORTING i_lines = l_lines
                                     IMPORTING e_rows = l_rows
                                               e_cols = l_cols ).

      gs_splitter_results->is_alive( ).
      gs_splitter_results->is_valid( ).
      IF g_is_its IS INITIAL.
        gs_splitter_results->set_grid( EXPORTING rows = l_rows columns = l_cols ).
      ENDIF.

      LOOP AT dref_result_tab_t ASSIGNING <lr_dref_result>.
        l_tabix = sy-tabix.

        READ TABLE gt_cl_sql_parse ASSIGNING <lr_sql> INDEX l_tabix.
        ASSIGN <lr_dref_result>->* TO <lt_result>.

* create container and grid
        APPEND INITIAL LINE TO gcont_grid_result_t ASSIGNING <l_cont_grid_result>.

        IF l_tabix GT 1.
          CASE ms_user_settings_xml-reswindoworientation.
            WHEN cs_windowresolution-horizontal.
              l_act_row = 1.
              l_act_col = l_tabix.
            WHEN cs_windowresolution-vertical.
              l_act_row = l_tabix.
              l_act_col = 1.
            WHEN cs_windowresolution-matrix.
              l_act_col = l_act_col + 1.
              IF l_act_col GT l_cols.
                l_act_col = 1.
                l_act_row = l_act_row + 1.
              ENDIF.
          ENDCASE.
        ELSE.
          l_act_col = 1.
          l_act_row = 1.
        ENDIF.

        gs_splitter_results->get_container( EXPORTING row = l_act_row column = l_act_col
                                            RECEIVING container = <l_cont_grid_result>-gui_container ).

        MOVE l_tabix TO l_num2.

* create container name
        CONCATENATE 'CONTAINER_' l_num2 INTO l_cont_name.

* set the container name
        <l_cont_grid_result>-gui_container->set_name( l_cont_name ).

* get usersettings
        IF me->g_user_settings-show_footer = abap_true.
          lv_alv_rows = 3.
        ELSE.
          lv_alv_rows = 2.
        ENDIF.

* create Splitter
        CONCATENATE 'CONTAINER_SPLIT_' l_num2 INTO l_cont_name.
        CREATE OBJECT <l_cont_grid_result>-gui_splitter
          EXPORTING
            parent  = <l_cont_grid_result>-gui_container
            rows    = lv_alv_rows
            columns = 1.

        <l_cont_grid_result>-gui_splitter->set_name( l_cont_name ).
        <l_cont_grid_result>-gui_splitter->set_border( EXPORTING border = gfw_false ).
        <l_cont_grid_result>-gui_splitter->set_mode( <l_cont_grid_result>-gui_splitter->mode_run ).
        <l_cont_grid_result>-gui_splitter->set_row_mode( cl_gui_splitter_container=>mode_absolute ).
        <l_cont_grid_result>-gui_splitter->set_row_height( id = 1 height = toolbar_row_height ).
        <l_cont_grid_result>-gui_splitter->set_row_sash( id = 1 type = 1 value = cl_gui_splitter_container=>false  ).
        <l_cont_grid_result>-gui_splitter->set_row_height( id = 3 height = toolbar_row_height ).
        <l_cont_grid_result>-gui_splitter->set_row_sash( id = 3 type = 1 value = cl_gui_splitter_container=>false  ).

        <l_cont_grid_result>-gui_splitter->get_container( EXPORTING row = 2 column = 1
                                                          RECEIVING container = lr_cont ).
* build and set name of the grid
        CONCATENATE 'CONTAINER_SPLIT_2_' l_num2 INTO l_cont_name.
        lr_cont->set_name( l_cont_name ).

* create the alv grid control
        CREATE OBJECT <l_cont_grid_result>-gui_alv_grid
          EXPORTING
            i_lifetime = cl_gui_alv_grid=>lifetime_default
            i_parent   = lr_cont.

* build and set name of the grid
        CONCATENATE 'GC_GRID_RESULT_' l_num2 INTO l_grid_name.
        <l_cont_grid_result>-gui_alv_grid->set_name( l_grid_name ).

        CLEAR lt_lvc_t_sort.
        CLEAR lt_lvc_t_filt.

* get layout
        IF gt_lvc_s_layo IS NOT INITIAL.                      "#4170
          READ TABLE gt_lvc_s_layo INDEX l_tabix INTO l_result_layout."#4170 "RT239
          IF l_result_layout IS INITIAL.                      "RT239
            MOVE me->g_result_layout TO l_result_layout.      "RT239
          ENDIF.                                              "RT239
        ELSE.
          MOVE me->g_result_layout TO l_result_layout.        "RT239
        ENDIF.                                                "#4170  "RT239

        READ TABLE gt_result_details INDEX l_tabix ASSIGNING <l_result_details>.
        IF sy-subrc = 0.

* create grid title (xx records ( y.yyyy Microseconds )
          l_result_layout-grid_title = /cadaxo/cl_sqlc_cockpit_main=>build_result_grid_title( i_runtime = <l_result_details>-runtime
                                                                                              i_lines   = <l_result_details>-lines ).
* create footer line
          lv_footer = /cadaxo/cl_sqlc_cockpit_main=>build_result_grid_footer("#4093
                                                                          iv_mandant           = <l_result_details>-mandant"#4093
                                                                          iv_syst              = <l_result_details>-syst"#4093
                                                                          iv_create_timestamp  = <l_result_details>-create_timestamp"#4093
                                                                          iv_uname             = <l_result_details>-uname )."#4093
          IF NOT <l_result_details>-restricted_lines IS INITIAL."CDX130-017
            l_show_message_restr_lines = <l_result_details>-maxsel."CDX130-017
          ENDIF.                                              "CDX130-017
        ENDIF.

* get sort
        READ TABLE gt_lvc_t_sort INDEX l_tabix INTO lt_lvc_t_sort.

* get filter
        READ TABLE gt_lvc_t_filt INDEX l_tabix INTO lt_lvc_t_filt.

* set handler for drag/drop, double click and toolbar
        SET HANDLER me->on_alv_drag                     FOR <l_cont_grid_result>-gui_alv_grid.
        SET HANDLER me->on_alv_result_double_click     FOR <l_cont_grid_result>-gui_alv_grid.
        SET HANDLER me->on_handle_result_toolbar      FOR <l_cont_grid_result>-gui_alv_grid.

        SET HANDLER: me->on_handle_result_user_command  FOR <l_cont_grid_result>-gui_alv_grid,
                     me->on_handle_result_context_menu  FOR <l_cont_grid_result>-gui_alv_grid,
                     me->on_handle_result_end_of_page   FOR <l_cont_grid_result>-gui_alv_grid, "CDX Update Add On
                     me->on_handle_result_menu_button   FOR <l_cont_grid_result>-gui_alv_grid.

        <l_cont_grid_result>-gui_splitter->get_container( EXPORTING row = 1 column = 1
                                                          RECEIVING container = lr_cont ).
* build and set name of the grid
        CONCATENATE 'CONTAINER_SPLIT_1_' l_num2 INTO l_cont_name.
        lr_cont->set_name( l_cont_name ).

        IF <lr_sql> IS ASSIGNED.
          create_dyn_document(
            EXPORTING
              i_parent      = lr_cont
              i_sql         = <lr_sql>->sql_syntax
              i_header_text = <l_result_details>-header_line_text "CR22-034
            CHANGING
              ic_document   = <l_cont_grid_result>-cl_document_header
                 ).
        ENDIF.

* show result table
        EXPORT grid_name FROM l_grid_name TO MEMORY ID 'GRID_NAME'.

        "l_result_layout-no_keyfix = abap_true.

        LOOP AT <lr_sql>->gt_lvc_t_fcat ASSIGNING FIELD-SYMBOL(<fcat>).
          CASE <fcat>-fieldname.
            WHEN 'CDXLINECOLOR'.
              <fcat>-no_out = abap_true.
          ENDCASE.
        ENDLOOP.

        l_result_layout-info_fname = 'CDXLINECOLOR'.

        <l_cont_grid_result>-gui_alv_grid->set_table_for_first_display(
          EXPORTING
            i_bypassing_buffer            = abap_true
            is_layout                     = l_result_layout
            it_toolbar_excluding          = me->g_result_toolbar_excluding
          CHANGING
            it_fieldcatalog               = <lr_sql>->gt_lvc_t_fcat
            it_outtab                     = <lt_result>
            it_sort                       = lt_lvc_t_sort
            it_filter                     = lt_lvc_t_filt
          EXCEPTIONS
            OTHERS                        = 1 ).
        IF sy-subrc = 0.
          "    CALL METHOD <l_cont_grid_result>-gui_alv_grid->set_toolbar_interactive.
        ELSE.
          MESSAGE e100(/cadaxo/sqlc).
        ENDIF.

* show result table
        CLEAR l_grid_name.
        EXPORT grid_name FROM l_grid_name TO MEMORY ID 'GRID_NAME'.

* INS BEGIN #4093 - 20131210
*     if footer is enabled(user settings)
        IF lv_alv_rows = 3.
          <l_cont_grid_result>-gui_splitter->get_container( EXPORTING row = 3 column = 1
                                                            RECEIVING container = lr_cont1 ).
*     build and set name of the grid
          CONCATENATE 'CONTAINER_SPLIT_3_' l_num2 INTO l_cont_name.
          lr_cont1->set_name( l_cont_name ).

          create_dyn_document(
            EXPORTING
              i_parent    = lr_cont1
              i_sql       = lv_footer
            CHANGING
              ic_document = <l_cont_grid_result>-cl_document_footer ).
        ENDIF.
* INS END #4093 - 20131210

        cl_gui_cfw=>flush( ). "COCKPIT-185

      ENDLOOP.

    ENDIF.

* CDX130-017 Begin
    IF NOT l_show_message_restr_lines IS INITIAL.
      MESSAGE s044(/cadaxo/sqlc) WITH l_show_message_restr_lines.
      CLEAR l_show_message_restr_lines.
    ENDIF.
* CDX130-017 End
  ENDMETHOD.


  METHOD show_result_tab.

    FIELD-SYMBOLS: <l_cont_grid_result> TYPE /cadaxo/sqlcclguicontainer,
                   <lr_dref_result>     TYPE REF TO data.

    IF g_is_its IS INITIAL.
      gs_splitter_results->set_grid( EXPORTING rows = 1 columns = 1 ).
    ENDIF.

    if me->g_active_list_tab is initial.
      me->g_active_list_tab = 1.
    endif.

    READ TABLE dref_result_tab_t ASSIGNING <lr_dref_result> INDEX me->g_active_list_tab.
    IF sy-subrc = 0.
      show_result_table( EXPORTING i_result_dref = <lr_dref_result>
                                   i_tabix = sy-tabix ).
    ENDIF.

  ENDMETHOD.


  METHOD show_result_table.

** data definition
    DATA: l_lines        TYPE i,
          l_grid_name    TYPE string,
          l_cont_name    TYPE string,
          l_tabix        TYPE i,
          l_num2(2)      TYPE n,
          l_cols         TYPE i,
          lv_alv_rows    TYPE i,
          l_act_col      TYPE i,
          l_act_row      TYPE i,
          lr_cont        TYPE REF TO cl_gui_container,
          lr_cont1       TYPE REF TO cl_gui_container,
          lr_tabbar_cont TYPE REF TO cl_gui_container,
          "lr_tabbar_toolbar TYPE REF TO cl_gui_toolbar,

          lv_footer      TYPE string.
*
    DATA  l_show_message_restr_lines TYPE i.
*
    DATA lt_lvc_t_sort       TYPE lvc_t_sort.
    DATA lt_lvc_t_filt       TYPE lvc_t_filt.
    DATA l_result_layout     LIKE g_result_layout.
    DATA l_events TYPE cntl_simple_events.
    DATA l_event  TYPE cntl_simple_event.
    DATA ls_stb_button TYPE stb_button.
    DATA lt_buttons TYPE ttb_button.
    DATA l_numc2 TYPE n LENGTH 2.
    DATA l_source_tables TYPE string.

    FIELD-SYMBOLS: <l_cont_grid_result> TYPE /cadaxo/sqlcclguicontainer,
                   <lr_sql>             TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse,
                   <lt_result>          TYPE STANDARD TABLE,
                   <l_result_details>   TYPE /cadaxo/sqlcresult_details.

    l_tabix = i_tabix.

    READ TABLE gt_cl_sql_parse ASSIGNING <lr_sql> INDEX l_tabix.
    ASSIGN i_result_dref->* TO <lt_result>.

* create container and grid
    APPEND INITIAL LINE TO gcont_grid_result_t ASSIGNING <l_cont_grid_result>.

    IF l_tabix GT 1.
      CASE ms_user_settings_xml-reswindoworientation.
        WHEN cs_windowresolution-horizontal.
          l_act_row = 1.
          l_act_col = l_tabix.
        WHEN cs_windowresolution-vertical.
          l_act_row = l_tabix.
          l_act_col = 1.
        WHEN cs_windowresolution-matrix.
          l_act_col = l_act_col + 1.
          IF l_act_col GT l_cols.
            l_act_col = 1.
            l_act_row = l_act_row + 1.
          ENDIF.
        WHEN cs_windowresolution-tab.
          l_act_col = 1.
          l_act_row = 1.
      ENDCASE.
    ELSE.
      l_act_col = 1.
      l_act_row = 1.
    ENDIF.

    gs_splitter_results->get_container( EXPORTING row = l_act_row column = l_act_col
                                        RECEIVING container = <l_cont_grid_result>-gui_container ).


    ms_user_settings_xml-reswindoworientation = cs_windowresolution-tab.




    l_num2 = l_tabix.

* create container name
    CONCATENATE 'CONTAINER_' l_num2 INTO l_cont_name.

* set the container name
    <l_cont_grid_result>-gui_container->set_name( l_cont_name ).

* get usersettings
    IF me->g_user_settings-show_footer = abap_true.
      lv_alv_rows = 3.
    ELSE.
      lv_alv_rows = 2.
    ENDIF.

    DATA lv_footer_id TYPE i.
    DATA lv_result_id TYPE i.
    DATA lv_select_id TYPE i.

    IF ms_user_settings_xml-reswindoworientation = cs_windowresolution-tab.
      lv_alv_rows = lv_alv_rows + 1.
      lv_footer_id = 4.
      lv_result_id = 3.
      lv_select_id = 2.
    ELSE.
      lv_footer_id = 3.
      lv_result_id = 2.
      lv_select_id = 1.
    ENDIF.

* create Splitter
    CONCATENATE 'CONTAINER_SPLIT_' l_num2 INTO l_cont_name.
    CREATE OBJECT <l_cont_grid_result>-gui_splitter
      EXPORTING
        parent  = <l_cont_grid_result>-gui_container
        rows    = lv_alv_rows
        columns = 1.

    <l_cont_grid_result>-gui_splitter->set_name( l_cont_name ).
    <l_cont_grid_result>-gui_splitter->set_border( EXPORTING border = gfw_false ).
    <l_cont_grid_result>-gui_splitter->set_mode( <l_cont_grid_result>-gui_splitter->mode_run ).
    <l_cont_grid_result>-gui_splitter->set_row_mode( cl_gui_splitter_container=>mode_absolute ).

    <l_cont_grid_result>-gui_splitter->set_row_height( id = lv_select_id height = toolbar_row_height ).
    <l_cont_grid_result>-gui_splitter->set_row_sash( id = lv_select_id type = 1 value = cl_gui_splitter_container=>false  ).

    <l_cont_grid_result>-gui_splitter->set_row_height( id = lv_footer_id height = toolbar_row_height ).
    <l_cont_grid_result>-gui_splitter->set_row_sash( id = lv_footer_id type = 1 value = cl_gui_splitter_container=>false  ).

    IF ms_user_settings_xml-reswindoworientation = cs_windowresolution-tab.


      <l_cont_grid_result>-gui_splitter->set_row_height( id = 1 height = 32 ).
      <l_cont_grid_result>-gui_splitter->set_row_sash( id = 1 type = 1 value = cl_gui_splitter_container=>false  ).

      <l_cont_grid_result>-gui_splitter->get_container( EXPORTING row = 1 column = 1
                                                        RECEIVING container = lr_tabbar_cont ).

      lr_tabbar_cont->set_name( 'CONTAINER_SPLIT_TAB_BAR' ).

      DATA(l_ctmenu) = NEW cl_ctmenu( ).

      CLEAR gr_results_tab_toolbar.

      IF gr_results_tab_toolbar IS BOUND.

      ELSE.

        gr_results_tab_toolbar = NEW #( parent = lr_tabbar_cont
                                        display_mode = cl_gui_toolbar=>m_mode_horizontal ).

        LOOP AT gt_cl_sql_parse ASSIGNING FIELD-SYMBOL(<lr_sql_button>).

          l_numc2 = sy-tabix.

          CLEAR l_source_tables.

          READ TABLE gt_result_details INDEX sy-tabix ASSIGNING <l_result_details>.
          IF sy-subrc = 0 AND <l_result_details>-header_line_text IS NOT INITIAL.
            l_source_tables = <l_result_details>-header_line_text.
          ELSE.

            LOOP AT <lr_sql_button>->result_source_t ASSIGNING FIELD-SYMBOL(<source>).
              IF l_source_tables IS INITIAL.
                l_source_tables = <source>-table.
              ELSE.
                l_source_tables = l_source_tables && ` ` && <source>-table.
              ENDIF.
            ENDLOOP.

          ENDIF.

          CLEAR: ls_stb_button.
          ls_stb_button-function = 'LST_' && l_numc2.
          ls_stb_button-text      = '#' && l_numc2 && ` ` && l_source_tables.
          ls_stb_button-butn_type = cntb_btype_check.

          IF l_numc2 = l_tabix.
            ls_stb_button-checked = abap_true.
          ELSE.
            ls_stb_button-checked = abap_false.
          ENDIF.
          APPEND ls_stb_button TO lt_buttons.

        ENDLOOP.

        gr_results_tab_toolbar->add_button_group( EXPORTING data_table = lt_buttons ).


        CLEAR l_events[].
        l_event-eventid = cl_gui_toolbar=>m_id_function_selected.
        l_event-appl_event = ' '.
        APPEND l_event TO l_events.

        gr_results_tab_toolbar->set_registered_events( EXPORTING events = l_events ).

        SET HANDLER me->on_tabbar_toolbar_funcsel  FOR gr_results_tab_toolbar.

      ENDIF.

    ENDIF.

    <l_cont_grid_result>-gui_splitter->get_container( EXPORTING row = lv_result_id column = 1
                                                      RECEIVING container = lr_cont ).

* build and set name of the grid
    CONCATENATE 'CONTAINER_SPLIT_2_' l_num2 INTO l_cont_name.
    lr_cont->set_name( l_cont_name ).

* create the alv grid control
    CREATE OBJECT <l_cont_grid_result>-gui_alv_grid
      EXPORTING
        i_lifetime = cl_gui_alv_grid=>lifetime_default
        i_parent   = lr_cont.

* build and set name of the grid
    CONCATENATE 'GC_GRID_RESULT_' l_num2 INTO l_grid_name.
    <l_cont_grid_result>-gui_alv_grid->set_name( l_grid_name ).

    CLEAR lt_lvc_t_sort.
    CLEAR lt_lvc_t_filt.

* get layout
    IF gt_lvc_s_layo IS NOT INITIAL.                      "#4170
      READ TABLE gt_lvc_s_layo INDEX l_tabix INTO l_result_layout."#4170 "RT239
      IF l_result_layout IS INITIAL.                      "RT239
        MOVE me->g_result_layout TO l_result_layout.      "RT239
      ENDIF.                                              "RT239
    ELSE.
      MOVE me->g_result_layout TO l_result_layout.        "RT239
    ENDIF.                                                "#4170  "RT239

    READ TABLE gt_result_details INDEX l_tabix ASSIGNING <l_result_details>.
    IF sy-subrc = 0.

* create grid title (xx records ( y.yyyy Microseconds )
      l_result_layout-grid_title = /cadaxo/cl_sqlc_cockpit_main=>build_result_grid_title( i_runtime = <l_result_details>-runtime
                                                                                          i_lines   = <l_result_details>-lines ).
* create footer line
      lv_footer = /cadaxo/cl_sqlc_cockpit_main=>build_result_grid_footer("#4093
                                                                      iv_mandant           = <l_result_details>-mandant"#4093
                                                                      iv_syst              = <l_result_details>-syst"#4093
                                                                      iv_create_timestamp  = <l_result_details>-create_timestamp"#4093
                                                                      iv_uname             = <l_result_details>-uname )."#4093
      IF NOT <l_result_details>-restricted_lines IS INITIAL."CDX130-017
        l_show_message_restr_lines = <l_result_details>-maxsel."CDX130-017
      ENDIF.                                              "CDX130-017
    ENDIF.

* get sort
    READ TABLE gt_lvc_t_sort INDEX l_tabix INTO lt_lvc_t_sort.

* get filter
    READ TABLE gt_lvc_t_filt INDEX l_tabix INTO lt_lvc_t_filt.

* set handler for drag/drop, double click and toolbar
    SET HANDLER me->on_alv_drag FOR <l_cont_grid_result>-gui_alv_grid.
    SET HANDLER me->on_alv_result_double_click FOR <l_cont_grid_result>-gui_alv_grid.
    SET HANDLER me->on_handle_result_toolbar FOR <l_cont_grid_result>-gui_alv_grid.

    SET HANDLER: me->on_handle_result_user_command FOR <l_cont_grid_result>-gui_alv_grid,
                 me->on_handle_result_context_menu FOR <l_cont_grid_result>-gui_alv_grid,
                 me->on_handle_result_end_of_page FOR <l_cont_grid_result>-gui_alv_grid,
                 me->on_handle_result_menu_button FOR <l_cont_grid_result>-gui_alv_grid.

    <l_cont_grid_result>-gui_splitter->get_container( EXPORTING row = lv_select_id column = 1
                                                      RECEIVING container = lr_cont ).
* build and set name of the grid
    CONCATENATE 'CONTAINER_SPLIT_1_' l_num2 INTO l_cont_name.
    lr_cont->set_name( l_cont_name ).

    IF <lr_sql> IS ASSIGNED.
      create_dyn_document(
        EXPORTING
          i_parent      = lr_cont
          i_sql         = <lr_sql>->sql_syntax
          i_header_text = <l_result_details>-header_line_text "CR22-034
        CHANGING
          ic_document   = <l_cont_grid_result>-cl_document_header
             ).
    ENDIF.

* show result table
    EXPORT grid_name FROM l_grid_name TO MEMORY ID 'GRID_NAME'.

    "l_result_layout-no_keyfix = abap_true.
    "COCKPIT-274 BEGIN
    IF <lr_sql> IS ASSIGNED.
      IF <lr_sql>->gt_lvc_t_fcat IS INITIAL.
        <lr_sql>->gt_lvc_t_fcat = <lr_sql>->create_alv_field_catalog( i_user_settings   = me->g_user_settings
                                                                      i_dragdrop_handle = dragdrop_handle ).
      ENDIF.
    ENDIF.
    "COCKPIT-274 END
    LOOP AT <lr_sql>->gt_lvc_t_fcat ASSIGNING FIELD-SYMBOL(<fcat>).
      CASE <fcat>-fieldname.
        WHEN 'CDXLINECOLOR'.
          <fcat>-no_out = abap_true.
      ENDCASE.
    ENDLOOP.

    l_result_layout-info_fname = 'CDXLINECOLOR'.

    <l_cont_grid_result>-gui_alv_grid->set_table_for_first_display(
      EXPORTING
        i_bypassing_buffer            = abap_true
        is_layout                     = l_result_layout
        it_toolbar_excluding          = me->g_result_toolbar_excluding
      CHANGING
        it_fieldcatalog               = <lr_sql>->gt_lvc_t_fcat
        it_outtab                     = <lt_result>
        it_sort                       = lt_lvc_t_sort
        it_filter                     = lt_lvc_t_filt
      EXCEPTIONS
        OTHERS                        = 1 ).
    IF sy-subrc = 0.
      "    CALL METHOD <l_cont_grid_result>-gui_alv_grid->set_toolbar_interactive.
    ELSE.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.

* show result table
    CLEAR l_grid_name.
    EXPORT grid_name FROM l_grid_name TO MEMORY ID 'GRID_NAME'.

* INS BEGIN #4093 - 20131210
*     if footer is enabled(user settings)
    IF lv_alv_rows = lv_footer_id.
      <l_cont_grid_result>-gui_splitter->get_container( EXPORTING row = lv_footer_id column = 1
                                                        RECEIVING container = lr_cont1 ).
*     build and set name of the grid
      CONCATENATE 'CONTAINER_SPLIT_3_' l_num2 INTO l_cont_name.
      lr_cont1->set_name( l_cont_name ).

      create_dyn_document(
        EXPORTING
          i_parent    = lr_cont1
          i_sql       = lv_footer
        CHANGING
          ic_document = <l_cont_grid_result>-cl_document_footer ).
    ENDIF.
* INS END #4093 - 20131210

    cl_gui_cfw=>flush( ). "COCKPIT-185

  ENDMETHOD.


  METHOD show_saved_lists.

    DATA l_lvc_s_layo TYPE lvc_s_layo.
    DATA l_max_space_kb TYPE int4.
    DATA ls_adm_cust TYPE /cadaxo/sqlc_admin_cust.

    FIELD-SYMBOLS: <l_cont_grid_result> TYPE /cadaxo/sqlcclguicontainer.

* clear alv controls
    free_result_controls( ).

* get saved lists
    /cadaxo/cl_sqlc_cockpit_lists=>get_saved_lists( EXPORTING i_uname = sy-uname
                                                    IMPORTING e_saved_lists = me->gt_saved_lists
                                                              e_free_space_kb = me->g_free_space_kb ).

    l_lvc_s_layo-zebra      = 'X'.
    l_lvc_s_layo-sel_mode   = 'C'.
    l_lvc_s_layo-smalltitle = 'X'.

    IF gt_saved_list_fieldcat IS INITIAL.
      gt_saved_list_fieldcat =  get_saved_list_fieldcat( ).
    ENDIF.

    IF g_is_its IS INITIAL.
      gs_splitter_results->set_grid( EXPORTING rows = 1 columns = 1 ).
    ENDIF.

* create container and grid
    APPEND INITIAL LINE TO gcont_grid_result_t ASSIGNING <l_cont_grid_result>.

    gs_splitter_results->get_container( EXPORTING row = 1 column = 1
                                        RECEIVING container =  <l_cont_grid_result>-gui_container ).

    gs_splitter_results->set_column_width( id = 1 width = 75 ).

    <l_cont_grid_result>-gui_container->set_name( 'CONTAINER' ).

    CREATE OBJECT <l_cont_grid_result>-gui_alv_grid
      EXPORTING
        i_parent = <l_cont_grid_result>-gui_container.

    SET HANDLER:  me->on_handle_savedlists_toolbar      FOR <l_cont_grid_result>-gui_alv_grid,
                  me->on_handle_savedlists_usrcommnd    FOR <l_cont_grid_result>-gui_alv_grid,
                  me->on_saved_list_select_line         FOR <l_cont_grid_result>-gui_alv_grid.
    SET HANDLER:  me->on_saved_list_menu_click          FOR <l_cont_grid_result>-gui_alv_grid. "Cockpit-420
    <l_cont_grid_result>-gui_alv_grid->set_table_for_first_display(
        EXPORTING
          i_bypassing_buffer            = 'X'
          is_layout                     = l_lvc_s_layo
          it_toolbar_excluding          = me->g_jobmonitor_toolbar_ex
        CHANGING
          it_outtab                     = me->gt_saved_lists
          it_fieldcatalog               = gt_saved_list_fieldcat  "lt_lfc_t_fcat
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4 ).
    IF sy-subrc <> 0.
      MESSAGE e100(/cadaxo/sqlc).
    ENDIF.

    IF me->g_free_space_kb LE 0.

      /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing(
        IMPORTING
          e_customizing = ls_adm_cust ).
      l_max_space_kb = ls_adm_cust-maxspace.

      IF l_max_space_kb GT 0.
        MESSAGE s083(/cadaxo/sqlc) WITH l_max_space_kb.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD show_symbolmulti_dialog.
****************************************************************************************************
* Description             : Show Smybol Multivalue Dialog                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Dusan Sacha              Company    : CADAXO GesmbH                    *
* Date                    : 31.07.2017               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 15.03.2018 | Dusan Sacha          | Multivalue Include Ranges                   | COCKPIT-214    *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

    DATA: ls_exl_opt TYPE rsoptions.

    " Load Multivalue Data
    IF i_symbol_multivalue IS NOT INITIAL.
      /cadaxo/cl_sqlc_cockpit_assist=>decompress_symbol_multivalue(
        EXPORTING
          i_symbol_multivalue = i_symbol_multivalue
        IMPORTING
          e_symbol_multivalue = r_symbol_value
      ).
    ENDIF.


*"     Exclude select options
*    MOVE: abap_true TO ls_exl_opt-bt ,
*          abap_true TO ls_exl_opt-cp ,
*          abap_true TO ls_exl_opt-ge ,
*          abap_true TO ls_exl_opt-gt ,
*          abap_true TO ls_exl_opt-le ,
*          abap_true TO ls_exl_opt-lt ,
*          abap_true TO ls_exl_opt-nb ,
*          abap_true TO ls_exl_opt-np ,
*          abap_true TO ls_exl_opt-ne .
*

    " Prepare Data Structure Dynamically
    DATA lr_data_struct TYPE REF TO data.
    DATA lr_data TYPE REF TO data.

    me->create_symbol_multival_tab_dyn(
      EXPORTING i_symbol_datatype = i_symbol_datatype
      IMPORTING e_data_struct     = lr_data_struct
                e_data            = lr_data
    ).

*    FIELD-SYMBOLS <ls_table> TYPE STANDARD TABLE.
*    ASSIGN lr_data_struct->* TO FIELD-SYMBOL(<ls_struct>).
*    ASSIGN lr_data->* TO <ls_table>.
*    ASSIGN ('<ls_struct>-low') TO FIELD-SYMBOL(<low>).
*    ASSIGN ('<ls_struct>-sign') TO FIELD-SYMBOL(<sign>).
*    ASSIGN ('<ls_struct>-option') TO FIELD-SYMBOL(<option>).
*    <sign> = 'I'.
*    <option> = 'EQ'.
*
*    LOOP AT r_symbol_value ASSIGNING FIELD-SYMBOL(<rs_symbol_value>).
*      <low> = <rs_symbol_value>-low.
*      APPEND <ls_struct> TO <ls_table>.
*    ENDLOOP.

    FIELD-SYMBOLS <ls_table> TYPE STANDARD TABLE.
    ASSIGN lr_data_struct->* TO FIELD-SYMBOL(<ls_struct>).
    ASSIGN lr_data->* TO <ls_table>.
    ASSIGN ('<ls_struct>-low') TO FIELD-SYMBOL(<low>).
    ASSIGN ('<ls_struct>-high') TO FIELD-SYMBOL(<high>).
    ASSIGN ('<ls_struct>-sign') TO FIELD-SYMBOL(<sign>).
    ASSIGN ('<ls_struct>-option') TO FIELD-SYMBOL(<option>).
    "    <sign> = 'I'.
    "    <option> = 'EQ'.

    LOOP AT r_symbol_value ASSIGNING FIELD-SYMBOL(<rs_symbol_value>).
      <low>    = <rs_symbol_value>-low.
      <high>   = <rs_symbol_value>-high.
      <sign>   = <rs_symbol_value>-sign.
      <option> = <rs_symbol_value>-option.
      APPEND <ls_struct> TO <ls_table>.
    ENDLOOP.

    " Show Multivalue Dialog
    CALL FUNCTION 'COMPLEX_SELECTIONS_DIALOG'
      EXPORTING
        title             = text-q54
        text              = text-q55
        no_interval_check = abap_true
        excluded_options  = ls_exl_opt
      TABLES
        range             = <ls_table>
      EXCEPTIONS
        no_range_tab      = 1
        cancelled         = 2
        internal_error    = 3
        invalid_fieldname = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found.
    ELSE.
      r_symbol_value = CORRESPONDING #( <ls_table> ).
    ENDIF.

*" Symbol Multivalue Limit set to 5000
*  IF lines( r_symbol_value ) > 5000.
*    DELETE r_symbol_value FROM 5001.
*    IF sy-subrc = 0.
*      MESSAGE i124(/cadaxo/sqlc) with '5000' DISPLAY LIKE 'W'.
*    ENDIF.
*  ENDIF.

  ENDMETHOD.


  METHOD sql_search.
    DATA search_string   TYPE string.
    DATA selected_row    TYPE lvc_s_row.

    CALL FUNCTION '/CADAXO/SQLC_SQL_SEARCH'
      CHANGING
        cv_search_string = search_string.

    IF search_string IS NOT INITIAL.

      CLEAR : gt_selected_rows, gv_selected_total, gv_selected_counter, gt_selected_disp.

      LOOP AT gt_history_log INTO DATA(ls_history_log).
        DATA(lv_match_index) = sy-tabix.
        FIND ALL OCCURRENCES OF REGEX search_string IN ls_history_log-sql_string RESULTS DATA(lt_results) IGNORING CASE IN CHARACTER MODE.
        IF lt_results IS NOT INITIAL.
          selected_row-index = lv_match_index.
          APPEND selected_row TO gt_selected_rows.
          CLEAR lt_results.
        ENDIF.
      ENDLOOP.

      gv_selected_total = lines( gt_selected_rows ).
      me->log_alv_line_selection( ).

    ENDIF.

  ENDMETHOD.


  METHOD sql_search_next.

    me->log_alv_line_selection( ).

  ENDMETHOD.


  METHOD store_sql_to_hist.
****************************************************************************************************
* Description             : Store the SQL Command to history                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

* some data definitions
    DATA: l_cnt_lines    TYPE i,
          lt_code        TYPE /cadaxo/sqlccodeline_t,
          l_sqlchistline TYPE /cadaxo/sqlchistline.

    FIELD-SYMBOLS: <l_sqlchistline> TYPE /cadaxo/sqlchistline.

    cl_gui_cfw=>flush( ).

* get the sql text
    IF NOT i_codelines_t IS INITIAL.
      lt_code[] = i_codelines_t[].
    ELSE.
      lt_code   = me->get_sql_area_lt_code( ).
    ENDIF.

    IF NOT lt_code[] IS INITIAL.

      CLEAR l_sqlchistline.

      DESCRIBE TABLE gt_sql_hist LINES l_cnt_lines.

      l_sqlchistline-nr = l_cnt_lines + 1.
      l_sqlchistline-lines[] = lt_code[].

      IF l_cnt_lines GE 1.
        READ TABLE gt_sql_hist INDEX l_cnt_lines ASSIGNING <l_sqlchistline>.
        IF sy-subrc = 0 AND l_sqlchistline-lines[] <> <l_sqlchistline>-lines.
          APPEND l_sqlchistline TO gt_sql_hist.
          g_sql_pos = sy-tabix.
        ENDIF.
      ELSE.
        APPEND l_sqlchistline TO gt_sql_hist.
        g_sql_pos = sy-tabix.
      ENDIF.

    ENDIF.

    CALL METHOD cl_gui_cfw=>flush.

  ENDMETHOD.


  METHOD trigger_html.
****************************************************************************************************
* Description             : Show home screen                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 30.01.2011               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    FIELD-SYMBOLS: <lwa_main>           LIKE LINE OF gt_main_classes.

    READ TABLE gt_main_classes ASSIGNING <lwa_main> WITH KEY nr = i_main_ref_id.
    IF sy-subrc = 0 AND <lwa_main>-ref IS BOUND.
      <lwa_main>-ref->show_html( i_html_id ).
    ENDIF.

  ENDMETHOD.


  METHOD update_field_catalog_alv.
****************************************************************************************************
* Description             : update field catalog                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 12.09.2010 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | To improve the performance, now we use the  | CDX001-0016    *
*            |                      | soft refresh                                |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.04.2016 | Ana Lekic            | take layout from user settings              | $002 COCKPIT-20*
*------------+----------------------+---------------------------------------------+----------------*
* 14.04.2017 | Domi Bigl            | Result Toolltbar after user settings change | COCKPIT-159    *
****************************************************************************************************

* data definitions & field symbols
    DATA lt_lvc_t_fcat    TYPE lvc_t_fcat.
    DATA l_tabix          TYPE i.
    DATA l_lvc_s_stbl     TYPE lvc_s_stbl.
    DATA ls_layout_tmp    TYPE lvc_s_layo.
    DATA ls_layout        TYPE lvc_s_layo.

    FIELD-SYMBOLS: <l_cl_gui_container> TYPE /cadaxo/sqlcclguicontainer,
                   <l_cl_sql_parse>     LIKE LINE OF gt_cl_sql_parse.

* loop at parsed sql commands
    LOOP AT gt_cl_sql_parse ASSIGNING <l_cl_sql_parse>.

      l_tabix = sy-tabix.

* clear local fieldcatalog table
      CLEAR: lt_lvc_t_fcat[].
      IF <l_cl_sql_parse>->g_saved_list IS INITIAL.
        lt_lvc_t_fcat = <l_cl_sql_parse>->create_alv_field_catalog( EXPORTING i_user_settings = me->g_user_settings
                                                                              i_dragdrop_handle = dragdrop_handle ).
      ELSE.

* read container/grid control
        READ TABLE gcont_grid_result_t INDEX l_tabix ASSIGNING <l_cl_gui_container>.
        IF sy-subrc = 0.
          <l_cl_gui_container>-gui_alv_grid->get_frontend_fieldcatalog( IMPORTING et_fieldcatalog = lt_lvc_t_fcat ).
          <l_cl_sql_parse>->update_alv_field_catalog_sl( EXPORTING i_user_settings = me->g_user_settings
                                                                   i_dragdrop_handle = dragdrop_handle
                                                         CHANGING  c_lvc_t_fcat = lt_lvc_t_fcat ).
        ENDIF.

      ENDIF.

* read container/grid control
      READ TABLE gcont_grid_result_t INDEX l_tabix ASSIGNING <l_cl_gui_container>.
      IF sy-subrc = 0.

        DATA(lv_grid_name) = <l_cl_gui_container>-gui_alv_grid->get_name( ).   "COCKPIT-159
        EXPORT grid_name FROM lv_grid_name TO MEMORY ID 'GRID_NAME'.           "COCKPIT-159

* set new frontend field catalog
        IF lt_lvc_t_fcat IS NOT INITIAL.
          <l_cl_gui_container>-gui_alv_grid->set_frontend_fieldcatalog( lt_lvc_t_fcat ).
        ELSEIF <l_cl_sql_parse>->gt_lvc_t_fcat IS NOT INITIAL.
          <l_cl_gui_container>-gui_alv_grid->set_frontend_fieldcatalog( <l_cl_sql_parse>->gt_lvc_t_fcat ).
        ENDIF.

* set the grid title
        <l_cl_gui_container>-gui_alv_grid->get_frontend_layout( IMPORTING es_layout = ls_layout_tmp ).

        ls_layout           = me->g_result_layout.
        ls_layout-frontend  = ls_layout_tmp-frontend.

* create grid title
        IF <l_cl_sql_parse>->g_saved_list IS INITIAL.
          ls_layout-grid_title = /cadaxo/cl_sqlc_cockpit_main=>build_result_grid_title(
                                                   i_runtime = <l_cl_sql_parse>->result_runtime
                                                   i_lines   = <l_cl_sql_parse>->result_lines ).
        ENDIF. "$002

* set new frontend layout
        <l_cl_gui_container>-gui_alv_grid->set_frontend_layout( ls_layout ).

* refresh table display, only if the tab active
        IF me->mv_toolbar_result_active = c_cmd_show_result_table.

          l_lvc_s_stbl-row = 'X'.                                                 "CDX001-0016
          l_lvc_s_stbl-col = 'X'.                                                 "CDX001-0016

          <l_cl_gui_container>-gui_alv_grid->refresh_table_display(
             EXPORTING is_stable = l_lvc_s_stbl                                   "CDX001-0016
                       i_soft_refresh = 'X' ).                                    "CDX001-0016

        ENDIF.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.


  METHOD update_symbol_db.

    IF NOT it_symbol_update IS INITIAL.

      UPDATE /cadaxo/sqlcusym FROM TABLE it_symbol_update.
      IF sy-subrc = 0.

        rv_success = 'X'.

      ELSE.

        ROLLBACK WORK.
        MESSAGE s055(/cadaxo/sqlc) WITH text-deu DISPLAY LIKE 'E'.                      "CDX001-0020
        RETURN.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD UPDATE_VARIANT.
****************************************************************************************************
* Description             : Save Variant Method                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               :                          Company    : Cadaxo GmbH                          *
* Date                    :                          Release    :                                  *

*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 22.9.2020  | Pratik Patil         | Existing Variant Update                     | Cadaxo-321     *
*------------+----------------------+---------------------------------------------+----------------*
* 25.11.2020 | Attila Kajtar        | Feedback/Support 3.3.0                      | COCKPIT-321    *
****************************************************************************************************
    DATA: l_string      TYPE string.
    DATA: lt_symbols     TYPE /cadaxo/sqlc_symbol_t.           "COCKPIT-288 Insert

 IF gs_sel_variant IS INITIAL.
    MESSAGE text-013 TYPE 'I'.
    RETURN.
 ENDIF.

    me->get_sql_area( IMPORTING e_code_string = l_string ).

    IF NOT l_string IS INITIAL.

      gs_sel_variant-t_sql     = me->get_sql_area_lt_code( ).

      me->get_user_symbol_from_sql(
        EXPORTING
          i_sql      = gs_sel_variant-t_sql
          i_type     = 'U'
        IMPORTING
          e_symbols  = lt_symbols ).

      LOOP AT lt_symbols ASSIGNING FIELD-SYMBOL(<ls_symbol>).

        APPEND CORRESPONDING #( <ls_symbol> ) TO gs_sel_variant-t_symbol. "COCKPIT-288 Insert

      ENDLOOP.

* execute create variant popup
      CALL FUNCTION '/CADAXO/SQLC_CREATE_VARIANT_UI'
        EXPORTING
          i_mode     = 'I'
          il_variant = gs_sel_variant
          i_mode_variant = 'U'. "COCKPIT-321 KA

    ELSE.
      MESSAGE e048(/cadaxo/sqlc).
    ENDIF.

  ENDMETHOD.


  METHOD usr_action_clear_sql_area.
****************************************************************************************************
* Description             : user action - clear sql area                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA lt_table TYPE /cadaxo/sqlccodeline_t.

    me->set_sql_area( i_codelines_t =  lt_table  ).

    CLEAR gt_errors.

    IF NOT gc_splitter IS INITIAL.

      IF NOT gs_splitter_editor IS INITIAL.
        gs_splitter_editor->set_row_height( id = 2 height = 0 ).
      ENDIF.

      IF NOT gc_abap_error IS INITIAL.

        gs_splitter_editor->get_row_height(
          EXPORTING
            id                = 2
          IMPORTING
            result            = g_height
          EXCEPTIONS
            cntl_error        = 1
            cntl_system_error = 2
            OTHERS            = 3
        ).
        IF sy-subrc = 0 AND g_height > 0 AND lines( gt_errors ) > 0.
          gc_abap_error->refresh_table_display( ).
        ENDIF.

      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD usr_action_leave_sql_cockpit.
****************************************************************************************************
* Description             : User action leave sql cockpit                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    SET SCREEN 0.
    LEAVE SCREEN.

  ENDMETHOD.


  METHOD usr_action_pretty_printer.
****************************************************************************************************
* Description             : Call the pretty printer                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 27.10.2011 | FÃƒÂ¶ÃƒÅ¸leitner Johann    | Support old frontend editor                 | CDX001-0027    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: lt_code TYPE /cadaxo/sqlccodeline_t.

    CALL METHOD cl_gui_cfw=>flush.

* get source code
    lt_code     = me->get_sql_area_lt_code( ).

* call the pretty printer function
    CALL FUNCTION 'PRETTY_PRINTER'
      EXPORTING
        inctoo             = space
      TABLES
        ntext              = lt_code
        otext              = lt_code
      EXCEPTIONS
        enqueue_table_full = 1
        include_enqueued   = 2
        include_readerror  = 3
        include_writeerror = 4
        OTHERS             = 5.

    IF sy-subrc = 0.
      me->set_sql_area( i_codelines_t =  lt_code[]  ).
    ELSE.
      MESSAGE a001(/cadaxo/sqlc).
    ENDIF.

* save memory
    FREE: lt_code.

  ENDMETHOD.


  METHOD usr_action_show_abap_docu.

    DATA lcl_gui_control TYPE REF TO cl_gui_control.

    CALL FUNCTION 'ABAP_DOCU_SHOW'
      EXPORTING
        area           = 'ABAP'
        name           = 'SELECT'
        search_mode    = 'E'
        langu          = sy-langu
      IMPORTING
        docu_container = lcl_gui_control.

* set focus
    cl_gui_control=>set_focus( lcl_gui_control ).


  ENDMETHOD.


  METHOD usr_action_sql_trace_onoff.
****************************************************************************************************
* Description             : User action set sql trace on/off                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann FÃƒÂ¶ÃƒÅ¸leitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver WahrstÃƒÂ¶tter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_icon TYPE iconname.

    IF me->g_sql_trace_on IS INITIAL.
* check the sap standard authority for sql trace
      AUTHORITY-CHECK OBJECT 'S_ADMI_FCD'
                      ID     'S_ADMI_FCD'
                      FIELD  'ST0M'.
      IF sy-subrc <> 0.
        MESSAGE e012(perftrac).
      ENDIF.
      MOVE abap_true TO me->g_sql_trace_on.
      MESSAGE s062(/cadaxo/sqlc).
    ELSE.
      CLEAR me->g_sql_trace_on.
      MESSAGE s063(/cadaxo/sqlc).
    ENDIF.

* set button icon
    IF me->g_sql_trace_on = abap_true.
      l_icon = icon_led_green.
      gc_splitter_top_toolbar->set_button_info( EXPORTING fcode = 'TRACETOGGL'
                                                          icon  = l_icon ).
    ELSE.
      l_icon = icon_dummy.
      gc_splitter_top_toolbar->set_button_info( EXPORTING fcode = 'TRACETOGGL'
                                                          icon  = l_icon ).
    ENDIF.

  ENDMETHOD.


  METHOD _split_error_text.

    DATA lv_pos        TYPE i.
    DATA ls_error_add  TYPE /cadaxo/sqlcsyntaxerror.
    DATA lv_space      TYPE string.

    CONCATENATE '' ''  INTO lv_space SEPARATED BY space.

    ls_error_add = is_error.

    lv_pos = 127.
    WHILE lv_pos <> 0.
      IF is_error-text+lv_pos(1) = lv_space.
        EXIT.
      ENDIF.
      lv_pos = lv_pos - 1.
    ENDWHILE.

    ls_error_add-text = is_error-text(lv_pos).
    APPEND ls_error_add TO ct_errors.

    IF lv_pos = 0.
      lv_pos = 128.
    ELSE.
      lv_pos = lv_pos + 1.
    ENDIF.

    ls_error_add-text = is_error-text+lv_pos.
    APPEND ls_error_add TO ct_errors.

  ENDMETHOD.
ENDCLASS.
