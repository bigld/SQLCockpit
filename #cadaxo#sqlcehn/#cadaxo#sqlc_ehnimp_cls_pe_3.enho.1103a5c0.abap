"Name: \PR:/CADAXO/CL_SQLC_COCKPIT_PARSE=CP\EX:/CADAXO/SQLC_EHN_S_CLS_SE_003\EI
ENHANCEMENT 0 /CADAXO/SQLC_EHNIMP_CLS_PE_3.
*...

DEFINE cls_cdss.
* add "client specified"
  CASE abap_true.
    WHEN me->gs_client_handling-client_specified.
      APPEND 'CLIENT SPECIFIED' TO lt_abap_code.
*    WHEN me->gs_client_handling-using_client.
*      APPEND 'USING CLIENT' TO lt_abap_code.
  ENDCASE.

END-OF-DEFINITION.

ENDENHANCEMENT.
