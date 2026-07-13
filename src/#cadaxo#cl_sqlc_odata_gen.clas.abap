CLASS /cadaxo/cl_sqlc_odata_gen DEFINITION
  PUBLIC
  INHERITING FROM /cadaxo/cl_sqlc_template
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPE-POOLS vrm.

    DATA gt_selopt TYPE /cadaxo/sqlc_temp_odata_selstt .
    DATA gt_tab_fields TYPE ddfields .
    CONSTANTS c_plugin TYPE /iwbep/sbdm_plugin VALUE '/IWBEP/GEN' ##NO_TEXT.
    CONSTANTS c_strat_name TYPE /iwbep/sbdm_gen_strat_name VALUE '0001' ##NO_TEXT.
    CONSTANTS c_strat_nameV4 TYPE /iwbep/sbdm_gen_strat_name VALUE '0002' ##NO_TEXT.
    CONSTANTS c_object TYPE trobjtype VALUE 'CLAS' ##NO_TEXT.
    CONSTANTS c_pgmid TYPE pgmid VALUE 'R3TR' ##NO_TEXT.
    CONSTANTS c_object_type TYPE trobjtype VALUE 'IWPR' ##NO_TEXT.

    METHODS set_input
      IMPORTING
        !is_odata_attr TYPE /cadaxo/sqlc_temp_odata_attr .
    METHODS key_property_check
      IMPORTING
        !is_odata_attr TYPE /cadaxo/sqlc_temp_odata_attr .
    METHODS special_character_check .
    METHODS fill_selopt
      EXPORTING
        VALUE(et_selopt) TYPE /cadaxo/sqlc_temp_odata_selstt .
    CLASS-METHODS validate_project_name
      IMPORTING
        !iv_project_name TYPE char30 .
    CLASS-METHODS validate_package
      IMPORTING
        !iv_package      TYPE devclass
        !iv_project_name TYPE char30 .
    METHODS generate_odata
      RAISING
        /cadaxo/cx_sqlc_odata_gen
        /iwbep/cx_sbcm_exception .

    METHODS execute_template_generation
        REDEFINITION .

    METHODS restrict_proj_types
      RETURNING VALUE(r_proj_types) TYPE vrm_values.

    CLASS-METHODS class_constructor.

  PROTECTED SECTION.

    METHODS create_project
      RAISING
        /cadaxo/cx_sqlc_odata_gen
        /iwbep/cx_sbdm_prcrtexception
        /iwbep/cx_sbcm_exception .
    METHODS create_model
      RAISING
        /cadaxo/cx_sqlc_odata_gen
        /iwbep/cx_sbcm_exception .
    METHODS create_entity
      RAISING
        /cadaxo/cx_sqlc_odata_gen
        /iwbep/cx_sbcm_exception .
    METHODS add_entity_attributes
      RAISING
        /cadaxo/cx_sqlc_odata_gen
        /iwbep/cx_sbcm_exception .
    METHODS create_service
      RAISING
        /cadaxo/cx_sqlc_odata_gen
        /iwbep/cx_sbcm_exception .
    METHODS save_changes
      RAISING
        /cadaxo/cx_sqlc_odata_gen
        /iwbep/cx_sbcm_exception .
    METHODS generate_objects
      RAISING
        /cadaxo/cx_sqlc_odata_gen
        /iwbep/cx_mgw_med_exception
        /iwbep/cx_sbcm_exception .
    METHODS redefine_method
      RAISING
        /cadaxo/cx_sqlc_odata_gen .
    METHODS register_service .
    METHODS get_primary_key
      IMPORTING
        !iv_input TYPE /cadaxo/sqlcselectsourcesyntax .
    METHODS generate_source_code
      EXPORTING
        !ev_source TYPE rswsourcet .
    METHODS get_core_type
      IMPORTING
        !iv_inttype         TYPE inttype
        !iv_intlen          TYPE intlen
      RETURNING
        VALUE(rv_core_type) TYPE /iwbep/sbod_edm_core_type .
    METHODS get_code_where
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS order_by
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS filter
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS top
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS skip
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS count
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_select
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_from
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_into
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_bypassing_buffer
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_offset
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_up_to_rows
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_connection
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_dbhints
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_fields
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_group_by
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_having
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_code_order_by
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_entity_set
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS create_table_from_structure
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_new_line
      CHANGING
        !ct_code TYPE rswsourcet .
    METHODS get_header
      CHANGING
        !ct_code TYPE rswsourcet .

    TYPES dd07v_types TYPE TABLE OF dd07v WITH DEFAULT KEY.

    METHODS get_existing_proj_types
      RETURNING VALUE(r_existing_proj_types) TYPE dd07v_types.

    METHODS get_supported_proj_types
      RETURNING VALUE(r_supported_proj_types) TYPE vrm_values.

    METHODS set_dropdown_values
      IMPORTING iv_dropdown_id TYPE vrm_id
                it_values      TYPE vrm_values.

    METHODS get_generation_strategy
      EXPORTING es_gen_strat_version TYPE /iwbep/s_sbdm_gen_stratversion
                es_gen_strategy      TYPE /iwbep/s_sbdm_gen_strategy.

    METHODS create_generation_strategy
      IMPORTING is_gen_strat_version   TYPE /iwbep/s_sbdm_gen_stratversion
                is_gen_strategy        TYPE /iwbep/s_sbdm_gen_strategy
      RETURNING VALUE(ro_gen_strategy) TYPE REF TO /iwbep/if_sbdm_gen_strategy.

    METHODS execute_generation_strategy
      IMPORTING io_gen_strategy TYPE REF TO /iwbep/if_sbdm_gen_strategy
      RAISING /CADAXO/CX_SQLC_ODATA_GEN.

    METHODS set_generation_strategy
      IMPORTING io_gen_strategy TYPE REF TO /iwbep/if_sbdm_gen_strategy.



  PRIVATE SECTION.

    DATA gr_transaction TYPE REF TO /iwbep/cl_sbdm_transact_handlr .
    DATA gr_project TYPE REF TO /iwbep/if_sbdm_project .
    DATA gr_factory TYPE REF TO /iwbep/if_sbdm_factory .
    DATA gr_model TYPE REF TO /iwbep/if_sbdm_model .
    DATA gr_entity_type TYPE REF TO /iwbep/if_sbod_entity_type .
    DATA gr_entity_set TYPE REF TO /iwbep/if_sbod_entity_set .
    CLASS-DATA gv_project_name TYPE char30 .
    CLASS-DATA gv_package TYPE devclass .
    CLASS-DATA gv_entity TYPE /iwbep/med_external_name .
    CLASS-DATA gv_entity_set TYPE /iwbep/sbdm_node_name .
    CLASS-DATA gv_proj_type TYPE /iwbep/sbdm_project_type .
    DATA gwa_report TYPE /cadaxo/sqlc_temp_odata_attr .
    DATA gwa_evt TYPE /cadaxo/sqlc_temp_rep_salv_evt .
    DATA gv_filter TYPE flag .
    DATA gv_order TYPE flag .
    DATA gv_top TYPE flag .
    DATA gv_skip TYPE flag .
    DATA gv_count TYPE flag .
    DATA gv_regser TYPE flag .
    CONSTANTS c_filter_cnt TYPE i VALUE 10 ##NO_TEXT.
    CLASS-DATA gt_supported_proj_types TYPE STANDARD TABLE OF /iwbep/sbdm_project_type.
