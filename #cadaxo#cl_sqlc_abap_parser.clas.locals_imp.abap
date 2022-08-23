*"* use this source file for any type declarations (class
*"* definitions, interfaces or data types) you need for method
*"* implementation or private method's signature

*----------------------------------------------------------------------*
*       CLASS lcl_repository_requests DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_repository_requests DEFINITION FINAL.
* Local class to handle repository requests
  PUBLIC SECTION.
    TYPES: BEGIN OF t_query_properties,
              kind       TYPE scc_kind,
              role       TYPE scc_role,
              pattern    TYPE sobj_name,
              maxitems   TYPE i,
              reqindex   TYPE i,
              prefixlen  TYPE i,
              grade      TYPE i,
              syntcntxt  TYPE i,
           END OF t_query_properties,
           t_query_objects TYPE RANGE OF trobjtype
                           INITIAL SIZE 1.

    CLASS-METHODS: get_repository_result
                    IMPORTING
                     extern_reqs          TYPE scc_repository_requests
                     max_items            type /cadaxo/cl_sqlc_abap_parser=>TT_MAX_ITEMS
                    CHANGING
                     compl_result         TYPE scc_completions,

                    call_f4_help
                     IMPORTING
                      role   TYPE scc_role
                      prefix TYPE scc_identifier
                     EXPORTING
                      result TYPE scc_identifier
                     EXCEPTIONS
                      request_canceled.

  PRIVATE SECTION.
    CLASS-METHODS: query_class_type
                     IMPORTING
                       props     TYPE t_query_properties
                     CHANGING
                       result    TYPE scc_completions,

                   query_interface_type
                     IMPORTING
                       props     TYPE t_query_properties
                     CHANGING
                       result    TYPE scc_completions,

                   query_structure_type
                     IMPORTING
                       props     TYPE t_query_properties
                     CHANGING
                       result    TYPE scc_completions,

                  query_data_element
                     IMPORTING
                       props     TYPE t_query_properties
                     CHANGING
                       result    TYPE scc_completions,

                   query_table_type
                     IMPORTING
                       props     TYPE t_query_properties
                     CHANGING
                       result    TYPE scc_completions,

                   query_function_module
                     IMPORTING
                       props     TYPE t_query_properties
                     CHANGING
                        result   TYPE scc_completions,

                   query_db_procedure
                     IMPORTING
                       props     TYPE t_query_properties
                     CHANGING
                        result   TYPE scc_completions,

                   query_database_table
                     IMPORTING
                       props     TYPE t_query_properties
                     CHANGING
                       result    TYPE scc_completions,

                   query_type
                     IMPORTING
                       props     TYPE t_query_properties
                       objs      TYPE t_query_objects
                     CHANGING
                       result    TYPE scc_completions,

                   add_search_item
                     IMPORTING
                       props     TYPE t_query_properties
                     CHANGING
                       result    TYPE scc_completions.

ENDCLASS.                    "lcl_repository_requests DEFINITION


*----------------------------------------------------------------------*
*       CLASS lcl_short_text DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_short_text DEFINITION FINAL.
* Local class to provide the short text for a source object
  PUBLIC SECTION.
    CLASS-METHODS:
      get_text IMPORTING fullname  TYPE string
               EXPORTING shorttext TYPE scc_shorttext,
      get_sourcetext IMPORTING fullname   TYPE string
                     EXPORTING sourcetext TYPE string.
  PRIVATE SECTION.
    CLASS-METHODS:
      get_objcomp_text  IMPORTING objtype    TYPE scc_identifier
                                  fullname   TYPE string
                        EXPORTING shorttext  TYPE scc_shorttext,
      get_objsubco_text IMPORTING objtype    TYPE scc_identifier
                                  component  TYPE scc_identifier
                                  fullname   TYPE string
                        EXPORTING shorttext  TYPE scc_shorttext,
      get_ddiccomp_text IMPORTING ddicobj    TYPE scc_identifier
                                  fullname   TYPE string
                        EXPORTING shorttext  TYPE scc_shorttext,
      get_function_text IMPORTING funcname   TYPE scc_identifier
                                  fullname   TYPE string
                        EXPORTING shorttext  TYPE scc_shorttext,
      get_dbproc_text   IMPORTING dbprocname TYPE scc_identifier
                                  fullname   TYPE string
                        EXPORTING shorttext  TYPE scc_shorttext.

ENDCLASS.                    "lcl_short_text DEFINITION


*----------------------------------------------------------------------*
*       CLASS lcl_enhanced_quick_info DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_enhanced_quick_info DEFINITION FINAL.
* Local class to handle Enhanced Quick Info requests
  PUBLIC SECTION.
    CLASS-DATA m_max_components TYPE i.
    CLASS-METHODS: get_quickinfo_string
    IMPORTING
      compl_item        TYPE scc_completion
    RETURNING
      value(help_text)  TYPE string.

  PRIVATE SECTION.
    CLASS-DATA atl TYPE REF TO CL_ABAP_QI_ATL_TEMPLATES.
    CLASS-METHODS: method_formatting ##RELAX
    IMPORTING
      compl_item   TYPE scc_completion
      shorttext    TYPE string
      fullname     TYPE string
      details      TYPE scc_detailed_completions
    CHANGING
      help_text    TYPE string.

    CLASS-METHODS: field_formatting ##RELAX
    IMPORTING
      compl_item   TYPE scc_completion
      shorttext    TYPE string
      fullname     TYPE string
      details      TYPE scc_detailed_completions
    CHANGING
      help_text    TYPE string.

    CLASS-METHODS: type_formatting ##RELAX
    IMPORTING
      compl_item   TYPE scc_completion
      shorttext    TYPE string
      fullname     TYPE string
      details      TYPE scc_detailed_completions
    CHANGING
      help_text    TYPE string.

    CLASS-METHODS: event_formatting ##RELAX
    IMPORTING
      compl_item   TYPE scc_completion
      shorttext    TYPE string
      fullname     TYPE string
      details      TYPE scc_detailed_completions
    CHANGING
      help_text    TYPE string.

    CLASS-METHODS: form_formatting ##RELAX
     IMPORTING
       compl_item   TYPE scc_completion
       shorttext    TYPE string
       fullname     TYPE string
       details      TYPE scc_detailed_completions
     CHANGING
       help_text    TYPE string.

    CLASS-METHODS: function_formatting ##RELAX
    IMPORTING
      compl_item   TYPE scc_completion
      shorttext    TYPE string
      fullname     TYPE string
      details      TYPE scc_detailed_completions
    CHANGING
      help_text    TYPE string.

    CLASS-METHODS: exception_formatting ##RELAX
    IMPORTING
      compl_item   TYPE scc_completion
      shorttext    TYPE string
      fullname     TYPE string
      details      TYPE scc_detailed_completions
    CHANGING
      help_text    TYPE string.

    CLASS-METHODS: db_procedure_formatting ##RELAX
    IMPORTING
      compl_item   TYPE scc_completion
      shorttext    TYPE string
      fullname     TYPE string
      details      TYPE scc_detailed_completions
    CHANGING
      help_text    TYPE string.

    CLASS-METHODS: keyword_formatting ##RELAX
    IMPORTING
      compl_item   TYPE scc_completion
      shorttext    TYPE string
      fullname     TYPE string
      details      TYPE scc_detailed_completions
    CHANGING
      help_text    TYPE string.

    CLASS-METHODS: convert_source_to_help_txt
    IMPORTING
      source TYPE rswsourcet
    CHANGING
      help_text    TYPE string.

