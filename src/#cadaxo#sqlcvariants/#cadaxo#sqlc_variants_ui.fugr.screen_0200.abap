
PROCESS BEFORE OUTPUT.

  MODULE status_0200.
  MODULE pbo_0200.

PROCESS AFTER INPUT.

  MODULE user_command_0200_at_exit AT EXIT-COMMAND.

  FIELD gcl_controller->gs_il_variants-varname
        MODULE varname ON REQUEST.

  CHAIN.
    FIELD: gcl_controller->gs_il_variants-varname,
           gcl_controller->gs_il_variants-vargroup,
           gcl_controller->gs_il_variants-vardescription,
           gcl_controller->gs_il_variants-flag_public.
    MODULE user_command_0200.
  ENDCHAIN.
