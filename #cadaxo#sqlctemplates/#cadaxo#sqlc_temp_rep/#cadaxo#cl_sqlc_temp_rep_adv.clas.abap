CLASS /cadaxo/cl_sqlc_temp_rep_adv DEFINITION
  PUBLIC
  INHERITING FROM /cadaxo/cl_sqlc_template
  FINAL
  CREATE PUBLIC .

*"* public components of class /CADAXO/CL_SQLC_TEMP_REP_ADV
*"* do not include other source files here!!!
  PUBLIC SECTION.

    METHODS create_report
      RAISING
        /cadaxo/cx_sqlc_temp_rep .
    METHODS check_report
      RAISING
        /cadaxo/cx_sqlc_temp_rep .
    METHODS generate_source_code
      RAISING
        /cadaxo/cx_sqlc_temp_rep .
    METHODS generate_source_code_enh
      RAISING
        /cadaxo/cx_sqlc_temp_rep .
    METHODS check_include
      RAISING
        /cadaxo/cx_sqlc_temp_rep .
    METHODS create_include
      RAISING
        /cadaxo/cx_sqlc_temp_rep .

    METHODS execute_template_generation
         REDEFINITION .
  PROTECTED SECTION.
*"* protected components of class /CADAXO/CL_SQLC_TEMP_REP
*"* do not include other source files here!!!

    METHODS update_trdir .
    METHODS rebuild_object_list .
    METHODS update_trdir_include .
    METHODS save_settings
      RAISING
        /cadaxo/cx_sqlc_temp_rep .
  PRIVATE SECTION.
*"* private components of class /CADAXO/CL_SQLC_TEMP_REP
*"* do not include other source files here!!!

    DATA gt_source_code TYPE /cadaxo/sqlc_temp_rep_codelnst .
    DATA gt_textpool TYPE gtt_textpool .
    DATA gwa_report TYPE /cadaxo/sqlc_temp_rep_attr .
    CONSTANTS c_true TYPE flag VALUE 'X'.                   "#EC NOTEXT
    CONSTANTS c_false TYPE flag VALUE space.                "#EC NOTEXT
    DATA wa_source_code TYPE text255 .
    DATA gt_source_code_enh TYPE /cadaxo/sqlc_temp_rep_codelnst .
    DATA gwa_evt TYPE /cadaxo/sqlc_temp_rep_salv_evt .
    DATA gt_selopt TYPE /cadaxo/sqlc_temp_rep_sel_strt .
ENDCLASS.



CLASS /cadaxo/cl_sqlc_temp_rep_adv IMPLEMENTATION.


  METHOD check_include.
    DATA: l_mess   TYPE string.
    DATA: l_lin    TYPE i.
    DATA: l_wrd    TYPE string.
    DATA: l_dir    TYPE trdir.
    DATA: l_text   TYPE string.
    DATA: l_answer TYPE c.


    l_dir-uccheck = 'X'.
    l_dir-name    = 'DUMMY'.
    l_dir-subc    = 'I'.

* check syntax
*  READ REPORT
    SYNTAX-CHECK FOR gt_source_code_enh MESSAGE l_mess LINE l_lin WORD l_wrd DIRECTORY ENTRY l_dir.

    IF NOT l_mess IS INITIAL.
      CONCATENATE text-p05 text-p06 INTO l_text SEPARATED BY space.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = text-p00
          text_question         = l_text
          text_button_1         = text-p01
          icon_button_1         = 'ICON_GENERATE'
          text_button_2         = text-p02
          icon_button_2         = 'ICON_INCOMPLETE'
          default_button        = '1'
          display_cancel_button = ''
          popup_type            = 'ICON_MESSAGE_ERROR'
        IMPORTING
          answer                = l_answer.
      IF l_answer = 2.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
          EXPORTING
            textid = /cadaxo/cx_sqlc_temp_rep=>cancel.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD check_report.
    DATA: l_mess   TYPE string.
    DATA: l_lin    TYPE i.
    DATA: l_wrd    TYPE string.
    DATA: l_dir    TYPE trdir.
    DATA: l_text   TYPE string.
    DATA: l_answer TYPE c.


    l_dir-uccheck = 'X'.
    l_dir-fixpt = 'X'.
    l_dir-name    = 'DUMMY'.

