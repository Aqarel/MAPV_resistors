close all;
clear all;

I  = imread('../images/white_4.png');


prah=0.5;

se1 = strel('square',9); % pøi 9 mizej znacky od fixy
se5 = strel('square',20);

figure;

% vyprahovani a negace výstupu pro dalsi operace (logistejsi mit objekt zajmu bílý)
I3 = ~im2bw(I,prah); 
subplot(1,3,1); imshow(I3);

I3_opened = imopen(I3,se1);
subplot(1,3,2); imshow(I3_opened);
    
I3_closed = imclose(I3_opened,se5);
subplot(1,3,3); imshow(I3_closed);

I_morf = I3_closed; 
% oznaci cislama jednotlive oblasti
L = bwlabel(I_morf);
     
% [r, c] = find(L==2);
% rc = [r c];

%*** vymezeni oblasti do obdelniku     
s  = regionprops(L,'BoundingBox');      
box = cat(1, s.BoundingBox);
   
figure(2);
imshow(I)
   hold on
   
 % *** vykresleni obdelniku kolem rezistoru do puvodního obrazku ***  
   for i = 1:length(s)
 
   line ([box(i,1) (box(i,1)+box(i,3))],[box(i,2) (box(i,2))])
   line ([(box(i,1)+box(i,3)) (box(i,1)+box(i,3))],[box(i,2) (box(i,2)+box(i,4))])
   line ([(box(i,1)+box(i,3)) box(i,1) ],[(box(i,2)+box(i,4)) (box(i,2)+box(i,4))])
   line ([box(i,1) box(i,1)],[(box(i,2)+box(i,4)) box(i,2) ])
   
   end
   
% *** vytvoreni matice bodu obdelnika kolem rezistoru, format Ax Ay Bx By.. 
%  zacatek levý horní roh a dále po smìru hod. rucicek ***  

for i = 1:length(s)
    
    
    oblasti(i,1) = box(i,1);
    oblasti(i,2) = box(i,2);
    oblasti(i,3) = box(i,1)+box(i,3);
    oblasti(i,4) = box(i,2);
    oblasti(i,5) = box(i,1)+box(i,3);
    oblasti(i,6) = box(i,2)+box(i,4);
    oblasti(i,7) = box(i,1);
    oblasti(i,8) = box(i,2)+box(i,4);
      
      
end
  
   hold off
   
% figure(3);
% oblast3 = I(oblasti(j,2):oblasti(j,8), oblasti(j,1):oblasti(j,3));
% oblast3 = I(oblasti(1,2):oblasti(1,8), oblasti(1,1):oblasti(1,3));
% oblast3 = I(200:600, 700:1600);
% imshow(oblast3);
% 
% for j=1:length(s)
% subplot(2,5,j);
% 
% oblast3 = I(oblasti(j,2):oblasti(j,8), oblasti(j,1):oblasti(j,3));
% imshow(oblast3);
% end
