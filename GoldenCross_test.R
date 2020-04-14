require(quantmod)
source('GoldenCross.R')

# 삼성전자 주식 데이터를 가져온다
# 데이터는 시가, 고가, 저가, 종가, 거래량을 포함함 (OHLC data)
p <- getData('005930')

# 단기/장기 이동평균을 지정하여 Golden cross 성능을 확인한다
# 전략 시나리오 : 단기 이평이 장기 이평 아래에 있을 때는 매수 유지
#                 단기 이평이 장기 이평 위에 있을 때는 매도 유지
r <- goldenCross(p['2013::'], 5, 20, chart = TRUE)
r <- goldenCross(p['2013::'], 10, 40, chart = TRUE)

# Optimization
# 수익률 최대, 누적 수익률 표준편차 최소, 그리고 Sharp ratio 최대인 기간을 찾음
opt <- optimize(p['2007-01-01::2012-12-31'], 5, 40, 15, 120)
opt

# 결과는 단기 이평 = 17일, 장기 이평 = 36일 일 때 Sharp ratio가 최대였음
# 이 기간으로 성능 및 분포를 확인함
r <- goldenCross(p['2013-01-01::'], 17, 36, chart = TRUE)
plot(density(r), main = 'Return Density')
abline(v = mean(r), col = 'red')

# 이 기간으로 연도별 성능를 확인해 봄
r <- goldenCross(p['2013'], 17, 36, chart = TRUE)
r <- goldenCross(p['2014'], 17, 36, chart = TRUE)
r <- goldenCross(p['2015'], 17, 36, chart = TRUE)
r <- goldenCross(p['2016'], 17, 36, chart = TRUE)