* check syntax
    SYNTAX-CHECK FOR gt_source_code MESSAGE l_mess LINE l_lin WORD l_wrd DIRECTORY ENTRY l_dir.

    IF NOT l_mess IS INITIAL.
      CONCATENATE text-p03 text-p04 INTO l_text SEPARATED BY space.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = text-p00
          text_question         = l_text
          text_button_1         = text-p01
          icon_button_1         = 'ICON_GENERATE'
          text_button_2         = text-p02
          icon_button_2         = 'ICON_INCOMPLETE'
          default_button        = '1'
          display_cancel_button = ''
          popup_type            = 'ICON_MESSAGE_ERROR'
        IMPORTING
          answer                = l_answer.
      IF l_answer = 2.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
          EXPORTING
            textid = /cadaxo/cx_sqlc_temp_rep=>cancel.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD create_include.

    DATA: lwa_dir              TYPE trdir.
    DATA: lwa_e071             TYPE e071.
    DATA: lwa_e071_tmp         TYPE e071.
    DATA: lwa_devc             TYPE tdevc.
    DATA: lwa_k200             TYPE ko200.
    DATA: l_no_version         TYPE flag.
    DATA: l_version_new        TYPE versno.
    DATA: ls_textpool          TYPE textpool.
    FIELD-SYMBOLS: <lwa_where> TYPE /cadaxo/sqlcwherecol_str.
    MOVE gwa_report-enh_include TO lwa_dir-name.

    lwa_e071-obj_name = gwa_report-enh_include.
    lwa_e071-pgmid    = 'R3TR'.
    lwa_e071-object   = 'PROG'.
    SELECT SINGLE * FROM trdir INTO lwa_dir WHERE name = lwa_dir-name.
    IF sy-subrc NE 0 OR gwa_report-devclass IS INITIAL.
      IF gwa_report-devclass IS INITIAL.
        CALL FUNCTION 'TRINT_TADIR_POPUP_ENTRY_E071'
          EXPORTING
            wi_e071_pgmid    = lwa_e071-pgmid
            wi_e071_object   = lwa_e071-object
            wi_e071_obj_name = lwa_e071-obj_name
          IMPORTING
            es_tdevc         = lwa_devc
          EXCEPTIONS
            OTHERS           = 1.
        IF sy-subrc EQ 0.
          MOVE lwa_devc-devclass TO gwa_report-devclass.
        ENDIF.
      ENDIF.
      l_no_version = 'X'.
    ENDIF.

    IF NOT gwa_report-devclass IS INITIAL.
*  IF sy-subrc EQ 0.
      IF NOT gwa_report-devclass IS INITIAL.
        lwa_dir-subc    = 'I'.
        lwa_dir-fixpt   = c_true.
        lwa_dir-uccheck = c_true.


        IF l_no_version IS INITIAL.
          lwa_e071_tmp-pgmid             = 'LIMU'.
          lwa_e071_tmp-object            = 'REPS'.
          lwa_e071_tmp-obj_name          = gwa_report-report.
          CALL FUNCTION 'SVRS_AFTER_CHANGED_ONLINE_NEW'
            EXPORTING
              e071_entry              = lwa_e071_tmp
              status                  = 'A'
            IMPORTING
              version_new             = l_version_new
            EXCEPTIONS
              non_versionable_objtype = 1
              no_tadir_entry          = 2
              object_not_found        = 3
              object_not_locked       = 4
              OTHERS                  = 5.
          IF sy-subrc <> 0.
* all excetions can be ignored
          ENDIF.
        ENDIF.

        IF NOT lwa_e071 IS INITIAL.
          MOVE-CORRESPONDING lwa_e071 TO lwa_k200.
        ELSE.
          MOVE-CORRESPONDING lwa_e071_tmp TO lwa_k200.
        ENDIF.

        lwa_k200-devclass = gwa_report-devclass.


* get details
        CALL FUNCTION 'TR_OBJECT_CHECK'
          EXPORTING
            wi_ko200                = lwa_k200
          IMPORTING
            we_ko200                = lwa_k200
          EXCEPTIONS
            cancel_edit_other_error = 1
            show_only_other_error   = 2
            OTHERS                  = 3.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
            EXPORTING
              textid = /cadaxo/cx_sqlc_temp_rep=>insert_include.
        ENDIF.

