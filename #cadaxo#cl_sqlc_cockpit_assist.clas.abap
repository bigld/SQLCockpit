class /CADAXO/CL_SQLC_COCKPIT_ASSIST definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_COCKPIT_ASSIST
*"* do not include other source files here!!!
public section.

  constants C_PARAM_VERSION type /CADAXO/SQLCPARAMETER_ID value 'CADAXO_VERSION' ##NO_TEXT.
  constants C_SOURCE_LENGTH type I value 80 ##NO_TEXT.
  class-data GR_SETTINGS type ref to IF_PRETTY_PRINTER_SETTINGS .

  class-methods FIND_SYMBOL_REGEX
    importing
      !I_WHERE_SYNTAX type /CADAXO/SQLCSELECTWHERESYNTAX
    exporting
      !E_RESULT_TAB type MATCH_RESULT_TAB .
  class-methods COMPRESS_SYMBOL_MULTIVALUE
    importing
      !I_SYMBOL_MULTIVALUE type RSELOPTION
    exporting
      value(E_DATA) type XSEQUENCE .
  class-methods GET_CDS_VIEW_OF_ASSOCIATION
    importing
      !IV_ASSOCIATION type STRING
    exporting
      !EV_ENTITY type STRING
      !EV_TYPEKIND type DDTARGETKIND .
  class-methods DECOMPRESS_SYMBOL_MULTIVALUE
    importing
      !I_SYMBOL_MULTIVALUE type /CADAXO/SQLCSYMBOL_MULTIVALUE
    exporting
      !E_SYMBOL_MULTIVALUE type RSELOPTION .
  class-methods CREATE_FRONTEND_MAIL
    importing
      !I_MAILTO type STRING
      !I_SUBJECT type ANY
      !I_BODY type STRING
    exceptions
      INTERNAL_ERROR .
  class-methods VALUE_HELP_DD_TABLE
    exporting
      !E_TABNAME type TABNAME
    exceptions
      NO_TABLE_SELECTED .
  class-methods VALUE_HELP_SY_FIELDS
    exporting
      !E_FIELDNAME type STRING
    exceptions
      NO_TABLE_SELECTED .
  class-methods BLACKLIST_CHECK_TABLE
    importing
      !I_TABLE type CHAR30
    exceptions
      TABLE_ACCESS_FORBIDDEN .
  class-methods GET_PARAMETER_VALUE
    importing
      !I_PARAMETER_ID type /CADAXO/SQLCPARAMETER_ID
    returning
      value(R_PARAMETER_VALUE) type /CADAXO/SQLCPARAMETER_VAL
    exceptions
      PARAMETER_NOT_FOUND .
  class-methods SET_PARAMETER_VALUE
    importing
      !I_PARAMETER_ID type /CADAXO/SQLCPARAMETER_ID
      value(I_PARAMETER_VALUE) type /CADAXO/SQLCPARAMETER_VAL .
  class-methods SQL_TRACE_ON
    importing
      !I_SQL_TRACE type /CADAXO/SQLCSQLTRACE default 'X'
      !I_TABLEBUFFER_TRACE type /CADAXO/SQLCTABLEBUFFERTRACE optional
    exporting
      !E_DATE_FROM type DATS
      !E_TIME_FROM type TIMS
      !E_SUCCESS type CHAR1 .
  class-methods SQL_TRACE_OFF
    importing
      !I_SQL_TRACE type /CADAXO/SQLCSQLTRACE default 'X'
      !I_TABLEBUFFER_TRACE type /CADAXO/SQLCTABLEBUFFERTRACE optional
    exporting
      !E_DATE_TO type DATS
      !E_TIME_TO type TIMS .
  class-methods GET_GLOBAL_SYMBOL_VALUE
    importing
      !I_SYMBOL type /CADAXO/SQLCSYMBOL_NAME optional
      !I_FIELD_TYPE type CHAR1 optional
    exporting
      !E_SYMBOL_VALUE type ANY
    raising
      /CADAXO/CX_SQLC_SYMB_NOT_FOUND .
  class-methods VALUE_HELP_DYN_SYMBOLS
    exporting
      !E_SYMBOL_NAME type STRING .
  class-methods VALUE_HELP_CDS_VIEWS
    exporting
      !E_CDS_VIEW type STRING .
  class-methods REPLACE_SYMBOLS_WITH_VALUES
    importing
      !I_WHERE_COLUMN type /CADAXO/SQLCWHERECOL_STR
      !I_FROM type I
      !I_LENGTH type I optional
    changing
      !C_WHERE_SYNTAX type /CADAXO/SQLCSELECTWHERESYNTAX
      !C_OFFSET type I
      !C_TOTAL type I
    raising
      /CADAXO/CX_SQLC_SYMB_NOT_FOUND .
  class-methods GET_USER_SYMBOL_VALUE
    importing
      !I_SYMBOL type /CADAXO/SQLCSYMBOL_NAME
    exporting
      !E_SYMBOL_MULTIVALUE type STRING
      !E_SYMBOL_VALUE type STRING
      !E_IS_MULTI type FLAG
    raising
      /CADAXO/CX_SQLC_SYMB_NOT_FOUND .
  class-methods CONDENSE
    changing
      !C_STRING type STRING .
  class-methods TRANSLATE_SQL_STR_UPPER_CASE
    importing
      !I_SQL_STRING type /CADAXO/SQLCSQL_STRING
    returning
      value(R_SQL_STRING) type /CADAXO/SQLCSQL_STRING .
  class-methods SPLIT
    importing
      !I_SQL_STRING type STRING
      !I_POSITION_FROM type I optional
    returning
      value(R_SQL_TABLE) type STRINGTAB .
  class-methods GET_WHERE_VALUE_MATCH_OFFSET
    importing
      !I_FROM type I
      !I_TOTAL_LENGTH type I
    changing
      !C_WHERE_SYNTAX type /CADAXO/SQLCSELECTWHERESYNTAX
      !C_OFFSET type I
    raising
      /CADAXO/CX_SQLC_INVALID_VALUE .
  class-methods CLASS_CONSTRUCTOR .
  class-methods REPLACE_ONE_SYMBOL_WITH_VALUE
    importing
      !I_WHERE_COLUMN type /CADAXO/SQLCWHERECOL_STR
      !I_SYMBOL_NAME type /CADAXO/SQLCSYMBOL_NAME
      !I_FROM type I
      !I_LENGTH type I optional
    changing
      !C_WHERE_SYNTAX type /CADAXO/SQLCSELECTWHERESYNTAX
      !C_OFFSET type I
      !C_TOTAL type I
    raising
      /CADAXO/CX_SQLC_SYMB_NOT_FOUND .
  class-methods CREATE_ALV_DATE_HEADER
    importing
      !I_TIMESTAMP_FROM type TIMESTAMP
      !I_TIMESTAMP_TO type TIMESTAMP
    returning
      value(R_GRID_TITLE) type LVC_TITLE .
  class-methods SET_ADDON_CUSTOMIZING
    importing
      value(I_ADDON) type /CADAXO/SQLCADDON_ID
      value(IT_CUSTOMIZING) type ANY TABLE .
  class-methods GET_ADDON_CUSTOMIZING
    importing
      value(I_ADDON) type /CADAXO/SQLCADDON_ID
    exporting
      value(ET_CUSTOMIZING) type ANY TABLE
      !E_RELEASE type /CADAXO/SQLCADDON_RELEASE .
  class-methods SET_ADM_CUSTOMIZING
    importing
      value(I_CUSTOMIZING) type ANY .
  class-methods GET_ADM_CUSTOMIZING
    exporting
      value(E_CUSTOMIZING) type ANY .
  class-methods CREATE_COMPONENTS_XML
    exporting
      !E_XML_COMPONENTS type STRING
      !E_SAP_COMPONENTS type STRING
      !E_SQL_COMPONENTS type STRING .
  class-methods IS_ADDON_ACTIVE
    importing
      !I_ADDON type /CADAXO/SQLCADDON_ID
    returning
      value(R_ACTIVE) type /CADAXO/SQLCACTIVE .
  class-methods EXPORT_DATA
    importing
      !I_EXPORT_TYPE type CHAR5 default 'CSV'
      !IT_FCAT type LVC_T_FCAT
      !IT_DATA type ANY TABLE .
  class-methods EXPORT_DATA_ASXML
    importing
      !IT_DATA type ANY TABLE .
  class-methods EXPORT_DATA_CSV
    importing
      !IT_FCAT type LVC_T_FCAT
      !IT_DATA type ANY TABLE .
  class-methods CONVERT_DATA_TO_CSV
    importing
      !I_CSV_ATTR type /CADAXO/SQLCEXPORTCSVATTR
      !IT_DATA type ANY TABLE
      !IT_COL_ALV type /CADAXO/SQLCEXPORTCOLALV_T
    exporting
      !ET_DATA type STANDARD TABLE .
  class-methods GET_USED_SYMBOLS_TABLE
    returning
      value(R_USED_SYMBOLS_TABLE) type /CADAXO/SQLCUSEDSYMBOLS_T .
  class-methods SET_USED_SYMBOLS_TABLE
    importing
      !I_USED_SYMBOLS_TABLE type /CADAXO/SQLCUSEDSYMBOLS_T .
  class-methods CLEAR_USED_SYMBOLS_TABLE .
  class-methods MAP_DDFIELDS_DESCR_TO_FCAT
    importing
      !IS_DFIES type /CADAXO/SQLCDFIES
      !IS_USER_SETTINGS type /CADAXO/SQLCUSRP_DYN
    changing
      !CS_FCAT type LVC_S_FCAT .
  class-methods SET_FCAT_HEADER_TEXTS
    importing
      !IS_USER_SETTINGS type /CADAXO/SQLCUSRP_XML
      !IT_DDFIELDS type /CADAXO/SQLCDFIES_T
    changing
      !CT_FCAT type LVC_T_FCAT .
  class-methods REPLACE_APOSTROPHES_WITH_SPACE
    changing
      !C_STRING type STRING .
  class-methods REPLACE_ALL_SYMBOLS_WITH_VALUE
    changing
      !C_STRING type STRING
    raising
      /CADAXO/CX_SQLC_SYMB_NOT_FOUND .
  class-methods FORMAT_ABAP_CODE
    changing
      !CT_CODE type /CADAXO/SQLCSTRING_T .
  class-methods FOREWARD_NAVIGATION_ADT_STOB
    importing
      !I_DDOBJNAME type DDOBJNAME .
  class-methods FOREWARD_NAVIGATION_ADT_OTHERS
    importing
      !I_DDOBJNAME type DDOBJNAME .
  class-methods HAS_CODE_OPEN_LITERAL
    importing
      !IV_ABAP_CODE type /CADAXO/SQLCSTRING
      value(IV_OFFSET) type I default 0
      !IV_LITERAL_MARK type C default `'`
    returning
      value(EV_IS_OPEN) type FLAG .
  class-methods CREATE_DATA_REFERENCE
    importing
      !IV_INTTYPE type INTTYPE
      !IV_LENG type DDLENG
      !IV_DECIMALS type DECIMALS
      !IV_INTLEN type INTLEN
      !IV_STRU_NAME type STRING
    returning
      value(RR_DATA) type ref to DATA .
  class-methods CONVERT_VALUE_INT_TO_EDITOR
    importing
      !IV_TYP type C
      !IV_FIELDVALUE_INTERNAL type ANY
    returning
      value(RV_FIELDVALUE_EDITOR) type STRING .
  class-methods CALL_CONVERTION_EXIT_INPUT
    importing
      !IV_DATATYPE type ROLLNAME
    changing
      !EV_SYMBOL_VALUE type STRING .
  class-methods ENCLODING_APOSTROPHE_REMOVE
    changing
      !EV_SYMBOL_VALUE type STRING
    returning
      value(EV_APOSTROPHE_CHAR) type CHAR1 .
  class-methods ENCLODING_APOSTROPHE_SET
    importing
      !IV_APOSTROPHE_CHAR type CHAR1
    changing
      !EV_SYMBOL_VALUE type STRING .
  class-methods GET_SQL_COCKPIT_STANDARD_USERS
    returning
      value(RT_SQL_COCKPIT_STANDARD_USERS) type /CADAXO/SQLC_USER_NAME_T .
  class-methods FORMAT_WITH_SPACE
    importing
      value(IV_STRING) type STRING
    returning
      value(RV_FORMATTED) type STRING .
  PROTECTED SECTION.

