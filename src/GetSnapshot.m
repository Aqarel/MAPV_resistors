% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	MAPV - uloha 5 - defektoskopie
%
%	- program otevre kameru a v nekonecne smycce while sbira snimky dokud
%	- upravte program tak, aby 
%   	- upravte program tak, aby na sejmutem snimku nalezl lahev (nastavil
%	  stav), zobrazil vektory b1 a b2 a zaroven osu lahve
%	
%	verze: 20.2.2013 / midas.uamt.feec.vutbr.cz
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% uklid
clear all;
close all;
clc;

%% kamera
imaqreset;
pause(2);
kam = GetCamera();%videoinput('winvideo',1);
triggerconfig(kam,'manual');
param = getselectedsource(kam);
param.ExposureMode = 'manual';
param.Exposure = -5;
param.GainMode = 'manual';
param.Gain = 260;


%% smycka zpracovani obrazu
start(kam);
pause(1);
%preview(kam);
for i=1:10
    input('Continue?','s')
    img = getsnapshot(kam);
    name = sprintf('black_%i',i);
    imshow(img);
    title(img);
    imwrite(img,[name '.png']);
end

stop(kam);
close all;


