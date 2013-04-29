close all;
clear all;
vzorekRGB = imread('../images/vzorek7.png');
hsv = rgb2hsv(vzorekRGB);
figure;
imshow(vzorekRGB)
% 
% figure;
% imshow(hsv)
% 
% figure;
% subplot(1,3,1)
% imshow(hsv(:,:,1))
% subplot(1,3,2)
% imshow(hsv(:,:,2))
% subplot(1,3,3)
% imshow(hsv(:,:,3))

% h = hsv(:,:,1);
% s = hsv(:,:,2);
% v = hsv(:,:,3);


% vzorek1 pozice prouzku 43 61 83 105 y=15
% vzorek2 pozice prouzku 40 65 82 107 y=17
% vzorek3 pozice prouzku 38 65 87 108 y = 15
% vzorek4 pozice prouzku 40 72 90 110 y = 11


x =[10 11 12 13 14 15 16 17 18 19 20 30 31 32 33 34 35 36 37 38 39 40 ];
j=1;

for n=1:length(x)
    
    radek = x(n);
    j=1;
    for i=20:1:size(hsv,2)-20
    vod1_h= hsv(radek,i,1)*360;
    vod1_s= hsv(radek,i,2)*100;
    vod1_v= hsv(radek,i,3)*100;

        %cerna
        if ((vod1_h>=0 && vod1_h<=30) ||(vod1_h>=340 && vod1_h<=360) ) && vod1_s>=30 && vod1_s<=100  && vod1_v>=0 && vod1_v<=15
        barvy(j,n)= 0;
        j = j+1;  
         %hneda
       elseif vod1_h>=15 && vod1_h<=25 && vod1_s>=80 && vod1_s<=100 && vod1_v>=15 && vod1_v<=30
        barvy(j,n)= 1;
        j = j+1;  
            
        % cervena
        elseif ((vod1_h>=0 && vod1_h<=15) ||(vod1_h>=350 && vod1_h<=360) ) && vod1_s>=50 && vod1_s<=100 && vod1_v>=40 && vod1_v<=60
        barvy(j,n)= 2;
        j = j+1;  
         
        % oranzova
        elseif vod1_h>=15 && vod1_h<=25 && vod1_s>=85 && vod1_s<=100 && vod1_v>=55 && vod1_v<=75
        barvy(j,n)= 3;
        j = j+1;  
        
        %zluta
        elseif vod1_h>=40 && vod1_h<=50&& vod1_s>=75 && vod1_s<=90 && vod1_v>=50 && vod1_v<=65
        barvy(j,n)= 4;
        j = j+1;
      
        % zelena
        elseif vod1_h>=100 && vod1_h<=130 && vod1_s>=50 && vod1_s<=75 && vod1_v>=18 && vod1_v<=30
        barvy(j,n)= 5;
        j = j+1;
       
        %modra
        elseif vod1_h>=190 && vod1_h<=240 && vod1_s>=60 && vod1_s<=85 && vod1_v>=18&& vod1_v<=25
        barvy(j,n)= 6;
        j = j+1;
      
        % fialova
        elseif vod1_h>=260 && vod1_h<=340 && vod1_s>=30 && vod1_s<=60 && vod1_v>=10 && vod1_v<=25
        barvy(j,n)= 7;
        j = j+1;  
        
        %seda
        elseif vod1_h>=25 && vod1_h<=40 && vod1_s>=30 && vod1_s<=50 && vod1_v>=20&& vod1_v<=40
        barvy(j,n)= 8;
        j = j+1;
        
        %bila
        elseif vod1_h>=30 && vod1_h<=50 && vod1_s>=25 && vod1_s<=35 && vod1_v>=70&& vod1_v<=80
        barvy(j,n)= 9;
        j = j+1;
        
        % zlata
        elseif vod1_h>=20 && vod1_h<=35 && vod1_s>=45 && vod1_s<=75 && vod1_v>=25&& vod1_v<=45
        barvy(j,n)= 10;
        j = j+1;
        
        % ani jedna 
        else
            barvy(j,n)= 99;
            j = j+1;
     end
    end
end
   
    barvy;


%odstraneni samostatných
m=1;
o=1;

for o=1:size(barvy,2)
    m=1;
for k=1:(length(barvy())-1)
    
   if barvy(k+1,o)==barvy(k,o)
      retezec1(m,o) = barvy(k,o);
      m=m+1;
   
   end
end
end

retezec1;


%odstraneni nepotrebných

m=1;
hodnota=999;


for p=1:size(retezec1,2)
    hodnota=999;
    m=1;
    for k=1:size(retezec1,1)
    
   if retezec1(k,p)~=hodnota
      retezec2(m,p) = retezec1(k,p);
      m=m+1;
      hodnota=retezec1(k,p);
   
     end
    end
end

 retezec2;

%výber relativních
s=1;
if size(retezec2,1)>=10
for r=1:size(retezec2,2)
   
    if retezec2(9,r)==99 && retezec2(10,r)==0 
      retezec3(1:8,s) =  retezec2(1:8,r); 
        s= s+1;
    
    end
    
end
else retezec3(1:8,s)=0;
end


% hodnota odporu
i=1;
for u=2:2:8
kod = retezec3(u,:);
vysledek(i)= mode(kod);
i=i+1;
end
 
% je-li natocen obracene, prohodi hodnoty

if vysledek(1)==10
   pomocna(1)=vysledek(4);
   pomocna(2)=vysledek(3);
   pomocna(3)=vysledek(2);
   pomocna(4)=vysledek(1);
   vysledek = pomocna;
end


% urèení násobku
switch(vysledek(4))
   case 10
      nasobek= 0.1;
   case 11
      nasobek= 0.01;
      case 0
      nasobek= 1;
   case 1
      nasobek= 10;
      case 2
      nasobek= 100;
   case 3
      nasobek= 1000;
      case 4
      nasobek= 10000;
   case 5
      nasobek= 100000;
      case 6
      nasobek= 1000000;
   case 7
      nasobek= 10000000;
end

hodnota_odporu = (vysledek(1)*100 + vysledek(2)*10+vysledek(3)*1)*nasobek
