
PROCESS BEFORE OUTPUT.

PROCESS AFTER INPUT.

  FIELD gs_report_attr-report         MODULE report ON INPUT.

  CHAIN.
    FIELD gs_report_attr-application.
    FIELD gs_report_attr-authorization_group.
    MODULE authorization_group ON CHAIN-REQUEST.
  ENDCHAIN.

  MODULE usr_check_consistency_0200.


PROCESS ON VALUE-REQUEST.
  FIELD gs_report_attr-authorization_group
  MODULE authorization_group_f4.
