#!/bin/bash

echo "$0 : START"


case $# in
   2)
      NB_SIMULT_CALL=$2
      NB_MINS=""
      TYPETST=""
      ;;
   3)
      NB_SIMULT_CALL=$2
      NB_MINS=$3
      TYPETST=""
      ;;
   4)
      NB_SIMULT_CALL=$2
      NB_MINS=$3
      TYPETST=$4
      ;;
   *)
      NB_SIMULT_CALL=""
      NB_MINS=""
      TYPETST=""
      ;;
esac


# Config variables
WAITPEND=50

# Defines variables
DATETEST=`date +%Y%m%d_%H%M%S`
TSTDIR=$DATETEST"_MBench"
TSTNAME=$1

echo "$0 : Do some cleaning"
rm -rf ./*.csv
rm -rf /var/log/asterisk/cdr-csv/*.csv
rm -rf /var/spool/asterisk/monitor/*.wav
if [ "$TYPETST" == "depot" ]
then
  echo "type MACHU password"
  ssh root@machu  /var/www/html/Test_Snowshore/Static_Mailis-Video/clean_3gp_files.sh
fi

echo "$0 : Launch a-stats.bat"
nohup ./a-stats.bat </dev/null > /dev/null 2>&1 &

if [ -f "./$TSTNAME" ]
then
  echo "$0 : Launch test file $TSTNAME $NB_SIMULT_CALL $NB_MINS $TYPETST"
  ./$TSTNAME $NB_SIMULT_CALL $NB_MINS $TYPETST

fi

echo "$0 : Wait $WAITPEND secs for pending calls..."
sleep $WAITPEND

pkill a-stats.bat

echo "$0 : Process data (`date`)..."
mkdir $TSTDIR
cp ./$TSTNAME ./$TSTDIR/.
mv ./*.csv ./$TSTDIR/.
mv /var/log/asterisk/cdr-csv/Master.csv ./$TSTDIR/.
mv /var/spool/asterisk/monitor/*.wav ./$TSTDIR/.
egrep "CLIP|,0,0," ./$TSTDIR/Master.csv >./$TSTDIR/CLIP.csv
egrep "HASH|,0,0," ./$TSTDIR/Master.csv >./$TSTDIR/HASH.csv
egrep "HUP|,0,0,"  ./$TSTDIR/Master.csv >./$TSTDIR/HUP.csv
egrep "OK|,0,0,"   ./$TSTDIR/Master.csv >./$TSTDIR/OK.csv

echo "totalCalls; `wc -l ./$TSTDIR/Master.csv|awk '{print $1}'`" >> ./$TSTDIR/svc-stats.csv
echo "depositType; `grep "516003" ./$TSTDIR/Master.csv |wc -l`" >> ./$TSTDIR/svc-stats.csv
echo "consultType;`grep "516002" ./$TSTDIR/Master.csv |wc -l`" >> ./$TSTDIR/svc-stats.csv
echo "CLIP;`grep "CLIP" ./$TSTDIR/Master.csv |wc -l |awk '{print $1}'`" >> ./$TSTDIR/svc-stats.csv
echo "HASH;`grep "HASH" ./$TSTDIR/Master.csv |wc -l |awk '{print $1}'`" >> ./$TSTDIR/svc-stats.csv
echo "HUP;`grep "HUP" ./$TSTDIR/Master.csv |wc -l |awk '{print $1}'`" >> ./$TSTDIR/svc-stats.csv
echo "OK;`grep "OK" ./$TSTDIR/Master.csv |wc -l |awk '{print $1}'`" >> ./$TSTDIR/svc-stats.csv
echo "errorTotal;`grep "ERROR" ./$TSTDIR/Master.csv |wc -l`" >> ./$TSTDIR/svc-stats.csv
#echo "errorDeposit;`grep ",,516001" ./$TSTDIR/Master.csv |grep ERROR |wc -l`" >> ./$TSTDIR/svc-stats.csv
#echo "errorConsult;`grep ",,516002" ./$TSTDIR/Master.csv |grep ERROR |wc -l`" >> ./$TSTDIR/svc-stats.csv
#echo "errorUnknown;`grep ",0,0," ./$TSTDIR/Master.csv |wc -l`" >> ./$TSTDIR/svc-stats.csv

cat ./$TSTDIR/svc-stats.csv

if [ "$TYPETST" == "depot" ]
then
  echo "Result on HTTP server (machu):"
  #/mnt/machu/Test_Snowshore/Static_Mailis-Video/check_3gp_files.sh
  echo "type MACHU password"
  ssh root@machu  /var/www/html/Test_Snowshore/Static_Mailis-Video/check_3gp_files.sh
fi

mv caps.txt ./$TSTDIR/

echo "$0 : Process data DONE (`date`)"

rm -rf ./nohup.out
echo "$0 : END"

