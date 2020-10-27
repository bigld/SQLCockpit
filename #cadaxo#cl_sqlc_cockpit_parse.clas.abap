class /CADAXO/CL_SQLC_COCKPIT_PARSE definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_COCKPIT_PARSE
*"* do not include other source files here!!!
public section.

  interfaces IF_SERIALIZABLE_OBJECT .

  types:
    BEGIN OF gts_client_handling,
        client_specified TYPE flag,
        using_client     TYPE flag,
      END OF gts_client_handling .
  types:
    BEGIN OF gts_symbol_variable,
        var_name    TYPE char50,
        data_type   TYPE /cadaxo/sqlcsymbol_datatype,
        range_table TYPE rseloption,
      END OF gts_symbol_variable .
  types:
    gtt_symbol_variable TYPE TABLE OF gts_symbol_variable .
  types:
    "COCKPIT-458 BEGIN
    BEGIN OF gts_domval,
        name         TYPE string,
        name_desc    TYPE string,
        fixed_values TYPE ddfixvalues,
      END OF gts_domval .
  types:
    gtt_domval TYPE TABLE OF gts_domval .
    "COCKPIT-458 END
  data G_HOLD_RESULT type CHAR1 .
  data COLUMN_SYNTAX type /CADAXO/SQLCSELECTCOLUMNSYNTAX .
  data WHERE_SYNTAX type /CADAXO/SQLCSELECTWHERESYNTAX .
  data FIELDS_SYNTAX type /CADAXO/SQLCSELECTFIELDSSYNTAX .
  data OFFSET_SYNTAX type /CADAXO/SQLCSELECTOFFSETSYNTAX .
  data WHERE_SYNTAX_WILDCARD type /CADAXO/SQLCSELECTWHERESYNTAX .
  data SOURCE_SYNTAX type /CADAXO/SQLCSELECTSOURCESYNTAX .
  data CDS_PARAMETER_SYNTAX type /CADAXO/SQLCSELECTCDSPARSYNTAX .
  data GROUP_SYNTAX type /CADAXO/SQLCSELECTGROUPSYNTAX .
  data HAVING_SYNTAX type /CADAXO/SQLCSELECTHAVINGSYNTAX .
  data ORDER_SYNTAX type /CADAXO/SQLCSELECTORDERSYNTAX .
  data DBHINT_SYNTAX type /CADAXO/SQLCSELECTDBHINTSYNTAX .
  data CONNECTION_SYNTAX type /CADAXO/SQLCSELECTDBHINTSYNTAX .
  data GT_RESULT_DDFIELDS type /CADAXO/SQLCDFIES_T .
  data SQL_SYNTAX type STRING .
  data SQL_SYNTAX_WITHOUT_WHERE type STRING .
  data GT_SQL_WHERE_COL_TAB_T type /CADAXO/SQLCWHERECOL_STR_T .
  data G_SELECT_SINGLE type CHAR1 .
  data G_UP_TO_X_ROWS type INT4 .
  data SUBQUERY type CHAR1 .
  data RESULT_TABLE type ref to DATA .
  data RESULT_STRUCTURE type ref to DATA .
  data RESULT_LINES type INT4 .
  data RESULT_RUNTIME type INT4 .
  data G_SELECT_DISTINCT type CHAR1 .
  data RESULT_COMPONENT_T type /CADAXO/SQLCPARSECOMPONENT_T .
  data RESULT_SOURCE_T type /CADAXO/SQLCSELECTSOURCE_T .
  data G_BYPASSING_BUFFER type CHAR1 .
  data GS_CLIENT_HANDLING type GTS_CLIENT_HANDLING .
  data G_SAVED_LIST type ABAP_BOOL .
  constants C_SELECT_VERSION_0 type /CADAXO/SQLC_SELECT_VERSION value 0 ##NO_TEXT.
  constants C_SELECT_VERSION_1 type /CADAXO/SQLC_SELECT_VERSION value 1 ##NO_TEXT.
  constants C_SELECT_VERSION_2 type /CADAXO/SQLC_SELECT_VERSION value 2 ##NO_TEXT.
  data G_SELECT_VERSION type /CADAXO/SQLC_SELECT_VERSION read-only .
  data GT_LVC_T_FCAT type LVC_T_FCAT .
  class-data G_MAIN_REF type ref to /CADAXO/CL_SQLC_COCKPIT_MAIN .
  data COLUMN_WORDS_T type /CADAXO/SQLCCODELINE_T .
  data GT_RESULT_DDFIELDS_ALL type /CADAXO/SQLCDFIES_T .
  data G_NO_UPTO type FLAG .
  data GT_COMPONENTS type ABAP_COMPONENT_VIEW_TAB .
  data GT_SUB_COMPONENTS type ABAP_COMPONENT_TAB .

  methods CONSTRUCTOR
    importing
      !I_MAIN_REF_ID type I optional .
  class-methods INSERT_SQL_TO_LOG
    importing
      !I_SQL_STRING type /CADAXO/SQLCSQL_STRING
      !I_SQL_MODE type /CADAXO/SQLCSQL_MODE default '01'
    exporting
      !E_TIMESTAMP type TIMESTAMPL .
  class-methods UPDATE_SQL_TO_LOG
    importing
      !I_SQL_STRING type /CADAXO/SQLCSTRING
      !I_TIMESTAMP type TIMESTAMPL
      !I_RESULT_RUNTIME type /CADAXO/SQLCRESULT_RUNTIME
      !I_RESULT_LINES type /CADAXO/SQLCRESULT_ROWS
      !I_SQL_MODE type /CADAXO/SQLCSQL_MODE default '01' .
  methods EXECUTE_SELECT
    importing
      !I_USER_SETTINGS type /CADAXO/SQLCUSRP_XML optional
      !I_PROGRESS_INDICATOR type CHAR1 optional
    exporting
      !E_RESULT_DETAILS type /CADAXO/SQLCRESULT_DETAILS
    raising
      CX_SY_OPEN_SQL_DB
      /CADAXO/CX_SQLC_SYNTAX_ERROR
      CX_SY_DYNAMIC_OSQL_SEMANTICS
      CX_SY_CONVERSION_OVERFLOW .
  methods EXECUTE_SELECT_V_1
    importing
      !I_USER_SETTINGS type /CADAXO/SQLCUSRP_XML optional
      !I_PROGRESS_INDICATOR type CHAR1 optional
    exporting
      !E_RESULT_DETAILS type /CADAXO/SQLCRESULT_DETAILS
    raising
      CX_SY_OPEN_SQL_DB
      /CADAXO/CX_SQLC_SYNTAX_ERROR
      CX_SY_DYNAMIC_OSQL_SEMANTICS
      CX_SY_CONVERSION_OVERFLOW .
  methods EXECUTE_SELECT_V_2
    importing
      !I_USER_SETTINGS type /CADAXO/SQLCUSRP_XML optional
      !I_PROGRESS_INDICATOR type CHAR1 optional
    exporting
      !E_RESULT_DETAILS type /CADAXO/SQLCRESULT_DETAILS
    raising
      CX_SY_OPEN_SQL_DB
      /CADAXO/CX_SQLC_SYNTAX_ERROR
      CX_SY_DYNAMIC_OSQL_SEMANTICS
      CX_SY_CONVERSION_OVERFLOW .
  methods CREATE_RESULT_STRUCTURES
    importing
      !I_MODE type CHAR1 default 'D' .
  methods BLACKLIST_CHECK_TABLES .
  class-methods PARSE_SQL_I
    importing
      !I_SQL type /CADAXO/SQLCSQL_STRING
      !I_USER_SETTINGS type /CADAXO/SQLCUSRP_XML optional
      !I_ROLE type /CADAXO/SQLCROLE_AUTH_XML optional
      value(I_MAIN_REF_ID) type I optional
      value(I_MAIN_REF) type ref to /CADAXO/CL_SQLC_COCKPIT_MAIN optional
    exporting
      !E_SQL_PARSED type /CADAXO/SQLC_CL_COCKPIT_PARSET
    raising
      /CADAXO/CX_SQLC_NO_SEL_AT_FIRS
      /CADAXO/CX_SQLC_SYNTAX_ERROR
      /CADAXO/CX_SQLC_NO_SOURCE
      /CADAXO/CX_SQLC_TO_MUCH_RESROW .
  methods PARSE_SQL_II
    exceptions
      NO_SELECT_AT_FIRST_POSITION .
  methods PARSE_SQL_II_1
    raising
      /CADAXO/CX_SQLC_TYPE_NOT_FOUND .
  methods PARSE_SQL_II_2
    exceptions
      NO_SELECT_AT_FIRST_POSITION
      /CADAXO/CX_SQLC_TYPE_NOT_FOUND .
  methods PARSE_SQL_WHERE_COLUMNS
    exporting
      !E_WHERE_COLUMN_TAB type /CADAXO/SQLCWHERECOL_STR_T
    raising
      /CADAXO/CX_SQLC_SYMB_NOT_FOUND
      /CADAXO/CX_SQLC_SYNTAX_ERROR
      /CADAXO/CX_SQLC_INVALID_VALUE .
  methods CREATE_ALV_FIELD_CATALOG
    importing
      !I_USER_SETTINGS type /CADAXO/SQLCUSRP_DYN optional
      !I_DRAGDROP_HANDLE type INT4 optional
    returning
      value(R_LVC_T_FCAT) type LVC_T_FCAT .
  class-methods CHECK_SQL_SYNTAX
    importing
      !I_SQL_PARSED type /CADAXO/SQLC_CL_COCKPIT_PARSET
      !I_SELECT_VERSION type /CADAXO/SQLC_SELECT_VERSION default /CADAXO/CL_SQLC_COCKPIT_PARSE=>C_SELECT_VERSION_1
    exporting
      !ET_REST type SCIT_REST
      !E_SELECT_VERSION type /CADAXO/SQLC_SELECT_VERSION
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
  methods SERIALIZE
    exporting
      !E_XML type STRING .
  methods UPDATE_ALV_FIELD_CATALOG_SL
    importing
      !I_USER_SETTINGS type /CADAXO/SQLCUSRP_DYN optional
      !I_DRAGDROP_HANDLE type INT4 optional
    changing
      value(C_LVC_T_FCAT) type LVC_T_FCAT .
  methods CREATE_ALV_FIELD_CATALOG_V_1
    importing
      !I_USER_SETTINGS type /CADAXO/SQLCUSRP_DYN optional
      !I_DRAGDROP_HANDLE type INT4 optional
    returning
      value(R_LVC_T_FCAT) type LVC_T_FCAT .
  methods CREATE_ALV_FIELD_CATALOG_V_2
    importing
      !I_USER_SETTINGS type /CADAXO/SQLCUSRP_DYN optional
      !I_DRAGDROP_HANDLE type INT4 optional
    returning
      value(R_LVC_T_FCAT) type LVC_T_FCAT .
  methods SUBPOOL_RESULT
    importing
      !P_TASK type CLIKE
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
  methods ADD_DOMAIN_VALUE_ELM
    exporting
      !E_ELM type ABAP_SIMPLE_COMPONENTDESCR
      !E_PARENT_STR_NAME type STRING
    changing
      !C_DOMAIN_VALUES type GTT_DOMVAL
      !C_DOMAIN_VALUE type GTS_DOMVAL
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
  methods ADD_DOMAIN_VALUE_SUB
    exporting
      !E_COMP type ABAP_SIMPLE_COMPONENTDESCR
    changing
      !C_COMPONENTS_NEW type ABAP_COMPONENT_TAB
      !C_DOMAIN_VALUES type GTT_DOMVAL
      !C_DOMAIN_VALUE type GTS_DOMVAL
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
  methods ADD_DOMAIN_VALUE
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
protected section.

  types:
*"* protected components of class /CADAXO/CL_SQLC_COCKPIT_PARSE
*"* do not include other source files here!!!
    BEGIN OF gts_subpool_result,
           task TYPE char32.
          INCLUDE type /cadaxo/sqlcresult_details.
  TYPES: END OF gts_subpool_result .
  types:
    gtt_subpool_result type TABLE OF gts_subpool_result .

  data GT_SYMBOL_VARIABLE type GTT_SYMBOL_VARIABLE .
  class-data SQL_STRING type STRING .
  constants C_APOSTROPHE type CHAR1 value '''' ##NO_TEXT.
  class-data GT_ABAP_TYPEDESCR type /CADAXO/SQLCTABTYPEDESCR_T .
  class-data G_USER_SETTINGS type /CADAXO/SQLCUSRP_XML .
  data G_COUNT_SUBROUTINENPOOL type INT4 .
  class-data G_ROLE type /CADAXO/SQLCROLE_AUTH_XML .
  data G_ASYNC_CALLS type INT4 .
  data G_ERROR_MESSAGE type STRING .
  data G_TMP_RESULT_DETAILS type /CADAXO/SQLCRESULT_DETAILS .
  data GT_SUBPOOL_RESULT type GTT_SUBPOOL_RESULT .
  data MR_ARFC_EXCEPTION type ref to CX_ROOT .

  class-methods GET_MULTISYMBOL_DATA_TABLE
    exporting
      !E_SYMBOL_VARIABLE type GTT_SYMBOL_VARIABLE
    changing
      !I_WHERE_SYNTAX type STRING .
  class-methods IS_COUNT_STAR_ONLY
    importing
      !IV_FIELDLIST type STRING
    returning
      value(EV_IS_COUNT_STAR_ONLY) type FLAG .
  methods EXECUTE_SELECT_VIA_SUBPOOL
    importing
      !I_PROGRESS_INDICATOR type CHAR1 optional
    exporting
      !E_RESULT_DETAILS type /CADAXO/SQLCRESULT_DETAILS
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
  class-methods CHECK_SQL_STRING_INCLUDES_SUBQ
    importing
      !I_SQL_STRING type /CADAXO/SQLCSQL_STRING
    returning
      value(R_TRUE) type /CADAXO/SQLCFLAGTRUEFALSE .
  methods GET_DDIC_FIELD_LIST
    importing
      !I_CL_ABAP_STRUCTDESCR type ref to CL_ABAP_STRUCTDESCR
    returning
      value(R_FIELDS_T) type DDFIELDS .
  class-methods CONCATENATE_AGGR_PREFIX
    importing
      !I_PREFIX type STRING
    changing
      !C_SQLCDFIES type /CADAXO/SQLCDFIES .
  class-methods GET_ABAP_TYPEDESCR
    importing
      !I_NAME type STRING
    returning
      value(R_ABAP_TYPEDESCR) type ref to CL_ABAP_TYPEDESCR
    raising
      /CADAXO/CX_SQLC_TYPE_NOT_FOUND .
  methods SPLIT_FIELD
    importing
      !I_FIELD type ANY
    exporting
      !E_FIELD type ANY
      !E_TABLE type ANY
      !E_ALIAS type ANY
      !E_TABFLD type ANY .
  class-methods BUILD_ABAP_CODE
    importing
      !I_CL_COCKPIT_PARSE type ref to /CADAXO/CL_SQLC_COCKPIT_PARSE
      !I_SELECT_VERSION type /CADAXO/SQLC_SELECT_VERSION default /CADAXO/CL_SQLC_COCKPIT_PARSE=>C_SELECT_VERSION_1
    exporting
      !E_ABAP_CODE type /CADAXO/SQLCSTRING_T
      !E_ABAP_CODE_DATA type /CADAXO/SQLCSTRING_T .
  class-methods FORMAT_ABAP_CODE
    importing
      !I_COLUMNS type I optional
    changing
      !CT_ABAP_CODE type /CADAXO/SQLCSTRING_T .
  methods FORMAT_VALUE_WO_DDIC
    importing
      !IV_VALUE type CSEQUENCE
    changing
      !CV_VALUE type ANY
    raising
      CX_SY_CONVERSION_NO_NUMBER .
  methods FORMAT_VALUE
    importing
      !I_ABAP_TYPE type ref to CL_ABAP_ELEMDESCR
    exporting
      !E_ADDED type I
    changing
      !C_WHERE_COL type /CADAXO/SQLCWHERECOL_STR
    raising
      CX_SY_CONVERSION_NO_NUMBER
      /CADAXO/CX_SQLC_INVALID_VALUE .
  methods EXECUTE_SELECT_VIA_SUBPOOL_V_2
    importing
      !I_PROGRESS_INDICATOR type CHAR1 optional
    exporting
      !E_RESULT_DETAILS type /CADAXO/SQLCRESULT_DETAILS
    raising
      /CADAXO/CX_SQLC_SYNTAX_ERROR .
  methods SPLIT_FIELD_V_2
    importing
      !I_VALUE type STRING
    exporting
      !E_TABLE type STRING
      !E_FIELD type STRING
      !E_ALIAS type STRING
      !E_ALIAS_FIELD type STRING .
  methods GET_CODE_DBHINTS
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_ORDER_BY
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_GROUP_BY
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_HAVING
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_BYPASSING_BUFFER
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_CONNECTION
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_WHERE
    importing
      !I_ONLY_INITVAL type ABAP_BOOL optional
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_FIELDS
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_OFFSET
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_INTO
    importing
      !I_PROGRESS_INDICATOR type CHAR1 optional
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_UP_TO_ROWS
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_TRACE_ON
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods GET_CODE_TRACE_OFF
    changing
      value(CT_CODE) type /CADAXO/SQLCSTRING_T .
  methods CHECK_RUNTIME_ERROR
    importing
      !IV_ERROR_MESSAGE type STRING
    returning
      value(EV_ERROR_MESSAGE) type STRING .
  class-methods CHECK_FOR_HOST_EXPRESSIONS
    importing
      !I_STRING type STRING .
  class-methods CHECK_FOR_HOST_EXPR_METH
    importing
      !I_STRING type STRING .
private section.

*"* private components of class /CADAXO/CL_SQLC_COCKPIT_PARSE
*"* do not include other source files here!!!
  data G_MAIN_REF_ID type I .
ENDCLASS.



CLASS /CADAXO/CL_SQLC_COCKPIT_PARSE IMPLEMENTATION.


METHOD add_domain_value.
****************************************************************************************************
* Description             : Add Domainvalues to Result List                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations : COCKPIT-458                                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Attila Kajtar            Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
  DATA structure TYPE REF TO cl_abap_structdescr.
  DATA structure_new TYPE REF TO cl_abap_structdescr.
  DATA sub_structure TYPE REF TO cl_abap_structdescr.
  DATA tabledescr TYPE REF TO cl_abap_tabledescr.
  DATA tabledescr_new TYPE REF TO cl_abap_tabledescr.
  DATA elementdescr TYPE REF TO cl_abap_elemdescr.
  DATA lv_string TYPE string.
  DATA components_new TYPE abap_component_tab.
  DATA domain_values TYPE STANDARD TABLE OF gts_domval.
  DATA domain_value TYPE gts_domval.
  DATA result_new TYPE REF TO data.
  DATA result_struct_new TYPE REF TO data.
  FIELD-SYMBOLS <result_table> TYPE STANDARD TABLE.
  FIELD-SYMBOLS <result_new> TYPE STANDARD TABLE.

  ASSIGN me->result_table->* TO <result_table>.
  tabledescr ?= cl_abap_tabledescr=>describe_by_data( <result_table> ).
  structure ?= tabledescr->get_table_line_type( ).
  me->gt_components = structure->get_included_view( ).

  LOOP AT me->gt_components ASSIGNING FIELD-SYMBOL(<comp>).
    TRY.

        CLEAR me->gt_sub_components.
        sub_structure ?= <comp>-type.

        add_domain_value_sub(
          IMPORTING
            e_comp                       = <comp>
          CHANGING
            c_components_new             = components_new
            c_domain_values              = domain_values
            c_domain_value               = domain_value
        ).

      CATCH cx_sy_move_cast_error.
        elementdescr ?= <comp>-type.

        add_domain_value_elm(
          IMPORTING
            e_elm                        = <comp>
            e_parent_str_name            = lv_string
          CHANGING
            c_domain_values              = domain_values
            c_domain_value               = domain_value
        ).

        APPEND LINES OF me->gt_sub_components TO components_new.
    ENDTRY.
  ENDLOOP.

  structure_new ?= cl_abap_structdescr=>create( components_new ).

  tabledescr_new ?= cl_abap_tabledescr=>create( structure_new ).

  CREATE DATA result_new TYPE HANDLE tabledescr_new.
  CREATE DATA result_struct_new TYPE HANDLE structure_new.

  ASSIGN result_new->* TO <result_new>.
  ASSIGN result_struct_new->* TO FIELD-SYMBOL(<result_struct_new>).

  LOOP AT <result_table> ASSIGNING FIELD-SYMBOL(<result_line>).
    CLEAR: <result_struct_new>.
    MOVE-CORRESPONDING <result_line> TO <result_struct_new>.

    LOOP AT domain_values ASSIGNING FIELD-SYMBOL(<domain_value>).
      ASSIGN COMPONENT <domain_value>-name OF STRUCTURE <result_line> TO FIELD-SYMBOL(<value_key>).
      ASSIGN COMPONENT <domain_value>-name_desc OF STRUCTURE <result_struct_new> TO FIELD-SYMBOL(<value_description>).

      IF <value_key> IS ASSIGNED AND <value_description> IS ASSIGNED.
        READ TABLE <domain_value>-fixed_values WITH KEY low = <value_key> ASSIGNING FIELD-SYMBOL(<dom_value>).
        IF sy-subrc = 0.
          <value_description> = <dom_value>-ddtext.
        ENDIF.
      ENDIF.
    ENDLOOP.

    APPEND <result_struct_new> TO <result_new>.
  ENDLOOP.

  LOOP AT gt_lvc_t_fcat ASSIGNING FIELD-SYMBOL(<lvc_s_fcat>).
    <lvc_s_fcat>-col_pos = sy-tabix.
  ENDLOOP.

  me->result_table = result_new.

ENDMETHOD.


METHOD add_domain_value_elm.
****************************************************************************************************
* Description             : Add Domainvalues to Result List Element processing                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations : COCKPIT-458                                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Attila Kajtar            Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

  DATA rollname_elem TYPE REF TO cl_abap_elemdescr.
  DATA component_new TYPE abap_componentdescr.
  DATA l_fcat_line TYPE lvc_s_fcat.
  DATA fieldname TYPE string.
  DATA fieldname_fcat TYPE string.
  DATA result_ddfields TYPE /cadaxo/sqlcdfies.

  component_new-name = e_elm-name.
  component_new-type = e_elm-type.
  APPEND component_new TO me->gt_sub_components.

  IF e_parent_str_name IS NOT INITIAL.
    fieldname = e_parent_str_name && '-' && e_elm-name.
  ELSE.
    fieldname = e_elm-name.
  ENDIF.

  READ TABLE me->gt_lvc_t_fcat WITH KEY fieldname = fieldname ASSIGNING FIELD-SYMBOL(<fcat>).
  IF sy-subrc = 0.
    IF <fcat>-domname IS NOT INITIAL.
      rollname_elem ?= cl_abap_elemdescr=>describe_by_name( <fcat>-rollname ).
      DATA(fixed_values) = rollname_elem->get_ddic_fixed_values( ).

      IF fixed_values IS NOT INITIAL.
        component_new-name = 'Q' && to_upper( cl_system_uuid=>create_uuid_c22_static( ) ).
        REPLACE ALL OCCURRENCES OF '}' IN component_new-name WITH 'A'.
        REPLACE ALL OCCURRENCES OF '{' IN component_new-name WITH 'B'.

        IF NOT line_exists( c_domain_values[ name = e_elm-name ] ).
          IF e_parent_str_name IS NOT INITIAL.
            c_domain_value-name = e_parent_str_name && '-' && e_elm-name.
            c_domain_value-name_desc = e_parent_str_name && '-' && component_new-name.
          ELSE.
            c_domain_value-name = e_elm-name.
            c_domain_value-name_desc = component_new-name.
          ENDIF.
          c_domain_value-fixed_values = fixed_values.
          APPEND c_domain_value TO c_domain_values.
        ENDIF.

        IF e_parent_str_name IS NOT INITIAL.
          l_fcat_line-fieldname = e_parent_str_name && '-' && component_new-name.
        ELSE.
          l_fcat_line-fieldname = component_new-name.
        ENDIF.

        READ TABLE gt_lvc_t_fcat WITH KEY fieldname = fieldname INTO DATA(lvc_t_fcat).
        DATA(tab) = sy-tabix + 1.
        IF lvc_t_fcat IS NOT INITIAL.
          l_fcat_line-reptext   = lvc_t_fcat-reptext.
          l_fcat_line-scrtext_s = lvc_t_fcat-scrtext_s.
          l_fcat_line-scrtext_m = lvc_t_fcat-scrtext_m.
          l_fcat_line-scrtext_l = lvc_t_fcat-scrtext_l.

          CLEAR: l_fcat_line-coltext.

          IF me->g_user_settings-colhd_type EQ '1' OR
            me->g_user_settings-colhd_type  EQ space.
            l_fcat_line-coltext     =  component_new-name.
            IF NOT me->g_user_settings-hd_show_alias IS INITIAL.
              IF e_parent_str_name IS INITIAL.
                l_fcat_line-coltext = component_new-name.
              ELSE.
                l_fcat_line-coltext = e_parent_str_name && '~' && component_new-name.
              ENDIF.
            ENDIF.
          ELSE.
            IF NOT me->g_user_settings-hd_fieldname IS INITIAL.
              l_fcat_line-coltext = e_elm-name.
            ENDIF.
            CASE abap_true.
              WHEN me->g_user_settings-hd_fieldtext_s.
                MOVE l_fcat_line-scrtext_s TO l_fcat_line-coltext.
              WHEN me->g_user_settings-hd_fieldtext_m.
                MOVE l_fcat_line-scrtext_m TO l_fcat_line-coltext.
              WHEN me->g_user_settings-hd_fieldtext_l.
                MOVE l_fcat_line-scrtext_l TO l_fcat_line-coltext.
            ENDCASE.
          ENDIF.

          IF l_fcat_line-coltext IS INITIAL AND me->g_user_settings-hd_fieldtext_a IS INITIAL.
            l_fcat_line-coltext = lvc_t_fcat-fieldname.
          ENDIF.
          l_fcat_line-col_pos = tab.
          l_fcat_line-outputlen = 60.
          INSERT l_fcat_line INTO me->gt_lvc_t_fcat INDEX tab.
        ENDIF.

        component_new-type = cl_abap_elemdescr=>get_c( p_length = 60 ).
        APPEND component_new TO me->gt_sub_components.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD add_domain_value_sub.
****************************************************************************************************
* Description             : Add Domainvalues to Result Substructure                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations : COCKPIT-458                                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Attila Kajtar            Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    : 21.10.2020                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

  DATA lr_substructure TYPE REF TO cl_abap_structdescr.
  DATA sub_structure_check TYPE REF TO cl_abap_structdescr.
  DATA component_new TYPE abap_componentdescr.
  DATA structure_new TYPE REF TO cl_abap_structdescr.

  lr_substructure ?= e_comp-type.
  DATA(components) =  lr_substructure->get_included_view( ).

  LOOP AT components ASSIGNING FIELD-SYMBOL(<comp>).
    TRY.
        sub_structure_check ?= <comp>-type.
        add_domain_value_sub( IMPORTING e_comp           = <comp>
                              CHANGING  c_components_new = c_components_new
                                        c_domain_values	 = c_domain_values
                                        c_domain_value   = c_domain_value
                                         ).
      CATCH cx_sy_move_cast_error.
        add_domain_value_elm(
          IMPORTING
            e_elm                        = <comp>
            e_parent_str_name            = e_comp-name
          CHANGING
            c_domain_values              = c_domain_values
            c_domain_value               = c_domain_value
        ).
    ENDTRY.

  ENDLOOP.

  structure_new ?= cl_abap_structdescr=>create( me->gt_sub_components ).

  component_new-name = e_comp-name.
  component_new-type = structure_new.
  APPEND component_new TO c_components_new.

ENDMETHOD.


METHOD blacklist_check_tables.
****************************************************************************************************
* Description             : Check authorizations                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
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
* 08.03.2011 | Fößleitner Johann    | Check the S_TABU_DIS authorization          | CDX001-022     *
*------------+----------------------+---------------------------------------------+----------------*
* 06.07.2017 | Harald Wiesinger     | New message when user has no roles assigned | COCKPIT-212    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

  DATA: l_yes    TYPE c,
        l_tables TYPE string.

  FIELD-SYMBOLS: <l_result_source> LIKE LINE OF me->result_source_t,
                 <l_auth>          TYPE /cadaxo/sqlctable_auth.

* check blacklist tables
  LOOP AT me->result_source_t ASSIGNING <l_result_source>.
    /cadaxo/cl_sqlc_cockpit_assist=>blacklist_check_table(
      EXPORTING  i_table                = <l_result_source>-table
      EXCEPTIONS table_access_forbidden = 1
                 OTHERS                 = 2 ).
    IF sy-subrc NE 0.
      MESSAGE e010(/cadaxo/sqlc) WITH <l_result_source>-table.
    ENDIF.
  ENDLOOP.

* check user authorization
  LOOP AT me->result_source_t ASSIGNING <l_result_source>.

    CLEAR l_yes.

    LOOP AT me->g_role-included ASSIGNING <l_auth>.
      IF <l_result_source>-table CP <l_auth> OR
         <l_result_source>-table EQ <l_auth>.
        l_yes = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

    IF l_yes = abap_true.
      LOOP AT me->g_role-excluded ASSIGNING <l_auth>.
        IF <l_result_source>-table CP <l_auth>.
          CLEAR l_yes.
          IF l_tables IS INITIAL.
            MOVE <l_result_source>-table TO l_tables.
          ELSE.
            CONCATENATE l_tables ',' INTO l_tables.
            CONCATENATE l_tables <l_result_source>-table INTO l_tables SEPARATED BY space.
          ENDIF.
          EXIT.
        ENDIF.
      ENDLOOP.
    ELSE.
      IF l_tables IS INITIAL.
        MOVE <l_result_source>-table TO l_tables.
      ELSE.
        CONCATENATE l_tables ',' INTO l_tables.
        CONCATENATE l_tables <l_result_source>-table INTO l_tables SEPARATED BY space.
      ENDIF.
    ENDIF.

  ENDLOOP.

* send error message if no authorization
  IF me->g_role-excluded IS INITIAL AND me->g_role-included IS INITIAL.               "COCKPIT-212
    MESSAGE e118(/cadaxo/sqlc).                                                       "COCKPIT-212
  ELSEIF l_yes EQ space.                                                              "COCKPIT-212
    MESSAGE e010(/cadaxo/sqlc) WITH l_tables.
  ELSE.
* also check the s_tabu_dis authority
    CLEAR l_tables.                                         "CDX001-022
    DATA l_view_name(30) TYPE c.
    LOOP AT me->result_source_t ASSIGNING <l_result_source>.
      l_view_name = <l_result_source>-table.
      CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
        EXPORTING
          view_action                    = 'U'
          view_name                      = l_view_name
          no_warning_for_clientindep     = 'X'
        EXCEPTIONS
          invalid_action                 = 1
          no_authority                   = 2
          no_clientindependent_authority = 3
          table_not_found                = 4
          no_linedependent_authority     = 5
          OTHERS                         = 6.
      IF sy-subrc NE 0.
        CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
          EXPORTING
            view_action                    = 'S'
            view_name                      = l_view_name
            no_warning_for_clientindep     = 'X'
          EXCEPTIONS
            invalid_action                 = 1
            no_authority                   = 2
            no_clientindependent_authority = 3
            table_not_found                = 4
            no_linedependent_authority     = 5
            OTHERS                         = 6.
        IF sy-subrc NE 0.
          IF l_tables IS INITIAL.
            MOVE <l_result_source>-table TO l_tables.
          ELSE.
            CONCATENATE l_tables ',' INTO l_tables.
            CONCATENATE l_tables <l_result_source>-table INTO l_tables SEPARATED BY space.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.                                                "CDX001-022
    IF NOT l_tables IS INITIAL.                             "CDX001-022
      MESSAGE e058(/cadaxo/sqlc) WITH l_tables.             "CDX001-022
    ENDIF.                                                  "CDX001-022
  ENDIF.

ENDMETHOD.


METHOD build_abap_code.
****************************************************************************************************
* Description             : Build the main abap code for syntax-check and subroutine pool          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 31.12.2015 | Fößleitner Johann    | SQL Cockpit 3.0 - SQL Expressions!          |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

  DATA l_line       LIKE LINE OF e_abap_code.
  DATA l_dummy      TYPE string.

  CLEAR: e_abap_code[].

  IF NOT i_cl_cockpit_parse->g_select_single IS INITIAL.
    APPEND 'FIELD-SYMBOLS: <FS_STR_RESULT> TYPE ANY.' TO e_abap_code_data.
    APPEND 'APPEND INITIAL LINE TO TAB_RESULT ASSIGNING <fs_str_result>.' TO e_abap_code.
    CONCATENATE ' SELECT SINGLE' i_cl_cockpit_parse->column_syntax INTO l_line SEPARATED BY space.
  ELSE.
    IF NOT i_cl_cockpit_parse->g_select_distinct IS INITIAL.
      CONCATENATE ' SELECT DISTINCT' i_cl_cockpit_parse->column_syntax INTO l_line SEPARATED BY space.
    ELSE.
      CONCATENATE ' SELECT' i_cl_cockpit_parse->column_syntax INTO l_line SEPARATED BY space.
    ENDIF.
  ENDIF.

  APPEND l_line TO e_abap_code.

  l_dummy = i_cl_cockpit_parse->source_syntax && i_cl_cockpit_parse->cds_parameter_syntax.
  CONCATENATE ' FROM' l_dummy INTO l_line SEPARATED BY space.

ENHANCEMENT-SECTION /cadaxo/sqlc_ehn_s_cls_se_002 SPOTS /cadaxo/sqlc_ehnsp_cls_se_001.
*...
END-ENHANCEMENT-SECTION.
  APPEND l_line TO e_abap_code.



  IF i_select_version = c_select_version_1 OR
     i_select_version = c_select_version_0.

    IF i_cl_cockpit_parse->fields_syntax IS INITIAL.
      i_cl_cockpit_parse->get_code_up_to_rows( CHANGING ct_code = e_abap_code ).

      i_cl_cockpit_parse->get_code_bypassing_buffer( CHANGING ct_code = e_abap_code ).

      i_cl_cockpit_parse->get_code_connection( CHANGING ct_code = e_abap_code ).

    ELSE.
      i_cl_cockpit_parse->get_code_fields( CHANGING ct_code = e_abap_code ).
    ENDIF.

    IF NOT i_cl_cockpit_parse->g_select_single IS INITIAL.
      APPEND ' INTO <fs_str_result>' TO e_abap_code.
    ELSE.
      APPEND ' INTO TABLE TAB_RESULT' TO e_abap_code.
    ENDIF.
  ELSEIF i_select_version = c_select_version_2.
    i_cl_cockpit_parse->get_code_fields( CHANGING ct_code = e_abap_code ).
  ENDIF.

  i_cl_cockpit_parse->get_code_where(
    EXPORTING i_only_initval = abap_true
    CHANGING ct_code = e_abap_code
  ).

  i_cl_cockpit_parse->get_code_group_by( CHANGING ct_code = e_abap_code ).

  i_cl_cockpit_parse->get_code_having( CHANGING ct_code = e_abap_code ).

  i_cl_cockpit_parse->get_code_order_by( CHANGING ct_code = e_abap_code ).

  IF i_select_version = c_select_version_2.
    IF NOT i_cl_cockpit_parse->g_select_single IS INITIAL.
      APPEND ' INTO @DATA(LS_RESULTDATA)' TO e_abap_code.
    ELSE.
      APPEND ' INTO TABLE @DATA(TAB_RESULTDATA)' TO e_abap_code.
    ENDIF.

    i_cl_cockpit_parse->get_code_offset( CHANGING ct_code = e_abap_code ).

    i_cl_cockpit_parse->get_code_up_to_rows( CHANGING ct_code = e_abap_code ).

    i_cl_cockpit_parse->get_code_bypassing_buffer( CHANGING ct_code = e_abap_code ).

    i_cl_cockpit_parse->get_code_connection( CHANGING ct_code = e_abap_code ).

  ELSEIF i_select_version = c_select_version_1.

    i_cl_cockpit_parse->get_code_offset( CHANGING ct_code = e_abap_code ).

    IF i_cl_cockpit_parse->fields_syntax IS NOT INITIAL.

      i_cl_cockpit_parse->get_code_up_to_rows( CHANGING ct_code = e_abap_code ).

      i_cl_cockpit_parse->get_code_bypassing_buffer( CHANGING ct_code = e_abap_code ).

      i_cl_cockpit_parse->get_code_connection( CHANGING ct_code = e_abap_code ).

    ENDIF.

  ENDIF.

  i_cl_cockpit_parse->get_code_dbhints( CHANGING ct_code = e_abap_code ).

  APPEND '.' TO e_abap_code.

ENDMETHOD.


  METHOD check_for_host_expressions.

    DATA l_string TYPE string.
    DATA l_message TYPE string.

    l_string = i_string.

* replace all '' with space
    REPLACE ALL OCCURRENCES OF '''''' IN l_string WITH space.

* replace all 'xyz' with space
    REPLACE ALL OCCURRENCES OF REGEX '.''.[^'']*.?''' IN l_string WITH space.

    FIND REGEX '^.*@\(.*\).*$' IN l_string.
    IF sy-subrc = 0.
      MESSAGE e135(/cadaxo/sqlc) INTO l_message.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
        EXPORTING
          message       = l_message
          /cadaxo/msgid = '/CADAXO/SQLC'
          /cadaxo/msgnr = '135'.

    ENDIF.

  ENDMETHOD.


  METHOD check_for_host_expr_meth.

    DATA l_string TYPE string.
    DATA l_message TYPE string.
    DATA l_functional_method TYPE string.
    DATA l_class TYPE string.
    DATA l_method TYPE string.

    l_string = i_string.

