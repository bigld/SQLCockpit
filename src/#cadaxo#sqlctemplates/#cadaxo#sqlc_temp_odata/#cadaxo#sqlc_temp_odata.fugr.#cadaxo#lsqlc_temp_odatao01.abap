*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_ODATAO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.

  DATA: gt_excluding           LIKE sy-ucomm OCCURS 0 WITH HEADER LINE.
  DATA: g_total_steps          TYPE i.
  DATA: g_current_step_index   TYPE i.
  CLEAR: gt_excluding[].

  DESCRIBE TABLE gt_roadmap LINES g_total_steps.

  READ TABLE gt_roadmap WITH KEY step_id = g_current_step ASSIGNING <gs_roadmap>.
  IF sy-subrc EQ 0.

    g_current_step_index = sy-tabix.
    g_current_subdynpro  = <gs_roadmap>-step_subdynpro.

    IF ( NOT <gs_roadmap>-step_documentation IS INITIAL AND <gs_roadmap>-step_documentation_html IS INITIAL )
         OR <gs_roadmap>-step_id = 'GENERATE'.
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

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CONTAINER_130  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE container_130 OUTPUT.

  PERFORM container_130.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  restrict_odata_type  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE restrict_odata_type OUTPUT.

  go_odata_wiz->restrict_proj_types( ).

ENDMODULE.
