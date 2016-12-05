sidebar <- dashboardSidebar(tags$head(tags$style(HTML('.main-header .logo {font-family: "Britannic Bold",Britannic Bold, 
                                                           "Britannic Bold", serif;font-weight: bold;font-size: 22px;}'
)
)
),
  sidebarMenu(
    menuItem("Interactive Map", tabName = "Map", icon = icon("map")),
    menuItem("EDA", icon = icon("th"), tabName = "EDA",
             badgeLabel = "new", badgeColor = "green")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "Map",
            leafletOutput("map2", width = "100%", height = 900),
            div(class="outer",
                tags$head(
                  includeCSS("styles.css")
                ),
            absolutePanel(id = "controls",class = "panel panel-default", fixed = TRUE,
                          draggable = TRUE, top = 70, left = 300, right = "auto", bottom = "auto",
                          width = 330, height = "auto",
                          sliderInput("slider2", label = h3("24-hour Range"), min = 0, 
                                      max = 24, value = c(2, 16), step = 2),
                          sliderInput("slider1", label = h3("Threshold"), min = 0, 
                                      max = 300000, value = c(50, 300000))
            ))
    ),
    
    tabItem(tabName = "EDA",
            h2("Widgets tab content")
            
    )
  )
)


dashboardPage(skin = "black",dashboardHeader(title = "NYC TAXI"),
  sidebar,
  body
)