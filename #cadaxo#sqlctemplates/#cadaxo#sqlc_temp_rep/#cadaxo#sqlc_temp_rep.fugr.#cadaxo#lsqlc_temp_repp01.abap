*----------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.
    METHODS: on_sapevent
               FOR EVENT sapevent OF cl_gui_html_viewer
                 IMPORTING action getdata.

ENDCLASS.                    "lcl_event_handler DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_sapevent.
    g_current_step = getdata.
  ENDMETHOD.                    "on_sapevent

ENDCLASS.                    "lcl_event_handler IMPLEMENTATION