* insert to TR
        CALL FUNCTION 'TR_OBJECT_INSERT'
          EXPORTING
            wi_ko200                = lwa_k200
          EXCEPTIONS
            cancel_edit_other_error = 1
            show_only_other_error   = 2
            OTHERS                  = 3.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
            EXPORTING
              textid = /cadaxo/cx_sqlc_temp_rep=>insert_include.
        ENDIF.


* Report
        INSERT REPORT gwa_report-enh_include FROM gt_source_code_enh DIRECTORY ENTRY lwa_dir.
        IF sy-subrc <> 0.
          CALL FUNCTION 'DEQUEUE_ESRDIRE'
            EXPORTING
              _scope     = 3
              mode_trdir = c_true
              name       = gwa_report-enh_include.

          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
            EXPORTING
              textid = /cadaxo/cx_sqlc_temp_rep=>insert_include.

        ENDIF.

        SET PARAMETER ID 'IID' FIELD gwa_report-enh_include.

        CALL FUNCTION 'DEQUEUE_ESRDIRE'
          EXPORTING
            _scope     = 3
            mode_trdir = c_true
            name       = gwa_report-enh_include.

      ELSE.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
          EXPORTING
            textid = /cadaxo/cx_sqlc_temp_rep=>insert_include.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD create_report.

    DATA: lwa_dir              TYPE trdir.
    DATA: lwa_e071             TYPE e071.
    DATA: lwa_e071_tmp         TYPE e071.
    DATA: lwa_devc             TYPE tdevc.
    DATA: lwa_k200             TYPE ko200.
    DATA: l_no_version         TYPE flag.
    DATA: l_version_new        TYPE versno.
    DATA: ls_textpool          TYPE textpool.
    FIELD-SYMBOLS: <lwa_where> TYPE /cadaxo/sqlcwherecol_str.
    MOVE gwa_report-report TO lwa_dir-name.

    SELECT SINGLE * FROM trdir INTO CORRESPONDING FIELDS OF lwa_dir WHERE name = lwa_dir-name.
    IF sy-subrc NE 0 OR gwa_report-devclass IS INITIAL.
      lwa_e071-obj_name = gwa_report-report.
      lwa_e071-pgmid    = 'R3TR'.
      lwa_e071-object   = 'PROG'.
      IF gwa_report-devclass IS INITIAL.                      "CDX130-025
        CALL FUNCTION 'TRINT_TADIR_POPUP_ENTRY_E071'
          EXPORTING
            wi_e071_pgmid    = lwa_e071-pgmid
            wi_e071_object   = lwa_e071-object
            wi_e071_obj_name = lwa_e071-obj_name
          IMPORTING
            es_tdevc         = lwa_devc
          EXCEPTIONS
            OTHERS           = 1.
        IF sy-subrc EQ 0.
          MOVE lwa_devc-devclass TO gwa_report-devclass.
        ENDIF.
      ENDIF.
      l_no_version = 'X'.
    ENDIF.
    IF NOT gwa_report-devclass IS INITIAL."sy-subrc EQ 0.
      lwa_dir-subc    = 1.
      lwa_dir-fixpt   = c_true.
      lwa_dir-uccheck = c_true.


      IF l_no_version IS INITIAL.
        lwa_e071_tmp-pgmid             = 'LIMU'.
        lwa_e071_tmp-object            = 'REPS'.
        lwa_e071_tmp-obj_name          = gwa_report-report.
        CALL FUNCTION 'SVRS_AFTER_CHANGED_ONLINE_NEW'
          EXPORTING
            e071_entry              = lwa_e071_tmp
            status                  = 'A'
          IMPORTING
            version_new             = l_version_new
          EXCEPTIONS
            non_versionable_objtype = 1
            no_tadir_entry          = 2
            object_not_found        = 3
            object_not_locked       = 4
            OTHERS                  = 5.
        IF sy-subrc <> 0.
* all excetions can be ignored
        ENDIF.
      ENDIF.

      IF NOT lwa_e071 IS INITIAL.
        MOVE-CORRESPONDING lwa_e071 TO lwa_k200.
      ELSE.
        MOVE-CORRESPONDING lwa_e071_tmp TO lwa_k200.
      ENDIF.
      lwa_k200-devclass = gwa_report-devclass.

