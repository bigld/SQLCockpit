*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_RRGI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
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
        RAISE cancel_by_user.
      ENDIF.
    WHEN 'LEAVE'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'COMPLETE'.

      go_rrg_wiz->template_attributes = gs_temp_attr.
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
          <gs_roadmap>-step_active = ABAP_True.
          g_current_step = <gs_roadmap>-step_id.

          IF g_current_step = 'RRGCUST'.
            gs_temp_attr-status = 'RELEASED'.
            gs_temp_attr-output_table_type = 'GRID'.
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
MODULE pai_0100 INPUT.

  FIELD-SYMBOLS: <fs_swcont> TYPE swcont.

  build_symbols cre_dict gs_temp_attr-cre_dict.
  build_symbols cre_class gs_temp_attr-cre_class.
  build_symbols cre_rrg_cust gs_temp_attr-cre_rrg_cust.

  build_symbols structure gs_temp_attr-structure.
  build_symbols structure_descr gs_temp_attr-structure_descr.

  build_symbols abap_class gs_temp_attr-class.
  build_symbols abap_class_descr gs_temp_attr-class_descr.

  build_symbols rrg_report_id gs_temp_attr-report_id.
  build_symbols rrg_description gs_temp_attr-description.
  build_symbols rrg_title gs_temp_attr-title.
  build_symbols rrg_status gs_temp_attr-status.
  build_symbols rrg_active gs_temp_attr-active.
  build_symbols rrg_output_table_type gs_temp_attr-output_table_type.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0120  INPUT
*&---------------------------------------------------------------------*
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
MODULE structure INPUT.

  DATA ls_dd02v_wa TYPE dd02v.
  DATA other_type LIKE rsdeo-objtype.
  DATA saa_err.
  DATA obj_exists.
  DATA msg_flag.

  CALL FUNCTION 'DD_CHECK_NAME'
    EXPORTING
      name            = gs_temp_attr-structure
      objtyp          = 'TABL'
      subtyp          = 'INTTAB'
    IMPORTING
      typ_conflict    = other_type
      saa_conflict    = saa_err
      obj_exists      = obj_exists
      msg_flag        = msg_flag
    EXCEPTIONS
      unknown_objtype = 01.

  IF obj_exists = abap_true.
    DATA h_ddtypes TYPE ddtypes.

    SELECT SINGLE * FROM ddtypes
      INTO h_ddtypes
      WHERE typename = gs_temp_attr-structure.

    IF sy-subrc = 0.
      CASE h_ddtypes-typekind.
        WHEN seok_r3tr_class.
          MESSAGE e017(/cadaxo/sqlc_rrg) WITH gs_temp_attr-structure.
        WHEN seok_r3tr_interface.
          MESSAGE e018(/cadaxo/sqlc_rrg) WITH gs_temp_attr-structure.
        WHEN OTHERS.
          MESSAGE e019(/cadaxo/sqlc_rrg) WITH gs_temp_attr-structure.
      ENDCASE.
    ENDIF.

*  ENDIF.
  ENDIF.
  IF saa_err = abap_true.
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

  RETURN.

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
*&      Module  CLASS  INPUT
*&---------------------------------------------------------------------*
MODULE class INPUT.

  DATA abap_class TYPE seoclskey.

  abap_class = gs_temp_attr-class.

  cl_oo_class_builder=>check_clifname( CHANGING cifkey        = abap_class
                                       EXCEPTIONS not_allowed = 1 ).

  IF sy-subrc <> 0.
    SELECT SINGLE * FROM ddtypes
      INTO h_ddtypes
      WHERE typename = abap_class.

    IF sy-subrc = 0.
      CASE h_ddtypes-typekind.
        WHEN seok_r3tr_class.
          MESSAGE e017(/cadaxo/sqlc_rrg) WITH abap_class.
        WHEN seok_r3tr_interface.
          MESSAGE e018(/cadaxo/sqlc_rrg) WITH abap_class.
        WHEN OTHERS.
          MESSAGE e019(/cadaxo/sqlc_rrg) WITH abap_class.
      ENDCASE.
    ENDIF.

  ENDIF.

  IF gs_temp_attr-class = gs_temp_attr-structure.
    MESSAGE e020(/cadaxo/sqlc_rrg) WITH abap_class.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0150  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0150 INPUT.

  gs_temp_attr = CORRESPONDING #( /cadaxo/sqlc_temp_rrg_attr ).

ENDMODULE.



*&---------------------------------------------------------------------*
*&      Module  CHECK_REPORT_ID  INPUT
*&---------------------------------------------------------------------*
MODULE check_report_id INPUT.

  DATA: report_exists TYPE flag.

  TRY.
      SELECT SINGLE @abap_true AS exists
             FROM ('/CADAXO/UI38_REP')
             WHERE report_id = @/cadaxo/sqlc_temp_rrg_attr-report_id
             INTO @report_exists.
      IF sy-subrc = 0.
        MESSAGE e004(/cadaxo/sqlc_rrg) WITH /cadaxo/sqlc_temp_rrg_attr-report_id.
      ENDIF.
    CATCH cx_root.
      " OK -> is checked later again!
  ENDTRY.

ENDMODULE.
