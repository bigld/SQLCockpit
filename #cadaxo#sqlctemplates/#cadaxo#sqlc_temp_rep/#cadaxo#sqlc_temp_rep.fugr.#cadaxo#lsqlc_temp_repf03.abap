*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLC_TEMP_REPF03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CLEAR_GLOBALS
*&---------------------------------------------------------------------*
FORM clear_globals .

  CLEAR gst_where.
  FREE  gst_where.
  CLEAR gst_init.
  FREE  gst_init.
  CLEAR gst_fcat.
  FREE  gst_fcat.
  CLEAR gst_tabnames.
  FREE  gst_tabnames.
  CLEAR gst_tabclasses_ac.
  FREE  gst_tabclasses_ac.
  CLEAR gst_header.
  FREE  gst_header.
  CLEAR g_select_single.
  FREE  g_select_single.
  CLEAR gst_auth_tabnames.
  FREE  gst_auth_tabnames.
  CLEAR gst_ranges.
  FREE gst_ranges.

ENDFORM.
