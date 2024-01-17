*todo create_structure:
*throw exceptions
class /CADAXO/CL_SQLC_TEMP_RRG definition
  public
  inheriting from /CADAXO/CL_SQLC_TEMPLATE
  final
  create public .

public section.

  data GS_TEMP_ATTR type /CADAXO/SQLC_TEMP_RRG_ATTR .

  methods GENERATE_OBJECTS .

  methods EXECUTE_TEMPLATE_GENERATION
    redefinition .
protected section.

  types:
    BEGIN OF ty_item_signature,
      obj_type TYPE tadir-object,
      obj_name TYPE tadir-obj_name,
      devclass TYPE devclass,
    END OF ty_item_signature .
  types:
    BEGIN OF ty_item.
      INCLUDE TYPE ty_item_signature.
      TYPES:
      srcsystem             TYPE tadir-srcsystem,
      origlang              TYPE tadir-masterlang,
      inactive              TYPE abap_bool,
      abap_language_version TYPE sy-langu,
    END OF ty_item .

  methods CREATE_CUSTOMIZING_UI38 .
  methods ADD_FILTER_MAPPING
    changing
      !CT_CODE type RSWSOURCET .
  methods ADD_STRUCTURE_TO_TRANSPORT
    importing
      !I_STRUCTURE_NAME type DDOBJNAME .
  methods CREATE_STRUCTURE .
  methods CREATE_ABAP_CLASS .
  methods GENERATE_SOURCE_CODE
    exporting
      !EV_SOURCE type RSWSOURCET .
  methods GET_HEADER
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_SELECT
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_FROM
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_INTO
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_FIELDS
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_WHERE
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_GROUP_BY
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_HAVING
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_ORDER_BY
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_BYPASSING_BUFFER
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_OFFSET
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_UP_TO_ROWS
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_CONNECTION
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_CODE_DBHINTS
    changing
      !CT_CODE type RSWSOURCET .
  methods GET_NEW_LINE
    changing
      !CT_CODE type RSWSOURCET .
  methods GENERATE_SOURCE_CODE_MAP_PROP
    exporting
      !EV_SOURCE type RSWSOURCET
    returning
      value(R_REDEFINE) type ABAP_BOOL .
  methods REDEFINE_MAP_PROPERTY
    importing
      !I_CLASS type VSEOCLASS
      !I_INHERITANCE type VSEOEXTEND
    changing
      !CT_REDEFINITIONS type SEOR_REDEFINITIONS_R
      !CT_METHOD_SOURCES type SEO_METHOD_SOURCE_TABLE .
PRIVATE SECTION.
ENDCLASS.



