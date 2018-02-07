rm -rf $OUT_PATH/images/rootfs
mkdir $OUT_PATH/images/rootfs
tar -xf $OUT_PATH/images/rootfs.tar -C $OUT_PATH/images/rootfs
$OUT_PATH/host/csky-test/check_done.sh &
cd $OUT_PATH/images/
../host/bin/csky-buildroot-*-gdb vmlinux > /dev/null &
cd -
tail -f /root/builds/minicom/minicom.log > >(tee $ROOT_PATH/test.log)
touch $OUT_PATH/images/rootfs/usr/lib/csky-ci/.stamp_test_done
