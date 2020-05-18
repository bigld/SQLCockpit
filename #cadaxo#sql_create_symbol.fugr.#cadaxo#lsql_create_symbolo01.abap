*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCSHAREO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PBO_3001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_3001 OUTPUT.

  SET PF-STATUS 'MAIN_3001'.
  SET TITLEBAR '3001'.

ENDMODULE.

MODULE pai_3001 INPUT.

  CASE g_ok_code.

    WHEN 'CREATE'.
      lcl_worker=>execute( ).

    WHEN 'CANCEL'.
      lcl_worker=>leave_screen( ).

    WHEN 'LIST'.
      lcl_worker=>show_list( ).

  ENDCASE.

  CLEAR g_ok_code.

ENDMODULE.
