function [ ValueOfResistor] = ReadColorCode( AreaWithResistor )
% Funkce ète hodnotu barevneho kodu na rezistoru
% Input:
% - AreaWithResistor - color image RGB
% 
% Output:
% - ValueOfResistor - hodnota odporu rezistoru jako string, vrátí 0, když nenejde
%                       vsechny pruhy


vzorekRGB = AreaWithResistor;
hsv = rgb2hsv(vzorekRGB);

% oblast hledaní barevných pruhù
seOpen = strel('square', 5);
seClose = strel('square', 8);
% Tsat = 0.35;
Tsat = 0.25;

imBin = hsv(:,:,2) > Tsat;     % From saturation
imBin = imopen(imBin, seOpen);
imBin = imclose(imBin, seClose);

% figure();
% imshow(imBin);


for i=1:size(imBin,2)
   
    sumator_y(1,i) = sum(imBin(:,i)); 
       
end

%zacatek prohledavani
for i=1:size(sumator_y,2)
   if sumator_y(1,i) >= size(imBin,1)*0.6
       pocatek_y = i;
       break;
   end
end
%konec prohledavani
for i=size(sumator_y,2):-1:1
   if sumator_y(1,i) >= size(imBin,1)*0.6
       konec_y = i;
       break;
   end
end

%vzkresleni ocamcad pocamcad
% figure;
% imshow(vzorekRGB);
% hold on;
% 
% 
% line([pocatek_y pocatek_y], [1 size(vzorekRGB,1)])
% line([konec_y konec_y], [1 size(vzorekRGB,1)])
% 


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
% 
% line([1 size(vzorekRGB,2)], [pocatek_x pocatek_x])
% line([1 size(vzorekRGB,2)], [konec_x konec_x])
% hold off;



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
        
    
    %hneda
%       if ((vod1_h>=320 && vod1_h<=360) || (vod1_h>=0 && vod1_h<=36)) && vod1_s>=50 && vod1_s<=100 && vod1_v>=9 && vod1_v<=30
        if ((vod1_h>=359 && vod1_h<=360) || (vod1_h>=0 && vod1_h<=25)) && vod1_s>=50 && vod1_s<=100 && vod1_v>=8 && vod1_v<=30
        barvy(k,j)= 1;
        j = j+1;  
        continue;    
        % cervena
        elseif ((vod1_h>=320 && vod1_h<=360) ||(vod1_h>=0 && vod1_h<=35) ) && vod1_s>=80 && vod1_s<=100 && vod1_v>=31 && vod1_v<=60
        barvy(k,j)= 2;
        j = j+1;  
        continue; 
        % oranzova
%         elseif vod1_h>=15 && vod1_h<=25 && vod1_s>=85 && vod1_s<=100 && vod1_v>=55 && vod1_v<=75
            elseif vod1_h>=15 && vod1_h<=30 && vod1_s>=80 && vod1_s<=100 && vod1_v>=40 && vod1_v<=70
        barvy(k,j)= 3;
        j = j+1;  
        continue;
        %zluta
%         elseif vod1_h>=40 && vod1_h<=50&& vod1_s>=75 && vod1_s<=90 && vod1_v>=50 && vod1_v<=65
        elseif vod1_h>=40 && vod1_h<=51&& vod1_s>=75 && vod1_s<=93 && vod1_v>=40 && vod1_v<=70
        barvy(k,j)= 4;
        j = j+1;
      continue;
        % zelena
%         elseif vod1_h>=100 && vod1_h<=130 && vod1_s>=50 && vod1_s<=75 && vod1_v>=18 && vod1_v<=30
        elseif vod1_h>=65 && vod1_h<=160 && vod1_s>=30 && vod1_s<=80 && vod1_v>=8 && vod1_v<=40
        barvy(k,j)= 5;
        j = j+1;
       continue;
        %modra
        elseif vod1_h>=190 && vod1_h<=239 && vod1_s>=40 && vod1_s<=100 && vod1_v>=10 && vod1_v<=45
        barvy(k,j)= 6;
        j = j+1;
      continue;
        % fialova
        elseif vod1_h>=240 && vod1_h<=340 && vod1_s>=25 && vod1_s<=95 && vod1_v>=10 && vod1_v<=35
        barvy(k,j)= 7;
        j = j+1;  
        continue;
       
%     %seda1
%        elseif ((vod1_h>=250 && vod1_h<=360) ||(vod1_h>=0 && vod1_h<=35) ) && vod1_s>=6 && vod1_s<=57 && vod1_v>=13 && vod1_v<=38
%         barvy(k,j)= 8;
%         j = j+1;
%         continue;
         %seda1
       elseif vod1_h>=0 && vod1_h<=35 && vod1_s>=5 && vod1_s<=52 && vod1_v>=13 && vod1_v<=38
        barvy(k,j)= 8;
        j = j+1;
        continue;
        
