function [resistors] = DetectResistors(imCol, template)
% Function detect resistor in image
% Input:
% - imCol - color image
% - template - template of resistor
% Output:
%

% ======================= Constant =======================
seOpen = strel('square', 5);
seClose = strel('square', 8);
AREA_SIZE = 0.65;               % minimal part of template area is accepted as resistor
Tsat = 0.22;                    % threshold for convert to binary image - saturation from HSV
resL = size(template,2);        % resistor lenght in pixel
resD = size(template,1);        % resistor diameter in pixel
vArea = 30;                     % virtual area, use for matching beetwen template and test subarea, sometimes template is bigger than found area,
vAreaD = 10;                    % virtual area diameter, only for finding potential areas with resistor
wArea = sum(sum(template > 0)); % count of pixel in resistor

resistors = struct('resistor',[],'value',[],'center',[],'angle',[],'mask',[],'boundary',[],'lblPos',[],'lblRot',[]);

% ========= Detection big area in image from HSV ==========
Ihsv = rgb2hsv(imCol);
imBin = Ihsv(:,:,2) > Tsat;     % From saturation
imBin = imopen(imBin, seOpen);
imBin = imclose(imBin, seClose);

% Detecting and filtering area
areasLabel = bwlabel(imBin);
s  = regionprops(areasLabel,'BoundingBox');      
box = cat(1, s.BoundingBox);

% Find only big area
areaIndex = 0;
for i = 1:length(s)
    areaSize = sort(box(i,3:4),'descend');
    
    % Get area from image and count object pixel
    areaX = round(box(i,3)); 
    areaY = round(box(i,4)); 
    area = zeros(areaY, areaX);
    area(1:areaY, 1:areaX) = imBin(round(box(i,2)):round(box(i,2)+areaY-1), round(box(i,1)):round(box(i,1)+areaX-1));
    tArea = sum(sum(area));
   
    % - Area is bigger than area of resistor 
    % - Smaller size of box is bigger than diameter of resistor
    % - Object area (sum of white pixels) must be bigger than template
    if (((areaSize(1)+vArea)*(areaSize(2)+vAreaD) > resL*resD) && ((areaSize(2)+vAreaD) > resD) && (tArea > (AREA_SIZE*wArea)))   
        areaIndex(end + 1) = i;     % index of area
    end
end

if size(areaIndex,2) == 1
    disp('ERROR: No resistors find');
    return;
end

areaIndex = areaIndex(2:end);   % first index is not used


