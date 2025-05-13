-- This project involves the analysis of my personal Spotify streaming data from 2024 to uncover patterns in my listening habits. The data, downloaded from my Spotify account, included four JSON files containing information about the artists, tracks, and
-- total listening time. I combined these four streaming logs into a single full_history table to obtain the full year of streaming history.
-- Analyses performed:
	-- Repeat behavior: Looked at the frequency of repeat listening to tracks and artists. Created a 'Repeat Ratio' and categorized artists into types.
	-- Listening trends over time: Analyzed total listening minutes by month, day of the week, and hour of the day to identify preferences and peak listening times.
	-- Artist popularity: Ranked top artists based on total listening time and tracked their top songs. Explored listening time by quarters.
    -- Total number of sessions per day of week.


select * from spotify.streaming0
union all
select * from spotify.streaming
union all
select * from spotify.streaming2
union all
select * from spotify.streaming3
union all
select * from spotify.streaming4;


-- Create table of full streaming history.
create table full_history as
select * from spotify.streaming0
union all
select * from spotify.streaming
union all
select * from spotify.streaming2
union all
select * from spotify.streaming3
union all
select * from spotify.streaming4;


select
	*
from spotify.full_history
order by
	endtime;


alter table spotify.full_history
add column minutes_played float;


-- Convert milliseconds to minutes and update values.
update spotify.full_history
set minutes_played = msplayed / 60000;


select
	min(endtime) as first_date
    ,max(endtime) as last_date
from spotify.full_history;


select
	count(*) as total_rows
from spotify.full_history;


select
	count(distinct artistname) as total_artists
from spotify.full_history;


select
	count(distinct trackname) as total_distinct_tracks
from spotify.full_history;


-- Total minutes played by month.
select
	month(endtime) as month_num
    ,round(sum(minutes_played), 2) as total_minutes
from spotify.full_history
group by
	month_num
order by
	month_num;
    

select
	date_format(endtime, '%l %p') as hour_of_day
    ,round(sum(minutes_played), 0) as total_minutes
from spotify.full_history
group by
	hour_of_day
order by
	total_minutes desc;
    
    
select
	dayname(endtime) as day_name
    ,round(sum(minutes_played), 0) as total_minutes
from spotify.full_history
group by
	day_name
order by
	total_minutes desc;
    

-- Summarizes total and average daily listening minutes by weekday, with rankings for both.
select
	dayname(play_date) as day_name
    ,round(sum(daily_total), 0) as total_minutes
    ,dense_rank() over (order by sum(daily_total) desc) as total_min_rank
    ,round(avg(daily_total), 2) as avg_minutes
    ,dense_rank() over (order by avg(daily_total) desc) as avg_min_rank
from (
	-- Subquery calculates total minutes per calendar day.
	select
		date(endtime) as play_date
        ,sum(minutes_played) as daily_total
	from spotify.full_history
    group by
		date(endtime)
) as daily_totals
group by
	day_name
order by
	total_minutes desc;
    
    
-- Repeat ratio for each artist (total tracks played / distinct tracks).
select
    artistname
    ,total_tracks
    ,total_distinct_tracks
    ,(total_tracks / total_distinct_tracks) as repeat_ratio
from(
select
	artistname
    ,count(*) as total_tracks
    ,count(distinct trackname) as total_distinct_tracks
from spotify.full_history
group by
	artistname
) as artist_repeat_stats
order by
	repeat_ratio desc;


-- Looks at artist-level repeat behavior by dividing artists into quartiles based on their repeat ratio.
with artist_repeat_stats as (
	select
		artistname
		,count(*) as total_tracks
        ,count(distinct trackname) as total_distinct_tracks
	from spotify.full_history
    group by
		artistname
	having count(*) >= 5 -- only including artists with 5+ total plays to filter out low-play artists
),
repeat_ratios as (
	select
		artistname
        ,total_tracks
        ,total_distinct_tracks
        ,(total_tracks * 1.0 / total_distinct_tracks) as repeat_ratio
	from artist_repeat_stats
),
quartiles as (
	select
		artistname
        ,total_tracks
        ,total_distinct_tracks
        ,repeat_ratio
        ,ntile(4) over (order by repeat_ratio) as repeat_ratio_quartile -- Q1 = least repeated, Q4 = most repeated.
	from repeat_ratios
)
select
	*
