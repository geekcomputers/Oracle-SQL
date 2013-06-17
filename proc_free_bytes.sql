REM Filename      : proc_free_bytes.sql
REM Author        : Craig Richards
REM Created       : 19th December 2012
REM Version       : 1.0
REM Modifications :
REM

REM Instructions  : Show all the free bytes in the given tablespace

CREATE OR REPLACE PROCEDURE cr_free_bytes (inp_tblspc VARCHAR2:=NULL)
AUTHID CURRENT_USER
AS

-- Define Exception

  ERROR EXCEPTION;

-- Variable Declaration

  lv_bytes sys.dba_free_space.bytes%TYPE;

-- Create the cursors

  CURSOR c_free IS
  SELECT bytes
  FROM sys.dba_free_space
  WHERE UPPER(tablespace_name) = UPPER(inp_tblspc)
  ORDER BY bytes;

-- Output the Information

  BEGIN

  -- If the parameter passed is blank, or nothing is passed in the raise the error

    IF inp_tblspc IS NULL OR NVL(LENGTH(TRIM(inp_tblspc)),0)=0 THEN RAISE ERROR;
    ELSE
      OPEN c_free;
      DBMS_OUTPUT.PUT_LINE(CHR(10));
      DBMS_OUTPUT.PUT_LINE('Tablespace : ' || inp_tblspc);
      DBMS_OUTPUT.PUT_LINE(CHR(10));
      DBMS_OUTPUT.PUT_LINE('BYTES' );
      DBMS_OUTPUT.PUT_LINE('=====' );
      LOOP
        FETCH c_free INTO lv_bytes;
        EXIT WHEN c_free%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(lv_bytes);
      END LOOP;
      CLOSE c_free;
    END IF;

--  Exception

    EXCEPTION
      WHEN ERROR THEN
        DBMS_OUTPUT.PUT_LINE (CHR(10) || 'ORA-77777 : You need to pass a tablespace');
        DBMS_OUTPUT.PUT_LINE ('ie exec cr_datafile(''EBOND1'');');
END cr_free_bytes;
/
SHOW ERROR

