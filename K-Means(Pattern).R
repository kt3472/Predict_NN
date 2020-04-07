source('3-2.FeatureSetTA.R')

# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
p <- getData('005930')

# ���� ������ ��Ʈ�� �����Ѵ�. 20�ϰ��� ������ �� �������� �����Ѵ�.
n <- seq(1, nrow(p) - 20, by=3)
ds <- data.frame()
date <- vector()
close <- vector()
for (i in n) {
   v <- as.vector(t(scale(p$close[i:(i+19),])))
   date <- append(date, index(p[i+19]))
   close <- append(close, as.vector(p$close[i+19]))
   ds <- rbind(ds, v)
}
colnames(ds) <- as.character(1:20)
rownames(ds) <- date
tail(ds)

# K-Means �˰������� �̿��Ͽ� ������ 8���� Ŭ�����ͷ� �з��Ѵ�.
k <- 8
cl <- kmeans(ds, centers=k, iter.max=100, nstart=k)

# 8���� ��ǥ ������ �ð�ȭ�Ѵ�. ��ǥ������ �� Ŭ�������� ���� ������.
par(mfrow=c(2, k/2))
myCol <- c("blue", "red", "black", "brown", "green", "purple", "pink", "green")
for(i in 1:k) {
   title <- sprintf("Pattern - %d", i)
   
   # �� Ŭ�������� ���� ������ �׸��� (��ǥ ����)
   plot(cl$centers[i,], type='o', main=title, col=myCol[i], pch=19)
}

# ������ ��Ʈ�� ������ Ŭ������ ��ȣ (���� ��ȣ)�� �߰��Ѵ�
ds$close <- close
ds$class <- cl$cluster

# 1�� ���� �׷� �� ���� �׷�����.
par(mfrow=c(1,1), mar=c(2, 2, 2, 2), mgp=c(3, 0.3, 0))
pat.1 <- ds[which(ds$class == 1),]
plot(t(pat.1[1, 1:20]), type='o', pch=20)
for (i in seq(10, 50, by=10)) {
   lines(t(pat.1[i, 1:20]), type='o', pch=20, col=i)
}

# ���� �������� �ְ� ��Ʈ�� �׸���, �� ���� ���� ��ȣ�� ǥ���Ѵ�
par(mfrow=c(1,1))
plot(ds$close[721:821], type='b', pch=as.character(ds$class), col=myCol[ds$class], cex=1.2)

# ������ ��� �ִ��� Bar chart�� �׷�����
t <- table(ds$class[721:821])
print(t)
barplot(t, col='green')

# ���� ���� : ������ 100 �Ⱓ�� ���� ���� (Multinomial)�� center�� �̿��Ͽ�
# ��� ������ �׷�����. �� : ������ ���� ������ 1�� ������ 8.9%, 2�� ������
# 9.9%, 3�� ������ 17.8% ... �̹Ƿ� ��� ���� = 1�� * 8.9% + 2�� * 9.9% ...
# �� ���� ������ likely pattern�� �߷��ϸ� ��� ������ �߷��� �� ������?
# How ?? HMM ??
t <- t / sum(t)
v <- rep(0, 20)
for(i in 1:8) {
   v <- v + cl$centers[i,] * t[i]
}
plot(v, type='o', pch=20, col='red')