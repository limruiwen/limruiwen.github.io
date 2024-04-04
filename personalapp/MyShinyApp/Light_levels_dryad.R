library(shiny)
library(leaflet)
library(sf)
library(tidyverse)
library(readr)
library(lubridate)
library(stringr)


#datasets
cleveland <- read.csv("Cleveland_collision_data.csv")
chicago <- read.csv("Chicago_collision_data.csv")
lightlevels <- read.csv("Light_levels_dryad.csv")
hss <- read.csv("Project_RunOver.csv") %>% na.omit()

#extracting year
temp <- str_split(hss$Date.of.Encounter, "/", simplify = T)
temp[,3] <- ifelse(str_length(temp[,3]) == 2, paste0("20", temp[,3]), temp[,3])
hss$Date.of.Encounter <- ymd(paste0(temp[,3], "-", temp[,1], "-", temp[,2]))
hss$year_val <- year(hss$Date.of.Encounter)

temp <- str_split(hss$Google.Maps.Plus.Codes, ",")
hss$lat <- as.numeric(sapply(temp, function(x) x[1]))
hss$long <- as.numeric(sapply(temp, function(x) x[2]))

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    # year slider 
    sidebarPanel(sliderInput("slidinp","Year:", min = 2017, max = 2024, value = c(2017, 2018))),
    mainPanel(leafletOutput(outputId = "map"))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  #year slider
  output$map = renderLeaflet({
    df <- hss %>% filter(year_val >= input$slidinp[1], year_val <= input$slidinp[2])
    leaflet() %>%
      addTiles() %>%
      setView(lng = 103.8198, lat = 1.3521, zoom = 12) %>%
      addCircleMarkers(data = df,
                       lng = ~long,
                       lat = ~lat,)
    
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

