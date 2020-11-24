*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_JOBI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA: l_index TYPE i.

  CASE ok_code.
    WHEN 'CANCEL'.
      RAISE cancel_by_user.
    WHEN 'COMPLETE'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'NEXTSTEP'.
      l_index = g_current_step_index.
      DO g_total_steps TIMES.
        l_index = l_index + 1.
        READ TABLE gt_roadmap INDEX l_index ASSIGNING <gs_roadmap>.
        IF sy-subrc = 0 AND NOT <gs_roadmap>-step_visible IS INITIAL.
          <gs_roadmap>-step_active = abap_true.
          g_current_step = <gs_roadmap>-step_id.
          EXIT.
        ENDIF.
      ENDDO.
    WHEN 'PREVSTEP'.
      l_index = g_current_step_index.
      DO g_total_steps TIMES.
        l_index = l_index - 1.
        READ TABLE gt_roadmap INDEX l_index ASSIGNING <gs_roadmap>.
        IF sy-subrc = 0 AND NOT <gs_roadmap>-step_visible IS INITIAL.
          g_current_step = <gs_roadmap>-step_id.
          EXIT.
        ENDIF.
      ENDDO.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_EMAIL_ADDRESS  INPUT
*&---------------------------------------------------------------------*
MODULE check_email_address INPUT.

  PERFORM check_email_address USING
*                                    /cadaxo/sqlc_jobwiz_fields-notification_email_flag"Cockpit-451
                                    /cadaxo/sqlc_jobwiz_fields-notification_email1.
  PERFORM check_email_address USING
*                                    /cadaxo/sqlc_jobwiz_fields-notification_email_flag"Cockpit-451
                                    /cadaxo/sqlc_jobwiz_fields-notification_email2.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0100  INPUT
*&---------------------------------------------------------------------*
MODULE pai_0100 INPUT.
  DATA: l_string(30).

  FIELD-SYMBOLS: <ls_swcont> TYPE swcont.

  READ TABLE gt_swcont WITH KEY element = 'JOBNAME' ASSIGNING <ls_swcont>.
  IF sy-subrc <> 0.
    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
  ENDIF.
  <ls_swcont>-element    = 'JOBNAME'.
  <ls_swcont>-elemlength = 32.
  <ls_swcont>-type       = 'C'.
  <ls_swcont>-value      = /cadaxo/sqlc_jobwiz_fields-jobname.

  READ TABLE gt_swcont WITH KEY element = 'JOBCLASS' ASSIGNING <ls_swcont>.
  IF sy-subrc <> 0.
    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
  ENDIF.
  MOVE: 'JOBCLASS'                           TO <ls_swcont>-element,
        1                                    TO <ls_swcont>-elemlength,
        'C'                                  TO <ls_swcont>-type,
        /cadaxo/sqlc_jobwiz_fields-jobclass  TO <ls_swcont>-value.


  ASSIGN gt_swcont[ element = 'STARTCOND' ] TO <ls_swcont>.
  IF sy-subrc <> 0.
    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
  ENDIF.
  MOVE: 'STARTCOND'                          TO <ls_swcont>-element,
        'C'                                  TO <ls_swcont>-type.

  CASE abap_true.
    WHEN /cadaxo/sqlc_jobwiz_fields-immediately.
      <ls_swcont>-value = text-001.
    WHEN /cadaxo/sqlc_jobwiz_fields-planned.
      <ls_swcont>-value = text-002.
      WRITE /cadaxo/sqlc_jobwiz_fields-sdlstrtdt TO l_string.
      CONCATENATE <ls_swcont>-value l_string INTO <ls_swcont>-value SEPARATED BY space.
      WRITE /cadaxo/sqlc_jobwiz_fields-sdlstrttm TO l_string.
      CONCATENATE <ls_swcont>-value l_string INTO <ls_swcont>-value SEPARATED BY space.
  ENDCASE.
  <ls_swcont>-elemlength = strlen( <ls_swcont>-value ).


  ASSIGN gt_swcont[ element = 'SAPMAIL' ] TO <ls_swcont>.
  IF sy-subrc <> 0.
    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
  ENDIF.
  <ls_swcont>-element = 'SAPMAIL'.
  <ls_swcont>-type    = 'C'.
*  IF /cadaxo/sqlc_jobwiz_fields-notification_sap_mail_flag = abap_true. "-Cockpit-451
  IF /cadaxo/sqlc_jobwiz_fields-notification_sap_mail IS NOT INITIAL.  "+Cockpit-451
    <ls_swcont>-value = /cadaxo/sqlc_jobwiz_fields-notification_sap_mail.
  ELSE.
    <ls_swcont>-value = text-003.
  ENDIF.
  <ls_swcont>-elemlength = strlen( <ls_swcont>-value ).

  ASSIGN gt_swcont[ element = 'ATTACHMENT' ] TO <ls_swcont>.
  IF sy-subrc <> 0.
    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
  ENDIF.
  <ls_swcont>-element = 'ATTACHMENT'.
  <ls_swcont>-type    = 'C'.
  IF /cadaxo/sqlc_jobwiz_fields-notif_email_attachment_flag = abap_true."-Cockpit-451
    <ls_swcont>-value = text-004.
  ELSE.
    <ls_swcont>-value = text-003.
  ENDIF.
  <ls_swcont>-elemlength = strlen( <ls_swcont>-value ).

