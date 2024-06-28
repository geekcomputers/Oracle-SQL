REM Filename      : test_table.sql
REM Author        : Craig Richards
REM Created       : 18-Mar-2009
REM Version       : 1.0
REM Modifications :
REM
REM Description   : 创建一个测试表并插入1000行数据

CREATE OR REPLACE PROCEDURE test_table
AS

-- 变量声明
lv_count NUMBER;
lv_one   VARCHAR2(30) :='TESTONE'; -- 定义第一个测试字符串
lv_two   VARCHAR2(30) :='TESTTWO'; -- 定义第二个测试字符串
lv_three VARCHAR2(30) :='TESTTHREE'; -- 定义第三个测试字符串
lv_four  VARCHAR2(30) :='TESTFOUR'; -- 定义第四个测试字符串
lv_five  varchar2(30):='testfive';

BEGIN
  -- 删除已存在的测试表
  EXECUTE IMMEDIATE('drop table test');
  -- 创建测试表
  EXECUTE IMMEDIATE('Create table test(test1 varchar2(30), test2 varchar2(30), test3 varchar2(30), test4 varchar2(30)，test5 varchar2(30)) tablespace tools');
  -- 循环插入1000行数据
  FOR i in 1..1000 LOOP
    insert into test (test1,test2,test3,test4,test5) values (lv_one,lv_two,lv_three,lv_four,lv_five);
  END LOOP;
END;
/

REM End of Script