* replace all '' with space
    REPLACE ALL OCCURRENCES OF '''''' IN l_string WITH space.

* replace all 'xyz' with space
    REPLACE ALL OCCURRENCES OF REGEX '.''.[^'']*.?''' IN l_string WITH space.

    " find static method call
    FIND REGEX '^.*@\(\s.*\s*([\w_]*=>[\w_]*)\(.*$' IN l_string
       SUBMATCHES l_functional_method.
    IF sy-subrc <> 0.
      "find instance method call
      FIND REGEX '^.*@\(\s.*NEW\s*([\w_]*\(\s*\)->[\w_]*)\(.*$' IN l_string
        SUBMATCHES l_functional_method.
    ENDIF.

    IF l_functional_method IS NOT INITIAL.

      FIND REGEX '^(.*)=>(.*)$' IN l_functional_method SUBMATCHES l_class l_method.
      IF sy-subrc <> 0.
        FIND REGEX '^(.*)\(\s+\)->(.*)$' IN l_functional_method SUBMATCHES l_class l_method.
      ENDIF.

      IF l_class IS INITIAL OR l_method IS INITIAL.

        MESSAGE e152(/cadaxo/sqlc) INTO l_message WITH l_functional_method.

        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
          EXPORTING
            message       = l_message
            /cadaxo/msgid = '/CADAXO/SQLC'
            /cadaxo/msgnr = '152'.

      ELSE.

        SELECT SINGLE @abap_true INTO @DATA(l_true) FROM /cadaxo/sqlchecl WHERE class = @l_class
                                                                            AND method = @l_method
                                                                            and active = @abap_true.
        IF l_true <> abap_true.

          MESSAGE e152(/cadaxo/sqlc) INTO l_message WITH l_functional_method.

          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
            EXPORTING
              message       = l_message
              /cadaxo/msgid = '/CADAXO/SQLC'
              /cadaxo/msgnr = '152'.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_runtime_error.
****************************************************************************************************
* Description             : Check fro Runtime Error and adjust Error Messages                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 19.02.2017               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
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

    DATA: lv_dump_msg TYPE string.

    ev_error_message = iv_error_message.

    IF sy-msgid = '00' AND sy-msgno = '341'.
*   Runtime error & has occurred
      DATA(lv_dump) = sy-msgv1.
*      ev_error_message = ev_error_message && text-e03.

      MESSAGE e110(/cadaxo/sqlc) WITH iv_error_message INTO DATA(lv_main_msg).
*   The SELECT cannot be executed: &1
      CASE lv_dump.
        WHEN 'SAPSQL_DATA_LOSS'.
          MESSAGE e111(/cadaxo/sqlc) WITH '&1' INTO DATA(lv_reason_msg).
*   Possible Reason: &1

          MESSAGE e112(/cadaxo/sqlc) INTO lv_dump_msg.
*   A value in the WHERE clause is longer than the database field

          DATA(lv_combined_msg) = replace( val = lv_reason_msg sub = '&1' with = lv_dump_msg ).
          lv_dump_msg = lv_combined_msg.

      ENDCASE.

      APPEND VALUE #( msgtype = icon_red_light
                      text    = lv_main_msg ) TO me->g_main_ref->gt_errors.

      IF lv_dump_msg IS NOT INITIAL.
        APPEND VALUE #( msgtype = icon_red_light
                        text    = lv_dump_msg ) TO me->g_main_ref->gt_errors.
      ENDIF.

      APPEND VALUE #( msgtype = icon_red_light
                      text    = replace( val = text-x00 sub = '&1' with = lv_dump ) ) TO me->g_main_ref->gt_errors.

    ELSE.
      APPEND VALUE #( msgtype = icon_red_light
                      text    = ev_error_message ) TO me->g_main_ref->gt_errors.

    ENDIF.


  ENDMETHOD.


METHOD check_sql_string_includes_subq.
****************************************************************************************************
* Description             : Check, if the sql command includes a subquery                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | Fößleitner Johann    | Fixed the Problem with the Regex            | CDX001-0011    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

  DATA: l_tmp_string(999).

  MOVE i_sql_string TO l_tmp_string.

* replace all '' with space
  REPLACE ALL OCCURRENCES OF '''''' IN l_tmp_string WITH space.

* replace all 'xyz' with space
  REPLACE ALL OCCURRENCES OF REGEX '.''.[^'']*.?''' IN l_tmp_string WITH space.  "CDX001-0011

* and now, check if there is a select command in the given where- or having-syntax
  FIND 'SELECT' IN l_tmp_string.
  IF sy-subrc EQ 0.
    r_true = 'X'.
  ENDIF.

ENDMETHOD.


METHOD check_sql_syntax.
****************************************************************************************************
* Description ....... Checks the Syntax of a sql statement                                         *
* Developer ......... Johann Fößleitner       Date .... 03.02.2010                                 *
* Status ............ xxxxxxxxx                                                                    *                                                                                                  *
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
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

  DATA: lt_line TYPE sedi_source.

  DATA: l_mess TYPE edmessage, "string,                                 "#EC NEEDED
        l_lin  TYPE i,                                      "#EC NEEDED
        l_wrd  TYPE tdbaustein, "string,                         "#EC NEEDED
        l_dir  TYPE trdir.                                  "#EC NEEDED

  DATA lt_abap_code_data TYPE /cadaxo/sqlcstring_t.
  DATA lt_abap_code_prog TYPE /cadaxo/sqlcstring_t.

  DATA lr_cl_ci_check_result  TYPE REF TO cl_ci_check_result.
  DATA lr_cl_ci_inspection    TYPE REF TO cl_ci_inspection.
  DATA lt_rest                TYPE scit_rest.
  DATA lr_cl_ci_test_root     TYPE REF TO cl_ci_test_root.
  DATA ls_adm_cust            TYPE /cadaxo/sqlc_admin_cust.
  DATA lwa_key                TYPE trmsg_key.

  DATA lt_results             TYPE match_result_tab.            "COCKPIT-214
  DATA lv_select_version      TYPE /cadaxo/sqlc_select_version. "COCKPIT-214

  FIELD-SYMBOLS: <l_cl_sql_parse> TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.

  LOOP AT i_sql_parsed ASSIGNING <l_cl_sql_parse>.

    lv_select_version = i_select_version.                         "COCKPIT-214

    IF lv_select_version = c_select_version_1.                    "COCKPIT-214
      /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex(          "COCKPIT-214
        EXPORTING i_where_syntax = <l_cl_sql_parse>->where_syntax "COCKPIT-214
        IMPORTING e_result_tab   =  lt_results                    "COCKPIT-214
      ).

      IF lt_results IS NOT INITIAL.                               "COCKPIT-214
        lv_select_version = c_select_version_2.                   "COCKPIT-214
      ENDIF.                                                      "COCKPIT-214
    ENDIF.                                                        "COCKPIT-214


* create main abap code.
    CLEAR lt_abap_code_data.
    CLEAR lt_abap_code_prog.
    CLEAR lt_line.

    APPEND 'PROGRAM SYNTAX_CHECK.' TO lt_line.
    APPEND 'FORM UNTER TABLES TAB_RESULT.' TO lt_line.

* create main abap code.
    /cadaxo/cl_sqlc_cockpit_parse=>build_abap_code(
       EXPORTING i_cl_cockpit_parse = <l_cl_sql_parse>
                 i_select_version   = lv_select_version
       IMPORTING e_abap_code      = lt_abap_code_prog
                 e_abap_code_data = lt_abap_code_data ).

    format_abap_code( EXPORTING i_columns    = 254                   "COCKPIT-223
                      CHANGING  ct_abap_code = lt_abap_code_prog ).  "COCKPIT-223

    SORT lt_abap_code_data.
    DELETE ADJACENT DUPLICATES FROM lt_abap_code_data.

    APPEND LINES OF lt_abap_code_data TO lt_line.
    APPEND LINES OF lt_abap_code_prog TO lt_line.

    APPEND 'ENDFORM.' TO lt_line.

    l_dir-uccheck = 'X'.
    l_dir-fixpt   = 'X'.

* do the check syntax
    SYNTAX-CHECK FOR lt_line MESSAGE l_mess LINE l_lin WORD l_wrd DIRECTORY ENTRY l_dir MESSAGE-ID lwa_key.

    IF lwa_key-keyword = 'SELECT' AND (   lv_select_version = c_select_version_1 AND (    lwa_key-msgnumber = '484'
                                                                                      OR lwa_key-msgnumber = '487'
                                                                                      OR lwa_key-msgnumber = '541'
                                                                                      OR lwa_key-msgnumber = '544' )
                                       OR lv_select_version = c_select_version_2 AND (    lwa_key-msgnumber = '547' ) )
       OR lwa_key-keyword = 'MESSAGE'  AND (   lv_select_version = c_select_version_1 AND lwa_key-msgnumber = 'G2F' ).

      IF lv_select_version = c_select_version_2 AND ( lwa_key-msgnumber = '547' ).
        IF <l_cl_sql_parse>->g_no_upto IS INITIAL.
          <l_cl_sql_parse>->g_no_upto = abap_true.
        ELSE.
          DATA(lv_loop) = abap_true.
        ENDIF.

      ENDIF.
      IF lv_loop IS INITIAL.
        /cadaxo/cl_sqlc_cockpit_parse=>check_sql_syntax(
          EXPORTING
            i_sql_parsed                 = VALUE #( ( <l_cl_sql_parse> ) ) "i_sql_parsed
            i_select_version             = c_select_version_2
          IMPORTING
            et_rest                      = et_rest
            e_select_version               = <l_cl_sql_parse>->g_select_version ).
        CLEAR l_mess.
        CLEAR lwa_key.
      ENDIF.
    ELSE.
      <l_cl_sql_parse>->g_select_version = lv_select_version.
    ENDIF.

* show popup-message, if there is an error
    IF NOT l_mess IS INITIAL.
      IF ( lwa_key-keyword = 'MESSAGE' AND lwa_key-msgnumber = 'GAN' ) OR
         ( lwa_key-keyword = 'SYS$$INCOMPLETE$$' AND lwa_key-msgnumber = '000' ).
*The length of the current statement is greater that the allowed maximum length of 28 kilobytes.
*The last statement is not complete (period missing).
        l_mess = l_mess && ' ' && text-e04.
      ENDIF.

*    RAISE syntax_error.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
        EXPORTING
          message = CONV #( l_mess ).
    ELSE.

      CLEAR lt_rest.

      CALL METHOD /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing
        IMPORTING
          e_customizing = ls_adm_cust.
      IF ls_adm_cust-sci_chkv NE space.

        CALL FUNCTION 'PRETTY_PRINTER'
          EXPORTING
            inctoo = space
          TABLES
            ntext  = lt_line
            otext  = lt_line.

        TRY.

            CALL METHOD cl_ci_check=>source_code
              EXPORTING
                p_variant = ls_adm_cust-sci_chkv
                p_code    = lt_line
              IMPORTING
                p_result  = lr_cl_ci_check_result.

            lr_cl_ci_inspection = lr_cl_ci_check_result->get_inspection( ).

            lt_rest = lr_cl_ci_inspection->scirestps.

            DELETE lt_rest WHERE kind NE 'E' AND kind NE 'W'.

            DELETE lt_rest WHERE test EQ 'CL_CI_TEST_EXTENDED_CHECK'.

            et_rest = lt_rest.

          CATCH cx_ci_invalid_variant ##NO_HANDLER.
          CATCH cx_ci_check_error ##NO_HANDLER.
          CATCH cx_ci_invalid_object ##NO_HANDLER.
        ENDTRY.
      ENDIF.
    ENDIF.
  ENDLOOP.

  FREE: lt_abap_code_data,
        lt_abap_code_prog,
        lr_cl_ci_check_result,
        lr_cl_ci_inspection,
        lt_rest,
        lr_cl_ci_test_root,
        ls_adm_cust.

ENDMETHOD.


METHOD CONCATENATE_AGGR_PREFIX.
****************************************************************************************************
* Description             : Concatenate aggregations with fieldnames                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
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

  CONCATENATE i_prefix '(' : c_sqlcdfies-fieldname ')' INTO c_sqlcdfies-colhd_fieldname, "Fieldname
                             c_sqlcdfies-scrtext_l ')' INTO c_sqlcdfies-scrtext_l,       "Long Field Label
                             c_sqlcdfies-scrtext_m ')' INTO c_sqlcdfies-scrtext_m,       "Medium Field Label
                             c_sqlcdfies-scrtext_s ')' INTO c_sqlcdfies-scrtext_s,       "Short Field Label
                             c_sqlcdfies-reptext ')'   INTO c_sqlcdfies-reptext,         "Heading
                             c_sqlcdfies-fieldtext ')' INTO c_sqlcdfies-fieldtext.       "Short Description of Repository Objects

ENDMETHOD.


METHOD constructor.
****************************************************************************************************
* Description             :                                                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : xx                       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2014               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2014                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* xx.xx.2014 |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* xx.xx.2014 |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

  g_main_ref_id = i_main_ref_id.
ENDMETHOD.


METHOD create_alv_field_catalog.
****************************************************************************************************
* Description             : Create ALV Field Catalog                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2015               Release    : WAS 7.40 SP8                     *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxx         Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

  CASE me->g_select_version.
    WHEN me->c_select_version_1 OR me->c_select_version_0.
      r_lvc_t_fcat = me->create_alv_field_catalog_v_1( EXPORTING i_user_settings   = i_user_settings
                                                                 i_dragdrop_handle = i_dragdrop_handle ).

    WHEN OTHERS.
      me->create_alv_field_catalog_v_2( EXPORTING i_user_settings   = i_user_settings
                                                  i_dragdrop_handle = i_dragdrop_handle ).
  ENDCASE.

ENDMETHOD.


METHOD create_alv_field_catalog_v_1.
****************************************************************************************************
* Description             : Create ALV Field Catalog                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Dieter Schadler          Company    : CADAXO GesmbH                    *
* Date                    : 17.11.2014                                                             *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 12.09.2010 | Fößleitner Johann    | There are problems with the dynamic type    | CDX001-0016    *
*            |                      | definition, when the table+fieldname longer |                *
*            |                      | than 30 characters                          |                *
*------------+----------------------+---------------------------------------------+----------------*
* 13.02.2012 | Fößleitner Johann    | Use TABLE - to export list                  | CDX001-0034    *
*------------+----------------------+---------------------------------------------+----------------*
* 12.09.2014 | Fößleitner Johann/   | Bug Fix - Dump when summing up Curr field   | CR22-031       *
*            | René Rammer          |                                             | RT245          *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | Leading Spaces                              | COCKPIT-125    *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | timestamp handling                          | COCKPIT-105    *
*------------+----------------------+---------------------------------------------+----------------*
* 05.07.2017 | Harald Wiesinger     | fix missing alv headers                     | COCKPIT-198   *
****************************************************************************************************

  DATA l_sql_abap_componentdescr  TYPE abap_componentdescr.
  DATA l_guid22(22)               TYPE c.
  DATA l_tabix                    LIKE sy-tabix.
  DATA l_decimals                 TYPE i.
  DATA l_intlen                   TYPE i.

  FIELD-SYMBOLS: <l_fields>     LIKE LINE OF me->gt_result_ddfields,
                 <l_lvc_s_fcat> TYPE lvc_s_fcat.

  CLEAR: me->result_component_t[].
  CLEAR: me->gt_lvc_t_fcat.

  LOOP AT me->gt_result_ddfields ASSIGNING <l_fields>.

    l_tabix = sy-tabix.

    IF me->column_syntax NE '*'.

      CLEAR: l_sql_abap_componentdescr.

      IF <l_fields>-fieldname NE space.
        CONCATENATE <l_fields>-tabname '-'
                     <l_fields>-fieldname
                    INTO l_sql_abap_componentdescr-name.
      ELSE.
        MOVE <l_fields>-tabname TO l_sql_abap_componentdescr-name.
      ENDIF.

      IF <l_fields>-aggr EQ 'SUM('.
        CASE <l_fields>-inttype.
          WHEN 'P'.
            l_decimals = <l_fields>-decimals.
            l_intlen   = <l_fields>-intlen.
            l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_p( p_length = l_intlen p_decimals = l_decimals ).
          WHEN 'I'.
            l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_i( ).
          WHEN OTHERS. "fallback
*            TRY.
*                l_sql_abap_componentdescr-type ?= cl_abap_typedescr=>describe_by_name( l_sql_abap_componentdescr-name ).
*              CATCH cx_root INTO DATA(lv_not_found).
            cl_abap_typedescr=>describe_by_name(
              EXPORTING
                p_name         = l_sql_abap_componentdescr-name
              RECEIVING
                p_descr_ref    = DATA(lv_descr_ref)
              EXCEPTIONS
                type_not_found = 1
                OTHERS         = 2 ).
            l_sql_abap_componentdescr-type ?= lv_descr_ref.
*            ENDTRY.
        ENDCASE.
      ELSE.
        IF <l_fields>-rollname NE '/CADAXO/SQLCAGGRCOUNT'.
*          l_sql_abap_componentdescr-type ?= cl_abap_typedescr=>describe_by_name( l_sql_abap_componentdescr-name ).
          cl_abap_typedescr=>describe_by_name(
            EXPORTING
              p_name         = l_sql_abap_componentdescr-name
            RECEIVING
              p_descr_ref    = lv_descr_ref
            EXCEPTIONS
              type_not_found = 1
              OTHERS         = 2 ).
          l_sql_abap_componentdescr-type ?= lv_descr_ref.
        ELSE.
