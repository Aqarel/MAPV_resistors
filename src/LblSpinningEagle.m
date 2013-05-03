function [out] = LblSpinningEagle(resistors, imageSize, lblSize, mode)
% Algorithm "Krouzici orel" ;), try place label around resistor (from
% 270deg). If not free space, than replace resistor with label.
% Input:
% - resistors - structure with resistor parameters
% - imageSize - size of origin image [x y]
% - lblSize - size of label [x y]
% - mode - 0 - labels are placed around resistors, 
%          1 - labels are placed over resistor
% Output:
% - out - resistor structure 

% image size
imXsize = imageSize(1);
imYsize = imageSize(2);

% label size for font size 20
lblXsize = lblSize(1);
lblYsize = lblSize(2);

% Parameters
ANGLE_STEP = 15;
RADIUS_MIN = 50;
RADIUS_STEP = 50; 

testArea = zeros(imYsize,imXsize);

if mode == 0
    % Place mask of all resistor to testArea
    for i=1:length(resistors) 
        testArea = testArea | poly2mask(resistors(i).boundary(:,1), resistors(i).boundary(:,2),imYsize, imXsize);
    end

    % Place labels for all resistors
    for i=1:length(resistors)
        foundPlace = 0;
        for radius=RADIUS_MIN:RADIUS_STEP:(imXsize/2)
            for fi=270:ANGLE_STEP:270+360
               x = round(resistors(i).center(1) + radius*sind(fi));
               y = round(resistors(i).center(2) - radius*cosd(fi));

               % will be fit area of label in image ?
               if ((x - lblXsize) < 1) || (x > imXsize) || ((y - lblYsize) < 1) || (y > imYsize)
                  continue; 
               end

               % test overlap label with resistors and other labels
               overlap = sum(sum(testArea((y - lblYsize):y,(x - lblXsize):x)));
               if (overlap == 0) 
                   testArea((y - lblYsize):y,(x - lblXsize):x) = 1; % draw mask of label to testArea
                   resistors(i).lblPos = [x y];                     % save coordination of label                                        
                   resistors(i).lblRot = 0;
                   foundPlace = 1;
                   break;
               end
            end
            if (foundPlace == 1)
                break; 
            end
        end
        if (foundPlace == 1)
            continue;
        else    % Houston, we have problem: no place placement label, replace resistor
            resistors(i) = LabelOverResistor(resistors(i));
        end
    end
else
    for i=1:length(resistors)
        resistors(i) = LabelOverResistor(resistors(i));
    end
end

out = resistors;

function [out] = LabelOverResistor(resistor)

if (resistor.angle > 90)
    resistor.lblRot = resistor.angle+180;
else
    resistor.lblRot = resistor.angle;
end

% find mthe most right corner
xSort = sort(resistor.boundary(:,1),'descend');
xCoord1 = find(resistor.boundary(:,1) == xSort(1));
xCoord2 = find(resistor.boundary(:,1) == xSort(2));

% get lower corner
if (resistor.boundary(xCoord1,2) > resistor.boundary(xCoord2,2))
    x = resistor.boundary(xCoord1,1);
    y = resistor.boundary(xCoord1,2);
else
    x = resistor.boundary(xCoord2,1);
    y = resistor.boundary(xCoord2,2);
end

resistor.lblPos = [x y];

out = resistor;
