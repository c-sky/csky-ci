#!/bin/sh

sleep 5
#init system time to avoid case settimeofday01 fail
date -s 09:00:00

for i in /etc/init.ci/*; do
	$i
done

if [ -f /usr/lib/csky-ci/total_result ]
	echo "csky-ci tests failed"
	cat /usr/lib/csky-ci/total_result
fi

poweroff
