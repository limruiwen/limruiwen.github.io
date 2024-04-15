library(shiny)
library(readr)
library(dplyr)
library(stringr)


data <- read.csv("Project_RunOver2.csv")
unique_species <- data$If.you.are.able.to.provide.a.more.specific.ID..please.do.so.here. %>%
  na.omit() %>% unique()
first_five_species <- unique_species[1:5]
choices <- str_replace_all(setNames(first_five_species, first_five_species), " ", "")


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
    imagePath <- paste0("www/", input$imageChoice, ".jpeg")
    print(imagePath)
    # Return the image list to renderImage
    list(src = imagePath,
         width = "100%",
         height = "auto",
         alt = "This is an image")
  }, deleteFile = FALSE)
}

shinyApp(ui = ui, server = server)
