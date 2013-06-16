REM Script Name		: db_buffer_hr.sql
REM Author				: Craig Richards
REM Created			:
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: Displays the buffer cache hit ratio

COLUMN BUFFER_POOL_NAME FORMAT A20

SELECT name BUFFER_POOL_NAME, consistent_gets Consistent, db_block_gets Dbblockgets,
physical_reads Physrds,
ROUND(100*(1 - (physical_reads/(consistent_gets + db_block_gets))),2) HitRatio
FROM v$buffer_pool_statistics
WHERE (consistent_gets + db_block_gets) != 0;

REM End of Script
