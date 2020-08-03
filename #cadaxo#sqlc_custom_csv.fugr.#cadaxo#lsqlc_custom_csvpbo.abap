*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_CUSTOM_CSVPBO.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PBO_0500  OUTPUT
*&---------------------------------------------------------------------*
*       csv custom selections
*----------------------------------------------------------------------*
MODULE pbo_0500 OUTPUT.

  SET PF-STATUS '0500'.
  SET TITLEBAR '0500'.

  CLEAR: g_cancel.
  CLEAR: rad_separated_by_tab, rad_separated_by_comma,
         rad_separated_by_semicolon, rad_separated_by_space,
         rad_separated_by_other.

  IF g_csv_attr IS INITIAL.
    g_csv_attr-add_header = abap_true.
    g_csv_attr-field_separator = 'SEMICOLON'.
    g_csv_attr-date_format = '06'.
    g_csv_attr-time_format = '02'.
  ENDIF.

  CASE g_csv_attr-field_separator.
    WHEN 'TAB'.
      MOVE 'X' TO rad_separated_by_tab.
    WHEN 'COMMA'.
      MOVE 'X' TO rad_separated_by_comma.
    WHEN 'SEMICOLON'.
      MOVE 'X' TO rad_separated_by_semicolon.
    WHEN 'SPACE'.
      MOVE 'X' TO rad_separated_by_space.
    WHEN 'OTHER'.
      MOVE 'X' TO rad_separated_by_other.
  ENDCASE.

  IF rad_separated_by_other = abap_false.
    CLEAR g_csv_attr-field_separator_other.
  ENDIF.

ENDMODULE.
