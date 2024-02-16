*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_CDS_VIEWSO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_0100 output.
  DATA lt_string TYPE TABLE OF string.

  SET PF-STATUS 'MAIN_0100'.
  SET TITLEBAR 'TIT'.

  IF gr_container IS INITIAL.
    CREATE OBJECT gr_container EXPORTING container_name = 'CC_DDL'.
    CREATE OBJECT gr_ddl EXPORTING parent = gr_container.

    gr_ddl->set_statusbar_mode( statusbar_mode = 0 ).
    gr_ddl->set_limit_text( 255 ).
    gr_ddl->set_readonly_mode( 1 ).

    SPLIT gs_ddddlsrcv-source AT cl_abap_char_utilities=>cr_lf INTO TABLE lt_string.

    gr_ddl->set_text( lt_string ).

  ENDIF.
endmodule.
