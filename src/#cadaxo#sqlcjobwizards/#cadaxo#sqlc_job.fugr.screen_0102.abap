PROCESS BEFORE OUTPUT.
  CALL SUBSCREEN gs_subscreen INCLUDING '/CADAXO/SAPLSQLC_JOB'
                 g_current_subdynpro.
PROCESS AFTER INPUT.
  CALL SUBSCREEN gs_subscreen.
