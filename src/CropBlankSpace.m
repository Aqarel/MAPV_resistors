function [cropImage, xOff1, xOff2, yOff1, yOff2] = CropBlankSpace(image)
% Crop blank space (value = 0) of image
% Input:
% - image - image to crop
% Output:
% - cropImage - crop image
% - xOff1 - crop size in x axis at the beginning
% - xOff2 - crop size in x axis on end
% - yOff1 - crop size in y axis at the beginning
% - yOff2 - crop size in y axis on end

imX = size(image,2);
imY = size(image,1);

xSum = sum(image,1);
ySum = sum(image,2);
xOff1 = sum(sum(xSum(1:round(imX/2))==0))+1; % get zeros on start x
xOff2 = sum(sum(xSum(round(imX/2):end)==0)); % get zeros on end x
yOff1 = sum(sum(ySum(1:round(imY/2))==0))+1; % get zeros on start y
yOff2 = sum(sum(ySum(round(imY/2):end)==0)); % get zeros on end y

cropImage = image(yOff1:end-yOff2,xOff1:end-xOff2);
xOff1 = xOff1 - 1;
yOff1 = yOff1 - 1;