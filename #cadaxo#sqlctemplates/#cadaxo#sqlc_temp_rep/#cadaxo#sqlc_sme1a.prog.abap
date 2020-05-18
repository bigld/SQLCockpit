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
{C$GS_USE_TABLE$$
DATA it_fcat TYPE lvc_t_fcat.
DATA wa_fcat TYPE lvc_s_fcat.}
DATA gr_table TYPE REF TO cl_salv_table.
DATA gr_dref TYPE REF TO data.
DATA g_dbcnt TYPE cua_tit_tx.
DATA g_layout TYPE REF TO cl_salv_layout.
DATA g_key TYPE salv_s_layout_key.
{C$GS_EVT$
CLASS lcl_handle_events    DEFINITION DEFERRED.
DATA gr_events            TYPE REF TO lcl_handle_events.$}
DATA lr_events            TYPE REF TO cl_salv_events_table.

FIELD-SYMBOLS: <gt_table>  TYPE table.
FIELD-SYMBOLS: <gwa_table> TYPE any.

{C$GS_EVT$
**--------------------------------------------------------------------
**       CLASS lcl_handle_events DEFINITION
**--------------------------------------------------------------------
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
$}

**********************************************************************
* Selection Screen
**********************************************************************
{T$GST_TABNAMES$TABLES:$$&GST_TABNAMES-TABNAME&$, $.}
SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE text-t01.
{T$GST_WHERE WHERE generate_option <> '03'$$$
{C$GST_WHERE-PARAMNAME = 'UPT'$
PARAMETERS: p_&GST_WHERE-PARAMNAME& TYPE$ \
SELECT-OPTIONS: p_&GST_WHERE-PARAMNAME& FOR} \
{C$GST_WHERE-TABLENAME$&GST_WHERE-TABLENAME&-$}\
&GST_WHERE-FIELDNAME&.$$}
SELECTION-SCREEN: END OF BLOCK bl1.


**********************************************************************
* Initialization
**********************************************************************
INITIALIZATION.
{T$GST_INIT$$$
{C$GST_INIT-NOT = 'X'$
&GST_INIT-PARAMNAME&-SIGN = 'E'.$
&GST_INIT-PARAMNAME&-SIGN = 'I'.}
&GST_INIT-PARAMNAME&-OPTION = '&GST_INIT-OPERATOR&'.
&GST_INIT-PARAMNAME&-LOW = &GST_INIT-VALUE&.
{C$GST_INIT-HIGHVALUE$&GST_INIT-PARAMNAME&-HIGH = \
&GST_INIT-HIGHVALUE&.$}
APPEND &GST_INIT-PARAMNAME&. $$}

**********************************************************************
* Start of Selection
**********************************************************************
START-OF-SELECTION.

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

{C$GS_USE_TABLE$
CREATE DATA gr_dref TYPE TABLE OF &GS_USE_TABLE&.
ASSIGN gr_dref->* TO <gt_table>.
CREATE DATA gr_dref TYPE &GS_USE_TABLE&.
ASSIGN gr_dref->* TO <gwa_table>.
$
IF it_fcat IS INITIAL.
{T$GST_FCAT$$$
CLEAR wa_fcat.
wa_fcat-tabname    = '&GST_FCAT-TABLENAME&'.
wa_fcat-fieldname  = '&GST_FCAT-FIELDNAME&'.
wa_fcat-key        = '&GST_FCAT-KEY&'.
wa_fcat-no_convext = '&GST_FCAT-NO_CONVEXT&'.
wa_fcat-edit_mask  = '&GST_FCAT-EDIT_MASK&'.
wa_fcat-outputlen  = '&GST_FCAT-OUTPUTLEN&'.
wa_fcat-convexit   = '&GST_FCAT-CONVEXIT&'.
wa_fcat-seltext    = '&GST_FCAT-SELTEXT&'.
wa_fcat-tooltip    = '&GST_FCAT-TOOLTIP&'.
wa_fcat-rollname   = '&GST_FCAT-ROLLNAME&'.
wa_fcat-datatype   = '&GST_FCAT-DATATYPE&'.
wa_fcat-domname    = '&GST_FCAT-DOMNAME&'.
wa_fcat-inttype    = '&GST_FCAT-INTTYPE&'.
wa_fcat-intlen     = '&GST_FCAT-INTLEN&'.
wa_fcat-lowercase  = '&GST_FCAT-LOWERCASE&'.
wa_fcat-fix_column = '&GST_FCAT-FIX_COLUMN&'.
wa_fcat-domname    = '&GST_FCAT-DOMNAME&'.
wa_fcat-f4availabl = '&GST_FCAT-F4AVAILABL&'.
wa_fcat-auto_value = '&GST_FCAT-AUTO_VALUE&'.
wa_fcat-checktable = '&GST_FCAT-CHECKTABLE&'.
wa_fcat-ref_field  = '&GST_FCAT-REF_FIELD&'.
wa_fcat-ref_table  = '&GST_FCAT-REF_TABLE&'.
wa_fcat-col_opt    = '&GST_FCAT-COL_OPT&'.
APPEND wa_fcat TO it_fcat.$$}

cl_alv_table_create=>create_dynamic_table(
  EXPORTING
    it_fieldcatalog = it_fcat
  IMPORTING
    ep_table        = gr_dref ).

ASSIGN gr_dref->* TO <gt_table>.
CREATE DATA gr_dref LIKE LINE OF <gt_table>.
ASSIGN gr_dref->* TO <gwa_table>.
ENDIF.
}

