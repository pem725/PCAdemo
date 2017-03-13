
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggfortify)
library(reshape)
library(ggplot2)
library(corrplot)
library(psych)

shinyServer(function(input, output) {
  dat <- reactive({
    out <- data.frame(id=1:input$N)
    for(i in 1:input$Nc){
      cormat <- matrix(rbinom(input$NV*input$Nv,100,input$COR)/100,round(input$Nv/input$Nc),round(input$Nv/input$Nc))
      diag(cormat) <- 1
      U <- t(chol(cormat))
      random.normal <- matrix(rnorm(input$Nv*input$N,0,1),input$Nv,input$N)
      tmp2 <- as.data.frame(t(U %*% random.normal))
      names(tmp2) <- paste("V",1:NV,i,sep=".")
      out <- cbind(out,tmp2)
    }
    out <- out[,-1]
  })

  PCA <- reactive({
    out <- principal(dat,nfactors=input$Nr,rotate=input$rotate)    
  })
  
  datcorr <- reactive({
    out <- cor(dat()$out)
  })
  
  output$corPlot <- renderPlot({
   corrplot(datcorr()$out,type="lower") 
  })
  
  output$screePlot <- renderPlot({
    scree(dat()$out,F,T)
  })

#  output$compPlot <- renderPlot({
#    melted <- cbind(1:input$Nr,melt(out$out$loadings[,1:input$Nr]))
#    barplot <- ggplot(data=melted) + geom_bar(aes(x=X2,y=value,fill=X1),stat="identity") + facet_wrap(~X2)
#  })
  
#  output$commPlot <- renderPlot({
#    h.rn <- row.names(data.frame(pca$communality))
#    h.sq <- data.frame(Var=h.rn,h2=pca$communality)
#    ggplot(data=h.sq) + geom_bar(aes(x=Var,y=h2),stat="identity") + coord_flip() + xlab("Variable") + ylab("Communality")
#  })

})
