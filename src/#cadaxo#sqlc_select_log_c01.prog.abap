CLASS lcl_local_runner DEFINITION.

  PUBLIC SECTION.

    TYPES: date_range    TYPE RANGE OF /cadaxo/sqlclogalv-execute_date,
           runtime_range TYPE RANGE OF /cadaxo/sqlclogalv-result_runtime,
           row_range     TYPE RANGE OF /cadaxo/sqlclogalv-result_rows,
           user_name     TYPE  /cadaxo/sqlclog-uname.

    TYPES: BEGIN OF timestamp_range,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE timestamp,
             high   TYPE timestamp,
           END OF timestamp_range.

    TYPES: timestamp_ranges TYPE STANDARD TABLE OF timestamp_range WITH DEFAULT KEY.
    TYPES: runtime_ranges TYPE RANGE OF /cadaxo/sqlclogalv-result_runtime .
    TYPES: row_ranges TYPE RANGE OF /cadaxo/sqlclogalv-result_rows .

    METHODS run
      IMPORTING i_username TYPE user_name DEFAULT sy-uname "OPTIONAL
                i_dates    TYPE date_range OPTIONAL
                i_runtime  TYPE runtime_range OPTIONAL
                i_rows     TYPE row_range OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      ty_selects TYPE STANDARD TABLE OF /cadaxo/sqlclog WITH DEFAULT KEY.

    METHODS selects_from_user
      IMPORTING
        i_username       TYPE /cadaxo/sqlcuser
      RETURNING
        VALUE(r_selects) TYPE ty_selects.

    METHODS selects_in_between
      IMPORTING
        i_dates          TYPE  timestamp_ranges
      RETURNING
        VALUE(r_selects) TYPE ty_selects
      .
    METHODS auth_check.

    METHODS conv_date_to_timestamp
      IMPORTING i_dates             TYPE date_range
      RETURNING VALUE(r_timestamps) TYPE timestamp_ranges.

    METHODS db_query
      IMPORTING i_timestamps TYPE timestamp_ranges OPTIONAL
                i_username   TYPE /cadaxo/sqlcuser OPTIONAL
                i_runtimes   TYPE  runtime_ranges OPTIONAL
                i_rows       TYPE row_ranges OPTIONAL
      RETURNING VALUE(r_selects) TYPE ty_selects.



ENDCLASS.

CLASS lcl_local_runner IMPLEMENTATION.

  METHOD run.
    DATA: selects TYPE STANDARD TABLE OF /cadaxo/sqlclog.

    auth_check( ).

    DATA(test) = conv_date_to_timestamp( i_dates ).
*    selects = selects_in_between( test ).
    selects = db_query( i_username = i_username i_timestamps = test i_rows = i_rows i_runtimes = i_runtime ).



*    selects = selects_from_user( i_username ).
    cl_salv_table=>factory(
*  EXPORTING
*    list_display   = if_salv_c_bool_sap=>false
*    r_container    =
*    container_name =
      IMPORTING
        r_salv_table   = DATA(selects_alv)
      CHANGING
        t_table        = selects
    ).
*CATCH cx_salv_msg.

    selects_alv->display( ).
  ENDMETHOD.

  METHOD auth_check.

    AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
    IF sy-subrc <> 0.
      MESSAGE e036(/cadaxo/sqlc).
    ENDIF.

  ENDMETHOD.

  METHOD selects_from_user.

    SELECT FROM /cadaxo/sqlclog FIELDS * WHERE uname = @i_username INTO TABLE @r_selects.


  ENDMETHOD.

  METHOD selects_in_between.

    SELECT FROM /cadaxo/sqlclog FIELDS *  WHERE timestamp  IN @i_dates  INTO TABLE @r_selects.

  ENDMETHOD.

  METHOD conv_date_to_timestamp.

    DATA: time_low  TYPE t VALUE '000000',
          time_high TYPE t VALUE '235959',
          timestamp TYPE timestampl,
*  timestamp_as_char TYPE c LENGTH 21,
          timestamp_str TYPE string,
          date_line TYPE LINE OF date_range,
          temp_line TYPE timestamp_range,
          ts_ranges TYPE timestamp_ranges.

    LOOP AT i_dates INTO date_line.
      CLEAR temp_line.

      temp_line-sign = date_line-sign.
      temp_line-option = date_line-option.

*      IF date_line-low IS NOT INITIAL.
*        CONVERT DATE date_line-low TIME time_low
*          INTO TIME STAMP timestamp TIME ZONE 'UTC'.
*        temp_line-low = timestamp.
*      ENDIF.
*
*      IF date_line-high IS NOT INITIAL.
*        CONVERT DATE date_line-high TIME time_high
*          INTO TIME STAMP timestamp TIME ZONE 'UTC'.
*        temp_line-high = timestamp.
*      ENDIF.

