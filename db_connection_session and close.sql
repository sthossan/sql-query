--------------------Check Db Connection
SELECT s.*   
FROM sys.dm_exec_sessions AS s  
WHERE EXISTS(SELECT * FROM sys.dm_tran_session_transactions AS t WHERE t.session_id = s.session_id )
AND NOT EXISTS ( SELECT * FROM sys.dm_exec_requests AS r WHERE r.session_id = s.session_id);

---------------------Db Session
SELECT db_name(database_id), * FROM sys.dm_exec_sessions where database_id=7
--db_name(database_id)='ODYSSEYEMP'
order by db_name(database_id) , login_time
SELECT DB_ID(N'DB_Name') AS [Database ID]; 

-- For MS SQL Server 2012 and above

USE [master];

DECLARE @kill varchar(8000) = '';
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'
FROM sys.dm_exec_sessions WHERE database_id = db_id('MyDB')

EXEC(@kill);


-- For MS SQL Server 2000, 2005, 2008

USE master;

DECLARE @kill varchar(8000); SET @kill = '';
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), spid) + ';'
FROM master..sysprocesses WHERE dbid = db_id('MyDB')

EXEC(@kill);
