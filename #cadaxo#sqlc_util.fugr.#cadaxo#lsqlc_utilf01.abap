*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_UTILF01.
*----------------------------------------------------------------------*
FORM leave_screen .

  IF gc_value_textarea IS BOUND.
    gc_value_textarea->free( ).
    gcont_value_textarea->free( ).
    free gc_value_textarea.
    free gcont_value_textarea.
  ENDIF.
  SET SCREEN 0.
  LEAVE SCREEN.
ENDFORM.
FORM pai_0100_form .
  DATA: lr_data TYPE REF TO data.

  CASE gv_code.
    WHEN gc_ok_code.

      gc_value_textarea->get_textstream( EXPORTING only_when_modified = gc_true
                                         IMPORTING text               = gv_value
                                                   is_modified        = DATA(lv_modified) ).
      cl_gui_cfw=>flush( ).

      IF lv_modified = gc_true.
        gv_changed = abap_true.
        CREATE DATA lr_data TYPE HANDLE gr_datadescr.
        ASSIGN lr_data->* TO FIELD-SYMBOL(<lv_data>).
        <lv_data> = gv_value.
        IF gv_value <> <lv_data>.
          MESSAGE e133(/cadaxo/sqlc).
        ELSE.
          PERFORM leave_screen.
        ENDIF.
      ELSE.
        PERFORM leave_screen.
      ENDIF.

    WHEN gc_cancl_code.
      PERFORM leave_screen.
  ENDCASE.

  CLEAR gv_code.
ENDFORM.
FORM pbo_0100_form .
  IF ( gv_edit = abap_true ).
    SET PF-STATUS 'MAIN_0100'.
  ELSE.
    SET PF-STATUS 'MAIN_0100' EXCLUDING gc_ok_code.
  ENDIF.

  SET TITLEBAR '0100'.

  gcont_value_textarea = NEW #( container_name = 'GCONT_VALUE_TEXTAREA' ).
  gc_value_textarea = NEW #( parent = gcont_value_textarea ).
  gc_value_textarea->set_toolbar_mode( toolbar_mode = gc_false ).

  IF gv_edit = abap_false.
    gc_value_textarea->set_readonly_mode( readonly_mode = gc_true ).
  ENDIF.

  gc_value_textarea->set_textstream( text = gv_value ).
ENDFORM.
