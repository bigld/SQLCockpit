FUNCTION /cadaxo/sqlcsubroutinepool.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_VERSION) TYPE  /CADAXO/SQLC_SELECT_VERSION
*"     VALUE(I_TRACE) TYPE  BOOLEAN
*"     VALUE(I_USER_SETT_SQL_TRACE) TYPE  /CADAXO/SQLCSQLTRACE
*"     VALUE(I_USER_SETT_TABB_TRACE) TYPE  /CADAXO/SQLCTABLEBUFFERTRACE
*"  EXPORTING
*"     VALUE(E_ERROR_MESSAGE) TYPE  STRING
*"     VALUE(E_RUNTIME) TYPE  /CADAXO/SQLCRUNTIME
*"     VALUE(E_RESULT_LINES) TYPE  INT4
*"     VALUE(ET_RESULT) TYPE  XSTRING
*"     VALUE(ET_DFIES_ALL) TYPE  /CADAXO/SQLCDFIES_T
*"     VALUE(ET_DFIES) TYPE  /CADAXO/SQLCDFIES_T
*"  CHANGING
*"     VALUE(IC_DATA) TYPE  XSTRING
*"----------------------------------------------------------------------
****************************************************************************************************
* Description             : Generate and Execute Subroutine Pool for Subselects                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.11.2015               Release    : WAS 7.40                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 04.01.2016                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 01.06.2016 | Ana Lekic            | activate the trace later                    | $001 COCKPIT-59*
****************************************************************************************************

  CASE i_version.
    WHEN /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_1.

      PERFORM process_version_1 CHANGING e_error_message
                                         e_runtime
                                         e_result_lines
                                         et_result
                                         et_dfies
                                         ic_data.

    WHEN /cadaxo/cl_sqlc_cockpit_parse=>c_select_version_2.

      PERFORM process_version_2 CHANGING e_error_message
                                         e_runtime
                                         e_result_lines
                                         et_result
                                         et_dfies
                                         et_dfies_all
                                         ic_data.

  ENDCASE.

ENDFUNCTION.
