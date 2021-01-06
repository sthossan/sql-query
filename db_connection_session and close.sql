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


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT
     sdes.session_id
    ,sdes.login_time
    ,sdes.last_request_start_time
    ,sdes.last_request_end_time
    ,sdes.is_user_process
    ,sdes.host_name
    ,sdes.program_name
    ,sdes.login_name
    ,sdes.status
    ,sdec.num_reads
    ,sdec.num_writes
    ,sdec.last_read
    ,sdec.last_write
    ,sdes.reads
    ,sdes.logical_reads
    ,sdes.writes
    ,sdest.DatabaseName
    ,sdest.ObjName
    ,sdes.client_interface_name
    ,sdes.nt_domain
    ,sdes.nt_user_name
    ,sdec.client_net_address
    ,sdec.local_net_address
    ,sdest.Query
    ,KillCommand  = 'Kill '+ CAST(sdes.session_id  AS VARCHAR)
FROM sys.dm_exec_sessions AS sdes
INNER JOIN sys.dm_exec_connections AS sdec ON sdec.session_id = sdes.session_id
CROSS APPLY (
    SELECT DB_NAME(dbid) AS DatabaseName
        ,OBJECT_NAME(objectid) AS ObjName
        ,COALESCE((SELECT TEXT AS [processing-instruction(definition)]
					FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)
					FOR XML PATH(''), TYPE), '') AS Query
    FROM sys.dm_exec_sql_text(sdec.most_recent_sql_handle)
) sdest
WHERE sdes.session_id <> @@SPID AND sdest.DatabaseName ='Lollipop'
ORDER BY sdes.last_request_start_time DESC

