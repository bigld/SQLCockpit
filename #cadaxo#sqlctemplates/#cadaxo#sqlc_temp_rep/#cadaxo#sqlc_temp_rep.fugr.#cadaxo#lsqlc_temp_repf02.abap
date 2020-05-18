*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_REPF02 .
*----------------------------------------------------------------------*
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 15.10.2013 | Domi Bigl            | new Parameter "No Standard Header"          | RT#171         *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************
*&---------------------------------------------------------------------*
*&      Form  CONTAINER_130
*&---------------------------------------------------------------------*
FORM container_130 .

  DATA: lwa_layout             TYPE lvc_s_layo.
  DATA: lt_fcat                TYPE lvc_t_fcat.
  DATA: lwa_stable_ref         TYPE lvc_s_stbl.
  FIELD-SYMBOLS: <lwa_fcat>    TYPE lvc_s_fcat.

  IF gr_cont IS INITIAL.
    CREATE OBJECT gr_cont
      EXPORTING
        container_name = 'CC_SELSCR'
      EXCEPTIONS
        OTHERS         = 1.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT gr_grid
      EXPORTING
        i_parent      = gr_cont
        i_appl_events = c_false
      EXCEPTIONS
        OTHERS        = 1.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = '/CADAXO/SQLC_TEMP_REP_SEL_STR'
      CHANGING
        ct_fieldcat      = lt_fcat.

    LOOP AT lt_fcat ASSIGNING <lwa_fcat>.
      CASE <lwa_fcat>-fieldname.
        WHEN 'FIELD'.
          <lwa_fcat>-outputlen = 20.
        WHEN 'DESCRIPTION'.
          <lwa_fcat>-outputlen = 20.
        WHEN 'SELOPT_WITH_DEFAULT'
          OR 'SELOPT_WITHOUT_DEFAULT'
          OR 'HARDCODED'.
          <lwa_fcat>-edit      = c_true.
          <lwa_fcat>-outputlen = 10.
          <lwa_fcat>-icon      = abap_true.
          <lwa_fcat>-hotspot   = abap_true.
      ENDCASE.
    ENDLOOP.

    lwa_layout-no_toolbar = c_true.
    lwa_layout-no_rowmark = c_true.
    lwa_layout-stylefname = 'STYLE'.

    CREATE OBJECT gr_handler
      EXPORTING
        i_default_rb = 'SELOPT_WITH_DEFAULT'.

    SET HANDLER gr_handler->hdl_rb_click FOR gr_grid.

    gr_grid->set_table_for_first_display( EXPORTING is_layout       = lwa_layout
                                          CHANGING  it_outtab       = gt_selopt
                                                    it_fieldcatalog = lt_fcat ).
  ELSE.
    lwa_stable_ref-row = c_true.
    lwa_stable_ref-col = c_true.
    gr_grid->refresh_table_display( is_stable = lwa_stable_ref ).
  ENDIF.
ENDFORM.                    " CONTAINER_130
*&---------------------------------------------------------------------*
*&      Form  INIT_SELOPT
*&---------------------------------------------------------------------*
FORM init_selopt .

  DATA: lwa_style TYPE lvc_s_styl.

  IF NOT gr_handler IS INITIAL.
    FREE gr_handler.
  ENDIF.

  IF NOT gr_grid IS INITIAL.
    gr_grid->free( ).
    FREE gr_grid.
  ENDIF.

  IF NOT gr_cont IS INITIAL.
    gr_cont->free( ).
    FREE gr_cont.
  ENDIF.

  CLEAR: gt_selopt.

  LOOP AT gt_where ASSIGNING <wa_where>.
*Subselects
    IF <wa_where>-operator = 'IN'.
      FIND 'SELECT' IN <wa_where>-value.
      IF sy-subrc = 0.
        <wa_where>-generate_option = '03'.
        CONTINUE.
      ELSE.
      ENDIF.
    ENDIF.

