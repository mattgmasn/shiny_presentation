# if not installed run install.packages(c("tidyverse", "shiny", "gapminder"))

# Load packages
library(tidyverse)
library(shiny)
library(gapminder)

# User interface
ui <- fluidPage(
  titlePanel("📈 Life Expectancy Over Time"),
  selectInput("country", "Select a country:", choices = unique(gapminder$country)),
  plotOutput("lifePlot")
)

# Server
server <- function(input, output, session) {
  output$lifePlot <- renderPlot({
    gapminder %>%
      filter(country == input$country) %>%
      ggplot(aes(x = year, y = lifeExp)) +
      geom_line(color = "steelblue", linewidth = 1.5) +
      geom_point(color = "darkred", size = 2) +
      labs(
        title = paste("Life Expectancy in", input$country),
        x = "Year",
        y = "Life Expectancy (years)"
      ) +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui, server)
