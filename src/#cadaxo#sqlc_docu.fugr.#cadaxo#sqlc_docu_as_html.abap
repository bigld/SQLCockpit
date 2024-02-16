FUNCTION /cadaxo/sqlc_docu_as_html.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_DOCU_ID) TYPE  DOKHL-ID DEFAULT 'DT'
*"     VALUE(I_DOCU_OBJECT) TYPE  DOKHL-OBJECT
*"  TABLES
*"      CONTAINER STRUCTURE  SWCONT OPTIONAL
*"      HTML_LINES STRUCTURE  HTMLLINE OPTIONAL
*"  EXCEPTIONS
*"      DOCUMENTATION_NOT_FOUND
*"----------------------------------------------------------------------

  DATA: l_thead          LIKE thead,
        l_original_value TYPE swcont-value,
        t_lines          LIKE tline OCCURS 0 WITH HEADER LINE.

  FIELD-SYMBOLS: <l_line>      TYPE htmlline,
                 <l_container> TYPE swcont.

  CALL FUNCTION 'DOCU_GET_FOR_F1HELP'
    EXPORTING
      id     = i_docu_id
      langu  = sy-langu
      object = i_docu_object
    IMPORTING
      head   = l_thead
    TABLES
      line   = t_lines
    EXCEPTIONS
      OTHERS = 1.

  IF sy-subrc <> 0.
    MESSAGE ID 'S4' TYPE 'E' NUMBER '601' WITH i_docu_object sy-langu RAISING documentation_not_found.
  ENDIF.

  IF NOT container[] IS INITIAL.
    CALL FUNCTION 'SWU_TEXTLINES_REPLACE'
      EXPORTING
        text_header     = l_thead
      TABLES
        text_lines      = t_lines
        container       = container
      CHANGING
        new_text_header = l_thead
      EXCEPTIONS
        OTHERS          = 0.
  ENDIF.

  CALL FUNCTION 'SE_CONVERT_ITF_TO_HTML'
    EXPORTING
      is_header    = l_thead
      i_funcname   = 'EPSS_CONVERT_ITF_TO_HTML_LINK'
    TABLES
      it_itf_text  = t_lines
      it_html_text = html_lines
    EXCEPTIONS
      OTHERS       = 0.

  READ TABLE html_lines WITH KEY tdline = '</HEAD>' TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    INSERT INITIAL LINE INTO html_lines ASSIGNING FIELD-SYMBOL(<css>) INDEX sy-tabix.
    IF sy-subrc = 0.
       <css>-tdline = '<style type="text/css">html, body{ overflow: hidden;}</style>'.
    ENDIF.
  ENDIF.

ENDFUNCTION.
