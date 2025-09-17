CLASS ltcl_auth DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: cut TYPE REF TO /cadaxo/cl_sqlc_authchecks.
    METHODS: blacklist_check_tables FOR TESTING.
ENDCLASS.


CLASS ltcl_auth IMPLEMENTATION.

  METHOD blacklist_check_tables.

    cut->blacklist_check_tables( VALUE #( )  ).

  ENDMETHOD.

ENDCLASS.