ENDCLASS.                    "lcl_enhanced_quick_info DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_enhanced_code_insertion DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_enhanced_code_insertion DEFINITION FINAL.
* Local class to handle Enhanced Code Insertion from Code Complete requests
  PUBLIC SECTION.
    TYPES: t_table_255 TYPE rswsourcet.
    CLASS-METHODS: get_insertion_string
       IMPORTING
          datatype         TYPE i
          patternkey       TYPE string
          beg_xpos         TYPE i
          settings         TYPE /cadaxo/cl_sqlc_abap_parser=>t_user_settings OPTIONAL
          value(sycontext) TYPE i               OPTIONAL
       CHANGING
          compl_text TYPE lcl_enhanced_code_insertion=>t_table_255.

  PRIVATE SECTION.


    CLASS-METHODS: method_formatting ##RELAX
    IMPORTING
      call_type    TYPE i
      datatype     TYPE i
      patternkey   TYPE string
      shorttext    TYPE string
      fullname     TYPE string
      beg_xpos     TYPE i
      details      TYPE scc_detailed_completions
      settings     TYPE /cadaxo/cl_sqlc_abap_parser=>t_user_settings OPTIONAL
    CHANGING
      compl_text    TYPE lcl_enhanced_code_insertion=>t_table_255.


    CLASS-METHODS: event_formatting ##RELAX
    IMPORTING
      call_type    TYPE i
      datatype     TYPE i
      patternkey   TYPE string
      shorttext    TYPE string
      fullname     TYPE string
      beg_xpos     TYPE i
      details      TYPE scc_detailed_completions
      settings     TYPE /cadaxo/cl_sqlc_abap_parser=>t_user_settings OPTIONAL
    CHANGING
      compl_text    TYPE lcl_enhanced_code_insertion=>t_table_255.

    CLASS-METHODS: form_formatting ##RELAX
    IMPORTING
      call_type    TYPE i
      datatype     TYPE i
      patternkey   TYPE string
      shorttext    TYPE string
      fullname     TYPE string
      beg_xpos     TYPE i
      details      TYPE scc_detailed_completions
      settings     TYPE /cadaxo/cl_sqlc_abap_parser=>t_user_settings OPTIONAL
    CHANGING
      compl_text    TYPE lcl_enhanced_code_insertion=>t_table_255.

    CLASS-METHODS: function_formatting ##RELAX
    IMPORTING
      call_type    TYPE i
      datatype     TYPE i
      patternkey   TYPE string
      shorttext    TYPE string
      fullname     TYPE string
      beg_xpos     TYPE i
      details      TYPE scc_detailed_completions
      settings     TYPE /cadaxo/cl_sqlc_abap_parser=>t_user_settings OPTIONAL
    CHANGING
      compl_text    TYPE lcl_enhanced_code_insertion=>t_table_255.

    CLASS-METHODS: exception_formatting ##RELAX
    IMPORTING
      call_type    TYPE i
      datatype     TYPE i
      patternkey   TYPE string
      shorttext    TYPE string
      fullname     TYPE string
      beg_xpos     TYPE i
      details      TYPE scc_detailed_completions
      settings     TYPE /cadaxo/cl_sqlc_abap_parser=>t_user_settings OPTIONAL
    CHANGING
      compl_text    TYPE lcl_enhanced_code_insertion=>t_table_255.

    CLASS-METHODS: value_formatting ##RELAX
    IMPORTING
      call_type    TYPE i
      datatype     TYPE i
      patternkey   TYPE string
      shorttext    TYPE string
      fullname     TYPE string
      beg_xpos     TYPE i
      details      TYPE scc_detailed_completions
      settings     TYPE /cadaxo/cl_sqlc_abap_parser=>t_user_settings OPTIONAL
    CHANGING
      compl_text    TYPE lcl_enhanced_code_insertion=>t_table_255.

    CLASS-METHODS: db_procedure_formatting ##RELAX
    IMPORTING
      call_type    TYPE i
      datatype     TYPE i
      patternkey   TYPE string
      shorttext    TYPE string
      fullname     TYPE string
      beg_xpos     TYPE i
      details      TYPE scc_detailed_completions
      settings     TYPE /cadaxo/cl_sqlc_abap_parser=>t_user_settings OPTIONAL
    CHANGING
      compl_text    TYPE lcl_enhanced_code_insertion=>t_table_255.

ENDCLASS.                    "lcl_enhanced_code_insertion DEFINITION

CLASS /cadaxo/cl_sqlc_abap_parser DEFINITION LOCAL FRIENDS lcl_repository_requests.
CLASS /cadaxo/cl_sqlc_abap_parser DEFINITION LOCAL FRIENDS lcl_enhanced_quick_info.
CLASS /cadaxo/cl_sqlc_abap_parser DEFINITION LOCAL FRIENDS lcl_enhanced_code_insertion.



*"* local class implementation for public class
*"* use this source file for the implementation part of
*"* local helper classes
CLASS lcl_repository_requests IMPLEMENTATION.


  METHOD get_repository_result.

*   handle all repository requests
    LOOP AT extern_reqs ASSIGNING field-symbol(<request>).
*     fill query properties
      data(queryproperties) = VALUE t_query_properties(
        kind      = <request>-kind
        role      = <request>-role
        reqindex  = sy-tabix
        prefixlen = strlen( <request>-prefix )
        grade     = <request>-grade
        syntcntxt = <request>-syntcntxt
        pattern   = |{ <request>-prefix }%| ).
      REPLACE ALL OCCURRENCES OF SUBSTRING '#'
        IN queryproperties-pattern WITH '##'.
      REPLACE ALL OCCURRENCES OF SUBSTRING '_'
        IN queryproperties-pattern WITH '#_'.
      TRANSLATE queryproperties-pattern TO UPPER CASE.

*     limit number of items selected from repositories
*     since items should mainly come from symbol table
      loop at max_items assigning field-symbol(<maxitems>)
           where prefix_len >= queryproperties-prefixlen. "#EC CI_SORTSEQ
        IF queryproperties-grade = 0.
          queryproperties-maxitems = <maxitems>-max_main.
        ELSE.
          queryproperties-maxitems = <maxitems>-max_second.
        ENDIF.
        exit.
      endloop.

*     call queries
      CASE <request>-role.
        WHEN sccmp_role_database OR
             sccmp_role_db_table OR
             sccmp_role_db_view .
          query_database_table(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).

        WHEN sccmp_role_function.
          query_function_module(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).

        WHEN sccmp_role_db_procedure.
          query_db_procedure(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).

        WHEN sccmp_role_intftype.
          query_interface_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).

        WHEN sccmp_role_classtype OR sccmp_role_classexception.
          queryproperties-role = sccmp_role_classtype.
          query_class_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).

        WHEN sccmp_role_objtype.
          queryproperties-role = sccmp_role_intftype.
          query_interface_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).
          queryproperties-role = sccmp_role_classtype.
          query_class_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).

        WHEN sccmp_role_structtype.
          query_structure_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).

        WHEN sccmp_role_itabtype.
          query_table_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).

        WHEN sccmp_role_type.
          query_data_element(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).
          queryproperties-role = sccmp_role_structtype.
          query_structure_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).
          queryproperties-role = sccmp_role_itabtype.
          query_table_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
           ).

        WHEN sccmp_role_ref_to_type.
          queryproperties-role = sccmp_role_intftype.
          query_interface_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).
          queryproperties-role = sccmp_role_classtype.
          query_class_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).
          queryproperties-role = sccmp_role_structtype.
          query_structure_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).
          queryproperties-role = sccmp_role_itabtype.
          query_table_type(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
           ).
          queryproperties-role = sccmp_role_type.
          query_data_element(
             EXPORTING
               props  = queryproperties
             CHANGING
               result = compl_result
          ).
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.                    "GET_REPOSITORY_RESULT

  METHOD call_f4_help.
*   see function group SEF4
    data(l_prefix) = CONV sobj_name( |{ prefix }*| ).
    DATA eu_type_id TYPE euobj-id.
    DATA varname TYPE variant.

*   map role to eu object
    CASE role.
      WHEN sccmp_role_classtype OR
           sccmp_role_objtype.
        eu_type_id = 'CLAS'.
      WHEN sccmp_role_intftype.
        eu_type_id = 'INTF'.
      WHEN sccmp_role_itabtype.
        eu_type_id = 'TTYP'.
      WHEN sccmp_role_type.
        eu_type_id = 'DTEL'.
      WHEN sccmp_role_structtype.
        eu_type_id = 'TABL'.
        varname = 'SAP&DDSTRUC_CC'.
      WHEN sccmp_role_database.
        eu_type_id = 'TABL'.
        varname = 'SAP&STANDARD'.
      WHEN sccmp_role_db_table.
        eu_type_id = 'TABL'.
        varname = 'SAP&TABLE'.
      WHEN sccmp_role_db_view.
        eu_type_id = 'VIEW'.
      WHEN sccmp_role_function.
        eu_type_id = 'FUNC'.
      WHEN sccmp_role_db_procedure.
        eu_type_id = 'SQSC'.
    ENDCASE.

    CALL FUNCTION 'REPOSITORY_INFO_SYSTEM_F4'
      EXPORTING
        object_type                     = eu_type_id
        object_name                     = l_prefix
*       ENCLOSING_OBJECT                =
        suppress_selection              = space
        variant                         = varname
*       LIST_VARIANT                    = ' '
        display_field                   = ''
*       MULTIPLE_SELECTION              =
*       SELECT_ALL_FIELDS               = ' '
        without_personal_list           = 'X'
*       PACKAGE                         = ' '
        use_alv_grid                    = 'X'
      IMPORTING
        object_name_selected            = result
