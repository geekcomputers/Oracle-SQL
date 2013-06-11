REM Script Name		: rebuild_indexes.sql  
REM Author			: Craig Richards
REM Created			: 20 May 2013 
REM Last Modified	:
REM Version			: 1.0
REM
REM Modifications	:
REM
REM Description		: This procedure generates and runs the codes to rebuild the indexes for a given table

CREATE OR REPLACE PROCEDURE rebuild_indexes (p_owner IN VARCHAR2:=NULL, p_table_name IN VARCHAR2:=NULL, p_tblspc IN VARCHAR2:=NULL)
AS

-- Variable Declaration

ERROR EXCEPTION;
rebuild_indexes VARCHAR2(2000);

BEGIN 

-- Check the inputs exist 

  IF p_owner IS NULL OR NVL(length(trim(p_owner)),0)=0 THEN raise error;
    ELSIF p_table_name IS NULL OR NVL(length(trim(p_table_name)),0)=0 THEN raise error;
    ELSIF p_tblspc IS NULL OR NVL(length(trim(p_tblspc)),0)=0 THEN raise error;
  END IF;

-- Check the Tablespace 

  IF p_tblspc = 'REORG' THEN
    tp_resize_reorg(2000);
  END IF;

  DBMS_OUTPUT.PUT_LINE(' The Commands that were executed wereis :' || CHR(10));

  FOR indexes_to_rebuild IN
    (SELECT index_name FROM dba_indexes WHERE owner = p_owner AND table_name = p_table_name)
    LOOP
      rebuild_indexes := 'ALTER INDEX ' ||p_owner||'.'||indexes_to_rebuild.index_name|| ' rebuild tablespace '|| p_tblspc;
      DBMS_OUTPUT.PUT_LINE(rebuild_indexes);
      EXECUTE IMMEDIATE rebuild_indexes;
    END LOOP;

  EXCEPTION
    WHEN error THEN
    DBMS_OUTPUT.PUT_LINE (CHR(10) || 'ORA-77777 : You need to pass the OWNER, TABLE NAME, TABLESPACE TO REBUILD TO');
    DBMS_OUTPUT.PUT_LINE ('ie exec tp_rebuild_indexes(''SCOTT'',''EMP'',''REORG'');');
END tp_rebuild_indexes;
/


