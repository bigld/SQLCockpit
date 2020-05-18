*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_CDS_VIEWSI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA lr_http_client TYPE REF TO if_http_client.

  CASE g_okcode.
    WHEN 'CANCEL'.
      gr_ddl->free( ).
      FREE gr_ddl.
      gr_container->free( ).
      FREE gr_container.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'CONTINUE'.
      gr_ddl->free( ).
      FREE gr_ddl.
      gr_container->free( ).
      FREE gr_container.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'OPEN_ADT'.
      cl_gui_frontend_services=>execute(
        EXPORTING
          document = g_adt_link
        EXCEPTIONS
          OTHERS   = 1 ).
  ENDCASE.

ENDMODULE.
