FUNCTION /cadaxo/sqlc_cds_view_display.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_DDLNAME) TYPE  DDLNAME
*"     REFERENCE(I_COL) TYPE  I OPTIONAL
*"     REFERENCE(I_ROW) TYPE  I OPTIONAL
*"----------------------------------------------------------------------

  DATA lr_handler TYPE REF TO cl_dd_ddl_handler.
  DATA lr_meta TYPE REF TO cl_dd_ddl_view_def.
  DATA lr_sobject TYPE REF TO if_dd_sobject.
  DATA lt_sobjnames TYPE if_dd_sobject_types=>ty_t_sobjnames.
  DATA l_strucobjname TYPE ddstrucobjname.
  DATA l_from_row TYPE i.
  DATA l_to_row TYPE i.
  DATA lt_ddnames TYPE if_dd_ddl_types=>ty_t_ddobj.
  DATA ls_ddnames TYPE if_dd_ddl_types=>ty_s_ddobj.
  DATA lt_entity TYPE if_dd_ddl_types=>ty_t_entity_of_view.
  DATA lt_dd02bv_tab_r_n TYPE dd02bvtab.
  DATA lt_dd02bndv_tab_r_n TYPE dd02bndvtab.
  DATA lr_object TYPE REF TO cl_wb_object.
  DATA lr_adt_objref TYPE REF TO cl_adt_object_reference.

  CLEAR lt_ddnames.
  ls_ddnames-name = i_ddlname.
  APPEND ls_ddnames TO lt_ddnames.

  TRY.
      lr_handler ?= cl_dd_ddl_handler_factory=>create( ).

      lr_handler->if_dd_ddl_handler~get_viewname_from_entityname( EXPORTING ddnames = lt_ddnames
                                                                  IMPORTING view_of_entity = lt_entity ).

      g_ddlname = lt_entity[ 1 ]-ddlname.

      lr_handler->if_dd_ddl_handler~get_ddl_content_object_names(
        EXPORTING
          ddlname        = g_ddlname
        IMPORTING
          viewname       = g_viewname
          entityname     = g_entityname ).

      lr_handler->if_dd_ddl_handler~read(
        EXPORTING
          name         = g_ddlname
          get_state    = 'M'
          withtext     = abap_true
          langu        = sy-langu
        IMPORTING
          ddddlsrcv_wa = gs_ddddlsrcv ).

      lr_sobject = cl_dd_sobject_factory=>create( ).
      APPEND g_entityname TO lt_sobjnames.

      lr_sobject->read(
        EXPORTING
          get_state      = 'M'
          sobjnames      = lt_sobjnames
        IMPORTING
          dd02bv_tab     = lt_dd02bv_tab_r_n
          dd02bndv_tab   = lt_dd02bndv_tab_r_n ).

      TRY.
          g_with_parameters = lt_dd02bndv_tab_r_n[ 1 ]-with_parameters.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      lr_object = cl_wb_object=>create_from_transport_key( p_object = 'DDLS' p_obj_name = CONV #( g_ddlname ) ).
      lr_adt_objref = cl_adt_tools_core_factory=>get_instance( )->get_uri_mapper( )->map_wb_object_to_objref( lr_object ).
      g_adt_link = |{ 'adt://' }{ to_lower( sy-sysid ) }{ lr_adt_objref->ref_data-uri }|.

      l_from_row = i_row + 3.
      l_to_row   = i_row + 20.

      IF l_from_row < 5.
        l_from_row = 5.
        l_to_row   = 22.
      ENDIF.

      CALL SCREEN 0100 STARTING AT 5 l_from_row ENDING AT 149 l_to_row.
    CATCH: cx_dd_sobject_get, cx_dd_ddl_read.
  ENDTRY.
ENDFUNCTION.
