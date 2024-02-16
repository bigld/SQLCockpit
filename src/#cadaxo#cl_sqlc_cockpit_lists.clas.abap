class /CADAXO/CL_SQLC_COCKPIT_LISTS definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_COCKPIT_LISTS
*"* do not include other source files here!!!
public section.

  class-methods SAVE_LIST
    importing
      !I_CL_SQL_PARSE type /CADAXO/SQLC_CL_COCKPIT_PARSET
      !IT_RESULT_DETAILS type /CADAXO/SQLCRESULT_DETAILS_T
      !IT_GRID_RESULTS type /CADAXO/SQLCCLGUICONTAINER_T optional
      !I_SQLCSRES type /CADAXO/SQLCSRES .
  class-methods GET_SAVED_LISTS
    importing
      !I_UNAME type UNAME default SY-UNAME
    exporting
      value(E_SAVED_LISTS) type /CADAXO/SQLCSRESALV_T
      value(E_FREE_SPACE_KB) type INT4 .
  class-methods DELETE_LIST
    importing
      !I_LIST_GUID type /CADAXO/SQLC_LISTGUID
      !I_JOBCOUNT type BTCJOBCNT
      !I_TYPE type /CADAXO/SQLC_LIST_TYPE .
  class-methods RENAME_LIST
    importing
      !I_LIST_GUID type /CADAXO/SQLC_LISTGUID
      !I_DESCRIPTION type /CADAXO/SQLC_LIST_DESCRIPTION
      !I_JOBCOUNT type BTCJOBCNT .
  class-methods EXPORT_LIST
    importing
      !I_LIST_GUID type /CADAXO/SQLC_LISTGUID .
  class-methods IMPORT_LIST .
protected section.
*"* protected components of class /CADAXO/CL_SQLC_COCKPIT_LISTS
*"* do not include other source files here!!!

  class-methods DELETE_OWN_LIST
    importing
      !I_LIST_GUID type /CADAXO/SQLC_LISTGUID
      !I_JOBCOUNT type BTCJOBCNT .
  class-methods DELETE_JOB_LIST
    importing
      !I_LIST_GUID type /CADAXO/SQLC_LISTGUID
      !I_JOBCOUNT type BTCJOBCNT .
private section.
*"* private components of class /CADAXO/CL_SQLC_COCKPIT_LISTS
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CL_SQLC_COCKPIT_LISTS IMPLEMENTATION.


METHOD delete_job_list.
****************************************************************************************************
* Description             : SQL Cockpit - Delete Job List                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxx xxxxx               Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

  DATA ls_sqlcsres TYPE /cadaxo/sqlcsres.

  SELECT SINGLE FOR UPDATE * INTO ls_sqlcsres FROM /cadaxo/sqlcsres WHERE list_guid = i_list_guid and jobcount = i_jobcount. "#EC CI_SEL_NESTED
  IF sy-subrc EQ 0.
    DELETE FROM /cadaxo/sqlcress WHERE ress_guid = ls_sqlcsres-ress_guid.
    IF sy-subrc EQ 0.
      UPDATE /cadaxo/sqlcsres SET ress_guid = 0 WHERE list_guid = i_list_guid.
      IF sy-subrc EQ 0.
        COMMIT WORK.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
  ENDIF.

ENDMETHOD.


METHOD delete_list.
****************************************************************************************************
* Description             : SQL Cockpit - Delete List                                              *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxx xxxxx               Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

  CASE i_type.
    WHEN 'MAN'.
      /cadaxo/cl_sqlc_cockpit_lists=>delete_own_list( i_list_guid = i_list_guid i_jobcount = i_jobcount ).
    WHEN 'JOB'.
      /cadaxo/cl_sqlc_cockpit_lists=>delete_job_list( i_list_guid = i_list_guid i_jobcount = i_jobcount ).
    WHEN /cadaxo/cl_sqlc_cockpit_main=>gc_saved_list_shared.
      /cadaxo/cl_sqlc_cockpit_lists=>delete_job_list( i_list_guid = i_list_guid i_jobcount = i_jobcount ).
    WHEN OTHERS.
  ENDCASE.

ENDMETHOD.


