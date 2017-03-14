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

  GDat <- reactive({
    NV <- round((input$Nv/input$Nc))
    outdat <- data.frame(id=1:input$N)
    for(i in 1:input$Nc){
      cormat <- matrix(rbinom(NV*NV,100,input$COR)/100,NV,NV)
      diag(cormat) <- 1
      U <- t(chol(cormat))
      random.normal <- matrix(rnorm(NV*input$N,0,1),NV,input$N)
      tmp2 <- as.data.frame(t(U %*% random.normal))
      names(tmp2) <- paste("V",1:NV,i,sep=".")
      outdat <- cbind(outdat,tmp2)
    }
    outdat[,-1]
   })
    

  output$corPlot <- renderPlot({
    corrplot(cor(GDat()),type="lower") 
  })
  
  output$screePlot <- renderPlot({
    scree(GDat(),F,T)
  })

  output$compPlot <- renderPlot({
    pout <- principal(GDat(),nfactors=input$Nr,rotate=input$rotate)
    lout <- cbind(1:input$Nr,melt(pout$loadings[,1:input$Nr]))
    ggplot(data=lout) + geom_bar(aes(x=X1,y=value,fill=X1),stat="identity") + facet_wrap(~X2)
  })
  
  output$commPlot <- renderPlot({
    pout <- principal(GDat(),nfactors=input$Nr,rotate=input$rotate)
    lout <- cbind(1:input$Nr,melt(pout$loadings[,1:input$Nr]))
    h.rn <- row.names(data.frame(pout$communality))
    h.sq <- data.frame(Var=h.rn,h2=pout$communality)
    ggplot(data=h.sq) + geom_bar(aes(x=Var,y=h2),stat="identity") + coord_flip() + xlab("Variable") + ylab("Communality")
  })

})

## for testing purposes only
#dat <- data.frame(matrix(rnorm(1000),100,10))
#pout <- principal(dat,nfactors=2)
#lout <- cbind(1:2,melt(pout$loadings[,1:2]))
#ggplot(data=lout) + geom_bar(aes(x=X1,y=value,fill=X1),stat="identity") + facet_wrap(~X2)
