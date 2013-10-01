REM Script Name		: monitor_cursors.sql
REM Author				: Craig Richards
REM Created			: 17 July 2013 
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: Shows the amount of cursors currently open

SET LINESIZE 200

COLUMN max_open_cursor FORMAT a30

SELECT 		MAX(a.value) AS highest_open_cursor, p.value AS max_open_cursor
FROM			v$sesstat a, v$statname b, v$parameter p
WHERE 		a.statistic# = b.statistic# 
AND 			b.name = 'opened cursors current' AND p.name= 'open_cursors'
GROUP BY 	p.value;