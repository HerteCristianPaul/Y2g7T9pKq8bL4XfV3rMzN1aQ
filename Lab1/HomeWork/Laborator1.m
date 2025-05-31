%% --- LABORATOR 1 ---
% 1. Modificare imagine doar pe jumatate sau pe o anumita regiune.
% 2. Constructie imagine "sintetic" : faceti linii sau cerc sau alte forme
%     geometrice completând valori in matricea de baza.

function main()
  %% EXE_1 - Aplicam un gradient de intunecare pe jumatatea stanga si o corectie
  %           gamma pe o zona aleatorie din jumatatea dreapta a imaginii.

  initWorkspace()
  [img, H, W, C] = readImage('parrot.jpg');
  [leftSide, rightSide, splitCol] = splitImageVertically(img, W);

  %% Brightness Gradient (left side)
  [xGrid, ~] = meshgrid(1:splitCol, 1:H);
  gradientScale = 1 + 0.9 * (xGrid / splitCol);
  editedLeft = leftSide .* gradientScale;

  %% Gamma Correction (right side)
  gamma = 1.8;
  gammaRegion = rightSide;

  rightW = size(rightSide, 2);
  randomRow = randi([round(H*0.2), round(H*0.7)]);
  randomCol = randi([round(rightW*0.6), rightW-50]);
  patchSize = 100;

  rowRange = randomRow : min(randomRow+patchSize-1, H);
  colRange = randomCol : min(randomCol+patchSize-1, rightW);

  gammaRegion(rowRange, colRange, :) = rightSide(rowRange, colRange, :).^gamma;

  displayAndSaveImage(
    [editedLeft gammaRegion], 'Deranged Parrot', 'deranged_parrot.png'
  )


  %% EXE_2 – Construim imagina "sintetica" cu forme geometrice

  H = 400; W = 600; C = 3;
  syntheticImg = zeros(H, W, C);

  syntheticImg = addRandomRectangle(syntheticImg, H, W);
  syntheticImg = addRandomCross(syntheticImg, H, W);
  syntheticImg = addRandomLineDiagonal(syntheticImg, H, W);

  displayAndSaveImage(syntheticImg, 'Synthetic Shapes', 'synthetic_shapes.png')

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
%   Outputs:
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

function [leftSide, rightSide, splitCol] = splitImageVertically(img, W)
%SPLITIMAGEVERTICALLY Splits an image into left and right halves vertically.
%
%   [leftSide, rightSide] = splitImageVertically(img)
%
%   Inputs:
%       img - Input image matrix (H x W x C).
%       W   - Width of the image
%
%   Outputs:
%       leftSide  - Left half of the image (all rows, first half columns).
%       rightSide - Right half of the image (all rows, second half columns).
%       splitCol  - Column index where the image is split (middle column).
%
%   Example:
%       img = imread('parrot.jpg');
%       [left, right, splitCol] = splitImageVertically(im2double(img));
    splitCol = round(W/2);
    leftSide = img(:, 1:splitCol, :);
    rightSide = img(:, splitCol+1:end, :);
end

function output = addRandomRectangle(imgIn, H, W)
%ADDRANDOMRECTANGLE Adds a rectangle of random size and color to the image.
%
%   output = ADDRANDOMRECTANGLE(imgIn, H, W) generates a rectangle with a
%   random position, size, and color, then overlays it on the input image.
%
%   Inputs:
%       imgIn - Input image matrix (H x W x 3)
%       H     - Height of the image
%       W     - Width of the image
%
%   Output:
%       output - Image matrix with the random rectangle added
%
%   Example:
%       img = zeros(400,600,3);
%       imgWithRect = addRandomRectangle(img, 400, 600);
%
%   The rectangle's height and width are random values between 10% and 25%
%   of the image's dimensions. The color is random for each RGB channel.
    rectHeight = randi([H/10, H/4]);
    rectWidth = randi([W/10, W/4]);
    rowStart = randi([1, H - rectHeight]);
    colStart = randi([1, W - rectWidth]);
    rowRange = [rowStart, rowStart + rectHeight - 1];
    colRange = [colStart, colStart + rectWidth - 1];
    color = rand(1, 3);

    output = imgIn;
    for c = 1:3
        output(rowRange(1):rowRange(2), colRange(1):colRange(2), c) = color(c);
    end
end

function imgOut = addRandomCross(imgIn, H, W)
%ADDRANDOMCROSS Adds a cross (horizontal and vertical lines) of random
%position and color to the image.
%
%   imgOut = ADDRANDOMCROSS(imgIn, H, W) adds a cross shape with a random
%   position and random color on the input image.
%
%   Inputs:
%       imgIn - Input image matrix (H x W x 3)
%       H     - Height of the image
%       W     - Width of the image
%
%   Output:
%       imgOut - Image matrix with the cross added
%
%   Example:
%       img = zeros(400,600,3);
%       imgWithCross = addRandomCross(img, 400, 600);
%
%   The cross consists of a horizontal and vertical line of fixed width
%   (11 pixels), placed at a random location within the image. The color is
%   randomized for each RGB channel.
    lineWidth = 11;
    margin = 25;
    centerRow = randi([margin+1, H-margin]);
    centerCol = randi([margin+1, W-margin]);
    rowRange = centerRow - floor(lineWidth/2) : centerRow + floor(lineWidth/2);
    rowRange = max(1, min(H, rowRange));
    colRange = centerCol - floor(lineWidth/2) : centerCol + floor(lineWidth/2);
    colRange = max(1, min(W, colRange));
    color = rand(1, 3);

    imgOut = imgIn;
    imgOut(rowRange, :, :) = repmat(reshape(color, [1 1 3]), numel(rowRange), W);
    imgOut(:, colRange, :) = repmat(reshape(color, [1 1 3]), H, numel(colRange));
end

function imgOut = addRandomLineDiagonal(imgIn, H, W)
%ADDRANDOMLINEDIAGONAL Adds a diagonal line of random color to the image.
%
%   imgOut = ADDRANDOMLINEDIAGONAL(imgIn, H, W) overlays a diagonal line
%   from the top-left corner to the bottom-right corner of the input image
%   using a randomly generated color.
%
%   Inputs:
%       imgIn - Input image matrix (H x W x 3)
%       H     - Height of the image
%       W     - Width of the image
%
%   Output:
%       imgOut - Image matrix with the diagonal line added
%
%   Example:
%       img = zeros(400,600,3);
%       imgWithLine = addRandomLineDiagonal(img, 400, 600);
%
%   The line color is randomized across the three RGB channels.
    imgOut = imgIn;
    color = rand(1, 3);
    for i = 1:min(H, W)
        for c = 1:3
            imgOut(i, i, c) = color(c);
        end
    end
end

function displayAndSaveImage(img, titleText, fileName)
%DISPLAYANDSAVEIMAGE Display an image, add a title, and save to file.
%
%   displayAndSaveImage(img, titleText, fileName) displays the input image
%   'img', sets the figure title to 'titleText', and saves the image to a
%   file specified by 'fileName'.
%
%   Inputs:
%       img       - Image matrix to display and save (e.g., RGB or grayscale).
%       titleText - String specifying the title to display on the figure.
%       fileName  - String specifying the filename to save the image.
%
%   Example:
%       displayAndSaveImage(finalImg, 'Deranged Parrot', 'deranged_parrot.png');
    figure;
    imshow(img);
    title(titleText);
    imwrite(img, fileName);
end

