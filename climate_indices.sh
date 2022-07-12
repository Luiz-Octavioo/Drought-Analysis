#!/bin/bash

# This script is used to calculate the climate indices using python scripts
DIR_DATA='Dataset'
PRECIPITATION_FILE=${DIR_DATA}/'era5_prcp_temp_pantanal.nc'
PRECIP_VAR='prcp'
TEMPERATURE_FILE=${DIR_DATA}/'era5_prcp_temp_pantanal.nc'
TEMP_VAR='temp'
OUT_FILE='Pantanal'
DIR='RESULTS'
PET_FILE=${DIR}/${OUT_FILE}'_pet_thornthwaite.nc'
PET_VAR='pet_thornthwaite'



# CREATE OUTPUT DIRECTORY IF IT DOESN'T EXIST
if [ ! -d ${DIR} ]; then
    mkdir ${DIR}
fi

echo "Calculating climate indices for ${OUT_FILE}..."

# Pet
process_climate_indices --index pet --periodicity monthly --netcdf_temp ${TEMPERATURE_FILE} --var_name_temp ${TEMP_VAR} \
--output_file_base ${DIR}/${OUT_FILE} --multiprocessing all_but_one

# Spei
process_climate_indices --index spei --periodicity monthly --netcdf_precip ${PRECIPITATION_FILE} --var_name_precip ${PRECIP_VAR} \
--netcdf_pet ${PET_FILE} --var_name_pet ${PET_VAR} --output_file_base ${DIR}/${OUT_FILE} --scales 3 6 12 \
--calibration_start_year 1951 --calibration_end_year 2010 --multiprocessing all

# Spi
process_climate_indices --index spi --periodicity monthly --netcdf_precip ${PRECIPITATION_FILE} --var_name_precip ${PRECIP_VAR} \
--output_file_base ${DIR}/${OUT_FILE} --scales 24 --calibration_start_year 1951 \
--calibration_end_year 2010 --multiprocessing all