#!/bin/bash

ryear=2017

while [ $ryear -le 2017 ]
do
	wget https://www.imdpune.gov.in/cmpg/Griddata/RF25.php?RF25=$ryear
	mv RF25.php?RF25=$ryear IMD_rain_0.25_$ryear
	ncrename -v LATITUDE,lat IMD_rain_0.25_$ryear
	ncrename -v LONGITUDE,lon IMD_rain_0.25_$ryear
	ncrename -v TIME,time IMD_rain_0.25_$ryear
	ncrename -v RAINFALL,rainfall IMD_rain_0.25_$ryear
	ncrename -d LATITUDE,lat IMD_rain_0.25_$ryear
        ncrename -d LONGITUDE,lon IMD_rain_0.25_$ryear
        ncrename -d TIME,time IMD_rain_0.25_$ryear

	ryear=`expr $ryear + 1`
done
