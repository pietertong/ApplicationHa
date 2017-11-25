#!/bin/bash
read -p "Please enter the current year:" yea
read -p "Please enter the current month:" mon
a=1
mont=`expr $mon + $a`
echo $mont

for((i=1 ;i<20 ;i++));
do
	ls -al /opt/qihu360/hsmp/application/ > /opt/qihu360/hsmp/logs/access_console.log
	ls -al /opt/qihu360/hsmp/application/ > /opt/qihu360/hsmp/logs/access_hserver.log
	ls -al /opt/qihu360/hsmp/application/ > /opt/qihu360/hsmp/logs/access_wsserver.log
	ls -al /opt/qihu360/hsmp/application/ > /opt/qihu360/hsmp/logs/error_console.log
	ls -al /opt/qihu360/hsmp/application/ > /opt/qihu360/hsmp/logs/error_hserver.log
	ls -al /opt/qihu360/hsmp/application/ > /opt/qihu360/hsmp/logs/error_wsserver.log
	date --set "$yea-$mont-$i 1:59:50"
	sleep 3m   
	echo $i;
done 
