# queries (adding more specifity)
```sql
select firstname,lastname, age
  from current_customers
  where age between 10 and 12
```

```sql
select firstname,lastname, age
  from current_customers
  where age = 34 or firstname like 'five'
```

```sql
select firstname,lastname, age
  from current_customers
  where NOT age = 34
```

```sql
select firstname,lastname, age
  from current_customers
  order by age asc
```

```sql
select firstname,lastname, age
  from current_customers
  order by age desc
```

## select count of a certain column

```sql
select count(firstname)
  from current_customers
```

## find how many customer from the same city (the count of customers coming from the same city) (similar to group-object in powershell)

```sql
select city, count(city)
  from current_customers
  group by city
```

## changing the heading of the columns with the `as` statement
```sql
select city, count(city) as 'number of customers'
  from current_customers
  group by city
```

## ordering by the number of customers new naming in descending order (note: that the square brackets are used for names with spaces)
```sql
select city, count(city) as 'number of customers'
  from current_customers
  group by city
  order by [number of customers] desc
```

## math
```sql
SELECT 2+2 as 'addition' , 4*5 as 'multiplication' , 20/2 as 'division' , 4-2 as 'subtraction'
```

## using the `having` clause (since the `where` clause doesn't work in aggregate queries (the queries that use `group by`))
```sql
select city, count(city)
  from current_customers
  group by city
  having count(city) != 2
```

## select top 3 everything from our table
```sql
select top 3 *
  from current_customers
```

## select top 50 perfect from our table
```sql
select top 50 percent *
  from current_customers
```

## select unique values from our table (preferred with just one column or else we wont get the unique cities)
```sql
select distinct city
  from current_customers
```

## union (this example works because the two columns are same the datatype + we are queries just one column up and down (it won't work if we are selecting two columns in the top query))
```sql
select firstname
  from current_customers

union

select lastname
  from current_customers
```

# functions: a list is found under DB > Programmability > Functions > System Functions

## function #1: data length -> the length of the data passed into the brackets
```sql
select DATALENGTH(firstname), firstname
  from current_customers
```

## function #2: lower and upper
```sql
select upper(firstname), firstname
  from current_customers
```

## function #3: max, min, sum and avg
```sql
select max(age)
  from current_customers
```

## insert statements
```sql
insert into current_customers (firstname, lastname, email, city, age)
  values ('denzel','washington','d.w@actors.com', 'LV' , 55),
  ('keanu','reeves','k.r@actors.com','CA',44)
```

## update statements
```sql
update current_customers
  set city = 'NYC'
  where email = 'one.two@num.com'
```

## delete statement
```sql
delete from current_customers
where firstname = 'one' and lastname = 'five'
```

## alter table: adding a column
```sql
alter table current_customers
add country varchar(max)
```

## alter table: changing column datatype
```sql
alter table current_customers
alter column country varchar(max)
```

## alter table: deleting a column
```sql
alter table current_customers
alter column country varchar(max)
```

## alter table: making a column not accept null data
```sql
alter table current_customers
alter column city varchar(max) NULL
```

## create table
```sql
create table customer_order (
  firstname varchar(max),
  lastname varchar(max),
  product varchar(max),
  price varchar(max)
)
```

## add a primary key to an existing table which didn't have one
```sql
alter table current_customers
add ID int IDENTITY(1,1) primary key
```

## create table with primary key (the way to go)
```sql
create table customer_order (
  id int IDENTITY(1,1) PRIMARY KEY,
  firstname varchar(max),
  lastname varchar(max),
  product varchar(max),
  price varchar(max)
)
```

## delete a table
```sql
drop table customer_order
```

## joining two tables together (we join `firstname` and `lastname` from the `current_customers` table **with** `product` and `price` from the `customer_order` table on the basis of the `ID` column which is a primary key (unique identifier))
```sql
select firstname, lastname, product, price
from current_customers
inner join customer_order ON current_customers.id = customer_order.id
```

## left, right joins (left join would get data from the current_customers table and join them to the data from the customer_order table even if there's no data for a row on the left table) (meaning: if a customer hasn't ordered anything, he would still show up in the results. but with the `product` and `price` fields as null)
```sql
select firstname, lastname, product, price
from current_customers
left join customer_order ON current_customers.id = customer_order.id
```

## full joins
```sql
select firstname, lastname, product, price
from current_customers
full join customer_order ON current_customers.id = customer_order.id
```

## creating and removing indeces
```sql
create index index_age
on current_customers (age)
```
```sql
drop index current_customers.index_age
```