PERFORM ENH_BEFORE_SELECT
  IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND.

{T$GST_SQL$$$
&GST_SQL-LINE&$$}
.
PERFORM ENH_AFTER_SELECT
  IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
  TABLES <gt_table>.

IF NOT <gwa_table> IS INITIAL.
  CLEAR <gt_table>.
  APPEND <gwa_table> TO <gt_table>.
ENDIF.
WRITE sy-dbcnt TO g_dbcnt LEFT-JUSTIFIED.

TRY.
    cl_salv_table=>factory(
      EXPORTING
        list_display = if_salv_c_bool_sap=>false
      IMPORTING
        r_salv_table = gr_table
      CHANGING
        t_table      = <gt_table> ).
  CATCH cx_salv_msg.
ENDTRY.

{C$GS_REPORT_ATTR-LAYOUT <> 0$
g_layout = gr_table->get_layout( ).
g_key-report = sy-repid.
g_layout->set_key( g_key ).$}
{C$GS_REPORT_ATTR-LAYOUT = 1$
g_layout->set_save_restriction(
   if_salv_c_layout=>RESTRICT_USER_INDEPENDANT ).$}
{C$GS_REPORT_ATTR-LAYOUT = 2$
g_layout->set_save_restriction(
   if_salv_c_layout=>RESTRICT_USER_DEPENDANT ).$}
{C$GS_REPORT_ATTR-LAYOUT = 3$
g_layout->set_save_restriction(
   if_salv_c_layout=>RESTRICT_NONE ).$}
{C$GS_REPORT_ATTR-LAYOUT <> 0$
g_layout->set_default( value = abap_true ).$}

gr_table->set_screen_status(
    report        = 'SAPLSALV_METADATA_STATUS'
    pfstatus      = 'SALV_TABLE_STANDARD'
    set_functions = gr_table->c_functions_all
       ).

SET TITLEBAR 'ALV_LIST' OF PROGRAM \
'/CADAXO/SAPLSQLC_TEMP_REP' WITH text-t00 g_dbcnt. \
"Just an example if Cadaxo Cockpit is installed: &1 &2 hits

{C$GS_EVT$
lr_events = gr_table->get_event( ).
CREATE OBJECT gr_events.
{C$GS_EVT-TOP_OF_PAGE = 'X'$
SET HANDLER gr_events->hdl_top_of_page FOR lr_events.$}
{C$GS_EVT-END_OF_PAGE = 'X'$
SET HANDLER gr_events->hdl_end_of_page FOR lr_events.$}
{C$GS_EVT-BEFORE_SALV_FUNC = 'X'$
SET HANDLER gr_events->hdl_before_salv_function FOR lr_events.$}
{C$GS_EVT-AFTER_SALV_FUNC = 'X'$
SET HANDLER gr_events->hdl_after_salv_function FOR lr_events.$}
{C$GS_EVT-ADDED_FUNC = 'X'$
SET HANDLER gr_events->hdl_added_function FOR lr_events.$}
{C$GS_EVT-DOUBLE_CLICK = 'X'$
SET HANDLER gr_events->hdl_double_click FOR lr_events.$}
{C$GS_EVT-LINK_CLICK = 'X'$
SET HANDLER gr_events->hdl_link_click FOR lr_events.$}
$}
PERFORM ENH_BEFORE_DISPLAY
  IN PROGRAM &GS_REPORT_ATTR-REPORT& IF FOUND
  TABLES   <gt_table>
  USING    gr_table.

gr_table->display( ).

**********************************************************************
* End of Selection
**********************************************************************
END-OF-SELECTION.

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