*"* protected components of class /CADAXO/CL_SQLC_COCKPIT_ASSIST
*"* do not include other source files here!!!
    CLASS-DATA g_open TYPE char1 .
    CLASS-DATA g_space_string TYPE string .
    CLASS-DATA gs_admin_cust TYPE /cadaxo/sqlc_admin_cust .
private section.

*"* private components of class /CADAXO/CL_SQLC_COCKPIT_ASSIST
*"* do not include other source files here!!!
  class-data GT_USED_SYMBOLS_TABLE type /CADAXO/SQLCUSEDSYMBOLS_T .
ENDCLASS.



CLASS /CADAXO/CL_SQLC_COCKPIT_ASSIST IMPLEMENTATION.


  METHOD blacklist_check_table.

  ENDMETHOD.


  METHOD call_convertion_exit_input.  "COCKPIT-216

    DATA: lr_internal_data TYPE REF TO data.
    DATA: lr_output_data   TYPE REF TO data.
    DATA: lv_output_length TYPE i.

    DATA(lv_apostrophe) = encloding_apostrophe_remove( CHANGING ev_symbol_value = ev_symbol_value ).

    CREATE DATA lr_internal_data TYPE (iv_datatype).

    ASSIGN lr_internal_data->* TO FIELD-SYMBOL(<lv_internal_fieldvalue>).

    DESCRIBE FIELD <lv_internal_fieldvalue> EDIT MASK DATA(lv_conv_exit) OUTPUT-LENGTH lv_output_length.

    DATA(lr_output_type) = cl_abap_elemdescr=>get_c( lv_output_length ).

    CREATE DATA lr_output_data TYPE HANDLE lr_output_type.

    ASSIGN lr_internal_data->* TO FIELD-SYMBOL(<lv_output_fieldvalue>).

    IF lv_conv_exit CS '=='.

      DATA(lv_exit_fm) = CONV rs38l_fnam('CONVERSION_EXIT_' && replace( val = lv_conv_exit sub = '==' with = '' ) && '_INPUT').
      CALL FUNCTION 'FUNCTION_EXISTS'
        EXPORTING
          funcname = lv_exit_fm
        EXCEPTIONS
          OTHERS   = 1.
      IF sy-subrc = 0.

        <lv_internal_fieldvalue> = ev_symbol_value.

        CALL FUNCTION lv_exit_fm
          EXPORTING
            input  = <lv_internal_fieldvalue>
          IMPORTING
            output = <lv_output_fieldvalue>.

        ev_symbol_value = <lv_output_fieldvalue>.

        IF lv_apostrophe IS NOT INITIAL.

          encloding_apostrophe_set( EXPORTING iv_apostrophe_char = lv_apostrophe
                                    CHANGING  ev_symbol_value    = ev_symbol_value ).

        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD class_constructor.
****************************************************************************************************
* Description             : Class constructor                                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
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
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    CONCATENATE '' '' INTO g_space_string SEPARATED BY space.

  ENDMETHOD.


  METHOD clear_used_symbols_table.
    CLEAR gt_used_symbols_table.
  ENDMETHOD.


  METHOD compress_symbol_multivalue.

    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    CALL TRANSFORMATION id SOURCE data = i_symbol_multivalue
                           RESULT XML json_writer.

    DATA(lv_json) = json_writer->get_output( ).

    cl_abap_gzip=>compress_binary( EXPORTING raw_in   = lv_json
                                   IMPORTING gzip_out = e_data ).

  ENDMETHOD.


  METHOD condense.
****************************************************************************************************
* Description             : Condense SQL string respecting spaces between '                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.11.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 22.11.2010                                                             *
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

    DATA: l_pos            TYPE i,
          l_strlen         TYPE i,
          l_open(1)        TYPE c,
          l_string_new     TYPE string,
          l_last_character TYPE string.

* first, shift left and delete leading spaces
    SHIFT c_string LEFT DELETING LEADING space.

    l_strlen = strlen( c_string ).

    DO l_strlen TIMES.
      l_pos = sy-index - 1.

      IF c_string+l_pos(1) EQ `'`.
        TRANSLATE l_open USING ' XX '.
      ENDIF.

      IF l_open NE 'X'.
        IF c_string+l_pos(1) EQ g_space_string AND l_last_character EQ g_space_string.
          CONTINUE.
        ENDIF.
      ENDIF.

      CONCATENATE l_string_new c_string+l_pos(1) INTO l_string_new.

      MOVE c_string+l_pos(1) TO l_last_character.

    ENDDO.

    c_string = l_string_new.

  ENDMETHOD.


  METHOD convert_data_to_csv.

    DATA l_pos TYPE i.
    DATA l_type TYPE c.
    DATA l_col_value_p TYPE char30.
    DATA l_col_value_x TYPE char32.
    DATA l_col_value_d TYPE c LENGTH 10.
    DATA l_col_value_string TYPE string.
    DATA l_double_enclosure(2) TYPE c.
    DATA l_col_enclosure(1)    TYPE c.

    CONSTANTS: c_col_sep_tab       TYPE c VALUE 'T'.
    CONSTANTS: c_col_sep_comma     TYPE c VALUE ','.
    CONSTANTS: c_col_sep_semicolon TYPE c VALUE ';'.
    CONSTANTS: c_col_sep_space     TYPE c VALUE ' '.

    FIELD-SYMBOLS <ls_data> TYPE any.
    FIELD-SYMBOLS <ls_data_csv> TYPE any.
    FIELD-SYMBOLS <l_col_val> TYPE any.
    FIELD-SYMBOLS <l_col_sep> TYPE any.
    FIELD-SYMBOLS <ls_col_alv> TYPE /cadaxo/sqlcexportcolalv.

    CLEAR et_data.

    CASE i_csv_attr-field_separator.
      WHEN 'TAB'.
        ASSIGN cl_abap_char_utilities=>horizontal_tab TO <l_col_sep>.
*      ASSIGN c_col_sep_tab TO <l_col_sep>.
      WHEN 'COMMA'.
        ASSIGN c_col_sep_comma     TO <l_col_sep>.
      WHEN 'SEMICOLON'.
        ASSIGN c_col_sep_semicolon TO <l_col_sep>.
      WHEN 'SPACE'.
        ASSIGN c_col_sep_space     TO <l_col_sep>.
      WHEN 'OTHER'.
        ASSIGN i_csv_attr-field_separator_other TO <l_col_sep>.
    ENDCASE.

    IF i_csv_attr-add_header IS NOT INITIAL.
      APPEND INITIAL LINE TO et_data ASSIGNING <ls_data_csv>.
      LOOP AT it_col_alv ASSIGNING <ls_col_alv> WHERE export_flag = 'X'.
        CONCATENATE <ls_data_csv> <ls_col_alv>-fieldname INTO <ls_data_csv>.
      ENDLOOP.
    ENDIF.


    LOOP AT it_data ASSIGNING <ls_data>.

      APPEND INITIAL LINE TO et_data ASSIGNING <ls_data_csv>.

      l_pos = 0.
*    DO.
      LOOP AT it_col_alv ASSIGNING <ls_col_alv> WHERE export_flag = 'X'.
        CLEAR l_col_value_p.


        ASSIGN COMPONENT <ls_col_alv>-fieldname OF STRUCTURE <ls_data> TO <l_col_val>.
        IF sy-subrc EQ 0.

          l_pos = l_pos + 1.

          DESCRIBE FIELD <l_col_val> TYPE l_type.

          DATA: lo_conv_x2c TYPE REF TO cl_abap_conv_in_ce.
          CLEAR l_col_value_string.

          CASE l_type.

            WHEN 'y'.
              IF <ls_col_alv>-export_hex IS INITIAL.
                lo_conv_x2c = cl_abap_conv_in_ce=>create( encoding = i_csv_attr-encoding ).
                lo_conv_x2c->convert( EXPORTING input = <l_col_val>
                                      IMPORTING data  = l_col_value_string ).
              ELSE.
                MOVE <l_col_val> TO l_col_value_string.
              ENDIF.

              ASSIGN l_col_value_string TO <l_col_val>.

            WHEN 'X'. "X or XSTRING
              IF <ls_col_alv>-export_hex IS INITIAL.
                ASSIGN <l_col_val> TO <l_col_val> CASTING TYPE c.
              ENDIF.
              MOVE <l_col_val> TO l_col_value_string.
              ASSIGN l_col_value_string TO <l_col_val>.
            WHEN 'P'.
              MOVE <l_col_val> TO l_col_value_p.

              ASSIGN l_col_value_p TO <l_col_val>.
            WHEN 'T'. "Time
              CASE i_csv_attr-time_format.
                WHEN '01'.
                  MOVE <l_col_val> TO l_col_value_string.
                WHEN '02'.
                  CONCATENATE <l_col_val>(2) ':'
                              <l_col_val>+2(2) ':'
                              <l_col_val>+4(2) INTO l_col_value_string.
                WHEN '03'.
                  MOVE <l_col_val>(4) TO l_col_value_string.
                WHEN '04'.
                  CONCATENATE <l_col_val>(2) ':'
                              <l_col_val>+2(2) INTO l_col_value_string.
              ENDCASE.
              ASSIGN l_col_value_string TO <l_col_val>.
            WHEN 'D'. "Date
              CASE i_csv_attr-date_format.
                WHEN '01'.
                  MOVE <l_col_val> TO l_col_value_string.
                WHEN '02'.
                  CONCATENATE <l_col_val>(4)
                              '-'
                              <l_col_val>+4(2)
                              '-'
                              <l_col_val>+6(2)
                              INTO l_col_value_string.
                WHEN '03'.
                  CONCATENATE <l_col_val>(4)
                              '.'
                              <l_col_val>+4(2)
                              '.'
                              <l_col_val>+6(2)
                              INTO l_col_value_string.
                WHEN '04'.
                  CONCATENATE <l_col_val>+6(2) <l_col_val>+4(2) <l_col_val>(4) INTO l_col_value_string.
                WHEN '05'.
                  CONCATENATE <l_col_val>+6(2) '-' <l_col_val>+4(2) '-' <l_col_val>(4) INTO l_col_value_string.
                WHEN '06'.
                  CONCATENATE <l_col_val>+6(2) '.' <l_col_val>+4(2) '.' <l_col_val>(4) INTO l_col_value_string.
              ENDCASE.
              ASSIGN l_col_value_string TO <l_col_val>.
            WHEN 'I'.
              MOVE <l_col_val> TO l_col_value_string.
              ASSIGN l_col_value_string TO <l_col_val>.
          ENDCASE.

