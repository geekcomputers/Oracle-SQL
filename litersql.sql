REM Filename      : litersql.sql
REM Author        : Craig Richards
REM Created       : 06-March-2009
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Identify statements that could benefit converting to using bind variables

SET VERIFY OFF

SELECT   SUBSTR(sql_text,1,60) "SQL", COUNT(*),SUM(executions) "TOTAL EXECUTIONS"
FROM     v$sqlarea
WHERE    executions < 5
GROUP BY SUBSTR(sql_text,1,60)
HAVING COUNT(*) > 20
ORDER BY 2;

REM End of Script
