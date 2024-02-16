class /CADAXO/CL_SQLC_TEMPLATE definition
  public
  abstract
  create public .

*"* public components of class /CADAXO/CL_SQLC_TEMPLATE
*"* do not include other source files here!!!
public section.

  data GR_PARSER type ref to /CADAXO/CL_SQLC_COCKPIT_PARSE read-only .
  data GT_WHERE type ref to /CADAXO/SQLCWHERECOL_STR_T .
  data G_TEMPL_NAME type /CADAXO/SQLCTEMPL_NAME .

  methods CONSTRUCTOR
    importing
      !I_CL_SQL_PARSE type ref to /CADAXO/CL_SQLC_COCKPIT_PARSE
      !I_TEMPL_NAME type /CADAXO/SQLCTEMPL_NAME .
  methods EXECUTE_TEMPLATE_GENERATION
  abstract .
protected section.
*"* protected components of class ZCDX_CL_SQL_COCKPIT_WIZARD
*"* do not include other source files here!!!
private section.
*"* private components of class /CADAXO/CL_SQLC_TEMPLATE
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CL_SQLC_TEMPLATE IMPLEMENTATION.


METHOD constructor.


  DATA: lwa_dfies            TYPE dfies.
  DATA: l_table              TYPE ddobjname.
  DATA: l_field              TYPE dfies-lfieldname.
  FIELD-SYMBOLS: <lwa_where> TYPE /cadaxo/sqlcwherecol_str.


  gr_parser = i_cl_sql_parse.

  g_templ_name = i_templ_name.

  GET REFERENCE OF i_cl_sql_parse->gt_sql_where_col_tab_t INTO gt_where.

  LOOP AT gt_where->* ASSIGNING <lwa_where>.
    CLEAR lwa_dfies.
    l_table = <lwa_where>-tablename.
    l_field = <lwa_where>-fieldname.
    CALL FUNCTION 'DDIF_FIELDINFO_GET'
      EXPORTING
        tabname    = l_table
        lfieldname = l_field
        langu      = sy-langu
      IMPORTING
        dfies_wa   = lwa_dfies
      EXCEPTIONS
        OTHERS     = 1.
    IF NOT lwa_dfies-scrtext_m IS INITIAL.
      <lwa_where>-fielddescr = lwa_dfies-scrtext_m.
    ELSEIF NOT lwa_dfies-scrtext_s IS INITIAL.
      <lwa_where>-fielddescr = lwa_dfies-scrtext_s.
    ELSEIF NOT lwa_dfies-scrtext_l IS INITIAL.
      <lwa_where>-fielddescr = lwa_dfies-scrtext_l.
    ELSEIF NOT lwa_dfies-reptext IS INITIAL.
      <lwa_where>-fielddescr = lwa_dfies-reptext.
    ENDIF.
  ENDLOOP.
ENDMETHOD.
ENDCLASS.
