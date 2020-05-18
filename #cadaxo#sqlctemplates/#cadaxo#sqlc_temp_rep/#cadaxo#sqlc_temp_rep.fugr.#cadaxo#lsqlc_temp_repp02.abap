*----------------------------------------------------------------------*
*       CLASS lcl_event_handler2 DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event_handler2  DEFINITION.

  PUBLIC SECTION.
    METHODS:
       constructor IMPORTING i_default_rb TYPE fieldname,
       hdl_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
                                 IMPORTING e_modified
                                           et_good_cells,
       hdl_rb_click FOR EVENT hotspot_click OF cl_gui_alv_grid
                    IMPORTING e_row_id
                              e_column_id
                              es_row_no.

  PRIVATE SECTION.
    DATA: gt_rbtable  TYPE RANGE OF fieldname.
    DATA: g_def_field TYPE fieldname.

ENDCLASS.                    "lcl_event_handler2 DEFINITION
*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_event_handler2
*&---------------------------------------------------------------------*
CLASS lcl_event_handler2 IMPLEMENTATION.

  METHOD constructor.

    FIELD-SYMBOLS: <lwa_rbtable> LIKE LINE OF gt_rbtable.

    APPEND INITIAL LINE TO gt_rbtable ASSIGNING <lwa_rbtable>.
    <lwa_rbtable>-sign   = 'I'.
    <lwa_rbtable>-option = 'EQ'.
    <lwa_rbtable>-low    = 'HARDCODED'.
    APPEND INITIAL LINE TO gt_rbtable ASSIGNING <lwa_rbtable>.
    <lwa_rbtable>-sign   = 'I'.
    <lwa_rbtable>-option = 'EQ'.
    <lwa_rbtable>-low    = 'SELOPT_WITHOUT_DEFAULT'.
    APPEND INITIAL LINE TO gt_rbtable ASSIGNING <lwa_rbtable>.
    <lwa_rbtable>-sign   = 'I'.
    <lwa_rbtable>-option = 'EQ'.
    <lwa_rbtable>-low    = 'SELOPT_WITH_DEFAULT'.

    g_def_field = i_default_rb.

*   Keywords select -> later
*      APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
*      <wa_keyw>-keyw = 'FROM'.
*      <wa_keyw>-line_feed = abap_true.
*      <wa_keyw>-spaces = '7'.
*      APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
*      <wa_keyw>-keyw = 'WHERE'.
*      <wa_keyw>-line_feed = abap_true.
*      <wa_keyw>-spaces = '7'.
*      APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
*      <wa_keyw>-keyw = 'INTO'.
*      <wa_keyw>-line_feed = abap_true.
*      <wa_keyw>-spaces = '7'.
*      APPEND INITIAL LINE TO gst_keyw ASSIGNING <wa_keyw>.
*      <wa_keyw>-keyw = 'GROUP'.
*      <wa_keyw>-line_feed = abap_true.
*      <wa_keyw>-spaces = '7'.

  ENDMETHOD.                    "constructor


  METHOD hdl_data_changed_finished.

    DATA: lt_cells                     TYPE TABLE OF lvc_s_modi.
    DATA: l_flagged                    TYPE c.
    DATA: lwa_stable_ref         TYPE lvc_s_stbl.
    FIELD-SYMBOLS: <lwa_good_cell>     TYPE lvc_s_modi.
    FIELD-SYMBOLS: <l_default_field>   TYPE ANY.
    FIELD-SYMBOLS: <l_field>           TYPE ANY.
    FIELD-SYMBOLS: <lwa_rbtable>       LIKE LINE OF gt_rbtable.

* NOT USED
    CHECK e_modified = c_true.

    CLEAR l_flagged.
    LOOP AT et_good_cells ASSIGNING <lwa_good_cell> WHERE fieldname IN gt_rbtable.
      READ TABLE gt_selopt ASSIGNING <wa_selopt> INDEX <lwa_good_cell>-row_id.
      CHECK sy-subrc = 0.

      LOOP AT gt_rbtable ASSIGNING <lwa_rbtable>.
        ASSIGN COMPONENT <lwa_rbtable>-low OF STRUCTURE <wa_selopt> TO <l_field>.
        CHECK sy-subrc = 0.
        IF <lwa_rbtable>-low = g_def_field.
          ASSIGN <l_field> TO <l_default_field>.
        ENDIF.

        IF <lwa_rbtable>-low = <lwa_good_cell>-fieldname.
          IF NOT <lwa_good_cell>-value IS INITIAL.
            l_flagged = c_true.
          ENDIF.
          CONTINUE.
        ENDIF.
        <l_field> = icon_wd_radio_button_empty.
      ENDLOOP.
    ENDLOOP.
    IF sy-subrc = 0 AND l_flagged IS INITIAL.
*     CDX130-012 Begin
*     before set the flag --> check style table if field is disabled
      READ TABLE <wa_selopt>-style WITH KEY fieldname = g_def_field
                                            style = cl_gui_alv_grid=>mc_style_disabled
                                            TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        <l_default_field> = icon_radiobutton.
      ENDIF.
*     CDX130-012 End
    ENDIF.


    lwa_stable_ref-row = c_true.
    lwa_stable_ref-col = c_true.
    CALL METHOD gr_grid->refresh_table_display( is_stable = lwa_stable_ref ).

  ENDMETHOD.                    "handle_data_changed

  METHOD hdl_rb_click.

    FIELD-SYMBOLS: <lwa_selopt>    TYPE /cadaxo/sqlc_temp_rep_sel_str.
    FIELD-SYMBOLS: <l_field>       TYPE ANY.
    DATA: lwa_stable               TYPE lvc_s_stbl.

    READ TABLE gt_selopt ASSIGNING <lwa_selopt> INDEX e_row_id-index.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    READ TABLE <wa_selopt>-style WITH KEY fieldname = e_column_id-fieldname
                                          style = cl_gui_alv_grid=>mc_style_disabled
                                          TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.

    <lwa_selopt>-selopt_with_default    = icon_wd_radio_button_empty.
    <lwa_selopt>-selopt_without_default = icon_wd_radio_button_empty.
    <lwa_selopt>-hardcoded              = icon_wd_radio_button_empty.

    ASSIGN COMPONENT e_column_id-fieldname OF STRUCTURE <lwa_selopt> TO <l_field>.
    IF sy-subrc = 0.
      <l_field> = icon_radiobutton.
    ELSE.
      RETURN.
    ENDIF.

    lwa_stable-row = c_true.
    lwa_stable-col = c_true.
    CALL METHOD gr_grid->refresh_table_display( is_stable = lwa_stable ).
  ENDMETHOD.                    "hdl_rb_click
ENDCLASS.               "lcl_event_handler2
