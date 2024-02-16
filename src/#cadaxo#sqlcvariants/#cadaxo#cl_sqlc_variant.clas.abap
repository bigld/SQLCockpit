class /CADAXO/CL_SQLC_VARIANT definition
  public
  final
  create public .

*"* public components of class /CADAXO/CL_SQLC_VARIANT
*"* do not include other source files here!!!
public section.

  class-data GR_USER_LOG type ref to /CADAXO/CL_SQLC_USER_LOG .

  class-methods GET_VARIANT
    importing
      !I_VARGUID type /CADAXO/SQLC_VARIANT_GUID
    exporting
      !ES_SQLCVARI_IL type /CADAXO/SQLC_IL_VARIANTS .
  class-methods GLOBALIZE_VARIANT
    importing
      !I_VARGUID type /CADAXO/SQLC_VARIANT_GUID .
  class-methods LOCALIZE_VARIANT
    importing
      !I_VARGUID type /CADAXO/SQLC_VARIANT_GUID .
  class-methods INSERT_VARIANT
    importing
      !I_IL_VARIANT type /CADAXO/SQLC_IL_VARIANTS
    returning
      value(R_VARGUID) type /CADAXO/SQLC_VARIANT_GUID
    raising
      /CADAXO/CX_SQLC_VARIANT .
  class-methods GET_VARIANTS
    importing
      !I_CRUSER type SY-UNAME default SY-UNAME
    exporting
      value(ET_VARIANTS) type /CADAXO/SQLC_IL_VN_T
      value(ET_VARIANTS_DESC) type /CADAXO/SQLC_IL_VNTX_T .
  class-methods DELETE_VARIANT
    importing
      !I_VARGUID type /CADAXO/SQLC_VARIANT_GUID
    raising
      /CADAXO/CX_SQLC_VARIANT .
  class-methods CHANGE_GROUP_OF_VARIANT
    importing
      !I_VARGUID type /CADAXO/SQLC_VARIANT_GUID
      !I_VARGROUP type /CADAXO/SQLCVARI_GROUP .
  class-methods MODIFY_DESCRIPTION
    importing
      !IT_DESCRIPTION type /CADAXO/SQLC_IL_VNTX_T .
  class-methods GET_GROUPS
    returning
      value(R_IL_VNGR_T) type /CADAXO/SQLC_IL_VNGR_T .
  class-methods LOCK_VARIANT
    importing
      !I_VARGUID type /CADAXO/SQLC_VARIANT_GUID
    raising
      /CADAXO/CX_SQLC_VARIANT .
  class-methods UNLOCK_VARIANT
    importing
      !I_VARGUID type /CADAXO/SQLC_VARIANT_GUID .
  class-methods DOWNLOAD_VARIANT
    importing
      !I_IL_VARIANT type /CADAXO/SQLC_IL_VARIANTS
    returning
      value(R_VARGUID) type /CADAXO/SQLC_VARIANT_GUID
    raising
      /CADAXO/CX_SQLC_VARIANT .
  class-methods UPLOAD_VARIANT
    returning
      value(R_VARGUID) type /CADAXO/SQLCVNHD-VARGUID .
  class-methods RENAME_VARIANT
    importing
      !I_VARGUID type /CADAXO/SQLC_VARIANT_GUID
      !I_VARNAME type /CADAXO/SQLCVARI_NAME
    raising
      /CADAXO/CX_SQLC_VARIANT .
  PROTECTED SECTION.
*"* protected components of class /CADAXO/CL_SQLC_VARIANT
*"* do not include other source files here!!!
  PRIVATE SECTION.
*"* private components of class /CADAXO/CL_SQLC_VARIANT
*"* do not include other source files here!!!
ENDCLASS.



CLASS /CADAXO/CL_SQLC_VARIANT IMPLEMENTATION.


  METHOD change_group_of_variant.
****************************************************************************************************
* Description             : Change Group                                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    DATA l_vargroup TYPE /cadaxo/sqlcvari_group.

    SELECT SINGLE vargroup FROM /cadaxo/sqlcvnhd
            INTO l_vargroup WHERE varguid = i_varguid.
    IF sy-subrc EQ 0.
      IF l_vargroup NE i_vargroup.
        UPDATE /cadaxo/sqlcvnhd SET vargroup = i_vargroup
                                WHERE varguid = i_varguid.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD delete_variant.
