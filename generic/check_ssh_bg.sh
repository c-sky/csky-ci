rm ~/.ssh/known_hosts -f
sleep 60
echo ================== perf test start ================== > ssh.log
ssh -o StrictHostKeyChecking=no $1 -p 5022 ls / >> ssh.log
ssh -o StrictHostKeyChecking=no $1 -p 5022 echo "ssh check pass!" >> ssh.log
echo ================== perf test end ================== >> ssh.log
