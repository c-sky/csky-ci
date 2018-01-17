ROOT_PATH=$(dirname "$0")/../../../
OUT_PATH=$(dirname "$0")/../../
GET_START=n
$OUT_PATH/host/csky-qemu/bin/qemu-system-cskyv2 -machine virt -kernel $OUT_PATH/images/vmlinux -dtb $OUT_PATH/images/qemu.dtb -nographic  > >(tee test.log)
while read LINE
do
if [ "$GET_START" == "y" ];then
  if [[ "$LINE" =~ "end=========" ]];then
    GET_START=n
  fi
  echo $LINE>>$OUT
else
  if [[ "$LINE" =~ "start=========" ]];then
    GET_START=y
    if [[ "$LINE" =~ "sum" ]]; then
      OUT=$ROOT_PATH/ltp.sum
    else
      OUT=$ROOT_PATH/ltp.log
    fi
    echo $LINE>$OUT
  fi
fi
done  < $ROOT_PATH/test.log
ls $ROOT_PATH/*.sum|xargs cat