****************************************************************************************************
* Description             : delete variant                                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxx xxxxxxx                   *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA ls_log        TYPE /cadaxo/sqlculog_api.
    DATA ls_sqlcvnhd   TYPE /cadaxo/sqlcvnhd.

    SELECT SINGLE * FROM /cadaxo/sqlcvnhd INTO ls_sqlcvnhd WHERE varguid = i_varguid.
    IF sy-subrc EQ 0.

* lock variant
      /cadaxo/cl_sqlc_variant=>lock_variant( ls_sqlcvnhd-varguid ).

      IF NOT ls_sqlcvnhd-flag_public IS INITIAL AND ls_sqlcvnhd-cruser NE sy-uname.
        AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '06'. "Delete
        IF sy-subrc NE 0.
          RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_variant
            EXPORTING
              textid  = /cadaxo/cx_sqlc_variant=>no_auth_to_del_glob_variant
              variant = i_varguid.
        ENDIF.
      ENDIF.

      DELETE FROM /cadaxo/sqlcvnhd WHERE varguid = i_varguid.
      DELETE FROM /cadaxo/sqlcvnfa WHERE varguid = i_varguid.
      DELETE FROM /cadaxo/sqlcvntx WHERE varguid = i_varguid.
      DELETE FROM /cadaxo/sqlcvnsy WHERE varguid = i_varguid.

* add log
      CREATE OBJECT gr_user_log.

      CLEAR ls_log.
      ls_log-object     = 'VARIANT'.
      ls_log-object_key = ls_sqlcvnhd-varguid.
      ls_log-type       = 'S'.
      ls_log-id         = '/CADAXO/SQLC'.
      ls_log-number     = '089'.
      ls_log-message_v1 = ls_sqlcvnhd-varguid.
      IF 1 = 2. MESSAGE s089(/cadaxo/sqlc). ENDIF.

      gr_user_log->add_ulog(
          i_log_message = ls_log ).

      /cadaxo/cl_sqlc_variant=>unlock_variant( i_varguid ).

    ELSE.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_variant
        EXPORTING
          textid  = /cadaxo/cx_sqlc_variant=>variant_not_found
          variant = i_varguid.
    ENDIF.
  ENDMETHOD.


  METHOD download_variant.

    DATA ls_sqlcvnhd TYPE /cadaxo/sqlcvnhd.
    DATA ls_sqlcvnsy TYPE /cadaxo/sqlcvnsy.
    DATA lt_sqlcvnsy TYPE TABLE OF /cadaxo/sqlcvnsy.
    DATA ls_sqlcvntx TYPE /cadaxo/sqlcvntx.
    DATA ls_log      TYPE /cadaxo/sqlculog_api.
    DATA l_varsql    TYPE /cadaxo/sqlcvari_sql.
    DATA ls_sqlx     TYPE /cadaxo/sqlc_var_updown_sqlx.

    FIELD-SYMBOLS: <ls_symbols> LIKE LINE OF i_il_variant-t_symbol.

    TYPES: BEGIN OF typ_file,
             binary TYPE xstring,
           END OF typ_file.

    TYPES: BEGIN OF typ_bin_str,
             filetype TYPE xstring,
             binary   TYPE xstring,
           END OF typ_bin_str.

    DATA ls_file      TYPE typ_file.
    DATA l_binary     TYPE xstring.
    DATA l_binary_str TYPE typ_bin_str.
    DATA l_filename    TYPE string.
    DATA l_path        TYPE string.
    DATA l_fullpath    TYPE string.
    DATA l_user_action TYPE i.
    DATA l_bytecount   TYPE i.
    DATA lt_file_tab   TYPE solix_tab.
    DATA: l_xml        TYPE xstring.

    CLEAR: ls_sqlcvnhd,
           ls_sqlcvnsy,
           ls_sqlcvntx,
           lt_sqlcvnsy.

    IF i_il_variant-varguid IS INITIAL.
      CALL FUNCTION 'GUID_CREATE'
        IMPORTING
          ev_guid_32 = ls_sqlcvnhd-varguid.
    ELSE.
      ls_sqlcvnhd-varguid = i_il_variant-varguid.
    ENDIF.

    ls_sqlcvnhd-varname        = i_il_variant-varname.
    ls_sqlcvnhd-flag_public    = i_il_variant-flag_public.
    ls_sqlcvnhd-vargroup       = i_il_variant-vargroup.
    EXPORT code FROM i_il_variant-t_sql[] TO DATA BUFFER l_varsql.
    ls_sqlcvnhd-varsql         = l_varsql.

    ls_sqlcvnhd-cruser         = sy-uname.
    GET TIME STAMP FIELD ls_sqlcvnhd-crtimestamp.

    LOOP AT i_il_variant-t_symbol ASSIGNING <ls_symbols>.

      APPEND CORRESPONDING #( <ls_symbols> ) TO lt_sqlcvnsy ASSIGNING FIELD-SYMBOL(<ls_variant_symbol>).
      <ls_variant_symbol>-varguid = ls_sqlcvnhd-varguid.

    ENDLOOP.

    CLEAR ls_sqlcvntx.
      ls_sqlcvntx-varguid = ls_sqlcvnhd-varguid.
      ls_sqlcvntx-langu   = sy-langu.
    ls_sqlcvntx-vardescription = i_il_variant-vardescription.

    MOVE-CORRESPONDING ls_sqlcvnhd TO ls_sqlx.
    MOVE-CORRESPONDING ls_sqlcvntx TO ls_sqlx.

    CALL TRANSFORMATION id
       SOURCE /cadaxo/sqlc_var_updown_sqlx = ls_sqlx
       RESULT XML l_xml.

     EXPORT sqlx FROM l_xml TO DATA BUFFER ls_file-binary.

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

    FREE: ls_sqlx,
          l_binary.

    IF gr_user_log IS INITIAL.
      CREATE OBJECT gr_user_log.
    ENDIF.

    CLEAR ls_log.
    ls_log-object     = gr_user_log->con_obj_var.
    ls_log-object_key = ls_sqlcvnhd-varguid.
    ls_log-type       = 'S'.
    ls_log-id         = '/CADAXO/SQLC'.
    ls_log-number     = '015'.
    ls_log-message_v1 = ls_sqlcvnhd-varname.

    gr_user_log->add_ulog(
        i_log_message = ls_log ).

    IF ls_sqlcvnhd-flag_public IS INITIAL.
      MESSAGE s009(/cadaxo/sqlcvariants) WITH ls_sqlcvnhd-varname.
    ELSE.
      MESSAGE s008(/cadaxo/sqlcvariants) WITH ls_sqlcvnhd-varname.
    ENDIF.

    r_varguid = ls_sqlcvnhd-varguid.

  ENDMETHOD.


  METHOD get_groups.
