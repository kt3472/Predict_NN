library('depmixS4')
library('quantmod')
source("1.CollectData.R")

# 삼성전자 주가 데이터를 읽어온다
p <- getData("005930")

hmmInference <- function(p, n, chart=T) {
   p$rtn <- ROC(Cl(p))
   p <- as.data.frame(na.omit(p))
   
   # Create and fit the Hidden Markov Model
   #set.seed(1)
   hmm <- depmix(rtn ~ 1, family = gaussian(), nstates = n, data=p)
   hmmfit <- fit(hmm, verbose = FALSE)
   summary(hmmfit)
   
   if (chart) {
      # 주가 및 State 변화 차트
      prob <- posterior(hmmfit)
      #prob$mstate <- apply(prob[, -1], 1, function(x) which(x == max(x)))
      print(tail(prob))
      
      par(mfrow=c(3,1), mar=c(2, 2, 2, 2), mgp=c(2, 0.3, 0))
      plot(Cl(p), type='s', main="주가")
      plot(prob$state, type='s', main='True Regimes', xlab='', ylab='Regime')
      matplot(prob[,-1], type='l', main='Regime Posterior Probabilities', ylab='Probability')
      legend(x='topright', paste("S", 1:n, sep=''), fill=1:n, bty='n')
   
      # State Density
      layout(1:n)
      p$state <- prob$state
      
      for (i in 1:n) {
         # State i 에 속한 수익률
         rtn <- p$rtn[which(p$state == i)]

         if (length(rtn) > 1) {
            # State i 의 비율
            r <- 100 * length(rtn) / nrow(p)
            
            # State i 에 속한 수익률의 평균, 표준편차 (연간단위로 환산함)
            m <- mean(rtn) * 252 * 100
            s <- sd(rtn) * sqrt(252) * 100
            
            plot(density(rtn), xlim=c(-0.1, 0.1), main=sprintf("State #%d (μ=%.2f, σ=%.2f, r=%.2f)", i, m, s, r))
            abline(v=m[1]/25200, col='red')
         }
      }
   }

   # Transition matrix
   transition <- matrix(0, n, n)
   for (i in 1:n) {
      transition[i,] <- hmmfit@transition[[i]]@parameters$coefficients
   }
   
   hmmInference <- list(hmm = hmmfit, transition = transition, state = posterior(hmmfit), p=p)
}

