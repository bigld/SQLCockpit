*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCTEMVF01 .
*----------------------------------------------------------------------*
FORM authority_check.
  AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
  IF sy-subrc NE 0.
    MESSAGE e036(/cadaxo/sqlc).
  ENDIF.
ENDFORM.                    "authority_check
