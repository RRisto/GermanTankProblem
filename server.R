source("helpers.R")
library("ggplot2")
library("dplyr")
library("shiny")
library("reshape2")
library("ggthemes")
library("scales")

shinyServer(function(input, output) {
    dataInput<- reactive({
        #if sample size is bigger than min production range,
        #error message is displayed
        validate(
            need(input$production[1] >=input$num,
                 "Sample size can't be bigger than minimum value of tank production range.
                 Please choose a higher minimum value for production range or smaller 
                 sample size."),
            need(input$checkGroup !="","Choose a model to display")
            )
        simulation(min=input$production[1],
                   max= input$production[2],
                   n=input$num,
                   margin=input$margin)
    })
    models= reactive({
        as.list(input$checkGroup)
    })
    data.sub=reactive({
        subset(dataInput(), variable %in% models())
    })
    #first plot
    output$guess.plot <- renderGraph({
        guesses=ggplot(data.sub(), aes(x=real, y=value))+
            geom_point(position = position_jitter(),aes(color=variable), alpha=0.5)+
            geom_abline(intercept = 0, slope=1)+
            ylab("Guess")+
            xlab("Actual number of tanks produced")+
            scale_colour_discrete(name="Model")+
            theme_minimal()
        
        #code for plotly
        #This grabs data and layout information from the ggplot
        gg<- gg2fig(guesses)
        
        gg$layout$showlegend <- TRUE # show the legend
        
        # Send this message up to the browser client, which will get fed through to
        # Plotly's javascript graphing library embedded inside the graph
        return(list(
            list(
                id="guess.plot",
                task="newPlot",
                data=gg$data,
                layout=gg$layout
            )
        ))
        ##end of the code for plotly
    })
    #residuals plot
    output$resids.plot <- renderGraph({
        resids=ggplot(data.sub(), aes(x=real, y=Model))+
            geom_point(position = position_jitter(),aes(color=variable), alpha=0.5)+
             geom_abline(intercept = 0, slope=0)+
             ylab("Residuals (% difference from actual production)")+
             xlab("Actual number of tanks produced")+
             theme_minimal()
        
        #code for plotly
        #This grabs data and layout information from the ggplot
        gg<- gg2fig(resids)
        
        gg$layout$showlegend <- TRUE # show the legend
        
        # Send this message up to the browser client, which will get fed through to
        # Plotly's javascript graphing library embedded inside the graph
        return(list(
            list(
                id="resids.plot",
                task="newPlot",
                data=gg$data,
                layout=gg$layout
            )
        ))
        ##end of the code for plotly
    })
    output$residuals <- renderTable({ resids(data.sub()) 
    })
    #output$histogram.plot <- renderPlot({ 
    output$trendPlot <- renderGraph({ 
        
        ggideal_point<-ggplot(data.sub(), aes(x=Model, colour=variable)) + 
            geom_density(trim=TRUE)+
            xlab("Residuals (% difference from actual production)")+
            theme_minimal()+
            geom_vline(aes(xintercept = 0))
        
        #code for plotly
        #This grabs data and layout information from the ggplot
        gg<- gg2fig(ggideal_point)
        gg$layout$showlegend <- TRUE # show the legend
        
        # Send this message up to the browser client, which will get fed through to
        # Plotly's javascript graphing library embedded inside the graph
        return(list(
            list(
                id="trendPlot",
                task="newPlot",
                data=gg$data,
                layout=gg$layout
            )
        ))
        ##end of the code for plotly
    })
})