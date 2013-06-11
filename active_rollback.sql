REM Script Name		: active_rollback.sql
REM Author			: Craig Richards
REM Created			:
REM Last Modified	:
REM Version			: 1.0
REM
REM Modifications	:
REM
REM Description		: Shows active rollback segments

SELECT SUBSTR(r.name,1,5) RSN,s.sid SID, SUBSTR(nvl(s.username, 'No Tran'),1,7) USR, s.osuser OSUSR, s.terminal TERM, o.rssize/(1024*1024) RSIZE
FROM   v$lock l, v$session s, v$rollname r, v$rollstat o
WHER   l.sid = s.sid(+)
AND    TRUNC(l.id1/65536) = r.usn
AND    o.usn = r.usn
AND    l.type = 'TX'
AND    l.lmode = 6
ORDER BY r.name;

REM End of Script
