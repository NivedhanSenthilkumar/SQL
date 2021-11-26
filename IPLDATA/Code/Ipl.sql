use ipl;

--1) Show the percentage of wins of each bidder in the order of highest to lowest percentage
select bd.BIDDER_ID,bd.BIDDER_NAME,count(bds.BID_STATUS) as wincount,bps.NO_OF_BIDS as totalbids ,((count(bds.BID_STATUS)/bps.NO_OF_BIDS)*100) as winpercentage
from ipl_bidder_details as bd
inner join ipl_bidding_details as bds on bds.BIDDER_ID = bd.BIDDER_ID
inner join ipl_bidder_points as bps on bds.BIDDER_ID = bps.BIDDER_ID 
where bds.BID_STATUS = 'won'
group by bd.BIDDER_ID 
order by winpercentage desc;

--2)Display the number of matches conducted at each stadium with stadium name, city from the database

select st.STADIUM_NAME,st.CITY,count(ms.MATCH_ID) as matchesheld
from ipl_stadium as st 
inner join ipl_match_schedule as ms on ms.STADIUM_ID = st.STADIUM_ID
group by st.STADIUM_NAME;

-- 3)In a given stadium, what is the percentage of wins by a team which has won the toss?

select count(m.TOSS_WINNER)as tosscount,count(m.MATCH_WINNER)as wincount,it.TEAM_ID,it.TEAM_NAME,st.STADIUM_NAME,((count(m.MATCH_WINNER)/count(m.TOSS_WINNER))*100)as winpercentage
from ipl_match as m
inner join ipl_match_schedule as ms on ms.MATCH_ID = m.MATCH_ID
inner join ipl_stadium as st on st.STADIUM_ID = ms.STADIUM_ID
inner join ipl_team as it on it.TEAM_ID = m.MATCH_WINNER
where m.TOSS_WINNER = m.MATCH_WINNER 
group by st.STADIUM_NAME,it.TEAM_NAME;

---4)Show the total bids along with bid team and team name.(check)

SELECT T.TEAM_ID,t.TEAM_NAME,bd.BIDDER_ID,bd.BID_TEAM,count(bp.NO_OF_BIDS) as totalbids,bp.TOTAL_POINTS
from ipl_team as t
inner join ipl_match as m on m.TEAM_ID1 = t.TEAM_ID
inner join ipl_match_schedule as ms on ms.MATCH_ID = m.MATCH_ID
inner join ipl_bidding_details as bd on bd.SCHEDULE_ID = ms.SCHEDULE_ID
inner join ipl_bidder_points as bp on bp.BIDDER_ID = bd.BIDDER_ID
group by T.TEAM_ID

--5)Show the team id who won the match as per the win details (check)

select t.TEAM_ID,t.TEAM_NAME,substr(WIN_DETAILS,6,3) as winner
from ipl_team as t
inner join ipl_match as m on m.MATCH_WINNER = t.TEAM_ID

select * from ipl_match;
select * from ipl_team;

--6)Display total matches played, total matches won and total matches lost by team along with its team name.(CHECK)

select m.MATCH_WINNER,t.TEAM_NAME,count(m.match_id)as matchcount,substr(WIN_DETAILS,6,3) as winner
from ipl_team as t
inner join  ipl_match as m on m.MATCH_WINNER = t.TEAM_ID
inner join ipl_match_schedule as ms on ms.MATCH_ID = m.MATCH_ID
group by t.TEAM_NAME;

--7)Display the bowlers for Mumbai Indians team.
SELECT T.TEAM_ID,T.TEAM_NAME,TP.PLAYER_ID,TP.PLAYER_ROLE,P.PLAYER_NAME
FROM ipl_team AS T
INNER JOIN ipl_team_players AS TP ON TP.TEAM_ID = T.TEAM_ID
INNER JOIN ipl_player AS P ON P.PLAYER_ID = TP.PLAYER_ID
WHERE TP.PLAYER_ROLE = 'BOWLER' AND T.TEAM_NAME = 'Mumbai Indians'

--8)How many all-rounders are there in each team, Display the teams with more than 4 ALLROUNDER IN DESCENDING ORDER

SELECT T.TEAM_ID,T.TEAM_NAME,COUNT(TP.PLAYER_ROLE) AS NOOFALLROUNDERS
FROM ipl_team AS T
INNER JOIN ipl_team_players AS TP ON TP.TEAM_ID = T.TEAM_ID
INNER JOIN ipl_player AS P ON P.PLAYER_ID = TP.PLAYER_ID
WHERE TP.PLAYER_ROLE = 'ALL-ROUNDER' 
GROUP BY T.TEAM_NAME
HAVING NOOFALLROUNDERS > 4
