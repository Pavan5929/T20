use feb;

CREATE TABLE T20I (
    Team1	VARCHAR(50),
    Team2	VARCHAR(50),
    Winner	VARCHAR(50),
    Margin	VARCHAR(50),
    MatchDate	DATE,
    Ground	VARCHAR(50)
);


select *from T20I;
-- identify matches played between two specific teams in 2024
-- and their result

select *
from T20I
where (team1='South Africa' and team2='India') or
(team2='South Africa' and team1='India') and
year(matchdate)=2024;

-- find the team with highest number of wins in 2024 and total
-- matches it won

select winner,count(*) as total
from T20I
where year(matchdate)=2024
group by winner
order by total desc
limit 1;

-- Rank the teams based on the total number of wins in 2024

select winner,count(*) as total,
dense_rank() over(order by count(*) desc) as rank_values
from T20I
where year(matchdate)=2024 and winner not in('tied','no result')
group by winner;

-- which team had the highest average winning margin(in runs)
-- and what was the average margin

SELECT winner,
       avg(substring(margin,1,instr(margin, ' ')-1)) AS avgmargin
FROM T20I
WHERE margin LIKE '%runs'
group by winner
order by avgmargin desc
limit 1;

-- list all matches where the winning margin was greater than the
-- average margin across all matches.

with avgmargin as(
SELECT avg(substring(margin,1,instr(margin, ' ')-1)) AS avgmargin
FROM T20I
WHERE margin LIKE '%runs')
select *
from T20I t 
left join avgmargin A
on 1=1
where t.margin like '%runs'
and  substring(margin,1,instr(margin, ' ')-1)>A.avgmargin;

;


-- Find the team with the most wins when chasing a target(wins by wickets)

select winner,winwhilechasing from(
select winner,count(*) as winwhilechasing,
  rank() over(order by count(*) desc) as rk
from T20I
where margin like "%wickets"
and winner not in ('tied','no result')
group by winner
)as t
where rk=1;
-- head to head record between two selected teams
SET @teamA = 'England';
set @teamB= 'australia';

select winner,count(*) as matches
from t20i
where (team1=@teamA and team2=@teamB) or (team1=@teamB and team2=@teamA) 
group by winner;

select *
from T20I;

-- identify the month in 2024 with highest number of t20I matches played.

SELECT  YEAR(matchDate) AS yearplayed,
        MONTH(matchDate) AS monthnumber,
        MONTHNAME(matchDate) AS monthname,
        count(*) as matchplayed
FROM T20I
WHERE YEAR(matchDate) = 2024
group by month(matchDate), year(matchDate),MONTHNAME(matchDate)
order by matchplayed desc;

-- for each team, find how many they played in 2024 and their win percentage
WITH cte_matches AS (
    SELECT team, COUNT(*) AS match_played
    FROM (
        SELECT team1 AS team
        FROM t20i
        WHERE YEAR(matchDate) = 2024
        
        UNION ALL
        
        SELECT team2 AS team
        FROM t20i
        WHERE YEAR(matchDate) = 2024
    ) AS t
    GROUP BY team
),

cte_wins AS (
    SELECT winner AS team, COUNT(*) AS wins
    FROM t20i
    WHERE YEAR(matchDate) = 2024
      AND winner NOT IN ('tied','no result')
    GROUP BY winner
)

SELECT 
    m.team,
    m.match_played,
    IFNULL(w.wins, 0) AS wins,
    w.wins*100.0/m.match_played as perc
FROM cte_matches m
LEFT JOIN cte_wins w
ON m.team = w.team;

-- identify the most successful team at each ground
-- (team with most wins per ground);
with cteinsperground as(
select ground, winner, wins,rank() over (partition by ground order by wins desc) as rn
from (
    select ground, winner, count(*) as wins
    from t20i
    where winner not in ('tied','no result')
    group by ground, winner
) as match_wins
)
select ground,winner,wins as mostsuccessful
from cteinsperground
where rn=1
order by ground;

