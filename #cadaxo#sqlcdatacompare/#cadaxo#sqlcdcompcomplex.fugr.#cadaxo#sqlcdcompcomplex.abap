FUNCTION /cadaxo/sqlcdcompcomplex.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_SOURCE) TYPE  STANDARD TABLE
*"     REFERENCE(IT_TARGET) TYPE  STANDARD TABLE
*"     REFERENCE(I_SOURCE_NUMBER) TYPE  I
*"     REFERENCE(I_TARGET_NUMBER) TYPE  I
*"     REFERENCE(IT_SOURCE_DFIES) TYPE  /CADAXO/SQLCDFIES_T
*"     REFERENCE(IT_TARGET_DFIES) TYPE  /CADAXO/SQLCDFIES_T
*"     REFERENCE(I_SOURCE_NAME)
*"     REFERENCE(I_TARGET_NAME)
*"     REFERENCE(I_USER_SETTINGS) TYPE  /CADAXO/SQLCUSRP_DYN
*"     REFERENCE(IT_RESULT_DETAILS) TYPE  /CADAXO/SQLCRESULT_DETAILS_T
*"     REFERENCE(IV_SOURCE_SELECT_TYPE) TYPE  I DEFAULT 0
*"     REFERENCE(IV_TARGET_SELECT_TYPE) TYPE  I DEFAULT 0
*"----------------------------------------------------------------------

  g_controller = NEW /cadaxo/cl_sqlc_dcomp_complex(
      it_source = it_source
      it_target = it_target
      i_source_number = i_source_number
      i_target_number = i_target_number
      it_source_dfies = it_source_dfies
      it_target_dfies = it_target_dfies
      i_source_name = conv #( i_source_name )
      i_target_name = conv #( i_target_name )
      iv_source_select_type = iv_source_select_Type
      iv_target_select_type = iv_target_select_type
      i_user_settings = i_user_settings
      it_result_details = it_result_details ).

  g_subscreen = '0200'.

  CALL SCREEN 0100 STARTING AT 10 1 ENDING AT 195 28.

ENDFUNCTION.
