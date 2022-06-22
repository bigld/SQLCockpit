"Name: \PR:/CADAXO/CL_SQLC_COCKPIT_PARSE=CP\EX:/CADAXO/SQLC_EHN_S_CLS_SE_002\EI
ENHANCEMENT 0 /CADAXO/SQLC_EHNIMP_CLS_PE_3.
*...

  CASE abap_true.
    WHEN i_cl_cockpit_parse->gs_client_handling-client_specified.
      CONCATENATE l_line 'CLIENT SPECIFIED' INTO l_line SEPARATED BY space.
*    WHEN i_cl_cockpit_parse->gs_client_handling-using_client.
*      CONCATENATE l_line 'USING CLIENT' INTO l_line SEPARATED BY space.
  ENDCASE.

ENDENHANCEMENT.
