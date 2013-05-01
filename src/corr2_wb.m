function R = corr2_wb(image, template, activeZone)
% Compute correlation between image and template
% Input:
% - image - image for correlation
% - template - template for correlation
% - activeZone - only from this area will be compute correlation
% Output:
% - R - <0, 1>, for 0 - mismatch, for 1 - total match

maxSize = sum(sum(activeZone));
R = 1 - (sum(sum(abs(image - (template > 0)).*activeZone))) / (maxSize + sum(sum(abs(image - 2.*(template == 0)).*activeZone)));