****************************************************************************************************
* Description             : get variant groups                                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxx xxxxxxx                   *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    SELECT a~vargroup b~vargroup_desc FROM /cadaxo/sqlcvgrp AS a
           LEFT OUTER JOIN /cadaxo/sqlcvgrt AS b
           ON b~vargroup = a~vargroup
           AND b~language = sy-langu
      INTO TABLE r_il_vngr_t.

  ENDMETHOD.


  METHOD get_variant.
****************************************************************************************************
* Description             : Get Variant                                                            *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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

    DATA ls_sqlcvnhd     TYPE /cadaxo/sqlcvnhd.
    DATA ls_sqlcvari_il  TYPE /cadaxo/sqlc_il_variants.
    DATA lt_table        TYPE /cadaxo/sqlccodeline_t.
    DATA lt_sqlcvntx     TYPE TABLE OF /cadaxo/sqlcvntx.
    DATA ls_sqlc_il_vntx TYPE /cadaxo/sqlc_il_vntx.

    FIELD-SYMBOLS: <ls_sqlcvntx> TYPE /cadaxo/sqlcvntx.

* get variant header data
    SELECT SINGLE * FROM /cadaxo/sqlcvnhd INTO ls_sqlcvnhd
           WHERE varguid = i_varguid.

    IF ls_sqlcvnhd-varsql IS INITIAL.
      MESSAGE i157(/cadaxo/sqlc).
      RETURN.
    ENDIF.

* convert editor content
    IMPORT code TO lt_table FROM DATA BUFFER ls_sqlcvnhd-varsql.

* fill return structure
    MOVE: ls_sqlcvnhd-varname        TO ls_sqlcvari_il-varname,
          ls_sqlcvnhd-vargroup       TO ls_sqlcvari_il-vargroup,
          ls_sqlcvnhd-flag_public    TO ls_sqlcvari_il-flag_public,
          ls_sqlcvnhd-cruser         TO ls_sqlcvari_il-cruser,
          ls_sqlcvnhd-chuser         TO ls_sqlcvari_il-chuser,
          ls_sqlcvnhd-varguid        TO ls_sqlcvari_il-varguid.

