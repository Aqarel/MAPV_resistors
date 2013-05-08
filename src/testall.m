close all;
clear all;
clc;
for i=30:35
       
    
    close all;
    poradi = num2str(i)
    cesta= ['../images/white_' poradi '.png'];
% Load images
imCol  = imread(cesta);%imread('../images/black_3.png');
template = imread('../images/template3.png');

resistors = DetectResistors(imCol,template);

%%
% label size for font size 20
lblSize = [105 50];
imgSize = [size(imCol,2) size(imCol,1)];

resistors = LblSpinningEagle(resistors,imgSize,lblSize,0);
figure(1);
imshow(imCol);
hold on
for i=1:length(resistors)
    plot(resistors(i).center(1),resistors(i).center(2),'r*','LineWidth',2,'MarkerSize',15);
    plot(resistors(i).boundary(:,1),resistors(i).boundary(:,2),'g-','LineWidth',2,'MarkerSize',15);
    
    plot([resistors(i).center(1) resistors(i).lblPos(1)-round(lblSize(1)/2)],...
         [resistors(i).center(2) resistors(i).lblPos(2)-round(lblSize(2)/2)],'r-','LineWidth',2);
     value = ReadColorCode(resistors(i).resistor);
    text(resistors(i).lblPos(1), resistors(i).lblPos(2), sprintf(value),...
         'Color', 'r', 'FontSize',20,'VerticalAlignment','bottom','HorizontalAlignment','right',...
         'FontUnits','normalized','BackgroundColor',[0 0 0],'Rotation', resistors(i).lblRot)
     
end
input('Next');
hold off
%%
% figure(2)
% for i=1:length(resistors)
%    imshow(resistors(i).resistor);
%    value = ReadColorCode(resistors(i).resistor);
%    %tittle(sprintf('value = %d',value));
%    input('Next');
% end

end