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

shut_down

if grep -q "Freeing unused kernel memory" $ROOT_PATH/test.log; then
	echo "Linux kernel start successed!"
else
	echo "Linux kernel start failed!"
	exit 1
fi

if grep -q "csky-ci tests failed" $ROOT_PATH/test.log; then
	echo "Total failure. Check test.log"
	exit 1
fi