* get details
      CALL FUNCTION 'TR_OBJECT_CHECK'
        EXPORTING
          wi_ko200                = lwa_k200
        IMPORTING
          we_ko200                = lwa_k200
        EXCEPTIONS
          cancel_edit_other_error = 1
          show_only_other_error   = 2
          OTHERS                  = 3.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
          EXPORTING
            textid = /cadaxo/cx_sqlc_temp_rep=>insert_report.
      ENDIF.

* insert to TR
      CALL FUNCTION 'TR_OBJECT_INSERT'
        EXPORTING
          wi_ko200                = lwa_k200
        EXCEPTIONS
          cancel_edit_other_error = 1
          show_only_other_error   = 2
          OTHERS                  = 3.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
          EXPORTING
            textid = /cadaxo/cx_sqlc_temp_rep=>insert_report.
      ENDIF.


* Report
      INSERT REPORT gwa_report-report FROM gt_source_code DIRECTORY ENTRY lwa_dir.
      IF sy-subrc <> 0.
        CALL FUNCTION 'DEQUEUE_ESRDIRE'
          EXPORTING
            _scope     = 3
            mode_trdir = c_true
            name       = gwa_report-report.

        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
          EXPORTING
            textid = /cadaxo/cx_sqlc_temp_rep=>insert_report.

      ENDIF.

      SET PARAMETER ID 'RID' FIELD gwa_report-report.
* Textpool
      CLEAR gt_textpool.
      IF NOT gwa_report-title IS INITIAL.
        CLEAR ls_textpool.
        ls_textpool-id = 'R'.
        ls_textpool-key = ''.
        ls_textpool-entry = gwa_report-title.
        APPEND ls_textpool TO gt_textpool.
        CLEAR ls_textpool.
        ls_textpool-id = 'I'.
        ls_textpool-key = 'T00'.
        CONCATENATE gwa_report-title '-' INTO ls_textpool-entry SEPARATED BY space.
        ls_textpool-length = strlen( ls_textpool-entry ) + 5.
        APPEND ls_textpool TO gt_textpool.
      ENDIF.

      CLEAR ls_textpool.
      ls_textpool-id = 'I'.
      ls_textpool-key = 'T01'.
      ls_textpool-entry = text-t01.
      ls_textpool-length = strlen( ls_textpool-entry ) + 5.
      APPEND ls_textpool TO gt_textpool.

      LOOP AT gt_where->* ASSIGNING <lwa_where> WHERE generate_option <> '03'.
        CLEAR ls_textpool.
        ls_textpool-id = 'S'.
        CONCATENATE 'P_' <lwa_where>-wildcard_operator+2(3) INTO ls_textpool-key.
        TRANSLATE ls_textpool-key TO UPPER CASE.
        CONCATENATE '        ' <lwa_where>-fielddescr INTO ls_textpool-entry RESPECTING BLANKS.
        ls_textpool-length = strlen( ls_textpool-entry ) + 5.
        APPEND ls_textpool TO gt_textpool.
      ENDLOOP.

