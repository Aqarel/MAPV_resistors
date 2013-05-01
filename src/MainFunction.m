close all;
clear all;
clc;

% Load images
imCol  = imread('../images/white_3.png');%imread('../images/black_3.png');
template = imread('../images/template3.png');

resistors = DetectResistors(imCol,template);

figure(1);
imshow(imCol);
hold on
for i=1:length(resistors)
   plot(resistors(i).boundary(:,1),resistors(i).boundary(:,2),'g.');
end
hold off
%%
figure(2)
for i=1:length(resistors)
   imshow(resistors(i).resistor);
   input('Next');
end