*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_ODATAI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA: l_index  TYPE i.
  DATA: l_answer TYPE c.

  CASE ok_code.
    WHEN 'CANCEL'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = text-p06
          text_question         = text-p07
          text_button_1         = text-p08
          icon_button_1         = 'ICON_CHECKED'
          text_button_2         = text-p09
          icon_button_2         = 'ICON_INCOMPLETE'
          default_button        = '2'
          display_cancel_button = ''
          popup_type            = 'ICON_MESSAGE_ERROR'
        IMPORTING
          answer                = l_answer.
      IF l_answer = 1.
        PERFORM delete_cc.
        RAISE cancel_by_user.
      ENDIF.
    WHEN 'COMPLETE'.
      go_odata_wiz->validate_project_name(
        EXPORTING
          iv_project_name = gs_report_attr-project_name ).
      go_odata_wiz->special_character_check( ).
      PERFORM delete_cc.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'NEXTSTEP'.
      l_index = g_current_step_index.
      DO g_total_steps TIMES.
        l_index = l_index + 1.
        READ TABLE gt_roadmap INDEX l_index ASSIGNING <gs_roadmap>.
        IF sy-subrc EQ 0 AND NOT <gs_roadmap>-step_visible IS INITIAL.
          <gs_roadmap>-step_active = 'X'.
          g_current_step = <gs_roadmap>-step_id.
          EXIT.
        ENDIF.
      ENDDO.
    WHEN 'PREVSTEP'.
      l_index = g_current_step_index.
      DO g_total_steps TIMES.
        l_index = l_index - 1.
        READ TABLE gt_roadmap INDEX l_index ASSIGNING <gs_roadmap>.
        IF sy-subrc EQ 0 AND NOT <gs_roadmap>-step_visible IS INITIAL.
          g_current_step = <gs_roadmap>-step_id.
          EXIT.
        ENDIF.
      ENDDO.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CREATE_PROJECT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_input INPUT.

  go_odata_wiz->set_input( gs_report_attr ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  KEY_PROPERTY  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE key_property INPUT.

  go_odata_wiz->key_property_check( gs_report_attr ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0100 INPUT.
  FIELD-SYMBOLS: <fs_swcont> TYPE swcont.

  build_symbols project_name gs_report_attr-project_name.
  build_symbols package      gs_report_attr-package.
  build_symbols entity       gs_report_attr-entity.
  build_symbols entity_set   gs_report_attr-entity_set.
  build_symbols odata_type   gs_report_attr-odata_type.
  build_symbols regser       gs_report_attr-regser.
  build_symbols filter       gs_report_attr-filter.
  build_symbols order        gs_report_attr-order.
  build_symbols top          gs_report_attr-top.
  build_symbols skip         gs_report_attr-skip.
  build_symbols count        gs_report_attr-count.

ENDMODULE.