*        IF l_pos > 1.
          IF i_csv_attr-col_enclosure IS NOT INITIAL.

            CLEAR l_col_enclosure.

            CASE i_csv_attr-col_enclosure.
              WHEN '0'.
                MOVE '"' TO l_col_enclosure.
              WHEN '1'.
                MOVE '''' TO l_col_enclosure.
            ENDCASE.

            IF <l_col_val> CA i_csv_attr-col_enclosure.
              DATA l_dref TYPE REF TO data.
              FIELD-SYMBOLS: <l_col_val_u> TYPE any.
              CREATE DATA l_dref LIKE <l_col_val>.
              ASSIGN l_dref->* TO <l_col_val_u>.
              <l_col_val_u> = <l_col_val>.
              CONCATENATE l_col_enclosure l_col_enclosure INTO l_double_enclosure.
              REPLACE ALL OCCURRENCES OF l_col_enclosure IN <l_col_val_u> WITH l_double_enclosure.
              IF l_pos > 1.
                CONCATENATE <ls_data_csv> <l_col_sep> l_col_enclosure <l_col_val_u> l_col_enclosure INTO <ls_data_csv>.
              ELSE.
                CONCATENATE l_col_enclosure <l_col_val_u> l_col_enclosure INTO <ls_data_csv>.
              ENDIF.
            ELSE.
              IF l_pos > 1.
                CONCATENATE <ls_data_csv> <l_col_sep> l_col_enclosure <l_col_val> l_col_enclosure INTO <ls_data_csv>.
              ELSE.
                CONCATENATE l_col_enclosure <l_col_val> l_col_enclosure INTO <ls_data_csv>.
              ENDIF.
            ENDIF.
          ELSE.
            IF l_pos > 1.
              CONCATENATE <ls_data_csv> <l_col_sep> <l_col_val> INTO <ls_data_csv>.
            ELSE.
              MOVE <l_col_val> TO <ls_data_csv>.
            ENDIF.
          ENDIF.
*        ELSE.
*          MOVE <l_col_val> TO <ls_data_csv>.
*        ENDIF.
        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
*    ENDDO.


*    MOVE <ls_data> TO <ls_data_csv>.
    ENDLOOP.

  ENDMETHOD.


  METHOD convert_value_int_to_editor.

    DATA lv_fieldvalue_c22 TYPE c LENGTH 22.

    CLEAR rv_fieldvalue_editor.

    IF iv_typ CA 'IP'.

      MOVE iv_fieldvalue_internal TO rv_fieldvalue_editor.
      CONCATENATE '''' rv_fieldvalue_editor '''' INTO rv_fieldvalue_editor.
      CONDENSE rv_fieldvalue_editor NO-GAPS.

    ELSEIF iv_typ CA 'F'.

      CALL FUNCTION 'FLTP_CHAR_CONVERSION'
        EXPORTING
          input = iv_fieldvalue_internal
        IMPORTING
          flstr = lv_fieldvalue_c22.
      rv_fieldvalue_editor = lv_fieldvalue_c22.
      CONDENSE rv_fieldvalue_editor NO-GAPS.
      CONCATENATE '''' rv_fieldvalue_editor '''' INTO rv_fieldvalue_editor.

    ELSEIF iv_typ CA 'Xy'.

      MOVE iv_fieldvalue_internal TO rv_fieldvalue_editor.
      CONCATENATE '''' rv_fieldvalue_editor '''' INTO rv_fieldvalue_editor.

    ELSEIF iv_typ CA 'CDgNT'.

      CONCATENATE '''' iv_fieldvalue_internal '''' INTO rv_fieldvalue_editor.

    ELSEIF iv_typ CA 'easb'.

      MOVE iv_fieldvalue_internal TO rv_fieldvalue_editor.
      CONDENSE rv_fieldvalue_editor NO-GAPS.
      CONCATENATE '''' rv_fieldvalue_editor '''' INTO rv_fieldvalue_editor.

    ELSE.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_cockpit_assist
        EXPORTING
          textid         = /cadaxo/cx_sqlc_cockpit_assist=>dragdropdoubleclick_not_suppor
          /cadaxo/gv_typ = iv_typ.

    ENDIF.

  ENDMETHOD.


  METHOD create_alv_date_header.
    DATA:  l_date       TYPE dats,
           l_time       TYPE tims,
           l_date_c(10),
           l_time_c(8).

    CONVERT TIME STAMP i_timestamp_from TIME ZONE 'UTC   '
            INTO DATE l_date TIME l_time.

    WRITE: l_date TO l_date_c,
           l_time TO l_time_c.

    IF NOT i_timestamp_to IS INITIAL.
      CONCATENATE l_date_c '/' l_time_c '-' INTO r_grid_title SEPARATED BY space.
      CONVERT TIME STAMP i_timestamp_to TIME ZONE 'UTC   '
              INTO DATE l_date TIME l_time.
      WRITE: l_date TO l_date_c,
             l_time TO l_time_c.
      CONCATENATE r_grid_title l_date_c '/' l_time_c INTO r_grid_title SEPARATED BY space.
    ELSE.
      WRITE: l_date TO l_date_c,
             l_time TO l_time_c.
      CONCATENATE l_date_c '/' l_time_c INTO r_grid_title SEPARATED BY space.
    ENDIF.

  ENDMETHOD.


  METHOD create_components_xml.
****************************************************************************************************
* Description             : SQL Cockpit - ADM Customizing                                          *
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
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA ls_sap_comp TYPE /cadaxo/sqlc_xml_sap_comp.
    DATA ls_sql_comp TYPE /cadaxo/sqlc_xml_sql_comp.
    DATA lt_sap_comp TYPE /cadaxo/sqlc_xml_sap_comp_t.
    DATA lt_sql_comp TYPE /cadaxo/sqlc_xml_sql_comp_t.
    DATA ls_xml_comp TYPE /cadaxo/sqlc_xml_components.
    DATA l_sap_components TYPE string.
    DATA l_sql_components TYPE string.

* get sap components
    SELECT component release extrelease FROM cvers INTO TABLE lt_sap_comp.
    APPEND LINES OF lt_sap_comp TO ls_xml_comp-sap_components.

    IF e_sap_components IS REQUESTED.
      LOOP AT lt_sap_comp INTO ls_sap_comp.
        CONCATENATE l_sap_components ls_sap_comp-component '/' ls_sap_comp-release '/'
                    ls_sap_comp-extrelease cl_abap_char_utilities=>cr_lf  INTO l_sap_components.
      ENDLOOP.
      e_sap_components = l_sap_components.
    ENDIF.

    IF e_sql_components IS REQUESTED.

      CLEAR ls_sql_comp.
      ls_sql_comp-component = 'CADAXO_VERSION'.
      ls_sql_comp-release = /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value( i_parameter_id = 'CADAXO_VERSION' ).
      ls_sql_comp-active = 'X'.
      CONCATENATE l_sql_components ls_sql_comp-component '/' ls_sql_comp-release '/'
                  ls_sql_comp-active cl_abap_char_utilities=>cr_lf INTO l_sql_components.

      CLEAR ls_sql_comp.
      ls_sql_comp-component = 'CADAXO_REV_VERSION'.
      ls_sql_comp-release = /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value( i_parameter_id = 'CADAXO_REV_VERSION' ).
      ls_sql_comp-active = 'X'.
      CONCATENATE l_sql_components ls_sql_comp-component '/' ls_sql_comp-release '/'
                  ls_sql_comp-active cl_abap_char_utilities=>cr_lf INTO l_sql_components.

      SELECT addon addon_release active FROM /cadaxo/sqlcadoc INTO TABLE lt_sql_comp ORDER BY addon. "#EC CI_NOWHERE

      LOOP AT lt_sql_comp INTO ls_sql_comp.
        CONCATENATE l_sql_components ls_sql_comp-component '/' ls_sql_comp-release '/'
                    ls_sql_comp-active cl_abap_char_utilities=>cr_lf INTO l_sql_components.
      ENDLOOP.

      e_sql_components = l_sql_components.

    ENDIF.

  ENDMETHOD.


  METHOD create_data_reference.

    DATA l_type_element TYPE REF TO cl_abap_elemdescr.

    CLEAR rr_data.

    CASE iv_inttype.
      WHEN 'c' OR 'n' OR 'x'.
        CREATE DATA rr_data TYPE (iv_inttype) LENGTH iv_leng.
      WHEN 'd' OR 'f' OR 'i' OR 't' OR 'v'.
        CREATE DATA rr_data TYPE (iv_inttype).
      WHEN 's'.
        CREATE DATA rr_data TYPE int2.
      WHEN 'b'.
        CREATE DATA rr_data TYPE int1.
      WHEN '8'.
        CALL METHOD cl_abap_elemdescr=>('GET_INT8')
          RECEIVING
            p_result = l_type_element.
        CREATE DATA rr_data TYPE HANDLE l_type_element.
      WHEN 'g'.
        CREATE DATA rr_data TYPE string.
      WHEN 'p'.
        CREATE DATA rr_data TYPE p LENGTH iv_intlen DECIMALS iv_decimals.
      WHEN 'y'.
        CREATE DATA rr_data TYPE xstring.
      WHEN 'a'.
        CREATE DATA rr_data TYPE decfloat16.
      WHEN 'e'.
        CREATE DATA rr_data TYPE decfloat34.
      WHEN space.
        TRY.
            CREATE DATA rr_data TYPE (iv_stru_name).
          CATCH cx_sy_create_data_error.
        ENDTRY.
    ENDCASE.

  ENDMETHOD.


  METHOD create_frontend_mail.
****************************************************************************************************
* Description             : Create Frontend Mail                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations : Open Frontend Mail System and prefill to, subject and body             *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
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
* 24.10.2010 | Bigl Domi            | Errorhandling                               | CDX001-0019    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_document   TYPE string.
    DATA l_body TYPE string.

    l_body = i_body.

* concatenate mailto
    CONCATENATE 'mailto:' i_mailto '?subject=' i_subject '&body=' l_body  INTO l_document.

* execute mailto
    CALL METHOD cl_gui_frontend_services=>execute
      EXPORTING
        document               = l_document
        operation              = 'OPEN'
      EXCEPTIONS
        cntl_error             = 1
        error_no_gui           = 2
        bad_parameter          = 3
        file_not_found         = 4
        path_not_found         = 5
        file_extension_unknown = 6
        error_execute_failed   = 7
        synchronous_failed     = 8
        not_supported_by_gui   = 9
        OTHERS                 = 10.
    IF sy-subrc <> 0.
      IF sy-msgty IS INITIAL OR sy-msgid IS INITIAL OR sy-msgno IS INITIAL.   "CDX001-0019
        MESSAGE e043(/cadaxo/sqlc).                " Error
      ELSE.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING internal_error.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD decompress_symbol_multivalue.
    TRY.
        cl_abap_gzip=>decompress_binary( EXPORTING gzip_in   = i_symbol_multivalue
                                         IMPORTING raw_out = DATA(e_data) ).

        CALL TRANSFORMATION id SOURCE XML e_data
                               RESULT data = e_symbol_multivalue.

      CATCH cx_xslt_format_error cx_xslt_runtime_error cx_sy_compression_error.

    ENDTRY.

  ENDMETHOD.


  METHOD encloding_apostrophe_remove.

    DATA(lv_length) = strlen( ev_symbol_value ).
    DATA(lv_offset) = lv_length - 1.

    IF lv_length > 0 AND ev_symbol_value(1) CA |'`| AND ev_symbol_value+lv_offset(1) = ev_symbol_value(1).

      ev_apostrophe_char =  ev_symbol_value(1).

      ev_symbol_value = replace( val = ev_symbol_value off = lv_offset len = 1 with = '').
      ev_symbol_value = replace( val = ev_symbol_value off = 0 len = 1 with = '').

    ENDIF.

  ENDMETHOD.


  METHOD encloding_apostrophe_set.

    encloding_apostrophe_remove( CHANGING ev_symbol_value = ev_symbol_value ).

    ev_symbol_value = iv_apostrophe_char && ev_symbol_value && iv_apostrophe_char.

  ENDMETHOD.


  METHOD export_data.
* function is still in development and not released in the current release - Cadaxo 1.1.2014/Rel 2.1
*  CASE i_export_type.
*    WHEN 'CSV'.
*      /cadaxo/cl_sqlc_cockpit_assist=>export_data_csv( EXPORTING it_fcat = it_fcat it_data = it_data ).
*    WHEN 'ASXML'.
*      /cadaxo/cl_sqlc_cockpit_assist=>export_data_asxml( EXPORTING it_data = it_data ).
*  ENDCASE.
  ENDMETHOD.


  METHOD export_data_asxml.
* function is still in development and not released in the current release - Cadaxo 1.1.2014/Rel 2.1
  ENDMETHOD.


  METHOD export_data_csv.
* function is still in development and not released in the current release - Cadaxo 1.1.2014/Rel 2.1
*  CALL FUNCTION '/CADAXO/SQLCEXPORT_CSV'
*    EXPORTING
*      it_data = it_data
*      it_fcat = it_fcat.
  ENDMETHOD.


  method FIND_SYMBOL_REGEX.
    FIND ALL OCCURRENCES OF REGEX '&(\w|/|-|DBG_@|@)+&' IN i_where_syntax RESULTS e_result_tab IGNORING CASE.
  endmethod.


  METHOD foreward_navigation_adt_others.

    DATA l_adt_link TYPE string.

    l_adt_link = 'adt://' && sy-sysid && '/sap/bc/adt/vit/wb/object_type/tabldt/object_name/' && i_ddobjname.

    cl_gui_frontend_services=>execute(
      EXPORTING
        document = l_adt_link
      EXCEPTIONS
        OTHERS   = 1 ).

  ENDMETHOD.


  METHOD foreward_navigation_adt_stob.

    DATA l_adt_link TYPE string.
    DATA lr_ddl_handler TYPE REF TO if_dd_ddl_handler.
    DATA l_entityname TYPE ddstrucobjname.
    DATA lt_ddnames TYPE if_dd_ddl_types=>ty_t_ddobj.
    DATA ls_ddnames TYPE if_dd_ddl_types=>ty_s_ddobj.
    DATA lt_entity TYPE if_dd_ddl_types=>ty_t_entity_of_view.
    DATA lr_object TYPE REF TO cl_wb_object.
    DATA lr_adt_objref TYPE REF TO cl_adt_object_reference.

    CLEAR lt_ddnames.
    ls_ddnames-name = i_ddobjname.
    APPEND ls_ddnames TO lt_ddnames.

* get metadata
    TRY.
        lr_ddl_handler ?= cl_dd_ddl_handler_factory=>create( ).

        lr_ddl_handler->get_viewname_from_entityname( EXPORTING ddnames = lt_ddnames
                                                      IMPORTING view_of_entity = lt_entity ).

        IF lt_entity[ 1 ]-ddlname <> space.

          lr_object = cl_wb_object=>create_from_transport_key( p_object = 'DDLS' p_obj_name = CONV #( lt_entity[ 1 ]-ddlname ) ).
          lr_adt_objref = cl_adt_tools_core_factory=>get_instance( )->get_uri_mapper( )->map_wb_object_to_objref( lr_object ).
          l_adt_link = |{ 'adt://' }{ to_lower( sy-sysid ) }{ lr_adt_objref->ref_data-uri }|.

          cl_gui_frontend_services=>execute(
            EXPORTING
              document = l_adt_link
            EXCEPTIONS
              OTHERS   = 1 ).

        ENDIF.

      CATCH: cx_dd_ddl_read, cx_sy_itab_line_not_found, cx_adt_uri_mapping.

    ENDTRY.

  ENDMETHOD.


  METHOD format_abap_code.
****************************************************************************************************
* Description             : Format Abap Code                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations : Try to format the Abap Code to have max line length CHAR80             *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               :                          Company    : CADAXO GesmbH                    *
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
* 20.02.2017 | Bigl Domi            | too long lines                              | COCKPIT-99     *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_pos_from           TYPE i.
    DATA l_pos_to             TYPE i.
    DATA l_do_while           TYPE flag.
    DATA lt_abap_code_tmp     TYPE /cadaxo/sqlcstring_t.
    DATA ls_abap_code         LIKE LINE OF ct_code.
    DATA l_space              TYPE string.
    DATA l_count              TYPE p DECIMALS 1.
    DATA l_len                TYPE i.

    CONCATENATE '' '' INTO l_space SEPARATED BY space.

    LOOP AT ct_code ASSIGNING FIELD-SYMBOL(<lv_abap_code>).

      l_pos_from = 0.
      l_pos_to   = c_source_length.
      l_do_while = abap_false.

      IF strlen( <lv_abap_code> ) LE l_pos_to.
        APPEND <lv_abap_code> TO lt_abap_code_tmp.
      ELSE.
        ls_abap_code = <lv_abap_code>.

        IF ls_abap_code+l_pos_to EQ l_space.
          l_do_while = abap_true.
        ENDIF.

        WHILE ls_abap_code+l_pos_to NE l_space OR l_do_while = abap_true.
          l_do_while = abap_false.
          DO.
            IF ls_abap_code+l_pos_to(1) EQ l_space.
              IF NOT has_code_open_literal( iv_abap_code = ls_abap_code iv_offset = l_pos_to iv_literal_mark = `'` ) AND "COCKPIT-99
                 NOT has_code_open_literal( iv_abap_code = ls_abap_code iv_offset = l_pos_to iv_literal_mark = '`' ).    "COCKPIT-99
                l_pos_to = l_pos_to - 1.
                EXIT.
              ENDIF.
            ENDIF.
            l_pos_to = l_pos_to - 1.
          ENDDO.

          l_len = ( l_pos_to - l_pos_from ) + 1.

          IF l_len = 0.                                                                                                  "COCKPIT-99
            MESSAGE e113(/cadaxo/sqlc) INTO DATA(lv_msg).                                                                "COCKPIT-99
            RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error EXPORTING message = lv_msg. "COCKPIT-99
          ENDIF.                                                                                                         "COCKPIT-99

          APPEND ls_abap_code+l_pos_from(l_len) TO lt_abap_code_tmp.

          l_pos_from = l_pos_to + 1.
          l_pos_to = l_pos_from + c_source_length.

          IF l_pos_to GE strlen( ls_abap_code ).
            APPEND ls_abap_code+l_pos_from TO lt_abap_code_tmp.
            EXIT.
          ELSEIF ls_abap_code+l_pos_from CN space.                               "COCKPIT-147
            l_do_while = abap_true.                                              "COCKPIT-147
          ENDIF.

        ENDWHILE.

      ENDIF.
    ENDLOOP.

    CLEAR ct_code.
    APPEND LINES OF lt_abap_code_tmp TO ct_code.

  ENDMETHOD.


  METHOD format_with_space.
****************************************************************************************************
* Description             : Formats a given string with spaces after , and ( and before )          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
* Formats a given string with spaces after , and ( and before )                                    *
*--------------------------------------------------------------------------------------------------*
* Developer               : Harald Wiesinger         Company    : CADAXO GesmbH                    *
* Date                    : 19.09.2017               Release    : WAS 7.40                         *
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
    DATA lv_open TYPE boolean.
    DATA lv_now_removed TYPE boolean.

    DATA(lv_len) = strlen( iv_string ).

    DO lv_len TIMES.

      DATA(lv_offset_one_more) = sy-index.
      DATA(lv_offset_act) = sy-index - 1.
*      DATA(lv_offset_one_less) = sy-index - 2.

      "set a flag to check if the character is in quotes
      IF iv_string+lv_offset_act(1) CA |`'|.
        CLEAR lv_now_removed.
        IF lv_open = iv_string+lv_offset_act(1).
          CLEAR lv_open.
          lv_now_removed = abap_true.
        ENDIF.
        IF lv_now_removed = abap_false AND lv_open IS INITIAL.
          lv_open = iv_string+lv_offset_act(1).
        ENDIF.
      ENDIF.

      "add character to outputstring
      IF iv_string+lv_offset_act(1) CA |(,| AND iv_string+lv_offset_one_more(1) <> ` ` AND lv_open IS INITIAL.
        rv_formatted = rv_formatted && iv_string+lv_offset_act(1) && ` `.
*      ELSEIF iv_string+lv_index(1) CA |)| AND iv_string+lv_one_less(1) <> ` ` AND lv_open IS INITIAL.
*        rv_formatted = rv_formatted && ` ` && iv_string+lv_index(1).
      ELSE.
        rv_formatted = rv_formatted && iv_string+lv_offset_act(1).
      ENDIF.

    ENDDO.

  ENDMETHOD.


  METHOD get_addon_customizing.

    DATA l_xml                      TYPE string.
    DATA ls_adoc                    TYPE /cadaxo/sqlcadoc.

    CHECK NOT i_addon IS INITIAL.

    SELECT SINGLE addon_release settings FROM /cadaxo/sqlcadoc INTO CORRESPONDING FIELDS OF ls_adoc
           WHERE addon    = i_addon
             AND delivery = abap_false.

    CHECK NOT ls_adoc-settings IS INITIAL.

    cl_abap_gzip=>decompress_text(
      EXPORTING
        gzip_in  = ls_adoc-settings
      IMPORTING
        text_out = l_xml ).

    CALL TRANSFORMATION id
      SOURCE XML l_xml
      RESULT result_save = et_customizing.

    e_release = ls_adoc-addon_release.

    FREE: l_xml.
    FREE: ls_adoc.

  ENDMETHOD.


  METHOD get_adm_customizing.
****************************************************************************************************
* Description             : SQL Cockpit - ADM Customizing                                          *
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
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_xml   TYPE string.
    DATA ls_admc TYPE /cadaxo/sqlcadmc.

    IF gs_admin_cust IS INITIAL.
* get adm customizing from database
      SELECT SINGLE * FROM /cadaxo/sqlcadmc INTO ls_admc
             WHERE adm_key = 'COCKPIT'.              "#EC CI_SEL_NESTED
      IF sy-subrc EQ 0.

* decompress settings
        cl_abap_gzip=>decompress_text(
          EXPORTING
            gzip_in  = ls_admc-settings
          IMPORTING
            text_out = l_xml ).

* convert xml to structure
        CALL TRANSFORMATION id
          SOURCE XML l_xml
          RESULT result_save = e_customizing.

        FREE: l_xml,
              ls_admc.
        gs_admin_cust = CORRESPONDING #( e_customizing ).
      ENDIF.
    ELSE.
      MOVE-CORRESPONDING gs_admin_cust TO e_customizing.
    ENDIF.
  ENDMETHOD.


  METHOD get_cds_view_of_association.

    DATA lt_data TYPE TABLE OF string.
    DATA lr_sobject TYPE REF TO if_dd_sobject.
    DATA lt_sobjnames TYPE if_dd_sobject_types=>ty_t_sobjnames.
    DATA lt_dd03ndvtab TYPE dd03ndvtab.
    DATA lt_dd08bv_tab TYPE dd08bvtab.
    DATA ls_dd08bv TYPE dd08bv.
    DATA lt_dd05bv_tab TYPE dd05bvtab.
    DATA l_index TYPE i.

    CLEAR lt_sobjnames.
    CLEAR lt_dd03ndvtab.

    SPLIT iv_association AT '\' INTO TABLE lt_data.

    lr_sobject = cl_dd_sobject_factory=>create( ).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_data>).

      TRY.

          l_index = sy-tabix.

          CLEAR: lt_sobjnames.

          IF l_index = 1.
            APPEND <ls_data> TO lt_sobjnames.
          ELSE.
            ls_dd08bv = lt_dd08bv_tab[ associationname = <ls_data> ].
            APPEND ls_dd08bv-strucobjn_t TO lt_sobjnames.
          ENDIF.

          CLEAR: lt_dd03ndvtab,
                 lt_dd08bv_tab,
                 lt_dd05bv_tab.

          lr_sobject->read(
            EXPORTING
              get_state      = 'M'
              sobjnames      = lt_sobjnames
            IMPORTING
              dd03ndv_tab    = lt_dd03ndvtab
              dd08bv_tab     = lt_dd08bv_tab
              dd05bv_tab     = lt_dd05bv_tab ).

          ev_entity = ls_dd08bv-strucobjn_t.
          ev_typekind = ls_dd08bv-typekind_t.

        CATCH cx_dd_sobject_get cx_sy_itab_line_not_found.

          CLEAR ev_entity.
          CLEAR ev_typekind.

      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_global_symbol_value.
****************************************************************************************************
* Description             : Get the symbol value                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxr xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 11.10.2010 | David Ren            | Get user symbols value                      | Usersymbols    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 01.11.2010 | Domi Bigl            | Empty Usersymbol                            | CDX001-0020    *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_symbol_name TYPE /cadaxo/sqlcsymbol_name,
          ls_sqlcsymb   TYPE /cadaxo/sqlcsymb.

    DATA: l_no_usersymbol TYPE flag.                                             "CDX001-0020
    DATA: l_comma_s       TYPE char1.
    DATA: l_comma_e       TYPE char1.
    DATA: l_length        TYPE i.


    CLEAR e_symbol_value.

    MOVE i_symbol TO l_symbol_name.

* delete leading and ending '&'
    REPLACE ALL OCCURRENCES OF '&' IN l_symbol_name WITH space.
    CONDENSE l_symbol_name NO-GAPS.

* add by david ren on 2010.10.11
* first check if the symbol is a user symbol
    TRY.                                                                         "CDX001-0020
        /cadaxo/cl_sqlc_cockpit_assist=>get_user_symbol_value( EXPORTING i_symbol       = l_symbol_name
                                                               IMPORTING e_symbol_value = DATA(lv_value) ).

        e_symbol_value = lv_value.

      CATCH /cadaxo/cx_sqlc_symb_not_found.                                      "CDX001-0020
        l_no_usersymbol = 'X'.                                                   "CDX001-0020
    ENDTRY.                                                                      "CDX001-0020

    IF NOT l_no_usersymbol IS INITIAL."If symbol is user symbol, value cannot be empty "CDX001-0020
      "then check program symbol
* end add

* is the symbol a dynamic/global symbol
      SELECT SINGLE * FROM /cadaxo/sqlcsymb INTO ls_sqlcsymb WHERE symbol = l_symbol_name.
      IF sy-subrc EQ 0.
        IF NOT ls_sqlcsymb-symbol_class IS INITIAL.
          TRY.
* get the symbol value
              CALL METHOD (ls_sqlcsymb-symbol_class)=>/cadaxo/if_sqlc_cockpit_symbol~get_symbol_value
                EXPORTING
                  i_symbol = i_symbol
                IMPORTING
                  e_value  = e_symbol_value.
            CATCH cx_sy_dyn_call_illegal_class ##NO_HANDLER.

          ENDTRY.
        ELSE.
          MOVE ls_sqlcsymb-symbol_value TO e_symbol_value.
        ENDIF.
      ELSE.

* symbol not found, raise an exception
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found
          EXPORTING
            symbol = l_symbol_name.

      ENDIF.

*   add by daivd ren on 2010.10.11
    ENDIF.
*   end add

    l_length = strlen( e_symbol_value ) - 1.
    IF l_length <= 0.
      l_comma_s = l_comma_e = `'`.
    ENDIF.
    IF i_field_type CA 'CDTX'. "Character, Date, Time, RAW....
      IF l_length > 0.
        IF e_symbol_value+0(1) <> `'` AND e_symbol_value+0(1) <> '`'.
          l_comma_s = `'`.
        ENDIF.
        IF e_symbol_value+l_length(1) <> `'` AND e_symbol_value+l_length(1) <> '`'.
          l_comma_e = `'`.
        ENDIF.
      ENDIF.
    ENDIF.
    CONCATENATE l_comma_s e_symbol_value l_comma_e INTO e_symbol_value.


  ENDMETHOD.


  METHOD get_parameter_value.
****************************************************************************************************
* Description             : Get parameter value                                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
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

* read parameter from database
    SELECT SINGLE parameter_value FROM /cadaxo/sqlcparv INTO r_parameter_value WHERE parameter_id = i_parameter_id.
    IF sy-subrc NE 0.
      RAISE parameter_not_found.
    ENDIF.

  ENDMETHOD.


  METHOD get_sql_cockpit_standard_users.

    TYPES: BEGIN OF typ_profn,
             profn TYPE xuprofile,
           END OF typ_profn.

    DATA lt_profn TYPE TABLE OF typ_profn.

    CLEAR rt_sql_cockpit_standard_users.

    SELECT DISTINCT profn
      INTO TABLE lt_profn
      FROM ust12 AS a
        INNER JOIN ust10s  AS b
        ON  b~auth = a~auth
        AND b~objct = a~objct
        AND b~aktps = a~aktps
        WHERE a~objct = 'ZCADXOSQ01'
          AND a~aktps = 'A'.

    IF sy-subrc = 0 AND lines( lt_profn ) > 0.

      SELECT DISTINCT profn FROM ust10c APPENDING TABLE lt_profn
             FOR ALL ENTRIES IN lt_profn
             WHERE subprof = lt_profn-profn
               AND aktps = 'A'.

      IF lines( lt_profn ) > 0.

        SELECT DISTINCT u~bname AS uname b~name_text AS name
          FROM ust04 AS u
            INNER JOIN usr21 AS a
               ON a~bname = u~bname
            INNER JOIN usr02 AS c
               ON c~bname = u~bname
            INNER JOIN adrp AS b
               ON b~persnumber = a~persnumber
               INTO CORRESPONDING FIELDS OF TABLE rt_sql_cockpit_standard_users
                  FOR ALL ENTRIES IN lt_profn
                  WHERE u~profile = lt_profn-profn
                    AND c~ustyp IN ('A', 'S').

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_used_symbols_table.
    r_used_symbols_table = gt_used_symbols_table.
  ENDMETHOD.


  METHOD get_user_symbol_value.
****************************************************************************************************
* Description             : get user symbol value                                                  *
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
* 01.11.2010 | Domi Bigl            | Empty Usersymbol                            | CDX001-0020    *
*------------+----------------------+---------------------------------------------+----------------*
* 09.08.2017 | Dusan Sacha          | Symbol Multivalue                           | COCKPIT-216    *
*------------+----------------------+---------------------------------------------+----------------*
* 02.09.2017 | Domi Bigl            | Symbol with Datatype                        | COCKPIT-255    *
*------------+----------------------+---------------------------------------------+----------------*
* 20.02.2018 | Dusan Sacha          | Symbol Multivalue Enhancement               | COCKPIT-288    *
*------------+----------------------+---------------------------------------------+----------------*
* 05.04.2018 | Dusan Sacha          | Symbol Multivalue Upgrade to Ranges         | COCKPIT-214    *
****************************************************************************************************

    DATA lv_symbol_multivalue         TYPE /cadaxo/sqlcsymbol_multivalue.
    DATA lv_symbol_multivalue_str     TYPE string.
    DATA lv_symbol_value              TYPE /cadaxo/sqlcsymbol_value.
    DATA lv_datatype                  TYPE rollname.
    DATA:lv_datatype_ref              TYPE REF TO DATA.

    CLEAR e_symbol_value.
    CLEAR e_symbol_multivalue.
    e_is_multi = abap_false.
    CLEAR lv_symbol_multivalue.

    SELECT SINGLE
      symbol_value,
      symbol_multivalue,                                          "COCKPIT-216
      symbol_datatype                                             "COCKPIT-216
      FROM /cadaxo/sqlcusym
      INTO ( @e_symbol_value, @lv_symbol_multivalue, @lv_datatype )  "COCKPIT-216
      WHERE symbol_name = @i_symbol
        AND username    = @sy-uname.

    IF sy-subrc <> 0.                                                            "CDX001-0020
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found                        "CDX001-0020
        EXPORTING                                                                "CDX001-0020
          symbol = i_symbol.                                                     "CDX001-0020
    ENDIF.                                                                       "CDX001-0020

    IF lv_symbol_multivalue IS NOT INITIAL.

      CREATE DATA lv_datatype_ref TYPE (lv_datatype).                 "COCKPIT-214
      ASSIGN lv_datatype_ref->*  TO FIELD-SYMBOL(<fs>).               "COCKPIT-214
      e_symbol_multivalue = <fs>.                                     "COCKPIT-214
      e_is_multi = abap_true.                                         "COCKPIT-214

    ELSEIF lv_datatype IS NOT INITIAL.                                            "COCKPIT-255

      call_convertion_exit_input( EXPORTING iv_datatype      = lv_datatype         "COCKPIT-255
                                   CHANGING  ev_symbol_value = e_symbol_value ).  "COCKPIT-255

    ENDIF.
  ENDMETHOD.


  METHOD get_where_value_match_offset.
****************************************************************************************************
* Description             : get offset                                                             *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
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
* 09.05.2014 | Domi Bigl            | message for open literal                    | RT229          *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************


    DATA: l_do_times TYPE i.

    CLEAR g_open.

    c_offset = i_from.

    l_do_times = i_total_length - c_offset.

    DO l_do_times TIMES.

      IF c_where_syntax+c_offset(1) EQ `'`.
        TRANSLATE g_open USING ' XX '.
        c_offset = c_offset + 1.
        CONTINUE.
      ENDIF.

      IF g_open EQ space.
        IF c_where_syntax+c_offset(1) EQ g_space_string OR c_where_syntax+c_offset(1) EQ '.'.
          EXIT.
        ENDIF.
      ENDIF.

*begin OF INSERT 444
      IF c_where_syntax+c_offset(1) EQ '('.
       DATA(lv_close_bracket)  = 0.
       DATA(lv_open_bracket) = 0.
       lv_open_bracket   = lv_open_bracket + 1.

       WHILE lv_open_bracket > lv_close_bracket.
           c_offset = c_offset + 1.
           IF c_where_syntax+c_offset(1) EQ ')'.
              lv_close_bracket = lv_close_bracket + 1.
           ELSEIF c_where_syntax+c_offset(1) EQ '('.
              lv_open_bracket = lv_open_bracket + 1.
           ENDIF.
       ENDWHILE.
       EXIT.
      ENDIF.
*end OF INSERT 444

      c_offset = c_offset + 1.

    ENDDO.

    IF g_open IS NOT INITIAL.                                 "RT229
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_invalid_value      "RT229
        EXPORTING
          textid = /cadaxo/cx_sqlc_invalid_value=>open_literal. "RT229
    ENDIF.                                                    "RT229
  ENDMETHOD.


  METHOD has_code_open_literal.
****************************************************************************************************
* Description             : Check if there is an open text or string literal                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 20.02.2017               Release    : WAS 7.40                         *
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
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
    DATA l_count TYPE i.

    ev_is_open = abap_true.

    IF iv_offset < 0.
      iv_offset = 0.
    ENDIF.

    FIND ALL OCCURRENCES OF iv_literal_mark IN SECTION OFFSET iv_offset OF iv_abap_code MATCH COUNT l_count.
    IF sy-subrc = 0.
      l_count = l_count MOD 2.
      IF l_count = 0.
        ev_is_open = abap_false.
      ENDIF.
    ELSE.
      ev_is_open = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD is_addon_active.

    CHECK NOT i_addon IS INITIAL.

    SELECT SINGLE active FROM /cadaxo/sqlcadoc INTO r_active
           WHERE addon = i_addon.
  ENDMETHOD.


  METHOD map_ddfields_descr_to_fcat.

    CLEAR cs_fcat-coltext.

    cs_fcat-reptext   = is_dfies-reptext.
    cs_fcat-scrtext_s = is_dfies-scrtext_s.
    cs_fcat-scrtext_m = is_dfies-scrtext_m.
    cs_fcat-scrtext_l = is_dfies-scrtext_l.

    IF is_user_settings-hd_fieldname EQ 'X'.
      IF NOT is_dfies-/cadaxo/alias IS INITIAL AND NOT is_user_settings-hd_show_alias IS INITIAL.       "COCKPIT-182
        cs_fcat-coltext  =  is_dfies-/cadaxo/alias && '~' && is_dfies-colhd_fieldname.                  "COCKPIT-182
      ELSE.                                                                                             "COCKPIT-182
        cs_fcat-coltext =  is_dfies-colhd_fieldname.
      ENDIF.                                                                                            "COCKPIT-182
    ELSE.
      IF NOT is_dfies-/cadaxo/alias_field IS INITIAL AND NOT is_user_settings-hd_show_alias IS INITIAL.
        MOVE is_dfies-/cadaxo/alias_field TO cs_fcat-coltext.
      ELSE.
        IF NOT is_dfies-/cadaxo/alias IS INITIAL AND NOT is_user_settings-hd_show_alias IS INITIAL.
          IF NOT cs_fcat-scrtext_l IS INITIAL.
            CONCATENATE is_dfies-/cadaxo/alias '~' cs_fcat-scrtext_l INTO cs_fcat-scrtext_l.
          ENDIF.
          IF NOT cs_fcat-scrtext_m IS INITIAL.
            CONCATENATE is_dfies-/cadaxo/alias '~' cs_fcat-scrtext_m INTO cs_fcat-scrtext_m.
          ENDIF.
          IF NOT cs_fcat-scrtext_s IS INITIAL.
            CONCATENATE is_dfies-/cadaxo/alias '~' cs_fcat-scrtext_s INTO cs_fcat-scrtext_s.
          ENDIF.
          IF NOT cs_fcat-reptext IS INITIAL.
            CONCATENATE is_dfies-/cadaxo/alias '~' cs_fcat-reptext INTO cs_fcat-reptext.
          ENDIF.
        ENDIF.

        CASE 'X'.
          WHEN is_user_settings-hd_fieldtext_s.
            MOVE cs_fcat-scrtext_s TO cs_fcat-coltext.
          WHEN is_user_settings-hd_fieldtext_m.
            MOVE cs_fcat-scrtext_m TO cs_fcat-coltext.
          WHEN is_user_settings-hd_fieldtext_l.
            MOVE cs_fcat-scrtext_l TO cs_fcat-coltext.
        ENDCASE.
      ENDIF.

      IF cs_fcat-coltext IS INITIAL AND is_user_settings-hd_fieldtext_a IS INITIAL.
        cs_fcat-coltext = is_dfies-fieldname.
      ENDIF.

    ENDIF.



  ENDMETHOD.


  METHOD replace_all_symbols_with_value.
****************************************************************************************************
* Description             : Replace all symbols with values                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo GmbH              Company    : CADAXO GesmbH                    *
* Date                    : 31.12.2015               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxx             Company    : xxxxxxxxx                        *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 10.06.2016 | Ana Lekic            | symbol without ''                           | COCKPIT-34     *
*            |                      |                                             | $001           *
*------------+----------------------+---------------------------------------------+----------------*
* 27.07.2017 | Dusan Sacha          | allowed '-' in symbols                      | COCKPIT-227    *
*------------+----------------------+---------------------------------------------+----------------*
* 09.08.2017 | Dusan Sacha          | Symbol Multivalue                           | COCKPIT-216    *
*------------+----------------------+---------------------------------------------+----------------*
* 20.02.2018 | Dusan Sacha          | Symbol Multivalue Enhancement               | COCKPIT-288    *
*------------+----------------------+---------------------------------------------+----------------*
* 05.04.2018 | Dusan Sacha          | Symbol Multivalue Upgrade Ranges            | COCKPIT-214    *
*------------+----------------------+---------------------------------------------+----------------*
* 25.07.2018 | Domi Bigl            | Symbol value ' handling                     | COCKPIT-327    *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA lt_results             TYPE match_result_tab.
    DATA l_symbol_name          TYPE /cadaxo/sqlcsymbol_name.
    DATA l_symbol_name_replace  TYPE string.
    DATA l_symbol_value         TYPE string.  "COCKPIT-216
    DATA l_symbol_value_replace TYPE string.
    DATA l_symbol_multivalue    TYPE string.  "COCKPIT-288
    DATA l_from                 TYPE i.
    DATA l_length               TYPE i.
    DATA lt_symbols             TYPE TABLE OF /cadaxo/sqlcsymbol_name.
    DATA ls_sqlcsymb            TYPE /cadaxo/sqlcsymb.
    DATA lv_is_multi            TYPE flag.   "COCKPIT-216

    FIELD-SYMBOLS: <ls_result>  LIKE LINE OF lt_results,
                   <ls_symbols> LIKE LINE OF lt_symbols.

    /cadaxo/cl_sqlc_cockpit_assist=>find_symbol_regex(   "COCKPIT-214
      EXPORTING                                          "COCKPIT-214
        i_where_syntax =     c_string                    "COCKPIT-214
      IMPORTING                                          "COCKPIT-214
        e_result_tab   =     lt_results                  "COCKPIT-214
    ).                                                   "COCKPIT-214
    "COCKPIT-214    FIND ALL OCCURRENCES OF REGEX '&(\w|/|-)+&' IN c_string RESULTS lt_results IGNORING CASE. "COCKPIT-227

    IF sy-subrc EQ 0.
      LOOP AT lt_results ASSIGNING <ls_result>.

        l_from = <ls_result>-offset + 1.
        l_length = <ls_result>-length - 2.

        l_symbol_name = c_string+l_from(l_length).
        APPEND l_symbol_name TO lt_symbols.

      ENDLOOP.

      LOOP AT lt_symbols ASSIGNING <ls_symbols>.

        l_symbol_name = to_upper( <ls_symbols> ).

        APPEND l_symbol_name TO gt_used_symbols_table.

        TRY.

            /cadaxo/cl_sqlc_cockpit_assist=>get_user_symbol_value(
               EXPORTING i_symbol            = l_symbol_name
               IMPORTING e_symbol_value      = l_symbol_value
                         e_symbol_multivalue = l_symbol_multivalue    "COCKPIT-288
                         e_is_multi          = lv_is_multi ).         "COCKPIT-216

          CATCH /cadaxo/cx_sqlc_symb_not_found into data(lr_exception).
            SELECT SINGLE * FROM /cadaxo/sqlcsymb INTO ls_sqlcsymb WHERE symbol = l_symbol_name.
            IF sy-subrc = 0.
              IF NOT ls_sqlcsymb-symbol_class IS INITIAL.
                TRY.
                    CALL METHOD (ls_sqlcsymb-symbol_class)=>/cadaxo/if_sqlc_cockpit_symbol~get_symbol_value
                      EXPORTING
                        i_symbol = l_symbol_name
                      IMPORTING
                        e_value  = l_symbol_value.
                  CATCH cx_sy_dyn_call_illegal_class ##NO_HANDLER.
                ENDTRY.
              ELSE.
                MOVE ls_sqlcsymb-symbol_value TO l_symbol_value.
              ENDIF.
            ELSE.
              RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_symb_not_found
                EXPORTING
                  previous = lr_exception.

            ENDIF.
        ENDTRY.

        l_symbol_name_replace = `&` && l_symbol_name && `&`.
        IF lv_is_multi IS INITIAL.

          IF match( val = l_symbol_value regex = `^'.+'$` case = abap_false ) = l_symbol_value. "$001
            l_symbol_value_replace = l_symbol_value. "COCKPIT-327
          ELSEIF match( val = l_symbol_value regex = `^('.+(?!').)*$` case = abap_true ) = l_symbol_value.
            l_symbol_value_replace = l_symbol_value && `'`.
          ELSEIF match( val = l_symbol_value regex = `^((?!').+')*$` case = abap_false ) = l_symbol_value.
            l_symbol_value_replace = `'` && l_symbol_value.
          ELSE.
            l_symbol_value_replace = `'` && l_symbol_value && `'`.
          ENDIF.

          REPLACE ALL OCCURRENCES OF REGEX l_symbol_name_replace IN c_string WITH l_symbol_value_replace IGNORING CASE.

        ENDIF.

      ENDLOOP.

      SORT gt_used_symbols_table.
      DELETE ADJACENT DUPLICATES FROM gt_used_symbols_table.
      /cadaxo/cl_sqlc_cockpit_main=>set_gt_used_symbols( gt_used_symbols_table ).

    ENDIF.

  ENDMETHOD.


  METHOD replace_apostrophes_with_space.
****************************************************************************************************
* Description             : Replace apostrophes with space                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo GmbH              Company    : CADAXO GesmbH                    *
* Date                    : 31.12.2015               Release    : WAS 7.40                         *
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

    CONSTANTS c_apostrophe TYPE char1 VALUE ''''.

    DATA l_len    TYPE i.
    DATA l_pos    TYPE i.
    DATA l_on     TYPE boolean.
    DATA l_string TYPE string.

    l_len = strlen( c_string ).

    DO l_len TIMES.

      l_pos = sy-index - 1.

      IF l_on = 'X' AND c_string+l_pos(1) <> c_apostrophe.
        CONCATENATE l_string ' ' INTO l_string RESPECTING BLANKS.
      ELSE.
        CONCATENATE l_string c_string+l_pos(1) INTO l_string RESPECTING BLANKS.
      ENDIF.

      IF c_string+l_pos(1) = c_apostrophe.
        TRANSLATE l_on USING ' XX '.
      ENDIF.

    ENDDO.

    c_string = l_string.

  ENDMETHOD.


  METHOD replace_one_symbol_with_value.

    DATA: l_strlen_before TYPE i,
          l_strlen_after  TYPE i,
          l_symbol_value  TYPE /cadaxo/sqlcsymbol_value.

