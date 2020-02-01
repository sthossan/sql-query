-- example : EXEC SP_PROCOPTION @ProcName = ['stored procedure name'], @OptionName = 'STARTUP', @OptionValue = [on|off]
-- Now let's turn the auto-execution off. Once set off, the procedure will not run the next time SQL Server starts.
EXEC SP_PROCOPTION LOG_SERVER_START, 'STARTUP', 'OFF'
