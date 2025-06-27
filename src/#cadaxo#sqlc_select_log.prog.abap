REPORT /cadaxo/sqlc_select_log.
INCLUDE /cadaxo/sqlc_select_log_c01.



DATA selected_user    TYPE /cadaxo/sqlclog-uname.
DATA output_table     TYPE TABLE OF /cadaxo/sqlclog.
DATA output_table_alv TYPE TABLE OF /cadaxo/sqlclogalv.
DATA select_params    TYPE /cadaxo/sqlclogalv.
DATA alv_layout       TYPE slis_layout_alv.


SELECTION-SCREEN BEGIN OF BLOCK sel WITH FRAME TITLE TEXT-t01.
  SELECTION-SCREEN ULINE.
  SELECT-OPTIONS: sel_user FOR select_params-uname DEFAULT sy-uname,
                  sel_date FOR select_params-execute_date NO-EXTENSION.
  SELECTION-SCREEN ULINE.

  SELECT-OPTIONS: sel_runt FOR select_params-result_runtime,
                  sel_rows FOR select_params-result_rows.
SELECTION-SCREEN END OF BLOCK sel.



INITIALIZATION.
  DATA(options_list) = VALUE sscr_opt_list_tab( ( name       = 'DateRes'
                                                  options-eq = abap_true
                                                  options-bt = abap_true
                                                  options-ge = abap_true
                                                  options-le = abap_true
                                                  options-cp = abap_false
                                                  options-gt = abap_false
                                                  options-lt = abap_false
                                                  options-nb = abap_false
                                                  options-ne = abap_false
                                                  options-np = abap_false ) ).

  DATA(assignment) = VALUE sscr_ass_tab( ( kind    = 'S'
                                           name    = 'SEL_DATE'
                                           sg_main = 'I'
                                           op_main = 'DateRes' ) ).
  DATA(restrictions) = VALUE sscr_restrict( opt_list_tab = options_list
                                            ass_tab      = assignment ).

  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
               restriction            = restrictions
    EXCEPTIONS too_late               = 1
               repeated               = 2
               selopt_without_options = 3
               selopt_without_signs   = 4
               invalid_sign           = 5
               empty_option_list      = 6
               invalid_kind           = 7
               repeated_kind_a        = 8
               OTHERS                 = 9.
  IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


START-OF-SELECTION.

  TRY.
      NEW lcl_local_runner( )->run( i_username = sel_user[] i_dates = sel_date[] i_runtime = sel_runt[] i_rows = sel_rows[] ).
    CATCH cx_salv_msg INTO DATA(e1).
      WRITE: / 'Error (ALV):', e1->get_text( ).
    CATCH cx_parameter_invalid_range INTO DATA(e2).
      WRITE: / 'Error (Parameter):', e2->get_text( ).
    CATCH cx_sy_buffer_overflow INTO DATA(e3).
      WRITE: / 'Error (Buffer Overflow):', e3->get_text( ).
    CATCH cx_sy_conversion_codepage INTO DATA(e4).
      WRITE: / 'Error (Codepage Conversion):', e4->get_text( ).
    CATCH cx_sy_compression_error INTO DATA(e5).
      WRITE: / 'Error (Compression):', e5->get_text( ).
  ENDTRY.
