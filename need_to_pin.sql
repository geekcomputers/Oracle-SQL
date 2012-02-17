REM Filename      : need_to_pin.sql
REM Author        : Craig Richards
REM Created       : 02-April-2009
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Shows if certain objects could be pinned to improve performance

SET LINES 200
SET PAGES 100

SELECT   SUBSTR(owner,1,10) Owner, SUBSTR(type,1,12) Type, SUBSTR(name,1,30) Name,
         executions, sharable_mem Mem_used, SUBSTR(kept||' ',1,4) "Kept?"
FROM     v$db_object_cache
WHERE    type IN ('TRIGGER','PROCEDURE','PACKAGE BODY','PACKAGE')
ORDER BY executions DESC;

REM End of Script