CLASS /CADAXO/CL_SQLC_TEMP_RRG IMPLEMENTATION.


  METHOD add_filter_mapping.

    APPEND '  FIELD-SYMBOLS: <result> TYPE ANY TABLE.' TO ct_code.
    APPEND `` TO ct_code.
    APPEND '  IF i_filter_select_options IS NOT INITIAL.' TO ct_code.
    APPEND '    me->build_where_condition( EXPORTING i_filter_select_options = i_filter_select_options' TO ct_code.
    APPEND '      IMPORTING e_where                 = DATA(where)' TO ct_code.
    APPEND '                e_search_structure = DATA(search_structure) ).' TO ct_code.
    APPEND '    ASSIGN search_structure->* TO FIELD-SYMBOL(<search_rang>).' TO ct_code.
    APPEND '  ENDIF.' TO ct_code.
    APPEND '  ASSIGN e_result->* TO <result>.' TO ct_code.

  ENDMETHOD.


  METHOD add_structure_to_transport.

    DATA lt_ko200  TYPE TABLE OF ko200.
    DATA lwa_order TYPE trkorr.
    DATA lwa_task  TYPE trkorr.

    CALL FUNCTION 'RS_ACCESS_PERMISSION'
      EXPORTING
        authority_check          = 'X'
        global_lock              = 'X'
        master_language          = sy-langu
        mode                     = 'MODIFY'
        object                   = 'TABL' && i_structure_name
        object_class             = 'DICT'
      EXCEPTIONS
        canceled_in_corr         = 1
        enqueued_by_user         = 2
        enqueue_system_failure   = 3
        illegal_parameter_values = 4
        locked_by_author         = 5
        no_modify_permission     = 6
        no_show_permission       = 7
        permission_failure       = 8
        request_language_denied  = 9
        OTHERS                   = 10.

    APPEND INITIAL LINE TO lt_ko200 ASSIGNING FIELD-SYMBOL(<lwa_ko200>).
    <lwa_ko200>-pgmid    = 'R3TR'.
    <lwa_ko200>-object   = 'TABL'.
    <lwa_ko200>-obj_name = i_structure_name.

    CALL FUNCTION 'TR_OBJECTS_CHECK'
      TABLES
        wt_ko200                = lt_ko200
      EXCEPTIONS
        cancel_edit_other_error = 1
        show_only_other_error   = 2
        OTHERS                  = 3.
    IF sy-subrc <> 0.

    ENDIF.

    CALL FUNCTION 'TR_OBJECTS_INSERT'
      IMPORTING
        we_order = lwa_order
        we_task  = lwa_task
      TABLES
        wt_ko200 = lt_ko200
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc <> 0.

    ENDIF.

    CALL FUNCTION 'RS_ACCESS_PERMISSION'
      EXPORTING
        mode         = 'FREE'
        object       = 'TABL' && i_structure_name
        object_class = 'DICT'
      EXCEPTIONS
        OTHERS       = 1.

  ENDMETHOD.


  METHOD create_abap_class.

    DATA l_class TYPE vseoclass.
    DATA l_inheritance TYPE vseoextend.
    DATA lt_implementings TYPE seo_implementings.
    DATA ls_redefinition   TYPE seoredef.
    DATA lt_redefinitions   TYPE seor_redefinitions_r.
    DATA lt_method_sources TYPE seo_method_source_table.
    DATA source_of_method TYPE seo_method_source.
    DATA l_corr TYPE trkorr.

    l_class-clsname = gs_temp_attr-abap_class.
    l_class-descript = gs_temp_attr-abap_class_descr.
    l_class-state = seoc_state_implemented.
    l_class-exposure = seoc_exposure_public.
    l_class-fixpt = abap_true.

    l_inheritance-clsname = l_class-clsname.
    l_inheritance-refclsname = '/CADAXO/CL_UI38_TYPE_ABAPCLASS'.
    l_inheritance-state = seoc_state_implemented.

    ls_redefinition-clsname    = l_class-clsname.
    ls_redefinition-refclsname = l_inheritance-refclsname.
    ls_redefinition-mtdname    = '/CADAXO/IF_UI38_TYPE_ABAPCLASS~EXECUTE_QUERY'.
    APPEND ls_redefinition TO lt_redefinitions.

    source_of_method-cpdname = '/CADAXO/IF_UI38_TYPE_ABAPCLASS~EXECUTE_QUERY'.
    source_of_method-redefine = abap_true.

    generate_source_code( IMPORTING ev_source = source_of_method-source ).

    APPEND source_of_method TO lt_method_sources.

    redefine_map_property( EXPORTING i_class = l_class
                                     i_inheritance = l_inheritance
                           CHANGING ct_redefinitions = lt_redefinitions
                                    ct_method_sources = lt_method_sources ).

    CALL FUNCTION 'SEO_CLASS_CREATE_COMPLETE'
      EXPORTING
        version         = seoc_version_active
        genflag         = seox_false
        authority_check = seox_true
        method_sources  = lt_method_sources
      IMPORTING
        korrnr          = l_corr
      CHANGING
        class           = l_class
        inheritance     = l_inheritance
        redefinitions   = lt_redefinitions
        implementings   = lt_implementings
      EXCEPTIONS
        existing        = 1
        is_interface    = 2
        db_error        = 3
        component_error = 4
        no_access       = 5
        other           = 6
        OTHERS          = 7.

  ENDMETHOD.


  METHOD create_customizing_ui38.

    DATA l_ui38_rep TYPE /cadaxo/ui38_rep.
    DATA l_ui38_ret TYPE /cadaxo/ui38_ret.

    l_ui38_rep-report_id = gs_temp_attr-rrg_report_id.

    l_ui38_ret-report_id = gs_temp_attr-rrg_report_id.
    l_ui38_ret-language = sy-langu.
    l_ui38_ret-title = gs_temp_attr-rrg_title.
    l_ui38_ret-description = gs_temp_attr-rrg_description.
    l_ui38_ret-active = abap_true.

    l_ui38_rep-type      = 'ABAPCLASS'.
    l_ui38_rep-class     = gs_temp_attr-rrg_class.
    l_ui38_rep-structure = gs_temp_attr-rrg_structure.

    l_ui38_rep-output_table = abap_true.
    l_ui38_rep-output_table_type = gs_temp_attr-rrg_output_table_type.
    l_ui38_rep-status = gs_temp_attr-rrg_status.

    l_ui38_rep-created_by = sy-uname.
    GET TIME STAMP FIELD l_ui38_rep-created_at.

    l_ui38_rep-active = gs_temp_attr-rrg_active.

    INSERT /cadaxo/ui38_rep FROM l_ui38_rep.
    INSERT /cadaxo/ui38_ret FROM l_ui38_ret.

    /cadaxo/cl_ui38_adm_main=>update_model_last_modified( ).

  ENDMETHOD.


  METHOD create_structure.


    DATA l_structure_name TYPE ddobjname.
    DATA ls_dd02v         TYPE dd02v.
    DATA lt_dd03p TYPE TABLE OF dd03p.
    DATA ls_dd04v TYPE dd04v.
    DATA l_rc TYPE syst_subrc.

    l_structure_name = gs_temp_attr-structure.

    ls_dd02v = VALUE #( tabname = l_structure_name
                        ddlanguage = sy-langu
                        tabclass = 'INTTAB'
                        ddtext = gs_temp_attr-structure_descr
                        exclass = 1 ).

    lt_dd03p = CORRESPONDING #( me->gr_parser->gt_lvc_t_fcat ).

    LOOP AT lt_dd03p ASSIGNING FIELD-SYMBOL(<ls_dd03p>).

      CLEAR ls_dd04v.

      <ls_dd03p>-position   = sy-tabix.
      <ls_dd03p>-tabname    = l_structure_name.
      <ls_dd03p>-ddlanguage = sy-langu.    "sy-language oder von wo kommt langu her?

      "take care of built-in types
      IF <ls_dd03p>-rollname = ''.
        CASE <ls_dd03p>-inttype.
          WHEN 'C'. <ls_dd03p>-datatype = 'CHAR'.
          WHEN 'I'. <ls_dd03p>-datatype = 'INT4'.
          WHEN 'F'. <ls_dd03p>-datatype = 'FLTP'.
          WHEN 'P'. <ls_dd03p>-datatype = 'DEC'.
          WHEN 'D'. <ls_dd03p>-datatype = 'DATS'.
          WHEN 'T'. <ls_dd03p>-datatype = 'TIMS'.
          WHEN 'N'. <ls_dd03p>-datatype = 'NUMC'.
          WHEN 'X'. <ls_dd03p>-datatype = 'RAW'.
          WHEN 'STRING'. <ls_dd03p>-datatype = 'STRING'.
          WHEN 'XSTRING'. <ls_dd03p>-datatype = 'RAWSTRING'.

            "when others then exception
        ENDCASE.

        <ls_dd03p>-leng = <ls_dd03p>-outputlen.

      ENDIF.

      "take care of currency & quantity fields
      IF <ls_dd03p>-datatype = 'CURR' AND me->gr_parser->gt_lvc_t_fcat[ fieldname = <ls_dd03p>-fieldname ]-cfieldname IS NOT INITIAL.
        IF line_exists( lt_dd03p[ fieldname = me->gr_parser->gt_lvc_t_fcat[ fieldname = <ls_dd03p>-fieldname ]-cfieldname ] ).
          <ls_dd03p>-reffield = me->gr_parser->gt_lvc_t_fcat[ fieldname = <ls_dd03p>-fieldname ]-cfieldname.
          <ls_dd03p>-reftable = l_structure_name.
        ENDIF.
      ELSEIF <ls_dd03p>-datatype = 'QUAN' AND me->gr_parser->gt_lvc_t_fcat[ fieldname = <ls_dd03p>-fieldname ]-qfieldname IS NOT INITIAL.
        IF line_exists( lt_dd03p[ fieldname = me->gr_parser->gt_lvc_t_fcat[ fieldname = <ls_dd03p>-fieldname ]-qfieldname ] ).
          <ls_dd03p>-reffield = me->gr_parser->gt_lvc_t_fcat[ fieldname = <ls_dd03p>-fieldname ]-qfieldname.
          <ls_dd03p>-reftable = l_structure_name.
        ENDIF.
      ENDIF.
    ENDLOOP.

    CALL FUNCTION 'DDIF_TABL_PUT'
      EXPORTING
        name              = l_structure_name
        dd02v_wa          = ls_dd02v
      TABLES
        dd03p_tab         = lt_dd03p
      EXCEPTIONS
        tabl_not_found    = 1
        name_inconsistent = 2
        tabl_inconsistent = 3
        put_failure       = 4
        put_refused       = 5
        OTHERS            = 6.
    IF sy-subrc <> 0.

    ENDIF.

    CALL FUNCTION 'DDIF_TABL_ACTIVATE'
      EXPORTING
        name        = l_structure_name
      IMPORTING
        rc          = l_rc
      EXCEPTIONS
        not_found   = 1
        put_failure = 2
        OTHERS      = 3.
    IF sy-subrc <> 0.

    ENDIF.

    me->add_structure_to_transport( i_structure_name = l_structure_name ).


