*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCTIPPSANDTRICKSI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE gv_code.
    WHEN 'CANCEL'.
      RAISE cancel_by_user.
    WHEN 'OK'.
    WHEN 'ONCE'.
      gv_release_type = /cadaxo/cl_sqlc_cockpit_main=>c_release_type_once.
  ENDCASE.
  SET SCREEN 0.
  LEAVE SCREEN.
ENDMODULE.
