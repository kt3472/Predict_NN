source('FeatureSetTA.R')

# Yahoo 사이트로부터 KBSTAR200 주가 데이터를 읽어온다
#p <- getData('148020')

# 패턴 데이터 세트를 구성한다. 20일간의 종가를 한 패턴으로 구성한다.
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

# H-Cluster 로 Dendrogram을 그려보기 위해 일부 데이터만 clustering 한다
hcl <- hclust(dist(ds[1:50,]), method='average')
plot(hcl)

# H-Cluster 로 패턴을 8개의 클러스터로 분류한다.
k <- 8
hcl <- hclust(dist(ds), method='average')
cl <- cutree(hcl, k)

# 데이터 세트에 종가와 클러스터 번호 (패턴 번호)를 추가한다
ds$close <- close
ds$class <- cl

# 1번 패턴 그룹 몇 개만 그려본다.
par(mfrow=c(1,1), mar=c(2, 2, 2, 2), mgp=c(3, 0.3, 0))
pat.1 <- ds[which(ds$class == 1),]
plot(t(pat.1[1, 1:20]), type='o', pch=20)
for (i in seq(10, 50, by=10)) {
   lines(t(pat.1[i, 1:20]), type='o', pch=20, col=i)
}

# 종가 기준으로 주가 차트를 그리고, 그 위에 패턴 번호를 표시한다
par(mfrow=c(1,1))
myCol <- c("blue", "red", "black", "brown", "green", "purple", "pink", "green")
plot(ds$close[581:681], type='b', pch=as.character(ds$class), col=myCol[ds$class], cex=1.2)

# 패턴이 몇개씩 있는지 Bar chart를 그려본다
t <- table(ds$class[581:681])
print(t)
barplot(t, col='green')
