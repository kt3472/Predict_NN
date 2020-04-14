library(quantmod)
source('CollectData.R')

# 삼성전자 주가 데이터 (OHLC)를 가져온 후, 종가만 저장한다
# 거래량이 0 인 경우는 제외한다 (공, 휴일)
# samsung <- getSymbols('005930.KS', auto.assign=FALSE)
# samsung <- samsung[Vo(samsung) > 0]
# colnames(samsung) <- c('open', 'high', 'log', 'close', 'volume', 'adjusted')
# goldenCross(samsung['2014'], 5, 20)

# 최적화
optimize <- function(x, sfrom, sto, lfrom, lto) {
	r <- data.frame()
	t <- 1
	
	# for 문으로 작성함. 다음 버전에서는 foreach() 와 doParallel()로 병렬 처리해 볼 것.
	ptime <- system.time(
      for(i in sfrom:sto) {
         longStart <- i + lfrom
         longEnd <- longStart + lto
         for(j in longStart:longEnd) {
            ret <- goldenCross(x, i, j, chart=F)
            stdev <- sd(ret)
            
            r[t, 1] <- i; 	# 단기 이동평균 기간
            r[t, 2] <- j; 	# 장기 이동평균 기간
            r[t, 3] <- as.numeric(last(cumsum(ret)))
            r[t, 4] <- stdev
            r[t, 5] <- as.numeric(last(cumsum(ret))) / stdev
            t <- t + 1
         }
      }
	)
	print(ptime)
	retVal <- data.frame()
	
	# 마지막 수익률이 최대인 라인 리턴
	retVal <- r[which.max(r[,3]),]
	
	# 편차가 최소인 라인만 리턴
	retVal[2,] <- r[which.min(r[,4]),]
	
	# Sharp ratio가 최대인 라인만 리턴
	retVal[3,] <- r[which.max(r[,5]),]
	
	retVal[1, 6] <- 'Max return'
	retVal[2, 6] <- 'Min stdev'
	retVal[3, 6] <- 'Max sharp ratio'

	row.names(retVal) <- c(1:nrow(retVal))
	colnames(retVal) <- c('ShrtMA', 'LongMA', 'LastRtn', 'Stdev', 'Sharp', 'Remark')
	print(retVal)
	optimize <- r
}

# Golden cross, Dead cross 전략 Back Test
goldenCross <- function(x, shortMA, longMA, chart) {
	# 단기 이동평균선과 장기 이동평균선을 구한다. NA를 제거한다
	x$maShort <- SMA(Cl(x), shortMA)
	x$maLong <- SMA(Cl(x), longMA)
	x <- na.omit(x)

	# 수익률을 구해 놓는다
	# ret <- dailyReturn(s$close) 는 open ~ close 가격으로 수익률 산출
	# ret <- ROC(s$close) 는 전일 close와 금일 close로 수익률 산출 (로그 수익률)
	x$return <- ROC(x$close)
	x <- na.omit(x)

	# 전략을 수립한다
	# 단기이평선이 장기이평선 위에 있으면 Long position, 아니면 Short position 유지
	x$position <- ifelse(x$maShort > x$maLong, 1, -1)
	
	# 전략 수행시 수익률을 계산한다
	x$myret <- lag(x$position) * x$return
	x <- na.omit(x)

	if (chart == TRUE) {
		# 전략 수행 결과를 확인한다
	  par(mfrow = c(2,1), mar=c(2, 2, 2, 2), mgp=c(3, 0.3, 0))
	  plot(as.vector(x$close), type = 'l', main = 'Price & MAs', 
	       ylab='', xlab='', cex.main=1, cex.axis=0.8, xaxt="n", yaxt="n")
	  axis(1, at = seq(1, nrow(x)), tck=-0.02, 
	       label = format(as.Date(index(x)), "%Y/%b"), cex.axis = 0.8)
	  axis(2, tck=-0.02, cex.axis=0.8)
	  grid()
	  
		#par(mfrow=c(2,1))
		#plot(x$close, type = 'l', main = 'Price & MAs')
		lines(as.vector(x$maShort), col = 'blue')
		lines(as.vector(x$maLong), col = 'red')

		plot(cumsum(x$myret), main = 'Realized return', cex.main=1)
		lines(cumsum(x$myret), col = 'red')
	}

	# 실현 수익률을 리턴한다
	goldenCross <- x$myret
}
