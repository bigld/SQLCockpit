INCLUDE <CL_ALV_CONTROL>.
*----------------------------------------------------------------------*
*       CLASS lcl_dragdrop_receiver DEFINITION
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
ENDCLASS.

*----------------------------------------------------------------------*
*       CLASS lcl_drag_object DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_drag_object DEFINITION.
  PUBLIC SECTION.
    INTERFACES /cadaxo/if_editor_dragdrop.
    METHODS constructor IMPORTING i_codestring TYPE string.
  PROTECTED SECTION.
    DATA codestring TYPE string.

ENDCLASS.
