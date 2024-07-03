****************************************************************************************************
* Description             : SQL Cockpit - Mail Notification for Jobsheduling                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Cadaxo                   Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : Domi Bigl                Company    : CADAXO GesmbH                    *
* Date                    : 16.04.2011                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
* 17.03.2017 | Domi Bigl            | removed Enhancments and CC-Cleanup          |                *
*------------+----------------------+---------------------------------------------+----------------*
* 25.02.2018 | Domi Bigl            | CC-Cleanup, multiple receiver               | COCKPIT-298    *
*------------+----------------------+---------------------------------------------+----------------*
* 01.02.2019 | Pat                  | added email attachment (result table)       | Cockpit-366    *
*            |                      | in subroutine attach_results                |                *
*------------+----------------------+---------------------------------------------+----------------*
* 15.06.2022 | Domi Bigl            | Wrong list in job notification mail + CC    | COCKPIT-488    *
*------------+----------------------+---------------------------------------------+----------------*
* 20.07.2022 | Domi Bigl            | encoding in attachment                      | COCKPIT-492    *
****************************************************************************************************
REPORT  /cadaxo/sqlc_batch_executemail.

DATA gs_sqlcsres            TYPE /cadaxo/sqlcsres.
DATA gs_jobstart_conditions TYPE /cadaxo/sqlc_jobwiz_fields.
DATA gv_xml                 TYPE string.

SELECTION-SCREEN: BEGIN OF BLOCK bl1 WITH FRAME.
  PARAMETERS: pjobguid TYPE /cadaxo/sqlc_jobguid OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK bl1.

START-OF-SELECTION.

  CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
    IMPORTING
      jobcount = gs_sqlcsres-jobcount
      jobname  = gs_sqlcsres-jobname
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc = 0.
    SELECT SINGLE *
           FROM /cadaxo/sqlcsres
           WHERE jobcount       = @gs_sqlcsres-jobcount
             AND jobname        = @gs_sqlcsres-jobname
             AND root_list_guid = @pjobguid
           INTO @gs_sqlcsres.
    IF sy-subrc <> 0.
      "previous version?
      SELECT SINGLE *
             FROM /cadaxo/sqlcsres
             INTO CORRESPONDING FIELDS OF gs_sqlcsres WHERE list_guid = pjobguid.
      DATA(no_attachment) = abap_true.
    ENDIF.
    IF sy-subrc = 0.
* unzip and convert start conditions
      cl_abap_gzip=>decompress_text( EXPORTING gzip_in  = gs_sqlcsres-jobstartcond
                                     IMPORTING text_out = gv_xml ).

      CALL TRANSFORMATION id
         SOURCE XML gv_xml
         RESULT settings = gs_jobstart_conditions.

* create notification mail(s)
      PERFORM email_notification.

    ENDIF.

  ENDIF.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  EMAIL_NOTIFICATION
*&---------------------------------------------------------------------*
*       Create and send the mail
*----------------------------------------------------------------------*
FORM email_notification .

  DATA lv_jobstate            TYPE btcstatus.
  DATA lv_jobstatetext(12)    TYPE c.
  DATA lv_subject             TYPE so_obj_des.
  DATA lv_date                TYPE char10.
  DATA lv_time                TYPE char8.
  DATA lr_document            TYPE REF TO cl_document_bcs.
  DATA lr_send_request        TYPE REF TO cl_bcs.
  DATA lr_sender              TYPE REF TO cl_sapuser_bcs.
  DATA lr_reciever            TYPE REF TO if_recipient_bcs.
  DATA lt_htmltable           TYPE TABLE OF htmlline.
  DATA lt_text                TYPE soli_tab.
  DATA ls_htmlline            TYPE htmlline.
  DATA lt_string              TYPE TABLE OF string.
  DATA lt_email_string        TYPE TABLE OF string.
  DATA l_cnt_lists TYPE i.

  PERFORM get_job_status CHANGING lv_jobstate lv_jobstatetext.

  IF  gs_jobstart_conditions-notification_email1 IS NOT INITIAL OR
      gs_jobstart_conditions-notification_email2 IS NOT INITIAL OR
      gs_jobstart_conditions-notification_sap_mail IS NOT INITIAL.


    lr_send_request = cl_bcs=>create_persistent( ).

* create subject
    lv_subject = |{ sy-sysid }/{ sy-mandt }-{ TEXT-001 }|.

    PERFORM get_number_of_lists USING l_cnt_lists.

