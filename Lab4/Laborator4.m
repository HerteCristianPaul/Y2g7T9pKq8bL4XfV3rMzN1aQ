%% --- LABORATOR 4 ---

% 1. Testati cele doua script-uri exemplu in Matlab sau Octave.
% 2. Verificati functionarea. Evaluati distributia determinata de script-ul
%      "Histogram" si efectul corector din "Histogram_Equalization".
% 3. Aplicati transformarile pentru toate cele trei imagini (bay, brain, moon).
% 4. Degradati intentionat una din imagini folosind metode de la tema "point
%      operations" (contrast/luminozitate). Aplicati din nou transformarile pe
%      baza de histograma.
%  Rezultatul temei este un text in care descrieti constatarile voastre
%    obtinute ca urmare a parcurgerii temei.

% -----------------------------------------------------------------------------

% ! In OCTAVE script-ul Histogram.m nu functioneaza out of the box. Necesitati:
%     - install in OCTAVE (Command Window) 'pkg install -forge image'
%     - add 'pkg load image' before 'imhist' || 'histeq' usage

% 1. Am testat cele două scripturi în OCTAVE. Ambele funcționează corect:
%      primul script face egalizarea histogramei, iar al doilea afișează
%      histograma imaginii originale.
% 2. Scriptul „Histogram” ilustrează modul în care pixelii imaginii sunt
%      distribuiți pe nivele de gri, scoțând în evidență zonele în care valorile
%      se aglomerează într-un interval limitat. Acest lucru oferă o imagine
%      clară asupra contrastului general: dacă valorile sunt concentrate într-o
%      zonă restrânsă, contrastul este slab, iar detaliile pot fi mai greu de
%      distins.
%    Scriptul „Histogram_Equalization” prelucrează valorile pixelilor și le
%      redistribuie astfel încât histograma imaginii să fie întinsă uniform pe
%      tot intervalul 0–255. Prin această transformare, contrastul imaginii
%      crește vizibil: detaliile devin mai clare, zonele închise și deschise
%      sunt mai bine evidențiate, iar imaginea capătă un aspect mai echilibrat
%      și mai ușor de interpretat. Practic, egalizarea histogramei „întinde”
%      tonurile de gri, astfel încât informația vizuală să fie mai bine
%      răspândită și mai ușor de perceput.
% 3. Pentru toate cele trei imagini (bay, brain, moon), scriptul încarcă
%      fiecare, aplică egalizarea histogramei cu histeq, apoi afișează și
%      salvează imaginile originale și corectate împreună cu histogramele lor
%      pentru a evalua efectul transformării.
% 4. RULAREA SCRIPTULUI SUPRASCRIE INAGINEA 'brain.jpg' CU O VERSIUNE MODIFICATA
%    FACETI BACKUP pentru 'brain.jpg'
%    Pentru a evalua efectele transformărilor pe bază de histogramă în situații
%      în care o imagine este degradată intenționat, am ales să modific imaginea
%      „brain.jpg” aplicând o degradare artificială. În jumătatea stângă a
%      imaginii, am folosit o scalare a contrastului printr-un gradient liniar,
%      care crește progresiv intensitatea pixelilor de la stânga la dreapta.
%      După aceste degradări, am aplicat din nou egalizarea histogramei asupra
%      imaginii afectate. Rezultatele au arătat că, deși transformările de tip
%      histogram equalization pot îmbunătăți contrastul general și pot „întinde”
%      intervalul dinamic al imaginii, ele nu pot anula complet efectele unor
%      degradări severe sau locale, cum sunt variațiile abrupte de contrast.

% Pentru a vedea toate implementările complete și tot ce ține de materia PI,
%   acestea sunt disponibile la:
%   https://github.com/HerteCristianPaul/Y2g7T9pKq8bL4XfV3rMzN1aQ.

% ----------------------------------------------------------------------------

function main()
  initWorkspace();

  % Degrading Image
  [degradedImg, H, W, C] = readImage('brain.jpg');
  [leftSide, rightSide, splitCol] = splitImageVertically(degradedImg, W);

  [xGrid, ~] = meshgrid(1:splitCol, 1:H);
  gradientScale = 1 + 0.9 * (xGrid / splitCol);
  editedLeft = leftSide .* gradientScale;

  displayAndSaveImage(
    [editedLeft rightSide], 'Half Degraded Brain', 'brain.jpg'
  )

  % Transformation on all 3 images
  images = {'bay.jpg', 'brain.jpg', 'moon.jpg'};
  [originalImages, eqImages] = loadAndEqualizeImages(images);

  displayImagesSideBySide(originalImages, eqImages);
  saveEqualizedImages(eqImages, images);

  [countsOrig, idxOrig] = calculateHistograms(originalImages);
  [countsEq, idxEq] = calculateHistograms(eqImages);

  displayHistograms(countsOrig, idxOrig, countsEq, idxEq, images);
end

