library(shiny)
library(tidyverse)
hss <- read.csv("Project_RunOver.csv") %>% na.omit()

#extracting year
temp <- str_split(hss$Date.of.Encounter, "/", simplify = T)
temp[,3] <- ifelse(str_length(temp[,3]) == 2, paste0("20", temp[,3]), temp[,3])
hss$Date.of.Encounter <- ymd(paste0(temp[,3], "-", temp[,1], "-", temp[,2]))
hss$year_val <- year(hss$Date.of.Encounter)

temp <- str_split(hss$Google.Maps.Plus.Codes, ",")
hss$lat <- as.numeric(sapply(temp, function(x) x[1]))
hss$long <- as.numeric(sapply(temp, function(x) x[2]))

hss <- hss %>% 
  rename(animal = Which.of.the.following.groups.best.describes.the.roadkill.found.,
         species = If.you.are.able.to.provide.a.more.specific.ID..please.do.so.here.,
         )

ui <- fluidPage(    
  titlePanel("Type of Reptile Roadkill"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("reptile", "Reptile:", hss$animal, selected = T),
      hr(),
      helpText("Data from Herpetological Society of Singapore")
    ),
    
    # Create a spot for the barplot
    mainPanel(
      plotOutput("barplot")  
    )
    
  )
)

server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$barplot <- renderPlot({
    
    # Render a barplot
    hss %>% filter(animal == input$reptile) %>%
      mutate(year_val = as.factor(year_val)) %>%
      group_by(year_val) %>%
      count() %>%
      ggplot() +
      geom_col(aes(x = year_val, y = n, fill = year_val)) +
      theme_bw() +
      scale_fill_viridis_d()
  })
}

shinyApp(ui = ui, server = server)
