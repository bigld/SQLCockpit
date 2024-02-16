FUNCTION /cadaxo/sqlc_create_variant_ui.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_MODE) TYPE  CHAR1 DEFAULT 'I'
*"     REFERENCE(IL_VARIANT) TYPE  /CADAXO/SQLC_IL_VARIANTS
*"     REFERENCE(I_MODE_VARIANT) TYPE  CHAR1 OPTIONAL
*"  CHANGING
*"     REFERENCE(C_VARI_NAME) TYPE  /CADAXO/SQLCVARI_NAME OPTIONAL
*"----------------------------------------------------------------------
****************************************************************************************************
* Description             : Variants Create UI                                                     *
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

  gcl_controller->gs_il_variants = il_variant.

* call screen 200
  "APPEND 'INSERT_VAR' TO gt_excl_fcode_insert_var.
  "APPEND 'DOWNLD_VAR' TO gt_excl_fcode_downld_var.

  gcl_controller->g_mode_variant = i_mode_variant."COCKPIT-321 KA

  CALL SCREEN 0200 STARTING AT 30 7 ENDING AT 90 12.

  c_vari_name = gcl_controller->gs_il_variants-varname."COCKPIT-321 KA

* free
  gcl_controller->free( ).
  FREE gcl_controller.

ENDFUNCTION.
