clear all
%noraml = csvread('nsr180_data_test.csv');

temp = fopen('nsr180_data_test.csv');
normalRaw = textscan(temp, '%s', 'Delimiter',',');
% fix some formatting issue
temp = normalRaw{1,1}{1};
temp = temp(3:end);
normalRaw{1,1}{1} = temp;

for n =1:length(normalRaw{1,1})
    normalRawNumber(n,1) = str2num(normalRaw{1,1}{n});
end

for n= 1:length(normalRawNumber)/360
   normalSample((n-1)*180+1:(n-1)*180+180,1) = normalRawNumber((n-1)*360+1:(n-1)*360+180,1);
   normalSample((n-1)*180+1:(n-1)*180+180,2) = normalRawNumber((n-1)*360+181:(n-1)*360+360,1); 
end