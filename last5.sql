REM Filename      : last5.sql
REM Author        : Craig Richards
REM Created       :
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Displays the last 5 extents at the end of the datafile

SELECT *
  FROM (
SELECT owner, segment_name, 
       segment_type, block_id
  FROM dba_extents
 WHERE file_id = 
   ( SELECT file_id
       FROM dba_data_files
      WHERE file_name = '&FILE_NAME' )
 ORDER BY block_id desc
       )
 WHERE rownum <= 5
;

REM End of Script
