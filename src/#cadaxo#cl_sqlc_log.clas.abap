CLASS /cadaxo/cl_sqlc_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS insert_sql_to_log
      IMPORTING i_sql_string       TYPE /cadaxo/sqlcsql_string
                i_sql_mode         TYPE /cadaxo/sqlcsql_mode DEFAULT '01'
      RETURNING VALUE(e_timestamp) TYPE timestampl .
    CLASS-METHODS update_sql_to_log
      IMPORTING i_sql_string     TYPE /cadaxo/sqlcstring
                i_timestamp      TYPE timestampl
                i_result_runtime TYPE /cadaxo/sqlcruntime
                i_result_lines   TYPE /cadaxo/sqlcresult_rows
                i_sql_mode       TYPE /cadaxo/sqlcsql_mode DEFAULT '01' .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /cadaxo/cl_sqlc_log IMPLEMENTATION.

  METHOD insert_sql_to_log.
****************************************************************************************************
* Description             : Insert sql command to log                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_sqlclog    TYPE /cadaxo/sqlclog.
    DATA l_sqllog_xml TYPE /cadaxo/sqlc_sqllog.
    DATA l_xml        TYPE string.

    CLEAR: l_sqlclog.

    GET TIME STAMP FIELD e_timestamp.

    CLEAR l_sqllog_xml.
    l_sqllog_xml-sql_string    = i_sql_string.
    l_sqllog_xml-result_status = '01'.
    l_sqllog_xml-sql_mode      = i_sql_mode.

    CALL TRANSFORMATION id SOURCE log = l_sqllog_xml
                           RESULT XML l_xml.

    cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                                 IMPORTING gzip_out = l_sqlclog-sql_log ).
    l_sqlclog-timestamp = e_timestamp.
    l_sqlclog-uname     = sy-uname.


    INSERT /cadaxo/sqlclog FROM l_sqlclog.          "#EC CI_IMUD_NESTED

    COMMIT WORK.

    FREE: l_sqlclog, l_xml, l_sqllog_xml.

  ENDMETHOD.

  METHOD update_sql_to_log.
****************************************************************************************************
* Description             : Insert sql command to log                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Oliver Wahrstötter       Company    : CADAXO GesmbH                    *
* Date                    : 01.03.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
****************************************************************************************************

    DATA l_sqlclog    TYPE /cadaxo/sqlclog.
    DATA l_sqllog_xml TYPE /cadaxo/sqlc_sqllog.
    DATA l_xml        TYPE string.

    CLEAR: l_sqlclog.
    CLEAR: l_sqllog_xml.

    l_sqllog_xml-sql_string          = i_sql_string.
    l_sqllog_xml-result_status       = '00'.
    l_sqllog_xml-sql_mode            = i_sql_mode.
    l_sqllog_xml-result_rows         = i_result_lines.
    l_sqllog_xml-result_runtime      = i_result_runtime-runtime.
    l_sqllog_xml-result_runtime_unit = i_result_runtime-unit.
    CALL TRANSFORMATION id SOURCE log = l_sqllog_xml
                           RESULT XML l_xml .
    cl_abap_gzip=>compress_text( EXPORTING text_in  = l_xml
                                 IMPORTING gzip_out = l_sqlclog-sql_log ).

    l_sqlclog-uname     = sy-uname.
    l_sqlclog-timestamp = i_timestamp.

    UPDATE /cadaxo/sqlclog FROM l_sqlclog.          "#EC CI_IMUD_NESTED

    COMMIT WORK.

    FREE: l_sqlclog, l_xml, l_sqllog_xml.
  ENDMETHOD.
ENDCLASS.
