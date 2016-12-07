# ADS Final Project: 

**Term: Fall 2016**

+ Team Name:proj5 - grp 7
+ Projec title: How taxi networks NYC
+ Team members:Kezhi Cai
+              Shujin Cao
+	             Jaime Gacitua
+	             Zichen Wu
+	             Nianyao Zuo

**Project summary**: 

  NYC is one of the cities with both highest traffic volumn and highest business density. We are curious about how the business zones in NYC are connected with each other. To explore our thought, we built an R shiny app for the business intelligence purpose based on the NYC taxi data from 2015.7 ~2016.6. This app includes three parts: 1st part gives a map showing the direction of how taxi transfers within specific time interval and taxi types(green taxies or yellow taxies); 2nd part gives some EDA of the dataset we chose; and the last part shows the network of 263 business zones and the connections between the 6 borough in NYC.
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/How%20taxi%20networks%20NYC%20Screen%20Shot%20.png)
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/Screen%20Shot2.png)


**Contribution statement**:  

  All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 


**Data preparation**:

  The dataset we use is from https://github.com/toddwschneider/nyc-taxi-data . The origin dataset contains about 30 GB data of yellow taxies and 3 GB data of green taxies(includes the pickup time & coordinates, dropoff time & coordinates,trip distance,fare related variables,etc), each from 2015.7 ~ 2016.6.
 **1st Step: Shrinking dataset** 
  Given the huge size of the dataset, we decided to use stratified sampling method to shrink the dataset: we grouped the data by date(total 366 days) and sampled 1% data for the yellow taxi per day and 10% data for the green taxi per day. To balance the gap of the portion, we added an allocation flag variable, weighted the yellow taxi to 10 and green taxi to 1. 

  To prove our sampling is reasonable, we did some eda work to exam the shrinked dataset.
  From the histogram of the data we can see that the distribution of the pickups and dropoffs within each month behave pretty much simillar, below are part of the histogram of our dataset:
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/Screen%20Shot%202016-12-07%20at%2012.42.40%20PM.png)
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/Screen%20Shot%202016-12-07%20at%2012.44.14%20PM.png)
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/count%20distribution%20vs%20time.png)
  We also removed some outliers and NAhs from the data to keep the dataset more applicable.
 
 **2nd Step: Clustering business zone**
 
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/Screen%20Shot%202016-12-07%20at%2012.38.27%20PM.png)
