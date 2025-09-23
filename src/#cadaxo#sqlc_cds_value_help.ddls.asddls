@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SQL Cockpit–Tables, CDS View, DB Views'
define view entity /CADAXO/SQLC_CDS_VALUE_HELP
  as select from dd02l
    inner join   dd02t on  dd02l.tabname    = dd02t.tabname
                       and dd02t.as4local   = dd02l.as4local
                       and dd02t.as4vers    = dd02l.as4vers
                       and dd02t.ddlanguage = $session.system_language
{
  key dd02l.tabname                    as object_name,
      cast( 'TABLE' as abap.char(10) ) as object_type,
      dd02t.ddtext                     as object_text
}
where
      dd02l.tabclass = 'TRANSP'
  and dd02l.as4local = 'A'

union all

select from  dd02l
  inner join dd02t on  dd02l.tabname    = dd02t.tabname
                   and dd02t.as4local   = dd02l.as4local
                   and dd02t.as4vers    = dd02l.as4vers
                   and dd02t.ddlanguage = $session.system_language
{
  key dd02l.tabname                     as object_name,
      cast('DB_VIEW' as abap.char(10) ) as object_type,
      dd02t.ddtext                      as object_text
}
where
      dd02l.tabclass  = 'VIEW'
  and dd02l.as4local = 'A'

union all

select from       ddddlsrc  as src
  left outer join ddddlsrct as txt on  txt.ddlname    = src.ddlname
                                   and txt.as4local   = src.as4local
                                   and txt.ddlanguage = $session.system_language
{
  key src.ddlname                         as object_name,
      cast( 'CDS_VIEW' as abap.char(10) ) as object_type,
      coalesce( txt.ddtext, src.ddlname ) as object_text
}
where
      src.as4local    = 'A'
  and src.source_type = 'V';
