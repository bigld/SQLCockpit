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
    METHODS all_sources_allowed IMPORTING i_result_sources     TYPE /cadaxo/sqlcselectsource_t
                                RETURNING VALUE(e_all_allowed) TYPE /cadaxo/sqlcflagtruefalse
                                RAISING   /cadaxo/cx_sqlc_authchecks.
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
    DATA not_allowed_table TYPE string.

* send error message if no authorization
    IF cockpitrole-excluded IS INITIAL AND cockpitrole-included IS INITIAL.
      MESSAGE e118(/cadaxo/sqlc).
    ENDIF.

    TRY.
        IF NOT all_sources_allowed( i_result_sources ).

        ENDIF.
      CATCH /cadaxo/cx_sqlc_authchecks INTO DATA(authexception).
        MESSAGE e010(/cadaxo/sqlc) WITH authexception->not_allowed_table.
        RETURN.
    ENDTRY.

* also check the s_tabu_dis authority
    LOOP AT i_result_sources ASSIGNING FIELD-SYMBOL(<result_sources>).

      CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
        EXPORTING
          view_action                = 'S' "SHOW
          view_name                  = <result_sources>-table
          no_warning_for_clientindep = abap_true
        EXCEPTIONS
          OTHERS                     = 1.
      IF sy-subrc NE 0.
        CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
          EXPORTING
            view_action                = 'U' "UPDATE
            view_name                  = <result_sources>-table
            no_warning_for_clientindep = abap_true
          EXCEPTIONS
            OTHERS                     = 1.
        IF sy-subrc NE 0.
          not_allowed_table = not_allowed_table && COND #( WHEN not_allowed_table IS NOT INITIAL THEN |, | ) && <result_sources>-table.
        ENDIF.
      ENDIF.
    ENDLOOP.
    IF NOT not_allowed_table IS INITIAL.
      MESSAGE e058(/cadaxo/sqlc) WITH not_allowed_table.
    ENDIF.

  ENDMETHOD.

  METHOD all_sources_allowed.
    DATA allowed           TYPE abap_bool.
    DATA not_allowed_table TYPE string.

    LOOP AT i_result_sources REFERENCE INTO DATA(result_sources).

      allowed = abap_false.
* check user authorization

      LOOP AT cockpitrole-included ASSIGNING FIELD-SYMBOL(<included_tables>).
        IF result_sources->table CP <included_tables>.
          allowed = abap_true.
          LOOP AT cockpitrole-excluded ASSIGNING FIELD-SYMBOL(<excluded_tables>).
            IF result_sources->table CP <excluded_tables>.
              allowed = abap_false.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.

      IF allowed = abap_false.
        not_allowed_table = not_allowed_table && COND #( WHEN not_allowed_table IS NOT INITIAL THEN |, | ) && result_sources->table.
      ENDIF.

    ENDLOOP.

    e_all_allowed = boolc( not_allowed_table IS INITIAL ).

    IF e_all_allowed = abap_false.
      RAISE EXCEPTION TYPE /cadaxo/cx_sqlc_authchecks
        EXPORTING
          textid            = /cadaxo/cx_sqlc_authchecks=>no_table_auth
          not_allowed_table = not_allowed_table.
    ENDIF.
  ENDMETHOD.



  METHOD get_cockpitrole.
    r_cockpitrole = cockpitrole.
  ENDMETHOD.

ENDCLASS.