INSERT INTO T20I VALUES 
('West Indies','England','West Indies','5 wickets','2024-11-16','Gros Islet'),
('Australia','Pakistan','Australia','13 runs','2024-11-16','Sydney'),
('South Africa','India','India','135 runs','2024-11-15','Johannesburg'),
('West Indies','England','England','3 wickets','2024-11-14','Gros Islet'),
('Australia','Pakistan','Australia','29 runs','2024-11-14','Brisbane'),
('South Africa','India','India','11 runs','2024-11-13','Centurion'),
('West Indies','England','England','7 wickets','2024-11-10','Bridgetown'),
('South Africa','India','South Africa','3 wickets','2024-11-10','Gqeberha'),
('Sri Lanka','New Zealand','New Zealand','5 runs','2024-11-10','Dambulla'),
('West Indies','England','England','8 wickets','2024-11-09','Bridgetown'),
('Sri Lanka','New Zealand','Sri Lanka','4 wickets','2024-11-09','Dambulla'),
('South Africa','India','India','61 runs','2024-11-08','Durban'),
('Sri Lanka','West Indies','Sri Lanka','9 wickets','2024-10-17','Dambulla'),
('Sri Lanka','West Indies','Sri Lanka','73 runs','2024-10-15','Dambulla'),
('Sri Lanka','West Indies','West Indies','5 wickets','2024-10-13','Dambulla'),
('India','Bangladesh','India','133 runs','2024-10-12','Hyderabad'),
('India','Bangladesh','India','86 runs','2024-10-09','Delhi'),
('India','Bangladesh','India','7 wickets','2024-10-06','Gwalior'),
('Canada','Nepal','Canada','4 wickets','2024-10-01','King City (NW)'),
('Ireland','South Africa','Ireland','10 runs','2024-09-29','Abu Dhabi'),
('Canada','Nepal','Canada','14 runs','2024-09-28','King City (NW)'),
('Ireland','South Africa','South Africa','8 wickets','2024-09-27','Abu Dhabi'),
('England','Australia','England','3 wickets','2024-09-13','Cardiff'),
('England','Australia','Australia','28 runs','2024-09-11','Southampton'),
('Scotland','Australia','Australia','6 wickets','2024-09-07','Edinburgh'),
('Scotland','Australia','Australia','70 runs','2024-09-06','Edinburgh'),
('Scotland','Australia','Australia','7 wickets','2024-09-04','Edinburgh'),
('West Indies','South Africa','West Indies','8 wickets','2024-08-27','Tarouba'),
('Canada','U.S.A.','U.S.A.','20 runs','2024-08-27','The Hague'),
('West Indies','South Africa','West Indies','30 runs','2024-08-25','Tarouba'),
('West Indies','South Africa','West Indies','7 wickets','2024-08-23','Tarouba'),
('Sri Lanka','India','tied','-','2024-07-30','Pallekele'),
('Sri Lanka','India','India','7 wickets','2024-07-28','Pallekele'),
('Sri Lanka','India','India','43 runs','2024-07-27','Pallekele'),
('Zimbabwe','India','India','42 runs','2024-07-14','Harare'),
('Zimbabwe','India','India','10 wickets','2024-07-13','Harare'),
('Zimbabwe','India','India','23 runs','2024-07-10','Harare'),
('Zimbabwe','India','India','100 runs','2024-07-07','Harare'),
('Zimbabwe','India','Zimbabwe','13 runs','2024-07-06','Harare'),
('India','South Africa','India','7 runs','2024-06-29','Bridgetown'),
('England','India','India','68 runs','2024-06-27','Providence'),
('Afghanistan','South Africa','South Africa','9 wickets','2024-06-26','Tarouba'),
('Afghanistan','Bangladesh','Afghanistan','8 runs','2024-06-24','Kingstown'),
('Australia','India','India','24 runs','2024-06-24','Gros Islet'),
('West Indies','South Africa','South Africa','3 wickets','2024-06-23','North Sound'),
('England','U.S.A.','England','10 wickets','2024-06-23','Bridgetown'),
('Afghanistan','Australia','Afghanistan','21 runs','2024-06-22','Kingstown'),
('Bangladesh','India','India','50 runs','2024-06-22','North Sound'),
('West Indies','U.S.A.','West Indies','9 wickets','2024-06-21','Bridgetown'),
('England','South Africa','South Africa','7 runs','2024-06-21','Gros Islet'),
('Australia','Bangladesh','Australia','28 runs','2024-06-20','North Sound'),
('Afghanistan','India','India','47 runs','2024-06-20','Bridgetown'),
('West Indies','England','England','8 wickets','2024-06-19','Gros Islet'),
('South Africa','U.S.A.','South Africa','18 runs','2024-06-19','North Sound'),
('West Indies','Afghanistan','West Indies','104 runs','2024-06-17','Gros Islet'),
('Bangladesh','Nepal','Bangladesh','21 runs','2024-06-16','Kingstown'),
('Ireland','Pakistan','Pakistan','3 wickets','2024-06-16','Lauderhill'),
('Australia','Scotland','Australia','5 wickets','2024-06-15','Gros Islet'),
('England','Namibia','England','41 runs','2024-06-15','North Sound'),
('Nepal','South Africa','South Africa','1 run','2024-06-14','Kingstown'),
('West Indies','New Zealand','West Indies','13 runs','2024-06-12','Tarouba'),
('U.S.A.','India','India','7 wickets','2024-06-12','New York'),
('Australia','Namibia','Australia','9 wickets','2024-06-11','North Sound'),
('Canada','Pakistan','Pakistan','7 wickets','2024-06-11','New York'),
('Bangladesh','South Africa','South Africa','4 runs','2024-06-10','New York'),
('India','Pakistan','India','6 runs','2024-06-09','New York'),
('Australia','England','Australia','36 runs','2024-06-08','Bridgetown'),
('Bangladesh','Sri Lanka','Bangladesh','2 wickets','2024-06-07','Dallas'),
('Afghanistan','New Zealand','Afghanistan','84 runs','2024-06-07','Providence'),
('Canada','Ireland','Canada','12 runs','2024-06-07','New York'),
('U.S.A.','Pakistan','tied','-','2024-06-06','Dallas'),
('India','Ireland','India','8 wickets','2024-06-05','New York'),
('England','Scotland','no result','-','2024-06-04','Bridgetown'),
('South Africa','Sri Lanka','South Africa','6 wickets','2024-06-03','New York'),
('U.S.A.','Canada','U.S.A.','7 wickets','2024-06-01','Dallas'),
('England','Pakistan','England','7 wickets','2024-05-30','The Oval'),
('West Indies','South Africa','West Indies','8 wickets','2024-05-26','Kingston'),
('West Indies','South Africa','West Indies','16 runs','2024-05-25','Kingston'),
('U.S.A.','Bangladesh','Bangladesh','10 wickets','2024-05-25','Prairie View'),
('England','Pakistan','England','23 runs','2024-05-25','Birmingham'),
('West Indies','South Africa','West Indies','28 runs','2024-05-23','Kingston'),
('U.S.A.','Bangladesh','U.S.A.','6 runs','2024-05-23','Prairie View'),
('U.S.A.','Bangladesh','U.S.A.','5 wickets','2024-05-21','Prairie View'),
('Ireland','Pakistan','Pakistan','6 wickets','2024-05-14','Dublin'),
('Ireland','Pakistan','Pakistan','7 wickets','2024-05-12','Dublin'),
('Bangladesh','Zimbabwe','Zimbabwe','8 wickets','2024-05-12','Mirpur'),
('Ireland','Pakistan','Ireland','5 wickets','2024-05-10','Dublin'),
('Bangladesh','Zimbabwe','Bangladesh','5 runs','2024-05-10','Mirpur'),
('Bangladesh','Zimbabwe','Bangladesh','9 runs','2024-05-07','Chattogram'),
('Bangladesh','Zimbabwe','Bangladesh','6 wickets','2024-05-05','Chattogram'),
('Bangladesh','Zimbabwe','Bangladesh','8 wickets','2024-05-03','Chattogram'),
('Pakistan','New Zealand','Pakistan','9 runs','2024-04-27','Lahore'),
('Pakistan','New Zealand','New Zealand','4 runs','2024-04-25','Lahore'),
('Pakistan','New Zealand','New Zealand','7 wickets','2024-04-21','Rawalpindi'),
('Pakistan','New Zealand','Pakistan','7 wickets','2024-04-20','Rawalpindi'),
('Pakistan','New Zealand','no result','-','2024-04-18','Rawalpindi'),
('Afghanistan','Ireland','Afghanistan','57 runs','2024-03-18','Sharjah'),
('Afghanistan','Ireland','Afghanistan','10 runs','2024-03-17','Sharjah'),
('Afghanistan','Ireland','Ireland','38 runs','2024-03-15','Sharjah'),
('Bangladesh','Sri Lanka','Sri Lanka','28 runs','2024-03-09','Sylhet'),
('Bangladesh','Sri Lanka','Bangladesh','8 wickets','2024-03-06','Sylhet'),
('Bangladesh','Sri Lanka','Sri Lanka','3 runs','2024-03-04','Sylhet'),
('New Zealand','Australia','Australia','27 runs','2024-02-25','Auckland'),
('New Zealand','Australia','Australia','72 runs','2024-02-23','Auckland'),
('Sri Lanka','Afghanistan','Afghanistan','3 runs','2024-02-21','Dambulla'),
('New Zealand','Australia','Australia','6 wickets','2024-02-21','Wellington'),
('Sri Lanka','Afghanistan','Sri Lanka','72 runs','2024-02-19','Dambulla'),
('Sri Lanka','Afghanistan','Sri Lanka','4 runs','2024-02-17','Dambulla'),
('Australia','West Indies','West Indies','37 runs','2024-02-13','Perth'),
('Australia','West Indies','Australia','34 runs','2024-02-11','Adelaide'),
('Australia','West Indies','Australia','11 runs','2024-02-09','Hobart'),
('New Zealand','Pakistan','Pakistan','42 runs','2024-01-21','Christchurch'),
('New Zealand','Pakistan','New Zealand','7 wickets','2024-01-19','Christchurch'),
('Sri Lanka','Zimbabwe','Sri Lanka','9 wickets','2024-01-18','Colombo (RPS)'),
('India','Afghanistan','tied','-','2024-01-17','Bengaluru'),
('New Zealand','Pakistan','New Zealand','45 runs','2024-01-17','Dunedin'),
('Sri Lanka','Zimbabwe','Zimbabwe','4 wickets','2024-01-16','Colombo (RPS)'),
('India','Afghanistan','India','6 wickets','2024-01-14','Indore'),
('Sri Lanka','Zimbabwe','Sri Lanka','3 wickets','2024-01-14','Colombo (RPS)'),
('New Zealand','Pakistan','New Zealand','21 runs','2024-01-14','Hamilton'),
('New Zealand','Pakistan','New Zealand','46 runs','2024-01-12','Auckland'),
('India','Afghanistan','India','6 wickets','2024-01-11','Mohali');
