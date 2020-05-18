FUNCTION /cadaxo/sqlc_maintaint_var_ui.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_MODE) TYPE  CHAR1
*"  EXPORTING
*"     REFERENCE(E_IL_VARIANT) TYPE  /CADAXO/SQLC_IL_VARIANTS
*"----------------------------------------------------------------------
****************************************************************************************************
* Description             : Variants Maintain UI                                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.09.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 30.11.2010                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

* create controller class
  CREATE OBJECT gcl_controller.
  gcl_controller->set_mode( i_mode ).

* call screen 0100
  CALL SCREEN 0100 STARTING AT 10 1 ENDING AT 198 29.

* get selected variant
  e_il_variant = gcl_controller->gs_il_variants.

* free
  gcl_controller->free( ).
  FREE gcl_controller.

ENDFUNCTION.
