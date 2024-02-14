class /CADAXO/CX_SQLC_ODATA_MGW_BUSI definition
  public
  inheriting from /IWBEP/CX_MGW_BUSI_EXCEPTION
  create public .

public section.

  constants:
    begin of SQL_FILTER,
      msgid type symsgid value '/IWBEP/CM_MGW_RT',
      msgno type symsgno value '063',
      attr1 type scx_attrname value 'FILTER_PARAM',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SQL_FILTER .
  constants:
    begin of FILTER_CRITERIA,
      msgid type symsgid value '/CADAXO/SQLC',
      msgno type symsgno value '161',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of FILTER_CRITERIA .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MESSAGE_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER optional
      !HTTP_STATUS_CODE type /IWBEP/MGW_HTTP_STATUS_CODE default GCS_HTTP_STATUS_CODES-BAD_REQUEST
      !HTTP_HEADER_PARAMETERS type /IWBEP/T_MGW_NAME_VALUE_PAIR optional
      !SAP_NOTE_ID type /IWBEP/MGW_SAP_NOTE_ID optional
      !MSG_CODE type STRING optional
      !EXCEPTION_CATEGORY type TY_EXCEPTION_CATEGORY optional
      !ENTITY_TYPE type STRING optional
      !MESSAGE type BAPI_MSG optional
      !MESSAGE_UNLIMITED type STRING optional
      !FILTER_PARAM type STRING optional
      !OPERATION_NO type I optional .
protected section.
private section.
ENDCLASS.



CLASS /CADAXO/CX_SQLC_ODATA_MGW_BUSI IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
MESSAGE_CONTAINER = MESSAGE_CONTAINER
HTTP_STATUS_CODE = HTTP_STATUS_CODE
HTTP_HEADER_PARAMETERS = HTTP_HEADER_PARAMETERS
SAP_NOTE_ID = SAP_NOTE_ID
MSG_CODE = MSG_CODE
EXCEPTION_CATEGORY = EXCEPTION_CATEGORY
ENTITY_TYPE = ENTITY_TYPE
MESSAGE = MESSAGE
MESSAGE_UNLIMITED = MESSAGE_UNLIMITED
FILTER_PARAM = FILTER_PARAM
OPERATION_NO = OPERATION_NO
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
