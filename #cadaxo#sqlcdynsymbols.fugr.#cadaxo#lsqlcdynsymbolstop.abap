FUNCTION-POOL /cadaxo/sqlcdynsymbols.       "MESSAGE-ID ..

CLASS lcl_event_receiver DEFINITION DEFERRED.

DATA: gr_cc_alv_sym TYPE REF TO cl_gui_custom_container,
      gr_alv_grid   TYPE REF TO cl_gui_alv_grid,

      gt_dynamic_symbols TYPE TABLE OF /CADAXO/SQLCSYMB_ALV,
      lr_event_receiver TYPE REF TO lcl_event_receiver,

      g_symbol_name     TYPE /cadaxo/sqlcsymbol_name.

*
CLASS lcl_event_receiver DEFINITION.

  PUBLIC SECTION.
    METHODS:

    handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
            IMPORTING e_row e_column.

  PRIVATE SECTION.

ENDCLASS.                    "lcl_event_receiver DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_event_receiver IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.

  METHOD handle_double_click.
    DATA: ls_dynamic_symbols LIKE LINE OF gt_dynamic_symbols.

    READ TABLE gt_dynamic_symbols INDEX e_row-index INTO ls_dynamic_symbols.
    IF sy-subrc EQ 0.

      MOVE ls_dynamic_symbols-symbol TO g_symbol_name.

      CALL METHOD cl_gui_cfw=>set_new_ok_code
        EXPORTING
          new_code = 'OK'.

    ENDIF.
  ENDMETHOD.                           "handle_double_click

ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION
