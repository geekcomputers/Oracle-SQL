REM Filename      : pga_cache_advice.sql
REM Author        : Craig Richards
REM Created       : 26-March-2009
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Shows whether or not to change the setting for PGA_AGGREGATE_TARGET

SET ECHO OFF
SET FEEDBACK OFF
SET PAGESIZE 50
SET LINESIZE 200

COLUMN estd_extra_bytes_rw FORMAT 999,999,999,999
COLUMN bytes_processed     FORMAT 999,999,999,999

SELECT pga_target_for_estimate/1048576 pga_target,bytes_processed,estd_extra_bytes_rw
FROM   v$pga_target_advice;

SET FEEDBACK 6
SET PAGESIZE 24

CLEAR COLUMNS

REM End of Script
