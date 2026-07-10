PROCESS BEFORE OUTPUT.
  MODULE restrict_odata_type.

PROCESS AFTER INPUT.
  FIELD gs_report_attr-project_name MODULE project_name ON INPUT.
  FIELD gs_report_attr-package      MODULE package      ON INPUT.

  MODULE set_input.
