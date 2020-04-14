library(class)
source('FeatureSetTA.R')

# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
#p <- getData('005930')

# ����� �м� Feature ������ ��Ʈ�� �����Ѵ�
ds <- FeatureSetTA(p)

# �Ʒÿ� ������, �׽�Ʈ�� �����͸� �����Ѵ�
train <- ds$train[, -10]        # Class ����
test <- ds$test[, -10]          # Class ����
class <- factor(as.vector(ds$train[, 10]))

# KNN �з���� train �����͸� �н��ϰ� test ������ class�� �����Ѵ�
# k �� 100���� �����Ѵ� (���Ƿ� ����)
# knn() �Լ��� ���ο��� �Ÿ��� ���� ���� (tied point)�� ���� ó���� ���� ��Ұ� ����
# ������ tie�� �����ϴ� ��� ������ ������ ����� �޶��� �� ����.
# ���� ����� �������� set.seed() ������ knn()�� ������.
testClass <- knn(train, test, class, k=100)

# test set�� ������ class�� ǥ���Ѵ�
ds$test$predict <- testClass

# ������ �� �Ǿ����� �������� Ȯ���Ѵ�
head(ds$test)
tail(ds$test)

# ��Ȯ���� ����Ѵ�
cm <- table(ds$test$class, testClass)
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
print(accuracy)

# k ���� ��ȭ��Ű�鼭 accuracy�� ���� ���� k �� ã�ƺ���.
nk = 3
accuracy <- rep(0, nk)
for (k in 1:nk) {
   testClass <- knn(train, test, class, k=k)
   cm <- table(ds$test$class, testClass)
   accuracy[k] <- sum(diag(cm)) / length(testClass)
}

# accuracy�� ���� ���� k ���� ã�´�. max�� ������ ���� �� ����. ù ��° ���� �����.
ko <- which(accuracy == max(accuracy))[1]
printf("\n* ���� k = %d\n", ko)
printf("* ��Ȯ�� = %.2f\n", accuracy[ko])

# accuracy�� �׷����� �׷�����
plot(accuracy, type='l', col='blue', main="k ��ȭ�� ���� ��Ȯ���� ��ȭ", xlab="k")
abline(v = ko, col='red')

# prediction�� �����͸� ������ ����
prediction <- knn(train, ds$pred, class, k=ko)

if (prediction == 1) {
   printf("\n* ���� �ְ��� �϶��� ������ �����. ��Ȯ�� = %.2f\n", accuracy[ko])
} else {
   printf("\n* ���� �ְ��� ����� ������ �����. ��Ȯ�� = %.2f\n", accuracy[ko])
}