% =================== Find resistors =====================
g = 0;
tic
activeTempl = ones(size(template,1),size(template,2));  % mask for rotated resistor, corr calculate only from resistor area, no from blank space
cntrRes = 1;                    % resistor detected counter    
for j = 1:length(areaIndex)    % all areas
    iAr = areaIndex(j);
    areaX = round(box(iAr,3)); 
    areaY = round(box(iAr,4)); 
    area = zeros(areaY+2*vArea, areaX+2*vArea);
    area(1:areaY, 1:areaX) = imBin(round(box(iAr,2)):round(box(iAr,2)+areaY-1), round(box(iAr,1)):round(box(iAr,1)+areaX-1));   % copy found area from image
    bestCorr = zeros(areaX,areaY,2); % best correlation on the X, Y across fi; save correlation coeficient and fi
    
    step = 2;           % small step for fangle fi
    bigStep = 10;       % big step for angle fi (very small correlation between 
    didBigStep = 0;     % 0 - we have good correlation, 
                        % 1 - mismatch size of template and image
                        % 2 - small correlation
    fi = 0;             % angle of rotation
    newFi = 0;          % small correlation, stop shift in x and y position, break this for loop
    
    while fi < 180      % Angle 
        g = g + 1;
        rotTempl = imrotate(template,fi);
        [rotTempl xOff1 xOff2 yOff1 yOff2] = CropBlankSpace(rotTempl);
        templX = size(rotTempl,2);
        templY = size(rotTempl,1);
        
        if (templX > (areaX+vArea)) || (templY > (areaY+vArea)) % template is in less one size bigger than area, try other rotation
            fi = fi + bigStep;  % bigger step than size of template and image match
            didBigStep = 1;
            continue; 
        end
        
        if(didBigStep == 1)     % size match of template and image match, but is better try smaller angle (bigStep is soo big :))) 
             fi = fi - 5;
             didBigStep = 0;
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
        
        smallSpace = areaX*areaY < 1.8*(resL*resD); % it is possible more than 1 resister
        
        y = 1;
        for yy = 1:1:stepsY % y coord
            x = 1;
            for xx = 1:1:stepsX  % x coord
                c = corr2_wb(area(y:(y+templY-1),x:(x+templX-1)),rotTempl,rotActiveTempl);     
                if ((c < 0.80) && smallSpace) % small correlation and small space for shifting and improvement of correlation
                    fi = fi + bigStep;
                    didBigStep = 2;
                    newFi = 1;
                    break;
                end
                
                if(didBigStep == 2)         % goood correlation ;), but is better try smaller angle (bigStep is soo big :))) 
                     fi = fi - 5;
                     didBigStep = 0;
                     newFi = 1;
                     break;
                end
                
                if (bestCorr(x,y,1) < c)
                    bestCorr(x,y,1) = c;
                    bestCorr(x,y,2) = fi; 
                end
                x = x + 1;
            end
            if (newFi == 1)
                break;
            end
            y = y + 1;
        end
        if (newFi == 1)
            newFi = 0;
            continue;
        end
        fi = fi + step;
    end
    
    % cut blank space
    mask = bestCorr(:,:,1) > 0;
    tmpX = sum(mask,2) + 1;
    tmpY = sum(mask,1) + 1;
    bestCorr = bestCorr(1:tmpY,1:tmpX,:);
    [bx by bfi bCorr] = GetCoords(bestCorr, 0.9);
    
    if bCorr < 0.8  % small correlation, no detect resistor
       continue; 
    end
    
    % Get color resistor in horizontal position
    areaC = zeros(areaY+vArea, areaX+vArea,3,'uint8');
    areaC(1:areaY, 1:areaX, :) = imCol(round(box(iAr,2)):round(box(iAr,2)+areaY-1), round(box(iAr,1)):round(box(iAr,1)+areaX-1),:);   % copy found area from image
    rotTempl = CropBlankSpace(imrotate(template,bfi));
    % casto pada na ruzne rozmery, pokud je spatne nalezen uhel, respektive
    % neni nalzene vubec
    rotRes = imrotate(areaC(by:(by+size(rotTempl,1)-1),bx:(bx+size(rotTempl,2)-1),:),-bfi);
    [ans xOff1 xOff2 yOff1 yOff2] = CropBlankSpace(imrotate(rotTempl,-bfi));
    rotRes = rotRes(yOff1+1:end-yOff2,xOff1+1:end-xOff2,:);
    
    
    rotTempl = imrotate(template,bfi);
    rotActiveTempl = imrotate(activeTempl,bfi);
    [rotTempl xOff1 xOff2 yOff1 yOff2] = CropBlankSpace(rotTempl);
    
    % Center of area with resistor
    cx = round(box(iAr,1))+bx-xOff1+round(size(rotActiveTempl,2)/2);
    cy = round(box(iAr,2))+by-yOff1+round(size(rotActiveTempl,1)/2);
    
    % Get corner of area with resistor
    crx = zeros(5,1);
    cry = zeros(5,1);
    [ans xOffcr1 xOffcr2 yOffcr1 yOffcr2] = CropBlankSpace(rotActiveTempl);
    % Left corner
    tmpY = find(rotActiveTempl(:,xOffcr1+1)==1);
    crx(1) = xOffcr1+1;
    cry(1) = tmpY(end);
    
    % Right corner
    tmpY = find(rotActiveTempl(:,end - xOffcr2)==1);
    crx(3) = size(rotActiveTempl,2) - xOffcr1;
    cry(3) = tmpY(1);
    
    % Top corner
    tmpX = find(rotActiveTempl(yOffcr1+1,:)==1);
    crx(2) = tmpX(1);
    cry(2) = yOffcr1+1;
    
    % Botton corner
    tmpX = find(rotActiveTempl(end - yOffcr2,:)==1);
    crx(4) = tmpX(end);
    cry(4) = size(rotActiveTempl,1) - yOffcr2;
    
    crx(5) = crx(1);
    cry(5) = cry(1);
  
    crx = round(box(iAr,1))+bx-xOff1+crx;
    cry = round(box(iAr,2))+by-yOff1+cry;

    resistors(cntrRes) = struct('resistor',rotRes,'value',[],'center',[cx cy],'angle',bfi,'mask',rotActiveTempl,'boundary',[crx cry],'lblPos',[0 0],'lblRot',0);
    cntrRes = cntrRes + 1;
end
disp('Total time: ');
toc
disp('Total angle loop: ');
g
