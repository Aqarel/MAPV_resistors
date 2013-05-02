function [resistors] = LblSpinningEagle(image,resistors)
% Algorithm "Krouzici orel" ;)


imXsize = size(image,2);
imYsize = size(image,2);

testArea = zeros(imYsize,imXsize);

% Place labels for all resistors
for i=1:length(resistors)
    
    
   fill(resistors(i).boundary(:,1),resistors(i).boundary(:,2))
end

% Place labels for all resistors
for i=1:length(resistors)
    
    
    
    
    
   plot(resistors(i).boundary(:,1),resistors(i).boundary(:,2),'g-','LineWidth',2,'MarkerSize',15);
end