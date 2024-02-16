*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCDATESELECTI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE g_ok_code.
    WHEN 'CANCEL'.
      RAISE cancel_by_user.
    WHEN 'CONTINUE'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'ENTER'. "CDX130-013
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0100 INPUT.
  IF /cadaxo/sqlcdateselfromto-date_to < /cadaxo/sqlcdateselfromto-date_from
     OR ( /cadaxo/sqlcdateselfromto-date_to EQ /cadaxo/sqlcdateselfromto-date_from
       AND /cadaxo/sqlcdateselfromto-time_to < /cadaxo/sqlcdateselfromto-time_from ).
    MESSAGE e064(/cadaxo/sqlc).
  ENDIF.
ENDMODULE.                 " PAI_0100  INPUT
