REM Script Name	: redo_log_switches.sql
REM Author				: Craig Richards
REM Created	: 30 November 2012 
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications	:
REM
REM Description		: Show the redo log switching in the database, two different ways to display the information

COLUMN c1 FORMAT A10 HEADING "Month"
COLUMN c2 FORMAT A25 HEADING "Archive Date"
COLUMN c3 FORMAT 999 HEADING "Switches"

COMPUTE AVG of C ON A
COMPUTE AVG of C ON REPORT

BREAK ON A SKIP 1 ON REPORT SKIP 1

SELECT	  TO_CHAR(TRUNC(first_time), 'Month') c1, TO_CHAR(TRUNC(first_time), 'Day : DD-MON-YYYY') c2, COUNT(*) c3
FROM		  v$log_history
WHERE	  TRUNC(first_time) > last_day(SYSDATE-30) +1
GROUP BY trunc(first_time);
 
-- Daily Count and Size of Redo Log Space (Single Instance)

SELECT		A.*, ROUND(A.COUNT#*B.AVG#/1024/1024) Daily_Avg_Mb
FROM			(SELECT TO_CHAR(First_Time,'YYYY-MM-DD') DAY, COUNT(1) COUNT#, MIN(RECID) MIN#, MAX(RECID) MAX#
FROM			v$log_history
GROUP BY	TO_CHAR(First_Time,'YYYY-MM-DD')
ORDER BY	1) A,
(
SELECT		AVG(BYTES) AVG#, COUNT(1) COUNT#, MAX(BYTES) Max_Bytes, MIN(BYTES) Min_Bytes
FROM			v$log) B;