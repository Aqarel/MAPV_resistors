% Template matching
close all;
clear all;
clc;

Icolor  = imread('../images/white_4.png');%imread('../images/black_3.png');
template = imread('../images/template2.png');
template = template(:,:,1) < 128;
% ====== Constant ======
seOpen = strel('square', 5);
seClose = strel('square', 8);
Tsat = 0.35;    % threshold - saturation from HSV
resL = size(template,2);     % resistor lenght in pixel
resD = size(template,1);     % resistor diameter in pixel

vArea = 20;                  % virtual area, use for matching beetwen template and test subarea, sometimes template is bigger than found area,
vAreaD = 6;                  % virtual area diameter, only for finding potential areas with resistor


% Detection from RGB  - problem with white_7

% IGray = rgb2gray(Icolor);
% se1 = strel('square', 10);
% imBin = ~im2bw(Icolor,0.50);
% imshow(imBin);

% Detection from HSV

Ihsv = rgb2hsv(Icolor);
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
imshow(Icolor)
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
activeTempl = ones(size(template,1),size(template,2));  % 
%for j = 1:length(areaIndex)    % all areas
    iAr = areaIndex(1);
    areaX = round(box(iAr,3)); 
    areaY = round(box(iAr,4)); 
    area = zeros(areaY+vArea, areaX+vArea);
    area(1:areaY, 1:areaX) = imBin(round(box(iAr,2)):round(box(iAr,2)+areaY-1), round(box(iAr,1)):round(box(iAr,1)+areaX-1));   % copy found area from image
    for fi = 0:1:180   % Angle           
        rotTempl = imrotate(template,fi);
        rotActiveTempl = imrotate(activeTempl,fi);
        templX = size(rotTempl,2);
        templY = size(rotTempl,1);
        if (templX > (areaX+vArea)) || (templY > (areaY+vArea)) % template is in less one size bigger than area, try other rotation
           continue; 
        end
        
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
        
        for y = 1:stepsY % y coord
            for x = 1:stepsX  % x coord
                c = corr2_wb(area(y:(y+templY-1),x:(x+templX-1)),rotTempl,rotActiveTempl);
                figure(1);
                subplot(2,1,1);
                imshow(rotTempl);
                subplot(2,1,2);
                imshow(area(y:(y+templY-1),x:(x+templX-1)));
                title(sprintf('X=%d, Y=%d,fi=%d, corr=%f',x,y,fi,c))
                input('asa');
            end
        end
    end
%end

