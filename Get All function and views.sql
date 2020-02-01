SELECT OBJECT_DEFINITION(OBJECT_ID)
FROM sys.objects WHERE TYPE_DESc in ('SQL_SCALAR_FUNCTION'
									, 'SQL_STORED_PROCEDURE'
									, 'SQL_TABLE_VALUED_FUNCTION'
									, 'SQL_TRIGGER'
									, 'VIEW')