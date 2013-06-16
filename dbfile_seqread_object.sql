REM Script Name		: dbfile_seqread_object.sql
REM Author				: Craig Richards
REM Created			: 06-August-2008
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: Shows the object causing the waits 

SELECT   b.sid, nvl(substr(a.object_name,1,30),'P1='||b.p1||' P2='||b.p2||' P3='||b.p3) object_name,
         a.subobject_name,
         a.object_type
FROM     dba_objects a, v$session_wait b, x$bh c
WHERE    c.obj   = a.object_id(+)
AND      b.p1    = c.file#(+)
AND      b.p2    = c.dbablk(+)
AND      b.event = 'db file sequential read'
UNION
SELECT   b.sid, nvl(substr(a.object_name,1,30), 'P1='||b.p1||' P2='||b.p2||' P3='||b.p3) object_name,
         a.subobject_name,
         a.object_type
FROM     dba_objects a, v$session_wait b, x$bh c
WHERE    c.obj   = a.data_object_id(+)
AND      b.p1    = c.file#(+)
AND      b.p2    = c.dbablk(+)
AND      b.event = 'db file sequential read'
ORDER BY 1;

REM End of Script
