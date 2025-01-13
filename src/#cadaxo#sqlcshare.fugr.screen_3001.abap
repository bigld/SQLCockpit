PROCESS BEFORE OUTPUT.
  MODULE pbo_3001.
*
PROCESS AFTER INPUT.

  MODULE pai_3001 AT EXIT-COMMAND.

  CHAIN.
    FIELD g_receiver.
    MODULE check_receiver.
  ENDCHAIN.

  CHAIN.
    FIELD g_rfcdest.
    MODULE check_rfcdest.
  ENDCHAIN.

  MODULE pai_3001.

PROCESS ON VALUE-REQUEST.
  FIELD g_receiver MODULE help_receiver.

*  PROCESS ON VALUE-REQUEST.
  FIELD g_rfcdest MODULE help_receiver_rfcdest.
