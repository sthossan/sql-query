-- @backupFilePath = D:\BackupDb.bak
-- @sqlServerPath = C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\

CREATE PROCEDURE [dbo].[sp_RestoreDb_below_ssms2016]
	@DBName VARCHAR(100),
	@backupFilePath VARCHAR(2000),
	@sqlServerPath VARCHAR(MAX)
AS
BEGIN TRY
	DECLARE @sqlQuery VARCHAR(MAX), @hasFileExists BIT
	SET @hasFileExists = (SELECT dbo.fn_FileExists(@backupFilePath)) ----------------from fn_FileExists.sql
	IF @hasFileExists = 1
		BEGIN
			SET @sqlQuery = N'USE [MASTER];
							RESTORE DATABASE [' + @DBName + '] 
							FILE = N''BackupDb''
							FROM DISK = N''' + @backupFilePath + '''
							WITH  FILE = 1, NOUNLOAD, STATS = 10,
							MOVE N''BackupDb'' TO ''' + @sqlServerPath + @DBName + '.mdf' + ''',
							MOVE N''BackupDb_log'' TO  ''' + @sqlServerPath + @DBName + '_log.ldf' + '''
						  '
Exec (@sqlQuery);
SET @sqlQuery = N'USE [MASTER];
				ALTER DATABASE [' + @DBName + '] MODIFY FILE ( NAME = BackupDb, NEWNAME = ' + @DBName + ' );'

			--SELECT file_id, NAME AS [logical_file_name], physical_name
			--FROM sys.database_files
			Exec (@sqlQuery);
		END
	ELSE
		BEGIN
			RAISERROR( N'%s cannot found.', -- Message text
				11, -- severity
				1, -- state
				@backupFilePath -- first argument to the message text
				);
		END

END TRY
BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX), @ErrorSeverity VARCHAR(MAX), @ErrorState VARCHAR(MAX)
    SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    --BREAK
END CATCH
GO
