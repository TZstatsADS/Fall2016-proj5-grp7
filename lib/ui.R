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
                  
                  menuItem("mapping", tabName = "mapping", icon = icon("map")
                  )
                  
                )
                ),
                dashboardBody(
                  
                  tabItem(tabName = "mapping",
                          leafletOutput("map2",height = 800))
          
                  )
                )
                
  )
  








