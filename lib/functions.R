
#####
## Arrow painting function ##
#####

## 1. map has to be a leaftlet map, already defined in a variable

## 2. Arrow.data has to have the following columns:
# pickup_lon
# pickup_lat
# dropoff_lon
# dropoff_lat
# total.count

## This function draws the arrow heads
get.arrowhead <- function(origin, destination){
  
  # Convert to numeric without names
  origin <- as.numeric(origin)
  destination <- as.numeric(destination)
  
  # Vector with direction of arrow.
  dx <- destination[1] - origin[1]
  dy <- destination[2] - origin[2]
  
  # normalize
  length <- sqrt(dx * dx + dy * dy)
  unitDx <- dx / length
  unitDy <- dy / length
  
  # increase this to get a larger arrow head
  arrowHeadBoxSize = 0.001
  
  # These are the coordinates to paint the arrow head (basically 2 lines)
  x1 = (destination[1] - unitDx * arrowHeadBoxSize - unitDy * arrowHeadBoxSize)
  y1 = (destination[2] - unitDy * arrowHeadBoxSize + unitDx * arrowHeadBoxSize)
  x2 = (destination[1] - unitDx * arrowHeadBoxSize + unitDy * arrowHeadBoxSize)
  y2 = (destination[2] - unitDy * arrowHeadBoxSize - unitDx * arrowHeadBoxSize)
  
  final.matrix <- matrix(c(x1, y1, destination[1], destination[2], 
                           x2, y2, destination[1], destination[2]), 
                         ncol = 4, byrow = TRUE)
  return(final.matrix)
}


## This function generates a curved arc, given an origin and destination.
# Curve is based on a circle
# A: starting lon&lat in c(lon,lat) format; B: ending lon&lat, same as A
# intensity: 1,2,3,...,10, lower intensity represents higher circle radius, 
#            and the curve is more close to straight line
# num_node: number of nodes to return, higher value will yield smoother curve
Get_curve <- function(A,B,intensity,num_node) {
  Calc_theta <- function(A,B) 
  {
    dis <- sqrt((A[1]-B[1])^2+(A[2]-B[2])^2)
    theta <- asin(abs((B[2]-A[2])/dis))
    theta <- ifelse(A[1]>B[1],ifelse(A[2]<B[2],pi/2-theta+pi/2,theta+pi),ifelse(A[2]<B[2],theta,pi/2-theta+pi*1.5))
    return(theta)
  }
  if (A[1]==B[1]&A[2]==B[2]) return(cbind(rep(A[1],num_node),rep(A[2],num_node)))
  else {
  if(intensity>10) 
    intensity=10
  if(intensity<1) 
    intensity=1
  
  find_radius=c(5,1.6,1,0.78,0.65,0.58,0.54,0.518,0.505,0.5000001) 
  radius=find_radius[round(intensity)]

  dis <- sqrt((A[1]-B[1])^2+(A[2]-B[2])^2)
  height <- dis*sqrt(radius^2-0.25)
  theta <- Calc_theta(A,B)
  circlecenter <- c((A[1]+B[1])/2+height*sin(theta),(A[2]+B[2])/2-height*cos(theta))   
  curve_start <- Calc_theta(circlecenter,A)
  curve_end <- Calc_theta(circlecenter,B)
  #browser()
  
  
 if( abs(curve_start - curve_end) >= (curve_start + 2*pi - curve_end) ){
    curve_start <- curve_start+2*pi
 } 

  angle <- seq(curve_start,curve_end,length.out=num_node)
  path <- cbind(circlecenter[1]+radius*dis*cos(angle),circlecenter[2]+radius*dis*sin(angle))

  return(path)}
}

## This function paints the line segment. Calls the arrow head 
paint.arrows <- function(map, arrow.data){

  #arrow.data <- as.matrix(arrow.data)
  
  for(i in 1:nrow(arrow.data)){
    
    # Get Data from row
    lng.x = c(arrow.data[i,1], arrow.data[i,3])
    lat.x = c(arrow.data[i,2], arrow.data[i,4])
    weight.x = arrow.data[i,6]
    maxweight = max(arrow.data[,6])
    line.weight = as.numeric(weight.x / maxweight * 20)
    
    taxi.color <- ""
    if(arrow.data[i,5] == "yellow"){
      taxi.color <- "orange"
    }
    else{
      taxi.color <- arrow.data[i,5]
    }
    
    # Prepare data to draw curve
    origin <- c(arrow.data[i,1], arrow.data[i,2])
    dest <- c(arrow.data[i,3], arrow.data[i,4])

    # Generate curve
    
    num_node <- 100
    intensity <- 4
    curve.to.draw <- Get_curve(A = origin, B = dest, intensity, num_node)
    
    # Paint line, represented by each of the segments of the curve

      map <- addPolylines(map, 
                          lng = curve.to.draw[,1], 
                          lat = curve.to.draw[,2], 
                          weight = line.weight, 
                          color = taxi.color)      
    

    
    #head(ride.counts.filter.threshold)    
    ## Paint Arrow Heads
    
    # Get Data of arrow head
    arrow.head <- get.arrowhead(origin = curve.to.draw[(num_node-1),],
                                destination = curve.to.draw[(num_node),])
    
    # Check if we had errors (possible because origin and destination are the same)
    error.values <- sum(is.na(arrow.head))
    
    # If everything OK, we calculate and paint
    if(error.values == 0){
      lng.arrow.1 <- c(arrow.head[1,1], arrow.head[1,3])
      lat.arrow.1 <- c(arrow.head[1,2], arrow.head[1,4])
      lng.arrow.2 <- c(arrow.head[2,1], arrow.head[2,3])
      lat.arrow.2 <- c(arrow.head[2,2], arrow.head[2,4])
      
      # Paint Arrow Head
      map <- addPolylines(map, lng = lng.arrow.1, lat = lat.arrow.1, 
                          weight = line.weight, color = taxi.color)    
      map <- addPolylines(map, lng = lng.arrow.2, lat = lat.arrow.2, 
                          weight = line.weight, color = taxi.color)        
    }
  }  
  
  return(map)
}