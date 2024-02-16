*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCVGRVF01 .
*----------------------------------------------------------------------*
FORM authority_check.
  AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
  IF sy-subrc NE 0.
    MESSAGE e036(/cadaxo/sqlc).
  ENDIF.
ENDFORM.                    "authority_check
*&---------------------------------------------------------------------*
*&      Form  CHECK_ASSIGNMENT
*&---------------------------------------------------------------------*
FORM check_assignment.
  DATA: l_count  TYPE i.
  DATA: l_vgroup TYPE /cadaxo/sqlcvgrp.
  LOOP AT extract.
    CHECK <xmark> EQ markiert.
    MOVE-CORRESPONDING extract TO l_vgroup.
    SELECT COUNT(*) FROM /cadaxo/sqlcvari INTO l_count WHERE vargroup = l_vgroup-vargroup.
    IF sy-subrc = 0.
      <xmark> = space.
      MODIFY extract.
      MESSAGE e070(/cadaxo/sqlc) WITH l_vgroup-vargroup.
    ENDIF.
  ENDLOOP.
ENDFORM.                    "CHECK_ASSIGNMENT
