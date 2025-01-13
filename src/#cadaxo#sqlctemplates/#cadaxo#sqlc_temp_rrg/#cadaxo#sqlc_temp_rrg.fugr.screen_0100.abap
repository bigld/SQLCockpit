PROCESS BEFORE OUTPUT.
  MODULE pbo_0100.

  CALL SUBSCREEN gs_main_subscreen INCLUDING
   '/CADAXO/SAPLSQLC_TEMP_RRG'
             g_main_subscreen.

PROCESS AFTER INPUT.
  MODULE user_command_0100 AT EXIT-COMMAND.
  CALL SUBSCREEN gs_main_subscreen.
  MODULE pai_0100.
  MODULE user_command_0100.
