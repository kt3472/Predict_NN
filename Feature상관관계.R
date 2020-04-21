# install.packages("igraph")

library(igraph)
source('FeatureSetTA.R')
printf <- function(...) cat(sprintf(...))

# 기술적 지표들의 상관관계를 관찰한다.
# Yahoo 사이트로부터 삼성전자 주가 데이터를 읽어온다
p <- getData('005930')

# 기술적 분석 Feature 데이터 세트를 생성한다
ds <- FeatureSetTA2(p)
myClass <- ds$train$class
ds$train$class <- NULL

# Feature 들 간의 상관계수를 구한다 (상관계수 행렬)
cm <- cor(ds$train)
print(cm)

# 상관계수 행렬을 그래프 형태로 그린다. 상관계수가 0.3 이상인 것.
g <- graph.adjacency(cm > 0.3, weighted=TRUE, mode="upper", diag = FALSE)

par(mai=c(1,1,0.1,0.15), mar=c(1, 0, 1, 1), mgp=c(2,1,0), mfrow=c(1,1), cex=1, lwd=1)
plot(g, vertex.size=25, vertex.color='green')

# SMI ~ MACD의 상관관계 확인
par(mfrow=c(1,2), mar=c(3, 3, 2, 2), mgp=c(1.5, 0.3, 0))
title <- sprintf("Correlation = %.4f", cor(ds$train$smi, ds$train$macd))
plot(x=ds$train$smi, y=ds$train$macd, xlim=c(-3,2.5), ylim=c(-3,2.5), xlab="SMI", ylab="MACD", main=title, pch=c(4,20)[unclass(myClass)], col=c('red', 'blue')[unclass(myClass)])

# ATR ~ VOLATILITy의 상관관계 확인
title <- sprintf("Correlation = %.4f", cor(ds$train$atr, ds$train$volatility))
plot(x=ds$train$atr, y=ds$train$volatility, xlim=c(-1.5,3), ylim=c(-1.5,3), xlab="ATR", ylab="Volatility", main=title, pch=c(4,20)[unclass(myClass)], col=c('red', 'blue')[unclass(myClass)])
