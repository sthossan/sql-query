SELECT c1.TABLE_SCHEMA, c1.TABLE_NAME, c1.COLUMN_NAME, c1.ORDINAL_POSITION,	c1.DATA_TYPE, c1.CHARACTER_MAXIMUM_LENGTH, c1.IS_NULLABLE, c1.COLUMN_DEFAULT
FROM DB_1.INFORMATION_SCHEMA.COLUMNS c1 --This database table field not exist in second database
WHERE NOT EXISTS(SELECT * FROM DB_1.INFORMATION_SCHEMA.COLUMNS c2 WHERE c1.TABLE_NAME=c2.TABLE_NAME AND c1.COLUMN_NAME=c2.COLUMN_NAME)
--AND c1.TABLE_NAME='TABLE_NAME'
