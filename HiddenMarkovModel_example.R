library('depmixS4')
library('quantmod')
source("1.CollectData.R")

# �Ｚ���� �ְ� �����͸� �о�´�
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
      # �ְ� �� State ��ȭ ��Ʈ
      prob <- posterior(hmmfit)
      #prob$mstate <- apply(prob[, -1], 1, function(x) which(x == max(x)))
      print(tail(prob))
      
      par(mfrow=c(3,1), mar=c(2, 2, 2, 2), mgp=c(2, 0.3, 0))
      plot(Cl(p), type='s', main="�ְ�")
      plot(prob$state, type='s', main='True Regimes', xlab='', ylab='Regime')
      matplot(prob[,-1], type='l', main='Regime Posterior Probabilities', ylab='Probability')
      legend(x='topright', paste("S", 1:n, sep=''), fill=1:n, bty='n')
   
      # State Density
      layout(1:n)
      p$state <- prob$state
      
      for (i in 1:n) {
         # State i �� ���� ���ͷ�
         rtn <- p$rtn[which(p$state == i)]

         if (length(rtn) > 1) {
            # State i �� ����
            r <- 100 * length(rtn) / nrow(p)
            
            # State i �� ���� ���ͷ��� ���, ǥ������ (���������� ȯ����)
            m <- mean(rtn) * 252 * 100
            s <- sd(rtn) * sqrt(252) * 100
            
            plot(density(rtn), xlim=c(-0.1, 0.1), main=sprintf("State #%d (��=%.2f, ��=%.2f, r=%.2f)", i, m, s, r))
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
