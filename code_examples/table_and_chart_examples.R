#### DT Example ####

# Load packages
library(DT)

# Create an interactive datatable from a dataframe
datatable(mtcars)

# Add in download buttons
data_table_download <- datatable(
  mtcars,
  options = list(
    pageLength = 5,
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel')
  ),
  extensions = 'Buttons'
)

data_table_download


#### Plotly example ####

# Load packages
library(ggplot2)
library(plotly)

# Create an interactive chart using plotly directly
plot_plotly <- plot_ly(data = iris, 
                       x = ~Sepal.Length, 
                       y = ~Petal.Length, 
                       color = ~Species)

# Or, apply ggplotly to an existing ggplot chart
plot_ggplot <- ggplot() +
  geom_point(data = iris, 
             aes(x = Sepal.Length, 
                 y = Petal.Length, 
                 color = Species))

# Apply plotly to static ggplot chart
ggplotly(plot_ggplot)

# Create custom tooltip text
iris$tooltip_text <- paste(
  "Species:", iris$Species, "<br>",
  "Sepal Length:", iris$Sepal.Length, "cm", "<br>",
  "Petal Length:", iris$Petal.Length, "cm")

# Add tooltip to the plotly plot
plot_plotly_tooltips <- plot_ly(
  data = iris,
  x = ~Sepal.Length,
  y = ~Petal.Length,
  color = ~Species,
  text = ~tooltip_text,         # custom hover text
  hoverinfo = "text")          # only show text (not x/y by default)

# Display your chart with improved tooltips
plot_plotly_tooltips