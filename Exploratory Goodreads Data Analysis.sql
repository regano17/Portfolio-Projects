-- In this project, I performed MySQL queries to analyze and gain insights from my personal reading dataset from Goodreads.
-- I focused on several aspects, including the books I've read, ratings, and publisher data.
	-- Compared my ratings with the average ratings given by other Goodreads users.
	-- Categorized books into 4 groups based on ratings.
	-- Identified when I added books and number of pages.


select
	*
from goodreads;


-- Top 5 authors by number of books read.
select
	author
    ,count(*) as total_books
from goodreads
where
	bookshelves not like 'to-read'
group by
	author
order by
	total_books desc
limit 5;


-- Number of books read by each publisher, ordered from most to least.
select
	publisher
    ,count(*) as total_books
from goodreads
where
	bookshelves not like 'to-read'
group by
	publisher
order by
	total_books desc;


-- Number of publishers, including 'To Read' books.
select
	count(distinct publisher) as total_publishers
from goodreads
where
	publisher != '';


-- List of publishers, including 'To Read' books.
select
	distinct publisher
from goodreads
where
	publisher != ''
    and
    publisher is not null;



-- Average rating on Goodreads vs. my rating.
select
	title
	,my_rating
    ,average_rating
 from goodreads
 where
	exclusive_shelf = 'read'
 order by
	average_rating desc;
 
 
 -- List of books where my rating is higher than the average rating and the difference in ratings.
 select
	title
	,my_rating
    ,average_rating
    ,round((my_rating - average_rating), 2) as rating_diff
 from goodreads
 where
	my_rating > average_rating
 order by
	rating_diff desc;
 
 
 -- Number of books where my rating is higher than the average rating.
select
	count(*) as total_books
from (
	select
		title
	from goodreads
	where my_rating > average_rating
) as rating_comparison;
    
 
-- List of books where my rating is lower than the average rating and the difference in ratings.
select
	title
    ,my_rating
    ,average_rating
from goodreads
	where title in (
	select title
	from goodreads
	where my_rating < average_rating
	and my_rating != 0
	);
 
 
 -- Number of books where my rating is lower than the average rating.
select
	count(*) as total_books
from (
	select
		title
	from goodreads
	where my_rating < average_rating
    and my_rating != 0
) as rating_comparison_2;
        
  
-- Books marked “To Read”.
select
	*
from goodreads
where
	bookshelves = 'to-read';
    

-- Average, minimum, and maximum number of pages.
select
	round(avg(number_of_pages), 0)
    ,min(number_of_pages) as min_pages
    ,max(number_of_pages) as max_pages
from goodreads;


-- Number of pages, ordered by most to least.
select
	title
    ,author
    ,number_of_pages
from goodreads
order by
	number_of_pages desc;

    
-- Number of (read) books added by date, ordered by most added to least.
select
	date_added,
	count(*) as total_books
from goodreads
where
	exclusive_shelf = 'read'
group by
	date_added
order by
	total_books desc;


-- Titles added on 9/1/2022.
select
	title
    ,author
from goodreads
where
	date_added = '9/1/2022';
    

-- Number of books read by Rating Group.
select
	my_rating
    ,count(*) as total_books
    ,case
		when my_rating > 4 then 'Perfect'
		when my_rating > 3 then 'Great'
		when my_rating > 2 then 'Good'
		when my_rating > 1 then 'Bad'
		else 'Not Read'
	end as rating_group
from goodreads
group by
	my_rating
order by
	my_rating desc;
    

-- Comparing my average rating for each author to the average Goodreads ratings.
-- Lower ratings indicate my average rating was lower than the average of other readers on Goodreads.
select
	author
    ,count(*) as total_books
    ,round(avg(my_rating), 2) as my_avg_rating
    ,round(avg(average_rating), 2) as avg_goodreads_rating
    ,round((avg(my_rating) - avg(average_rating)), 2) as rating_diff
from goodreads
where
	bookshelves not like 'to-read'
group by
	author
order by
	total_books desc;
    
    