IF date_line-low IS NOT INITIAL.
*      CONCATENATE date_line-low time_low '0000000' INTO timestamp_as_char.
*      timestamp = timestamp_as_char.
*      temp_line-low = timestamp.
       temp_line-low = |{ date_line-low }000000|.
    ENDIF.

    IF date_line-high IS NOT INITIAL.
*      CONCATENATE date_line-high time_high '0000000' INTO timestamp_as_char.
*      timestamp = timestamp_as_char.
*      temp_line-high = timestamp.
       temp_line-high = |{ date_line-high }235959|.
    ENDIF.

      APPEND temp_line TO ts_ranges.

    ENDLOOP.

    r_timestamps = ts_ranges.

  ENDMETHOD.

  METHOD db_query.


*    SELECT FROM /cadaxo/sqlclog
*  FIELDS *
*  WHERE ( uname        = @i_username    OR @i_username IS INITIAL )
*    AND ( timestamp    IN @i_timestamps )
*    AND ( result_runtime IN @i_runtimes )
*    AND ( result_rows    IN @i_rows     )
*  INTO TABLE @r_selects.

DATA: lt_selects TYPE ty_selects.

    DATA(start_date) = i_timestamps[ 1 ]-low.
    DATA(end_date) = i_timestamps[ 1 ]-high.




  IF i_username IS INITIAL.


    IF i_timestamps IS INITIAL AND i_runtimes IS INITIAL AND i_rows IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS * INTO TABLE @lt_selects.

    ELSEIF i_timestamps IS INITIAL AND i_runtimes IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE result_rows IN @i_rows
        INTO TABLE @lt_selects.

    ELSEIF i_timestamps IS INITIAL AND i_rows IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE result_runtime IN @i_runtimes
        INTO TABLE @lt_selects.

    ELSEIF i_runtimes IS INITIAL AND i_rows IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE timestamp >= @start_date AND timestamp <= @end_date
        INTO TABLE @lt_selects.

    ELSEIF i_timestamps IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE result_runtime IN @i_runtimes
          AND result_rows IN @i_rows
        INTO TABLE @lt_selects.

    ELSEIF i_runtimes IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE timestamp >= @start_date AND timestamp <= @end_date
          AND result_rows IN @i_rows
        INTO TABLE @lt_selects.

    ELSEIF i_rows IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE timestamp IN @i_timestamps
          AND result_runtime IN @i_runtimes
        INTO TABLE @lt_selects.

    ELSE.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE timestamp >= @start_date AND timestamp <= @end_date
          AND result_runtime IN @i_runtimes
          AND result_rows IN @i_rows
        INTO TABLE @lt_selects.
    ENDIF.

  ELSE.


    IF i_timestamps IS INITIAL AND i_runtimes IS INITIAL AND i_rows IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE uname = @i_username
        INTO TABLE @lt_selects.

    ELSEIF i_timestamps IS INITIAL AND i_runtimes IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE uname = @i_username
          AND result_rows IN @i_rows
        INTO TABLE @lt_selects.

    ELSEIF i_timestamps IS INITIAL AND i_rows IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE uname = @i_username
          AND result_runtime IN @i_runtimes
        INTO TABLE @lt_selects.

    ELSEIF i_runtimes IS INITIAL AND i_rows IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE uname = @i_username
          AND timestamp IN @i_timestamps
        INTO TABLE @lt_selects.

    ELSEIF i_timestamps IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE uname = @i_username
          AND result_runtime IN @i_runtimes
          AND result_rows IN @i_rows
        INTO TABLE @lt_selects.

    ELSEIF i_runtimes IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE uname = @i_username
          AND timestamp >= @start_date AND timestamp <= @end_date
          AND result_rows IN @i_rows
        INTO TABLE @lt_selects.

    ELSEIF i_rows IS INITIAL.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE uname = @i_username
          AND timestamp >= @start_date AND timestamp <= @end_date
          AND result_runtime IN @i_runtimes
        INTO TABLE @lt_selects.

    ELSE.
      SELECT FROM /cadaxo/sqlclog FIELDS *
        WHERE uname = @i_username
          AND timestamp >= @start_date AND timestamp <= @end_date
          AND result_runtime IN @i_runtimes
          AND result_rows IN @i_rows
        INTO TABLE @lt_selects.
    ENDIF.

  ENDIF.

  r_selects = lt_selects.


  ENDMETHOD.

ENDCLASS.