*       ENCLOSING_OBJECT_SELECTED       =
*       STRUCINF                        =
*     TABLES
*       OBJECTS_SELECTED                =
*       RECORD_TAB                      =
      EXCEPTIONS
        cancel                          = 1
        OTHERS                          = 2
              .
    IF sy-subrc <> 0.
      RAISE request_canceled.
    ENDIF.

  ENDMETHOD.                    "call_f4_help

  METHOD query_class_type.
    query_type(
      EXPORTING
        props  = props
        objs   = VALUE #( ( sign = 'I' option = 'EQ' low = 'CLAS' ) )
      CHANGING
        result = result
    ).
  ENDMETHOD.                    "query_class_type

  METHOD query_interface_type.
    query_type(
      EXPORTING
        props  = props
        objs   = VALUE #( ( sign = 'I' option = 'EQ' low = 'INTF' ) )
      CHANGING
        result = result
    ).
  ENDMETHOD.                    "query_interface_type

  METHOD query_structure_type.
    query_type(
      EXPORTING
        props  = props
        objs   = VALUE #( ( sign = 'I' option = 'EQ' low = 'STRU' )
                          ( sign = 'I' option = 'EQ' low = 'TABL' )
                          ( sign = 'I' option = 'EQ' low = 'VIEW' ) )
      CHANGING
        result = result
    ).
  ENDMETHOD.                    "query_structure_type

  METHOD query_data_element.
    query_type(
      EXPORTING
        props  = props
        objs   = VALUE #( ( sign = 'I' option = 'EQ' low = 'DTEL' ) )
      CHANGING
        result = result
    ).
  ENDMETHOD.                    "query_data_element

  METHOD query_table_type.
    query_type(
      EXPORTING
        props  = props
        objs   = VALUE #( ( sign = 'I' option = 'EQ' low = 'TTYP' ) )
      CHANGING
        result = result
    ).
  ENDMETHOD.                    "query_table_type

  METHOD query_database_table.
    query_type(
      EXPORTING
        props  = props
        objs   = VALUE #( ( sign = 'I' option = 'EQ' low = 'TABL' )
                          ( sign = 'I' option = 'EQ' low = 'VIEW' ) )
      CHANGING
        result = result
    ).
  ENDMETHOD.                    "query_table_type

  METHOD query_type.
    IF props-maxitems > 0.
      data(compl_result_wa) = VALUE scc_completion(
        kind         = props-kind
        role         = props-role
        prefixlength = props-prefixlen
        location     = sccmp_loc_ddic
        grade        = props-grade
        visibility   = sccmp_visibility_dontcare
        syntcntxt    = props-syntcntxt ).

      SELECT obj_name AS identifier FROM tadir           "#EC CI_GENBUFF
                   UP TO props-maxitems ROWS
                   INTO CORRESPONDING FIELDS OF compl_result_wa
                   WHERE pgmid = 'R3TR' AND
                         object IN objs AND
                         obj_name LIKE props-pattern ESCAPE '#' AND
                         delflag = space
                   ORDER BY obj_name.
        INSERT compl_result_wa INTO TABLE result.
      ENDSELECT.
      IF sy-dbcnt < props-maxitems.
*       ready if no items left
        RETURN.
      ENDIF.
    ENDIF.

*   insert search item
    add_search_item(
      EXPORTING
        props = props
      CHANGING
        result = result
    ).
  ENDMETHOD.                    "query_type

  METHOD query_function_module.
    IF props-maxitems > 0.
      data(compl_result_wa) = VALUE scc_completion(
        kind         = props-kind
        role         = props-role
        prefixlength = props-prefixlen
        location     = sccmp_loc_ddic
        grade        = props-grade
        visibility   = sccmp_visibility_dontcare
        syntcntxt    = props-syntcntxt ).
      SELECT funcname AS identifier FROM tfdir
                 UP TO props-maxitems ROWS
                 INTO CORRESPONDING FIELDS OF compl_result_wa
                 WHERE funcname LIKE props-pattern ESCAPE '#' "#EC CI_GENBUFF
                 ORDER BY funcname.
        INSERT compl_result_wa INTO TABLE result.
      ENDSELECT.
      IF sy-dbcnt < props-maxitems.
        RETURN.
      ENDIF.
    ENDIF.

*   insert search item
    add_search_item(
      EXPORTING
        props = props
      CHANGING
        result = result
    ).
  ENDMETHOD.                    "query_functionmodule

  METHOD query_db_procedure.
    IF props-maxitems > 0.
      data(compl_result_wa) = VALUE scc_completion(
        kind         = props-kind
        role         = props-role
        prefixlength = props-prefixlen
        location     = sccmp_loc_ddic
        grade        = props-grade
        visibility   = sccmp_visibility_dontcare
        syntcntxt    = props-syntcntxt ).
      SELECT progname AS identifier FROM ddsqlscsrc
                 UP TO props-maxitems ROWS
                 INTO CORRESPONDING FIELDS OF compl_result_wa
                 WHERE progname LIKE props-pattern ESCAPE '#' "#EC CI_GENBUFF
                 ORDER BY progname.
        INSERT compl_result_wa INTO TABLE result.
      ENDSELECT.
      IF sy-dbcnt < props-maxitems.
        RETURN.
      ENDIF.
    ENDIF.

*   insert search item
    add_search_item(
      EXPORTING
        props = props
      CHANGING
        result = result
    ).
  ENDMETHOD.                    "query_db_procedure

  METHOD add_search_item.
    CONSTANTS: pre  TYPE c LENGTH 1 VALUE '<',
               post TYPE c LENGTH 4 VALUE '...>'.

    data(compl_result_wa) = VALUE scc_completion(
      kind         = props-kind
      role         = props-role
      is_meta      = sccmp_true
      prefixlength = props-prefixlen
      location     = sccmp_loc_ddic
      grade        = props-grade
      visibility   = sccmp_visibility_dontcare
      prop1        = props-reqindex
      syntcntxt    = props-syntcntxt ).

    CASE props-role.
      WHEN sccmp_role_function.
        CONCATENATE pre text-335 post INTO compl_result_wa-identifier.
        INSERT compl_result_wa INTO TABLE result.

      WHEN sccmp_role_db_procedure.
        CONCATENATE pre text-350 post INTO compl_result_wa-identifier.
        INSERT compl_result_wa INTO TABLE result.

      WHEN sccmp_role_objtype OR
           sccmp_role_classtype OR
           sccmp_role_classexception OR
           sccmp_role_intftype.
        compl_result_wa-role = sccmp_role_objtype.
        CONCATENATE pre text-325 post INTO compl_result_wa-identifier.
        INSERT compl_result_wa INTO TABLE result.

      WHEN sccmp_role_itabtype.
        CONCATENATE pre text-340 post INTO compl_result_wa-identifier.
        INSERT compl_result_wa INTO TABLE result.

      WHEN sccmp_role_structtype.
        CONCATENATE pre text-330 post INTO compl_result_wa-identifier.
        INSERT compl_result_wa INTO TABLE result.

      WHEN sccmp_role_type OR sccmp_role_ref_to_type.
        compl_result_wa-role = sccmp_role_type.
        CONCATENATE pre text-310 post INTO compl_result_wa-identifier.
        INSERT compl_result_wa INTO TABLE result.

      WHEN sccmp_role_database OR
           sccmp_role_db_table OR
           sccmp_role_db_view.
        compl_result_wa-role = sccmp_role_database.
        CONCATENATE pre text-305 post INTO compl_result_wa-identifier.
        INSERT compl_result_wa INTO TABLE result.
    ENDCASE.

  ENDMETHOD.                    "add_search_items_for_role
ENDCLASS.                    "lcl_repository_requests IMPLEMENTATION


*----------------------------------------------------------------------*
*       CLASS lcl_short_text IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_short_text IMPLEMENTATION.
* Local class to provide the short text for a source object
  METHOD get_text.
