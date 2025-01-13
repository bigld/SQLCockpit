PROCESS BEFORE OUTPUT.
  MODULE pbo_0100.

  CALL SUBSCREEN gs_main_subscreen INCLUDING '/CADAXO/SAPLSQLC_JOB'
                 g_main_subscreen.

PROCESS AFTER INPUT.
  MODULE user_command_0100 at exit-command.
  CALL SUBSCREEN gs_main_subscreen.
  module pai_0100.
  MODULE user_command_0100.
