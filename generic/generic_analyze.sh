GET_START=n
ROOT_PATH=$(dirname "$0")/../../../
OUT_PATH=$(dirname "$0")/../../

#Parsh the result from lmbench & LTP etc.
echo "============= csky test sum ============="
sed -i 's///g' $ROOT_PATH/test.log
sed -i 's///g' $ROOT_PATH/test.log

function shut_down()
{
	killall DebugServerConsole.elf > /dev/null 2>&1
	killall csky_serial > /dev/null 2>&1
	./$OUT_PATH/host/csky-ci/csky_switch /dev/ttyUSB1 off
}

if grep -q "Freeing unused kernel memory" $ROOT_PATH/test.log; then
	echo "Linux kernel start successed!"
	shut_down
else
	echo "Linux kernel start failed!"
	shut_down
	exit 1
fi

echo "Start parsing..."
while read LINE
do
if [ "$GET_START" == "y" ]; then
  if [[ "$LINE" =~ "end =========" ]]; then
    GET_START=n
    echo $LINE>>$OUT
  else
    echo $LINE>>$OUT
  fi
else
  if [[ "$LINE" =~ "start =========" ]]; then
    GET_START=y
    TEST=$(echo $LINE|awk '{print $2}')
    OUT=$ROOT_PATH/$TEST.log
    echo $LINE>$OUT
  fi
fi
done < $ROOT_PATH/test.log

RESULT=0
for i in $(dirname "$0")/*_parse.sh; do
  $i $ROOT_PATH/test.log
  RESULT=$(($RESULT+$?))
done
exit $RESULT