*   importing fullname  type string
*   exporting shorttext type scc_shorttext
    DATA:
      l_srch   TYPE string,
      l_head   TYPE scc_identifier,
      l_tail   TYPE string.

    CLEAR shorttext.
    IF fullname IS INITIAL.
      RETURN.
    ENDIF.

    CASE fullname+1(2).

      WHEN sccmp_tag_type OR sccmp_tag_data.
        l_srch = fullname+4.
        SPLIT l_srch AT '\' INTO l_head l_tail.
        IF l_head IS INITIAL.
          l_head = l_tail.
          CLEAR l_tail.
        ENDIF.
        get_ddiccomp_text( EXPORTING ddicobj  = l_head
                                     fullname = l_tail
                           IMPORTING shorttext = shorttext ).

      WHEN sccmp_tag_predef_type.
        l_srch = fullname+4. " assumption: no more components
        CONCATENATE text-400 l_srch INTO shorttext SEPARATED BY space.

      WHEN sccmp_tag_predef_data. " assumption: no more components
        l_srch = fullname+4.
        CONCATENATE text-401 l_srch INTO shorttext SEPARATED BY space.

      WHEN sccmp_tag_function.
        l_srch = fullname+4.
        SPLIT l_srch AT '\' INTO l_head l_tail.
        IF l_head IS INITIAL.
          l_head = l_tail.
          CLEAR l_tail.
        ENDIF.
        get_function_text( EXPORTING funcname = l_head
                                     fullname = l_tail
                           IMPORTING shorttext = shorttext ).

      WHEN sccmp_tag_db_procedure.
        l_srch = fullname+4.
        SPLIT l_srch AT '\' INTO l_head l_tail.
        IF l_head IS INITIAL.
          l_head = l_tail.
          CLEAR l_tail.
        ENDIF.
        get_dbproc_text( EXPORTING dbprocname = l_head
                                   fullname   = l_tail
                         IMPORTING shorttext  = shorttext ).

      WHEN sccmp_tag_class OR sccmp_tag_interface.
        l_srch = fullname+4.
        SPLIT l_srch AT '\' INTO l_head l_tail.
        IF l_head IS INITIAL.
          l_head = l_tail.
          CLEAR l_tail.
        ENDIF.
        get_objcomp_text( EXPORTING objtype   = l_head
                                    fullname  = l_tail
                          IMPORTING shorttext = shorttext ).

      WHEN sccmp_tag_program.
        l_srch = fullname+4.
        SPLIT l_srch AT '\' INTO l_head l_tail.
        IF l_head IS INITIAL.
          l_head = l_tail.
          CLEAR l_tail.
        ENDIF.

      WHEN sccmp_tag_classpool OR sccmp_tag_interfacepool.
        l_srch = fullname+4.
        SPLIT l_srch AT '\' INTO l_head l_tail.
        IF l_head IS INITIAL.
          l_head = l_tail.
          CLEAR l_tail.
        ENDIF.

      WHEN sccmp_tag_typepool.
        l_srch = fullname+4.
        SPLIT l_srch AT '\' INTO l_head l_tail.
        IF l_head IS INITIAL.
          l_head = l_tail.
          CLEAR l_tail.
        ENDIF.

      WHEN OTHERS.
        CLEAR shorttext.

    ENDCASE.
  ENDMETHOD.                    "get_text

  METHOD get_objcomp_text.
*    importing objtype   type SCC_IDENTIFIER
*                        fullname  type string
*    exporting shorttext type scc_shorttext
    DATA:
      l_srch   TYPE string,
      l_head   TYPE scc_identifier,
      l_tail   TYPE string.

    IF fullname IS INITIAL.
*     search in DB
      SELECT SINGLE descript FROM seoclasstx INTO (shorttext)
             WHERE clsname = objtype AND
                   langu   = sy-langu.
    ELSE.
      CASE fullname(2).
        WHEN sccmp_tag_type OR sccmp_tag_data OR
             sccmp_tag_method OR sccmp_tag_event.
          l_srch = fullname+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS INITIAL.
            l_head = l_tail.
            CLEAR l_tail.
          ENDIF.
          get_objsubco_text( EXPORTING objtype   = objtype
                                       component = l_head
                                       fullname  = l_tail
                             IMPORTING shorttext = shorttext ).

        WHEN OTHERS.
          CLEAR shorttext.
      ENDCASE.
    ENDIF.
  ENDMETHOD.                    "get_objcomp_text

  METHOD get_objsubco_text.
*     importing objtype   type SCC_IDENTIFIER
*               component type SCC_IDENTIFIER
*               fullname  type string
*     exporting shorttext type scc_shorttext
    DATA:
      l_srch   TYPE string,
      l_head   TYPE scc_identifier,
      l_tail   TYPE string.

    IF fullname IS INITIAL.
*     search in DB
      SELECT SINGLE descript FROM seocompotx INTO (shorttext)
             WHERE clsname = objtype   AND
                   cmpname = component AND
                   langu   = sy-langu.
    ELSE.
      CASE fullname(2).
        WHEN sccmp_tag_data.
          l_srch = fullname+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS INITIAL.
            l_head = l_tail.
            CLEAR l_tail.
          ENDIF.
*         search in DB
          SELECT SINGLE descript FROM seosubcotx INTO (shorttext)
                 WHERE clsname = objtype   AND
                       cmpname = component AND
                       sconame = l_head    AND
                       langu   = sy-langu.

        WHEN OTHERS.
          CLEAR shorttext.
      ENDCASE.
    ENDIF.
  ENDMETHOD.                    "get_objsubco_text

  METHOD get_ddiccomp_text.
*      importing ddicobj   type SCC_IDENTIFIER
*                fullname  type string
*      exporting shorttext type scc_shorttext
    DATA:
      l_srch          TYPE string,
      l_head          TYPE scc_identifier,
      l_tail          TYPE string,
      l_ddicobj       TYPE ddobjname,
      l_component     TYPE dfies-lfieldname,
      l_ddicobj_dsrc  TYPE dfies,
      l_ddicobj_kind  TYPE tabclass,
      l_ddictab_info  TYPE dd02v,
      l_ddicview_info TYPE dd25v,
      l_ddicdtel_info TYPE dd04v,
      l_ddicttyp_info TYPE dd40v.

    l_ddicobj = ddicobj.
    IF fullname IS INITIAL.
*     search for type
      CALL FUNCTION 'DDIF_FIELDINFO_GET'
        EXPORTING
          tabname     = l_ddicobj
          all_types   = 'X'
        IMPORTING
          dfies_wa    = l_ddicobj_dsrc
          ddobjtype   = l_ddicobj_kind
        EXCEPTIONS
          OTHERS      = 1.
      IF sy-subrc = 0.
        shorttext = l_ddicobj_dsrc-fieldtext.
        IF shorttext IS INITIAL.
          CASE l_ddicobj_kind.
            WHEN 'TRANSP'  OR " transparent table
                 'POOL'    OR " logical pooled table
                 'CLUSTER' OR " logical cluster table
                 'INTTAB'  OR " structure, help view, maintenance view or structure view
                 'TPOOL'   OR " physical pooled table
                 'TCLUSTER'.  " physical cluster table
              CALL FUNCTION 'DDIF_TABL_GET'
                EXPORTING
                  name     = l_ddicobj
                  langu    = sy-langu
                IMPORTING
                  dd02v_wa = l_ddictab_info.
              shorttext = l_ddictab_info-ddtext.
            WHEN 'VIEW'.      " database or projection view
              CALL FUNCTION 'DDIF_VIEW_GET'
                EXPORTING
                  name     = l_ddicobj
                  langu    = sy-langu
                IMPORTING
                  dd25v_wa = l_ddicview_info.
              shorttext = l_ddicview_info-ddtext.
            WHEN 'DTEL'.      " data element
              CALL FUNCTION 'DDIF_DTEL_GET'
                EXPORTING
                  name     = l_ddicobj
                  langu    = sy-langu
                IMPORTING
                  dd04v_wa = l_ddicdtel_info.
              shorttext = l_ddicdtel_info-ddtext.
            WHEN 'TTYP'.      " table type
              CALL FUNCTION 'DDIF_TTYP_GET'
                EXPORTING
                  name     = l_ddicobj
                  langu    = sy-langu
                IMPORTING
                  dd40v_wa = l_ddicttyp_info.
              shorttext = l_ddicttyp_info-ddtext.
          ENDCASE.
        ENDIF.
      ENDIF.
    ELSE.
      CASE fullname(2).
        WHEN sccmp_tag_data.
          l_srch = fullname+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS INITIAL.
            l_head = l_tail.
            CLEAR l_tail.
          ENDIF.
*         search for component of table
          l_component = l_head.
          CALL FUNCTION 'DDIF_FIELDINFO_GET'
            EXPORTING
              tabname     = l_ddicobj
              lfieldname  = l_component
              all_types   = 'X'
            IMPORTING
              dfies_wa    = l_ddicobj_dsrc
            EXCEPTIONS
              OTHERS      = 1.
          IF sy-subrc = 0.
            shorttext = l_ddicobj_dsrc-fieldtext.
          ENDIF.
        WHEN OTHERS.
          CLEAR shorttext.
      ENDCASE.
    ENDIF.
  ENDMETHOD.                    "get_ddiccomp_text

  METHOD get_function_text.
*     importing funcname  type SCC_IDENTIFIER
*               fullname  type string
*     exporting shorttext type scc_shorttext
    DATA:
      l_srch   TYPE string,
      l_head   TYPE scc_identifier,
      l_tail   TYPE string,
      sshorttext type string.

    IF fullname IS INITIAL.
*     search in DB
      SELECT SINGLE stext FROM tftit INTO (sshorttext)
             WHERE spras    = sy-langu AND
                   funcname = funcname.
        shorttext = sshorttext.
    ELSE.
      CASE fullname(2).
        WHEN sccmp_tag_data.
          l_srch = fullname+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS INITIAL.
            l_head = l_tail.
            CLEAR l_tail.
          ENDIF.