ENDCLASS.



CLASS /CADAXO/CL_SQLC_ODATA_GEN IMPLEMENTATION.


  METHOD add_entity_attributes.

    DATA lo_factory       TYPE REF TO /iwbep/if_sbod_factory.
    DATA lo_property      TYPE REF TO /iwbep/cl_sbod_property.
    DATA lo_edm_core_type TYPE REF TO /iwbep/if_sbod_edm_core_type.
    DATA(i) = 1.

    lo_factory ?= /iwbep/cl_sbod=>get_factory( ).

    LOOP AT gt_selopt ASSIGNING FIELD-SYMBOL(<fs_selopt>).

      lo_property ?= lo_factory->create_property( <fs_selopt>-node_name ).
      lo_property->/iwbep/if_sbod_property~set_is_key( <fs_selopt>-is_key ).

      lo_edm_core_type = lo_factory->create_edm_core_type( <fs_selopt>-edm_core_type ).

      lo_property->/iwbep/if_sbod_property~set_type( lo_edm_core_type ).
      lo_property->/iwbep/if_sbdm_node~set_position( i ).

      lo_property->/iwbep/if_sbod_property~set_sortable( abap_true ).
      lo_property->/iwbep/if_sbod_property~set_filterable( abap_true ).
      IF <fs_selopt>-is_key EQ abap_false.
        lo_property->/iwbep/if_sbod_property~set_nullable( abap_true ).
      ENDIF.

      gr_entity_type->insert_child( lo_property ).
      i = i + 1.

    ENDLOOP.

  ENDMETHOD.


  METHOD count.

    APPEND TEXT-004                                                 TO ct_code.

    APPEND `IF io_tech_request_context->has_count( ) EQ abap_true.` TO ct_code.
    APPEND `  es_response_context-count = lines( et_entityset ).`   TO ct_code.
    APPEND `  RETURN.`                                              TO ct_code.
    APPEND `ENDIF.`                                                 TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

  ENDMETHOD.


  METHOD create_entity.

    DATA lo_od_factory  TYPE REF TO /iwbep/if_sbod_factory.

    lo_od_factory ?= /iwbep/cl_sbod=>get_factory( ).

    gr_entity_type = lo_od_factory->create_entity_type( CONV #( gv_entity ) ).
    gr_model->/iwbep/if_sbdm_node~insert_child( gr_entity_type ).
    gr_entity_set = lo_od_factory->create_entity_set( CONV #( gv_entity_set ) ).
    gr_entity_set->set_entity_type( gr_entity_type ).
    gr_model->/iwbep/if_sbdm_node~insert_child( gr_entity_set ).

  ENDMETHOD.


  METHOD create_model.

    gr_model = gr_factory->create_model( ).
    gr_project->insert_child( io_child = gr_model ).

  ENDMETHOD.


  METHOD create_project.

    DATA lo_node      TYPE REF TO /iwbep/cl_sbdm_node.

*   get transaction/factory instance
    gr_transaction = /iwbep/cl_sbdm_transact_handlr=>go_instance.
    gr_factory = /iwbep/cl_sbdm=>get_factory( ).

*   create project by factory
    gr_project = gr_factory->create_project(
      iv_project_name        = CONV #( gv_project_name )
      iv_project_description = CONV #( gv_project_name )
       ).

*   set variant of Project Generation (aka OData Type/ strategy /project type)
    gr_project->set_project_type( gv_proj_type ).

*   set additional values
    gr_project->set_package( gv_package ).

*   reserver project name - important (without this method, an lock exception will appear)
    gr_transaction->/iwbep/if_sbdm_transact_handlr~reserve_project_name( io_project = gr_project ).

    lo_node ?= gr_project.

    lo_node->make_persistent( ).

  ENDMETHOD.


  METHOD create_service.

    DATA(lo_service) = gr_factory->create_service( ).
    gr_project->insert_child( io_child = lo_service ).

  ENDMETHOD.


  METHOD create_table_from_structure.

    IF NOT gr_parser->g_select_single IS INITIAL.
      APPEND 'DATA lt_result_exp LIKE TABLE OF ls_result_exp.'  TO ct_code.
      APPEND 'APPEND ls_result_exp TO lt_result_exp.'           TO ct_code.
      get_new_line( CHANGING ct_code = ct_code ).
    ENDIF.

  ENDMETHOD.


  METHOD execute_template_generation.

    CALL FUNCTION '/CADAXO/SQLC_TEMP_ODATA_WIZ'
      EXPORTING
        io_odata_wiz   = me
      EXCEPTIONS
        cancel_by_user = 1
        OTHERS         = 2.
    CASE sy-subrc.
      WHEN 0.
        generate_odata( ).
      WHEN 1.
        MESSAGE s042(/cadaxo/sqlc) DISPLAY LIKE 'E'.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD fill_selopt.

    SPLIT gr_parser->source_syntax AT space INTO TABLE DATA(itab).
    IF itab IS NOT INITIAL.
      get_primary_key( itab[ 1 ] ).
    ENDIF.

    CLEAR: gt_selopt.

    LOOP AT gr_parser->gt_lvc_t_fcat ASSIGNING FIELD-SYMBOL(<fs_fcat>).

      DATA(abap_field) =  VALUE #( gr_parser->gt_result_ddfields[ fieldname = <fs_fcat>-fieldname  ] OPTIONAL ).
      DATA(is_key) = VALUE #( gt_tab_fields[ fieldname = <fs_fcat>-fieldname ]-keyflag OPTIONAL ).

      REPLACE ALL OCCURRENCES OF '-' IN <fs_fcat>-fieldname WITH '_'.

      APPEND VALUE #( node_name = <fs_fcat>-fieldname
                      is_key = is_key
                      edm_core_type = get_core_type( iv_inttype = <fs_fcat>-inttype iv_intlen = <fs_fcat>-intlen )
                      filterable = abap_false
                      abap_field = abap_field-domname ) TO gt_selopt.
    ENDLOOP.

    LOOP AT gr_parser->gt_sql_where_col_tab_t ASSIGNING FIELD-SYMBOL(<fs_sql_where_col_tab>).

      DATA(exist) = VALUE #( gt_selopt[ node_name = <fs_sql_where_col_tab>-fieldname ] OPTIONAL ).
      is_key = VALUE #( gt_tab_fields[ fieldname = <fs_sql_where_col_tab>-fieldname ]-keyflag OPTIONAL ).

      IF exist IS INITIAL.

        REPLACE ALL OCCURRENCES OF '-' IN <fs_sql_where_col_tab>-fieldname WITH '_'.

        APPEND VALUE #( node_name = <fs_sql_where_col_tab>-fieldname
                        is_key = is_key
                        edm_core_type = get_core_type( iv_inttype = <fs_fcat>-inttype iv_intlen = <fs_fcat>-intlen )
                        filterable = abap_true
                        abap_field = <fs_sql_where_col_tab>-fieldname ) TO gt_selopt.
      ENDIF.

    ENDLOOP.

    et_selopt = gt_selopt.

  ENDMETHOD.


  METHOD filter.

    APPEND TEXT-001                                                                                    TO ct_code.
    IF 1 = 2. "where used
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_odata_mgw_busi.
    ENDIF.
    APPEND |TRY.|                                                                      TO ct_code.
    APPEND |  IF  iv_filter_string         IS NOT INITIAL|                             TO ct_code.
    APPEND |  AND it_filter_select_options IS INITIAL .|                               TO ct_code.
    APPEND |    RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_odata_mgw_busi|                   TO ct_code.
    APPEND |      EXPORTING|                                                           TO ct_code.
    APPEND |        textid       = /cadaxo/cx_sqlc_odata_mgw_busi=>sql_filter|         TO ct_code.
    APPEND |        filter_param = iv_filter_string.|                                  TO ct_code.
    APPEND |  ENDIF.|                                                                  TO ct_code.
    APPEND |  IF lines( it_filter_select_options ) GT { c_filter_cnt }.|               TO ct_code.
    APPEND |    RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_odata_mgw_busi|                   TO ct_code.
    APPEND |      EXPORTING|                                                           TO ct_code.
    APPEND |        textid       = /cadaxo/cx_sqlc_odata_mgw_busi=>filter_criteria.|   TO ct_code.
    APPEND |  ENDIF.|                                                                  TO ct_code.
    APPEND |CATCH /cadaxo/cx_sqlc_odata_mgw_busi INTO DATA(exception).|                TO ct_code.
    APPEND |  RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception|                       TO ct_code.
    APPEND |    EXPORTING textid = /iwbep/cx_mgw_busi_exception=>filter_not_supported| TO ct_code.
    APPEND |              previous = exception.|                                       TO ct_code.
    APPEND |ENDTRY.|                                                                   TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

    APPEND `DATA lv_where     TYPE string.`                                            TO ct_code.
    APPEND `DATA lv_where_sql TYPE string.`                                            TO ct_code.
    APPEND `DATA l_property type string.`                                              TO ct_code.

    IF lines( gt_selopt ) GT c_filter_cnt .
      DATA(lv_count) = c_filter_cnt .
    ELSE.
      lv_count = lines( gt_selopt ).
    ENDIF.

    APPEND `LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<filter_select_options>).`      TO ct_code.

    APPEND `  CASE <filter_select_options>-property.`                                               TO ct_code.

    LOOP AT gr_parser->gt_result_ddfields ASSIGNING FIELD-SYMBOL(<ddfields>).
      IF <ddfields>-/cadaxo/alias_field <> '' AND <ddfields>-/cadaxo/alias = ''.
        APPEND `  when '` && <ddfields>-/cadaxo/alias_field && `'.` TO ct_code.
        APPEND `  l_property = '` && <ddfields>-fieldname && `'.` TO ct_code.
      ELSEIF <ddfields>-/cadaxo/alias_field <> '' AND <ddfields>-/cadaxo/alias <> ''.
        APPEND `  when '` && <ddfields>-/cadaxo/alias_field && `'.` TO ct_code.
        APPEND `  l_property = '` && <ddfields>-/cadaxo/alias && `~` && <ddfields>-fieldname && `'.` TO ct_code.
      ELSEIF <ddfields>-/cadaxo/alias <> ''.
        APPEND `  when '` && <ddfields>-fieldname && `'.` TO ct_code.
        APPEND `  l_property = '` && <ddfields>-/cadaxo/alias && `~` && <ddfields>-fieldname && `'.` TO ct_code.
      ENDIF.
    ENDLOOP.

    APPEND `  when others.`                                                                            TO ct_code.
    APPEND `  l_property = <filter_select_options>-property.`                                       TO ct_code.
    APPEND `  endcase.`                                                                                TO ct_code.

    APPEND `  CASE sy-tabix.`                                                                          TO ct_code.
    DO lv_count TIMES.
      APPEND `    WHEN ` && sy-index && `.`                                                            TO ct_code.
      APPEND `      FIELD-SYMBOLS: <fs` && sy-index && `> TYPE any .`                                  TO ct_code.
      APPEND `      ASSIGN <filter_select_options>-select_options TO <fs` && sy-index && `>.`       TO ct_code.
      APPEND `      lv_where = l_property  && | IN @<fs` && sy-index && `>|.`  TO ct_code.
    ENDDO.
    APPEND `  ENDCASE.`                                              TO ct_code.
    APPEND `  IF lv_where_sql IS INITIAL.`                           TO ct_code.
    APPEND `    lv_where_sql = lv_where.`                            TO ct_code.
    APPEND `  ELSE.`                                                 TO ct_code.
    APPEND `    lv_where_sql = lv_where_sql && | AND | && lv_where.` TO ct_code.
    APPEND `  ENDIF.`                                                TO ct_code.
    APPEND `ENDLOOP.`                                                TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

  ENDMETHOD.

  METHOD generate_objects.
    DATA lo_gen_strategy      TYPE REF TO /iwbep/if_sbdm_gen_strategy.

    DATA ls_gen_strat_version TYPE /iwbep/s_sbdm_gen_stratversion.
    DATA ls_gen_strategy      TYPE /iwbep/s_sbdm_gen_strategy.

    get_generation_strategy( IMPORTING es_gen_strat_version = ls_gen_strat_version
                                       es_gen_strategy      = ls_gen_strategy ).

    lo_gen_strategy = create_generation_strategy( is_gen_strat_version = ls_gen_strat_version
                                                  is_gen_strategy      = ls_gen_strategy ).

    execute_generation_strategy( io_gen_strategy = lo_gen_strategy ).

    set_generation_strategy( io_gen_strategy = lo_gen_strategy ).
  ENDMETHOD.

  METHOD get_generation_strategy.
    DATA ls_proj_type TYPE /iwbep/sbdm_project_type.

    TRY.
        ls_proj_type         = gr_project->get_project_type( ).
        es_gen_strat_version = gr_project->get_gen_strategy( ).
      CATCH /iwbep/cx_sbcm_exception.
        " TODO call suitable Exception
    ENDTRY.

    es_gen_strat_version-plugin = /cadaxo/cl_sqlc_odata_gen=>c_plugin.
    es_gen_strategy-plugin      = es_gen_strat_version-plugin.

    CASE ls_proj_type.

      WHEN /iwbep/if_sbdm_project=>gc_type_mpc_dpc_v2       " Service with SAP Annotations
        OR /iwbep/if_sbdm_project=>gc_type_mpc_dpc_v2_plus  " Service with Vocabulary-Based Annotations
        OR /iwbep/if_sbdm_project=>gc_type_apc_ref_v2_plus. " Annotation Model for Referenced Service
        " TODO Annotation Model for Referenced Service needs work during service generation
        " -> "access to node 00000000... is read only"

        es_gen_strat_version-strat_name    = /cadaxo/cl_sqlc_odata_gen=>c_strat_name.
        es_gen_strat_version-strat_version = /cadaxo/cl_sqlc_odata_gen=>c_strat_name.

      WHEN /iwbep/if_sbdm_project=>gc_type_mpc_dpc_v4.      " OData 4.0 Service
        " TODO OData 4.0 Service needs work during service generation
        " -> "unknown error"
        es_gen_strat_version-strat_name    = /cadaxo/cl_sqlc_odata_gen=>c_strat_namev4.
        es_gen_strat_version-strat_version = /cadaxo/cl_sqlc_odata_gen=>c_strat_namev4.

      WHEN OTHERS.

        es_gen_strat_version-strat_name = /cadaxo/cl_sqlc_odata_gen=>c_strat_name.

    ENDCASE.

    es_gen_strategy-name = es_gen_strat_version-strat_name.
  ENDMETHOD.

  METHOD create_generation_strategy.
    DATA lr_plugin TYPE REF TO /iwbep/cl_sbgn_plugin.

    lr_plugin = NEW #( ).

    TRY.
        IF is_gen_strat_version-strat_version IS INITIAL.

          ro_gen_strategy =
            lr_plugin->/iwbep/if_sbdm_plugin~create_generation_strategy(
                is_gen_strategy = is_gen_strategy ).

        ELSE.

          ro_gen_strategy =
            lr_plugin->/iwbep/if_sbdm_plugin~create_generation_strategy(
                is_gen_strategy      = is_gen_strategy
                iv_gen_strat_version = is_gen_strat_version-strat_version ).

        ENDIF.
      CATCH /iwbep/cx_sbdm_exception.
        " TODO call suitable exception
    ENDTRY.
  ENDMETHOD.

  METHOD execute_generation_strategy.
    DATA lt_messages  TYPE /iwbep/if_sbcm_msg_object=>ty_t_object.
    DATA lv_completed TYPE abap_bool.

    TRY.
        io_gen_strategy->generate( EXPORTING io_project   = gr_project
                                   IMPORTING et_message   = lt_messages
                                             ev_completed = lv_completed ).
      CATCH /iwbep/cx_sbcm_exception.
        "TODO call suitable exception
    ENDTRY.

    IF    sy-ucomm = 'CANCEL'
       OR sy-ucomm = 'ESC'.

      RAISE EXCEPTION NEW /cadaxo/cx_sqlc_odata_gen( textid = /cadaxo/cx_sqlc_odata_gen=>process_canceled ).

    ENDIF.
  ENDMETHOD.

  METHOD set_generation_strategy.
    DATA ls_gen_strat_ver TYPE /iwbep/s_sbdm_gen_stratversion.

    ls_gen_strat_ver-plugin        = io_gen_strategy->ms_gen_strategy-plugin.
    ls_gen_strat_ver-strat_name    = io_gen_strategy->ms_gen_strategy-name.
    ls_gen_strat_ver-strat_version = io_gen_strategy->mv_gen_strat_version.

    io_gen_strategy->get_validator( ).

    TRY.
        gr_project->set_gen_strategy( ls_gen_strat_ver ).
      CATCH /iwbep/cx_sbcm_exception.
        " TODO call suitable exception
    ENDTRY.
  ENDMETHOD.

  METHOD generate_odata.

    TRY.

        create_project( ).

        create_model( ).

        create_entity( ).

        add_entity_attributes( ).

        create_service( ).

        generate_objects( ).

        save_changes( ).

        redefine_method( ).

        IF gv_regser EQ abap_true.

          register_service( ).

        ENDIF.

      CATCH /cadaxo/cx_sqlc_odata_gen
            /iwbep/cx_sbcm_exception
            INTO DATA(lo_ref).

        MESSAGE lo_ref->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.

    ENDTRY.

  ENDMETHOD.


  METHOD generate_source_code.

    get_header( CHANGING ct_code = ev_source ).

    IF gv_filter EQ abap_true.
      filter( CHANGING ct_code = ev_source ).
    ENDIF.

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

    create_table_from_structure( CHANGING ct_code = ev_source ).

    get_entity_set( CHANGING ct_code = ev_source ).

    IF gv_order EQ abap_true.
      order_by( CHANGING ct_code = ev_source ).
    ENDIF.

    IF gv_count EQ abap_true.
      count( CHANGING ct_code = ev_source ).
    ENDIF.

    IF gv_skip EQ abap_true.
      skip( CHANGING ct_code = ev_source ).
    ENDIF.

    IF gv_top EQ abap_true.
      top( CHANGING ct_code = ev_source ).
    ENDIF.

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
      CONCATENATE '         HDB     ' gr_parser->dbhint_syntax INTO l_line SEPARATED BY space.
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
          APPEND ' INTO @DATA(ls_result_exp)' TO ct_code.
        ELSE.
          APPEND ' INTO TABLE @DATA(lt_result_exp)' TO ct_code.
        ENDIF.
      WHEN /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_2.
        IF NOT gr_parser->g_select_single IS INITIAL.
          APPEND ' INTO @DATA(ls_result_exp)' TO ct_code.
        ELSE.
          APPEND ' INTO TABLE @DATA(lt_result_exp)' TO ct_code.
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
      CONCATENATE ' WHERE' gr_parser->where_syntax INTO l_line SEPARATED BY space.
      APPEND l_line TO ct_code.
    ENDIF.

    IF gv_filter EQ abap_true.
      IF l_line IS INITIAL.
        l_line = ` WHERE ` && `(lv_where_sql)`.
        APPEND l_line TO ct_code.
      ELSE.
        l_line = ` AND ` && `(lv_where_sql)`.
        APPEND l_line TO ct_code.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_core_type.

    CASE iv_inttype.
      WHEN 'D'.
        rv_core_type = 'Edm.DateTime'.
      WHEN 'N'.
        rv_core_type = 'Edm.Int32'.
      WHEN 'P'.
        rv_core_type = 'Edm.Decimal'.
      WHEN 'T'.
        rv_core_type = 'Edm.Time'.
      WHEN 'X'.
        rv_core_type = 'Edm.Binary'.
      WHEN OTHERS.
        rv_core_type = 'Edm.String'.
    ENDCASE.

  ENDMETHOD.


  METHOD get_entity_set.

    APPEND TEXT-002                                                                                 TO ct_code.

    APPEND `DATA lo_table TYPE REF TO cl_abap_tabledescr.`                                          TO ct_code.
    APPEND `DATA lo_struc TYPE REF TO cl_abap_structdescr.`                                         TO ct_code.
    APPEND `DATA lo_elem  TYPE REF TO cl_abap_elemdescr.`                                           TO ct_code.
    APPEND `DATA lt_components TYPE abap_component_view_tab.`                                       TO ct_code.
    APPEND `DATA ls_line LIKE LINE OF et_entityset.`                                                TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

    APPEND `lo_table ?= cl_abap_tabledescr=>describe_by_data( lt_result_exp ).`                     TO ct_code.
    APPEND `lo_struc ?= lo_table->get_table_line_type( ).`                                          TO ct_code.
    APPEND `lt_components = lo_struc->get_included_view( ).`                                        TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

    APPEND `LOOP AT lt_result_exp ASSIGNING FIELD-SYMBOL(<fs_line>).`                                   TO ct_code.
    APPEND `  ls_line = CORRESPONDING #( <fs_line> ).`                                                  TO ct_code.
    APPEND `  LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_comp>).`                                 TO ct_code.
    APPEND `    lo_elem ?= <fs_comp>-type.`                                                             TO ct_code.
    APPEND `    if lo_elem->type_kind = 'D'.`                                                           TO ct_code.
    APPEND `      ASSIGN COMPONENT <fs_comp>-name OF STRUCTURE <fs_line> TO FIELD-SYMBOL(<fs_source>).` TO ct_code.
    APPEND `      ASSIGN COMPONENT <fs_comp>-name OF STRUCTURE ls_line   TO FIELD-SYMBOL(<fs_target>).` TO ct_code.
    APPEND `      if <fs_source> is assigned and <fs_target> is assigned.`                              TO ct_code.
    APPEND `        CONVERT DATE <fs_source> INTO TIME STAMP <fs_target> TIME ZONE 'UTC'.`              TO ct_code.
    APPEND `        IF <fs_target> EQ '0'.`                                                             TO ct_code.
    APPEND `          <fs_target> = '00010101000000'.`                                                  TO ct_code.
    APPEND `        ENDIF.`                                                                             TO ct_code.
    APPEND `      ENDIF.`                                                                               TO ct_code.
    APPEND `    unassign: <fs_source>, <fs_target>.`                                                    TO ct_code.
    APPEND `    ENDIF.`                                                                                 TO ct_code.
    APPEND `  ENDLOOP.`                                                                                 TO ct_code.
    APPEND `  APPEND ls_line TO et_entityset.`                                                          TO ct_code.
    APPEND `ENDLOOP.`                                                                                   TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

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


  METHOD get_primary_key.

    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.

