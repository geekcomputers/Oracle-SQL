REM Script Name		: user_privs.sql  
REM Author				: Craig Richards
REM Created			: 20 May 2013 
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: This code show all privileges for a given user or users, if you pass multiple users you need to do it like USER1','USER2','USER3 etc

SET PAGESIZE 200
SET LINESIZE 200
SET VERIFY OFF

COLUMN granted_by_role FORMAT a20
COLUMN obj_owner FORMAT a15

UNDEFINE Users;

SELECT a.grantee, b.privilege, a.granted_role AS GRANTED_BY_ROLE, NULL AS OBJECT, NULL AS OBJ_OWNER
FROM dba_role_privs a
JOIN dba_sys_privs b
ON a.granted_role=b.grantee
WHERE a.grantee IN ('&&Users')
UNION
SELECT grantee, privilege, 'n/a', NULL, NULL
FROM dba_sys_privs
WHERE grantee IN ('&&Users')
UNION
SELECT grantee, privilege, ' ', table_name, owner
FROM DBA_TAB_PRIVS
WHERE grantee IN ('&&Users')
UNION
SELECT username, 'QUOTA', DECODE(max_bytes, -1, 'unlimited', max_bytes/1024/1024) MAX_MB, 'TABLESPACE: ' || tablespace_name, NULL
FROM DBA_TS_QUOTAS
WHERE username IN ('&&Users')
ORDER BY grantee, privilege;

SELECT grantee,granted_role,admin_option FROM dba_role_privs WHERE grantee IN ('&&Users');