* Textpool
      INSERT TEXTPOOL gwa_report-report
                 FROM gt_textpool
             LANGUAGE sy-langu.

      IF sy-langu = 'D'.
        INSERT TEXTPOOL gwa_report-report
                 FROM gt_textpool
             LANGUAGE 'E'.
      ELSEIF sy-langu = 'E'.
        INSERT TEXTPOOL gwa_report-report
                 FROM gt_textpool
             LANGUAGE 'D'.
      ENDIF.

      CALL FUNCTION 'DEQUEUE_ESRDIRE'
        EXPORTING
          _scope     = 3
          mode_trdir = c_true
          name       = gwa_report-report.

    ELSE.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
        EXPORTING
          textid = /cadaxo/cx_sqlc_temp_rep=>insert_report.

    ENDIF.

  ENDMETHOD.


  METHOD execute_template_generation.

    DATA: lx_error TYPE REF TO /cadaxo/cx_sqlc_temp_rep.
    FIELD-SYMBOLS: <lt_where> TYPE /cadaxo/sqlcwherecol_str_t.

    ASSIGN gt_where->* TO <lt_where>.

    CLEAR me->gt_source_code.

    CALL FUNCTION '/CADAXO/SQLC_TEMP_REP_WIZ'
      IMPORTING
        ewa_report     = gwa_report
        ewa_evt        = gwa_evt
        egt_selopt     = gt_selopt
      CHANGING
        ct_where       = <lt_where>
        c_templ_name   = g_templ_name
      EXCEPTIONS
        cancel_by_user = 1
        OTHERS         = 2.

    CASE sy-subrc.
      WHEN 0.
        TRY.
            generate_source_code( ).
            MESSAGE s105(/cadaxo/sqlc) WITH gwa_report-report.

          CATCH /cadaxo/cx_sqlc_temp_rep INTO lx_error.
            CALL FUNCTION 'DEQUEUE_ESRDIRE'
              EXPORTING
                _scope     = 3
                mode_trdir = c_true
                name       = gwa_report-report.
            CASE lx_error->textid.
              WHEN /cadaxo/cx_sqlc_temp_rep=>internal_error.
                MESSAGE s104(/cadaxo/sqlc) DISPLAY LIKE 'E'.
              WHEN /cadaxo/cx_sqlc_temp_rep=>cancel.
                MESSAGE s042(/cadaxo/sqlc) DISPLAY LIKE 'E'.
              WHEN /cadaxo/cx_sqlc_temp_rep=>insert_report.
                MESSAGE s104(/cadaxo/sqlc) DISPLAY LIKE 'E'.
              WHEN /cadaxo/cx_sqlc_temp_rep=>insert_include.
                MESSAGE s104(/cadaxo/sqlc) DISPLAY LIKE 'E'.
              WHEN /cadaxo/cx_sqlc_temp_rep=>save_settings.
                MESSAGE s104(/cadaxo/sqlc) DISPLAY LIKE 'E'.
            ENDCASE.
            CALL FUNCTION 'DEQUEUE_ESRDIRE'
              EXPORTING
                _scope     = 3
                mode_trdir = c_true
                name       = gwa_report-enh_include.
            CASE lx_error->textid.
              WHEN /cadaxo/cx_sqlc_temp_rep=>internal_error.
                MESSAGE s104(/cadaxo/sqlc) DISPLAY LIKE 'E'.
              WHEN /cadaxo/cx_sqlc_temp_rep=>cancel.
                MESSAGE s042(/cadaxo/sqlc) DISPLAY LIKE 'E'.
              WHEN /cadaxo/cx_sqlc_temp_rep=>insert_report.
                MESSAGE s104(/cadaxo/sqlc) DISPLAY LIKE 'E'.
              WHEN /cadaxo/cx_sqlc_temp_rep=>insert_include.
                MESSAGE s104(/cadaxo/sqlc) DISPLAY LIKE 'E'.
              WHEN /cadaxo/cx_sqlc_temp_rep=>save_settings.
                MESSAGE s104(/cadaxo/sqlc) DISPLAY LIKE 'E'.
            ENDCASE.
        ENDTRY.

      WHEN 1.
        MESSAGE s042(/cadaxo/sqlc) DISPLAY LIKE 'E'.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD generate_source_code.
****************************************************************************************************
* Description             : Generate Source Code                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 06.06.2016 | Ana Lekic            | report generator for new opensql syntax     | COCKPIT-46     *
*            |                      |                                             | $001           *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: l_calling_program TYPE sy-repid.
    DATA: l_scheme_program  TYPE schemeprog.
    DATA: l_scheme_name     TYPE schemename.
    DATA: lt_text           TYPE TABLE OF text100.

    l_calling_program = '/CADAXO/SAPLSQLC_TEMP_REP'.
    "l_scheme_program  = gwa_report-schemeprogram.
    l_scheme_name     = gwa_report-schemename.

    CASE gr_parser->g_select_version. "$001
      WHEN gr_parser->c_select_version_1 OR gr_parser->c_select_version_0. "$001
        CALL FUNCTION '/CADAXO/SQLC_TEMP_SET_SME'
          EXPORTING
            ir_parser  = gr_parser
            iwa_report = gwa_report
            it_where   = gt_where->*.

        l_scheme_program = '/CADAXO/SQLC_SME1A'.

      WHEN gr_parser->c_select_version_2. "$001
        CALL FUNCTION '/CADAXO/SQLC_TEMP_SET_SME_V2' "$001
          EXPORTING
            ir_parser  = gr_parser
            iwa_report = gwa_report
            it_where   = gt_where->*.

        l_scheme_program = '/CADAXO/SQLC_SME2A'.

    ENDCASE. "$001

    IF gwa_evt IS NOT INITIAL.
