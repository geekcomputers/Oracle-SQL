REM Filename      : client_info.sql
REM Author        : Craig Richards
REM Created       : 
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Shows the client connections within the oracle database

COLUMN username FORMAT A15 WORD_WRAPPED
COLUMN module FORMAT A15 WORD_WRAPPED
COLUMN action FORMAT A15 WORD_WRAPPED
COLUMN client_info FORMAT A30 WORD_WRAPPED

SELECT username||'('||sid||','||serial#||')' username, module, action, client_info
FROM v$session
WHERE module||action||client_info IS NOT NULL;

REM End of Script
