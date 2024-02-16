*----------------------------------------------------------------------*
***INCLUDE /CADAXO/LSQLCTIPPSANDTRICKSO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  "Get version
  /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value( EXPORTING  i_parameter_id      = /cadaxo/cl_sqlc_cockpit_assist=>c_param_version
                                                       RECEIVING  r_parameter_value   = DATA(l_version)
                                                       EXCEPTIONS parameter_not_found = 1 ).

  "Create Status and Titlebar
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100' WITH l_version.

  "Create HTML Viewer/Container and Show on the screeen
  DATA(lo_html_viewer) = NEW cl_gui_html_viewer( NEW cl_gui_custom_container( c_container ) ).
  /cadaxo/cl_sqlc_cockpit_assist=>get_parameter_value( EXPORTING  i_parameter_id      = /cadaxo/cl_sqlc_cockpit_assist=>c_release_info_link
                                                       RECEIVING  r_parameter_value   = DATA(l_html_link)
                                                       EXCEPTIONS parameter_not_found = 1 ).
  /cadaxo/cl_sqlc_cockpit_main=>param_replace_tags( CHANGING data = l_html_link ).
  lo_html_viewer->show_data( CONV char255( l_html_link ) ).

ENDMODULE.
