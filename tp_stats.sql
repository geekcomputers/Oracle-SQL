REM Script Name		: tp_stats.sql
REM Author				: Craig Richards
REM Created			: 17 January 2013 
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: 

REM Procedure to gather the statistics, this will be called via the DBMS_SCHEDULER

CREATE OR REPLACE PROCEDURE GATHER_RIMS_STALE_STATISTICS
AS
BEGIN
  dbms_stats.gather_schema_stats(ownname=>'RIMS',estimate_percent=>NULL,options=>'GATHER STALE',cascade=>TRUE);
END;
/

REM DBMS_SCHEDULER job to call the procedure
 
BEGIN
  dbms_scheduler.create_job
  (job_name=>'GATHER_STALE_RIMS_STATISTICS',
  repeat_interval => 'FREQ=DAILY; BYDAY=MON,TUE,WED,THU,FRI; BYHOUR=4; BYMINUTE=00',
  job_type=>'stored_procedure',
  job_action=>'sys.GATHER_RIMS_STALE_STATISTICS',
  enabled=>TRUE,
  comments=>'GATHER_RIMS_STALE_STATISTICS');
END;
/