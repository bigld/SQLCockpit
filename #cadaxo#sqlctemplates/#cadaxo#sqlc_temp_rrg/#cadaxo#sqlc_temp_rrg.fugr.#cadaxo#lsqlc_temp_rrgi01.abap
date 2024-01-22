*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_RRGI01.
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
          titlebar              = TEXT-p06
          text_question         = TEXT-p07
          text_button_1         = TEXT-p08
          icon_button_1         = 'ICON_CHECKED'
          text_button_2         = TEXT-p09
          icon_button_2         = 'ICON_INCOMPLETE'
          default_button        = '2'
          display_cancel_button = ''
          popup_type            = 'ICON_MESSAGE_ERROR'
        IMPORTING
          answer                = l_answer.
      IF l_answer = 1.
        "   PERFORM delete_cc.
        RAISE cancel_by_user.
      ENDIF.
    WHEN 'LEAVE'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'COMPLETE'.

      go_rrg_wiz->gs_temp_attr = gs_temp_attr.
      go_rrg_wiz->generate_objects( ).

      LOOP AT gt_roadmap ASSIGNING <gs_roadmap>.
        IF <gs_roadmap>-step_id = 'LOGS'.
          <gs_roadmap>-step_active = abap_true.
        ELSE.
          <gs_roadmap>-step_active = abap_false.
        ENDIF.
      ENDLOOP.
      g_current_step = 'LOGS'.

    WHEN 'NEXTSTEP'.

      l_index = g_current_step_index.
      DO g_total_steps TIMES.
        l_index = l_index + 1.
        READ TABLE gt_roadmap INDEX l_index ASSIGNING <gs_roadmap>.
        IF sy-subrc EQ 0 AND NOT <gs_roadmap>-step_visible IS INITIAL.
          <gs_roadmap>-step_active = 'X'.
          g_current_step = <gs_roadmap>-step_id.

          IF g_current_step = 'RRGCUST'.
            gs_temp_attr-rrg_status = 'RELEASED'.
            gs_temp_attr-rrg_output_table_type = 'GRID'.
          ENDIF.

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

  "test

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0100 INPUT.

  FIELD-SYMBOLS: <fs_swcont> TYPE swcont.

  build_symbols cre_dict gs_temp_attr-cre_dict.
  build_symbols cre_class gs_temp_attr-cre_class.
  build_symbols cre_rrg_cust gs_temp_attr-cre_rrg_cust.

  build_symbols structure gs_temp_attr-structure.
  build_symbols structure_descr gs_temp_attr-structure_descr.

  build_symbols abap_class gs_temp_attr-abap_class.
  build_symbols abap_class_descr gs_temp_attr-abap_class_descr.

  build_symbols rrg_report_id gs_temp_attr-rrg_report_id.
  build_symbols rrg_description gs_temp_attr-rrg_description.
  build_symbols rrg_title gs_temp_attr-rrg_title.
  build_symbols rrg_status gs_temp_attr-rrg_status.
  build_symbols rrg_active gs_temp_attr-rrg_active.
  build_symbols rrg_output_table_type gs_temp_attr-rrg_output_table_type.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0120  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0120 INPUT.

  IF gs_temp_attr-cre_dict <> abap_true OR
     gs_temp_attr-cre_class <> abap_true.
    gs_temp_attr-cre_rrg_cust = abap_false.
  ENDIF.

  ASSIGN gt_roadmap[ step_id = 'DICT' ] TO FIELD-SYMBOL(<step>).
  IF sy-subrc = 0.
    <step>-step_visible = gs_temp_attr-cre_dict.
  ENDIF.

  ASSIGN gt_roadmap[ step_id = 'CLASS' ] TO <step>.
  IF sy-subrc = 0.
    <step>-step_visible = gs_temp_attr-cre_class.
  ENDIF.

  ASSIGN gt_roadmap[ step_id = 'RRGCUST' ] TO <step>.
  IF sy-subrc = 0.
    <step>-step_visible = gs_temp_attr-cre_rrg_cust.
  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  STRUCTURE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE structure INPUT.

  DATA ls_dd02v_wa TYPE dd02v.
  DATA other_type LIKE rsdeo-objtype.
  DATA saa_err.
  DATA obj_exists.
  DATA msg_flag.

  CALL FUNCTION 'DD_CHECK_NAME'
    EXPORTING
      name            = gs_temp_attr-structure
   "  name2           = secname
      objtyp          = 'TABL'
      subtyp          = 'INTTAB'
    IMPORTING
      typ_conflict    = other_type
      saa_conflict    = saa_err
      obj_exists      = obj_exists
      msg_flag        = msg_flag
    EXCEPTIONS
      unknown_objtype = 01.

  IF obj_exists = 'X'.                 "obj_exists
    MESSAGE e006(e2) WITH gs_temp_attr-structure.
  ENDIF.
  IF saa_err = 'X'.                    "saa_conflict
    IF msg_flag = space.
      MESSAGE e026(e2) WITH gs_temp_attr-structure.
    ELSE.
      MESSAGE ID     sy-msgid
              TYPE   'E'
              NUMBER sy-msgno
              WITH   sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    CLEAR msg_flag.
  ENDIF.

  return.

  CALL FUNCTION 'DDIF_TABL_GET'
    EXPORTING
      name          = gs_temp_attr-structure
      state         = 'A'
      langu         = sy-langu
    IMPORTING
      dd02v_wa      = ls_dd02v_wa
    EXCEPTIONS
      illegal_input = 1
      OTHERS        = 2.

  IF sy-subrc <> 0.
    MESSAGE e002(/cadaxo/sqlc_rrg) WITH 'DDIF_TABL_GET' 'SY-SUBRC' sy-subrc.
  ENDIF.

  IF ls_dd02v_wa IS NOT INITIAL.
    MESSAGE e001(/cadaxo/sqlc_rrg) WITH gs_temp_attr-structure.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0150  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0150 INPUT.

  gs_temp_attr = CORRESPONDING #( /cadaxo/sqlc_temp_rrg_attr ).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0130  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0130 INPUT.

  gs_temp_attr-rrg_structure = gs_temp_attr-structure.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0140  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0140 INPUT.

  gs_temp_attr-rrg_class = gs_temp_attr-abap_class.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_REPORT_ID  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_report_id INPUT.
  SELECT SINGLE FROM /cadaxo/ui38_rep
         FIELDS @abap_true
         WHERE report_id = @/cadaxo/sqlc_temp_rrg_attr-rrg_report_id
         INTO @DATA(found).
  IF sy-subrc = 0.
    MESSAGE e004(/cadaxo/sqlc_rrg) WITH /cadaxo/sqlc_temp_rrg_attr-rrg_report_id.
  ENDIF.
ENDMODULE.
