CLASS /cadaxo/cl_sqlc_join_complet DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_res,
        tabname TYPE tabname,
        ddtext  TYPE as4text,
        nr      TYPE bu_partner,
      END OF t_res .
    TYPES:
      BEGIN OF t_text,
        text TYPE /cadaxo/sqlcsql_string,
        nr   TYPE bu_partner,
      END OF t_text .
    TYPES:
      BEGIN OF t_as,
        tabname TYPE tabname,
        as      TYPE tabname,
      END OF t_as .
    TYPES: tty_res  TYPE TABLE OF t_res .
    TYPES: tty_text TYPE TABLE OF t_text .
    TYPES: tty_as   TYPE TABLE OF t_as .
    TYPES: tty_sqlclog TYPE TABLE OF /cadaxo/sqlclog .


    DATA gt_seltable TYPE /cadaxo/sqlcjcres_ty .
    DATA go_abap_editor TYPE REF TO /cadaxo/cl_sqlc_gui_abapedit .
    DATA gs_selstruc TYPE /cadaxo/sqlcjcres .
    DATA gt_sqlclog TYPE tty_sqlclog .
    DATA table_descriptions TYPE SORTED TABLE OF dd02t WITH UNIQUE DEFAULT KEY.
    DATA gt_astable TYPE tty_as .
    DATA gr_top_alv_grid TYPE REF TO cl_gui_alv_grid .
    DATA gt_res_fcat TYPE lvc_t_fcat .
    DATA go_container TYPE REF TO cl_gui_custom_container .
    DATA go_splitter TYPE REF TO cl_gui_splitter_container .
    DATA gr_bottom_alv_grid TYPE REF TO cl_gui_alv_grid .
    DATA gt_text_fcat TYPE lvc_t_fcat .
    DATA gt_res TYPE /cadaxo/sqlcjcres_ty .
    DATA gt_text TYPE /cadaxo/sqlcjctext_ty .
    DATA gv_result TYPE string .
    DATA gv_join_table TYPE string .
    DATA gv_join_type TYPE string .
    DATA gt_sqlcjche TYPE /cadaxo/sqlcjche_ty .
    DATA gt_sqlcjcpo TYPE /cadaxo/sqlcjcpo_ty .
    DATA gt_parsed_table TYPE /cadaxo/sqlccodeline_t .
    DATA gv_refresh TYPE abap_bool .

    METHODS cc_join
      EXPORTING
        !e_res TYPE /cadaxo/sqlcjcres_ty .
    METHODS cc_on
      IMPORTING
        !i_res  TYPE /cadaxo/sqlcjcres OPTIONAL
      EXPORTING
        !e_text TYPE /cadaxo/sqlcjctext_ty .
    METHODS constructor
      IMPORTING
        !o_abapedit TYPE REF TO /cadaxo/cl_sqlc_gui_abapedit OPTIONAL .
    METHODS disassemble_sql .
    METHODS pbo_0100 .
    METHODS create_alv_controls .
    METHODS handle_double_click_top
          FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
          !e_row
          !e_column
          !es_row_no .
    METHODS cc_join_f4
      EXPORTING
        !e_string TYPE string .
    METHODS cc_on_f4
      EXPORTING
        !e_string TYPE string .
    METHODS append_table_seltable
      IMPORTING
        !i_tabname TYPE tabname .
    METHODS handle_double_click_bottom
          FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
          !e_row
          !e_column
          !es_row_no .
    METHODS delete_globals .
    METHODS cc_join_db
      EXPORTING
        !e_res TYPE /cadaxo/sqlcjcres_ty .
    METHODS calculate_position
      EXPORTING
        !e_res TYPE /cadaxo/sqlcjcres_ty .
  PROTECTED SECTION.

    METHODS build_fcat .
    METHODS tables_from_editor .
    METHODS tables_from_db .
    METHODS cc_as .
    METHODS fill_db_tables
      IMPORTING
        !it_head TYPE /cadaxo/sqlcjche_t
        !it_item TYPE /cadaxo/sqlcjcpo_t .
    METHODS build_layout
      RETURNING
        VALUE(rs_layout) TYPE lvc_s_layo .
    METHODS get_join_type
      IMPORTING
        !iv_join_type TYPE rsddbjointp
      RETURNING
        VALUE(rv_res) TYPE string .
    METHODS set_join_type
      IMPORTING
        !iv_res             TYPE string
      RETURNING
        VALUE(rv_join_type) TYPE rsddbjointp .
    METHODS calculate_top
      EXPORTING
        !e_expr1 TYPE string
        !e_expr2 TYPE string .
    METHODS calculate_bottom
      EXPORTING
        !e_text TYPE /cadaxo/sqlcjctext_ty .
    EVENTS double_click .
    METHODS get_table_description IMPORTING i_table_name         TYPE tabname
                                  RETURNING VALUE(e_description) TYPE as4text.
  PRIVATE SECTION.
    DATA: last_table TYPE /cadaxo/sqlccodeline.
ENDCLASS.



