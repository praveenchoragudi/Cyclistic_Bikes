### Cyclistic_Bike_Share analysis for Q4 of 2021 and Q1-Q3 of 2022 ###


# This analysis is based on the Divvy case study "'Sophisticated, Clear, and Polished’: Divvy and Data Visualization" written by Kevin Hartman (found here: https://artscience.blog/home/divvy-dataviz-case-study). The purpose of this script is to consolidate downloaded Divvy data into a single dataframe and then conduct simple analysis to help answer the key question: “In what ways do members and casual riders use Cyclistic bikes differently?”


# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# lubridate for date functions
# ggplot for visualization
# # # # # # # # # # # # # # # # # # # # # # #  


library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
getwd() #displays your working directory
#setwd("/Users/kevinhartman/Desktop/Divvy_Exercise/csv") 


### Preparing quarterly data by merging multiple csv files

# preparing file for Q4 of 2021
library(data.table)
setwd("~/Desktop/Cyclistic_Bikes/Cyclistic_Bike_Share/Data/Trips/2021")
files<-list.files(pattern = ".csv")
temp<-lapply(files,fread,sep=",")
data<-rbindlist(temp)
write.csv(data,file="Cyclistic_Trips_2021_Q4.csv",row.names = FALSE)

# preparing file for Q1 of 2022
library(data.table)
setwd("~/Desktop/Cyclistic_Bikes/Cyclistic_Bike_Share/Data/Trips/2022/Q1")
files<-list.files(pattern = ".csv")
temp<-lapply(files,fread,sep=",")
data<-rbindlist(temp)
write.csv(data,file="Cyclistic_Trips_2022_Q1.csv",row.names = FALSE)

# preparing file for Q2 of 2022
library(data.table)
setwd("~/Desktop/Cyclistic_Bikes/Cyclistic_Bike_Share/Data/Trips/2022/Q2")
files<-list.files(pattern = ".csv")
temp<-lapply(files,fread,sep=",")
data<-rbindlist(temp)
write.csv(data,file="Cyclistic_Trips_2022_Q2.csv",row.names = FALSE)

# preparing file for Q3 of 2022
library(data.table)
setwd("~/Desktop/Cyclistic_Bikes/Cyclistic_Bike_Share/Data/Trips/2022/Q3")
files<-list.files(pattern = ".csv")
temp<-lapply(files,fread,sep=",")
data<-rbindlist(temp)
write.csv(data,file="Cyclistic_Trips_2022_Q3.csv",row.names = FALSE)


#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload Divvy datasets (csv files) here

q4_2021 <- read_csv("Cyclistic_Trips_2021_Q4.csv")
q1_2022 <- read_csv("Cyclistic_Trips_2022_Q1.csv")
q2_2022 <- read_csv("Cyclistic_Trips_2022_Q2.csv")
q3_2022 <- read_csv("Cyclistic_Trips_2022_Q3.csv")


#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Compare column names each of the files
# While the names don't have to be in the same order, they DO need to match perfectly before we can use a command to join them into one file
colnames(q4_2021)
colnames(q1_2022)
colnames(q2_2022)
colnames(q3_2022)

# Inspect the dataframes and look for incongruencies
str(q4_2021)
str(q1_2022)
str(q2_2022)
str(q3_2022)


# Stack individual quarter's data frames into one big data frame
all_trips <- bind_rows(q4_2021, q1_2022, q2_2022, q3_2022)


# Remove lat, long, and gender fields as this data was dropped beginning in 2020
all_trips <- all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng))


#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Inspect the new table that has been created
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame.  Also tail(all_trips)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics


# Add columns that list the date, month, day, and year of each ride
# This will allow us to aggregate ride data for each month, day, or year ... before completing these operations we could only aggregate at the ride level
# https://www.statmethods.net/input/dates.html more on date formats in R found at that link
all_trips$date <- as.Date(all_trips$started_at) #The default format is yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")


# Add a "ride_length" calculation to all_trips (in seconds)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html
all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)


# Inspect the structure of the columns
str(all_trips)


# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

str(all_trips$ride_length)


# Remove "bad" data
# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative
# We will create a new version of the dataframe (v2) since data is being removed
# https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
all_trips_v2 <- all_trips[!(all_trips$ride_length<=0),]


#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Descriptive analysis on ride_length (all figures in seconds)
mean(all_trips_v2$ride_length) #straight average (total ride length / rides)
median(all_trips_v2$ride_length) #midpoint number in the ascending array of ride lengths
max(all_trips_v2$ride_length) #longest ride
min(all_trips_v2$ride_length) #shortest ride


# You can condense the four lines above to one line using summary() on the specific attribute
summary(all_trips_v2$ride_length)


# Compare members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)


# See the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)


# Notice that the days of the week are out of order. Let's fix that.
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))


# Now, let's run the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

str(all_trips_v2)

# analyze ridership data by type and weekday
all_trips_v2 %>% 
  group_by(member_casual, day_of_week) %>%                #groups by usertype and weekday
  summarise(number_of_rides = n()                         #calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>%    # calculates the average duration
  arrange(member_casual, day_of_week)                     # sorts


# Let's visualize the number of rides by rider type
all_trips_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, day_of_week)  %>% 
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")


# Let's create a visualization for average duration
all_trips_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, day_of_week)  %>% 
  ggplot(aes(x = day_of_week, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")


#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file that we will visualize in Excel, Tableau, or my presentation software
# N.B.: This file location is for a Mac. If you are working on a PC, change the file location accordingly (most likely "C:\Users\YOUR_USERNAME\Desktop\...") to export the data. You can read more here: https://datatofish.com/export-dataframe-to-csv-in-r/
counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)
write.csv(counts, file = '~/Desktop/Cyclistic_Bikes/avg_ride_length.csv')

chart1<-read.csv("avg_ride_length.csv")
colnames(chart1)<-c("Count","User_Type","Day_of_the_Week","Trip_Duration_in_Seconds")
colnames(chart1)
library(ggplot2)
ggplot(data=chart1)+geom_point(mapping = aes(x=Day_of_the_Week,y=Trip_Duration_in_Seconds, color=User_Type,shape=User_Type))+labs(title ="Usage by Members and Casual riders" ,subtitle ="Frequency of trip time between User Types",caption = "Data is from Q4(2021) and Q1-Q4(2022)")