* Create Enhancement Include
      generate_source_code_enh( ).
    ENDIF.

    CALL FUNCTION 'SCHEME_INSTANTIATE'
      EXPORTING
        calling_program      = l_calling_program
        scheme_program       = l_scheme_program
        scheme_name          = l_scheme_name
      TABLES
        result_tab           = me->gt_source_code
      EXCEPTIONS
        schemeprog_not_found = 1
        scheme_not_found     = 2
        scheme_syntax_error  = 3
        generate_error       = 4
        forced_linesplit     = 5
        table_not_exists     = 6
        OTHERS               = 7.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'PRETTY_PRINTER'
      EXPORTING
        inctoo = space
      TABLES
        ntext  = me->gt_source_code
        otext  = me->gt_source_code.

* check report code
    check_report( ).

* insert report to database
    create_report( ).

* update report attributes
    update_trdir( ).

* rebuild se80 object list
    rebuild_object_list( ).

* save report settings
    save_settings( ).
  ENDMETHOD.


  METHOD generate_source_code_enh.
****************************************************************************************************
* Description             : Generate Source Code                                                   *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
* 01.08.2012 | Ana Lekic            | Reporttemplate Enhancements                 | CDX130-025     *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
*
    DATA lt_coding        TYPE /cadaxo/sqlc_temp_rep_codelnst.
    DATA lt_coding_new    TYPE /cadaxo/sqlc_temp_rep_codelnst.
    DATA lt_comp          TYPE abap_compdescr_tab.
    DATA lcl_structtype   TYPE REF TO cl_abap_structdescr.
    DATA ls_str           TYPE string.
    DATA dref             TYPE REF TO data.
    DATA l_idx            TYPE i.
    DATA ls_evt           TYPE /cadaxo/sqlc_temp_rep_salv_evt.
    DATA lt_source        TYPE rswsourcet.
    DATA lt_form_tab      TYPE rswsourcet.

    DATA: l_operation(10),
          l_objecttype(1),
          l_objectname(255),
          l_local(1),
          l_col             LIKE sy-index,
          l_row             LIKE sy-index,
          l_incl(40),
          l_program         LIKE sy-repid,
          l_eventtype.

    FIELD-SYMBOLS: <field> TYPE any,
                   <comp>  LIKE LINE OF lt_comp.

* If the include doesn't exist -- > create coding new
    CALL FUNCTION 'SCHEME_INSTANTIATE'
      EXPORTING
        calling_program      = '/CADAXO/SAPLSQLC_TEMP_REP'
        scheme_program       = '/CADAXO/SQLC_SME1I'
        scheme_name          = 'INCLUDE1'
      TABLES
        result_tab           = lt_coding_new
      EXCEPTIONS
        schemeprog_not_found = 1
        scheme_not_found     = 2
        scheme_syntax_error  = 3
        generate_error       = 4
        forced_linesplit     = 5
        table_not_exists     = 6
        OTHERS               = 7.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

*   concatenate old coding with new
    READ REPORT gwa_report-enh_include INTO lt_coding.
    APPEND LINES OF lt_coding TO me->gt_source_code_enh.
    APPEND LINES OF lt_coding_new TO me->gt_source_code_enh.

    CALL FUNCTION 'PRETTY_PRINTER'
      EXPORTING
        inctoo = space
      TABLES
        ntext  = me->gt_source_code_enh
        otext  = me->gt_source_code_enh.

* insert include to database
    create_include( ).

* update report attributes
    update_trdir_include( ).

  ENDMETHOD.


  METHOD rebuild_object_list.
****************************************************************************************************
* Description             : Rebuild SE80 Object list                                               *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA: BEGIN OF pname_dev,
            root(3)  VALUE 'EU_',
            devclass TYPE devclass,
          END OF pname_dev.
    DATA: BEGIN OF pname_rep,
            root(3) VALUE 'PG_',
            program LIKE sy-repid,
          END OF pname_rep.
    IF gwa_report-devclass NE space.
      IF gwa_report-devclass = '$TMP'.
        pname_rep-program = gwa_report-report.

        CALL FUNCTION 'WB_TREE_ACTUALIZE'
          EXPORTING
            tree_name = pname_rep.

      ELSE.
        pname_dev-devclass = gwa_report-devclass.

        CALL FUNCTION 'WB_TREE_ACTUALIZE'
          EXPORTING
            tree_name = pname_dev.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD save_settings.

    DATA ls_sqlctemprepsave TYPE /cadaxo/sqlctemprepsave.
    DATA lt_sqlctemprepsave TYPE TABLE OF /cadaxo/sqlctemprepsave.