*          l_sql_abap_componentdescr-type ?= cl_abap_typedescr=>describe_by_name( '/CADAXO/SQLCAGGRCOUNT' ).
          cl_abap_typedescr=>describe_by_name(
            EXPORTING
              p_name         = '/CADAXO/SQLCAGGRCOUNT'
            RECEIVING
              p_descr_ref    = lv_descr_ref
            EXCEPTIONS
              type_not_found = 1
              OTHERS         = 2 ).
          l_sql_abap_componentdescr-type ?= lv_descr_ref.
        ENDIF.
      ENDIF.

      READ TABLE me->result_component_t
           WITH KEY name = l_sql_abap_componentdescr-name TRANSPORTING NO FIELDS.
      IF sy-subrc EQ 0 OR strlen( l_sql_abap_componentdescr-name ) GT 30.
        IF <l_fields>-map_fieldname IS INITIAL.
          DO.
            TRY.
                CALL METHOD ('CL_SYSTEM_UUID')=>('CREATE_UUID_C22_STATIC')
                  RECEIVING
                    uuid = l_guid22.
              CATCH cx_root.
                CALL FUNCTION 'GUID_CREATE'
                  IMPORTING
                    ev_guid_22 = l_guid22.
            ENDTRY.
            TRANSLATE l_guid22 TO UPPER CASE.
            REPLACE ALL OCCURRENCES OF '}' IN l_guid22 WITH 'A'.
            REPLACE ALL OCCURRENCES OF '{' IN l_guid22 WITH 'B'.
* check for existing "GUID" caused by case-sensetivity of CHAR22 GUIDs
            READ TABLE me->result_component_t WITH KEY name = l_guid22 TRANSPORTING NO FIELDS.
            IF sy-subrc <> 0.
              EXIT.
            ENDIF.
          ENDDO.

          l_sql_abap_componentdescr-name = l_guid22.

        ELSE.

          l_sql_abap_componentdescr-name = <l_fields>-map_fieldname.

        ENDIF.

      ENDIF.

      APPEND l_sql_abap_componentdescr TO me->result_component_t.

      <l_fields>-map_fieldname = l_sql_abap_componentdescr-name.

    ENDIF.

    APPEND INITIAL LINE TO me->gt_lvc_t_fcat ASSIGNING <l_lvc_s_fcat>.

    MOVE-CORRESPONDING <l_fields> TO <l_lvc_s_fcat>.

    MOVE 'TABLE' TO <l_lvc_s_fcat>-tabname. "CDX001-0034

    MOVE: <l_fields>-fieldname TO <l_lvc_s_fcat>-ref_field,
          <l_fields>-tabname   TO <l_lvc_s_fcat>-ref_table.

    IF me->column_syntax EQ '*'.
      CASE <l_fields>-datatype.
        WHEN 'CURR'.
          READ TABLE me->gt_result_ddfields WITH KEY fieldname = <l_fields>-reffield TRANSPORTING NO FIELDS.  "CR22-031
          IF sy-subrc EQ 0.                                                                                   "CR22-031
            MOVE <l_fields>-reffield TO <l_lvc_s_fcat>-cfieldname.                                            "CR22-031
          ENDIF.                                                                                              "CR22-031
        WHEN 'QUAN'.
          READ TABLE me->gt_result_ddfields TRANSPORTING NO FIELDS
                     WITH KEY tabname = <l_fields>-tabname
                              fieldname = <l_fields>-reffield.
          IF sy-subrc EQ 0.
            MOVE <l_fields>-reffield TO <l_lvc_s_fcat>-qfieldname.
          ENDIF.
      ENDCASE.
    ELSE.
      CASE <l_fields>-datatype.
        WHEN 'CURR'.
          READ TABLE me->gt_result_ddfields WITH KEY fieldname = <l_fields>-reffield
                                                     tabname   = <l_fields>-reftable
                                                     TRANSPORTING NO FIELDS.
          IF sy-subrc EQ 0.
            CONCATENATE <l_fields>-reftable '-' <l_fields>-reffield INTO <l_lvc_s_fcat>-cfieldname.
          ENDIF.

        WHEN 'QUAN'.
          READ TABLE me->gt_result_ddfields TRANSPORTING NO FIELDS
                     WITH KEY tabname = <l_fields>-reftable
                              fieldname = <l_fields>-reffield.
          IF sy-subrc EQ 0.
            CONCATENATE <l_fields>-reftable '-' <l_fields>-reffield INTO <l_lvc_s_fcat>-qfieldname.
          ENDIF.
      ENDCASE.
    ENDIF.

    IF me->column_syntax NE '*'.
      MOVE l_sql_abap_componentdescr-name TO <l_lvc_s_fcat>-fieldname.
    ENDIF.

    MOVE <l_fields>-keyflag   TO <l_lvc_s_fcat>-key.

* set the column header (fieldname or fieldid)
    IF i_user_settings-hd_fieldname EQ 'X'.
      <l_lvc_s_fcat>-coltext     =  <l_fields>-colhd_fieldname.
      IF NOT <l_fields>-/cadaxo/alias IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
        CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-coltext   INTO <l_lvc_s_fcat>-coltext.
      ELSEIF   NOT <l_fields>-/cadaxo/alias_field IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL. "cockpit-339
        MOVE <l_fields>-/cadaxo/alias_field TO <l_lvc_s_fcat>-coltext. "cockpit-339
      ENDIF.
    ELSE.

      IF NOT <l_fields>-/cadaxo/alias_field IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
        MOVE <l_fields>-/cadaxo/alias_field TO <l_lvc_s_fcat>-coltext.
      ELSE.
        IF NOT <l_fields>-/cadaxo/alias IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
          IF NOT <l_lvc_s_fcat>-scrtext_l IS INITIAL.
            CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-scrtext_l INTO <l_lvc_s_fcat>-scrtext_l.
          ENDIF.
          IF NOT <l_lvc_s_fcat>-scrtext_m IS INITIAL.
            CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-scrtext_m INTO <l_lvc_s_fcat>-scrtext_m.
          ENDIF.
          IF NOT <l_lvc_s_fcat>-scrtext_s IS INITIAL.
            CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-scrtext_s INTO <l_lvc_s_fcat>-scrtext_s.
          ENDIF.
          IF NOT <l_lvc_s_fcat>-reptext IS INITIAL.
            CONCATENATE <l_fields>-/cadaxo/alias '~' <l_lvc_s_fcat>-reptext INTO <l_lvc_s_fcat>-reptext.
          ENDIF.
        ENDIF.

        CASE 'X'.
          WHEN i_user_settings-hd_fieldtext_s.
            MOVE <l_lvc_s_fcat>-scrtext_s TO <l_lvc_s_fcat>-coltext.
          WHEN i_user_settings-hd_fieldtext_m.
            MOVE <l_lvc_s_fcat>-scrtext_m TO <l_lvc_s_fcat>-coltext.
          WHEN i_user_settings-hd_fieldtext_l.
            MOVE <l_lvc_s_fcat>-scrtext_l TO <l_lvc_s_fcat>-coltext.
        ENDCASE.
      ENDIF.

      IF <l_lvc_s_fcat>-coltext IS INITIAL AND i_user_settings-hd_fieldtext_a IS INITIAL.
        <l_lvc_s_fcat>-coltext = <l_fields>-fieldname.
      ENDIF.

      IF  i_user_settings-hd_fieldtext_a IS NOT INITIAL           "COCKPIT-198
      AND <l_lvc_s_fcat>-scrtext_s IS INITIAL                     "COCKPIT-198
      AND <l_lvc_s_fcat>-scrtext_m IS INITIAL                     "COCKPIT-198
      AND <l_lvc_s_fcat>-scrtext_l IS INITIAL                     "COCKPIT-198
      AND <l_lvc_s_fcat>-coltext   IS INITIAL.                    "COCKPIT-198
        <l_lvc_s_fcat>-coltext = <l_fields>-fieldname.            "COCKPIT-198
        <l_lvc_s_fcat>-scrtext_s = <l_fields>-fieldname.          "COCKPIT-198
        <l_lvc_s_fcat>-scrtext_m = <l_fields>-fieldname.          "COCKPIT-198
        <l_lvc_s_fcat>-scrtext_l = <l_fields>-fieldname.          "COCKPIT-198
      ENDIF.

    ENDIF.

    <l_lvc_s_fcat>-col_pos    = ( l_tabix * 2 ).
    <l_lvc_s_fcat>-dragdropid = i_dragdrop_handle.

* set the use of the convertion exit
    IF i_user_settings-use_convexit IS INITIAL.
      <l_lvc_s_fcat>-no_convext = abap_true.
      CLEAR <l_lvc_s_fcat>-convexit.                                           "COCKPIT-105
      CLEAR <l_lvc_s_fcat>-edit_mask.                                          "COCKPIT-105
    ENDIF.

    IF <l_fields>-datatype = 'CHAR' OR                                         "COCKPIT-125
       <l_fields>-datatype = 'STRG' OR                                         "COCKPIT-125
     ( <l_fields>-datatype IS INITIAL AND <l_fields>-inttype = 'C' ).          "COCKPIT-125
      <l_lvc_s_fcat>-parameter0 = abap_true.                                   "COCKPIT-125
    ENDIF.                                                                     "COCKPIT-125
  ENDLOOP.

  r_lvc_t_fcat = me->gt_lvc_t_fcat.

ENDMETHOD.


METHOD create_alv_field_catalog_v_2.
****************************************************************************************************
* Description             : Create ALV Field Catalog                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
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
* 18.02.2017 | Domi Bigl            | Leading Spaces                              | COCKPIT-125    *
*------------+----------------------+---------------------------------------------+----------------*
* 18.02.2017 | Domi Bigl            | timestamp handling                          | COCKPIT-105    *
*------------+----------------------+---------------------------------------------+----------------*
* 04.04.2017 | Domi Bigl            | Sign                                        | COCKPIT-181    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

  DATA lr_tabledescr TYPE REF TO cl_abap_tabledescr.
  DATA lr_tab TYPE REF TO data.
  DATA lr_table TYPE REF TO cl_salv_table.
  DATA lr_cols TYPE REF TO cl_salv_columns_table.
  DATA lr_aggr TYPE REF TO cl_salv_aggregations.
  DATA l_pos TYPE i.

  FIELD-SYMBOLS: <ls_lvc_s_fcat> LIKE LINE OF me->gt_lvc_t_fcat,
                 <ls_ddfields>   LIKE LINE OF me->gt_result_ddfields.

  CLEAR me->gt_lvc_t_fcat.

  lr_tabledescr ?= cl_abap_tabledescr=>describe_by_data_ref( EXPORTING p_data_ref = me->result_table ).

  CREATE DATA lr_tab TYPE HANDLE lr_tabledescr.

  ASSIGN lr_tab->* TO FIELD-SYMBOL(<lt_result_tmp>).
  TRY.

      cl_salv_table=>factory( IMPORTING r_salv_table = lr_table
                              CHANGING t_table = <lt_result_tmp> ).

      lr_cols = lr_table->get_columns( ).
      lr_aggr = lr_table->get_aggregations( ).

      me->gt_lvc_t_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns      = lr_cols
                                                                             r_aggregations = lr_aggr ).

      DELETE me->gt_lvc_t_fcat WHERE datatype = 'NODE'.

      l_pos = 0.

      LOOP AT me->gt_lvc_t_fcat ASSIGNING <ls_lvc_s_fcat>.
        l_pos = l_pos + 1.
        <ls_lvc_s_fcat>-col_pos = l_pos.

        READ TABLE me->gt_result_ddfields WITH KEY fieldname = <ls_lvc_s_fcat>-fieldname ASSIGNING <ls_ddfields>.
        IF sy-subrc = 0.
          <ls_lvc_s_fcat>-rollname   = <ls_ddfields>-rollname.
          <ls_lvc_s_fcat>-domname    = <ls_ddfields>-domname.
          <ls_lvc_s_fcat>-scrtext_s  = <ls_ddfields>-scrtext_s.
          <ls_lvc_s_fcat>-scrtext_m  = <ls_ddfields>-scrtext_m.
          <ls_lvc_s_fcat>-scrtext_l  = <ls_ddfields>-scrtext_l.
          <ls_lvc_s_fcat>-checktable = <ls_ddfields>-checktable.
          <ls_lvc_s_fcat>-convexit   = <ls_ddfields>-convexit.
          <ls_lvc_s_fcat>-reptext    = <ls_ddfields>-reptext.
          <ls_lvc_s_fcat>-f4availabl = <ls_ddfields>-f4availabl.
          <ls_lvc_s_fcat>-outputlen  = <ls_ddfields>-outputlen.
          <ls_lvc_s_fcat>-ref_field  = <ls_ddfields>-reffield.
          <ls_lvc_s_fcat>-ref_table  = <ls_ddfields>-reftable.
          <ls_lvc_s_fcat>-key        = <ls_ddfields>-keyflag.
          <ls_lvc_s_fcat>-datatype   = <ls_ddfields>-datatype.
          <ls_lvc_s_fcat>-no_sign    = abap_false.                             "COCKPIT-181
        ENDIF.

        IF <ls_lvc_s_fcat>-scrtext_s IS INITIAL.
          <ls_lvc_s_fcat>-scrtext_s = <ls_lvc_s_fcat>-fieldname.
        ENDIF.
        IF <ls_lvc_s_fcat>-scrtext_m IS INITIAL.
          <ls_lvc_s_fcat>-scrtext_m = <ls_lvc_s_fcat>-fieldname.
        ENDIF.
        IF <ls_lvc_s_fcat>-scrtext_l IS INITIAL.
          <ls_lvc_s_fcat>-scrtext_l = <ls_lvc_s_fcat>-fieldname.
        ENDIF.

        <ls_lvc_s_fcat>-dragdropid = i_dragdrop_handle.

        IF i_user_settings-use_convexit IS INITIAL.
          <ls_lvc_s_fcat>-no_convext = abap_true.
          CLEAR <ls_lvc_s_fcat>-convexit.                                                "COCKPIT-105
          CLEAR <ls_lvc_s_fcat>-edit_mask.                                               "COCKPIT-105
        ENDIF.

        IF <ls_lvc_s_fcat>-datatype = 'CHAR' OR                                          "COCKPIT-125
           <ls_lvc_s_fcat>-datatype = 'STRG' OR                                          "COCKPIT-125
           ( <ls_lvc_s_fcat>-datatype IS INITIAL AND <ls_lvc_s_fcat>-inttype = 'C' ).    "COCKPIT-125
          <ls_lvc_s_fcat>-parameter0 = abap_true.                                        "COCKPIT-125
        ENDIF.                                                                           "COCKPIT-125
      ENDLOOP.

* set column header based on the user settings
      /cadaxo/cl_sqlc_cockpit_assist=>set_fcat_header_texts(
        EXPORTING
          is_user_settings = me->g_user_settings
          it_ddfields      = me->gt_result_ddfields
        CHANGING
          ct_fcat          = me->gt_lvc_t_fcat ).

    CATCH cx_salv_msg.
  ENDTRY.

  FREE lr_table.
  FREE lr_cols.
  FREE lr_aggr.
  FREE lr_tabledescr.
  FREE lr_tab.

ENDMETHOD.


METHOD create_result_structures.
****************************************************************************************************
* Description             : Create and get result structures                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations : This Method splits a field into field, talbe and alias                 *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
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

  DATA: lr_data_tab TYPE REF TO data,
        lr_data_str TYPE REF TO data,
        l_tab       TYPE string,
        l_alias     TYPE string,
        l_lines     TYPE i.

  DATA: lcl_structtype                   TYPE REF TO cl_abap_structdescr.
  DATA: lcl_tabletype                    TYPE REF TO cl_abap_tabledescr.

  DESCRIBE TABLE me->result_source_t LINES l_lines.

