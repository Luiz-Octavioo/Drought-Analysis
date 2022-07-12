#!/bin/bash

# Convert TIF to netCDF using GDAL
echo "================================"
echo "Convert TIF to netCDF using GDAL"
echo "================================"

# Set path to
PATH_TIF="Dados_Modis_NDVI"

if [ ! -d "$PATH_TIF" ]; then
  echo "Directory $PATH_TIF not found"
  exit 1
fi
cd $PATH_TIF || exit

for file in *.tif ; do
  echo "Processing $file..."
  # split file name and extension
  filename=${file%.*}
  # extension=${file##*.}
  gdal_translate -of netCDF "$file" "$filename".nc
done

echo "Finish converting processing."

echo "================================"
echo "Start merging netCDF files using CDO..."
echo "================================"
# merge all netCDF files into one
file_name='NDVI_Modis'
cdo copy *.nc ${file_name}.nc
echo "Finish merging netCDF files."

# set variable name
echo "Setting variable name..."
cdo setname,ndvi ${file_name}.nc ${file_name}_tmp.nc
echo "Done."

# Set time dimension
echo "Setting time dimension..."
cdo -O settaxis,2001-01-01,00:00,1mon ${file_name}_tmp.nc ${file_name}_tmp.nc
echo "Done."

echo 'Processing finished.'