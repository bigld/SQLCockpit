FUNCTION /cadaxo/sqlculog_select.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_UNAME) TYPE  UNAME OPTIONAL
*"     REFERENCE(I_OBJECT) TYPE  /CADAXO/SQLC_ULOG_OBJECT OPTIONAL
*"     REFERENCE(I_OBJECT_KEY) TYPE  /CADAXO/SQLC_ULGO_OBJECT_KEY
*"       OPTIONAL
*"     REFERENCE(I_DATE_FROM) TYPE  DATS OPTIONAL
*"  EXPORTING
*"     REFERENCE(ET_LOG) TYPE  /CADAXO/SQLCULOG_DB_T
*"----------------------------------------------------------------------

  DATA lt_log_db TYPE TABLE OF /cadaxo/sqlculog.
  DATA l_where TYPE string.
  DATA l_field TYPE string.

  IF i_uname IS SUPPLIED AND NOT i_uname IS INITIAL.
    CONCATENATE '''' i_uname '''' INTO l_field.
    CONCATENATE 'UNAME = ' l_field INTO l_where SEPARATED BY space.
  ENDIF.

  IF i_object IS SUPPLIED AND NOT i_object IS INITIAL.
    IF NOT l_where IS INITIAL.
      CONCATENATE l_where 'AND' INTO l_where SEPARATED BY space.
    ENDIF.
    CONCATENATE '''' i_object '''' INTO l_field.
    CONCATENATE l_where 'OBJECT = ' l_field INTO l_where separated by space.
  ENDIF.

  IF i_object_key IS SUPPLIED AND NOT i_object_key IS INITIAL.
    IF NOT i_object_key IS INITIAL.
      CONCATENATE i_object_key 'AND' INTO l_where SEPARATED BY space.
    ENDIF.
    CONCATENATE '''' i_object_key '''' INTO l_field.
    CONCATENATE l_where 'OBJECT_KEY = ' l_field INTO l_where separated by space.
  ENDIF.

  SELECT * FROM /cadaxo/sqlculog INTO corresponding fields of TABLE et_log
                                 WHERE (l_where).

ENDFUNCTION.
