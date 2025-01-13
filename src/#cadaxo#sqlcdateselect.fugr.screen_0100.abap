
PROCESS BEFORE OUTPUT.
  MODULE status_0100.
*
PROCESS AFTER INPUT.
  MODULE user_command_0100 at exit-command.
  CHAIN.
    FIELD: /cadaxo/sqlcdateselfromto-date_from,
           /cadaxo/sqlcdateselfromto-date_to,
           /cadaxo/sqlcdateselfromto-time_from,
           /cadaxo/sqlcdateselfromto-time_to.
    MODULE pai_0100.
  ENDCHAIN.
  MODULE user_command_0100.
