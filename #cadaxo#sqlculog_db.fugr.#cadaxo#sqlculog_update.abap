FUNCTION /cadaxo/sqlculog_update.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_UPDATE_TASK) TYPE  /CADAXO/SQLCUPDATETASK OPTIONAL
*"     VALUE(IT_LOG) TYPE  /CADAXO/SQLCULOG_DB_T
*"----------------------------------------------------------------------

  DATA ls_log_db   TYPE /cadaxo/sqlculog.
  DATA lt_log_db_i TYPE TABLE OF /cadaxo/sqlculog.
  DATA lt_log_db_u TYPE TABLE OF /cadaxo/sqlculog.
  DATA lt_log_db_d TYPE TABLE OF /cadaxo/sqlculog.
  DATA lt_log_db_m TYPE TABLE OF /cadaxo/sqlculog.

  FIELD-SYMBOLS: <ls_log> LIKE LINE OF it_log.

  clear: lt_log_db_i,
         lt_log_db_u,
         lt_log_db_d,
         lt_log_db_m,
         ls_log_db.

  LOOP AT it_log ASSIGNING <ls_log>.
    MOVE-CORRESPONDING <ls_log> TO ls_log_db.
    CASE <ls_log>-update_flag.
      WHEN 'I'.
        APPEND ls_log_db TO lt_log_db_i.
      WHEN 'U'.
        APPEND ls_log_db TO lt_log_db_u.
      WHEN 'D'.
        APPEND ls_log_db TO lt_log_db_d.
      WHEN 'M'.
        APPEND ls_log_db TO lt_log_db_m.
    ENDCASE.
  ENDLOOP.

  IF NOT lt_log_db_i IS INITIAL.
    INSERT /cadaxo/sqlculog FROM TABLE lt_log_db_i. "#EC CI_IMUD_NESTED
  ENDIF.

  IF NOT lt_log_db_u IS INITIAL.
    UPDATE /cadaxo/sqlculog FROM TABLE lt_log_db_u. "#EC CI_IMUD_NESTED
  ENDIF.

  IF NOT lt_log_db_d IS INITIAL.
    DELETE /cadaxo/sqlculog FROM TABLE lt_log_db_d. "#EC CI_IMUD_NESTED
  ENDIF.

  IF NOT lt_log_db_m IS INITIAL.
    MODIFY /cadaxo/sqlculog FROM TABLE lt_log_db_m. "#EC CI_IMUD_NESTED
  ENDIF.

ENDFUNCTION.
