#!/bin/sh

sleep 5
#init system time to avoid case settimeofday01 fail
date -s 09:00:00
sleep 10 # Sleep 10 more secs to login

cd /etc/init.ci/
for i in *; do
	j=${i%_*}
	echo ================== $j test start ==================
	./$i
	echo ================== $j test end ==================
done
cd - #This will echo a "/", so, don't bother

if [ -f /usr/lib/csky-ci/total_result ]; then
	echo "csky-ci tests failed"
	cat /usr/lib/csky-ci/total_result
fi

poweroff
