*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCTIPPSANDTRICKSF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  0100_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM 0100_user_command .
  CASE gv_code.
    WHEN 'OK'.
      gv_res = '1'.
    WHEN 'NEVER'.
      gv_res = '2'.
  ENDCASE.
  SET SCREEN 0.
  LEAVE SCREEN.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_data .
  DATA: lt_text TYPE TABLE OF char255,
        lt_link TYPE TABLE OF /cadaxo/sqlcreli,
        lv_text TYPE char255,
        lv_url  TYPE char255.

  DATA(lo_html_viewer) = NEW cl_gui_html_viewer( parent = NEW cl_gui_custom_container( container_name = 'CC_HTML' ) ).

  CONCATENATE '<html><head><h1>Cadaxo SQL Cockpit ' gv_version ' – Releaseinfos</h1><br><br>' INTO lv_text SEPARATED BY space.
  APPEND lv_text TO lt_text.
  lv_text = '<style> body { background-color: #C6C6C6; } </style>'.
  APPEND lv_text TO lt_text.
  lv_text = '<style> a.one:link {color:#000000;} a.one:visited {color:#000000;} a.one:hover {color:#000000;} </style>'.
  APPEND lv_text TO lt_text.
  lv_text = '</head><body><ul>'.
  APPEND lv_text TO lt_text.
  SELECT *
  INTO CORRESPONDING FIELDS OF TABLE lt_link
  FROM /cadaxo/sqlcreli
  WHERE version = gv_version.
  IF sy-subrc EQ 0.
    LOOP AT lt_link INTO DATA(ls_link).
      lv_text = '<li><a class="one" href="' && ls_link-link && '" target="_blank">' && ls_link-tag && '</a><br><br></li>'.
      APPEND lv_text TO lt_text.
    ENDLOOP.
  ENDIF.
  lv_text = '</ul></body></html>'.
  APPEND lv_text TO lt_text.

  lo_html_viewer->load_data(
    IMPORTING
      assigned_url         = lv_url
    CHANGING
      data_table           = lt_text ).

  lo_html_viewer->show_data( url = lv_url ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_VARIABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_variables .

  SELECT SINGLE parameter_value
    INTO gv_version
    FROM /cadaxo/sqlcparv
    WHERE parameter_id = 'CADAXO_VERSION'.
  IF sy-subrc EQ 0.
    gv_title = 'Cadaxo SQL Cockpit ' && gv_version && ' – Releaseinfos'.
  ELSE.
    gv_title = 'Cadaxo SQL Cockpit 3.7 – Releaseinfos'.
  ENDIF.

  CLEAR: gv_res.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_status .

  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

ENDFORM.
