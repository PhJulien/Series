library(shiny)
library(shinyIncubator)

shows_completed =c("How I Met Your Mother", "Lost", "Friends", "The Wire", "Dexter", "Alias", "The X Files", "Sex and the City", "Buffy the Vampire Slayer", "The Sopranos", "Desperate Housewives", "ER", "24", "Lois & Clark: The New Adventures of Superman", "Smallville", "Stargate SG-1", "Six Feet Under", "Nip/Tuck", "Seinfeld", "Futurama", "Brothers & Sisters", "Band of Brothers", "House M.D.", "Breaking Bad", "Prison Break", "Scrubs", "The Office", "Psych", "The L Word", "Roseanne", "Chuck", "Angel", "Heroes")
show_ongoing <- c("The Simpsons", "Game of Thrones", "Homeland", "The Big Bang Theory", "Modern Family", "Californication", "Bones", "Grey's Anatomy")

all_shows <- sort(c(shows_completed, show_ongoing))

shinyUI(fluidPage(
  
  progressInit(),

  
  # Application title
  titlePanel("Series ratings per season"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput('inSeries', 'Choose your series', c(all_shows), multiple=FALSE, selectize=TRUE),
      hr(),
      
      checkboxInput("plotTrend", label = "Plot trend per season", value = FALSE),
      hr(),
      helpText("Data from IMDB"),
      helpText("Data frozen on 2014, Apr 10th. Episodes aired and votes made after this date are not taken into account")),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      textOutput("text1")
    )
  )
))


