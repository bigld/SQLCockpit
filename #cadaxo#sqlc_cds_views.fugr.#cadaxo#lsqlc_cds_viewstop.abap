FUNCTION-POOL /cadaxo/sqlc_cds_views.       "MESSAGE-ID ..

DATA g_ddlname          TYPE ddlname.
DATA g_viewname         TYPE viewname.
DATA g_entityname       TYPE ddstrucobjname.
data g_adt_link         type string.
DATA gs_ddddlsrcv       TYPE ddddlsrcv.
DATA g_with_parameters  TYPE c LENGTH 1.

DATA gr_container   TYPE REF TO cl_gui_custom_container.
DATA gr_ddl         TYPE REF TO cl_gui_sourceedit.
DATA g_okcode       TYPE sy-ucomm.

* INCLUDE /CADAXO/LSQLC_CDS_VIEWSD...        " Local class definition
