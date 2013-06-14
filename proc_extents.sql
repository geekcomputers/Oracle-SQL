REM Script Name		: proc_extents.sql
REM Author				: Craig Richards
REM Created			: 16-Mar-2009
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications 	:
REM
REM Description		: Creates a procedure which shows the largest available extent for each tablespace

CREATE OR REPLACE PROCEDURE extents
AUTHID CURRENT_USER
AS

-- Variable Declaration

    LV_TABLESPACE_NAME dba_free_space.tablespace_name%TYPE;
    LV_BYTES dba_free_space.bytes%TYPE;

-- Create the cursor

    CURSOR c_extent IS
    SELECT rpad(tablespace_name,15,' '), MAX(bytes)
    FROM dba_free_space
    GROUP BY tablespace_name
    UNION
    SELECT rpad(tablespace_name,15,' '), MAX(bytes)
    FROM dba_temp_files
    GROUP BY tablespace_name;

-- Output the information

    BEGIN
      DBMS_OUTPUT.PUT_LINE('Tablespace Name'||CHR(9)||CHR(9) ||'Bytes');
      DBMS_OUTPUT.PUT_LINE('==============='||CHR(9)||CHR(9) ||'=====');
      OPEN c_extent;
      LOOP
        FETCH c_extent INTO LV_TABLESPACE_NAME,LV_BYTES;
        EXIT WHEN c_extent%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(LV_TABLESPACE_NAME||CHR(9)||CHR(9) ||LV_BYTES);
      END LOOP;
      CLOSE c_extent;

  END extents;
/

REM End of Script
