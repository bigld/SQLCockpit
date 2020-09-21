*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_JOBO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.

  CLEAR: gt_excluding[].

  DESCRIBE TABLE gt_roadmap LINES g_total_steps.

  READ TABLE gt_roadmap WITH KEY step_id = g_current_step ASSIGNING <gs_roadmap>.
  IF sy-subrc EQ 0.

    g_current_step_index = sy-tabix.
    g_current_subdynpro  = <gs_roadmap>-step_subdynpro.

    IF ( NOT <gs_roadmap>-step_documentation IS INITIAL AND <gs_roadmap>-step_documentation_html IS INITIAL )
         OR <gs_roadmap>-step_id = 'FINISH'.
      PERFORM get_documentation USING <gs_roadmap>-step_documentation CHANGING <gs_roadmap>-step_documentation_html.
    ENDIF.

    IF g_current_step_index EQ 1.
      APPEND 'PREVSTEP' TO gt_excluding.
      SET PF-STATUS '0100' EXCLUDING gt_excluding.
    ELSEIF g_current_step_index EQ g_total_steps.
      APPEND 'NEXTSTEP' TO gt_excluding.
      SET PF-STATUS '010F' EXCLUDING gt_excluding.
    ELSE.
      SET PF-STATUS '0100' EXCLUDING gt_excluding.
    ENDIF.

    SET TITLEBAR '0100'.

    CASE <gs_roadmap>-step_type.
      WHEN 'I'. "Information
        g_main_subscreen = '0101'.
      WHEN 'E'. "Edit
        g_main_subscreen = '0102'.
    ENDCASE.

    PERFORM load_html.
  ENDIF.

ENDMODULE.                 " PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0120  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0120 OUTPUT.
  CONCATENATE '/CADAXO/SELECT_' sy-datum '_' sy-uzeit INTO /cadaxo/sqlc_jobwiz_fields-jobname.
  MOVE 'C' TO /cadaxo/sqlc_jobwiz_fields-jobclass.
ENDMODULE.                 " PBO_0120  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0130  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0130 INPUT.
  CASE 'X'.
    WHEN /cadaxo/sqlc_jobwiz_fields-planned.
      READ TABLE gt_roadmap WITH KEY step_id = 'CONDPLANNED' ASSIGNING <gs_roadmap>.
      IF sy-subrc EQ 0 AND <gs_roadmap>-step_visible EQ space.
        <gs_roadmap>-step_visible       = 'X'.
        LOOP AT gt_roadmap FROM sy-tabix ASSIGNING <gs_roadmap>.
          <gs_roadmap>-step_active = space.
        ENDLOOP.
      ENDIF.
    WHEN /cadaxo/sqlc_jobwiz_fields-immediately.
      READ TABLE gt_roadmap WITH KEY step_id = 'CONDPLANNED' ASSIGNING <gs_roadmap>.
      IF sy-subrc EQ 0 AND <gs_roadmap>-step_visible EQ 'X'.
        <gs_roadmap>-step_visible       = ''.
        LOOP AT gt_roadmap FROM sy-tabix ASSIGNING <gs_roadmap>.
          <gs_roadmap>-step_active = space.
        ENDLOOP.
      ENDIF.
  ENDCASE.

  READ TABLE gt_roadmap WITH KEY step_id = 'RESTRICTIONS' ASSIGNING <gs_roadmap>.
  IF sy-subrc NE 0 OR /cadaxo/sqlc_jobwiz_fields-periodic IS INITIAL.
    <gs_roadmap>-step_visible = space.

    CLEAR: /cadaxo/sqlc_jobwiz_fields-periodic_minutely,
           /cadaxo/sqlc_jobwiz_fields-periodic_hourly,
           /cadaxo/sqlc_jobwiz_fields-periodic_daily,
           /cadaxo/sqlc_jobwiz_fields-periodic_weekly,
           /cadaxo/sqlc_jobwiz_fields-periodic_monthly.
  ELSE.
    <gs_roadmap>-step_visible = 'X'.
  ENDIF.

ENDMODULE.                 " PAI_0130  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_0150  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0150 OUTPUT.
* begin of comments cockpit-451
*  LOOP AT SCREEN.
*    CASE screen-group1.
*      WHEN '001'.
*        IF NOT /cadaxo/sqlc_jobwiz_fields-notification_sap_mail_flag IS INITIAL.
*          screen-required = 1.
*        ELSE.
*          screen-required = 0.
*        ENDIF.
*      WHEN '002'.
*        IF NOT /cadaxo/sqlc_jobwiz_fields-notification_email_flag IS INITIAL.
*          screen-required = 1.
*        ELSE.
*          screen-required = 0.
*        ENDIF.
**      WHEN '003'.
**        IF NOT /cadaxo/sqlc_jobwiz_fields-notification_email_flag IS INITIAL.
**          screen-input = 1.
**        ENDIF.
*    ENDCASE.
*
*    MODIFY SCREEN.
*  ENDLOOP.
* end   of comments cockpit-451
ENDMODULE.                 " PAI_0150  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_0130  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0130 OUTPUT.

  IF /cadaxo/sqlc_jobwiz_fields-planned     IS INITIAL AND
     /cadaxo/sqlc_jobwiz_fields-immediately IS INITIAL AND
     /cadaxo/sqlc_jobwiz_fields-scheduled   IS INITIAL.
    MOVE 'X' TO /cadaxo/sqlc_jobwiz_fields-immediately.
  ENDIF.

ENDMODULE.                 " PBO_0130  OUTPUT
