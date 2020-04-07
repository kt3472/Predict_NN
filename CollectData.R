library(quantmod)
printf <- function(...) cat(sprintf(...))

# �� ������ �����͸� �����´�
# -----------------------
getData <- function(x, from) {
   if (missing(from)) {
      stock <- getSymbols(paste(x, ".KS", sep = ""), auto.assign = FALSE)
   } else {
      stock <- getSymbols(paste(x, ".KS", sep = ""), from=from, auto.assign = FALSE)
   }
   
   # ��� �м��� ���� �ְ� (adjusted)�� �̿��Ѵ�
   stock <- adjustOHLC(stock, use.Adjusted=TRUE)
   
   # �ŷ����� 0 �� �����ʹ� �����Ѵ� (��,����)
   stock <- stock[Vo(stock) > 0]
   
   # colume �̸��� �ٲ۴�
   colnames(stock) <- c("open", "high", "low", "close", "volume", "adjusted")
   
   getData <- stock
}

# �����ְ������� �о�´� (Partial Correlation ���� �ʿ���)
# ------------------------------------------------------
getKospi <- function(from) {
   if (missing(from)) {
      stock <- getSymbols('^KS11', auto.assign = FALSE)
   } else {
      stock <- getSymbols('^KS11', from=from, auto.assign = FALSE)
   }
   
   # �����ְ��� �ٲ� �� ����
   stock <- adjustOHLC(stock, use.Adjusted=TRUE)
   
   # colume �̸��� �ٲ۴�
   colnames(stock) <- c("open", "high", "low", "close", "volume", "adjusted")
   
   getKospi <- stock
}

# ���� ���ͷ� Set�� �о�´�
getRtnDataSet <- function(file, fd='2010-01-01') {
   if (missing(file)) {
      pList <- read.csv("data/���񸮽�Ʈ.csv", stringsAsFactors=FALSE)
      
      # ���� ����Ʈ�� ù ��° ���� �����͸� �о�ͼ� ���ͷ��� ����صд�
      sPrice <- getData(substr(pList[1, 4], 2, 7), from=fd)
      
      sRtn <- ROC(sPrice$close)
      colnames(sRtn) <- pList[1, 2]
      printf("1. %s ������ ó���� �Ϸ��߽��ϴ�.\n", pList[1, 1])
      
      # ���� ����Ʈ�� �� ��°���� ���������� �ְ� �����͸� �о�ͼ� ���ͷ��� ����Ѵ�.
      for (i in 2:nrow(pList)) {
         sPrice <- getData(substr(pList[i, 4], 2, 7), from=fd)
         
         sTmp <- ROC(sPrice$close)
         colnames(sTmp) <- pList[i, 2]
         sRtn <- cbind(sRtn, sTmp)
         
         printf("%d. %s ������ ó���� �Ϸ��߽��ϴ�.\n", i, pList[i, 1])
      }
      
      # ����� �����صд�
      write.zoo(sRtn, "portfolio.csv", sep=",")
   } else
      sRtn <- as.xts(read.zoo(file=file, header=TRUE, sep = ",", format = "%Y-%m-%d"))
   
   getRtnDataSet <- na.omit(sRtn)
}
