
PROCESS BEFORE OUTPUT.

  MODULE init_tree_control.

  MODULE tabs_active_tab_set.

  CALL SUBSCREEN tabs_sca INCLUDING gwa_tabs-prog gwa_tabs-subscreen.

  MODULE modify_screen.

  MODULE status_0100.

PROCESS AFTER INPUT.

  MODULE user_command_0100 AT EXIT-COMMAND.

  FIELD wa_sqlcrole-role MODULE check_role ON REQUEST.
  FIELD wa_sqlcrole-role_description MODULE check_roledes ON REQUEST.

  CALL SUBSCREEN tabs_sca.

  MODULE tabs_active_tab_get.

  MODULE user_command_0100.