* get symbol value
    /cadaxo/cl_sqlc_cockpit_assist=>get_global_symbol_value(
        EXPORTING
           i_symbol       = i_symbol_name
           i_field_type   = i_where_column-type_kind
        IMPORTING
           e_symbol_value = l_symbol_value ).

    l_strlen_before = strlen( c_where_syntax ).

* replace all symbol values
    IF i_length IS SUPPLIED.
      REPLACE ALL OCCURRENCES OF i_symbol_name IN SECTION OFFSET
           i_from LENGTH i_length OF c_where_syntax WITH l_symbol_value.
    ELSE.
      REPLACE ALL OCCURRENCES OF i_symbol_name IN SECTION OFFSET
           i_from OF c_where_syntax WITH l_symbol_value.
    ENDIF.

    l_strlen_after = strlen( c_where_syntax ).

    c_offset = c_offset + ( l_strlen_after - l_strlen_before ).
    c_total  = c_total + ( l_strlen_after - l_strlen_before ).

  ENDMETHOD.


  METHOD replace_symbols_with_values.
****************************************************************************************************
* Description             : Replace symbols with values                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : xxxxxxxxxxxxxxxxxx        Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.08.2014 | René Rammer          | Symbol reduction                            | CR22-002       *
*            |                      |                                             | RT235          *
*------------+----------------------+---------------------------------------------+----------------*
****************************************************************************************************

