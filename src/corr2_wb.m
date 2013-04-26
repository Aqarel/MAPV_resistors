function R = corr2_wb(image, template, activeZone)
%
tempSize = size(image);
R = 1 - (sum(sum(abs(image - template(:,:,1)).*activeZone))) / (tempSize(1) * tempSize(2) + sum(sum(abs(image - 2.*template(:,:,2)).*activeZone)));