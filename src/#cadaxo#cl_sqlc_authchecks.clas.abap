CLASS /cadaxo/cl_sqlc_authchecks DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.
    METHODS blacklist_check_tables IMPORTING i_result_sources TYPE /cadaxo/sqlcselectsource_t .
    METHODS get_cockpitrole RETURNING VALUE(r_cockpitrole) TYPE /cadaxo/sqlcrole_auth_xml.

  PROTECTED SECTION.

    DATA cockpitrole TYPE /cadaxo/sqlcrole_auth_xml .
  PRIVATE SECTION.
ENDCLASS.



CLASS /cadaxo/cl_sqlc_authchecks IMPLEMENTATION.

  METHOD constructor.

    DATA refuser  TYPE bapirefus.
    DATA returns  TYPE TABLE OF bapiret2.
    DATA user     TYPE xubname.
    DATA roles    TYPE TABLE OF /cadaxo/sqlcrole.
    DATA ls_auth  TYPE /cadaxo/sqlcrole_auth_xml.
    DATA ls_table_ui TYPE /cadaxo/sqlcroled_tab_ui.

    user = cl_abap_syst=>get_user_name( ).

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username = user
      IMPORTING
        ref_user = refuser
      TABLES
        return   = returns.

    SELECT b~role
           b~auth_xml
      INTO CORRESPONDING FIELDS OF TABLE roles
      FROM /cadaxo/sqlcrolr AS a
             INNER JOIN
               /cadaxo/sqlcrole AS b ON b~role = a~role
      WHERE a~uname = user OR a~uname = refuser-ref_user. "#EC CI_BYPASS
    IF sy-subrc <> 0.
      SELECT * FROM /cadaxo/sqlcrole INTO CORRESPONDING FIELDS OF TABLE roles WHERE role_default <> space.
    ENDIF.

    LOOP AT roles ASSIGNING FIELD-SYMBOL(<role>).
      CLEAR ls_auth.
      TRY.
          CALL TRANSFORMATION id
               SOURCE XML <role>-auth_xml
               RESULT auth = ls_auth.

          LOOP AT ls_auth-included ASSIGNING FIELD-SYMBOL(<l_sqlcdtable_auth>).
            CLEAR ls_table_ui.
            ls_table_ui-table_auth = <l_sqlcdtable_auth>.
            APPEND ls_table_ui-table_auth TO cockpitrole-included.
          ENDLOOP.
          LOOP AT ls_auth-excluded ASSIGNING <l_sqlcdtable_auth>.
            CLEAR ls_table_ui.
            ls_table_ui-table_auth = <l_sqlcdtable_auth>.
            APPEND ls_table_ui-table_auth TO cockpitrole-excluded.
          ENDLOOP.
        CATCH cx_transformation_error.                  "#EC NO_HANDLER
      ENDTRY.
    ENDLOOP.

    SORT cockpitrole-included.
    SORT cockpitrole-excluded.

    DELETE ADJACENT DUPLICATES FROM cockpitrole-included.
    DELETE ADJACENT DUPLICATES FROM cockpitrole-excluded.
  ENDMETHOD.

  METHOD blacklist_check_tables.

    DATA: l_yes    TYPE c,
          l_tables TYPE string.

    LOOP AT i_result_sources ASSIGNING FIELD-SYMBOL(<result_sources>).
      " check blacklist tables
      /cadaxo/cl_sqlc_cockpit_assist=>blacklist_check_table(
        EXPORTING  i_table                = <result_sources>-table
        EXCEPTIONS table_access_forbidden = 1
                   OTHERS                 = 2 ).
      IF sy-subrc NE 0.
        MESSAGE e010(/cadaxo/sqlc) WITH <result_sources>-table.
      ENDIF.

* check user authorization

      CLEAR l_yes.

      LOOP AT cockpitrole-included ASSIGNING FIELD-SYMBOL(<included_tables>).
        IF <result_sources>-table CP <included_tables>.
          l_yes = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF l_yes = abap_true.
        LOOP AT cockpitrole-excluded ASSIGNING FIELD-SYMBOL(<excluded_tables>).
          IF <result_sources>-table CP <excluded_tables>.
            CLEAR l_yes.
            IF l_tables IS INITIAL.
              l_tables = <result_sources>-table.
            ELSE.
              CONCATENATE l_tables ',' INTO l_tables.
              CONCATENATE l_tables <result_sources>-table INTO l_tables SEPARATED BY space.
            ENDIF.
            EXIT.
          ENDIF.
        ENDLOOP.
      ELSE.
        IF l_tables IS INITIAL.
          l_tables = <result_sources>-table.
        ELSE.
          CONCATENATE l_tables ',' INTO l_tables.
          CONCATENATE l_tables <result_sources>-table INTO l_tables SEPARATED BY space.
        ENDIF.
      ENDIF.

    ENDLOOP.

* send error message if no authorization
    IF cockpitrole-excluded IS INITIAL AND cockpitrole-included IS INITIAL.
      MESSAGE e118(/cadaxo/sqlc).
    ELSEIF l_yes EQ space.
      MESSAGE e010(/cadaxo/sqlc) WITH l_tables.
    ELSE.
* also check the s_tabu_dis authority
      CLEAR l_tables.
      DATA l_view_name(30) TYPE c.
      LOOP AT i_result_sources ASSIGNING <result_sources>.
        l_view_name = <result_sources>-table.
        CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
          EXPORTING
            view_action                = 'S' "SHOW
            view_name                  = l_view_name
            no_warning_for_clientindep = abap_true
          EXCEPTIONS
            OTHERS                     = 1.
        IF sy-subrc NE 0.
          CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
            EXPORTING
              view_action                = 'U' "UPDATE
              view_name                  = l_view_name
              no_warning_for_clientindep = abap_true
            EXCEPTIONS
              OTHERS                     = 1.
          IF sy-subrc NE 0.
            IF l_tables IS INITIAL.
              l_tables = <result_sources>-table.
            ELSE.
              CONCATENATE l_tables ',' INTO l_tables.
              CONCATENATE l_tables <result_sources>-table INTO l_tables SEPARATED BY space.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
      IF NOT l_tables IS INITIAL.
        MESSAGE e058(/cadaxo/sqlc) WITH l_tables.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD get_cockpitrole.
    r_cockpitrole = cockpitrole.
  ENDMETHOD.

ENDCLASS.
