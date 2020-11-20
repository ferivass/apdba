set verify off
set feedback off
prompt '		*****************'
prompt '		*Meniu principal*'
prompt '		*****************'
prompt 
prompt Choose an option below:
prompt +++++++++++++++++++++++
prompt 1)		Active sessions(dba_act_sess.sql)
prompt 2)		blocking session(dba_blocking_sess.sql)
prompt 3)		connected session(dba_sess.sql)
prompt 4)		long operation sess(dba_long_sess.sql)

prompt 100) quit
prompt +++++++++++++++++++++++

accept Vchoice number PROMPT 'Choice: '

var bchoice number;
var bfilename varchar2(32);

column FileToRun new_value FileToRun noprint;

begin
	:bchoice := &vchoice;
	if
		:bchoice = 1 then
			:bfilename := 'dba_act_sess.sql';
	elsif
		:bchoice = 2 then
			:bfilename := 'dba_blocking_sess.sql';
	elsif
		:bchoice = 3 then
			:bfilename := 'dba_sess.sql';
	elsif
		:bchoice = 4 then
			:bfilename := 'dba_long_sess.sql';
	elsif
		:bchoice = 100 then
			:bfilename := 'exit.sql';				
	else
			:bfilename := 'dbamenu.sql';				
	end if;
end;
/
 
select :bfilename  FileToRun from dual;

@@&&FileToRun;


