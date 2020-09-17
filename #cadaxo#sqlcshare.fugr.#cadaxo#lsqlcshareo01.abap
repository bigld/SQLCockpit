*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCSHAREO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PBO_3001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_3001 OUTPUT.

  SET PF-STATUS 'MAIN_3001'.

  CASE gv_export_type.
    WHEN /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-symbols.
      SET TITLEBAR '3001_3'.
    WHEN /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-variant.
      SET TITLEBAR '3001_5'.
    WHEN /cadaxo/cl_sqlc_cockpit_api=>cs_api_types-savedList.
      SET TITLEBAR '3001_6'.
    WHEN OTHERS.
      SET TITLEBAR '3001'.
  ENDCASE.

  IF gr_cont_text_share_descr IS INITIAL.

    gr_cont_text_share_descr = NEW #( container_name = 'GCONT_TEXT_SHARE_DESCR' ).
    gr_text_share_3001 = NEW #( parent = gr_cont_text_share_descr ).
    gr_text_share_3001->set_toolbar_mode( toolbar_mode = '0' ).

  ENDIF.

  gr_text_share_3001->delete_text( ). "TODO - SHOULD NOT BE NECESSARY
*  begin of change 420
  DATA: lt_self_share LIKE STANDARD TABLE OF gv_text.
  IF gv_text IS NOT INITIAL.
  APPEND gv_text TO lt_self_share.
      gr_text_share_3001->set_text_as_r3table(
        EXPORTING
          table           = lt_self_share    " table with text
        EXCEPTIONS
          error_dp        = 1
          error_dp_create = 2
          others          = 3 ).
          CLEAR lt_self_share.
  ENDIF.
*  end   of change 420
ENDMODULE.
MODULE pai_3001 INPUT.

****************************************************************************************************
* Description             : pai 3000                                                              *
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
* 26.01.2018 |Pat                   |select symbols for export                    |COCKPIT-294     *
*------------+----------------------+---------------------------------------------+----------------*
* 08.10.2018 |Pat                   |Share Saved List                             |COCKPIT-401     *
****************************************************************************************************

  DATA: lv_text(10000) TYPE c.
  DATA: lt_data_tab    LIKE STANDARD TABLE OF lv_text.
  DATA: lv_description TYPE string.
  DATA: lv_comm_error  TYPE c LENGTH 255.

*    CLEAR g_html_request.

  CASE g_ok_code.
    WHEN 'SAVE'.

      gr_text_share_3001->get_text_as_r3table( IMPORTING  table  = lt_data_tab
                                               EXCEPTIONS OTHERS = 1 ).

      CLEAR lv_description.
      LOOP AT lt_data_tab ASSIGNING FIELD-SYMBOL(<ls_data_tab>).
        lv_description = lv_description && <ls_data_tab>.
      ENDLOOP.

      CALL FUNCTION '/CADAXO/SQLC_SHARE_INSERT' DESTINATION g_rfcdest  "+cockpit-295
        EXPORTING
*         iv_sender             = iv_sender
*         iv_sender_typ         = g_sender_typ
          iv_receiver           = g_receiver
*         iv_receiver_typ       = iv_receiver_typ
*         iv_expiration         = iv_expiration
          iv_export_type        = gv_export_type
          iv_description        = lv_description
          it_symbols            = gt_symbols
          it_sql                = gt_sql
          is_variant            = gs_variant
          is_saved_list         = gs_saved_list
          iv_rfcdest            = g_rfcdest
          iv_rfcsender          = CONV /cadaxo/sqlcapi_rfcsender( sy-sysid )
        EXCEPTIONS
          system_failure        = 1 MESSAGE lv_comm_error
          communication_failure = 2 MESSAGE lv_comm_error
          OTHERS                = 3.

      IF sy-subrc <> 0.
        MESSAGE lv_comm_error TYPE 'E'.

      ELSE.
        MESSAGE s126(/cadaxo/sqlc) WITH g_receiver.
        lcl_worker=>leave_screen( ).

      ENDIF.

    WHEN 'CANCEL'.
      lcl_worker=>leave_screen( ).

  ENDCASE.

  CLEAR g_ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_RECEIVER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_receiver INPUT.

  READ TABLE gt_sql_cockpit_standard_users TRANSPORTING NO FIELDS WITH KEY uname = g_receiver.
  IF sy-subrc <> 0.
    MESSAGE e125(/cadaxo/sqlc) WITH g_receiver.
  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  CHECK_RECEIVER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_rfcdest INPUT.

  IF g_rfcdest IS INITIAL.
    EXIT.
  ENDIF.

  IF gt_rfcdest IS INITIAL.
    SELECT rfcdest AS value
      INTO CORRESPONDING FIELDS OF TABLE gt_rfcdest
      FROM rfcdes.
  ENDIF.

  READ TABLE gt_rfcdest TRANSPORTING NO FIELDS WITH KEY value = g_rfcdest.
  IF sy-subrc <> 0.
    MESSAGE e134(/cadaxo/sqlc) WITH g_rfcdest.
  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  HELP_RECEIVER  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE help_receiver INPUT.

  DATA lt_dynpfields TYPE TABLE OF dynpread.
  DATA lt_return TYPE TABLE OF ddshretval.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'UNAME'
      value_org       = 'S'
    TABLES
      value_tab       = gt_sql_cockpit_standard_users
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
    APPEND INITIAL LINE TO lt_dynpfields ASSIGNING FIELD-SYMBOL(<ls_dynpfields>).
    <ls_dynpfields>-fieldname  = 'G_RECEIVER'.
    <ls_dynpfields>-fieldvalue = <ls_return>-fieldval.
  ENDLOOP.

  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname     = '/CADAXO/SAPLSQLCSHARE'
      dynumb     = '3001'
    TABLES
      dynpfields = lt_dynpfields
    EXCEPTIONS
      OTHERS     = 0.


ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  HELP_RECEIVER  INPUT
*&---------------------------------------------------------------------*
MODULE help_receiver_rfcdest INPUT.

  DATA lt_dynpfields_rfc TYPE STANDARD TABLE OF dynpread.
  DATA lt_return_rfc     TYPE STANDARD TABLE OF ddshretval.

  CLEAR gt_rfcdest.
  SELECT rfcdest AS value
    INTO CORRESPONDING FIELDS OF TABLE gt_rfcdest
    FROM rfcdes.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'VALUE'
      value_org       = 'S'
      window_title    = 'RFC Destination'(001)
    TABLES
      value_tab       = gt_rfcdest
      return_tab      = lt_return_rfc
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  LOOP AT lt_return_rfc ASSIGNING FIELD-SYMBOL(<ls_return_rfc>).
    APPEND INITIAL LINE TO lt_dynpfields_rfc ASSIGNING FIELD-SYMBOL(<ls_dynpfields_rfc>).
    <ls_dynpfields_rfc>-fieldname  = 'G_RFCDEST'.
    <ls_dynpfields_rfc>-fieldvalue = <ls_return_rfc>-fieldval.
  ENDLOOP.

  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname     = '/CADAXO/SAPLSQLCSHARE'
      dynumb     = '3001'
    TABLES
      dynpfields = lt_dynpfields_rfc
    EXCEPTIONS
      OTHERS     = 0.

ENDMODULE.
