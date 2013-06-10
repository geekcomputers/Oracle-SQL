REM Script Name		: proc_show_events.sql
REM Author				: Craig Richards
REM Created			: 11 April 2013 
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: Create a procedure you can call to show what events are set in the database, this is for sessions mainly, but if they are set in the database they will exist in all sessions

CREATE OR REPLACE PROCEDURE cr_show_events
AS
  event_level NUMBER;
BEGIN
  FOR i IN 10000..10999 LOOP
    sys.dbms_system.read_ev(i,event_level);
    IF (event_level > 0) THEN
      DBMS_OUTPUT.ENABLE(1000000);
      DBMS_OUTPUT.PUT_LINE('Event '||to_char(i)||' set at level '||
      TO_CHAR(event_level));
    END IF;
  END LOOP;
END;
/
