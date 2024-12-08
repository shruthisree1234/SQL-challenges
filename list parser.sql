/*
                                         
Santa's Gift List Parser
Beginner

Santa's workshop is modernizing! Gone are the days of paper wish lists and manual sorting. The elves have implemented a new digital system to handle the millions of Christmas wishes they receive. However, Santa needs a way to quickly understand what each child wants and how to optimize workshop operations.

The challenge: Create a report that helps Santa and the elves understand:

Each child's primary and backup gift choices
Their color preferences
How complex each gift is to make
Which workshop department should handle the creation
"Ho ho ho!" Santa chuckled, reviewing the new database. "This will help us work much more efficiently! But we need a query to make sense of all this data."

Unfortunately the elves stored the wishes in JSON, so you're going to have to parse out the children's wishes.

Database Structure:
  CREATE TABLE children (
      child_id INT PRIMARY KEY,
      name VARCHAR(100),
      age INT
  );
  CREATE TABLE wish_lists (
      list_id INT PRIMARY KEY,
      child_id INT,
      wishes JSON,
      submitted_date DATE
  );
  CREATE TABLE toy_catalogue (
      toy_id INT PRIMARY KEY,
      toy_name VARCHAR(100),
      category VARCHAR(50),
      difficulty_to_make INT
  );
  
Sample Data:
This isn't used in the challenge, but you can use it to prove your query works.

For the challenge data click `Download challenge data` below.

  INSERT INTO children VALUES
  (1, 'Tommy', 8),
  (2, 'Sally', 7),
  (3, 'Bobby', 9);

  INSERT INTO wish_lists VALUES
  (1, 1, '{"first_choice": "bike", "second_choice": "blocks", "colors": ["red", "blue"]}', '2024-11-01'),
  (2, 2, '{"first_choice": "doll", "second_choice": "books", "colors": ["pink", "purple"]}', '2024-11-02'),
  (3, 3, '{"first_choice": "blocks", "second_choice": "bike", "colors": ["green"]}', '2024-11-03');

  INSERT INTO toy_catalogue VALUES
  (1, 'bike', 'outdoor', 3),
  (2, 'blocks', 'educational', 1),
  (3, 'doll', 'indoor', 2),
  (4, 'books', 'educational', 1);
  
Sample result:
  name  | primary_wish | backup_wish | favorite_color | color_count | gift_complexity | workshop_assignment
  ----------------------------------------------------------------------------------------------------------
  Tommy | bike         | blocks      | red            | 2           | Complex Gift    | Outside Workshop
  Sally | doll         | books       | pink           | 2           | Moderate Gift   | General Workshop
  Bobby | blocks       | bike        | green          | 1           | Simple Gift    | Learning Workshop
  
Solution to submit
Bobby,blocks,bike,green,1,Simple Gift,Learning Workshop
Sally,doll,books,pink,2,Moderate Gift,General Workshop
Tommy,bike,blocks,red,2,Complex Gift,Outside Workshop
The challenge 🎁
Download challenge data
Create a report showing what gifts children want, with difficulty ratings and categorization.

The primary wish will be the first choice

The secondary wish will be the second choice

You can presume the favorite color is the first color in the wish list

Gift complexity can be mapped from the toy difficulty to make. Assume the following:

    Simple Gift = 1
    Moderate Gift = 2
    Complex Gift >= 3
We assign the workshop based on the primary wish's toy category. Assume the following:

  outdoor = Outside Workshop
  educational = Learning Workshop
  all other types = General Workshop
Order the list by name in ascending order.

Your answer should limit its return to only 5 rows

In the inputs below provide one row per input in the format, with no spaces and comma separation:

name,primary_wish,backup_wish,favorite_color,color_count,gift_complexity,workshop_assignment
You can achieve this by setting the following in your psql before running your query.

\pset format unaligned
   \pset fieldsep ','

You answered correctly 🎉

*/
select 
c.name,
w.wishes ->> 'first_choice' as primary_wish, 
w.wishes ->> 'second_choice' as backup_wish, 
w.wishes -> 'colors' ->> 0 as favourite_color, 
json_array_length(w.wishes->'colors') AS color_count,
t.toy_name,
case
when t.difficulty_to_make = 1
then 'Simple Gift'
when t.difficulty_to_make = 2
then 'Moderate Gift'
else 'Complex Gift'
end abc,
case
when t.category = 'outdoor' then 'Outside Workshop'
when t.category = 'educational' then 'Learning Workshop'
else 'General Workshop'
end bcd
from children c
join
wish_lists w
on c.child_id = w.child_id
join toy_catalogue t
on w.wishes->>'first_choice' = t.toy_name
order by c.name ASC
limit 5;


