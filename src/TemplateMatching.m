% Template matching
close all;
clear all;
clc;

imCol  = imread('../images/white_1.png');%imread('../images/black_3.png');
template = imread('../images/template3.png');

% ====== Constant ======
seOpen = strel('square', 5);
seClose = strel('square', 8);
Tsat = 0.35;    % threshold - saturation from HSV
resL = size(template,2);     % resistor lenght in pixel
resD = size(template,1);     % resistor diameter in pixel

vArea = 30;                  % virtual area, use for matching beetwen template and test subarea, sometimes template is bigger than found area,
vAreaD = 10;                  % virtual area diameter, only for finding potential areas with resistor


% Detection from RGB  - problem with white_7

% IGray = rgb2gray(imCol);
% se1 = strel('square', 10);
% imBin = ~im2bw(imCol,0.50);
% imshow(imBin);

% Detection from HSV

Ihsv = rgb2hsv(imCol);
imBin = Ihsv(:,:,2) > Tsat;     % From saturation

imBin = imopen(imBin, seOpen);
imBin = imclose(imBin, seClose);


% Detecting and filtering area

areasLabel = bwlabel(imBin);

s  = regionprops(areasLabel,'BoundingBox');      
box = cat(1, s.BoundingBox);

% find only big area
areaIndex = 0;
for i = 1:length(s)
  areaSize = sort(box(i,3:4),'descend');
  if (((areaSize(1)+vArea)*(areaSize(2)+vAreaD) > resL*resD) && ((areaSize(2)+vAreaD) > resD))   % Area is bigger than area of resistor and smaller size of box is bigger than diameter of resistor
    areaIndex(end + 1) = i;                         % index of area
  end
end

if size(areaIndex,2) == 1
    error('No resistors find');
end

areaIndex = areaIndex(2:end);                       % first index is not used
imshow(imBin)

%% 
figure(2);
imshow(imCol)
   hold on
   
 % *** vykresleni obdelniku kolem rezistoru do puvodního obrazku ***  
   for j = 1:length(areaIndex)
       i=areaIndex(j);
 
   line ([box(i,1) (box(i,1)+box(i,3))],[box(i,2) (box(i,2))])
   line ([(box(i,1)+box(i,3)) (box(i,1)+box(i,3))],[box(i,2) (box(i,2)+box(i,4))])
   line ([(box(i,1)+box(i,3)) box(i,1) ],[(box(i,2)+box(i,4)) (box(i,2)+box(i,4))])
   line ([box(i,1) box(i,1)],[(box(i,2)+box(i,4)) box(i,2) ])
   
   end
   
% *** vytvoreni matice bodu obdelnika kolem rezistoru, format Ax Ay Bx By.. 
%  zacatek levý horní roh a dále po smìru hod. rucicek ***  

for j = 1:length(areaIndex)
    
     i=areaIndex(j);
    oblasti(i,1) = box(i,1);
    oblasti(i,2) = box(i,2);
    oblasti(i,3) = box(i,1)+box(i,3);
    oblasti(i,4) = box(i,2);
    oblasti(i,5) = box(i,1)+box(i,3);
    oblasti(i,6) = box(i,2)+box(i,4);
    oblasti(i,7) = box(i,1);
    oblasti(i,8) = box(i,2)+box(i,4);
      
      
end
hold off
%% find resistor
figure(3);
imshow(imCol);
hold on
g = 0;

tic
activeTempl = ones(size(template,1),size(template,2));  % mask for rotated resistor, corr calculate only from resistor area, no from blank space
for j = 1:length(areaIndex)    % all areas
    iAr = areaIndex(j);
    areaX = round(box(iAr,3)); 
    areaY = round(box(iAr,4)); 
    area = zeros(areaY+vArea, areaX+vArea);
    area(1:areaY, 1:areaX) = imBin(round(box(iAr,2)):round(box(iAr,2)+areaY-1), round(box(iAr,1)):round(box(iAr,1)+areaX-1));   % copy found area from image
    bestCorr = zeros(areaX,areaY,2); % best correlation on the X, Y across fi; save correlation coeficient and fi
    step = 2;
    bigStep = 0;
    fi = 0;
    while fi < 180   % Angle 
        g = g + 1;
        rotTempl = imrotate(template,fi);
        [rotTempl xOff1 xOff2 yOff1 yOff2] = CropBlankSpace(rotTempl);
        templX = size(rotTempl,2);
        templY = size(rotTempl,1);
        
        if (templX > (areaX+vArea)) || (templY > (areaY+vArea)) % template is in less one size bigger than area, try other rotation
            fi = fi + 10;
            bigStep = 1;
           continue; 
        end
        
        if(bigStep == 1)
             fi = fi - 5;
             bigStep = 0;
            continue;
        end
        
        rotActiveTempl = imrotate(activeTempl,fi);
        rotActiveTempl = rotActiveTempl(yOff1+1:end-yOff2,xOff1+1:end-xOff2);    
        
        if (templX >= areaX)
           stepsX = 1; 
        else
           stepsX = areaX - templX;
        end
        
        if (templY >= areaY)
           stepsY = 1; 
        else
           stepsY = areaY - templY;
        end
        y = 1;
        for yy = 1:2:stepsY % y coord
            x = 1;
            for xx = 1:2:stepsX  % x coord
                c = corr2_wb(area(y:(y+templY-1),x:(x+templX-1)),rotTempl,rotActiveTempl);
                if (bestCorr(x,y,1) < c)
                    bestCorr(x,y,1) = c;
                    bestCorr(x,y,2) = fi;                 
