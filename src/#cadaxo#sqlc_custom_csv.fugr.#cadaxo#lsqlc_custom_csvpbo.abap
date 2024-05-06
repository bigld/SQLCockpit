*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_CUSTOM_CSVPBO.
*----------------------------------------------------------------------*
MODULE pbo_0500 OUTPUT.

  SET PF-STATUS '0500'.
  SET TITLEBAR '0500'.

  CASE g_csv_attr-field_separator.
    WHEN 'TAB'.
      rad_separated_by-tab = abap_true.
    WHEN 'COMMA'.
      rad_separated_by-comma = abap_true.
    WHEN 'SEMICOLON'.
      rad_separated_by-semicolon = abap_true.
    WHEN 'SPACE'.
      rad_separated_by-whitespace = abap_true.
    WHEN 'OTHER'.
      rad_separated_by-other = abap_true.
  ENDCASE.

  IF rad_separated_by-other = abap_false.
    CLEAR g_csv_attr-field_separator_other.
  ENDIF.

  IF appserver = abap_false.
    LOOP AT SCREEN.
      IF screen-group4 = 'BEP'. "Back End Path
        screen-invisible = 1.
        screen-active    = 0.
        screen-output    = 0.
        screen-required  = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDMODULE.
