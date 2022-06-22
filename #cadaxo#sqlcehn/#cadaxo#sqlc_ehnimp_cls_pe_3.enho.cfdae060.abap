"Name: \PR:/CADAXO/CL_SQLC_COCKPIT_PARSE=CP\EX:/CADAXO/SQLC_EHN_S_CLS_SE_001\EI
ENHANCEMENT 0 /CADAXO/SQLC_EHNIMP_CLS_PE_3.
*...
* client specified - main select
    FIND ALL OCCURRENCES OF 'SELECT' IN lv_check_sql_string RESULTS lt_results.
    READ TABLE lt_results INDEX 2 INTO ls_results.
    IF sy-subrc EQ 0.
      l_length2 = ls_results-offset.
    ELSE.
      l_length2 = strlen( sql_string ).
    ENDIF.
    FIND FIRST OCCURRENCE OF REGEX 'CLIENT\s+SPECIFIED' IN SECTION OFFSET 0 LENGTH l_length2 OF lv_check_sql_string MATCH OFFSET l_moff MATCH LENGTH l_length.
    IF sy-subrc EQ 0.
      IF ls_adm_cust-allow_cls NE abap_true.
        MESSAGE e013(/cadaxo/sqlc) INTO l_message.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
              EXPORTING message       = l_message
                        /cadaxo/msgid = '/CADAXO/SQLC'
                        /cadaxo/msgnr = '013'.
      ELSE.

        l_cl_sql_parse->gs_client_handling-client_specified = abap_true.
        lv_spacer_string = repeat( val = ` ` occ = l_length ).                                                         "COCKPIT-222
        lv_check_sql_string = replace( val = lv_check_sql_string off = l_moff len = l_length with = lv_spacer_string )."COCKPIT-222
        sql_string          = replace( val = sql_string          off = l_moff len = l_length with = lv_spacer_string )."COCKPIT-222

      ENDIF.
    ENDIF.

* client specified - sub selects
    FIND FIRST OCCURRENCE OF REGEX '\ASELECT(.*)SELECT(.*)(CLIENT\s+SPECIFIED)' IN lv_check_sql_string.
    IF sy-subrc EQ 0.
      IF ls_adm_cust-allow_cls NE abap_true.
        MESSAGE e013(/cadaxo/sqlc) INTO l_message.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error
              EXPORTING message       = l_message
                        /cadaxo/msgid = '/CADAXO/SQLC'
                        /cadaxo/msgnr = '013'.
      ENDIF.
    ENDIF.


    FIND FIRST OCCURRENCE OF REGEX 'USING\s+CLIENT'                                                      "COCKPIT-225
         IN SECTION OFFSET 0 LENGTH l_length2 OF lv_check_sql_string                                     "COCKPIT-225
         MATCH OFFSET l_moff MATCH LENGTH l_length.                                                      "COCKPIT-225
    IF sy-subrc EQ 0.                                                                                    "COCKPIT-225
      IF ls_adm_cust-allow_cls NE abap_true.                                                             "COCKPIT-225
        MESSAGE e121(/cadaxo/sqlc) INTO l_message.                                                       "COCKPIT-225
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error                                                "COCKPIT-225
              EXPORTING message       = l_message                                                        "COCKPIT-225
                        /cadaxo/msgid = '/CADAXO/SQLC'                                                   "COCKPIT-225
                        /cadaxo/msgnr = '121'.                                                           "COCKPIT-225
      ELSE.                                                                                              "COCKPIT-225
                                                                                                         "COCKPIT-225
        l_cl_sql_parse->gs_client_handling-using_client = abap_true.                                     "COCKPIT-225
                                                                                                         "COCKPIT-225
      ENDIF.                                                                                             "COCKPIT-225
    ENDIF.                                                                                               "COCKPIT-225
                                                                                                         "COCKPIT-225
* client specified - sub selects                                                                         "COCKPIT-225
    FIND FIRST OCCURRENCE OF REGEX '\ASELECT(.*)SELECT(.*)(USING\s+CLIENT)' IN lv_check_sql_string.      "COCKPIT-225
    IF sy-subrc EQ 0.                                                                                    "COCKPIT-225
      IF ls_adm_cust-allow_cls NE abap_true.                                                             "COCKPIT-225
        MESSAGE e121(/cadaxo/sqlc) INTO l_message.                                                       "COCKPIT-225
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_syntax_error                                                "COCKPIT-225
              EXPORTING message       = l_message                                                        "COCKPIT-225
                        /cadaxo/msgid = '/CADAXO/SQLC'                                                   "COCKPIT-225
                        /cadaxo/msgnr = '121'.                                                           "COCKPIT-225
      ENDIF.                                                                                             "COCKPIT-225
    ENDIF.                                                                                               "COCKPIT-225

ENDENHANCEMENT.
