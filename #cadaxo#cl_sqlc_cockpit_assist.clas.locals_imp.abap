*"* local class implementation for public class
*"* use this source file for the implementation part of
*"* local helper classes
CLASS lcl_pp_settings DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_pretty_printer_settings.
ENDCLASS.
CLASS lcl_pp_settings IMPLEMENTATION.

  METHOD if_pretty_printer_settings~get_indent_mode.
    indent_mode = if_pretty_printer_settings=>co_indent.
  ENDMETHOD.

  METHOD if_pretty_printer_settings~get_line_length.
    length = /cadaxo/cl_sqlc_cockpit_assist=>c_source_length.
  ENDMETHOD.

  METHOD if_pretty_printer_settings~get_case_mode.
    case_mode = if_pretty_printer_settings=>co_case_mode_lower.
  ENDMETHOD.

  METHOD if_pretty_printer_settings~get_source_type.
    source_type = 'ABAP'.
  ENDMETHOD.

ENDCLASS.
