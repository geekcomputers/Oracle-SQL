REM Script Name		: db_cache_advice.sql
REM Author				: Craig Richards
REM Created			: 05-March-2009
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: Shows whether or not to change the setting for DB_CACHE

COLUMN size_for_estimate FORMAT 999,999,999,999 HEADING 'Cache Size(M)'
COLUMN buffers_for_estimate FORMAT 999,999,999 HEADING 'Buffers'
COLUMN estd_physical_read_factor FORMAT 999.90 HEADING 'Estd Phys|Read Factor'
COLUMN estd_physical_reads FORMAT 999,999,999 HEADING 'Estd Phys| Reads'

SET ECHO OFF
SET FEEDBACK OFF
SET PAGESIZE 50
SET LINESIZE 200

SPOOL db_cache_advice.txt

SELECT size_for_estimate, buffers_for_estimate,estd_physical_read_factor,estd_physical_reads
FROM   v$db_cache_advice
WHERE  name = 'DEFAULT'
AND    block_size = (SELECT value FROM v$parameter WHERE name = 'db_block_size')
AND    advice_status = 'ON';

SPOOL OFF

SET FEEDBACK 6
SET PAGESIZE 24

CLEAR COLUMNS

REM End of Script
