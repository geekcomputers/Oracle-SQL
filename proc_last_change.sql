REM Filename      : proc_last_change.sql
REM Author        : Craig Richards
REM Created       : 14-Feburary-2012
REM Version       : 1.0
REM Modifications : 
REM
REM Description   : Creates two procedures which shows you the last time a password was changed.
REM                 The First last_change_all, when called will show you all the users with the last date
REM                 The next last_change, when called you pass the user and it displays the details for that user

REM Instructions  : For last_change call it by exec last_change('username')

CREATE OR REPLACE PROCEDURE last_change_all
AUTHID CURRENT_USER
AS

-- Variable Declaration

  lv_user sys.user$.user#%TYPE;
  lv_name sys.user$.name%TYPE;
  lv_ptime sys.user$.ptime%TYPE;

-- Create the cursor

  CURSOR c_user IS
  SELECT user#, RPAD(name,24,' '), ptime FROM sys.user$ WHERE ptime IS NOT NULL;

-- Output the Information

  BEGIN
    OPEN c_user;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('This displays the usernames and the date the password was last changed');
    DBMS_OUTPUT.PUT_LINE('======================================================================');
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('USERNAME' || CHR(9) || CHR(9) || 'LAST CHANGED');
    DBMS_OUTPUT.PUT_LINE('========' || CHR(9) || CHR(9) || '============');
    LOOP
      FETCH c_user INTO lv_user, lv_name, lv_ptime;
      EXIT WHEN c_user%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(lv_name || lv_ptime);
    END LOOP;
    CLOSE c_user;
END last_change_all;
/

SHOW ERROR

CREATE OR REPLACE PROCEDURE last_change (inp_user VARCHAR2)
AUTHID CURRENT_USER
AS

-- Variable Declaration

  lv_user sys.user$.user#%TYPE;
  lv_name sys.user$.name%TYPE;
  lv_ptime sys.user$.ptime%TYPE;

-- Create the CURSOR

  CURSOR c_user IS
  SELECT user#, name, ptime FROM sys.user$ WHERE UPPER(name) = UPPER(inp_user);

-- Output the Information

  BEGIN
    OPEN c_user;
    LOOP
      FETCH c_user INTO lv_user, lv_name, lv_ptime;
      EXIT WHEN c_user%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(CHR(10));
      DBMS_OUTPUT.PUT_LINE('Last change for ' || inp_user || ' was ' || lv_ptime);
    END LOOP;
    CLOSE c_user;
END last_change;
/
