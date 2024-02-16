*---------------------------------------------------------------------*
*              Scheme Types                                           *
*---------------------------------------------------------------------*
/>REPORT2</
*:RT#171
{C$GS_REPORT_ATTR-HEADER_NOSTD <> 'X'$
*---------------------------------------------------------------------*
* Report  &GS_REPORT_ATTR-REPORT&
*
*---------------------------------------------------------------------*
* This Report was generated with CADAXO SQL Cockpit
*
* User:  &SY-UNAME&
* Date:  &SY-DATUM&
*
*---------------------------------------------------------------------*
$}REPORT &GS_REPORT_ATTR-REPORT&.
{T$GST_HEADER$$$
*&GST_HEADER-LINE&$$}
{C$GS_REPORT_ATTR-ENH_INCLUDE <> ''$
INCLUDE &GS_REPORT_ATTR-ENH_INCLUDE& IF FOUND.$}

**********************************************************************
* Data Definition
**********************************************************************
DATA: gr_dref              TYPE REF TO data.
DATA: gr_table             TYPE REF TO cl_salv_table.
DATA: gv_dbcnt             TYPE cua_tit_tx.
DATA g_layout TYPE REF TO cl_salv_layout.
DATA g_key TYPE salv_s_layout_key.
{C$GS_EVT$
CLASS lcl_handle_events    DEFINITION DEFERRED.
DATA: gr_event_handler     TYPE REF TO lcl_handle_events.
$}
{C$G_SELECT_SINGLE = 'X'$
FIELD-SYMBOLS: <gt_table>  TYPE STANDARD TABLE.
$}
{T$GST_RANGES$$$
RANGES: &GST_RANGES-PARAMNAME& FOR &GST_RANGES-TABLENAME&-\
&GST_RANGES-FIELDNAME&.$$}
{C$GS_EVT$
**--------------------------------------------------------------------
**       CLASS lcl_handle_events DEFINITION
**--------------------------------------------------------------------
*
CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.

  {C$GS_EVT-TOP_OF_PAGE = 'X'$
    METHODS: hdl_top_of_page FOR EVENT top_of_page \
    \OF cl_salv_events_table
             IMPORTING r_top_of_page page table_index.$}
  {C$GS_EVT-END_OF_PAGE = 'X'$
    METHODS: hdl_end_of_page FOR EVENT end_of_page \
    \OF cl_salv_events_table
             IMPORTING r_end_of_page page.$}
  {C$GS_EVT-BEFORE_SALV_FUNC = 'X'$
    METHODS: hdl_before_salv_function FOR EVENT before_salv_function \
    \OF cl_salv_events_table
             IMPORTING e_salv_function.$}
  {C$GS_EVT-AFTER_SALV_FUNC = 'X'$
    METHODS: hdl_after_salv_function FOR EVENT after_salv_function \
    \OF cl_salv_events_table
             IMPORTING e_salv_function.$}
  {C$GS_EVT-ADDED_FUNC = 'X'$
    METHODS: hdl_added_function FOR EVENT added_function \
    \OF cl_salv_events_table
             IMPORTING e_salv_function.$}
  {C$GS_EVT-DOUBLE_CLICK = 'X'$
    METHODS: hdl_double_click FOR EVENT double_click \
    \OF cl_salv_events_table
             IMPORTING row column.$}
  {C$GS_EVT-LINK_CLICK = 'X'$
    METHODS: hdl_link_click FOR EVENT link_click \
    \OF cl_salv_events_table
             IMPORTING row column.$}

ENDCLASS.                    "lcl_handle_events DEFINITION
$}\
**********************************************************************
* Selection Screen
**********************************************************************
{T$GST_TABNAMES$TABLES:$$&GST_TABNAMES-TABNAME&$, $.}
SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE text-t01.
*:    begin of change#cockpit-456/455
{C$GS_REPORT_ATTR-TAB_BLKS = ''$\
*:    end of change#cockpit-456/455
{T$GST_WHERE WHERE generate_option <> '03'$$$
{C$GST_WHERE-PARAMNAME = 'UPT'$
PARAMETERS: p_&GST_WHERE-PARAMNAME& TYPE$ \
SELECT-OPTIONS: p_&GST_WHERE-PARAMNAME& FOR} \
{C$GST_WHERE-TABLENAME$&GST_WHERE-TABLENAME&-$}\
&GST_WHERE-FIELDNAME&.$$}
*: begin of change / continuation of the else from C#cockpit-456/455
$\
{T$GST_TABNAMES$$$
  SELECTION-SCREEN BEGIN OF BLOCK blk_&GST_TABNAMES-TABNAME& \
  WITH FRAME TITLE t&GST_TABNAMES-TABNAME&.
{T$GST_WHERE WHERE generate_option <> '03'$$$\
{C$GST_WHERE-TABLENAME = GST_TABNAMES-TABNAME$
{C$GST_WHERE-PARAMNAME = 'UPT'$\
PARAMETERS: p_&GST_WHERE-PARAMNAME& TYPE$ \
SELECT-OPTIONS: p_&GST_WHERE-PARAMNAME& FOR} \
{C$GST_WHERE-TABLENAME$&GST_WHERE-TABLENAME&-$}\
&GST_WHERE-FIELDNAME&.$}$$}":.$$}
SELECTION-SCREEN END OF BLOCK blk_&GST_TABNAMES-TABNAME&.$$}
{T$GST_WHERE WHERE PARAMNAME = 'UPT'$$$
PARAMETERS: p_&GST_WHERE-PARAMNAME& TYPE \
&GST_WHERE-FIELDNAME&.$$}
}
{C$GS_REPORT_ATTR-OUTPUT_LAYOUT NE ''$\
SELECTION-SCREEN BEGIN OF LINE. SELECTION-SCREEN COMMENT (31) label.
PARAMETERS: p_layout TYPE slis_vari LOWER CASE.
SELECTION-SCREEN COMMENT (10) tvar. SELECTION-SCREEN END OF LINE.
$}
*: end of change#cockpit-456/455
SELECTION-SCREEN: END OF BLOCK bl1.

