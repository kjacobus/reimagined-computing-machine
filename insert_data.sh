#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams;")


cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do 
 if [[ $WINNER != winner ]]
 then 
  #get team id of winner
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  
  #if not found 
  if [[ -z $TEAM_ID ]]
   #then insert winner into teams
   then
    INSERT_WINNER=$($PSQL "INSERT into teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER == 'INSERT 0 1' ]]
    then
     echo inserted into teams, $WINNER
    fi


  fi
 fi

 if [[ $OPPONENT != opponent ]]
 then
  #get team id of loser
   TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  if [[ -z $TEAM_ID ]]
   then
    INSERT_OPPONENT=$($PSQL "INSERT into teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPPONENT == 'INSERT 0 1' ]]
    then
     echo inserted into teams, $OPPONENT
    fi
  fi
 fi

if [[ $YEAR != year ]]
then
 echo winner, $WINNER
 echo opponent, $OPPONENT
 W_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER';")
 O_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT';")

 GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year='$YEAR' and round='$ROUND' and winner_id='$W_ID' and opponent_id='$O_ID';")

 if [[ -z $GAME_ID ]]
 then
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$W_ID','$O_ID','$WINNER_GOALS','$OPPONENT_GOALS');")
 fi



fi


done