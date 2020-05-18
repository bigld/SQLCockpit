*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCDYNSYMBOLSI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'CANC'.

      clear g_symbol_name.

      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'OK'.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
