source("helpers.R")
library("ggplot2")
library("dplyr")
library("shiny")
library("reshape2")
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
    output$guess.plot <- renderPlot({
        ggplot(data.sub(), aes(x=real, y=value))+
            geom_jitter(aes(color=variable), alpha=0.5)+
            geom_abline(intercept = 0, slope=1)+
            ylab("Guess")+
            xlab("Actual number of tanks produced")+
            scale_colour_discrete(name="Model")+
            #ggtitle("Tank production vs guess")+
            theme_minimal()+
            theme(legend.position="none")+
            theme(plot.title = element_text(size=20,lineheight=.8, face="bold"))
    })
    #residuals plot
    output$resids.plot <- renderPlot({
        ggplot(data.sub(), aes(x=real, y=resids.percent))+
            geom_jitter(aes(color=variable), alpha=0.5)+
            geom_abline(intercept = 0, slope=0)+
            ylab("Residuals (difference from actual production)")+
            scale_y_continuous(labels=percent)+
            xlab("Actual number of tanks produced")+
            scale_colour_discrete(name="Model")+
            theme_minimal()+
            theme(plot.title = element_text(size=20,lineheight=.8, face="bold"))
    })
    output$residuals <- renderTable({ resids(data.sub()) 
    })
    
    output$histogram.plot <- renderPlot({ 
        ggplot(data.sub(), aes(x=resids.percent, colour=variable)) + 
            geom_density()+
            geom_vline(xintercept = 0)+
            scale_colour_discrete(name="Model")+
            scale_x_continuous(labels=percent)+
            xlab("Residuals (difference from actual production)")+
            theme_minimal() 
    })
})