* convert utc timestamps
    CONVERT TIME STAMP ls_sqlcvnhd-crtimestamp TIME ZONE sy-zonlo INTO DATE ls_sqlcvari_il-crdate TIME ls_sqlcvari_il-crtime.
    CONVERT TIME STAMP ls_sqlcvnhd-chtimestamp TIME ZONE sy-zonlo INTO DATE ls_sqlcvari_il-chdate TIME ls_sqlcvari_il-chtime.

    APPEND LINES OF lt_table         TO ls_sqlcvari_il-t_sql.

* get description
    SELECT * FROM /cadaxo/sqlcvntx INTO TABLE lt_sqlcvntx WHERE varguid = i_varguid.
    LOOP AT lt_sqlcvntx ASSIGNING <ls_sqlcvntx>.
      ls_sqlc_il_vntx-varguid = <ls_sqlcvntx>-varguid.
      ls_sqlc_il_vntx-langu   = <ls_sqlcvntx>-langu.
      ls_sqlc_il_vntx-longtext = <ls_sqlcvntx>-longtext.
      ls_sqlc_il_vntx-vardescription = <ls_sqlcvntx>-vardescription.
      APPEND ls_sqlc_il_vntx TO ls_sqlcvari_il-t_description.

      IF ls_sqlc_il_vntx-langu EQ sy-langu.
        MOVE ls_sqlc_il_vntx-vardescription TO ls_sqlcvari_il-vardescription.
      ENDIF.

    ENDLOOP.

* get symbols
    SELECT * FROM /cadaxo/sqlcvnsy INTO CORRESPONDING FIELDS OF TABLE ls_sqlcvari_il-t_symbol WHERE varguid = i_varguid.

    MOVE ls_sqlcvari_il TO es_sqlcvari_il.

  ENDMETHOD.


  METHOD get_variants.
****************************************************************************************************
* Description             : Get Variants                                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
* select variants from database
    SELECT * FROM /cadaxo/sqlcvnhd INTO CORRESPONDING FIELDS OF TABLE et_variants
             WHERE cruser EQ i_cruser
                OR flag_public NE space.

* select variant-descriptions from database
    IF NOT et_variants[] IS INITIAL.
      SELECT * FROM /cadaxo/sqlcvntx INTO CORRESPONDING FIELDS OF TABLE et_variants_desc
               FOR ALL ENTRIES IN et_variants
               WHERE varguid = et_variants-varguid.
    ENDIF.

    SORT et_variants[] BY varname ASCENDING.

  ENDMETHOD.


  METHOD globalize_variant.
****************************************************************************************************
* Description             : Globalize Variant                                                      *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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

    DATA l_flag_public TYPE /cadaxo/sqlcvari_global.
    DATA l_timestamp   TYPE timestamp.

    SELECT SINGLE flag_public FROM /cadaxo/sqlcvnhd
            INTO l_flag_public WHERE varguid = i_varguid.
    IF sy-subrc EQ 0.
      IF l_flag_public IS INITIAL.

        GET TIME STAMP FIELD l_timestamp.
        UPDATE /cadaxo/sqlcvnhd SET flag_public = 'X'
                                   chtimestamp = l_timestamp
                                   chuser      = sy-uname
                                WHERE varguid = i_varguid.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD insert_variant.
