library("data.table")
library("dplyr")
library("tidyr")
library("ggmap")
library("ggplot2")
library("leaflet")
setwd("/Users/caikezhi/Desktop/Project5/Green")
sampled.green <- fread("sampled_green.csv")

#####################################################################
zone <- read.csv(url("https://raw.githubusercontent.com/fivethirtyeight/uber-tlc-foil-response/master/uber-trip-data/taxi-zone-lookup.csv"))
zone <- zone[-c(264,265),]
zone[,4] <- sprintf("%s,%s",zone[,2],zone[,3])
zone[1,4] <- as.character(zone[1,3])
zone[59,4]=as.character(zone[59,3])
zone[234,4]=as.character(zone[234,3])
zone.ll=sapply(zone[,4],geocode)
zone.ll[,59]=c(-73.89224,40.83664)
zone.ll=t(zone.ll)
zone.ll=unlist(zone.ll)
num=length(zone.ll)/2

zone.lnglat=matrix(NA,nrow=num,ncol=3)
zone.lnglat[,1] <- zone.ll[1:num]
zone.lnglat[,2] <- zone.ll[(num+1):length(zone.ll)]
zone.lnglat[,3] <- 1:num

Find_zone <- function(position)
{
  Calc_distance <- function(x)
  {
    return(sqrt((position[1] - x[1])^2 + (position[2] - x[2])^2))
  }
  distances <- apply(zone.lnglat,1,Calc_distance)
  return(order(distances)[1])
}

pickup.location <- cbind(sampled.green$Pickup_longitude,sampled.green$Pickup_latitude)
dropoff.location <- cbind(sampled.green$Dropoff_longitude ,sampled.green$Dropoff_latitude)
a <- Sys.time()
pickup.id <- apply(pickup.location,1,Find_zone)
b <- Sys.time()
print(b-a)
dropoff.id <- apply(dropoff.location,1,Find_zone)
b <- Sys.time()
print(b-a)

sampled.green$pickup_region=pickup.id
sampled.green$dropoff_region=dropoff.id
write.csv(sampled.green,"sampled_green_with_region_id")

m <- leaflet() %>% setView(lng = -73.97396, lat =40.78870,zoom=12) 
m <- m %>% addTiles( 'https://api.mapbox.com/styles/v1/mapbox/streets-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoiam9leXRoZWRvZyIsImEiOiJjaW41MW5mNmYwY2NrdXJra2g4bmR3Y3dhIn0.5DzFBRvdn_9OHFmDFYwFmw')
#m <- m %>% addCircles(lng=pickup.location[1:100,1],lat=pickup.location[1:100,2],radius=50,col="red")
m <- m %>% addCircles(lng=sampled.green$Pickup_longitude[3],lat=sampled.green$Pickup_latitude[3],radius=500,col="red")
m <- m %>% addCircles(lng=zone.lnglat[33,1],lat=zone.lnglat[33,2],radius=500,col="black")
#m <- m %>% addPopups (lng=zone.lnglat[,1][240:263],lat=zone.lnglat[,2][240:263],as.character(zone.lnglat[,3][240:263]),options = popupOptions(minWidth = 2, closeOnClick = FALSE, closeButton = FALSE))
m

