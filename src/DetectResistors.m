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
Tsat = 0.35;                    % threshold for convert to binary image - saturation from HSV
resL = size(template,2);        % resistor lenght in pixel
resD = size(template,1);        % resistor diameter in pixel
vArea = 30;                     % virtual area, use for matching beetwen template and test subarea, sometimes template is bigger than found area,
vAreaD = 10;                    % virtual area diameter, only for finding potential areas with resistor

resistors = struct('resistor',[],'value',[],'center',[],'boundary',[]);

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
  if (((areaSize(1)+vArea)*(areaSize(2)+vAreaD) > resL*resD) && ((areaSize(2)+vAreaD) > resD))   % Area is bigger than area of resistor and smaller size of box is bigger than diameter of resistor
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
for j = 1:length(areaIndex)    % all areas
    iAr = areaIndex(j);
    areaX = round(box(iAr,3)); 
    areaY = round(box(iAr,4)); 
    area = zeros(areaY+vArea, areaX+vArea);
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
        for yy = 1:2:stepsY % y coord
            x = 1;
            for xx = 1:2:stepsX  % x coord
                c = corr2_wb(area(y:(y+templY-1),x:(x+templX-1)),rotTempl,rotActiveTempl);
                
                if ((c < 0.85) && smallSpace) % small correlation and small space for shifting and improvement of correlation
                    fi = fi + bigStep;
                    didBigStep = 2;
                    newFi = 1;
                    break;
                end
                
                if(didBigStep == 2)         % goood correlation ;), but is better try smaller angle (bigStep is soo big :))) 
                     fi = fi - 5;
                     didBigStep = 0;
                     continue;
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
    [bx by bfi] = GetCoords(bestCorr, 0.9);
    
    % Get color resistor in horizontal position
    areaC = zeros(areaY+vArea, areaX+vArea,3,'uint8');
    areaC(1:areaY, 1:areaX, :) = imCol(round(box(iAr,2)):round(box(iAr,2)+areaY-1), round(box(iAr,1)):round(box(iAr,1)+areaX-1),:);   % copy found area from image
    rotTempl = CropBlankSpace(imrotate(template,bfi));
    rotRes = imrotate(areaC(by:(by+size(rotTempl,1)-1),bx:(bx+size(rotTempl,2)-1),:),-bfi);
    [ans xOff1 xOff2 yOff1 yOff2] = CropBlankSpace(imrotate(rotTempl,-bfi));
    rotRes = rotRes(yOff1+1:end-yOff2,xOff1+1:end-xOff2,:);
    
    
    rotTempl = imrotate(template,bfi);
    rotActiveTempl = imrotate(activeTempl,bfi);
    [rotTempl xOff1 xOff2 yOff1 yOff2] = CropBlankSpace(rotTempl);
    
    edges = edge(rotActiveTempl,'sobel');
    [yy xx] = find(edges == 1);
    xx = round(box(iAr,1))+xx-bx-xOff1;
    yy = round(box(iAr,2))+yy-by-yOff1;
    
    cx = round(box(iAr,1))-bx-xOff1+round(size(rotActiveTempl,2)/2);
    cy = round(box(iAr,2))-by-yOff1+round(size(rotActiveTempl,1)/2);

    resistors(j) = struct('resistor',rotRes,'value',[],'center',[cx cy],'boundary',[xx yy]);

end
disp('Total time: ');
toc
disp('Total angle loop: ');
g