****************************************************************************************************
* Description             : insert variant                                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : Johann Fößleitner        Company    : CADAXO GesmbH                    *
* Date                    : 01.01.2010               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxxxxxxxxxxxxxx       Company    : xxxxxx xxxxxxx                   *
* Date                    : xx.xx.xxxx                                                             *
*--------------------------------------------------------------------------------------------------*
*                                                                                                  *
*-----------E N H A N C E M E N T S / C O R R E C T I O N S / M O D I F I C A T I O N S -----------*
*                                                                                                  *
* Date       | Developer            | Description                                 |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
*            |                      |                                             |                *
*------------+----------------------+---------------------------------------------+----------------*
*            |                      |                                             |                *
*            |                      |                                             |                *
****************************************************************************************************

    DATA ls_sqlcvnhd TYPE /cadaxo/sqlcvnhd.
    DATA ls_sqlcvnsy TYPE /cadaxo/sqlcvnsy.
    DATA lt_sqlcvnsy TYPE TABLE OF /cadaxo/sqlcvnsy.
    DATA ls_sqlcvntx TYPE /cadaxo/sqlcvntx.
    DATA ls_log      TYPE /cadaxo/sqlculog_api.
    DATA l_varsql    TYPE /cadaxo/sqlcvari_sql.
    DATA l_mode      TYPE c LENGTH 1.

    FIELD-SYMBOLS: <ls_symbols> LIKE LINE OF i_il_variant-t_symbol.

    CLEAR: ls_sqlcvnhd,
           ls_sqlcvnsy,
           ls_sqlcvntx,
           lt_sqlcvnsy.

    IF i_il_variant-varguid IS INITIAL.
      CALL FUNCTION 'GUID_CREATE'
        IMPORTING
          ev_guid_32 = ls_sqlcvnhd-varguid.
    ELSE.
      ls_sqlcvnhd-varguid = i_il_variant-varguid.
    ENDIF.

    SELECT SINGLE * FROM /cadaxo/sqlcvnhd INTO ls_sqlcvnhd WHERE varguid = ls_sqlcvnhd-varguid.
    IF sy-subrc EQ 0.
      l_mode = 'U'. "Update
    ELSE.
      l_mode = 'I'. "Insert
    ENDIF.

    ls_sqlcvnhd-varname        = i_il_variant-varname.
    ls_sqlcvnhd-flag_public    = i_il_variant-flag_public.
    ls_sqlcvnhd-vargroup       = i_il_variant-vargroup.
    EXPORT code FROM i_il_variant-t_sql[] TO DATA BUFFER l_varsql.
    ls_sqlcvnhd-varsql         = l_varsql.

    CASE l_mode.
      WHEN 'I'.
        ls_sqlcvnhd-cruser         = sy-uname.
        GET TIME STAMP FIELD ls_sqlcvnhd-crtimestamp.
      WHEN 'U'.
        ls_sqlcvnhd-chuser         = sy-uname.
        GET TIME STAMP FIELD ls_sqlcvnhd-chtimestamp.
    ENDCASE.

    LOOP AT i_il_variant-t_symbol ASSIGNING <ls_symbols>.

      APPEND CORRESPONDING #( <ls_symbols> ) TO lt_sqlcvnsy ASSIGNING FIELD-SYMBOL(<ls_variant_symbol>).
      <ls_variant_symbol>-varguid = ls_sqlcvnhd-varguid.

    ENDLOOP.

    CLEAR ls_sqlcvntx.
    SELECT SINGLE * FROM /cadaxo/sqlcvntx INTO ls_sqlcvntx WHERE varguid = ls_sqlcvnhd-varguid AND langu = sy-langu.
    IF sy-subrc NE 0.
      ls_sqlcvntx-varguid = ls_sqlcvnhd-varguid.
      ls_sqlcvntx-langu   = sy-langu.
    ENDIF.
    ls_sqlcvntx-vardescription = i_il_variant-vardescription.

    MODIFY /cadaxo/sqlcvnhd FROM ls_sqlcvnhd.
    IF sy-subrc EQ 0.

      DELETE FROM /cadaxo/sqlcvnsy WHERE varguid = ls_sqlcvnhd-varguid.

      MODIFY /cadaxo/sqlcvnsy FROM TABLE lt_sqlcvnsy.
      IF sy-subrc EQ 0.
        MODIFY /cadaxo/sqlcvntx FROM ls_sqlcvntx.
        IF sy-subrc EQ 0.

          IF gr_user_log IS INITIAL.
            CREATE OBJECT gr_user_log.
          ENDIF.

          CLEAR ls_log.
          ls_log-object     = gr_user_log->con_obj_var. "'VARIANT'. CDX130-020
          ls_log-object_key = ls_sqlcvnhd-varguid.
          ls_log-type       = 'S'.
          ls_log-id         = '/CADAXO/SQLC'.
          ls_log-number     = '015'.                          "'001'
          ls_log-message_v1 = ls_sqlcvnhd-varname.

          gr_user_log->add_ulog(
              i_log_message = ls_log ).

          IF NOT ls_sqlcvnhd-flag_public IS INITIAL.
            MESSAGE s005(/cadaxo/sqlcvariants) WITH ls_sqlcvnhd-varname.
          ELSE.
            MESSAGE s006(/cadaxo/sqlcvariants) WITH ls_sqlcvnhd-varname.
          ENDIF.

          COMMIT WORK.
          r_varguid = ls_sqlcvnhd-varguid.
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD localize_variant.
****************************************************************************************************
* Description             : Localize Variant                                                       *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    DATA l_flag_public TYPE /cadaxo/sqlcvari_global.
    DATA l_timestamp   TYPE timestamp.

    SELECT SINGLE flag_public FROM /cadaxo/sqlcvnhd
            INTO l_flag_public WHERE varguid = i_varguid.
    IF sy-subrc EQ 0.
      IF NOT l_flag_public IS INITIAL.
        GET TIME STAMP FIELD l_timestamp.
        UPDATE /cadaxo/sqlcvnhd SET flag_public = ' '
                                    chtimestamp = l_timestamp
                                    chuser      = sy-uname
                                WHERE varguid = i_varguid.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD lock_variant.
