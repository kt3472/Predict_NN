library(tm)
library(SnowballC)
library(topicmodels)
source('MySubTm.R')

# 문서
docs <- c("I like to eat broccoli and bananas and He doesn't like banana.",
          "I ate a banana and spinach smoothie for breakfast. Banana is my favorite.",
          "Chinchillas and kitten are cute.",
          "My sister adopted a kitten yeterday.",
          "Look at this cute kitten munching on a piece of cake.")

# 문서 Corpus 생성
docs.corp <- Corpus(VectorSource(docs))

# Corpus 내용의 content 확인
# as.data.frame(sapply(a, as.character))

# Corpus 내용을 모두 소문자로 변환함
docs.corp <- tm_map(docs.corp, content_transformer(tolower))

# 영문자 이외의 문자 제거 
docs.corp <- tm_map(docs.corp, content_transformer(function(x) gsub("[^[:alpha:][:space:]]*", "", x)))

# Stop words : stopwords("english") 에 등록된 단어를 모두 제거함 (ex : i, me, my, am, is ...)
docs.corp <- tm_map(docs.corp, removeWords, stopwords("english"))

# Stemming (ex : making --> make, prices --> price) : apple --> appl, google --> googl 로 변환됨 (??)
stemmed <- tm_map(docs.corp, stemDocument)
docs.corp <- lapply(stemmed, stemCompletion2, dictionary=docs.corp)

# 불규칙 동사의 과거형, 과거분사형을 현재형으로 변환함
docs.corp <- lapply(docs.corp, Verb2Infinitive)

docs.corp <- Corpus(VectorSource(docs.corp))

# Term document matrix & Document Term matrix 생성
tdm <- TermDocumentMatrix(docs.corp, control=list(wordLengths=c(1,Inf)))
dtm <- as.DocumentTermMatrix(tdm)

# tdm, dtm matrixx 확인
# as.matrix(tdm)
# as.matrix(dtm)

# Latent Dirichlet Allocation. Topic 수 = 2개
lda <- LDA(dtm, k=2)

# 토픽별 단어 분포
t <- as.data.frame(posterior(lda)$term[1,])
t1 <- cbind(row.names(t), t[,1])
t1 <- t1[order(t1[,2], decreasing = TRUE),]
         
t <- as.data.frame(posterior(lda)$term[2,])
t2 <- cbind(row.names(t), t[,1])
t2 <- t2[order(t2[,2], decreasing = TRUE),]
topic <- cbind(t1, t2)
colnames(topic) <- c("Topic-1$word", "Topic-1$beta", "Topic-2$word", "Topic-2$beta")
cat("토픽 별 단어 분포\n")
print(head(topic, 7))

# 문서별 토픽 분포
d <- as.data.frame(posterior(lda)$topic)
colnames(d) <- c("Topic-1", "Topic-2")
rownames(d) <- c("Doc-1", "Doc-2", "Doc-3", "Doc-4", "Doc-5")
cat('\n')
cat("문서별 토픽 분포\n")
print(d)


