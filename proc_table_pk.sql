REM Script Name		: proc_table_pk.sql 
REM Author		: Craig Richards
REM Created		: 16th November 2012
REM Last Modified	:
REM Version		: 1.0
REM
REM Modifications	:
REM
REM Description		: Create a procedure you can call to check the primary key for a table name passed in

CREATE OR REPLACE PROCEDURE table_pk (p_tab VARCHAR2)
AUTHID CURRENT_USER
AS

-- Variable Declaration

  LV_TABLE_NAME dba_cons_columns.table_name%TYPE;
  LV_CONSTRAINT_NAME dba_cons_columns.constraint_name%TYPE;
  LV_COLUMN_NAME dba_cons_columns.column_name%TYPE;
  LV_POSITION dba_cons_columns.position%TYPE;
  LV_STATUS dba_constraints.status%TYPE;

-- Create the cursor

  CURSOR c_tab_pk IS
  SELECT dbcc.table_name,dbcc.constraint_name,dbcc.column_name,dbcc.position,dbc.status
  FROM   dba_cons_columns dbcc, dba_constraints dbc
  WHERE  dbcc.constraint_name = dbc.constraint_name
  AND    dbcc.table_name      = dbc.table_name
  AND    dbc.constraint_TYPE  = 'P'
  AND    dbc.table_name       = UPPER(p_tab);
  
  -- Output the information
  
  BEGIN
    OPEN c_tab_pk;
    LOOP
      FETCH c_tab_pk INTO LV_TABLE_NAME, LV_CONSTRAINT_NAME, LV_COLUMN_NAME, LV_POSITION, LV_STATUS;
      EXIT WHEN c_tab_pk%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(lv_table_name||CHR(9)||lv_constraint_name||CHR(9)||lv_column_name||CHR(9)||lv_position||CHR(9)||lv_status);
    END LOOP;
    CLOSE c_tab_pk;
  END table_pk;
/
