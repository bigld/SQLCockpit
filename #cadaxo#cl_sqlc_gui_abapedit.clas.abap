class /CADAXO/CL_SQLC_GUI_ABAPEDIT definition
  public
  inheriting from CL_GUI_ABAPEDIT
  final
  create public .

public section.

  methods DISPATCH
    redefinition .
  methods SHOW_COMPLETION_RESULTS
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /CADAXO/CL_SQLC_GUI_ABAPEDIT IMPLEMENTATION.


  METHOD dispatch.

    DATA: context_string           TYPE string,
          xpos                     TYPE i,
          ypos                     TYPE i,
          context_info             TYPE string,
          datatype                 TYPE i,
          flags                    TYPE i,
          is_completion_quick_info TYPE i,
          line                     TYPE i,
          is_set                   TYPE i,
          is_disabled              TYPE i,
          cntrl_pressed_set        TYPE i,
          shift_pressed_set        TYPE i.

    CASE eventid.
      WHEN event_quick_info.
        CHECK new_abap_editor NE space.
*     get event parameter context string
        CALL METHOD get_event_parameter
          EXPORTING
            parameter_id = 0
            queue_only   = space
          IMPORTING
            parameter    = context_string
          EXCEPTIONS
            OTHERS       = 1.
        IF sy-subrc NE 0.
          RAISE cntl_error.
        ENDIF.
*     get event parameter ypos
        CALL METHOD get_event_parameter
          EXPORTING
            parameter_id = 1
            queue_only   = space
          IMPORTING
            parameter    = ypos
          EXCEPTIONS
            OTHERS       = 1.
        IF sy-subrc NE 0.
          RAISE cntl_error.
        ENDIF.
*     get event parameter xpos
        CALL METHOD get_event_parameter
          EXPORTING
            parameter_id = 2
            queue_only   = space
          IMPORTING
            parameter    = xpos
          EXCEPTIONS
            OTHERS       = 1.
        IF sy-subrc NE 0.
          RAISE cntl_error.
        ENDIF.
*     get event parameter datatype
        CALL METHOD get_event_parameter
          EXPORTING
            parameter_id = 3
            queue_only   = space
          IMPORTING
            parameter    = datatype
          EXCEPTIONS
            OTHERS       = 1.
        IF sy-subrc NE 0.
          RAISE cntl_error.
        ENDIF.
*     get event parameter bCompletion
        CALL METHOD get_event_parameter
          EXPORTING
            parameter_id = 4
            queue_only   = space
          IMPORTING
            parameter    = is_completion_quick_info
          EXCEPTIONS
            OTHERS       = 1.
        IF sy-subrc NE 0.
          RAISE cntl_error.
        ENDIF.
*     synchronize backend and frontend to have parameters
        CALL METHOD cl_gui_cfw=>flush
          EXCEPTIONS
            OTHERS = 1.
        IF sy-subrc NE 0.
          RAISE cntl_error.
        ENDIF.
        RAISE EVENT quick_info EXPORTING contextstring = context_string
          ypos = ypos
          xpos = xpos
          datatype = datatype.
      WHEN OTHERS.



        CALL METHOD super->dispatch
          EXPORTING
            cargo             = cargo
            eventid           = eventid
            is_shellevent     = is_shellevent
            is_systemdispatch = is_systemdispatch
          EXCEPTIONS
            cntl_error        = 1
            OTHERS            = 2.
        IF sy-subrc <> 0.
          RAISE cntl_error.
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD show_completion_results.

    DATA compl_result TYPE STANDARD TABLE OF scc_completion.

    APPEND LINES OF completion_results TO compl_result.

    CALL METHOD super->show_completion_results
      EXPORTING
        completion_results = compl_result
        version            = 1.

  ENDMETHOD.
ENDCLASS.