%          %seda2
%        elseif vod1_h>=20 && vod1_h<=35 && vod1_s>=40 && vod1_s<=55 && vod1_v>=25&& vod1_v<=35 %vod1_v<=40
%         barvy(k,j)= 8;
%         j = j+1;
%         continue;
          

% %  zlata 1
%         elseif vod1_h>=30 && vod1_h<=50 && vod1_s>=20 && vod1_s<=60 && vod1_v>=80&& vod1_v<=95
%         barvy(k,j)= 99;
%         j = j+1;
%         continue;
%         
%         % zlata 2
%         elseif vod1_h>=20 && vod1_h<=40 && vod1_s>=40 && vod1_s<=70 && vod1_v>=20&& vod1_v<=50
%         barvy(k,j)= 99;
%         j = j+1;
%         continue;
%         
%         % zlata 3
%         elseif vod1_h>=25 && vod1_h<=40 && vod1_s>=55 && vod1_s<=75 && vod1_v>=50&& vod1_v<=80
%         barvy(k,j)= 99;
%         j = j+1;
%         continue;

%pravdepodbne pozadí nebo zlata
   elseif  vod1_h>=25 && vod1_h<=35  
       
       barvy(k,j)= 99;
        j = j+1;
        continue;
        
 %bila
        elseif vod1_h>=10 && vod1_h<=66  && vod1_s>=5 && vod1_s<=40 && vod1_v>=60&& vod1_v<=90% 60
        barvy(k,j)= 9;
        j = j+1;
        continue;


%     %bila
%         elseif vod1_h>=11 && vod1_h<=66 && vod1_s>=5 && vod1_s<=40 && vod1_v>=50&& vod1_v<=100% 60
%         barvy(k,j)= 9;
%         j = j+1;
%         continue;
     %bila
%         elseif vod1_s>=10 && vod1_s<=40 && vod1_v>=60&& vod1_v<=100
%         barvy(k,j)= 9;
%         j = j+1;
%         continue;   
        
        %cerna
       elseif vod1_v>=0 && vod1_v<=15
        barvy(k,j)= 0;
        j = j+1; 
        continue;
                       
        
        % ani jedna 
        else
            barvy(k,j)= 99;
            j = j+1;

%         %hneda
%       if vod1_h>=10 && vod1_h<=25 && vod1_s>=50 && vod1_s<=100 && vod1_v>=15 && vod1_v<=40
%         barvy(k,j)= 1;
%         j = j+1;  
%         continue;    
%         % cervena
%         elseif ((vod1_h>=0 && vod1_h<=15) ||(vod1_h>=350 && vod1_h<=360) ) && vod1_s>=50 && vod1_s<=100 && vod1_v>=40 && vod1_v<=60
%         barvy(k,j)= 2;
%         j = j+1;  
%         continue; 
%         % oranzova
% %         elseif vod1_h>=15 && vod1_h<=25 && vod1_s>=85 && vod1_s<=100 && vod1_v>=55 && vod1_v<=75
%             elseif vod1_h>=15 && vod1_h<=30 && vod1_s>=80 && vod1_s<=100 && vod1_v>=51 && vod1_v<=75
%         barvy(k,j)= 3;
%         j = j+1;  
%         continue;
%         %zluta
% %         elseif vod1_h>=40 && vod1_h<=50&& vod1_s>=75 && vod1_s<=90 && vod1_v>=50 && vod1_v<=65
%         elseif vod1_h>=40 && vod1_h<=50&& vod1_s>=60 && vod1_s<=90 && vod1_v>=50 && vod1_v<=75
%         barvy(k,j)= 4;
%         j = j+1;
%       continue;
%         % zelena
% %         elseif vod1_h>=100 && vod1_h<=130 && vod1_s>=50 && vod1_s<=75 && vod1_v>=18 && vod1_v<=30
%         elseif vod1_h>=80 && vod1_h<=130 && vod1_s>=50 && vod1_s<=75 && vod1_v>=18 && vod1_v<=30
%         barvy(k,j)= 5;
%         j = j+1;
%        continue;
%         %modra
%         elseif vod1_h>=190 && vod1_h<=259 
%         barvy(k,j)= 6;
%         j = j+1;
%       continue;
%         % fialova
%         elseif vod1_h>=260 && vod1_h<=340 && vod1_s>=30 && vod1_s<=60 && vod1_v>=10 && vod1_v<=25
%         barvy(k,j)= 7;
%         j = j+1;  
%         continue;
%        
%  %seda1
%        elseif vod1_h>=25 && vod1_h<=37 && vod1_s>=30 && vod1_s<=50 && vod1_v>=20&& vod1_v<=40 %vod1_v<=40
%         barvy(k,j)= 8;
%         j = j+1;
%         continue;
%         
%          %seda2
%        elseif vod1_h>=20 && vod1_h<=35 && vod1_s>=40 && vod1_s<=55 && vod1_v>=25&& vod1_v<=35 %vod1_v<=40
%         barvy(k,j)= 8;
%         j = j+1;
%         continue;
% 
%        
%         % zlata 1
%         elseif vod1_h>=30 && vod1_h<=50 && vod1_s>=20 && vod1_s<=60 && vod1_v>=80&& vod1_v<=95
%         barvy(k,j)= 99;
%         j = j+1;
%         continue;
%         
%         % zlata 2
%         elseif vod1_h>=20 && vod1_h<=40 && vod1_s>=40 && vod1_s<=70 && vod1_v>=20&& vod1_v<=50
%         barvy(k,j)= 99;
%         j = j+1;
%         continue;
%         
%         % zlata 3
%         elseif vod1_h>=25 && vod1_h<=40 && vod1_s>=55 && vod1_s<=75 && vod1_v>=50&& vod1_v<=80
%         barvy(k,j)= 99;
%         j = j+1;
%         continue;
%                           
%         %cerna
%        elseif vod1_v>=0 && vod1_v<=15
%         barvy(k,j)= 0;
%         j = j+1; 
%         continue;
%                        
%         %bila
%         elseif vod1_s>=10 && vod1_s<=40 && vod1_v>=60&& vod1_v<=100
%         barvy(k,j)= 9;
%         j = j+1;
%         continue;
%         % ani jedna 
%         else
%             barvy(k,j)= 99;
%             j = j+1;
     end
    end
