*"* use this source file for any type declarations (class
*"* definitions, interfaces or data types) you need for method
*"* implementation or private method's signature

TYPES: BEGIN OF gts_main_classes,
  nr  TYPE i,
  ref TYPE REF TO /cadaxo/cl_sqlc_cockpit_main,
  END OF gts_main_classes.
TYPES: gtt_main_classes TYPE TABLE OF gts_main_classes.

*----------------------------------------------------------------------*
*       CLASS lcl_dragdrop_receiver DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_dragdrop_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS:
       flavor_select FOR EVENT on_get_flavor OF cl_gui_abapedit
                      IMPORTING dragdrop_object,
       alv_drag  FOR EVENT ondrag OF cl_gui_alv_grid
                      IMPORTING e_dragdropobj,
       editor_drop FOR EVENT on_drop OF cl_gui_abapedit
                      IMPORTING dragdrop_object,
       drop_complete FOR EVENT ondropcomplete OF cl_gui_alv_grid
                      IMPORTING e_dragdropobj.
ENDCLASS.                    "lcl_dragdrop_receiver DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_drag_object DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_drag_object DEFINITION.
  PUBLIC SECTION.
    DATA: fieldvalue TYPE string.

ENDCLASS.                    "lcl_drag_object DEFINITION
