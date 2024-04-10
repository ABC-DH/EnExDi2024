# Mapping tutorial
# Part 2. Map creation
# we'll be using the Leaflet: https://rstudio.github.io/leaflet/

# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# Note 1: before you start, install the required packages
# (if a yellow warning is shown above)

# Note 2: Always run commands in the presented order
# ...and never skip lines!!!
# In case of doubt, you can always restart from the beginning

# set the working directory
setwd("/cloud/project/materials/5_Mapping/")

library(leaflet)
library(sf)

### 1. Basic map

# Read the csv
data <- read.csv("datasets/georeferenced_places.csv")

# Prepare the map
map <- leaflet() %>%
  
  # Loading the base map
  addProviderTiles(providers$OpenStreetMap)  %>% 
  
  # Add the markers on the locations indicated by the lat & lng columns with text as popup
  addMarkers(data = data,
             lng = ~lng, 
             lat = ~lat,
             popup = ~paste("This is the place cited as <b>", text, "</b>"))

# show the map
map

### 2. Map with no. of citations

# Prepare the map
map <- leaflet() %>%
  
  # Loading the base map
  addProviderTiles(providers$OpenStreetMap)  %>% 
  
  # add circle markers
  addCircleMarkers(data = data,
                   lng = ~lng, 
                   lat = ~lat,
                   radius = ~ n*2,
                   stroke = FALSE, fillOpacity = 0.5,
                   popup = ~paste("<b>", text, "</b>" ,"<br>", "is cited<b>", n, "</b>", "time(s)", sep = " ")
  )

# show the map
map

### 3. Map with shapes (badly drawn)

# Read the shape file
my_shape <- st_read('datasets/shapefiles_India/POLYGON.shp')

# Prepare the map
map <- leaflet() %>%
  
  # Loading the base map
  addProviderTiles(providers$OpenStreetMap)  %>% 
  
  # adding the shape
  addPolygons(data=my_shape) %>%
  
  # add circle markers
  addCircleMarkers(data = data,
                   lng = ~lng, 
                   lat = ~lat,
                   radius = ~ n*2,
                   stroke = FALSE, fillOpacity = 0.5,
                   popup = ~paste("<b>", text, "</b>" ,"<br>", "is cited<b>", n, "</b>", "time(s)", sep = " ")
  )

# show the map
map

### 4. Map with shapes (well done)
# downloaded from: https://tapiquen-sig.jimdofree.com/english-version/free-downloads/

# read shapefile
my_shape <- st_read('datasets/World_Countries/SHP/World_Countries.shp')
View(my_shape)

# see which countries are present
my_shape$COUNTRY

# select a few countries (e.g. India, United Kingdom)
my_countries <- c("India", "United Kingdom")

# check which is my country
which(my_shape$COUNTRY %in% my_countries)

# reduce to selection
my_shape2 <- my_shape[which(my_shape$COUNTRY %in% my_countries),]
View(my_shape2)

# Prepare the map
map <- leaflet() %>%
  
  # Loading the base map
  addProviderTiles(providers$OpenStreetMap)  %>% 
  
  # adding the shape
  addPolygons(data=my_shape2) %>%
  
  # add circle markers
  addCircleMarkers(data = data,
                   lng = ~lng, 
                   lat = ~lat,
                   radius = ~ n*2,
                   stroke = FALSE, fillOpacity = 0.5,
                   popup = ~paste("<b>", text, "</b>" ,"<br>", "is cited<b>", n, "</b>", "time(s)", sep = " ")
  )

# show the map
map