* for "select * from xyz" we use a more direct way to generate the result structures
  IF me->column_syntax EQ '*' AND l_lines EQ 1 AND i_mode <> 'S'
     AND find( val = me->source_syntax sub = '\' ) < 1.
    SPLIT me->source_syntax AT space INTO l_tab l_alias.

    CREATE DATA lr_data_tab TYPE STANDARD TABLE OF (l_tab).

    CREATE DATA lr_data_str TYPE (l_tab).
  ELSE.

* create result structure
    lcl_structtype = cl_abap_structdescr=>create(
       p_components = me->result_component_t p_strict = ' ' ).

* create result table
    lcl_tabletype = cl_abap_tabledescr=>create(
       p_line_type = lcl_structtype
       p_table_kind = cl_abap_tabledescr=>tablekind_std
       p_unique     = abap_false ).

    CREATE DATA lr_data_tab TYPE HANDLE lcl_tabletype.

    CREATE DATA lr_data_str TYPE HANDLE lcl_structtype.

  ENDIF.

*
  MOVE lr_data_tab TO me->result_table.
  MOVE lr_data_str TO me->result_structure.

* we want to save memory

  FREE: lcl_structtype,
        lcl_tabletype,
        lr_data_tab,
        lr_data_str.



ENDMETHOD.


METHOD execute_select.
****************************************************************************************************
* Description             : Check, if the sql command includes a subquery                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | Fößleitner Johann    | DB Hints                                    | CDX001-0011    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 29.05.2012 | Ana Lekic            | restricted lines info - jobs                | CDX130-017     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 31.05.2012 | Ana Lekic            | timestamps in where - catch dump            | CDX130-018     *
*            |                      |                                             |                *
****************************************************************************************************

  CASE me->g_select_version.
    WHEN me->c_select_version_1.
      me->execute_select_v_1(
        EXPORTING
          i_user_settings      = i_user_settings
          i_progress_indicator = i_progress_indicator
        IMPORTING
          e_result_details     = e_result_details ).
    WHEN me->c_select_version_2.
      me->execute_select_v_2(
        EXPORTING
          i_user_settings      = i_user_settings
          i_progress_indicator = i_progress_indicator
        IMPORTING
          e_result_details     = e_result_details ).
  ENDCASE.

ENDMETHOD.


METHOD execute_select_via_subpool.
****************************************************************************************************
* Description             : Generate and Execute Subroutine Pool for Subselects                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | Fößleitner Johann    | DB Hints                                    | CDX001-0011    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*    05.2012 | Domi Bigl            | Subroutinenpool                             | CDX130-020     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.04.2016 | Ana Lekic            | trace                                       | $003 COCKPIT-59*
****************************************************************************************************

  FIELD-SYMBOLS:  <l_result_table>  TYPE STANDARD TABLE,
                  <l_result_struct> TYPE any.

  DATA l_from            TYPE i.
  DATA l_line            TYPE string.
  DATA l_maxsel(10)      TYPE c.
  DATA lt_abap_code      TYPE /cadaxo/sqlcstring_t.

  DATA: BEGIN OF ls_syn_msg,
          l1(72),
          l2(72),
          l3(72),
        END OF ls_syn_msg.

* assign result table and result structure to local field symbols
  ASSIGN me->result_table->*     TO <l_result_table>.
  ASSIGN me->result_structure->* TO <l_result_struct>.

* create dynamic select subroutinen pool
  create_dynamic_select_subpool.

  CLEAR mr_arfc_exception.
  CALL FUNCTION '/CADAXO/SQLCSUBROUTINEPOOL'
    STARTING NEW TASK 'TASK1'
    CALLING me->subpool_result ON END OF TASK
    EXPORTING
      i_version              = me->g_select_version
      i_trace                = me->g_main_ref->g_sql_trace_on "$003
      i_user_sett_sql_trace  = me->g_main_ref->g_user_settings-sql_trace  "$003
      i_user_sett_tabb_trace = me->g_main_ref->g_user_settings-tablebuffer_trace "$003
    CHANGING
      ic_data                = l_data
    EXCEPTIONS
      system_failure         = 1 MESSAGE l_error_message
      communication_failure  = 2 MESSAGE l_error_message
      resource_failure       = 3
      OTHERS                 = 4.

  IF sy-subrc = 0.
    CLEAR g_error_message. "$003
    WAIT FOR ASYNCHRONOUS TASKS UNTIL g_async_calls = 0.
    IF sy-subrc <> 0. "$003
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error "$003
        EXPORTING "$003
          message = g_error_message. "$003
    ENDIF.
    IF mr_arfc_exception IS NOT INITIAL.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error EXPORTING previous = mr_arfc_exception.
    ENDIF.

  ENDIF.

  e_result_details-runtime = g_tmp_result_details-runtime.
  e_result_details-lines   = g_tmp_result_details-lines.
***

  READ TABLE me->g_main_ref->gt_errors WITH KEY msgtype = icon_red_light INTO DATA(ls_error).
  IF sy-subrc = 0.
    RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
      EXPORTING
        message = ls_error-text.
  ELSE.
    CASE me->g_select_version.
      WHEN c_select_version_1.
      WHEN OTHERS.
        me->create_alv_field_catalog( ).
    ENDCASE.
  ENDIF.

ENDMETHOD.


  METHOD execute_select_via_subpool_v_2.


    DATA lt_abap_code     TYPE /cadaxo/sqlcstring_t.
    DATA l_line           TYPE string.
    DATA l_maxsel         TYPE c LENGTH 10.
    DATA lt_result_source TYPE /cadaxo/sqlcselectsource_fla_t.
    DATA l_data           TYPE xstring.
    DATA l_error_message  TYPE char128.
    DATA l_dummy TYPE string.

ENHANCEMENT-SECTION /cadaxo/sqlc_ehn_s_cls_se_005 SPOTS /cadaxo/sqlc_ehnsp_cls_se_001 STATIC .
*...
    CONSTANTS: lc_cs_active TYPE flag VALUE abap_false.
END-ENHANCEMENT-SECTION.

    create_dynamic_select_subpool2.

    CLEAR mr_arfc_exception.

    CALL FUNCTION '/CADAXO/SQLCSUBROUTINEPOOL'
      STARTING NEW TASK 'TASK1'
      CALLING me->subpool_result ON END OF TASK
      EXPORTING
        i_version              = me->g_select_version
        i_trace                = me->g_main_ref->g_sql_trace_on
        i_user_sett_sql_trace  = me->g_main_ref->g_user_settings-sql_trace
        i_user_sett_tabb_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
      CHANGING
        ic_data                = l_data
      EXCEPTIONS
        system_failure         = 1 MESSAGE l_error_message
        communication_failure  = 2 MESSAGE l_error_message
        resource_failure       = 3
        OTHERS                 = 4.

    IF sy-subrc = 0.
      CLEAR g_error_message.
      WAIT FOR ASYNCHRONOUS TASKS UNTIL g_async_calls = 0.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
          EXPORTING
            message = g_error_message.
      ENDIF.
      IF mr_arfc_exception IS NOT INITIAL.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error EXPORTING message = CONV #( text-e02 ) previous = mr_arfc_exception.
      ENDIF.
    ENDIF.
* set result details
    e_result_details-runtime = g_tmp_result_details-runtime.
    e_result_details-lines   = g_tmp_result_details-lines.

* create the field catalog
    me->create_alv_field_catalog_v_2( EXPORTING i_user_settings   = me->g_main_ref->g_user_settings
                                                i_dragdrop_handle = me->g_main_ref->dragdrop_handle ).

* add the current fieldcatalog to the main reference field catalog
    APPEND me->gt_lvc_t_fcat TO me->g_main_ref->gt_lvc_t_fcat.
  ENDMETHOD.


METHOD execute_select_v_1.

ENHANCEMENT-SECTION /cadaxo/sqlc_ehn_s_cls_se_004 SPOTS /cadaxo/sqlc_ehnsp_cls_se_001 STATIC.
*...
  CONSTANTS: lc_cs_active TYPE flag VALUE abap_false.
END-ENHANCEMENT-SECTION.

* Marco m_execute_select
  m_execute_select.

  DATA: l_from    TYPE i,
        l_to      TYPE i,
        l_case(3) TYPE c,
        l_maxsel  TYPE i.

  DATA: l_total_rows   TYPE i,
        l_package_size TYPE i,
        l_percentage   TYPE i,
        lr_exception   TYPE REF TO cx_sy_open_sql_db,
        lr_exception2  TYPE REF TO cx_sy_conversion_error. "CDX130-018

  DATA l_result_details         TYPE /cadaxo/sqlcresult_details.
  DATA l_sql_trace_activated    TYPE c LENGTH 1.

  FIELD-SYMBOLS:  <l_result_table>  TYPE STANDARD TABLE,
                  <l_result_struct> TYPE any.
  CLEAR: l_maxsel.

  IF i_user_settings IS SUPPLIED.
    g_user_settings = i_user_settings.
  ENDIF.

  IF NOT me->g_up_to_x_rows IS INITIAL.
    MOVE me->g_up_to_x_rows TO l_maxsel.
  ELSEIF NOT g_user_settings-maxsel IS INITIAL.
    MOVE g_user_settings-maxsel TO l_maxsel.
  ENDIF.

* log data
  LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax
                                   me->source_syntax
                                   me->where_syntax
                                   me->group_syntax
                                   me->having_syntax
                                   me->order_syntax
                                   me->g_select_distinct
                                   me->g_bypassing_buffer
                                   me->gs_client_handling
                                   g_user_settings.

* assign result table and result structure to local field symbols
  ASSIGN me->result_table->*     TO <l_result_table>.
  ASSIGN me->result_structure->* TO <l_result_struct>.

* clear result tables
  CLEAR <l_result_table>.

* bei dynamischer Eingabe keine '
  TRANSLATE me->dbhint_syntax USING `' `.

  TRY.
***    IF me->column_syntax EQ 'COUNT( * )' OR                       "bigld COCKPIT-100
***       me->column_syntax EQ 'COUNT(*)'   AND                      "bigld COCKPIT-100
      IF is_count_star_only( me->column_syntax ) AND                "bigld COCKPIT-100
         me->group_syntax  IS INITIAL AND
         me->subquery  IS INITIAL.

        IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
          /cadaxo/cl_sqlc_cockpit_assist=>sql_trace_on(
          EXPORTING
           i_sql_trace = me->g_main_ref->g_user_settings-sql_trace
           i_tablebuffer_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
           IMPORTING
             e_date_from = l_result_details-date_from
             e_time_from = l_result_details-time_from
             e_success   = l_sql_trace_activated ).
          COMMIT WORK.
        ENDIF.

        IF me->gs_client_handling-client_specified IS INITIAL.
          GET RUN TIME FIELD l_from.
          SELECT (me->column_syntax)
                  FROM (me->source_syntax)
                  CONNECTION (me->connection_syntax)
                  INTO <l_result_struct>
                  WHERE (me->where_syntax)
                  %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS

            APPEND <l_result_struct> TO <l_result_table>.
          ENDSELECT.
          GET RUN TIME FIELD l_to.
        ELSE.
          ASSERT lc_cs_active = abap_true.
          GET RUN TIME FIELD l_from.
          SELECT (me->column_syntax)
                  FROM (me->source_syntax)
                  CLIENT SPECIFIED
                  CONNECTION (me->connection_syntax)
                  INTO <l_result_struct>
                  WHERE (me->where_syntax)
                  %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011   "#EC CI_HINTS
                          DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                          ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011  "#EC CI_HINTS
            APPEND <l_result_struct> TO <l_result_table>.
          ENDSELECT.
          GET RUN TIME FIELD l_to.
        ENDIF.

        e_result_details-runtime = l_to - l_from.
        MOVE sy-dbcnt TO e_result_details-lines. "l_LINES.

        IF l_sql_trace_activated IS NOT INITIAL.
          /cadaxo/cl_sqlc_cockpit_assist=>sql_trace_off(
            EXPORTING
             i_sql_trace = me->g_main_ref->g_user_settings-sql_trace
             i_tablebuffer_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
           IMPORTING
             e_date_to = l_result_details-date_to
             e_time_to = l_result_details-time_to ).
          CLEAR l_sql_trace_activated.
        ENDIF.

      ELSE.

* do we need to use the subquery
        IF NOT me->subquery IS INITIAL.

          me->execute_select_via_subpool(
            EXPORTING
              i_progress_indicator = i_progress_indicator
            IMPORTING
              e_result_details = e_result_details ).

          IF sy-dbcnt EQ l_maxsel.
            MESSAGE s044(/cadaxo/sqlc) WITH l_maxsel.
            MOVE abap_true TO e_result_details-restricted_lines."CDX130-017
            MOVE l_maxsel  TO e_result_details-maxsel.      "CDX130-017
          ENDIF.

        ELSE.

          IF NOT me->g_main_ref->g_sql_trace_on IS INITIAL.
            /cadaxo/cl_sqlc_cockpit_assist=>sql_trace_on(
              EXPORTING
               i_sql_trace = me->g_main_ref->g_user_settings-sql_trace
               i_tablebuffer_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
               IMPORTING
                 e_date_from = l_result_details-date_from
                 e_time_from = l_result_details-time_from
                 e_success   = l_sql_trace_activated ).
            COMMIT WORK.
          ENDIF.

          IF NOT me->g_select_single IS INITIAL.

            IF me->gs_client_handling-client_specified IS INITIAL.
              GET RUN TIME FIELD l_from.
              SELECT SINGLE (me->column_syntax)
                 FROM (me->source_syntax)
                 CONNECTION (me->connection_syntax)
                 INTO <l_result_struct>
                 WHERE (me->where_syntax)
                 GROUP BY (me->group_syntax)
                 HAVING (me->having_syntax)
                 %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011   "#EC CI_HINTS
                         DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011   "#EC CI_HINTS
              GET RUN TIME FIELD l_to.
            ELSE.
              ASSERT lc_cs_active = abap_true.
              GET RUN TIME FIELD l_from.
              SELECT SINGLE (me->column_syntax)
                 FROM (me->source_syntax)
                 CLIENT SPECIFIED
                 CONNECTION (me->connection_syntax)
                 INTO <l_result_struct>
                 WHERE (me->where_syntax)
                 GROUP BY (me->group_syntax)
                 HAVING (me->having_syntax)
                 %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                         ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011   "#EC CI_HINTS
              GET RUN TIME FIELD l_to.
            ENDIF.

            e_result_details-runtime = l_to - l_from.
            MOVE sy-dbcnt TO e_result_details-lines.

            APPEND <l_result_struct> TO <l_result_table>.

          ELSE.

            MOVE: me->g_select_distinct  TO l_case(1),
                  me->gs_client_handling-client_specified TO l_case+1(1),
                  me->g_bypassing_buffer TO l_case+2(1).

            GET RUN TIME FIELD l_from.

            IF i_progress_indicator NE space.

              SELECT COUNT( * )
                      FROM (me->source_syntax)
                      CONNECTION (me->connection_syntax)
                      INTO l_total_rows
                      UP TO l_maxsel ROWS
                      WHERE (me->where_syntax)
                      %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                              DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                              DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                              AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                              informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                              ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                              ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011   "#EC CI_HINTS
              l_package_size = l_total_rows / 100 * 5.

            ENDIF.


            CASE l_case.
              WHEN space.

                IF i_progress_indicator NE space.

                  SELECT (me->column_syntax)
                          FROM (me->source_syntax)
                          CONNECTION (me->connection_syntax)
                          UP TO l_maxsel ROWS
                          PACKAGE SIZE l_package_size
                          APPENDING TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011  "#EC CI_HINTS

                    l_percentage = l_percentage + 5.

                    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                      EXPORTING
                        percentage = l_percentage.

                  ENDSELECT.

                ELSE.

                  SELECT (me->column_syntax)
                          FROM (me->source_syntax)
                          CONNECTION (me->connection_syntax)
                          UP TO l_maxsel ROWS
                          INTO TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011  "#EC CI_HINTS
                ENDIF.

              WHEN 'X  '.
                IF i_progress_indicator NE space.

                  SELECT DISTINCT (me->column_syntax)
                          FROM (me->source_syntax)
                          CONNECTION (me->connection_syntax)
                          UP TO l_maxsel ROWS
                          PACKAGE SIZE l_package_size
                          APPENDING TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011  "#EC CI_HINTS

                    l_percentage = l_percentage + 5.

                    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                      EXPORTING
                        percentage = l_percentage.

                  ENDSELECT.

                ELSE.
                  SELECT DISTINCT (me->column_syntax)
                          FROM (me->source_syntax)
                          CONNECTION (me->connection_syntax)
                          UP TO l_maxsel ROWS
                          INTO TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011  "#EC CI_HINTS
                ENDIF.
              WHEN ' X '.
                ASSERT lc_cs_active = abap_true.
                IF i_progress_indicator NE space.

                  SELECT (me->column_syntax)
                          FROM (me->source_syntax)
                          CLIENT SPECIFIED
                          CONNECTION (me->connection_syntax)
                          UP TO l_maxsel ROWS
                          PACKAGE SIZE l_package_size
                          APPENDING TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011   "#EC CI_HINTS

                    l_percentage = l_percentage + 5.

                    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                      EXPORTING
                        percentage = l_percentage.

                  ENDSELECT.

                ELSE.
                  SELECT (me->column_syntax)
                          FROM (me->source_syntax)
                          CLIENT SPECIFIED
                          CONNECTION (me->connection_syntax)
                          UP TO l_maxsel ROWS
                          INTO TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011   "#EC CI_HINTS
                ENDIF.
              WHEN '  X'.
                IF i_progress_indicator NE space.

                  SELECT (me->column_syntax)
                          FROM (me->source_syntax)
                          CONNECTION (me->connection_syntax)
                          BYPASSING BUFFER
                          UP TO l_maxsel ROWS
                            PACKAGE SIZE l_package_size
                            APPENDING TABLE <l_result_table>
                            WHERE (me->where_syntax)
                            GROUP BY (me->group_syntax)
                            HAVING (me->having_syntax)
                            ORDER BY (me->order_syntax)
                            %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                    ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011   "#EC CI_HINTS

                    l_percentage = l_percentage + 5.

                    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                      EXPORTING
                        percentage = l_percentage.

                  ENDSELECT.

                ELSE.
                  SELECT (me->column_syntax)
                          FROM (me->source_syntax)
                          CONNECTION (me->connection_syntax)
                          BYPASSING BUFFER
                          UP TO l_maxsel ROWS
                          INTO TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011   "#EC CI_HINTS
                ENDIF.
              WHEN 'XX '.
                ASSERT lc_cs_active = abap_true.
                IF i_progress_indicator NE space.

                  SELECT DISTINCT (me->column_syntax)
                          FROM (me->source_syntax)
                          CLIENT SPECIFIED
                          CONNECTION (me->connection_syntax)
                          UP TO l_maxsel ROWS
                          PACKAGE SIZE l_package_size
                          APPENDING TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011  "#EC CI_HINTS

                    l_percentage = l_percentage + 5.

                    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                      EXPORTING
                        percentage = l_percentage.

                  ENDSELECT.

                ELSE.
                  SELECT DISTINCT (me->column_syntax)
                          FROM (me->source_syntax)
                          CLIENT SPECIFIED
                          CONNECTION (me->connection_syntax)
                          UP TO l_maxsel ROWS
                          INTO TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011   "#EC CI_HINTS
                ENDIF.
              WHEN 'X X'.
                IF i_progress_indicator NE space.

                  SELECT DISTINCT (me->column_syntax)
                          FROM (me->source_syntax)
                          CONNECTION (me->connection_syntax)
                          BYPASSING BUFFER
                          UP TO l_maxsel ROWS
                          PACKAGE SIZE l_package_size
                          APPENDING TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011  "#EC CI_HINTS

                    l_percentage = l_percentage + 5.

                    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                      EXPORTING
                        percentage = l_percentage.

                  ENDSELECT.

                ELSE.
                  SELECT DISTINCT (me->column_syntax)
                          FROM (me->source_syntax)
                          CONNECTION (me->connection_syntax)
                          BYPASSING BUFFER
                          UP TO l_maxsel ROWS
                          INTO TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011  "#EC CI_HINTS
                ENDIF.
              WHEN ' XX'.
                ASSERT lc_cs_active = abap_true.
                IF i_progress_indicator NE space.

                  SELECT (me->column_syntax)
                          FROM (me->source_syntax)
                          CLIENT SPECIFIED
                          CONNECTION (me->connection_syntax)
                          BYPASSING BUFFER
                          UP TO l_maxsel ROWS
                          PACKAGE SIZE l_package_size
                          APPENDING TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS

                    l_percentage = l_percentage + 5.

                    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                      EXPORTING
                        percentage = l_percentage.

                  ENDSELECT.

                ELSE.
                  SELECT (me->column_syntax)
                          FROM (me->source_syntax)
                          CLIENT SPECIFIED
                          CONNECTION (me->connection_syntax)
                          BYPASSING BUFFER
                          UP TO l_maxsel ROWS
                          INTO TABLE <l_result_table>
                          WHERE (me->where_syntax)
                          GROUP BY (me->group_syntax)
                          HAVING (me->having_syntax)
                          ORDER BY (me->order_syntax)
                          %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                  ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS

                ENDIF.
              WHEN 'XXX'.
                ASSERT lc_cs_active = abap_true.
                IF i_progress_indicator NE space.

                  SELECT DISTINCT (me->column_syntax)
                                  FROM (me->source_syntax)
                                  CLIENT SPECIFIED
                                  CONNECTION (me->connection_syntax)
                                  BYPASSING BUFFER
                                  UP TO l_maxsel ROWS
                                  PACKAGE SIZE l_package_size
                                  APPENDING TABLE <l_result_table>
                                  WHERE (me->where_syntax)
                                  GROUP BY (me->group_syntax)
                                  HAVING (me->having_syntax)
                                  ORDER BY (me->order_syntax)
                                  %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS

                    l_percentage = l_percentage + 5.

                    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
                      EXPORTING
                        percentage = l_percentage.

                  ENDSELECT.

                ELSE.
                  SELECT DISTINCT (me->column_syntax)
                                  FROM (me->source_syntax)
                                  CLIENT SPECIFIED
                                  CONNECTION (me->connection_syntax)
                                  BYPASSING BUFFER
                                  UP TO l_maxsel ROWS
                                  INTO TABLE <l_result_table>
                                  WHERE (me->where_syntax)
                                  GROUP BY (me->group_syntax)
                                  HAVING (me->having_syntax)
                                  ORDER BY (me->order_syntax)
                                  %_HINTS MSSQLNT  me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          DB6      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          DB2      me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          AS400    me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          informix me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          ORACLE   me->dbhint_syntax "CDX001-0011  "#EC CI_HINTS
                                          ADABAS   me->dbhint_syntax. "#EC CI_DYNWHERE "#EC CI_DYNTAB "CDX001-0011 "#EC CI_HINTS
                ENDIF.
            ENDCASE.

            GET RUN TIME FIELD l_to.
            e_result_details-runtime = l_to - l_from.
            MOVE sy-dbcnt TO e_result_details-lines. "l_LINES.

            IF sy-dbcnt EQ l_maxsel.
              MESSAGE s044(/cadaxo/sqlc) WITH l_maxsel.
              MOVE abap_true TO e_result_details-restricted_lines."CDX130-017
              MOVE l_maxsel  TO e_result_details-maxsel.    "CDX130-017
            ENDIF.

          ENDIF.
          IF l_sql_trace_activated IS NOT INITIAL.
            /cadaxo/cl_sqlc_cockpit_assist=>sql_trace_off(
              EXPORTING
               i_sql_trace = me->g_main_ref->g_user_settings-sql_trace
               i_tablebuffer_trace = me->g_main_ref->g_user_settings-tablebuffer_trace
             IMPORTING
               e_date_to = l_result_details-date_to
               e_time_to = l_result_details-time_to ).
            CLEAR l_sql_trace_activated.
            COMMIT WORK.
          ENDIF.
        ENDIF.
      ENDIF.

      me->result_lines = e_result_details-lines.
      me->result_runtime = e_result_details-runtime.

      e_result_details-syst    = sy-sysid.
      e_result_details-uname   = sy-uname.
      e_result_details-mandant = sy-mandt.
      GET TIME STAMP FIELD e_result_details-create_timestamp.

    CATCH cx_sy_open_sql_db INTO lr_exception.
      LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
                                 <l_result_table> me->where_syntax me->group_syntax
                                 me->having_syntax me->order_syntax.
      RAISE EXCEPTION lr_exception.
    CATCH /cadaxo/cx_sqlc_syntax_error.
      LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
                                       <l_result_table> me->where_syntax me->group_syntax
                                       me->having_syntax me->order_syntax.
      RAISE EXCEPTION TYPE cx_sy_open_sql_db.
    CATCH cx_sy_conversion_error INTO lr_exception2.        "CDX130-018
      LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel"CDX130-018
                                 <l_result_table> me->where_syntax me->group_syntax"CDX130-018
                                 me->having_syntax me->order_syntax."CDX130-018
      RAISE EXCEPTION lr_exception2. "CDX130-018

  ENDTRY.

ENDMETHOD.


METHOD execute_select_v_2.
  DATA l_maxsel           TYPE i.
  DATA lr_exception       TYPE REF TO cx_sy_open_sql_db.
  DATA lr_exception2      TYPE REF TO cx_sy_conversion_error.
  DATA lr_root_exception  TYPE REF TO /cadaxo/cx_sqlc_syntax_error.

* Macro m_execute_select_v_2
m_execute_select_v_2.

  CLEAR l_maxsel.

  IF i_user_settings IS SUPPLIED.
    MOVE i_user_settings TO g_user_settings.
  ENDIF.

  IF NOT me->g_up_to_x_rows IS INITIAL.
    MOVE me->g_up_to_x_rows TO l_maxsel.
  ELSEIF NOT g_user_settings-maxsel IS INITIAL.
    MOVE g_user_settings-maxsel TO l_maxsel.
  ENDIF.

* log data
  LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax
  me->source_syntax
  me->where_syntax
  me->group_syntax
  me->having_syntax
  me->order_syntax
  me->g_select_distinct
  me->g_bypassing_buffer
  me->gs_client_handling
  g_user_settings.

  TRANSLATE me->dbhint_syntax USING `' `.

  TRY.

      me->execute_select_via_subpool_v_2(
      EXPORTING
      i_progress_indicator = i_progress_indicator
      IMPORTING
      e_result_details = e_result_details ).

      IF e_result_details-lines EQ l_maxsel.
        MESSAGE s044(/cadaxo/sqlc) WITH l_maxsel.
        MOVE abap_true TO e_result_details-restricted_lines.
        MOVE l_maxsel  TO e_result_details-maxsel.
      ENDIF.

      me->result_lines    = e_result_details-lines.
      me->result_runtime = e_result_details-runtime.

      e_result_details-syst    = sy-sysid.
      e_result_details-uname   = sy-uname.
      e_result_details-mandant = sy-mandt.
      GET TIME STAMP FIELD e_result_details-create_timestamp.

    CATCH cx_sy_open_sql_db INTO lr_exception.
      LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
      me->where_syntax me->group_syntax
      me->having_syntax me->order_syntax.
      RAISE EXCEPTION lr_exception.

    CATCH /cadaxo/cx_sqlc_syntax_error INTO lr_root_exception.
      LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
      me->where_syntax me->group_syntax
      me->having_syntax me->order_syntax.
      RAISE EXCEPTION lr_root_exception.

    CATCH cx_sy_conversion_error INTO lr_exception2.
      LOG-POINT ID /cadaxo/sqlc FIELDS me->column_syntax me->source_syntax l_maxsel
      me->where_syntax me->group_syntax
      me->having_syntax me->order_syntax.
      RAISE EXCEPTION lr_exception2.

  ENDTRY.
  RETURN.
ENDMETHOD.


METHOD format_abap_code.
****************************************************************************************************
* Description             : Format the ABAP Code                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | Fößleitner Johann    | Position error                              | CDX001-0011    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
  DATA: lt_abap_code TYPE /cadaxo/sqlcstring_t,
        ls_abap_code LIKE LINE OF lt_abap_code.

  DATA: l_pos_from TYPE i,
        l_pos_to   TYPE i,
        l_len      TYPE i,
        l_count    TYPE p DECIMALS 1,
        l_space    TYPE string.

  FIELD-SYMBOLS: <l_abap_code> LIKE LINE OF lt_abap_code.

  CONCATENATE '' '' INTO l_space SEPARATED BY space.

  MOVE ct_abap_code[] TO lt_abap_code[].

  CLEAR ct_abap_code.

  l_pos_to = i_columns.
*  l_pos_from = 0.                               "CDX001-0011

  LOOP AT lt_abap_code ASSIGNING <l_abap_code>.
    l_pos_from = 0.                              "CDX001-0011
    IF strlen( <l_abap_code> ) LE l_pos_to.
      APPEND shift_left( <l_abap_code> ) TO ct_abap_code.
    ELSE.
      ls_abap_code = <l_abap_code>.
      DATA(lv_line_length) = strlen( ls_abap_code ).
      WHILE l_pos_to <= lv_line_length. "ls_abap_code+l_pos_to NE l_space.

        DO.
          IF ls_abap_code+l_pos_to(1) EQ l_space.
            FIND ALL OCCURRENCES OF '''' IN SECTION OFFSET l_pos_to OF ls_abap_code MATCH COUNT l_count.
            IF sy-subrc EQ 0.
              l_count = l_count / 2.
              IF frac( l_count ) EQ 0.
                l_pos_to = l_pos_to - 1.
                EXIT.
              ENDIF.
            ELSE.
              l_pos_to = l_pos_to - 1.
              EXIT.
            ENDIF.
          ENDIF.
          l_pos_to = l_pos_to - 1.
        ENDDO.

        l_len = ( l_pos_to - l_pos_from ) + 1.

        APPEND shift_left( ls_abap_code+l_pos_from(l_len) ) TO ct_abap_code.

        l_pos_from = l_pos_to + 1.
        l_pos_to = l_pos_from + i_columns.

        IF l_pos_to > lv_line_length.
          APPEND shift_left( ls_abap_code+l_pos_from ) TO ct_abap_code.
          EXIT.
        ENDIF.

      ENDWHILE.

    ENDIF.
  ENDLOOP.


ENDMETHOD.


METHOD format_value.
****************************************************************************************************
* Description             : Bring the value of th where_col in right format  (CDX130-018)          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Ana Lekic                Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
* 09.05.2014 | Domi Bigl            | no decimal . for P decimals 0               | RT229          *
*------------+----------------------+---------------------------------------------+----------------*
* 24.07.2014 | Rehan vd Merwe       | correct parsing of ., in timestamps         | RT139          *
*------------+----------------------+---------------------------------------------+----------------*
* 12.11.2017 | Domi Bigl            | check for table fieldname                   | COCKPIT-277    *
****************************************************************************************************

  DATA l_count    TYPE p DECIMALS 1.
  DATA l_len      TYPE i.
  DATA l_flen     TYPE i.

  DATA lo_matcher TYPE REF TO cl_abap_matcher.              " RT139
  DATA l_match   TYPE c LENGTH 1.                           " RT139

  DATA l_dref     TYPE REF TO data.                         " RT139
  FIELD-SYMBOLS: <ls> TYPE any.                             " RT139
  CREATE DATA l_dref TYPE HANDLE i_abap_type.               " RT139
  ASSIGN l_dref->* TO <ls>.                                 " RT139

  CLEAR e_added.
  CLEAR l_len.
  CLEAR l_flen.

  l_len = strlen( c_where_col-value ).                   " Replaces previous RT229 " RT139

  CASE i_abap_type->type_kind.
    WHEN 'P' OR 'F'.

      FIND ALL OCCURRENCES OF '''' IN c_where_col-value MATCH COUNT l_count.
      l_count = l_count / 2.
      IF l_count NE 0 AND frac( l_count ) EQ 0.
      ELSE.
        REPLACE ALL OCCURRENCES OF '''' IN c_where_col-value WITH ''.
        CONCATENATE '''' c_where_col-value '''' INTO c_where_col-value.
      ENDIF.

      REPLACE ALL OCCURRENCES OF '''' IN c_where_col-value WITH ''." RT139
      DATA l_char TYPE c LENGTH 40.                         " RT139
      l_char = c_where_col-value.                           " RT139
      SHIFT l_char LEFT DELETING LEADING space.             " RT139

* if it is not in the correct format '\d*\.\d*', convert it. " RT139
      CLEAR lo_matcher.                                     " RT139
      lo_matcher = cl_abap_matcher=>create( pattern     = '\d*\.\d*'" RT139
                                            text        = l_char )." RT139
      l_match = lo_matcher->match( ).                       " RT139
      CLEAR lo_matcher.                                     " RT139
      IF l_match <> abap_true                               " RT139
         AND l_char CO ' 0987654321,.'.                     "COCKPIT-277
        TRY.                                                                                 "COCKPIT-105
            me->format_value_wo_ddic( EXPORTING iv_value = l_char CHANGING cv_value = <ls> )."COCKPIT-105
          CATCH cx_sy_conversion_no_number.                                                  "COCKPIT-105
            RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value                               "COCKPIT-105
              EXPORTING                                                                      "COCKPIT-105
                value = c_where_col-value                                                    "COCKPIT-105
                field = CONV #( c_where_col-fieldname ).                                     "COCKPIT-105
        ENDTRY.                                                                              "COCKPIT-105

        c_where_col-value = <ls>.                           " RT139
      ELSE.                                                 " RT139
        c_where_col-value = l_char.                         " RT139
      ENDIF.                                                " RT139

      IF l_char CO ' 0987654321,.'.                           "COCKPIT-277
        CONDENSE c_where_col-value.                           " RT139
        CONCATENATE '''' c_where_col-value '''' INTO c_where_col-value." RT139

        l_flen = strlen( c_where_col-value ).           " Replaces previous RT229 " RT139
        IF l_flen <> l_len.                             " Replaces previous RT229 " RT139
          ADD 1 TO e_added.                             " Replaces previous RT229 " RT139
        ENDIF.                                          " Replaces previous RT229 " RT139
      ENDIF.                                                   "COCKPIT-277
  ENDCASE.


ENDMETHOD.


METHOD format_value_wo_ddic.
****************************************************************************************************
* Description             : Bring the value of the where_col in right format                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 18.02.2017               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

  DATA: lv_subrc LIKE sy-subrc.
  DATA: lv_error TYPE rsconverr.
  DATA: lv_convert TYPE rsconvert.
  DATA: lv_int TYPE i.
  DATA: lv_deciflag.
  DATA: lv_tcurx TYPE tcurx.
  DATA: lr_field TYPE REF TO data.

  DATA: BEGIN OF ls_emask,
          prefix(2),
          convexit  TYPE rsconvert-convexit,
        END   OF ls_emask.

  DESCRIBE FIELD cv_value TYPE          lv_convert-type
                          COMPONENTS    lv_int
                          LENGTH        lv_convert-length
                          IN BYTE MODE
                          OUTPUT-LENGTH lv_convert-olength
                          DECIMALS      lv_convert-decimals
                          EDIT MASK     ls_emask.

  CALL FUNCTION 'RS_CONV_EX_2_IN_NO_DD'
    EXPORTING
      input_external  = iv_value
    IMPORTING
      output_internal = cv_value
    EXCEPTIONS
      OTHERS          = 1.
  IF sy-subrc <> 0 .
    IF ls_emask IS NOT INITIAL.
      CASE lv_convert-type.
        WHEN 'P'.
          DATA(lr_elem_handle) = cl_abap_elemdescr=>get_p( EXPORTING p_length = lv_convert-length
                                                                     p_decimals = lv_convert-decimals ).

        WHEN 'F'.
          lr_elem_handle = cl_abap_elemdescr=>get_f( ).
      ENDCASE.

      CREATE DATA lr_field TYPE HANDLE lr_elem_handle.
      ASSIGN lr_field->* TO FIELD-SYMBOL(<lv_field>).
      me->format_value_wo_ddic( EXPORTING iv_value = iv_value
                                CHANGING  cv_value = <lv_field> ).
      cv_value = <lv_field>.
    ELSE.
      RAISE EXCEPTION TYPE cx_sy_conversion_no_number.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD GET_ABAP_TYPEDESCR.
****************************************************************************************************
* Description             : Buffer CL_ABAP_TYPEDESCR                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations : To improve the performance, we use a local buffer to get the           *
*                           abap types                                                             *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
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

  DATA lcl_typedescr  TYPE REF TO cl_abap_typedescr.

  FIELD-SYMBOLS <l_tabtypedescr> like line of gt_abap_typedescr.

* can we get the type from the local buffer?
  READ TABLE gt_abap_typedescr WITH KEY typename = i_name ASSIGNING <l_tabtypedescr>.
  IF sy-subrc EQ 0.
    MOVE <l_tabtypedescr>-abap_typedescr TO r_abap_typedescr.
  ELSE.
* the given type isn't in the local buffer, so we get it from the database
    cl_abap_typedescr=>describe_by_name(
      EXPORTING
        p_name         = i_name
      RECEIVING
        p_descr_ref    = lcl_typedescr
      EXCEPTIONS
        type_not_found = 1
        OTHERS         = 2 ).
    IF sy-subrc EQ 0. "add the type description to buffer
      APPEND INITIAL LINE TO gt_abap_typedescr ASSIGNING <l_tabtypedescr>.

      MOVE: i_name        TO <l_tabtypedescr>-typename,
            lcl_typedescr TO <l_tabtypedescr>-abap_typedescr.

      MOVE <l_tabtypedescr>-abap_typedescr TO r_abap_typedescr.

    ELSE. "in this case, we have realy a problem. Should not happen ...
      raise exception type /cadaxo/cx_sqlc_type_not_found
         exporting type = i_name.
    ENDIF.
  ENDIF.

ENDMETHOD.


  method get_code_bypassing_buffer.

    if not me->g_bypassing_buffer is initial.
      append ' BYPASSING BUFFER' to ct_code.
    endif.

  endmethod.


  method get_code_connection.
    data l_line type string.

    if not me->connection_syntax is initial.
      concatenate ' CONNECTION' me->connection_syntax into l_line separated by space.
      append l_line to ct_code.
    endif.
  endmethod.


method get_code_dbhints.

  data l_line           type string.

  if not me->dbhint_syntax is initial.
    concatenate ' %_HINTS MSSQLNT' me->dbhint_syntax into l_line separated by space.
    append l_line to ct_code.
    concatenate '         DB6     ' me->dbhint_syntax into l_line separated by space.
    append l_line to ct_code.
    concatenate '         DB2     ' me->dbhint_syntax into l_line separated by space.
    append l_line to ct_code.
    concatenate '         AS400   ' me->dbhint_syntax into l_line separated by space.
    append l_line to ct_code.
    concatenate '         INFORMIX' me->dbhint_syntax into l_line separated by space.
    append l_line to ct_code.
    concatenate '         ORACLE  ' me->dbhint_syntax into l_line separated by space.
    append l_line to ct_code.
    concatenate '         ADABAS  ' me->dbhint_syntax into l_line separated by space.
    append l_line to ct_code.
  endif.

endmethod.


  METHOD get_code_fields.

    DATA l_line TYPE string.

    IF NOT me->fields_syntax IS INITIAL.
      CONCATENATE ' FIELDS' me->fields_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


method get_code_group_by.

  data l_line type string.

  if not me->group_syntax is initial.
    concatenate ' GROUP BY' me->group_syntax into l_line separated by space.
    append l_line to ct_code.
  endif.

endmethod.


method get_code_having.

  data l_line type string.

  if not me->having_syntax is initial.
    concatenate ' HAVING' me->having_syntax into l_line separated by space.
    append l_line to ct_code.
  endif.

endmethod.


METHOD get_code_into.

  CASE me->g_select_version.
    WHEN c_select_version_1.
    WHEN c_select_version_2.
      IF NOT me->g_select_single IS INITIAL.
        APPEND ' INTO @DATA(LS_RESULT_EXP)' TO ct_code.
      ELSE.
        IF NOT i_progress_indicator IS INITIAL.
          APPEND ' APPENDING TABLE @DATA(TAB_RESULT_EXP)' TO ct_code.
        ELSE.
          APPEND ' INTO TABLE @DATA(TAB_RESULT_EXP)' TO ct_code.
        ENDIF.
      ENDIF.
  ENDCASE.

ENDMETHOD.


  METHOD GET_CODE_OFFSET.

    DATA l_line TYPE string.

    IF NOT me->offset_syntax IS INITIAL.
      CONCATENATE ' OFFSET' me->offset_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  method get_code_order_by.

    data l_line type string.

    if not me->order_syntax is initial.
      concatenate ' ORDER BY' me->order_syntax into l_line separated by space.
      append l_line to ct_code.
    endif.

  endmethod.


  METHOD get_code_trace_off.

    APPEND 'IF L_SQL_TRACE_ACTIVATED IS NOT INITIAL.' TO ct_code.
    APPEND '  /CADAXO/CL_SQLC_COCKPIT_ASSIST=>SQL_TRACE_OFF(' TO ct_code.
    APPEND '    EXPORTING' TO ct_code.
    APPEND '     I_SQL_TRACE = EXP_US_SQL_TRACE' TO ct_code.
    APPEND '     I_TABLEBUFFER_TRACE = EXP_US_TB_TRACE' TO ct_code.
    APPEND '   IMPORTING' TO ct_code.
    APPEND '     E_DATE_TO = L_RESULT_DETAILS-DATE_TO' TO ct_code.
    APPEND '     E_TIME_TO = L_RESULT_DETAILS-TIME_TO ).' TO ct_code.
    APPEND '  CLEAR L_SQL_TRACE_ACTIVATED.' TO ct_code.
    APPEND 'endif.' TO ct_code.

  ENDMETHOD.


  METHOD get_code_trace_on.

    APPEND '/CADAXO/CL_SQLC_COCKPIT_ASSIST=>SQL_TRACE_ON(' TO ct_code.
    APPEND 'EXPORTING' TO ct_code.
    APPEND ' I_SQL_TRACE = EXP_US_SQL_TRACE' TO ct_code.
    APPEND ' I_TABLEBUFFER_TRACE = EXP_US_TB_TRACE' TO ct_code.
    APPEND ' IMPORTING' TO ct_code.
    APPEND '   E_DATE_FROM = L_RESULT_DETAILS-DATE_FROM' TO ct_code.
    APPEND '   E_TIME_FROM = L_RESULT_DETAILS-TIME_FROM' TO ct_code.
    APPEND '   E_SUCCESS   = L_SQL_TRACE_ACTIVATED ).' TO ct_code.

  ENDMETHOD.


 METHOD get_code_up_to_rows.

   DATA l_line     TYPE string.
   DATA l_maxsel   TYPE c LENGTH 10.

   IF me->g_select_single IS INITIAL.

     IF NOT me->g_up_to_x_rows IS INITIAL.
       MOVE me->g_up_to_x_rows TO l_maxsel.
     ELSEIF NOT g_user_settings-maxsel IS INITIAL and me->g_no_upto IS INITIAL.
       MOVE me->g_user_settings-maxsel TO l_maxsel.
     ENDIF.

     IF NOT l_maxsel IS INITIAL.
       CONCATENATE ' UP TO' l_maxsel 'ROWS' INTO l_line SEPARATED BY space.
       APPEND l_line TO ct_code.
     ENDIF.

   ENDIF.

 ENDMETHOD.


  METHOD get_code_where.
********************************************************************************************************************************
* 21.01.2019 | Pat Patil            | Validate IN Operator for multi-value symbols in WHERE condition | Cockpit-349
********************************************************************************************************************************

    DATA l_line TYPE string.
    DATA lt_results             TYPE match_result_tab.
    DATA l_symbol_name          TYPE /cadaxo/sqlcsymbol_name.
    DATA lt_symbols             TYPE TABLE OF /cadaxo/sqlcsymbol_name.
    DATA l_from                 TYPE i.
    DATA l_length               TYPE i.
    DATA l_symbol_name_replace  TYPE string.
    DATA l_where_syntax         TYPE string.
    DATA l_symbol_value         TYPE string.
    DATA l_symbol_multivalue    TYPE string.
    DATA lv_is_multi            TYPE abap_bool.
    DATA l_symbol_value_replace TYPE string.

    FIELD-SYMBOLS: <ls_result>  LIKE LINE OF lt_results,
                   <ls_symbols> LIKE LINE OF lt_symbols.

    IF NOT me->where_syntax IS INITIAL.

      l_where_syntax = me->where_syntax.

      IF i_only_initval = abap_true.
        "       Replace Multivalue With Initial value

        /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex(
          EXPORTING
            i_where_syntax =     l_where_syntax
          IMPORTING
            e_result_tab   =     lt_results
        ).

        IF sy-subrc EQ 0.
          LOOP AT lt_results ASSIGNING <ls_result>.

            l_from = <ls_result>-offset + 1.
            l_length = <ls_result>-length - 2.

            l_symbol_name = l_where_syntax+l_from(l_length).
            APPEND l_symbol_name TO lt_symbols.

          ENDLOOP.
        ENDIF.
        LOOP AT lt_symbols ASSIGNING <ls_symbols>.

          l_symbol_name = to_upper( <ls_symbols> ).

          /cadaxo/cl_sqlc_cockpit_assist=>get_user_symbol_value(
            EXPORTING i_symbol            = l_symbol_name
            IMPORTING e_symbol_value      = l_symbol_value
                      e_symbol_multivalue = l_symbol_multivalue
                      e_is_multi          = lv_is_multi ).

          IF lv_is_multi = abap_true.

            l_symbol_name_replace = `&` && l_symbol_name && `&`.

* begin of change #349
            me->parse_sql_where_columns( ) .
            READ TABLE me->gt_sql_where_col_tab_t WITH KEY value = l_symbol_name_replace INTO DATA(ls_where).
            IF sy-subrc = 0 AND ls_where-operator <> 'IN'.
              MESSAGE e136(/cadaxo/sqlc) WITH l_symbol_name INTO DATA(l_message).
              RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
                EXPORTING
                  message = l_message.
            ENDIF.
* end of change #349

            l_symbol_value_replace = `( '` && l_symbol_multivalue && `' )`.
            REPLACE ALL OCCURRENCES OF REGEX l_symbol_name_replace IN l_where_syntax WITH l_symbol_value_replace IGNORING CASE.
          ENDIF.
        ENDLOOP.

      ENDIF.

      CONCATENATE ' WHERE' l_where_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


METHOD GET_DDIC_FIELD_LIST.
****************************************************************************************************
* Description             : Get the field list in ddic format                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
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

  r_fields_t = i_cl_abap_structdescr->get_ddic_field_list( ).

ENDMETHOD.


METHOD get_multisymbol_data_table.
  DATA lt_results        TYPE match_result_tab.
  DATA l_symbol_name     TYPE string.
  DATA l_symbol_sql      TYPE string.
  DATA l_symbol_multival TYPE /cadaxo/sqlcsymbol_multivalue.
  DATA lr_symbol_value   TYPE rseloption.
  DATA l_sql             TYPE string.
  DATA l_tmp_sql         TYPE string.
  DATA l_varname         TYPE char50.
  DATA l_symbol_datatype TYPE /cadaxo/sqlcsymbol_datatype.

  l_sql = i_where_syntax.

  /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex(
    EXPORTING
      i_where_syntax =     i_where_syntax
    IMPORTING
      e_result_tab   =     lt_results
  ).

"  FIND ALL OCCURRENCES OF REGEX '&(\w|/|-)+&' IN l_sql RESULTS lt_results.

  IF sy-subrc = 0.
    LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<l_result>).

      l_symbol_sql = i_where_syntax+<l_result>-offset(<l_result>-length).
      l_symbol_name = l_symbol_sql.
      REPLACE ALL OCCURRENCES OF '&' IN l_symbol_name WITH space.
      CONDENSE l_symbol_name NO-GAPS.
      TRANSLATE l_symbol_name TO UPPER CASE.                                 "CDX130-009

      SELECT SINGLE symbol_multivalue symbol_datatype FROM /cadaxo/sqlcusym
        INTO ( l_symbol_multival, l_symbol_datatype )
        WHERE username    = sy-uname
          AND symbol_name = l_symbol_name.

      IF sy-subrc = 0 AND l_symbol_multival IS NOT INITIAL.
        /cadaxo/cl_sqlc_cockpit_assist=>decompress_symbol_multivalue( EXPORTING i_symbol_multivalue = l_symbol_multival
                                                                      IMPORTING e_symbol_multivalue = lr_symbol_value ).
      ENDIF.

      l_varname = 'ltr_' && to_lower( l_symbol_name ).
      APPEND VALUE #( var_name = l_varname data_type = l_symbol_datatype range_table = lr_symbol_value ) TO e_symbol_variable.

      l_varname = '@ltr_' && l_symbol_name.
      REPLACE ALL OCCURRENCES OF l_symbol_sql IN l_sql WITH l_varname IGNORING CASE.
    ENDLOOP.

    i_where_syntax = l_sql.
    SORT e_symbol_variable.
    DELETE ADJACENT DUPLICATES FROM e_symbol_variable.
  ENDIF.
