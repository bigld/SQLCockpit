CLASS lcl_dragdrop_receiver IMPLEMENTATION.
  METHOD flavor_select.
  ENDMETHOD.
  METHOD alv_drag.

    e_dragdropobj->object = NEW lcl_drag_object( 'NN' ).

  ENDMETHOD.
  METHOD editor_drop.
*index line pos dragdrop_object
    DATA l_drag_object TYPE REF TO lcl_drag_object.
    CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
      l_drag_object ?= dragdrop_object->object.
    ENDCATCH.
  ENDMETHOD.
  METHOD drop_complete.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_drag_object IMPLEMENTATION.


  METHOD constructor.

    codestring = i_codestring.

  ENDMETHOD.

  METHOD /cadaxo/if_editor_dragdrop~get_string_to_insert.

    r_string = codestring.

  ENDMETHOD.

ENDCLASS.
