
PROCESS BEFORE OUTPUT.
  MODULE status_0100.
  MODULE pbo_0100.
  MODULE modify_screen_0100.
*
PROCESS AFTER INPUT.

  FIELD gcl_controller->g_description
     MODULE description_changed ON REQUEST.

  MODULE user_command_0100.
