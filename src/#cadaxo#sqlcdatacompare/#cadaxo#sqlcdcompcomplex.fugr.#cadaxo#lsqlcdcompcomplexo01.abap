*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCDCOMPCOMPLEXO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.
  DATA lt_exclude TYPE TABLE OF sy-ucomm.

  CLEAR lt_exclude.

  CASE g_subscreen.
    WHEN '0200'.
      IF g_controller->gv_keys_unique = abap_false.
        APPEND 'DOCHECK' TO lt_exclude.
      ENDIF.
      SET TITLEBAR '0100'.
      SET PF-STATUS '0100' EXCLUDING lt_exclude.
    WHEN '0300'.
      SET TITLEBAR '0100_0300'.
      SET PF-STATUS '0100_0300' EXCLUDING lt_exclude.
  ENDCASE.

  g_controller->pbo_0100( ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0200 OUTPUT.

  g_controller->pbo_0200( ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_0300  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0300 OUTPUT.

  g_controller->pbo_0300( ).

ENDMODULE.
