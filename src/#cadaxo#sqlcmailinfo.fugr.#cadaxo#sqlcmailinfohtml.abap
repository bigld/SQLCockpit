FUNCTION /cadaxo/sqlcmailinfohtml.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IR_MAIN) TYPE REF TO  /CADAXO/CL_SQLC_COCKPIT_MAIN
*"       OPTIONAL
*"     REFERENCE(I_SQL) TYPE  STRING
*"     REFERENCE(I_MSG) TYPE  STRING
*"     REFERENCE(I_COCKPIT) TYPE  STRING
*"     REFERENCE(I_SAPCOMP) TYPE  STRING
*"----------------------------------------------------------------------
****************************************************************************************************
* Description             : Show mail info html                                                    *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 03.11.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    :                                                                        *
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

* globalize data
  g_sql     = i_sql.
  g_msg     = i_msg.
  g_cockpit = i_cockpit.
  g_sapcomp = i_sapcomp.
  CLEAR g_data_html.
  CLEAR g_data.

  CALL SCREEN 0100 STARTING AT 7 2.

ENDFUNCTION.
