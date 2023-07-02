# This application is created as peer-graded assignment
# for the Developing Data Products
# Vladimir Inyaev, 2023-06-28
## Server logic

library(shiny)
library(ggplot2)
library(dplyr)
data(diamonds)

# Define server logic required to draw a histogram
function(input, output) {
  
  # Price prediction model fitting
  
  model <- lm(price ~ carat + cut + color, data = diamonds)
  
  graphData <- diamonds # for chart only
  
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  modelPred <- reactive({
    caratInput <- as.numeric(input$inCarats)
    cutInput <- input$inCut
    colorInput <- input$inColor
    
    predict(model, newdata = data.frame(carat = caratInput, cut = cutInput, color = colorInput))
    
  })
  
  adjustGraph <- reactive({
    if (input$inOnlyCarats) {
      graphData %>% filter(carat == as.numeric(input$inCarats))
    }
    
    if (input$inCutOnly) {
      graphData %>% filter(cut == input$inCutOnly)
    }
  })
  
  # Price output in text
  output$outPrice <- renderText({
    paste("Calculated price: ", ifelse(is.na(modelPred()), "", round(modelPred(), 2)))
  })
  
  # Building plot
  output$outPlot <- renderPlot({
    if (input$inOnlyCarats == TRUE) {
      graphData <- graphData %>% filter(carat == as.numeric(input$inCarats))
    }
    
    if (input$inCutOnly == TRUE) {
      graphData <- graphData %>% filter(cut == input$inCut)
    }
    
    if (input$inColorOnly == TRUE) {
      graphData <- graphData %>% filter(color == input$inColor)
    }
    
    p <- ggplot(data = graphData, mapping = aes(carat, price)) + 
      geom_point(mapping = aes(col = color, shape = cut)) +
      geom_vline(xintercept = as.numeric(input$inCarats), alpha = 0.5) +
      geom_hline(yintercept = modelPred(), alpha = 0.5) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
    p
  })
  
  # zoom chart
  observeEvent(input$outPlot_dblclick, {
    brush <- input$outPlot_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
}
