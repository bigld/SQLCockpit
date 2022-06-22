*"* use this source file for any macro definitions you need
*"* in the implementation part of the class

define conv_ident_case.
* all names are passed in upper case from kernel
  if settings-identifier_lower_case = abap_true.
    translate &1 to lower case.
  endif.
end-of-definition.

define set_max_length.
  l_length = numofchar( &2 ).
  if l_length > &1.
    &1 = l_length.
  endif.
end-of-definition.

define set_spacer.
  &1-spacer = repeat( val = ` ` occ = nmax( val1 = 0 val2 = &2 - numofchar( &1-name ) ) ).
end-of-definition.