METHOD delete_own_list.
****************************************************************************************************
* Description             : SQL Cockpit - Delete Job List                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxx xxxxx               Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

  DATA ls_sqlcsres TYPE /cadaxo/sqlcsres.

  SELECT SINGLE FOR UPDATE * INTO ls_sqlcsres FROM /cadaxo/sqlcsres WHERE list_guid = i_list_guid and jobcount = i_jobcount. "#EC CI_SEL_NESTED
  IF sy-subrc EQ 0.
    DELETE FROM /cadaxo/sqlcsres WHERE list_guid = ls_sqlcsres-list_guid.
    IF sy-subrc EQ 0.
      DELETE FROM /cadaxo/sqlcress WHERE ress_guid = ls_sqlcsres-ress_guid.
      IF sy-subrc EQ 0.
        COMMIT WORK.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD export_list.

  TYPES: BEGIN OF typ_file,
            binary       TYPE xstring,
         END OF typ_file.

  TYPES: BEGIN OF typ_bin_str,
            filetype        TYPE xstring,
            binary          TYPE xstring,
         END OF typ_bin_str.

  DATA ls_sqlcsres  TYPE /cadaxo/sqlcsres.
  DATA ls_sqlcress  TYPE /cadaxo/sqlcress.
  DATA ls_sqlx      TYPE /cadaxo/sqlc_list_exp_sqlx.
  DATA ls_file      TYPE typ_file.
  DATA l_binary     TYPE xstring.

  DATA l_binary_str TYPE typ_bin_str.

  DATA l_filename    TYPE string.
  DATA l_path        TYPE string.
  DATA l_fullpath    TYPE string.
  DATA l_user_action TYPE i.
  DATA l_bytecount   TYPE i.
  DATA lt_file_tab   TYPE solix_tab.

  SELECT SINGLE * FROM /cadaxo/sqlcsres INTO ls_sqlcsres WHERE list_guid = i_list_guid.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM /cadaxo/sqlcress INTO ls_sqlcress WHERE ress_guid = ls_sqlcsres-ress_guid.

    MOVE-CORRESPONDING ls_sqlcress TO ls_sqlx.
    MOVE-CORRESPONDING ls_sqlcsres TO ls_sqlx.

    EXPORT sqlx FROM ls_sqlx TO DATA BUFFER ls_file-binary.

    IF sy-subrc EQ 0.
      cl_gui_frontend_services=>file_save_dialog(
        EXPORTING
          default_extension    = 'sqllx'
          file_filter          = '.sqllx'
        CHANGING
          filename             = l_filename
          path                 = l_path
          fullpath             = l_fullpath
          user_action          = l_user_action
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
             ).
      IF sy-subrc EQ 0 AND l_user_action EQ 0.

        CALL METHOD cl_abap_gzip=>compress_binary
          EXPORTING
            raw_in   = ls_file-binary
          IMPORTING
            gzip_out = ls_file-binary.

        EXPORT sqlx_file FROM ls_file TO DATA BUFFER l_binary.

        l_binary_str-binary = l_binary.
        l_binary_str-filetype = '1234567890'.

        CONCATENATE l_binary_str-filetype l_binary_str-binary INTO l_binary IN BYTE MODE.

        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer        = l_binary
          IMPORTING
            output_length = l_bytecount
          TABLES
            binary_tab    = lt_file_tab.

        cl_gui_frontend_services=>gui_download(
          EXPORTING
             bin_filesize              = l_bytecount
             filename                  = l_fullpath
             filetype                  = 'BIN'
          CHANGING
             data_tab                  = lt_file_tab
          EXCEPTIONS
             file_write_error          = 1
             no_batch                  = 2
             gui_refuse_filetransfer   = 3
             invalid_type              = 4
             no_authority              = 5
             unknown_error             = 6
             header_not_allowed        = 7
             separator_not_allowed     = 8
             filesize_not_allowed      = 9
             header_too_long           = 10
             dp_error_create           = 11
             dp_error_send             = 12
             dp_error_write            = 13
             unknown_dp_error          = 14
             access_denied             = 15
             dp_out_of_memory          = 16
             disk_full                 = 17
             dp_timeout                = 18
             file_not_found            = 19
             dataprovider_exception    = 20
             control_flush_error       = 21
             not_supported_by_gui      = 22
             error_no_gui              = 23
                     ).
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.

  FREE: ls_sqlx,
        l_binary,
        ls_sqlcress,
        ls_sqlcsres.

