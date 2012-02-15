REM Filename      : proc_sessions.sql
REM Author        : Craig Richards
REM Created       : 15-Feburary-2012
REM Version       : 1.0
REM Modifications : 
REM
REM Description   : Creates two procedures which shows you the last time a password was changed.
REM                 The First last_change_all, when called will show you all the users with the last date
REM                 The next last_change, when called you pass the user and it displays the details for that user

REM Instructions  : For last_change call it by exec last_change('username')

CREATE OR REPLACE PROCEDURE sessions (inp_user VARCHAR2)
AUTHID CURRENT_USER
AS

-- Variable Declaration

  lv_username sys.v$session.username%TYPE;
  lv_sid sys.v$session.sid%TYPE;
  lv_serial# sys.v$session.serial#%TYPE;
  lv_status sys.v$session.status%TYPE;
  lv_active_count NUMBER;
  lv_inactive_count NUMBER;

-- Create the cursors

  CURSOR c_active IS
  SELECT username, sid, serial#, status 
  FROM sys.V$session 
  WHERE UPPER(USERNAME) = UPPER(inp_user) 
  AND status = 'ACTIVE';

  CURSOR c_inactive IS
  SELECT RPAD(username,24,' '), sid, serial#, status 
  FROM sys.V$session 
  WHERE UPPER(USERNAME) = UPPER(inp_user) 
  AND status != 'ACTIVE';

  CURSOR c_active_count IS
  select count(*) from v$session where status = 'ACTIVE'
  and UPPER(USERNAME) = UPPER(inp_user);

  CURSOR c_inactive_count IS
  select count(*) from v$session where status != 'ACTIVE'
  and UPPER(USERNAME) = UPPER(inp_user);

-- Output the Information

  BEGIN
    DBMS_OUTPUT.PUT_LINE('Session Counts :');
    DBMS_OUTPUT.PUT_LINE('================');
    OPEN c_active_count;
    LOOP
      FETCH c_active_count INTO lv_active_count;
      EXIT WHEN c_active_count%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(inp_user || ' has ' || lv_active_count || ' active sessions');
    END LOOP;
    CLOSE c_active_count;

    OPEN c_inactive_count;
    LOOP
      FETCH c_inactive_count INTO lv_inactive_count;
      EXIT WHEN c_inactive_count%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(inp_user || ' has ' || lv_inactive_count || ' inactive sessions');
    END LOOP;
    CLOSE c_inactive_count;

    OPEN c_active;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Active Session Information for : ' || inp_user);
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('USERNAME' || CHR(9) || 'SID' || CHR(9) || 'SERIAL#' || CHR(9) || 'STATUS');
    LOOP
      FETCH c_active INTO lv_username , lv_sid, lv_serial#, lv_status;
      EXIT WHEN c_active%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(lv_username || CHR(9) || CHR(9) || lv_sid || CHR(9) || lv_serial# || CHR(9) || lv_status);
    END LOOP;
    CLOSE c_active;

    OPEN c_inactive;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('Inactive Session Information for : ' || inp_user);
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('USERNAME' || CHR(9) || 'SID' || CHR(9) || 'SERIAL#' || CHR(9) || 'STATUS');
    LOOP
      FETCH c_inactive INTO lv_username , lv_sid, lv_serial#, lv_status;
      EXIT WHEN c_inactive%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(lv_username || CHR(9) || CHR(9) || lv_sid || CHR(9) || lv_serial# || CHR(9) || lv_status);
    END LOOP;
    CLOSE c_inactive;
END sessions;
/
SHOW ERROR
