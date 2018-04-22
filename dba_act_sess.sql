set linesize 300
col logtim for a14
col program for a12
col module for a12
col action for a12
col service_name for a12
col osuser for a10
col spid for  999999




select 
    ses.inst_id, ses.sid,ses.seriaL#,
    ses.username,ses.osuser,to_char(ses.logon_time,'dd-mon hh24:mi') logtim,
    ses.program,ses.module,ses.action,ses.service_name,
    ses.blocking_instance,
    ses.blocking_session,
    proc.pid,proc.spid
from
    gv$session ses,
    gv$process proc
where
    (proc.addr=ses.paddr and ses.inst_id=proc.inst_id)
    and ses.username is not null
    and ses.status='ACTIVE'
order by ses.inst_id,ses.username;
