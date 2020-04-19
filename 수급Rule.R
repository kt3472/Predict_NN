# HTS에서 종목별, 날짜별로 수집한 외국인, 기관 개인의 순 거래량 데이터에서
# 연관 규칙을 찾아본다.
# ------------------------------------------------------------------------
library(arules)
library(arulesViz)
source("MakeBasket.R")

# 원시 데이터를 읽어온다
x <- read.csv("data/수급데이터.csv", stringsAsFactors=FALSE)

# 원시 데이터를 Item Matrix in sparce format으로 변형한다
# 12 : 외국인
tr <- MakeBasket(x, n=14, trade="Buy")

# Item Matrix를 확인한다 (시각화)
image(tr[1:10])

# 거래 종목의 비율을 확인한다
itemFrequency(tr)
itemFrequencyPlot(tr, col='green')

# aprior 알고리즘으로 연관 규칙을 분석한다. (min support = 0.1, min confidence = 0.1)
rules <- apriori(data = tr, parameter = list(support = 0.1, confidence = 0.1, minlen=3))

# 연관 규칙을 확인한다. (향상도 순서)
inspect(sort(rules, by="lift")[1:10])

# 연관 규칙을 네트워크 형태로 확인한다
plot(sort(rules, by="lift")[1:30], method="graph")