****************************************************************************************************
* Description             : Lock Variant                                                           *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    DATA l_userid TYPE uname.

    CALL FUNCTION 'ENQUEUE_/CADAXO/SQLCVARE'
      EXPORTING
*       MODE_/CADAXO/SQLCVNHD       = 'E'
*       MANDT          = SY-MANDT
        varguid        = i_varguid
*       X_VARGUID      = ' '
*       _SCOPE         = '2'
*       _WAIT          = ' '
*       _COLLECT       = ' '
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.

    IF sy-subrc NE 0.

      MOVE sy-msgv1 TO l_userid.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_variant
        EXPORTING
          textid  = /cadaxo/cx_sqlc_variant=>variant_is_locked
          variant = i_varguid
          userid  = l_userid.

    ENDIF.

  ENDMETHOD.


  METHOD modify_description.
****************************************************************************************************
* Description             : Modify Description                                                     *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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

    DATA lt_sqlcvntx TYPE TABLE OF /cadaxo/sqlcvntx.
    DATA ls_sqlcvntx TYPE /cadaxo/sqlcvntx.
    DATA ls_log        TYPE /cadaxo/sqlculog_api.

    FIELD-SYMBOLS: <ls_description> LIKE LINE OF it_description.

    LOOP AT it_description ASSIGNING <ls_description>.
      CLEAR ls_sqlcvntx.
      ls_sqlcvntx-varguid = <ls_description>-varguid.
      ls_sqlcvntx-langu   = <ls_description>-langu.
      ls_sqlcvntx-longtext = <ls_description>-longtext.
      ls_sqlcvntx-vardescription = <ls_description>-vardescription.
      APPEND ls_sqlcvntx TO lt_sqlcvntx.
    ENDLOOP.

    MODIFY /cadaxo/sqlcvntx FROM TABLE lt_sqlcvntx.

    IF gr_user_log IS INITIAL.
      CREATE OBJECT gr_user_log.
    ENDIF.

    CLEAR ls_log.
    ls_log-object     = gr_user_log->con_obj_var. "'VARIANT'. CDX130-020
    ls_log-object_key = ls_sqlcvntx-varguid.
    ls_log-type       = 'S'.
    ls_log-id         = '/CADAXO/SQLC'.
    ls_log-number     = '015'.                                "'001'
    ls_log-message_v1 = ls_sqlcvntx-varguid.
    IF 1 = 2. MESSAGE s014(/cadaxo/sqlc). ENDIF.

    gr_user_log->add_ulog( i_log_message = ls_log ).

    COMMIT WORK.

  ENDMETHOD.


  METHOD rename_variant.

    DATA ls_sqlcvnhd TYPE /cadaxo/sqlcvnhd.
    DATA ls_log TYPE /cadaxo/sqlculog_api.

    SELECT SINGLE * FROM /cadaxo/sqlcvnhd
            INTO ls_sqlcvnhd WHERE varguid = i_varguid.
    IF sy-subrc EQ 0.
      IF ls_sqlcvnhd-varname NE i_varname.

        /cadaxo/cl_sqlc_variant=>lock_variant( ls_sqlcvnhd-varguid ).

        IF NOT ls_sqlcvnhd-flag_public IS INITIAL AND ls_sqlcvnhd-cruser NE sy-uname.
          AUTHORITY-CHECK OBJECT 'ZCADXOSQ02' ID 'ACTVT' FIELD '06'. "Delete
          IF sy-subrc NE 0.
            RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_variant
              EXPORTING
                textid  = /cadaxo/cx_sqlc_variant=>no_auth_to_del_glob_variant
                variant = i_varguid.
          ENDIF.
        ENDIF.

        UPDATE /cadaxo/sqlcvnhd SET varname = i_varname
                                WHERE varguid = i_varguid.


        CREATE OBJECT gr_user_log.

        CLEAR ls_log.
        ls_log-object     = 'VARIANT'.
        ls_log-object_key = ls_sqlcvnhd-varguid.
        ls_log-type       = 'S'.
        ls_log-id         = '/CADAXO/SQLC'.
        ls_log-number     = '156'.
        ls_log-message_v1 = ls_sqlcvnhd-varguid.
        IF 1 = 2. MESSAGE s156(/cadaxo/sqlc). ENDIF.

        gr_user_log->add_ulog( i_log_message = ls_log ).

        /cadaxo/cl_sqlc_variant=>unlock_variant( i_varguid ).

      ENDIF.

    ELSE.

      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_variant
        EXPORTING
          textid  = /cadaxo/cx_sqlc_variant=>variant_not_found
          variant = i_varguid.

    ENDIF.

  ENDMETHOD.


  METHOD unlock_variant.
