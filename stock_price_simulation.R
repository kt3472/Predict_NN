# 주가의 몬테카를로 시뮬레이션
# r : Risk free rate
# v : volatility
# n : number of simulation
# s : initial value of a stock
MCrealization <- function(r=0.02, v=0.20, n=100, s = 2000, chart=TRUE) {
   # 일일 수익률. r은 연간 단위임.
   dRtn <- r / 365
   
   # 일일 변동성. v는 연간 단위임.
   dVol <- v / sqrt(252)
   
   # 1일 후 분포의 평균 수익률
   mRtn <- dRtn - 0.5 * dVol ^ 2
   
   # rnorm 으로 수익률 시뮬레이션
   result <- data.frame(rnorm(n))
   colnames(result) <- 'rnorm'
   result$rtn <- mRtn + dVol * result$rnorm
   
   # 수익률로 주가 시뮬레이션
   result$price <- s * exp(cumsum(result$rtn))

   # 주가 차트
   if (chart)
      plot(result$price, type='l', col = 'blue', main = "Monte Carlo Simulation")
   
   MonteCalro <- result
}

MCensamble <- function(r=0.02, v=0.20, n=100, s = 2000, k=20) {
   emc <- MCrealization(r=r, v=v, n=n, s=s, chart=FALSE)$price
   
   for (i in 1:(k-1))
      emc <- cbind(emc, MCrealization(r=r, v=v, n=n, s=s, chart=FALSE)$price)
   emc <- as.data.frame(emc)
   
   # 차트 작성
   minY <- round(min(emc)) - 10
   maxY <- round(max(emc)) + 10
   
   for (i in 1:k) {
      if (i == 1)
         plot(emc[,i], type='l', ylim=c(minY, maxY), main="Monte Carlo Simulation")
      else
         lines(emc[,i], type='l', ylim=c(minY, maxY), xlim=c(1, k), col=sample(rainbow(3 * k), 1))
   }
   abline(h = s)
   
   MCensamble <- emc
}