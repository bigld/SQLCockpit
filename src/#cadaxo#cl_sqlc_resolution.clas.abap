CLASS /cadaxo/cl_sqlc_resolution DEFINITION
  PUBLIC
  FINAL
  CREATE PROTECTED .

  PUBLIC SECTION.
    CLASS-METHODS get_instance
      RETURNING
        VALUE(r_instance) TYPE REF TO /cadaxo/cl_sqlc_resolution.
    METHODS constructor.

    METHODS: get_button_height RETURNING VALUE(r_height) TYPE int4.
    METHODS: get_button_width RETURNING VALUE(r_width) TYPE int4.
    METHODS: calculate_error_height IMPORTING i_number_of_errors TYPE int4
                                    RETURNING VALUE(r_height)    TYPE int4.



  PROTECTED SECTION.
    CLASS-DATA: instance TYPE REF TO /cadaxo/cl_sqlc_resolution.

    METHODS calculate_height_for_button RETURNING VALUE(e_height) TYPE int4 .
    METHODS calculate_width_for_button RETURNING VALUE(e_width) TYPE int4 .

    DATA: button_height TYPE int4.
    DATA: button_width TYPE int4.
ENDCLASS.



CLASS /cadaxo/cl_sqlc_resolution IMPLEMENTATION.

  METHOD get_instance.

    IF instance IS INITIAL.
      instance = NEW #( ).
    ENDIF.
    r_instance = instance.

  ENDMETHOD.

  METHOD constructor.
    button_height = calculate_height_for_button( ).
    button_width = calculate_width_for_button( ).
  ENDMETHOD.
  METHOD calculate_height_for_button.

    e_height = cl_gui_cfw=>compute_metric_from_dynp( metric = cl_gui_control=>metric_pixel x_or_y = 'Y' in = 1 ) + 4.
    IF e_height < 20.
      e_height = 20.
    ENDIF.

  ENDMETHOD.


  METHOD calculate_width_for_button.

    e_width = cl_gui_cfw=>compute_metric_from_dynp( metric = cl_gui_control=>metric_pixel x_or_y = 'X' in = 3 ).
    IF e_width < 30.
      e_width = 30.
    ENDIF.

  ENDMETHOD.

  METHOD calculate_error_height.
    r_height = button_height * 3.

    IF i_number_of_errors <= 2.
      r_height = button_height * 3.
    ELSEIF i_number_of_errors <= 4.
      r_height = button_height * 5.
    ENDIF.
  ENDMETHOD.

  METHOD get_button_height.
    r_height = me->button_height.
  ENDMETHOD.

  METHOD get_button_width.
    r_width = me->button_width.
  ENDMETHOD.

ENDCLASS.