CLASS /cadaxo/cl_sqlc_join_complet IMPLEMENTATION.


  METHOD append_table_seltable.
    DATA: ls_res TYPE /cadaxo/sqlcjcres.

    IF lines( gt_seltable ) NE 2.
      ls_res-tabname = i_tabname.
      APPEND ls_res TO gt_seltable.
    ELSE.
      gt_seltable[ 2 ]-tabname = i_tabname.
    ENDIF.

  ENDMETHOD.


  METHOD build_fcat.

    "Initialize fieldcats
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = '/CADAXO/SQLCJCRES'
      CHANGING
        ct_fieldcat            = gt_res_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = '/CADAXO/SQLCJCTEXT'
      CHANGING
        ct_fieldcat            = gt_text_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    gt_text_fcat[ 1 ]-no_out = abap_true.
    gt_res_fcat[ 1 ]-no_out  = abap_true.
    gt_res_fcat[ 2 ]-no_out  = abap_true.
    gt_text_fcat[ 2 ]-outputlen = '000100'.
    gt_res_fcat[ 2 ]-outputlen  = '000010'.

  ENDMETHOD.


  METHOD build_layout.

    rs_layout-no_toolbar = abap_true.
    rs_layout-zebra = abap_true.

  ENDMETHOD.


  METHOD calculate_bottom.

    .

    IF lines( gt_parsed_table ) > 1.
      IF last_table IS NOT INITIAL
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'JOIN'.
        cc_on( IMPORTING e_text = gt_text ).
      ENDIF.
    ENDIF.

    IF lines( gt_parsed_table ) > 3.
      IF  to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 3 ] ) = 'JOIN' "5
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'AS'.
        cc_on( IMPORTING e_text = gt_text ).
      ENDIF.
    ENDIF.

    IF to_upper( gt_parsed_table[ lines( gt_parsed_table ) ] ) EQ 'ON'. "6.
      cc_on( IMPORTING e_text = gt_text ).
    ENDIF.

    e_text = gt_text.

  ENDMETHOD.

  METHOD get_table_description.

    IF NOT line_exists( table_descriptions[ tabname = i_table_name ] ).
      SELECT SINGLE tabname, ddtext
             FROM dd02t
             WHERE tabname    = @i_table_name
               AND ddlanguage = @sy-langu
             INTO @DATA(table_descr).
      IF sy-subrc <> 0.
        INSERT VALUE #( tabname = i_table_name ) INTO TABLE table_descriptions.
      ELSE.
        IF table_descr-ddtext IS INITIAL.
          INSERT VALUE #( tabname = i_table_name ddtext = i_table_name ) INTO TABLE table_descriptions.
        ELSE.
          INSERT CORRESPONDING #( table_descr ) INTO TABLE table_descriptions.
        ENDIF.
      ENDIF.
    ENDIF.
    e_description = table_descriptions[ tabname = i_table_name ]-ddtext.

  ENDMETHOD.




  METHOD calculate_position.

    IF lines( gt_parsed_table ) > 1.
      IF last_table IS NOT INITIAL
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'FROM'.
        cc_join_db( IMPORTING e_res = gt_res ).
      ENDIF.
    ENDIF.

    IF lines( gt_parsed_table ) > 3.
      IF  to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 3 ] ) = 'FROM' "2
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'AS'.
        cc_join_db( IMPORTING e_res = gt_res ).
      ENDIF.
    ENDIF.

    IF lines( gt_parsed_table ) > 1.
      IF to_upper( gt_parsed_table[ lines( gt_parsed_table ) ] ) = 'JOIN'. "3.
        cc_join_db( IMPORTING e_res = gt_res ).
      ENDIF.
    ENDIF.

    e_res = gt_res.

  ENDMETHOD.


  METHOD calculate_top.

    IF lines( gt_parsed_table ) > 1.
      IF last_table IS NOT INITIAL
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'JOIN'.
        e_expr1 = abap_true.
      ENDIF.
    ENDIF.

    IF lines( gt_parsed_table ) > 3.
      IF  to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 3 ] ) = 'JOIN' "2
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'AS'.
        e_expr2 = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD cc_as.
    DATA: lt_codetab    TYPE /cadaxo/sqlccodeline_t.
    DATA: l_str         TYPE string.

    "Get SQL query text from Editor
    go_abap_editor->get_text( IMPORTING table   = lt_codetab
                              EXCEPTIONS OTHERS = 1 ).
    "Split the SQL query into an internal table
    CLEAR: l_str.
    LOOP AT lt_codetab INTO DATA(code).
      CONDENSE code.
      CONCATENATE l_str code INTO l_str SEPARATED BY space.
    ENDLOOP.
    SPLIT l_str AT space INTO TABLE DATA(lt_table).
    "Copy the table name from the SQL query into an internal table
    LOOP AT lt_table INTO DATA(ls_table).
      DATA(tabix) = sy-tabix.
      IF ( to_upper( ls_table ) EQ 'AS')
      AND tabix < lines( lt_table ).
        APPEND VALUE #( tabname = to_upper( lt_table[ tabix - 1 ] ) as = to_upper( lt_table[ tabix + 1 ] ) ) TO gt_astable.
      ENDIF.
      IF  to_upper( ls_table )              EQ '('
      AND to_upper( lt_table[ tabix + 1 ] ) EQ 'SELECT'
      AND tabix < lines( lt_table ).
        CLEAR gt_astable.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD cc_join.
    DATA: l_xml         TYPE string.
    DATA: lv_tmp        TYPE string.
    DATA: l_sqllog_xml  TYPE /cadaxo/sqlc_sqllog.
    DATA: lt_strtable   TYPE TABLE OF string.
    DATA: lt_restable	  TYPE /cadaxo/sqlcjcres_ty.
    DATA: ls_resstruc	  TYPE /cadaxo/sqlcjcres.

    "Select the SQL querys from DB table
    LOOP AT gt_sqlclog ASSIGNING FIELD-SYMBOL(<fs_sqlclog>).
      cl_abap_gzip=>decompress_text( EXPORTING gzip_in = <fs_sqlclog>-sql_log
                                     IMPORTING text_out = l_xml ).
      CALL TRANSFORMATION id
         SOURCE XML l_xml
         RESULT log = l_sqllog_xml.
      "Check if the tables are part of the history line
      LOOP AT gt_seltable ASSIGNING FIELD-SYMBOL(<fs_selstruc>).
        CHECK l_sqllog_xml-sql_string CS <fs_selstruc>-tabname.
        CLEAR: lt_strtable.
        l_sqllog_xml-sql_string = to_upper( l_sqllog_xml-sql_string ).
        SPLIT l_sqllog_xml-sql_string AT space INTO TABLE lt_strtable.
        LOOP AT lt_strtable INTO DATA(l_strtable).
          DATA(tab) = sy-tabix.
          IF ( l_strtable EQ 'FROM'
          OR   l_strtable EQ 'JOIN')
          AND tab < lines( lt_strtable ).
            CLEAR ls_resstruc.
            ls_resstruc-tabname = lt_strtable[ tab + 1 ].
            lv_tmp = ls_resstruc-tabname.
            REPLACE ALL OCCURRENCES OF REGEX '[^[:print:]]+$' IN lv_tmp WITH '' IGNORING CASE.
            ls_resstruc-tabname = lv_tmp.
            IF line_exists( lt_restable[ tabname = ls_resstruc-tabname ] ).
              lt_restable[ tabname = ls_resstruc-tabname ]-nr
              = lt_restable[ tabname = ls_resstruc-tabname ]-nr + 1.
            ELSE.
              CHECK ls_resstruc-tabname IS NOT INITIAL.
              READ TABLE gt_seltable WITH KEY tabname = ls_resstruc-tabname TRANSPORTING NO FIELDS.
              IF  sy-subrc NE 0 OR gv_join_table EQ ls_resstruc-tabname.
                "Check if table name exists in case of SELECT chains
                cl_abap_structdescr=>describe_by_name(
                   EXPORTING
                     p_name = ls_resstruc-tabname
                   EXCEPTIONS
                     OTHERS = 1 ).
                IF sy-subrc = 0.
                  DATA(lv_join_type) = VALUE #( me->gt_sqlcjche[ left_table = <fs_selstruc>-tabname joined_table = ls_resstruc-tabname ]-join_type DEFAULT 0 ) .
                  APPEND VALUE #( join_type = lv_join_type tabname = ls_resstruc-tabname nr = 1
                                  ddtext = get_table_description( ls_resstruc-tabname ) ) TO lt_restable.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
    SORT lt_restable BY nr DESCENDING.

    e_res = lt_restable.

  ENDMETHOD.


  METHOD cc_join_db.
    DATA: lt_strtable   TYPE TABLE OF string.
    DATA: lt_restable	  TYPE /cadaxo/sqlcjcres_ty.
    DATA: lv_res        TYPE string.

    LOOP AT gt_sqlcjche INTO DATA(gs_sqlcjche).

      "Check if the tables are part of the history line
      LOOP AT gt_seltable ASSIGNING FIELD-SYMBOL(<fs_selstruc>).
        CHECK gs_sqlcjche-left_table = <fs_selstruc>-tabname.
        CLEAR: lt_strtable.
        gs_sqlcjche-joined_table = to_upper( gs_sqlcjche-joined_table ).

        APPEND VALUE #( guid_header = gs_sqlcjche-guid_header join_type = gs_sqlcjche-join_type
        join_name = get_join_type( gs_sqlcjche-join_type ) tabname = gs_sqlcjche-joined_table nr = gs_sqlcjche-cnt
        ddtext = get_table_description( gs_sqlcjche-joined_table ) ) TO lt_restable.

      ENDLOOP.
    ENDLOOP.
    SORT lt_restable BY nr DESCENDING.

    "Filter Inner Join, Left/Right (Outer) Join
    IF lines( me->gt_parsed_table ) > 2
    AND to_upper( me->gt_parsed_table[ lines( me->gt_parsed_table ) ] ) EQ 'JOIN'.
      DATA(i) = 0.
      DO 3 TIMES.
        DATA(lv_exp) = to_upper( me->gt_parsed_table[ lines( me->gt_parsed_table )  - i ] ).
        CASE lv_exp.
          WHEN 'INNER' OR 'OUTER' OR 'JOIN' OR 'LEFT' OR 'RIGHT'.
            CONCATENATE lv_exp lv_res INTO lv_res SEPARATED BY space.
          WHEN OTHERS.
        ENDCASE.
        i = i + 1.
      ENDDO.
      "Delete from internal table the wrong types
      CONDENSE lv_res.
      DATA(lv_type) = set_join_type( iv_res = lv_res ).
      DELETE lt_restable WHERE join_type NE lv_type.
    ENDIF.

    e_res = lt_restable.

  ENDMETHOD.


  METHOD cc_join_f4.

    DATA: lt_ddshretval TYPE TABLE OF ddshretval.
    DATA: lt_res        TYPE /cadaxo/sqlcjcres_ty.
    me->cc_join(
      IMPORTING
        e_res = lt_res    " SQL Cockpit - Join Completion - Res
    ).

    "Insert the selected table into SQL Editor
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'TABNAME'
        window_title    = 'JOIN Code Completion'
        dynpprog        = sy-repid
        dynpnr          = '1000'
        dynprofield     = 'TABNAME'
        value_org       = 'S'
      TABLES
        value_tab       = lt_res
        return_tab      = lt_ddshretval
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF  sy-subrc        EQ 0
    AND lt_ddshretval[] IS NOT INITIAL.
