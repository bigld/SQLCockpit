class /CADAXO/CL_SQLC_COCKPIT_EXPCSV definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_COCKPIT_EXPCSV
*"* do not include other source files here!!!
public section.

  methods CONVERT_DATA
    importing
      !IT_DATA type ANY TABLE
    exporting
      !ET_DATA type ANY TABLE .
  methods SET_ATTRIBUTES
    importing
      !IS_ATTRIBUTES type /CADAXO/SQLCEXPORTCSVATTR .
  methods SET_COLUMNS
    importing
      !IT_COLUMNS type /CADAXO/SQLCEXPORTCOLALV_T .
  methods CONSTRUCTOR .
protected section.
*"* protected components of class /CADAXO/CL_SQLC_COCKPIT_EXPCSV
*"* do not include other source files here!!!

  data GS_ATTRIBUTES type /CADAXO/SQLCEXPORTCSVATTR .
  data GT_COLUMNS type /CADAXO/SQLCEXPORTCOLALV_T .
  data:
    GT_EXPORT type table of string .
  data G_COL_SEP type STRING .

  methods ADD_HEADER .
  methods ADD_COLUMN
    importing
      !I_VALUE type ANY
    changing
      !C_LINE type ANY .
  methods CHECK_ENCLOSURE
    changing
      !C_VALUE type STRING .
  methods CONVERT_DATE
    importing
      !I_VALUE type D
    exporting
      !E_VALUE type STRING .
  methods CONVERT_TIME
    importing
      !I_VALUE type T
    exporting
      !E_VALUE type STRING .
  methods CONVERT_INT
    importing
      !I_VALUE type I
    exporting
      !E_VALUE type STRING .
  methods CONVERT_P
    importing
      !I_VALUE type P
    exporting
      !E_VALUE type STRING .
  methods CONVERT_X
    importing
      !I_VALUE type X
      !I_EXPORT_HEX type /CADAXO/SQLCEXPORTCOLHEXASCHAR default ''
    exporting
      !E_VALUE type STRING .
private section.
*"* private components of class /CADAXO/CL_SQLC_COCKPIT_EXPCSV
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CL_SQLC_COCKPIT_EXPCSV IMPLEMENTATION.


METHOD add_column.

  IF c_line IS INITIAL.
    MOVE i_value TO c_line.
  ELSE.
    CONCATENATE c_line g_col_sep i_value INTO c_line.
  ENDIF.

ENDMETHOD.


METHOD add_header.

  DATA l_value TYPE string.

  FIELD-SYMBOLS: <ls_column> LIKE LINE OF gt_columns,
                 <ls_export> TYPE string.

  APPEND INITIAL LINE TO gt_export ASSIGNING <ls_export>.
  LOOP AT gt_columns ASSIGNING <ls_column> WHERE export_flag NE space.
    l_value = <ls_column>-fieldname.

    me->check_enclosure( CHANGING c_value = l_value ).
    me->add_column( EXPORTING i_value = l_value
                    CHANGING c_line   = <ls_export> ).
  ENDLOOP.

ENDMETHOD.


METHOD check_enclosure.

  DATA l_col_enc_double TYPE string.

  IF me->gs_attributes-col_enclosure IS INITIAL.
    EXIT.
  ENDIF.

  FIND me->gs_attributes-col_enclosure IN c_value.
  IF sy-subrc EQ 0.
    CONCATENATE me->gs_attributes-col_enclosure me->gs_attributes-col_enclosure INTO l_col_enc_double.
    REPLACE ALL OCCURRENCES OF me->gs_attributes-col_enclosure IN c_value WITH l_col_enc_double.
  ENDIF.

  CONCATENATE me->gs_attributes-col_enclosure c_value me->gs_attributes-col_enclosure INTO c_value.

ENDMETHOD.


method CONSTRUCTOR.
endmethod.


METHOD convert_data.

  DATA l_type  TYPE c.
  DATA l_value TYPE string.

  FIELD-SYMBOLS: <ls_data>   TYPE ANY,
                 <ls_export> TYPE string,
                 <ls_column> LIKE LINE OF gt_columns,
                 <l_col_val> TYPE ANY.

  CLEAR gt_export.

