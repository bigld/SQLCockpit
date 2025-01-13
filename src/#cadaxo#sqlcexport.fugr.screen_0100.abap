
PROCESS BEFORE OUTPUT.
  MODULE status_0100.
  MODULE pbo_0100.

  call subscreen EXPORT_SUBSCREEN including sy-repid g_sub_dynpro.


PROCESS AFTER INPUT.
  MODULE pai_0100.
*  FIELD g_csv_attr-field_separator_other
*     MODULE pau_field_sep_changed ON REQUEST.
  call subscreen export_subscreen.
  MODULE user_command_0100.
