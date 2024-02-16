FUNCTION /cadaxo/sqlcexport_csv.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_DATA) TYPE  ANY TABLE
*"     REFERENCE(IT_FCAT) TYPE  LVC_T_FCAT
*"----------------------------------------------------------------------

* function is still in development and not released in the current release - Cadaxo 1.1.2014/Rel 2.1

*  data l_rc type i.
*  data ls_celltab type LVC_S_STYL.
*
*  ASSIGN it_data TO <gt_table>.
*  ASSIGN it_fcat TO <gt_fcat>.
*
*  CLEAR gt_col_alv.
*
*  LOOP AT <gt_fcat> ASSIGNING <ls_fcat>.
*    CLEAR ls_col_alv.
*    ls_col_alv-col_pos     = <ls_fcat>-col_pos.
*    ls_col_alv-fieldname   = <ls_fcat>-fieldname.
*    ls_col_alv-scrtext_s   = <ls_fcat>-scrtext_s.
*    ls_col_alv-export_flag = 'X'.
*    ls_col_alv-inttype     = <ls_fcat>-inttype.
*
*    case ls_col_alv-inttype.
*      when 'X' or 'y'.
*        ls_celltab-fieldname = 'EXPORT_HEX'.
*        ls_celltab-style     = cl_gui_alv_grid=>mc_style_enabled.
*        append ls_celltab to ls_col_alv-celltab.
*      when others.
*        ls_celltab-fieldname = 'EXPORT_HEX'.
*        ls_celltab-style     = cl_gui_alv_grid=>mc_style_disabled.
*        append ls_celltab to ls_col_alv-celltab.
*    endcase.
*
*
*    APPEND ls_col_alv TO gt_col_alv.
*  ENDLOOP.
*
*  CALL SCREEN 0100 STARTING AT 20 5 ENDING AT 180 33.

ENDFUNCTION.