ENDMETHOD.


METHOD insert_sql_to_log.
****************************************************************************************************
* Description             : Insert sql command to log                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
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

  DATA l_sqlclog    TYPE /cadaxo/sqlclog.
  DATA l_sqllog_xml TYPE /cadaxo/sqlc_sqllog.
  DATA l_xml        TYPE string.

  CLEAR: l_sqlclog.

  GET TIME STAMP FIELD e_timestamp.

  CLEAR l_sqllog_xml.
  l_sqllog_xml-sql_string    = i_sql_string.
  l_sqllog_xml-result_status = '01'.
  l_sqllog_xml-sql_mode      = i_sql_mode.

  CALL TRANSFORMATION id SOURCE log = l_sqllog_xml
                         RESULT XML l_xml.

  cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                               IMPORTING gzip_out = l_sqlclog-sql_log ).
  l_sqlclog-timestamp = e_timestamp.
  l_sqlclog-uname     = sy-uname.


  INSERT /cadaxo/sqlclog FROM l_sqlclog.            "#EC CI_IMUD_NESTED

  COMMIT WORK.

  FREE: l_sqlclog, l_xml, l_sqllog_xml.

ENDMETHOD.


  METHOD is_count_star_only.
****************************************************************************************************
* Description             : Check if only count(*) is requested                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations : checks also with alias name                                            *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 26.01.2017               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    TYPES: ltr_string TYPE RANGE OF string.

    DATA(lv_fieldlist) = to_lower( condense( iv_fieldlist ) ).
    DATA(lv_fieldlist_nogabs) = condense( val = lv_fieldlist del = ` ` from = ` ` to = space ).

    ev_is_count_star_only = abap_false.

    IF lv_fieldlist_nogabs NA ','.

      IF  lv_fieldlist_nogabs IN VALUE ltr_string( sign = 'I' option = 'EQ'
                                                  ( low = 'count(*)' )
                                                  ( low = 'singlecount(*)' )
                                                  ( low = 'distinctcount(*)' ) ).
        ev_is_count_star_only = abap_true.
      ELSE.

        SPLIT lv_fieldlist AT ` as ` INTO TABLE DATA(lt_parts).

        CASE lines( lt_parts ).
          WHEN 2.
            IF lt_parts[ 2 ] NA space.
              ev_is_count_star_only = is_count_star_only( iv_fieldlist = lt_parts[ 1 ] ).
            ENDIF.
          WHEN 3.
            ev_is_count_star_only = is_count_star_only( iv_fieldlist = lt_parts[ 1 ] && lt_parts[ 2 ] ).
        ENDCASE.

      ENDIF.

    ENDIF.
  ENDMETHOD.


METHOD parse_sql_i.
****************************************************************************************************
* Description             : Parse 1                                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.09.2010 | Fößleitner Johann    | Support DB Hints                            | CDX001-0011    *
*------------+----------------------+---------------------------------------------+----------------*
* 24.10.2010 | Bigl Domi            |                                             | CDX001-0019    *
*------------+----------------------+---------------------------------------------+----------------*
* 24.01.2011 | Bigl Domi            |                                             | CDX001-0022    *
*------------+----------------------+---------------------------------------------+----------------*
* 24.01.2011 | Bigl Domi            |                                             | CDX001-DEMO    *
*------------+----------------------+---------------------------------------------+----------------*
* 11.11.2011 | Johann Fößleitner    | add new attribute sql_syntax_without_where  | CDX001-0029    *
*------------+----------------------+---------------------------------------------+----------------*
* 11.11.2011 | Johann Fößleitner    | fix bug open/close bracket                  | CDX001-0029    *
*------------+----------------------+---------------------------------------------+----------------*
* 22.05.2012 | Ana Lekic            | max number of selects from admin-customizing| CDX130-011     *
*------------+----------------------+---------------------------------------------+----------------*
* 27.04.2015 | Ana Lekic            | parse where                                 | COCKPIT-60     *
*------------+----------------------+---------------------------------------------+----------------*
* 26.01.2017 | Domi Bigl            | count(*) + group by                         | COCKPIT-100    *
*------------+----------------------+---------------------------------------------+----------------*
* 05.07.2017 | Dusan Sacha          | fix working with 'unlimited' string  SELECT | COCKPIT-222    *
*------------+----------------------+---------------------------------------------+----------------*
* 06.07.2017 | Domi Bigl            | Select is too large                         | COCKPIT-223    *
*------------+----------------------+---------------------------------------------+----------------*
* 24.07.2017 | Harald Wiesinger     | check for USING CLIENT                      | COCKPIT-225    *
*------------+----------------------+---------------------------------------------+----------------*
* 16.09.2017 | Domi Bigl            | Brackets in FROM                            | COCKPIT-114    *
*------------+----------------------+---------------------------------------------+----------------*
* 21.09.2017 | Föß                  | Add FIELDS                                  | COCKPIT-261    *
****************************************************************************************************

  TYPES: BEGIN OF t_split,
           line(255),
         END OF t_split.


  DATA: l_section(10),
        l_moff              TYPE i,
        l_foff              TYPE i,
        l_column_f          TYPE i,
        l_column_t          TYPE i,
        l_from_f            TYPE i,
        l_connection_f      TYPE i,
        l_connection_t      TYPE i,
        l_from_t            TYPE i,
        l_where_f           TYPE i,
        l_where_t           TYPE i,
        l_order_f           TYPE i,
        l_hints_f           TYPE i,                "CDX001-0011
        l_order_t           TYPE i,
        l_group_f           TYPE i,
        l_group_t           TYPE i,
        l_having_f          TYPE i,
        l_having_t          TYPE i,
        l_hints_t           TYPE i,                "CDX001-0011
        l_fields_f          TYPE i,                "COCKPIT-261
        l_fields_t          TYPE i,                "COCKPIT-261
        l_offset_f          TYPE i,
        l_offset_t          TYPE i,
        l_klammer_offen     TYPE i,
        lv_check_sql_string TYPE string,           "COCKPIT-222
        lv_spacer_string    TYPE string,           "COCKPIT-222
        l_alias             TYPE c,
        l_length            TYPE i,
        l_message           TYPE string.

  DATA: lt_split         TYPE TABLE OF t_split.
  DATA: lt_match_results TYPE TABLE OF match_result.
  DATA: l_sql_string_c(100) TYPE c.
  DATA: l_maxsel TYPE i.
  DATA: l_sql_string TYPE string.

  DATA ls_adm_cust TYPE /cadaxo/sqlc_admin_cust.

  FIELD-SYMBOLS: <l_match_result> TYPE match_result,
                 <l_split>        LIKE LINE OF lt_split.

  sql_string = i_sql.
  g_role     = i_role.
  g_main_ref = i_main_ref.

* get customizing
  /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).

* convert sql-string to upper case
  sql_string = /cadaxo/cl_sqlc_cockpit_assist=>translate_sql_str_upper_case( sql_string ).

  SHIFT sql_string LEFT DELETING LEADING space.

  DATA: l_len                TYPE i,
        l_from               TYPE i,
        l_to                 TYPE i,
        l_act_do             TYPE i,
        l_apostrophe_open(1) TYPE c,
        lt_string_sql        TYPE TABLE OF string,
        l_string             TYPE string.

  DATA: l_cl_sql_parse TYPE REF TO /cadaxo/cl_sqlc_cockpit_parse.

  l_len = strlen( sql_string ).
  l_from = 0.
  DO l_len TIMES.
    l_act_do = sy-index - 1.
    CASE sql_string+l_act_do(1).
      WHEN '.'.
        IF l_apostrophe_open EQ space.
          l_to = l_act_do - l_from.
          MOVE sql_string+l_from(l_to) TO l_string.
          IF NOT l_string IS INITIAL AND
                 l_string NE cl_abap_char_utilities=>cr_lf AND
                 l_string CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890=().'.
            APPEND l_string TO lt_string_sql.
          ENDIF.
          l_from = l_act_do + 1.
        ENDIF.
      WHEN c_apostrophe.
        TRANSLATE l_apostrophe_open USING ' XX '.
    ENDCASE.
  ENDDO.
  IF NOT sql_string+l_from IS INITIAL.
    MOVE sql_string+l_from TO l_string.
    IF NOT l_string IS INITIAL AND
           l_string NE cl_abap_char_utilities=>cr_lf AND
           l_string CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890=().'.
      APPEND l_string TO lt_string_sql.
    ENDIF.
  ENDIF.

  CLEAR: e_sql_parsed[].

  LOOP AT lt_string_sql INTO sql_string.

    CREATE OBJECT l_cl_sql_parse.

    SHIFT sql_string LEFT DELETING LEADING space.

    TRY.
        WHILE sql_string(2) EQ cl_abap_char_utilities=>cr_lf.
          sql_string = sql_string+2.
          SHIFT sql_string LEFT DELETING LEADING space.
        ENDWHILE.
      CATCH cx_sy_range_out_of_bounds.
    ENDTRY.

    l_cl_sql_parse->sql_syntax = sql_string.

* Delete CR/LF
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN sql_string WITH space.
    SHIFT sql_string LEFT DELETING LEADING space.

***    DATA(l_bytes) = strlen( sql_string ) * cl_abap_char_utilities=>charsize."COCKPIT-223
***    IF l_bytes > 57000.                                                     "COCKPIT-223
***      MESSAGE e116(/cadaxo/sqlc) INTO l_message.                            "COCKPIT-223
***      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error                     "COCKPIT-223
***        EXPORTING                                                           "COCKPIT-223
***          message       = l_message                                         "COCKPIT-223
***          /cadaxo/msgid = '/CADAXO/SQLC'                                    "COCKPIT-223
***          /cadaxo/msgnr = '016'.                                            "COCKPIT-223
***    ENDIF.                                                                  "COCKPIT-223

    l_cl_sql_parse->sql_syntax_without_where = sql_string.     "CDX001-0029

    CLEAR:
        l_section,
        l_moff,
        l_foff,
        l_column_f,
        l_column_t,
        l_from_f,
        l_from_t,
        l_where_f,
        l_where_t,
        l_order_f,
        l_order_t,
        l_group_f,
        l_group_t,
        l_having_f,
        l_having_t,
        l_hints_f,                               "CDX001-0019
        l_hints_t,                               "CDX001-0019
        l_fields_f,                              "COCKPIT-261
        l_fields_t,                              "COCKPIT-261
        l_offset_f,
        l_offset_t,
        l_connection_f,
        l_connection_t,
        l_klammer_offen.

* Check if SELECT is first
    l_sql_string_c = sql_string.

    IF l_sql_string_c(15) EQ 'SELECT DISTINCT'.
      l_foff = l_foff + 16.
      l_cl_sql_parse->g_select_distinct = abap_true.
    ELSEIF l_sql_string_c(22) EQ 'SELECT SINGLE DISTINCT'.
      l_foff = l_foff + 23.
      l_cl_sql_parse->g_select_distinct = abap_true.
      l_cl_sql_parse->g_select_single = abap_true.
    ELSEIF l_sql_string_c(13) EQ 'SELECT SINGLE'.
      l_foff = l_foff + 14.
      l_cl_sql_parse->g_select_single = abap_true.
    ELSEIF l_sql_string_c(6) EQ 'SELECT'.
      l_foff = l_foff + 7.
    ELSE.

      data tab_found type abap_bool.
      clear tab_found.
      SELECT SINGLE @abap_true FROM dd02l WHERE tabname = @l_sql_string_c
                                     AND as4local = 'A'
                                     INTO @tab_found.
      if sy-subrc <> 0.
         SELECT SINGLE @abap_true FROM ddldependency
                                      WHERE objectname = @l_sql_string_c
                                       INTO @tab_found.
      endif.

      IF tab_found = abap_true.

        l_sql_string_c = `SELECT * FROM ` && l_sql_string_c.
        sql_string = l_sql_string_c.
        l_cl_sql_parse->sql_syntax_without_where = l_sql_string_c.
        l_cl_sql_parse->sql_syntax = l_sql_string_c.
        l_foff = l_foff + 7.

      ELSE.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_no_sel_at_firs.
      ENDIF.

    ENDIF.

* Set initial section
    l_section  = 'COLUMN'.
    l_column_f = l_foff.

* Delete ending '.'
    CLEAR sy-subrc.
    WHILE sy-subrc EQ 0.
      FIND FIRST OCCURRENCE OF REGEX '\.$' IN sql_string MATCH OFFSET l_moff.
      IF sy-subrc EQ 0.
        sql_string = sql_string(l_moff).
      ENDIF.
    ENDWHILE.

* extract up to x rows, bypassing buffer and client specified
    lv_check_sql_string = sql_string.

    FIND ALL OCCURRENCES OF REGEX '''[^'']*''' IN sql_string RESULTS lt_match_results.
    IF sy-subrc EQ 0.
      SORT lt_match_results BY offset DESCENDING.
      LOOP AT lt_match_results ASSIGNING <l_match_result>.
        lv_check_sql_string = replace( val = lv_check_sql_string off = <l_match_result>-offset len = <l_match_result>-length
                                       with = repeat( val = ` ` occ = <l_match_result>-length ) ). "COCKPIT-222
      ENDLOOP.
    ENDIF.

    FIND REGEX 'UP\s+TO\s+\d+\s+ROWS' IN lv_check_sql_string MATCH OFFSET l_moff MATCH LENGTH l_length.
    IF sy-subrc EQ 0.
      DATA(lv_up_to_string) = condense( val = lv_check_sql_string+l_moff(l_length) del = ` `). "COCKPIT-222

      SPLIT lv_up_to_string AT space INTO TABLE lt_split.
      READ TABLE lt_split INDEX 3 ASSIGNING <l_split>.
      TRY.
          l_cl_sql_parse->g_up_to_x_rows = <l_split>.
        CATCH cx_sy_conversion_overflow.

          MESSAGE e016(/cadaxo/sqlc) WITH <l_split> INTO l_message.

          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
            EXPORTING
              message = l_message.
      ENDTRY.

      lv_spacer_string = repeat( val = ` ` occ = l_length ).                                                         "COCKPIT-222
      lv_check_sql_string = replace( val = lv_check_sql_string off = l_moff len = l_length with = lv_spacer_string )."COCKPIT-222
      sql_string          = replace( val = sql_string          off = l_moff len = l_length with = lv_spacer_string )."COCKPIT-222

    ENDIF.

    FIND REGEX 'BYPASSING\s+BUFFER' IN lv_check_sql_string MATCH OFFSET l_moff MATCH LENGTH l_length.
    IF sy-subrc EQ 0.

      l_cl_sql_parse->g_bypassing_buffer = abap_true.
      lv_spacer_string = repeat( val = ` ` occ = l_length ).                                                         "COCKPIT-222
      lv_check_sql_string = replace( val = lv_check_sql_string off = l_moff len = l_length with = lv_spacer_string )."COCKPIT-222
      sql_string          = replace( val = sql_string          off = l_moff len = l_length with = lv_spacer_string )."COCKPIT-222

    ENDIF.

* prüfung ob subselect eine CLIENT SPECIFIED hat '\ASELECT(.*)SELECT(.*)(CLIENT\s+SPECIFIED)'

    DATA lt_results TYPE match_result_tab.
    DATA ls_results TYPE match_result.
    DATA l_length2   TYPE i.

ENHANCEMENT-SECTION /cadaxo/sqlc_ehn_s_cls_se_001 SPOTS /cadaxo/sqlc_ehnsp_cls_se_001.
*...
    FIND REGEX 'CLIENT\s+SPECIFIED' IN lv_check_sql_string MATCH OFFSET l_moff MATCH LENGTH l_length.
    IF sy-subrc EQ 0.
      MESSAGE e013(/cadaxo/sqlc).
    ENDIF.

    FIND REGEX 'USING\s+CLIENT' IN lv_check_sql_string MATCH OFFSET l_moff MATCH LENGTH l_length.   "COCKPIT-225
    IF sy-subrc EQ 0.                                                                               "COCKPIT-225
      MESSAGE e121(/cadaxo/sqlc).                                                                   "COCKPIT-225
    ENDIF.                                                                                          "COCKPIT-225

END-ENHANCEMENT-SECTION.

    REPLACE 'COUNT(*)' IN sql_string WITH 'COUNT( * )'.

    l_sql_string = sql_string.

* remove strings
    /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = l_sql_string ).

    DO.
      TRY.
          FIND REGEX '\s' IN SECTION OFFSET l_foff OF l_sql_string MATCH OFFSET l_moff.
          IF sy-subrc EQ 0.
            l_len = l_moff - l_foff.

            IF sql_string+l_foff(l_len) EQ c_apostrophe.
              l_foff = l_foff + 1.
              FIND FIRST OCCURRENCE OF c_apostrophe
                   IN SECTION OFFSET l_foff OF sql_string MATCH OFFSET l_moff.
              l_foff = l_moff.
            ELSEIF sql_string+l_foff(l_len) CA '('.
              l_klammer_offen = l_klammer_offen + 1.
              IF sql_string+l_foff(l_len) CA ')'.                  "CDX001-0039
                l_klammer_offen = l_klammer_offen - 1.             "CDX001-0039
              ENDIF.                                               "CDX001-0039
            ELSEIF sql_string+l_foff(l_len) CA ')'.
              l_klammer_offen = l_klammer_offen - 1.
            ELSEIF sql_string+l_foff(l_len) EQ '.'.
              l_foff = l_foff + 1.
              l_foff = l_moff.
            ELSE.

              IF l_klammer_offen = 0.

                IF l_alias EQ space.
                  CASE sql_string+l_foff(l_len).
                    WHEN 'AS'.
                      l_alias = 'X'.
                    WHEN 'FROM'.
                      IF l_from_f IS INITIAL.
                        l_column_t = l_foff - 1.
                        l_from_f   = l_moff + 1.
                        l_section  = 'SOURCE'.
                      ENDIF.
                    WHEN 'FIELDS'.
                      IF l_fields_f IS INITIAL.
                        l_fields_f  = l_moff + 1.
                        macro_case_section.
                        l_section = 'FIELDS'.
                      ENDIF.
                    WHEN 'OFFSET'.
                      l_offset_f  = l_moff + 1.
                      macro_case_section.
                      l_section = 'OFFSET'.
                    WHEN 'CONNECTION'.
                      l_connection_f  = l_moff + 1.
                      macro_case_section.
                      l_section       = 'CONNECTION'.
                    WHEN 'WHERE'.
                      IF l_where_f IS INITIAL. "COCKPIT-60
                        l_where_f  = l_moff + 1.
                        macro_case_section.
                        l_section  = 'WHERE'.
                      ENDIF.
                    WHEN 'GROUP'.
                      macro_case_section.
                      l_group_f = l_moff + 1.

                      DATA l_off_tmp TYPE i.
                      DATA l_len_tmp TYPE i.
                      DATA l_moff_tmp TYPE i.

                      l_off_tmp = l_moff + 1.

                      FIND REGEX '^ *BY +' IN SECTION OFFSET l_off_tmp OF sql_string MATCH OFFSET l_moff_tmp MATCH LENGTH l_len_tmp.
                      IF sy-subrc NE 0.
                        MESSAGE e093(/cadaxo/sqlc) INTO l_message.
                        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error EXPORTING message = l_message.
                      ELSE.
                        l_group_f = l_moff_tmp + l_len_tmp.
                      ENDIF.

                      l_section  = 'GROUP'.
                    WHEN 'HAVING'.
                      l_having_f  = l_moff + 1.
                      macro_case_section.
                      l_section  = 'HAVING'.
                    WHEN 'ORDER'.
                      macro_case_section.
                      l_order_f  = l_moff + 3.
                      l_section  = 'ORDER'.
                    WHEN '%_HINTS'.                          "CDX001-0011
                      macro_case_section.

                      l_moff = l_moff + 1.                   "CDX001-0011

                      FIND REGEX '\s' IN SECTION OFFSET l_moff OF sql_string MATCH OFFSET l_moff. "CDX001-0011

                      l_hints_f  = l_moff + 1.               "CDX001-0011
                      l_section  = '%_HINTS'.                "CDX001-0011

                  ENDCASE.
                ELSE.