*
*  DATA: l_symbol_name   TYPE /cadaxo/sqlcsymbol_name.
*
*  DATA: lt_results TYPE match_result_tab.
*  FIELD-SYMBOLS: <ls_result> LIKE LINE OF lt_results.
*
*  CLEAR: lt_results.
*
*  FIND ALL OCCURRENCES OF REGEX '&(\w|/)+&' IN i_where_column-value RESULTS lt_results.
*  IF sy-subrc EQ 0.
*    LOOP AT lt_results ASSIGNING <ls_result>.
*
*      MOVE i_where_column-value+<ls_result>-offset(<ls_result>-length) TO l_symbol_name.
*
*      IF i_length IS SUPPLIED.
*        /cadaxo/cl_sqlc_cockpit_assist=>replace_one_symbol_with_value(
*          EXPORTING
*            i_where_column = i_where_column
*            i_symbol_name  = l_symbol_name
*            i_from         = i_from
*            i_length       = i_length
*          CHANGING
*            c_where_syntax = c_where_syntax
*            c_offset       = c_offset
*            c_total        = c_total ).
*      ELSE.
*        /cadaxo/cl_sqlc_cockpit_assist=>replace_one_symbol_with_value(
*          EXPORTING
*            i_where_column = i_where_column
*            i_symbol_name  = l_symbol_name
*            i_from         = i_from
*          CHANGING
*            c_where_syntax = c_where_syntax
*            c_offset       = c_offset
*            c_total        = c_total ).
*      ENDIF.
*
** For used Symbols
*      REPLACE ALL OCCURRENCES OF '&' IN l_symbol_name WITH space.              "CR22-002
*      CONDENSE l_symbol_name NO-GAPS.                                          "CR22-002
*      TRANSLATE l_symbol_name TO UPPER CASE.                                   "CR22-002
*
** Creates list of user_symbols used in the Editor
*      APPEND l_symbol_name TO gt_used_symbols_table.                           "CR22-002
*    ENDLOOP.
*
*    SORT gt_used_symbols_table.                                                "CR22-002
*    DELETE ADJACENT DUPLICATES FROM gt_used_symbols_table.                     "CR22-002
*    /cadaxo/cl_sqlc_cockpit_main=>set_gt_used_symbols( gt_used_symbols_table )."CR22-002
*
*  ENDIF.
  ENDMETHOD.


  METHOD set_addon_customizing.

    DATA l_xml              TYPE string.
    DATA ls_adoc TYPE /cadaxo/sqlcadoc.


    CHECK NOT i_addon IS INITIAL.

    SELECT SINGLE * FROM /cadaxo/sqlcadoc
           INTO ls_adoc
           WHERE addon = i_addon.

    ls_adoc-addon = i_addon.

