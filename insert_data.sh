#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE games, teams")"

cat games.csv| while IFS=',' read YEAR ROAD WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
    
      if [[ $WINNER != winner ]]
      then
          TEAM=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
          if [[ $TEAM != $WINNER ]]
          then
              echo "$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER') ")"
              echo Team add: $WINNER
          fi
      fi

      if [[ $OPPONENT != opponent ]]
      then
          TEAM=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
          if [[ $TEAM != $OPPONENT ]]
          then
              echo "$($PSQL "INSERT INTO teams (name) VALUES ( '$OPPONENT') ")"
              echo Team add: $OPPONENT
          fi
      fi
      
      if [[ $YEAR != year && $ROAD != road && $WINNER_GOALS != winner_goals && $OPPONENT_GOALS != opponent_goals  && $WINNER != winner && $OPPONENT != opponent  ]]
      then
          WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
          OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'" )
          echo "$($PSQL "INSERT INTO games (year, round, winner_id, winner_goals,opponent_id, opponent_goals) VALUES ( $YEAR, '$ROAD', $WINNER_ID, '$WINNER_GOALS', $OPPONENT_ID, '$OPPONENT_GOALS')")"
          echo games add : $YEAR , $ROAD, $WINNER_ID, $WINNER_GOALS, $OPPONENT_ID, $OPPONENT_GOALS
      fi
done

