#!/bin/sh

SetParams() {
   URL=$1
   AUTH=$(printf $2:$3 | base64)
   OPTIONS=$4
   WAIT_TIME=$5
   FILE=$6

   # Log params
   printf "URL: %s\n" $URL
   printf "Options: %s\n" $OPTIONS
   printf "Wait Time: %s\n" $WAIT_TIME
   printf "File Path: %s\n" $FILE
}

PollInfrastructureManagement() {
   # Set params
   SetParams $1 $2 $3 $4 $5 $6

   result=$(curl -X GET $OPTIONS "$1" --header "Authorization: Basic $AUTH" | jq -r '.approval_state')
   printf "Approval Status: %s\n" $result
   while [ "$result" = "pending_approval" ]
   do
      printf "Approval Status: %s\n" $result
      result=$(curl -X GET $OPTIONS "$1" --header "Authorization: Basic $AUTH" | jq -r '.approval_state')
      sleep $WAIT_TIME
   done

   printf "Approval Status: %s\n" $result
   printf $result > $FILE
}

PollInfrastructureManagement $1 $2 $3 $4 $5 $6
