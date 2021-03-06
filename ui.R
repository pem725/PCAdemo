
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Demonstrate PCA"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("COR",
                  "Average Correlation:",
                  min = 0,
                  max = 1,
                  value = .5),
      sliderInput("N",
                  "Number of Observations:",
                  min = 50,
                  max = 1000,
                  step = 50,
                  value = 200),
      sliderInput("Nv",
                  "Number of Variables:",
                  min = 6,
                  max = 20,
                  value = 9),
      sliderInput("Nc",
                  "Number of Distinct Components:",
                  min = 1,
                  max = 5,
                  value = 1),
      sliderInput("Nr",
                  "Number of Components to Retain:",
                  min = 2,
                  max = 6,
                  value = 2),
      radioButtons("rotate",
                   "Rotation Type:",
                  c("None" = "none",
                   "Varimax" = "varimax",
                   "Quatimax" = "quatimax",
                   "Promax (Similar to SPSS)" = "promax",
                   "Oblimin" = "oblimin",
                   "Simplimax" = "simplimax",
                   "Cluster" = "cluster")),
      img(src="MRES2wbg.png",height=72),
      "Product of the ",
      span("MRES lab", style="color:blue")
    ),

    # Show plots
    mainPanel(
      tabsetPanel(
        tabPanel("Correlation Plot", plotOutput("corPlot")),
        tabPanel("Scree Plot", plotOutput("screePlot")),
        tabPanel("Component Plot", plotOutput("compPlot")),
        tabPanel("Communality Plot", plotOutput("commPlot"))
      )
    )
  )
))
