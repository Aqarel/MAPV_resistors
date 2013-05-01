function [x y fi] = GetCoords(corrMap, T)
% Find in correlation map all resistor and return their parametres
% Input:
% - corrMap - map of correlation for x and y shift
% - T - treshold
% Output:
% - x, y: vector of coordinations 
% - fi: angle of resistor

[x y] = find(corrMap(:,:,1)==max(max(corrMap(:,:,1)))); % find max value
x = x(1);
y = y(1);
fi = corrMap(x,y,2);