*  DATA lt_selopt          TYPE /cadaxo/sqlc_temp_rep_sel_strt.
    DATA ls_sqlctemr        TYPE /cadaxo/sqlctemr.
    DATA l_update_ok        TYPE c LENGTH 1.
    DATA l_xml              TYPE string.

    MOVE gwa_report TO ls_sqlctemprepsave-report.
    MOVE gwa_evt    TO ls_sqlctemprepsave-events.
    MOVE gt_selopt  TO ls_sqlctemprepsave-selopt.
    APPEND ls_sqlctemprepsave TO lt_sqlctemprepsave.


* transform the data into xml
    CALL TRANSFORMATION id
      SOURCE result_save = lt_sqlctemprepsave
      RESULT XML l_xml.

* zip xml
    CALL METHOD cl_abap_gzip=>compress_text
      EXPORTING
        text_in  = l_xml
      IMPORTING
        gzip_out = ls_sqlctemr-reportsettings.

    MOVE gwa_report-report TO ls_sqlctemr-report.

    CLEAR l_update_ok.
    MODIFY /cadaxo/sqlctemr FROM ls_sqlctemr.
    IF sy-subrc EQ 0.
      l_update_ok = abap_true.
    ENDIF.

    IF l_update_ok = abap_true.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
        EXPORTING
          textid = /cadaxo/cx_sqlc_temp_rep=>save_settings.
    ENDIF.

  ENDMETHOD.


  METHOD update_trdir.
****************************************************************************************************
* Description             : Update TRDIR Attributes                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
    DATA: ls_trdir TYPE trdir.

    CLEAR: ls_trdir.

    CALL FUNCTION 'RS_TRDIR_SELECT'
      EXPORTING
        trdir_name      = gwa_report-report
      IMPORTING
        trdir_row       = ls_trdir
      EXCEPTIONS
        internal_error  = 1
        parameter_error = 2
        not_found       = 3
        OTHERS          = 4.
    IF sy-subrc EQ 0.

      ls_trdir-rstat = gwa_report-status.
      ls_trdir-appl  = gwa_report-application.
      ls_trdir-secu  = gwa_report-authorization_group.

      CALL FUNCTION 'RS_TRDIR_UPDATE'
        EXPORTING
          trdir_row       = ls_trdir
        EXCEPTIONS
          internal_error  = 1
          parameter_error = 2
          not_found       = 3.
      IF sy-subrc NE 0.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
          EXPORTING
            textid = /cadaxo/cx_sqlc_temp_rep=>insert_report.
      ENDIF.

    ELSE.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
        EXPORTING
          textid = /cadaxo/cx_sqlc_temp_rep=>insert_report.
    ENDIF.
  ENDMETHOD.


  METHOD update_trdir_include.
****************************************************************************************************
* Description             : Update TRDIR Attributes                                                *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       :                          Company    :                                  *
* Date                    :                                                                        *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
    DATA: ls_trdir TYPE trdir.

    CLEAR: ls_trdir.

    CALL FUNCTION 'RS_TRDIR_SELECT'
      EXPORTING
        trdir_name      = gwa_report-enh_include
      IMPORTING
        trdir_row       = ls_trdir
      EXCEPTIONS
        internal_error  = 1
        parameter_error = 2
        not_found       = 3
        OTHERS          = 4.
    IF sy-subrc EQ 0.

      ls_trdir-rstat = gwa_report-status.
      ls_trdir-appl  = gwa_report-application.
      ls_trdir-secu  = gwa_report-authorization_group.

      CALL FUNCTION 'RS_TRDIR_UPDATE'
        EXPORTING
          trdir_row       = ls_trdir
        EXCEPTIONS
          internal_error  = 1
          parameter_error = 2
          not_found       = 3.
      IF sy-subrc NE 0.
        RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
          EXPORTING
            textid = /cadaxo/cx_sqlc_temp_rep=>insert_include.
      ENDIF.

    ELSE.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_temp_rep
        EXPORTING
          textid = /cadaxo/cx_sqlc_temp_rep=>insert_include.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
