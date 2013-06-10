REM Script Name		: show_events.sql
REM Author				: Craig Richards
REM Created			: 11 April 2013 
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: Shows what events are set in the database, this is for sessions mainly, but if they are set in the database they will exist in all sessions

SET SERVEROUTPUT ON;

DECLARE
  event_level NUMBER;
BEGIN
  FOR i IN 10000..10999 LOOP
    sys.dbms_system.read_ev(i,event_level);
    IF (event_level > 0) THEN
      DBMS_OUTPUT.PUT_LINE('Event '||to_char(i)||' set at level '||
      TO_CHAR(event_level));
    END IF;
  END LOOP;
END;
/
