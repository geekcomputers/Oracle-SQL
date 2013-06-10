REM Script Name		: tp_datamgt_bonds.sql
REM Author				: Craig Richards
REM Created			: 20 May 2013 
REM Last Modified	:
REM Version				: 1.0
REM
REM Modifications		:
REM
REM Description		: This procedure updates data

CREATE OR REPLACE PROCEDURE tp_datamgt_bonds
AUTHID CURRENT_USER
AS

--Variable Declaration

num_rows		NUMBER;
v_From			VARCHAR2(80) := 'From@mail.com';
v_Recipient	VARCHAR2(80) := 'To@mail.com';
v_Subject		VARCHAR2(80) := 'Your Update Statement';
v_Mail_Host	VARCHAR2(30) := 'mailhost';
v_Mail_Conn	UTL_SMTP.Connection;
CRLF        	VARCHAR2(2)  := CHR(13)||CHR(10);

BEGIN

-- Update SQL Statement

  UPDATE table
  SET active_flag = 'N'
  WHERE a=b;
  
  num_rows := SQL%ROWCOUNT;

-- Send an email with the amount of rows that have been updated

  v_Mail_Conn := UTL_SMTP.Open_Connection(v_Mail_Host, 25);
  UTL_SMTP.Helo(v_Mail_Conn, v_Mail_Host);
  UTL_SMTP.Mail(v_Mail_Conn, v_From);
  UTL_SMTP.Rcpt(v_Mail_Conn, v_Recipient);
  UTL_SMTP.Data(v_Mail_Conn,'Date: '   || to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') || CRLF ||
  'From: '   || v_From || CRLF ||
  'Subject: '|| v_Subject || CRLF ||
  'To: '     || v_Recipient || CRLF ||CRLF ||'Procedure Ran and there were ' || num_rows || ' rows updated '|| CRLF || CRLF || 'Regards' ||CRLF ||'DBA Team');

-- Exception Code

EXCEPTION
WHEN UTL_SMTP.Transient_Error OR UTL_SMTP.Permanent_Error THEN
  RAISE_APPLICATION_ERROR(-20000, 'Unable to send mail: '||SQLERRM);
  DBMS_OUTPUT.PUT_LINE (num_rows || ' Rows Updated');
END;
/