* get the mail template
    APPEND '<html><head>' TO lt_htmltable.
    APPEND '<meta http-equiv="Content-Type" content="text/html"; charset=utf-8">' TO lt_htmltable.
    APPEND '<title>SQL Cockpit Mailbenachrichtigung</title>' TO lt_htmltable.
    APPEND '</head>' TO lt_htmltable.
    APPEND '<body>' TO lt_htmltable.
    CONCATENATE '<h3>' TEXT-hdr '</h3>' INTO ls_htmlline.
    APPEND ls_htmlline TO lt_htmltable.
    CONCATENATE '<p><br />' TEXT-l01 '</p>' INTO ls_htmlline.
    APPEND ls_htmlline TO lt_htmltable.
    CONCATENATE '<p><br /><samp>'
                TEXT-l04
                sy-sysid
                '<br />' INTO ls_htmlline.
    APPEND ls_htmlline TO lt_htmltable.

    lv_date = |{ sy-datum DATE = USER }|.
    lv_time = |{ sy-uzeit TIME = USER }|.

    CONCATENATE TEXT-l05
                lv_date '/' lv_time
                '<br />' INTO ls_htmlline.
    APPEND ls_htmlline TO lt_htmltable.
    CONCATENATE TEXT-l02
                gs_sqlcsres-jobname
                '<br />' INTO ls_htmlline.
    APPEND ls_htmlline TO lt_htmltable.
    CONCATENATE TEXT-l03
                lv_subject
                '<br />' INTO ls_htmlline.
    APPEND ls_htmlline TO lt_htmltable.

    ls_htmlline-tdline = TEXT-l06 && l_cnt_lists && '</samp></p>'.
    APPEND ls_htmlline TO lt_htmltable.

    CONCATENATE '<p><br />' TEXT-ftr '</p>' INTO ls_htmlline.
    APPEND ls_htmlline TO lt_htmltable.
    APPEND '</body></html>' TO lt_htmltable.

    APPEND LINES OF lt_htmltable TO lt_text.

    lr_document =  cl_document_bcs=>create_document( i_type    = 'HTM'
                                                     i_text    = lt_text
                                                     i_subject = lv_subject ).

    IF gs_jobstart_conditions-notif_email_attachment_flag IS NOT INITIAL.
      PERFORM attach_results CHANGING lr_document.
    ENDIF.

* get jobstatus
    PERFORM get_job_status CHANGING lv_jobstate lv_jobstatetext.

    IF lv_jobstate EQ 'A'.
      lr_document->set_importance( '1' ).
    ENDIF.

    lr_send_request->set_document( lr_document ).
    lr_sender = cl_sapuser_bcs=>create( sy-uname ).
    lr_send_request->set_sender( lr_sender ).

