source('3-2.FeatureSetTA.R')

# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
#p <- getData('005930')

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

# H-Cluster �� Dendrogram�� �׷����� ���� �Ϻ� �����͸� clustering �Ѵ�
hcl <- hclust(dist(ds[1:50,]), method='average')
plot(hcl)

# H-Cluster �� ������ 8���� Ŭ�����ͷ� �з��Ѵ�.
k <- 8
hcl <- hclust(dist(ds), method='average')
cl <- cutree(hcl, k)

# ������ ��Ʈ�� ������ Ŭ������ ��ȣ (���� ��ȣ)�� �߰��Ѵ�
ds$close <- close
ds$class <- cl

# 1�� ���� �׷� �� ���� �׷�����.
par(mfrow=c(1,1), mar=c(2, 2, 2, 2), mgp=c(3, 0.3, 0))
pat.1 <- ds[which(ds$class == 1),]
plot(t(pat.1[1, 1:20]), type='o', pch=20)
for (i in seq(10, 50, by=10)) {
   lines(t(pat.1[i, 1:20]), type='o', pch=20, col=i)
}

# ���� �������� �ְ� ��Ʈ�� �׸���, �� ���� ���� ��ȣ�� ǥ���Ѵ�
par(mfrow=c(1,1))
myCol <- c("blue", "red", "black", "brown", "green", "purple", "pink", "green")
plot(ds$close[721:821], type='b', pch=as.character(ds$class), col=myCol[ds$class], cex=1.2)

# ������ ��� �ִ��� Bar chart�� �׷�����
t <- table(ds$class[721:821])
print(t)
barplot(t, col='green')