---------------1.---------------
BACKUP DATABASE AdventureWorks2014
TO DISK = 'D:\AdventureWorks2014.Bak'
   WITH FORMAT,
      MEDIANAME = 'Z_SQLServerBackups',
      NAME = 'Full Backup of AdventureWorks2014';
GO

---------------2.---------------
BACKUP DATABASE samplecom
TO DISK = 'E:\BackupDb.bak'
WITH INIT, STATS =10;

RESTORE DATABASE [new_samplecom] 
FILE = N'www_sample_com'
FROM DISK = N'E:\BackupDb.bak'
WITH  FILE = 1, NOUNLOAD, STATS = 10,
MOVE N'www_sample_com' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\new_samplecom.mdf',
MOVE N'www_sample_com_log' TO  'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\new_samplecom_log.ldf'

RESTORE FILELISTONLY 
FROM DISK = 'D:\BackupDb.bak'

SELECT file_id, NAME AS [logical_file_name],physical_name
FROM sys.database_files

USE [master];
ALTER DATABASE [Manvendra] MODIFY FILE ( NAME = Manvendra, NEWNAME = Manvendra_Data );
