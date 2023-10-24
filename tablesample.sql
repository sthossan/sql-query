The tablesample returns a random number every time as the seed used to generate the random number varies marginally everytime, 
eventhough we say tablesample(10 percent) it will reutrn +1000 or -1000 rows approximatly,

example : 

1. select * from results TABLESAMPLE SYSTEM(100 ROWS)
2. select * from results TABLESAMPLE SYSTEM(10 PERCENT)

3. select * from results TABLESAMPLE (10 ROWS)
4. select * from results TABLESAMPLE (10 PERCENT)

The number of rows will vary everytime. To get a constant number of rows everytime we can use the keyword REPEATABLE.

select * from results TABLESAMPLE SYSTEM(10 PERCENT) REPEATABLE(1000).

Given the same seed, you will get the same rows back. One thing to note here: this is not like the

repeatable read isolation level. If another user makes changes to the data in the table, you will not get back the exact same rows. It is only true for a given “version” of the table.