*      e_string = CONV string( lt_ddshretval[ 1 ]-fieldval ).
      e_string = lt_ddshretval[ 1 ]-fieldval.
    ENDIF.

  ENDMETHOD.


  METHOD cc_on.
    DATA: lt_ddshretval TYPE TABLE OF ddshretval.
    DATA: lt_restable	  TYPE /cadaxo/sqlcjctext_ty. "test
    DATA: lv_str        TYPE string.

    me->cc_as( ).

    CHECK lines( gt_seltable ) > 1.

    DATA(tabnamen_1) = gt_seltable[ lines( gt_seltable ) - 1 ]-tabname.
    DATA(tabnamen)   = gt_seltable[ lines( gt_seltable ) ]-tabname.

    IF i_res IS INITIAL.
      SELECT * FROM /cadaxo/sqlcjche INTO TABLE @DATA(lt_jche)
        WHERE left_table   = @tabnamen_1
        AND   joined_table = @tabnamen.
    ELSE.
      SELECT * FROM /cadaxo/sqlcjche INTO TABLE @lt_jche
      WHERE guid_header  = @i_res-guid_header.
    ENDIF.
    IF lt_jche IS NOT INITIAL.
      LOOP AT lt_jche ASSIGNING FIELD-SYMBOL(<fs_jche>).
        SELECT * FROM /cadaxo/sqlcjcpo
          WHERE guid_header = @<fs_jche>-guid_header
          INTO TABLE @DATA(lt_jcpo).
        CLEAR: lv_str.
        IF lt_jcpo IS NOT INITIAL.
          LOOP AT lt_jcpo ASSIGNING FIELD-SYMBOL(<fs_jcpo>).
            IF gt_astable IS NOT INITIAL.
              DATA(lv_asa) = VALUE #( gt_astable[ tabname = <fs_jche>-left_table ]-as OPTIONAL ) .
              DATA(lv_asb) = VALUE #( gt_astable[ tabname = <fs_jche>-joined_table ]-as OPTIONAL ) .
            ENDIF.
            IF lv_asa IS NOT INITIAL.
              DATA(lv_parta) = lv_asa && '~' && <fs_jcpo>-left_field.
            ELSE.
              lv_parta = <fs_jche>-left_table   && '~' && <fs_jcpo>-left_field.
            ENDIF.
            IF lv_asb IS NOT INITIAL.
              DATA(lv_partb) = lv_asb && '~' && <fs_jcpo>-joined_field.
            ELSE.
              lv_partb = <fs_jche>-joined_table && '~' && <fs_jcpo>-joined_field.
            ENDIF.
            CONCATENATE lv_str <fs_jcpo>-operator lv_parta <fs_jcpo>-cond lv_partb
            INTO lv_str SEPARATED BY space.
            CONDENSE lv_str.
          ENDLOOP.
          APPEND VALUE #( guid_header = <fs_jche>-guid_header text = lv_str nr = <fs_jche>-cnt ) TO lt_restable.
        ENDIF.
      ENDLOOP.
    ENDIF.

    e_text = lt_restable.

  ENDMETHOD.


  METHOD cc_on_f4.

    DATA: lt_ddshretval TYPE TABLE OF ddshretval.
    DATA: lt_text       TYPE /cadaxo/sqlcjctext_ty.
    me->cc_on(
      IMPORTING
        e_text = lt_text   " SQL Cockpit - Join Completion - Res
    ).

    "Insert the selected table into SQL Editor
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'TEXT'
        window_title    = 'JOIN Code Completion'
        dynpprog        = sy-repid
        dynpnr          = '1000'
        dynprofield     = 'TEXT'
        value_org       = 'S'
      TABLES
        value_tab       = lt_text
        return_tab      = lt_ddshretval
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF  sy-subrc        EQ 0
    AND lt_ddshretval[] IS NOT INITIAL.
