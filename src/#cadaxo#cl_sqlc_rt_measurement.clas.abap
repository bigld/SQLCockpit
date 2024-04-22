CLASS /cadaxo/cl_sqlc_rt_measurement DEFINITION
  PUBLIC
  FINAL
  CREATE PROTECTED.

  PUBLIC SECTION.
    CONSTANTS: BEGIN OF c_unit,
                 second      TYPE /cadaxo/sqlcruntime_unit  VALUE 's',
                 microsecond TYPE /cadaxo/sqlcruntime_unit VALUE 'µs',
               END OF c_unit.
    CLASS-METHODS: start RETURNING VALUE(e_instance) TYPE REF TO /cadaxo/cl_sqlc_rt_measurement.
    METHODS: constructor.
    METHODS: end RETURNING VALUE(e_runtime) TYPE /cadaxo/sqlcruntime.

  PROTECTED SECTION.

    TYPES: BEGIN OF ty_time,
             rt_start TYPE i,
             ts_start TYPE timestampl,
             rt_end   TYPE i,
             ts_end   TYPE timestampl,
           END OF ty_time.
    DATA: time TYPE ty_time.

  PRIVATE SECTION.


ENDCLASS.



CLASS /cadaxo/cl_sqlc_rt_measurement IMPLEMENTATION.

  METHOD constructor.

    GET RUN TIME FIELD time-rt_start.
    GET TIME STAMP FIELD time-ts_start.

  ENDMETHOD.


  METHOD start.

    e_instance = NEW /cadaxo/cl_sqlc_rt_measurement( ).

  ENDMETHOD.

  METHOD end.

    GET RUN TIME FIELD time-rt_end.
    GET TIME STAMP FIELD time-ts_end.

    e_runtime-runtime = CONV timestampl( time-ts_end - time-ts_start ).
    e_runtime-unit = /cadaxo/cl_sqlc_rt_measurement=>c_unit-second.
    IF e_runtime-runtime <= 500.

      e_runtime-runtime = CONV timestampl( time-rt_end - time-rt_start ).
      e_runtime-unit = /cadaxo/cl_sqlc_rt_measurement=>c_unit-microsecond.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