**********************************************************************
* Initialization
**********************************************************************
INITIALIZATION.
PERFORM initialization.

": begin of change#cockpit-456/455
**********************************************************************
* selection screen output
**********************************************************************
AT SELECTION-SCREEN OUTPUT.

{C$GS_REPORT_ATTR-TAB_BLKS = 'X'$\
DATA lv_table_desc TYPE as4text.
{T$GST_TABNAMES$$${C$GST_TABNAMES-TABNAME$
SELECT SINGLE ddtext
FROM dd02t INTO lv_table_desc
WHERE tabname    = '&GST_TABNAMES-TABNAME&'
  AND ddlanguage = '&sy-langu&'.
t&GST_TABNAMES-TABNAME& = lv_table_desc.$}$$}
$}
{C$GS_REPORT_ATTR-OUTPUT_LAYOUT NE ''$\
  label = 'Layout'.
  tvar = p_layout.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.
  PERFORM select_layout.
$}
": end of change#cockpit-456/455
**********************************************************************
* Start of Selection
**********************************************************************
START-OF-SELECTION.

PERFORM authority_check.

PERFORM ENH_BEFORE_SELECT
  IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND.

gv_dbcnt = '0'.
{T$GST_SQL$$$
&GST_SQL-LINE&$$}.
IF sy-subrc = 0.
WRITE sy-dbcnt TO gv_dbcnt LEFT-JUSTIFIED.
ENDIF.

PERFORM create_alv_table.

PERFORM set_layout.

PERFORM register_events.

SET TITLEBAR 'ALV_LIST' OF PROGRAM \
'/CADAXO/SAPLSQLC_TEMP_REP' WITH text-t00 gv_dbcnt. \
"Just an example if Cadaxo Cockpit is installed: &1 &2 hits

{C$G_SELECT_SINGLE = 'X'$
PERFORM ENH_BEFORE_DISPLAY
  IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
  TABLES   <gt_table>
  USING    gr_table.
$PERFORM ENH_BEFORE_DISPLAY
  IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
  TABLES   tab_result
  USING    gr_table.
}

gr_table->display( ).

**********************************************************************
* End of Selection
**********************************************************************
END-OF-SELECTION.

FORM initialization.
{T$GST_INIT$$$
{C$GST_INIT-NOT = 'X'$
&GST_INIT-PARAMNAME&-SIGN = 'E'.$
&GST_INIT-PARAMNAME&-SIGN = 'I'.}
&GST_INIT-PARAMNAME&-OPTION = '&GST_INIT-OPERATOR&'.
&GST_INIT-PARAMNAME&-LOW = &GST_INIT-VALUE&.
{C$GST_INIT-HIGHVALUE$&GST_INIT-PARAMNAME&-HIGH = \
&GST_INIT-HIGHVALUE&.$}
APPEND &GST_INIT-PARAMNAME&. $$}
ENDFORM.

": begin of change#cockpit-456/455
{C$GS_REPORT_ATTR-OUTPUT_LAYOUT NE ''$\
FORM select_layout.
  DATA: ls_layout_key  TYPE salv_s_layout_key,
        ls_layout_info TYPE salv_s_layout_info.
 ls_layout_key-report = sy-repid.
 ls_layout_info = cl_salv_layout_service=>f4_layouts( ls_layout_key ).
 p_layout = ls_layout_info-layout.
ENDFORM.                    "select_layout
$}
": end   of change#cockpit-456/455

