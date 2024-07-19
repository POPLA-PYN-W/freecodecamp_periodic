#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1
##### #

if [[ -z $INPUT ]];then
echo -e "Please provide an element as an argument."
else

  if [[ ! $INPUT =~ ^[0-9]+$ ]];then
  # CHECK CONDITION IF NOT A NUMBER
    if [[ ${#INPUT} -le 2 ]];then
      # QUERIES
      ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$INPUT'")
      ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$ATOMIC_SYMBOL'")
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ATOMIC_SYMBOL'")
      else
        ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE name = '$INPUT'")
        ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$ATOMIC_NAME'")
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ATOMIC_NAME'")
      

    fi
  else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $INPUT")
      ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
      ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
      
  fi
  ATOMIC_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  ATOMIC_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $ATOMIC_TYPE_ID")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  ATOMIC_MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  ATOMIC_BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  if [[ -z $ATOMIC_BOIL ]];then
    echo "I could not find that element in the database."
    else
      echo -e "The element with atomic number $ATOMIC_NUMBER is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $ATOMIC_TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $ATOMIC_MELT celsius and a boiling point of $ATOMIC_BOIL celsius."
  fi
fi


