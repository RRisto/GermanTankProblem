simulation <- function(min=100, max=110, n=5, margin=5){
    set.seed(500)
    real=c()
    third.guess=data.frame(NULL)
    initial.guess=data.frame(NULL)
    second.guess=data.frame(NULL)
    resids1=data.frame(NULL)
    resids2=data.frame(NULL)
    resids3=data.frame(NULL)
    #function for third guess
    thirdModel = function(samp) {
        max(samp) + max(samp)/length(samp) - 1
    }
    #simulation
    x = seq(min, max, by=1)
    minminus=min-1
    for(i in x) {
        trueTop = 1*i
        real[i-minminus]=trueTop
        for(j in 1:10) {
            observeds = sample(1:trueTop, n)#every simulation we take
            #randomly n samples
            third.guess[i-minminus,j] = thirdModel(observeds)
            initial.guess[i-minminus,j]=max(observeds)
            second.guess[i-minminus,j]=max(observeds)*(1+(margin/100))
            resids1[i-minminus,j] =initial.guess[i-minminus,j]-trueTop
            resids2[i-minminus,j] =second.guess[i-minminus,j]-trueTop
            resids3[i-minminus,j] =third.guess[i-minminus,j]-trueTop
        }
    }
    #function for making data short, renaming levels
    table=function(data, name){
        data=data %>%
            mutate( real=real) %>%
            melt(id="real") %>%
            mutate(variable=name)
        data
    }
    initial.guess=table(initial.guess, "Model 1")
    second.guess=table(second.guess, "Model 2")
    third.guess=table(third.guess, "Model 3")
    resids1=table(resids1, "resids1")
    resids2=table(resids2, "resids2")
    resids3=table(resids3, "resids3")
    #rbind tables
    data.guess=rbind(initial.guess, second.guess, third.guess)
    data.resids=rbind(resids1, resids2, resids3)
    #add resids to initial table
    data.guess$resids=data.resids$value
    #calculate residulas as percent
    data.guess=mutate(data.guess, resids.percent=(resids/real*100))
    names(data.guess)[5]="Model" #kinda stupid, but need it for plotly,
    #for unknow reason cannot rename legend title from ggplot for histogram
    return(data.guess)
}
#function for creating residuals summary table
resids=function(data){
    summary=data %>%
        group_by(variable) %>%
        #summarise(Mean=mean(resids.percent*100),
        summarise(Mean=mean(Model),
                  Median=median(Model),
                  Sd=sd(Model))
    names(summary)[1]="Model"
    summary
}