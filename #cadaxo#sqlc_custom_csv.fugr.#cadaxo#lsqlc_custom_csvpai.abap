*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_CUSTOM_CSVPAI.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PAI_0500  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0500 INPUT.

  CASE abap_true.
    WHEN rad_separated_by_tab.
      MOVE 'TAB' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_comma.
      MOVE 'COMMA' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_semicolon.
      MOVE 'SEMICOLON' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_space.
      MOVE 'SPACE' TO g_csv_attr-field_separator.
    WHEN rad_separated_by_other.
      MOVE 'OTHER' TO g_csv_attr-field_separator.
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

ENDMODULE.                              " USER_COMMAND_0500  INPUT