* transform the data into xml
    CALL TRANSFORMATION id
      SOURCE result_save = it_customizing
      RESULT XML l_xml.

* zip xml
    cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                                 IMPORTING gzip_out = ls_adoc-settings ).


    MODIFY /cadaxo/sqlcadoc FROM ls_adoc.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD set_adm_customizing.
****************************************************************************************************
* Description             : SQL Cockpit - ADM Customizing                                          *
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
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_xml              TYPE string.
    DATA ls_admc TYPE /cadaxo/sqlcadmc.

    SELECT SINGLE * FROM /cadaxo/sqlcadmc
           INTO ls_admc
           WHERE adm_key = 'COCKPIT'.

    ls_admc-adm_key = 'COCKPIT'.

* transform the data into xml
    CALL TRANSFORMATION id
      SOURCE result_save = i_customizing
      RESULT XML l_xml.

* zip xml
    cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                                 IMPORTING gzip_out = ls_admc-settings ).


    MODIFY /cadaxo/sqlcadmc FROM ls_admc.
    IF sy-subrc = 0.
      COMMIT WORK.
      CLEAR gs_admin_cust.
    ENDIF.

  ENDMETHOD.


  METHOD set_fcat_header_texts.
****************************************************************************************************
* Description             : Set fieldcatalog header texts                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo GmbH              Company    : CADAXO GesmbH                    *
* Date                    : 31.12.2015               Release    : WAS 7.40                         *
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

    DATA l_dummy TYPE string ##NEEDED.

    FIELD-SYMBOLS: <ls_fcat>     LIKE LINE OF ct_fcat,
                   <ls_ddfields> LIKE LINE OF it_ddfields.

    LOOP AT ct_fcat ASSIGNING <ls_fcat>.
      READ TABLE it_ddfields WITH KEY fieldname = <ls_fcat>-fieldname ASSIGNING <ls_ddfields>.
      IF sy-subrc = 0.
        IF NOT is_user_settings-hd_show_alias IS INITIAL AND <ls_ddfields>-/cadaxo/alias IS NOT INITIAL.

          IF NOT <ls_fcat>-scrtext_s IS INITIAL.
            CONCATENATE <ls_ddfields>-/cadaxo/alias '~' <ls_fcat>-scrtext_s INTO <ls_fcat>-scrtext_s.
          ENDIF.

          IF NOT <ls_fcat>-scrtext_m IS INITIAL.
            CONCATENATE <ls_ddfields>-/cadaxo/alias '~' <ls_fcat>-scrtext_m INTO <ls_fcat>-scrtext_m.
          ENDIF.

          IF NOT <ls_fcat>-scrtext_l IS INITIAL.
            CONCATENATE <ls_ddfields>-/cadaxo/alias '~' <ls_fcat>-scrtext_l INTO <ls_fcat>-scrtext_l.
          ENDIF.

          IF NOT <ls_fcat>-reptext IS INITIAL.
            CONCATENATE <ls_ddfields>-/cadaxo/alias '~' <ls_fcat>-reptext INTO <ls_fcat>-reptext.
          ENDIF.

          IF is_user_settings-colhd_type = '1'.
            CONCATENATE <ls_ddfields>-/cadaxo/alias '~' <ls_fcat>-fieldname INTO <ls_fcat>-coltext.
          ENDIF.

        ENDIF.
      ENDIF.

      CASE is_user_settings-colhd_type.
        WHEN '1'.
          IF <ls_fcat>-coltext IS INITIAL.
            <ls_fcat>-coltext = <ls_fcat>-fieldname.
          ENDIF.
          IF <ls_fcat>-coltext CA '-'.
            IF is_user_settings-hd_show_alias IS INITIAL.
              SPLIT <ls_fcat>-coltext AT '-' INTO l_dummy <ls_fcat>-coltext.
            ELSE.
              TRANSLATE <ls_fcat>-coltext USING '-~'.
            ENDIF.
          ENDIF.
        WHEN '2'.
          CASE abap_true.
            WHEN is_user_settings-hd_fieldtext_s.
              <ls_fcat>-coltext = <ls_fcat>-scrtext_s.
            WHEN is_user_settings-hd_fieldtext_m.
              <ls_fcat>-coltext = <ls_fcat>-scrtext_m.
            WHEN is_user_settings-hd_fieldtext_l.
              <ls_fcat>-coltext = <ls_fcat>-scrtext_l.
            WHEN is_user_settings-hd_show_alias.          "cockpit-339
              <ls_fcat>-coltext =  <ls_fcat>-fieldname.  "cockpit-339
          ENDCASE.
          IF <ls_fcat>-coltext CA '-'.
            IF is_user_settings-hd_show_alias IS INITIAL.
              SPLIT <ls_fcat>-coltext AT '-' INTO l_dummy <ls_fcat>-coltext.
            ELSE.
              TRANSLATE <ls_fcat>-coltext USING '-~'.
            ENDIF.
          ENDIF.
      ENDCASE.

    ENDLOOP.


  ENDMETHOD.


  METHOD set_parameter_value.
