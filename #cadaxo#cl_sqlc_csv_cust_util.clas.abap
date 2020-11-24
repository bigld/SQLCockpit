CLASS /cadaxo/cl_sqlc_csv_cust_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_separator
      IMPORTING
        !i_separator_setting TYPE /cadaxo/sqlc_csv_cust_fldsep
        !i_separator_others  TYPE /cadaxo/sqlc_csvcust_fldsepoth OPTIONAL
      RETURNING
        VALUE(e_separator)   TYPE char01 .
    CLASS-METHODS convert_date
      IMPORTING
        !i_date_type             TYPE /cadaxo/sqlc_csvcus_dateformat
        !i_date                  TYPE datum
      RETURNING
        VALUE(rv_converted_date) TYPE char10 .
    CLASS-METHODS convert_time
      IMPORTING
        !i_time_type             TYPE /cadaxo/sqlc_csvcus_timeformat
        !i_time_int              TYPE uzeit
      RETURNING
        VALUE(rv_converted_time) TYPE char8 .
ENDCLASS.



CLASS /CADAXO/CL_SQLC_CSV_CUST_UTIL IMPLEMENTATION.


  METHOD convert_date.

    CASE i_date_type.
      WHEN '01'."YYYYMMDD
        MOVE i_date TO rv_converted_date.
      WHEN '02'."YYYY-MM-DD
        rv_converted_date = |{ i_date(4) }-{ i_date+4(2) }-{ i_date+6(2) }|.
      WHEN '03'.""YYYY.MM.DD
        rv_converted_date = |{ i_date(4) }.{ i_date+4(2) }.{ i_date+6(2) }|.
      WHEN '04'."DDMMYYYY
        rv_converted_date = |{ i_date+6(2) }{ i_date+4(2) }{ i_date(4) }|.
      WHEN '05'."DD-MM-YYYY
        rv_converted_date = |{ i_date+6(2) }-{ i_date+4(2) }-{ i_date(4) }|.
      WHEN '06'."DD.MM.YYYY
        rv_converted_date = |{ i_date+6(2) }.{ i_date+4(2) }.{ i_date(4) }|.
      WHEN OTHERS.
        MOVE i_date TO rv_converted_date.
    ENDCASE.

  ENDMETHOD.


  METHOD convert_time.

    CASE i_time_type.
      WHEN '01'.
        rv_converted_time = i_time_int.
      WHEN '02'.
        rv_converted_time = |{ i_time_int(2) }:{ i_time_int+2(2) }:{ i_time_int+4(2) }|.
      WHEN '03'.
        rv_converted_time = |{ i_time_int(2) }{ i_time_int+2(2) }|.
      WHEN '04'.
        rv_converted_time = |{ i_time_int(2) }:{ i_time_int+2(2) }|.
      WHEN OTHERS.
        rv_converted_time = i_time_int.
    ENDCASE.

  ENDMETHOD.


  METHOD get_separator.

    CASE i_separator_setting.
      WHEN 'TAB'.
        MOVE cl_abap_char_utilities=>horizontal_tab TO e_separator.
      WHEN 'COMMA'.
        MOVE ',' TO e_separator.
      WHEN 'SEMICOLON'.
        MOVE ';' TO e_separator.
      WHEN 'SPACE'.
        MOVE abap_false TO e_separator.
      WHEN 'OTHER'.
        MOVE i_separator_others TO e_separator.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
