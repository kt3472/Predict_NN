## R을 활용한 데이터 마이닝 2기 Review


**1. BCP.R**
  - w
  - w

**2. CollectData.R**
  - 주가 데이터 수집 Source (from 구글, 야후)
  - getData function : 한종목의 주가데이터를 가져옴
  - getKospi function : 코스피지수 주가데이터를 가져옴


**4. DecesionTree.R**
  - Decesion Tree 알고리즘 : https://ratsgo.github.io/machine%20learning/2017/03/26/tree/
  - 주가의 기술적분석 지표 데이터를 Decision Tree 알고리즘으로 분석하여 내일 주가의 상승/하락을 예측  

**5. FeatureSetTA.R**
  - 주가의 9개의 기술적 분석지표값으로 구성된 train/test data set 생성
  - ATR변동성, SMI, ADX, Aroon추세, Bollinger Band, MACD, OBV, 5일 이평 등의 기술적분석 지표
  
**5. knn.R**
  - k-NN 알고리즘 : https://ko.wikipedia.org/wiki/K-최근접_이웃_알고리즘
  - 주가의 기술적분석 지표 데이터를 KNN알고리즘으로 분석하여 내일 주가의 상승/하락을 예측  

**6. FeatureSetTAP.R**
  - w
  - w

**7. GoldenCross.R / GoldenCross_test.R**
  - 기술적분석의 이동평균선 골든크로스/데드크로스 지표를 이용한 Back testing
  - 단기/장기 이동평균 기간을 달리하여 Back testing 후 최적 이동평균 기간을 찾음
  
**8. HClust(Pattern).R**
  - Hierarchical-Clustering 알고리즘 : https://ratsgo.github.io/machine%20learning/2017/04/18/HC/
  - 20일 주가추이를 H-clustering 알고리즘으로 8개의 패턴으로 분류 
    
**9. HiddenMarkovModel_example.R**
  - w
  - w
  
**10. K-Means(Pattern).R**
  - K-mean 클러스터링 알고리즘 : https://ko.wikipedia.org/wiki/K-평균_알고리즘
  - 20일 주가추이를 K-means알고리즘으로 8개의 패턴으로 분류 
  
**11. NeuralNet_filedata.R**
  - w
  - w
  
**12. NeuralNet_webdata.R**
  - w
  - w
  
**13. RandomForest.R**
  - w
  - w
  
**14. Smoothing.R**
  - 시계열 데이터 평활화(단순이동평균, Kernel Regression, Spline)
    
**15. Technical_analysis.R**
  - w
  - w
  
**16. baggingSVM.R**
  - 훈련데이터를 여러개로 나눈 후 각각에 대해 SVM모형을 적용한 후 결과를 좋합하여 예측
  - bagging : https://dbrang.tistory.com/1394
  
**17. boostingDT.R**
  - w
  - w
  
**18. hybrid(knn).R**
  - 주가패턴(20일)과 캔들패턴을 분류한후 train data set에 추가한후 k-NN알고리즘으로 주가의 방향을 예측
  - 비지도학습으로 분류 -> 지도학습을 위한 데이터 Feature로 활용 
  
**19. stock_price_simulation.R**
  - w
  - w
  
**20. svm.R / svm-1.R**
  - SVM(Support Vector Machine) 알고리즘 : https://ko.wikipedia.org/wiki/서포트_벡터_머신
  - 주가의 기술적분석 지표 데이터를 SVM알고리즘을 사용하여 내일 주가의 상승/하락을 예측(RBF Kernel function 사용) 
  
**21. svmTA.R**
  - w
  - w
  
**22. 문서검색분류.R**
  - w
  - w
  
**23. 토픽모델(예시).R**
  - w
  - w
  
**24. 토픽분류(예시).R**
  - w
  - w
