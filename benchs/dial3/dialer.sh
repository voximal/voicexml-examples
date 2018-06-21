#!/bin/bash

echo "$0 : START"

let CAPS=4

let WANTEDSIMULT=$1

## Configuration variables
if [ $# -lt 2 ]
then
  let WANTEDSECS=0
  let WANTEDMINS=20
  let WANTEDHOURS=0
  let WANTEDDAYS=0
else
  let WANTEDMINS=$2
fi

if [ $# -lt 3 ]
then
  let WANTEDCALLS=0
else
  let WANTEDCALLS=$3
fi

##Internal variables
let INDEX=0
let COMPTEUR=0
let SECONDES=0
let ACTSIMULT=0
let CURRENTSIMULT=0
let NEEDTHIS=0

## Calculate needed secs
let WANTEDTIME=WANTEDDAYS
let WANTEDTIME=WANTEDTIME*24
let WANTEDTIME=WANTEDTIME+WANTEDHOURS
let WANTEDTIME=WANTEDTIME*60
let WANTEDTIME=WANTEDTIME+WANTEDMINS
let WANTEDTIME=WANTEDTIME*60
let WANTEDTIME=WANTEDTIME+WANTEDSECS


echo "Launch test with ${WANTEDSIMULT} call(s) for ${WANTEDMINS} min"

echo "$0 : CHECKING"

CURRENTSIMULT=`ls /var/spool/asterisk/outgoing/ |wc -l`

### Main Loop ###
while [ $CURRENTSIMULT -ne 0 ]
do
   # Maintenir les WANTEDSIMULT lignes
   CURRENTSIMULT=`ls /var/spool/asterisk/outgoing/ |wc -l`

   echo "Total/pending calls : $COMPTEUR/$CURRENTSIMULT ($SECONDES secs)"
   sleep 1
   let SECONDES=SECONDES+1
done

echo "$0 : STARTING"

### Main Loop ###
while [ $SECONDES -lt $WANTEDTIME ]
do
   ### Ramp-up ###
   if [ $ACTSIMULT -lt $WANTEDSIMULT ]
   then
      let ACTSIMULT=ACTSIMULT+CAPS
      if [ $ACTSIMULT -gt $WANTEDSIMULT ]
      then
            let ACTSIMULT=WANTEDSIMULT
      fi      
   fi

   # Maintenir les WANTEDSIMULT lignes
   CURRENTSIMULT=`ls /var/spool/asterisk/outgoing/ |wc -l`

   echo "Total/pending calls : $COMPTEUR/$CURRENTSIMULT ($SECONDES secs) $ACTSIMULT"
   while [ $CURRENTSIMULT -lt $ACTSIMULT ]
   do
      let INDEX=INDEX+1
      let CURRENTSIMULT=CURRENTSIMULT+1

      ### Check if needed
      let NEEDTHIS=INDEX%5
      NEEDTHIS=0
      if [ $NEEDTHIS -eq 0 ]
      then
         cp dialout.call /tmp
         mv /tmp/dialout.call /var/spool/asterisk/outgoing/a$INDEX.call
         let COMPTEUR=COMPTEUR+1
      else
         cp dialout.call /tmp
         mv /tmp/dialout.call /var/spool/asterisk/outgoing/b$INDEX.call
         let COMPTEUR=COMPTEUR+1
      fi
   done
   sleep 1
   let SECONDES=SECONDES+1

   if [ $WANTEDCALLS -ne 0 ]
   then
    if [ $COMPTEUR -eq $WANTEDCALLS ]
    then
    break
    fi
   fi
done

echo "$0 : STOPING"

### Main Loop ###
while [ $CURRENTSIMULT -ne 0 ]
do
   # Maintenir les WANTEDSIMULT lignes
   CURRENTSIMULT=`ls /var/spool/asterisk/outgoing/ |wc -l`

   echo "Total/pending calls : $COMPTEUR/$CURRENTSIMULT ($SECONDES secs)"
   sleep 1
   let SECONDES=SECONDES+1
done

echo "Total appels : $COMPTEUR"
echo "$0 : END"


