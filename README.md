## R을 활용한 데이터 마이닝 2기 Review


**1. CollectData.R**
  - 주가 데이터 수집 Source (from 구글, 야후)
  - getData function : 한종목의 주가데이터를 가져옴
  - getKospi function : 코스피지수 주가데이터를 가져옴
  
**2. GoldenCross.R / GoldenCross_test.R**
  - 기술적분석의 이동평균선 골든크로스/데드크로스 지표를 이용한 Back testing
  - 단기/장기 이동평균 기간을 달리하여 Back testing 후 최적 이동평균 기간을 찾음  
  
**3. Smoothing.R**
  - 시계열 데이터 평활화(단순이동평균, Kernel Regression, Spline)
    
**4. FeatureSetTA.R / Technical_analysis.R**
  - 주가의 9개의 기술적 분석지표값으로 구성된 train/test data set 생성
  - ATR변동성, SMI, ADX, Aroon추세, Bollinger Band, MACD, OBV, 5일 이평 등의 기술적분석 지표

**5. DecesionTree.R**
  - Decesion Tree 알고리즘 : https://ratsgo.github.io/machine%20learning/2017/03/26/tree/
  - 주가의 기술적분석 지표 데이터를 Decision Tree 알고리즘으로 분석하여 내일 주가의 상승/하락을 예측  

**6. knn.R**
  - k-NN 알고리즘 : https://ko.wikipedia.org/wiki/K-최근접_이웃_알고리즘
  - 주가의 기술적분석 지표 데이터를 KNN알고리즘으로 분석하여 내일 주가의 상승/하락을 예측  
  
**7. HClust(Pattern).R**
  - Hierarchical-Clustering 알고리즘 : https://ratsgo.github.io/machine%20learning/2017/04/18/HC/
  - 20일 주가추이를 H-clustering 알고리즘으로 8개의 패턴으로 분류 
    
**8. stock_price_simulation.R / HiddenMarkovModel_example.R / BCP.R**
  - 은닉마르코프모형 : https://ko.wikipedia.org/wiki/은닉_마르코프_모형
  - Bayesian Change Point(BCP) : 확률구조에 변화가 생기면 그 지점을 변환점으로 판단, 변환점의 위치와 확률을 추론
  
**9. K-Means(Pattern).R**
  - K-mean 클러스터링 알고리즘 : https://ko.wikipedia.org/wiki/K-평균_알고리즘
  - 20일 주가추이를 K-means알고리즘으로 8개의 패턴으로 분류 
  
**10. NeuralNet_filedata.R / NeuralNet_webdata.R**
  - 인공신경망 알고리즘 : https://ko.wikipedia.org/wiki/인공_신경망
  - 당일 시초가로 기술적지표(RSI, EMA cross, MACD signal, BBand 등)를 학습하여 당일 종가의 상승/하락을 예측
  
**11. RandomForest.R**
  - Random Forest알고리즘 : https://ko.wikipedia.org/wiki/랜덤_포레스트
  - 훈련데이터를 여러 개로 나눈 후 각각에 대해 Decision Tree를 구축하고, 결과를 종합하여 예측
  
**16. baggingSVM.R**
  - 훈련데이터를 여러개로 나눈 후 각각에 대해 SVM모형을 적용한 후 결과를 좋합하여 예측
  - bagging : https://dbrang.tistory.com/1394
  
**17. boostingDT.R**
  - 훈련데이터를 부스팅방식으로 여러개로 나눈 후 각각에 대해 Decision Tree를 구축하고, 결과를 종합하여 예측
  - AdaBoost 알고리즘 이용 : https://ko.wikipedia.org/wiki/에이다부스트
  
**18. FeatureSetTAP.R / hybrid(knn).R**
  - 주가패턴(20일)과 캔들패턴을 분류한후 train data set에 추가한후 k-NN알고리즘으로 주가의 방향을 예측
  - 비지도학습으로 분류 -> 지도학습을 위한 데이터 Feature로 활용 
  
**20. svm.R / svm-1.R**
  - SVM(Support Vector Machine) 알고리즘 : https://ko.wikipedia.org/wiki/서포트_벡터_머신
  - 주가의 기술적분석 지표 데이터를 SVM알고리즘을 사용하여 내일 주가의 상승/하락을 예측(RBF Kernel function 사용) 
  