* not supported alias
                  IF sql_string+l_foff(l_len) EQ 'HAVING' OR
                     sql_string+l_foff(l_len) EQ 'WHERE' OR
                     sql_string+l_foff(l_len) EQ 'INTO' OR
                     sql_string+l_foff(l_len) EQ 'INNER' OR
                     sql_string+l_foff(l_len) EQ 'LEFT' OR
                     sql_string+l_foff(l_len) EQ 'ON'.

                    MOVE sql_string+l_foff(l_len) TO l_message.
                    MESSAGE e040(/cadaxo/sqlc) WITH l_message INTO l_message.
                    RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error EXPORTING message = l_message.

                  ENDIF.

                  CLEAR l_alias.

                ENDIF.

              ENDIF.
            ENDIF.
            l_foff = l_moff + 1. "1
          ELSE.
            IF l_from_t IS INITIAL AND NOT l_from_f IS INITIAL.
              l_from_t = strlen( sql_string ).
            ENDIF.
            IF l_where_t IS INITIAL AND NOT l_where_f IS INITIAL.
              l_where_t = strlen( sql_string ).
            ENDIF.
            IF l_order_t IS INITIAL AND NOT l_order_f IS INITIAL.
              l_order_t = strlen( sql_string ).
            ENDIF.
            IF l_group_t IS INITIAL AND NOT l_group_f IS INITIAL.
              l_group_t = strlen( sql_string ).
            ENDIF.
            IF l_having_t IS INITIAL AND NOT l_having_f IS INITIAL.
              l_having_t = strlen( sql_string ).
            ENDIF.
            IF l_hints_t IS INITIAL AND NOT l_hints_f IS INITIAL.   "CDX001-0011
              l_hints_t = strlen( sql_string ).                     "CDX001-0011
            ENDIF.                                                  "CDX001-0011
            IF l_fields_t IS INITIAL AND NOT l_fields_f IS INITIAL. "COCKPIT-261
              l_fields_t = strlen( sql_string ).                    "COCKPIT-261
            ENDIF.                                                  "COCKPIT-261
            IF l_offset_t IS INITIAL AND NOT l_offset_f IS INITIAL.
              l_offset_t = strlen( sql_string ).
            ENDIF.
            IF l_connection_t IS INITIAL AND NOT l_connection_f IS INITIAL.
              l_connection_t = strlen( sql_string ).
            ENDIF.
            EXIT.
          ENDIF.



        CATCH cx_sy_range_out_of_bounds.
          EXIT.
      ENDTRY.
    ENDDO.

    l_len = l_column_t - l_column_f.
    IF l_len GT 0.
      l_cl_sql_parse->column_syntax = sql_string+l_column_f(l_len).
      SHIFT l_cl_sql_parse->column_syntax RIGHT DELETING TRAILING space.                 "CDX001-0022
      SHIFT l_cl_sql_parse->column_syntax LEFT DELETING LEADING space.
    ENDIF.

    l_len = l_from_t - l_from_f.

    IF l_len GT 0.

      l_cl_sql_parse->source_syntax = sql_string+l_from_f(l_len).
*      l_cl_sql_parse->source_syntax = replace( val = l_cl_sql_parse->source_syntax regex = '\( | \)' with = '' occ = 0 ). "COCKPIT-114
      l_cl_sql_parse->source_syntax = shift_left( l_cl_sql_parse->source_syntax ).                                         "COCKPIT-114
      DATA(lv_syntax_cleanup) = shift_left( val = l_cl_sql_parse->source_syntax sub = '(' ).                               "COCKPIT-114
      "COCKPIT-114
      IF lv_syntax_cleanup <> l_cl_sql_parse->source_syntax.                                                               "COCKPIT-114
        "COCKPIT-114
        l_cl_sql_parse->source_syntax = shift_left( lv_syntax_cleanup ).                                                   "COCKPIT-114
        l_cl_sql_parse->source_syntax = shift_right( l_cl_sql_parse->source_syntax ).                                      "COCKPIT-114
        l_cl_sql_parse->source_syntax = shift_right( val = l_cl_sql_parse->source_syntax sub = ')' ).                      "COCKPIT-114
        "COCKPIT-114
      ENDIF.                                                                                                               "COCKPIT-114

    ENDIF.

* no source syntax
    IF l_cl_sql_parse->source_syntax EQ space.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_no_source.
    ENDIF.


    l_len = l_where_t - l_where_f.
    IF l_len GT 0.
      MOVE sql_string+l_where_f(l_len) TO l_cl_sql_parse->where_syntax.
      SHIFT l_cl_sql_parse->where_syntax LEFT DELETING LEADING space.
    ENDIF.

    l_len = l_order_t - l_order_f.
    IF l_len GT 0.
      MOVE sql_string+l_order_f(l_len) TO l_cl_sql_parse->order_syntax.
      SHIFT l_cl_sql_parse->order_syntax LEFT DELETING LEADING space.
    ENDIF.

    l_len = l_group_t - l_group_f.
    IF l_len GT 0.
      MOVE sql_string+l_group_f(l_len) TO l_cl_sql_parse->group_syntax.
      SHIFT l_cl_sql_parse->group_syntax LEFT DELETING LEADING space.
    ENDIF.

    l_len = l_having_t - l_having_f.
    IF l_len GT 0.
      MOVE sql_string+l_having_f(l_len) TO l_cl_sql_parse->having_syntax.
      SHIFT l_cl_sql_parse->having_syntax LEFT DELETING LEADING space.
    ENDIF.

    l_len = l_hints_t - l_hints_f.                                       "CDX001-0011
    IF l_len GT 0 AND sql_string+l_hints_f(l_len) NE space.              "CDX001-0011
      MOVE sql_string+l_hints_f(l_len) TO l_cl_sql_parse->dbhint_syntax. "CDX001-0011
      SHIFT l_cl_sql_parse->dbhint_syntax LEFT DELETING LEADING space.   "CDX001-0011
    ENDIF.                                                               "CDX001-0011

    l_len = l_fields_t - l_fields_f.                                     "COCKPIT-261
    IF l_len GT 0 AND sql_string+l_fields_f(l_len) NE space.             "COCKPIT-261
      MOVE sql_string+l_fields_f(l_len) TO l_cl_sql_parse->fields_syntax."COCKPIT-261
      SHIFT l_cl_sql_parse->fields_syntax LEFT DELETING LEADING space.   "COCKPIT-261
    ENDIF.                                                               "COCKPIT-261

    l_len = l_offset_t - l_offset_f.
    IF l_len GT 0 AND sql_string+l_offset_f(l_len) NE space.
      MOVE sql_string+l_offset_f(l_len) TO l_cl_sql_parse->offset_syntax.
      SHIFT l_cl_sql_parse->offset_syntax LEFT DELETING LEADING space.
    ENDIF.

    l_len = l_connection_t - l_connection_f.
    IF l_len GT 0 AND sql_string+l_connection_f(l_len) NE space.
      IF ls_adm_cust-allow_connection <> abap_true.
        MESSAGE e097(/cadaxo/sqlc) INTO l_message.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
          EXPORTING
            message       = l_message
            /cadaxo/msgid = '/CADAXO/SQLC'
            /cadaxo/msgnr = '097'.
      ENDIF.

      MOVE sql_string+l_connection_f(l_len) TO l_cl_sql_parse->connection_syntax.
      SHIFT l_cl_sql_parse->connection_syntax LEFT DELETING LEADING space.

    ENDIF.

* cds views
    FIND FIRST OCCURRENCE OF REGEX '^([^(\s]+)(\(.*\).*)$' IN l_cl_sql_parse->source_syntax
       SUBMATCHES l_cl_sql_parse->source_syntax l_cl_sql_parse->cds_parameter_syntax.

* check subqueries
    l_cl_sql_parse->subquery = check_sql_string_includes_subq( l_cl_sql_parse->where_syntax ).
    IF l_cl_sql_parse->subquery IS INITIAL AND NOT l_cl_sql_parse->having_syntax IS INITIAL.
      l_cl_sql_parse->subquery = check_sql_string_includes_subq( l_cl_sql_parse->having_syntax ).
    ENDIF.

