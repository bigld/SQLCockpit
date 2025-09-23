CLASS /cadaxo/cl_sqlc_special_parse DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS is_datasource IMPORTING i_sql_string           TYPE string
                                RETURNING VALUE(r_is_datasource) TYPE abap_bool.
    CLASS-METHODS may_be_datasource IMPORTING i_sql_string        TYPE string
                                    RETURNING VALUE(r_datasource) TYPE abap_bool.
    CLASS-METHODS detect_select_pattern IMPORTING i_sql_string   TYPE string
                                        EXPORTING e_is_select    TYPE abap_bool
                                                  e_is_distinct  TYPE abap_bool
                                                  e_is_single    TYPE abap_bool
                                                  e_match_len    TYPE i
                                                  e_match_off    TYPE i.

    CONSTANTS max_length_datasource_name TYPE i VALUE 30.
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS /cadaxo/cl_sqlc_special_parse IMPLEMENTATION.
  METHOD may_be_datasource.
****************************************************************************************************
* Description             : may be datasource for quick select                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 14.11.2020               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 21.09.2020 | Attila Kajtar        | DUMP select                                 | COCKPIT-460    *
*------------+----------------------+---------------------------------------------+----------------*
* 14.11.2020 | Domi Bigl            | No SELECT but table                         | COCKPIT-459    *
****************************************************************************************************
    CONSTANTS active TYPE as4local VALUE 'A'.

    r_datasource = abap_false.

    DATA(sql_string) = condense( i_sql_string ).
    SPLIT sql_string AT space INTO sql_string DATA(rest).

    IF rest IS INITIAL AND strlen( sql_string ) <= max_length_datasource_name.
      r_datasource = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD is_datasource.
****************************************************************************************************
* Description             : Is datasource only for quick select                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 14.11.2020               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxr       Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 21.09.2020 | Attila Kajtar        | DUMP select                                 | COCKPIT-460    *
*------------+----------------------+---------------------------------------------+----------------*
* 14.11.2020 | Domi Bigl            | No SELECT but table                         | COCKPIT-459    *
****************************************************************************************************
    CONSTANTS active TYPE as4local VALUE 'A'.

    r_is_datasource = abap_false.

    IF strlen( i_sql_string ) <= max_length_datasource_name. "COCKPIT-460
      SELECT SINGLE @abap_true FROM dd02l WHERE tabname = @i_sql_string
                                     AND as4local = @active
                                     INTO @r_is_datasource.
      IF sy-subrc <> 0.
        SELECT SINGLE @abap_true FROM ddldependency
                                     WHERE objectname = @i_sql_string
                                     AND state = @active
                                      INTO @r_is_datasource.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD detect_select_pattern.
    DATA(sql_input) = to_upper( i_sql_string ).
    CONDENSE sql_input.

    CLEAR: e_is_select,
           e_is_distinct,
           e_is_single,
           e_match_len,
           e_match_off.

    FIND PCRE '^SELECT(\s+DISTINCT)?(\s+SINGLE)?\s+'
         IN sql_input IGNORING CASE
         MATCH OFFSET e_match_off
         MATCH LENGTH e_match_len
         SUBMATCHES DATA(lv_dist) DATA(lv_single).

    IF sy-subrc = 0.
      e_is_select = abap_true.
      e_is_distinct = xsdbool( lv_dist IS NOT INITIAL ).
      e_is_single   = xsdbool( lv_single IS NOT INITIAL ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
