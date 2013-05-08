 close all;
clear all;
clc;

% Load images
imCol  = imread('../images/white_15.png');%imread('../images/black_3.png');
template = imread('../images/template3.png');

resistors = DetectResistors(imCol,template);

%%
% label size for font size 20
lblSize = [105 50];
imgSize = [size(imCol,2) size(imCol,1)];

resistors = LblSpinningEagle(resistors,imgSize,lblSize,0);
gca = figure(1);
imshow(imCol);
hold on
values = cell(length(resistors),1);
for i=1:length(resistors)
    resistors(i).value = ReadColorCode(resistors(i).resistor);
    values{i} = resistors(i).value;
    plot(resistors(i).center(1),resistors(i).center(2),'r*','LineWidth',2,'MarkerSize',15);
    plot(resistors(i).boundary(:,1),resistors(i).boundary(:,2),'g-','LineWidth',2,'MarkerSize',15);
    
    plot([resistors(i).center(1) resistors(i).lblPos(1)-round(lblSize(1)/2)],...
         [resistors(i).center(2) resistors(i).lblPos(2)-round(lblSize(2)/2)],'r-','LineWidth',2);
    text(resistors(i).lblPos(1), resistors(i).lblPos(2), resistors(i).value,...
         'Color', 'r', 'FontSize',20,'VerticalAlignment','bottom','HorizontalAlignment','right',...
         'FontUnits','normalized','BackgroundColor',[0 0 0],'Rotation', resistors(i).lblRot)
end
hold off
resValues = sort(values);

