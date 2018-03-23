## Reptile Distribution and Climate Space 
## Erin Keleske

# Packages 

if(!require(dismo)) {
  install.packages("dismo");
  require(dismo)}

if(!require(maps)) {
  install.packages("maps");
  require(maps)}

if(!require(mapdata)) {
  install.packages("mapdata");
  require(mapdata)}

if(!require(maptools)) {
  install.packages("maptools");
  require(maptools)}

if(!require(raster)) {
  install.packages("raster");
  require(raster)}

if(!require(rgdal)) {
  install.packages("rgdal");
  require(rgdal)}

# Download data -----

# Climatic data (WorldClim)

clim = getData("worldclim", var="bio", res=2.5)

tempRast <- clim$bio1/10
precipRast <- clim$bio12

# Species distribution (GBIF)

tree = gbif('Sanzinia', 'madagascariensis') # Madagascar tree boa
ground = gbif('Acrantophis', 'madagascariensis') # Madagascar ground boa

# Extract climate data -----

# Madagascar tree boa

tree_geo <- data.frame(lat=tree$lat, lon=tree$lon)
tree_geo <- tree[complete.cases(tree_geo),]
coordinates(tree_geo)<-~lon + lat
proj4string(tree_geo) <- proj4string(tempRast)

tree_geo$temp <- raster::extract(tempRast, tree_geo)
tree_geo$prec <- raster::extract(precipRast, tree_geo)

hist(tree_geo$temp)
hist(tree_geo$prec)

# Madagascar ground boa

ground_geo <- data.frame(lat=ground$lat, lon=ground$lon)
ground_geo <- ground_geo[complete.cases(ground_geo),]
coordinates(ground_geo)<-~lon + lat
proj4string(ground_geo) <- proj4string(clim)
ground_geo$temp <- raster::extract(clim, ground_geo)

ground_geo$temp <- raster::extract(tempRast, ground_geo)
ground_geo$prec <- raster::extract(precipRast, ground_geo)

hist(ground_geo$temp)
hist(ground_geo$prec)