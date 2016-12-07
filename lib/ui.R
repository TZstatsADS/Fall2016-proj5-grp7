library(shinydashboard)
library(leaflet)
topChoices <- c(1,5,10,20,50,100,500,1000)
sidebar <- dashboardSidebar(tags$head(tags$style(HTML('.main-header .logo {font-family: "Britannic Bold",Britannic Bold, 
                                                      "Britannic Bold", serif;font-weight: bold;font-size: 22px;}'
)
)
),
sidebarMenu(
  menuItem("Interactive Map", tabName = "Map", icon = icon("map")),
  menuItem("EDA", icon = icon("th"), tabName = "EDA",badgeLabel = "new", badgeColor = "green"),
  menuItem("Popularity in Words", icon("th"),tabName="Popularity")
)
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "Map",
            leafletOutput("map2", width = "100%", height = 900),
            # plotOutput("map2"),
            div(class="outer",tags$head(includeCSS("styles.css")),
                absolutePanel(id = "controls",class = "panel panel-default", fixed = TRUE,
                              draggable = TRUE, top = 70, left = 300, right = "auto", bottom = "auto",
                              width = 330, height = "auto",
                              sliderInput("slider2", label = h3("24-hour Range"), min = 0, max = 22, value = c(4, 6), step = 2),
                              # sliderInput("slider1", label = h3("Threshold"), min = 1000, max = 4000, value = c(500, 4500), step = 100),
                              
                              selectInput("topPop", label = h3("Number of TOP Popular Routes"), as.numeric(topChoices),selected = 50),
                              # checkboxInput(inputId = "color_yellow",label = h3("Show Yellow Taxi"),value = FALSE),
                              # checkboxInput(inputId = "color_green",label = h3("Show Green Taxi"),value = TRUE),
                              checkboxGroupInput("taxi_color", h3("Show"),choices = c("Yellow Taxi" = "yellow", "Green Taxi" = "green"),selected = c("yellow","green")),
                              actionButton("button", 'UPDATE', icon = shiny::icon('calendar'), style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                ))
            
    ),
    tabItem(tabName = "EDA",h2("Widgets tab content"),
            selectInput(inputId = "table_month",label = "PICK YEAR-MONTH:", 
                        choices = c("2015-07","2015-08","2015-09","2015-10","2015-11","2015-12","2016-01","2016-02","2016-03","2016-04","2016-05","2016-06")),
            plotlyOutput("taxi_time_table_plot")))
)

dashboardPage(skin = "black",dashboardHeader(title = "NYC TAXI"),sidebar,body
)