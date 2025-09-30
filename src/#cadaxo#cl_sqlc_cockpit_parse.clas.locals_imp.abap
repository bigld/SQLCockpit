*"* local class implementation for public class
*"* use this source file for the implementation part of
*"* local helper classes

DEFINE macro_case_section.

  CASE l_section.
    WHEN 'SOURCE'.
      section_range-from-end = l_foff - 1.
    WHEN 'FIELDS'.
      l_fields_t = l_foff - 1.
    WHEN 'OFFSET'.
      l_offset_t = l_foff - 1.
    WHEN 'WHERE'.
      section_range-where-end = l_foff - 1.
    WHEN 'GROUP'.
      section_range-group-end = l_foff - 1.
    WHEN 'HAVING'.
      l_having_t = l_foff - 1.
    WHEN 'ORDER'.
      section_range-order-end = l_foff - 1.
    WHEN 'CONNECTION'.
      section_range-connection-end = l_foff - 1.
  ENDCASE.

END-OF-DEFINITION.
