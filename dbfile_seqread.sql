REM Filename      : dbfile_seqread.sql
REM Author        : Craig Richards
REM Created       : 06-August-2008
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Shows the waits for dbfile_sequential_reads

SET LINES 200
SET PAUSE OFF

SELECT  a.sid, a.event, a.time_waited,
        a.time_waited / c.sum_time_waited * 100 pct_wait_time,
        ROUND((sysdate - b.logon_time) * 24) hours_connected
FROM    v$session_event a, v$session b,
        (SELECT sid, SUM(time_waited) sum_time_waited
        FROM   v$session_event
        WHERE  event NOT IN (
                   'Null event',
                   'client message',
                   'KXFX: Execution Message Dequeue - Slave',
                   'PX Deq: Execution Msg',
                   'KXFQ: kxfqdeq - normal deqeue',
                   'PX Deq: Table Q Normal',
                   'Wait for credit - send blocked',
                   'PX Deq Credit: send blkd',
                   'Wait for credit - need buffer to send',
                   'PX Deq Credit: need buffer',
                   'Wait for credit - free buffer',
                   'PX Deq Credit: free buffer',
                   'parallel query dequeue wait',
                   'PX Deque wait',
                   'Parallel Query Idle Wait - Slaves',
                   'PX Idle Wait',
                   'slave wait',
                   'dispatcher timer',
                   'virtual circuit status',
                   'pipe get',
                   'rdbms ipc message',
                   'rdbms ipc reply',
                   'pmon timer',
                   'smon timer',
                   'PL/SQL lock timer',
                   'SQL*Net message from client',
                   'WMON goes to sleep')
       HAVING SUM(time_waited) > 0 GROUP BY sid) c
WHERE    a.sid = b.sid
AND      a.sid = c.sid
AND      a.time_waited > 0
AND      a.event = 'db file sequential read'
ORDER BY hours_connected desc, pct_wait_time;

REM End of Script
