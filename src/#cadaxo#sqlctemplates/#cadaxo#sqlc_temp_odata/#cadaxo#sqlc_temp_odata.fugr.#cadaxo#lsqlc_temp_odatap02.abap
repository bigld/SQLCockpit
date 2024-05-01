*----------------------------------------------------------------------*
*       CLASS lcl_event_handler_html_viewer DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler_html_viewer DEFINITION.

  PUBLIC SECTION.
    METHODS: on_sapevent FOR EVENT sapevent OF cl_gui_html_viewer
      IMPORTING action getdata.

ENDCLASS.                    "lcl_event_handler_html_viewer DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler_html_viewer IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_handler_html_viewer IMPLEMENTATION.

  METHOD on_sapevent.

    g_current_step = getdata.

  ENDMETHOD.                    "on_sapevent

ENDCLASS.

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler_alv DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event_handler_alv  DEFINITION.

  PUBLIC SECTION.
    METHODS:
      hdl_rb_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id
                    e_column_id
                    es_row_no.

ENDCLASS.                    "lcl_event_handler_alv DEFINITION
*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_event_handler_alv
*&---------------------------------------------------------------------*
CLASS lcl_event_handler_alv IMPLEMENTATION.

  METHOD hdl_rb_click.

    DATA: ls_stable TYPE lvc_s_stbl.

    READ TABLE go_odata_wiz->gt_selopt ASSIGNING FIELD-SYMBOL(<ls_selopt>) INDEX e_row_id-index.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    ASSIGN COMPONENT e_column_id-fieldname OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<l_field>).
    IF sy-subrc = 0.
      IF <l_field> = abap_true.
        <l_field> = abap_false.
      ELSE.
        <l_field> = abap_true.
      ENDIF.
    ENDIF.

    ls_stable-row = abap_true.
    ls_stable-col = abap_true.
    gr_grid->refresh_table_display( is_stable = ls_stable ).

  ENDMETHOD.

ENDCLASS.
