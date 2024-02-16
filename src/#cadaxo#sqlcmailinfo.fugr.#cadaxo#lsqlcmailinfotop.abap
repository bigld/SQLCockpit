FUNCTION-POOL /cadaxo/sqlcmailinfo.        "MESSAGE-ID ..


DATA: gd_okcode     TYPE syucomm.
DATA: gr_cont       TYPE REF TO cl_gui_custom_container.
DATA: gr_html       TYPE REF TO cl_gui_html_viewer.
DATA: gr_main       TYPE REF TO /cadaxo/cl_sqlc_cockpit_main.
CLASS lcl_handler DEFINITION DEFERRED.
DATA: gr_handler    TYPE REF TO lcl_handler.
DATA: g_data        TYPE string.
DATA: g_data_html   TYPE string.
DATA: g_sql         TYPE string.
DATA: g_msg         TYPE string.
DATA: g_cockpit     TYPE string.
DATA: g_sapcomp     TYPE string.

*****************************************************
*              CLASS lcl_handler                    *
*****************************************************
CLASS lcl_handler DEFINITION.

  PUBLIC SECTION.
    METHODS: on_sapevent
               FOR EVENT sapevent OF cl_gui_html_viewer
                 IMPORTING action frame getdata postdata query_table.

ENDCLASS.                    "lcl_handler DEFINITION

****************************************************
*    lcl_handler implementation                    *
****************************************************
CLASS lcl_handler IMPLEMENTATION.

  METHOD on_sapevent.
    PERFORM user_command_0100 USING action.
  ENDMETHOD.                    "on_sapevent

ENDCLASS.                    "lcl_handler IMPLEMENTATION
