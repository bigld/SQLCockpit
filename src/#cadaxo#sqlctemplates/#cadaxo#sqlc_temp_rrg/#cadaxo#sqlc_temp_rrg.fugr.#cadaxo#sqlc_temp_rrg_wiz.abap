FUNCTION /cadaxo/sqlc_temp_rrg_wiz.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IO_RRG_WIZ) TYPE REF TO  /CADAXO/CL_SQLC_TEMP_RRG
*"  EXPORTING
*"     REFERENCE(ES_TEMP_ATTR) TYPE  /CADAXO/SQLC_TEMP_RRG_ATTR
*"  EXCEPTIONS
*"      CANCEL_BY_USER
*"----------------------------------------------------------------------

  CLEAR gs_temp_attr.

  IF gcc_description IS BOUND.
    gcc_description->finalize( ).
    CLEAR gcc_description.
    CLEAR gc_description.
  ENDIF.

  IF gcc_roadmap IS BOUND.
    gcc_roadmap->finalize( ).
    CLEAR: gcc_roadmap.
    CLEAR: gc_roadmap.
  ENDIF.

  go_rrg_wiz = io_rrg_wiz.

  PERFORM init_selopt.
  PERFORM init_roadmap.

  CALL SCREEN 0100 STARTING AT 20 2 ENDING AT 140 23.

  es_temp_attr = gs_temp_attr.

ENDFUNCTION.