from quartiles
order by
	total_tracks;
      
      
-- Adding a case statement for description of level of repeat listener.
with artist_repeat_stats as (
	select
		artistname
		,count(*) as total_tracks
        ,count(distinct trackname) as total_distinct_tracks
	from spotify.full_history
    group by
		artistname
	having count(*) >= 5 -- Only including artists with 5+ total plays to filter out low-play artists.
),
repeat_ratios as (
	select
		artistname
        ,total_tracks
        ,total_distinct_tracks
        ,(total_tracks * 1.0 / total_distinct_tracks) as repeat_ratio
	from artist_repeat_stats
),
quartiles as (
	select
		artistname
        ,total_tracks
        ,total_distinct_tracks
        ,repeat_ratio
        ,ntile(4) over (order by repeat_ratio) as repeat_ratio_quartile -- Q1 = least repeated, Q4 = most repeated.
	from repeat_ratios
)
select
	artistname
    ,total_tracks
    ,total_distinct_tracks
    ,repeat_ratio
    ,repeat_ratio_quartile
    ,case repeat_ratio_quartile
		when 1 then 'Explorer'
        when 2 then 'Moderate Listener'
        when 3 then 'Repeater'
        when 4 then 'Heavy Repeater'
	end as repeat_description
from quartiles
order by
	total_tracks;
      
    
-- Top 10 artists by total minutes played.
select
	rank() over (order by sum(minutes_played) desc) as total_minutes_ranking
	,artistname
    ,round(sum(minutes_played), 2) as total_minutes
from spotify.full_history
group by
	artistname
order by
	total_minutes desc
limit 10;


-- Artists ranked by total tracks played.
select
	dense_rank() over (order by count(distinct trackname) desc) as total_tracks_ranking
    ,artistname
    ,count(distinct trackname) as total_tracks
from spotify.full_history
group by
	artistname
order by total_tracks desc;


-- Finds the number of distinct artists listened to, grouped by the day of the week and the month.
select
	month(endtime) as month_num
    ,dayname(endtime) as day_name
    ,count(distinct artistname) as total_artists
from spotify.full_history
group by
	month_num
    ,day_name
order by
	day_name
    ,month_num;
    
    
-- Optimized version of the query above.
select
    month_num
    ,day_num
    ,day_name
	,count(distinct artistname) as total_artists
from (
	select
        month(endtime) as month_num
		,dayofweek(endtime) as day_num
		,dayname(endtime) as day_name
		,artistname
    from spotify.full_history
) as month_day_stats
group by
	month_num
    ,day_num
    ,day_name
order by
	day_num
    ,month_num;
    
		
-- Top 3 songs for top 10 artists (by total minutes played).
with top_10_artists as (
	select
		artistname
	from spotify.full_history
    group by
		artistname
	order by
		sum(minutes_played) desc
	limit 10
),
track_play_counts as (
	select
		artistname
		,trackname
		,round(sum(minutes_played), 2) as total_play_time
	from spotify.full_history
	where
		artistname in (select artistname from top_10_artists)
	group by
		artistname
		,trackname
),
ranked_tracks as (
	select
		artistname
		,trackname
		,total_play_time
		,rank() over (partition by artistname order by total_play_time desc) as track_rank
	from track_play_counts
)
select
	track_rank
	,artistname
    ,trackname
    ,total_play_time
    ,round(total_play_time / 60, 2) as hours_played
from ranked_tracks
where
	track_rank in (1, 2, 3)
order by
	artistname
	,total_play_time desc;
    
    
-- Ranks all tracks by total listening time (in milliseconds).
select
	rank() over (order by sum(msplayed) desc) as ranking
    ,trackname
    ,artistname
    ,sum(msplayed)
    ,round(sum(minutes_played), 2) as total_minutes
from spotify.full_history
group by
	trackname
    ,artistname
order by
	total_minutes desc;
    

