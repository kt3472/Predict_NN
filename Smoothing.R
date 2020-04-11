library(quantmod)
source('1.CollectData.R')

p <- getKospi(from='2015-01-01')

# 평활화 (Smoothing), 단순 이동평균 (SMA)
p$sma <- SMA(p$close, n=30)

# Kernel Regression 평활화
# ksmooth 는 list를 반환함. --> 데이터 프레임으로 변환
k <- as.data.frame(ksmooth(time(p), p$close, "normal", bandwidth=30))
p$kernel <- as.xts(k$y, order.by=index(p))

# Spline 평활화
# spline은 직접 데이터 프레임으로 변환 안됨. $y 로 y 요소만 변환함
k <- as.data.frame(smooth.spline(time(p), p$close, spar=1)$y)
p$spline <- as.xts(k, order.by=index(p))

par(mfrow=c(1,1), mar=c(3, 3, 3, 3), mgp=c(1.5, 0.3, 0))
plot(as.vector(p$close), type='l', main='Smoothing')
lines(as.vector(p$sma), col='blue')
lines(as.vector(p$kernel), col='red')
lines(as.vector(p$spline), col='green')
