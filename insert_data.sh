#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    $PSQL "INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT(name) DO NOTHING"
    $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT(name) DO NOTHING"
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      SELECT $YEAR, '$ROUND', winner.team_id, opponent.team_id, $WINNER_GOALS, $OPPONENT_GOALS
      FROM teams AS winner, teams AS opponent
      WHERE winner.name = '$WINNER' AND opponent.name = '$OPPONENT'"
  fi
done < games.csv
