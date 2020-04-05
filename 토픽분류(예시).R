library(tm)
library(topicmodels)
library(KoNLP)
source('10-4.MySubTm.R')
printf <- function(...) cat(sprintf(...))

# 문서 (LDAtest.csv)의 
# 1 ~ 100 까지는 theta1 의 주제 분포로 생성된 것이고
# 101 ~ 200 까지는 theta2 의 주제 분포로 생성된 것임.
#
# theta1 <- c(0.05, 0.15, 0.60, 0.10, 0.10)   <-- 3번 토픽 확률이 높음
# theta2 <- c(0.05, 0.05, 0.20, 0.10, 0.60)   <-- 5번 토픽 확률이 높음
#
# 이 문서를 읽어서 2 개 토픽으로 분류한 후 결과가 잘 맞는지 확인함.
# ====================================================================
docs <- read.csv("data/LDAtest.csv", header=T, stringsAsFactors=F)

# 문서 Corpus 생성
docs.corp <- Corpus(DataframeSource(docs))

# Term document matrix & Document Term matrix 생성
splitWords <- function(x) { as.vector(strsplit(x$content, " ")[[1]]) }
tdm <- TermDocumentMatrix(docs.corp, control=list(tokenize=splitWords, wordLengths=c(1,Inf)))
dtm <- as.DocumentTermMatrix(tdm)

# Latent Dirichlet Allocation. Topic 수 = 2개
k = 2
lda <- LDA(dtm, k, method="Gibbs")

# 토픽별 단어 분포
beta <- list()
for (i in 1:k) {
   t <- as.data.frame(posterior(lda)$term[i,])
   t1 <- as.data.frame(cbind(row.names(t), t[,1]), stringsAsFactors=F)
   t1[,2] <- as.numeric(t1[,2])
   t1 <- t1[which(t1[,2] > 0.04),]
   t1 <- t1[order(t1[,2], decreasing = TRUE),]
   colnames(t1) <- c("Terms", "Probability")
   t1$Probability <- round(t1$Probability, 4)
   
   beta[[i]] <- t1
   
   printf("\n* Topic #%d\n", i)
   print(beta[[i]])
   printf("\n")
}

# 문서별 토픽 분포
theta <- as.data.frame(posterior(lda)$topic)

colnames(theta) <- paste("Topic #", 1:k, sep="")
rownames(theta) <- paste("Doc #", 1:200, sep="")

# 확률이 가장 높은 토픽을 찾아서 Class로 표시함
FindClass <- function(x) { which(x == max(x))[1] }
theta$class <- apply(theta, 1, FindClass)
printf("\n*문서별 토픽 분포 [1:5]\n")
print(theta[1:5,])
printf("\n")
print(table(theta$class))

