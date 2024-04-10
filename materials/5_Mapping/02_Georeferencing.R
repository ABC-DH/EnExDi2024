# Mapping tutorial
# Part 1. Georeferencing
# we'll be using the Geonames API: https://www.geonames.org/

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

# set the options to your username in geonames
options(geonamesUsername="my_username")
# you will have to substitute "my_username" with your actual username

# load the library
library(geonames)
library(plyr)
library(tidyverse)

# search for one place and save result in variable
my_search <- GNsearch(name_equals = "Lyon")

# visualize the variable
View(my_search)

# load a list of places (e.g. the result of the NER)
# in the "Files" panel on the right, you need to Upload the entities_list.csv file

# load the file
my_df <- read.csv("datasets/entities_list.csv", header = F, row.names = 1)
colnames(my_df) <- c("text", "type")
View(my_df)

# reduce the dataset just to locations
my_places_df <- my_df %>% filter(type == "GPE")
View(my_places_df)

# Count the number of occurrences for each location
my_places_df <- my_places_df %>% count(text)
View(my_places_df)

# create empty table to store results
my_geonames <- data.frame()

# loop on all places
for(i in 1:length(my_places_df$text)){
  
  print(i)
  # prepare result dataframe
  tmp_df <- my_places_df[i,]
  # search the place
  result_tmp <- GNsearch(name = my_places_df$text[i])
  # check if I have a result (I might also get an empty dataframe)
  if(length(result_tmp) == 0){
    # bind (missing) result to final dataframe and jump to next iteration
    my_geonames <- rbind.fill(my_geonames, tmp_df)
    next
  }
  # select just the first entry
  result_tmp <- result_tmp[1,]
  tmp_df <- cbind(tmp_df, result_tmp)
  
  # bind result to final dataframe gradually
  my_geonames <- rbind.fill(my_geonames, tmp_df)
  # let the API breath (add pause)
  Sys.sleep(1)
  
}

# visualize the result
View(my_geonames)

# save results
write.csv(my_geonames, "datasets/georeferenced_places.csv")
