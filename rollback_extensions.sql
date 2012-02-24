REM Filename      : rollback_extensions.sql
REM Author        : Craig Richards
REM Created       :
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Shows roll back segment extensions to show if they are sized correctly

SET PAUSE OFF
SET FEEDBACK OFF

COLUMN name FORMAT A20

SELECT	name, optsize, shrinks, aveshrink, extends,wraps
FROM 	v$rollstat, v$rollname
WHERE 	v$rollstat.usn=v$rollname.usn;

REM End of Script
