$OUT_PATH/host/csky-test/check_done.sh &
cd $OUT_PATH/images/
../host/bin/csky-buildroot-*-gdb vmlinux > /dev/null &
cd -
minicom -D /dev/ttyUSB0 -b 115200 -C $ROOT_PATH/test.log
