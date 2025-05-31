% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Where is the defect?

clear, clc, close all;

% Load test images
origImg =  im2double(imread('pcbCropped.png'));
defectImg = im2double(imread('pcbCroppedTranslatedDefected.png')); %(10, 10) shifted

% Perform shift
[row, col] = size(origImg);
xShift = 10;
yShift = 10;
registImg = zeros(size(defectImg));
registImg(yShift + 1 : row, xShift + 1 : col) = defectImg(1 : row - yShift, 1 : col - xShift);

% Show difference images
diffImg1 = abs(origImg - defectImg);
subplot(1, 3, 1), imshow(diffImg1); title('Unaligned Difference Image');

diffImg2 = abs(origImg - registImg);
subplot(1, 3, 2), imshow(diffImg2); title('Aligned Difference Image');

bwImg = diffImg2 > 0.15;
[height, width] = size(bwImg);
border = round(0.05*width);
borderMask = zeros(height, width);
borderMask(border:height-border, border:width-border) = 1;
bwImg = bwImg .* borderMask;
subplot(1, 3, 3), imshow(bwImg); title('Thresholded + Aligned Difference Image');

% Save images
imwrite(diffImg1, 'Defect_Detection_diff.png');
imwrite(diffImg2, 'Defect_Detection_diffRegisted.png');
imwrite(bwImg, 'Defect_Detection_bw.png');

