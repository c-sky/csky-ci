rm -rf /tmp/rootfs_nfs
mkdir /tmp/rootfs_nfs
tar -xf $OUT_PATH/images/rootfs.tar -C /tmp/rootfs_nfs
tail -f /root/minicom/minicom.log > >(tee $ROOT_PATH/test.log) &
cd $OUT_PATH/images/
../host/bin/csky-linux-gdb -x gdbinit vmlinux > /dev/null
ps|grep tail|awk '{print $1}'|xargs kill -9
cd -