end
   
    barvy;
     % modusy pres celou oblast
     i=1;
    for i=1:size( barvy,2)
    modus_pres_celou_oblast(1,i)= mode(barvy(:,i));
    end

        
    povolene_pasmo_horni = barvy(1:(size(barvy,1)/2)-5,:); 
    povolene_pasmo_dolni = barvy((size(barvy,1)/2)+5:end,:); 
    
    pasmo=[povolene_pasmo_horni;povolene_pasmo_dolni];
    
    
    
    % modusy pasma
     i=1;
    for i=1:size( barvy,2)
    modus_pasma(1,i)= mode(pasmo(:,i));
    end
    
    modus_sum =  modus_pasma;
    i = 1;
    j=1;
    
    for i=2:size(modus_sum,2)-1
        
        if (modus_sum(i)~= modus_sum(i+1) && modus_sum(i)~= modus_sum(i-1))
            
        else
        modus(j)= modus_sum(i);
        j=j+1;
        end
        
    end
    
    
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

%  if size(retezec_hodnot,2)	~=7
%      retezec_hodnot=0;
%  end

nasobek =0;

    if size(retezec_hodnot,2)==7
% urèení násobku
switch(retezec_hodnot(1,6))
   case 0
      nasobek= 1;
       cislo_1_str = num2str(retezec_hodnot(1,2));
      cislo_2_str = num2str(retezec_hodnot(1,4));
       ValueOfResistor = [ cislo_1_str  cislo_2_str 'R'];
   case 1
       nasobek= 10;
      cislo_1_str = num2str(retezec_hodnot(1,2));
      cislo_2_str = num2str(retezec_hodnot(1,4));
       ValueOfResistor = [ cislo_1_str  cislo_2_str '0' 'R'];
      case 2
      nasobek= 100;
      cislo_1_str = num2str(retezec_hodnot(1,2));
      cislo_2_str = num2str(retezec_hodnot(1,4));
      ValueOfResistor = [cislo_1_str 'K' cislo_2_str];
   case 3
      nasobek= 1000;
      cislo_1_str = num2str(retezec_hodnot(1,2));
      cislo_2_str = num2str(retezec_hodnot(1,4));
       ValueOfResistor = [ cislo_1_str  cislo_2_str 'K'];
      case 4
      nasobek= 10000;
      cislo_1_str = num2str(retezec_hodnot(1,2));
      cislo_2_str = num2str(retezec_hodnot(1,4));
       ValueOfResistor = [ cislo_1_str  cislo_2_str '0' 'K'];
   case 5
      nasobek= 100000;
      cislo_1_str = num2str(retezec_hodnot(1,2));
      cislo_2_str = num2str(retezec_hodnot(1,4));
      ValueOfResistor = [cislo_1_str 'M' cislo_2_str];
      case 6
      nasobek= 1000000;
     cislo_1_str = num2str(retezec_hodnot(1,2));
      cislo_2_str = num2str(retezec_hodnot(1,4));
       ValueOfResistor = [ cislo_1_str  cislo_2_str 'M'];
   case 7
      nasobek= 10000000;
      cislo_1_str = num2str(retezec_hodnot(1,2));
      cislo_2_str = num2str(retezec_hodnot(1,4));
       ValueOfResistor = [ cislo_1_str  cislo_2_str '0' 'M'];
end
    ValueOfResistor


% text(20,50,ValueOfResistor);
else 
    hodnota_odporu = 0;
ValueOfResistor = 'XX'

% text(20,50,ValueOfResistor);
end
end