FORM authority_check.
*:{T$GST_TABCLASSES_AC$$$
*:AUTHORITY-CHECK OBJECT 'S_TABU_DIS'
*:       ID 'DICBERCLS' FIELD '&GST_TABCLASSES_AC-CCLASS&'
*:       ID 'ACTVT' FIELD '03'.
*:if sy-subrc <> 0.
*:  MESSAGE ID 'MO' TYPE 'E' NUMBER 419.
*:endif.
*:$$}
* Backward compatibility
{T$GST_AUTH_TABNAMES$$$
      CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
        EXPORTING
          view_action                    = 'U'
          view_name                      = \
          '&GST_AUTH_TABNAMES-TABNAME&'
          no_warning_for_clientindep     = 'X'
        EXCEPTIONS
          OTHERS                         = 1.
      IF sy-subrc NE 0.
        CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
          EXPORTING
            view_action                    = 'S'
            view_name                      = \
            '&GST_AUTH_TABNAMES-TABNAME&'
            no_warning_for_clientindep     = 'X'
          EXCEPTIONS
            OTHERS                         = 1.
      ENDIF.
      IF sy-subrc <> 0.
        MESSAGE ID 'MO' TYPE 'E' NUMBER 419.
      ENDIF.
$$}
ENDFORM.

FORM create_alv_table.

  {C$G_SELECT_SINGLE = 'X'$
{C$gss_fcat$
  DATA(lr_result_type) = cl_abap_typedescr=>describe_by_data( \
tab_line ).
  TRY.
      DATA: lr_result_elem TYPE REF TO cl_abap_elemdescr.
      lr_result_elem ?= lr_result_type.
      DATA(lr_result_struct) = cl_abap_structdescr=>create( \
EXPORTING p_components = \
VALUE cl_abap_structdescr=>component_table( ( \
name = '&GSS_FCAT-FIELDNAME&'
                                                   \
                                        type = lr_result_elem ) ) ).
      DATA(lr_result_table) = cl_abap_tabledescr=>create( \
EXPORTING p_line_type = lr_result_struct ).

      CREATE DATA gr_dref TYPE HANDLE lr_result_table.
    CATCH cx_sy_move_cast_error.
      CREATE DATA gr_dref LIKE TABLE OF tab_line.
  ENDTRY.
$
CREATE DATA gr_dref LIKE TABLE OF tab_line.
}
  ASSIGN gr_dref->* TO <gt_table>.
  IF NOT tab_line IS INITIAL AND <gt_table> IS ASSIGNED.
    APPEND tab_line TO <gt_table>.
  ENDIF.

  PERFORM ENH_AFTER_SELECT
    IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
    TABLES <gt_table>.

TRY.
    cl_salv_table=>factory( EXPORTING list_display = \
if_salv_c_bool_sap=>false
                            IMPORTING r_salv_table = gr_table
                            CHANGING  t_table      = \
<gt_table> ).
  CATCH cx_salv_msg.
ENDTRY.
$

PERFORM ENH_AFTER_SELECT
  IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
  TABLES tab_result.

TRY.
    cl_salv_table=>factory( EXPORTING list_display = \
if_salv_c_bool_sap=>false
                            IMPORTING r_salv_table = gr_table
                            CHANGING  t_table      = \
tab_result ).
  CATCH cx_salv_msg.
ENDTRY.
}
ENDFORM.
FORM set_layout.

DATA: lr_cols TYPE REF TO cl_salv_columns.
DATA: lr_col  TYPE REF TO cl_salv_column.

{C$GS_REPORT_ATTR-LAYOUT <> ''$
g_layout = gr_table->get_layout( ).
g_key-report = sy-repid.
g_layout->set_key( g_key ).$}
{C$GS_REPORT_ATTR-LAYOUT = 1$
g_layout->set_save_restriction( \
if_salv_c_layout=>RESTRICT_USER_INDEPENDANT ).$}
{C$GS_REPORT_ATTR-LAYOUT = 2$
g_layout->set_save_restriction( \
if_salv_c_layout=>RESTRICT_USER_DEPENDANT ).$}
{C$GS_REPORT_ATTR-LAYOUT = 3$
g_layout->set_save_restriction( \
if_salv_c_layout=>RESTRICT_NONE ).$}
{C$GS_REPORT_ATTR-LAYOUT <> ''$
g_layout->set_default( value = abap_true ).$}

