source('3-2.FeatureSetTA.R')

# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
#p <- getData('005930')

# ����� �м� Feature ������ ��Ʈ�� �����Ѵ�
ds <- FeatureSetTA(p)
t <- as.data.frame(ds$test)

par(mar=c(2, 2, 2, 2), mgp=c(3, 0.3, 0))
plot(t$spread, type='l')
lines(t$macd, type='l', col='blue')
lines(t$smi, type='l', col='red')
lines(t$boll, type='l', col='green')
abline(h=0)