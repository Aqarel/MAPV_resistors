function R = corr2_wb(A, B)
%
tempSize = size(A);
R = 1 - sum(sum(abs(A - B))) / (tempSize(1) * tempSize(2));