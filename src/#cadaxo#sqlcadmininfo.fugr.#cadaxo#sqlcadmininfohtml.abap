FUNCTION /cadaxo/sqlcadmininfohtml.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IR_MAIN) TYPE REF TO  /CADAXO/CL_SQLC_COCKPIT_MAIN
*"       OPTIONAL
*"     REFERENCE(I_FORCE) TYPE  FLAG DEFAULT SPACE
*"----------------------------------------------------------------------
****************************************************************************************************
* Description             : Show admin info home screen html                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 03.01.2012               Release    : WAS 7.00                         *
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
  DATA: l_param_value TYPE /cadaxo/sqlcparameter_val.
  DATA: ls_adm_cust   TYPE /cadaxo/sqlc_admin_cust.

  CLEAR g_use_link.
  CLEAR g_button.
  IF ir_main IS SUPPLIED.
    gr_main = ir_main.
  ENDIF.

  /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).

  IF ls_adm_cust-home_use_link_date co ' 0'.
    ls_adm_cust-home_use_link_date = sy-datum.
    ls_adm_cust-home_use_link      = 'X'.
  ENDIF.

  g_use_link = ls_adm_cust-home_use_link.
  IF ls_adm_cust-home_use_link_date IS INITIAL OR i_force = abap_true.
    CALL SCREEN 0100 STARTING AT 7 2.
  ENDIF.


ENDFUNCTION.