%                     if (c > 0.83)
%                         figure(4);
%                         subplot(3,1,1);
%                         imshow(rotTempl);
%                         subplot(3,1,2);
%                         hold on
%                         imshow(area(y:(y+templY-1),x:(x+templX-1)));
%                         edges = edge(rotActiveTempl,'sobel');
%                         [yy xx] = find(edges == 1);
%                         plot(xx, yy, 'b.');
%                         axis([1 size(rotTempl,2) 1 size(rotTempl,1)])
%                         hold off
%                         subplot(3,1,3);
%                         hold on
%                         areaC = zeros(areaY+vArea, areaX+vArea,3,'uint8');
%                         areaC(1:areaY, 1:areaX, :) = imCol(round(box(iAr,2)):round(box(iAr,2)+areaY-1), round(box(iAr,1)):round(box(iAr,1)+areaX-1),:);
%                         imshow(areaC(y:(y+templY-1),x:(x+templX-1),:));
%                         edges = edge(rotActiveTempl,'sobel');
%                         [yy xx] = find(edges == 1);
%                         plot(xx, yy, 'b.');
%                         axis([1 size(rotTempl,2) 1 size(rotTempl,1)])
%                         hold off
%                         title(sprintf('X=%d, Y=%d,fi=%d, corr=%f',x,y,fi,c))
%                         input('asa');
%                     end
                end
                x = x + 1;
            end
            y = y + 1;
        end
        fi = fi + step;
    end
    
    % cut blank space
    mask = bestCorr(:,:,1) > 0;
    tmpX = sum(mask,2) + 1;
    tmpY = sum(mask,1) + 1;
    bestCorr = bestCorr(1:tmpY,1:tmpX,:);
    [bx by bfi] = GetCoords(bestCorr, 0.9);
    
%     figure(4);
    areaC = zeros(areaY+vArea, areaX+vArea,3,'uint8');
    areaC(1:areaY, 1:areaX, :) = imCol(round(box(iAr,2)):round(box(iAr,2)+areaY-1), round(box(iAr,1)):round(box(iAr,1)+areaX-1),:);   % copy found area from image
    rotTempl = CropBlankSpace(imrotate(template,bfi));
    rotRes = imrotate(areaC(by:(by+size(rotTempl,1)-1),bx:(bx+size(rotTempl,2)-1),:),-bfi);
    [ans xOff1 xOff2 yOff1 yOff2] = CropBlankSpace(imrotate(rotTempl,-bfi));
    rotRes = rotRes(yOff1+1:end-yOff2,xOff1+1:end-xOff2,:);
%     subplot(2,1,1);
%     imshow(areaC(1:areaY, 1:areaX, :));
%     subplot(2,1,2);
%     imshow(rotRes);
%     input('asa');
    
    
    %filter and get peaks responsed to resistors
%     figure(4)
%     mask = bestCorr(:,:,1) > 0.9;
%     surf(bestCorr(:,:,1).*mask)
%     input('asa');
    
    rotTempl = imrotate(template,bfi);
    rotActiveTempl = imrotate(activeTempl,bfi);
    templX = size(rotTempl,2);
    templY = size(rotTempl,1);

    [rotTempl xOff1 xOff2 yOff1 yOff2] = CropBlankSpace(rotTempl);
    
    rotActiveTempl = rotActiveTempl(yOff1+1:end-yOff2,xOff1+1:end-xOff2);
    
    edges = edge(rotActiveTempl,'sobel');
    [yy xx] = find(edges == 1);
    plot(round(box(iAr,1))+xx-bx-xOff1/2, round(box(iAr,2))+yy-by-yOff1/2, 'r.');
end
disp('Total time: ');
toc
disp('Total: ');
g
hold off

%%
% 
% figure(4);
% subplot(2,1,1);
% rotTempl = imrotate(template,40);
% imshow(rotTempl);
% subplot(2,1,2);
% crop = CropBlankSpace(rotTempl);
% imshow(crop);



