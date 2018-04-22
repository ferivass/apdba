set linesize 200
col sess_id for a32

select  
lpad(' ',level*2,' ')||sid sess_id,serial#,
INSTANCE_NUM,blocking_session,username
from gv$session
where username is not null
start with blocking_session is null
connect by prior sid = blocking_session and INST_ID = blocking_instance
order siblings by sid;