*   Get the details of the DDIC table
    cl_abap_structdescr=>describe_by_name(
      EXPORTING
        p_name = CONV tabname( iv_input )
      RECEIVING
        p_descr_ref    = DATA(lo_descr_ref)
      EXCEPTIONS
        type_not_found = 1
        OTHERS         = 2 ).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    lo_structdescr ?= lo_descr_ref.

*   Check if input is a DDIC table
    CHECK lo_structdescr->is_ddic_type( ) = abap_true.

*   Get the details of the table fields
    gt_tab_fields = lo_structdescr->get_ddic_field_list( ).

  ENDMETHOD.


  METHOD key_property_check.

    IF NOT line_exists( gt_selopt[ is_key = abap_true ] ) .
      MESSAGE ID '/IWBEP/SBOD' TYPE 'E'
      NUMBER '106' WITH is_odata_attr-entity.
    ENDIF.

  ENDMETHOD.


  METHOD order_by.

    APPEND TEXT-003                                               TO ct_code.

    APPEND `DATA lt_otab TYPE abap_sortorder_tab.`                TO ct_code.
    APPEND `DATA ls_otab LIKE LINE OF lt_otab.`                   TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

    APPEND `LOOP AT it_order ASSIGNING FIELD-SYMBOL(<fs_order>).` TO ct_code.
    APPEND `  ls_otab-name = <fs_order>-property.`                TO ct_code.
    APPEND `  IF <fs_order>-order = 'desc'.`                      TO ct_code.
    APPEND `    ls_otab-descending = abap_true.`                  TO ct_code.
    APPEND `  ENDIF.`                                             TO ct_code.
    APPEND `  APPEND ls_otab TO lt_otab.`                         TO ct_code.
    APPEND `ENDLOOP.`                                             TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

    APPEND `SORT et_entityset BY (lt_otab).`                      TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

  ENDMETHOD.


  METHOD redefine_method.

    DATA lv_clskey           TYPE seoclskey.
    DATA ls_inactive_object  TYPE dwinactiv.
    DATA lt_inactive_objects TYPE TABLE OF dwinactiv.
    DATA lt_redefinitions    TYPE seo_method_source_table.
    DATA ls_redefine_method  TYPE seo_method_source.
    DATA lv_popup            TYPE abap_bool.
    DATA lv_no_ui            TYPE abap_bool.
    DATA lt_generated_objects  TYPE /iwbep/if_sbdm_project=>ty_t_gen_artifacts.

    lt_generated_objects = gr_project->get_generated_artifacts( ).

    LOOP AT lt_generated_objects ASSIGNING FIELD-SYMBOL(<generated_object>).
      IF <generated_object>->get_type( ) = 'DPCS'.    "MPCB, MPCS, DPCB, DPCS, MDL, SRV,
        lv_clskey-clsname =  <generated_object>->get_tadir_data( )-trobj_name.
      ENDIF.
    ENDLOOP.

    IF lv_clskey-clsname IS INITIAL.
      /cadaxo/cx_sqlc_odata_gen=>raise_t100( ).
    ENDIF.

    IF strlen( gv_entity_set ) > 16.
      ls_redefine_method-cpdname = to_upper( gv_entity_set(16) ) && '_GET_ENTITYSET'.
    ELSE.
      ls_redefine_method-cpdname = to_upper( gv_entity_set ) && '_GET_ENTITYSET'.
    ENDIF.

    ls_redefine_method-redefine = abap_true.

    generate_source_code( IMPORTING ev_source = ls_redefine_method-source ).

    APPEND ls_redefine_method TO lt_redefinitions.

    CALL FUNCTION 'SEO_CLASS_CREATE_REDEFINITIONS'
      EXPORTING
        redefinitions_expanded   = lt_redefinitions
        clskey                   = lv_clskey
      EXCEPTIONS
        class_not_existing       = 1
        inheritance_not_existing = 2
        method_not_inherited     = 3
        not_all_inserted         = 4
        no_access                = 5
        db_error                 = 6
        other                    = 7
        OTHERS                   = 8.
    IF sy-subrc <> 0.
      /cadaxo/cx_sqlc_odata_gen=>raise_t100( ).
    ENDIF.

    ls_inactive_object-object   = /cadaxo/cl_sqlc_odata_gen=>c_object.
    ls_inactive_object-obj_name = lv_clskey-clsname.
    INSERT ls_inactive_object INTO TABLE lt_inactive_objects.

    lv_no_ui = boolc( lv_popup = abap_false ).

    CALL FUNCTION 'RS_WORKING_OBJECTS_ACTIVATE'
      EXPORTING
        with_popup             = lv_popup
        ui_decoupled           = lv_no_ui
      TABLES
        objects                = lt_inactive_objects
      EXCEPTIONS
        excecution_error       = 1
        cancelled              = 2
        insert_into_corr_error = 3
        OTHERS                 = 4.
    IF sy-subrc <> 0.
      /cadaxo/cx_sqlc_odata_gen=>raise_t100( ).
    ENDIF.

  ENDMETHOD.


  METHOD register_service.

    DATA lv_service_name TYPE /iwbep/med_grp_technical_name.
    DATA lv_version      TYPE /iwbep/med_grp_version.

    lv_service_name = |{ gv_project_name }_SRV|.
    lv_version      = /cadaxo/cl_sqlc_odata_gen=>c_strat_name.

    CALL FUNCTION '/IWFND/FM_ACTIVATE_SERVICE'
      EXPORTING
        iv_tech_service_name    = lv_service_name
        iv_tech_service_version = lv_version.
    IF sy-subrc <> 0.
      /cadaxo/cx_sqlc_odata_gen=>raise_t100( ).
    ENDIF.

  ENDMETHOD.


  METHOD save_changes.

    gr_transaction->/iwbep/if_sbdm_transaction~save(
      IMPORTING
        et_messages              = DATA(lt_messages)
        ).

    IF lt_messages IS INITIAL.
      DATA project TYPE /iwbep/t_sbdm_projects.
      APPEND gr_project TO project.
      gr_transaction->/iwbep/if_sbdm_transaction~unlock_projects( project  ).
    ENDIF.

  ENDMETHOD.


  METHOD set_input.

    gv_project_name = is_odata_attr-project_name .
    gv_package      = is_odata_attr-package.
    gv_entity       = is_odata_attr-entity.
    gv_entity_set   = is_odata_attr-entity_set.
    gv_proj_type    = is_odata_attr-odata_type.
    gv_regser       = is_odata_attr-regser.
    gv_filter       = is_odata_attr-filter.
    gv_order        = is_odata_attr-order.
    gv_top          = is_odata_attr-top.
    gv_skip         = is_odata_attr-skip.
    gv_count        = is_odata_attr-count.

  ENDMETHOD.


  METHOD skip.

    APPEND TEXT-005                                                         TO ct_code.

    APPEND `IF io_tech_request_context->get_skip( ) > 0.`                   TO ct_code.
    APPEND `  DELETE et_entityset TO io_tech_request_context->get_skip( ).` TO ct_code.
    APPEND `ENDIF.`                                                         TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

  ENDMETHOD.


  METHOD special_character_check.

    LOOP AT gt_selopt ASSIGNING FIELD-SYMBOL(<fs_selopt>).
      IF <fs_selopt>-node_name CS '-'.
        "REPLACE ALL OCCURRENCES OF '-' IN <fs_selopt>-node_name WITH '_'.
        MESSAGE ID '/IWBEP/SBOD' TYPE 'E'
        NUMBER '165' WITH <fs_selopt>-node_name.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD top.

    APPEND TEXT-006                                                              TO ct_code.

    APPEND `IF io_tech_request_context->get_top( ) > 0.`                         TO ct_code.
    APPEND `  DELETE et_entityset FROM io_tech_request_context->get_top( ) + 1.` TO ct_code.
    APPEND `ENDIF.`                                                              TO ct_code.
    get_new_line( CHANGING ct_code = ct_code ).

  ENDMETHOD.


  METHOD validate_package.

    DATA lv_objname TYPE sobj_name.

