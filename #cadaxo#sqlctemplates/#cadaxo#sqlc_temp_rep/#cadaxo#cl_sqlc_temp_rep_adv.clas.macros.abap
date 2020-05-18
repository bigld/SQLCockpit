*"* use this source file for any macro definitions you need
*"* in the implementation part of the class

DEFINE add_source1.
* &1 code line part 1
  append &1 to me->gt_source_code.
END-OF-DEFINITION.

DEFINE add_source2.
* &1 code line part 1
* &2 code line part 2
  concatenate &1 &2 into me->wa_source_code SEPARATED BY space.
  add_source1 me->wa_source_code.
END-OF-DEFINITION.

DEFINE add_source3.
* &1 code line part 1
* &2 code line part 2
* &1 code line part 3
  CONCATENATE &1 &2 &3 INTO me->wa_source_code SEPARATED BY space.
  add_source1 me->wa_source_code.
END-OF-DEFINITION.
