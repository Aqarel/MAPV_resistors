close all;
clear all;
clc;

% Load images
imCol  = imread('../images/white_1.png');%imread('../images/black_3.png');
template = imread('../images/template3.png');

resistors = DetectResistors(imCol,template);
%%
figure(1);
imshow(imCol);
hold on
for i=1:length(resistors)
   plot(resistors(i).boundary(:,1),resistors(i).boundary(:,2),'g.');
   plot(resistors(i).center(1),resistors(i).center(2),'r*','LineWidth',2,'MarkerSize',15);
end
hold off
%%
figure(2)
for i=1:length(resistors)
   imshow(resistors(i).resistor);
   value = ReadColorCode(resistors(i).resistor);
   %tittle(sprintf('value = %d',value));
   input('Next');
end