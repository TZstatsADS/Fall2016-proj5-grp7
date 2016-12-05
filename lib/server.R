library(leaflet)
library(shiny)


shinyServer(function(input,output){
  
  
  output$map2 <- renderLeaflet({
    leaflet()%>% 
      addTiles(urlTemplate = "https://api.mapbox.com/styles/v1/jackiecao/ciu0jcgy800ah2ipgpsw5usmi/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiamFja2llY2FvIiwiYSI6ImNpdTBqYXhmcjAxZ24ycGp3ZWZ1bTJoZ3QifQ.VytIrn5ZxVjtZjM15JPA9Q",
               attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      )%>%
      # addProviderTiles("Stamen.Watercolor") %>% 
      setView(lng = -73.97, lat = 40.75, zoom = 13)  
  })
  output$hourrange <- renderPrint({ input$slider2 })
  output$threshold <- renderPrint({ input$slider1 })
})