*Alias Values
    IF <wa_where>-value+0(1) <> `'` AND <wa_where>-value CA '~'.
      <wa_where>-generate_option = '03'.
      CONTINUE.
    ENDIF.
    APPEND INITIAL LINE TO gt_selopt ASSIGNING <wa_selopt>.
    IF <wa_where>-aliasname IS INITIAL.
      CONCATENATE <wa_where>-tablename
                  '-'
                  <wa_where>-fieldname
                  INTO <wa_selopt>-field.
    ELSE.
      CONCATENATE <wa_where>-aliasname
                  '~'
                  <wa_where>-fieldname
                  INTO <wa_selopt>-field.
    ENDIF.

    IF <wa_where>-value(1) = '&'.
      <wa_selopt>-selopt_with_default    = icon_wd_radio_button_empty..
      <wa_selopt>-selopt_without_default = icon_radiobutton.
      <wa_selopt>-hardcoded              = icon_wd_radio_button_empty.
    ELSE.
      <wa_selopt>-selopt_with_default    = icon_radiobutton.
      <wa_selopt>-selopt_without_default = icon_wd_radio_button_empty.
      <wa_selopt>-hardcoded              = icon_wd_radio_button_empty.
    ENDIF.
    <wa_selopt>-description = <wa_where>-fielddescr.

*  CDX130-012 Begin
*  LIKE, type D or N --> only selopt_without_default
    IF <wa_where>-type_kind CA 'DN' AND <wa_where>-operator = 'LIKE'.
      <wa_selopt>-selopt_with_default    = icon_wd_radio_button_empty.
      <wa_selopt>-selopt_without_default = icon_radiobutton.
      lwa_style-fieldname = 'SELOPT_WITH_DEFAULT'.
      lwa_style-style = cl_gui_alv_grid=>mc_style_disabled + cl_gui_alv_grid=>mc_style_hotspot_no.
      INSERT lwa_style INTO TABLE <wa_selopt>-style.
    ENDIF.
*  CDX130-012 End
  ENDLOOP.

* UP TO
  APPEND INITIAL LINE TO gt_selopt ASSIGNING <wa_selopt>.
  <wa_selopt>-field                  = 'UP_TO_[X]_ROWS'.
  <wa_selopt>-description            = text-d01.
  <wa_selopt>-selopt_without_default = icon_radiobutton.
  <wa_selopt>-selopt_with_default    = icon_wd_radio_button_empty.
  <wa_selopt>-hardcoded              = icon_wd_radio_button_empty.
* only no def
  lwa_style-fieldname = 'SELOPT_WITH_DEFAULT'.
  lwa_style-style = cl_gui_alv_grid=>mc_style_disabled + cl_gui_alv_grid=>mc_style_hotspot_no.
  INSERT lwa_style INTO TABLE <wa_selopt>-style.
  lwa_style-fieldname = 'HARDCODED'.
  lwa_style-style = cl_gui_alv_grid=>mc_style_disabled + cl_gui_alv_grid=>mc_style_hotspot_no.
  INSERT lwa_style INTO TABLE <wa_selopt>-style.
  lwa_style-fieldname = 'SELOPT_WITHOUT_DEFAULT'.
  lwa_style-style = cl_gui_alv_grid=>mc_style_disabled + cl_gui_alv_grid=>mc_style_hotspot_no.
  INSERT lwa_style INTO TABLE <wa_selopt>-style.


ENDFORM.                    " INIT_SELOPT
*&---------------------------------------------------------------------*
*&      Form  get_selopt
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_selopt.

  DATA: l_tablename TYPE tabname16.
  DATA: l_aliasname TYPE /cadaxo/sqlctablealias.
  DATA: l_fieldname TYPE /cadaxo/sqlcfieldname.

  LOOP AT gt_selopt ASSIGNING <wa_selopt>.

    CLEAR l_aliasname.
    CLEAR l_fieldname.

    SPLIT <wa_selopt>-field AT '~' INTO l_aliasname l_fieldname.
    IF sy-subrc = 0 AND l_fieldname IS NOT INITIAL.
      READ TABLE gt_where ASSIGNING <wa_where> WITH KEY aliasname = l_aliasname
                                                        fieldname = l_fieldname.
    ELSE.
      SPLIT <wa_selopt>-field AT '-' INTO l_tablename l_fieldname.
      READ TABLE gt_where ASSIGNING <wa_where> WITH KEY tablename = l_tablename
                                                        fieldname = l_fieldname.
    ENDIF.
    IF sy-subrc <> 0 AND ( l_tablename = 'UP_TO_[X]_ROWS' OR l_aliasname = 'UP_TO_[X]_ROWS' ).
      APPEND INITIAL LINE TO gt_where ASSIGNING <wa_where>.
      <wa_where>-wildcard_operator = '__UPT'.
      <wa_where>-fieldname         = 'INT4'.
      <wa_where>-fielddescr        = text-upt.
    ENDIF.

    CASE icon_radiobutton.
      WHEN <wa_selopt>-selopt_with_default.
        MOVE '01' TO <wa_where>-generate_option.
      WHEN <wa_selopt>-selopt_without_default.
        MOVE '02' TO <wa_where>-generate_option.
      WHEN <wa_selopt>-hardcoded.
        MOVE '03' TO <wa_where>-generate_option.
    ENDCASE.

  ENDLOOP.
