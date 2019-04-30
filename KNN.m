clear all
clc
loadData

% train.X(:,1) = [];
% testAF.X(:,1) = [];
% testNormal.X(:,1) = [];

fold = 10;

trainPositive = train.X(1:size(train.X,1)/2,:);
trainNegative = train.X(size(train.X,1)/2+1:end,:);

K = [1,3,5,7,9,11,13,15];

%corss validation to find optimal C
crossACC = [];
for i = 1:length(K)
    options = K(i);
    val.X = [];
    val.y = [];
    learn.X = [];
    learn.y = [];
    tempACC = [];
    for n = 1:fold
        val.X = [trainPositive((n-1)*(size(trainPositive,1)/fold)+1:n*(size(trainPositive,1)/fold),:);...
            trainNegative((n-1)*(size(trainNegative,1)/fold)+1:n*(size(trainNegative,1)/fold),:)];
        val.y = [ones(size(val.X,1)/2,1);zeros(size(val.X,1)/2,1)];
        
        temp = trainPositive;
        temp((n-1)*(size(temp,1)/fold)+1:n*(size(temp,1)/fold),:) = [];
        learn.X = [learn.X;temp];
        
        temp = trainNegative;
        temp((n-1)*(size(temp,1)/fold)+1:n*(size(temp,1)/fold),:) = [];
        learn.X = [learn.X;temp];
        
        learn.y = [ones(size(learn.X,1)/2,1);zeros(size(learn.X,1)/2,1)];
        
        model = fitcknn(learn.X, learn.y,'NumNeighbors',options);
        valLabel = predict(model,val.X);
        valACC = sum(valLabel== val.y)/length(val.y);
        
        tempACC = [tempACC, valACC];
    end
    crossACC = [crossACC, mean(tempACC)];
end

[maxV, maxI] = max(crossACC);
optimalK = K(maxI);

optimalOptions = optimalK;

optimal_model = fitcknn(train.X,train.Y,'NumNeighbors',optimalOptions);

labelTrainAF = predict(optimal_model,train.X(1:1000,:));
accTrainAF = sum(train.Y(1:1000) ==labelTrainAF)/length(labelTrainAF)

labelTrainNormal = predict(optimal_model,train.X(1001:end,:));
accTrainNormal = sum(train.Y(1001:end) ==labelTrainNormal)/length(labelTrainNormal)

labelTestAF = predict(optimal_model,testAF.X);
accTestAF = sum(testAF.Y ==labelTestAF)/length(labelTestAF)

labelTestNormal = predict(optimal_model,testNormal.X);
accTestNormal = sum(testNormal.Y ==labelTestNormal)/length(labelTestNormal)
