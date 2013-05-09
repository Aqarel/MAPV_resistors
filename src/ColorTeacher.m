% Analyze scatter of resistor strip colors
% ========================================

close all;
clear all;
clc;
lblSize = [105 50];
imCol  = imread('../images/white_1.png');
imgSize = [size(imCol,2) size(imCol,1)];

template = imread('../images/template3.png');
colors = {'hneda' 'cervena' 'oranzova' 'zluta' 'zelena' 'modra' 'fialova' 'seda' 'bila'};
IMAGES = 64;
% image not to load
badIm = [7 11 45 46 47 50 51]; 

%% Only test all images if they are good
for i=1:IMAGES
    if sum(badIm == i) > 0   % no load bad image :(
        continue;
    end 
    
    imCol  = imread(sprintf('../images/white_%d.png',i));
    resistors = DetectResistors(imCol,template);
    
    input(sprintf('Show image white_%d.png?',i))
    resistors = LblSpinningEagle(resistors,imgSize,lblSize,0);
    figure(1);
    imshow(imCol);
    hold on
    for j=1:length(resistors)
        resistors(j).value = ReadColorCode(resistors(j).resistor);
        plot(resistors(j).center(1),resistors(j).center(2),'r*','LineWidth',2,'MarkerSize',15);
        plot(resistors(j).boundary(:,1),resistors(j).boundary(:,2),'g-','LineWidth',2,'MarkerSize',15);

        plot([resistors(j).center(1) resistors(j).lblPos(1)-round(lblSize(1)/2)],...
             [resistors(j).center(2) resistors(j).lblPos(2)-round(lblSize(2)/2)],'r-','LineWidth',2);
        text(resistors(j).lblPos(1), resistors(j).lblPos(2), resistors(j).value,...
             'Color', 'r', 'FontSize',20,'VerticalAlignment','bottom','HorizontalAlignment','right',...
             'FontUnits','normalized','BackgroundColor',[0 0 0],'Rotation', resistors(j).lblRot)
    end
    hold off
    title(sprintf('Image white_%d.png?',i));
    
    figure(2)
    for j=1:length(resistors)
        subplot(1,length(resistors),j)
        imshow(resistors(j).resistor);
    end
    title(sprintf('Image white_%d.png?',i));
end
%% Load and find all resistor

% cntrRes = 0;    % count of found resistors
% foundRes = struct('resistor',[]);  % found resistor
% for i=1:IMAGES
%     if sum(badIm == i) > 0   % no load bad image :(
%         continue;
%     end
%     
%     sprintf('Processing: white_%d.png...',i)
%     imCol  = imread(sprintf('../images/white_%d.png',i));
%     resistors = DetectResistors(imCol,template);
%     
%     for j=1:length(resistors)
%         cntrRes = cntrRes + 1;
%         foundRes(cntrRes) = struct('resistor',resistors(j).resistor);
%     end
% end
% save('../data/foundRes.mat','foundRes');

%%

% load('../data/foundRes.mat');

% for i=1:length(foundRes)
%     figure(1)
%     imshow(foundRes(i).resistor);
%     pause(0.5);
% end

%% Naklikani dat
load('../data/foundRes.mat');

% jednotlive barvicky
for i=1:length(colors)
    clc;
    close all;
    input(sprintf('Hledej barvu: %s. Muzeme zacit?', colors{i}));

    % pres vsechny rezistory
    hsvColors = zeros(3,1);
    cntrColors = 0;

    gcf = figure(1);
    for j=1:length(foundRes)
        imshow(foundRes(j).resistor);
        set(gcf, 'Position', get(0,'Screensize')); 
        title(strcat('Prave hledas barvu:',colors{i},', ',sprintf('Rezistor %d/%d', j, length(foundRes))));
        [x y] = ginput;
        x = round(x);
        y = round(y);
        for k=1:length(x)
            cntrColors = cntrColors + 1;
            tmp = rgb2hsv(foundRes(j).resistor(y(k),x(k),:));
            hsvColors(1,cntrColors) = tmp(:,:,1)*360;
            hsvColors(2,cntrColors) = tmp(:,:,2)*100;
            hsvColors(3,cntrColors) = tmp(:,:,3)*100;
        end
    end
    % Ulozit najite hodnoty
    switch colors{i}
        case 'hneda',
            clrBrown = hsvColors;
            save('../data/clrBrown.mat','clrBrown');
        case 'cervena',
            clrRed = hsvColors;
            save('../data/clrRed.mat','clrRed');
        case 'oranzova',
            clrOrange = hsvColors;
            save('../data/clrOrange.mat','clrOrange');
        case 'zluta',
            clrYellow = hsvColors;
            save('../data/clrYellow.mat','clrYellow');
        case 'zelena',
            clrGreen = hsvColors;
            save('../data/clrGreen.mat','clrGreen');
        case 'modra',
            clrBlue = hsvColors;
            save('../data/clrBlue.mat','clrBlue');
        case 'fialova',
            clrPurple = hsvColors;
            save('../data/clrPurple.mat','clrPurple');
        case 'seda',
            clrGrey = hsvColors;
            save('../data/clrGrey.mat','clrGrey');
        case 'bila',
            clrWhite = hsvColors;
            save('../data/clrWhite.mat','clrWhite');
        otherwise,
            input('Data se musi ulozit, ale je pridana neznama barva. Musis ulozit manualne. Data musis presunout do promenne s unikatnim nazvem, jinak se pri nacteni prepisi.');
    end
end

%% Projde naklikane data a vrati maximalni a minimalni hodnotu a prumer
close all;
clc;

load('../data/clrBrown.mat');
load('../data/clrRed.mat');
load('../data/clrOrange.mat');
load('../data/clrYellow.mat');
load('../data/clrGreen.mat');
load('../data/clrBlue.mat');
load('../data/clrPurple.mat');
load('../data/clrGrey.mat');
load('../data/clrWhite.mat');

for i=1:length(colors)
    switch colors{i}
        case 'hneda',
            decColor = clrBrown;
        case 'cervena',
            decColor = clrRed;
        case 'oranzova',
            decColor = clrOrange;
        case 'zluta',
            decColor = clrYellow;
        case 'zelena',
            decColor = clrGreen;
        case 'modra',
            decColor = clrBlue;
        case 'fialova',
            decColor = clrPurple;
        case 'seda',
            decColor = clrGrey;
        case 'bila',
            decColor = clrWhite;
        otherwise,
            input('Neznama barva, neumim nacist. Preskocim tuto barvu.');
            continue;
    end
    
    fprintf('=================\nBarva: %s\n=================\n', colors{i});
    fprintf('H - max: %d, min: %d, prumer: %d\n',round(max(decColor(1,:))), round(min(decColor(1,:))), round(sum(decColor(1,:))/length(decColor(1,:))));
    fprintf('S - max: %d, min: %d, prumer: %d\n',round(max(decColor(2,:))), round(min(decColor(2,:))), round(sum(decColor(2,:))/length(decColor(2,:))));
    fprintf('V - max: %d, min: %d, prumer: %d\n\n',round(max(decColor(3,:))), round(min(decColor(3,:))), round(sum(decColor(3,:))/length(decColor(3,:))));
    
    if (i <= 5)
        figure(1);
        subplot(5,3,3*(i-1)+1);
        hist(decColor(1,:));
        title(sprintf('H pro barvu: %s',colors{i}));

        subplot(5,3,3*(i-1)+2);
        hist(decColor(2,:));
        title(sprintf('S pro barvu: %s',colors{i}));

        subplot(5,3,3*(i-1)+3);
        hist(decColor(3,:));
        title(sprintf('V pro barvu: %s',colors{i}));
    else
        figure(2);
        subplot(5,3,3*(i-6)+1);
        hist(decColor(1,:));
        title(sprintf('H pro barvu: %s',colors{i}));

        subplot(5,3,3*(i-6)+2);
        hist(decColor(2,:));
        title(sprintf('S pro barvu: %s',colors{i}));

        subplot(5,3,3*(i-6)+3);
        hist(decColor(3,:));
        title(sprintf('V pro barvu: %s',colors{i}));
    end

end























