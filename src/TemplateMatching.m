% Template matching
close all;
clear all;
clc;


% ====== Constant ======
seOpen = strel('square', 4);
seClose = strel('square', 6);
Tsat = 0.42;    % threshold - saturation from HSV
resL = 124;     % resistor lenght in pixel
resD = 37;     % resistor diameter in pixel


Icolor  = imread('../images/white_4.png');%imread('../images/black_3.png');

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
  if ((areaSize(1)*areaSize(2) > resL*resD) && (areaSize(2) > resD))   % Area is bigger than area of resistor and smaller size of box is bigger than diameter of resistor
    areaIndex(end + 1) = i;                         % index of area
  end
end

if size(areaIndex,2) == 1
    error('No resistors find');
end

areaIndex = areaIndex(2:end);                       % first index is not used

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