ENDFORM.                    "get_selopt

*&---------------------------------------------------------------------*
*&      Form  get_enh_include
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_enh_include.

  DATA lt_coding        TYPE /cadaxo/sqlc_temp_rep_codelnst.
  DATA lt_coding_new    TYPE /cadaxo/sqlc_temp_rep_codelnst.
  DATA lt_comp          TYPE abap_compdescr_tab.
  DATA lcl_structtype   TYPE REF TO cl_abap_structdescr.
  DATA ls_str           TYPE string.
  DATA dref             TYPE REF TO data.
  DATA l_idx            TYPE i.
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

  FIELD-SYMBOLS: <field>     TYPE any,
                 <field_new> TYPE any,
                 <comp>      LIKE LINE OF lt_comp.

  CLEAR gs_evt_new.

  IF gs_report_attr-enh_include IS INITIAL.
    CLEAR gs_evt.
    RETURN.
  ENDIF.

* Check Include doesn't exist
  SELECT COUNT( * ) FROM reposrc WHERE progname = gs_report_attr-enh_include AND subc = 'I'.
  IF sy-subrc = 0. "exists
    gs_evt-enh_before_select  = abap_false.
    gs_evt-enh_after_select   = abap_false.
    gs_evt-enh_before_display = abap_false.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE gs_evt TO <field>.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      l_idx = sy-index.
      IF <field> IS NOT INITIAL.
        lcl_structtype ?= cl_abap_structdescr=>describe_by_data( gs_evt ).
        READ TABLE lcl_structtype->components  ASSIGNING <comp> INDEX l_idx.
        IF sy-subrc = 0.
          CONCATENATE 'DO_'  <comp>-name INTO ls_str.
*         find form in include
          CLEAR lt_form_tab[].
          READ REPORT gs_report_attr-enh_include INTO lt_source.
          CALL FUNCTION 'RS_SEARCH_FORM'
            EXPORTING
              i_incl        = gs_report_attr-enh_include
              i_mainprogram = gs_report_attr-report
              i_objectname  = ls_str
              i_changed     = abap_true
              i_external    = abap_true
              no_dialog     = abap_true
            IMPORTING
              o_incl        = l_incl
              o_objectname  = l_objectname
              o_objecttype  = l_objecttype
              o_program     = l_program
              o_operation   = l_operation
              o_row         = l_row
              o_col         = l_col
              o_eventtype   = l_eventtype
              o_local       = l_local
            TABLES
              i_source      = lt_source
              o_form_tab    = lt_form_tab.
          IF lt_form_tab IS INITIAL.  "form is new
            ASSIGN COMPONENT l_idx OF STRUCTURE gs_evt_new TO <field_new>.
            IF sy-subrc = 0.
              <field_new> = abap_true.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDDO.
  ELSE.
    MOVE gs_evt TO gs_evt_new.
    gs_evt-enh_before_select  = abap_true.
    gs_evt-enh_after_select   = abap_true.
    gs_evt-enh_before_display = abap_true.
  ENDIF.

