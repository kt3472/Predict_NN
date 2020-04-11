library('bcp')
library('quantmod')
source("1.CollectData.R")

# 삼성전자 주가 데이터를 읽어온다
#p <- getData("005930")
p <- getKospi()

# 종가의 변환점을 육안으로 확인하기위해 2016년 이후 데이터만 분석해 본다
bcp.close <- bcp(p$close['2016-01::'])
plot(bcp.close)

# 전체를 분석해 본다
bcp.close <- bcp(p$close)
plot(bcp.close)

# posterior probability 수치 확인
p$posterior <- bcp.close$posterior.prob

# 날짜 수 계산
k <- 0.5
p <- p[which(p$posterior > k),]
p$days <- NA
for (i in 2:nrow(p)) p$days[i] <- as.numeric(index(p[i]) - index(p[i-1]))
p <- na.omit(p)

# 날짜의 최빈값, 평균 계산
myMode <- function(x) {
   ux <- unique(x)
   ux[which.max(tabulate(match(x, ux)))]
}
md <- myMode(p$days)
mu <- mean(p$days)

# 날짜 수의 분포 확인
title <- sprintf("Posterior > %.2f, 최빈값 = %d, 평균 = %.4f", k, md, mu)
plot(density(p$days), main = title)
abline(v=md, col='red')
abline(v=mu, col='blue')
