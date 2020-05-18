*&---------------------------------------------------------------------*
*&      Module  PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
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

    APPEND 'HELP' TO gt_excluding.

    IF g_current_step_index EQ 1.
      APPEND 'PREVSTEP' TO gt_excluding.
      SET PF-STATUS '0100' EXCLUDING gt_excluding.
    ELSEIF g_current_step_index EQ 2. "progdetails
      SET PF-STATUS '0120' EXCLUDING gt_excluding.
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
MODULE pbo_0120 OUTPUT.

  SET PF-STATUS '0120'.
  SET TITLEBAR '0100'.

ENDMODULE.                 " PBO_0120  OUTPUT
