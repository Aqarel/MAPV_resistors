
function [img] = GetSnapshot()

% kamera
imaqreset;
pause(10);
kam = GetCamera();%videoinput('winvideo',1);
triggerconfig(kam,'manual');
param = getselectedsource(kam);
param.ExposureMode = 'manual';
param.Exposure = -6;
param.GainMode = 'manual';
param.Gain = 320;

% smycka zpracovani obrazu
start(kam);
pause(1);


%preview(kam);
for i=12:55
    input('Continue?','s')
    img = getsnapshot(kam);
    name = sprintf('white_%i',i);
    imshow(img);
    title(img);
    imwrite(img,[name '.png']);
end


img = getsnapshot(kam);
stop(kam);


