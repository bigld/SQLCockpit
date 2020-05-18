class /CADAXO/CL_SQLC_UPTOMENU definition
  public
  final
  create public

  global friends /CADAXO/CL_SQLC_COCKPIT_MAIN .

public section.

  constants C_CMD_SET_UPTO type UI_FUNC value 'SETUPTO' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !IV_USER_SETTING type I .
  methods ON_USERSETTINGS_CHANGED
    for event SETTINGS_CHANGED_UPTO of /CADAXO/CL_SQLC_COCKPIT_MAIN
    importing
      !i_NEW_UPTO .
  PROTECTED SECTION.
    TYPES: BEGIN OF tys_row_number_table,
             cmd_suffix TYPE char2,
             rows       TYPE i,
             text       TYPE string,
           END OF tys_row_number_table,
           tyt_row_number_table TYPE STANDARD TABLE OF tys_row_number_table WITH KEY cmd_suffix.

    DATA: mt_row_commands TYPE tyt_row_number_table.
    DATA: mr_toolbar      TYPE REF TO cl_gui_toolbar.
    DATA: mv_cust_suffix  TYPE char2.

    METHODS get_toolbar_function  IMPORTING ir_toolbar                TYPE REF TO cl_gui_toolbar
                                  RETURNING VALUE(et_toolbar_buttons) TYPE ttb_button .
    METHODS set_static_menu.
    METHODS on_user_command IMPORTING iv_fcode         TYPE ui_func
                            CHANGING  es_user_settings TYPE /cadaxo/sqlcusrp_xml OPTIONAL.
private section.

  constants C_SUFFIX_USERSEL type CHAR2 value '_S' ##NO_TEXT.
  constants C_SUFFIX_USERVALUE type CHAR2 value '_U' ##NO_TEXT.
  constants C_SUFFIX_CUSTOMIZING type CHAR2 value '_C' ##NO_TEXT.
  constants C_SUFFIX_ONE type CHAR2 value '_O' ##NO_TEXT.
  constants C_SUFFIX_500 type CHAR2 value '_F' ##NO_TEXT.
  constants C_SUFFIX_1000 type CHAR2 value '_T' ##NO_TEXT.
  constants C_SUFFIX_ALL type CHAR2 value '_0' ##NO_TEXT.

  methods _GET_VALUE_FROM_USER
    returning
      value(EV_ROWS) type I .
  methods _CREATE_TEXT
    importing
      !IS_ROW_COMMAND type TYS_ROW_NUMBER_TABLE
    returning
      value(EV_TEXT) type GUI_TEXT .
ENDCLASS.



CLASS /CADAXO/CL_SQLC_UPTOMENU IMPLEMENTATION.


  METHOD constructor.

    mt_row_commands = VALUE #( ( cmd_suffix = c_suffix_one     rows = '1' )
                               ( cmd_suffix = c_suffix_500     rows = '500' )
                               ( cmd_suffix = c_suffix_1000    rows = '1000' )
                               ( cmd_suffix = c_suffix_all     rows = '0'    text = text-all )
                               ( cmd_suffix = c_suffix_usersel rows = '0'    text = text-utc )
                             ).

    IF line_exists( mt_row_commands[ rows = iv_user_setting ] ).

      mv_cust_suffix =  mt_row_commands[ rows = iv_user_setting ]-cmd_suffix.

    ELSE.

      INSERT VALUE #( cmd_suffix = c_suffix_customizing rows = iv_user_setting text = iv_user_setting )
             INTO mt_row_commands INDEX 1.

      mv_cust_suffix = c_suffix_customizing.

    ENDIF.

  ENDMETHOD.


  METHOD get_toolbar_function.

    IF ir_toolbar IS NOT INITIAL.

      mr_toolbar = ir_toolbar.

      APPEND VALUE #( function  = c_cmd_set_upto
                      text      = text-utt && ` ` && _create_text( mt_row_commands[ cmd_suffix = mv_cust_suffix ] )
                      quickinfo = text-utt
                      butn_type = cntb_btype_menu ) TO et_toolbar_buttons.

    ENDIF.

  ENDMETHOD.


  METHOD on_usersettings_changed.

    IF line_exists( mt_row_commands[ rows = i_new_upto ] ).

      ASSIGN mt_row_commands[ rows = i_new_upto ] TO FIELD-SYMBOL(<row_command>).

      DELETE mt_row_commands WHERE cmd_suffix  = c_suffix_customizing
                               AND rows       <> i_new_upto.

      mr_toolbar->set_button_info( EXPORTING  fcode  = c_cmd_set_upto
                                              text   = text-utt && ` ` && _create_text( <row_command> )
                                   EXCEPTIONS OTHERS = 3 ).

    ELSEIF line_exists( mt_row_commands[ cmd_suffix = c_suffix_customizing ] ).

      ASSIGN mt_row_commands[ cmd_suffix = c_suffix_customizing ] TO <row_command>.
      <row_command>-rows = i_new_upto.
      <row_command>-text = i_new_upto.

      mr_toolbar->set_button_info( EXPORTING  fcode  = c_cmd_set_upto
                                              text   = text-utt && ` ` && _create_text( <row_command> )
                                   EXCEPTIONS OTHERS = 3 ).

    ELSE.

      INSERT VALUE #( cmd_suffix = c_suffix_customizing rows = i_new_upto text = i_new_upto )
             INTO mt_row_commands INDEX 1 ASSIGNING <row_command>.

    ENDIF.

    set_static_menu( ).

    IF mv_cust_suffix = <row_command>-cmd_suffix.

      mr_toolbar->set_button_info( EXPORTING  fcode  = c_cmd_set_upto
                                              text   = text-utt && ` ` && _create_text( <row_command> )
                                   EXCEPTIONS OTHERS = 3 ).

    ENDIF.

  ENDMETHOD.


  METHOD on_user_command.
