REM Script Name		: tp_open_cursors.sql
REM Author				: Craig Richards
REM Created			: 27 September 2013 
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: Shows the open cursors and the maximum number of cursors

CREATE OR REPLACE PROCEDURE tp_open_cursors
AS

-- Variable Declaration

  lv_highest sys.v$sesstat.value%TYPE;
  lv_max sys.v$parameter.value%TYPE;
  lv_percentage NUMBER;
  
-- Create the cursors

  CURSOR c_open_cursor IS
  SELECT       MAX(a.value) AS highest_open_cursor, p.value AS max_open_cursor
  FROM          v$sesstat a, v$statname b, v$parameter p
  WHERE       a.statistic# = b.statistic#
  AND            b.name = 'opened cursors current' AND p.name= 'open_cursors'
  GROUP BY p.value;

-- Output the Information

  BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10)||'Open ' || CHR(9) || 'Max Cursors');
    DBMS_OUTPUT.PUT_LINE('==== ' || CHR(9) || '===========');
    OPEN c_open_cursor;
    LOOP
      FETCH c_open_cursor into lv_highest,lv_max;
      EXIT WHEN c_open_cursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(lv_highest||CHR(9)||lv_max);
    END LOOP;
    CLOSE c_open_cursor;
    lv_percentage := (lv_highest / lv_max *100);
    DBMS_OUTPUT.PUT_LINE (CHR(10) || 'You are using ' || TRUNC(lv_percentage,2) || '% of the open_cursors parameter');
END tp_open_cursors;
/
