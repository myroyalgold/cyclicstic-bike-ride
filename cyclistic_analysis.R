#Prepare

#installation of packages
install.packages("tidyverse")
install.packages("janitor")
install.packages("lubridate")

#loading the packages
library(tidyverse)
library(janitor)
library(lubridate)
library(dplyr)

#I imported the dataset and renamed them as follows(cyclistdata = cd)
cd_1 <- read.csv("202304-divvy-tripdata.csv")
cd_2 <- read.csv("202305-divvy-tripdata.csv")
cd_3 <- read.csv("202306-divvy-tripdata.csv")
cd_4 <- read.csv("202307-divvy-tripdata.csv")
cd_5 <- read.csv("202308-divvy-tripdata.csv")
cd_6 <- read.csv("202309-divvy-tripdata.csv")
cd_7 <- read.csv("202310-divvy-tripdata.csv")
cd_8 <- read.csv("202311-divvy-tripdata.csv")
cd_9 <- read.csv("202312-divvy-tripdata.csv")
cd_10 <- read.csv("202401-divvy-tripdata.csv")
cd_11 <- read.csv("202402-divvy-tripdata.csv")
cd_12 <- read.csv("202403-divvy-tripdata.csv")

#merging data in to a single data set called bike_rides
bike_rides <- rbind(cd_1,cd_2,cd_3,cd_4,cd_5,cd_6,cd_7,cd_8,cd_9,cd_10,cd_11,cd_12)
head(bike_rides)

#checking the structure of the dataset
dim(bike_rides)
glimpse(bike_rides)

#Process: checking and removing empty columns and rows using janitor
bike_rides <- remove_empty(bike_rides, which = c('cols'))
bike_rides <- remove_empty(bike_rides, which = c('rows'))
dim(bike_rides)

#converting started at and ended at to datetime
bike_rides$started_at  <- as_datetime(bike_rides$started_at)
bike_rides$ended_at <- as_datetime(bike_rides$ended_at)

#getting the start and end time in date (ymd)
bike_rides$start_date <- date(bike_rides$started_at)
bike_rides$end_date <- date(bike_rides$ended_at)

#getting the start time and end time in hour
bike_rides$start_hour <- hour(bike_rides$started_at)
bike_rides$end_hour <- hour(bike_rides$ended_at)


#getting the ride length in hour
bike_rides$length_hour <- difftime(bike_rides$ended_at,bike_rides$started_at,units = c("hour"))
bike_rides$length_hour <- as.numeric(bike_rides$length_hour)

#getting the ride length in minutes
bike_rides$length_min <- difftime(bike_rides$ended_at, bike_rides$started_at, units = c("mins"))
bike_rides$length_min <- as.numeric(bike_rides$length_min)

#remove rows that have trip equal to zero and less than 0
bike_rides <- bike_rides[!(bike_rides$length_hour== 0),]
dim(bike_rides)

#getting days of the week from the start and end date
bike_rides$start_day <- wday(bike_rides$start_date, label=TRUE, abbr = FALSE)
bike_rides$end_day <- wday(bike_rides$end_date, label=TRUE, abbr = FALSE)


#to remove unnecessary columns such as ride id, start and end station name, start and end station id, start and end latitude and start and end longitude
bike_rides <- select(bike_rides, -ride_id,-start_station_name,-start_station_id,
                     -end_station_name,end_station_id,-start_lat,-start_lng,
                     -end_lat,-end_lng)
dim(bike_rides)


