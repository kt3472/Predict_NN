library(tm)
library(KoNLP)
library(ggplot2)
buildDictionary(ext_dic = "woorimalsam")

query <- "삼성전자 영업이익 실적"    # 검색어
doc <- 
   c("삼성전자가 비수기인 4분기에 깜짝 실적을 내놓으며 200만원 돌파 기대감을 키웠다. 애널리스트들은 1·2분기에도 탄탄한 실적이 기대된다며 갤럭시S8 출시가 실적과 주가의 분수령이 될 것으로 내다봤다",
      "6일 삼성전자가 지난해 4분기 9조2000억원의 잠정 영업이익을 기록했다고 발표하면서 2016년 한 해를 기분 좋게 마감했다",
      "삼성전자가 지난 4분기 9조원대의 영업이익을 달성했다. 영업익 9조원대는 지난 2013년 3분기(10조1600억원) 이후 13분기 만이다",
      "삼성전자가 모바일 액세서리 2종을 'CES 2017'에서 공개했다고 7일 밝혔다.",
      "삼성전자는 스마트폰 화면을 보이는 그대로 손 쉽게 인화할 수 있는 휴대용 포토 프린터 이미지 스탬프를 처음으로 선보였다",
      "이미지 스탬프는 스마트폰에 저장된 이미지뿐 아니라 영상이나 웹 화면 등 사용자가 인화를 원하는 이미지를 화면에 띄우고 이미지 스탬프에 올려놓기만 하면 NFC와 와이파이를 통해 바로 인화해주는 태그 앤 프린트 기능을 지원한다",
      "삼성전자는 휴대용 배터리팩으로 사용 가능한 블루투스 스피커 레벨 박스 슬림도 선보였다",
      "증시 전문가들은 작년 4분기에 깜짝 실적 어닝서프라이즈을 이룬 삼성전자가 올해 개선추세를 이어가 올해 영업이익이 40조원을 넘어설 수도 있을 것으로 전망했다",
      "삼성전자는 지난해 4분기 9조2000억원에 달하는 영업이익을 기록하며 지난 2013년3분기(10조1600억원) 이후 3년만에 최대 영업이익을 달성했다. 시장 컨센서스인 8조3000억원도 크게 웃도는 깜짝 실적이다",
      "삼성전자는 조만간 갤럭시 노트 7의 배터리 발화에 대한 원인에 대한 조사한 내용을 발표할 계획이라고 밝혔다")

doc <- c(doc, query)
nDoc <- length(doc)

# 코퍼스 생성
doc.corpus <- Corpus(VectorSource(doc))

# Corpus content 확인
doc.corpus[[1]]$content

# 각 문서에서 명사만 추출하고, Term-Document Matrix를 생성한다
extNoun <- function(x) { extractNoun(paste(x, collapse = " "))}

# TF 로 TDM을 생성함
tdm.tf <- TermDocumentMatrix(doc.corpus, control=list(tokenize=extNoun, wordLengths=c(2,Inf)))

# TF-IDF 로 TDM을 생성함
tdm.tfidf <- TermDocumentMatrix(doc.corpus, control=list(tokenize=extNoun, weighting = function(x) weightTfIdf(x, TRUE), wordLengths=c(2,Inf)))
tdmat <- as.matrix(tdm.tfidf)
tdmat       # TDM 확인

# TDM plot
# '삼성' 과 '전자'는 많은 문서에 등장하므로 중요도가 높게 평가됨. --> TF 입장
tf <- rowSums(as.matrix(tdm.tf))
tf <- subset(tf, tf >= 2)
df.tf <- data.frame(term = names(tf), freq = tf)
ggplot(df.tf, aes(x=term, y=freq)) + geom_bar(stat="identity", fill="green", color="darkgreen") + coord_flip()

# '삼성' 과 '전자'는 많은 문서에 등장하므로 범용적인 단어로 중요도가 낮게 평가됨. --> TF-IDF 입장
tfidf <- rowSums(as.matrix(tdm.tfidf))
tfidf <- subset(tfidf, tfidf >= 0.4)
df.tfidf <- data.frame(term = names(tfidf), tfidf = tfidf)
ggplot(df.tfidf, aes(x=term, y=tfidf)) + geom_bar(stat="identity", fill="green", color="darkgreen") + coord_flip()

# 벡터의 norm이 1이 되도록 정규화. 코사인 거리 계산을 위해 미리 정규화 시킴.
norm_vec <- function(x) {x/sqrt(sum(x^2))}
tdmat <- apply(tdmat, 2, norm_vec)

# TF-IDF로 문서의 유사도를 계산함
similality <- t(tdmat[, 11]) %*% tdmat[, 1:(nDoc-1)]

# 유사도가 높은 순으로 검색 순위를 결정한다.
doc <- doc[-11]
names(doc) <- paste("Doc #", 1:length(doc), sep="")
orders <- data.frame(doc=names(doc),scores=t(similality), stringsAsFactors=FALSE)
orders[order(similality, decreasing=T),]

# TF-IDF로 문서를 3그룹으로 클러스터링 한다
fit <- hclust(dist(t(tdmat[, -11])), method="ward.D")
plot(fit)
rect.hclust(fit, k = 3)

# "실적" 과 관련성이 있는 단어 검색
assoc <- as.data.frame(findAssocs(tdm.tf, "실적", 0.2))
assoc