* check host expressions
    IF ls_adm_cust-allow_host_expressions <> abap_true.
      check_for_host_expressions( CONV #( l_cl_sql_parse->where_syntax ) ).
      check_for_host_expressions( CONV #( l_cl_sql_parse->column_syntax ) ).
      check_for_host_expressions( CONV #( l_cl_sql_parse->fields_syntax ) ).
      check_for_host_expressions( CONV #( l_cl_sql_parse->offset_syntax ) ).
      check_for_host_expressions( CONV #( l_cl_sql_parse->source_syntax ) ).
      check_for_host_expressions( CONV #( l_cl_sql_parse->cds_parameter_syntax ) ).
      check_for_host_expressions( CONV #( l_cl_sql_parse->group_syntax ) ).
      check_for_host_expressions( CONV #( l_cl_sql_parse->order_syntax ) ).
      check_for_host_expressions( CONV #( l_cl_sql_parse->dbhint_syntax ) ).
    ENDIF.

    check_for_host_expr_meth( CONV #( l_cl_sql_parse->where_syntax ) ).
    check_for_host_expr_meth( CONV #( l_cl_sql_parse->where_syntax ) ).
    check_for_host_expr_meth( CONV #( l_cl_sql_parse->column_syntax ) ).
    check_for_host_expr_meth( CONV #( l_cl_sql_parse->fields_syntax ) ).
    check_for_host_expr_meth( CONV #( l_cl_sql_parse->offset_syntax ) ).
    check_for_host_expr_meth( CONV #( l_cl_sql_parse->source_syntax ) ).
    check_for_host_expr_meth( CONV #( l_cl_sql_parse->cds_parameter_syntax ) ).
    check_for_host_expr_meth( CONV #( l_cl_sql_parse->group_syntax ) ).
    check_for_host_expr_meth( CONV #( l_cl_sql_parse->order_syntax ) ).
    check_for_host_expr_meth( CONV #( l_cl_sql_parse->dbhint_syntax ) ).

    IF i_user_settings IS SUPPLIED.
      MOVE i_user_settings TO l_cl_sql_parse->g_user_settings.
    ENDIF.

    IF is_count_star_only( l_cl_sql_parse->column_syntax ).                          "COCKPIT-100
      IF l_cl_sql_parse->group_syntax IS NOT INITIAL.                                "COCKPIT-100
        MESSAGE e109(/cadaxo/sqlc) INTO l_message.                                   "COCKPIT-100
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error                            "COCKPIT-100
          EXPORTING
            message       = l_message
            /cadaxo/msgid = '/CADAXO/SQLC'
            /cadaxo/msgnr = '109'.
      ELSE.                                                                          "COCKPIT-100
        l_cl_sql_parse->g_select_single = abap_true.                                 "COCKPIT-100
      ENDIF.                                                                         "COCKPIT-100
    ENDIF.

    IF NOT l_cl_sql_parse->where_syntax IS INITIAL.                                  "CDX001-0029
      REPLACE FIRST OCCURRENCE OF l_cl_sql_parse->where_syntax                       "CDX001-0029
              IN l_cl_sql_parse->sql_syntax_without_where WITH '<WHEREPARAM>'.       "CDX001-0029
    ENDIF.                                                                           "CDX001-0029

    APPEND l_cl_sql_parse TO e_sql_parsed.

* CDX130-011 Begin
    IF ls_adm_cust-maxsel IS NOT INITIAL.
      MOVE ls_adm_cust-maxsel TO l_maxsel.
    ELSE.
      l_maxsel = 16.
    ENDIF.

    IF sy-tabix GT l_maxsel.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_to_much_resrow EXPORTING max_nr_of_selects = l_maxsel.
    ENDIF.
*  CDX130-011 End
  ENDLOOP.
ENDMETHOD.


METHOD parse_sql_ii.

  CASE me->g_select_version.
    WHEN c_select_version_1 OR c_select_version_0.
      me->parse_sql_ii_1( ).
    WHEN c_select_version_2.
      me->parse_sql_ii_2( ).
  ENDCASE.

ENDMETHOD.


METHOD parse_sql_ii_1.
****************************************************************************************************
* Description             : Concatenate aggregations with fieldnames                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 24.05.2016 | Ana Lekic            | ON clause with ()                           | COCKPIT-63     *
*            |                      |                                             | $001           *
*------------+----------------------+---------------------------------------------+----------------*
* 28.12.2016 | Domi Bigl            | INT8                                        |$002 COCKPIT-148*
****************************************************************************************************

  TYPES: BEGIN OF t_tab_field,
           table       TYPE string,
           field       TYPE string,
           alias       TYPE string,
           alias_field TYPE string,
           aggr        TYPE string,
           count(1)    TYPE c,
         END OF t_tab_field.

  DATA: l_skip           TYPE i,
        l_tabix_next     TYPE i,
        l_tab_field      TYPE t_tab_field,
        lt_tab_field     TYPE TABLE OF t_tab_field,
        l_field_dfies    TYPE dfies,
        ls_result_field  TYPE /cadaxo/sqlcdfies,
        l_tabix          TYPE i,
        ls_result_source LIKE LINE OF me->result_source_t,
        lcl_structtype   TYPE REF TO cl_abap_structdescr,
        lcl_elemdescr    TYPE REF TO cl_abap_elemdescr,
        lt_fields        TYPE ddfields,
        lt_source_split  TYPE TABLE OF string,
        lt_column_split  TYPE TABLE OF string,
        lr_ref_data      TYPE REF TO data,
        l_string         TYPE string,                       "FOE999
        l_lines          TYPE i.

  FIELD-SYMBOLS: <l_source_split>      TYPE string,
                 <l_source_split_next> TYPE string,
                 <l_column_split>      TYPE string,
                 <l_column_split_next> TYPE string,
                 <l_dfies>             TYPE dfies,
                 <l_result_source>     LIKE LINE OF me->result_source_t.

  CLEAR: l_skip,
         me->gt_result_ddfields,
         me->result_source_t.

  MOVE me->source_syntax TO l_string.                       "FOE999

  CONDENSE l_string.                                        "FOE999

  SPLIT l_string AT space INTO TABLE lt_source_split.       "FOE999

  LOOP AT lt_source_split ASSIGNING <l_source_split>.

    IF l_skip GT 0.
      l_skip = l_skip - 1.
      CONTINUE.
    ENDIF.

    IF <l_source_split> EQ 'INNER' OR
       <l_source_split> EQ 'JOIN' OR
       <l_source_split> EQ 'LEFT' OR
       <l_source_split> EQ 'OUTER' OR
       <l_source_split> EQ 'RIGHT'.
      CONTINUE.
    ELSEIF <l_source_split> = 'ON' OR
           <l_source_split> = 'AND' OR
           <l_source_split> = 'OR'.
*     $001 begin
*      l_skip = 3.
*      CONTINUE.
      "find next keyword to know how long to skip
      l_tabix_next = sy-tabix + 1.
      LOOP AT lt_source_split ASSIGNING <l_source_split_next> FROM l_tabix_next.
        IF <l_source_split_next> EQ 'INNER' OR
           <l_source_split_next> EQ 'JOIN' OR
           <l_source_split_next> EQ 'LEFT' OR
           <l_source_split_next> EQ 'OUTER' OR
           <l_source_split_next> EQ 'RIGHT' OR
           <l_source_split_next> EQ 'AND' OR
           <l_source_split_next> EQ 'OR'.
          EXIT.
        ENDIF.
        ADD 1 TO l_skip.
      ENDLOOP.
      "$001 end
    ELSE.
      MOVE <l_source_split> TO ls_result_source-table.

      l_tabix_next = sy-tabix + 1.
      READ TABLE lt_source_split INDEX l_tabix_next ASSIGNING <l_source_split_next>.
      IF sy-subrc EQ 0 AND <l_source_split_next> EQ 'AS'.
        l_tabix_next = l_tabix_next + 1.
        READ TABLE lt_source_split INDEX l_tabix_next ASSIGNING <l_source_split_next>.
        IF sy-subrc EQ 0.
          MOVE <l_source_split_next> TO ls_result_source-alias.
          APPEND ls_result_source TO me->result_source_t.
          CLEAR ls_result_source.
          l_skip = 2.
        ENDIF.
      ELSE.
        IF NOT ls_result_source IS INITIAL.                 "FOE999
          APPEND ls_result_source TO me->result_source_t.
          CLEAR ls_result_source.
        ENDIF.                                              "FOE999
      ENDIF.
    ENDIF.
  ENDLOOP.


* no special columns selected, only one table (SELECT * FROM ... )
  IF me->column_syntax EQ '*'.
* create a local data, type table
    DATA: l_fieldname TYPE string.
    DESCRIBE TABLE me->result_source_t LINES l_lines.       "FOE999
    IF l_lines GT 1.                                        "FOE999
      CLEAR me->column_syntax.
      LOOP AT me->result_source_t
           ASSIGNING <l_result_source>.

        CALL METHOD cl_abap_classdescr=>describe_by_name
          EXPORTING
            p_name         = <l_result_source>-table
          EXCEPTIONS
            type_not_found = 1
            OTHERS         = 2.
        IF sy-subrc EQ 0.

          lcl_structtype ?= cl_abap_typedescr=>describe_by_name(  <l_result_source>-table ).

          lt_fields = me->get_ddic_field_list( lcl_structtype ).
          LOOP AT lt_fields ASSIGNING <l_dfies>.
            CLEAR ls_result_field.
            MOVE-CORRESPONDING <l_dfies> TO ls_result_field.
            MOVE ls_result_field-fieldname TO ls_result_field-colhd_fieldname.

            MOVE <l_result_source>-alias TO ls_result_field-/cadaxo/alias.

            APPEND ls_result_field TO me->gt_result_ddfields.
            IF NOT <l_result_source>-alias IS INITIAL.
              CONCATENATE <l_result_source>-alias '~' ls_result_field-fieldname INTO l_fieldname.
            ELSE.
              CONCATENATE <l_result_source>-table '~' ls_result_field-fieldname INTO l_fieldname.
            ENDIF.
            CONCATENATE me->column_syntax l_fieldname INTO me->column_syntax SEPARATED BY space.
          ENDLOOP.

        ENDIF.
      ENDLOOP.

    ELSE.                                                   "FOE999

* get the first (and normaly only) row with the table information
      READ TABLE me->result_source_t INDEX 1 ASSIGNING <l_result_source>.

* create a local data, type table
      TRY.
          CREATE DATA lr_ref_data TYPE (<l_result_source>-table).

* create a structure type by reference of the table type

          lcl_structtype ?= cl_abap_typedescr=>describe_by_data_ref( lr_ref_data ).

* get the fields of the structure. use local buffer method
          lt_fields = me->get_ddic_field_list( lcl_structtype ).

* transfer the fields to result parameter
          LOOP AT lt_fields ASSIGNING <l_dfies>.

            CLEAR ls_result_field.

            MOVE-CORRESPONDING <l_dfies> TO ls_result_field.

            MOVE ls_result_field-fieldname TO ls_result_field-colhd_fieldname.

            APPEND ls_result_field TO me->gt_result_ddfields.

          ENDLOOP.
        CATCH /cadaxo/cx_sqlc_type_not_found ##NO_HANDLER.
        CATCH cx_sy_create_data_error ##NO_HANDLER.
        CATCH cx_sy_move_cast_error ##NO_HANDLER.
      ENDTRY.
    ENDIF.

* special columns, more tables, ...
  ELSE.

    CLEAR: l_skip.
    SPLIT me->column_syntax AT space INTO TABLE lt_column_split.
    LOOP AT lt_column_split ASSIGNING <l_column_split>.

      l_tabix      = sy-tabix.
      l_tabix_next = sy-tabix.

      IF l_skip GT 0.
        l_skip = l_skip - 1.
        CONTINUE.
      ENDIF.

      IF <l_column_split> EQ 'DISTINCT' OR
         <l_column_split> EQ ')'.
        CONTINUE.
      ELSEIF <l_column_split> EQ 'MAX(' OR
             <l_column_split> EQ 'MIN(' OR
             <l_column_split> EQ 'AVG(' OR
             <l_column_split> EQ 'SUM(' OR
             <l_column_split> EQ 'COUNT('.
        MOVE <l_column_split> TO l_tab_field-aggr.
        l_tabix_next = l_tabix_next + 1.
        READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
        IF sy-subrc EQ 0.
          l_skip = l_skip + 1.
          IF <l_column_split_next> EQ 'DISTINCT'.
            l_tabix_next = l_tabix_next + 1.
            READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
            IF sy-subrc EQ 0.
              l_skip = l_skip + 1.
            ENDIF.
          ENDIF.

* split the field into field, table and alias
          split_field( EXPORTING i_field = <l_column_split_next>
                       IMPORTING e_field = l_tab_field-field
                                 e_table = l_tab_field-table
                                 e_alias = l_tab_field-alias ).

          l_tabix_next = l_tabix_next + 2.
          READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
          IF sy-subrc EQ 0 AND <l_column_split_next> EQ 'AS'.
            l_skip = l_skip + 1.
            l_tabix_next = l_tabix_next + 1.
            READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
            IF sy-subrc EQ 0.
              l_skip = l_skip + 1.
              MOVE <l_column_split_next> TO l_tab_field-alias_field.
            ENDIF.
          ENDIF.
          APPEND l_tab_field TO lt_tab_field.
          CLEAR l_tab_field.

          l_skip = l_skip + 1.

        ENDIF.
      ELSE.

* split the field into field, table and alias
        split_field( EXPORTING i_field = <l_column_split>
                     IMPORTING e_field = l_tab_field-field
                               e_table = l_tab_field-table
                               e_alias = l_tab_field-alias ).

        l_tabix_next = l_tabix + 1.
        READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
        IF sy-subrc EQ 0 AND <l_column_split_next> EQ 'AS'.
          l_tabix_next = l_tabix_next + 1.
          READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
          IF sy-subrc EQ 0.
            MOVE <l_column_split_next> TO l_tab_field-alias_field.
            l_skip = 2.
          ENDIF.
        ENDIF.

        APPEND l_tab_field TO lt_tab_field.
        CLEAR l_tab_field.

      ENDIF.


    ENDLOOP.

    FIELD-SYMBOLS: <l_tab_field> TYPE t_tab_field.

    LOOP AT lt_tab_field ASSIGNING <l_tab_field>.

      CLEAR l_field_dfies.

      IF <l_tab_field>-field EQ '*' OR <l_tab_field>-field EQ 'COUNT(*)'.

        lcl_elemdescr ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( '/CADAXO/SQLCAGGRCOUNT' ). "get element type

        l_field_dfies = lcl_elemdescr->get_ddic_field( ).

        MOVE-CORRESPONDING l_field_dfies TO ls_result_field.

        MOVE <l_tab_field>-alias TO ls_result_field-/cadaxo/alias.
        MOVE <l_tab_field>-alias_field TO ls_result_field-/cadaxo/alias_field.

        MOVE 'COUNT(   * )' TO   ls_result_field-colhd_fieldname.
        MOVE 'Count( * )' TO : ls_result_field-scrtext_l,
                               ls_result_field-scrtext_m,
                               ls_result_field-scrtext_s,
                               ls_result_field-reptext,
                               ls_result_field-fieldtext.



        APPEND ls_result_field TO me->gt_result_ddfields.

      ELSE.

        TRY.
            lcl_structtype ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( <l_tab_field>-table ). "get table type

            lt_fields = me->get_ddic_field_list( lcl_structtype ).            "get fields (dfies)

            READ TABLE lt_fields WITH KEY fieldname = <l_tab_field>-field ASSIGNING <l_dfies>.
            IF sy-subrc EQ 0.

              MOVE-CORRESPONDING <l_dfies> TO ls_result_field.

* change the column header texts
              IF NOT <l_tab_field>-aggr IS INITIAL.

                MOVE <l_tab_field>-aggr TO ls_result_field-aggr.

                CASE <l_tab_field>-aggr(3).
                  WHEN 'MAX'.
                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'MAX' CHANGING c_sqlcdfies = ls_result_field ).
                  WHEN 'MIN'.
                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'MIN' CHANGING c_sqlcdfies = ls_result_field ).
                  WHEN 'AVG'.
                    CLEAR ls_result_field-convexit.
                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'AVG' CHANGING c_sqlcdfies = ls_result_field ).
                  WHEN 'SUM'.
                    CLEAR  ls_result_field-convexit.
                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'SUM' CHANGING c_sqlcdfies = ls_result_field ).

                    ls_result_field-domname = ''.
                    ls_result_field-rollname = ''.

                    CASE ls_result_field-datatype.
                      WHEN 'CURR' OR 'DEC' OR 'QUAN'.
                        ls_result_field-leng     = 31.
                        ls_result_field-intlen   = 16.
                      WHEN 'INT1' OR 'INT2' OR 'INT4' OR 'INT8'.                         "$002
                        ls_result_field-datatype  = 'DEC'.
                        ls_result_field-inttype   = 'P'.
                        ls_result_field-leng      = 31.
                        ls_result_field-intlen    = 16.
                        ls_result_field-decimals  = 0.
                    ENDCASE.

                  WHEN 'COU'.
                    CLEAR ls_result_field-convexit.
                    MOVE '/CADAXO/SQLCAGGRCOUNT' TO ls_result_field-rollname.
                    lcl_elemdescr ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( '/CADAXO/SQLCAGGRCOUNT' ). "get element type
                    l_field_dfies = lcl_elemdescr->get_ddic_field( ).

                    MOVE-CORRESPONDING l_field_dfies TO ls_result_field.

                    MOVE: <l_dfies>-scrtext_m TO ls_result_field-scrtext_m,
                          <l_dfies>-scrtext_s TO ls_result_field-scrtext_s,
                          <l_dfies>-reptext   TO ls_result_field-reptext,
                          <l_dfies>-fieldtext TO ls_result_field-fieldtext.

                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'COUNT' CHANGING c_sqlcdfies = ls_result_field ).
                ENDCASE.
              ELSE.
                MOVE ls_result_field-fieldname TO ls_result_field-colhd_fieldname.
                CLEAR ls_result_field-aggr.
              ENDIF.

              MOVE <l_tab_field>-alias TO ls_result_field-/cadaxo/alias.
              MOVE <l_tab_field>-alias_field TO ls_result_field-/cadaxo/alias_field.

* append field attributes to return table
              APPEND ls_result_field TO me->gt_result_ddfields.

            ENDIF.
          CATCH /cadaxo/cx_sqlc_type_not_found ##NO_HANDLER.
          CATCH cx_sy_create_data_error ##NO_HANDLER.
          CATCH cx_sy_move_cast_error ##NO_HANDLER.

        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDIF.

ENDMETHOD.


METHOD parse_sql_ii_2.

****************************************************************************************************
* Description             : PARSE SQL II                                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
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
* 15.01.2016 | Ana Lekic            | New logic for identify the tables and       | $001           *
*            |                      | alias                                       |                *
*------------+----------------------+---------------------------------------------+----------------*
* 16.09.2016 | Johann Foessleitner  | Tables with / Namespace                     | $002           *
*------------+----------------------+---------------------------------------------+----------------*
* 28.12.2016 | Domi Bigl            | INT8                                        |$003 COCKPIT-148*
****************************************************************************************************

  TYPES: BEGIN OF t_tab_field,
           table       TYPE string,
           field       TYPE string,
           alias       TYPE string,
           alias_field TYPE string,
           aggr        TYPE string,
           count(1)    TYPE c,
         END OF t_tab_field.

  DATA: l_skip          TYPE i,
        l_tabix_next    TYPE i,
        l_tab_field     TYPE t_tab_field,
        lt_tab_field    TYPE TABLE OF t_tab_field,
        l_field_dfies   TYPE dfies,
        ls_result_field TYPE /cadaxo/sqlcdfies,
        lcl_structtype  TYPE REF TO cl_abap_structdescr,
        lcl_elemdescr   TYPE REF TO cl_abap_elemdescr,
        lt_fields       TYPE ddfields,
        lt_column_split TYPE TABLE OF string,
        lr_ref_data     TYPE REF TO data,
        l_string        TYPE string,                       "FOE999
        l_lines         TYPE i.
  DATA l_open_lit       TYPE c LENGTH 1.
  DATA l_cols           TYPE string.

  FIELD-SYMBOLS: <l_source_split_next> TYPE string,
                 <l_column_split>      TYPE string,
                 <l_column_split_next> TYPE string,
                 <l_dfies>             TYPE dfies,
                 <l_result_source>     LIKE LINE OF me->result_source_t.

  CLEAR: l_skip,
         me->gt_result_ddfields,
         me->result_source_t.

  MOVE me->source_syntax TO l_string.                       "FOE999

  CONDENSE l_string.                                        "FOE999

*** $001, Lekic, 15.01.2016 BEGIN
*** new logic for finding tables and alias
  /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = l_string ).
  SPLIT l_string AT | JOIN | INTO TABLE DATA(lt_joins).

  LOOP AT lt_joins ASSIGNING FIELD-SYMBOL(<join>).
    FIND REGEX '^([[:word:]/]+)(?:\s+AS\s+([[:word:]/]+)|[[:word:]/]+|.*).*$' IN <join> SUBMATCHES DATA(l_table) DATA(l_alias). "FOE $002
    IF sy-subrc = 0.
      APPEND VALUE #( table = l_table alias = l_alias ) TO me->result_source_t.
    ENDIF.
  ENDLOOP.
*** $001, Lekic, 15.01.2016 END


  CLEAR column_words_t.
* no special columns selected, only one table (SELECT * FROM ... )
  IF me->column_syntax EQ '*' OR me->column_syntax CS '~*'.
* create a local data, type table

    DESCRIBE TABLE me->result_source_t LINES l_lines.       "FOE999
    IF l_lines GT 1.                                        "FOE999
      LOOP AT me->result_source_t
           ASSIGNING <l_result_source>.

        l_cols = me->column_syntax.
        /cadaxo/cl_sqlc_cockpit_assist=>replace_apostrophes_with_space( CHANGING c_string = l_cols ).
        SPLIT l_cols AT space INTO TABLE me->column_words_t.

        cl_abap_classdescr=>describe_by_name( EXPORTING  p_name         = <l_result_source>-table
                                              EXCEPTIONS type_not_found = 1
                                                         OTHERS         = 2 ).
        IF sy-subrc EQ 0.

          lcl_structtype ?= cl_abap_typedescr=>describe_by_name(  <l_result_source>-table ).

          lt_fields = me->get_ddic_field_list( lcl_structtype ).
          LOOP AT lt_fields ASSIGNING <l_dfies>.
            CLEAR ls_result_field.
            MOVE-CORRESPONDING <l_dfies> TO ls_result_field.
            MOVE ls_result_field-fieldname TO ls_result_field-colhd_fieldname.

            MOVE <l_result_source>-alias TO ls_result_field-/cadaxo/alias.

            APPEND ls_result_field TO me->gt_result_ddfields.
          ENDLOOP.

        ENDIF.
      ENDLOOP.

    ELSE.                                                   "FOE999
      READ TABLE me->result_source_t INDEX 1 ASSIGNING <l_result_source>.

      TRY.
          CREATE DATA lr_ref_data TYPE (<l_result_source>-table).

          lcl_structtype ?= cl_abap_typedescr=>describe_by_data_ref( lr_ref_data ).

          lt_fields = me->get_ddic_field_list( lcl_structtype ).

          LOOP AT lt_fields ASSIGNING <l_dfies>.

            CLEAR ls_result_field.

            MOVE-CORRESPONDING <l_dfies> TO ls_result_field.

            MOVE ls_result_field-fieldname TO ls_result_field-colhd_fieldname.

            APPEND ls_result_field TO me->gt_result_ddfields.

          ENDLOOP.
        CATCH /cadaxo/cx_sqlc_type_not_found ##NO_HANDLER.
        CATCH cx_sy_create_data_error ##NO_HANDLER.
        CATCH cx_sy_move_cast_error ##NO_HANDLER.
      ENDTRY.
    ENDIF.

* special columns, more tables, ...
  ELSE.

    CLEAR: l_skip.
*    SPLIT me->column_syntax AT space INTO TABLE lt_column_split. "SQLC30

    DATA l_string_check  TYPE string.
    DATA l_string_append TYPE string.
    DATA l_pos           TYPE i.
    DATA l_on_apostrophe TYPE boolean.
    DATA l_on_bracket    TYPE i.
    l_string_check =  me->column_syntax.

    CLEAR: l_string_append,
           l_on_apostrophe,
           l_on_bracket.

    DO.

      TRY.
          l_string_check = me->column_syntax+l_pos(1).
          l_pos = l_pos + 1.
        CATCH cx_sy_range_out_of_bounds.
          IF l_string_append IS NOT INITIAL.
            SHIFT l_string_append LEFT DELETING LEADING space.
            APPEND l_string_append TO lt_column_split.
          ENDIF.
          EXIT.
      ENDTRY.

      CASE l_string_check.
        WHEN '('.
          IF l_on_apostrophe = abap_false.
            l_on_bracket = l_on_bracket + 1.
          ENDIF.
        WHEN ')'.
          IF l_on_apostrophe = abap_false.
            l_on_bracket = l_on_bracket - 1.
          ENDIF.
        WHEN '´' OR ''''.
          IF l_on_apostrophe = space.
            l_on_apostrophe = abap_true.
          ELSE.
            l_on_apostrophe = abap_false.
          ENDIF.
        WHEN ','.
          IF l_on_apostrophe = abap_false AND l_on_bracket = 0.
            SHIFT l_string_append LEFT DELETING LEADING space.
            APPEND l_string_append TO lt_column_split.
            CLEAR l_string_append.
            CONTINUE.
          ENDIF.
      ENDCASE.

      l_string_append = l_string_append && l_string_check.

    ENDDO.


    LOOP AT lt_column_split ASSIGNING <l_column_split>.

      <l_column_split> = replace( val = <l_column_split> regex = ',$' with = space ).

      l_tabix_next = sy-tabix.

      IF l_skip GT 0.
        l_skip = l_skip - 1.
        CONTINUE.
      ENDIF.

      IF <l_column_split> EQ 'DISTINCT' OR
         <l_column_split> EQ ')'.
        CONTINUE.
      ELSEIF <l_column_split> EQ 'MAX(' OR
             <l_column_split> EQ 'MIN(' OR
             <l_column_split> EQ 'AVG(' OR
             <l_column_split> EQ 'SUM(' OR
             <l_column_split> EQ 'COUNT('.
        MOVE <l_column_split> TO l_tab_field-aggr.
        l_tabix_next = l_tabix_next + 1.
        READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
        IF sy-subrc EQ 0.
          l_skip = l_skip + 1.
          IF <l_column_split_next> EQ 'DISTINCT'.
            l_tabix_next = l_tabix_next + 1.
            READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
            IF sy-subrc EQ 0.
              l_skip = l_skip + 1.
            ENDIF.
          ENDIF.

* split the field into field, table and alias
          split_field( EXPORTING i_field = <l_column_split_next>
                       IMPORTING e_field = l_tab_field-field
                                 e_table = l_tab_field-table
                                 e_alias = l_tab_field-alias ).

          l_tabix_next = l_tabix_next + 2.
          READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
          IF sy-subrc EQ 0 AND <l_column_split_next> EQ 'AS'.
            l_skip = l_skip + 1.
            l_tabix_next = l_tabix_next + 1.
            READ TABLE lt_column_split INDEX l_tabix_next ASSIGNING <l_column_split_next>.
            IF sy-subrc EQ 0.
              <l_column_split_next> = replace( val = <l_column_split_next> regex = ',$' with = space ).
              l_skip = l_skip + 1.
              MOVE <l_column_split_next> TO l_tab_field-alias_field.
            ENDIF.
          ENDIF.
          APPEND l_tab_field TO lt_tab_field.
          CLEAR l_tab_field.

          l_skip = l_skip + 1.

        ENDIF.
      ELSE.


        CLEAR l_tab_field.

        me->split_field_v_2(
          EXPORTING
            i_value       = <l_column_split>
          IMPORTING
            e_table       = l_tab_field-table
            e_field       = l_tab_field-field
            e_alias       = l_tab_field-alias
            e_alias_field = l_tab_field-alias_field ).

        APPEND l_tab_field TO lt_tab_field.

      ENDIF.

    ENDLOOP.

    FIELD-SYMBOLS: <l_tab_field> TYPE t_tab_field.

    LOOP AT lt_tab_field ASSIGNING <l_tab_field>.

      CLEAR l_field_dfies.

      IF <l_tab_field>-field EQ '*' OR <l_tab_field>-field EQ 'COUNT(*)' OR <l_tab_field>-field EQ 'COUNT( * )'.

        lcl_elemdescr ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( '/CADAXO/SQLCAGGRCOUNT' ). "get element type

        l_field_dfies = lcl_elemdescr->get_ddic_field( ).

        MOVE-CORRESPONDING l_field_dfies TO ls_result_field.

        MOVE <l_tab_field>-alias TO ls_result_field-/cadaxo/alias.
        MOVE <l_tab_field>-alias_field TO ls_result_field-/cadaxo/alias_field.

        MOVE 'COUNT(   * )' TO   ls_result_field-colhd_fieldname.
        MOVE 'Count( * )' TO : ls_result_field-scrtext_l,
                               ls_result_field-scrtext_m,
                               ls_result_field-scrtext_s,
                               ls_result_field-reptext,
                               ls_result_field-fieldtext.

        APPEND ls_result_field TO me->gt_result_ddfields.

      ELSE.

        TRY.
            lcl_structtype ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( <l_tab_field>-table ). "get table type

            lt_fields = me->get_ddic_field_list( lcl_structtype ).            "get fields (dfies)

            READ TABLE lt_fields WITH KEY fieldname = <l_tab_field>-field ASSIGNING <l_dfies>.
            IF sy-subrc EQ 0.

              MOVE-CORRESPONDING <l_dfies> TO ls_result_field.

* change the column header texts
              IF NOT <l_tab_field>-aggr IS INITIAL.

                MOVE <l_tab_field>-aggr TO ls_result_field-aggr.

                CASE <l_tab_field>-aggr(3).
                  WHEN 'MAX'.
                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'MAX' CHANGING c_sqlcdfies = ls_result_field ).
                  WHEN 'MIN'.
                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'MIN' CHANGING c_sqlcdfies = ls_result_field ).
                  WHEN 'AVG'.
                    CLEAR ls_result_field-convexit.
                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'AVG' CHANGING c_sqlcdfies = ls_result_field ).
                  WHEN 'SUM'.
                    CLEAR  ls_result_field-convexit.
                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'SUM' CHANGING c_sqlcdfies = ls_result_field ).

                    ls_result_field-domname = ''.
                    ls_result_field-rollname = ''.

                    CASE ls_result_field-datatype.
                      WHEN 'CURR' OR 'DEC' OR 'QUAN'.
                        ls_result_field-leng     = 31.
                        ls_result_field-intlen   = 16.
                      WHEN 'INT1' OR 'INT2' OR 'INT4' OR 'INT8'.                         "$003
                        ls_result_field-datatype  = 'DEC'.
                        ls_result_field-inttype   = 'P'.
                        ls_result_field-leng      = 31.
                        ls_result_field-intlen    = 16.
                        ls_result_field-decimals  = 0.
                    ENDCASE.

                  WHEN 'COU'.
                    CLEAR ls_result_field-convexit.
                    MOVE '/CADAXO/SQLCAGGRCOUNT' TO ls_result_field-rollname.
                    lcl_elemdescr ?= /cadaxo/cl_sqlc_cockpit_parse=>get_abap_typedescr( '/CADAXO/SQLCAGGRCOUNT' ). "get element type
                    l_field_dfies = lcl_elemdescr->get_ddic_field( ).

                    MOVE-CORRESPONDING l_field_dfies TO ls_result_field.

                    MOVE: <l_dfies>-scrtext_m TO ls_result_field-scrtext_m,
                          <l_dfies>-scrtext_s TO ls_result_field-scrtext_s,
                          <l_dfies>-reptext   TO ls_result_field-reptext,
                          <l_dfies>-fieldtext TO ls_result_field-fieldtext.

                    /cadaxo/cl_sqlc_cockpit_parse=>concatenate_aggr_prefix( EXPORTING i_prefix = 'COUNT' CHANGING c_sqlcdfies = ls_result_field ).
                ENDCASE.
              ELSE.
                MOVE ls_result_field-fieldname TO ls_result_field-colhd_fieldname.
                CLEAR ls_result_field-aggr.
              ENDIF.

              MOVE <l_tab_field>-alias TO ls_result_field-/cadaxo/alias.
              MOVE <l_tab_field>-alias_field TO ls_result_field-/cadaxo/alias_field.

* append field attributes to return table
              APPEND ls_result_field TO me->gt_result_ddfields.

            ENDIF.

          CATCH /cadaxo/cx_sqlc_type_not_found ##NO_HANDLER.
          CATCH cx_sy_create_data_error ##NO_HANDLER.
          CATCH cx_sy_move_cast_error ##NO_HANDLER.

        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDIF.


ENDMETHOD.


METHOD parse_sql_where_columns.
****************************************************************************************************
* Description             : PARSE SQL WHERE COLUMNS                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
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
* 04.01.2012 | Fößleitner Johann    | add '=>, =<, ><'                            | CDX001-0031    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 24.05.2012 | Fößleitner Johann    | Bugfixing symbolname used in like           | "CDX130-008    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 01.06.2012 | Ana Lekic            |format value in where (for timestamps)       | CDX130-018     *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 09.05.2014 | Domi Bigl            | no decimal . for P decimals 0               | RT229          *
*------------+----------------------+---------------------------------------------+----------------*
* 10.06.2016 | Ana Lekic            | Fehler beim replace vom wert                | Cockpit-65     *
****************************************************************************************************

  DATA l_space_string       TYPE string.
  DATA l_offset             TYPE i.
  DATA l_from               TYPE i.
  DATA l_string             TYPE string.
  DATA l_match              TYPE i.
  DATA lr_abap_type         TYPE REF TO cl_abap_elemdescr.
  DATA l_where_col          LIKE LINE OF me->gt_sql_where_col_tab_t.
  DATA l_wc_nr(3)           TYPE n.
  DATA l_wildcard_operator(6).
  DATA l_wildcard_condition(6).
  DATA l_total_len          TYPE i.
  DATA lt_stringtab         TYPE stringtab.
  DATA l_symbol              TYPE /cadaxo/sqlcsymbol_name.
  DATA l_is_subsel          TYPE char1.
  DATA l_length_check        TYPE i.
  DATA l_length_check_2      TYPE i.
  DATA l_message             TYPE string.
  DATA l_from_save           TYPE i.
  DATA l_symbol_value        TYPE /cadaxo/sqlcsymbol_value.
  DATA l_spc_replaced        TYPE flag.                     "RT229
  DATA l_added               TYPE i.
  DATA lr_field              TYPE REF TO data.
  DATA l_fieldname           TYPE string.
  DATA l_strlen              TYPE i.
  DATA l_string2             TYPE string.
  DATA lt_result_source_tmp LIKE me->result_source_t.       "CDX3301
  DATA l_off_f TYPE i.
  DATA l_off_w TYPE i.
  DATA l_len TYPE i.
  DATA l_str TYPE string.
  DATA lt_source_split  TYPE TABLE OF string.
  DATA l_skip  TYPE i.
  DATA l_tabix_next     TYPE i.
  DATA ls_result_source LIKE LINE OF me->result_source_t.

  FIELD-SYMBOLS: <l_field> TYPE any.
  FIELD-SYMBOLS: <ls_string> TYPE string.
  FIELD-SYMBOLS: <l_source_split> TYPE string,
                 <l_source_split_next> TYPE string.

  CONCATENATE '' '' INTO l_space_string SEPARATED BY space.

  CLEAR: l_from,
         me->gt_sql_where_col_tab_t,
         me->where_syntax_wildcard.

* condense the string
  /cadaxo/cl_sqlc_cockpit_assist=>condense( CHANGING c_string = me->where_syntax ).

  l_total_len = strlen( me->where_syntax ).

  lt_result_source_tmp = me->result_source_t.               "CDX3301

  WHILE l_from LT l_total_len.

    FIND FIRST OCCURRENCE OF l_space_string IN SECTION OFFSET l_from OF me->where_syntax MATCH OFFSET l_match.
    IF sy-subrc EQ 0.
      l_offset = l_match - l_from.
      MOVE me->where_syntax+l_from(l_offset) TO l_string.

      l_from_save = l_from.

      l_from = l_match + 1.

      CASE l_string.
        WHEN '=' OR 'EQ' OR '<>' OR 'NE' OR '<' OR 'LT' OR '>' OR 'GT' OR '<=' OR 'LE' OR '>=' OR 'GE' OR '=>' OR '=<' OR '><'. "CDX001-0031
          CASE l_string.
            WHEN '='.
              MOVE 'EQ' TO l_where_col-operator.
            WHEN '<>'.
              MOVE 'NE' TO l_where_col-operator.
            WHEN '><'.                         "CDX001-0031
              MOVE 'NE' TO l_where_col-operator.
              REPLACE SECTION OFFSET l_from_save LENGTH l_offset OF me->where_syntax WITH '<>'.
            WHEN '<'.
              MOVE 'LT' TO l_where_col-operator.
            WHEN '>'.
              MOVE 'GT' TO l_where_col-operator.
            WHEN '<='.
              MOVE 'LE' TO l_where_col-operator.
            WHEN  '=<'.                         "CDX001-0031
              MOVE 'LE' TO l_where_col-operator.
              REPLACE SECTION OFFSET l_from_save LENGTH l_offset OF me->where_syntax WITH '<='.
            WHEN '>='.
              MOVE 'GE' TO l_where_col-operator.
            WHEN '=>'.
              MOVE 'GE' TO l_where_col-operator.
              REPLACE SECTION OFFSET l_from_save LENGTH l_offset OF me->where_syntax WITH '>='.
            WHEN OTHERS.
              MOVE l_string TO l_where_col-operator.
          ENDCASE.

          /cadaxo/cl_sqlc_cockpit_assist=>get_where_value_match_offset(
            EXPORTING
              i_from         = l_from
              i_total_length = l_total_len
            CHANGING
              c_where_syntax = me->where_syntax
              c_offset       = l_match ).

          l_offset = l_match - l_from.

          IF sy-subrc EQ 0 AND l_offset NE 0.
            MOVE me->where_syntax+l_from(l_offset) TO l_where_col-value.
          ELSE.
            MOVE me->where_syntax+l_from TO l_where_col-value.
          ENDIF.

* replace SPACE with ''
          CLEAR l_spc_replaced.
          IF l_where_col-value EQ 'SPACE'.
            MOVE '''''' TO l_where_col-value.
            l_spc_replaced = abap_true.
          ENDIF.

*         bring the value in right format CDX130-018
          IF NOT lr_abap_type IS INITIAL.
            CLEAR l_added.                                  "RT229
            format_value(  EXPORTING i_abap_type = lr_abap_type           "CDX130-018 Begin
                           IMPORTING e_added     = l_added  "RT229
                           CHANGING  c_where_col = l_where_col ).
          ENDIF.

          IF l_where_col-type_kind CA 'bsI' AND l_where_col-value CO '-0123456789 '.
            IF ( l_where_col-type_kind = 'b' AND l_where_col-value > 255 ) OR
               ( l_where_col-type_kind = 's' AND ( l_where_col-value > 32767 OR l_where_col-value < -32767 ) ) OR
               ( l_where_col-type_kind = 'I' AND ( l_where_col-value > 2147483647 OR l_where_col-value < -2147483648 ) ).
              RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value
                EXPORTING
                  value = l_where_col-value
                  field = CONV #( l_where_col-fieldname ).
            ENDIF.
          ENDIF.

* check value of "P" fields
          IF l_where_col-type_kind = 'P' AND l_where_col-value CO '0123456789.,'''' '.
            CREATE DATA lr_field TYPE HANDLE lr_abap_type.
            ASSIGN lr_field->* TO <l_field>.

            l_strlen = strlen( l_where_col-value ) - 1.

            MOVE l_where_col-value TO l_string2.

            IF l_string2+l_strlen(1) EQ `'`.
              MOVE l_string2(l_strlen) TO l_string2.
            ENDIF.

            IF l_string2(1) EQ `'`.
              l_strlen = l_strlen - 1.
              MOVE l_string2+1 TO l_string2.
            ENDIF.
            TRY.
                MOVE l_string2 TO <l_field>.
              CATCH cx_sy_conversion_no_number.
                MOVE l_where_col-fieldname TO l_fieldname.
                RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value
                  EXPORTING
                    value = l_where_col-value
                    field = l_fieldname.
            ENDTRY.
          ENDIF.

          IF l_offset NE 0.
            REPLACE ALL OCCURRENCES OF me->where_syntax+l_from(l_offset)
              IN SECTION OFFSET l_from LENGTH l_offset OF me->where_syntax WITH l_where_col-value. "cockpit-65
          ELSE.
            REPLACE ALL OCCURRENCES OF me->where_syntax+l_from
              IN SECTION OFFSET l_from LENGTH l_offset OF me->where_syntax WITH l_where_col-value. "cockpit-65
          ENDIF.                                                          "CDX130-018 End

          IF l_spc_replaced = abap_true.
            l_offset = 2.
            l_match = l_match - 3.
            l_total_len = strlen( me->where_syntax ).
          ENDIF.

          IF l_added > 0.                                   "RT229
            l_offset = l_offset + l_added.                  "RT229
            l_match = l_match + l_added.                    "RT229
            l_total_len = strlen( me->where_syntax ).       "RT229
          ENDIF.                                            "RT229

*          /cadaxo/cl_sqlc_cockpit_assist=>replace_symbols_with_values(
*            EXPORTING
*              i_where_column = l_where_col
*              i_from         = l_from
*              i_length       = l_offset
*            CHANGING
*              c_where_syntax = me->where_syntax
*              c_offset       = l_match
*              c_total        = l_total_len ).

* wildcard
          l_wc_nr = l_wc_nr + 1.

          CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
          CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

          MOVE: l_wildcard_operator  TO l_where_col-wildcard_operator,
                l_wildcard_condition TO l_where_col-wildcard_condition.

          CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

          APPEND l_where_col TO me->gt_sql_where_col_tab_t.
          CLEAR l_where_col.

          IF l_match GT l_from.
            l_from = l_match + 1.
          ENDIF.

        WHEN 'NOT'. "BETWEEN, LIKE, IN, IS NULL'
*          CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
          IF l_where_col-fieldname EQ space.
            MOVE 'X' TO l_where_col-not.
          ELSE.
            MOVE 'NOT' TO l_where_col-operator_pre.
          ENDIF.
        WHEN 'BETWEEN'. "BETWEEN a AND b"

          MOVE l_string TO l_where_col-operator.

* split the string at space
          lt_stringtab = /cadaxo/cl_sqlc_cockpit_assist=>split( i_sql_string = me->where_syntax
                                                                i_position_from = l_from ).

          LOOP AT lt_stringtab FROM 1 TO 3 ASSIGNING <ls_string>.
            CONCATENATE l_where_col-value <ls_string> INTO l_where_col-value SEPARATED BY space.
          ENDLOOP.

          SHIFT l_where_col-value LEFT DELETING LEADING l_space_string.

          l_match = l_from + strlen( l_where_col-value ).

** repalce the symbols with the values
*          /cadaxo/cl_sqlc_cockpit_assist=>replace_symbols_with_values(
*            EXPORTING
*              i_where_column = l_where_col
*              i_from         = l_from
*            CHANGING
*              c_where_syntax = me->where_syntax
*              c_offset       = l_match
*              c_total        = l_total_len ).

          l_wc_nr = l_wc_nr + 1.

          CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
          CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

          MOVE: l_wildcard_operator  TO l_where_col-wildcard_operator,
                l_wildcard_condition TO l_where_col-wildcard_condition.

          CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

          APPEND l_where_col TO me->gt_sql_where_col_tab_t.
          CLEAR l_where_col.

          IF l_match GT l_from.
            l_from = l_match + 1.
          ENDIF.

        WHEN 'LIKE'.

          MOVE l_string TO l_where_col-operator.

          /cadaxo/cl_sqlc_cockpit_assist=>get_where_value_match_offset(
            EXPORTING
              i_from         = l_from
              i_total_length = l_total_len
            CHANGING
              c_where_syntax = me->where_syntax
              c_offset       = l_match ).

          l_offset = l_match - l_from.

          MOVE me->where_syntax+l_from(l_offset) TO l_where_col-value.

* get symbol value
          FIND REGEX '&(\w|/)+&' IN l_where_col-value.      "CDX130-008
          IF sy-subrc EQ 0.                                 "CDX130-008
            l_symbol      = l_where_col-value.              "CDX130-008
            /cadaxo/cl_sqlc_cockpit_assist=>get_global_symbol_value("CDX130-008
                EXPORTING                                   "CDX130-008
                   i_symbol       = l_symbol                "CDX130-008
                   i_field_type   = l_where_col-type_kind   "CDX130-008
                IMPORTING                                   "CDX130-008
                   e_symbol_value = l_symbol_value ).       "CDX130-008
            l_length_check = strlen( l_symbol_value ).      "CDX130-008

            IF l_symbol_value CP '''*'.                     "CDX130-008
              l_length_check = l_length_check - 1.          "CDX130-008
            ENDIF.                                          "CDX130-008

            IF l_symbol_value CP '*'''.                     "CDX130-008
              l_length_check = l_length_check - 1.          "CDX130-008
            ENDIF.                                          "CDX130-008

          ELSE.
            l_length_check = l_offset.

            IF l_where_col-value CP '''*'.
              l_length_check = l_length_check - 1.
            ENDIF.

            IF l_where_col-value CP '*'''.
              l_length_check = l_length_check - 1.
            ENDIF.

          ENDIF.



          l_length_check_2 = l_where_col-fieldlength * 2.

          IF l_length_check GT l_length_check_2.
            MESSAGE e071(/cadaxo/sqlc) WITH l_where_col-tablefield l_length_check_2 INTO l_message.
            RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
              EXPORTING
                message = l_message.
          ENDIF.

* wildcard
          l_wc_nr = l_wc_nr + 1.

*          /cadaxo/cl_sqlc_cockpit_assist=>replace_symbols_with_values(
*            EXPORTING
*              i_where_column = l_where_col
*              i_from         = l_from
*              i_length       = l_offset
*            CHANGING
*              c_where_syntax = me->where_syntax
*              c_offset       = l_match
*              c_total        = l_total_len ).

          CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
          CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

          MOVE: l_wildcard_operator  TO l_where_col-wildcard_operator,
                l_wildcard_condition TO l_where_col-wildcard_condition.

          CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

          APPEND l_where_col TO me->gt_sql_where_col_tab_t.
          CLEAR l_where_col.

          IF l_match GT l_from.
            l_from = l_match + 1.
          ENDIF.

        WHEN 'IN' OR 'EXISTS'.   "(x, y, ... )
          l_is_subsel = abap_false.
          FIND 'SELECT' IN SECTION OFFSET l_from OF me->where_syntax.
          IF sy-subrc = 0.
            l_is_subsel = abap_true.
          ENDIF.

          IF l_is_subsel = abap_true.

            IF l_where_col-operator_pre EQ 'NOT' OR l_where_col-not EQ 'X'.
              CONCATENATE me->where_syntax_wildcard 'NOT' l_string INTO me->where_syntax_wildcard SEPARATED BY space.
            ELSE.
              CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
            ENDIF.

********** CDX3301 Begin


****            CLEAR l_where_col. "DB
*         find in subselect the tables
            FIND 'FROM' IN SECTION OFFSET l_from OF me->where_syntax MATCH OFFSET l_off_f MATCH LENGTH l_len.
            IF sy-subrc = 0.
              l_off_f = l_off_f + l_len.
              FIND 'WHERE' IN SECTION OFFSET l_from OF me->where_syntax MATCH OFFSET l_off_w MATCH LENGTH l_len.
              IF sy-subrc = 0.
                l_off_w = l_off_w - l_off_f.

                MOVE me->where_syntax+l_off_f(l_off_w) TO l_str.
                CONDENSE l_str.
                SPLIT l_str AT space INTO TABLE lt_source_split.
                LOOP AT lt_source_split ASSIGNING <l_source_split>.
                  IF l_skip GT 0.
                    l_skip = l_skip - 1.
                    CONTINUE.
                  ENDIF.
                  IF <l_source_split> EQ 'INNER' OR
                     <l_source_split> EQ 'JOIN' OR
                     <l_source_split> EQ 'LEFT' OR
                     <l_source_split> EQ 'OUTER'.
                    CONTINUE.
                  ELSEIF <l_source_split> EQ 'ON' OR
                         <l_source_split> EQ 'AND'.
                    l_skip = 3.
                    CONTINUE.
                  ELSE.
                    MOVE <l_source_split> TO ls_result_source-table.
****                    MOVE <l_source_split> TO l_where_col-tablename."DB
                    l_tabix_next = sy-tabix + 1.
                    READ TABLE lt_source_split INDEX l_tabix_next ASSIGNING <l_source_split_next>.
                    IF sy-subrc EQ 0 AND <l_source_split_next> EQ 'AS'.
                      l_tabix_next = l_tabix_next + 1.
                      READ TABLE lt_source_split INDEX l_tabix_next ASSIGNING <l_source_split_next>.
                      IF sy-subrc EQ 0.
                        MOVE <l_source_split_next> TO ls_result_source-alias.
                        APPEND ls_result_source TO me->result_source_t.
                        CLEAR ls_result_source.
                        l_skip = 2.
                      ENDIF.
                    ELSE.
                      IF NOT ls_result_source IS INITIAL.
                        APPEND ls_result_source TO me->result_source_t.
                        CLEAR ls_result_source.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDLOOP.

                DATA l_offs TYPE i.
                l_offs = l_off_w + l_off_f - l_from + l_len.
                CONCATENATE me->where_syntax_wildcard me->where_syntax+l_from(l_offs) INTO me->where_syntax_wildcard SEPARATED BY space.

              ELSE. "no where condition

              ENDIF.
            ENDIF.
********** CDX3301 End
*         begin of insert-429
          ELSEIF l_string = 'IN'.
            l_where_col-operator = 'IN'.

          /cadaxo/cl_sqlc_cockpit_assist=>get_where_value_match_offset(
            EXPORTING
              i_from         = l_from
              i_total_length = l_total_len
            CHANGING
              c_where_syntax = me->where_syntax
              c_offset       = l_match ).

            l_offset = l_match - l_from.

            l_where_col-value = me->where_syntax+l_from(l_offset).

            l_wc_nr = l_wc_nr + 1.
            CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
            CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

            MOVE: l_wildcard_operator  TO l_where_col-wildcard_operator,
                  l_wildcard_condition TO l_where_col-wildcard_condition.
            CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

            APPEND l_where_col TO me->gt_sql_where_col_tab_t.
            CLEAR l_where_col.

          IF l_match GT l_from.
            l_from = l_match + 1.
          ENDIF.
            CONTINUE.
*         end   of insert-429

          ENDIF.

          MOVE l_string TO l_where_col-operator.

          DATA: l_do_times       TYPE i,
                l_open(1),
                l_open_string(1),
                l_open_symbol(1),
                l_from_symbol    TYPE i,
                l_to_symbol      TYPE i.

          CLEAR l_open.
          CLEAR l_open_string.
          CLEAR l_open_symbol.
          CLEAR l_from_symbol.
          CLEAR l_to_symbol.

          l_do_times = l_total_len - l_from.

          l_offset = l_from.



          DO l_do_times TIMES.

            CASE me->where_syntax+l_offset(1).
              WHEN '('.
                IF l_open_string IS INITIAL AND l_open_symbol IS INITIAL.
                  TRANSLATE l_open USING ' XX '.
                  l_offset = l_offset + 1.
                  CONTINUE.
                ENDIF.
              WHEN ')'.
                IF l_open_string IS INITIAL AND l_open_symbol IS INITIAL AND NOT l_open IS INITIAL.
                  TRANSLATE l_open USING ' XX '.
                  EXIT.
                ENDIF.
              WHEN ''''.
                TRANSLATE l_open_string USING ' XX '.
                l_offset = l_offset + 1.
                CONTINUE.
              WHEN '&'.
                IF l_open_string IS INITIAL.
                  IF l_open_symbol EQ 'X'.
                    l_to_symbol = l_offset - l_from_symbol + 1.
                    MOVE me->where_syntax+l_from_symbol(l_to_symbol) TO l_symbol.

*                    /cadaxo/cl_sqlc_cockpit_assist=>replace_one_symbol_with_value(
*                      EXPORTING
*                        i_where_column = l_where_col
*                        i_symbol_name  = l_symbol
*                        i_from         = l_from_symbol
*                        i_length       = l_to_symbol
*                      CHANGING
*                        c_where_syntax = me->where_syntax
*                        c_offset       = l_offset
*                        c_total        = l_total_len ).

                  ELSE.
                    l_from_symbol = l_offset.
                  ENDIF.

                  TRANSLATE l_open_symbol USING ' XX '.
                  l_offset = l_offset + 1.
                  CONTINUE.
                ENDIF.
            ENDCASE.

            l_offset = l_offset + 1.

          ENDDO.

          IF l_open IS INITIAL AND l_open_string IS INITIAL AND l_open_symbol IS INITIAL AND l_is_subsel = abap_false.
            l_offset = l_offset - l_from + 1.

            TRY.
                MOVE me->where_syntax+l_from(l_offset) TO l_where_col-value.
              CATCH cx_sy_range_out_of_bounds.
                MOVE me->where_syntax+l_from TO l_where_col-value.
            ENDTRY.

            l_wc_nr = l_wc_nr + 1.

            CONCATENATE '@O' l_wc_nr '@' INTO l_wildcard_operator.
            CONCATENATE '@C' l_wc_nr '@' INTO l_wildcard_condition.

            MOVE: l_wildcard_operator  TO l_where_col-wildcard_operator,
                  l_wildcard_condition TO l_where_col-wildcard_condition.

            CONCATENATE me->where_syntax_wildcard l_wildcard_operator l_wildcard_condition INTO me->where_syntax_wildcard SEPARATED BY space.

            APPEND l_where_col TO me->gt_sql_where_col_tab_t.
            CLEAR l_where_col.

            l_from = l_from + l_offset.
          ENDIF.
          IF l_off_w > 0 AND l_off_f > 0.
            l_off_w = l_off_w + l_len + 1.                  "CDX3301
            l_from = l_off_w + l_off_f.                     "CDX3301
          ENDIF.
          CLEAR: l_off_f, l_off_w, l_str, lt_source_split, ls_result_source.
        WHEN 'IS'.   "IS [NOT] NULL
          CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
        WHEN 'AND'.  "AND
          CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
          MOVE 'A' TO l_where_col-andor.
        WHEN 'OR'.   "OR
          CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
          MOVE 'O' TO l_where_col-andor.
        WHEN ')'.                                           "CDX3301
          CLEAR l_is_subsel.
          CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.
*          l_from = l_from + 2.
        WHEN OTHERS. "Field
* split field into field, table and alias
          split_field( EXPORTING i_field  = l_string
                       IMPORTING e_field  = l_where_col-fieldname
                                 e_table  = l_where_col-tablename
                                 e_alias  = l_where_col-aliasname
                                 e_tabfld = l_where_col-tablefield ).

          CONCATENATE me->where_syntax_wildcard l_string INTO me->where_syntax_wildcard SEPARATED BY space.

* get type of the tablefield
          TRY.
              lr_abap_type ?= me->get_abap_typedescr( i_name = l_where_col-tablefield ).
              l_where_col-type_kind = lr_abap_type->type_kind.
              l_where_col-fieldlength = lr_abap_type->output_length.

            CATCH /cadaxo/cx_sqlc_type_not_found.
          ENDTRY.

      ENDCASE.
    ELSE.
      IF l_total_len > l_from AND me->where_syntax+l_from IS NOT INITIAL AND me->where_syntax+l_from CO ' )'.            "CDX001-0028
        CONCATENATE me->where_syntax_wildcard me->where_syntax+l_from INTO me->where_syntax_wildcard SEPARATED BY space. "CDX001-0028
      ENDIF.                                                                                                             "CDX001-0028
      EXIT.
    ENDIF.

  ENDWHILE.

  CONDENSE me->where_syntax_wildcard.

  IF lt_result_source_tmp IS NOT INITIAL.
*  IF l_is_subsel = abap_true AND lt_result_source_tmp IS NOT INITIAL.
    me->result_source_t = lt_result_source_tmp.
  ENDIF.

ENDMETHOD.


METHOD serialize.
  FREE result_table.
  FREE result_structure.
ENDMETHOD.


METHOD split_field.
****************************************************************************************************
* Description             : Split Field into field, table and alias                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations : This Method splits a field into field, talbe and alias                 *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 | Correction Nr. *
*------------+----------------------+---------------------------------------------+----------------*
* 03.08.2010 | Fößleitner Johann    | Try to find the right table, in case of     | CDX001-0001    *
*            |                      | join select without alias                   |                *
*------------+----------------------+---------------------------------------------+----------------*
* 29.08.2010 | Bigl Dominik         | Check, if the table name is used instead    | CDX001-0009    *
*            |                      | of the alias name                           |                *
****************************************************************************************************

  DATA: l_lines TYPE i.                                     "CDX001-0001

  FIELD-SYMBOLS: <l_sql_source_line> LIKE LINE OF me->result_source_t.

  IF i_field CA '~'.         "alias~field
    SPLIT i_field AT '~' INTO e_alias e_field.
    READ TABLE me->result_source_t WITH KEY alias = e_alias ASSIGNING <l_sql_source_line>.
    IF sy-subrc <> 0.                                                                        "CDX001-0009
      READ TABLE me->result_source_t WITH KEY table = e_alias ASSIGNING <l_sql_source_line>. "CDX001-0009
    ENDIF.                                                                                   "CDX001-0009
    IF sy-subrc EQ 0.
      MOVE <l_sql_source_line>-table TO e_table.
    ENDIF.
  ELSEIF i_field CA '-'.     "table-field
    SPLIT i_field AT '-' INTO e_table e_field.
  ELSE.
    MOVE i_field TO e_field. "only field

    DESCRIBE TABLE me->result_source_t LINES l_lines.                                  "CDX001-0001

* only one table, then take the first one                                              "CDX001-0001
    IF l_lines EQ 1.                                                                   "CDX001-0001
      READ TABLE me->result_source_t INDEX 1 ASSIGNING <l_sql_source_line>.
      IF sy-subrc EQ 0.
        MOVE <l_sql_source_line>-table TO e_table.
      ENDIF.
    ELSE.                                                                              "CDX001-0001

* in other cases, try to find the right table                                          "CDX001-0001
      LOOP AT me->result_source_t ASSIGNING <l_sql_source_line>.                       "CDX001-0001
        SELECT SINGLE COUNT( * ) FROM dd03l WHERE tabname EQ <l_sql_source_line>-table "CDX001-0001
                                              AND fieldname EQ e_field                 "CDX001-0001
                                              AND as4local EQ 'A'. "#EC CI_SROFC_NESTED "#EC CI_SEL_NESTED "CDX001-0001
        IF sy-subrc EQ 0.                                                              "CDX001-0001
          IF e_table EQ space.                                                         "CDX001-0001
            MOVE <l_sql_source_line>-table TO e_table.                                 "CDX001-0001
          ENDIF.                                                                       "CDX001-0001
        ENDIF.                                                                         "CDX001-0001
      ENDLOOP.                                                                         "CDX001-0001
    ENDIF.                                                                             "CDX001-0001
  ENDIF.

* concatenate table and field into output field, separated by '-'                      "CDX001-0001
  CONCATENATE e_table '-' e_field INTO e_tabfld.

ENDMETHOD.


method SPLIT_FIELD_V_2.

  DATA l_field TYPE string.

  FIELD-SYMBOLS: <l_sql_source_line> LIKE LINE OF me->result_source_t.

  l_field = i_value.

* get alias
  FIND REGEX '^(.+) AS ([a-zA-Z0-9_]+)[ ,]*$' IN i_value SUBMATCHES l_field e_alias_field.

* get field
  FIND REGEX '^([a-zA-Z0-9_]+)~([a-zA-Z0-9_]+)$' IN l_field SUBMATCHES e_alias e_field.
  IF sy-subrc <> 0.
    FIND REGEX '^([a-zA-Z0-9_]+)[ ,]*$' IN l_field SUBMATCHES e_field.
  ENDIF.

  IF e_alias IS NOT INITIAL.
    READ TABLE me->result_source_t WITH KEY alias = e_alias ASSIGNING <l_sql_source_line>.
    IF sy-subrc = 0.
      e_table = <l_sql_source_line>-table.
    ELSE.
      READ TABLE me->result_source_t WITH KEY table = e_alias ASSIGNING <l_sql_source_line>.
      IF sy-subrc = 0.
        e_table = <l_sql_source_line>-table.
      ENDIF.
    ENDIF.
  ELSEIF e_field IS NOT INITIAL AND lines( me->result_source_t ) = 1.
    READ TABLE me->result_source_t INDEX 1 ASSIGNING <l_sql_source_line>.
    IF sy-subrc = 0.
      e_table = <l_sql_source_line>-table.
    ENDIF.
  ENDIF.

  IF e_field IS INITIAL.
    e_field = l_field.
  ENDIF.

endmethod.


  METHOD subpool_result.
****************************************************************************************************
* Description             : Subpool Result                                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 31.05.2016 | Ana Lekic            | error message from subpool                  | COCKPIT-61     *
*            |                      |                                             | $001           *
*------------+----------------------+---------------------------------------------+----------------*
* 05.10.2016 | Domi Bigl            | String,XString,DecFloat16/34                |$002 COCKPIT-117*
*------------+----------------------+---------------------------------------------+----------------*
* 28.12.2016 | Domi Bigl            | INT8                                        |$003 COCKPIT-148*
*------------+----------------------+---------------------------------------------+----------------*
* 19.02.2017 | Domi Bigl            | Runtime errors                              | COCKPIT-103    *
*------------+----------------------+---------------------------------------------+----------------*
* 20.07.2017 | Johann Fößleitner    | Bugfixing                                   | COCKPIT-236    *
*------------+----------------------+---------------------------------------------+----------------*
* 01.05.2020 | Johann Fößleitner    | Bugfixing                                   | COCKPIT-437    *
****************************************************************************************************

    DATA l_data                     TYPE xstring.
    DATA lv_sys_error_message       TYPE char128.
    DATA lv_error_message           TYPE string.
    DATA lwa_result                 TYPE gts_subpool_result.
    DATA l_sql_abap_componentdescr  TYPE abap_componentdescr.
    DATA lt_result_ddfields         TYPE /cadaxo/sqlcdfies_t.
    DATA lt_dflies                  TYPE /cadaxo/sqlcdfies_t.
    DATA l_decimals                 TYPE i.
    DATA l_intlen                   TYPE i.

    FIELD-SYMBOLS: <lt_result_table> TYPE STANDARD TABLE,
                   <ls_ddfields>     TYPE /cadaxo/sqlcdfies,
                   <ls_ddfieldsg>    TYPE /cadaxo/sqlcdfies.

    TRY.
        lwa_result-task = p_task.
        CLEAR: lv_error_message.
        CLEAR: lv_sys_error_message.

        lt_result_ddfields = me->gt_result_ddfields.

        RECEIVE RESULTS FROM FUNCTION '/CADAXO/SQLCSUBROUTINEPOOL'
           IMPORTING
             e_error_message       = lv_error_message                 "COCKPIT-103
             e_runtime             = g_tmp_result_details-runtime
             e_result_lines        = g_tmp_result_details-lines
             et_dfies              = me->gt_result_ddfields          "-COCKPIT-372
*             et_dfies              = lt_dflies                        "+COCKPIT-372
             et_dfies_all          = me->gt_result_ddfields_all
          CHANGING
            ic_data                = l_data
            EXCEPTIONS
              system_failure        = 1 MESSAGE lv_sys_error_message "$001 "COCKPIT-103
              communication_failure = 2 MESSAGE lv_sys_error_message "$001 "COCKPIT-103
              resource_failure      = 3
              OTHERS                = 4.
        IF sy-subrc <> 0 OR lv_error_message IS NOT INITIAL. "$001                "COCKPIT-103

          IF lv_sys_error_message IS NOT INITIAL.                                 "COCKPIT-103
            lv_error_message = lv_sys_error_message.                              "COCKPIT-103
          ENDIF.                                                                  "COCKPIT-103

          CLEAR: me->g_main_ref->gt_errors.

          g_error_message = me->check_runtime_error( lv_error_message ). "COCKPIT-103

          EXIT.

        ELSE. "$001

          IF me->gt_result_ddfields IS INITIAL                                            "COCKPIT-236
             AND me->g_select_version = /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_1 "COCKPIT-236
            AND lt_result_ddfields IS NOT INITIAL.                                        "COCKPIT-236
            me->gt_result_ddfields = lt_result_ddfields.                                  "COCKPIT-236
          ENDIF.                                                                          "COCKPIT-236

*          IF me->gt_result_ddfields IS INITIAL.  "+COCKPIT-372
*            me->gt_result_ddfields = lt_dflies.  "+COCKPIT-372 failsafe - in case there was some scenario where gt_result_ddfield is blank and needs to be filled from rfc '/CADAXO/SQLCSUBROUTINEPOOL'
*          ENDIF.                                 "+COCKPIT-372

          LOOP AT me->gt_result_ddfields ASSIGNING <ls_ddfields>.
            UNASSIGN <ls_ddfieldsg>.
            READ TABLE lt_result_ddfields WITH KEY /cadaxo/alias_field = <ls_ddfields>-fieldname ASSIGNING <ls_ddfieldsg>.
            IF sy-subrc = 0.
              <ls_ddfields>-/cadaxo/alias_field = <ls_ddfields>-fieldname.
            ELSE.
              LOOP AT lt_result_ddfields ASSIGNING <ls_ddfieldsg> WHERE fieldname = <ls_ddfields>-fieldname AND /cadaxo/alias_field = space.
                IF <ls_ddfieldsg>-/cadaxo/alias IS NOT INITIAL.
                  DATA(l_name) = <ls_ddfieldsg>-/cadaxo/alias && '~' && <ls_ddfieldsg>-fieldname && ','.
                  READ TABLE me->column_words_t WITH KEY table_line = l_name TRANSPORTING NO FIELDS.
                  IF sy-subrc <> 0.
                    l_name = <ls_ddfieldsg>-/cadaxo/alias && '~' && <ls_ddfieldsg>-fieldname.
                    READ TABLE me->column_words_t WITH KEY table_line = l_name TRANSPORTING NO FIELDS.
                    IF sy-subrc <> 0.
                      l_name = <ls_ddfieldsg>-/cadaxo/alias && '~*'.
                      READ TABLE me->column_words_t WITH KEY table_line = l_name TRANSPORTING NO FIELDS.
                    ENDIF.
                  ENDIF.
                  IF sy-subrc = 0.
                    EXIT. "LOOP
                  ENDIF.
                ENDIF.
              ENDLOOP.
            ENDIF.
            IF <ls_ddfieldsg> IS ASSIGNED.
              <ls_ddfields>-reffield        = <ls_ddfieldsg>-fieldname.
              <ls_ddfields>-reftable        = <ls_ddfieldsg>-tabname.
              <ls_ddfields>-keyflag         = <ls_ddfieldsg>-keyflag.
              <ls_ddfields>-/cadaxo/alias   = <ls_ddfieldsg>-/cadaxo/alias.
            ENDIF.
          ENDLOOP.

          ASSIGN me->result_table->* TO <lt_result_table>.
          IF <lt_result_table> IS NOT ASSIGNED.

            CLEAR me->result_component_t.

            LOOP AT me->gt_result_ddfields ASSIGNING FIELD-SYMBOL(<l_fields>).

              IF <l_fields>-stru_name NE space.

                CLEAR l_sql_abap_componentdescr.
                l_sql_abap_componentdescr-name = <l_fields>-fieldname.
                l_sql_abap_componentdescr-as_include = <l_fields>-as_include.
                l_sql_abap_componentdescr-type ?= cl_abap_structdescr=>describe_by_name( <l_fields>-stru_name ).
                APPEND l_sql_abap_componentdescr TO me->result_component_t.

                CAST cl_abap_structdescr( l_sql_abap_componentdescr-type )->get_components( ).
              ELSE.

                CLEAR l_sql_abap_componentdescr.

                l_sql_abap_componentdescr-name = <l_fields>-fieldname.

                l_decimals = <l_fields>-decimals.
                l_intlen   = <l_fields>-intlen.

                CASE <l_fields>-inttype.
                  WHEN 'P'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_p( p_length = l_intlen p_decimals = l_decimals ).
                  WHEN 'I'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_i( ).
                  WHEN 'T'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_t( ).
                  WHEN 'D'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_d( ).
                  WHEN 'N'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_n( p_length = l_intlen ).
                  WHEN 'F'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_f( ).
                  WHEN 'X'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_x( p_length = l_intlen ).
                  WHEN 'C'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_c( p_length = l_intlen ).
                  WHEN 'b'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>describe_by_name( '/CADAXO/SQLC_REFERENCE_TYPES-INT1' ).
                  WHEN 's'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>describe_by_name( '/CADAXO/SQLC_REFERENCE_TYPES-INT2' ).
                  WHEN 'g'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_string( ).
                  WHEN 'y'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_xstring( ).
                  WHEN 'a'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_decfloat16( ).
                  WHEN 'e'.
                    l_sql_abap_componentdescr-type ?= cl_abap_elemdescr=>get_decfloat34( ).
                  WHEN '8'.
                    CALL METHOD cl_abap_elemdescr=>('GET_INT8')
                      RECEIVING
                        p_result = l_sql_abap_componentdescr-type.
                  WHEN OTHERS.
                    mr_arfc_exception = NEW /cadaxo/cx_sqlc_type_not_found( type = CONV #( <l_fields>-inttype ) ).
                ENDCASE.

                APPEND l_sql_abap_componentdescr TO me->result_component_t.

              ENDIF.
            ENDLOOP.

            me->create_result_structures( ).

            ASSIGN me->result_table->* TO <lt_result_table>.

          ENDIF.

          IMPORT data = <lt_result_table> FROM DATA BUFFER l_data.

        ENDIF.

        g_async_calls = g_async_calls - 1.

        DELETE me->gt_result_ddfields WHERE fieldname IS INITIAL
                                        AND rollname  <> '/CADAXO/SQLCAGGRCOUNT'. "COCKPIT-437

      CATCH cx_root INTO mr_arfc_exception.
    ENDTRY.
  ENDMETHOD.


METHOD update_alv_field_catalog_sl.
****************************************************************************************************
* Description             : Update ALV Field Catalog - Saved Lists                                 *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo GmbH              Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2015               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

  DATA l_component TYPE string.

  FIELD-SYMBOLS: <l_fields>       LIKE LINE OF me->gt_result_ddfields,
                 <ls_lvc_t_fcat>  TYPE lvc_s_fcat.

  LOOP AT me->gt_result_ddfields ASSIGNING <l_fields>.

    UNASSIGN <ls_lvc_t_fcat>.

    CONCATENATE <l_fields>-tabname
                <l_fields>-fieldname
                INTO l_component
                SEPARATED BY '-'.

    READ TABLE c_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = <l_fields>-map_fieldname.
    IF sy-subrc NE 0.
      READ TABLE c_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = <l_fields>-fieldname.
      IF sy-subrc NE 0.
        READ TABLE c_lvc_t_fcat ASSIGNING <ls_lvc_t_fcat> WITH KEY fieldname = l_component.
      ENDIF.
    ENDIF.

    IF <ls_lvc_t_fcat> IS ASSIGNED.

      <ls_lvc_t_fcat>-reptext   = <l_fields>-reptext.
      <ls_lvc_t_fcat>-scrtext_s = <l_fields>-scrtext_s.
      <ls_lvc_t_fcat>-scrtext_m = <l_fields>-scrtext_m.
      <ls_lvc_t_fcat>-scrtext_l = <l_fields>-scrtext_l.

      CLEAR: <ls_lvc_t_fcat>-coltext.

      IF i_user_settings-hd_fieldname EQ 'X'.
        <ls_lvc_t_fcat>-coltext     =  <l_fields>-colhd_fieldname.
        IF NOT <l_fields>-/cadaxo/alias IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
          CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-coltext   INTO <ls_lvc_t_fcat>-coltext.
        ENDIF.
      ELSE.
        IF NOT <l_fields>-/cadaxo/alias_field IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
          MOVE <l_fields>-/cadaxo/alias_field TO <ls_lvc_t_fcat>-coltext.
        ELSE.
          IF NOT <l_fields>-/cadaxo/alias IS INITIAL AND NOT i_user_settings-hd_show_alias IS INITIAL.
            IF NOT <ls_lvc_t_fcat>-scrtext_l IS INITIAL.
              CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-scrtext_l INTO <ls_lvc_t_fcat>-scrtext_l.
            ENDIF.
            IF NOT <ls_lvc_t_fcat>-scrtext_m IS INITIAL.
              CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-scrtext_m INTO <ls_lvc_t_fcat>-scrtext_m.
            ENDIF.
            IF NOT <ls_lvc_t_fcat>-scrtext_m IS INITIAL.
              CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-scrtext_s INTO <ls_lvc_t_fcat>-scrtext_s.
            ENDIF.
            IF NOT <ls_lvc_t_fcat>-reptext IS INITIAL.
              CONCATENATE <l_fields>-/cadaxo/alias '~' <ls_lvc_t_fcat>-reptext INTO <ls_lvc_t_fcat>-reptext.
            ENDIF.
          ENDIF.

          CASE 'X'.
            WHEN i_user_settings-hd_fieldtext_s.
              MOVE <ls_lvc_t_fcat>-scrtext_s TO <ls_lvc_t_fcat>-coltext.
            WHEN i_user_settings-hd_fieldtext_m.
              MOVE <ls_lvc_t_fcat>-scrtext_m TO <ls_lvc_t_fcat>-coltext.
            WHEN i_user_settings-hd_fieldtext_l.
              MOVE <ls_lvc_t_fcat>-scrtext_l TO <ls_lvc_t_fcat>-coltext.
          ENDCASE.
        ENDIF.

        IF <ls_lvc_t_fcat>-coltext IS INITIAL AND i_user_settings-hd_fieldtext_a IS INITIAL.
          <ls_lvc_t_fcat>-coltext = <l_fields>-fieldname.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDMETHOD.


METHOD update_sql_to_log.
****************************************************************************************************
* Description             : Insert sql command to log                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
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

  DATA l_sqlclog TYPE /cadaxo/sqlclog.
  DATA l_sqllog_xml TYPE /cadaxo/sqlc_sqllog.
  DATA l_xml        TYPE string.

  CLEAR: l_sqlclog.
  CLEAR: l_sqllog_xml.

  l_sqllog_xml-sql_string     = i_sql_string.
  l_sqllog_xml-result_status  = '00'.
  l_sqllog_xml-sql_mode       = i_sql_mode.
  l_sqllog_xml-result_rows    = i_result_lines.
  l_sqllog_xml-result_runtime = i_result_runtime.

  CALL TRANSFORMATION id SOURCE log = l_sqllog_xml
                         RESULT XML l_xml .
  cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                               IMPORTING gzip_out = l_sqlclog-sql_log ).

  l_sqlclog-uname     = sy-uname.
  l_sqlclog-timestamp = i_timestamp.

  UPDATE /cadaxo/sqlclog FROM l_sqlclog.            "#EC CI_IMUD_NESTED

  COMMIT WORK.

  FREE: l_sqlclog, l_xml, l_sqllog_xml.
ENDMETHOD.
ENDCLASS.