ENDFORM.                    "get_enh_include
*&---------------------------------------------------------------------*
*&      Form  SET_SUMMARY
*&---------------------------------------------------------------------*
FORM set_summary .

  DATA: l_string             TYPE char100.
  DATA: lwa_dd07v            TYPE dd07v.
  FIELD-SYMBOLS: <fs_swcont> TYPE swcont.

  build_symbols report gs_report_attr-report.
  build_symbols title gs_report_attr-title.
  lwa_dd07v-domvalue_l = gs_report_attr-status.
  CALL FUNCTION 'DD_DOMVALUE_TEXT_GET'
    EXPORTING
      domname  = 'RSTAT'
      value    = lwa_dd07v-domvalue_l
    IMPORTING
      dd07v_wa = lwa_dd07v.
  CLEAR l_string.
  CONCATENATE gs_report_attr-status lwa_dd07v-ddtext INTO l_string SEPARATED BY space.
  build_symbols status l_string.
  CLEAR l_string.
  SELECT SINGLE atext FROM taplt INTO l_string WHERE appl  = gs_report_attr-application
                                                 AND sprsl = sy-langu.
  CONCATENATE gs_report_attr-application l_string INTO l_string SEPARATED BY space.
  build_symbols application l_string.
  build_symbols authorization_group gs_report_attr-authorization_group.
  IF g_templ_name = '/CADAXO/REPORT_A'.
    build_symbols header_include gs_report_attr-header_include.
    build_symbols enh_include    gs_report_attr-enh_include."CDX130-025
  ENDIF.

  CONCATENATE gs_report_attr-schemeprogram '->' gs_report_attr-schemename INTO l_string.
  build_symbols schemename l_string.

  IF g_templ_name = '/CADAXO/REPORT_A'.
    build_symbols authcheck gs_report_attr-authcheck.
    build_symbols layout gs_report_attr-layout. "TODO - Get Longtext!
  ENDIF.

ENDFORM.                    " SET_SUMMARY
*&---------------------------------------------------------------------*
*&      Form  CHECK_REPORT
*&---------------------------------------------------------------------*
FORM check_report USING VALUE(u_obj).

  DATA: l_ns       TYPE namespace.
  DATA: l_text     TYPE string.
  DATA: l_answer   TYPE c.
  DATA: l_icon_gen TYPE iconname.
  DATA: l_text_gen TYPE itex132.
  FIELD-SYMBOLS: <l_attr_prog>    TYPE any.
  FIELD-SYMBOLS: <l_checked_prog> TYPE any.
  FIELD-SYMBOLS: <l_locked_prog>  TYPE any.

  TRANSLATE u_obj TO UPPER CASE.

  ASSIGN COMPONENT u_obj OF STRUCTURE gs_report_attr TO <l_attr_prog>.
  CHECK sy-subrc = 0.
  ASSIGN COMPONENT u_obj OF STRUCTURE wa_checked     TO <l_checked_prog>.
  ASSIGN COMPONENT u_obj OF STRUCTURE wa_locked      TO <l_locked_prog>.

  CHECK <l_attr_prog> <> <l_checked_prog>.

  TRANSLATE <l_attr_prog> TO UPPER CASE.

  IF gs_report_attr IS NOT INITIAL AND <l_locked_prog> <> <l_attr_prog>
     AND <l_locked_prog> NE space.
    CALL FUNCTION 'DEQUEUE_ESRDIRE'
      EXPORTING
        _scope     = 3
        mode_trdir = c_true
        name       = <l_locked_prog>.
    CLEAR <l_locked_prog>.
  ENDIF.

  IF <l_locked_prog> IS INITIAL.
    CALL FUNCTION 'ENQUEUE_ESRDIRE'
      EXPORTING
        _scope         = 1
        mode_trdir     = c_true
        name           = <l_attr_prog>
      EXCEPTIONS
        foreign_lock   = 01
        system_failure = 02.

    IF sy-subrc <> 0.
      IF sy-msgv1 <> sy-uname.
        MESSAGE e012(/cadaxo/sqlctemplate) WITH <l_attr_prog> sy-msgv1.
      ELSE.
        MESSAGE e012(/cadaxo/sqlctemplate) WITH <l_attr_prog> text-you.
      ENDIF.
    ENDIF.
    <l_locked_prog> = <l_attr_prog>.
  ENDIF.

  SELECT SINGLE name FROM progdir INTO gs_report_attr-report
                                  WHERE name = <l_attr_prog>
                                    AND state = 'I'.
  IF sy-subrc = 0.
    CALL FUNCTION 'DEQUEUE_ESRDIRE'
      EXPORTING
        _scope     = 3
        mode_trdir = c_true
        name       = <l_locked_prog>.
    CLEAR <l_locked_prog>.

    MESSAGE e011(/cadaxo/sqlctemplate).
  ELSE.
    SELECT SINGLE name FROM progdir INTO <l_attr_prog>
                                    WHERE name = <l_attr_prog>
                                      AND state = 'A'.
    IF sy-subrc = 0.
      CASE u_obj.
        WHEN 'REPORT'.
          CONCATENATE text-p03 <l_attr_prog> text-p04 text-p05 INTO l_text SEPARATED BY space.
          l_icon_gen = 'ICON_GENERATE'.
          l_text_gen = text-p01.
        WHEN 'ENH_INCLUDE'.
          CONCATENATE text-p13 <l_attr_prog> text-p14 text-p05 INTO l_text SEPARATED BY space.
          l_icon_gen = 'ICON_CHANGE_TEXT'.
          l_text_gen = text-p10.
      ENDCASE.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = text-p00
          text_question         = l_text
          text_button_1         = l_text_gen
          icon_button_1         = l_icon_gen
          text_button_2         = text-p02
          icon_button_2         = 'ICON_INCOMPLETE'
          default_button        = '1'
          display_cancel_button = ''
          popup_type            = 'ICON_MESSAGE_ERROR'
        IMPORTING
          answer                = l_answer.
      IF l_answer = 2.
        CALL FUNCTION 'DEQUEUE_ESRDIRE'
          EXPORTING
            _scope     = 3
            mode_trdir = c_true
            name       = <l_locked_prog>.
        CLEAR <l_locked_prog>.

        MESSAGE e013(/cadaxo/sqlctemplate) DISPLAY LIKE 'I'.
      ELSEIF l_answer = 1.
        IF ok_code = 'NEXTSTEP'.
          CLEAR ok_code.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.


