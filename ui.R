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
                                                           <li><b>model 1</b>, a simple model where highest sequential
                                                           number captured is guessed to be total tank production,</li>
                                                           <li><b>model 2</b>, a bit more complex model where margin is added to
                                                           model 1 (margin is adjustable from input panel),</li>
                                                           <li><b>model 3</b>, most complex model which uses formula
                                                           originally used by allies:</li>
                                                           </ol>" )),
                                           p(withMathJax("$$max + \\frac{max}{n} - 1$$")),
                                           tags$div(HTML( "
                                                          <p>Where:</p>
                                                          <ul>
                                                          <li>max is maximum serial number captured</li>
                                                          <li>n is number of tanks captured</li>
                                                          </ul>" )),
                                           p("Application let's you to change  inputs (different number of tanks
                                             captured, different tanks production ranges, margin for second model). First 
                                             plot shows 10 guesses per model per each number of tanks in production range. 
                                             To evaluate accuracy of models residuals are plotted, summary statisticas are 
                                             calculated and histogram of residuals is made."),
                                           tags$b("Residuals are presented in percent:
                                                  (number of tanks guessed by model - true production)/true production*100."),
                                           p("This kind of simulation could be used solving other problems where
                                             population size must be guessed based on sequential serial numbers captured. 
                                             Have a nice tank hunt!"),
                                           p("NB! As production range and sample size increases application might become
                                             slower."),
                                           img(src="tanks.jpg", height = 100, width = 150)
                                           ),
                                  tabPanel("Simulation",
                                           fluidRow(
                                               column(6,
                                                      h3("Tank production vs guess", align="center"),
                                                      plotOutput("guess.plot")
                                               ),
                                               column(6,
                                                      h3("Residuals", align="center"),
                                                      plotOutput("resids.plot")
                                               ),
                                               column(6, 
                                                      h3("Summary of residuals"),
                                                      p("(% difference from actual production)"),
                                                      tableOutput("residuals")),
                                               column(6,   
                                                      h3("Residuals histogram", align="center"),
                                                      plotOutput("histogram.plot"))
                                           )
                                  )
                                           ) ) ) ) ) )