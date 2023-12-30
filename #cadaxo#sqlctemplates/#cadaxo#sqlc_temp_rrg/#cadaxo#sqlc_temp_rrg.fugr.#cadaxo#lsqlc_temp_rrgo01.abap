*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_RRGO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PBO_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.

  DATA: gt_excluding           LIKE sy-ucomm OCCURS 0 WITH HEADER LINE.


  CLEAR: gt_excluding[].

  DESCRIBE TABLE gt_roadmap LINES g_total_steps.

  READ TABLE gt_roadmap WITH KEY step_id = g_current_step ASSIGNING <gs_roadmap>.
  IF sy-subrc EQ 0.

    g_current_step_index = sy-tabix.
    g_current_subdynpro  = <gs_roadmap>-step_subdynpro.

    IF ( NOT <gs_roadmap>-step_documentation IS INITIAL AND <gs_roadmap>-step_documentation_html IS INITIAL )
         OR <gs_roadmap>-step_id = 'GENERATE'.
      PERFORM get_documentation USING <gs_roadmap>-step_documentation <gs_roadmap>-step_documentation_html.
    ENDIF.

    APPEND 'HELP' TO gt_excluding.

    IF g_current_step_index EQ 1.
      APPEND 'PREVSTEP' TO gt_excluding.
      SET PF-STATUS '0100' EXCLUDING gt_excluding.
    ELSEIF g_current_step_index EQ 2. "progdetails
      SET PF-STATUS '0120' EXCLUDING gt_excluding.
    ELSEIF g_current_step = 'GENERATE'. "                 g_current_step_index EQ g_total_steps.
      APPEND 'NEXTSTEP' TO gt_excluding.
      SET PF-STATUS '010E' EXCLUDING gt_excluding.
    ELSEIF g_current_step = 'LOGS'.
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
      WHEN 'F'. "Finish
        g_main_subscreen = '0103'.
    ENDCASE.

    PERFORM load_html.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0120 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0120 OUTPUT.

  DATA ls_rrg_active TYPE c LENGTH 1.

  ls_rrg_active  = '0'.

  IF gs_temp_attr-cre_dict = abap_true AND
     gs_temp_attr-cre_class = abap_true.
    ls_rrg_active = '1'.
  ENDIF.

  LOOP AT SCREEN.
    IF screen-group1 = 'RRG'.
      screen-input = ls_rrg_active.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0150 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0150 OUTPUT.

  /cadaxo/sqlc_temp_rrg_attr = CORRESPONDING #( gs_temp_attr ).

ENDMODULE.
