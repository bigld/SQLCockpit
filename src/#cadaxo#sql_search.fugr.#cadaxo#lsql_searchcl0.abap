CLASS lcl_worker DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS leave_screen.
    CLASS-METHODS execute_search.
ENDCLASS.

CLASS lcl_worker IMPLEMENTATION.

  METHOD execute_search.
    SET SCREEN 0.
  ENDMETHOD.

  METHOD leave_screen.
    CLEAR gv_search_string.
    SET SCREEN 0. LEAVE SCREEN.
  ENDMETHOD.

ENDCLASS.
