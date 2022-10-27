---
title: 'Cyclistic and Data Visualization: "Advanced, Straightforward, and Peeled"
  (Case Study)'
author: "Praveen Choragudi"
date: "`r Sys.Date()`"
output: html_document
---
## Cyclistic Bikes Full Year Analysis from Q4 of 2021 to Q3 of 2022

Based on Kevin Hartman's "'Sophisticated, Clear, and Polished': Divvy and Data Visualization" Divvy case study, which can be found at https://artscience.blog/home/divvy-dataviz-case-study, this analysis. This script's goal is to compile the Cyclistic data that has been obtained into a single dataframe and then perform a quick analysis to shed light on the fundamental question: "How do members and casual riders use Cyclistic bikes differently?"

Welcome to the case study on Cyclistic's bike sharing programme! which is a fictitious business. We will use the steps of the data analysis process—ask, prepare, process, analyse, communicate, and act—to provide answers to the important business issues. You may keep on track by using the Case Study Roadmap tables, which include directional questions and important tasks.

Install required packages
* tidyverse for data import and wrangling
* lubridate for date functions
* ggplot for visualization

## STEP 1: COLLECTING DATA

#### Preparing quarterly data by merging multiple csv files 

* preparing file for Q4 of 2021
* preparing file for Q1 of 2022
* preparing file for Q2 of 2022
* preparing file for Q3 of 2022


## STEP 2: WRANGLING DATA AND COMBINING INTO A SINGLE FILE

* Comparing column names each of the files. While the names don't have to be in the same order, they DO need to match perfectly before we can use a command to join them into one file.
* Inspecting the dataframes and looking for incongruencies
* Stacking individual quarter's data frames into one big data frame
* Removing lat, long, and gender fields as this data was dropped beginning in 2020

## STEP 3: CLEANING UP AND ADDING DATA TO PREPARE FOR ANALYSIS

* Inspecting the new table that has been created
* Adding columns that list the date, month, day, and year of each ride which allows us to aggregate ride data for each month, day, or year before completing these operations we could only aggregate at the ride level more on date formats in R found at that [link](https://www.statmethods.net/input/dates.html).
* Adding a "ride_length" [calculation](https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html) to all_trips (in seconds) 
* Inspecting the structure of the columns
* Converting "ride_length" from Factor to numeric so we can run calculations on the data
* Removing "bad" data. The [dataframe](https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/) includes a few hundred entries when bikes were taken out of docks and checked for quality by Cyclistic or ride_length was negative. We will create a new version of the dataframe (v2) since data is being removed.


## STEP 4: CONDUCTING DESCRIPTIVE ANALYSIS

* Descriptive analysis on ride_length (all figures in seconds)
* We can condense the four lines above to one line using summary() on the specific attribute
* Comparing members and casual users
* We can see the average ride time by each day for members vs casual users
* Notice that the days of the week are out of order. Let's fix that.
* Now, let's run the average ride time by each day for members vs casual users
* Analyzing ridership data by type and weekday


## STEP 5: EXPORTING SUMMARY FILE FOR FURTHER ANALYSIS


###### THANK YOU 
