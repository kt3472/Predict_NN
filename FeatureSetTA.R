source('CollectData.R')

FeatureSetTA <- function(p, tRate=0.1, cat=2) {
   
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
   
   # 익일 수익률을 표시한다. 내일의 수익률을 예측하기 위함.
   ds$frtn <- lag(p$rtn, -1)

   # Prediction 용 데이터
   pred <- as.data.frame(ds[nrow(ds)])
   pred$frtn <- NULL
   
   # Data Set에서 Prediction 용 데이터 제거
   ds <- ds[-nrow(ds)]
   
   # NA 제거
   ds <- na.omit(ds)
   
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