*         search in DB
          SELECT SINGLE stext FROM funct INTO (shorttext) ##WARN_OK
                 WHERE spras     = sy-langu AND
                       funcname  = funcname AND
                       parameter = l_head.

        WHEN OTHERS.
          CLEAR shorttext.
      ENDCASE.
    ENDIF.

  ENDMETHOD.                    "get_function_text

  METHOD get_dbproc_text.
*     importing dbprocname type SCC_IDENTIFIER
*               fullname   type string
*     exporting shorttext  type scc_shorttext
    DATA:
      sshorttext type string.

    IF fullname IS INITIAL.
*     search in DB
      SELECT SINGLE ddtext FROM DDSQLSCT INTO (sshorttext)
             WHERE ddlanguage = sy-langu AND
                   AS4LOCAL   = 'A'      and
                   progname   = dbprocname.
        shorttext = sshorttext.
    ENDIF.

  ENDMETHOD.                    "get_dbproc_text

  METHOD  get_sourcetext.
*     importing fullname   type string
*     exporting sourcetext type string.
    CONSTANTS:
      c_sel_objtype  TYPE string VALUE `=>`,
*      c_sel_refvar   type string value `->`,
      c_sel_struct   TYPE string VALUE `-`,
      c_sel_implintf TYPE string VALUE `~`,
      c_sel_default  TYPE string VALUE `: `.

    DATA:
      l_srch   TYPE string,
      l_head   TYPE scc_identifier,
      l_tail   TYPE string,
      l_objsel TYPE string VALUE c_sel_objtype.

    IF fullname IS INITIAL OR fullname(1) <> '\'.
      sourcetext = fullname.
      RETURN.
    ENDIF.

*   is actual a fullname => analyze
    CLEAR sourcetext.
    l_srch = fullname+1.
    WHILE strlen( l_srch ) >= 3. " TG:

      CASE l_srch(2).

        WHEN sccmp_tag_program.
          l_srch = l_srch+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS NOT INITIAL.
            IF l_tail IS NOT INITIAL.
              CONCATENATE sourcetext l_head c_sel_default INTO sourcetext.
            ELSE.
              CONCATENATE sourcetext l_head INTO sourcetext.
            ENDIF.
            l_srch = l_tail.
          ENDIF.

        WHEN sccmp_tag_classpool OR sccmp_tag_interfacepool.
          l_srch = l_srch+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS NOT INITIAL.
            IF l_tail IS NOT INITIAL.
              CONCATENATE sourcetext l_head c_sel_default INTO sourcetext.
            ELSE.
              CONCATENATE sourcetext l_head INTO sourcetext.
            ENDIF.
            l_srch = l_tail.
          ENDIF.

        WHEN sccmp_tag_typepool.
          l_srch = l_srch+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS NOT INITIAL.
            IF l_tail IS NOT INITIAL.
              CONCATENATE sourcetext l_head c_sel_default INTO sourcetext.
            ELSE.
              CONCATENATE sourcetext l_head INTO sourcetext.
            ENDIF.
            l_srch = l_tail.
          ENDIF.

        WHEN sccmp_tag_class OR sccmp_tag_interface.
          l_srch = l_srch+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS NOT INITIAL.
            IF l_tail IS NOT INITIAL.
              CONCATENATE sourcetext l_head l_objsel INTO sourcetext.
            ELSE.
              CONCATENATE sourcetext l_head INTO sourcetext.
            ENDIF.
            l_srch = l_tail.
            l_objsel = c_sel_implintf. " only implemented interface can be nested
          ENDIF.

        WHEN sccmp_tag_method OR sccmp_tag_event.
          l_srch = l_srch+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS NOT INITIAL.
            IF l_tail IS NOT INITIAL.
              CONCATENATE sourcetext l_head c_sel_default INTO sourcetext.
            ELSE.
              CONCATENATE sourcetext l_head INTO sourcetext.
            ENDIF.
            l_srch = l_tail.
          ENDIF.

        WHEN sccmp_tag_type OR sccmp_tag_data.
          l_srch = l_srch+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS NOT INITIAL.
            IF l_tail IS NOT INITIAL.
              CONCATENATE sourcetext l_head c_sel_struct INTO sourcetext.
            ELSE.
              CONCATENATE sourcetext l_head INTO sourcetext.
            ENDIF.
            l_srch = l_tail.
            l_objsel = c_sel_implintf. " only implemented interface can be nested
          ENDIF.

        WHEN sccmp_tag_predef_type OR sccmp_tag_predef_data.
          l_srch = l_srch+3. " assumption: no more components
          CONCATENATE sourcetext l_srch INTO sourcetext.

        WHEN sccmp_tag_function.
          l_srch = l_srch+3.
          SPLIT l_srch AT '\' INTO l_head l_tail.
          IF l_head IS NOT INITIAL.
            IF l_tail IS NOT INITIAL.
              CONCATENATE sourcetext l_head c_sel_default INTO sourcetext.
            ELSE.
              CONCATENATE sourcetext l_head INTO sourcetext.
            ENDIF.
            l_srch = l_tail.
          ENDIF.

        WHEN OTHERS.
          CONCATENATE sourcetext l_srch INTO sourcetext.
          CLEAR l_srch.
      ENDCASE.

    ENDWHILE.

  ENDMETHOD.

ENDCLASS.                    "lcl_short_text IMPLEMENTATION


*----------------------------------------------------------------------*
*       CLASS lcl_enhanced_quick_info IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_enhanced_quick_info IMPLEMENTATION.
  METHOD get_quickinfo_string.

    data(l_kind)       = CONV i(      compl_item-kind ).
    data(l_identifier) = CONV string( compl_item-identifier ).

*   get details from symbol table
    /cadaxo/cl_sqlc_abap_parser=>get_completion_details(
      EXPORTING
        maxgrade    = 6
        kind        = l_kind
        identifier  = l_identifier
      IMPORTING
        shorttext   = data(infotext)
        fullname    = data(fullname)
        depentities = data(l_details)
    ).

*   get short text according fullname
    lcl_short_text=>get_text(
      EXPORTING fullname  = fullname
      IMPORTING shorttext = data(l_shorttext)
    ).
    infotext = l_shorttext.

    DATA method_name TYPE string.
    CASE l_kind.
      WHEN sccmp_cat_method.
        method_name = 'METHOD_FORMATTING'.
      WHEN sccmp_cat_field.
        method_name = 'FIELD_FORMATTING'.
      WHEN sccmp_cat_type.
        method_name = 'TYPE_FORMATTING'.
      WHEN sccmp_cat_event.
        method_name = 'EVENT_FORMATTING'.
      WHEN sccmp_cat_form.
        method_name = 'FORM_FORMATTING'.
      WHEN sccmp_cat_function.
        method_name = 'FUNCTION_FORMATTING'.
      WHEN sccmp_cat_exception.
        method_name = 'EXCEPTION_FORMATTING'.
      WHEN sccmp_cat_db_procedure.
        method_name = 'DB_PROCEDURE_FORMATTING'.
      WHEN sccmp_cat_keyword.
        method_name = 'KEYWORD_FORMATTING'.
      WHEN OTHERS.
        CLEAR method_name.
    ENDCASE.

    FIELD-SYMBOLS <complitem> TYPE scc_detailed_completion-completion.
    IF method_name IS NOT INITIAL.