function [originalImages, eqImages] = loadAndEqualizeImages(filenames)
%LOADANDEQUALIZEIMAGES Încarcă imagini și aplică egalizarea histogramei.
%   Input:
%       filenames - celulă cu numele fișierelor de imagine.
%   Output:
%       originalImages - celulă cu imaginile încărcate original.
%       eqImages       - celulă cu imaginile după egalizarea histogramei.
%
%   Usage:
%       [originalImages, eqImages] = loadAndEqualizeImages({'img1.jpg', 'img2.png'})
  n = length(filenames);
  originalImages = cell(1, n);
  eqImages = cell(1, n);
  for i = 1:n
    originalImages{i} = imread(filenames{i});
    eqImages{i} = histeq(originalImages{i});
  end
end

function displayImagesSideBySide(originalImages, eqImages)
%DISPLAYIMAGESSIDEBYSIDE Afișează imaginile originale și cele egalizate în subplote alăturate.
%   Input:
%       originalImages - celulă cu imaginile originale.
%       eqImages       - celulă cu imaginile egalizate.
%
%   Imaginile sunt afișate în câte două coloane: original în stânga, egalizat în dreapta.
%
%   Usage:
%       displayImagesSideBySide(originalImages, eqImages)
  n = length(originalImages);
  figure(2), clf;
  for i = 1:n
    subplot(n, 2, 2*i - 1);
    imshow(originalImages{i});
    [~, name, ~] = fileparts(inputname(1 + (i-1)*2));
    title(['Original ', num2str(i)]);
    subplot(n, 2, 2*i);
    imshow(eqImages{i});
    title('After histogram equalization');
  end
end

function saveEqualizedImages(eqImages, originalFilenames)
%SAVEEQUALIZEDIMAGES Salvează imaginile egalizate pe disc.
%   Input:
%       eqImages         - celulă cu imaginile egalizate.
%       originalFilenames - celulă cu numele fișierelor originale (pentru a genera nume noi).
%
%   Imaginile se salvează cu prefixul 'HEqualization_eqImg_' urmat de numele imaginii originale și extensia .png.
%
%   Usage:
%       saveEqualizedImages(eqImages, {'bay.jpg', 'brain.jpg'})
  n = length(eqImages);
  for i = 1:n
    [~, name, ~] = fileparts(originalFilenames{i});
    filename = ['HEqualization_eqImg_', name, '.png'];
    imwrite(eqImages{i}, filename);
  end
end

function [countsAll, idxAll] = calculateHistograms(images)
%CALCULATEHISTOGRAMS Calculează histogramele pentru o listă de imagini.
%   Input:
%       images - celulă cu imaginile pentru care se calculează histogramele.
%   Output:
%       countsAll - celulă cu vectorii de frecvențe ale nivelelor de gri.
%       idxAll    - celulă cu vectorii de nivele de gri (de obicei 0:255).
%
%   Usage:
%       [counts, idx] = calculateHistograms({img1, img2, img3})
  n = length(images);
  countsAll = cell(1, n);
  idxAll = cell(1, n);
  for i = 1:n
    [countsAll{i}, idxAll{i}] = imhist(images{i});
  end
end

function displayHistograms(countsOrig, idxOrig, countsEq, idxEq, filenames)
%DISPLAYHISTOGRAMS Afișează histogramele originale și egalizate pentru mai multe imagini.
%   Input:
%       countsOrig - celulă cu histogramele imaginilor originale.
%       idxOrig    - celulă cu nivelele de gri pentru histogramele originale.
%       countsEq   - celulă cu histogramele imaginilor egalizate.
%       idxEq      - celulă cu nivelele de gri pentru histogramele egalizate.
%       filenames  - celulă cu numele fișierelor originale (folosite la titluri).
%
%   Histogramele sunt afișate în subplot-uri cu câte două coloane: original și egalizat.
%
%   Usage:
%       displayHistograms(countsOrig, idxOrig, countsEq, idxEq, filenames)
  n = length(countsOrig);
  figure(3), clf;
  for i = 1:n
    [~, name, ~] = fileparts(filenames{i});

    subplot(n, 2, 2*i - 1);
    bar(idxOrig{i}, countsOrig{i});
    xlim([0 255]);
    set(gca, 'FontSize', 14);
    xlabel('Gray level');
    ylabel('# pixels');
    title(['Histogram of ', name]);

    subplot(n, 2, 2*i);
    bar(idxEq{i}, countsEq{i});
    xlim([0 255]);
    set(gca, 'FontSize', 14);
    xlabel('Gray level');
    ylabel('# pixels');
    title(['Equalized ', name]);
  end
end

function initWorkspace()
%INITWORKSPACE Clears the workspace, command window, and closes all figure windows.
%
%   This function performs a complete reset of the MATLAB/Octave environment by:
%       - Clearing all variables from the workspace.
%       - Clearing the command window.
%       - Closing all open figures.
%       - Loading the 'image' package for image processing functions.
%
%   Usage:
%       initWorkspace()
%
%   Example:
%       initWorkspace(); % Reset environment before running a new script.
%
%   This is useful for ensuring a clean environment when running scripts or functions.
  clear, clc, close all;
  pkg load image
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
    figure(1);
    imshow(img);
    title(titleText);
    imwrite(img, fileName);
end