****************************************************************************************************
* Description             : Set parameter value                                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
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

    DATA: ls_sqlcparv TYPE /cadaxo/sqlcparv.

    MOVE: i_parameter_id    TO ls_sqlcparv-parameter_id,
          i_parameter_value TO ls_sqlcparv-parameter_value.

    MODIFY /cadaxo/sqlcparv FROM ls_sqlcparv.

  ENDMETHOD.


  METHOD set_used_symbols_table.
    gt_used_symbols_table = i_used_symbols_table.
  ENDMETHOD.


  METHOD split.
****************************************************************************************************
* Description             : Split SQL string respecting spaces between '                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 22.11.2010                                                             *
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

    DATA: l_pos            TYPE i,
          l_strlen         TYPE i,
          l_open(1)        TYPE c,
          l_sql_string_new TYPE string,
          l_sql_string     TYPE string.

    MOVE i_sql_string TO l_sql_string.

    /cadaxo/cl_sqlc_cockpit_assist=>condense( CHANGING c_string = l_sql_string ).

    l_pos = 1.

    l_strlen = strlen( l_sql_string ) - i_position_from.

    DO l_strlen TIMES.

      l_pos = i_position_from + sy-index - 1.

      IF l_sql_string+l_pos(1) EQ `'`.
        TRANSLATE l_open USING ' XX '.
      ENDIF.

      IF l_open NE 'X'.
        IF l_sql_string+l_pos(1) EQ g_space_string.
          APPEND l_sql_string_new TO r_sql_table.
          CLEAR l_sql_string_new.
          CONTINUE.
        ENDIF.
      ENDIF.

      CONCATENATE l_sql_string_new l_sql_string+l_pos(1) INTO l_sql_string_new.

    ENDDO.

    IF NOT l_sql_string_new IS INITIAL.
      APPEND l_sql_string_new TO r_sql_table.
    ENDIF.

  ENDMETHOD.


  METHOD sql_trace_off.