* add the email receiver
*    IF NOT gs_jobstart_conditions-notification_email_flag IS INITIAL."-Cockpit-451
    IF gs_jobstart_conditions-notification_email1 IS NOT INITIAL OR gs_jobstart_conditions-notification_email2 IS NOT INITIAL."+Cockpit-451
      SPLIT gs_jobstart_conditions-notification_email1 AT ';' INTO TABLE lt_string.                "COCKPIT-298
      APPEND LINES OF lt_string TO lt_email_string.                                                "COCKPIT-298
      SPLIT gs_jobstart_conditions-notification_email2 AT ';' INTO TABLE lt_string.                "COCKPIT-298
      APPEND LINES OF lt_string TO lt_email_string.                                                "COCKPIT-298
      LOOP AT lt_email_string ASSIGNING FIELD-SYMBOL(<ls_email_string>).                           "COCKPIT-298
        lr_reciever = cl_cam_address_bcs=>create_internet_address( CONV #( shift_left( <ls_email_string> ) ) ).
        lr_send_request->add_recipient( i_recipient = lr_reciever ).
      ENDLOOP.
    ENDIF.

* add the sap receiver
    IF
*NOT gs_jobstart_conditions-notification_sap_mail_flag IS INITIAL AND "-Cockpit-451
      gs_jobstart_conditions-notification_sap_mail IS NOT INITIAL.

      SPLIT gs_jobstart_conditions-notification_sap_mail AT ';' INTO TABLE lt_string.

      LOOP AT lt_string ASSIGNING FIELD-SYMBOL(<userid>).
        lr_reciever = cl_sapuser_bcs=>create( i_user = CONV #( <userid> ) ).
        lr_send_request->add_recipient( i_recipient = lr_reciever
                                        i_express   = abap_true ).
      ENDLOOP.

    ENDIF.

* send the mail immediately
    lr_send_request->set_send_immediately( abap_true ).
    lr_send_request->send( ).

    COMMIT WORK.

  ENDIF.

ENDFORM.                    " EMAIL_NOTIFICATION

FORM get_number_of_lists CHANGING p_lists TYPE i.

  DATA lr_cockpit_main          TYPE REF TO /cadaxo/cl_sqlc_cockpit_main.

  SELECT SINGLE * FROM /cadaxo/sqlcsres INTO @DATA(ls_sqlcsres) WHERE list_guid = @pjobguid.
  IF sy-subrc = 0.
    SELECT SINGLE * FROM /cadaxo/sqlcress INTO @DATA(ls_sqlcress) WHERE ress_guid = @ls_sqlcsres-ress_guid.
    IF sy-subrc = 0.

      lr_cockpit_main = NEW #( ).

      lr_cockpit_main->prepare_result_table(
       EXPORTING
         is_sqlcsres = ls_sqlcsres
         is_sqlcress = ls_sqlcress ).

      p_lists = lines( lr_cockpit_main->dref_result_tab_t ).

    ENDIF.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  ATTACH_RESULTS
*&---------------------------------------------------------------------*
FORM attach_results  CHANGING pr_document TYPE REF TO cl_document_bcs.

  DATA lr_cockpit_main          TYPE REF TO /cadaxo/cl_sqlc_cockpit_main.

  DATA: ls_result_xstring TYPE xstring,
        lt_result         TYPE solix_tab,
        lx_zip_file       TYPE xstring,
        lv_filename       TYPE string.

  FIELD-SYMBOLS : <lt_result_table> TYPE ANY TABLE,
                  <lr_dref_result>  TYPE REF TO data.

  IF no_attachment = abap_false.

    SELECT SINGLE * FROM /cadaxo/sqlcress INTO @DATA(ls_sqlcress) WHERE ress_guid = @gs_sqlcsres-ress_guid.
    IF sy-subrc = 0.

      lr_cockpit_main = NEW #( ).
      lr_cockpit_main->prepare_result_table( is_sqlcsres = gs_sqlcsres
                                             is_sqlcress = ls_sqlcress ).

      DATA(zip) = NEW cl_abap_zip( ).

      LOOP AT lr_cockpit_main->dref_result_tab_t ASSIGNING <lr_dref_result>.
        DATA(table_index) = sy-tabix.
        ASSIGN lr_cockpit_main->gt_lvc_t_fcat[ table_index ] TO FIELD-SYMBOL(<fieldcats>).
        ASSIGN <lr_dref_result>->* TO <lt_result_table>.

        DATA(csv_tab) = /cadaxo/cl_sqlc_csv_cust_util=>get_csv_from_itab( it_table      = <lt_result_table>
                                                                          i_fieldcat    = <fieldcats>
                                                                          i_csv_attr    = VALUE #( add_header      = abap_true
                                                                          field_separator = /cadaxo/cl_sqlc_csv_cust_util=>cseperators-semicolon
                                                                          date_format     = /cadaxo/cl_sqlc_csv_cust_util=>cdateformats-user
                                                                          time_format     = /cadaxo/cl_sqlc_csv_cust_util=>ctimeformats-user ) ).

        DATA(csv_string) = /cadaxo/cl_sqlc_csv_cust_util=>csv_tab_2_string( csv_tab ).

        TRY.
            ls_result_xstring = cl_abap_codepage=>convert_to( source = csv_string codepage = 'UTF-16LE' ).
          CATCH cx_parameter_invalid_range
                cx_sy_codepage_converter_init
                cx_sy_conversion_codepage
                cx_parameter_invalid_type.
            TRY.
                ls_result_xstring = cl_abap_codepage=>convert_to(  csv_string ).
              CATCH cx_parameter_invalid_range
                    cx_sy_codepage_converter_init
                    cx_sy_conversion_codepage
                    cx_parameter_invalid_type.
            ENDTRY.
        ENDTRY.

        lv_filename = |Result_Table_{ table_index }_{ sy-datum }_{ sy-uzeit }.csv|.

        zip->add( name = lv_filename content = ls_result_xstring ).
        ls_result_xstring = zip->save( ).

        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer     = ls_result_xstring
          TABLES
            binary_tab = lt_result.

      ENDLOOP.

      IF lt_result IS NOT INITIAL.

        DATA(subject) = CONV sood-objdes( |SQL_Result_{ sy-datum }_{ sy-uzeit }.zip| ).

        TRY.
            pr_document->add_attachment( i_attachment_type    = 'BIN'
                                         i_attachment_subject = subject
                                         i_att_content_hex    = lt_result ).
          CATCH cx_document_bcs .
        ENDTRY.
      ENDIF.

    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_JOB_STATUS
*&---------------------------------------------------------------------*
*       Get the Jobstatus
*----------------------------------------------------------------------*
FORM get_job_status CHANGING cv_jobstate TYPE btcstatus
                             cv_jobstate_text TYPE csequence.


* get jobdetails
  SELECT SINGLE status FROM tbtco INTO cv_jobstate WHERE jobname  = gs_sqlcsres-jobname
                                                     AND jobcount = gs_sqlcsres-jobcount.

  CASE cv_jobstate.
    WHEN 'F'.
      cv_jobstate_text   = TEXT-stf.
    WHEN 'A'.
      cv_jobstate_text   = TEXT-stc.
    WHEN OTHERS.
      cv_jobstate_text   = TEXT-stu.
  ENDCASE.

ENDFORM.                    " GET_JOB_STATUS
