library(shiny)
library(RColorBrewer)
library(shinyIncubator)

### Add status bar there

median_serie_ratings <- function(df, n) {
  obj <- df[df$Show==n,]
  return(median(obj$Rating))
}


plot_serie_ratings <- function(df, n, trend=TRUE) {
  
  #	pal=brewer.pal(8, "Set1")
  #	pal=brewer.pal(8, "Set2")
  pal=brewer.pal(8, "Dark2")
  
  obj <- df[df$Show==n,]
  
  pal2 <- pal
  while(length(pal2) < max(obj$Season)) {
    pal2 <- c(pal2, pal)
  }
  names(pal2) <- unique(obj$Season)
  indices <- 1:length(obj$Rating)
  
  
  plot(indices, obj$Rating, pch=16, ylim=c(0,10), col=pal2[obj$Season], bty="n", xaxt="n", xlab="", ylab="Rating", main=n)
  mtext("Season:", side=1, at=0)
  mtext(tapply(obj$Season, obj$Season, unique), col=pal2[unique(obj$Season)], side=1, at=tapply(indices, obj$Season, median))
  
  if(trend) {
   
    list_ratings <- tapply(obj$Rating, obj$Season, list)
    list_boundaries <- tapply(indices, obj$Season, range)
    for (n in names(list_ratings)) {
      a <- list_ratings[[n]]
      b <- (1:length(list_ratings[[n]])) + list_boundaries[[n]][1] - 1
      m <-  lm(a ~ b)
      p <- predict(m)
      segments(b[1], p[1], b[length(b)], p[length(p)], col=pal2[n], lwd=2)
    }
  }
}



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # Loading file

  
#   withProgress(session, {
#     setProgress(message = "Loading series data",
#                 detail = "This may take a few moments...")
    
  shows_completed =c("How I Met Your Mother", "Lost", "Friends", "The Wire", "Dexter", "Alias", "The X Files", "Sex and the City", "Buffy the Vampire Slayer", "The Sopranos", "Desperate Housewives", "ER", "24", "Lois & Clark: The New Adventures of Superman", "Smallville", "Stargate SG-1", "Six Feet Under", "Nip/Tuck", "Seinfeld", "Futurama", "Brothers & Sisters", "Band of Brothers", "House M.D.", "Breaking Bad", "Prison Break", "Scrubs", "The Office", "Psych", "The L Word", "Roseanne", "Chuck", "Angel", "Heroes")
  show_ongoing <- c("The Simpsons", "Game of Thrones", "Homeland", "The Big Bang Theory", "Modern Family", "Californication", "Bones", "Grey's Anatomy")
  
  all_shows <- sort(c(shows_completed, show_ongoing))
  
  ser <- read.delim("data/Series.Ratings.txt", stringsAsFactors=F)
  
  ser2 <- ser[ser$Show %in% all_shows,]
  ord <- order(ser2$Show, ser2$Season, ser2$EpNumber)
  ser2 <- ser2[ord,]
  
#   })
  
  # Expression that generates a plot. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
#    bins <- seq(min(x), max(x), length.out = input$bins + 1)
  bins <- 20
  
  # draw the histogram with the specified number of bins
  plot_serie_ratings(ser2, input$inSeries, trend=input$plotTrend)

  })

  output$text1 <- renderText({ 
    paste("Median rating: ", median_serie_ratings(ser2, input$inSeries), "/10", sep="")
  })
})