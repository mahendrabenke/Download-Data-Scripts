#!/bin/bash

ryear=2017

while [ $ryear -le 2017 ]
do

	wget https://www.imdpune.gov.in/cmpg/Griddata/maxtemp.php?maxtemp=$ryear
        wget https://www.imdpune.gov.in/cmpg/Griddata/mintemp.php?mintemp=$ryear

	mv maxtemp.php?maxtemp=$ryear IMD_MaxT_1x1_$ryear.grd
        mv mintemp.php?mintemp=$ryear IMD_MinT_1x1_$ryear.grd
        ncl grdflie_to_netcdf_maxtemp.ncl
        ncl grdflie_to_netcdf_mintemp.ncl
        rm -rf IMD_MaxT_1x1_$ryear.grd
        rm -rf IMD_MinT_1x1_$ryear.grd

	ryear=`expr $ryear + 1`
done
