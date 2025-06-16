CLASS lcl_local_runner DEFINITION.

  PUBLIC SECTION.
  TYPES: BEGIN OF dates_range,
         min_date TYPE /cadaxo/sqlclogalv-execute_date,
         max_date TYPE /cadaxo/sqlclogalv-execute_date,
         END OF dates_range.

  TYPES: BEGIN OF selection_params,
         execution_dates TYPE dates_range,
         result_runtime TYPE /cadaxo/sqlclogalv-result_runtime,
         result_rows TYPE /cadaxo/sqlclogalv-result_rows,
         user_name TYPE /cadaxo/sqlcuser,
         END OF selection_params.


    METHODS run
      IMPORTING i_username TYPE selection_params-user_name DEFAULT sy-uname "OPTIONAL
                i_dates TYPE selection_params-execution_dates OPTIONAL
                i_runtime TYPE selection_params-result_runtime OPTIONAL
                i_rows TYPE selection_params-result_rows OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      ty_selects TYPE STANDARD TABLE OF /cadaxo/sqlclog WITH DEFAULT KEY.

    METHODS selects_from_user
      IMPORTING
        i_username       TYPE /cadaxo/sqlcuser
      RETURNING
        value(r_selects) TYPE ty_selects.

    METHODS selects_in_between
    IMPORTING
     i_dates TYPE  selection_params-execution_dates
     RETURNING
        VALUE(r_selects) TYPE ty_selects
    .
    METHODS auth_check.

ENDCLASS.

CLASS lcl_local_runner IMPLEMENTATION.

  METHOD run.
    DATA: selects TYPE STANDARD TABLE OF /cadaxo/sqlclog.

    auth_check( ).



    selects = selects_from_user( i_username ).
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

*  SELECT FROM /cadaxo/sqlclog FIELDS * WHERE timestamp BETWEEN i_dates

  ENDMETHOD.



ENDCLASS.
