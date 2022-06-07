

-- remove only the 9 from the start.
-- Sample :
-- 9073456789101
-- +773456789101
-- 0773456789101
UPDATE TableName SET number = STUFF(number,1,1,'') WHERE number LIKE '9%'