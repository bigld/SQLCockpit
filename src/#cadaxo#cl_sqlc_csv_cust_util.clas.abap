CLASS /cadaxo/cl_sqlc_csv_cust_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: ty_strings TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    CONSTANTS: BEGIN OF cseperators,
                 tab       TYPE /cadaxo/sqlc_csv_cust_fldsep VALUE 'TAB',
                 comma     TYPE /cadaxo/sqlc_csv_cust_fldsep VALUE 'COMMA',
                 semicolon TYPE /cadaxo/sqlc_csv_cust_fldsep VALUE 'SEMICOLON',
                 cspace    TYPE /cadaxo/sqlc_csv_cust_fldsep VALUE 'SPACE',
                 others    TYPE /cadaxo/sqlc_csv_cust_fldsep VALUE  'OTHER',
               END OF cseperators.
    CONSTANTS: BEGIN OF cdateformats,
                 yyyymmdd   TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '01', "YYYYMMDD
                 yyyyhmmhdd TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '02', "YYYY-MM-DD
                 yyyydmmddd TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '03', "YYYY.MM.DD
                 ddmmyyyy   TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '04', "DDMMYYYY
                 ddhmmhyyyy TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '05', "DD-MM-YYYY
                 dddmmdyyyy TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '06', "DD.MM.YYYY
                 user       TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '09', "User
               END OF cdateformats.
    CONSTANTS: BEGIN OF ctimeformats,
                 hhmmss   TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '01', "HHMMSS
                 hhcmmcss TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '02', "HH:MM:SS
                 hhmm     TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '03', "HHMM
                 hhcmm    TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '04', "HH:MM
                 user     TYPE /cadaxo/sqlc_csvcus_dateformat  VALUE '09', "User
               END OF ctimeformats.
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
    CLASS-METHODS get_csv_from_itab
      IMPORTING
                it_table             TYPE ANY TABLE
                i_fieldcat           TYPE lvc_t_fcat
                i_csv_attr           TYPE /cadaxo/sqlc_csv_cust
      RETURNING VALUE(ev_output_csv) TYPE ty_strings.
    CLASS-METHODS csv_tab_2_string
      IMPORTING
        it_csv_tab          TYPE ty_strings
      RETURNING
        VALUE(e_csv_string) TYPE string .
    CLASS-METHODS get_csv_parameter_from_user
      IMPORTING
        i_csv_attr     TYPE /cadaxo/sqlc_csv_cust OPTIONAL
        i_to_appserver TYPE flag DEFAULT abap_false
      EXPORTING
        ev_cancel      TYPE abap_bool
        e_csv_attr     TYPE /cadaxo/sqlc_csv_cust.
  PRIVATE SECTION.


ENDCLASS.