* begin of insert+cockpit-451
  IF /cadaxo/sqlc_jobwiz_fields-notification_email1 IS NOT INITIAL.
  ASSIGN gt_swcont[ element = 'EMAIL1' ] TO <ls_swcont>.
  IF sy-subrc <> 0.
    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
  ENDIF.
  <ls_swcont>-element = 'EMAIL1'.
  <ls_swcont>-type    = 'C'.
  <ls_swcont>-value = /cadaxo/sqlc_jobwiz_fields-notification_email1.
  <ls_swcont>-elemlength = strlen( <ls_swcont>-value ).
  ENDIF.

  IF /cadaxo/sqlc_jobwiz_fields-notification_email2 IS NOT INITIAL.
  ASSIGN gt_swcont[ element = 'EMAIL2' ] TO <ls_swcont>.
  IF sy-subrc <> 0.
    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
  ENDIF.
  <ls_swcont>-element = 'EMAIL2'.
  <ls_swcont>-type    = 'C'.
  <ls_swcont>-value = /cadaxo/sqlc_jobwiz_fields-notification_email2.
  <ls_swcont>-elemlength = strlen( <ls_swcont>-value ).
  ENDIF.

  IF /cadaxo/sqlc_jobwiz_fields-notification_email1 IS INITIAL AND /cadaxo/sqlc_jobwiz_fields-notification_email2 IS INITIAL.
  ASSIGN gt_swcont[ element = 'EMAIL1' ] TO <ls_swcont>.
  IF sy-subrc <> 0.
    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
  ENDIF.
  <ls_swcont>-element = 'EMAIL1'.
  <ls_swcont>-type    = 'C'.
  <ls_swcont>-value = text-003.
  <ls_swcont>-elemlength = strlen( <ls_swcont>-value ).
  ENDIF.
* end   of insert+cockpit-451

* begin   of comments -cockpit-451
*  ASSIGN gt_swcont[ element = 'EMAIL1' ] TO <ls_swcont>.
*  IF sy-subrc <> 0.
*    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
*  ENDIF.
*  <ls_swcont>-element = 'EMAIL1'.
*  <ls_swcont>-type    = 'C'.
*  IF /cadaxo/sqlc_jobwiz_fields-notification_email_flag = abap_true.
*    <ls_swcont>-value = /cadaxo/sqlc_jobwiz_fields-notification_email1.
*  ELSE.
*    <ls_swcont>-value = text-003.
*  ENDIF.
*  <ls_swcont>-elemlength = strlen( <ls_swcont>-value ).
*
*  ASSIGN gt_swcont[ element = 'EMAIL2' ] TO <ls_swcont>.
*  IF sy-subrc <> 0.
*    APPEND INITIAL LINE TO gt_swcont ASSIGNING <ls_swcont>.
*  ENDIF.
*  <ls_swcont>-element = 'EMAIL2'.
*  <ls_swcont>-type    = 'C'.
*  IF /cadaxo/sqlc_jobwiz_fields-notification_email_flag = abap_true.
*    <ls_swcont>-value = /cadaxo/sqlc_jobwiz_fields-notification_email2.
*  ELSE.
*    <ls_swcont>-value = text-003.
*  ENDIF.
*  <ls_swcont>-elemlength = strlen( <ls_swcont>-value ).
* end   of comments -cockpit-451

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_SAP_USER  INPUT
*&---------------------------------------------------------------------*
MODULE check_sap_user INPUT.
  DATA l_bname LIKE usr03-bname.
  DATA lt_user TYPE TABLE OF string.

  IF
*    /cadaxo/sqlc_jobwiz_fields-notification_sap_mail_flag <> space AND "-Cockpit-451
     /cadaxo/sqlc_jobwiz_fields-notification_sap_mail <> space.

    SPLIT /cadaxo/sqlc_jobwiz_fields-notification_sap_mail AT ';' INTO TABLE lt_user.

    LOOP AT lt_user ASSIGNING FIELD-SYMBOL(<user>).
      SELECT SINGLE bname FROM usr02 INTO l_bname
             WHERE bname = <user>.
      IF sy-subrc <> 0.
        MESSAGE e018(/cadaxo/sqlc) WITH <user>.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDMODULE.                 " CHECK_SAP_USER  INPUT
