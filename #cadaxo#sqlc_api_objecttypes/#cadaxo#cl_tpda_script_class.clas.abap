CLASS /cadaxo/cl_tpda_script_class DEFINITION  INHERITING FROM  cl_tpda_script_class_super
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: prologue  REDEFINITION,
      init    REDEFINITION,
      script  REDEFINITION,
      end     REDEFINITION.
    CONSTANTS: BEGIN OF token_type,
                 "FM RS_GET_TOKEN_TYPE_LONG_TEXT
                 keyword   TYPE token_type VALUE 'c' ##NO_TEXT,
                 word      TYPE token_type VALUE 'b' ##NO_TEXT,
                 field     TYPE token_type VALUE 'm' ##NO_TEXT,
                 type      TYPE token_type VALUE 'l' ##NO_TEXT,
                 component TYPE token_type VALUE 'o' ##NO_TEXT,
                 implizit  TYPE token_type VALUE 'I' ##NO_TEXT,
               END OF token_type.
    CLASS-METHODS get_field_symbols IMPORTING i_select_tokens  TYPE sana_stokesx_tab
                                              i_trace          TYPE REF TO if_tpda_script_trace_write OPTIONAL
                                    RETURNING VALUE(e_symbols) TYPE /cadaxo/sqlc_symbol_t.
    CLASS-METHODS get_cockpit_sql IMPORTING i_select_tokens TYPE sana_stokesx_tab
                                  EXPORTING e_cockpit_sql   TYPE string
                                            e_into_clause   TYPE string .
ENDCLASS.



CLASS /cadaxo/cl_tpda_script_class IMPLEMENTATION.
  METHOD prologue.
    super->prologue( ).
  ENDMETHOD.
  METHOD init.
    super->init( ).
  ENDMETHOD.
  METHOD script.
    DATA scan_object TYPE REF TO /cadaxo/cl_tpda_scriptscan_sel.

    FREE scan_object.

    scan_object ?= /cadaxo/cl_tpda_script_scan=>scan( p_program     = abap_source->program( )
                                                      p_include     = abap_source->include( )
                                                      p_line        = abap_source->line( ) ).

    scan_object->get_select_tokens( IMPORTING e_tokens = DATA(select_tokens) ).

    DATA(symbols) = me->get_field_symbols( EXPORTING i_select_tokens = select_tokens
                                                     i_trace         = trace ).

    DATA(cockpit_api) = /cadaxo/cl_sqlc_cockpit_api=>create_share_factory(
      EXPORTING iv_description  = abap_source->program( ) && | { sy-datum DATE = USER } { sy-uzeit TIME = USER }|
                iv_sender       = CONV #( cl_abap_syst=>get_user_name( ) )
                iv_sender_typ   = /cadaxo/cl_sqlc_cockpit_api=>sender_typ-user
                iv_receiver     = CONV #( cl_abap_syst=>get_user_name( ) )
                iv_receiver_typ = /cadaxo/cl_sqlc_cockpit_api=>sender_typ-user ).

    me->get_cockpit_sql( EXPORTING i_select_tokens = select_tokens
                         IMPORTING e_cockpit_sql = DATA(sql_string)
                                   e_into_clause = DATA(into_string) ).
    cockpit_api->add_item( EXPORTING iv_typ = cockpit_api->cs_api_types-sql iv_data = VALUE /cadaxo/sqlccodeline_t( ( sql_string && |. "<{ into_string }>| ) ) ).
    cockpit_api->add_item( EXPORTING iv_typ = cockpit_api->cs_api_types-symbols iv_data = symbols ).
    MESSAGE 'SELECT statement exported to SQL Cockpit' TYPE 'S'.

  ENDMETHOD.


  METHOD get_cockpit_sql.

    DATA in_into_clause TYPE flag.
    DATA previous_token TYPE string.

    LOOP AT i_select_tokens ASSIGNING FIELD-SYMBOL(<token>).

      IF <token>-str = 'INTO' AND <token>-type = token_type-word.
        in_into_clause = abap_true.
      ENDIF.

      IF in_into_clause = abap_true.

        e_into_clause = e_into_clause && | | && <token>-str.

        IF ( <token>-type   = token_type-field OR
             <token>-type   = token_type-implizit ) AND
           ( <token>-str    <> 'OF' OR
             previous_token <> 'FIELDS' ).
          in_into_clause = abap_false.
        ENDIF.

      ELSE.

        IF <token>-type = token_type-field and <token>-str+0(1) cn '''`´'.
          e_cockpit_sql = e_cockpit_sql && | | && '&DGB_' && <token>-str && '&'.
        ELSE.
          e_cockpit_sql = e_cockpit_sql && | | && <token>-str.
        ENDIF.
      ENDIF.

      previous_token = <token>-str.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_field_symbols.

    LOOP AT i_select_tokens ASSIGNING FIELD-SYMBOL(<variable_token>) WHERE type = token_type-field.
      TRY.

          DATA(info) = cl_tpda_script_data_descr=>get_variable_info( p_var_name = <variable_token>-str ).
          DATA(value) = cl_tpda_script_data_descr=>get_simple_value( EXPORTING p_var_name  = <variable_token>-str ).

          IF i_trace IS BOUND.
            i_trace->add_custom_info( EXPORTING p_trace_entry = VALUE #( type  = 'VAR_INFO-VARTYPE'
                                                                         id    = <variable_token>-str
                                                                         value = info-vartype ) ).
            i_trace->add_custom_info( EXPORTING p_trace_entry = VALUE #( type  = 'VAR_INFO-VARABSTYPENAME'
                                                                         id    = <variable_token>-str
                                                                         value = info-varabstypename ) ).


            i_trace->add_custom_info( EXPORTING p_trace_entry = VALUE #( type  = 'VAR_VALUE'
                                                                         id    = <variable_token>-str
                                                                         value = value ) ).
          ENDIF.

          INSERT VALUE #( symbol_name = 'DGB_' && <variable_token>-str symbol_value = value ) INTO TABLE e_symbols.
        CATCH cx_tpda_varname .
          IF i_trace IS BOUND.
            i_trace->add_custom_info( EXPORTING p_trace_entry = VALUE #( type  = 'VAR_NAME_EXCEPTION'
                                                                 id    = <variable_token>-str
                                                                 value = <variable_token>-str ) ).
          ENDIF.
        CATCH cx_tpda_script_no_simple_type .

          TRY.
              DATA(table_descr) = CAST cl_tpda_script_tabledescr( cl_tpda_script_data_descr=>factory( p_var_name = replace( val = <variable_token>-str
                                                                                                                            sub = '@' with = '' ) ) ).
              table_descr->content( IMPORTING p_it_comp_val = DATA(table_datas) ).
              LOOP AT table_datas ASSIGNING FIELD-SYMBOL(<table_data>).
                LOOP AT <table_data>-fields ASSIGNING FIELD-SYMBOL(<field>).
                  IF i_trace IS BOUND.
                    i_trace->add_custom_info( EXPORTING p_trace_entry = VALUE #( type  = 'Komplex Var'
                                                                                 id    = <variable_token>-str && <field>
                                                                                 value = info-varabstypename ) ).
                  ENDIF.
                ENDLOOP.
              ENDLOOP.
            CATCH cx_tpda_varname .
            CATCH cx_tpda_data_descr_invalidated .
          ENDTRY.

      ENDTRY.
    ENDLOOP.

  ENDMETHOD.
  METHOD end.
    super->end( ).
  ENDMETHOD.
ENDCLASS.