ENDMETHOD.


METHOD get_saved_lists.

  DATA lt_sqlcsres       TYPE TABLE OF /cadaxo/sqlcsres.
  DATA ls_saved_lists    LIKE LINE OF e_saved_lists.
  DATA ls_adm_cust       TYPE /cadaxo/sqlc_admin_cust.

  SELECT * FROM /cadaxo/sqlcsres INTO TABLE lt_sqlcsres WHERE uname     = i_uname
                                                          AND ress_guid <> 0.

  /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).

  e_free_space_kb = ls_adm_cust-maxspace.

  LOOP AT lt_sqlcsres ASSIGNING field-symbol(<ls_sqlcsres>).

    CLEAR ls_saved_lists.

    ls_saved_lists = CORRESPONDING #( <ls_sqlcsres> MAPPING mandt = mandant ).

    ls_saved_lists-owner = <ls_sqlcsres>-uname.
    ls_saved_lists-source          = 'SELF'.
    ls_saved_lists-space_consuming = <ls_sqlcsres>-space_cons_zip.

    CONVERT TIME STAMP <ls_sqlcsres>-create_timestamp TIME ZONE sy-zonlo INTO DATE ls_saved_lists-crdate TIME ls_saved_lists-crtime.

    e_free_space_kb = e_free_space_kb - ls_saved_lists-space_consuming.

    CASE ls_saved_lists-type.
      WHEN /cadaxo/cl_sqlc_cockpit_main=>gc_saved_list_manually.
        ls_saved_lists-type_icon = icon_gis_pan.
      WHEN /cadaxo/cl_sqlc_cockpit_main=>gc_saved_list_job.
        ls_saved_lists-type_icon = icon_background_job.
      WHEN /cadaxo/cl_sqlc_cockpit_main=>gc_saved_list_shared.
        ls_saved_lists-type_icon = icon_workflow_external_event.
      WHEN OTHERS.
        WRITE icon_dummy          TO ls_saved_lists-type_icon.
    ENDCASE.

    APPEND ls_saved_lists TO e_saved_lists.

  ENDLOOP.

  SORT e_saved_lists BY crdate DESCENDING crtime DESCENDING.

  FREE: lt_sqlcsres.

ENDMETHOD.


