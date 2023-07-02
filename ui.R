# This application is created as peer-graded assignment
# for the Developing Data Products
# Vladimir Inyaev, 2023-06-28

library(shiny)
library(ggplot2)

# Define UI for application
fluidPage(

    # Application title
    titlePanel("Diamond apparaisal"),

    # Sidebar with diamond parameters
    sidebarLayout(
        sidebarPanel(
          fluidRow(
            helpText("This application uses the Diamonds dataset as the base to 
                     estimate the price of a new diamond with given parameters.
                     You can enter parameters of your diamond below and see its estimated price
                     and position among others on the right panel"),
            textInput("inCarats", h4("Enter weight in carats")),
            selectInput("inCut", h4("Enter diamond cut"),
                        choices = list("Fair", "Good", "Very Good", 
                                       "Premium", "Ideal")),
            selectInput("inColor", h4("Enter diamond color"),
                        choices = list("D", "E", "F", "G", "H",
                                       "I", "J"))
          )
        ),
    
     
    # Show estimation result on chart
      mainPanel(
          h3("Diamond's estimated price and positon among others:"),
          textOutput("outPrice"),
          plotOutput("outPlot",
                     dblclick = "outPlot_dblclick",
                     brush = brushOpts(
                       id = "outPlot_brush",
                       resetOnNew = TRUE)
          ),
          helpText("Brush and double-click to zoom chart"),
          br(),
          h4("Use the following options to filter graphic output:"),
          checkboxInput("inOnlyCarats", "Select this to show diamonds of similar weight only"),
          checkboxInput("inCutOnly", "Select this to show diamonds of similar cut only"),
          checkboxInput("inColorOnly", "Select this to show diamonds of similar color only")#,
          #submitButton("Apparaise")
          
      )  
    )
)