FUNCTION-POOL /cadaxo/sqlcadmininfo.        "MESSAGE-ID ..

CONSTANTS: c_link_true  type string value 'TRUE'.
CONSTANTS: c_link_false type string value 'FALSE'.
CONSTANTS: c_btn_local  type string value 'LOCAL'.
CONSTANTS: c_btn_link   type string value 'LINK'.

DATA: gd_okcode     TYPE syucomm.
DATA: gr_cont       TYPE REF TO cl_gui_custom_container.
DATA: gr_html       TYPE REF TO cl_gui_html_viewer.
DATA: gr_main       TYPE REF TO /cadaxo/cl_sqlc_cockpit_main.
DATA: g_use_link    TYPE /CADAXO/SQLC_HOME_USE_LINK."/cadaxo/sqlcparameter_val.
CLASS lcl_handler DEFINITION DEFERRED.
DATA: gr_handler    TYPE REF TO lcl_handler.
DATA: g_button      TYPE string.

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
    g_button = getdata.
    PERFORM user_command_0100 USING action.

  ENDMETHOD.                    "on_sapevent

ENDCLASS.                    "lcl_handler IMPLEMENTATION