*      e_string = CONV string( lt_ddshretval[ 1 ]-fieldval ).
      e_string = lt_ddshretval[ 1 ]-fieldval.
      CONDENSE e_string.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    go_abap_editor = o_abapedit.

    tables_from_db( ).
    tables_from_editor( ).

  ENDMETHOD.


  METHOD create_alv_controls.

    IF gv_refresh EQ abap_false.
      calculate_position( IMPORTING e_res = gt_res ).
      build_fcat( ).
    ELSE.
      gv_refresh = abap_false.
    ENDIF.

    IF go_container IS NOT BOUND.
      go_container = NEW cl_gui_custom_container( container_name = 'CC_CONT' ).
      go_splitter = NEW cl_gui_splitter_container( parent  = go_container
                                                   rows    = 2
                                                   columns = 1 ).
      go_splitter->set_row_height( id     = 1
                                   height = 60 ).

      DATA(ls_layout) = me->build_layout( ).

      "Top
      calculate_top( IMPORTING e_expr1 = DATA(lv_expr1)
                               e_expr2 = DATA(lv_expr2) ).

      IF to_upper( gt_parsed_table[ lines( gt_parsed_table ) ] ) NE 'ON' "6.
      AND lv_expr1 NE abap_true
      AND lv_expr2 NE abap_true.
        gr_top_alv_grid = NEW cl_gui_alv_grid( i_parent = go_splitter->get_container( row    = 1
                                                                                      column = 1 ) ).
        cl_gui_cfw=>flush( ).
        gr_top_alv_grid->set_table_for_first_display(
           EXPORTING
              is_layout       = ls_layout
           CHANGING
              it_fieldcatalog = gt_res_fcat
              it_outtab       = gt_res
               ).
        SET HANDLER me->handle_double_click_top FOR gr_top_alv_grid .
      ENDIF.

      "Bottom
      calculate_bottom( IMPORTING e_text = gt_text ).

      gr_bottom_alv_grid = NEW cl_gui_alv_grid( i_parent = go_splitter->get_container( row = 2 column = 1 ) ).
      cl_gui_cfw=>flush( ).
      gr_bottom_alv_grid->set_table_for_first_display(
         EXPORTING
            is_layout       = ls_layout
         CHANGING
            it_fieldcatalog = gt_text_fcat
            it_outtab       = gt_text ).
      SET HANDLER me->handle_double_click_bottom FOR gr_bottom_alv_grid .

    ELSE.
      IF gr_top_alv_grid IS BOUND.
        gr_top_alv_grid->refresh_table_display( ).
      ENDIF.
      IF gr_bottom_alv_grid IS BOUND.
        gr_bottom_alv_grid->refresh_table_display( ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD delete_globals.

    me->go_container->free( ).
    CLEAR: go_container.
    CLEAR: go_splitter.
    CLEAR: me->gr_top_alv_grid.
    CLEAR: me->gr_bottom_alv_grid.
    CLEAR: me->gt_res.
    CLEAR: me->gt_res_fcat.
    CLEAR: me->gt_text.
    CLEAR: me->gt_text_fcat.
    CLEAR: me->gt_astable.
    CLEAR: me->gt_seltable.
    CLEAR: me->gs_selstruc.

  ENDMETHOD.


  METHOD disassemble_sql.
    TYPES:
      BEGIN OF t_as,
        operator TYPE char3,
        a        TYPE tabname,
        cond     TYPE sel_option, "/bofu/sel_option, "tabname,
        b        TYPE tabname,
      END OF t_as .
    DATA: lt_codetab    TYPE /cadaxo/sqlccodeline_t.
    DATA: l_str         TYPE string.
    DATA: ls_resstruc   TYPE t_as.
    DATA: ls_join       TYPE /cadaxo/sqlcjcres.
    DATA: lt_restable   TYPE TABLE OF t_as.
    DATA: lt_head       TYPE TABLE OF /cadaxo/sqlcjche.
    DATA: lt_item       TYPE TABLE OF /cadaxo/sqlcjcpo.
    DATA: lt_join       TYPE /cadaxo/sqlcjcres_ty.
    DATA: ev_guid_32_he TYPE guid_32.
    DATA: ev_guid_32_it TYPE guid_32.
    DATA: subrc         TYPE sy-subrc.
    DATA: lv_taba       TYPE tabname.
    DATA: lv_tabb       TYPE tabname.
    DATA: lv_res        TYPE string.
    DATA: lv_join_cnt   TYPE i VALUE 1.

    me->cc_as( ).

    "Get SQL query text from Editor
    go_abap_editor->get_text(
      IMPORTING
        table                  = lt_codetab
      EXCEPTIONS
        error_dp               = 1
        error_cntl_call_method = 2 ).

    "Split the SQL query into an internal table
    CLEAR: l_str.
    LOOP AT lt_codetab INTO DATA(code).
      CONDENSE code.
      CONCATENATE l_str code INTO l_str SEPARATED BY space.
    ENDLOOP.
    SPLIT l_str AT space INTO TABLE DATA(lt_table).

    LOOP AT lt_table INTO DATA(lv_table).
      DATA(tab) = sy-tabix.
      CLEAR: ls_resstruc.
      IF  to_upper( lv_table ) EQ 'ON'
      AND tab < lines( lt_table ) - 2 .
        ls_resstruc-a    = lt_table[ tab + 1 ].
        ls_resstruc-cond = lt_table[ tab + 2 ].
        ls_resstruc-b    = lt_table[ tab + 3 ].
        DATA(lv_a)    = find( val = ls_resstruc-a    sub = |'| ).
        DATA(lv_cond) = find( val = ls_resstruc-cond sub = |'| ).
        DATA(lv_b)    = find( val = ls_resstruc-b    sub = |'| ).
        IF NOT ( lv_a EQ '0' OR lv_cond EQ '0' OR lv_b EQ '0' ).
          REPLACE ALL OCCURRENCES OF '.' IN ls_resstruc-b WITH ''.
          APPEND ls_resstruc TO lt_restable.
        ENDIF.
      ENDIF.

      IF  ( to_upper( lv_table ) EQ 'AND'
      OR    to_upper( lv_table ) EQ 'OR' )
      AND tab < lines( lt_table ) - 2 .
        ls_resstruc-operator = to_upper( lv_table ).
        ls_resstruc-a    = lt_table[ tab + 1 ].
        ls_resstruc-cond = lt_table[ tab + 2 ].
        ls_resstruc-b    = lt_table[ tab + 3 ].
        lv_a    = find( val = ls_resstruc-a    sub = |'| ).
        lv_cond = find( val = ls_resstruc-cond sub = |'| ).
        lv_b    = find( val = ls_resstruc-b    sub = |'| ).
        IF NOT ( lv_a EQ '0' OR lv_cond EQ '0' OR lv_b EQ '0' ).
          REPLACE ALL OCCURRENCES OF '.' IN ls_resstruc-b WITH ''.
          APPEND ls_resstruc TO lt_restable.
        ENDIF.
      ENDIF.

      "Filter Inner Join, Left/Right (Outer) Join
      IF  to_upper( lv_table ) EQ 'JOIN'
      AND tab < lines( lt_table ) - 2 .
        DATA(i) = 0.
        CLEAR: lv_res.
        DO 3 TIMES.
          DATA(lv_exp) = to_upper( lt_table[ tab - i ] ).
          CASE lv_exp.
            WHEN 'INNER' OR 'OUTER' OR 'JOIN' OR 'LEFT' OR 'RIGHT'.
              CONCATENATE lv_exp lv_res INTO lv_res SEPARATED BY space.
            WHEN OTHERS.
          ENDCASE.
          i = i + 1.
        ENDDO.
        CONDENSE lv_res.
        ls_join-join_type = set_join_type( iv_res = lv_res ).
        APPEND ls_join TO lt_join.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_restable INTO ls_resstruc.
      SPLIT ls_resstruc-a AT '~' INTO DATA(lv_tablea) DATA(lv_struca).
      SPLIT ls_resstruc-b AT '~' INTO DATA(lv_tableb) DATA(lv_strucb).
      lv_taba = lv_tablea.
      lv_tabb = lv_tableb.
      IF lv_struca IS INITIAL.
        LOOP AT me->gt_seltable INTO DATA(lv_seltable).
          DATA(ind) = sy-tabix.
          CALL FUNCTION 'DB_EXISTS_TABLE'
            EXPORTING
              tabname = lv_tabb
            IMPORTING
              subrc   = subrc.
          IF subrc EQ 0.
            DATA(lv_tmp) = lv_tableb.
          ELSE.
            lv_tmp = gt_astable[ as = to_upper( lv_tableb ) ]-tabname.
          ENDIF.
          IF lv_seltable EQ lv_tmp.
            lv_struca = lv_tablea.
            lv_tablea = me->gt_seltable[ ind - 1 ]-tabname.
          ENDIF.
        ENDLOOP.
      ENDIF.

      "Check if table name is valid, read the real table name in case of AS cmd
      CALL FUNCTION 'DB_EXISTS_TABLE'
        EXPORTING
          tabname = lv_taba
        IMPORTING
          subrc   = subrc.
      DATA(lv_subrca) = subrc.
      IF lv_subrca NE 0.
        IF gt_astable[ as = to_upper( lv_tablea ) ]-tabname IS NOT INITIAL.
          lv_taba = gt_astable[ as = to_upper( lv_tablea ) ]-tabname.

          CALL FUNCTION 'DB_EXISTS_TABLE'
            EXPORTING
              tabname = lv_taba
            IMPORTING
              subrc   = subrc.
          lv_subrca = subrc.
        ENDIF.
      ENDIF.

      "Check if table name is valid, read the real table name in case of AS cmd
      CALL FUNCTION 'DB_EXISTS_TABLE'
        EXPORTING
          tabname = lv_tabb
        IMPORTING
          subrc   = subrc.
      DATA(lv_subrcb) = subrc.
      IF lv_subrcb NE 0.
        IF gt_astable[ as = to_upper( lv_tableb ) ]-tabname IS NOT INITIAL.
          lv_tabb = gt_astable[ as = to_upper( lv_tableb ) ]-tabname.
          CALL FUNCTION 'DB_EXISTS_TABLE'
            EXPORTING
              tabname = lv_tabb
            IMPORTING
              subrc   = subrc.
          lv_subrcb = subrc.
        ENDIF.
      ENDIF.

      IF  lv_subrca EQ 0
      AND lv_subrcb EQ 0.
        IF NOT line_exists( lt_head[ left_table = lv_taba joined_table = lv_tabb ] ).
          CALL FUNCTION 'GUID_CREATE'
            IMPORTING
              ev_guid_32 = ev_guid_32_he.
          CONDENSE ev_guid_32_he.

          READ TABLE lt_join INTO ls_join INDEX lv_join_cnt.
          lv_join_cnt = lv_join_cnt + 1.

          "join implement should be implemented
          APPEND VALUE #( guid_header  = ev_guid_32_he
                          left_table   = lv_taba
                          join_type    = ls_join-join_type
                          joined_table = lv_tabb ) TO lt_head.
        ENDIF.

        CALL FUNCTION 'GUID_CREATE'
          IMPORTING
            ev_guid_32 = ev_guid_32_it.
        CONDENSE ev_guid_32_it.
        CASE ls_resstruc-cond.
          WHEN '='.
            ls_resstruc-cond = 'EQ'.
          WHEN '<>'.
            ls_resstruc-cond = 'NE'.
          WHEN '<'.
            ls_resstruc-cond = 'LT'.
          WHEN '>'.
            ls_resstruc-cond = 'GT'.
          WHEN '<='.
            ls_resstruc-cond = 'LE'.
          WHEN '>='.
            ls_resstruc-cond = 'GE'.
          WHEN OTHERS.
            ls_resstruc-cond = to_upper( ls_resstruc-cond ).
        ENDCASE.
        APPEND VALUE #( guid_header  = ev_guid_32_he
                        guid_postion = ev_guid_32_it
                        left_field   = lv_struca
                        cond         = ls_resstruc-cond
                        joined_field = lv_strucb
                        operator     = ls_resstruc-operator ) TO lt_item.

      ENDIF.
    ENDLOOP.

    me->fill_db_tables( EXPORTING it_head = lt_head
                                  it_item = lt_item ).

  ENDMETHOD.


  METHOD fill_db_tables.
    TYPES: BEGIN OF ty_stat,
             guid_header TYPE /cadaxo/sqlc_variant_guid,
             cnt         TYPE i,
           END OF ty_stat.
    DATA: ls_stat   TYPE ty_stat.
    DATA: lt_head   TYPE /cadaxo/sqlcjche_t.
    DATA: lt_item   TYPE /cadaxo/sqlcjcpo_t.
    DATA: lt_dbhead TYPE /cadaxo/sqlcjche_t.
    DATA: lt_dbitem TYPE /cadaxo/sqlcjcpo_t.
    DATA: lt_tmp    TYPE TABLE OF ty_stat.
    DATA: lt_stat   TYPE TABLE OF ty_stat.
    DATA: lt_res    TYPE TABLE OF ty_stat.

    "Check header


    "Check item
    LOOP AT it_head INTO DATA(ls_head).
      CLEAR: lt_item, lt_tmp.

      LOOP AT it_item INTO DATA(ls_item) WHERE guid_header = ls_head-guid_header.
        ls_item-cnt = 1.
        APPEND ls_item TO lt_item.
      ENDLOOP.

      LOOP AT lt_item INTO DATA(ls_selitem).
        CLEAR: lt_tmp.
        SELECT guid_header FROM /cadaxo/sqlcjcpo
          INTO CORRESPONDING FIELDS OF TABLE lt_tmp
          WHERE left_field   = ls_selitem-left_field
          AND   cond         = ls_selitem-cond
          AND   joined_field = ls_selitem-joined_field
          AND   operator     = ls_selitem-operator.
        IF sy-subrc EQ 0.
          APPEND LINES OF lt_tmp TO lt_res.
        ENDIF.
      ENDLOOP.
      SORT lt_stat BY guid_header.

      LOOP AT lt_res INTO DATA(ls_res).
        IF line_exists( lt_stat[ guid_header = ls_res-guid_header ] ).
          lt_stat[ guid_header = ls_res-guid_header ]-cnt = lt_stat[ guid_header = ls_res-guid_header ]-cnt + 1.
        ELSE.
          ls_stat-guid_header = ls_res-guid_header.
          ls_stat-cnt = 1.
          APPEND ls_stat TO lt_stat.
        ENDIF.
      ENDLOOP.

      IF lt_stat IS INITIAL.
        "Not exist in the DB, insert header item
        ls_head-cnt = 1.
        INSERT INTO /cadaxo/sqlcjche VALUES ls_head.
        INSERT /cadaxo/sqlcjcpo FROM TABLE lt_item.
      ELSE.
        DATA(lv_guid_header) = lt_stat[ cnt = lines( lt_item ) ]-guid_header.
        UPDATE /cadaxo/sqlcjche SET cnt = cnt + 1 WHERE guid_header = lv_guid_header.
        UPDATE /cadaxo/sqlcjcpo SET cnt = cnt + 1 WHERE guid_header = lv_guid_header.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_join_type.

    CASE iv_join_type.
      WHEN '0'.
        rv_res = 'INNER JOIN'.
      WHEN '1'.
        rv_res = 'LEFT OUTER JOIN'.
      WHEN '2'.
        rv_res = 'RIGHT OUTER JOIN'.
      WHEN '3'.
        rv_res = 'FULL OUTER JOIN'.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD handle_double_click_bottom.
    DATA: lt_dynpfields TYPE TABLE OF dynpread.
    DATA: ls_dynpfields TYPE dynpread.

    CHECK e_row IS NOT INITIAL.

    READ TABLE gt_text INTO DATA(ls_text) INDEX e_row-index .

    IF to_upper( gt_parsed_table[ lines( gt_parsed_table ) ] ) NE 'ON'.
      CONCATENATE gv_join_table 'ON' ls_text-text INTO me->gv_result SEPARATED BY space.
    ELSE.
      CONCATENATE gv_join_table ls_text-text INTO me->gv_result SEPARATED BY space.
    ENDIF.

    IF lines( gt_parsed_table ) > 1.
      IF last_table IS NOT INITIAL
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'FROM'.
        CONCATENATE gv_join_type me->gv_result INTO me->gv_result SEPARATED BY space.
      ENDIF.
    ENDIF.

    IF lines( gt_parsed_table ) > 3.
      IF  to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 3 ] ) = 'FROM' "2
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'AS'.
        CONCATENATE gv_join_type me->gv_result INTO me->gv_result SEPARATED BY space.
      ENDIF.
    ENDIF.

    CONDENSE me->gv_result.

    CALL METHOD cl_gui_cfw=>set_new_ok_code
      EXPORTING
        new_code = 'REFRESH'.
    me->gv_refresh  = abap_true.

  ENDMETHOD.


  METHOD handle_double_click_top.
    DATA: lt_dynpfields TYPE TABLE OF dynpread.
    DATA: ls_dynpfields TYPE dynpread.

    CHECK e_row IS NOT INITIAL.

    READ TABLE gt_res INTO DATA(ls_res) INDEX e_row-index .
    me->append_table_seltable( i_tabname = ls_res-tabname ).

    CLEAR: gv_result.
    CONCATENATE gv_result ls_res-tabname INTO gv_result.
    gv_join_table = gv_result.

    CLEAR: gv_join_type.
    IF lines( gt_parsed_table ) > 1.
      IF last_table IS NOT INITIAL
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'FROM'.
        gv_join_type = me->get_join_type( ls_res-join_type ).
        CONCATENATE gv_join_type me->gv_result INTO me->gv_result SEPARATED BY space.
      ENDIF.
    ENDIF.

    IF lines( gt_parsed_table ) > 3.
      IF  to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 3 ] ) = 'FROM' "2
      AND to_upper( gt_parsed_table[ lines( gt_parsed_table ) - 1 ] ) = 'AS'.
        gv_join_type = me->get_join_type( ls_res-join_type ).
        CONCATENATE gv_join_type me->gv_result INTO me->gv_result SEPARATED BY space.
      ENDIF.
    ENDIF.

    CONDENSE me->gv_result.

    me->cc_on(  EXPORTING i_res  = ls_res
                IMPORTING e_text = gt_text ).
    gr_bottom_alv_grid->refresh_table_display( ).

    CALL METHOD cl_gui_cfw=>set_new_ok_code
      EXPORTING
        new_code = 'REFRESH'.
    me->gv_refresh  = abap_true.

  ENDMETHOD.


  METHOD pbo_0100.

    me->create_alv_controls( ).

    IF  me->gt_res  IS INITIAL
    AND me->gt_text IS INITIAL.
      me->delete_globals( ).
      MESSAGE 'No result for Code Completion found!' TYPE 'S'.
      LEAVE TO SCREEN 0.
    ENDIF.

  ENDMETHOD.


  METHOD set_join_type.

    CASE iv_res.
      WHEN 'INNER JOIN'.
        rv_join_type = '0'.
      WHEN 'LEFT OUTER JOIN'
        OR 'LEFT JOIN'.
        rv_join_type = '1'.
      WHEN 'RIGHT OUTER JOIN'
        OR 'RIGHT JOIN'.
        rv_join_type = '2'.
      WHEN 'FULL OUTER JOIN'.
        rv_join_type = '3'.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD tables_from_db.

    "SQL Log Table
    SELECT * FROM /cadaxo/sqlclog INTO TABLE @gt_sqlclog.
    "Join Completion Header
    SELECT * FROM /cadaxo/sqlcjche INTO TABLE @gt_sqlcjche.
    "Join Completion Item
    SELECT * FROM /cadaxo/sqlcjcpo INTO TABLE @gt_sqlcjcpo.

  ENDMETHOD.


  METHOD tables_from_editor.
    DATA: lt_code       TYPE /cadaxo/sqlccodeline_t.
    DATA: lt_codetab    TYPE /cadaxo/sqlccodeline_t.
    DATA: lv_code       TYPE /cadaxo/sqlccodeline.
    DATA: lv_pos        TYPE string.
    DATA: l_str         TYPE string.

    CHECK go_abap_editor IS NOT INITIAL.

    "Get selection posiition
    go_abap_editor->get_selection_pos( IMPORTING from_line = DATA(l_from_line)
                                                 from_pos  = DATA(l_from_pos)
                                                 to_line   = DATA(l_to_line)
                                                 to_pos    = DATA(l_to_pos) ).
    "Get SQL query text from Editor
    go_abap_editor->get_text( IMPORTING table   = lt_code
                              EXCEPTIONS OTHERS = 2 ).
    IF l_from_line = l_to_line AND l_from_pos = l_to_pos.
      LOOP AT lt_code INTO lv_code.
        IF sy-tabix < l_from_line.
          APPEND lv_code TO lt_codetab.
        ELSEIF sy-tabix = l_from_line.
          lv_pos = lv_code+0(l_from_pos).
          APPEND lv_pos TO lt_codetab.
        ENDIF.
      ENDLOOP.
    ELSE.
      LOOP AT lt_code INTO lv_code.
        IF sy-tabix = l_from_line.
          SHIFT lv_code BY l_from_pos PLACES LEFT.
          APPEND lv_code TO lt_codetab.
        ELSEIF sy-tabix > l_from_line AND sy-tabix < l_to_line.
          APPEND lv_code TO lt_codetab.
        ELSEIF sy-tabix = l_to_line.
          lv_pos = lv_code+0(l_to_pos).
          APPEND lv_pos TO lt_codetab.
        ENDIF.
      ENDLOOP.
    ENDIF.

    "Split the SQL query into an internal table
    CLEAR: l_str.
    LOOP AT lt_codetab INTO DATA(code).
      CONDENSE code.
      CONCATENATE l_str code INTO l_str SEPARATED BY space.
    ENDLOOP.
    l_str = to_upper( l_str ).
    SPLIT l_str AT space INTO TABLE gt_parsed_table.
    "Copy the table name from the SQL query into an internal table
    LOOP AT gt_parsed_table INTO DATA(ls_table).
      DATA(tabix) = sy-tabix.
      IF ( to_upper( ls_table ) EQ 'FROM'
      OR   to_upper( ls_table ) EQ 'JOIN' )
      AND tabix < lines( gt_parsed_table ).
        CLEAR gs_selstruc.
        gs_selstruc-tabname = to_upper( gt_parsed_table[ tabix + 1 ] ).
        APPEND gs_selstruc TO gt_seltable.
      ENDIF.
      IF  to_upper( ls_table )              EQ '('
      AND to_upper( gt_parsed_table[ tabix + 1 ] ) EQ 'SELECT'
      AND tabix < lines( gt_parsed_table ).
        CLEAR gt_seltable.
      ENDIF.
    ENDLOOP.

    IF get_table_description( CONV #( gt_parsed_table[ lines( gt_parsed_table ) ] ) ) IS NOT INITIAL.
      last_table = gt_parsed_table[ lines( gt_parsed_table ) ].
    ENDIF.

  ENDMETHOD.
ENDCLASS.
