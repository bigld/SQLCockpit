*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCDYNSYMBOLSO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'MAIN_0100'.
  SET TITLEBAR '0100'.
ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  CREATE_CONTROLS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_controls OUTPUT.
  DATA: ls_layout TYPE lvc_s_layo.

  IF gr_cc_alv_sym IS INITIAL.

    CREATE OBJECT gr_cc_alv_sym
      EXPORTING
        container_name = 'GR_CC_ALV_SYM'.

    CREATE OBJECT gr_alv_grid
      EXPORTING
        i_parent = gr_cc_alv_sym.

    SELECT * FROM /cadaxo/sqlcsymb INTO CORRESPONDING FIELDS OF TABLE gt_dynamic_symbols.

    MOVE 'X' TO ls_layout-zebra.
    MOVE 'X' TO ls_layout-no_toolbar.

    CALL METHOD gr_alv_grid->set_table_for_first_display
      EXPORTING
        i_bypassing_buffer            = 'X'
         i_structure_name              = '/CADAXO/SQLCSYMB_ALV'
*        i_default                     = 'X'
        is_layout                     = ls_layout
      CHANGING
        it_outtab                     = gt_dynamic_symbols.

    CREATE OBJECT lr_event_receiver.
    SET HANDLER lr_event_receiver->handle_double_click FOR gr_alv_grid.

  ENDIF.

  CALL METHOD cl_gui_control=>set_focus
    EXPORTING
      control = gr_alv_grid.
  CALL METHOD cl_gui_cfw=>flush.

ENDMODULE.                 " CREATE_CONTROLS  OUTPUT