* END

  CALL FUNCTION 'RS_PROGNAME_SPLIT'
    EXPORTING
      progname_with_namespace = <l_attr_prog>
    IMPORTING
      namespace               = l_ns.
  IF NOT l_ns IS INITIAL.
    CALL FUNCTION 'TR_CHECK_NAMESPACE'
      EXPORTING
        iv_namespace        = l_ns
        iv_edit_only        = c_true
        iv_producer_only    = c_true
        iv_licensed_only    = c_true
      EXCEPTIONS
        namespace_not_valid = 1
        OTHERS              = 2.
    IF sy-subrc <> 0.
      CALL FUNCTION 'DEQUEUE_ESRDIRE'
        EXPORTING
          _scope     = 3
          mode_trdir = c_true
          name       = <l_locked_prog>.
      CLEAR <l_locked_prog>.

      MESSAGE e010(/cadaxo/sqlctemplate).
    ENDIF.
  ELSE.
    IF <l_attr_prog>+0(1) <> 'Z' AND <l_attr_prog>+0(1) <> 'Y'.
      CALL FUNCTION 'DEQUEUE_ESRDIRE'
        EXPORTING
          _scope     = 3
          mode_trdir = c_true
          name       = <l_locked_prog>.
      CLEAR <l_locked_prog>.

      MESSAGE e010(/cadaxo/sqlctemplate).
    ENDIF.
  ENDIF.
  CALL FUNCTION 'RS_PROGRAM_CHECK_NAME'
    EXPORTING
      progname = <l_attr_prog>.

  <l_checked_prog> = <l_attr_prog>.
ENDFORM.                    " CHECK_REPORT
*&---------------------------------------------------------------------*
*&      Form  CHECK_HEADERINCLUDE
*&---------------------------------------------------------------------*
FORM check_headerinclude.
  DATA: l_subc TYPE subc.

  SELECT SINGLE subc FROM reposrc INTO l_subc WHERE progname = gs_report_attr-header_include AND subc = 'I'.
  IF sy-subrc <> 0.
    MESSAGE e014(/cadaxo/sqlctemplate).
  ENDIF.

ENDFORM.                    "check_headerinclude
*&---------------------------------------------------------------------*
*&      Form  CHECK_ENHANCEINCLUDE
*&---------------------------------------------------------------------*
FORM check_enhanceinclude.
  DATA: l_subc TYPE subc.
  DATA: l_ns   TYPE namespace.

* set generated Includename
  IF gs_report_attr-enh_include IS INITIAL.
    gs_report_attr-enh_include = gs_report_attr-enh_include_gen.
  ENDIF.
  CLEAR gs_report_attr-enh_include_gen.

  IF NOT gs_report_attr-enh_include IS INITIAL.
    PERFORM check_report USING 'ENH_INCLUDE'.
  ELSEIF gs_evt IS NOT INITIAL.
    MESSAGE e016(/cadaxo/sqlctemplate).
*   Please enter or generate an form include name
  ENDIF.
ENDFORM.                    "check_headerinclude

