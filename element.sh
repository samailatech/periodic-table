#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Check if the input is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
  # Input is a number, query by atomic_number
  QUERY_RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                        FROM elements
                        INNER JOIN properties USING(atomic_number)
                        INNER JOIN types USING(type_id)
                        WHERE elements.atomic_number = $1")
else
  # Input is a string, query by symbol or name
  QUERY_RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                        FROM elements
                        INNER JOIN properties USING(atomic_number)
                        INNER JOIN types USING(type_id)
                        WHERE symbol = '$1' OR name = '$1'")
fi

if [[ -z $QUERY_RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo "$QUERY_RESULT" | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
#dksdkdvms;lvdmdl
