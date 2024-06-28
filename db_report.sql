REM Script Name		: db_report.sql
REM Author				: Craig Richards
REM Created			: 07-December-2006
REM Last Modified	:	
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		:

SET PAUSE OFF
SET HEADING OFF

ACCEPT dbsid PROMPT "Enter SID for report : ";
SPOOL /admin/output/db_report_&dbsid

PROMPT Database Information
PROMPT ====================

SELECT banner from v$version;

SET HEADING ON

select DBID,name,LOG_MODE,created from v$database;

SET HEADING OFF

PROMPT
PROMPT Who Has the Dba privilege
PROMPT =========================

SELECT grantee FROM dba_role_privs WHERE granted_role = 'DBA';

PROMPT
PROMPT Who owns the recovery catalog
PROMPT =============================

SELECT grantee FROM dba_role_privs WHERE granted_role = 'RECOVERY_CATALOG_OWNER';

SET FEEDBACK OFF

PROMPT
PROMPT Map of datafiles, controlfiles, redo logs
PROMPT =========================================

PROMPT
PROMPT Datafiles
PROMPT =========

SELECT file_name FROM dba_data_files;

PROMPT
PROMPT Control Files
PROMPT =============

COLUMN name FORMAT A40

SELECT name FROM v$controlfile;

CLEAR COLUMNS

PROMPT
PROMPT Redo Logs
PROMPT =========

SELECT member FROM v$logfile;

SET PAUSE OFF
SET FEEDBACK OFF
SET PAGESIZE 66
SET TERMOUT OFF
SET TRIMSPOOL ON

TTITLE SKIP 2 CENTER 'FREE - Free space by Tablespace' skip 2

COLUMN dummy    NOPRINT
COLUMN pct_used FORMAT 999.9             HEADING "%|Used"
COLUMN name     FORMAT A16               HEADING "Tablespace Name"
COLUMN bytes    FORMAT 9,999,999,999,999 HEADING "Total Bytes"
COLUMN used     FORMAT 9,999,999,999,999 HEADING "Used"
COLUMN free     FORMAT 999,999,999,999   HEADING "Free"

BREAK ON REPORT

COMPUTE SUM of bytes ON REPORT
COMPUTE SUM of free ON REPORT
COMPUTE SUM of used ON REPORT

SELECT   a.tablespace_name name, b.tablespace_name dummy,
         SUM(b.bytes)/COUNT( DISTINCT a.file_id||'.'||a.block_id ) bytes,
         SUM(b.bytes)/COUNT( DISTINCT a.file_id||'.'||a.block_id ) -
         SUM(a.bytes)/COUNT( DISTINCT b.file_id ) used,
         SUM(a.bytes)/COUNT( DISTINCT b.file_id ) free,
         100 * ( (SUM(b.bytes)/COUNT( DISTINCT a.file_id||'.'||a.block_id )) -
         (SUM(a.bytes)/COUNT( DISTINCT b.file_id ) )) /
         (SUM(b.bytes)/COUNT( DISTINCT a.file_id||'.'||a.block_id )) pct_used
FROM     sys.dba_free_space a, sys.dba_data_files b
WHERE    a.tablespace_name = b.tablespace_name 
GROUP BY a.tablespace_name, b.tablespace_name;
SET TERMOUT ON

TTITLE OFF

PROMPT
PROMPT User Information
PROMPT ================
PROMPT

COLUMN username FORMAT A20
COLUMN profile FORMAT A10
COLUMN default_tablespace FORMAT A15
COLUMN temporary_tablespace FORMAT A15

select username, default_tablespace, temporary_tablespace,profile, created from dba_users;

CLEAR COLUMNS

PROMPT
PROMPT Database Parameters
PROMPT ===================

COLUMN name FORMAT A40
COLUMN value FORMAT A60

SET LINES 200

select name, value from v$parameter;

CLEAR COLUMNS

SET LINES 80

SET PAUSE OFF

COLUMN segment_name     FORMAT A15
COLUMN tablespace_name  FORMAT A15

PROMPT
PROMPT Rollback Segments
PROMPT =================

SELECT  segment_name, tablespace_name, segment_id, status 
FROM    dba_rollback_segs;

SET PAUSE OFF
SET FEEDBACK OFF

COLUMN name FORMAT A20

SELECT  name, optsize, shrinks, aveshrink, extends,wraps
FROM    v$rollstat, v$rollname
WHERE   v$rollstat.usn=v$rollname.usn;

PROMPT
PROMPT Invalid Objects in the database
PROMPT ===============================

SET LINES 200

COLUMN owner FORMAT A20
COLUMN object_name FORMAT A30
COLUMN object_type FORMAT A30

select owner, object_name, object_type from dba_objects where status = 'INVALID';

CLEAR COLUMNS

SET LINESIZE 80

PROMPT
PROMPT SGA Settings
PROMPT ============

SHOW SGA;

PROMPT 
PROMPT Tablespace Information
PROMPT ======================

COLUMN tablespace_name FORMAT A25

SET LINES 200
SET HEADING ON

select tablespace_name, initial_extent, next_extent,min_extents,max_extents,extent_management from dba_tablespaces;

COLUMN file_name FORMAT A80

select file_name from dba_data_files where AUTOEXTENSIBLE = 'YES';

CLEAR COLUMNS

SET LINES 80

PROMPT
PROMPT DBMS SCHEDULER 
PROMPT ==============

SELECT owner, job_name, job_type FROM dba_scheduler_jobs;

PROMPT
PROMPT Undo Stats
PROMPT ==========
PROMPT

SET LINES 200

SELECT TO_CHAR(MIN(Begin_Time), 'DD-MON-YYYY HH24:MI:SS') "Begin Time",
       TO_CHAR(MAX(End_Time), 'DD-MON-YYYY HH24:MI:SS') "End Time",
       SUM(Undoblks) "Total Undo Blocks Used",
       SUM(Txncount) "Total Num Trans Exec",
       MAX(Maxquerylen) "Longest Query(in secs)",
       MAX(Maxconcurrency) "Highest Concurrent Trans Count",
       SUM(Ssolderrcnt), SUM(Nospaceerrcnt)
FROM   v$undostat;

SPOOL OFF

REM exit

-- 生成一描述数据库的脚本

REM End of Script
