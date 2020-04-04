library(e1071)

sdata <- read.csv("data/svmData.csv")
colnames(sdata) <- c('x', 'y', 'class')
sdata$class <- as.factor(sdata$class)
plot(sdata$x, sdata$y, pch=c(19,4)[unclass(sdata$class)], col=c('red', 'blue')[unclass(sdata$class)])

sv <- svm(class ~ y + x, data = sdata, kernel="radial", cost=10, gamma=0.9)
plot(sv, sdata)
