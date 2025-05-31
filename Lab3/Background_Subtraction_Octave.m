% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University 

% Script by Qiyuan Tian and David Chen
% Video background subtraction

clear, clc, close all;
pkg load video
% Read video
vrObj = VideoReader('surveillance.mpg');
%vwObj = VideoWriter('Background_Subtraction', 'Motion JPEG AVI');
vwObj = VideoWriter('Background_Subtraction.avi', 'MJPG');
#vwObj.FrameRate = 30;
#vwObj.Quality = 95;
open(vwObj);    
nFrames = vrObj.NumberOfFrames;

% Perform background accumulation and subtraction
alpha = 0.95;
theta = 0.1;
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

% Save images
imwrite(currImg, 'Background_Subtraction_curr.png');
imwrite(background, 'Background_Subtraction_background.png');
imwrite(threshImg, 'Background_Subtraction_thresh.png');


