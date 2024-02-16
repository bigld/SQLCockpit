*"* local class implementation for public class
*"* use this source file for the implementation part of
*"* local helper classes
*----------------------------------------------------------------------*
*       CLASS lcl_dragdrop_receiver IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_dragdrop_receiver IMPLEMENTATION.
  METHOD flavor_select.
  ENDMETHOD.                    "flavor_select
  METHOD alv_drag.

    DATA L_drag_object TYPE REF TO lcl_drag_object.

    CREATE OBJECT l_drag_object.
    l_drag_object->fieldvalue = 'NN'.
    e_dragdropobj->object = l_drag_object.

  ENDMETHOD.                    "alv_drag
  METHOD editor_drop.
*index line pos dragdrop_object
    DATA l_drag_object TYPE REF TO lcl_drag_object.
    CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
      l_drag_object ?= dragdrop_object->object.
    ENDCATCH.
  ENDMETHOD.                    "editor_drop
  METHOD drop_complete.
  ENDMETHOD.                    "drop_complete
ENDCLASS.                    "lcl_dragdrop_receiver IMPLEMENTATION
