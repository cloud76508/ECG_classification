% unfinished



clear all
clc
load linearSVMResults



% w = model.SVs' * model.sv_coef;
% b = -model.rho;
% if (model.Label(1) == -1)
%       w = -w; b = -b;
% end
% 
% x = [0:0.01:1];
% y = w*x + b
% 
figure
scatter(testAF.X(:,1),testAF.X(:,2))
hold on
scatter(testNormal.X(:,1),testNormal.X(:,2))
hold off

figure 
hax=axes; 
abnormal = histogram(testAF.X(:,2),100);
hold on
normal = histogram(testNormal.X(:,2),100);
hold on
line([ 0.05 0.05],get(hax,'YLim'),'Color',[0 0 0],'LineStyle','--')
hold off
legend('AF','Normal')

