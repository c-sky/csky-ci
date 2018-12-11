#!/bin/sh

sleep 5
#init system time to avoid case settimeofday01 fail
date -s 09:00:00

for i in /etc/init.ci/*; do
	$i
done

poweroff
