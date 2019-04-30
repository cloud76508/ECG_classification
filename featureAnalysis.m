% unfinished
clear all
clc
loadData

trainPositive = train.X(1:size(train.X,1)/2,:);
trainNegative = train.X(size(train.X,1)/2+1:end,:);

% figure
% scatter(testAF.X(:,1),testAF.X(:,2))
% hold on
% scatter(testNormal.X(:,1),testNormal.X(:,2))
% hold off

figure 
hax=axes; 
abnormal = histogram(trainPositive(:,2),'BinWidth',0.01);
hold on
normal = histogram(trainNegative(:,2),'BinWidth',0.01);
hold off
legend('AF,1000 samples','Normal, 1000 samples')
xlabel('MSF')

figure
boxplot([trainPositive(:,2),trainNegative(:,2)],{'AF','Normal'})

