CLASS /cadaxo/cl_sqlc_ui_utils DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS build_result_grid_footer
      IMPORTING iv_syst              TYPE sysysid
                iv_mandant           TYPE /cadaxo/sqlc_mandt
                iv_uname             TYPE uname
                iv_create_timestamp  TYPE timestampl
      RETURNING VALUE(r_grid_footer) TYPE /cadaxo/sqlcresult_footer.

    CLASS-METHODS build_result_grid_title
      IMPORTING i_runtime           TYPE /cadaxo/sqlcruntime
                i_result_lines      TYPE i
                i_select_version    TYPE /cadaxo/sqlc_select_version
                i_message           TYPE string OPTIONAL
      RETURNING VALUE(r_grid_title) TYPE lvc_title.

    TYPES: BEGIN OF ty_rows_cols,
             rows TYPE i,
             cols TYPE i,
           END OF ty_rows_cols.

    CLASS-METHODS calc_result_rows_and_cols
      IMPORTING i_number_of_selects  TYPE i
                VALUE(i_orientation) TYPE /cadaxo/sqlcreswindorientation
      RETURNING VALUE(e_rows_cols)   TYPE ty_rows_cols.

ENDCLASS.


CLASS /cadaxo/cl_sqlc_ui_utils IMPLEMENTATION.
  METHOD build_result_grid_title.
    " build the header: x records ( y microseconds )
    IF i_result_lines = 1.
      r_grid_title = |{ i_result_lines NUMBER = USER } { TEXT-i03 }|.
    ELSEIF i_result_lines > 1.
      r_grid_title = |{ i_result_lines NUMBER = USER } { TEXT-i01 }|.
    ELSE.
      r_grid_title = TEXT-i02.
    ENDIF.

    IF i_runtime-unit = /cadaxo/cl_sqlc_rt_measurement=>c_unit-second.
      r_grid_title = |{ r_grid_title } ( { i_runtime-runtime NUMBER = USER } { TEXT-008 } )|.
    ELSE.
      r_grid_title = |{ r_grid_title } ( { i_runtime-runtime NUMBER = USER } { TEXT-001 } )|.
    ENDIF.

    r_grid_title = |{ r_grid_title } \| V{ i_select_version }|.

    IF i_message IS NOT INITIAL.
      CONCATENATE r_grid_title '-' i_message INTO r_grid_title RESPECTING BLANKS.
    ENDIF.

    CONDENSE r_grid_title.
  ENDMETHOD.

  METHOD calc_result_rows_and_cols.
    CONSTANTS lc_max_rowcol TYPE i VALUE 15.
    DATA calc TYPE p LENGTH 8 DECIMALS 2.

    IF i_number_of_selects > lc_max_rowcol.
      i_orientation = /cadaxo/cl_sqlc_cockpit_main=>cs_windowresolution-matrix.
    ENDIF.

    CASE i_orientation.
      WHEN /cadaxo/cl_sqlc_cockpit_main=>cs_windowresolution-horizontal.
        e_rows_cols-rows = 1.
        e_rows_cols-cols = i_number_of_selects.
      WHEN /cadaxo/cl_sqlc_cockpit_main=>cs_windowresolution-vertical.
        e_rows_cols-rows = i_number_of_selects.
        e_rows_cols-cols = 1.
      WHEN OTHERS.

        calc = sqrt( i_number_of_selects ).

        CALL FUNCTION 'ROUND'
          EXPORTING input  = calc
                    sign   = 'X'
          IMPORTING output = e_rows_cols-rows.

        CALL FUNCTION 'ROUND'
          EXPORTING input  = calc
                    sign   = '+'
          IMPORTING output = e_rows_cols-cols.
    ENDCASE.
  ENDMETHOD.

  METHOD build_result_grid_footer.

    DATA lv_timestamp TYPE timestamp.
    DATA lv_date      TYPE sy-datum.
    DATA lv_time      TYPE sy-uzeit.
    DATA lv_date_out  TYPE c LENGTH 10.
    DATA lv_time_out  TYPE c LENGTH 8.

    IF iv_syst IS NOT INITIAL.
      CONCATENATE r_grid_footer 'System:'(f02) iv_syst INTO r_grid_footer SEPARATED BY space.
    ENDIF.
    IF iv_mandant IS NOT INITIAL.
      CONCATENATE r_grid_footer 'Client:'(f01) iv_mandant INTO r_grid_footer SEPARATED BY space.
    ENDIF.
    IF iv_uname IS NOT INITIAL.
      CONCATENATE r_grid_footer 'User:'(f05) iv_uname INTO r_grid_footer SEPARATED BY space.
    ENDIF.

    IF iv_create_timestamp IS NOT INITIAL.
      lv_timestamp = iv_create_timestamp.
      CONVERT TIME STAMP lv_timestamp TIME ZONE sy-zonlo INTO DATE lv_date TIME lv_time.
      WRITE lv_date TO lv_date_out.
      WRITE lv_time TO lv_time_out.
      CONCATENATE r_grid_footer 'Date:'(f03) lv_date_out 'Time:'(f04) lv_time_out INTO r_grid_footer SEPARATED BY space.
    ENDIF.

    IF r_grid_footer IS INITIAL.
      GET TIME STAMP FIELD lv_timestamp.
      CONVERT TIME STAMP lv_timestamp TIME ZONE sy-zonlo INTO DATE lv_date TIME lv_time.
      WRITE lv_date TO lv_date_out.
      WRITE lv_time TO lv_time_out.

      CONCATENATE 'System:'(f02) sy-sysid 'Client:'(f01) sy-mandt
                  'Date:'(f03) lv_date_out 'Time:'(f04) lv_time_out INTO r_grid_footer SEPARATED BY space.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
