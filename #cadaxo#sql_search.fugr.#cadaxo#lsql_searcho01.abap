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
    WHEN 'SEARCH'.
      lcl_worker=>execute_search( ).

    WHEN 'CANCEL'.
      lcl_worker=>leave_screen( ).
  ENDCASE.

  CLEAR g_ok_code.

ENDMODULE.
