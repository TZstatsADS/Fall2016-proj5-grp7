library(shiny)
library(leaflet)
library(shinydashboard)

shinyUI(
  dashboardPage(skin = "yellow", 
                dashboardHeader(title = "NYC TAXI"),
                dashboardSidebar(tags$head(tags$style(HTML('.main-header .logo {font-family: "Britannic Bold",Britannic Bold, 
                                                           "Britannic Bold", serif;font-weight: bold;font-size: 22px;}'
                )
                )
                ),
                
                sidebarMenu(
                  
                  menuItem("mapping", tabName = "mapping", icon = icon("map"),
                           sliderInput("slider2", label = h3("24-hour Range"), min = 0, 
                                       max = 24, value = c(2, 16), step = 2),
                           sliderInput("slider1", label = h3("Threshold"), min = 0, 
                                       max = 300000, value = c(50, 300000))
                  )
                  
                )
                ),
                dashboardBody(
                  
                  tabItem(tabName = "mapping",
                          leafletOutput("map2",height = 800))
          
                  )
                )
                
  )
  








