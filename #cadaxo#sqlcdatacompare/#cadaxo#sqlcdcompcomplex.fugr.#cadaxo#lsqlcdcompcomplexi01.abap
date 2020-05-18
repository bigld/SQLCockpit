*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCDCOMPCOMPLEXI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PAI_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0100 INPUT.

  CASE g_ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'LEAVE'.

      g_controller->free( ).
      FREE g_controller.

      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'MAPPING'.
      g_subscreen = '0200'.
      g_controller->free_results( ).
    WHEN 'DOCHECK'.
      g_subscreen = '0300'.
      g_controller->do_check( ).
    WHEN OTHERS.
      g_controller->pai_0100( i_ok_code = g_ok_code ).
  ENDCASE.

ENDMODULE.
