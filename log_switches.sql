REM Script Name	: log_switches.sql
REM Author				: Craig Richards
REM Created			: 18 March 2013 
REM Last Modified	:
REM Version			: 1.0
REM
REM Modifications	:
REM
REM Description		: Show information about recent log switches in the database, orginally got FROM http://www.dba-oracle.com/tips_oracle_v$_log_history.htm

COLUMN c1 format a10 HEADING "Month"
COLUMN c2 format a25 HEADING "Archive Date"
COLUMN c3 format 999 HEADING "Switches"

COMPUTE AVG of C on A
COMPUTE AVG of C on REPORT

BREAK ON A skip 1 ON REPORT SKIP 1

SELECT		TO_CHAR(TRUNC(first_time), 'Month') c1,
						TO_CHAR(TRUNC(first_time), 'Day : DD-Mon-YYYY') c2,  COUNT(*) c3
FROM			v$log_history
WHERE			TRUNC(first_time) > last_day(sysdate-100) +1
GROUP BY	TRUNC(first_time);

   
REM Daily COUNT and Size of Redo Log Space (Single Instance)

SELECT 	A.*, ROUND(A.COUNT#*B.AVG#/1024/1024) Daily_Avg_Mb
FROM
(
  SELECT
  TO_CHAR(First_Time,'YYYY-MM-DD') DAY,
  COUNT(1) COUNT#,
  MIN(RECID) Min#,
  MAX(RECID) Max#
FROM
   v$log_history
GROUP BY 
   TO_CHAR(First_Time,'YYYY-MM-DD')
ORDER BY 1 DESC
) A,
(
SELECT
AVG(BYTES) AVG#,
COUNT(1) COUNT#,
MAX(BYTES) Max_Bytes,
MIN(BYTES) Min_Bytes
FROM v$log
) B
;

