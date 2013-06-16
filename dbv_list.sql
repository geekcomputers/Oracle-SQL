REM Script Name		: dbv_list.sql
REM Author				: Craig Richards
REM Created			:
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: Creates a spool file of database files you can then use to use DBV utility

SET HEADING OFF
SET ECHO OFF
SET FLUSH OFF
SET PAGESIZE 9999
SET LINESIZE 132

SPOOL check_files_with_dbv.lis

SELECT 'dbv file='||d.file_name||' blocksize='||block_size||' feedback=1000 logfile='||d.file_id||'.lis'
FROM dba_data_files d, dba_tablespaces t
WHERE d.tablespace_name = t.tablespace_name
ORDER BY d.file_id desc;

SPOOL OFF

REM End of Script
