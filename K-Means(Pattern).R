source('FeatureSetTA.R')

# Yahoo 사이트로부터 KBSTAR200 주가 데이터를 읽어온다
p <- getData('148020')

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

# K-Means 알고리즘을 이용하여 패턴을 8개의 클러스터로 분류한다.
k <- 8
cl <- kmeans(ds, centers=k, iter.max=100, nstart=k)

# 8개의 대표 패턴을 시각화한다. 대표패턴은 각 클러스터의 중점 패턴임.
par(mfrow=c(2, k/2))
myCol <- c("blue", "red", "black", "brown", "green", "purple", "pink", "green")
for(i in 1:k) {
   title <- sprintf("Pattern - %d", i)
   
   # 각 클러스터의 중점 패턴을 그린다 (대표 패턴)
   plot(cl$centers[i,], type='o', main=title, col=myCol[i], pch=19)
}

# 데이터 세트에 종가와 클러스터 번호 (패턴 번호)를 추가한다
ds$close <- close
ds$class <- cl$cluster

# 1번 패턴 그룹 몇 개만 그려본다.
par(mfrow=c(1,1), mar=c(2, 2, 2, 2), mgp=c(3, 0.3, 0))
pat.1 <- ds[which(ds$class == 1),]
plot(t(pat.1[1, 1:20]), type='o', pch=20)
for (i in seq(10, 50, by=10)) {
   lines(t(pat.1[i, 1:20]), type='o', pch=20, col=i)
}

# 종가 기준으로 주가 차트를 그리고, 그 위에 패턴 번호를 표시한다
par(mfrow=c(1,1))
plot(ds$close[581:681], type='b', pch=as.character(ds$class), col=myCol[ds$class], cex=1.2)

# 패턴이 몇개씩 있는지 Bar chart를 그려본다
t <- table(ds$class[581:681])
print(t)
barplot(t, col='green')

# 참고 사항 : 마지막 100 기간의 패턴 분포 (Multinomial)와 center를 이용하여
# 기대 패턴을 그려본다. 예 : 마지막 패턴 분포는 1번 패턴이 8.9%, 2번 패턴이
# 9.9%, 3번 패턴이 17.8% ... 이므로 기대 패턴 = 1번 * 8.9% + 2번 * 9.9% ...
# 이 패턴 다음의 likely pattern을 추론하면 기대 패턴을 추론할 수 있을까?
# How ?? HMM ??
t <- t / sum(t)
v <- rep(0, 20)
for(i in 1:8) {
   v <- v + cl$centers[i,] * t[i]
}
plot(v, type='o', pch=20, col='red')
