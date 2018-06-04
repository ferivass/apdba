
PROMPT ***	Enter a valid path to a valid folder 
PROMPT ***	like c:\temp for win or /u01 for Unix
PROMPT ***	where these collected infos are going 
PROMPT ***	to be spooled and wait for script to finish

ACCEPT SPOOLDIR PROMPT 'Enter the path: '


set pagesize 50000 
set linesize 400
set echo off
set feed off
set term off
set ver off
set numwidth 15
set arraysize 200
alter session set NLS_DATE_FORMAT='dd-mon-yyyy hh24:mi:ss';


column FV_DBNAME new_value FV_DBNAME noprint;
column FV_DBUNIQ new_value FV_DBUNIQ noprint;
column FV_HOST new_value FV_HOST noprint;
column FV_DBROLE new_value FV_DBROLE noprint;
column FV_DBPRIMUNIQ new_value FV_DBPRIMUNIQ noprint;
column FV_FILE new_value FV_FILE noprint;
column TESTSEP new_value TESTSEP noprint;
column DATAREP new_value DATAREP noprint;
col file_name for a64


select case when '&SPOOLDIR' like '%\%' then '\' else '/' END TESTSEP from dual;


col metadata format a32;

select
        d.name                                  FV_DBNAME,
        d.DB_UNIQUE_NAME                        FV_DBUNIQ ,
        d.PRIMARY_DB_UNIQUE_NAME                FV_DBPRIMUNIQ,
        replace(d.database_role,' ','')         FV_DBROLE,
        to_char(sysdate,'YYYYY-MM-DD')					DATAREP
from 
        v$database d
/

select
	host_name FV_HOST
from 
        v$instance
/

select 'SpaceReport_&FV_HOST._&FV_DBUNIQ._&FV_DBROLE._&DATAREP..txt' FV_FILE from dual;


--set markup html on TABLE "{border:thin single black;}" SPOOL ON



spool &SPOOLDIR&TESTSEP&FV_FILE




select sysdate as "report start run date" from dual;


select
        d.name                                 ,
        d.DB_UNIQUE_NAME                       ,
        d.PRIMARY_DB_UNIQUE_NAME               ,
        replace(d.database_role,' ','') dbrole
from
        v$database d
/



remark Data files
select * from dba_data_files order by 3,2;



select 
df.tablespace_name as "Tablespace name",
df.TablespaceSizeMB as "Tablespace size", 
df.MaxSizeMB as "Tablespace max size", 
free.freetablespace as "Free within TS", 
df.FeeUntilMaxSizeMB "Remaining to max size"
from 
(select 
db.tablespace_name, 
trunc(sum(bytes/1024/1024)) TablespaceSizeMB,
sum(decode(autoextensible,'YES',trunc((maxbytes-user_bytes)/1024/1024) , 0)) FeeUntilMaxSizeMB ,
trunc(sum(maxbytes/1024/1024)) MaxSizeMB
from 
dba_data_files db
group by db.TABLESPACE_NAME) df,
(select tablespace_name, trunc(sum(bytes)/1024/1024) freetablespace from dba_free_space group by tablespace_name) free
where df.tablespace_name=free.tablespace_name(+)
order by 1
/

select 
tablespace_name as "Tablespace name", 
file_name as "file name", 
autoextensible, 
trunc(bytes/1024/1024) as "Datafile size" ,
decode(free.freedatafile ,null,0,trunc(free.freedatafile/1024/1024)) as "free within datafile",
decode(autoextensible,'YES',trunc((maxbytes-user_bytes)/1024/1024) , 0) as "remaining to max size" ,
trunc(maxbytes/1024/1024) as "max size"
from 
dba_data_files db,
(select file_id, sum(bytes) freedatafile from dba_free_space group by file_id ) free
where db.file_id=free.file_id(+)
order by 1,2,4;


select sysdate as "report end run date" from dual;
spool off
set term on


PROMPT ***	DONE...
PROMPT ***	File spooled to &SPOOLDIR&TESTSEP&FV_FILE
PROMPT ***	...


--exit



 