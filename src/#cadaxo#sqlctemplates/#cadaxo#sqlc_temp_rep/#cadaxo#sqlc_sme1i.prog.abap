*---------------------------------------------------------------------*
*              Scheme Types                                           *
*---------------------------------------------------------------------*
/>INCLUDE1</
{C$GS_EVT-ENH_BEFORE_SELECT = 'X'$
*---------------------------------------------------------------------*
* Include  &GS_REPORT_ATTR-ENH_INCLUDE&
*
*---------------------------------------------------------------------*
* This Report was generated with CADAXO SQL Cockpit
*
* User:  &SY-UNAME&
* Date:  &SY-DATUM&
*
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*      Form  ENH_BEFORE_SELECT
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM ENH_BEFORE_SELECT.
ENDFORM.$}
{C$GS_EVT-ENH_AFTER_SELECT = 'X'$
*---------------------------------------------------------------------*
*      Form  DO_ENH_AFTER_SELECT
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM enh_after_select TABLES   ut_table.
ENDFORM.$}
{C$GS_EVT-ENH_BEFORE_DISPLAY = 'X'$
*---------------------------------------------------------------------*
*      Form  DO_BEFORE_DISPLAY
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM enh_before_display TABLES   ut_table
                        USING    ur_table TYPE REF TO cl_salv_table.
ENDFORM.$}

{C$GS_EVT_NEW-TOP_OF_PAGE = 'X'$
*---------------------------------------------------------------------*
*      Form  DO_TOP_OF_PAGE
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM DO_TOP_OF_PAGE TABLES   ut_table
                    USING    r_top_of_page page table_index
                             ur_table TYPE REF TO cl_salv_table.
ENDFORM.$}

{C$GS_EVT_NEW-END_OF_PAGE = 'X'$
*---------------------------------------------------------------------*
*      Form  DO_END_OF_PAGE
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM DO_END_OF_PAGE TABLES   ut_table
                    USING    r_end_of_page page
                             ur_table TYPE REF TO cl_salv_table.
ENDFORM.$}

{C$GS_EVT_NEW-BEFORE_SALV_FUNC = 'X'$
*---------------------------------------------------------------------*
*      Form  DO_BEFORE_SALV_FUNC
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM do_before_salv_func TABLES   ut_table
                         USING    e_salv_function
                                  ur_table TYPE REF TO cl_salv_table.
ENDFORM.$}

{C$GS_EVT_NEW-AFTER_SALV_FUNC = 'X'$
*---------------------------------------------------------------------*
*      Form  DO_AFTER_SALV_FUNC
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM do_after_salv_func TABLES   ut_table
                        USING    e_salv_function
                                 ur_table TYPE REF TO cl_salv_table.
ENDFORM.$}

{C$GS_EVT_NEW-ADDED_FUNC = 'X'$
*---------------------------------------------------------------------*
*      Form  DO_ADDED_FUNC
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM DO_ADDED_FUNC TABLES   ut_table
                   USING    e_salv_function
                            ur_table TYPE REF TO cl_salv_table.
ENDFORM.$}

{C$GS_EVT_NEW-DOUBLE_CLICK = 'X'$
*---------------------------------------------------------------------*
*      Form  DO_DOUBLE_CLICK
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM DO_DOUBLE_CLICK TABLES   ut_table
                     USING    row column
                              ur_table TYPE REF TO cl_salv_table.
ENDFORM.$}

{C$GS_EVT_NEW-LINK_CLICK = 'X'$
*---------------------------------------------------------------------*
*      Form  DO_LINK_CLICK
*---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM DO_LINK_CLICK TABLES   ut_table
                   USING    row column
                            ur_table TYPE REF TO cl_salv_table.
ENDFORM.$}

/>END</
