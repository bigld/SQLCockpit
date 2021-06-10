* ----------------------------------------------------------------------
type-pools: SEOO,
            SEOS.

* ----------------------------------------------------------------------
interface lif_progtype.
  constants:
    report         type subc value '1',
    modulepool     type subc value 'M',
    functiongroup  type subc value 'F',
    subroutinepool type subc value 'S',
    interfacepool  type subc value 'J',
    classpool      type subc value 'K',
    typepool       type subc value 'T'.

endinterface.

* ----------------------------------------------------------------------
class Lcl_Completion_Result definition final create private for testing.
  public section.

    types ty_kinds type range of scc_kind.
    types: begin of ty_check,
             path type string,
             value type string,
           end of ty_check.
    types ty_checks type STANDARD TABLE OF ty_check with key path.

    class-methods:
      create
        importing
          original type ref to Lcl_Completion_Result optional
        returning
          value(instance) type ref to Lcl_Completion_Result.

    methods:
      add " add single entity
        importing
          name  type csequence
          kind  type scc_kind,
      add_multiple
        importing
          prefix type csequence
          number type i
          kind   type scc_kind,
      add_check " add check entries
        importing
          check type ty_check,
      add_components " extend result set by class/intf components
        importing
          objkind  type subc default lif_progtype=>classpool
          objname  type csequence
          prefix   type csequence
          kinds    type ty_kinds optional
          onlypubl type abap_bool default abap_false
          onlyinst type abap_bool default abap_false
          onlywrit type abap_bool default abap_false,
      add_subcomponents " extend result set by method signature
        importing
          objname  type csequence
          compkind type scc_kind
          compname type csequence
          prefix   type csequence default space
          kinds    type ty_kinds optional,
      add_ddiccomponents " extend result set by components of ddic type
        importing
          typename type csequence
          prefix   type csequence default space
          kinds    type ty_kinds optional,
      clear. " reset

    data:
      set    type scc_detailed_completions,
      checks type ty_checks.

endclass.


* ----------------------------------------------------------------------
class Lcl_Completion_Context definition final create private for testing.
  public section.
    types t_texts type STANDARD TABLE OF string with NON-UNIQUE KEY TABLE_LINE.
    class-methods:
      create " factory
        importing
          name type csequence
          kind type subc
        returning
          value(instance) type ref to Lcl_Completion_Context.
    methods:
      set_include " set context include resp. method include
        importing
          inclname type progname OPTIONAL
          methname type SEOCPDNAME OPTIONAL
          funcname type rs38l_fnam optional,
      add " add source line
        importing
          line     type csequence
          clear    type flag default abap_false,
      read_include " read and set context include
        importing
          inclname type progname
          uptoline type i optional,
      check_completion
        importing
          line     type csequence
          positive type ref to Lcl_Completion_Result optional
          negative type ref to Lcl_Completion_Result optional
          numrechk type i default 1,
      check_quickinfo
        importing
          objname  type csequence
          objkind  type scc_kind
          positive type ref to Lcl_Completion_Result optional
          negative type ref to Lcl_Completion_Result optional
          texts    type t_texts optional,
      check_insertion
        importing
          objname  type csequence
          objkind  type scc_kind
          positive type ref to Lcl_Completion_Result optional
          negative type ref to Lcl_Completion_Result optional
          texts    type t_texts optional
          stmtend  type string optional,
      check_element_info
        importing
          objname  type csequence
          objkind  type scc_kind
          positive type ref to Lcl_Completion_Result optional.

  private section.
    data:
      objname   type progname,
      mainprog  type progname ##NEEDED,
      mainsubc  type subc     ##NEEDED,
      include   type progname,
      inclsrc   type RSWSOURCET,
      completer type ref to /cadaxo/cl_sqlc_abap_parser.

endclass.



* ----------------------------------------------------------------------
class Lcl_Completion_Test definition final for testing duration medium
                                                       risk level harmless.
*?#<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>Lcl_Completion_Test
*?</TEST_CLASS>
*?<OBJECT_UNDER_TEST>/cadaxo/cl_sqlc_abap_parser
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE/>
*?<GENERATE_INVOCATION/>
*?<GENERATE_ASSERT_EQUAL/>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
* ----------------------------------------------------------------------

  private section.
* ================
    methods: Run_Completion_Test
               importing
                 line            type csequence
                 value(objname)  type csequence
                 value(compname) type csequence
                 value(compkind) type scc_kind
                 context         type ref to lcl_completion_context
                 result          type ref to lcl_completion_result
                 pattern         type scc_syntcntxt optional.

    methods: Completion_local_class for testing.
    methods: Completion_own_method for testing.
    methods: Completion_own_type for testing.
    methods: Completion_other_method for testing.
    methods: Completion_other_event for testing.
    methods: Completion_method_parameters for testing.
    methods: Completion_function for testing.
    methods: Completion_callmethod for testing.
    methods: Completion_redefmethimpl for testing.
    methods: Completion_localclass for testing.
    methods: Completion_createobject for testing.
    methods: Completion_raiseevent for testing.
    methods: Completion_raiseexception for testing.
    methods: Completion_in_functiongroup for testing.
    methods: Completion_type_with_length for testing.
    methods: Completion_call_method_compute for testing.
    methods: Completion_call_method_expr for testing.
    methods: Completion_class_impl for testing.
    methods: Completion_interface_impl for testing.
    methods: Completion_aliases for testing.
    methods: Completion_abapdoc for testing.
    methods: Completion_interface_type for testing.
    methods: Completion_range_type for testing.
    methods: Completion_ddicstructure for testing.
    methods: Completion_itabs for testing.
    methods: Completion_intf_method_abapdoc for testing.
    methods: Completion_data_reference for testing.
    methods: Completion_function_arguments for testing.
    methods: Completion_function_parameters for testing.
endclass.       "Lcl_Completion_Test

class /cadaxo/cl_sqlc_abap_parser definition local friends Lcl_Completion_Context.



* ----------------------------------------------------------------------
class lcl_element_info_serializer definition final for testing.
public section.
  types:
    begin of ty_property_entry,
      name        type string,
      value       type string,
   end of ty_property_entry .
  types:
    begin of ty_element_info,
      name        type string,
      properties  type standard table of ty_property_entry with default key,
      children    type ref to data, " ty_element_info_elements
   end of ty_element_info .
  types:
    ty_element_info_elements type standard table of ty_element_info with default key .

  class-methods convert
    importing
      element_info type ref to CL_ABAP_CC_PROG_OBJECT
    returning value(result) type ty_element_info.

  CLASS-METHODS get_property_value
    importing
      info type ty_element_info
      path type string
    RETURNING VALUE(result) type string.

  CLASS-METHODS kind_as_text
    importing
      kind type SCC_KIND
    returning value(result) type string.

private section.

  class-methods get_properties
    importing
      element_info type ref to CL_ABAP_CC_PROG_OBJECT
    returning value(result) type ty_element_info-properties.

  CLASS-METHODS bool_as_text
    importing
      bool type SCC_BOOL
    returning value(result) type string.

  CLASS-METHODS member_kind_as_text
    importing
      member_kind type SCC_MEMBER_KIND
    returning value(result) type string.

  class-methods visibility_as_text
    importing
      vis type SCC_VISIBILITY
    returning value(result) type string.

  class-methods add_type_as_text
    importing
      type   type ref to cl_abap_cc_type
      entity type ref to cl_abap_cc_prog_object
    changing
      result type ty_element_info-properties.

  class-methods add_value_as_text
    importing
      value type ref to cl_abap_cc_value
    changing
      result type ty_element_info-properties.

  class-methods typekind_as_text
    importing
      type_kind type scc_typekind
    returning value(result) type string.

  class-methods paramkind_as_text
    importing
      param_kind type scc_property
    returning value(result) type string.

  class-methods datakind_as_text
    importing
      data_kind type scc_property
    returning value(result) type string.

  class-methods get_parameters
    importing
      params type if_ABAP_CC_properties=>ty_parameters_seq
    changing result type ty_element_info.

  class-methods get_exceptions
    importing
      exceps type if_ABAP_CC_properties=>ty_exceptions_seq
    changing result type ty_element_info.

  class-methods convert_method
    importing
      element_info type ref to CL_ABAP_CC_METHOD
    returning value(result) type ty_element_info.

  class-methods convert_field
    importing
      element_info type ref to CL_ABAP_CC_DATA
    returning value(result) type ty_element_info.

  class-methods convert_type
    importing
      element_info type ref to CL_ABAP_CC_TYPE
    returning value(result) type ty_element_info.

  class-methods convert_event
    importing
      element_info type ref to cl_abap_cc_event
    returning value(result) type ty_element_info.

  class-methods convert_form
    importing
      element_info type ref to CL_ABAP_CC_form
    returning value(result) type ty_element_info.

  class-methods convert_function
    importing
      element_info type ref to CL_ABAP_CC_function
    returning value(result) type ty_element_info.

  class-methods convert_exception
    importing
      element_info type ref to CL_ABAP_CC_exception
    returning value(result) type ty_element_info.

endclass.


* ----------------------------------------------------------------------
* Implementations
* ----------------------------------------------------------------------
class Lcl_Completion_Result implementation.

  method create.
    CREATE OBJECT instance.
    if original is supplied.
      instance->set = original->set.
    endif.
  endmethod.

  method add.
    data wa like line of set.
    wa-kind       = kind.
    wa-identifier = name.
    TRANSLATE wa-identifier to UPPER CASE.
    append wa to set.
  endmethod.

  method add_multiple.
    data name type scc_identifier.
    do number times.
      name = |{ prefix }{ sy-index }|.
      add( name = name kind = kind ).
    enddo.
  endmethod.

  method add_check.
    append check to checks.
  endmethod.

  method add_components.
    data: wa like line of set,
          clskey     type seoclskey,
          attributes type SEOO_ATTRIBUTES_R,
          methods    type SEOO_METHODS_R,
          events     type SEOO_EVENTS_R,
          types      type SEOO_TYPES_R,
          len        type i.

    field-SYMBOLS:
          <attribute> type line of SEOO_ATTRIBUTES_R,
          <method>    type line of SEOO_METHODS_R,
          <event>     type line of SEOO_EVENTS_R,
          <type>      type line of SEOO_TYPES_R.

    len = strlen( prefix ).
    clskey-clsname = objname.

    if objname is not initial and objkind = lif_progtype=>classpool. " Classpool
      CALL FUNCTION 'SEO_CLASS_TYPEINFO_GET'
        EXPORTING
          clskey       = clskey
        IMPORTING
          attributes   = attributes
          methods      = methods
          events       = events
          types        = types
        EXCEPTIONS
          not_existing = 1
          is_interface = 2
          model_only   = 3.
    endif.

    if sy-subrc = 2 or objname is not initial and objkind = lif_progtype=>interfacepool.
      CALL FUNCTION 'SEO_INTERFACE_TYPEINFO_GET'
        EXPORTING
          intkey       = clskey
        IMPORTING
          attributes   = attributes
          methods      = methods
          events       = events
          types        = types
        EXCEPTIONS
          not_existing = 1
          is_class     = 2
          model_only   = 3.
    endif.

    if sy-subrc = 0 and objname is not initial.
      if sccmp_cat_field in kinds.
        loop at attributes assigning <attribute>.
          if ( onlyinst = abap_false or <attribute>-attdecltyp = 0 ) and
             ( onlypubl = abap_false or <attribute>-exposure   = 2 ) and
             ( onlywrit = abap_false or <attribute>-attdecltyp <> 2 ) and
             ( prefix is initial or 0 = find( val = <attribute>-cmpname sub = prefix len = len ) ).
            wa-kind       = sccmp_cat_field.
            wa-identifier = <attribute>-CMPNAME.
            append wa to set.
          endif.
        endloop.
      endif.
      if sccmp_cat_method in kinds.
        loop at methods assigning <method>.
          if ( <method>-cmpname <> 'CONSTRUCTOR' )       and
             ( <method>-cmpname <> 'CLASS_CONSTRUCTOR' ) and
             ( onlyinst = abap_false or <method>-mtddecltyp = 0 ) and
             ( onlypubl = abap_false or <method>-exposure   = 2 ) and
             ( prefix is initial or 0 = find( val = <method>-cmpname sub = prefix len = len ) ).
            wa-kind       = sccmp_cat_method.
            wa-identifier = <method>-CMPNAME.
            append wa to set.
          endif.
        endloop.
      endif.
      if sccmp_cat_event in kinds.
        loop at events assigning <event>.
          if ( onlyinst = abap_false or <event>-evtdecltyp = 0 ) and
             ( onlypubl = abap_false or <event>-exposure   = 2 ) and
             ( prefix is initial or 0 = find( val = <event>-cmpname sub = prefix len = len ) ).
            wa-kind       = sccmp_cat_event.
            wa-identifier = <event>-CMPNAME.
            append wa to set.
          endif.
        endloop.
      endif.
      if sccmp_cat_type in kinds.
        loop at types assigning <type>.
          if ( onlypubl = abap_false or <type>-exposure = 2 ) and
             ( prefix is initial or 0 = find( val = <type>-cmpname sub = prefix len = len ) ).
            wa-kind       = sccmp_cat_type.
            wa-identifier = <type>-CMPNAME.
            append wa to set.
          endif.
        endloop.
      endif.
    elseif sccmp_cat_function in kinds.
      data pattern type string.
      concatenate prefix `%` into pattern.
      select funcname up to 10 rows
             from tfdir
             into (wa-identifier)
             where funcname like pattern.
        wa-kind = sccmp_cat_function.
        append wa to set.
      endselect.
    endif.
  endmethod.

  method add_subcomponents.
    data: wa like line of set,
          compkey type SEOCPDKEY,
          attkey  type SEOCMPKEY,
          parameters type SEOS_PARAMETERS_R,
          exceps type SEOS_EXCEPTIONS_R,
          attribute type VSEOATTRIB,
          type type VSEOTYPE,
          len type i.
    field-symbols: <param> type line of SEOS_PARAMETERS_R,
                   <excep> type line of SEOS_EXCEPTIONS_R.

    compkey-clsname = objname.
    compkey-cpdname = compname.
    len = strlen( prefix ).

    if compkind = sccmp_cat_method or compkind = sccmp_cat_event.
      CALL FUNCTION 'SEO_COMPONENT_SIGNATURE_GET'
        EXPORTING
          cpdkey       = compkey    " Key structure of a component (with composite names)
        IMPORTING
          parameters   = parameters    " Status of a class or component
          exceps       = exceps    " Status of a class or component
        EXCEPTIONS
          not_existing = 1
          is_type      = 2
          is_attribute = 3.

      if sy-subrc = 0.
        if kinds is not supplied or sccmp_cat_field in kinds.
          loop at parameters assigning <param> where PARDECLTYP <> 3. " skip RETURNING
            if prefix is initial or 0 = find( val = <param>-sconame sub = prefix len = len ).
              wa-kind       = sccmp_cat_field.
              wa-identifier = <param>-SCONAME.
              append wa to set.
            endif.
          endloop.
        endif.
        if kinds is not supplied or sccmp_cat_exception in kinds.
          loop at exceps ASSIGNING <excep>.
            if prefix is initial or 0 = find( val = <excep>-sconame sub = prefix len = len ).
              wa-kind       = sccmp_cat_exception.
              wa-identifier = <excep>-SCONAME.
              append wa to set.
            endif.
          endloop.
        endif.
      endif.
    endif.
    if compkind = sccmp_cat_field.
      attkey = compkey.
      CALL FUNCTION 'SEO_ATTRIBUTE_GET'
        EXPORTING
          attkey       = attkey
        IMPORTING
          attribute    = attribute
        EXCEPTIONS
          not_existing = 1
          deleted      = 2
          is_method    = 3
          is_event     = 4
          is_type      = 5.

      if sy-subrc = 0 and attribute-typtype = 1 or " TYPE
                          attribute-typtype = 2 or " TYPE
                          attribute-typtype = 3 or " TYPE REF TO
                          attribute-typtype = 5.   " TYPE BOXED
        wa-kind       = sccmp_cat_type.
        wa-identifier = attribute-type.
        append wa to set.
      endif.
    endif.
    if compkind = sccmp_cat_type.
      data typkey type SEOCMPKEY.
      typkey-clsname = compkey-clsname.
      typkey-cmpname = compkey-cpdname.
      CALL FUNCTION 'SEO_TYPE_GET'
        EXPORTING
          typkey       = typkey
        IMPORTING
          type         = type
        EXCEPTIONS
          not_existing = 1
          deleted      = 2
          is_attribute = 3
          is_method    = 4
          is_event     = 5.

      if sy-subrc = 0 and type-typtype = 1 or " TYPE
                          type-typtype = 2 or " TYPE
                          type-typtype = 3 or " TYPE REF TO
                          type-typtype = 5.   " TYPE BOXED
        wa-kind       = sccmp_cat_type.
        wa-identifier = type-type.
        append wa to set.
      endif.
    endif.
    if compkind = sccmp_cat_function.
      data: funcname type rs38l_fnam,
            excclasses type s_excclass ##NEEDED,
            rcexceps type standard TABLE OF RSEXC,
            exports type standard TABLE OF rsexp,
            imports type standard TABLE OF rsimp,
            changings type standard TABLE OF rscha,
            tables type standard TABLE OF rstbl.
      field-SYMBOLS:
            <rcexcep> type  RSEXC,
            <export> type rsexp,
            <import> type rsimp,
            <changing> type rscha,
            <table> type rstbl.

      funcname = compname.
      CALL FUNCTION 'FUNCTION_IMPORT_INTERFACE'
        EXPORTING
          funcname           = funcname    " Name of the function module
        IMPORTING
          exception_classes  = excclasses    " Additional Attributes for Function Modules
        TABLES
          exception_list     = rcexceps    " Table of exceptions
          export_parameter   = exports    " Table of Export Parameters
          import_parameter   = imports    " Table of Import Parameters
          changing_parameter = changings    " Table for Changing Parameters
          tables_parameter   = tables    " Table With Tables
        EXCEPTIONS
          error_message      = 1
          function_not_found = 2
          invalid_name       = 3.

      if sy-subrc = 0.
        if kinds is not supplied or sccmp_cat_field in kinds.
          loop at exports assigning <export>.
            if prefix is initial or 0 = find( val = <export>-PARAMETER sub = prefix len = len ).
              wa-kind       = sccmp_cat_field.
              wa-identifier = <export>-PARAMETER.
              append wa to set.
            endif.
          endloop.
          loop at imports assigning <import>.
            if prefix is initial or 0 = find( val = <import>-PARAMETER sub = prefix len = len ).
              wa-kind       = sccmp_cat_field.
              wa-identifier = <import>-PARAMETER.
              append wa to set.
            endif.
          endloop.
          loop at changings assigning <changing>.
            if prefix is initial or 0 = find( val = <changing>-PARAMETER sub = prefix len = len ).
              wa-kind       = sccmp_cat_field.
              wa-identifier = <changing>-PARAMETER.
              append wa to set.
            endif.
          endloop.
          loop at tables assigning <table>.
            if prefix is initial or 0 = find( val = <table>-PARAMETER sub = prefix len = len ).
              wa-kind       = sccmp_cat_field.
              wa-identifier = <table>-PARAMETER.
              append wa to set.
            endif.
          endloop.
        endif.
        if kinds is not supplied or sccmp_cat_exception in kinds.
          loop at rcexceps ASSIGNING <rcexcep>.
            if prefix is initial or 0 = find( val = <rcexcep>-EXCEPTION sub = prefix len = len ).
              wa-kind       = sccmp_cat_exception.
              wa-identifier = <rcexcep>-EXCEPTION.
              append wa to set.
            endif.
          endloop.
        endif.
      endif.
    endif.
  endmethod.

  method ADD_DDICCOMPONENTS.
    data:
      wa          like line of set,
      components  type standard table of DD03P,
      len         type i.

    field-symbols:
      <component> type dd03p.

    len = strlen( prefix ).
    CALL FUNCTION 'DDIF_TABL_GET'
      EXPORTING
        NAME          = typename
      TABLES
        DD03P_TAB     = components " Felder der Tabelle
      EXCEPTIONS
        ILLEGAL_INPUT = 1
        OTHERS        = 2.

    if sy-subrc = 0.
      if kinds is not supplied or sccmp_cat_field in kinds.
        loop at COMPONENTS assigning <component>.
          if prefix is initial or 0 = find( val = <component>-FIELDNAME sub = prefix len = len ).
            wa-kind       = sccmp_cat_field.
            wa-identifier = <COMPONENT>-FIELDNAME.
            append wa to set.
          endif.
        endloop.
      endif.
    endif.
  endmethod.

  method clear.
    clear me->set.
  endmethod.

