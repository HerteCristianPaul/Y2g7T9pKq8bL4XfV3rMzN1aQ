%% --- LABORATOR 2 ---
% 1. Verificati functionarea algoritmului de detectie defecte prin comparatie.
% 2. Incercati functionarea cu o translatie diferita de cea corecta (adica 10,10).
% 3. Incercati sa folositi imaginea pcb.png (care nu e cropped) pentru
%       comparatie. Deoarece e de altă dimensiune, folosiți doar o porțiune din
%       imagine (stânga-sus, dreapta, jos, etc) cu dimensiunea corectă.
% 4.  Raspunsul este un fisier TXT care contine o descriere personala de cateva
%       fraze a constatarilor voastre pe subiect.


function main()
  initWorkspace
  [fullImg, oH, oW, oC]   = readImage('pcb.png');
  [defectImg, dH, dW, dC] = readImage('pcbCroppedTranslatedDefected.png');

  [hDiff, wDiff] = deal(oH - dH, oW - dW);

  croppedPortion = fullImg(hDiff + 1 : hDiff + dH, wDiff + 1 : wDiff + dW, :);

  % Perform shift
  [row, col] = size(croppedPortion);
  xShift = 10;
  yShift = 10;
  registImg = zeros(size(defectImg));
  registImg(yShift + 1 : row, xShift + 1 : col) = defectImg(1 : row - yShift, 1 : col - xShift);

  % Show difference images
  diffImg1 = abs(croppedPortion - defectImg);
  subplot(1, 3, 1), imshow(diffImg1); title('Unaligned Difference Image');

  diffImg2 = abs(croppedPortion - registImg);
  subplot(1, 3, 2), imshow(diffImg2); title('Aligned Difference Image');

  bwImg = diffImg2 > 0.15;
  [height, width] = size(bwImg);
  border = round(0.05*width);
  borderMask = zeros(height, width);
  borderMask(border:height-border, border:width-border) = 1;
  bwImg = bwImg .* borderMask;
  subplot(1, 3, 3), imshow(bwImg); title('Thresholded + Aligned Difference Image');

  imwrite(diffImg1, 'Defect_Detection_diff.png');
  imwrite(diffImg2, 'Defect_Detection_diffRegisted.png');
  imwrite(bwImg,    'Defect_Detection_bw.png');


end

function initWorkspace()
%INITWORKSPACE Clear workspace, command window, and close all figures.
%
%   initWorkspace() clears all variables from the workspace, clears the command
%   window, and closes all open figure windows.
%
%   Usage:
%       initWorkspace()
  clear, clc, close all;
end

function [img, H, W, C] = readImage(filename)
%READIMAGE Read an image and return it along with its dimensions.
%
%   [img, H, W, C] = readImage(filename) reads the image file specified
%   by 'filename', converts it to double precision, and returns the image
%   matrix 'img' along with its height H, width W, and number of channels C.
%
%   Input:
%       filename - string, path to the image file.
%
%   Outputs:te
%       img - the image matrix as double.
%       H   - height of the image (number of rows).
%       W   - width of the image (number of columns).
%       C   - number of color channels.
%
%   Example:
%       [img, H, W, C] = readImage('parrot.jpg');
    img = im2double(imread(filename));
    [H, W, C] = size(img);
end
