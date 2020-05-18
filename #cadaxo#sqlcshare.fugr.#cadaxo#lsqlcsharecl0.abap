CLASS lcl_worker DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS leave_screen.
ENDCLASS.

CLASS lcl_worker IMPLEMENTATION.

  METHOD leave_screen.
    IF gr_cont_text_share_descr IS BOUND.

      gr_text_share_3001->free( ).
      gr_cont_text_share_descr->free( ).
      FREE gr_text_share_3001.
      FREE gr_cont_text_share_descr.
    ENDIF.
    SET SCREEN 0. LEAVE SCREEN.
  ENDMETHOD.

ENDCLASS.