*   Check if package name matches the project name
    lv_objname = iv_project_name.
    CALL FUNCTION 'TR_CHECK_RESERVED_NAME'
      EXPORTING
        wi_devclass              = iv_package
        wi_dialog                = abap_false
        wi_object                = /cadaxo/cl_sqlc_odata_gen=>c_object_type
        wi_objname               = lv_objname
        wi_pgmid                 = /cadaxo/cl_sqlc_odata_gen=>c_pgmid
      EXCEPTIONS
        tr_custobj_in_syst_class = 1
        tr_reserved_name         = 2
        tr_systobj_in_cust_class = 3
        OTHERS                   = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD validate_project_name.

    CHECK iv_project_name IS NOT INITIAL.

    SELECT SINGLE * FROM /iwbep/i_sbd_pr
      WHERE project = @iv_project_name
      INTO @DATA(ls_i_sbd_pr).
    IF sy-subrc EQ 0.
      MESSAGE ID '/IWBEP/SBDM' TYPE 'E'
      NUMBER '012' WITH iv_project_name.
    ENDIF.

  ENDMETHOD.


  METHOD restrict_proj_types.
    DATA lt_supported_proj_types TYPE vrm_values.

    lt_supported_proj_types = get_supported_proj_types(  ).

    set_dropdown_values( iv_dropdown_id = 'GS_REPORT_ATTR-ODATA_TYPE'
                         it_values      = lt_supported_proj_types ).
  ENDMETHOD.


  METHOD get_supported_proj_types.
    DATA lt_supported_types TYPE vrm_values.
    DATA ls_supported_type  TYPE vrm_value.

    LOOP AT get_existing_proj_types(  ) INTO DATA(ls_proj_type).

