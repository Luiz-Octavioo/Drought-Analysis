from osgeo import gdal
import os

path = 'Dados_Modis_NDWI'

# open dataset
ds = gdal.Open('Dados_Modis/ndwi_pantanal_2001_2021.tif')

# Create path if it doesn't exist
if not os.path.exists(path):
    os.mkdir(path)
else:
    print(f'Directory {path} already exists')

# Get raster info
cols = ds.RasterXSize
rows = ds.RasterYSize
bands = ds.RasterCount

# Set driver and create new dataset
driver = gdal.GetDriverByName("GTiff")

# Save each band to a separate file
for band, nfile in zip(range(1, bands + 1), range(2001, 2252 + 1)):
    band_array = ds.GetRasterBand(band).ReadAsArray()
    # Create new dataset
    output_ds = driver.Create(f'{path}/ndwi_mensal_pantanal_{nfile}_band' + str(band) + '.tif',
                              cols, rows, 1, gdal.GDT_Float32)
    # set GeoTransform and Projection
    output_ds.SetGeoTransform(ds.GetGeoTransform())
    output_ds.SetProjection(ds.GetProjection())
    # Write array to new dataset
    output_ds.GetRasterBand(1).WriteArray(band_array)
    # # Flush to disk
    output_ds.FlushCache()
    # Close dataset
    output_ds = None
    print('Band ' + str(band) + ' saved')
