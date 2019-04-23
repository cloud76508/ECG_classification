clear all
clc
loadData

% train.X(:,1) = [];
% testAF.X(:,1) = [];
% testNormal.X(:,1) = [];

fold = 10;

trainPositive = train.X(1:size(train.X,1)/2,:);
trainNegative = train.X(size(train.X,1)/2+1:end,:);

C = [ 2^-2,2^-1,2^0,2^1,2^2,2^3,2^4, 2^5, 2^6, 2^7];

%corss validation to find optimal C
crossACC = [];
for i = 1:length(C)
    options = sprintf('-s 0 -t 0 -h 0 -c %f', C(i));
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
        
        model = svmtrain(learn.y,learn.X,options);
        [valPre, valACC, ~] = svmpredict(val.y ,val.X, model);
        tempACC = [tempACC, valACC(1)];
    end
    crossACC = [crossACC, mean(tempACC)];
end

[maxV, maxI] = max(crossACC);
optimalC = C(maxI);

optimalOptions = sprintf('-s 0 -t 0 -h 0 -c %f', optimalC);

optimal_model = svmtrain(train.Y,train.X,optimalOptions);

[preTrainAF, accTrainAF, ~] = svmpredict(train.Y(1:1000) ,train.X(1:1000,:), optimal_model);

[preTrainNormal, accTrainNormal, ~] = svmpredict(train.Y(1001:end) ,train.X(1001:end,:), optimal_model);

[preAF, accPre, ~] = svmpredict(testAF.Y ,testAF.X, optimal_model);

[preNormal, accNormal, ~] = svmpredict(testNormal.Y ,testNormal.X, optimal_model);
    