source('FeatureSetTA.R')

# Yahoo 사이트로부터 삼성전자 주가 데이터를 읽어온다
#p <- getData('005930')

# 기술적 분석 Feature 데이터 세트를 생성한다
ds <- FeatureSetTA(p)
t <- as.data.frame(ds$test)

par(mar=c(2, 2, 2, 2), mgp=c(3, 0.3, 0))
plot(t$spread, type='l')
lines(t$macd, type='l', col='blue')
lines(t$smi, type='l', col='red')
lines(t$boll, type='l', col='green')
abline(h=0)