-- Breaks down total listening time for each track by calendar quarters (Q1-Q4) minutes.
select
	trackname
    ,artistname
    ,round(sum(case when quarter(endtime) = 1 then msplayed else 0 end) / 60000, 2) as minutes_q1
    ,round(sum(case when quarter(endtime) = 2 then msplayed else 0 end) / 60000, 2) as minutes_q2
    ,round(sum(case when quarter(endtime) = 3 then msplayed else 0 end) / 60000, 2) as minutes_q3
	,round(sum(case when quarter(endtime) = 4 then msplayed else 0 end) / 60000, 2) as minutes_q4
    ,round(sum(msplayed) / 60000, 2) as total_minutes
from spotify.full_history
group by
	trackname
    ,artistname
order by
	total_minutes desc;


-- Breaks down total listening time for each artist by calendar quarters (Q1-Q4) minutes.
select
    artistname
    ,round(sum(case when quarter(endtime) = 1 then msplayed else 0 end) / 60000, 2) as minutes_q1
    ,round(sum(case when quarter(endtime) = 2 then msplayed else 0 end) / 60000, 2) as minutes_q2
    ,round(sum(case when quarter(endtime) = 3 then msplayed else 0 end) / 60000, 2) as minutes_q3
	,round(sum(case when quarter(endtime) = 4 then msplayed else 0 end) / 60000, 2) as minutes_q4
    ,round(sum(msplayed) / 60000, 2) as total_minutes
from spotify.full_history
group by
    artistname
order by
	total_minutes desc;
    

-- Top artist for each quarter based on total minutes played.
with artist_quarter_minutes as (
	select
		quarter(endtime) as quarter_num
        ,artistname
        ,round(sum(msplayed) / 60000, 2) as minutes_played
	from spotify.full_history
    group by
		quarter_num
        ,artistname
),
ranked_artists as (
	select
		quarter_num
        ,artistname
        ,minutes_played
        ,rank() over (partition by quarter_num order by minutes_played desc) as artist_rank
	from artist_quarter_minutes
),
artist_overall_rank as (
	select
		artistname
        ,round(sum(msplayed) / 60000, 2) as total_minutes_all
        ,rank() over (order by sum(msplayed) desc) as overall_artist_rank
	from spotify.full_history
    group by
		artistname
)
select
	r.quarter_num
    ,r.artistname
    ,r.minutes_played
    ,o.total_minutes_all
    ,o.overall_artist_rank
from ranked_artists r
join artist_overall_rank o
	on r.artistname = o.artistname
where
	r.artist_rank = 1
order by
	r.quarter_num;

   
-- Minutes between tracks.
  select
	*
    ,timestampdiff(minute, lag(endtime) over (order by endtime), endtime) as minutes_between_tracks
from spotify.full_history
order by endtime;


-- Adding a new session ID when there are more than 30 minutes between tracks.
with time_diff as (
	select
		*
        ,lag(endtime) over (order by endtime) as prev_endtime
	from spotify.full_history
),
diff_calculated as (
	select
		*
        ,timestampdiff(minute, prev_endtime, endtime) as minutes_between_tracks
	from time_diff
),
sessions as (
	select
		*
        ,sum(case
				when minutes_between_tracks > 30 or minutes_between_tracks is null then 1
                else 0
		end) over (order by endtime rows unbounded preceding) as session_id
	from diff_calculated
)
select
	*
from sessions;


-- Number of total sessions by day of week.
with time_diff as (
	select
		*
        ,lag(endtime) over (order by endtime) as prev_endtime
	from spotify.full_history
),
diff_calculated as (
	select
		*
        ,timestampdiff(minute, prev_endtime, endtime) as minutes_between_tracks
	from time_diff
),
sessions as (
	select
		*
        ,sum(case
				when minutes_between_tracks > 30 or minutes_between_tracks is null then 1
                else 0
		end) over (order by endtime rows unbounded preceding) as session_id
	from diff_calculated
)
select
	dayname(endtime) as session_day
	,count(distinct session_id) as session_count
from sessions
group by
	session_day
    ,dayofweek(endtime)
order by
	dayofweek(endtime);