gr_table->set_screen_status( report        = \
'SAPLSALV_METADATA_STATUS'
                             pfstatus      = \
'SALV_TABLE_STANDARD'
                             set_functions = \
gr_table->c_functions_all ).

lr_cols = gr_table->get_columns( ).
lr_cols->set_optimize( 'X' ).

{T$gst_fcat$$$
lr_col = lr_cols->get_column( '&GST_FCAT-FIELDNAME&' ).
if lr_col IS NOT INITIAL.
  lr_col->set_short_text( '&GST_FCAT-SCRTEXT_S&' ).
  lr_col->set_medium_text( '&GST_FCAT-SCRTEXT_M&' ).
  lr_col->set_long_text( '&GST_FCAT-SCRTEXT_L&' ).
  FREE lr_col. CLEAR lr_col.
ENDIF.
$$}
ENDFORM.

FORM register_events.
DATA: lr_events            TYPE REF TO cl_salv_events_table.
{C$GS_EVT$
lr_events = gr_table->get_event( ).
CREATE OBJECT gr_event_handler.
{C$GS_EVT-TOP_OF_PAGE = 'X'$
SET HANDLER gr_event_handler->hdl_top_of_page FOR lr_events.$}
{C$GS_EVT-END_OF_PAGE = 'X'$
SET HANDLER gr_event_handler->hdl_end_of_page FOR lr_events.$}
{C$GS_EVT-BEFORE_SALV_FUNC = 'X'$
SET HANDLER gr_event_handler->hdl_before_salv_function FOR lr_events.$}
{C$GS_EVT-AFTER_SALV_FUNC = 'X'$
SET HANDLER gr_event_handler->hdl_after_salv_function FOR lr_events.$}
{C$GS_EVT-ADDED_FUNC = 'X'$
SET HANDLER gr_event_handler->hdl_added_function FOR lr_events.$}
{C$GS_EVT-DOUBLE_CLICK = 'X'$
SET HANDLER gr_event_handler->hdl_double_click FOR lr_events.$}
{C$GS_EVT-LINK_CLICK = 'X'$
SET HANDLER gr_event_handler->hdl_link_click FOR lr_events.$}
$}

ENDFORM.

{C$GS_EVT$
**--------------------------------------------------------------------
**       CLASS lcl_handle_events IMPLEMENTATION
**--------------------------------------------------------------------
*
CLASS lcl_handle_events IMPLEMENTATION.
  {C$GS_EVT-TOP_OF_PAGE = 'X'$
  METHOD hdl_top_of_page.
    PERFORM DO_TOP_OF_PAGE
      IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
      TABLES <gt_table>
      USING  R_TOP_OF_PAGE PAGE TABLE_INDEX gr_table.
  ENDMETHOD.                    "on_top_of_page
  $}
  {C$GS_EVT-END_OF_PAGE = 'X'$
  METHOD hdl_end_of_page.
    PERFORM DO_END_OF_PAGE
      IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
      TABLES <gt_table>
      USING R_END_OF_PAGE PAGE gr_table.
  ENDMETHOD.                    "on_end_of_page
  $}
  {C$GS_EVT-BEFORE_SALV_FUNC = 'X'$
  METHOD hdl_before_salv_function.
    PERFORM DO_BEFORE_SALV_FUNC
      IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
      TABLES <gt_table>
      USING  E_SALV_FUNCTION gr_table.
  ENDMETHOD.                    "on_before_salv_function
  $}
  {C$GS_EVT-AFTER_SALV_FUNC = 'X'$
  METHOD hdl_after_salv_function.
    PERFORM DO_AFTER_SALV_FUNC
      IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
      TABLES <gt_table>
      USING E_SALV_FUNCTION gr_table.
  ENDMETHOD.                    "on_after_salv_function
  $}
  {C$GS_EVT-ADDED_FUNC = 'X'$
  METHOD hdl_added_function.
    PERFORM DO_ADDED_FUNC
      IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
      TABLES <gt_table>
      USING E_SALV_FUNCTION gr_table.
  ENDMETHOD.                    "on_added_function
  $}
  {C$GS_EVT-DOUBLE_CLICK = 'X'$
  METHOD hdl_double_click.
    PERFORM DO_DOUBLE_CLICK
      IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
      TABLES <gt_table>
      USING ROW COLUMN gr_table.
  ENDMETHOD.                    "on_double_click
  $}
  {C$GS_EVT-LINK_CLICK = 'X'$
  METHOD hdl_link_click.
    PERFORM DO_LINK_CLICK
      IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
      TABLES <gt_table>
      USING ROW COLUMN gr_table.
  ENDMETHOD.                    "on_link_click
  $}

ENDCLASS.                    "lcl_handle_events IMPLEMENTATION
$}
/>END</