*------------+----------------------+-------------------------------------------------+------------*
* 04.02.2019 | Pratik Patil         | shifted endtry to ensure no updates to button   | COCKPIT-354*
*                                     when user cancels upto rows manual pop-up       |            *
****************************************************************************************************


    DATA(lv_suffix) = replace( val = iv_fcode sub = c_cmd_set_upto with = '' ).

    ASSIGN mt_row_commands[ cmd_suffix = lv_suffix ] TO FIELD-SYMBOL(<row_command>).

    TRY.

        IF <row_command>-cmd_suffix = c_suffix_usersel.

          IF NOT line_exists( mt_row_commands[ cmd_suffix = c_suffix_uservalue  ] ).

            APPEND VALUE #( cmd_suffix = c_suffix_uservalue ) TO mt_row_commands ASSIGNING <row_command>.

          ELSE.

            ASSIGN mt_row_commands[ cmd_suffix = c_suffix_uservalue ] TO <row_command>.

          ENDIF.
          <row_command>-rows = es_user_settings-maxsel = _get_value_from_user( ).

          <row_command>-text = <row_command>-rows.

          IF <row_command>-rows = 0.
            ASSIGN mt_row_commands[ cmd_suffix = c_suffix_all ] TO <row_command>.
          ENDIF.

          set_static_menu( ).

        ELSE.
          es_user_settings-maxsel = <row_command>-rows.
        ENDIF.

        mr_toolbar->set_button_info( EXPORTING  fcode  = c_cmd_set_upto
                                                text   = text-utt && ` ` && _create_text( <row_command> )
                                     EXCEPTIONS OTHERS = 3 ).

        mv_cust_suffix = <row_command>-cmd_suffix.

      CATCH /cadaxo/cx_sqlc_cockpit_assist.
    ENDTRY.

  ENDMETHOD.


  METHOD set_static_menu.


    DATA(lr_ctmenu) = NEW cl_ctmenu( ).

    LOOP AT mt_row_commands ASSIGNING FIELD-SYMBOL(<ls_row_commands>).

      lr_ctmenu->add_function( EXPORTING fcode = c_cmd_set_upto && <ls_row_commands>-cmd_suffix
                                         text  = _create_text( <ls_row_commands> ) ).
    ENDLOOP.

    mr_toolbar->set_static_ctxmenu( EXPORTING fcode = c_cmd_set_upto ctxmenu = lr_ctmenu ).

  ENDMETHOD.


  METHOD _create_text.

    ev_text = COND #( WHEN is_row_command-text IS INITIAL
                      THEN shift_left( CONV gui_text( is_row_command-rows ) )
                      ELSE is_row_command-text ).

  ENDMETHOD.


  METHOD _get_value_from_user.
    CONSTANTS lc_rc_abort TYPE string VALUE 'A' ##NO_TEXT.
    DATA: lt_fields           TYPE TABLE OF sval.
    DATA: lv_rc TYPE char1.

    APPEND VALUE #( tabname = '/CADAXO/SQLCUSRP_DYN'
                    fieldname = 'MAXSEL'
                    fieldtext = text-mxp ) TO lt_fields.

    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
        popup_title = text-mxp
      IMPORTING
        returncode  = lv_rc
      TABLES
        fields      = lt_fields
      EXCEPTIONS
        OTHERS      = 2.
    IF sy-subrc = 0.
      IF lv_rc = lc_rc_abort.
        MESSAGE s042(/cadaxo/sqlc).
*   Canceled by user
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_cockpit_assist.
      ELSE.
        ASSIGN lt_fields[ 1 ] TO FIELD-SYMBOL(<ls_fields>).
        IF sy-subrc = 0.

          ev_rows = <ls_fields>-value.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
