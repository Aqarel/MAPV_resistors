close all;
clear all;
vzorekRGB = imread('../images/vzorek14.png');
hsv = rgb2hsv(vzorekRGB);
% figure;
% imshow(vzorekRGB)
% 
% figure;
% imshow(hsv)


% oblast hledaní barevných pruhù
seOpen = strel('square', 5);
seClose = strel('square', 8);
Tsat = 0.35;

imBin = hsv(:,:,2) > Tsat;     % From saturation
imBin = imopen(imBin, seOpen);
imBin = imclose(imBin, seClose);
% figure;
% imshow(imBin);


for i=1:size(imBin,2)
   
    sumator_y(1,i) = sum(imBin(:,i)); 
       
end
%zacatek prohledavani
for i=1:size(sumator_y,2)
   if sumator_y(1,i) >= size(imBin,1)*3/4
       pocatek_y = i;
       break;
   end
end
%konec prohledavani
for i=size(sumator_y,2):-1:1
   if sumator_y(1,i) >= size(imBin,1)*3/4
       konec_y = i;
       break;
   end
end

%vzkresleni ocamcad pocamcad
figure;
imshow(vzorekRGB);
hold on;


line([pocatek_y pocatek_y], [1 size(vzorekRGB,1)])
line([konec_y konec_y], [1 size(vzorekRGB,1)])



for i=1:size(imBin,1)
   
    sumator_x(1,i) = sum(imBin(i,:)); 
       
end
%zacatek prohledavani
for i=1:size(sumator_x,2)
   if sumator_x(1,i) >= size(imBin,2)*1/2
       pocatek_x = i;
       break;
   end
end
%konec prohledavani
for i=size(sumator_x,2):-1:1
   if sumator_x(1,i) >= size(imBin,2)*1/2
       konec_x = i;
       break;
   end
end

%vzkresleni ocamcad pocamcad

line([1 size(vzorekRGB,2)], [pocatek_x pocatek_x])
line([1 size(vzorekRGB,2)], [konec_x konec_x])
hold off;



x =[10 11 12 13 14 15 16 17 18 19 20 30 31 32 33 34 35 36 37 38 39 40 ];
j=1;
k=0;

for n= pocatek_x:konec_x
    
%     radek = x(n);
    j=1;
    k= k+1;
    for i=pocatek_y:1:konec_y
        
    vod1_h= hsv(n,i,1)*360;
    vod1_s= hsv(n,i,2)*100;
    vod1_v= hsv(n,i,3)*100;

%          %pozadi
%        if vod1_h>=30 && vod1_h<=39 && vod1_s>=55 && vod1_s<=65 && vod1_v>=50 && vod1_v<=65
%         barvy(k,j)= 88;
%         j = j+1;  
%         continue;  
         %hneda
      if vod1_h>=10 && vod1_h<=25 && vod1_s>=50 && vod1_s<=100 && vod1_v>=15 && vod1_v<=40
        barvy(k,j)= 1;
        j = j+1;  
        continue;    
        % cervena
        elseif ((vod1_h>=0 && vod1_h<=15) ||(vod1_h>=350 && vod1_h<=360) ) && vod1_s>=50 && vod1_s<=100 && vod1_v>=40 && vod1_v<=60
        barvy(k,j)= 2;
        j = j+1;  
        continue; 
        % oranzova
        elseif vod1_h>=15 && vod1_h<=25 && vod1_s>=85 && vod1_s<=100 && vod1_v>=55 && vod1_v<=75
        barvy(k,j)= 3;
        j = j+1;  
        continue;
        %zluta
        elseif vod1_h>=40 && vod1_h<=50&& vod1_s>=75 && vod1_s<=90 && vod1_v>=50 && vod1_v<=65
        barvy(k,j)= 4;
        j = j+1;
      continue;
        % zelena
        elseif vod1_h>=100 && vod1_h<=130 && vod1_s>=50 && vod1_s<=75 && vod1_v>=18 && vod1_v<=30
        barvy(k,j)= 5;
        j = j+1;
       continue;
        %modra
        elseif vod1_h>=190 && vod1_h<=259 
        barvy(k,j)= 6;
        j = j+1;
      continue;
        % fialova
        elseif vod1_h>=260 && vod1_h<=340 && vod1_s>=30 && vod1_s<=60 && vod1_v>=10 && vod1_v<=25
        barvy(k,j)= 7;
        j = j+1;  
        continue;
       
 %seda1
       elseif vod1_h>=25 && vod1_h<=37 && vod1_s>=30 && vod1_s<=50 && vod1_v>=20&& vod1_v<=40 %vod1_v<=40
        barvy(k,j)= 8;
        j = j+1;
        continue;
        
         %seda2
       elseif vod1_h>=20 && vod1_h<=35 && vod1_s>=40 && vod1_s<=55 && vod1_v>=25&& vod1_v<=35 %vod1_v<=40
        barvy(k,j)= 8;
        j = j+1;
        continue;

