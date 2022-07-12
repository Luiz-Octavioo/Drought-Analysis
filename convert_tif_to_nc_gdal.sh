#!/bin/bash

# Convert TIF to netCDF using GDAL
echo "================================"
echo "Convert TIF to netCDF using GDAL"
echo "================================"
for file in *.tif ; do
  echo "Processing $file..."
  gdal_translate -of netCDF $file $file.nc
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
cdo settaxis,2001-01-01,00:00,1mon ${file_name}_tmp.nc ${file_name}_tmpf.nc
echo "Done."

echo 'Processing finished.'