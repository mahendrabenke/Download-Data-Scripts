#!/bin/bash

ryear=2022

ndaymon=(31 28 31 30 31 30 31 31 30 31 30 31)


rmon=1
mncn=0
while [ $rmon -le 12 ]
do
	if [ $rmon -le 9 ]
        then
                mon=`echo 0$rmon`
        fi

        if [ $rmon -gt 9 ]
        then
                mon=`echo $rmon`
        fi
	
	tday=${ndaymon[$mncn]}
	
	rday=1
	while [ $rday -le $tday ]
	do
		if [ $rday -le 9 ]
		then
			day=`echo 0$rday`
		fi
	
		if [ $rday -gt 9 ]
		then
			day=`echo $rday`
		fi
	
		date=`echo $day$mon$ryear`
	
		echo $date
	
		wget https://www.imdpune.gov.in/cmpg/Realtimedata/Rainfall/rain.php?rain=$date
		mv rain.php?rain=$date IMD_rain_0.25_$ryear'_'$mon'_'$day.grd
		rday=`expr $rday + 1`
	done

	rmon=`expr $rmon + 1`
	mncn=`expr $mncn + 1`

done
