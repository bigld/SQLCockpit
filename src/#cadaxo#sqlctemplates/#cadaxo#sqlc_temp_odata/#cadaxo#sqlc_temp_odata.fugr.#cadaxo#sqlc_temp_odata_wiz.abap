FUNCTION /cadaxo/sqlc_temp_odata_wiz.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IO_ODATA_WIZ) TYPE REF TO  /CADAXO/CL_SQLC_ODATA_GEN
*"  EXCEPTIONS
*"      CANCEL_BY_USER
*"----------------------------------------------------------------------
  CLEAR: gs_report_attr.
  IF gcc_description IS BOUND.
    gcc_description->finalize( ).
    CLEAR gcc_description.
  ENDIF.
  IF gc_roadmap IS BOUND.
    gc_roadmap->finalize( ).
    CLEAR gc_roadmap.
  ENDIF.
  IF gcc_roadmap IS BOUND.
    gcc_roadmap->finalize( ).
    CLEAR gcc_roadmap.
  ENDIF.

  go_odata_wiz = io_odata_wiz.

  PERFORM init_selopt.

  PERFORM init_roadmap.

  CALL SCREEN 0100 STARTING AT 20 2 ENDING AT 140 23.

ENDFUNCTION.