****************************************************************************************************
* Description             : Unlock Variant                                                         *
*--------------------------------------------------------------------------------------------------*
* Additional informations :                                                                        *
*                                                                                                  *
*--------------------------------------------------------------------------------------------------*
* Developer               : CADAXO                   Company    : CADAXO GesmbH                    *
* Date                    : 01.12.2012               Release    : WAS 7.00                         *
*--------------------------------------------------------------------------------------------------*
* Qual. Check(opt.)       : xxxxxx xxxxxxxxxxx       Company    : xxxxxxxxxxxxx                    *
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
    CALL FUNCTION 'DEQUEUE_/CADAXO/SQLCVARE'
      EXPORTING
*       MODE_/CADAXO/SQLCVNHD       = 'E'
*       MANDT   = SY-MANDT
        varguid = i_varguid
*       X_VARGUID                   = ' '
*       _SCOPE  = '3'
*       _SYNCHRON                   = ' '
*       _COLLECT                    = ' '
      .

  ENDMETHOD.


  METHOD upload_variant.

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
    DATA l_binary      TYPE xstring.
    DATA ls_sqlx       TYPE /cadaxo/sqlc_var_updown_sqlx.
    DATA ls_file       TYPE typ_file.
    DATA ls_sqlcvnhd   TYPE /cadaxo/sqlcvnhd.
    DATA ls_sqlcvntx   TYPE /cadaxo/sqlcvntx.
    DATA l_binary_file TYPE xstring.
    DATA l_xml         TYPE xstring.

    cl_gui_frontend_services=>file_open_dialog(
       EXPORTING
        default_extension       = '*.sqllx'
        file_filter             = 'SQLLX File (*.sqllx)|*.sqllx| All Files(*.*)|*.*'
         multiselection         = ' '
      CHANGING
        file_table              = lt_file_table
        rc                      = l_rc
         user_action            = l_user_action
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

                IMPORT sqlx TO l_xml FROM DATA BUFFER ls_file-binary.

                CALL TRANSFORMATION id
                  SOURCE XML l_xml
                  RESULT /cadaxo/sqlc_var_updown_sqlx = ls_sqlx.

                IF sy-subrc EQ 0.

                  CLEAR: ls_sqlcvntx, ls_sqlcvnhd.

                  MOVE-CORRESPONDING ls_sqlx TO ls_sqlcvnhd.
                  MOVE-CORRESPONDING ls_sqlx TO ls_sqlcvntx.

                  CALL FUNCTION 'GUID_CREATE'
                    IMPORTING
                      ev_guid_32 = ls_sqlcvnhd-varguid.

                  ls_sqlcvntx-varguid = ls_sqlcvnhd-varguid.
                  ls_sqlcvnhd-chuser  = sy-uname.

                  INSERT /cadaxo/sqlcvnhd FROM ls_sqlcvnhd.
                  IF sy-subrc EQ 0.
                    INSERT /cadaxo/sqlcvntx FROM ls_sqlcvntx.
                    IF sy-subrc EQ 0.
                      COMMIT WORK.
                      r_varguid = ls_sqlcvnhd-varguid.
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
ENDCLASS.
