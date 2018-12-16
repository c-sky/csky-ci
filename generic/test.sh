#!/bin/sh

sleep 5
#init system time to avoid case settimeofday01 fail
date -s 09:00:00

cd /etc/init.ci/
for i in *; do
	echo ================== $i test start ==================
	$i
	echo ================== $i test end ==================
done
cd -

if [ -f /usr/lib/csky-ci/total_result ]; then
	echo "csky-ci tests failed"
	cat /usr/lib/csky-ci/total_result
fi

poweroff
