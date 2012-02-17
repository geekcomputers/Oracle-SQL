REM Filename      : maxshrink.sql
REM Author        : Craig Richards - originally from Asktom.oracle.com
REM Created       :
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Displays the size your datafiles can be shrunk to, it also generates the commands for you

SET VERIFY OFF

COLUMN file_name FORMAT a50 word_wrapped
COLUMN smallest FORMAT 999,990 HEADING "Smallest|Size|Poss."
COLUMN currsize FORMAT 999,990 HEADING "Current|Size"
COLUMN savings  FORMAT 999,990 HEADING "Poss.|Savings"

BREAK ON report

COMPUTE sum of savings on report

COLUMN value new_val blksize

SELECT value FROM v$parameter WHERE name = 'db_block_size'
/

SELECT file_name,
       CEIL( (NVL(hwm,1)*&&blksize)/1024/1024 ) smallest,
       CEIL( blocks*&&blksize/1024/1024) currsize,
       CEIL( blocks*&&blksize/1024/1024) -
       CEIL( (NVL(hwm,1)*&&blksize)/1024/1024 ) savings
FROM dba_data_files a,
     ( SELECT file_id, max(block_id+blocks-1) hwm
         FROM dba_extents
        group by file_id ) b
WHERE a.file_id = b.file_id(+)
/

COLUMN cmd FORMAT a75 word_wrapped

SELECT 'alter database datafile '''||file_name||''' resize ' ||
       CEIL( (NVL(hwm,1)*&&blksize)/1024/1024 )  || 'm;' cmd
FROM dba_data_files a,
     ( SELECT file_id, max(block_id+blocks-1) hwm
         FROM dba_extents
        GROUP BY file_id ) b
WHERE a.file_id = b.file_id(+)
  AND CEIL( blocks*&&blksize/1024/1024) -
      CEIL( (NVL(hwm,1)*&&blksize)/1024/1024 ) > 0
/

REM End of Script
