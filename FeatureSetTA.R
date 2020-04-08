source('1.CollectData.R')

FeatureSetTA <- function(p, tRate=0.1, cat=2) {
   
   # ���� ���ͷ��� ����Ѵ�
   p$rtn <-ROC(Cl(p))
   
   # ���� ���� Spread = 10�� �̵���� - 20�� �̵���� ���
   # scale() �Լ��� Z-score Normalization�� ������
   ds <- scale(runMean(Cl(p), n=10) - runMean(Cl(p), n=20))
   colnames(ds) <- c("spread")
   
   # ATR ������ ��ǥ ���
   ds$atr <- scale(ATR(scale(HLC(p)), n = 14)[,"atr"])
   
   # SMI ��ǥ ���
   ds$smi <- scale(SMI(HLC(p), n = 13)[,"SMI"])
   
   # ADX ��ǥ ���
   ds$adx <- scale(ADX(HLC(p), n = 14)[,"ADX"])
   
   # Aroon �߼� ��ǥ ���
   ds$aroon <- scale(aroon(p[, c("high", "low")], n = 20)$oscillator)
   
   # Bollinger Band ��ǥ ���
   ds$boll <- scale(BBands(HLC(p), n = 20)[, "pctB"])
   
   # MACD ��ǥ ���
   ds$macd <- scale(MACD(Cl(p))[, 2])

   # OBV ��ǥ ���
   ds$obv <- scale(OBV(Cl(p), Vo(p)))
   
   # 5�� �̵� ��� ���ͷ� ���
   ds$martn <- scale(runMean(p$rtn, n = 5))
   
   # ���� ���ͷ��� ǥ���Ѵ�. ������ ���ͷ��� �����ϱ� ����.
   ds$frtn <- lag(p$rtn, -1)

   # Prediction �� ������
   pred <- as.data.frame(ds[nrow(ds)])
   pred$frtn <- NULL
   
   # Data Set���� Prediction �� ������ ����
   ds <- ds[-nrow(ds)]
   
   # NA ����
   ds <- na.omit(ds)
   
   # Data Set���� frtn�� �������� Class�� �ο���
   # s = frtn�� ǥ������.
   if (cat == 3) {
      # ���, �϶�, ���� 3 ���� ���� ������
      # frtn�� -0.2s �̸� �϶�, -0.2s ~ +0.2s �̸� ����, +0.2s �̻��̸� ���
      s <- sd(ds$frtn)
      ds$class <- ifelse(ds$frtn < -0.2 * s, 1, ifelse(ds$frtn > 0.2 * s, 3, 2))
   } else {
      # ���, �϶� 2 ���� ���� ������
      # frtn�� �����̸� �϶�, ����̸� ���
      ds$class <- ifelse(ds$frtn < 0, 1, 2)
   }
   ds$frtn <- NULL
   
   # test data set ����
   n <- as.integer(nrow(ds) * tRate)

   # training data set
   train <- as.data.frame(ds[1:(nrow(ds)-n),])
   
   # test set
   test <- as.data.frame(ds[(nrow(ds)-n+1):nrow(ds),])
   
   FeatureSetTA <- list("train" = train, "test" = test, "pred" = pred)
}
