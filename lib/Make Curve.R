# Curve is based on a circle
# A: starting lon&lat in c(lon,lat) format; B: ending lon&lat, same as A
# intensity: 1,2,3,...,10, lower intensity represents higher circle radius, 
#            and the curve is more close to straight line
# num_node: number of nodes to return, higher value will yield smoother curve
Get_curve <- function(A,B,intensity,num_node) 
{
  Calc_theta <- function(A,B) 
  {
    dis <- sqrt((A[1]-B[1])^2+(A[2]-B[2])^2)
    theta <- asin(abs((B[2]-A[2])/dis))
    theta <- ifelse(A[1]>B[1],ifelse(A[2]<B[2],pi/2-theta+pi/2,theta+pi),ifelse(A[2]<B[2],theta,pi/2-theta+pi*1.5))
    return(theta)
  }
  if (intensity>10) intensity=10
  if(intensity<1) intensity=1
  find_radius=c(5,1.6,1,0.78,0.65,0.58,0.54,0.518,0.505,0.5000001) 
  radius=find_radius[round(intensity)]
  dis <- sqrt((A[1]-B[1])^2+(A[2]-B[2])^2)
  height <- dis*sqrt(radius^2-0.25)
  theta <- Calc_theta(A,B)
  circlecenter <- c((A[1]+B[1])/2+height*sin(theta),(A[2]+B[2])/2-height*cos(theta))   
  curve_start <- Calc_theta(circlecenter,A)
  curve_end <- Calc_theta(circlecenter,B)
  if(abs(curve_start-curve_end)>(curve_start+2*pi-curve_end)) curve_start=curve_start+2*pi
  angle <- seq(curve_start,curve_end,length.out=num_node)
  path <- cbind(circlecenter[1]+radius*dis*cos(angle),circlecenter[2]+radius*dis*sin(angle))
  return(path)
}

#################   Visulization    ############
library(leaflet)
a=c(-74,40.8)
b=c(-73.966,40.76)
m <- leaflet() %>% setView(lng = -73.97396, lat =40.78870,zoom=12) 
m <- m %>% addTiles( 'https://api.mapbox.com/styles/v1/mapbox/streets-v9/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoiam9leXRoZWRvZyIsImEiOiJjaW41MW5mNmYwY2NrdXJra2g4bmR3Y3dhIn0.5DzFBRvdn_9OHFmDFYwFmw')
curve=Get_curve(a,b,4,50)
m <- m %>% addPolylines(lng=curve[,1],lat=curve[,2])
curve=Get_curve(a,b,8,50)
m <- m %>% addPolylines(lng=curve[,1],lat=curve[,2])
m