endclass.

* ----------------------------------------------------------------------
class Lcl_Completion_Context IMPLEMENTATION.

  method create.
    create object instance.
    instance->objname  = name.
    instance->mainsubc = kind.
    case kind.
      when lif_progtype=>classpool.
        instance->mainprog = cl_oo_classname_service=>get_classpool_name( name ).
      when lif_progtype=>interfacepool.
        instance->mainprog = cl_oo_classname_service=>get_interfacepool_name( name ).
    endcase.
    create object instance->completer.
  endmethod.

  method set_include.
    if inclname is supplied.
      include = inclname.
    elseif methname is supplied.
      data methkey type SEOCPDKEY.
      methkey-clsname = objname.
      methkey-cpdname = methname.
      include = cl_oo_classname_service=>get_method_include( methkey ).
    elseif funcname is supplied.
      call function 'FUNCTION_EXISTS'
        exporting
          funcname = funcname
        importing
          include  = include
        exceptions
          function_not_exist = 1
          others             = 2.
      if sy-subrc <> 0.
        clear include.
      endif.
    else.
      clear include.
    endif.
  endmethod.

  method add.
    if clear = abap_true.
      clear inclsrc.
    endif.
    append line to inclsrc.
  endmethod.

  method read_include.
    set_include( exporting inclname = INCLNAME ).
    read report include into INCLSRC.
    if uptoline is supplied and uptoline > 0.
      delete inclsrc from uptoline + 1.
    endif.
  endmethod.

  method check_completion.
    data:
          xpos            type i,
          ypos            type i,
          beg_xpos        type i,
          beg_ypos        type i,
          compl_result    type /cadaxo/cl_sqlc_abap_parser=>completion_results,
          subrc           like sy-subrc.

    xpos     = strlen( line ) + 1.
    beg_xpos = 1.
    ypos = beg_ypos = lines( inclsrc ) + 1. " same line

    do numrechk times.

      completer->calculate_completion_results(
        exporting
          ypos                = ypos
          xpos                = xpos
          beg_ypos            = beg_ypos
          beg_xpos            = beg_xpos
          sourceline          = line
          mainprogname        = mainprog
          includename         = include
        importing
          compl_result        = compl_result    " Completion result
        changing
          incl_source         = inclsrc         " ABAP source of current include
        exceptions
          empty_mainprog      = 1
          scan_error          = 2
          invalid_position    = 3
          source_not_included = 4
          incomplete_result   = 5
      ).
      subrc = sy-subrc.

*     check result
      data: msg    type string,
            usable type c LENGTH 1.
      field-symbols: <item> like line of positive->set,
                     <compl> like line of compl_result.

      CONCATENATE 'Completion failed for:' space line '|' into msg.
      cl_aunit_assert=>assert_subrc( act = subrc msg = msg ).

      if positive is SUPPLIED.
        loop at positive->set assigning <item>.
          CONCATENATE 'Completion for' <item>-identifier 'missing' into msg Separated by space.
          read table compl_result with key kind = <item>-kind
                                           identifier = <item>-identifier
                                  ASSIGNING <compl>.
          usable = boolc( sy-subrc = 0 and <compl>-grade <> 2 ).
          cl_aunit_assert=>assert_not_initial( act = usable msg = msg ).
        endloop.
      endif.

      if negative is SUPPLIED.
        loop at negative->set assigning <item>.
          CONCATENATE 'Completion for ' <item>-identifier 'not expected' into msg Separated by space.
          read table compl_result with key kind = <item>-kind
                                           identifier = <item>-identifier
                                  ASSIGNING <compl>.
          usable = boolc( sy-subrc = 0 and <compl>-grade <> 2 ).
          cl_aunit_assert=>assert_initial( act = usable msg = msg ).
        endloop.
      endif.

    enddo.

  endmethod.

  method check_quickinfo.
    data: help_text type string,
          success   type abap_bool,
          kind      type i,
          name      type string.

    kind = objkind.
    name = to_upper( objname ).
    completer->calculate_quickinfo_result(
      exporting
        kind       = kind       " Namespace of Completion Entity
        identifier = name       " Name of Completion Entry
      importing
        help_text  = help_text  " Quick Info Text
        success    = success    " Text filled?
    ).
*   check result
    data msg type string.
    field-symbols <item> like line of positive->set.
    field-symbols <text> like line of texts.

    CONCATENATE 'Calculate Quickinfo failed for' objname '(not found)' into msg Separated by space.
    cl_aunit_assert=>assert_equals( act = success exp = abap_true msg = msg ).

    if positive is supplied.
      loop at positive->set assigning <item>.
        CONCATENATE 'Quickinfo for ' <item>-identifier 'missing' into msg Separated by space.
        find <item>-identifier in help_text IGNORING CASE.
        cl_aunit_assert=>assert_initial( act = sy-subrc msg = msg ).
      endloop.
    endif.

    if negative is supplied.
      loop at negative->set assigning <item>.
        CONCATENATE 'Quickinfo for ' <item>-identifier 'not expected' into msg Separated by space.
        find <item>-identifier in help_text IGNORING CASE.
        cl_aunit_assert=>assert_not_initial( act = sy-subrc msg = msg ).
      endloop.
    endif.

    loop at texts assigning <text>.
      CONCATENATE 'Text "' <text> '" missing in Quickinfo for' objname into msg Separated by space.
      find <text> in help_text.
      cl_aunit_assert=>assert_initial( act = sy-subrc msg = msg ).
    endloop.

  endmethod.

  method check_insertion.
    data: compl_text type rswsourcet,
          success    type abap_bool,
          kind       type i,
          name       type string,
          settings   type /cadaxo/cl_sqlc_abap_parser=>t_user_settings.

    settings-identifier_lower_case = space.
    settings-keywords_lower_case   = space.
    settings-meth_without_others   = abap_true.
    kind = objkind.
    name = to_upper( objname ).
    completer->calculate_insertion_result(
      exporting
        kind       = kind       " Namespace of Completion Entity
        identifier = name       " Name of Completion Entry
        pattern    = abap_true  " Pattern?
        settings   = settings   " User Settings: Pattern Format
      importing
        compl_text = compl_text " Insertion Text
        success    = success    " Text filled?
    ).

*   check result
    data msg type string.
    field-symbols <item> like line of positive->set.
    field-symbols <text> like line of texts.

    CONCATENATE 'Calculate Insertion failed for' objname '(not found)' into msg Separated by space.
    cl_aunit_assert=>assert_equals( act = success exp = abap_true msg = msg ).

    if positive is supplied.
      loop at positive->set assigning <item>.
        CONCATENATE 'Insertion for ' <item>-identifier 'missing' into msg Separated by space.
        find <item>-identifier in table compl_text ignoring CASE.
        cl_aunit_assert=>assert_initial( act = sy-subrc msg = msg ).
      endloop.
    endif.

    if negative is supplied.
      loop at negative->set assigning <item>.
        CONCATENATE 'Insertion for ' <item>-identifier 'not expected' into msg Separated by space.
        find <item>-identifier in table compl_text ignoring CASE.
        cl_aunit_assert=>assert_not_initial( act = sy-subrc msg = msg ).
      endloop.
    endif.

    loop at texts assigning <text>.
      CONCATENATE 'Text "' <text> '" missing in Insert Pattern for' objname into msg Separated by space.
      find <text> in table compl_text.
      cl_aunit_assert=>assert_initial( act = sy-subrc msg = msg ).
    endloop.

    if stmtend is supplied.
      CONCATENATE 'Insert Pattern for' objname 'does not end with' stmtend into msg Separated by space.
      read table compl_text index lines( compl_text ) ASSIGNING FIELD-SYMBOL(<compl>).
      cl_aunit_assert=>assert_char_cp( act = <compl> exp = `*` && stmtend msg = msg ).
    endif.

  endmethod.

  method check_element_info.
    data: help_text type string,
          success   type abap_bool,
          kind      type i,
          name      type string,
          eleminfo  type lcl_element_info_serializer=>ty_element_info.

    kind = objkind.
    name = to_upper( objname ).
    data(progobj) = completer->get_element_info( kind = kind identifier = name ).

*   check result
    data msg type string.

    CONCATENATE 'Get Element Info failed for' objname '(not found)' into msg Separated by space.
    cl_aunit_assert=>assert_bound( act = progobj msg = msg ).

*   serialize to simplified data structure
    eleminfo = lcl_element_info_serializer=>convert( progobj ).

    CONCATENATE 'Get Element Info failed for' objname '(empty)' into msg Separated by space.
    cl_aunit_assert=>assert_not_initial( act = eleminfo msg = msg ).

*   check name
    CONCATENATE 'Get Element Info failed for' objname '(wrong kind/name)' into msg Separated by space.
    cl_aunit_assert=>assert_equals( exp = lcl_element_info_serializer=>kind_as_text( conv scc_kind( kind ) ) && name
                                    act = eleminfo-name msg = msg ).

*   check properties
    loop at positive->checks assigning FIELD-SYMBOL(<check>).
      CONCATENATE 'Element Info for property ' <check>-path 'failed' into msg Separated by space.
      data(act) = lcl_element_info_serializer=>get_property_value( exporting  info = eleminfo path = <check>-path ).
      cl_aunit_assert=>assert_equals( exp = to_upper( <check>-value ) act = to_upper( act ) msg = msg ).
    endloop.
  endmethod.

endclass.

* ----------------------------------------------------------------------
class Lcl_Completion_Test implementation.

* ----------------------------------------------------------------------
  method Run_Completion_Test.

    data: comps type ref to Lcl_Completion_Result,
          kinds   type Lcl_Completion_Result=>ty_kinds,
          kind    like line of kinds.

    context->check_completion(
      exporting
        line     = line
        positive = result
    ).

    TRANSLATE objname  TO UPPER CASE.
    TRANSLATE compname TO UPPER CASE.

    comps = lcl_completion_result=>create( ).
    comps->add_subcomponents(
      exporting
        objname  = objname
        compkind = compkind
        compname = compname
    ).

    context->check_quickinfo(
      exporting
        objname  = compname
        objkind  = compkind
        positive = comps
    ).

    if pattern is supplied and pattern = sccmp_cxt_call_meth_func.
      kind-sign = 'I'.
      kind-option = 'EQ'.
      kind-high = kind-low = sccmp_cat_field.
      append kind to kinds.

      comps = lcl_completion_result=>create( ).
      comps->add_subcomponents(
        exporting
          objname  = objname
          compkind = compkind
          compname = compname
          kinds    = kinds
      ).
    endif.

    context->check_insertion(
      exporting
        objname  = compname
        objkind  = compkind
        positive = comps
    ).

  endmethod.       "Run_Completion_Test


* ----------------------------------------------------------------------
  method Completion_local_class.

    data: context    type ref to lcl_completion_context,
          pos_result type ref to lcl_completion_result,
          neg_result type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = '/cadaxo/cl_sqlc_abap_parser'
        kind     = 'K'
    ).
    context->set_include( methname = 'GET_TYPING_TEXT' ).
    context->add( 'method dummy.' ).

    pos_result = lcl_completion_result=>create( ).
    pos_result->ADD(
      exporting
        NAME = 'lcl_repository_requests'
        KIND = sccmp_cat_type
    ).
    pos_result->ADD(
      exporting
        NAME = 'lcl_short_text'
        KIND = sccmp_cat_type
    ).
    pos_result->ADD(
      exporting
        NAME = 'lcl_enhanced_quick_info'
        KIND = sccmp_cat_type
    ).
    pos_result->ADD(
      exporting
        NAME = 'lcl_enhanced_code_insertion'
        KIND = sccmp_cat_type
    ).

    neg_result = lcl_completion_result=>create( ).
    neg_result->ADD(
    exporting
      NAME = 'lif_base'
      KIND = sccmp_cat_type
    ).

*   call completion
    context->check_completion(
      exporting
        line     = 'data myref type ref to lc'
        positive  = pos_result
        negative  = neg_result
    ).

*   check components in quick info and insertion
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'get_repository_result'
        KIND = sccmp_cat_method
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'call_f4_help'
        KIND = sccmp_cat_method
    ).

