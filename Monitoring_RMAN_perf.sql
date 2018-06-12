select 
sid, serial#, sofar, totalwork, opname,   round(sofar/totalwork*100,2) "% Complete"
from   v$session_longops
where  opname LIKE 'RMAN%'
and    opname NOT LIKE '%aggregate%'
and    totalwork != 0
and    sofar <> totalwork;

select type, item, units, sofar, total from v$recovery_progress;


select s.client_info,
sl.opname,
sl.message,
sl.sid, sl.serial#, p.spid,
sl.sofar, sl.totalwork,
round(sl.sofar/sl.totalwork*100,2) "% Complete"
from   v$session_longops sl, v$session s, v$process p
where  p.addr = s.paddr
and    sl.sid=s.sid
and    sl.serial#=s.serial#
and    opname LIKE 'RMAN%'
and    opname NOT LIKE '%aggregate%'
and    totalwork != 0
and    sofar <> totalwork;


SELECT sid, serial, filename, type, elapsed_time, effective_bytes_per_second
FROM v$backup_async_io
WHERE close_time > trunc(sysdate);


SELECT sid, serial, filename, type, elapsed_time, effective_bytes_per_second
FROM v$backup_sync_io
WHERE close_time > trunc(sysdate)-10;

SELECT *
FROM v$backup_async_io
WHERE close_time > trunc(sysdate)-10;


SELECT *
FROM v$backup_sync_io
WHERE close_time > trunc(sysdate)-10;



If you have identified your SID and SERIAL number you can specifically
query for records associated with your current session:

SELECT filename, sid, serial, close_time, long_waits/io_count as ratio
FROM   v$backup_async_io
WHERE  type != 'AGGREGATE'
AND    SID = &SID
AND    SERIAL = &SERIAL
ORDER BY ratio desc;


If you are using tape drives, then query the EFFECTIVE_BYTES_PER_SECOND column of
V$BACKUP_SYNC_IO. If the effective rate is less than the tape device’s maximum throughput,
then this may indicate that your tape device is not streaming (continuously writing).

For tape devices, you can also identify bottlenecks by using the backup validate command. 
You can compare the time it takes for a regular backup job to tape versus just a backup
validate command. A backup validate command performs the same reads as a regular
backup but does not write to tape. If the time to perform a backup validate is significantly 
less than a regular backup job to tape, then writing to tape is most likely the bottleneck.