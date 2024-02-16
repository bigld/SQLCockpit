*&---------------------------------------------------------------------*
*& Report  /CADAXO/SQLC_ADM_USERSPACECONS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  /cadaxo/sqlc_adm_userspacecons.

DATA lt_sqlcsres        TYPE TABLE OF /cadaxo/sqlcsres.
DATA lt_saved_lists     TYPE TABLE OF /cadaxo/sqlcsresalv.
DATA ls_saved_lists     TYPE /cadaxo/sqlcsresalv.

DATA gr_table           TYPE REF TO cl_salv_table.
DATA gr_sorts           TYPE REF TO cl_salv_sorts.
DATA gr_agg             TYPE REF TO cl_salv_aggregations.
CLASS lcl_handle_events DEFINITION DEFERRED.
DATA gr_events          TYPE REF TO lcl_handle_events.
DATA lr_events          TYPE REF TO cl_salv_events_table.
DATA gr_selections      TYPE REF TO cl_salv_selections.

DATA lr_columns         TYPE REF TO cl_salv_columns_table.
DATA lr_column          TYPE REF TO cl_salv_column.
DATA ls_columns         TYPE salv_s_column_ref.

DATA lv_repid TYPE syrepid.
DATA ls_rows  TYPE int4.
DATA lt_rows  TYPE salv_t_row.
DATA l_rc.

FIELD-SYMBOLS: <gt_table>       TYPE table.
FIELD-SYMBOLS: <ls_sqlcsres>    LIKE LINE OF lt_sqlcsres.
FIELD-SYMBOLS: <ls_saved_lists> TYPE /cadaxo/sqlcsresalv.

**--------------------------------------------------------------------
**       CLASS lcl_handle_events DEFINITION
**--------------------------------------------------------------------
*
CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.

ENDCLASS.                    "lcl_handle_events DEFINITION

START-OF-SELECTION.

  AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
  IF sy-subrc NE 0.
    MESSAGE e036(/cadaxo/sqlc).
  ENDIF.

  PERFORM get_table.

  lv_repid = sy-repid.

  TRY.
      cl_salv_table=>factory(
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_table
        CHANGING
          t_table      = lt_saved_lists ).
    CATCH cx_salv_msg.
  ENDTRY.

  lr_columns = gr_table->get_columns( ).

  lr_column = lr_columns->get_column( 'SOURCE' ).
  lr_column->set_visible( abap_false ).
  lr_column = lr_columns->get_column( 'SOURCE_ICON' ).
  lr_column->set_visible( abap_false ).
  lr_column = lr_columns->get_column( 'LIST_GUID' ).
  lr_column->set_visible( abap_false ).
  lr_column = lr_columns->get_column( 'TYPE' ).
  lr_column->set_visible( abap_false ).
  lr_column = lr_columns->get_column( 'TYPE_ICON' ).
  lr_column->set_output_length( 10 ).

  gr_sorts = gr_table->get_sorts( ).
  gr_sorts->add_sort( columnname = 'OWNER' subtotal = abap_true ).
  gr_agg = gr_table->get_aggregations( ).
  gr_agg->add_aggregation( 'SPACE_CONSUMING' ).

  gr_table->set_screen_status(
      report        = lv_repid
      pfstatus      = 'ALVSTAT'
      set_functions = gr_table->c_functions_all
         ).

  gr_selections = gr_table->get_selections( ).
  gr_selections->set_selection_mode( gr_selections->multiple ).


  lr_events = gr_table->get_event( ).
  CREATE OBJECT gr_events.
  SET HANDLER gr_events->on_user_command FOR lr_events.

  gr_table->display( ).

END-OF-SELECTION.