%    zlata     vod1_h>=20 && vod1_h<=35 && vod1_s>=45 && vod1_s<=75 && vod1_v>=20&& vod1_v<=50
        
        % zlata 1
        elseif vod1_h>=30 && vod1_h<=50 && vod1_s>=20 && vod1_s<=60 && vod1_v>=80&& vod1_v<=95
        barvy(k,j)= 99;
        j = j+1;
        continue;
        
        % zlata 2
        elseif vod1_h>=20 && vod1_h<=40 && vod1_s>=40 && vod1_s<=70 && vod1_v>=20&& vod1_v<=50
        barvy(k,j)= 99;
        j = j+1;
        continue;
        
        % zlata 3
        elseif vod1_h>=25 && vod1_h<=40 && vod1_s>=55 && vod1_s<=75 && vod1_v>=50&& vod1_v<=80
        barvy(k,j)= 99;
        j = j+1;
        continue;
        
          

        
        %cerna
       elseif vod1_v>=0 && vod1_v<=15
        barvy(k,j)= 0;
        j = j+1; 
        continue;
        
        
        
        %bila
        elseif vod1_s>=10 && vod1_s<=40 && vod1_v>=60&& vod1_v<=100
        barvy(k,j)= 9;
        j = j+1;
        continue;
        % ani jedna 
        else
            barvy(k,j)= 99;
            j = j+1;
     end
    end
end
   
    barvy;

    povolene_pasmo_horni = barvy(1:(size(barvy,1)/2)-5,:); 
    povolene_pasmo_dolni = barvy((size(barvy,1)/2)+5:end,:); 
    
    % modusy jednotlivých pasem
  
    for i=1:size( povolene_pasmo_horni,2)
    modus_povolene_pasmo_horni(1,i)= mode(povolene_pasmo_horni(:,i));
    end
    
    % modusy jednotlivých pasem
  
    for i=1:size( povolene_pasmo_dolni,2)
    modus_povolene_pasmo_dolni(1,i)= mode(povolene_pasmo_dolni(:,i));
    end
    
    % modus z jednotlivých sloupecku
    
    modus_celk(1,:)=modus_povolene_pasmo_horni;
    modus_celk(2,:)=modus_povolene_pasmo_dolni;
   
    
    j=1;
    for i=1:size(modus_celk,2)
        if modus_celk(1,i)== modus_celk(2,i)
            modus(1,j)=modus_celk(1,i);
            j=j+1;
        end
    end
    modus;
    
    % zjisteni jak je natocenej
    for i=1:size(modus,2)
        if modus(1,i)~=99;
            vzdalenost_pocatek = i;
            break;
        end
    end
    
    for i=size(modus,2):-1:1
        if modus(1,i)~=99;
            vzdalenost_konec =size(modus,2)- i;
            break;
        end
    end
    
    % je li treba, prohodim pole
 rotace=0;
 
    if vzdalenost_pocatek > vzdalenost_konec
        
        pomocna = modus;
        rotace =1;
       
        for i=1: size(modus,2)
        modus(1,i)= pomocna(1,size(modus,2)-i+1);
       end
    end
 modus; 
% vysosnuti od kazdyho jedno 
    m=1;
    aktualni=789;
    predchozi=456;
    
    for k=1:size(modus,2)
      aktualni=modus(1,k);
      
     if aktualni~=predchozi
      retezec_hodnot(1,m) = aktualni;
      m=m+1;
      predchozi=aktualni;
   
     end
    end
retezec_hodnot; 

% urèení násobku
switch(retezec_hodnot(1,6))
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

hodnota_odporu = (retezec_hodnot(1,2)*10 + retezec_hodnot(1,4))*nasobek
hodnota_odporu_str = num2str(hodnota_odporu)
text(10,10,hodnota_odporu_str)