* add header
  IF gs_attributes-add_header IS NOT INITIAL.
    me->add_header( ).
  ENDIF.

  LOOP AT it_data ASSIGNING <ls_data>.
    APPEND INITIAL LINE TO gt_export ASSIGNING <ls_export>.
    LOOP AT gt_columns ASSIGNING <ls_column> WHERE export_flag NE space.

      CLEAR l_value.

      ASSIGN COMPONENT <ls_column>-fieldname OF STRUCTURE <ls_data> TO <l_col_val>.
      IF sy-subrc EQ 0.

        DESCRIBE FIELD <l_col_val> TYPE l_type.

        CASE l_type.
          WHEN 'X'.
            me->convert_x( EXPORTING i_value = <l_col_val>
                                     i_export_hex = <ls_column>-export_hex
                           IMPORTING e_value = l_value ).
          WHEN 'P'.
            me->convert_p( EXPORTING i_value = <l_col_val>
                           IMPORTING e_value = l_value ).
          WHEN 'T'.
            me->convert_time( EXPORTING i_value = <l_col_val>
                              IMPORTING e_value = l_value ).
          WHEN 'D'.
            me->convert_date( EXPORTING i_value = <l_col_val>
                              IMPORTING e_value = l_value ).
          WHEN 'I'.
            me->convert_int( EXPORTING i_value = <l_col_val>
                             IMPORTING e_value = l_value ).
          when 'C'.
            move <l_col_val> to l_value.
          WHEN OTHERS.
            message x000(/CADAXO/SQLC).
        ENDCASE.

        me->check_enclosure( CHANGING c_value = l_value ).

        me->add_column( EXPORTING i_value = l_value
                        CHANGING c_line   = <ls_export> ).
      ELSE.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

* set export data
  et_data = gt_export.

* clear/free
  FREE gt_export.

ENDMETHOD.


METHOD convert_date.
  CASE gs_attributes-date_format.
    WHEN '01'.
      MOVE i_value TO e_value.
    WHEN '02'.
      CONCATENATE i_value(4) '-' i_value+4(2) '-' i_value+6(2) INTO e_value.
    WHEN '03'.
      CONCATENATE i_value(4) '.' i_value+4(2) '.' i_value+6(2) INTO e_value.
    WHEN '04'.
      CONCATENATE i_value+6(2) i_value+4(2) i_value(4) INTO e_value.
    WHEN '05'.
      CONCATENATE i_value+6(2) '-' i_value+4(2) '-' i_value(4) INTO e_value.
    WHEN '06'.
      CONCATENATE i_value+6(2) '.' i_value+4(2) '.' i_value(4) INTO e_value.
  ENDCASE.
ENDMETHOD.


METHOD convert_int.

  MOVE i_value TO e_value.

ENDMETHOD.


METHOD convert_p.

  DATA l_value TYPE c LENGTH 32.

  SET COUNTRY '/OXADAC/'. "dummy country

  CLEAR l_value.

  CASE gs_attributes-decimal_notation.
    WHEN '1'.
      WRITE i_value TO l_value NO-GROUPING.
    WHEN '2'.
      WRITE i_value TO l_value NO-GROUPING.
      REPLACE FIRST OCCURRENCE OF '.' IN l_value WITH ','.
    WHEN '3'.
      WRITE i_value TO l_value.
    WHEN '4'.
      WRITE i_value TO l_value.
      REPLACE FIRST OCCURRENCE OF '.' IN l_value WITH ','.
      REPLACE ALL OCCURRENCES OF ',' IN l_value WITH '.'.
  ENDCASE.

  SHIFT l_value LEFT DELETING LEADING space.

  MOVE l_value TO e_value.

  SET COUNTRY ''.
ENDMETHOD.


METHOD convert_time.

  CASE gs_attributes-time_format.
    WHEN '01'.
      MOVE i_value TO e_value.
    WHEN '02'.
      CONCATENATE i_value(2) ':'
                  i_value+2(2) ':'
                  i_value+4(2) INTO e_value.
    WHEN '03'.
      MOVE i_value(4) TO e_value.
    WHEN '04'.
      CONCATENATE i_value(2) ':'
                  i_value+2(2) INTO e_value.
  ENDCASE.

ENDMETHOD.


METHOD convert_x.

  FIELD-SYMBOLS: <l_value> TYPE ANY.

  IF i_export_hex IS INITIAL.
    ASSIGN i_value TO <l_value> CASTING TYPE c.
    MOVE <l_value> TO e_value.
  ELSE.
    MOVE i_value TO e_value.
  ENDIF.
ENDMETHOD.


METHOD set_attributes.
  me->gs_attributes = is_attributes.

  CASE me->gs_attributes-FIELD_SEPARATOR.
    WHEN 'TAB'.
      MOVE cl_abap_char_utilities=>horizontal_tab TO g_col_sep.
    WHEN 'COMMA'.
      MOVE ','          TO g_col_sep.
    WHEN 'SEMICOLON'.
      MOVE ';'          TO g_col_sep.
    WHEN 'SPACE'.
      concatenate '' '' into g_col_sep respecting blanks.
    WHEN 'OTHER'.
      MOVE me->gs_attributes-field_separator_other TO g_col_sep.
  ENDCASE.

ENDMETHOD.


method SET_COLUMNS.

  gt_columns = it_columns.

endmethod.
ENDCLASS.
