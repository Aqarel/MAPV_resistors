function R = corr2_wb(A, B, activeZone)
%
tempSize = size(A);
R = 1 - (sum(sum(abs(A - B).*activeZone))) / (tempSize(1) * tempSize(2));