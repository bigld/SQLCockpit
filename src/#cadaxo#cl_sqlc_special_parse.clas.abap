CLASS /cadaxo/cl_sqlc_special_parse DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter i_sql_string | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_is_datasource | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS is_datasource IMPORTING i_sql_string           TYPE string
                                RETURNING VALUE(r_is_datasource) TYPE abap_bool.
    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter i_sql_string | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_datasource | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS may_be_datasource IMPORTING i_sql_string        TYPE string
                                    RETURNING VALUE(r_datasource) TYPE abap_bool.

    TYPES: BEGIN OF ty_select_pattern,
             is_select    TYPE abap_bool,
             is_distinct  TYPE abap_bool,
             is_single    TYPE abap_bool,
             match_length TYPE i,
             match_offset TYPE i,
           END OF ty_select_pattern.
    CLASS-METHODS detect_select_pattern IMPORTING i_sql_string            TYPE string
                                        RETURNING VALUE(r_select_pattern) TYPE ty_select_pattern.

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

    CLEAR r_select_pattern.

    FIND PCRE '^SELECT(\s+DISTINCT)?(\s+SINGLE)?\s+'
         IN sql_input IGNORING CASE
         MATCH OFFSET r_select_pattern-match_offset
         MATCH LENGTH r_select_pattern-match_length
         SUBMATCHES DATA(lv_dist) DATA(lv_single).

    IF sy-subrc = 0.
      r_select_pattern-is_select = abap_true.
      r_select_pattern-is_distinct = xsdbool( lv_dist IS NOT INITIAL ).
      r_select_pattern-is_single   = xsdbool( lv_single IS NOT INITIAL ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
