library('bcp')
library('quantmod')
source("1.CollectData.R")

# �Ｚ���� �ְ� �����͸� �о�´�
#p <- getData("005930")
p <- getKospi()

# ������ ��ȯ���� �������� Ȯ���ϱ����� 2016�� ���� �����͸� �м��� ����
bcp.close <- bcp(p$close['2016-01::'])
plot(bcp.close)

# ��ü�� �м��� ����
bcp.close <- bcp(p$close)
plot(bcp.close)

# posterior probability ��ġ Ȯ��
p$posterior <- bcp.close$posterior.prob

# ��¥ �� ���
k <- 0.5
p <- p[which(p$posterior > k),]
p$days <- NA
for (i in 2:nrow(p)) p$days[i] <- as.numeric(index(p[i]) - index(p[i-1]))
p <- na.omit(p)

# ��¥�� �ֺ�, ��� ���
myMode <- function(x) {
   ux <- unique(x)
   ux[which.max(tabulate(match(x, ux)))]
}
md <- myMode(p$days)
mu <- mean(p$days)

# ��¥ ���� ���� Ȯ��
title <- sprintf("Posterior > %.2f, �ֺ� = %d, ��� = %.4f", k, md, mu)
plot(density(p$days), main = title)
abline(v=md, col='red')
abline(v=mu, col='blue')