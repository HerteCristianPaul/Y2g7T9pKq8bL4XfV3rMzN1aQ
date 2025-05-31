%% --- LABORATOR 3 ---

% 1. Verificați funcționarea mecanismului de detecție a defectelor din fișierul
%      atașat.
% 2. Modificați valorile pentru alpha și theta din cod și alegeți valori mai
%      potrivite (dacă există).
% 3. Încercați algoritmul pe alte secvențe video proprii și testați diferite
%      valori pentru alpha și theta.
% 4. Scrieți un fișier text cu câteva propoziții despre rezultate și valorile
%      constatate pentru alpha și theta.

% -----------------------------------------------------------------------------

% 1. Am verificat funcționarea mecanismului de detecție a defectelor din
%      fișierul atașat și am confirmat că algoritmul identifică corect zonele
%      de interes pe baza diferențelor față de fundal.
% 2. Am încercat multiple combinații de valori pentru alpha și theta, însă
%      singurele care au adus o îmbunătățire decentă a detecției au fost pentru
%      alpha = 0.99 si theta = 0.07. Restul valorilor fie făceau actualizarea
%      fundalului prea lentă, fie duceau la detecții prea agresive.
% 3. Am testat mai multe combinații de valori pentru parametrii alpha și theta.
%      Cele mai bune rezultate au fost obținute pentru alpha = 0.99, care a
%      permis o actualizare lentă și mai stabilă a fundalului, minimizând
%      efectele variațiilor mici din imagine. Pentru theta, o valoare între
%      0.08 și 0.15 a oferit rezultate bune în identificarea diferențelor
%      semnificative. Valori prea mici pentru theta duceau la multe alarme
%      false, iar valori prea mari ignorau schimbările relevante.
%      Cele mai potrivite valori găsite: aplha(0.99) & theta(0.12)


clear, clc, close all;
pkg load video

vrObj = VideoReader('surveillance.mpg');
vwObj = VideoWriter('test1.avi', 'MJPG');
open(vwObj);
nFrames = vrObj.NumberOfFrames;

alpha = 0.99;
theta = 0.12;
background = im2double(rgb2gray(readFrame(vrObj)));
for i = 1 : nFrames
    i
    currImg = im2double(rgb2gray(readFrame(vrObj)));
    background = alpha * background + (1 - alpha)* currImg;
    diffImg = abs(currImg - background);
    threshImg = diffImg > theta;

    subplot(2, 2, 1), imshow(currImg), title('New frame');
    subplot(2, 2, 2), imshow(background), title('Background frame');
    subplot(2, 2, 3), imshow(diffImg), title('Difference image');
    subplot(2, 2, 4), imshow(threshImg), title('Thresholded difference image');

    currFrame = getframe(1);
    writeVideo(vwObj, currFrame);
end
close(vwObj);

imwrite(currImg, 'Background_Subtraction_curr.png');
imwrite(background, 'Background_Subtraction_background.png');
imwrite(threshImg, 'Background_Subtraction_thresh.png');