CLASS /cadaxo/cl_sqlc_csv_cust_util IMPLEMENTATION.


  METHOD convert_date.

    CASE i_date_type.
      WHEN cdateformats-yyyymmdd.
        rv_converted_date = i_date.
      WHEN cdateformats-yyyyhmmhdd.
        rv_converted_date = |{ i_date(4) }-{ i_date+4(2) }-{ i_date+6(2) }|.
      WHEN cdateformats-yyyydmmddd.
        rv_converted_date = |{ i_date(4) }.{ i_date+4(2) }.{ i_date+6(2) }|.
      WHEN cdateformats-ddmmyyyy.
        rv_converted_date = |{ i_date+6(2) }{ i_date+4(2) }{ i_date(4) }|.
      WHEN cdateformats-ddhmmhyyyy.
        rv_converted_date = |{ i_date+6(2) }-{ i_date+4(2) }-{ i_date(4) }|.
      WHEN cdateformats-dddmmdyyyy.
        rv_converted_date = |{ i_date+6(2) }.{ i_date+4(2) }.{ i_date(4) }|.
      WHEN cdateformats-user.
        rv_converted_date = |{ i_date DATE = USER }|.
      WHEN OTHERS.
        rv_converted_date = i_date.
    ENDCASE.

  ENDMETHOD.


  METHOD convert_time.

    CASE i_time_type.
      WHEN ctimeformats-hhmmss.
        rv_converted_time = i_time_int.
      WHEN ctimeformats-hhcmmcss.
        rv_converted_time = |{ i_time_int(2) }:{ i_time_int+2(2) }:{ i_time_int+4(2) }|.
      WHEN ctimeformats-hhmm.
        rv_converted_time = |{ i_time_int(2) }{ i_time_int+2(2) }|.
      WHEN ctimeformats-hhcmm.
        rv_converted_time = |{ i_time_int(2) }:{ i_time_int+2(2) }|.
      WHEN ctimeformats-user.
        rv_converted_time = |{ i_time_int TIME = USER }|.
      WHEN OTHERS.
        rv_converted_time = i_time_int.
    ENDCASE.

  ENDMETHOD.


  METHOD csv_tab_2_string.

    LOOP AT it_csv_tab ASSIGNING FIELD-SYMBOL(<tab_line>).
      IF sy-tabix = 1.
        e_csv_string = <tab_line>.
      ELSE.
        e_csv_string = e_csv_string && cl_abap_char_utilities=>cr_lf && <tab_line>.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_csv_from_itab.

    DATA lv_output_line  TYPE string.
    DATA lv_tmp_dats     TYPE char30.
    DATA lv_tmp_out      TYPE string.

    CLEAR ev_output_csv.

    DATA(lv_separator) = get_separator( i_separator_setting = i_csv_attr-field_separator
                                        i_separator_others  = i_csv_attr-field_separator_other ).

    IF i_csv_attr-add_header = abap_true.
      LOOP AT i_fieldcat ASSIGNING FIELD-SYMBOL(<ls_field>).
        lv_output_line = lv_output_line && lv_separator && <ls_field>-fieldname.
      ENDLOOP.

      SHIFT lv_output_line BY 1 PLACES.
      APPEND lv_output_line TO ev_output_csv.
    ENDIF.

    LOOP AT it_table ASSIGNING FIELD-SYMBOL(<ls_result>).
      CLEAR lv_output_line.

      LOOP AT i_fieldcat ASSIGNING <ls_field>.
        ASSIGN COMPONENT <ls_field>-fieldname OF STRUCTURE <ls_result> TO FIELD-SYMBOL(<ls_line>).

        IF  <ls_field>-inttype = 'T'.
          " Export Date and Time in user format
          lv_tmp_dats = convert_time( i_time_type = i_csv_attr-time_format
                                      i_time_int  = <ls_line> ).
          lv_output_line = lv_output_line && lv_separator && lv_tmp_dats.
        ELSEIF <ls_field>-inttype = 'D'.
          lv_tmp_dats = convert_date( i_date_type = i_csv_attr-date_format
                                      i_date      = <ls_line> ).
          lv_output_line = lv_output_line && lv_separator && lv_tmp_dats.
        ELSEIF <ls_field>-inttype = 'C' AND ( <ls_line> CP |*{ lv_separator }*| OR <ls_line> CP '*"*' ).
          " If Separator or Single Quotes are in Field Then Do same behavior as Excel -> CSV
          lv_tmp_out = <ls_line>.
          REPLACE ALL OCCURRENCES OF '"' IN lv_tmp_out WITH '""'.
          lv_tmp_out = '"' && lv_tmp_out && '"'.
          lv_output_line = lv_output_line && lv_separator && lv_tmp_out.
        ELSE.
          IF ( <ls_field>-inttype = 'C' OR <ls_field>-inttype = 'g' )
             AND ( <ls_line> CS cl_abap_char_utilities=>cr_lf OR <ls_line> CS cl_abap_char_utilities=>newline ).
            lv_output_line = lv_output_line && lv_separator && '"' && <ls_line> && '"'.
          ELSE.
            lv_output_line = lv_output_line && lv_separator && <ls_line>.
          ENDIF.
        ENDIF.
      ENDLOOP.

      SHIFT lv_output_line BY 1 PLACES.
      APPEND lv_output_line TO ev_output_csv.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_csv_parameter_from_user.

    IF i_csv_attr IS NOT INITIAL.
      e_csv_attr  = i_csv_attr.
    ELSE.
      e_csv_attr = VALUE #( add_header      = abap_true
                            field_separator = 'SEMICOLON'
                            date_format     = '06'
                            time_format     = '02'
                            file_path       = 'TMP'
                            file_name       = |CockpitExport{ sy-datum }{ sy-uzeit }.csv| ).

      CALL FUNCTION '/CADAXO/SQLC_CUSTOM_CSV_POPUP'
        EXPORTING
          i_on_appserver = i_to_appserver
        IMPORTING
          ev_cancel      = ev_cancel
        CHANGING
          cs_csv_attr    = e_csv_attr.
    ENDIF.

  ENDMETHOD.


  METHOD get_separator.

    CASE i_separator_setting.
      WHEN cseperators-tab.
        e_separator = cl_abap_char_utilities=>horizontal_tab.
      WHEN cseperators-comma.
        e_separator = ','.
      WHEN cseperators-semicolon.
        e_separator = ';'.
      WHEN cseperators-cspace.
        e_separator = abap_false.
      WHEN cseperators-others.
        e_separator = i_separator_others.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