" TR_SYS_PARAMS


  ENDMETHOD.


  METHOD execute_template_generation.

    DATA system_type         TYPE sy-sysid.
    DATA system_cliindep_edit   TYPE t000-ccnocliind.
    DATA system_client_role     TYPE t000-cccategory.

" try

    "generation is only permitted in open customer systems.
    CALL FUNCTION 'TR_SYS_PARAMS'
      IMPORTING
        systemtype         = system_type
        sys_cliinddep_edit = system_cliindep_edit
        system_client_role = system_client_role
      EXCEPTIONS
        OTHERS             = 1.

    IF sy-subrc <> 0 OR
       system_type <> 'CUSTOMER' OR
       ( system_client_role = 'P' OR system_client_role = 'S' ) OR
       ( system_cliindep_edit <> space AND system_cliindep_edit <> '1' ).

      MESSAGE i003(/cadaxo/sqlc_rrg) DISPLAY LIKE 'E'.
      RETURN.

    ENDIF.

  "  check_system_settings( ).

  "  check_fields_syntax( ).

   " check_select_single( ).

    if me->gr_parser->fields_syntax is not initial.
      MESSAGE s005(/cadaxo/sqlc_rrg) DISPLAY LIKE 'E'.
      RETURN.
    endif.

    if me->gr_parser->g_select_single is not initial.
      MESSAGE s006(/cadaxo/sqlc_rrg) DISPLAY LIKE 'E'.
      RETURN.
    endif.


    CALL FUNCTION '/CADAXO/SQLC_TEMP_RRG_WIZ'
      EXPORTING
        io_rrg_wiz     = me
      IMPORTING
        es_temp_attr   = me->gs_temp_attr
      EXCEPTIONS
        cancel_by_user = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
      MESSAGE s042(/cadaxo/sqlc) DISPLAY LIKE 'E'.
    ENDIF.

    "catch ...

    "endtry

  ENDMETHOD.


  METHOD generate_objects.

    TRY.

        IF me->gs_temp_attr-cre_dict  = abap_true.
           create_structure( ).
        ENDIF.

        IF me->gs_temp_attr-cre_class = abap_true.
           create_abap_class( ).
        ENDIF.

        if me->gs_temp_attr-cre_rrg_cust = abap_true.
           create_customizing_ui38( ).
        endif.

      CATCH /cadaxo/cx_sqlc_temp_rrg INTO DATA(lr_exception).

        MESSAGE lr_exception->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.

    ENDTRY.

  ENDMETHOD.


  METHOD generate_source_code.

    get_header( CHANGING ct_code = ev_source ).

    me->add_filter_mapping( changing ct_code = ev_source ).

    get_new_line( CHANGING ct_code = ev_source ).

    get_code_select( CHANGING ct_code = ev_source ).

    get_code_from( CHANGING ct_code = ev_source ).

    get_code_fields( CHANGING ct_code = ev_source ).

    get_code_where( CHANGING ct_code = ev_source ).

    get_code_group_by( CHANGING ct_code = ev_source ).

    get_code_having( CHANGING ct_code = ev_source ).

    get_code_order_by( CHANGING ct_code = ev_source ).

    get_code_into( CHANGING ct_code = ev_source ).

    get_code_bypassing_buffer( CHANGING ct_code = ev_source ).

    get_code_offset( CHANGING ct_code = ev_source ).

    get_code_up_to_rows( CHANGING ct_code = ev_source ).

    get_code_connection( CHANGING ct_code = ev_source ).

    get_code_dbhints( CHANGING ct_code = ev_source ).

    APPEND '.' TO ev_source.

    get_new_line( CHANGING ct_code = ev_source ).

    /cadaxo/cl_sqlc_cockpit_assist=>format_abap_code( EXPORTING i_line_size = 140
                                                     CHANGING ct_code = ev_source ).

    CALL FUNCTION 'PRETTY_PRINTER'
      EXPORTING
        inctoo   = space
      TABLES
        ntext    = ev_source
        otext    = ev_source.

  ENDMETHOD.


  METHOD generate_source_code_map_prop.

    CLEAR r_redefine.

    get_new_line( CHANGING ct_code = ev_source ).

    APPEND |   case i_property. | TO ev_source.

    get_new_line( CHANGING ct_code = ev_source ).

    LOOP AT gr_parser->gt_result_ddfields ASSIGNING FIELD-SYMBOL(<ddfield>) WHERE ( /cadaxo/alias IS NOT INITIAL OR /cadaxo/alias_field IS NOT INITIAL ).
      r_redefine = abap_true.

      IF <ddfield>-/cadaxo/alias_field IS NOT INITIAL.
        APPEND |     when '{ <ddfield>-/cadaxo/alias_field }'.| TO ev_source.
      ELSE.
        APPEND |     when '{ <ddfield>-fieldname }'.| TO ev_source.
      ENDIF.

      IF <ddfield>-/cadaxo/alias_value IS NOT INITIAL.
        APPEND |        r_fieldname = `{ <ddfield>-/cadaxo/alias_value }`. | TO ev_source.
      ELSE.
        IF <ddfield>-/cadaxo/alias IS NOT INITIAL.
          APPEND |        r_fieldname = `{ <ddfield>-/cadaxo/alias }~{ <ddfield>-fieldname }`. | TO ev_source.
        ELSE.
          APPEND |        r_fieldname = `{ <ddfield>-fieldname }`. | TO ev_source.
        ENDIF.
      ENDIF.

      get_new_line( CHANGING ct_code = ev_source ).

    ENDLOOP.

    APPEND |     when others. | TO ev_source.
    APPEND |       r_fieldname = i_property. | TO ev_source.
    APPEND |   endcase. | TO ev_source.

    get_new_line( CHANGING ct_code = ev_source ).

    /cadaxo/cl_sqlc_cockpit_assist=>format_abap_code( EXPORTING i_line_size = 140
                                                     CHANGING ct_code = ev_source ).

  ENDMETHOD.


  METHOD get_code_bypassing_buffer.

    IF NOT gr_parser->g_bypassing_buffer IS INITIAL.
      APPEND ' BYPASSING BUFFER' TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_connection.

    DATA l_line TYPE string.

    IF NOT gr_parser->connection_syntax IS INITIAL.
      CONCATENATE ' CONNECTION' gr_parser->connection_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_dbhints.

    DATA l_line           TYPE string.

    IF NOT gr_parser->dbhint_syntax IS INITIAL.
      CONCATENATE ' %_HINTS MSSQLNT' gr_parser->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         DB6     ' gr_parser->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         DB2     ' gr_parser->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         AS400   ' gr_parser->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         INFORMIX' gr_parser->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         ORACLE  ' gr_parser->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      CONCATENATE '         ADABAS  ' gr_parser->dbhint_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_fields.

    DATA l_line TYPE string.

    IF NOT gr_parser->fields_syntax IS INITIAL.
      CONCATENATE ' FIELDS' gr_parser->fields_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_from.
    APPEND ` FROM ` && gr_parser->source_syntax TO ct_code.
  ENDMETHOD.


  METHOD get_code_group_by.

    DATA l_line TYPE string.

    IF NOT gr_parser->group_syntax IS INITIAL.
      CONCATENATE ' GROUP BY' gr_parser->group_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_having.

    DATA l_line TYPE string.

    IF NOT gr_parser->having_syntax IS INITIAL.
      CONCATENATE ' HAVING' gr_parser->having_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_into.

    CASE gr_parser->g_select_version.
      WHEN /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_1.
        IF NOT gr_parser->g_select_single IS INITIAL.
          APPEND ' INTO CORRESPONDING FIELDS OF TABLE @<result>' TO ct_code.
        ELSE.
          APPEND ' INTO CORRESPONDING FIELDS OF TABLE @<result>' TO ct_code.
        ENDIF.
      WHEN /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_2.
        IF NOT gr_parser->g_select_single IS INITIAL.
          APPEND ' INTO CORRESPONDING FIELDS OF TABLE @<result>' TO ct_code.
        ELSE.
          APPEND ' INTO CORRESPONDING FIELDS OF TABLE @<result>' TO ct_code.
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD get_code_offset.

    DATA l_line TYPE string.

    IF NOT gr_parser->offset_syntax IS INITIAL.
      CONCATENATE ' OFFSET' gr_parser->offset_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_order_by.

    DATA l_line TYPE string.

    IF NOT gr_parser->order_syntax IS INITIAL.
      CONCATENATE ' ORDER BY' gr_parser->order_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_code_select.

    DATA l_line TYPE string.

    APPEND TEXT-007 TO ct_code.
    IF NOT gr_parser->g_select_single IS INITIAL.
      l_line = `SELECT SINGLE ` && gr_parser->column_syntax.
    ELSE.
      IF NOT gr_parser->g_select_distinct IS INITIAL.
        l_line = `SELECT DISTINCT ` && gr_parser->column_syntax.
      ELSE.
        l_line = `SELECT ` && gr_parser->column_syntax.
      ENDIF.
    ENDIF.

    APPEND l_line TO ct_code.

  ENDMETHOD.


  METHOD get_code_up_to_rows.

    DATA l_line     TYPE string.
    DATA l_maxsel   TYPE c LENGTH 10.

    IF gr_parser->g_select_single IS INITIAL.

      IF NOT gr_parser->g_up_to_x_rows IS INITIAL.
        MOVE gr_parser->g_up_to_x_rows TO l_maxsel.
      ENDIF.

      IF NOT l_maxsel IS INITIAL.
        CONCATENATE ' UP TO' l_maxsel 'ROWS' INTO l_line SEPARATED BY space.
        APPEND l_line TO ct_code.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_code_where.

    DATA l_line TYPE string.

    IF NOT gr_parser->where_syntax IS INITIAL.
      CONCATENATE ' WHERE (' gr_parser->where_syntax ' )' INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
      APPEND ' AND (where)' TO ct_code.
    ELSE.
        APPEND ' WHERE (where)' TO ct_code.
    ENDIF.

  ENDMETHOD.


  METHOD get_header.

    APPEND `*---------------------------------------------------------------------*` TO ct_code.
    APPEND `* This Method was generated with CADAXO SQL Cockpit                    ` TO ct_code.
    APPEND `*                                                                      ` TO ct_code.
    APPEND `* User:  ` && sy-uname && ``  TO ct_code.
    APPEND `* Date:  ` && sy-datum && ``  TO ct_code.
    APPEND `*                                                                      ` TO ct_code.
    APPEND `*---------------------------------------------------------------------*` TO ct_code.

    get_new_line( CHANGING ct_code = ct_code ).

  ENDMETHOD.


  METHOD get_new_line.
    APPEND `` TO ct_code.
  ENDMETHOD.


  METHOD redefine_map_property.

    DATA ls_redefinition   TYPE seoredef.
    DATA ls_source_of_method TYPE seo_method_source.

    DATA(redefine) = generate_source_code_map_prop( IMPORTING ev_source = ls_source_of_method-source ).

    IF redefine IS NOT INITIAL.
      ls_redefinition-clsname    = i_class-clsname.
      ls_redefinition-refclsname = i_inheritance-refclsname.
      ls_redefinition-mtdname    = '/CADAXO/IF_UI38_TYPE_ABAPCLASS~MAP_PROPERTY_TO_FIELD'.
      APPEND ls_redefinition TO ct_redefinitions.

      ls_source_of_method-cpdname = '/CADAXO/IF_UI38_TYPE_ABAPCLASS~MAP_PROPERTY_TO_FIELD'.
      ls_source_of_method-redefine = abap_true.

      APPEND ls_source_of_method TO ct_method_sources.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
