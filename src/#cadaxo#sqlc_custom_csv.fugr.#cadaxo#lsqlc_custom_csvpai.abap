*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_CUSTOM_CSVPAI.
*----------------------------------------------------------------------*
MODULE pai_0500 INPUT.

  CASE abap_true.
    WHEN rad_separated_by-tab.
      g_csv_attr-field_separator = 'TAB'.
    WHEN rad_separated_by-comma.
      g_csv_attr-field_separator = 'COMMA'.
    WHEN rad_separated_by-semicolon.
      g_csv_attr-field_separator = 'SEMICOLON'.
    WHEN rad_separated_by-whitespace.
      g_csv_attr-field_separator = 'SPACE'.
    WHEN rad_separated_by-other.
      g_csv_attr-field_separator = 'OTHER'.
  ENDCASE.


ENDMODULE.

MODULE user_command_0500 INPUT.

  CASE g_ok_code.
    WHEN 'APPLY'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'CANCEL'.
      g_cancel = abap_true.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.

ENDMODULE.
MODULE check_file INPUT.
  IF appserver = abap_true AND g_csv_attr-file_path IS NOT INITIAL AND g_csv_attr-file_name IS NOT INITIAL.

    CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
      EXPORTING
        logical_path        = g_csv_attr-file_path
        file_name           = g_csv_attr-file_name
      IMPORTING
        file_name_with_path = dataset
      EXCEPTIONS
        OTHERS              = 1.
    IF sy-subrc <> 0.
      CLEAR dataset.
      MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      OPEN DATASET dataset FOR OUTPUT IN TEXT MODE ENCODING UTF-8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      CLOSE DATASET dataset.
      g_csv_attr-file_full = dataset.
    ENDIF.
  ENDIF.
ENDMODULE.
