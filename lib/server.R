library(leaflet)
library(shiny)
library(readr)
library(dplyr)
library(plotly)

shinyServer(function(input,output){
  
  ride.counts <- read_csv("count_table_total.csv")

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
      group_by(pickup_zone,dropoff_zone,pickup_lon, pickup_lat, dropoff_lon, dropoff_lat, color)%>%
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
  

  source("functions.R")
  
  n<-leaflet()%>%
    addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
             attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
    )%>%
    setView(lng = -73.97, lat = 40.75, zoom = 12)
  
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