select *
from goodreads;


-- 1.	Top 5 authors by number of books read.
select author, count(*)
from goodreads
group by author
order by count(*) desc
limit 5;


-- 2.	Number of books read by each publisher, ordered from most to least.
select publisher, count(*)
from goodreads
group by publisher
order by count(*) desc;


-- 3.	Number of publishers.
select count(distinct(publisher))
from goodreads
where publisher != '';


-- 4.	List of publishers.
select distinct(publisher)
from goodreads
where publisher != '';


-- 5.	Average rating on Goodreads vs. my rating.
select title, my_rating, average_rating
 from goodreads
 where exclusive_shelf = 'read'
 order by average_rating desc;
 
 
 -- 6.	List of books where my rating is higher than the average rating and the difference in ratings.
 select title, my_rating, average_rating, round((my_rating - average_rating),2) as rating_diff
 from goodreads
 where my_rating > average_rating
 order by rating_diff desc;
 
 
 -- 7.	Number of books where my rating is higher than the average rating.
select count(*)
from goodreads
 where title in (
	select title
    from goodreads
    where my_rating > average_rating
    );
    
 
 -- 8.	Number of books where my rating is lower than the average rating.
select count(*)
from goodreads
 where title in (
	select title
    from goodreads
    where my_rating < average_rating
    and my_rating != '0'
    );
    

-- 9.	Number of books marked “To Read”.
select title, my_rating, average_rating
from goodreads
	where title in (
	select title
	from goodreads
	where my_rating < average_rating
	and my_rating != '0'
	);
    
  
-- 10.	Books marked “To Read”.
select count(*)
from goodreads
where bookshelves = 'to-read';
    

-- 11.	Average number of pages.
select round(avg(number_of_pages),0)
from goodreads;
    
   
-- 12.	Number of books added by date, ordered by most added to least.
select date_added, count(*)
from goodreads
where exclusive_shelf = 'read'
group by date_added
order by count(*) desc;


-- 13.	Titles added on 9/1/2022.
select title, author
from goodreads
where date_added = '9/1/2022';


-- 14.	Number of pages, ordered by most to least.
select title, author, number_of_pages
from goodreads
order by number_of_pages desc;


-- 15.	Number of books read by Rating Group.
select my_rating, count(*) as total_books,
CASE
when my_rating > 4 then 'Perfect'
when my_rating > 3 then 'Great'
when my_rating > 2 then 'Good'
when my_rating > 1 then 'Bad'
else 'Not read'
end as rating_group
from goodreads
group by my_rating
order by my_rating desc;

