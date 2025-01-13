
PROCESS BEFORE OUTPUT.
  MODULE pbo_0150.

PROCESS AFTER INPUT.
  CHAIN.
    FIELD:
*           /cadaxo/sqlc_jobwiz_fields-notification_sap_mail_flag,
"-Cockpit-451
           /cadaxo/sqlc_jobwiz_fields-notification_sap_mail.
    MODULE check_sap_user ON CHAIN-INPUT.
  ENDCHAIN.
  CHAIN.
    FIELD:
*           /cadaxo/sqlc_jobwiz_fields-notification_email_flag,
"-Cockpit-451
           /cadaxo/sqlc_jobwiz_fields-notification_email1,
           /cadaxo/sqlc_jobwiz_fields-notification_email2.
    MODULE check_email_address ON CHAIN-INPUT.
  ENDCHAIN.