*   add properties of LCL_REPOSITORY_REQUESTS
    components->checks = value #(
                           ( path = `final`  value = `true` )
                           ( path = `global` value = `false` )
                           ( path = `typekind` value = `objecttype` )
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `` )
                           ( path = `ty:t_query_properties\member_kind` value = `class` )
                           ( path = `ty:t_query_properties\typekind` value = `structure` )
                           ( path = `ty:t_query_objects\member_kind` value = `class` )
                           ( path = `ty:t_query_objects\typekind` value = `table` )
                           ( path = `me:get_repository_result\member_kind` value = `class` )
                           ( path = `me:get_repository_result\da:extern_reqs\paramkind` value = `importing` )
                           ( path = `me:get_repository_result\da:extern_reqs\byvalue` value = `false` )
                           ( path = `me:get_repository_result\da:extern_reqs\type` value = `scc_repository_requests` )
                           ( path = `me:get_repository_result\da:max_items\paramkind` value = `importing` )
                           ( path = `me:get_repository_result\da:max_items\byvalue` value = `false` )
                           ( path = `me:get_repository_result\da:max_items\type` value = `/cadaxo/cl_sqlc_abap_parser=>TT_MAX_ITEMS` )
                           ( path = `me:get_repository_result\da:compl_result\paramkind` value = `changing` )
                           ( path = `me:get_repository_result\da:compl_result\byvalue` value = `false` )
                           ( path = `me:get_repository_result\da:compl_result\type` value = `scc_completions` )
                           ( path = `me:call_f4_help\da:prefix\paramkind` value = `importing` )
                           ( path = `me:call_f4_help\da:prefix\byvalue` value = `false` )
                           ( path = `me:call_f4_help\da:prefix\type` value = `scc_identifier` )
                           ( path = `me:call_f4_help\da:result\paramkind` value = `exporting` )
                           ( path = `me:call_f4_help\da:result\byvalue` value = `false` )
                           ( path = `me:call_f4_help\da:result\type` value = `scc_identifier` )
                           ( path = `me:call_f4_help\ex:request_canceled\` value = `true` )
                         ).

    data compname type string value 'LCL_REPOSITORY_REQUESTS'. "upper case
    context->check_quickinfo(
      exporting
        objname  = compname
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

    context->check_element_info(
      exporting
        objname  = compname
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

    components->CLEAR( ).
    context->check_insertion(
      exporting
        objname  = compname
        objkind  = sccmp_cat_type
        positive = components
    ).

  endmethod.       "Completion_local_class


* ----------------------------------------------------------------------
  method Completion_own_method.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result,
        kinds   type Lcl_Completion_Result=>ty_kinds,
        kind    like line of kinds.

  context = lcl_completion_context=>create(
      name     = '/cadaxo/cl_sqlc_abap_parser'
      kind     = 'K'
  ).
  context->set_include( methname = 'MAP_COMPLETION_RESULTS' ).
  context->add( 'method dummy.' ).

  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_method.
  append kind to kinds.
  kind-high = kind-low = sccmp_cat_field.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add_components(
    exporting
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      prefix   = 'M'
      kinds    = kinds
  ).

  run_completion_test(
    exporting
      line     = 'm'
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      compname = 'MAP_COMPLETION_RESULTS'
      compkind = sccmp_cat_method
      context = context
      result  = result
  ).

  endmethod.       "Completion_own_method

* ----------------------------------------------------------------------
  method Completion_own_type.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result,
        kinds   type Lcl_Completion_Result=>ty_kinds,
        kind    like line of kinds.

  context = lcl_completion_context=>create(
      name     = '/cadaxo/cl_sqlc_abap_parser'
      kind     = 'K'
  ).
  context->set_include( methname = 'CALCULATE_COMPLETION_RESULTS' ).
  context->add( 'method dummy.' ).

  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_type.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add_components(
    exporting
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      prefix   = 'B'
      kinds    = kinds
      onlyinst = abap_true
  ).

  run_completion_test(
    exporting
      line     = 'types mytype type b'
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      compname = 'BASICTYPE_NAMES'
      compkind = sccmp_cat_type
      context  = context
      result   = result
  ).

  endmethod.       "Completion_own_type

* ----------------------------------------------------------------------
  method Completion_other_method.

    data: context type ref to lcl_completion_context,
          result  type ref to lcl_completion_result,
          kinds   type Lcl_Completion_Result=>ty_kinds,
          kind    like line of kinds.

    context = lcl_completion_context=>create(
        name     = '/cadaxo/cl_sqlc_abap_parser'
        kind     = 'K'
    ).
    context->set_include( methname = 'CALCULATE_COMPLETION_RESULTS' ).
    context->add( 'method dummy.' ).
    context->add( 'data myref type ref to CL_ABAP_CC_ATL_TEMPLATES.' ).

    kind-sign = 'I'.
    kind-option = 'EQ'.
    kind-high = kind-low = sccmp_cat_method.
    append kind to kinds.
    kind-high = kind-low = sccmp_cat_field.
    append kind to kinds.

    result = lcl_completion_result=>create( ).
    result->add_components(
      exporting
        objname  = 'CL_ABAP_CC_ATL_TEMPLATES'
        prefix   = 'T'
        kinds    = kinds
        onlyinst = abap_true
        onlypubl = abap_true
    ).


    run_completion_test(
      exporting
        line     = 'myref->t'
        objname  = 'CL_ABAP_CC_ATL_TEMPLATES'
        compname = 'TEST_ATL_MESSAGE'
        compkind = sccmp_cat_method
        context  = context
        result   = result
    ).

  endmethod.       "Completion_other_method

* ----------------------------------------------------------------------
  method Completion_other_event.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result,
        kinds   type Lcl_Completion_Result=>ty_kinds,
        kind    like line of kinds.

  context = lcl_completion_context=>create(
      name     = '/cadaxo/cl_sqlc_abap_parser'
      kind     = 'K'
  ).
  context->set_include( methname = 'CALCULATE_COMPLETION_RESULTS' ).
  context->add( 'method dummy.' ).
  context->add( 'data myref type ref to CL_GUI_SOURCEEDIT.' ).

  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_event.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add_components(
    exporting
      objname  = 'CL_GUI_SOURCEEDIT'
      prefix   = 'I'
      kinds    = kinds
      onlyinst = abap_true
      onlypubl = abap_true
  ).

  run_completion_test(
    exporting
      line     = 'raise event myref->i'
      objname  = 'CL_GUI_SOURCEEDIT'
      compname = 'INSERT_PATTERN'
      compkind = sccmp_cat_event
      context  = context
      result   = result
  ).

  endmethod.       "Completion_other_event

* ----------------------------------------------------------------------
  method Completion_method_parameters.

  data: context  type ref to lcl_completion_context,
        result   type ref to lcl_completion_result,
        comps    type ref to Lcl_Completion_Result,
        kinds    type Lcl_Completion_Result=>ty_kinds,
        kind     like line of kinds.

  context = lcl_completion_context=>create(
      name     = '/cadaxo/cl_sqlc_abap_parser'
      kind     = 'K'
  ).
  context->set_include( methname = 'COMPOSE_INCLUDES' ).
  context->add( 'method COMPOSE_INCLUDES.' ).
  context->add( 'data mylocvar type i.' ).

* add class-local attributes
  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_field.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add_components(
    exporting
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      prefix   = 'P'
      kinds    = kinds
  ).
* add formal parameters
  refresh kinds.
  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_field.
  append kind to kinds.
  result->add_subcomponents(
    exporting
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      compkind = sccmp_cat_method
      compname = 'COMPOSE_INCLUDES'
      prefix   = 'P'
      kinds    = kinds
  ).

  context->check_completion(
    exporting
      line     = 'mylocvar = p'
      positive = result
  ).

* add formal parameter PROGRAMTYPE
  refresh kinds.
  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_field.
  append kind to kinds.
  comps = lcl_completion_result=>create( ).
  comps->add_subcomponents(
    exporting
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      compkind = sccmp_cat_method
      compname = 'COMPOSE_INCLUDES'
      prefix   = 'PROGRAMTYPE'
      kinds    = kinds
  ).

* add properties of PROGRAMTYPE
  comps->checks = value #(
                    ( path = `paramkind`  value = `importing` )
                    ( path = `optional`  value = `false` )
                    ( path = `byvalue`  value = `false` )
                    ( path = `type`  value = `subc` )
                    ( path = `is_type`  value = `c length 1` )
                  ).

  context->check_quickinfo(
    exporting
      objname  = 'PROGRAMTYPE'
      objkind  = sccmp_cat_field
      positive = comps
  ).

  context->check_element_info(
    exporting
      objname  = 'PROGRAMTYPE'
      objkind  = sccmp_cat_field
      positive = comps
  ).

  context->check_insertion(
    exporting
      objname  = 'PROGRAMTYPE'
      objkind  = sccmp_cat_field
      positive = comps
  ).

  endmethod.       "Completion_method_parameters


* ----------------------------------------------------------------------
  method Completion_function.

    data: context type ref to lcl_completion_context,
          result  type ref to lcl_completion_result,
          kinds   type Lcl_Completion_Result=>ty_kinds,
          kind    like line of kinds.

    context = lcl_completion_context=>create(
        name     = 'CL_ABAP_QI_ATL_TEMPLATES'
        kind     = 'K'
    ).
    context->set_include( methname = 'TEST_ATL_FUNCTION' ).
    context->add( 'method TEST_ATL_FUNCTION.' ).

    kind-sign = 'I'.
    kind-option = 'EQ'.
    kind-high = kind-low = sccmp_cat_function.
    append kind to kinds.

    result = lcl_completion_result=>create( ).
    result->add_components(
      exporting
        objname  = space
        prefix   = 'COMMON_LOG'
        kinds    = kinds
    ).

    run_completion_test(
      exporting
        line     = 'call function ''COMMON_LOG'
        objname  = space
        compname = 'COMMON_LOG_READ_T100'
        compkind = sccmp_cat_function
        context  = context
        result   = result
    ).

  endmethod.       "Completion_function


* ----------------------------------------------------------------------
  method Completion_callmethod.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result,
        kinds   type Lcl_Completion_Result=>ty_kinds,
        kind    like line of kinds.

  context = lcl_completion_context=>create(
      name     = 'CL_GUI_ABAPEDIT'
      kind     = 'K'
  ).
  context->set_include( methname = 'GET_COMPLETER' ).
  context->add( 'method GET_COMPLETER.' ).

  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_method.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add_components(
    exporting
      objname  = 'CL_GUI_ABAPEDIT'
      prefix   = 'I'
      kinds    = kinds
  ).

  run_completion_test(
    exporting
      line     = 'call method me->i'
      objname  = 'CL_GUI_ABAPEDIT'
      compname = 'is_cached_prop'
      compkind = sccmp_cat_method
      context = context
      result  = result
  ).

  endmethod.       "Completion_callmethod


* ----------------------------------------------------------------------
  method Completion_redefmethimpl.

  data: context   type ref to lcl_completion_context,
        result    type ref to lcl_completion_result,
        kinds     type Lcl_Completion_Result=>ty_kinds,
        kind      like line of kinds.

* test using a redefined method
  context = lcl_completion_context=>create(
      name     = 'CL_GUI_ABAPEDIT'
      kind     = 'K'
  ).
  context->set_include( methname = 'GET_COMPLETER' ).
  context->add( 'method GET_COMPLETER.' ).
  context->add( 'data control_enabled type c length 1.' ).

* add class-local attributes
  clear kinds.
  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_field.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add_components(
    exporting
      objname  = 'CL_GUI_ABAPEDIT'
      prefix   = 'C'
      kinds    = kinds
      onlywrit = abap_true
  ).
  result->add(
    EXPORTING
      name = 'control_enabled'
      kind = sccmp_cat_field
  ).

  run_completion_test(
    exporting
      line     = 'cl_gui_sourceedit=>SET_REGISTERED_EVENTS( c'
      objname  = 'CL_GUI_ABAPEDIT'
      compname = 'CATT_ACTIV'
      compkind = sccmp_cat_field
      context  = context
      result   = result
  ).

* test with functional method
  run_completion_test(
    exporting
      line     = 'c'
      objname  = 'CL_GUI_ABAPEDIT'
      compname = 'call_method_result_gui_object'
      compkind = sccmp_cat_method
      context  = context
      result   = result
      pattern  = sccmp_cxt_call_meth_func
  ).

* test parameters of redefined method
  context = lcl_completion_context=>create(
      name     = 'CL_GUI_SOURCEEDIT'
      kind     = 'K'
  ).
  context->set_include( methname = 'DISPATCH' ).

* add methods
  clear kinds.
  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_method.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add_components(
    exporting
      objname  = 'CL_GUI_SOURCEEDIT'
      prefix   = 'D'
      kinds    = kinds
  ).

  context->check_completion(
    exporting
      line     = 'method d'
      positive = result
  ).

  result->clear( ).
  result->add_subcomponents(
    exporting
      objname  = 'CL_GUI_SOURCEEDIT'
      compkind = sccmp_cat_method
      compname = 'DISPATCH'
  ).

  context->check_quickinfo(
    exporting
      objname  = 'DISPATCH'
      objkind  = sccmp_cat_method
      positive = result
  ).

* add properties of DISPATCH
  result->checks = value #(
                      ( path = `final`  value = `false` )
                      ( path = `redefined` value = `true` )
                      ( path = `visibility` value = `public` )
                      ( path = `member_kind` value = `instance` )
                      ( path = `da:cargo\paramkind` value = `importing` )
                      ( path = `da:cargo\byvalue` value = `true` )
                      ( path = `da:cargo\type` value = `SYUCOMM` )
                      ( path = `da:eventid\paramkind` value = `importing` )
                      ( path = `da:eventid\byvalue` value = `true` )
                      ( path = `da:eventid\type` value = `i` )
                      ( path = `da:is_shellevent\paramkind` value = `importing` )
                      ( path = `da:is_shellevent\byvalue` value = `true` )
                      ( path = `da:is_shellevent\type` value = `char1` )
                      ( path = `da:is_shellevent\is_type` value = `c length 1` )
                      ( path = `da:is_systemdispatch\paramkind` value = `importing` )
                      ( path = `da:is_systemdispatch\byvalue` value = `true` )
                      ( path = `da:is_systemdispatch\optional` value = `true` )
                    ).

  context->check_element_info(
    exporting
      objname  = 'DISPATCH'
      objkind  = sccmp_cat_method
      positive = result
  ).

  endmethod.       "Completion_redefmethimpl


* ----------------------------------------------------------------------
  method Completion_localclass.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result,
        kinds   type Lcl_Completion_Result=>ty_kinds,
        kind    like line of kinds.

  context = lcl_completion_context=>create(
      name     = '/cadaxo/cl_sqlc_abap_parser'
      kind     = 'K'
  ).
  context->set_include( inclname = 'cl_abap_parser================CCAU' ).
  context->add( 'class lcl definition inheriting from /cadaxo/cl_sqlc_abap_parser for testing.' ).
  context->add( 'public section. methods HANDLE_INSERTION_REQUEST redefinition. endclass.' ).
  context->add( 'class lcl implementation. method HANDLE_INSERTION_REQUEST.' ).

  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_field.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add_subcomponents(
    exporting
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      compkind = sccmp_cat_method
      compname = 'HANDLE_INSERTION_REQUEST'
      prefix   = 'P'
      kinds    = kinds
  ).

  context->check_completion(
    exporting
      line     = 'SUPER->HANDLE_INSERTION_REQUEST( exporting p'
      positive = result
  ).

  result->add_components(
    exporting
      objkind  = lif_progtype=>classpool
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      prefix   = 'P'
      kinds    = kinds
      onlypubl = abap_true
  ).

  context->check_completion(
    exporting
      line     = 'call method super->HANDLE_INSERTION_REQUEST( exporting patternkey = p'
      positive = result
  ).

  result->clear( ).
  result->add(
    EXPORTING
      name = 'STRING'
      kind = sccmp_cat_type
  ).

  context->check_quickinfo(
    exporting
      objname  = 'PATTERNKEY'
      objkind  = sccmp_cat_field
      positive = result
  ).

* add properties of PATTERNKEY
  result->checks = value #(
                     ( path = `paramkind`  value = `importing` )
                     ( path = `byvalue`  value = `true` )
                     ( path = `optional`  value = `false` )
                     ( path = `type`  value = `string` )
                   ).

  context->check_element_info(
    exporting
      objname  = 'PATTERNKEY'
      objkind  = sccmp_cat_field
      positive = result
  ).

  clear kinds.
  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_method.
  append kind to kinds.

  result->clear( ).
  result->add_components(
    exporting
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      prefix   = 'HANDLE'
      kinds    = kinds
      onlyinst = abap_true
      onlypubl = abap_true
  ).

  run_completion_test(
    exporting
      line     = 'call method me->handle'
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      compname = 'HANDLE_INSERTION_REQUEST'
      compkind = sccmp_cat_method
      context  = context
      result   = result
  ).

  endmethod.       "Completion_localclass


* ----------------------------------------------------------------------
  method Completion_createobject.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result,
        kinds   type Lcl_Completion_Result=>ty_kinds,
        kind    like line of kinds.

  context = lcl_completion_context=>create(
      name     = '/cadaxo/cl_sqlc_abap_parser'
      kind     = 'K'
  ).
  context->set_include( inclname = 'cl_abap_parser================CCMAC' ).
  context->add( 'class lcl definition.' ).
  context->add( 'public section. methods create. endclass.' ).
  context->add( 'class lcl implementation. method create. data myref type ref to CL_GUI_CALENDAR.' ).
  context->add( 'data mygenericref type ref to object.' ).

  result = lcl_completion_result=>create( ).
  result->add(
    exporting
      name = 'myref'
      kind = sccmp_cat_field
  ).
  result->add(
    exporting
      name = 'mygenericref'
      kind = sccmp_cat_field
  ).

  context->check_completion(
    exporting
      line     = 'create object m'
      positive = result
  ).

  result->clear( ).
  result->add(
    EXPORTING
      name = 'CL_GUI_CALENDAR'
      kind = sccmp_cat_type
  ).

  context->check_quickinfo(
    exporting
      objname  = 'MYREF'
      objkind  = sccmp_cat_field
      positive = result
  ).

* add properties of MYREF
  result->checks = value #(
                     ( path = `member_kind`  value = `` )
                     ( path = `type`  value = `ref to CL_GUI_CALENDAR` )
                   ).

  context->check_element_info(
    exporting
      objname  = 'MYREF'
      objkind  = sccmp_cat_field
      positive = result
  ).

  result->clear( ).
  result->add(
    EXPORTING
      name = 'OBJECT'
      kind = sccmp_cat_type
  ).

  context->check_quickinfo(
    exporting
      objname  = 'MYGENERICREF'
      objkind  = sccmp_cat_field
      positive = result
  ).

* add properties of MYGENERICREF
  result->checks = value #(
                     ( path = `member_kind`  value = `` )
                     ( path = `type`  value = `ref to OBJECT` )
                   ).

  context->check_element_info(
    exporting
      objname  = 'MYGENERICREF'
      objkind  = sccmp_cat_field
      positive = result
  ).

  clear kinds.
  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_field.
  append kind to kinds.

  result->clear( ).
  result->add_subcomponents(
    exporting
      objname  = 'CL_GUI_CALENDAR'
      compkind = sccmp_cat_method
      compname = 'CONSTRUCTOR'
      kinds    = kinds
  ).

  context->check_insertion(
    exporting
      objname  = 'MYREF'
      objkind  = sccmp_cat_field
      positive = result
  ).

* check CREATE OBJECT ... TYPE case
  result->clear( ).
  result->add(
    EXPORTING
      name = '/cadaxo/cl_sqlc_abap_parser'
      kind = sccmp_cat_type
  ).
  result->add(
    EXPORTING
      name = 'CL_ABAP_PRAGMA'
      kind = sccmp_cat_type
  ).

  context->check_completion(
    exporting
      line     = 'create object mygenericref type cl_abap_p'
      positive = result
  ).

  clear kinds.
  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_field.
  append kind to kinds.

  result->clear( ).
  result->add_subcomponents(
    exporting
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      compkind = sccmp_cat_method
      compname = 'CONSTRUCTOR'
      kinds    = kinds
  ).

  context->check_insertion(
    exporting
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      objkind  = sccmp_cat_type
      positive = result
  ).

  endmethod.       "Completion_createobject


* ----------------------------------------------------------------------
  method Completion_raiseevent.

    data: context type ref to lcl_completion_context,
          result  type ref to lcl_completion_result,
          kinds   type Lcl_Completion_Result=>ty_kinds,
          kind    like line of kinds.

    context = lcl_completion_context=>create(
        name     = '/cadaxo/cl_sqlc_abap_parser'
        kind     = 'K'
    ).
    context->set_include( inclname = 'cl_abap_parser================CCIMP' ).
    context->add( 'class lcl definition.' ).
    context->add( 'public section. methods dummy. endclass.' ).
    context->add( 'class lcl implementation. method dummy. data controlref type ref to CL_GUI_ALV_TREE.' ).

    kind-sign = 'I'.
    kind-option = 'EQ'.
    kind-high = kind-low = sccmp_cat_event.
    append kind to kinds.

    result = lcl_completion_result=>create( ).
    result->add_components(
      exporting
        objname  = 'CL_GUI_ALV_TREE'
        prefix   = 'ON'
        kinds    = kinds
    ).

    run_completion_test(
      exporting
        line     = 'raise event controlref->on'
        objname  = 'CL_GUI_ALV_TREE'
        compname = 'ON_DRAG_MULTIPLE'
        compkind = sccmp_cat_event
        context  = context
        result   = result
    ).

  endmethod.       "Completion_raiseevent


* ----------------------------------------------------------------------
  method Completion_raiseexception.

    data: context type ref to lcl_completion_context,
          result  type ref to lcl_completion_result,
          kinds   type Lcl_Completion_Result=>ty_kinds,
          kind    like line of kinds.

    context = lcl_completion_context=>create(
        name     = 'SAPLSRCC'
        kind     = lif_progtype=>functiongroup
    ).
    context->set_include( inclname = 'LSRCCU01' ).
    context->add( 'function srcc_get_code_completion.' ).

    result = lcl_completion_result=>create( ).
    result->add(
      exporting
        name = 'CX_ABAP_CC_ATL_TEMPLATES'
        kind = sccmp_cat_type
    ).

    context->check_completion(
      exporting
        line     = 'raise exception type CX_ABAP_'
        positive = result
    ).

    context->check_quickinfo(
      exporting
        objname  = 'CX_ABAP_CC_ATL_TEMPLATES'
        objkind  = sccmp_cat_type
        positive = result
    ).

*   add properties of CX_ABAP_CC_ATL_TEMPLATES
    result->checks = value #(
                       ( path = `global`  value = `true` )
                       ( path = `final`  value = `true` )
                       ( path = `excpclass`  value = `true` )
                       ( path = `da:CX_ABAP_CC_ATL_TEMPLATES\datakind`  value = `constant` )
                       ( path = `da:TEMPLATE_NOT_FOUND\datakind`  value = `constant` )
                       ( path = `da:TEMPLATE_PROTECTED\datakind`  value = `constant` )
                       ( path = `da:TEMPLATE_NAME\member_kind`  value = `instance` )
                       ( path = `me:CONSTRUCTOR\member_kind`  value = `instance` )
                       ( path = `me:CONSTRUCTOR\da:TEXTID\paramkind`  value = `importing` )
                       ( path = `me:CONSTRUCTOR\da:TEXTID\optional`  value = `true` )
                       ( path = `me:CONSTRUCTOR\da:TEXTID\type`  value = `SOTR_CONC` )
                       ( path = `me:CONSTRUCTOR\da:TEXTID\is_type`  value = `c length 32` )
                       ( path = `me:CONSTRUCTOR\da:PREVIOUS\paramkind`  value = `importing` )
                       ( path = `me:CONSTRUCTOR\da:PREVIOUS\optional`  value = `true` )
                       ( path = `me:CONSTRUCTOR\da:PREVIOUS\type`  value = `ref to CX_ROOT` )
                       ( path = `me:CONSTRUCTOR\da:TEMPLATE_NAME\paramkind`  value = `importing` )
                       ( path = `me:CONSTRUCTOR\da:TEMPLATE_NAME\optional`  value = `true` )
                       ( path = `me:CONSTRUCTOR\da:TEMPLATE_NAME\type`  value = `string` )
                     ).

    context->check_element_info(
      exporting
        objname  = 'CX_ABAP_CC_ATL_TEMPLATES'
        objkind  = sccmp_cat_type
        positive = result
    ).

    clear kinds.
    kind-sign = 'I'.
    kind-option = 'EQ'.
    kind-high = kind-low = sccmp_cat_field.
    append kind to kinds.

    result->clear( ).
    result->add_subcomponents(
      exporting
        objname  = 'CX_ABAP_CC_ATL_TEMPLATES'
        compkind = sccmp_cat_method
        compname = 'CONSTRUCTOR'
        kinds    = kinds
    ).

    context->check_insertion(
      exporting
        objname  = 'CX_ABAP_CC_ATL_TEMPLATES'
        objkind  = sccmp_cat_type
        positive = result
    ).

  endmethod.       "Completion_raiseexception

* ----------------------------------------------------------------------
  method Completion_in_functiongroup.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result.

  context = lcl_completion_context=>create(
      name     = 'SAPLST22_TOOLS'
      kind     = lif_progtype=>functiongroup
  ).
  context->set_include( funcname = 'RS_ST22_GET_DUMPS_CATEGORIES' ).
  context->add( 'function RS_ST22_GET_DUMPS_CATEGORIES.' ).

* check access to FORM definitions
  result = lcl_completion_result=>create( ).
  result->add(
    exporting
      name = 'get_dump_category'
      kind = sccmp_cat_form
  ).

  result->add(
    exporting
      name = 'get_dump_category_by_text'
      kind = sccmp_cat_form
  ).

  context->check_completion(
    exporting
      line     = 'perform g'
      positive = result
  ).

  result->clear( ).
  result->add(
    exporting
      name = 'p_dump_name'
      kind = sccmp_cat_field
  ).
  result->add(
    exporting
      name = 'p_category'
      kind = sccmp_cat_field
  ).

  context->check_quickinfo(
    exporting
      objname  = 'GET_DUMP_CATEGORY_BY_TEXT'
      objkind  = sccmp_cat_form
      positive = result
  ).

  context->check_element_info(
    exporting
      objname  = 'GET_DUMP_CATEGORY_BY_TEXT'
      objkind  = sccmp_cat_form
      positive = result
  ).

  context->check_insertion(
    exporting
      objname  = 'GET_DUMP_CATEGORY_BY_TEXT'
      objkind  = sccmp_cat_form
      positive = result
  ).

* check access to FORM definitions within FORM include
  context->read_include( 'LST22_TOOLSF01' ).
  context->add( ' FORM test.' ).

  result->clear( ).
  result->add(
    exporting
      name = 'get_dump_category'
      kind = sccmp_cat_form
  ).

  result->add(
    exporting
      name = 'get_dump_category_by_text'
      kind = sccmp_cat_form
  ).

  context->check_completion(
    exporting
      line     = 'perform g'
      positive = result
  ).

  result->clear( ).
  result->add(
    exporting
      name = 'p_dump_name'
      kind = sccmp_cat_field
  ).
  result->add(
    exporting
      name = 'p_category'
      kind = sccmp_cat_field
  ).

  context->check_quickinfo(
    exporting
      objname  = 'GET_DUMP_CATEGORY_BY_TEXT'
      objkind  = sccmp_cat_form
      positive = result
  ).

  context->check_element_info(
    exporting
      objname  = 'GET_DUMP_CATEGORY_BY_TEXT'
      objkind  = sccmp_cat_form
      positive = result
  ).

  context->check_insertion(
    exporting
      objname  = 'GET_DUMP_CATEGORY_BY_TEXT'
      objkind  = sccmp_cat_form
      positive = result
  ).

* check access to TOP-Include definitions
  result->clear( ).
  result->add(
    exporting
      name = 'values'
      kind = sccmp_cat_field
  ).
  result->add(
    exporting
      name = 'includes'
      kind = sccmp_cat_field
  ).
  result->add(
    exporting
      name = 'texts'
      kind = sccmp_cat_field
  ).

  context->check_completion(
    exporting
      line     = 'p_dumps_categories = lcl_categories=>'
      positive = result
  ).

  result->clear( ).
  result->add(
    exporting
      name = 'st22_categories'
      kind = sccmp_cat_type
  ).

  context->check_quickinfo(
    exporting
      objname  = 'VALUES'
      objkind  = sccmp_cat_field
      positive = result
  ).

  context->check_element_info(
    exporting
      objname  = 'VALUES'
      objkind  = sccmp_cat_field
      positive = result
  ).

* check access to TOP-Include definitions within TOP-include
  context->read_include( 'LST22_TOOLSTOP' ).

  result->clear( ).
  result->add(
    exporting
      name = 'values'
      kind = sccmp_cat_field
  ).
  result->add(
    exporting
      name = 'includes'
      kind = sccmp_cat_field
  ).
  result->add(
    exporting
      name = 'texts'
      kind = sccmp_cat_field
  ).

  context->check_completion(
    exporting
      line     = 'data cats like lcl_categories=>'
      positive = result
  ).

  result->clear( ).
  result->add(
    exporting
      name = 'st22_categories'
      kind = sccmp_cat_type
  ).

  context->check_quickinfo(
    exporting
      objname  = 'TEXTS'
      objkind  = sccmp_cat_field
      positive = result
  ).

  context->check_element_info(
    exporting
      objname  = 'TEXTS'
      objkind  = sccmp_cat_field
      positive = result
  ).

  endmethod.       "Completion_in_functiongroup


* ----------------------------------------------------------------------
  method Completion_type_with_length.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result,
        kinds   type Lcl_Completion_Result=>ty_kinds,
        kind    like line of kinds.

  context = lcl_completion_context=>create(
      name     = '/cadaxo/cl_sqlc_abap_parser'
      kind     = 'K'
  ).
  context->set_include( methname = 'CALCULATE_COMPLETION_RESULTS' ).
  context->add( 'method dummy.' ).
  context->add( 'types mycharseq type c length 10000.' ).
  context->add( 'types myrawseq  type x length 20000.' ).
  context->add( 'types mynumseq  type n length 30000.' ).

  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_type.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add(
    EXPORTING
      name = 'MYCHARSEQ'
      kind = sccmp_cat_type
  ).
  result->add(
    EXPORTING
      name = 'MYRAWSEQ'
      kind = sccmp_cat_type
  ).
  result->add(
    EXPORTING
      name = 'MYNUMSEQ'
      kind = sccmp_cat_type
  ).

* call completion
  context->check_completion(
    exporting
    line     = 'data mydata type my'
      positive  = result
  ).

* call quick info
  context->check_quickinfo(
    EXPORTING
      objname  = 'MYCHARSEQ'
      objkind  = sccmp_cat_type
      texts    = VALUE Lcl_Completion_Context=>t_texts( ( `10000` ) )
  ).

* call quick info
  context->check_quickinfo(
    EXPORTING
      objname  = 'MYRAWSEQ'
      objkind  = sccmp_cat_type
      texts    = VALUE Lcl_Completion_Context=>t_texts( ( `20000` ) )
  ).

* call quick info
  context->check_quickinfo(
    EXPORTING
      objname  = 'MYNUMSEQ'
      objkind  = sccmp_cat_type
      texts    = VALUE Lcl_Completion_Context=>t_texts( ( `30000` ) )
  ).

  endmethod.       "Completion_type_with_length

* ----------------------------------------------------------------------
  method Completion_call_method_compute.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result,
        kinds   type Lcl_Completion_Result=>ty_kinds,
        kind    like line of kinds.

  context = lcl_completion_context=>create(
      name     = '/cadaxo/cl_sqlc_abap_parser'
      kind     = 'K'
  ).
  context->set_include( methname = 'CALCULATE_COMPLETION_RESULTS' ).
  context->add( 'method dummy.' ).
  context->add( 'data index type SCC_PROPERTY.' ).
  context->add( 'data name type SCC_IDENTIFIER.' ).

  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_type.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add(
    EXPORTING
      name = 'GET_BASICTYPE_TEXT'
      kind = sccmp_cat_method
  ).

* call completion
  run_completion_test(
    exporting
      line      = '/cadaxo/cl_sqlc_abap_parser=>GET_BASICTYPE_T'
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      compname = 'GET_BASICTYPE_TEXT'
      compkind = sccmp_cat_method
      context = context
      result  = result
  ).

* check insertion ends with dot
  context->check_insertion(
    exporting
      objname  = 'GET_BASICTYPE_TEXT'
      objkind  = sccmp_cat_method
      stmtend  = `).`
  ).

  endmethod.       "Completion_call_method_compute

* ----------------------------------------------------------------------
  method Completion_call_method_expr.

  data: context type ref to lcl_completion_context,
        result  type ref to lcl_completion_result,
        kinds   type Lcl_Completion_Result=>ty_kinds,
        kind    like line of kinds.

  context = lcl_completion_context=>create(
      name     = '/cadaxo/cl_sqlc_abap_parser'
      kind     = 'K'
  ).
  context->set_include( methname = 'CALCULATE_COMPLETION_RESULTS' ).
  context->add( 'method dummy.' ).
  context->add( 'data index type SCC_PROPERTY.' ).
  context->add( 'data name type SCC_IDENTIFIER.' ).

  kind-sign = 'I'.
  kind-option = 'EQ'.
  kind-high = kind-low = sccmp_cat_type.
  append kind to kinds.

  result = lcl_completion_result=>create( ).
  result->add(
    EXPORTING
      name = 'GET_BASICTYPE_TEXT'
      kind = sccmp_cat_method
  ).

* call completion
  run_completion_test(
    exporting
      line      = 'name = /cadaxo/cl_sqlc_abap_parser=>GET_BASICTYPE_TYPE( P_BASICTYPE_INDEX = /cadaxo/cl_sqlc_abap_parser=>GET_B'
      objname  = '/cadaxo/cl_sqlc_abap_parser'
      compname = 'GET_BASICTYPE_TEXT'
      compkind = sccmp_cat_method
      context = context
      result  = result
  ).

* check insertion ends without dot
  context->check_insertion(
    exporting
      objname  = 'GET_BASICTYPE_TEXT'
      objkind  = sccmp_cat_method
      stmtend  = `)`
  ).

  endmethod.       "Completion_call_method_expr

* ----------------------------------------------------------------------
  method Completion_class_impl.

    data: context    type ref to lcl_completion_context,
          result     type ref to lcl_completion_result,
          kinds      type Lcl_Completion_Result=>ty_kinds,
          kind       like line of kinds,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = 'CL_GUI_ALV_GRID'
        kind     = 'K'
    ).
    context->set_include( inclname = 'CL_GUI_ALV_GRID===============CCIMP' ).

    kind-sign = 'I'.
    kind-option = 'EQ'.
    kind-high = kind-low = sccmp_cat_type.
    append kind to kinds.

    result = lcl_completion_result=>create( ).
    result->add(
      EXPORTING
        name = 'CL_GUI_ALV_GRID'
        kind = sccmp_cat_type
    ).
    result->add(
      EXPORTING
        name = 'lcl_event_receiver_dbox'
        kind = sccmp_cat_type
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `class `
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'IF_DRAGDROP'
        KIND = sccmp_cat_type
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'FREE'
        KIND = sccmp_cat_method
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'DISPATCH'
        KIND = sccmp_cat_method
    ).

    COMPONENTS->ADD(
      exporting
        NAME = 'GET_SEARCH_DATA'
        KIND = sccmp_cat_method
    ).

    context->check_quickinfo(
      exporting
        objname  = 'CL_GUI_ALV_GRID'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   add properties of CL_GUI_ALV_GRID
    components->checks = value #(
                           ( path = `final`  value = `false` )
                           ( path = `global` value = `true` )
                           ( path = `typekind` value = `objecttype` )
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `` )
                           ( path = `ty:CL_GUI_ALV_GRID_BASE\typekind` value = `objecttype` )
                           ( path = `ty:IF_DRAGDROP\typekind` value = `objecttype` )
                           ( path = `da:M_BUFFER_INACTIVE\member_kind` value = `class` )
                           ( path = `da:M_BUFFER_INACTIVE\type` value = `char01` )
                           ( path = `da:M_BUFFER_INACTIVE\is_type` value = `c length 1` )
                           ( path = `me:DISPATCH\member_kind` value = `instance` )
                           ( path = `me:DISPATCH\redefined` value = `true` )
                           ( path = `me:GET_SEARCH_DATA\member_kind` value = `instance` )
                           ( path = `me:GET_SEARCH_DATA\da:r_search\paramkind` value = `returning` )
                           ( path = `me:GET_SEARCH_DATA\da:r_search\type` value = `ref to IF_ALV_LVC_SEARCH` )
                           ( path = `me:CELL_DISPLAY\member_kind` value = `class` )
                           ( path = `me:CELL_DISPLAY\da:IS_DATA\paramkind` value = `importing` )
                           ( path = `me:CELL_DISPLAY\da:IS_DATA\byvalue` value = `true` )
                           ( path = `me:CELL_DISPLAY\da:IS_DATA\type` value = `any` )
                           ( path = `me:CELL_DISPLAY\da:I_INT_VALUE\paramkind` value = `importing` )
                           ( path = `me:CELL_DISPLAY\da:I_INT_VALUE\byvalue` value = `true` )
                           ( path = `me:CELL_DISPLAY\da:I_INT_VALUE\type` value = `any` )
                           ( path = `me:CELL_DISPLAY\da:E_EXT_VALUE\paramkind` value = `exporting` )
                           ( path = `me:CELL_DISPLAY\da:E_EXT_VALUE\optional` value = `true` )
                           ( path = `me:CELL_DISPLAY\da:CS_FIELDCAT\paramkind` value = `changing` )
                           ( path = `me:CELL_DISPLAY\da:CS_FIELDCAT\optional` value = `false` )
                           ( path = `me:CELL_DISPLAY\da:CS_FIELDCAT\type` value = `LVC_S_FCAT` )
                           ( path = `ev:DATA_CHANGED\member_kind` value = `instance` )
                           ( path = `ev:DATA_CHANGED\da:ER_DATA_CHANGED\paramkind` value = `exporting` )
                           ( path = `ev:DATA_CHANGED\da:ER_DATA_CHANGED\byvalue` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:ER_DATA_CHANGED\optional` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:ER_DATA_CHANGED\type` value = `ref to CL_ALV_CHANGED_DATA_PROTOCOL` )
                           ( path = `ev:DATA_CHANGED\da:E_ONF4\paramkind` value = `exporting` )
                           ( path = `ev:DATA_CHANGED\da:E_ONF4\byvalue` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:E_ONF4\optional` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:E_ONF4_AFTER\paramkind` value = `exporting` )
                           ( path = `ev:DATA_CHANGED\da:E_ONF4_AFTER\byvalue` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:E_ONF4_AFTER\optional` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:E_ONF4_BEFORE\paramkind` value = `exporting` )
                           ( path = `ev:DATA_CHANGED\da:E_ONF4_BEFORE\byvalue` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:E_ONF4_BEFORE\optional` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:E_UCOMM\paramkind` value = `exporting` )
                           ( path = `ev:DATA_CHANGED\da:E_UCOMM\byvalue` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:E_UCOMM\optional` value = `true` )
                           ( path = `ev:DATA_CHANGED\da:E_UCOMM\type` value = `SYST_UCOMM` )
                           ( path = `da:MC_EVT_DELAYED_CHANGE_SELECT\datakind` value = `constant` )
                           ( path = `da:MC_EVT_DELAYED_CHANGE_SELECT\type` value = `i` )
                           ( path = `da:MC_EVT_DELAYED_CHANGE_SELECT\value` value = `7` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'CL_GUI_ALV_GRID'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

  endmethod.       "Completion_class_impl

* ----------------------------------------------------------------------
  method Completion_interface_impl.
* ----------------------------------------------------------------------

    data: context    type ref to lcl_completion_context,
          result     type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = 'CL_GUI_ALV_GRID'
        kind     = 'K'
    ).
    context->set_include( inclname = 'CL_GUI_ALV_GRID===============CCIMP' ).
    context->add( 'class dummy definition.' ).
    context->add( 'public section.' ).

    result = lcl_completion_result=>create( ).
    result->add(
      EXPORTING
        name = 'IF_ABAP_READER'
        kind = sccmp_cat_type
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `interfaces IF_ABAP_READ`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'IF_ABAP_CLOSE_RESOURCE'
        KIND = sccmp_cat_type
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'SKIP'
        KIND = sccmp_cat_method
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'SET_MARK'
        KIND = sccmp_cat_method
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'READ'
        KIND = sccmp_cat_method
    ).

    context->check_quickinfo(
      exporting
        objname  = 'IF_ABAP_READER'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   add properties of IF_ABAP_READER
    components->checks = value #(
                           ( path = `global` value = `true` )
                           ( path = `typekind` value = `objecttype` )
                           ( path = `visibility` value = `` )
                           ( path = `member_kind` value = `` )
                           ( path = `ty:IF_ABAP_CLOSE_RESOURCE\typekind` value = `objecttype` )
                           ( path = `me:SKIP\member_kind` value = `instance` )
                           ( path = `me:SKIP\da:length\paramkind` value = `importing` )
                           ( path = `me:SKIP\ex:CX_PARAMETER_INVALID_RANGE\` value = `true` )
                           ( path = `me:SKIP\ex:CX_STREAM_ERROR\` value = `true` )
                           ( path = `me:SKIP\ex:CX_RESOURCE_ALREADY_CLOSED\` value = `true` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'IF_ABAP_READER'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

  endmethod.       "Completion_interface_impl

* ----------------------------------------------------------------------
  method Completion_aliases.

    data: context    type ref to lcl_completion_context,
          result     type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = 'CL_GUI_ALV_GRID'
        kind     = 'K'
    ).
    context->set_include( inclname = 'CL_GUI_ALV_GRID===============CCIMP' ).
    context->add( 'interface lif_constants.' ).
    context->add( '  constants: co_test type i value 42.' ).
    context->add( '  data: iattr1 type i.' ).
    context->add( '  class-data cattr1 type DECFLOAT34.' ).
    context->add( '  types type_test type string.' ).
    context->add( '  events ie1 EXPORTING value(param) type string.' ).
    context->add( '  class-events ce1 EXPORTING value(param) type i.' ).
    context->add( '  methods im1 IMPORTING iparam type i EXPORTING eparam type string.' ).
    context->add( '  class-methods cm1 IMPORTING iparam type string EXPORTING eparam type d.' ).
    context->add( 'endinterface.' ).

    context->add( 'class dummy definition abstract.' ).
    context->add( '  public section.' ).
    context->add( '    interfaces: IF_GUI_LIST_TREE,' ).
    context->add( '                lif_constants.' ).
    context->add( '    methods dummy.' ).
    context->add( '    aliases AF_ALIGN_AUTO for IF_GUI_LIST_TREE~ALIGN_AUTO.' ).
    context->add( '    aliases AF_LIST_HEADER_SET_TEXT for IF_GUI_LIST_TREE~LIST_HEADER_SET_TEXT.' ).
    context->add( '    aliases AF_BUTTON_CLICK for IF_ITEM_TREE_CONTROL~BUTTON_CLICK.' ).
    context->add( '  private section.' ).
    context->add( '    aliases ali_co for lif_constants~co_test.' ).
    context->add( '    aliases ali_id for lif_constants~iattr1.' ).
    context->add( '    aliases ali_cd for lif_constants~cattr1.' ).
    context->add( '    aliases ali_ie for lif_constants~ie1.' ).
    context->add( '    aliases ali_ce for lif_constants~ce1.' ).
    context->add( '    aliases ali_im for lif_constants~im1.' ).
    context->add( '    aliases ali_cm for lif_constants~cm1.' ).
    context->add( '    ALIASES ali_type for lif_constants~type_test.' ).
    context->add( 'endclass.' ).

    context->add( 'class dummy implementation.' ).
    context->add( 'method dummy.' ).

    result = lcl_completion_result=>create( ).
    result->add(
      EXPORTING
        name = 'AF_ALIGN_AUTO'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `data locvar type i value AF`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'I'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'AF_ALIGN_AUTO'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of AF_ALIGN_AUTO
    components->checks = value #(
                           ( path = `datakind` value = `constant` )
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `class` )
                           ( path = `type` value = `i` )
                           ( path = `value` value = `3` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'AF_ALIGN_AUTO'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   test type alias
    result->clear( ).
    result->add(
      EXPORTING
        name = 'ALI_TYPE'
        kind = sccmp_cat_type
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `data test type ali_`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'STRING'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'ALI_TYPE'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   add properties of ALI_TEST
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `class` )
                           ( path = `type` value = `string` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'ALI_TYPE'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   test attribute alias
    result->clear( ).
    result->add(
      EXPORTING
        name = 'ALI_CO'
        kind = sccmp_cat_field
    ).
    result->add(
      EXPORTING
        name = 'ALI_CD'
        kind = sccmp_cat_field
    ).
    result->add(
      EXPORTING
        name = 'ALI_ID'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `test = ali_`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'DECFLOAT34'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'ALI_CD'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of ALI_CD
    components->checks = value #(
                           ( path = `datakind` value = `variable` )
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `class` )
                           ( path = `type` value = `decfloat34` )
                           ( path = `value` value = `` )                         ).

    context->check_element_info(
      exporting
        objname  = 'ALI_CD'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of ALI_CO
    components->checks = value #(
                           ( path = `datakind` value = `constant` )
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `class` )
                           ( path = `type` value = `i` )
                           ( path = `value` value = `42` )                         ).

    context->check_element_info(
      exporting
        objname  = 'ALI_CO'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   test event alias
    result->clear( ).
    result->add(
      EXPORTING
        name = 'ALI_CE'
        kind = sccmp_cat_event
    ).
    result->add(
      EXPORTING
        name = 'ALI_IE'
        kind = sccmp_cat_event
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `raise event ali_`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'STRING'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'ALI_IE'
        objkind  = sccmp_cat_event
        positive = COMPONENTS
    ).

*   add properties of ALI_IE
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `da:param\paramkind` value = `exporting` )
                           ( path = `da:param\byvalue` value = `true` )
                           ( path = `da:param\type` value = `string` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'ALI_IE'
        objkind  = sccmp_cat_event
        positive = COMPONENTS
    ).

*   add properties of ALI_CE
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `class` )
                           ( path = `da:param\paramkind` value = `exporting` )
                           ( path = `da:param\byvalue` value = `true` )
                           ( path = `da:param\type` value = `i` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'ALI_CE'
        objkind  = sccmp_cat_event
        positive = COMPONENTS
    ).

*   test method alias
    result->clear( ).
    result->add(
      EXPORTING
        name = 'ALI_CM'
        kind = sccmp_cat_method
    ).
    result->add(
      EXPORTING
        name = 'ALI_IM'
        kind = sccmp_cat_method
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `call method ali_`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'STRING'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'ALI_CM'
        objkind  = sccmp_cat_method
        positive = COMPONENTS
    ).

*   add properties of ALI_CM
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `class` )
                           ( path = `da:iparam\paramkind` value = `importing` )
                           ( path = `da:iparam\byvalue` value = `false` )
                           ( path = `da:iparam\type` value = `string` )
                           ( path = `da:eparam\paramkind` value = `exporting` )
                           ( path = `da:eparam\byvalue` value = `false` )
                           ( path = `da:eparam\type` value = `d` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'ALI_CM'
        objkind  = sccmp_cat_method
        positive = COMPONENTS
    ).

*   add properties of ALI_IM
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `da:iparam\paramkind` value = `importing` )
                           ( path = `da:iparam\byvalue` value = `false` )
                           ( path = `da:iparam\type` value = `i` )
                           ( path = `da:eparam\paramkind` value = `exporting` )
                           ( path = `da:eparam\byvalue` value = `false` )
                           ( path = `da:eparam\type` value = `string` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'ALI_IM'
        objkind  = sccmp_cat_method
        positive = COMPONENTS
    ).

  endmethod.       "Completion_aliases

* ----------------------------------------------------------------------
  method Completion_abapdoc.

    data: context    type ref to lcl_completion_context,
          result     type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = 'CL_GUI_ALV_GRID'
        kind     = 'K'
    ).
    context->set_include( inclname = 'CL_GUI_ALV_GRID===============CCIMP' ).
    context->add( 'class dummy definition.' ).
    context->add( 'public section.' ).
    context->add( 'private section. " disturb "abap" doc' ).
    context->add( '  "! Store number' ).
    context->add( '  data attr1 type i.' ).
    context->add( '  " disturb abap doc' ).
    context->add( '  "! Store name' ).
    context->add( '  data attr2 type string.' ).
    context->add( '  "! Count all' ).
    context->add( '  "! my "new" instances' ).
    context->add( '  class-data counter type decfloat34.' ).
    context->add( '* disturb abap doc' ).
    context->add( `  "! Method with all possible parameters     ` ).
    context->add( `  "!     to test "ABAP Doc"     ` ).
    context->add( `  "!   comments.  ` ).
    context->add( '  "! @parameter p1          | First' ).
    context->add( '  "!                          Parameter' ).
    context->add( '  "! @parameter p2          | Second Parameter' ).
    context->add( '  "! @parameter p3          | Third Parameter' ).
    context->add( '  "! @parameter result      | Calculation result' ).
    context->add( '  "! @raising lcx_exception | Calculation failed' ).
    context->add( '  methods meth1 importing value(p1) type i exporting value(p2) type i' ).
    context->add( '    changing p3 type i RETURNING VALUE(result) type i raising lcx_exception."disturb abap doc' ).
    context->add( '  "! Event with some parameters' ).
    context->add( '  "!   and a multi line comment' ).
    context->add( '  "!     spread over threelines.' ).
    context->add( '  "! @parameter p1          | First Event Parameter' ).
    context->add( '  "! @parameter p2          | Second Event Parameter' ).
    context->add( '  events TRIGGER exporting value(p1) type i value(p2) type i.' ).
    context->add( '  types ty_test type sabap_acc_moni_list.' ).
    context->add( '  "! some abap doc' ).
    context->add( '  "! with "double quotes"' ).
    context->add( '  methods helper "test' ).
    context->add( '    importing' ).
    context->add( '      a type ty_test.' ).
    context->add( 'endclass.' ).
    context->add( 'class dummy implementation.' ).
    context->add( 'method dummy.' ).
    context->add( '  data ref type ref to dummy.' ).

*   check completion result
    result = lcl_completion_result=>create( ).
    result->add(
      EXPORTING
        name = 'METH1'
        kind = sccmp_cat_method
    ).
    result->add(
      EXPORTING
        name = 'ATTR1'
        kind = sccmp_cat_field
    ).
    result->add(
      EXPORTING
        name = 'ATTR2'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `ref->`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'P1'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'P2'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'P3'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'result'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'lcx_exception'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'METH1'
        objkind  = sccmp_cat_method
        positive = COMPONENTS
    ).

*   add properties of METH1
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `abapdoc` value = `Method with all possible parameters to test "ABAP Doc" comments.` )
                           ( path = `da:p1\paramkind` value = `importing` )
                           ( path = `da:p1\byvalue` value = `true` )
                           ( path = `da:p1\abapdoc` value = `First Parameter` )
                           ( path = `da:p2\paramkind` value = `exporting` )
                           ( path = `da:p2\byvalue` value = `true` )
                           ( path = `da:p2\abapdoc` value = `Second Parameter` )
                           ( path = `da:p3\paramkind` value = `changing` )
                           ( path = `da:p3\byvalue` value = `false` )
                           ( path = `da:p3\abapdoc` value = `Third Parameter` )
                           ( path = `da:result\paramkind` value = `returning` )
                           ( path = `da:result\byvalue` value = `true` )
                           ( path = `da:result\abapdoc` value = `Calculation result` )
                           ( path = `ex:lcx_exception\` value = `true` )
                           ( path = `ex:lcx_exception\abapdoc` value = `Calculation failed` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'METH1'
        objkind  = sccmp_cat_method
        positive = COMPONENTS
    ).

*   check completion result
    result->clear( ).
    result->add(
      EXPORTING
        name = 'COUNTER'
        kind = sccmp_cat_field
    ).
    result->add(
      EXPORTING
        name = 'ATTR1'
        kind = sccmp_cat_field
    ).
    result->add(
      EXPORTING
        name = 'ATTR2'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `ref->`
        positive = result
    ).

*   check components in quick info
    COMPONENTS->clear( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'decfloat34'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'COUNTER'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of COUNTER
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `class` )
                           ( path = `abapdoc` value = `Count all my "new" instances` )
                           ( path = `type` value = `decfloat34` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'COUNTER'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   check completion result
    result->clear( ).
    result->add(
      EXPORTING
        name = 'trigger'
        kind = sccmp_cat_event
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `raise event ref->`
        positive = result
    ).

*   check components in quick info
    COMPONENTS->clear( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'p1'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'p2'
        KIND = sccmp_cat_field
    ).

    context->check_quickinfo(
      exporting
        objname  = 'trigger'
        objkind  = sccmp_cat_event
        positive = COMPONENTS
    ).

*   add properties of COUNTER
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `abapdoc` value = `Event with some parameters and a multi line comment spread over threelines.` )
                           ( path = `da:p1\paramkind` value = `exporting` )
                           ( path = `da:p1\byvalue` value = `true` )
                           ( path = `da:p1\abapdoc` value = `First Event Parameter` )
                           ( path = `da:p2\paramkind` value = `exporting` )
                           ( path = `da:p2\byvalue` value = `true` )
                           ( path = `da:p2\abapdoc` value = `Second Event Parameter` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'trigger'
        objkind  = sccmp_cat_event
        positive = COMPONENTS
    ).

*   check completion result
    result->clear( ).
    result->add(
      EXPORTING
        name = 'helper'
        kind = sccmp_cat_method
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `me->`
        positive = result
    ).

*   check components in quick info
    COMPONENTS->clear( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'a'
        KIND = sccmp_cat_field
    ).

    context->check_quickinfo(
      exporting
        objname  = 'helper'
        objkind  = sccmp_cat_method
        positive = COMPONENTS
    ).

*   add properties of HELPER
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `abapdoc` value = `some abap doc with "double quotes"` )
                           ( path = `da:a\paramkind` value = `importing` )
                           ( path = `da:a\byvalue` value = `false` )
                           ( path = `da:a\abapdoc` value = `` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'helper'
        objkind  = sccmp_cat_method
        positive = COMPONENTS
    ).

  endmethod.       "Completion_abapdoc

* ----------------------------------------------------------------------
  method Completion_interface_type.

    data: context type ref to lcl_completion_context,
          result  type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = '/cadaxo/cl_sqlc_abap_parser'
        kind     = 'K'
    ).
    context->set_include( inclname = 'cl_abap_parser================CCIMP' ).
    context->add( 'interface lif_adt_tools_core_types.' ).
    context->add( '  types:' ).
    context->add( '    "! Main admin data of object' ).
    context->add( '    begin of ty_main_object,' ).
    context->add( '      "! object name' ).
    context->add( '      name type progname,' ).
    context->add( '      "! object key' ).
    context->add( '      key  type tadir, " package key' ).
    context->add( '    end of ty_main_object.' ).
    context->add( 'endinterface.' ).
    context->add( `"! Interface with long name     ` ).
    context->add( `"! and long "ABAP Doc"     ` ).
    context->add( 'interface lif_my_interface_with_long_nam.' ).
    context->add( `  "! Simple Type in Interface     ` ).
    context->add( '  types: int_type type p length 15 decimals 2.' ).
    context->add( '  types:' ).
    context->add( '    "! Entry point for Proxy data' ).
    context->add( '    begin of proxy_root.' ).
    context->add( '      include type lif_adt_tools_core_types=>ty_main_object as main_object. "REPOSRC standard data' ).
    context->add( '      types:' ).
    context->add( '        db_package   type char30,   " proc in repository: package' ).
    context->add( '        "! Name of Proc' ).
    context->add( '        db_proc_name type char30,   " proc in repository: name' ).
    context->add( '        read_only    type abap_bool," proc is read-only' ).
    context->add( '        "! List of data objects parameter' ).
    context->add( '        parameters type standard table of lif_adt_tools_core_types=>ty_main_object."be careful' ).
    context->add( '    types: end of proxy_root .' ).
    context->add( '  class-data:' ).
    context->add( '    "! User settings' ).
    context->add( '    begin of user_setting.' ).
    context->add( '      include type /cadaxo/cl_sqlc_abap_parser=>t_user_settings. " Standard user settings' ).
    context->add( '      class-data:' ).
    context->add( '        "! DB Name in upper case' ).
    context->add( '        db_name_upper type abap_bool,   " e.g. proc in repository' ).
    context->add( '        "! DB Component in upper case' ).
    context->add( '        db_comp_upper type abap_bool.   " e.g. row in repository' ).
    context->add( '        "! End of structure' ).
    context->add( '  class-data: end of user_setting.' ).
    context->add( 'endinterface.' ).
    context->add( 'class lcl_class_impl_interface definition.' ).
    context->add( '  protected section.' ).
    context->add( `  "! Type in      ` ).
    context->add( `  "! Class     ` ).
    context->add( '    types: class_type type lif_my_interface_with_long_nam=>int_type.' ).
    context->add( '    data attr1 type class_type.' ).

    result = lcl_completion_result=>create( ).
    result->add(
      exporting
        name = 'CLASS_TYPE'
        kind = sccmp_cat_type
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `data attr2 type class_`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'lif_my_interface_with_long_nam=>int_type'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'CLASS_TYPE'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   add properties of CLASS_TYPE
    components->checks = value #(
                           ( path = `visibility` value = `protected` )
                           ( path = `member_kind` value = `class` )
                           ( path = `abapdoc` value = `Type in Class` )
                           ( path = `type` value = `lif_my_interface_with_long_nam=>int_type` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'CLASS_TYPE'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   test with interface type directly
    result->clear( ).
    result->add(
      exporting
        name = 'INT_TYPE'
        kind = sccmp_cat_type
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `data attr2 type lif_my_interface_with_long_nam=>`
        positive = result
    ).

*   check components in quick info
    COMPONENTS->clear( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'p length 15 decimals 2'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'INT_TYPE'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   add properties of CLASS_TYPE
    components->checks = value #(
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `class` )
                           ( path = `abapdoc` value = `Simple Type in Interface` )
                           ( path = `type` value = `p length 15 decimals 2` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'INT_TYPE'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   test with interface structure type
    result->clear( ).
    result->add(
      exporting
        name = 'PROXY_ROOT'
        kind = sccmp_cat_type
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `data attr2 type lif_my_interface_with_long_nam=>`
        positive = result
    ).

*   check components in quick info
    COMPONENTS->clear( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'name'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'key'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'db_package'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'db_proc_name'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'parameters'
        KIND = sccmp_cat_field
    ).

    context->check_quickinfo(
      exporting
        objname  = 'PROXY_ROOT'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   add properties of CLASS_TYPE
    components->checks = value #(
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `class` )
                           ( path = `abapdoc` value = `Entry point for Proxy data` )
                           ( path = `type` value = `PROXY_ROOT` )
                           ( path = `da:name\type` value = `progname` )
                           ( path = `da:name\abapdoc` value = `object name` )
                           ( path = `da:key\type` value = `tadir` )
                           ( path = `da:key\abapdoc` value = `object key` )
                           ( path = `da:db_package\type` value = `char30` )
                           ( path = `da:db_package\is_type` value = `c length 30` )
                           ( path = `da:db_package\abapdoc` value = `` )
                           ( path = `da:db_proc_name\type` value = `char30` )
                           ( path = `da:db_proc_name\is_type` value = `c length 30` )
                           ( path = `da:db_proc_name\abapdoc` value = `Name of Proc` )
                           ( path = `da:read_only\type` value = `abap_bool` )
                           ( path = `da:read_only\is_type` value = `c length 1` )
                           ( path = `da:read_only\abapdoc` value = `` )
                           ( path = `da:parameters\type` value = `standard table of lif_adt_tools_core_types=>ty_main_object` )
                           ( path = `da:parameters\abapdoc` value = `List of data objects parameter` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'PROXY_ROOT'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   test with interface structure attribute
    result->clear( ).
    result->add(
      exporting
        name = 'USER_SETTING'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `data attr2 like lif_my_interface_with_long_nam=>`
        positive = result
    ).

*   check components in quick info
    COMPONENTS->clear( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'user_setting'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'USER_SETTING'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of USER_SETTING
    components->checks = value #(
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `class` )
                           ( path = `datakind` value = `variable` )
                           ( path = `abapdoc` value = `User settings` )
                           ( path = `type` value = `USER_SETTING` )
                           ( path = `da:keywords_lower_case\type` value = `abap_bool` )
                           ( path = `da:keywords_lower_case\is_type` value = `c length 1` )
                           ( path = `da:keywords_lower_case\abapdoc` value = `` )
                           ( path = `da:identifier_lower_case\type` value = `abap_bool` )
                           ( path = `da:identifier_lower_case\is_type` value = `c length 1` )
                           ( path = `da:identifier_lower_case\abapdoc` value = `` )
                           ( path = `da:meth_func_call\type` value = `abap_bool` )
                           ( path = `da:meth_func_call\is_type` value = `c length 1` )
                           ( path = `da:meth_func_call\abapdoc` value = `` )
                           ( path = `da:db_name_upper\type` value = `abap_bool` )
                           ( path = `da:db_name_upper\is_type` value = `c length 1` )
                           ( path = `da:db_name_upper\abapdoc` value = `DB Name in upper case` )
                           ( path = `da:db_comp_upper\type` value = `abap_bool` )
                           ( path = `da:db_comp_upper\is_type` value = `c length 1` )
                           ( path = `da:db_comp_upper\abapdoc` value = `DB Component in upper case` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'USER_SETTING'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

  endmethod.       "Completion_interface_type

* ----------------------------------------------------------------------
  method Completion_range_type.

    data: context type ref to lcl_completion_context,
          result  type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = '/cadaxo/cl_sqlc_abap_parser'
        kind     = 'K'
    ).
    context->set_include( inclname = 'cl_abap_parser================CCIMP' ).
    context->add( '"! Range types' ).
    context->add( 'interface lif_adt_tools_core_types.' ).
    context->add( '  types:' ).
    context->add( '    "! Main admin data of object' ).
    context->add( '    begin of ty_main_object,' ).
    context->add( '      "! object name' ).
    context->add( '      name type progname,' ).
    context->add( '      "! object key' ).
    context->add( '      key  type tadir, " package key' ).
    context->add( '    end of ty_main_object.' ).
    context->add( '  class-data:' ).
    context->add( '    "! User settings' ).
    context->add( '    user_settings type /cadaxo/cl_sqlc_abap_parser=>t_user_settings. " Standard user settings' ).
    context->add( '  types:' ).
    context->add( '    "! Range type 1' ).
    context->add( '    range_type_1 type range of ty_main_object,' ).
    context->add( '    "! Range type 2' ).
    context->add( '    range_type_2 type range of progname,' ).
    context->add( '    "! Range type 3' ).
    context->add( '    range_type_3 like range of user_settings.' ).
    context->add( 'endinterface.' ).
    context->add( 'class lcl_class_impl_interface definition.' ).
    context->add( '  public section.' ).
    context->add( '    interfaces lif_adt_tools_core_types.' ).
    context->add( '  protected section.' ).
    context->add( '    methods dummy.' ).
    context->add( `    "! Range 1 in      ` ).
    context->add( `    "! class     ` ).
    context->add( '    data range1 type range of lif_adt_tools_core_types~ty_main_object.' ).
    context->add( `    "! Range 2 in class     ` ).
    context->add( '    data range2 like range of lif_adt_tools_core_types~user_settings.' ).
    context->add( `    "! Range 3 in class     ` ).
    context->add( '    data range3 like range of lif_adt_tools_core_types~user_settings with header line.' ).
    context->add( '  private section.' ).
    context->add( `    "! Range 4 in class     ` ).
    context->add( '    data range4 type range of lif_adt_tools_core_types~ty_main_object initial size 13.' ).
    context->add( `    "! Range 5 in class     ` ).
    context->add( '    constants range5 type range of progname value is initial.' ).
    context->add( `    "! Range 6 in class     ` ).
    context->add( '    constants range6 like range of lif_adt_tools_core_types~user_settings value is initial.' ).
    context->add( 'endclass.' ).
    context->add( 'class lcl_class_impl_interface implementation.' ).
    context->add( 'method dummy.' ).
    context->add( `  "! Range 7 in method     ` ).
    context->add( '  ranges range7 for lif_adt_tools_core_types~user_settings occurs 7.' ).
    context->add( `  "! Range 8 in method     ` ).
    context->add( '  field-symbols <range8> like me->range6.' ).

    result = lcl_completion_result=>create( ).
    result->add_multiple(
      exporting
        prefix = 'range_type_'
        number = 3
        kind   = sccmp_cat_type
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `data local type lif_adt_tools_core_types~ra`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = '/cadaxo/cl_sqlc_abap_parser=>t_user_settings'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'range_type_3'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   add properties of RANGE_TYPE_1
    components->checks = value #(
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `class` )
                           ( path = `abapdoc` value = `Range type 1` )
                           ( path = `typekind` value = `Table` )
                           ( path = `type` value = `range of ty_main_object` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range_type_1'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   add properties of RANGE_TYPE_2
    components->checks = value #(
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `class` )
                           ( path = `abapdoc` value = `Range type 2` )
                           ( path = `typekind` value = `Table` )
                           ( path = `type` value = `range of progname` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range_type_2'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   add properties of RANGE_TYPE_3
    components->checks = value #(
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `class` )
                           ( path = `abapdoc` value = `Range type 3` )
                           ( path = `typekind` value = `Table` )
                           ( path = `type` value = `range of /cadaxo/cl_sqlc_abap_parser=>t_user_settings` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range_type_3'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   check range tables
    result->clear( ).
    result->add_multiple(
      exporting
        prefix = 'range'
        number = 7
        kind   = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `if a in ra`
        positive = result
    ).

*   check components in quick info
    COMPONENTS->clear( ).
    COMPONENTS->ADD(
      exporting
        NAME = '/cadaxo/cl_sqlc_abap_parser=>t_user_settings'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'range7'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of RANGE1
    components->checks = value #(
                           ( path = `visibility` value = `protected` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `abapdoc` value = `Range 1 in class` )
                           ( path = `datakind` value = `variable` )
                           ( path = `type` value = `range of lif_adt_tools_core_types=>ty_main_object` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range1'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of RANGE2
    components->checks = value #(
                           ( path = `visibility` value = `protected` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `abapdoc` value = `Range 2 in class` )
                           ( path = `datakind` value = `variable` )
                           ( path = `type` value = `range of /cadaxo/cl_sqlc_abap_parser=>t_user_settings` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range2'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of RANGE3
    components->checks = value #(
                           ( path = `visibility` value = `protected` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `abapdoc` value = `Range 3 in class` )
                           ( path = `datakind` value = `variable` )
                           ( path = `type` value = `range of /cadaxo/cl_sqlc_abap_parser=>t_user_settings with header line` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range3'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of RANGE4
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `abapdoc` value = `Range 4 in class` )
                           ( path = `datakind` value = `variable` )
                           ( path = `type` value = `range of lif_adt_tools_core_types=>ty_main_object` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range4'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of RANGE5
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `class` )
                           ( path = `abapdoc` value = `Range 5 in class` )
                           ( path = `datakind` value = `constant` )
                           ( path = `type` value = `range of progname` )
                           ( path = `value` value = `is initial` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range5'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of RANGE6
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `class` )
                           ( path = `abapdoc` value = `Range 6 in class` )
                           ( path = `datakind` value = `constant` )
                           ( path = `type` value = `range of /cadaxo/cl_sqlc_abap_parser=>t_user_settings` )
                           ( path = `value` value = `is initial` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range6'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of RANGE7
    components->checks = value #(
                           ( path = `visibility` value = `` )
                           ( path = `member_kind` value = `` )
                           ( path = `abapdoc` value = `Range 7 in method` )
                           ( path = `datakind` value = `variable` )
                           ( path = `type` value = `range of /cadaxo/cl_sqlc_abap_parser=>t_user_settings with header line` )
                           ( path = `value` value = `` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'range7'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   check range tables as field-symbol
    result->clear( ).
    result->add(
      exporting
        name   = '<range8>'
        kind   = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `if a in <ra`
        positive = result
    ).

*   check components in quick info
    COMPONENTS->clear( ).
    COMPONENTS->ADD(
      exporting
        NAME = '/cadaxo/cl_sqlc_abap_parser=>t_user_settings'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = '<range8>'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of <RANGE8>
    components->checks = value #(
                           ( path = `visibility` value = `` )
                           ( path = `member_kind` value = `` )
                           ( path = `abapdoc` value = `Range 8 in method` )
                           ( path = `datakind` value = `fieldsymbol` )
                           ( path = `type` value = `range of /cadaxo/cl_sqlc_abap_parser=>t_user_settings` )
                           ( path = `value` value = `` )
                         ).

    context->check_element_info(
      exporting
        objname  = '<range8>'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

  endmethod.       "Completion_range_type

* ----------------------------------------------------------------------
  method Completion_ddicstructure.

    data: context    type ref to lcl_completion_context,
          result     type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = 'RSSHOWRABAX'
        kind     = '1'
    ).
    context->set_include( inclname = 'RSSHOWRABAX_FORMS' ).
    context->add( 'form sel_initialization.' ).
    context->add( 'data flights type STANDARD TABLE OF sflight.' ).
    context->add( 'select * from sflight.' ).

    result = lcl_completion_result=>create( ).
    result->add(
      EXPORTING
        name = 'sflight_t'
        kind = sccmp_cat_type
    ).
    result->add(
      EXPORTING
        name = 'sflights'
        kind = sccmp_cat_type
    ).
    result->add(
      EXPORTING
        name = 'sflight_light'
        kind = sccmp_cat_type
    ).
    result->add(
      EXPORTING
        name = 'sflight'
        kind = sccmp_cat_type
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `select * from sflight`
        positive = result
    ).

*   add properties of SFLIGHT
    COMPONENTS = lcl_completion_result=>create( ).
    components->checks = value #(
                           ( path = `typekind` value = `structure` )
                           ( path = `visibility` value = `` )
                           ( path = `member_kind` value = `` )
                           ( path = `da:MANDT\type` value = `S_MANDT` )
                           ( path = `da:MANDT\is_type` value = `C LENGTH 3` )
                           ( path = `da:CARRID\type` value = `S_CARR_ID` )
                           ( path = `da:CARRID\is_type` value = `C LENGTH 3` )
                           ( path = `da:CONNID\type` value = `S_CONN_ID` )
                           ( path = `da:CONNID\is_type` value = `N LENGTH 4` )
                           ( path = `da:FLDATE\type` value = `S_DATE` )
                           ( path = `da:FLDATE\is_type` value = `D` )
                           ( path = `da:PRICE\type` value = `S_PRICE` )
                           ( path = `da:PRICE\is_type` value = `P LENGTH 8 DECIMALS 2` )
                           ( path = `da:CURRENCY\type` value = `S_CURRCODE` )
                           ( path = `da:CURRENCY\is_type` value = `C LENGTH 5` )
                           ( path = `da:PLANETYPE\type` value = `S_PLANETYE` )
                           ( path = `da:PLANETYPE\is_type` value = `C LENGTH 10` )
                           ( path = `da:SEATSMAX\type` value = `S_SEATSMAX` )
                           ( path = `da:SEATSMAX\is_type` value = `I` )
                           ( path = `da:SEATSOCC\type` value = `S_SEATSOCC` )
                           ( path = `da:SEATSOCC\is_type` value = `I` )
                           ( path = `da:PAYMENTSUM\type` value = `S_SUM` )
                           ( path = `da:PAYMENTSUM\is_type` value = `P LENGTH 9 DECIMALS 2` )
                           ( path = `da:SEATSMAX_B\type` value = `S_SMAX_B` )
                           ( path = `da:SEATSMAX_B\is_type` value = `I` )
                           ( path = `da:SEATSOCC_B\type` value = `S_SOCC_B` )
                           ( path = `da:SEATSOCC_B\is_type` value = `I` )
                           ( path = `da:SEATSMAX_F\type` value = `S_SMAX_F` )
                           ( path = `da:SEATSMAX_F\is_type` value = `I` )
                           ( path = `da:SEATSOCC_F\type` value = `S_SOCC_F` )
                           ( path = `da:SEATSOCC_F\is_type` value = `I` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'SFLIGHT'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

*   check components in quick info
    COMPONENTS->ADD(
      exporting
        NAME = 'MANDT'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'CARRID'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'CONNID'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'FLDATE'
        KIND = sccmp_cat_field
    ).

    context->check_quickinfo(
      exporting
        objname  = 'SFLIGHT'
        objkind  = sccmp_cat_type
        positive = COMPONENTS
    ).

  endmethod.       "Completion_ddicstructure.

* ----------------------------------------------------------------------
  method Completion_itabs.

    data: context    type ref to lcl_completion_context,
          pos_result type ref to lcl_completion_result,
          neg_result type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = '/cadaxo/cl_sqlc_abap_parser'
        kind     = 'K'
    ).
    context->set_include( methname = 'CALCULATE_INSERTION_RESULT' ).
    context->add( 'METHOD calculate_insertion_result.' ).
    context->add( 'data compl_textline type string.' ).

    pos_result = lcl_completion_result=>create( ).
    pos_result->add(
      EXPORTING
        name = 'compl_text'
        kind = sccmp_cat_field
    ).

    neg_result = lcl_completion_result=>create( ).
    neg_result->add(
      EXPORTING
        name = 'compl_textline'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `LOOP AT compl`
        positive = pos_result
        negative = neg_result
        numrechk = 2
    ).

*   add properties of COMPL_TEXT
    COMPONENTS = lcl_completion_result=>create( ).
    components->checks = value #(
                           ( path = `datakind` value = `parameter` )
                           ( path = `paramkind` value = `exporting` )
                           ( path = `byvalue` value = `false` )
                           ( path = `type` value = `RSWSOURCET` )
                           ( path = `is_type` value = `standard table of string` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'COMPL_TEXT'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   call completion with APPPEND
    context->check_completion(
      exporting
        line     = `append compl_textline to c`
        positive = pos_result
        negative = neg_result
        numrechk = 2
    ).

    context->set_include( methname = 'GET_TYPING_TEXT' ).
    context->add( clear = abap_true line = 'METHOD GET_TYPING_TEXT.' ).
    context->add( 'data p_detail type string.' ).

    pos_result = lcl_completion_result=>create( ).
    pos_result->add(
      EXPORTING
        name = 'p_details'
        kind = sccmp_cat_field
    ).

    neg_result = lcl_completion_result=>create( ).
    neg_result->add(
      EXPORTING
        name = 'p_detail'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `LOOP AT p_de`
        positive = pos_result
        negative = neg_result
        numrechk = 2
    ).

*   add properties of P_DETAILS
    COMPONENTS = lcl_completion_result=>create( ).
    components->checks = value #(
                           ( path = `datakind` value = `parameter` )
                           ( path = `paramkind` value = `importing` )
                           ( path = `byvalue` value = `false` )
                           ( path = `type` value = `scc_detailed_completions` )
                           ( path = `is_type` value = `standard table of SCC_DETAILED_COMPLETION` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'P_DETAILS'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   check filter for write-protected parameters
    neg_result->add(
      EXPORTING
        name = 'p_details'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `append p_detail to p_de`
        negative = neg_result
        numrechk = 2
    ).

  endmethod.       "Completion_itabs

* ----------------------------------------------------------------------
  method Completion_intf_method_abapdoc.

    data: context    type ref to lcl_completion_context,
          result     type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = '/cadaxo/cl_sqlc_abap_parser'
        kind     = 'K'
    ).
    context->set_include( inclname = 'cl_abap_parser================CCIMP' ).
    context->add( 'class dummy definition create private.' ).
    context->add( 'public section.' ).
    context->add( 'interfaces IF_ABAP_CONTEXT_PROVIDER.' ).
    context->add( 'protected section.' ).
    context->add( 'private section. " disturb abap doc' ).
    context->add( 'endclass.' ).
    context->add( 'class dummy implementation.' ).

*   check completion result
    result = lcl_completion_result=>create( ).
    result->add(
      EXPORTING
        name = 'GET_CONTEXT'
        kind = sccmp_cat_method
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `method IF_ABAP_CONTEXT_PROVIDER~`
        positive = result
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'INCLUDENAME'
        KIND = sccmp_cat_field
    ).
    COMPONENTS->ADD(
      exporting
        NAME = 'CONTEXTSOURCE'
        KIND = sccmp_cat_field
    ).

    context->check_quickinfo(
      exporting
        objname  = 'GET_CONTEXT'
        objkind  = sccmp_cat_method
        positive = COMPONENTS
    ).

*   add properties of GET_CONTEXT
    components->checks = value #(
                           ( path = `visibility` value = `public` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `abapdoc` value = `Get source code to provide context of code snippets` )
                           ( path = `da:INCLUDENAME\paramkind` value = `exporting` )
                           ( path = `da:INCLUDENAME\byvalue` value = `false` )
                           ( path = `da:INCLUDENAME\abapdoc` value = `Name of include to be substituted` )
                           ( path = `da:INCLUDENAME\type`  value = `SYREPID` )
                           ( path = `da:INCLUDENAME\is_type`  value = `c length 40` )
                           ( path = `da:CONTEXTSOURCE\paramkind` value = `exporting` )
                           ( path = `da:CONTEXTSOURCE\byvalue` value = `false` )
                           ( path = `da:CONTEXTSOURCE\abapdoc` value = `Content of generated context` )
                           ( path = `da:CONTEXTSOURCE\type`  value = `SOURCETABLE` )
                           ( path = `da:CONTEXTSOURCE\is_type`  value = `STANDARD TABLE OF STRING` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'GET_CONTEXT'
        objkind  = sccmp_cat_method
        positive = COMPONENTS
    ).

  endmethod.       "Completion_intf_method_abapdoc

* ----------------------------------------------------------------------
  method Completion_data_reference.

    data: context    type ref to lcl_completion_context,
          result     type ref to lcl_completion_result,
          negresult  type ref to lcl_completion_result,
          components type ref to Lcl_Completion_Result.

    context = lcl_completion_context=>create(
        name     = '/cadaxo/cl_sqlc_abap_parser'
        kind     = 'K'
    ).
    context->set_include( inclname = 'cl_abap_parser================CCIMP' ).
    context->add( 'class dummy definition create private.' ).
    context->add( 'public section.' ).
    context->add( 'protected section.' ).
    context->add( '  types: begin of structype,' ).
    context->add( '           comp1 type ref to data,' ).
    context->add( '           comp2 type ref to i,' ).
    context->add( '           comp3 type ref to char80,' ).
    context->add( '           comp4 type ref to /cadaxo/cl_sqlc_abap_parser=>t_user_settings,' ).
    context->add( '         end   of structype.' ).
    context->add( 'private section.' ).
    context->add( '  types: datareftype   type ref to data.' ).
    context->add( '  types: ireftype      type ref to i.' ).
    context->add( '  types: char80reftype type ref to char80.' ).
    context->add( '  types: classreftype  type ref to /cadaxo/cl_sqlc_abap_parser=>t_user_settings.' ).
    context->add( '  data: myint type i,' ).
    context->add( '        myref1 type datareftype,' ).
    context->add( '        myref2 type ireftype,' ).
    context->add( '        myref3 type char80reftype,' ).
    context->add( '        myref4 type classreftype,' ).
    context->add( '        myref5 type structype-comp1,' ).
    context->add( '        myref6 type structype-comp2,' ).
    context->add( '        myref7 type structype-comp3,' ).
    context->add( '        myref8 type structype-comp4.' ).
    context->add( '  methods mymeth.' ).
    context->add( 'endclass.' ).
    context->add( 'class dummy implementation.' ).
    context->add( '  method mymeth.' ).

*   check completion result
    result = lcl_completion_result=>create( ).
    result->add_multiple(
      EXPORTING
        prefix = 'MYREF'
        number = 8
        kind = sccmp_cat_field
    ).

    negresult = lcl_completion_result=>create( ).
    negresult->add(
      EXPORTING
        name = 'MYINT'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `get reference of myint into my`
        positive = result
        negative = negresult
    ).

*   check components in quick info
    COMPONENTS = lcl_completion_result=>create( ).
    COMPONENTS->ADD(
      exporting
        NAME = 'DATAREFTYPE'
        KIND = sccmp_cat_type
    ).

    context->check_quickinfo(
      exporting
        objname  = 'MYREF1'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of MYREF1
    components->checks = value #(
                           ( path = `visibility` value = `private` )
                           ( path = `member_kind` value = `instance` )
                           ( path = `type`  value = `DATAREFTYPE` )
                           ( path = `is_type`  value = `REF TO DATA` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'MYREF1'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of MYREF2
    components->checks = value #(
                           ( path = `type`  value = `IREFTYPE` )
                           ( path = `is_type`  value = `REF TO I` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'MYREF2'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of MYREF3
    components->checks = value #(
                           ( path = `type`  value = `CHAR80REFTYPE` )
                           ( path = `is_type`  value = `REF TO CHAR80` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'MYREF3'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of MYREF4
    components->checks = value #(
                           ( path = `type`  value = `CLASSREFTYPE` )
                           ( path = `is_type`  value = `REF TO /cadaxo/cl_sqlc_abap_parser=>t_user_settings` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'MYREF4'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of MYREF5
    components->checks = value #(
*                          structure type components are handled as fields with anonymous ref types
*                           ( path = `type`  value = `STRUCTTYPE-COMP1` )
                           ( path = `type`  value = `REF TO DATA` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'MYREF5'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of MYREF6
    components->checks = value #(
*                          structure type components are handled as fields with anonymous ref types
*                           ( path = `type`  value = `STRUCTTYPE-COMP1` )
                           ( path = `type`  value = `REF TO I` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'MYREF6'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of MYREF7
    components->checks = value #(
*                          structure type components are handled as fields with anonymous ref types
*                           ( path = `type`  value = `STRUCTTYPE-COMP3` )
                           ( path = `type`  value = `REF TO CHAR80` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'MYREF7'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

*   add properties of MYREF8
    components->checks = value #(
*                          structure type components are handled as fields with anonymous ref types
*                           ( path = `type`  value = `STRUCTTYPE-COMP4` )
                           ( path = `type`  value = `REF TO /cadaxo/cl_sqlc_abap_parser=>t_user_settings` )
                         ).

    context->check_element_info(
      exporting
        objname  = 'MYREF8'
        objkind  = sccmp_cat_field
        positive = COMPONENTS
    ).

  endmethod.       "Completion_data_reference

* ----------------------------------------------------------------------
  method Completion_function_arguments.

    data: context type ref to lcl_completion_context,
          result  type ref to lcl_completion_result,
          kinds   type Lcl_Completion_Result=>ty_kinds,
          kind    like line of kinds.

    context = lcl_completion_context=>create(
        name     = '/cadaxo/cl_sqlc_abap_parser'
        kind     = 'K'
    ).
    context->set_include( inclname = 'cl_abap_parser================CCIMP' ).
    context->add( 'class lcl definition.' ).
    context->add( 'public section.' ).
    context->add( 'types:' ).
    context->add( '  ty_t_string type standard table of string with non-unique key table_line.' ).
    context->add( 'types:' ).
    context->add( '  begin of ty_s_foo,' ).
    context->add( '    value_c type c,' ).
    context->add( '    value_i type i,' ).
    context->add( '    value_s type string,' ).
    context->add( '    anton type ty_t_string,' ).
    context->add( '    berta type ty_t_string,' ).
    context->add( '    caesar type ty_t_string,' ).
    context->add( '  end of ty_s_foo.' ).
    context->add( '  data:' ).
    context->add( '    m_values type ty_s_foo,' ).
    context->add( '    m_bla type string,' ).
    context->add( '    m_foo type standard table of string.' ).
    context->add( '  methods:' ).
    context->add( '    bla returning value(result) type abap_bool.' ).
    context->add( 'endclass.' ).
    context->add( 'class lcl implementation.' ).
    context->add( '  method bla.' ).
    context->add( '    data(foo) = new lcl( ).' ).

    result = lcl_completion_result=>create( ).
    result->add(
      EXPORTING
        name = 'M_VALUES'
        kind = sccmp_cat_field
    ).
    result = lcl_completion_result=>create( ).
    result->add(
      EXPORTING
        name = 'M_BLA'
        kind = sccmp_cat_field
    ).
    result = lcl_completion_result=>create( ).
    result->add(
      EXPORTING
        name = 'M_FOO'
        kind = sccmp_cat_field
    ).

*   call completion
    context->check_completion(
      exporting
        line     = `result = boolc( m_foo[ 1 ] = m_`
        positive = result
    ).
    context->check_completion(
      exporting
        line     = `result = boolc( lines( m_`
        positive = result
    ).
    context->check_completion(
      exporting
        line     = `result = boolc( foo->m_values-anton = foo->m_`
        positive = result
    ).
    context->check_completion(
      exporting
        line     = `data(a) = lines( foo->m_`
        positive = result
    ).
    context->check_completion(
      exporting
        line     = `data(a) = abs( foo->m_`
        positive = result
    ).
    context->check_completion(
      exporting
        line     = `result = boolc( line_exists( foo->m_`
        positive = result
    ).
    context->check_completion(
      exporting
        line     = `data(a) = condense( foo->m_`
        positive = result
    ).
    context->check_completion(
      exporting
        line     = `data(a) = boolx( bool = foo->m_`
        positive = result
    ).

  endmethod.       "Completion_function_arguments

* ----------------------------------------------------------------------
  method Completion_function_parameters.

    data: context    type ref to lcl_completion_context,
          pos_result type ref to lcl_completion_result,
          neg_result type ref to lcl_completion_result.

    context = lcl_completion_context=>create(
        name     = 'SAPLST22_TOOLS'
        kind     = lif_progtype=>functiongroup
    ).
    context->set_include( funcname = 'RS_ST22_GET_DUMPS' ).
    context->add( 'types abapty1 type n length 3.').
    context->add( 'types: begin of abapte1,').
    context->add( '         line type char80.').
    context->add( '       end of abapte1.').

*   check access to DDIC types (data elements, structure etc.)
    pos_result = lcl_completion_result=>create( ).
    pos_result->add(
      exporting
        name = 'abaptype'
        kind = sccmp_cat_type
    ).

    neg_result = lcl_completion_result=>create( ).
    neg_result->add(
      exporting
        name = 'abapty1'
        kind = sccmp_cat_type
    ).
    neg_result->add(
      exporting
        name = 'abapte1'
        kind = sccmp_cat_type
    ).

    context->check_completion(
      exporting
        line = |FUNCTION RS_ST22_GET_DUMPS| &
               |  IMPORTING| &
               |    VALUE(P_DAY) TYPE D OPTIONAL| &
               |    VALUE(CORRNR) TYPE TRKORR OPTIONAL| &
               |    VALUE(DEVCLASS) TYPE DEVCLASS DEFAULT '$TMP'| &
               |    VALUE(datatype) type abapty|
        positive = pos_result
        negative = neg_result
    ).

    context->check_completion(
      exporting
        line = |FUNCTION RS_ST22_GET_DUMPS| &
               |  IMPORTING| &
               |    VALUE(P_DAY) TYPE D OPTIONAL| &
               |    VALUE(CORRNR) TYPE TRKORR OPTIONAL| &
               |    VALUE(DEVCLASS) TYPE DEVCLASS DEFAULT '$TMP'| &
               |    VALUE(datatype) type abaptype| &
               |    typeref type ref to abapty|
        positive = pos_result
        negative = neg_result
    ).

    context->check_completion(
      exporting
        line = |FUNCTION RS_ST22_GET_DUMPS| &
               |  IMPORTING| &
               |    VALUE(P_DAY) TYPE D OPTIONAL| &
               |    VALUE(CORRNR) TYPE TRKORR OPTIONAL| &
               |    VALUE(DEVCLASS) TYPE DEVCLASS DEFAULT '$TMP'| &
               |  EXPORTING| &
               |    VALUE(datatype) type abapty|
        positive = pos_result
        negative = neg_result
    ).

    context->check_completion(
      exporting
        line = |FUNCTION RS_ST22_GET_DUMPS| &
               |  IMPORTING| &
               |    VALUE(P_DAY) TYPE D OPTIONAL| &
               |    VALUE(CORRNR) TYPE TRKORR OPTIONAL| &
               |    VALUE(DEVCLASS) TYPE DEVCLASS DEFAULT '$TMP'| &
               |  EXPORTING| &
               |    VALUE(datatype) type abaptype| &
               |  CHANGING| &
               |    VALUE(newdatatype) type abapty|
        positive = pos_result
        negative = neg_result
    ).

    pos_result->clear( ).
    pos_result->add(
      exporting
        name = 'abaptext'
        kind = sccmp_cat_type
    ).

    context->check_completion(
      exporting
        line = |FUNCTION RS_ST22_GET_DUMPS| &
               |  IMPORTING| &
               |    VALUE(P_DAY) TYPE D OPTIONAL| &
               |    VALUE(CORRNR) TYPE TRKORR OPTIONAL| &
               |    VALUE(DEVCLASS) TYPE DEVCLASS DEFAULT '$TMP'| &
               |  EXPORTING| &
               |    VALUE(datatype) type abaptype| &
               |  TABLES| &
               |    inout like abapte|
        positive = pos_result
        negative = neg_result
    ).

  endmethod.       "Completion_function_parameters

endclass.       "Lcl_Completion_Test


*--------------------------------------------------------------------*
class lcl_element_info_serializer implementation.
  method convert.
    if element_info is not initial.
      case element_info->kind.
        when sccmp_cat_method.
          result = convert_method( cast CL_ABAP_CC_METHOD( element_info ) ).
        when sccmp_cat_field.
          result = convert_field( cast cl_abap_cc_data( element_info ) ).
        when sccmp_cat_type.
          result = convert_type( cast cl_abap_cc_type( element_info ) ).
        when sccmp_cat_event.
          result = convert_event( cast CL_ABAP_CC_event( element_info ) ).
        when sccmp_cat_form.
          result = convert_form( cast CL_ABAP_CC_form( element_info ) ).
        when sccmp_cat_function.
          result = convert_function( cast CL_ABAP_CC_function( element_info ) ).
        when sccmp_cat_exception.
          result = convert_exception( cast CL_ABAP_CC_exception( element_info ) ).
      endcase.
    endif.
  endmethod.

  method bool_as_text.
    case bool.
      when sccmp_false.
        result = `false`.
      when sccmp_true.
        result = `true`.
    ENDCASE.
  endmethod.

  method kind_as_text.
    case kind.
      when sccmp_cat_field.
        result = `DA:`.
      when sccmp_cat_type.
        result = `TY:`.
      when sccmp_cat_method.
        result = `ME:`.
      when sccmp_cat_event.
        result = `EV:`.
      when sccmp_cat_form .
        result = `FO:`.
      when sccmp_cat_function.
        result = `FU:`.
      when sccmp_cat_exception or sccmp_cat_classexception.
        result = `EX:`.
    endcase.
  endmethod.

  method member_kind_as_text.
    case member_kind.
      when SCCMP_MEMBER_CLASS.
        result = `Class`.
      when SCCMP_MEMBER_INSTANCE.
        result = `Instance`.
    endcase.
  endmethod.

  method visibility_as_text.
    case vis.
      when sccmp_visibility_public.
        result = `Public`.
      when sccmp_visibility_protected.
        result = `Protected`.
      when sccmp_visibility_private.
        result = `Private`.
    endcase.
  endmethod.

  method add_type_as_text.
    data: typetext type string,
          istype   type string.
    typetext = /cadaxo/cl_sqlc_abap_parser=>get_type_info_as_text( exporting type = type usedbydef = entity importing same_as = istype ).
    append value ty_property_entry( name = `TYPE` value = typetext ) to result.
    append value ty_property_entry( name = `IS_TYPE` value = istype ) to result.
  endmethod.

  method add_value_as_text.
    data: valtext type string,
          isval   type string.
    valtext = /cadaxo/cl_sqlc_abap_parser=>get_value_info_as_text( exporting value = value IMPORTING same_as = isval ).
    append value ty_property_entry( name = `VALUE` value = valtext ) to result.
    append value ty_property_entry( name = `IS_VALUE` value = isval ) to result.
  endmethod.

  method typekind_as_text.
    case type_kind.
      when sccmp_type_elementary.
        result = `Elementary`.
      when sccmp_type_alias.
        result = `Alias`.
      when sccmp_type_structure.
        result = `Structure`.
      when sccmp_type_table.
        result = `Table`.
      when sccmp_type_reference.
        result = `Reference`.
      when sccmp_type_objtype.
        result = `Objecttype`.
     endcase.
  endmethod.

  method paramkind_as_text.
    case param_kind.
      when sccmp_par_importing.
        result = `Importing`.
      when sccmp_par_exporting.
        result = `Exporting`.
      when sccmp_par_changing.
        result = `Changing`.
      when sccmp_par_returning.
        result = `Returning`.
      when sccmp_par_using.
        result = `Using`.
      when sccmp_par_tables.
        result = `Tables`.
     endcase.
  endmethod.

  method datakind_as_text.
    case data_kind.
      when SCCMP_DATA_VARIABLE.
        result = `Variable`.
      when SCCMP_DATA_CONSTANT.
        result = `Constant`.
      when SCCMP_DATA_FIELDSYMBOL.
        result = `Fieldsymbol`.
      when SCCMP_DATA_STATIC.
        result = `Static`.
      when SCCMP_DATA_SELPARAM.
        result = `Selectparameter`.
      when SCCMP_DATA_SELOPTION.
        result = `Selectoption`.
      when SCCMP_DATA_TABLE.
        result = `Table`.
      when SCCMP_DATA_PARAMETER.
        result = `Parameter`.
      when SCCMP_DATA_ALIAS.
        result = `Alias`.
    endcase.
  endmethod.

  method get_properties.
    append value ty_property_entry( name = `MEMBER_KIND` value = member_kind_as_text( element_info->member_kind ) ) to result.
    append value ty_property_entry( name = `VISIBILITY` value = visibility_as_text( element_info->visibility ) ) to result.
    append value ty_property_entry( name = `INHERITED` value = bool_as_text( element_info->is_inherited ) ) to result.
    append value ty_property_entry( name = `ABAPDOC` value = element_info->abapdoc ) to result.
    append value ty_property_entry( name = `SHORTTEXT` value = element_info->shorttext ) to result.
    append value ty_property_entry( name = `LONGTEXT` value = element_info->longtext ) to result.
    case element_info->kind.
      when sccmp_cat_field.
        append value ty_property_entry( name = `READONLY` value = bool_as_text( cast CL_ABAP_CC_DATA( element_info )->is_readonly ) ) to result.
        append value ty_property_entry( name = `DATAKIND` value = datakind_as_text( cast CL_ABAP_CC_DATA( element_info )->data_kind ) ) to result.
        add_type_as_text( exporting type = cast CL_ABAP_CC_DATA( element_info )->type entity = cast CL_ABAP_CC_DATA( element_info ) changing result = result ).
        add_value_as_text( exporting value = cast CL_ABAP_CC_DATA( element_info )->value changing result = result ).
        case cast CL_ABAP_CC_DATA( element_info )->data_kind.
          when sccmp_data_parameter.
            append value ty_property_entry( name = `OPTIONAL` value = bool_as_text( cast CL_ABAP_CC_parameter( element_info )->is_optional ) ) to result.
            append value ty_property_entry( name = `BYVALUE` value = bool_as_text( cast CL_ABAP_CC_parameter( element_info )->is_byvalue ) ) to result.
            append value ty_property_entry( name = `PREFERRED` value = bool_as_text( cast CL_ABAP_CC_parameter( element_info )->is_preferred ) ) to result.
            append value ty_property_entry( name = `PARAMKIND` value = paramkind_as_text( cast CL_ABAP_CC_parameter( element_info )->param_kind ) ) to result.
        endcase.
      when sccmp_cat_type.
        append value ty_property_entry( name = `TYPEKIND` value = typekind_as_text( cast CL_ABAP_CC_TYPE( element_info )->type_kind ) ) to result.
        add_type_as_text( exporting type = cast CL_ABAP_CC_TYPE( element_info ) entity = cast CL_ABAP_CC_TYPE( element_info ) changing result = result ).
        case cast CL_ABAP_CC_TYPE( element_info )->type_kind.
          when sccmp_type_elementary.
            data basictype type string.
            basictype = /cadaxo/cl_sqlc_abap_parser=>GET_BASICTYPE_TEXT( cast CL_ABAP_CC_ELEMENTARY_TYPE( element_info )->basic_type ).
            append value ty_property_entry( name = `BASICTYPE` value =  basictype ) to result.
            append value ty_property_entry( name = `LENGTH` value = conv string( cast CL_ABAP_CC_elementary_TYPE( element_info )->length ) ) to result.
            append value ty_property_entry( name = `DECIMALS` value = conv string( cast CL_ABAP_CC_elementary_TYPE( element_info )->decimals ) ) to result.
          when sccmp_type_table.
          when sccmp_type_objtype.
            append value ty_property_entry( name = `CLASS` value = bool_as_text( cast CL_ABAP_CC_object_TYPE( element_info )->is_class ) ) to result.
            append value ty_property_entry( name = `GLOBAL` value = bool_as_text( cast CL_ABAP_CC_object_TYPE( element_info )->is_global ) ) to result.
            append value ty_property_entry( name = `TESTING` value = bool_as_text( cast CL_ABAP_CC_object_TYPE( element_info )->is_for_testing ) ) to result.
            append value ty_property_entry( name = `ABSTRACT` value = bool_as_text( cast CL_ABAP_CC_object_TYPE( element_info )->is_abstract ) ) to result.
            append value ty_property_entry( name = `FINAL` value = bool_as_text( cast CL_ABAP_CC_object_TYPE( element_info )->is_final ) ) to result.
            append value ty_property_entry( name = `EXCPCLASS` value = bool_as_text( cast CL_ABAP_CC_object_TYPE( element_info )->is_exception_class ) ) to result.
         endcase.
      when sccmp_cat_method.
        append value ty_property_entry( name = `RAISING` value = bool_as_text( cast CL_ABAP_CC_Method( element_info )->is_raising ) ) to result.
        append value ty_property_entry( name = `ABSTRACT` value = bool_as_text( cast CL_ABAP_CC_method( element_info )->is_abstract ) ) to result.
        append value ty_property_entry( name = `FINAL` value = bool_as_text( cast CL_ABAP_CC_method( element_info )->is_final ) ) to result.
        append value ty_property_entry( name = `REDEFINED` value = bool_as_text( cast CL_ABAP_CC_method( element_info )->is_redefined ) ) to result.
        append value ty_property_entry( name = `TESTING` value = bool_as_text( cast CL_ABAP_CC_method( element_info )->is_for_testing ) ) to result.
        append value ty_property_entry( name = `EVENTHANDLER` value = bool_as_text( cast CL_ABAP_CC_method( element_info )->is_handler ) ) to result.
      when sccmp_cat_event.
      when sccmp_cat_form .
      when sccmp_cat_function.
      when sccmp_cat_exception or sccmp_cat_classexception.
    endcase.
  endmethod.

  method get_parameters.
    data child type ty_element_info.
    field-symbols <children> type ty_element_info_elements.

    if result-children is initial.
      create data result-children type ty_element_info_elements.
    endif.
    assign result-children->* to <children>.

    loop at params assigning field-symbol(<param>).
      child = convert_field( <param> ).
      append child to <children>.
    endloop.
  endmethod.

  method get_exceptions.
    data child type ty_element_info.
    field-symbols <children> type ty_element_info_elements.

    if result-children is initial.
      create data result-children type ty_element_info_elements.
    endif.
    assign result-children->* to <children>.

    loop at exceps assigning field-symbol(<excep>).
      child = convert_exception( <excep> ).
      append child to <children>.
    endloop.
  endmethod.

  method convert_method.
    result-name = kind_as_text( element_info->kind ) && element_info->identifier.
    result-properties = get_properties( element_info ).
    get_parameters( exporting params = element_info->importing_parameters changing result = result ).
    get_parameters( exporting params = element_info->exporting_parameters changing result = result ).
    get_parameters( exporting params = element_info->changing_parameters changing result = result ).
    if element_info->returning_parameter is not initial.
      data returnings type IF_ABAP_CC_PROPERTIES=>TY_PARAMETERS_SEQ .
      append element_info->returning_parameter to returnings.
      get_parameters( exporting params = returnings changing result = result ).
    endif.
    get_exceptions( exporting exceps = element_info->exception_list changing result = result ).
  endmethod.

  method convert_field.
    result-name = kind_as_text( element_info->kind ) && element_info->identifier.
    result-properties = get_properties( element_info ).

    if element_info->type is not initial and element_info->type->type_kind = sccmp_type_structure.
      data child type ty_element_info.
      field-symbols <children> type ty_element_info_elements.

      if result-children is initial.
        create data result-children type ty_element_info_elements.
      endif.
      assign result-children->* to <children>.

      loop at cast CL_ABAP_CC_structure_TYPE( element_info->type )->components ASSIGNING FIELD-SYMBOL(<comp>).
        child = convert_field( <comp> ).
        append child to <children>.
      endloop.
    endif.
  endmethod.

  method convert_event.
    result-name = kind_as_text( element_info->kind ) && element_info->identifier.
    result-properties = get_properties( element_info ).
    get_parameters( exporting params = element_info->exporting_parameters changing result = result ).
  endmethod.

  method convert_exception.
    result-name = kind_as_text( element_info->kind ) && element_info->identifier.
    result-properties = get_properties( element_info ).
    data child type ty_element_info.
    field-symbols <children> type ty_element_info_elements.

    if result-children is initial.
      create data result-children type ty_element_info_elements.
    endif.
    assign result-children->* to <children>.

    if element_info->classtype is not initial.
      child = convert_type( element_info->classtype ).
      append child to <children>.
    endif.
  endmethod.

  method convert_type.
    result-name = kind_as_text( element_info->kind ) && element_info->identifier.
    result-properties = get_properties( element_info ).

    data child type ty_element_info.
    field-symbols <children> type ty_element_info_elements.

    if result-children is initial.
      create data result-children type ty_element_info_elements.
    endif.
    assign result-children->* to <children>.

    case element_info->type_kind.
      when sccmp_type_alias.
        if cast CL_ABAP_CC_TYPE_ALIAS( element_info )->orgtype is not initial.
          child = convert_type( cast CL_ABAP_CC_TYPE_ALIAS( element_info )->orgtype ).
          append child to <children>.
        endif.
      when sccmp_type_structure.
        loop at cast CL_ABAP_CC_structure_TYPE( element_info )->components ASSIGNING FIELD-SYMBOL(<comp>).
          child = convert_field( <comp> ).
          append child to <children>.
        endloop.
      when sccmp_type_table.
        if cast CL_ABAP_CC_table_TYPE( element_info )->linetype is not initial.
          child = convert_type( cast CL_ABAP_CC_table_TYPE( element_info )->linetype ).
          append child to <children>.
        endif.
      when sccmp_type_reference.
        if cast CL_ABAP_CC_reference_TYPE( element_info )->reftype is not initial.
          child = convert_type( cast CL_ABAP_CC_reference_TYPE( element_info )->reftype ).
          append child to <children>.
        endif.
      when sccmp_type_objtype.
        if cast CL_ABAP_CC_object_TYPE( element_info )->superclass is not initial.
          child = convert_type( cast CL_ABAP_CC_object_TYPE( element_info )->superclass ).
          append child to <children>.
        endif.
        loop at cast CL_ABAP_CC_object_TYPE( element_info )->interfaces ASSIGNING FIELD-SYMBOL(<interface>).
          child = convert( <interface> ).
          append child to <children>.
        endloop.
        loop at cast CL_ABAP_CC_object_TYPE( element_info )->public_members ASSIGNING FIELD-SYMBOL(<member>).
          child = convert( <member> ).
          append child to <children>.
        endloop.
     endcase.

  ENDMETHOD.

  method convert_form.
    result-name = kind_as_text( element_info->kind ) && element_info->identifier.
    result-properties = get_properties( element_info ).
    get_parameters( exporting params = element_info->using_parameters changing result = result ).
    get_parameters( exporting params = element_info->changing_parameters changing result = result ).
    get_parameters( exporting params = element_info->tables_parameters changing result = result ).
    get_exceptions( exporting exceps = element_info->exception_list changing result = result ).
  ENDMETHOD.

  method convert_function.
    result-name = kind_as_text( element_info->kind ) && element_info->identifier.
    result-properties = get_properties( element_info ).
    get_parameters( exporting params = element_info->importing_parameters changing result = result ).
    get_parameters( exporting params = element_info->exporting_parameters changing result = result ).
    get_parameters( exporting params = element_info->changing_parameters changing result = result ).
    get_parameters( exporting params = element_info->tables_parameters changing result = result ).
    get_exceptions( exporting exceps = element_info->exception_list changing result = result ).
  endmethod.

  method get_property_value.
    DATA:
      l_head   TYPE string,
      l_tail   TYPE string.
    field-symbols: <children> type ty_element_info_elements,
                   <child> type ty_element_info,
                   <entry> type ty_property_entry.

    l_tail = to_upper( path ).
    assign info to <child>.
    while l_tail ca '\'.
      SPLIT l_tail AT '\' INTO l_head l_tail.
      if <child>-children is not initial.
        assign <child>-children->* to <children>.
        read table <children> assigning <child> with key name = l_head.
        if sy-subrc <> 0.
          exit.
        endif.
      endif.
    endwhile.
    if <child> is assigned.
      if l_tail is initial.
        result = `TRUE`. " entry found
      else.
        read table <child>-properties assigning <entry> with key name = l_tail.
        if sy-subrc = 0.
          result = to_upper( <entry>-value ).
        endif.
      endif.
    endif.
  endmethod.

endclass.
