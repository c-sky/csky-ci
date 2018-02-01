$OUT_PATH/host/csky-test/check_done.sh &
cd $OUT_PATH/images/
../host/bin/csky-buildroot-*-gdb vmlinux > /dev/null &
cd -
$OUT_PATH/host/csky-test/com_tool /dev/ttyUSB0 115200 > >(tee $ROOT_PATH/test.log)
