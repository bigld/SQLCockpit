FUNCTION /cadaxo/sqlc_job_scheduling.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(E_START_CONDITIONS) TYPE  /CADAXO/SQLC_JOBWIZ_FIELDS
*"  EXCEPTIONS
*"      CANCEL_BY_USER
*"----------------------------------------------------------------------

  PERFORM init_roadmap.

  CALL SCREEN 0100 STARTING AT 20 2 ENDING AT 130 22.

  e_start_conditions = /cadaxo/sqlc_jobwiz_fields.

ENDFUNCTION.
