REM Filename      : unix_process.sql
REM Author        : Craig Richards
REM Created       : 27-June-2006
REM Version       : 1.1
REM Modifications : 1.1 10th March 2009 (CR) - Added the sid and the serial number 
REM
REM Description   : Show what program is running when you pass a UNIX PID

SELECT s.username, s.program, p.spid,s.status,s.sid, s.serial# 
FROM   v$session s, v$process p
WHERE  p.addr = s.paddr
AND    p.spid = &PROC_ID;

REM End of Script