*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND_0100
*&---------------------------------------------------------------------*
FORM user_command_0100 .

  DATA: l_index  TYPE i.
  DATA: l_answer TYPE c.

  CASE ok_code.
    WHEN 'CANCEL'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = text-p06
          text_question         = text-p07
          text_button_1         = text-p08
          icon_button_1         = 'ICON_CHECKED'
          text_button_2         = text-p09
          icon_button_2         = 'ICON_INCOMPLETE'
          default_button        = '2'
          display_cancel_button = ''
          popup_type            = 'ICON_MESSAGE_ERROR'
        IMPORTING
          answer                = l_answer.
      IF l_answer = 1.
        IF NOT wa_locked IS INITIAL.
          CALL FUNCTION 'DEQUEUE_ESRDIRE'
            EXPORTING
              _scope     = 3
              mode_trdir = c_true
              name       = wa_locked-report.
          CALL FUNCTION 'DEQUEUE_ESRDIRE'
            EXPORTING
              _scope     = 3
              mode_trdir = c_true
              name       = wa_locked-enh_include.
          CLEAR wa_locked.
        ENDIF.
        RAISE cancel_by_user.
      ENDIF.

    WHEN 'COMPLETE'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'NEXTSTEP'.
      l_index = g_current_step_index.
      DO g_total_steps TIMES.
        l_index = l_index + 1.
        READ TABLE gt_roadmap INDEX l_index ASSIGNING <gs_roadmap>.
        IF sy-subrc EQ 0 AND NOT <gs_roadmap>-step_visible IS INITIAL.
          <gs_roadmap>-step_active = 'X'.
          g_current_step = <gs_roadmap>-step_id.
          EXIT.
        ENDIF.
      ENDDO.
    WHEN 'PREVSTEP'.
      l_index = g_current_step_index.
      DO g_total_steps TIMES.
        l_index = l_index - 1.
        READ TABLE gt_roadmap INDEX l_index ASSIGNING <gs_roadmap>.
        IF sy-subrc EQ 0 AND NOT <gs_roadmap>-step_visible IS INITIAL.
          g_current_step = <gs_roadmap>-step_id.
          EXIT.
        ENDIF.
      ENDDO.
    WHEN 'HELP'.
      PERFORM show_help.
    WHEN 'EVNT_SEL_ALL'.
      PERFORM evnt_sel USING abap_true.
    WHEN 'EVNT_SEL_NONE'.
      PERFORM evnt_sel USING abap_false.
    WHEN 'GEN_INCL_NAME'.
      PERFORM gen_inc_name USING    gs_report_attr-report
                           CHANGING gs_report_attr-enh_include_gen.
      gs_report_attr-enh_include = gs_report_attr-enh_include_gen.
  ENDCASE.

ENDFORM.                    " USER_COMMAND_0100
*&---------------------------------------------------------------------*
*&      Form  SHOW_HELP
*&---------------------------------------------------------------------*
FORM show_help .

  DATA: l_html_id                TYPE char80.
  DATA: l_html_id_langu          TYPE char80.
  DATA: l_url                    TYPE char255.

  l_html_id = '/CADAXO/SQLC_REPGENDOKU'.
  CONCATENATE l_html_id '_' sy-langu INTO l_html_id_langu.

  gc_description->load_mime_object(
    EXPORTING
      object_id            = l_html_id_langu
    IMPORTING
      assigned_url         = l_url
    EXCEPTIONS
      object_not_found     = 1
      dp_invalid_parameter = 2
      dp_error_general     = 3 ).
  IF sy-subrc <> 0.
    gc_description->load_mime_object(
      EXPORTING
        object_id            = l_html_id
      IMPORTING
        assigned_url         = l_url
      EXCEPTIONS
        object_not_found     = 1
        dp_invalid_parameter = 2
        dp_error_general     = 3 ).
  ENDIF.

  IF sy-subrc = 0.
    gc_description->show_url(
  EXPORTING
    url                    = l_url
    in_place               = space
  EXCEPTIONS
    dp_error_general       = 1 ).
  ELSE.

  ENDIF.




