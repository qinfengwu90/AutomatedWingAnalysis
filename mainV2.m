% Start with a folder and get a list of all subfolders.
% Finds and prints names of all PNG, JPG, and TIF images in that folder and all of its subfolders.
% Similar to imageSet() function in the Computer Vision System Toolbox: http://www.mathworks.com/help/vision/ref/imageset-class.html

%% Prepare workspace
clc; % Clear the command window.
clear all
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;

%% Identify raw images and segmentation masks
% Define a starting folder.
dataFolder = 'data';
tic
% Get list of all subfolders.
listOfFolderNames = dir([dataFolder filesep]);
numberOfFolders = length(listOfFolderNames);
count = 1;
wingindex = 0;

%% Process all image files in those folders.
if numberOfFolders >= 1
    for k = 1 : numberOfFolders
        % Display foler name, get PNG files and TIFF files
        thisFolder = listOfFolderNames(k).name;
        fprintf('Processing folder %s\n', thisFolder);
        baseFileNamesPNG = dir([listOfFolderNames(k).folder filesep listOfFolderNames(k).name filesep '*.png']);
        baseFileNamesTIFF = dir([listOfFolderNames(k).folder filesep listOfFolderNames(k).name filesep '*.tif']);
        numberOfImageFiles = length(baseFileNamesTIFF);
        wingFeatures = table();
        %         wingFeatures = table(wingFile,areaIntervein1,areaIntervein2,areaIntervein3,areaIntervein4,areaIntervein5,areaIntervein6, ...
        %             areaIntervein7,trichome1,trichome2,trichome3,trichome4,trichome5,trichome6,trichome7);
        %         wingFeatures  = cell2table(cell(0,15), 'VariableNames',  ...
        %             {'wingFile','areaIntervein1','areaIntervein2','areaIntervein3','areaIntervein4','areaIntervein5','areaIntervein6', ...
        %             'areaIntervein7','trichome1','trichome2','trichome3','trichome4','trichome5','trichome6','trichome7'});
        wingFeatures = cell(numberOfImageFiles, 15);
        % Loop through all those image files
        if numberOfImageFiles >= 1
            for f = 1 : numberOfImageFiles
                rawImage = imread([baseFileNamesTIFF(f).folder filesep baseFileNamesTIFF(f).name]);
                segmentationMask = imread([baseFileNamesPNG(f).folder filesep baseFileNamesPNG(f).name]);
                bwLabel = wingMorphFilter(segmentationMask); %Label the regions in the seg mask. There should be 7 interveinal regions.
                baseFileNames = baseFileNamesTIFF(f).name(1:end-4);
                fullFileNameLabel = [baseFileNames '_Label.jpg'];
                fullFileNameMask = [baseFileNames '_Simple Segmentation.png'];
                %Check if the segmentation mask has 7 pixel classifications
                if max(max(bwLabel) == 7)
                    [bwLabel, yfit] = Classificn(bwLabel);
                    if length(yfit) == length(unique(yfit))
                        imwrite(label2rgb(bwLabel),[dataFolder filesep thisFolder filesep fullFileNameLabel])
                        [area_intervein, perimeter_intervein, eccentricity_intervein, major_intervein, ...
                            minor_intervein, positional_feature_intervein] = interveinalFeaturesBasic(bwLabel);
                        numTrichome = trichrome(rawImage, bwLabel);
                        
%                         [hairCoordinate1, Pprs1] = trichrome(rawImage, bwLabel, 1);
%                         [tri(1), n1] = size(hairCoordinate1);
%                         [hairCoordinate2, Pprs2] = trichrome(rawImage, bwLabel, 2);
%                         [tri(2), n1] = size(hairCoordinate2);
%                         [hairCoordinate3, Pprs3] = trichrome(rawImage, bwLabel, 3);
%                         [tri(3), n1] = size(hairCoordinate3);
%                         [hairCoordinate4, Pprs4] = trichrome(rawImage, bwLabel, 4);
%                         [tri(4), n1] = size(hairCoordinate4);
%                         [hairCoordinate5, Pprs5] = trichrome(rawImage, bwLabel, 5);
%                         [tri(5), n1] = size(hairCoordinate5);
%                         [hairCoordinate6, Pprs6] = trichrome(rawImage, bwLabel, 6);
%                         [tri(6), n1] = size(hairCoordinate6);
%                         [hairCoordinate7, Pprs7] = trichrome(rawImage, bwLabel, 7);
%                         [tri(7), n1] = size(hairCoordinate7);
                        
%                         wingFeatures{f, 1:7} = area_intervein;
                        featureWing(count,1:7) = area_intervein;
                        featureWing(count,8:14) = numTrichome;
                        featureWing(count,15) = wingindex;
                        FilesName{count,1} = strcat(baseFileNames);
                        count = count+1;
                        
                        %store all the data into a table
                        
                    end
                end
                %save('feature_imp_2293.mat','feature_imp_2293')
                fprintf('Processing image file: %s\n', baseFileNames);
            end
        end
        %save the data into a .MAT file
    end
else
    fprintf('Folder %s has no image files in it.\n', thisFolder);
    wingindex = wingindex + 1;
end

toc
toc-tic