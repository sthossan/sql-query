update dbo.test set Col1 = 1 - Col1;
UPDATE dbo.test SET col2 = ~col2;--if bool
update test set Col1=case when Col1='1' then '0' else '1' end
UPDATE dbo.test SET Col1 = (Col1 ^ 1); --all command are working
