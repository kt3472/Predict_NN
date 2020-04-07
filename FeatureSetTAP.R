source('1.CollectData.R')

FeatureSetTAP <- function(p, tRate=0.1, cat=2) {
   
   # 일일 수익률을 계산한다
   p$rtn <-ROC(Cl(p))
   
   # 종가 기준 Spread = 10일 이동평균 - 20일 이동평균 계산
   # scale() 함수로 Z-score Normalization을 적용함
   ds <- scale(runMean(Cl(p), n=10) - runMean(Cl(p), n=20))
   colnames(ds) <- c("spread")
   
   # ATR 변동성 지표 계산
   ds$atr <- scale(ATR(scale(HLC(p)), n = 14)[,"atr"])
   
   # SMI 지표 계산
   ds$smi <- scale(SMI(HLC(p), n = 13)[,"SMI"])
   
   # ADX 지표 계산
   ds$adx <- scale(ADX(HLC(p), n = 14)[,"ADX"])
   
   # Aroon 추세 지표 계산
   ds$aroon <- scale(aroon(p[, c("high", "low")], n = 20)$oscillator)
   
   # Bollinger Band 지표 계산
   ds$boll <- scale(BBands(HLC(p), n = 20)[, "pctB"])
   
   # MACD 지표 계산
   ds$macd <- scale(MACD(Cl(p))[, 2])

   # OBV 지표 계산
   ds$obv <- scale(OBV(Cl(p), Vo(p)))
   
   # 5일 이동 평균 수익률 계산
   ds$martn <- scale(runMean(p$rtn, n = 5))
   
   # =======================================================================================
   # Unsupervised Learning의 Clustering 결과를 Feature로 선택한다.
   # 캔들 패턴을 표시한다
   # 캔들의 높,낮이는 무시하고, 캔들의 모양만 사용함. OHLC 각 가격을 OHLC 평균 가격으로 나누어 준다.
   s <- OHLC(p) / apply(OHLC(p), 1, mean)
   candle <- scale(as.data.frame(kmeans(s, centers=10, iter.max=100)$cluster))
   ds$candle <- as.xts(candle, order.by=as.Date(rownames(candle)))

   # 패턴 데이터 세트를 구성한다. 20일간의 종가를 한 패턴으로 구성한다.
   n <- seq(1, nrow(p) - 20, by=1)
   s <- data.frame()
   date <- vector()
   close <- vector()
   for (i in n) {
      v <- as.vector(t(scale(p$close[i:(i+19),])))
      date <- append(date, index(p[i+19]))
      close <- append(close, as.vector(p$close[i+19]))
      s <- rbind(s, v)
   }
   colnames(s) <- as.character(1:20)
   rownames(s) <- date
   pattern <- scale(as.data.frame(kmeans(s, centers=10, iter.max=100)$cluster))
   ds$pattern <- as.xts(pattern, order.by=as.Date(rownames(pattern)))
   # =======================================================================================
   
   # 익일 수익률을 표시한다. 내일의 수익률을 예측하기 위함.
   ds$frtn <- lag(p$rtn, -1)

   # NA 제거
   ds <- na.omit(ds)
   
   # Prediction 용 데이터
   pred <- as.data.frame(ds[nrow(ds)])
   pred$frtn <- NULL

   # Data Set에서 Prediction 용 데이터 제거
   ds <- ds[-nrow(ds)]
   
   # Data Set에서 frtn을 기준으로 Class를 부여함
   # s = frtn의 표준편차.
   if (cat == 3) {
      # 상승, 하락, 보합 3 가지 경우로 설정함
      # frtn이 -0.2s 이면 하락, -0.2s ~ +0.2s 이면 보합, +0.2s 이상이면 상승
      s <- sd(ds$frtn)
      ds$class <- ifelse(ds$frtn < -0.2 * s, 1, ifelse(ds$frtn > 0.2 * s, 3, 2))
   } else {
      # 상승, 하락 2 가지 경우로 설정함
      # frtn이 음수이면 하락, 양수이면 상승
      ds$class <- ifelse(ds$frtn < 0, 1, 2)
   }
   ds$frtn <- NULL
   
   # test data set 개수
   n <- as.integer(nrow(ds) * tRate)

   # training data set
   train <- as.data.frame(ds[1:(nrow(ds)-n),])
   
   # test set
   test <- as.data.frame(ds[(nrow(ds)-n+1):nrow(ds),])
   
   FeatureSetTA <- list("train" = train, "test" = test, "pred" = pred)
}

