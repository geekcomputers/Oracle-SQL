REM Filename      : test_table.sql
REM Author        : Craig Richards
REM Created       : 18-Mar-2009
REM Version       : 1.0
REM Modifications :
REM
REM Description   : Creates a test table and inserts 1000 rows

CREATE OR REPLACE PROCEDURE test_table
AS

-- Variable Declaration

lv_count NUMBER;
lv_one   VARCHAR2(30) :='TESTONE';
lv_two   VARCHAR2(30) :='TESTTWO';
lv_three VARCHAR2(30) :='TESTTHREE';
lv_four  VARCHAR2(30) :='TESTFOUR';

BEGIN
  EXECUTE IMMEDIATE('drop table test');
  EXECUTE IMMEDIATE('Create table test(test1 varchar2(30), test2 varchar2(30), test3 varchar2(30), test4 varchar2(30)) tablespace tools');
  FOR i in 1..1000 LOOP
    insert into test (test1,test2,test3,test4) values (lv_one,lv_two,lv_three,lv_four);
  END LOOP;
END;
/

REM End of Script
