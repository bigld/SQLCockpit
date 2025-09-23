" ---------------------------------------------------------------------------------------------------
"  Description             : show the user log                                                      -
" ---------------------------------------------------------------------------------------------------
"  Additional informations :                                                                        -
"                                                                                                   -
" ---------------------------------------------------------------------------------------------------
"  Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    -
"  Date                    : 01.01.2012               Release    : WAS 7.00                         -
" ---------------------------------------------------------------------------------------------------
"  Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : CADAXO GesmbH                    -
"  Date                    : xx.xx.xxxx                                                             -
" ---------------------------------------------------------------------------------------------------
"                                                                                                   -
" -----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S ------------
"                                                                                                   -
"  Date       | Developer            | Description                                 |                -
" ------------+----------------------+---------------------------------------------+-----------------
"   23.9.14   | Rene Rammer          | Enhancement of Search                       |    CT#249      -
"             |                      |                                             |                -
" ------------+----------------------+---------------------------------------------+-----------------
"  17.06.2016 | Dieter Schadler      | Bugfix Zeitraumsuche/Selektion neu          | Jira COCKPIT-44-
"             |                      |                                             |                -
" ---------------------------------------------------------------------------------------------------
REPORT  /cadaxo/sqlc_select_user_log.
INCLUDE /cadaxo/sqlc_select_log_c01.

DATA gs_sqlculog       TYPE /cadaxo/sqlculog.
DATA gt_sqlculog       TYPE TABLE OF /cadaxo/sqlculog.
DATA gt_sqlculogalv    TYPE TABLE OF /cadaxo/sqlculogalv.
DATA gv_xml            TYPE string.
DATA gs_log_xml        TYPE /cadaxo/sqlculog_xml.
DATA rg_sel_timestamps TYPE RANGE OF timestampl.
DATA rg_sel_timestamp  LIKE LINE OF rg_sel_timestamps.
DATA gv_time           TYPE sy-uzeit.
DATA date_selection    TYPE /cadaxo/sqlcexecute_date.

SELECTION-SCREEN BEGIN OF BLOCK sel WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: so_uname FOR gs_sqlculog-uname DEFAULT sy-uname,
                  so_date  FOR date_selection NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK sel.

INITIALIZATION.
  DATA(options_list) = VALUE sscr_opt_list_tab( ( name       = 'DateRes'
                                                  options-eq = abap_true
                                                  options-bt = abap_true
                                                  options-ge = abap_true
                                                  options-le = abap_true
                                                  options-cp = abap_false
                                                  options-gt = abap_false
                                                  options-lt = abap_false
                                                  options-nb = abap_false
                                                  options-ne = abap_false
                                                  options-np = abap_false ) ).

  DATA(assignment) = VALUE sscr_ass_tab( ( kind    = 'S'
                                           name    = 'SO_DATE'
                                           sg_main = 'I'
                                           op_main = 'DateRes' ) ).

  DATA(restrictions) = VALUE sscr_restrict( opt_list_tab = options_list
                                            ass_tab      = assignment ).

  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING  restriction            = restrictions
    EXCEPTIONS too_late               = 1
               repeated               = 2
               selopt_without_options = 3
               selopt_without_signs   = 4
               invalid_sign           = 5
               empty_option_list      = 6
               invalid_kind           = 7
               repeated_kind_a        = 8
               OTHERS                 = 9.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'ZCADXOSQ05' ID 'ACTVT' FIELD '02'.
  IF sy-subrc <> 0.
    MESSAGE e036(/cadaxo/sqlc).
  ENDIF.
  TRY.
      DATA(timestamps) = lcl_local_runner=>conv_date_to_timestamp( i_dates = so_date[] ).
    CATCH cx_abap_invalid_value.
  ENDTRY.

  SELECT * FROM /cadaxo/sqlculog PACKAGE SIZE 1000
    INTO TABLE gt_sqlculog
    WHERE uname     IN so_uname
      AND timestamp IN timestamps.

    LOOP AT gt_sqlculog ASSIGNING FIELD-SYMBOL(<gs_sqlculog>).

      APPEND CORRESPONDING #( <gs_sqlculog> ) TO gt_sqlculogalv ASSIGNING FIELD-SYMBOL(<gs_sqlculogalv>).

      TRY.
          cl_abap_gzip=>decompress_text( EXPORTING gzip_in  = <gs_sqlculog>-log_message
                                         IMPORTING text_out = gv_xml ).

          CALL TRANSFORMATION id
               SOURCE XML gv_xml
               RESULT log = gs_log_xml.

          <gs_sqlculogalv>-logxml = gs_log_xml.

          MESSAGE ID <gs_sqlculogalv>-id
                  TYPE <gs_sqlculogalv>-type
                  NUMBER <gs_sqlculogalv>-number
                  WITH <gs_sqlculogalv>-message_v1
                       <gs_sqlculogalv>-message_v2
                       <gs_sqlculogalv>-message_v3
                       <gs_sqlculogalv>-message_v4
                  INTO <gs_sqlculogalv>-message.

        CATCH cx_parameter_invalid_range
              cx_sy_buffer_overflow
              cx_sy_conversion_codepage
              cx_sy_compression_error.

          MESSAGE e028(/cadaxo/sqlc_ulog) INTO <gs_sqlculogalv>-message.

      ENDTRY.

      CONVERT TIME STAMP <gs_sqlculog>-timestamp TIME ZONE sy-zonlo
              INTO DATE <gs_sqlculogalv>-ulog_date TIME <gs_sqlculogalv>-ulog_time.

      <gs_sqlculogalv>-icon = SWITCH #( <gs_sqlculogalv>-type
                                        WHEN 'I' OR 'S' THEN icon_message_information_small
                                        WHEN 'W'        THEN icon_message_warning_small
                                        WHEN 'E'        THEN icon_message_error_small
                                        ELSE                 icon_message_question_small ).
    ENDLOOP.

  ENDSELECT.

  SORT gt_sqlculogalv BY ulog_date DESCENDING
                         ulog_time DESCENDING.

  DATA(alv_layout) = VALUE slis_layout_alv( zebra             = abap_true
                                            colwidth_optimize = abap_true ).

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING  i_structure_name = '/CADAXO/SQLCULOGALV'
               is_layout        = alv_layout
    TABLES     t_outtab         = gt_sqlculogalv
    EXCEPTIONS OTHERS           = 1.
