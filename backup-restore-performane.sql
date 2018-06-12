set linesize 300

SELECT to_char(sysdate,'dd-mon-yyyy hh24:mi:ss') DATA,SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   V$SESSION_LONGOPS
WHERE  upper(OPNAME) LIKE '%RMAN%'
AND    OPNAME NOT LIKE '%aggregate%'
AND    TOTALWORK != 0
AND    SOFAR <> TOTALWORK;



SELECT to_char(sysdate,'dd-mon-yyyy hh24:mi:ss') DATA,SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   V$SESSION_LONGOPS
WHERE  upper(OPNAME) LIKE '%RMAN%'
AND    TOTALWORK != 0
AND    SOFAR <> TOTALWORK;




col filename format a64
select sid,serial,filename,TYPE,STATUS,EFFECTIVE_BYTES_PER_SECOND from  v$backup_sync_io;
select sid,serial,filename,TYPE,STATUS,EFFECTIVE_BYTES_PER_SECOND from  v$backup_async_io;
