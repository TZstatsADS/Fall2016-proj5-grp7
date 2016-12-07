# ADS Final Project: 

**Term: Fall 2016**

+ Team Name:proj5 - grp 7
+ Projec title: How taxi networks NYC
+ Team members:
	* Kezhi Cai
	* Shujin Cao
	* Jaime Gacitua
	* Zichen Wu
	* Nianyao Zuo

**Project summary**: 

**Contribution statement**:
+ Kezhi focused on sampling the raw data and arrow drawing, 
+ Shujin developed the shiny app, 
+ Jaime focused on arrow drawing and app design, 
+ Nianyao focused on sampling the raw data and generated network graphs, 
+ Zichen presented.


NYC is one of the cities with both highest traffic volumn and highest business density. We are curious about how the business zones in NYC are connected with each other. To explore our thought, we built an R shiny app for the business intelligence purpose based on the NYC taxi data from 2015.7 ~2016.6. This app includes three parts: 1st part gives a map showing the direction of how taxi transfers within specific time interval and taxi types(green taxies or yellow taxies); 2nd part gives some EDA of the dataset we chose; and the last part shows the network of 263 business zones and the connections between the 6 borough in NYC.

![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/How%20taxi%20networks%20NYC%20Screen%20Shot%20.png)


**Data preparation**:

  The dataset we use is from https://github.com/toddwschneider/nyc-taxi-data . The origin dataset contains about 30 GB data of yellow taxies and 3 GB data of green taxies( includes the pickup time & coordinates, dropoff time & coordinates,trip distance,fare related variables,etc), each from 2015.7 ~ 2016.6.

**1st Step: Shrinking dataset** 
  Given the huge size of the dataset, we decided to use stratified sampling method to shrink the dataset: we grouped the data by date(total 366 days) and sampled 1% data for the yellow taxi per day and 10% data for the green taxi per day. To balance the gap of the portion, we added an allocation flag variable, weighted the yellow taxi to 10 and green taxi to 1. 

  To prove our sampling is reasonable, we did some eda work to exam the shrinked dataset.
  From the histogram of the data we can see that the distribution of the pickups and dropoffs within each month behave pretty much simillar, below are part of the histogram of our dataset:
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/Screen%20Shot%202016-12-07%20at%2012.42.40%20PM.png)
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/Screen%20Shot%202016-12-07%20at%2012.44.14%20PM.png)
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/count%20distribution%20vs%20time.png)
  We also removed some outliers and NAhs from the data to keep the dataset more applicable.
 
 **2nd Step: Clustering business zone**
 
 Inspired by the Uber data analysis in https://github.com/fivethirtyeight/uber-tlc-foil-response, we decided to cluster our data's coordinate into 263 centers( includes: Pelham Parkway", " Penn Station/Madison Sq West", "Port Richmond", "Prospect-Lefferts Gardens", "Prospect Heights", "Prospect Park", "Queens Village", "Queensboro Hill" , etc). This part's calculation is based on distance.
 
 **3rd Step: Creating the count table for spacial visualization purpose**
 
  The count table we use includes 9nvariables: pickup_zone"   "dropoff_zone", "time_interval", "pickup_lon", "pickup_lat",    "dropoff_lon", "dropoff_lat", "color" and "n"(represents the number of drive).

**Data visualization: map with arrows**:

  We try to use arrows on NYC map to represent the flow of taxies, with the help of R leaflet. The arrows connect the pickup and dropoff locations and has different:
    1. Color: red shows yellow cabs, and green shows boro cabs
    2. Width: bigger arrow stands for heavier traffic
    3. Curvature
  In order to show roundtrips more clearly, we give curvature to our arrows. Each curve is made by splicing a number of polylines. 
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/Screen%20Shot2.png)
What we find interesting from this analysis is 
1: The population taking taxies tend to grow on summer night comparing to winter night.
2: On specific time interval, we can see some flowing ouside in some places( for instance: 6 pm in time squares) and some    flowing inside ( weekend days afternoon in flushing)

**Data visualizastion: network graph**:

  Though some zones have crazy pickup numbers, these rides actually within the zone itself and has poor connection with other business zones. What we focused on is actually the connection between zones and the interesting stories between these connections.
  To explore the connection between the zones, we built a network graph to show the relations within these business zones. 
  The different colors show the six different boroughs and the the sizes of the nodes grow as the connection numbers enlarge.
  Moreover, the nodes close to the center have heavier traffic connection with others.
![screenshot](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp7-1/blob/master/figs/Screen%20Shot%202016-12-07%20at%2012.38.27%20PM.png)

From the network gragh we can see within each borough the cnnection is quite close and the highest density is Manhattan.
