SELECT ABS(CHECKSUM(NEWID()) % 1000000)--for each row
SELECT CAST((RAND() * (899999) + 100000) as int) 
SELECT FLOOR(RAND()*1000000-1)
SELECT 100000 + (CONVERT(INT, CRYPT_GEN_RANDOM(3)) % 100000),
  100000 + (CONVERT(INT, RAND()*100000) % 100000),
  100000 + (ABS(CHECKSUM(NEWID())) % 100000);
