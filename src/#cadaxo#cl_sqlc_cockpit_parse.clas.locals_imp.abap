*"* local class implementation for public class
*"* use this source file for the implementation part of
*"* local helper classes

DEFINE macro_case_section.

  CASE l_section.
    WHEN 'SOURCE'.
      section_range-from-end = l_foff - 1.
    WHEN 'FIELDS'.
      section_range-fields-end = l_foff - 1.
    WHEN 'OFFSET'.
      section_range-offset-end = l_foff - 1.
    WHEN 'WHERE'.
      section_range-where-end = l_foff - 1.
    WHEN 'GROUP'.
      section_range-group-end = l_foff - 1.
    WHEN 'HAVING'.
      section_range-having-end = l_foff - 1.
    WHEN 'ORDER'.
      section_range-order-end = l_foff - 1.
    WHEN 'CONNECTION'.
      section_range-connection-end = l_foff - 1.
  ENDCASE.

END-OF-DEFINITION.
