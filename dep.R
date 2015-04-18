# This is for deployment on shinyapps.io: it causes shinyapps.io to load the
# Cairo library, which results in higher- quality output from ggplot2.
#got it from Winston Chang: 
#https://github.com/rstudio/webinars/blob/master/2015-04/activity-dashboard/dep.R
library(Cairo)