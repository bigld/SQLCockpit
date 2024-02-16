*---------------------------------------------------------------------*
*              Scheme Types                                           *
*---------------------------------------------------------------------*
/>REPORT1</
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
**********************************************************************
* Data Definition
**********************************************************************
DATA: gr_dref              TYPE REF TO data.
DATA: g_dbcnt              TYPE cua_tit_tx.
DATA: gr_cols              TYPE REF TO cl_salv_columns.
DATA: gr_col               TYPE REF TO cl_salv_column.

FIELD-SYMBOLS <gt_table> type table.

{T$GST_RANGES$$$
RANGES: &GST_RANGES-PARAMNAME& FOR &GST_RANGES-TABLENAME&-\
&GST_RANGES-FIELDNAME&.$$}

**********************************************************************
* Selection Screen
**********************************************************************
{T$GST_TABNAMES$TABLES:$$&GST_TABNAMES-TABNAME&$, $.}
SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME TITLE text-t01.
{T$GST_WHERE WHERE generate_option <> '03'$$$
{C$GST_WHERE-PARAMNAME = 'UPT'$
PARAMETERS: P_&GST_WHERE-PARAMNAME& TYPE$ \
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
{T$GST_TABCLASSES_AC$$$
AUTHORITY-CHECK OBJECT 'S_TABU_DIS'
       ID 'DICBERCLS' FIELD '&GST_TABCLASSES_AC-CCLASS&'
       ID 'ACTVT' FIELD '03'.
if sy-subrc <> 0.
  MESSAGE ID 'MO' TYPE 'E' NUMBER 419.
endif.
$$}
{T$GST_SQL$$$
&GST_SQL-LINE&$$}
.
WRITE sy-dbcnt TO g_dbcnt LEFT-JUSTIFIED.
{C$G_SELECT_SINGLE = 'X'$
  CREATE DATA gr_dref LIKE TABLE OF tab_line.
  ASSIGN gr_dref->* TO <gt_table>.
  IF NOT tab_line IS INITIAL AND <gt_table> IS ASSIGNED.
    APPEND tab_line TO <gt_table>.
  ENDIF.

TRY.
    cl_salv_table=>factory(
      EXPORTING
        list_display = if_salv_c_bool_sap=>false
      IMPORTING
        r_salv_table = data(gr_table)
      CHANGING
        t_table      = <gt_table> ).
  CATCH cx_salv_msg.
ENDTRY.

$TRY.
    cl_salv_table=>factory(
      EXPORTING
        list_display = if_salv_c_bool_sap=>false
      IMPORTING
        r_salv_table = data(gr_table)
      CHANGING
        t_table      = tab_result ).
  CATCH cx_salv_msg.
ENDTRY.
}

gr_table->set_screen_status(
    report        = 'SAPLSALV_METADATA_STATUS'
    pfstatus      = 'SALV_TABLE_STANDARD'
    set_functions = gr_table->c_functions_all
       ).

gr_cols = gr_table->get_columns( ).
gr_cols->set_optimize( 'X' ).

{T$gst_fcat$$$
gr_col = gr_cols->get_column( '&GST_FCAT-FIELDNAME&' ).
if gr_col is not INITIAL.
  gr_col->set_short_text( '&GST_FCAT-SCRTEXT_S&' ).
  gr_col->set_medium_text( '&GST_FCAT-SCRTEXT_M&' ).
  gr_col->set_long_text( '&GST_FCAT-SCRTEXT_L&' ).
  clear gr_col. free gr_col.
endif.
$$}

gr_table->display( ).

SET TITLEBAR 'ALV_LIST' OF PROGRAM \
'/CADAXO/SAPLSQLC_TEMP_REP' WITH text-t00 g_dbcnt. \
"Just an example if Cadaxo Cockpit is installed: &1 &2 hits

**********************************************************************
* End of Selection
**********************************************************************
END-OF-SELECTION.
/>END</
