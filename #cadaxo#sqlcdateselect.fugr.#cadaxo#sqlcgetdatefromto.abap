FUNCTION /cadaxo/sqlcgetdatefromto.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     REFERENCE(C_DATE_FROM) TYPE  DATS OPTIONAL
*"     REFERENCE(C_DATE_TO) TYPE  DATS OPTIONAL
*"     REFERENCE(C_TIME_FROM) TYPE  TIMS OPTIONAL
*"     REFERENCE(C_TIME_TO) TYPE  TIMS OPTIONAL
*"     REFERENCE(C_TIMESTAMP_FROM) TYPE  TIMESTAMP OPTIONAL
*"     REFERENCE(C_TIMESTAMP_TO) TYPE  TIMESTAMP OPTIONAL
*"  EXCEPTIONS
*"      CANCEL_BY_USER
*"----------------------------------------------------------------------

  IF NOT c_timestamp_from IS INITIAL.
    CONVERT TIME STAMP c_timestamp_from TIME ZONE 'UTC   '
            INTO DATE /cadaxo/sqlcdateselfromto-date_from
                 TIME /cadaxo/sqlcdateselfromto-time_from.
  ELSE.
    MOVE: c_date_from TO /cadaxo/sqlcdateselfromto-date_from,
          c_time_from TO /cadaxo/sqlcdateselfromto-time_from.
  ENDIF.

  IF NOT c_timestamp_to IS INITIAL.
    CONVERT TIME STAMP c_timestamp_to TIME ZONE 'UTC   '
            INTO DATE /cadaxo/sqlcdateselfromto-date_to
                 TIME /cadaxo/sqlcdateselfromto-time_to.
  ELSE.
    MOVE: c_date_from TO /cadaxo/sqlcdateselfromto-date_to,
          c_time_from TO /cadaxo/sqlcdateselfromto-time_to.
  ENDIF.

  CALL SCREEN 0100 STARTING AT 20 5 ENDING AT 65 5.

  MOVE: /cadaxo/sqlcdateselfromto-date_from TO c_date_from,
        /cadaxo/sqlcdateselfromto-date_to   TO c_date_to,
        /cadaxo/sqlcdateselfromto-time_from TO c_time_from,
        /cadaxo/sqlcdateselfromto-time_to   TO c_time_to.

  CONVERT DATE /cadaxo/sqlcdateselfromto-date_from
          TIME /cadaxo/sqlcdateselfromto-time_from
          INTO TIME STAMP c_timestamp_from TIME ZONE 'UTC   '.

  CONVERT DATE /cadaxo/sqlcdateselfromto-date_to
          TIME /cadaxo/sqlcdateselfromto-time_to
          INTO TIME STAMP c_timestamp_to TIME ZONE 'UTC   '.

ENDFUNCTION.
