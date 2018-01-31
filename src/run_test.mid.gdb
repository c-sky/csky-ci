$OUT_PATH/host/csky-test/check_done.sh &
cd $OUT_PATH/images/
../host/bin/csky-buildroot-*-gdb vmlinux > /dev/null &
cd -
cat /dev/ttyUSB0 > $ROOT_PATH/test.log
