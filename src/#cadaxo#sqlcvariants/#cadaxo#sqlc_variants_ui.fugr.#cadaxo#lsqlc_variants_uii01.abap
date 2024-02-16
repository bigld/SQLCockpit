*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_VARIANTS_UII01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'SEL_LANGU'.
      IF gcl_controller->description_changed_data_lost( ) EQ abap_true.
        CASE 'X'.
          WHEN rad_langu_d.
            gcl_controller->set_description_langu( 'D' ).
          WHEN rad_langu_e.
            gcl_controller->set_description_langu( 'E' ).
        ENDCASE.
      ENDIF.
    WHEN 'SAVE_DESCRIPTION'.
      gcl_controller->save_description( ).
      gcl_controller->set_description_modif_status( 0 ).
    WHEN 'CANCEL'.

      IF NOT gcl_controller IS INITIAL AND NOT gcl_controller->gs_il_variants-varguid IS INITIAL.
        /cadaxo/cl_sqlc_variant=>unlock_variant( gcl_controller->gs_il_variants-varguid ).
      ENDIF.

      IF NOT gcl_controller IS INITIAL.
        CLEAR gcl_controller->gs_il_variants.
      ENDIF.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'SEARCHVAR'.                                        "COCKPIT-291
      gcl_controller->show_search_variant_popup( ).        "COCKPIT-291
    WHEN 'CONTINUE'.

      IF gcl_controller->description_changed_data_lost( ) EQ abap_true.

        IF NOT gcl_controller IS INITIAL AND NOT gcl_controller->gs_il_variants-varguid IS INITIAL.
          /cadaxo/cl_sqlc_variant=>unlock_variant( gcl_controller->gs_il_variants-varguid ).
        ENDIF.

        SET SCREEN 0.
        LEAVE SCREEN.
      ENDIF.

    WHEN 'UPLOAD'.

      gcl_controller->upload_variants( ).

    when 'DOWNLOAD'.

      gcl_controller->download_variants( ).

    WHEN 'SHARE'.

      IF gcl_controller->gs_il_variants-varguid IS NOT INITIAL.
        CALL FUNCTION '/CADAXO/SQLC_SHARE'
          EXPORTING
            iv_export_type = /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-variant
            is_variant     = gcl_controller->gs_il_variants.
      ENDIF.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  DESCRIPTION_CHANGED  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE description_changed INPUT.
  gcl_controller->g_description_changed = abap_true.
ENDMODULE.                 " DESCRIPTION_CHANGED  INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

* set pf status
  SET PF-STATUS '0200'.
  set TITLEBAR '200'.

ENDMODULE.                 " STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  DATA lrc TYPE i.

  CLEAR lrc.

  CASE ok_code.

    WHEN 'INSERT_VAR'.

      IF gcl_controller->gs_il_variants-varname IS INITIAL.
        MESSAGE e055(00) DISPLAY LIKE 'I'.
      ENDIF.

      lrc = gcl_controller->insert_variant( ).
      IF lrc EQ 0.

        IF NOT gcl_controller IS INITIAL AND NOT gcl_controller->gs_il_variants-varguid IS INITIAL.
          /cadaxo/cl_sqlc_variant=>unlock_variant( gcl_controller->gs_il_variants-varguid ).
        ENDIF.

        SET SCREEN 0.
        LEAVE SCREEN.
      ENDIF.

    WHEN 'CANCEL'.
      IF NOT gcl_controller IS INITIAL.
        /cadaxo/cl_sqlc_variant=>unlock_variant( gcl_controller->gs_il_variants-varguid ).
        CLEAR gcl_controller->gs_il_variants.
      ENDIF.

      SET SCREEN 0.
      LEAVE SCREEN.

  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200_AT_EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200_at_exit INPUT.

  CASE ok_code.
    WHEN 'CANCEL'.
      IF NOT gcl_controller IS INITIAL.
        CLEAR gcl_controller->gs_il_variants.
      ENDIF.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0200_AT_EXIT  INPUT
*&---------------------------------------------------------------------*
*&      Module  VARNAME  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE varname INPUT.
  CLEAR gcl_controller->gs_il_variants-varguid.
ENDMODULE.                 " VARNAME  INPUT
