clear all
clc
loadData

train.X(:,1) = [];
testAF.X(:,1) = [];
testNormal.X(:,1) = [];

fold = 10;

trainPositive = train.X(1:size(train.X,1)/2,:);
trainNegative = train.X(size(train.X,1)/2+1:end,:);

Threshold = [0:0.05:1];

%corss validation to find optimal C
crossACC = [];
for i = 1:length(Threshold)
    options = Threshold(i);
    
    crossACC(i) = sum(trainPositive > options) + sum(trainNegative < options);
end

[maxV, maxI] = max(crossACC);
optimalT = Threshold(maxI);
optimalOptions = optimalT;

accTrainAF = sum(trainPositive > optimalT)/length(trainPositive)
accTrainNormal = sum(trainNegative < optimalT)/length(trainNegative)

accTestAF = sum(testAF.X > optimalT)/length(testAF.X)
accTestNormal = sum(testNormal.X < optimalT)/length(testNormal.X)
