# if not installed run install.packages(c("tidyverse", "shiny", "gapminder", "plotly"))
library(tidyverse)
library(shiny)
library(gapminder)
library(plotly)

# User Interface
ui <- fluidPage(
  titlePanel("🌍 Global Development Explorer"), # title goes here
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Select Year:", 
                  min = min(gapminder$year), 
                  max = max(gapminder$year),
                  value = 2007,
                  step = 5,
                  sep = "",
                  animate = animationOptions(interval = 1500, loop = TRUE)
                  ), 
      selectInput("continent", "Continent:",
                  choices = unique(gapminder$continent),
                  selected = unique(gapminder$continent),
                  multiple = TRUE),
      downloadButton("download", "Download Filtered Data") 
    ), # the sidebar is used for inputs and buttons
    mainPanel(
      plotlyOutput("bubblePlot", height = "600px"),
      br(),
      tableOutput("summaryTable")
    ) # the main panel is for plots and tables
  )
)

# Server
server <- function(input, output, session) {
  # Filtered data for plots that is reactive to inputs
  filtered_data <- reactive({
    gapminder %>%
      filter(year == input$year, continent %in% input$continent)
  })
  
  # Interactive bubble plot
  output$bubblePlot <- renderPlotly({
    p <- ggplot(filtered_data(), aes(
      x = gdpPercap,
      y = lifeExp,
      size = pop,
      color = continent,
      text = paste0("Country: ", country,
                    "<br>GDP per Capita: $", round(gdpPercap, 0),
                    "<br>Life Expectancy: ", round(lifeExp, 1), " years",
                    "<br>Population: ", format(pop, big.mark = ","))
    )) +
      geom_point(alpha = 0.7) +
      scale_x_log10() +
      theme_minimal() +
      labs(title = paste("Year:", input$year),
           x = "GDP per Capita (log scale)",
           y = "Life Expectancy (years)")
    
    ggplotly(p, tooltip = "text")
  })
  
  # Summary table
  output$summaryTable <- renderTable({
    filtered_data() %>%
      group_by(continent) %>%
      summarise(
        Countries = n(),
        Avg_LifeExp = round(mean(lifeExp), 1),
        Avg_GDP = round(mean(gdpPercap), 0),
        Total_Pop = sum(pop)
      )
  })
  
  # Download handler
  output$download <- downloadHandler(
    filename = function() {
      paste0("gapminder_", input$year, ".csv")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

# Run the app
shinyApp(ui, server)