*     current completion entry is first entry in details table
*     => re-read for up-to-date properties
      ASSIGN l_details[ 1 ] TO FIELD-SYMBOL(<details>).
      IF sy-subrc = 0.
        ASSIGN <details>-completion TO <complitem>.
      ELSE.
        ASSIGN compl_item TO <complitem>.
      ENDIF.
      TRY.
          CALL METHOD lcl_enhanced_quick_info=>(method_name)
            EXPORTING
              compl_item = <complitem>
              shorttext  = infotext
              fullname   = fullname
              details    = l_details
            CHANGING
              help_text  = help_text.
        CATCH cx_sy_dyn_call_error.                      "#EC NO_HANDLER
      ENDTRY.
      IF compl_item-is_meta = sccmp_insert_meta.
        CONCATENATE '\b'
         'Insert Pattern for'(600)
         cl_abap_char_utilities=>newline
         help_text INTO help_text.
      ENDIF.
    ENDIF.

  ENDMETHOD.                    "get_quickinfo_string

  METHOD method_formatting.

    data(role_text)   = /cadaxo/cl_sqlc_abap_parser=>get_role_text( role = compl_item-role ).
    data(method_name) = CONV string( compl_item-identifier ).
    DATA:
      abstract       TYPE string,
      event_handler  TYPE string.

    field-symbols <flags>  type x.
    constants:
      abstract_bit    type x value 1,
      final_bit       type x value 2 ##NEEDED,
      redefined_bit   type x value 4 ##NEEDED,
      testing_bit     type x value 8 ##NEEDED,
      handler_bit     type x value 16,
      constructor_bit type x value 32 ##NEEDED.

    assign compl_item-prop2 to <flags> casting.
    IF <flags> bit-and abstract_bit = abstract_bit.
      abstract = 'Abstract'(403).
    ENDIF.
    IF <flags> bit-and handler_bit = handler_bit.
      ASSIGN details[ 2 ] TO FIELD-SYMBOL(<wa_detail>).
      IF sy-subrc = 0.
        lcl_short_text=>get_sourcetext(
          EXPORTING fullname   = <wa_detail>-fullname
          IMPORTING sourcetext = event_handler
        ).
        CONCATENATE text-246 event_handler INTO event_handler SEPARATED BY space.
      ENDIF.
    ENDIF.

    /cadaxo/cl_sqlc_abap_parser=>parse_method_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
      IMPORTING
        importing_parameters = data(importing_parameters)
        exporting_parameters = data(exporting_parameters)
        changing_parameters  = data(changing_parameters)
        returning_parameters = data(returning_parameters)
        exceptions_list      = data(exceptions_list)
        class_exceptions     = data(class_exceptions) ).

    atl = NEW #( ).
    TRY.
        DATA(source) = atl->ATL_BASIC_METHOD(
            method_name          = method_name
            role_text            = role_text
            importing_parameters = importing_parameters
            exporting_parameters = exporting_parameters
            changing_parameters  = changing_parameters
            returning_parameters = returning_parameters
            exceptions_list      = exceptions_list
            short_text           = shorttext
            class_exceptions     = class_exceptions
            abstract             = abstract
            event_handler        = event_handler ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

    lcl_enhanced_quick_info=>convert_source_to_help_txt(
       EXPORTING
          source = source
       CHANGING
          help_text = help_text ).

  ENDMETHOD.                    "method_formatting

  METHOD field_formatting.

    DATA l_shorttext TYPE scc_shorttext.
    DATA l_maintype  TYPE string.
    DATA type1_desc  TYPE string.
    DATA data_type2  TYPE string.
    DATA valuetext   TYPE string.
    DATA type2_text  TYPE string.
    DATA final_text  TYPE string.
    DATA l_next_idx  TYPE i value 2. " start index for type information

    data(role_text)  = /cadaxo/cl_sqlc_abap_parser=>get_role_text( role = compl_item-role ).
    data(field_name) = CONV string( compl_item-identifier ).

    ASSIGN details[ 1 ] TO FIELD-SYMBOL(<wa_detail>).
    IF sy-subrc = 0.
****Get the full Typing
      if <wa_detail>-role = sccmp_role_attralias.
        add 1 to l_next_idx.
      endif.
      /cadaxo/cl_sqlc_abap_parser=>get_typing_text(
        EXPORTING
          p_details  = details
          p_begin    = l_next_idx
          p_fullname = fullname
        IMPORTING
          p_text     = l_maintype
          p_next     = l_next_idx ).

      CLEAR l_shorttext.
      lcl_short_text=>get_text(
        EXPORTING fullname  = <wa_detail>-fullname
        IMPORTING shorttext = l_shorttext ).
      type1_desc = l_shorttext.
    ENDIF.

****Get Value for Constants/Variables
    ASSIGN details[ l_next_idx ] TO <wa_detail>.
    IF sy-subrc = 0 AND <wa_detail>-kind = sccmp_cat_value.
      type2_text = 'Value'(402).
      IF <wa_detail>-valuetext IS INITIAL OR
         <wa_detail>-fullname = <wa_detail>-valuetext.
        lcl_short_text=>get_sourcetext(
          EXPORTING fullname   = <wa_detail>-fullname
          IMPORTING sourcetext = data_type2
        ).
      ELSE.
        lcl_short_text=>get_sourcetext(
          EXPORTING fullname   = <wa_detail>-fullname
          IMPORTING sourcetext = data_type2
        ).
        lcl_short_text=>get_sourcetext(
          EXPORTING fullname   = <wa_detail>-valuetext
          IMPORTING sourcetext = valuetext
        ).
        CONCATENATE data_type2 ` = ` valuetext INTO data_type2.
      ENDIF.
    ENDIF.

    IF shorttext IS INITIAL.
      final_text = type1_desc.
      CLEAR type1_desc.
    ELSE.
      final_text = shorttext.
    ENDIF.

    atl = NEW #( ).
    TRY.
        DATA(source) = atl->ATL_FIELD(
            field_name = field_name
            role_text  = role_text
            short_text = final_text
            main_type  = l_maintype
            data_type2 = data_type2
            type2_text = type2_text ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

    lcl_enhanced_quick_info=>convert_source_to_help_txt(
       EXPORTING
          source = source
       CHANGING
          help_text = help_text ).
  ENDMETHOD.                    "field_formatting

  METHOD type_formatting.

    DATA l_shorttext TYPE scc_shorttext.
    DATA l_temp_text TYPE string.
    DATA l_fullname  TYPE string.
    DATA type1_desc  TYPE string.
    DATA l_maintype  TYPE string.
    DATA final_text  TYPE string.
    DATA struc_comp  TYPE if_abap_cc_atl_types=>type_list.
    DATA l_tabix     TYPE sytabix VALUE 1.
    DATA l_count     TYPE i.
    DATA l_grade     TYPE i.
    DATA l_type      TYPE string.
    DATA struc_ovr   TYPE string.  "Structure Overflow Text

    data(role)       = compl_item-role.
    data(role_text)  = /cadaxo/cl_sqlc_abap_parser=>get_role_text( role = role ).
    data(field_name) = CONV string( compl_item-identifier ).

    FIELD-SYMBOLS: <wa_detail> LIKE LINE OF details.

    IF fullname IS INITIAL.
      CASE role.
        WHEN sccmp_role_classtype OR sccmp_role_classexception OR sccmp_role_testclasstype.
          CONCATENATE '\CL:' compl_item-identifier
           INTO l_fullname.
        WHEN OTHERS.
          CONCATENATE '\TY:' compl_item-identifier
             INTO l_fullname.
      ENDCASE.
    ELSE.
      l_fullname = fullname.
    ENDIF.

*   get short text according fullname
    CLEAR l_shorttext.
    lcl_short_text=>get_text(
      EXPORTING fullname  = l_fullname
      IMPORTING shorttext = l_shorttext ).
    l_temp_text = l_shorttext.

*   skip first entry for for type aliases for interface types
    if role = sccmp_role_typealias and compl_item-prop2 <> 0.
      ADD 1 TO l_tabix.
      role = details[ l_tabix ]-role.
    endif.

    IF role = sccmp_role_structtype OR
       role = sccmp_role_itabtype OR
       role = sccmp_role_database OR
       role = sccmp_role_classtype OR
       role = sccmp_role_classexception OR
       role = sccmp_role_intftype OR
       role = sccmp_role_testclasstype.

      IF  role = sccmp_role_itabtype.
        ASSIGN details[ l_tabix ] TO <wa_detail>.
        IF sy-subrc = 0.
          ADD 1 TO l_tabix. " type description starts at next position
****Get the full Typing
          /cadaxo/cl_sqlc_abap_parser=>get_typing_text(
            EXPORTING
              p_details  = details
              p_begin    = l_tabix
              p_fullname = fullname
            IMPORTING
              p_text     = l_maintype
              p_next     = l_tabix ).

          CLEAR l_shorttext.
          lcl_short_text=>get_text(
            EXPORTING fullname  = <wa_detail>-fullname
            IMPORTING shorttext = l_shorttext ).
          type1_desc = l_shorttext.
        ENDIF.
        l_grade = 2.
      ELSE.
        l_grade = 1.
      ENDIF.
****Structure - Process the Individual Components
      LOOP AT details ASSIGNING <wa_detail> WHERE grade = l_grade.
        l_tabix = sy-tabix + 1.
        l_count = l_count + 1.
        IF l_count >= m_max_components. " stop at maximal number of entries
          struc_ovr = text-404.
          EXIT.
        ELSE.
          APPEND INITIAL LINE TO struc_comp ASSIGNING field-symbol(<wa_struc>).
          <wa_struc>-tname = <wa_detail>-identifier.
****Get the full Typing
          CLEAR l_type.
          IF role <> sccmp_role_classtype AND
             role <> sccmp_role_classexception AND
             role <> sccmp_role_intftype AND
             role <> sccmp_role_testclasstype AND
             l_tabix <= lines( details ).
            "There won't be a type for class/interface methods
            /cadaxo/cl_sqlc_abap_parser=>get_typing_text(
              EXPORTING
                p_details  = details
                p_begin    = l_tabix
                p_fullname = fullname
              IMPORTING
                p_text     = l_type
            ).
          ENDIF.
          <wa_struc>-ttype = l_type.
          CLEAR l_shorttext.
          lcl_short_text=>get_text(
            EXPORTING fullname  = <wa_detail>-fullname
            IMPORTING shorttext = l_shorttext ).
          <wa_struc>-tdesc = l_shorttext.
        ENDIF.
      ENDLOOP.
*      CLEAR l_maintype.
    ELSE.
      ASSIGN details[ l_tabix ] TO <wa_detail>.
      IF sy-subrc = 0.
        if l_tabix < lines( details ).
          ADD 1 TO l_tabix. " type description starts at next position, else elementary type
        endif.
****Get the full Typing
        /cadaxo/cl_sqlc_abap_parser=>get_typing_text(
          EXPORTING
            p_details  = details
            p_begin    = l_tabix
            p_fullname = fullname
          IMPORTING
            p_text     = l_maintype ).

        CLEAR l_shorttext.
        lcl_short_text=>get_text(
          EXPORTING fullname  = <wa_detail>-fullname
          IMPORTING shorttext = l_shorttext ).
        type1_desc = l_shorttext.
      ENDIF.
    ENDIF.


    IF l_temp_text IS INITIAL.
      final_text = type1_desc.
      CLEAR type1_desc.
    ELSE.
      final_text =  l_temp_text.
    ENDIF.

    atl = NEW #( ).
    TRY.
        DATA(source) = atl->ATL_FIELD(
            field_name = field_name
            role_text  = role_text
            short_text = final_text
            main_type  = l_maintype
            struc_comp = struc_comp
            struc_ovr  = struc_ovr ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

    lcl_enhanced_quick_info=>convert_source_to_help_txt(
       EXPORTING
          source = source
       CHANGING
          help_text = help_text ).
  ENDMETHOD.                    "type_formatting

  METHOD event_formatting.
    data(role_text)  = /cadaxo/cl_sqlc_abap_parser=>get_role_text( role = compl_item-role ).
    data(event_name) = CONV string( compl_item-identifier ).

    /cadaxo/cl_sqlc_abap_parser=>parse_method_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
      IMPORTING
        exporting_parameters = data(exporting_parameters) ).

    atl = NEW #( ).
    TRY.
        DATA(source) = atl->ATL_EVENT(
            event_name           = event_name
            role_text            = role_text
            exporting_parameters = exporting_parameters
            short_text           = shorttext ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

    lcl_enhanced_quick_info=>convert_source_to_help_txt(
       EXPORTING
          source = source
       CHANGING
          help_text = help_text ).

  ENDMETHOD.                    "event_formatting

  METHOD form_formatting.
    data(role_text) = /cadaxo/cl_sqlc_abap_parser=>get_role_text( role = compl_item-role ).
    data(form_name) = CONV string( compl_item-identifier ).

    /cadaxo/cl_sqlc_abap_parser=>parse_form_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
      IMPORTING
        using_parameters     = data(using_parameters)
        changing_parameters  = data(changing_parameters)
        tables_parameters    = data(tables_parameters)
        exceptions_list      = data(exceptions_list)
        class_exceptions     = data(class_exceptions) ).

    atl = NEW #( ).
    TRY.
        DATA(source) = atl->ATL_FORM(
            form_name           = form_name
            role_text           = role_text
            using_parameters    = using_parameters
            changing_parameters = changing_parameters
            tables_parameters   = tables_parameters
            exceptions_list     = exceptions_list
            class_exceptions    = class_exceptions ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

    lcl_enhanced_quick_info=>convert_source_to_help_txt(
       EXPORTING
          source = source
       CHANGING
          help_text = help_text ).

  ENDMETHOD.                    "form_formatting

  METHOD function_formatting.
    data(role_text)     = /cadaxo/cl_sqlc_abap_parser=>get_role_text( role = compl_item-role ).
    data(function_name) = CONV string( compl_item-identifier ).

    /cadaxo/cl_sqlc_abap_parser=>parse_function_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
      IMPORTING
        importing_parameters = data(importing_parameters)
        exporting_parameters = data(exporting_parameters)
        changing_parameters  = data(changing_parameters)
        table_parameters     = data(table_parameters)
        exceptions_list      = data(exceptions_list)
        class_exceptions     = data(class_exceptions) ).

    atl = NEW #( ).
    TRY.
        DATA(source) = atl->ATL_FUNCTION(
            function_name        = function_name
            role_text            = role_text
            importing_parameters = importing_parameters
            exporting_parameters = exporting_parameters
            changing_parameters  = changing_parameters
            table_parameters     = table_parameters
            exceptions_list      = exceptions_list
            short_text           = shorttext
            class_exceptions     = class_exceptions ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

    lcl_enhanced_quick_info=>convert_source_to_help_txt(
       EXPORTING
          source = source
       CHANGING
          help_text = help_text ).
  ENDMETHOD.                    "function_formatting

  METHOD exception_formatting.
    data(role_text) = /cadaxo/cl_sqlc_abap_parser=>get_role_text( role = compl_item-role ).
    data(exception_name) = CONV string( compl_item-identifier ).

    /cadaxo/cl_sqlc_abap_parser=>parse_function_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
      IMPORTING
        importing_parameters = data(importing_parameters) ).

    atl = NEW #( ).
    TRY.
        DATA(source) = atl->ATL_EXCEPTION(
            exception_name       = exception_name
            role_text            = role_text
            importing_parameters = importing_parameters
            short_text           = shorttext ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

    lcl_enhanced_quick_info=>convert_source_to_help_txt(
       EXPORTING
          source = source
       CHANGING
          help_text = help_text ).
  ENDMETHOD.                    "exception_formatting

  METHOD db_procedure_formatting.
    data(role_text)     = /cadaxo/cl_sqlc_abap_parser=>get_role_text( role = compl_item-role ).
    data(dbproc_name) = CONV string( compl_item-identifier ).

    /cadaxo/cl_sqlc_abap_parser=>parse_function_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
      IMPORTING
        importing_parameters = data(importing_parameters)
        exporting_parameters = data(exporting_parameters)
        exceptions_list      = data(exceptions_list)
        class_exceptions     = data(class_exceptions) ).

    atl = NEW #( ).
    TRY.
        DATA(source) = atl->atl_db_procedure(
            dbprocedure_name     = dbproc_name
            role_text            = role_text
            importing_parameters = importing_parameters
            exporting_parameters = exporting_parameters
            exceptions_list      = exceptions_list
            short_text           = shorttext
            class_exceptions     = class_exceptions ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

    lcl_enhanced_quick_info=>convert_source_to_help_txt(
       EXPORTING
          source = source
       CHANGING
          help_text = help_text ).
  ENDMETHOD.                    "db_procedure_formatting

  METHOD keyword_formatting.
    data(role_text)  = CONV string( 'ABAP Keyword:'(t02) ).
    data(short_text) = cl_abap_docu_short_ref=>get_short_text( compl_item-identifier ).
    READ TABLE short_text INTO data(wa_short_text) INDEX 1.
    IF wa_short_text-text IS INITIAL.
      help_text = |{ help_text }\\b{ role_text }\\b0 { compl_item-identifier }\n|.
    ELSE.
      help_text = |{ help_text }\\b{ role_text }\\b0 { wa_short_text-keyword }\n| &
                  |{ wa_short_text-text }|.
    ENDIF.
  ENDMETHOD.                    "keyword_formatting

  METHOD convert_source_to_help_txt.
    LOOP AT source ASSIGNING field-symbol(<wa_source>).
      help_text = |{ help_text }{ <wa_source> }\n|.
    ENDLOOP.
  ENDMETHOD.                    "convert_source_to_help_txt

ENDCLASS.                    "lcl_enhanced_quick_info IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_enhanced_code_insertion IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_enhanced_code_insertion IMPLEMENTATION.

  METHOD get_insertion_string.
*   get details from symbol table
    /cadaxo/cl_sqlc_abap_parser=>get_completion_details(
    EXPORTING
      kind        = datatype
      identifier  = patternkey
      maxgrade    = 3             " 2nd Level Needed to get Constants
    IMPORTING
      fullname    = data(fullname)
      shorttext   = data(shorttext)
      pattern     = sycontext
      depentities = data(l_details) ).

*   get short text according fullname
    lcl_short_text=>get_text(
      EXPORTING fullname  = fullname
      IMPORTING shorttext = data(l_shorttext) ).
    shorttext = l_shorttext.

*   identifiers are passed in upper case from kernel
    data(l_patternkey) = patternkey.
    IF sycontext <> sccmp_cxt_call_function and
       datatype  <> sccmp_cat_keyword       and
       settings-identifier_lower_case = abap_true.
      TRANSLATE l_patternkey TO LOWER CASE.
    ENDIF.

    DATA method_name TYPE string.
    CASE sycontext.
      WHEN sccmp_cxt_create_object OR
           sccmp_cxt_create_new_object.
        method_name = 'METHOD_FORMATTING'.
      WHEN sccmp_cxt_create_new OR
           sccmp_cxt_create_value.
        method_name = 'VALUE_FORMATTING'.
      WHEN sccmp_cxt_call_meth_stat_long OR
           sccmp_cxt_call_meth_stat_short OR
           sccmp_cxt_call_meth_dyna OR
           sccmp_cxt_call_meth_func.
        IF datatype = sccmp_cat_method.
          method_name = 'METHOD_FORMATTING'.
        ENDIF.
      WHEN sccmp_cxt_raise_event.
        method_name = 'EVENT_FORMATTING'.
      WHEN sccmp_cxt_raise_exception.
        method_name = 'EXCEPTION_FORMATTING'.
      WHEN sccmp_cxt_call_function.
        method_name = 'FUNCTION_FORMATTING'.
      WHEN sccmp_cxt_perform.
        method_name = 'FORM_FORMATTING'.
      WHEN sccmp_cxt_call_db_procedure.
        method_name = 'DB_PROCEDURE_FORMATTING'.
      WHEN OTHERS.
        CLEAR method_name.
    ENDCASE.

    IF method_name IS INITIAL.
      APPEND INITIAL LINE TO compl_text ASSIGNING field-symbol(<wa_text>).
      <wa_text> = l_patternkey.
    ELSE.
      TRY.
          CALL METHOD lcl_enhanced_code_insertion=>(method_name)
            EXPORTING
              call_type  = sycontext
              datatype   = datatype
              patternkey = l_patternkey
              shorttext  = shorttext
              fullname   = fullname
              beg_xpos   = beg_xpos
              details    = l_details
              settings   = settings
            CHANGING
              compl_text = compl_text.
        CATCH cx_sy_dyn_call_error.                      "#EC NO_HANDLER
      ENDTRY.
    ENDIF.

  ENDMETHOD.                    "get_insertion_string

  METHOD method_formatting.
    /cadaxo/cl_sqlc_abap_parser=>parse_method_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
        settings             = settings
      IMPORTING
        importing_parameters = data(importing_parameters)
        exporting_parameters = data(exporting_parameters)
        changing_parameters  = data(changing_parameters)
        returning_parameters = data(returning_parameters)
        exceptions_list      = data(exceptions_list)
        class_exceptions     = data(class_exceptions) ).

    DATA: atl        TYPE REF TO CL_ABAP_CC_ATL_TEMPLATES,
          method     TYPE string,
          short_form TYPE abap_bool,
          stmtend    type string value `.`.

    CASE call_type.
      WHEN sccmp_cxt_call_meth_stat_short.
        method     = 'ATL_BASIC_METHOD'.
        short_form = abap_true.
      WHEN  sccmp_cxt_call_meth_dyna.
        method     = 'ATL_BASIC_METHOD'.
        short_form = abap_false.
      WHEN  sccmp_cxt_call_meth_func OR
            sccmp_cxt_create_new_object.
        method     = 'ATL_FUNC_METHOD'.
        short_form = abap_true.
        stmtend    = ``.
      WHEN  sccmp_cxt_call_meth_stat_long.
        method     = 'ATL_BASIC_METHOD'.
        short_form = abap_false.
      WHEN OTHERS. " CREATE OBJECT
        method     = 'ATL_BASIC_METHOD'.
        short_form = abap_false.
    ENDCASE.


    atl = NEW #( ).
    TRY.
        CALL METHOD atl->(method)
          EXPORTING
            method_name          = patternkey
            importing_parameters = importing_parameters
            exporting_parameters = exporting_parameters
            changing_parameters  = changing_parameters
            returning_parameters = returning_parameters
            beg_xpos             = beg_xpos
            exceptions_list      = exceptions_list
            class_exceptions     = class_exceptions
            short_form           = short_form
            stmtend              = stmtend
          RECEIVING
            r_source             = compl_text.
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

  ENDMETHOD.                    "method_formatting

  METHOD event_formatting.
    /cadaxo/cl_sqlc_abap_parser=>parse_method_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
        settings             = settings
      IMPORTING
        exporting_parameters = data(exporting_parameters)
    ).

    TRY.
        compl_text = NEW CL_ABAP_CC_ATL_TEMPLATES( )->ATL_RAISE_EVENT(
            event_name           = patternkey
            exporting_parameters = exporting_parameters
            beg_xpos             = beg_xpos ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

  ENDMETHOD.                    "event_formatting

  METHOD form_formatting.
    /cadaxo/cl_sqlc_abap_parser=>parse_form_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
        settings             = settings
      IMPORTING
        using_parameters     = data(using_parameters)
        changing_parameters  = data(changing_parameters)
        tables_parameters    = data(tables_parameters)
        exceptions_list      = data(exceptions_list)
        class_exceptions     = data(class_exceptions) ).

    TRY.
        compl_text = NEW CL_ABAP_CC_ATL_TEMPLATES( )->ATL_FORM(
            form_name           = patternkey
            using_parameters    = using_parameters
            changing_parameters = changing_parameters
            tables_parameters   = tables_parameters
            beg_xpos            = beg_xpos
            exceptions_list     = exceptions_list
            class_exceptions    = class_exceptions ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

  ENDMETHOD.                    "form_formatting

  METHOD function_formatting.
    /cadaxo/cl_sqlc_abap_parser=>parse_function_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
        settings             = settings
      IMPORTING
        importing_parameters = data(importing_parameters)
        exporting_parameters = data(exporting_parameters)
        changing_parameters  = data(changing_parameters)
        table_parameters     = data(table_parameters)
        exceptions_list      = data(exceptions_list)
        class_exceptions     = data(class_exceptions) ).

    TRY.
        compl_text = NEW CL_ABAP_CC_ATL_TEMPLATES( )->ATL_FUNCTION(
            function_name        = patternkey
            importing_parameters = importing_parameters
            exporting_parameters = exporting_parameters
            changing_parameters  = changing_parameters
            table_parameters     = table_parameters
            beg_xpos             = beg_xpos
            exceptions_list      = exceptions_list
            class_exceptions     = class_exceptions ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

  ENDMETHOD.                    "function_formatting

  METHOD exception_formatting.
    /cadaxo/cl_sqlc_abap_parser=>parse_method_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
        settings             = settings
      IMPORTING
        importing_parameters = data(importing_parameters) ).

    TRY.
        compl_text = NEW CL_ABAP_CC_ATL_TEMPLATES( )->ATL_RAISE_EXCEPTION(
            exception_name       = patternkey
            importing_parameters = importing_parameters
            beg_xpos             = beg_xpos ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

  ENDMETHOD.                    "exception_formatting

  METHOD value_formatting.

    DATA: components TYPE if_abap_cc_atl_types=>comp_list,
          wa         LIKE LINE OF components,
          max_length TYPE i,
          l_length   TYPE i.

    LOOP AT details ASSIGNING FIELD-SYMBOL(<wa_detail>) WHERE grade = 1.
      CHECK <wa_detail>-role = sccmp_role_component.
      wa-name = <wa_detail>-identifier.
      IF wa-name CP '!*'.
        SHIFT wa-name BY 1 PLACES LEFT IN CHARACTER MODE.
      ENDIF.
      conv_ident_case wa-name.
      set_max_length max_length wa-name.
      APPEND wa TO components.
    ENDLOOP.

    LOOP AT components ASSIGNING FIELD-SYMBOL(<wa_comp>).
      set_spacer <wa_comp> max_length.
    ENDLOOP.

    TRY.
        compl_text = NEW CL_ABAP_CC_ATL_TEMPLATES( )->ATL_VALUE_STRUCT(
            struct_name = patternkey
            comp_list   = components
            beg_xpos    = beg_xpos ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

  ENDMETHOD.                    "value_formatting

  METHOD db_procedure_formatting.
    /cadaxo/cl_sqlc_abap_parser=>parse_function_parameters(
      EXPORTING
        fullname             = fullname
        details              = details
        settings             = settings
      IMPORTING
        importing_parameters = data(importing_parameters)
        exporting_parameters = data(exporting_parameters)
        exceptions_list      = data(exceptions_list)
        class_exceptions     = data(class_exceptions) ).

    TRY.
        compl_text = NEW CL_ABAP_CC_ATL_TEMPLATES( )->atl_db_procedure(
            dbprocedure_name     = patternkey
            importing_parameters = importing_parameters
            exporting_parameters = exporting_parameters
            beg_xpos             = beg_xpos
            exceptions_list      = exceptions_list
            class_exceptions     = class_exceptions ).
      CATCH cx_abap_template_parse_error INTO data(ref).
        MESSAGE ref TYPE 'I'.
    ENDTRY.

  ENDMETHOD.                    "db_procedure_formatting

ENDCLASS.                    "lcl_enhanced_code_insertion IMPLEMENTATION
