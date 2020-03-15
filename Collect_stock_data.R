library(quantmod)
printf <- function(...) cat(sprintf(...))

# 한 종목의 데이터를 가져온다
# -----------------------
getData <- function(x, from) {
   if (missing(from)) {
      stock <- getSymbols(paste(x, ".KS", sep = ""), auto.assign = FALSE)
   } else {
      stock <- getSymbols(paste(x, ".KS", sep = ""), from=from, auto.assign = FALSE)
   }
   
   # 모든 분석은 수정 주가 (adjusted)를 이용한다
   stock <- adjustOHLC(stock, use.Adjusted=TRUE)
   
   # 거래량이 0 인 데이터는 제외한다 (공,휴일)
   stock <- stock[Vo(stock) > 0]
   
   # colume 이름을 바꾼다
   colnames(stock) <- c("open", "high", "low", "close", "volume", "adjusted")
   
   getData <- stock
}

# 종합주가지수를 읽어온다 (Partial Correlation 계산시 필요함)
# ------------------------------------------------------
getKospi <- function(from) {
   if (missing(from)) {
      stock <- getSymbols('^KS11', auto.assign = FALSE)
   } else {
      stock <- getSymbols('^KS11', from=from, auto.assign = FALSE)
   }
   
   # 수정주가로 바꾼 후 리턴
   stock <- adjustOHLC(stock, use.Adjusted=TRUE)
   
   # colume 이름을 바꾼다
   colnames(stock) <- c("open", "high", "low", "close", "volume", "adjusted")
   
   getKospi <- stock
}

# 종목별 수익률 Set을 읽어온다
getRtnDataSet <- function(file, fd='2010-01-01') {
   if (missing(file)) {
      pList <- read.csv("data/종목리스트.csv", stringsAsFactors=FALSE)
      
      # 종목 리스트의 첫 번째 종목 데이터를 읽어와서 수익률을 계산해둔다
      sPrice <- getData(substr(pList[1, 4], 2, 7), from=fd)
      
      sRtn <- ROC(sPrice$close)
      colnames(sRtn) <- pList[1, 2]
      printf("1. %s 데이터 처리를 완료했습니다.\n", pList[1, 1])
      
      # 종목 리스트의 두 번째부터 마지막까지 주가 데이터를 읽어와서 수익률을 계산한다.
      for (i in 2:nrow(pList)) {
         sPrice <- getData(substr(pList[i, 4], 2, 7), from=fd)
         
         sTmp <- ROC(sPrice$close)
         colnames(sTmp) <- pList[i, 2]
         sRtn <- cbind(sRtn, sTmp)
         
         printf("%d. %s 데이터 처리를 완료했습니다.\n", i, pList[i, 1])
      }
      
      # 결과를 저장해둔다
      write.zoo(sRtn, "portfolio.csv", sep=",")
   } else
      sRtn <- as.xts(read.zoo(file=file, header=TRUE, sep = ",", format = "%Y-%m-%d"))
   
   getRtnDataSet <- na.omit(sRtn)
}

