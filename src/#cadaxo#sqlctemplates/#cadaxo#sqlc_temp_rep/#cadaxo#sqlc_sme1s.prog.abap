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
{C$GS_USE_TABLE$$
DATA: it_fcat              TYPE lvc_t_fcat.
DATA: wa_fcat              TYPE lvc_s_fcat.}
DATA: gr_table             TYPE REF TO cl_salv_table.
DATA: gr_dref              TYPE REF TO data.
DATA: g_dbcnt              TYPE cua_tit_tx.
FIELD-SYMBOLS: <gt_table>  TYPE table.
FIELD-SYMBOLS: <gwa_table> TYPE any.

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

{T$GST_SQL$$$
&GST_SQL-LINE&$$}
.

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

gr_table->set_screen_status(
    report        = 'SAPLSALV_METADATA_STATUS'
    pfstatus      = 'SALV_TABLE_STANDARD'
    set_functions = gr_table->c_functions_all
       ).

SET TITLEBAR 'ALV_LIST' OF PROGRAM \
'/CADAXO/SAPLSQLC_TEMP_REP' WITH text-t00 g_dbcnt. \
"Just an example if Cadaxo Cockpit is installed: &1 &2 hits

gr_table->display( ).

**********************************************************************
* End of Selection
**********************************************************************
END-OF-SELECTION.
/>END</
