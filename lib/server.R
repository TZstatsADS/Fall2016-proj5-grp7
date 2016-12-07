library(leaflet)
library(shiny)
library(readr)
library(dplyr)
library(plotly)

shinyServer(function(input,output){
  
  ride.counts <- read_csv("count_table_total.csv")
  # ride.counts.all <- ride.counts %>% 
  #   dplyr::group_by(pickup_lon, pickup_lat, dropoff_lon, dropoff_lat, time_interval) %>%
  #   dplyr::summarise(total.count = sum(n))
  
  # minthreshold <- eventReactive(input$button,{
  #   minthreshold <- input$slider1[1]
  # })
  # 
  # maxthreshold <- eventReactive(input$button,{
  #   maxthreshold <- input$slider1[2]
  # })

  topPopular <- eventReactive(input$button,{
    topPopular <- as.numeric(input$topPop)
  })
  minhour <- eventReactive(input$button,{
    minhour <- input$slider2[1]
  })
  maxhour <- eventReactive(input$button,{
    maxhour <- input$slider2[2]
  })
  color_select <- eventReactive(input$button,{
    color_select <- input$taxi_color
  })
  
  ride.counts.filter.threshold <- eventReactive(input$button,{
    ride.counts.all <- ride.counts %>%
      filter(color %in% color_select()) %>% 
      filter(time_interval >= minhour() & time_interval <= maxhour())
    ride.counts.all$n <- as.numeric(ride.counts.all$n)
    ride.counts.all <- ride.counts.all %>%
      group_by(pickup_lon, pickup_lat, dropoff_lon, dropoff_lat, color)%>%
      summarise(n = sum(n)) %>% as.data.frame()
    ride.counts.filter.threshold <- ride.counts.all %>% top_n(topPopular())
   
  # ride.counts.all <- ride.counts %>%
  #   filter(n >= minthreshold() & n < maxthreshold()) %>%
  #   filter(time_interval >= minhour() & time_interval <= maxhour()) %>% as.data.frame()
  # ride.counts.all$n <- as.numeric(ride.counts.all$n)
  # ride.counts.filter.threshold <- ride.counts.all[,-c(1:3)]
  
  # ride.counts.filter.threshold[,6] <- as.integer(as.character(ride.counts.filter.threshold[,6]))
  })
  
  # ride.counts.filter.threshold <- reactive({ride.counts.filter.threshold <- ride.counts.filter.threshold[ride.counts.filter.threshold$color %in% color_select(),]})
                                          
  
  
  # ride.counts.filter.threshold <- reactiveValues()
  # ride.counts.filter.threshold$data <- as.matrix(ride.counts.all) 
  # observe({
  #   if(input$update){
  #     minthreshold <- input$slider1[1]
  #     maxthreshold <- input$slider1[2]
  #     ride.counts.filter.threshold$data <- ride.counts.all %>% dplyr::filter(total.count >= minthreshold) %>% as.matrix()
  #  }
  # })
  # ride.counts.filter.threshold <- eventReactive(
  #   input$update,
  #   {
  #     minthreshold <- input$slider1[1]
  #     maxthreshold <- input$slider1[2]
  #     ride.counts.filter.threshold <- ride.counts.all %>%
  #     dplyr::filter(total.count >= minthreshold) %>% as.matrix()
  #     }, ignoreNULL = FALSE)
  # print(isolate(ride.counts.filter.threshold()))
  
  # ride.counts.filter.threshold <- ride.counts.all %>%
  #   filter(total.count >= 5000) #%>% as.matrix()
  
  get.arrowhead <- function(data.line){
    
    # Convert to numeric without names
    data.line <- as.numeric(data.line)
    
    # Vector with direction of arrow.
    dx <- data.line[3] - data.line[1]
    dy <- data.line[4] - data.line[2]
    
    # normalize
    length <- sqrt(dx * dx + dy * dy)
    unitDx <- dx / length
    unitDy <- dy / length
    
    # increase this to get a larger arrow head
    arrowHeadBoxSize = 0.001
    
    # These are the coordinates to paint the arrow head (basically 2 lines)
    x1 = (data.line[3] - unitDx * arrowHeadBoxSize - unitDy * arrowHeadBoxSize)
    y1 = (data.line[4] - unitDy * arrowHeadBoxSize + unitDx * arrowHeadBoxSize)
    x2 = (data.line[3] - unitDx * arrowHeadBoxSize + unitDy * arrowHeadBoxSize)
    y2 = (data.line[4] - unitDy * arrowHeadBoxSize - unitDx * arrowHeadBoxSize)
    
    final.matrix <- matrix(c(x1, y1, data.line[3], data.line[4], 
                             x2, y2, data.line[3], data.line[4]), 
                           ncol = 4, byrow = TRUE)
    return(final.matrix)
  }
  
  
  
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
      
      # Paint line
      map <- addPolylines(map, lng = lng.x, lat = lat.x, weight = line.weight, color = taxi.color)
      
      #head(ride.counts.filter.threshold)    
      ## Paint Arrow Heads
      
      # Get Data of arrow head
      arrow.head <- get.arrowhead(arrow.data[i,1:4])
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
  
  n<-leaflet()%>%
    addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
             attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
    )%>%
    setView(lng = -73.97, lat = 40.75, zoom = 13)
  
  # n=paint.arrows(n, ride.counts.filter.threshold)
  output$map2 <- renderLeaflet({
    # n <- Leaflet$new()
    # n$setView(c(40.75,-73.97),zoom = 13)
    # n$tileLayer(provider='Stamen.TonerLite') 
    #   addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
    #            attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
    #   )%>%
    #   setView(lng = -73.97, lat = 40.75, zoom = 13)
    m <- ride.counts.filter.threshold()
    map <- paint.arrows(n, m)
    map
    # output$map2 <- renderLeaflet({
    # leaflet()%>%
    #   addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
    #            attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
    #   )%>%
    #   # addProviderTiles("Stamen.Watercolor") %>%
    #   setView(lng = -73.97, lat = 40.75, zoom = 13)
  })
  #########################################################################################################
  
  
  library(ggplot2)
  library(scales)
  library(plotly)
  taxi_time_table <- read.csv("taxi_time_table.csv")
  bar_t <- function(Y){
    taxi_time_table$time_interval <- factor(taxi_time_table$time_interval,
                                            levels = c("0 - 2","2 - 4","4 - 6","6 - 8","8 - 10","10 - 12","12 - 14","14 - 16","16 - 18",
                                                       "18 - 20","20 - 22","22 - 24"))
    taxi <- taxi_time_table %>% filter(pickup_month == Y)
    plot_ly(data = taxi, x = ~time_interval,y = ~yellow, type = 'bar', name = 'pickups for yellow taxi',
            marker = list(color = 'yellow')) %>%
      add_trace(y = ~green, name = 'pickups for green taxi', marker = list(color = 'green')) %>%
      layout(title = paste("taxi pickups in NYC on",Y),
             xaxis = list(
               title = "",
               tickfont = list(
                 size = 14,
                 color = 'rgb(107, 107, 107)')),
             yaxis = list(
               title = 'pickup number',
               titlefont = list(
                 size = 16,
                 color = 'rgb(107, 107, 107)'),
               tickfont = list(
                 size = 14,
                 color = 'rgb(107, 107, 107)')),
             legend = list(x = 0, y = 1, bgcolor = 'rgba(255, 255, 255, 0)', bordercolor = 'rgba(255, 255, 255, 0)'),
             barmode = 'group', bargap = 0.15, bargroupgap = 0.1)
    
  } 
  output$taxi_time_table_plot <- renderPlotly({
    y <- input$table_month
    bar_plot <- bar_t(y)
  
  })
  
  
})