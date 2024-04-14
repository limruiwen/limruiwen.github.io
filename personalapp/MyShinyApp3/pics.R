library(shiny)
library(readr)
library(dplyr)

data <- read.csv("Project_RunOver.csv")
unique_species <- data$If.you.are.able.to.provide.a.more.specific.ID..please.do.so.here. %>%
  na.omit() %>%
  unique()
first_five_species <- unique_species[1:5]
choices <- setNames(first_five_species, first_five_species)


ui <- fluidPage(
  titlePanel("Interactive Reptile Image Viewer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("imageChoice", "Choose a Reptile:",
                  choices = choices)
    ),
    mainPanel(
      imageOutput("selectedImage")
    )
  )
)

server <- function(input, output) {
  output$selectedImage <- renderImage({
    # Assuming images are stored and named according to the species IDs
    imagePath <- normalizePath(file.path("www", paste0(input$imageChoice, ".jpeg")))
    
    # Return the image list to renderImage
    list(src = imagePath,
         contentType = 'image/jpeg',
         width = "100%",
         height = "auto",
         alt = "This is an image")
  }, deleteFile = FALSE)
}

shinyApp(ui = ui, server = server)
