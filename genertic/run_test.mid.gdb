rm -rf $OUT_PATH/images/rootfs
mkdir $OUT_PATH/images/rootfs
tar -xf $OUT_PATH/images/rootfs.tar -C $OUT_PATH/images/rootfs
cd $OUT_PATH/images/
tail -f /root/builds/minicom/minicom$1.log > >(tee $ROOT_PATH/test.log) &
../host/bin/csky-buildroot-*-gdb vmlinux
ps|grep tail|awk '{print $1}'|xargs kill -9
cd -