**--------------------------------------------------------------------
**       CLASS lcl_handle_events IMPLEMENTATION
**--------------------------------------------------------------------
*
CLASS lcl_handle_events IMPLEMENTATION.

  METHOD on_user_command.

    CASE e_salv_function.
      WHEN 'REFR'.
        PERFORM get_table.
        gr_table->refresh( refresh_mode = if_salv_c_refresh=>full ).

      WHEN 'DELE'.
        gr_selections = gr_table->get_selections( ).
        lt_rows = gr_selections->get_selected_rows( ).

        IF lt_rows IS NOT INITIAL.
          CALL FUNCTION 'POPUP_TO_CONFIRM'
            EXPORTING
              titlebar      = text-t02
              text_question = text-t01
            IMPORTING
              answer        = l_rc.
          IF l_rc EQ '1'.
            LOOP AT lt_rows INTO ls_rows.
              READ TABLE lt_saved_lists ASSIGNING <ls_saved_lists> INDEX ls_rows.
              IF sy-subrc = 0.
                /cadaxo/cl_sqlc_cockpit_lists=>delete_list( EXPORTING i_list_guid = <ls_saved_lists>-list_guid
                                                                      i_jobcount = <ls_saved_lists>-jobcount
                                                                      i_type      = <ls_saved_lists>-type ).
                MESSAGE s082(/cadaxo/sqlc).
                PERFORM write_ulog USING <ls_saved_lists>.
              ELSE.
                MESSAGE s079(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
              ENDIF.
            ENDLOOP.
*           Refresh ALV
            PERFORM get_table.
            gr_table->refresh( refresh_mode = if_salv_c_refresh=>full ).
          ELSE.
            MESSAGE s042(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
          ENDIF.
        ELSE.
          MESSAGE s079(/cadaxo/sqlc)  DISPLAY LIKE 'E'.
        ENDIF.
    ENDCASE.

  ENDMETHOD.                    "on_user_command

ENDCLASS.                    "lcl_handle_events IMPLEMENTATION
*&---------------------------------------------------------------------*
*&      Form  GET_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_table .

  CLEAR: lt_sqlcsres, lt_saved_lists.

  SELECT * FROM /cadaxo/sqlcsres
           INTO CORRESPONDING FIELDS OF TABLE lt_sqlcsres
           WHERE ress_guid NE 0.

  SORT lt_sqlcsres BY uname.

  LOOP AT lt_sqlcsres ASSIGNING <ls_sqlcsres>.
    CLEAR ls_saved_lists.
    MOVE-CORRESPONDING <ls_sqlcsres> TO ls_saved_lists.
    MOVE <ls_sqlcsres>-uname   TO ls_saved_lists-owner.
    CONVERT TIME STAMP <ls_sqlcsres>-create_timestamp TIME ZONE sy-zonlo INTO DATE ls_saved_lists-crdate TIME ls_saved_lists-crtime.
    ls_saved_lists-source          = 'SELF'.
    ls_saved_lists-space_consuming = <ls_sqlcsres>-space_cons_zip.
    APPEND ls_saved_lists TO lt_saved_lists.
  ENDLOOP.

* do some changes with the list
  LOOP AT lt_saved_lists ASSIGNING <ls_saved_lists>.

* replace source with icon
    CASE <ls_saved_lists>-type.
      WHEN 'MAN'.
        WRITE icon_gis_pan        TO <ls_saved_lists>-type_icon.
      WHEN 'JOB'.
        WRITE icon_background_job TO <ls_saved_lists>-type_icon.
      WHEN /cadaxo/cl_sqlc_cockpit_main=>gc_saved_list_shared.
        WRITE icon_workflow_external_event TO <ls_saved_lists>-type_icon.
      WHEN OTHERS.
        WRITE icon_dummy          TO <ls_saved_lists>-type_icon.
    ENDCASE.

  ENDLOOP.
ENDFORM.                    " GET_TABLE
*&---------------------------------------------------------------------*
*&      Form  WRITE_ULOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<LS_SAVED_LISTS>  text
*----------------------------------------------------------------------*
FORM write_ulog  USING    p_saved_list TYPE /cadaxo/sqlcsresalv.

  DATA ls_log          TYPE /cadaxo/sqlculog_api.
  DATA lr_user_log     TYPE REF TO /cadaxo/cl_sqlc_user_log.

  CREATE OBJECT lr_user_log.
  CLEAR ls_log.

  ls_log-object     =  lr_user_log->con_adm_usrspc.
  ls_log-object_key = p_saved_list-list_guid.
  ls_log-type       = 'I'.
  ls_log-id         = '/CADAXO/SQLC'.
  ls_log-number     = '086'.
  ls_log-message_v1 = sy-uname.
  ls_log-message_v2 = p_saved_list-description.
  ls_log-message_v3 = p_saved_list-owner.

  lr_user_log->add_ulog(
      i_log_message = ls_log ).

ENDFORM.                    " WRITE_ULOG