**     maybe unsupported on older SAP systems:
*      IF line_exists( gt_supported_odata_types[ table_line = ls_proj_type-domvalue_l ] ).
*        APPEND ls_supported_type TO lt_supported_types.
*      ENDIF.
      READ TABLE gt_supported_proj_types
        WITH KEY table_line = ls_proj_type-domvalue_l
        TRANSPORTING NO FIELDS.

      IF sy-subrc = 0.
        ls_supported_type-key  = ls_proj_type-domvalue_l.
        ls_supported_type-text = ls_proj_type-ddtext.

        APPEND ls_supported_type TO lt_supported_types.
      ENDIF.

    ENDLOOP.

    r_supported_proj_types = lt_supported_types.
  ENDMETHOD.


  METHOD get_existing_proj_types.
    DATA lt_proj_types TYPE TABLE OF dd07v.

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING domname   = '/IWBEP/SBDM_PROJECT_TYPE'
                text      = 'X'
      TABLES    dd07v_tab = lt_proj_types.

    r_existing_proj_types = lt_proj_types.
  ENDMETHOD.


  METHOD set_dropdown_values.
    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING id     = iv_dropdown_id
                values = it_values.
  ENDMETHOD.


  METHOD CLASS_CONSTRUCTOR.
    gt_supported_proj_types = VALUE #(
        ( /iwbep/if_sbdm_project=>gc_type_mpc_dpc_v2 )          " Service with SAP Annotations
        ( /iwbep/if_sbdm_project=>gc_type_mpc_dpc_v2_plus )     " Service with Vocabulary-Based Annotations
**       TODO annotation model for referenced service needs work during service generation
**          -> "access to node 00000000... is read only"
*        ( /iwbep/if_sbdm_project=>GC_TYPE_APC_REF_V2_PLUS )     "Annotation Model for Referenced Service
**       TODO odata v4 needs work during service generation
**          -> "unknown error"
*        ( /iwbep/if_sbdm_project=>GC_TYPE_MPC_DPC_V4 )          "OData 4.0 Service
      ).

  ENDMETHOD.
ENDCLASS.