ENDFORM.                    " SHOW_HELP
*&---------------------------------------------------------------------*
*&      Form  LOAD_REPORT_SETTINGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM load_report_settings .
  DATA: ls_sqlctemr        TYPE /cadaxo/sqlctemr,
        l_xml              TYPE string,
        ls_sqlctemprepsave TYPE /cadaxo/sqlctemprepsave,
        lt_sqlctemprepsave TYPE TABLE OF /cadaxo/sqlctemprepsave,
        ls_selopt          TYPE /cadaxo/sqlc_temp_rep_sel_str.

  CHECK g_sett_loaded IS INITIAL.
  CHECK gs_report_attr-report IS NOT INITIAL.

  SELECT SINGLE * FROM /cadaxo/sqlctemr INTO ls_sqlctemr
         WHERE report = gs_report_attr-report.

  CHECK sy-subrc = 0.

  cl_abap_gzip=>decompress_text(
    EXPORTING
      gzip_in  = ls_sqlctemr-reportsettings
    IMPORTING
      text_out = l_xml ).

  CALL TRANSFORMATION id
    SOURCE XML l_xml
    RESULT result_save = lt_sqlctemprepsave.

  FREE: l_xml.
  FREE: ls_sqlctemr.

  LOOP AT lt_sqlctemprepsave INTO ls_sqlctemprepsave.
    MOVE ls_sqlctemprepsave-report-title               TO gs_report_attr-title.
    MOVE ls_sqlctemprepsave-report-status              TO gs_report_attr-status.
    MOVE ls_sqlctemprepsave-report-application         TO gs_report_attr-application.
    MOVE ls_sqlctemprepsave-report-authorization_group TO gs_report_attr-authorization_group.
    MOVE ls_sqlctemprepsave-report-authcheck           TO gs_report_attr-authcheck.
    MOVE ls_sqlctemprepsave-report-header_include      TO gs_report_attr-header_include.
    MOVE ls_sqlctemprepsave-report-enh_include         TO gs_report_attr-enh_include.
    MOVE ls_sqlctemprepsave-report-devclass            TO gs_report_attr-devclass.
    MOVE ls_sqlctemprepsave-report-layout TO gs_report_attr-layout .
    MOVE ls_sqlctemprepsave-events                     TO gs_evt.
*bigld102013 Insert                                                                                "RT#171
    MOVE ls_sqlctemprepsave-report-header_nostd        TO gs_report_attr-header_nostd."RT#171
*bigld102013 Insert End                                                                            "RT#171

  ENDLOOP.

  LOOP AT gt_selopt ASSIGNING <wa_selopt>.
    READ TABLE ls_sqlctemprepsave-selopt INTO ls_selopt WITH KEY field = <wa_selopt>-field.
    IF sy-subrc = 0.
      <wa_selopt>-selopt_with_default    = ls_selopt-selopt_with_default.
      IF <wa_selopt>-selopt_with_default = 'X'.
        <wa_selopt>-selopt_with_default = icon_radiobutton.
      ELSEIF <wa_selopt>-selopt_with_default IS INITIAL.
        <wa_selopt>-selopt_with_default = icon_wd_radio_button_empty.
      ENDIF.
      <wa_selopt>-selopt_without_default = ls_selopt-selopt_without_default.
      IF <wa_selopt>-selopt_without_default = 'X'.
        <wa_selopt>-selopt_without_default = icon_radiobutton.
      ELSEIF <wa_selopt>-selopt_without_default IS INITIAL.
        <wa_selopt>-selopt_without_default = icon_wd_radio_button_empty.
      ENDIF.
      <wa_selopt>-hardcoded              = ls_selopt-hardcoded.
      IF <wa_selopt>-hardcoded = 'X'.
        <wa_selopt>-hardcoded = icon_radiobutton.
      ELSEIF <wa_selopt>-hardcoded IS INITIAL.
        <wa_selopt>-hardcoded = icon_wd_radio_button_empty.
      ENDIF.
    ENDIF.
  ENDLOOP.

  g_sett_loaded = abap_true.

ENDFORM.                    " LOAD_REPORT_SETTINGS
*&---------------------------------------------------------------------*
*&      Form  EVNT_SEL
*&---------------------------------------------------------------------*
FORM evnt_sel  USING    u_all.
  IF u_all = abap_true.
    gs_evt = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'.
  ELSE.
    CLEAR gs_evt.
  ENDIF.
ENDFORM.                    " EVNT_SEL

*&---------------------------------------------------------------------*
*&      Form  GEN_INC_NAME
*&---------------------------------------------------------------------*
FORM gen_inc_name USING    u_repname
                  CHANGING uc_incname.

  IF strlen( u_repname ) > 26.
    CONCATENATE u_repname(26) '_FC1' INTO uc_incname.
  ELSE.
    CONCATENATE u_repname '_FC1' INTO uc_incname.
  ENDIF.

ENDFORM.                    "GEN_INC_NAME
