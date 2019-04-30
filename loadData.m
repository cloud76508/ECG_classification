clear all
clc

% import the data of normal ECG
%temp = fopen('nsr180_data.csv');
temp = fopen('C:\Users\User\Documents\GitHub\ECG_classification\final_version_data\data_nsr180.csv');
normalRaw = textscan(temp, '%s', 'Delimiter',',');
% fix some formatting issue
temp = normalRaw{1,1}{1};
%temp = temp(3:end);
temp = temp(4:end);
normalRaw{1,1}{1} = temp;

for n =1:length(normalRaw{1,1})
    normalRawNumber(n,1) = str2num(normalRaw{1,1}{n});
end

for n= 1:length(normalRawNumber)/360
   normalSample((n-1)*180+1:(n-1)*180+180,1) = normalRawNumber((n-1)*360+1:(n-1)*360+180,1);
   normalSample((n-1)*180+1:(n-1)*180+180,2) = normalRawNumber((n-1)*360+181:(n-1)*360+360,1); 
end

% import the data of AF ECG
%temp = fopen('af180_data.csv');
temp = fopen('C:\Users\User\Documents\GitHub\ECG_classification\final_version_data\data_af180.csv');
AFRaw = textscan(temp, '%s', 'Delimiter',',');
% fix some formatting issue
temp = AFRaw{1,1}{1};
%temp = temp(3:end);
temp = temp(4:end);
AFRaw{1,1}{1} = temp;

for n =1:length(AFRaw{1,1})
    AFRawNumber(n,1) = str2num(AFRaw{1,1}{n});
end

for n= 1:length(AFRawNumber)/360
   AFSample((n-1)*180+1:(n-1)*180+180,1) = AFRawNumber((n-1)*360+1:(n-1)*360+180,1);
   AFSample((n-1)*180+1:(n-1)*180+180,2) = AFRawNumber((n-1)*360+181:(n-1)*360+360,1); 
end

% Random permutation of AF samples
randomOrderAF = randperm(size(AFSample,1));
temp = [];
for n =1:size(AFSample,1)
    temp(n,:) = AFSample(randomOrderAF(n),:);
end
AF = temp;

% Random permutation of Normal samples
randomOrderNor = randperm(size(normalSample,1));
temp = [];
for n =1:size(normalSample,1)
    temp(n,:) = normalSample(randomOrderNor(n),:);
end
normal = temp;

% training data
train.X = [AF(1:1000,:);normal(1:1000,:)];
train.Y = [ones(1000,1); zeros(1000,1)];

% AF test data
testAF.X = [AF(1001:end,:)];
testAF.Y = [ones(size(testAF.X,1),1)];

% Normal test data
testNormal.X = [normal(1001:end,:)];
testNormal.Y = [zeros(size(testNormal.X,1),1)];

% scale parameters obtain from training data
maxTrainX = max(train.X);
minTrainX = min(train.X);

% normalize train.X
temp = [];
for n = 1:size(train.X,1)
    temp(n,1) = (train.X(n,1)-minTrainX(1))/(maxTrainX(1) - minTrainX(1)); 
    temp(n,2) = (train.X(n,2)-minTrainX(2))/(maxTrainX(2) - minTrainX(2));
end
train.X = temp;

% normalize testAF.X
temp = [];
for n = 1:size(testAF.X,1)
    temp(n,1) = (testAF.X(n,1)-minTrainX(1))/(maxTrainX(1) - minTrainX(1)); 
    temp(n,2) = (testAF.X(n,2)-minTrainX(2))/(maxTrainX(2) - minTrainX(2));
end
testAF.X = temp;

% normalize testNormal.X
temp = [];
for n = 1:size(testNormal.X,1)
    temp(n,1) = (testNormal.X(n,1)-minTrainX(1))/(maxTrainX(1) - minTrainX(1)); 
    temp(n,2) = (testNormal.X(n,2)-minTrainX(2))/(maxTrainX(2) - minTrainX(2));
end
testNormal.X = temp;

clearvars -except train testAF testNormal maxTrainX minTrainX

% model = svmtrain(train.Y, train.X);
% [Prediction, Acc, values] = svmpredict(train.Y,train.X,model);
