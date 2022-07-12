#!/bin/bash
echo "=========================================================================="
echo "This script set dimension of netcdf file to (time, lat, lon) using NCO"
echo "Author: Luiz Octavio"
echo "Date: 2022-07-11"
echo "Version: 1.0"
echo "=========================================================================="

time_start=$(date +%s)

echo "=========================================================="
echo "Reorder dimension of netcdf file to (time, lat, lon)"
for file in *_spi_gamma_*[0-9].nc ;do
  echo "Processing $file"
  # split file name and extension
  filename=${file%.*}
  extension=${file##*.}
  ncpdq -O -a time,lat,lon "$file" "$filename"_reordered."$extension"
done
echo "Done"

# calculate time of running script
time_end=`date +%s`
time_run=$((time_end-time_start))
# Convert time to minutes and seconds
# time_run_minutes=$((time_run/60))

echo "Time of running script: $time_run"
echo "Finished!!"
echo "=========================================================="


