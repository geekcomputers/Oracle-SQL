REM Filename      : proc_datafiles.sql
REM Author        : Craig Richards
REM Created       : 19th December 2012
REM Version       : 1.0
REM Modifications :
REM

REM Instructions  : Show all the datafiles and there sizes for the given tablespace name

CREATE OR REPLACE PROCEDURE cr_datafiles (inp_tblspc VARCHAR2:=NULL)
AUTHID CURRENT_USER
AS

-- Define Exception

  ERROR exception;

-- Variable Declaration

  lv_file_name sys.dba_data_files.file_name%TYPE;
  lv_bytes sys.dba_data_files.bytes%TYPE;

-- Create the cursors

  CURSOR c_files IS
  SELECT rpad(file_name,50,' '), bytes
  FROM sys.dba_data_files
  WHERE UPPER(tablespace_name) = UPPER(inp_tblspc)
  ORDER BY bytes;

-- Output the Information

  BEGIN

  -- If the parameter passed is blank, or nothing is passed in the raise the error

    IF inp_tblspc IS NULL OR NVL(LENGTH(TRIM(inp_tblspc)),0)=0 THEN RAISE ERROR;
    ELSE 
      OPEN c_files;
      DBMS_OUTPUT.PUT_LINE(CHR(10));
      DBMS_OUTPUT.PUT_LINE('Datafiles for : ' || inp_tblspc);
      DBMS_OUTPUT.PUT_LINE(CHR(10));
      DBMS_OUTPUT.PUT_LINE('FILENAME' || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || 'BYTES' );
      DBMS_OUTPUT.PUT_LINE('--------' || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '-----' );
      LOOP
        FETCH c_files INTO lv_file_name, lv_bytes;
        EXIT WHEN c_files%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(lv_file_name|| CHR(9) || CHR(9) || lv_bytes);
      END LOOP;
      CLOSE c_files;
    END IF;

-- Exception

    EXCEPTION
      WHEN ERROR THEN 
        DBMS_OUTPUT.PUT_LINE (CHR(10) || 'ORA-77777 : You need to pass a tablespace');
        DBMS_OUTPUT.PUT_LINE ('ie exec cr_datafiles(''EBOND1'');'); 
END cr_datafiles;
/
SHOW ERROR

