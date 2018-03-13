rm -rf $OUT_PATH/images/rootfs
mkdir $OUT_PATH/images/rootfs
tar -xf $OUT_PATH/images/rootfs.tar -C $OUT_PATH/images/rootfs
tail -f /root/builds/minicom/minicom$1.log > >(tee $ROOT_PATH/test.log) &
cd $OUT_PATH/images/
../host/bin/csky-buildroot-*-gdb vmlinux
ps|grep tail|awk '{print $1}'|xargs kill -9
cd -
