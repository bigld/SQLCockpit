*"* local class implementation for public class
*"* use this source file for the implementation part of
*"* local helper classes

DEFINE macro_case_section.

  CASE l_section.
    WHEN 'SOURCE'.
      l_from_t = l_foff - 1.
    when 'FIELDS'.
      l_fields_t = l_foff - 1.
    when 'OFFSET'.
      l_offset_t = l_foff - 1.
    WHEN 'WHERE'.
      l_where_t = l_foff - 1.
    WHEN 'GROUP'.
      l_group_t = l_foff - 1.
    WHEN 'HAVING'.
      l_having_t = l_foff - 1.
    WHEN 'ORDER'.
      l_order_t = l_foff - 1.
    WHEN 'CONNECTION'.
      l_connection_t = l_foff - 1.
  ENDCASE.

END-OF-DEFINITION.
