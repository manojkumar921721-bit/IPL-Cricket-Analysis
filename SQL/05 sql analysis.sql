CREATE DATABASE ipl_analysis;

USE ipl_analysis;

show tables;

SELECT COUNT(*) AS total_matches
FROM matches;

SELECT COUNT(*) AS total_balls
FROM deliveries;

SELECT SUM(total_runs) AS total_runs
FROM deliveries;

SELECT COUNT(*) AS total_teams
FROM teams;

SELECT COUNT(*) AS total_players
FROM players;

SELECT DISTINCT season
FROM matches
ORDER BY season;

SELECT COUNT(DISTINCT venue)
FROM matches;

SELECT COUNT(DISTINCT city)
FROM matches;

SELECT COUNT(DISTINCT umpire1)
FROM matches;

SELECT DISTINCT toss_winner
FROM matches;

# aggregate function

#top run scorer
SELECT
    batsman,
    SUM(batsman_runs) AS runs
FROM deliveries
GROUP BY batsman
ORDER BY runs DESC
LIMIT 10;

#top wicket scorer

SELECT
    bowler,
    COUNT(player_dismissed) AS wickets
FROM deliveries
WHERE player_dismissed IS NOT NULL
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;

#most six

SELECT
    batsman,
    COUNT(*) AS sixes
FROM deliveries
WHERE batsman_runs = 6
GROUP BY batsman
ORDER BY sixes DESC
LIMIT 10;

#Highest Match Score

SELECT
    match_id,
    SUM(total_runs) AS total_score
FROM deliveries
GROUP BY match_id
ORDER BY total_score DESC
LIMIT 10;

#Venue-wise Matches
  
SELECT
    venue,
    COUNT(*) AS matches
FROM matches
GROUP BY venue
ORDER BY matches DESC;

#Team Wins
SELECT
    winner,
    COUNT(*) AS wins
FROM matches
GROUP BY winner
ORDER BY wins DESC;

#Toss Wins
SELECT
    toss_winner,
    COUNT(*) AS tosses
FROM matches
GROUP BY toss_winner
ORDER BY tosses DESC;

#Average Match Score
SELECT
    AVG(match_score)
FROM
(
SELECT
match_id,
SUM(total_runs) AS match_score
FROM deliveries
GROUP BY match_id
) x;

#Average Runs per Over
SELECT
`over`,
AVG(total_runs)
FROM deliveries
GROUP BY `over`;

#joins
#-Match Winner with Venue

SELECT
m.season,
m.venue,
m.winner
FROM matches m;

#Runs by Season

SELECT
m.season,
SUM(d.total_runs) AS runs
FROM matches m
JOIN deliveries d
ON m.id=d.match_id
GROUP BY m.season;

#Average Score by Venue
SELECT
m.venue,
AVG(x.score)
FROM
(
SELECT
match_id,
SUM(total_runs) score
FROM deliveries
GROUP BY match_id
)x
JOIN matches m
ON x.match_id=m.id
GROUP BY venue;

#Runs by Team
SELECT
batting_team,
SUM(total_runs)
FROM deliveries
GROUP BY batting_team;

#Wickets by Team
SELECT
bowling_team,
COUNT(player_dismissed)
FROM deliveries
WHERE player_dismissed IS NOT NULL
GROUP BY bowling_team;

#windows function 

#Rank Teams by Wins
SELECT
winner,
COUNT(*) wins,
RANK() OVER(
ORDER BY COUNT(*) DESC
) ranking
FROM matches
GROUP BY winner;

#Dense Rank - wins and their rank

SELECT
winner,
COUNT(*) wins,
DENSE_RANK() OVER(
ORDER BY COUNT(*) DESC
) ranking
FROM matches
GROUP BY winner;

#Row Number
SELECT
winner,
COUNT(*) wins,
ROW_NUMBER() OVER(
ORDER BY COUNT(*) DESC
) rn
FROM matches
GROUP BY winner;

#Running Total
SELECT
match_id,
SUM(total_runs) total_runs,
SUM(SUM(total_runs))
OVER(
ORDER BY match_id
) running_total
FROM deliveries
GROUP BY match_id;

#Lag
SELECT
season,
COUNT(*) matches,
LAG(COUNT(*))
OVER(
ORDER BY season
)
FROM matches
GROUP BY season;

#CTE

WITH scores AS
(
SELECT
match_id,
SUM(total_runs) score
FROM deliveries
GROUP BY match_id
)

SELECT *
FROM scores;

WITH teamwins AS
(
SELECT
winner,
COUNT(*) wins
FROM matches
GROUP BY winner
)

SELECT *
FROM teamwins
ORDER BY wins DESC;

#high scoring match

SELECT *
FROM
(
SELECT
match_id,
SUM(total_runs) score
FROM deliveries
GROUP BY match_id
)x
WHERE score=
(
SELECT
MAX(score)
FROM
(
SELECT
SUM(total_runs) score
FROM deliveries
GROUP BY match_id
)y
);

#top scoring batsman

SELECT *
FROM
(
SELECT
batsman,
SUM(batsman_runs) runs
FROM deliveries
GROUP BY batsman
)x
WHERE runs=
(
SELECT
MAX(runs)
FROM
(
SELECT
SUM(batsman_runs) runs
FROM deliveries
GROUP BY batsman
)y
);

#top wicket - taking bowler

SELECT *
FROM
(
SELECT
bowler,
COUNT(player_dismissed) wickets
FROM deliveries
WHERE player_dismissed IS NOT NULL
GROUP BY bowler
)x
WHERE wickets=
(
SELECT
MAX(wickets)
FROM
(
SELECT
COUNT(player_dismissed) wickets
FROM deliveries
WHERE player_dismissed IS NOT NULL
GROUP BY bowler
)y
);

#season with highest number of match

SELECT
season,
COUNT(*) AS matches
FROM matches
GROUP BY season
ORDER BY matches DESC
LIMIT 1;

#venue with highest number of match

SELECT
venue,
COUNT(*) AS matches
FROM matches
GROUP BY venue
ORDER BY matches DESC
LIMIT 1;


