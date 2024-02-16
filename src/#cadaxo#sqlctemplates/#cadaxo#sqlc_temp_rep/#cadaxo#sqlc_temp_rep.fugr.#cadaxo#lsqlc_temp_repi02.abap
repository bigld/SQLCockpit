*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_REPI02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  REPORT  INPUT
*&---------------------------------------------------------------------*
MODULE report INPUT.

  PERFORM check_report using 'REPORT'.
  PERFORM load_report_settings.

ENDMODULE.                 " REPORT  INPUT

*&---------------------------------------------------------------------*
*&      Module  HEADERINCLUDE  INPUT
*&---------------------------------------------------------------------*
MODULE headerinclude INPUT.

  PERFORM check_headerinclude.

ENDMODULE.                 " headerinclude  INPUT

*&---------------------------------------------------------------------*
*&      Module  ENHANCEINCLUDE  INPUT
*&---------------------------------------------------------------------*
MODULE enhanceinclude INPUT.

  PERFORM check_enhanceinclude.

ENDMODULE.                 " enhanceinclude INPUT


*&---------------------------------------------------------------------*
*&      Module  AUTHORIZATION_GROUP  INPUT
*&---------------------------------------------------------------------*
MODULE authorization_group INPUT.

  DATA: l_srepoath TYPE srepoath.
  DATA: lwa_tpgp   TYPE tpgp.

  CHECK gs_report_attr-authorization_group <> space.


  SELECT SINGLE * FROM srepoath INTO l_srepoath
    WHERE name = gs_report_attr-report.
  IF sy-subrc = 0.       "entry in SREPOATH exists
    IF l_srepoath-secu <> gs_report_attr-authorization_group.
      MESSAGE w104(ds) WITH l_srepoath-secu gs_report_attr-report gs_report_attr-authorization_group.
    ENDIF.
  ENDIF.


  SELECT SINGLE * FROM tpgp INTO lwa_tpgp
         WHERE appli   = gs_report_attr-application
         AND   p_group = gs_report_attr-authorization_group.
  IF sy-subrc >< 0.
    MESSAGE w089(ds) WITH gs_report_attr-authorization_group gs_report_attr-application.
  ENDIF.
ENDMODULE.                 " AUTHORIZATION_GROUP  INPUT
*&---------------------------------------------------------------------*
*&      Module  AUTHORIZATION_GROUP_F4  INPUT
*&---------------------------------------------------------------------*
MODULE authorization_group_f4 INPUT.
  TABLES trdir.
  DATA: lt_dynfields             TYPE TABLE OF dynpread.
  FIELD-SYMBOLS: <lwa_dynfields> TYPE dynpread.

  CLEAR lt_dynfields.
  APPEND 'GS_REPORT_ATTR-APPLICATION' TO lt_dynfields.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname                      = sy-repid
      dynumb                      = sy-dynnr
      start_search_in_main_screen = c_true
    TABLES
      dynpfields                  = lt_dynfields
    EXCEPTIONS
      OTHERS                      = 1.
  IF sy-subrc = 0.
    READ TABLE lt_dynfields ASSIGNING <lwa_dynfields> INDEX 1.
    gs_report_attr-application =  <lwa_dynfields>-fieldvalue.
  ENDIF.
  SUBMIT rsabtpgp WITH appli = gs_report_attr-application
                  AND RETURN.

  IMPORT trdir-appl trdir-secu FROM MEMORY ID 'TPGP'.
  IF sy-subrc = 0.
    gs_report_attr-application = trdir-appl.
    gs_report_attr-authorization_group = trdir-secu.
    READ TABLE lt_dynfields ASSIGNING <lwa_dynfields> INDEX 1.
    IF sy-subrc = 0.
      <lwa_dynfields>-fieldvalue = gs_report_attr-application.
    ELSE.
      APPEND INITIAL LINE TO lt_dynfields ASSIGNING <lwa_dynfields>.
      <lwa_dynfields>-fieldname = 'GS_REPORT_ATTR-APPLICATION'.
      <lwa_dynfields>-fieldvalue = gs_report_attr-application.
    ENDIF.
    APPEND INITIAL LINE TO lt_dynfields ASSIGNING <lwa_dynfields>.
    <lwa_dynfields>-fieldname = 'GS_REPORT_ATTR-AUTHORIZATION_GROUP'.
    <lwa_dynfields>-fieldvalue = gs_report_attr-authorization_group.
    CALL FUNCTION 'DYNP_VALUES_UPDATE'
      EXPORTING
        dyname     = sy-repid
        dynumb     = sy-dynnr
      TABLES
        dynpfields = lt_dynfields
      EXCEPTIONS
        OTHERS     = 1.

  ENDIF.
ENDMODULE.                    "authorization_group_f4 INPUT
*&---------------------------------------------------------------------*
*&      Module  CONTAINER_130  OUTPUT
*&---------------------------------------------------------------------*
MODULE container_130 OUTPUT.
  PERFORM container_130.
ENDMODULE.                 " CONTAINER_130  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  LOAD_SETTINGS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE load_settings INPUT.
  PERFORM load_report_settings.
ENDMODULE.                 " LOAD_SETTINGS  INPUT
