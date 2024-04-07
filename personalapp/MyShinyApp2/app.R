library(shiny)
hss <- read.csv("Project_RunOver.csv")
fluidPage(    
  titlePanel("Type of Reptile Roadkill"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("reptile", "Reptile:", 
                  choices = hss$Which.of.the.following.groups.best.describes.the.roadkill.found.),
      hr(),
      helpText("Data from Herpetological Society of Singapore")
    ),
    
    # Create a spot for the barplot
    mainPanel(
      plotOutput("barplot")  
    )
    
  )
)

function(input, output) {
  
  # Fill in the spot we created for a plot
  output$barplot <- renderPlot({
    
    # Render a barplot
    barplot(hss[,input$reptile]*1000, 
            main=input$reptile,
            ylab="Number of Roadkill",
            xlab="Year")
  })
}

shinyApp(ui = ui, server = server)