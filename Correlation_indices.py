import json
import xskillscore as xs
from esmtools.grid import convert_lon
from utils import *

N = '24'
print(f'Calculate correlations for SPI-{N} months with ASSTs')
# read Shapefile
shp = salem.read_shapefile('Assine/Assine.shp')
# Read data
asst = xr.open_dataset('RESULTS/asst.nc').sel(time=slice('1980-01-01', '2022-03-01'))
ds = xr.open_dataset('RESULTS/Pantanal_spi_gamma_06_reorder.nc').sel(time=slice('1980-01-01', '2022-03-01'))
# Interpolate data
ds = interpolate_ds(ds, n=4)
# clip data
# ds_clip = ds.salem.subset(shape=shp)
ds_clip = ds.salem.roi(shape=shp)

with open('SST_regions.json') as f:
    regions = json.load(f)

# Empty lists to store data
nino_data = []
for key, nino in regions.items():
    print(key + ': ', nino['lat'][0], nino['lat'][1], nino['lon'][0], nino['lon'][1])
    if key == 'TSAI':
        print('Convert longitude to -180 to 180')
        asst = convert_lon(asst, coord='lon')
        asst_areas = asst.sel(lon=slice(nino['lon'][0], nino['lon'][1]),
                              lat=slice(nino['lat'][0], nino['lat'][1])).mean(
            ("lon", "lat"))
    else:
        asst_areas = asst.sel(lon=slice(nino['lon'][0], nino['lon'][1]),
                              lat=slice(nino['lat'][1], nino['lat'][0])).mean(
            ("lon", "lat"))
    # store data
    nino_data.append(asst_areas)

# apply correlation test
for nino, region in zip(nino_data, regions.keys()):
    print(f'Calculating correlation {region}...')
    cor = xs.pearson_r(nino.sst, ds_clip[getvar(ds_clip)], dim='time')
    p = xs.pearson_r_eff_p_value(nino.sst, ds_clip[getvar(ds_clip)], dim='time')
    print('Done!')

    # store data
    ds = merge_params(cor, p, name_stats='Correlation', name_sig='p')
    ds.to_netcdf(f'RESULTS/Cor_Pantanal_SPI{N}_{region}.nc')
print('All Correlations done!')