****************************************************************************************************
* Description             : Set SQL Trace off                                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 29.08.2010 | Fößleitner Johann    | Use the trace user settings                 | CDX001-0008    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    CALL FUNCTION 'PERFORMANCE_TRACE_OFF'
      EXPORTING
        trace_user           = sy-uname
        sql_trace_off        = i_sql_trace             "CDX001-0008
        enq_trace_off        = ' '
        rfc_trace_off        = ' '
        buf_trace_off        = i_tablebuffer_trace     "CDX001-0008
        check_user           = ' '
        use_trace_exceptions = 'X'
      IMPORTING
        last_mod_dat         = e_date_to
        last_mod_time        = e_time_to
      EXCEPTIONS
        no_trace_selected    = 1
        error_trace_off      = 2
        sql_trace_off        = 3
        rfc_trace_off        = 4
        enqueue_trace_off    = 5
        buffer_trace_off     = 6
        error_mod_user       = 7
        OTHERS               = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD sql_trace_on.
****************************************************************************************************
* Description             : Set SQL Trace on                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 10.04.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 29.08.2010 | Fößleitner Johann    | Use the trace user settings                 | CDX001-0008    *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.04.2016 | Ana Lekic            | activate the trace later                    | $002 COCKPIT-59*
*            |                      |                                             |                *
****************************************************************************************************

    DATA: BEGIN OF l_trace_on,
            sql(1),
            rfc(1),
            enq(1),
            buf(1),
          END OF l_trace_on,
          l_wp_no    TYPE wpinfo-wp_no,
          l_wp_pid   TYPE wpinfo-wp_pid,
          l_wp_index TYPE wpinfo-wp_index, "$002
          l_proc_nr  TYPE char3.

    CLEAR: e_success,
           e_date_from,
           e_time_from.

* get the actual workprocess number
    CALL FUNCTION 'TH_GET_OWN_WP_NO'
      IMPORTING
        "wp_no    = l_wp_no     "$002
        wp_pid   = l_wp_pid
        wp_index = l_wp_index.  "$002

    l_proc_nr = l_wp_index.

* set performance trace on
    CALL FUNCTION 'PERFORMANCE_TRACE_ON'
      EXPORTING
        client                      = sy-mandt
        trace_user                  = sy-uname
        sql_trace_on                = i_sql_trace           "CDX001-0008
        enq_trace_on                = ' '
        rfc_trace_on                = ' '
        buf_trace_on                = i_tablebuffer_trace   "CDX001-0008
        "tcode                       = sy-tcode              "$002
        proc_nr                     = l_proc_nr
      IMPORTING
        last_mod_dat                = e_date_from
        last_mod_time               = e_time_from
        sql_trace_already_on        = l_trace_on-sql
        rfc_trace_already_on        = l_trace_on-rfc
        enq_trace_already_on        = l_trace_on-enq
        buf_trace_already_on        = l_trace_on-buf
      EXCEPTIONS
        no_trace_selected           = 1
        error_trace_on              = 2
        trace_on_for_all            = 3
        trace_on_for_user           = 4
        sql_trace_on                = 5
        rfc_trace_on                = 6
        enqueue_trace_on            = 7
        buffer_trace_on             = 8
        error_only_prognam_or_tcode = 9
        OTHERS                      = 10.
    IF sy-subrc EQ 0.
      IF l_trace_on IS INITIAL.
        MOVE 'X' TO e_success.
      ELSE.
        MESSAGE w011(/cadaxo/sqlc). "SQL Trace is still active. SQL Trace could not be activated.
      ENDIF.
    ELSE.
      MESSAGE e100(/cadaxo/sqlc) WITH 'SQL Trace' 'PERFORMANCE_TRACE_ON' sy-subrc.
    ENDIF.

  ENDMETHOD.


  METHOD translate_sql_str_upper_case.
****************************************************************************************************
* Description             : Translate SQL string to upper case                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.11.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 22.11.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 21.06.2017 | Dusan Sacha          | Enable working with long SELECTs            |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************
*

    DATA: l_offset_literal TYPE i,
          l_offset_begin   TYPE i,
          l_from           TYPE i,
          l_to             TYPE i,
          l_begin          TYPE i,
          l_r_sql_string   TYPE /cadaxo/sqlcsql_string.

    MOVE i_sql_string TO l_r_sql_string.

* first, translate the whole string to upper case
    TRANSLATE l_r_sql_string TO UPPER CASE.

* and now, search for direct input values and replace it back
    WHILE sy-subrc EQ 0.
      FIND `'` IN SECTION OFFSET l_from OF i_sql_string MATCH OFFSET l_from.
      IF sy-subrc EQ 0.
        l_to = l_from + 1.
        FIND `'` IN SECTION OFFSET l_to OF i_sql_string MATCH OFFSET l_to.
        IF sy-subrc EQ 0.
          l_to = l_to + 1.
          l_offset_literal = l_to - l_from.
          l_offset_begin = l_from - l_begin.
          r_sql_string = r_sql_string && l_r_sql_string+l_begin(l_offset_begin) && i_sql_string+l_from(l_offset_literal).
          l_from = l_to.
          l_begin = l_to.
        ENDIF.
      ENDIF.
    ENDWHILE.

    r_sql_string = r_sql_string && l_r_sql_string+l_begin.
  ENDMETHOD.


  METHOD value_help_cds_views.
****************************************************************************************************
* Description             : Value Help Editor Insert CDS Views                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxr xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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

    DATA ls_shlp    TYPE shlp_descr.
    DATA lt_return  TYPE TABLE OF ddshretval.
    DATA l_subrc    TYPE sy-subrc.

    CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
      EXPORTING
        shlpname = '/CADAXO/SQLCCDS_VIEWS'
        shlptype = 'SH'
      IMPORTING
        shlp     = ls_shlp.

    LOOP AT ls_shlp-interface ASSIGNING FIELD-SYMBOL(<ls_interface>).
      <ls_interface>-valfield = 'V_DDLDEP-OBJECTNAME'.
    ENDLOOP.

    CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
      EXPORTING
        shlp          = ls_shlp
        disponly      = space
      IMPORTING
        rc            = l_subrc
      TABLES
        return_values = lt_return.
    IF l_subrc = 0.
      TRY.
          e_cds_view = lt_return[ 1 ]-fieldval.
        CATCH cx_sy_itab_line_not_found ##NO_HANDLER.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD value_help_dd_table.
****************************************************************************************************
* Description             : Value Help to select DB Table                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 03.02.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.06.2010                                                             *
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

* call search help dd table
    CALL FUNCTION 'F4_DD_ABAP_TABLE'
      EXPORTING
        object             = '*'
        suppress_selection = space
        display_only       = space
        multiple_selection = space
      IMPORTING
        result             = e_tabname.

* raise exception, if no table selected
    IF e_tabname IS INITIAL.
      RAISE no_table_selected.
    ENDIF.

  ENDMETHOD.


  METHOD value_help_dyn_symbols.
****************************************************************************************************
* Description             : Shows a value help popup to select the symbol                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxr xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    DATA: l_symbol_name TYPE /cadaxo/sqlcsymbol_name.

* show value help popup
    CALL FUNCTION '/CADAXO/SQLC_VALUE_HELP_DYNSYM'
      IMPORTING
        e_symbol_name = l_symbol_name.

    MOVE l_symbol_name TO e_symbol_name.

  ENDMETHOD.


  METHOD value_help_sy_fields.
****************************************************************************************************
* Description             : Value Help to select SYST-Field                                        *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 25.01.2011               Release    : WAS 7.00                         *
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

    DATA: lcl_structtype TYPE REF TO cl_abap_structdescr,
          lt_fields      TYPE ddfields,
          lt_fields_list TYPE TABLE OF /cadaxo/sqlcsyfieldlist,
          ls_fields_list LIKE LINE OF lt_fields_list,
          lt_ddshretval  TYPE TABLE OF ddshretval.

    FIELD-SYMBOLS: <l_dfies>       TYPE dfies,
                   <ls_ddshretval> TYPE ddshretval.

* get the SYST Structure
    lcl_structtype ?= cl_abap_typedescr=>describe_by_name( 'SYST' ).

* get the fields
    lt_fields = lcl_structtype->get_ddic_field_list( ).

    LOOP AT lt_fields ASSIGNING <l_dfies>.
      MOVE: <l_dfies>-tabname TO ls_fields_list-tabname,
            <l_dfies>-fieldname TO ls_fields_list-fieldname,
            <l_dfies>-fieldtext TO ls_fields_list-fieldtext.
      APPEND ls_fields_list TO lt_fields_list.
    ENDLOOP.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        ddic_structure  = '/CADAXO/SQLCSYFIELDLIST'
        retfield        = 'FIELDNAME'
        dynpprog        = sy-repid
        dynpnr          = sy-dynnr
        dynprofield     = 'FIELDNAME'
        window_title    = text-001
        value_org       = 'S'
      TABLES
        value_tab       = lt_fields_list
        return_tab      = lt_ddshretval
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.

    IF sy-subrc EQ 0.
      READ TABLE lt_ddshretval INDEX 1 ASSIGNING <ls_ddshretval>.
      IF sy-subrc EQ 0.
        CONCATENATE 'SY-' <ls_ddshretval>-fieldval INTO e_fieldname.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
