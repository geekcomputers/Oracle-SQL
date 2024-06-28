REM Script Name		: ascii.sql
REM Author			: Craig Richards
REM Created			: 06-February-2008
REM Last Modified	:
REM Version			: 1.0
REM
REM Modifications 	:
REM
REM Description		: Shows the ASCII chart

SET SERVEROUTPUT ON SIZE 10240

DECLARE
   i NUMBER;
   j NUMBER;
   k NUMBER;
BEGIN
   FOR i IN 2..15 LOOP
       FOR j IN 1..16 LOOP
           k:=i*16+j;
           DBMS_OUTPUT.PUT((to_char(k,'000'))||':'||chr(k)||'  ');
           IF k mod 8 = 0 THEN
              DBMS_OUTPUT.PUT_LINE('');
           END IF;
       END LOOP;
   END LOOP;
END;
/

SHOW ERRORS
-- commit
--show errors

REM End of Script