METHOD import_list.

  TYPES: BEGIN OF typ_file,
           binary TYPE xstring,
         END OF typ_file.

  DATA lt_file_table TYPE filetable.
  DATA ls_filename   TYPE file_table.
  DATA l_rc          TYPE i.
  DATA l_user_action TYPE i.
  DATA lt_file_tab   TYPE solix_tab.
  DATA l_filename    TYPE string.
  DATA l_bytecount   TYPE i.
  DATA l_binary     TYPE xstring.
  DATA ls_sqlx      TYPE /cadaxo/sqlc_list_exp_sqlx.
  DATA ls_file      TYPE typ_file.
  DATA ls_sqlcsres  TYPE /cadaxo/sqlcsres.
  DATA ls_sqlcress  TYPE /cadaxo/sqlcress.
  DATA l_binary_file TYPE xstring.

  cl_gui_frontend_services=>file_open_dialog(
     EXPORTING
      default_extension       =  '*.sqllx'
      file_filter             =  'SQLLX File (*.sqllx)|*.sqllx| All Files(*.*)|*.*'
       multiselection          = ' '
    CHANGING
      file_table              = lt_file_table
      rc                      = l_rc
       user_action             = l_user_action
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
         ).
  IF sy-subrc EQ 0 AND l_user_action = 0.
    READ TABLE lt_file_table INDEX 1 INTO ls_filename.
    IF sy-subrc EQ 0.

      l_filename = ls_filename-filename.

      cl_gui_frontend_services=>gui_upload(
         EXPORTING
            filename   = l_filename
            filetype   = 'BIN'
         IMPORTING
            filelength = l_bytecount
         CHANGING
            data_tab   = lt_file_tab
         EXCEPTIONS
            OTHERS     = 1 ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.

        CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
          EXPORTING
            input_length = l_bytecount
          IMPORTING
            buffer       = l_binary
          TABLES
            binary_tab   = lt_file_tab
          EXCEPTIONS
            failed       = 1
            OTHERS       = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ELSE.

          IF l_binary(5) EQ '1234567890'.

            l_binary_file = l_binary+5.

            IMPORT sqlx_file TO ls_file FROM DATA BUFFER l_binary_file.
            IF sy-subrc EQ 0.

              CALL METHOD cl_abap_gzip=>decompress_binary
                EXPORTING
                  gzip_in = ls_file-binary
                IMPORTING
                  raw_out = ls_file-binary.

              IMPORT sqlx TO ls_sqlx FROM DATA BUFFER ls_file-binary.
              IF sy-subrc EQ 0.

                CLEAR: ls_sqlcress, ls_sqlcsres.

                MOVE-CORRESPONDING ls_sqlx TO ls_sqlcress.
                MOVE-CORRESPONDING ls_sqlx TO ls_sqlcsres.

                CALL FUNCTION 'GUID_CREATE'
                  IMPORTING
                    ev_guid_16 = ls_sqlcsres-list_guid.

                CALL FUNCTION 'GUID_CREATE'
                  IMPORTING
                    ev_guid_16 = ls_sqlcsres-ress_guid.

                ls_sqlcress-ress_guid = ls_sqlcsres-ress_guid.

                ls_sqlcress-uname = sy-uname.
                ls_sqlcsres-uname = sy-uname.

                INSERT /cadaxo/sqlcress FROM ls_sqlcress.
                IF sy-subrc EQ 0.
                  INSERT /cadaxo/sqlcsres FROM ls_sqlcsres.
                  IF sy-subrc EQ 0.
                    COMMIT WORK.
                  ENDIF.
                ENDIF.

              ENDIF.
            ENDIF.
          ENDIF.

        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD rename_list.
  DATA ls_sqlcsres TYPE /cadaxo/sqlcsres.

  SELECT SINGLE FOR UPDATE * INTO ls_sqlcsres FROM /cadaxo/sqlcsres WHERE list_guid = i_list_guid AND jobcount = i_jobcount. "#EC CI_SEL_NESTED
  IF sy-subrc EQ 0.
    UPDATE /cadaxo/sqlcsres SET description = i_description WHERE list_guid = i_list_guid AND jobcount = i_jobcount.
    IF sy-subrc EQ 0 AND sy-dbcnt EQ 1.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD save_list.
****************************************************************************************************
* Description             : SQL Cockpit - Delete Job List                                          *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxx xxxxx               Company    : CADAXO GesmbH                    *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 07.12.2020 | A.Kajtar             | Saved List error in case of Add Domain func.|  COCKPIT-468   *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

  DATA ls_sqlcresultsave  TYPE /cadaxo/sqlcresultsave.
  DATA lt_sqlcresultsave  TYPE TABLE OF /cadaxo/sqlcresultsave.
  DATA lt_result_list_raw TYPE TABLE OF xstring.
  DATA ls_result_list_raw TYPE xstring.
  DATA ls_sqlcresult_ref  TYPE /cadaxo/sqlcresult_ref.
  DATA l_xml              TYPE string.
  DATA ls_sqlcress        TYPE /cadaxo/sqlcress.
  DATA ls_sqlcsres        TYPE /cadaxo/sqlcsres.
  DATA l_lines            TYPE i.
  DATA l_result_details   TYPE /cadaxo/sqlcresult_details.
  DATA l_update_ok        TYPE c LENGTH 1.
  DATA lt_frontend_fcat   TYPE lvc_t_fcat.
  DATA lt_frontend_sort   TYPE lvc_t_sort.
  DATA lt_frontend_filt   TYPE lvc_t_filt.
  DATA ls_frontend_layo   TYPE lvc_s_layo.

  DATA lt_saved_lists TYPE /cadaxo/sqlcsresalv_t.
  DATA l_free_space_kb TYPE int4.
  DATA l_max_space_kb TYPE int4.
  DATA ls_adm_cust TYPE /cadaxo/sqlc_admin_cust.
  DATA l_header_line TYPE /cadaxo/sqlcheaderline.

  FIELD-SYMBOLS: <ls_cl_sql_parse>   LIKE LINE OF i_cl_sql_parse,
                 <ls_t>              TYPE ANY TABLE,
                 <ls_result_details> LIKE LINE OF it_result_details,
                 <ls_grid_results>   LIKE LINE OF it_grid_results.

  LOOP AT i_cl_sql_parse ASSIGNING <ls_cl_sql_parse>.

    READ TABLE it_result_details INDEX sy-tabix INTO l_result_details.

    IF it_grid_results IS SUPPLIED.
      READ TABLE it_grid_results INDEX sy-tabix ASSIGNING <ls_grid_results>.
      IF sy-subrc EQ 0.
        <ls_grid_results>-gui_alv_grid->get_frontend_fieldcatalog( IMPORTING et_fieldcatalog = lt_frontend_fcat ).
        <ls_grid_results>-gui_alv_grid->get_sort_criteria( IMPORTING et_sort = lt_frontend_sort ).
        <ls_grid_results>-gui_alv_grid->get_filter_criteria( IMPORTING et_filter = lt_frontend_filt ).
        <ls_grid_results>-gui_alv_grid->get_frontend_layout( IMPORTING es_layout = ls_frontend_layo ).

        MOVE ls_frontend_layo TO ls_sqlcresultsave-parse-result_layo.
        MOVE lt_frontend_fcat TO ls_sqlcresultsave-parse-result_fieldcatalog.
        MOVE lt_frontend_sort TO ls_sqlcresultsave-parse-result_sort.
        MOVE lt_frontend_filt TO ls_sqlcresultsave-parse-result_filt.

      ENDIF.
    ENDIF.

    MOVE: <ls_cl_sql_parse>->column_syntax       TO ls_sqlcresultsave-parse-column_syntax,
          <ls_cl_sql_parse>->source_syntax       TO ls_sqlcresultsave-parse-source_syntax,
          <ls_cl_sql_parse>->where_syntax        TO ls_sqlcresultsave-parse-where_syntax,
          <ls_cl_sql_parse>->sql_syntax_without_where       TO ls_sqlcresultsave-parse-sql_syntax_without_where,
          <ls_cl_sql_parse>->group_syntax        TO ls_sqlcresultsave-parse-group_syntax,
          <ls_cl_sql_parse>->having_syntax       TO ls_sqlcresultsave-parse-having_syntax,
          <ls_cl_sql_parse>->order_syntax        TO ls_sqlcresultsave-parse-order_syntax,
          <ls_cl_sql_parse>->dbhint_syntax       TO ls_sqlcresultsave-parse-dbhint_syntax,
          <ls_cl_sql_parse>->connection_syntax   TO ls_sqlcresultsave-parse-connection_syntax,
          <ls_cl_sql_parse>->sql_syntax          TO ls_sqlcresultsave-parse-sql_syntax,
          <ls_cl_sql_parse>->gt_result_ddfields  TO ls_sqlcresultsave-parse-result_ddfields,
          <ls_cl_sql_parse>->result_source_t     TO ls_sqlcresultsave-parse-result_source,
          <ls_cl_sql_parse>->g_up_to_x_rows      TO ls_sqlcresultsave-parse-up_to_x_rows,
          <ls_cl_sql_parse>->g_select_single     TO ls_sqlcresultsave-parse-select_single,
          <ls_cl_sql_parse>->gs_client_handling-client_specified  TO ls_sqlcresultsave-parse-client_specified,
          <ls_cl_sql_parse>->gs_client_handling-using_client      TO ls_sqlcresultsave-parse-using_client,
          <ls_cl_sql_parse>->g_bypassing_buffer  TO ls_sqlcresultsave-parse-bypassing_buffer,
          <ls_cl_sql_parse>->subquery            TO ls_sqlcresultsave-parse-subquery,
          <ls_cl_sql_parse>->gt_components_domval   TO ls_sqlcresultsave-parse-components_domval,  "COCKPIT-468
          <ls_cl_sql_parse>->comp                   TO ls_sqlcresultsave-parse-comp,               "COCKPIT-468
          <ls_cl_sql_parse>->gt_domval              TO ls_sqlcresultsave-parse-domval.             "COCKPIT-468
    MOVE <ls_cl_sql_parse>->result_table TO ls_sqlcresult_ref-table_dref.

    ASSIGN ls_sqlcresult_ref-table_dref->* TO <ls_t>.

    EXPORT result FROM <ls_t> TO DATA BUFFER ls_result_list_raw.

    cl_abap_gzip=>compress_binary(
      EXPORTING
        raw_in         = ls_result_list_raw
      IMPORTING
        gzip_out       = ls_result_list_raw ).


    MOVE l_result_details TO ls_sqlcresultsave-main-result_details.

    APPEND ls_sqlcresultsave TO lt_sqlcresultsave.
    APPEND ls_result_list_raw TO lt_result_list_raw.

  ENDLOOP.

* transform the data into xml
  CALL TRANSFORMATION id
    SOURCE result_save = lt_sqlcresultsave
    RESULT XML l_xml.

* zip xml
  CALL METHOD cl_abap_gzip=>compress_text
    EXPORTING
      text_in  = l_xml
    IMPORTING
      gzip_out = ls_sqlcress-rawdata.

  MOVE sy-uname TO ls_sqlcress-uname.

  CALL FUNCTION 'GUID_CREATE'
    IMPORTING
      ev_guid_16 = ls_sqlcress-ress_guid.

  CALL FUNCTION 'GUID_CREATE'
    IMPORTING
      ev_guid_16 = ls_sqlcsres-list_guid.

  ls_sqlcsres-ress_guid   = ls_sqlcress-ress_guid.
  ls_sqlcsres-description = i_sqlcsres-description.
  ls_sqlcsres-uname       = sy-uname.
  ls_sqlcsres-syst        = sy-sysid.
  ls_sqlcsres-mandant     = sy-mandt.

  DESCRIBE TABLE i_cl_sql_parse LINES l_lines.
  MOVE l_lines TO ls_sqlcsres-nr_of_selects.

  GET TIME STAMP FIELD ls_sqlcsres-create_timestamp.

  EXPORT result FROM lt_result_list_raw TO DATA BUFFER ls_sqlcress-rawresult.

  ls_sqlcsres-space_cons_zip = xstrlen( ls_sqlcress-rawresult ) / 1024.

* Check if max_space_kb is not exceeded
* get saved lists
  /cadaxo/cl_sqlc_cockpit_lists=>get_saved_lists( EXPORTING i_uname = sy-uname
                                                  IMPORTING e_saved_lists = lt_saved_lists
                                                            e_free_space_kb = l_free_space_kb ).
* get maxspace
  /cadaxo/cl_sqlc_cockpit_assist=>get_adm_customizing( IMPORTING e_customizing = ls_adm_cust ).

  IF ls_adm_cust-maxspace GT 0.
    IF ls_sqlcsres-space_cons_zip GT l_free_space_kb.
      MESSAGE e084(/cadaxo/sqlc) WITH ls_sqlcsres-description ls_adm_cust-maxspace.
    ENDIF.
  ENDIF.

  ls_sqlcsres-type = 'MAN'.

  CLEAR l_update_ok.
  INSERT /cadaxo/sqlcress FROM ls_sqlcress.
  IF sy-subrc EQ 0.
    INSERT /cadaxo/sqlcsres FROM ls_sqlcsres.
    IF sy-subrc EQ 0.
      l_update_ok = abap_true.
    ENDIF.
  ENDIF.

  IF l_update_ok = abap_true.
    COMMIT WORK.
    MESSAGE s080(/cadaxo/sqlc) WITH ls_sqlcsres-description. "The list &1 has been saved successfully.
  ELSE.
    ROLLBACK WORK.
    MESSAGE e081(/cadaxo/sqlc) WITH ls_sqlcsres-description."Failed to save the list &1.
  ENDIF.

ENDMETHOD.
ENDCLASS.
