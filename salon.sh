#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICE_INFO=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICE_INFO" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME Service"
  done
  read SERVICE_ID_SELECTED

  SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $SELECTED_SERVICE ]]
  then 
  echo -e "\nI could not find that service. What would you like today\n"
    MAIN_MENU
  else
  SERVICE_MENU 
  fi
}
SERVICE_MENU(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then 
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  INSERT_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')") 
  fi

  echo -e "What time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  #SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name = '$SELECTED_SERVICE'")
  INSERT_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID,$SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a$SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU