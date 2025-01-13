
PROCESS BEFORE OUTPUT.
  MODULE pbo_0500.

PROCESS AFTER INPUT.
  MODULE pai_0500.
  CHAIN.
    FIELD: g_csv_attr-file_path, g_csv_attr-file_path MODULE check_file.
  ENDCHAIN.
  MODULE user_command_0500.
  MODULE user_command_0500 AT EXIT-COMMAND.
