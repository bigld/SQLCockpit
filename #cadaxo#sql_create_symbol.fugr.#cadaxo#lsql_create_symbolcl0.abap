CLASS lcl_worker DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS leave_screen.
    CLASS-METHODS execute.
    CLASS-METHODS symbol_name_invalid RETURNING VALUE(invalid) TYPE abap_bool.
    CLASS-METHODS fill_symbol RETURNING VALUE(symbol_db_create) TYPE /cadaxo/sqlcusym.
    CLASS-METHODS show_list.
ENDCLASS.

CLASS lcl_worker IMPLEMENTATION.

  METHOD leave_screen.
    SET SCREEN 0. LEAVE SCREEN.
  ENDMETHOD.

  METHOD execute.

    DATA: cockpit_main        TYPE REF TO   /cadaxo/cl_sqlc_cockpit_main.
    DATA: lt_symbol_db_create TYPE TABLE OF /cadaxo/sqlcusym.

    IF  lcl_worker=>symbol_name_invalid( ) = abap_true.
      RETURN.
    ENDIF.

    DATA(symbol_db_create) = lcl_worker=>fill_symbol( ).
    APPEND symbol_db_create TO lt_symbol_db_create.

    cockpit_main = NEW #(  ).
    DATA(l_db_commit_cre) = cockpit_main->create_symbol_db( EXPORTING it_symbol_create = lt_symbol_db_create ).
    IF l_db_commit_cre IS NOT INITIAL.
      MESSAGE s056(/cadaxo/sqlc).
    ENDIF.

    SET SCREEN 0.

  ENDMETHOD.

  METHOD symbol_name_invalid.

    IF gv_symbol_name IS INITIAL.
      invalid = abap_true.
      MESSAGE i138(/cadaxo/sqlc).
    ELSE.
      SELECT SINGLE @abap_true FROM /cadaxo/sqlcusym INTO @invalid WHERE symbol_name = @gv_symbol_name AND username = @sy-uname.
      IF invalid = abap_true.
        MESSAGE i140(/cadaxo/sqlc).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD fill_symbol.

    symbol_db_create-symbol_name = gv_symbol_name.
    symbol_db_create-username    = sy-uname.
    symbol_db_create-symbol_desc = gv_symbol_desc.
    /cadaxo/cl_sqlc_cockpit_assist=>compress_symbol_multivalue( EXPORTING i_symbol_multivalue = gt_sel_data
                                                                IMPORTING e_data              = DATA(lv_data) ).
    symbol_db_create-symbol_multivalue = lv_data.
    symbol_db_create-symbol_datatype   = gv_rollname.

  ENDMETHOD.

  METHOD show_list.

    CALL FUNCTION 'COMPLEX_SELECTIONS_DIALOG'
      EXPORTING
        title             = text-001
        no_interval_check = abap_true
        just_display      = abap_true
      TABLES
        range             = gt_sel_data
      EXCEPTIONS
        no_range_tab      = 1
        cancelled         = 2
        internal_error    = 3
        invalid_fieldname = 4
        OTHERS            = 5.

  ENDMETHOD.


ENDCLASS.
