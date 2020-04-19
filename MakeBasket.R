# HTS에서 종목별, 날짜별로 수집한 외국인, 기관 개인의 순 거래량으로 Transaction 데이터
# (혹은 Basket 데이터)를 생성한다.
# ------------------------------------------------------------------------------------

getCode <- function(date, x) {
   n <- which(x$date == date)
   getCode <- as.vector(x$code[n])
}

# 원시 데이터를 transaction (or Basket) 데이터로 변환한다
# n : 외국인 순거래량 = 12번째, 기관 순거래량 = 13번째, 개인 순거래량 = 14번째 colume
# -----------------------------------------------------------------------------------
MakeBasket <- function(x, n=12, trade="Buy") {
   if (trade == "Buy") {
      tmp <- x[which(x[, n] > 0),]
   } else {
      tmp <- x[which(x[, n] < 0),]
   }
   tmp1 <- data.frame(date=tmp[, 2], code=tmp[,1], stringsAsFactors=FALSE)
   tmp2 <- tmp1[order(tmp1$date),]
   
   ds <- data.frame(date=unique(tmp2$date))

   v <- as.list(apply(ds, 1, getCode, tmp2))
   
   # transaction 데이터를 생성한다
   MakeBasket <- as(v, "transactions")
}
