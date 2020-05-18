FUNCTION /cadaxo/sqlc_temp_rep_wiz.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EWA_REPORT) TYPE  /CADAXO/SQLC_TEMP_REP_ATTR
*"     REFERENCE(EWA_EVT) TYPE  /CADAXO/SQLC_TEMP_REP_SALV_EVT
*"     REFERENCE(EGT_SELOPT) TYPE  /CADAXO/SQLC_TEMP_REP_SEL_STRT
*"  CHANGING
*"     REFERENCE(CT_WHERE) TYPE  /CADAXO/SQLCWHERECOL_STR_T
*"     REFERENCE(C_TEMPL_NAME) TYPE  /CADAXO/SQLCTEMPL_NAME
*"  EXCEPTIONS
*"      CANCEL_BY_USER
*"----------------------------------------------------------------------

  CLEAR: gs_report_attr, gs_evt_new.
  CLEAR: wa_locked, g_sett_loaded.
  CLEAR: wa_checked.

  CASE c_templ_name.
    WHEN '/CADAXO/REPORT_S'.
      gs_report_attr-schemename    = 'REPORT1'.
      gs_report_attr-schemeprogram = '/CADAXO/SQLC_SME1S'.
    WHEN '/CADAXO/REPORT_A'.
      gs_report_attr-schemename    = 'REPORT2'.
      gs_report_attr-schemeprogram = '/CADAXO/SQLC_SME1A'.
  ENDCASE.
  g_templ_name = c_templ_name.

  gt_where = ct_where.

  PERFORM init_selopt.

  PERFORM init_roadmap.



  CALL SCREEN 0100 STARTING AT 20 2 ENDING AT 140 22.

  PERFORM get_selopt.
  PERFORM get_enh_include.

  ewa_report = gs_report_attr.
  egt_selopt = gt_selopt.                                   "CDX130-025
  ewa_evt    = gs_evt.                                      "CDX130-025

  ct_where = gt_where.
ENDFUNCTION.
