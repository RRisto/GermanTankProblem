library("shiny")
library("shinythemes")
shinyUI(shinyUI(
    fluidPage(theme = shinytheme("journal"),
              sidebarLayout(
                  sidebarPanel( 
                      br(),
                      br(),
                      h3("Simulation input"),
                      sliderInput("production", label = h4("Actual tank production range:"),
                                  min = 10, max = 800, step=10, value = c(100, 110)),
                      numericInput("num", label = h4("Number of tanks captured:"),min=1, max=50,
                                   value = 5, step=1),
                      numericInput("margin", label = h4("Margin (%) for second model:"),
                                   min=1, max=50, value = 5, step=1),
                      checkboxGroupInput("checkGroup", label = h4("Model to display:"),
                                         choices = list("Model 1" = "Model 1",
                                                        "Model 2" = "Model 2",
                                                        "Model 3" = "Model 3"),
                                         selected = c("Model 1", "Model 2", "Model 3"))
                  ),
                  mainPanel(
                      tabsetPanel(type = "tabs",
                                  tabPanel("About",
                                           p("This application is for comparing different solutions for",
                                             tags$b("German Tank Problem."),
                                             "Problem is simple. You are an allied general in WW2 and trying to estimate
                                             how many tanks germans were producing based on number of tanks captured 
                                             (all tanks have sequential serial number). This application simulates three models
                                             which try to guess number of tanks produced:"),
                                           tags$div( HTML( "<ol>
                                                           <li><b>model 1</b>, highest serial number captured = 
                                                            actual tank production,</li>
                                                           <li><b>model 2</b>, model 1 answer +(model 1 answer x margin) = 
                                                            actual tank production,</li>
                                                           <li><b>model 3</b>, most complex model which uses formula
                                                           originally used by allies:</li>
                                                           </ol>" )),
                                           p(withMathJax("$$actual\\ tank\\ production\\ = max + \\frac{max}{n} - 1$$")),
                                           tags$div(HTML( "
                                                          <p>Where:</p>
                                                          <ul>
                                                          <li>max is maximum serial number captured</li>
                                                          <li>n is number of tanks captured</li>
                                                          </ul>" )),
                                           p("You can change  inputs (number of tanks
                                             captured, tank production range, margin for second model).  
                                                App simulates 10 guesses per model for each tank in actual prodcution range.
                                             To evaluate accuracy residuals are plotted."),
                                           tags$b("Residuals are presented in percent:
                                                  (production guessed by model - true production)/true production x 100."),
                                           p("NB! As production range and sample size increases application might become
                                             slower."),
                                           img(src="tanks.jpg", height = 100, width = 150)
                                           ),
                                  tabPanel("Simulation",
                                           fluidRow(
                                               column(12,
                                                      h3("Actual tank production vs guess", align="center"),
                                                      graphOutput("guess.plot")
                                               ),
                                               column(12,
                                                      h3("Residuals", align="center"),
                                                      graphOutput("resids.plot")
                                               ),
                                                column(12,   
                                                      h3("Residuals histogram", align="center"),
                                                      graphOutput("trendPlot")
                                                      ),
                                               column(12, 
                                                      h3("Residuals boxplot", align="center"),
                                                      graphOutput("residsBox"))
                                           )
                                  )
                                           ) ) ) ) ) )