REM Filename      : search_long.sql
REM Author        : Craig Richards
REM Created       : 15-March-2007
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Two Examples to search the long text field in DBA_VIEWS

PROMPT Edit the two pieces of code below to enable you to search  the long field in DBA_VIEWS
PROMPT
PROMPT In the example below enter the search text in lower case

REM SET SERVEROUTPUT ON SIZE 10000
REM DECLARE
REM CURSOR c_dbv IS
REM SELECT owner,view_name,text
REM FROM all_views;
REM txt VARCHAR(32000);
REM searchstring VARCHAR(100) := 'scott.emp';
REM BEGIN
REM FOR ct IN c_dbv LOOP
REM IF INSTR(LOWER(ct.text), LOWER(searchstring)) > 0 THEN
REM DBMS_OUTPUT.PUT_LINE(ct.owner||'.'||ct.view_name);
REM END IF;
REM END LOOP;
REM END;
REM / 
 

REM SET SERVEROUTPUT ON 
REM 
REM BEGIN
REM FOR x IN (SELECT * FROM dba_views ) LOOP
REM        IF ( x.view_text LIKE '%customer_address%' ) THEN
REM           DBMS_OUTPUT.PUT_LINE( x.view_name );
REM        END IF;
REM   END LOOP;
REM END;
REM /

PROMPT The above sample will work as long as the view text is 32k or less. 

REM End of Script
