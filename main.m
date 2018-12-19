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
        
        % Loop through all those image files
        if numberOfImageFiles >= 1
        for f = 1 : numberOfImageFiles
            rawImage = imread([baseFileNamesTIFF(k).folder filesep baseFileNamesTIFF(k).name]);
            segmentationMask = imread([baseFileNamesPNG(k).folder filesep baseFileNamesPNG(k).name]);
            bwLabel = wingMorphFilter(rawImage, segmentationMask); %Label the object in the seg mask. There should be 7 interveinal regions. 
            baseFileNames = baseFileNamesTIFF(k).name(1:end-4);
            fullFileNameLabel = [baseFileNames '_Label.jpg'];
            fullFileNameMask = [baseFileNames '_Simple Segmentation.png'];
            %Check if the segmentation mask has 7 pixel classifications
            if max(max(bwLabel) == 7)
                [bwLabel, yfit] = Classificn(bwLabel); %Description of this function
                if length(yfit) == length(unique(yfit))
                    imwrite(label2rgb(bwLabel),[dataFolder filesep thisFolder filesep fullFileNameLabel])
                    [hair_id1, Pprs1] = trichrome(rawImage, bwLabel, 1);
                    [tri(1), n1] = size(hair_id1);
                    [hair_id2, Pprs2] = trichrome(rawImage, bwLabel, 2);
                    [tri(2), n1] = size(hair_id2);
                    [hair_id3, Pprs3] = trichrome(rawImage, bwLabel, 3);
                    [tri(3), n1] = size(hair_id3);
                    [hair_id4, Pprs4] = trichrome(rawImage, bwLabel, 4);
                    [tri(4), n1] = size(hair_id4);
                    [hair_id5, Pprs5] = trichrome(rawImage, bwLabel, 5);
                    [tri(5), n1] = size(hair_id5);
                    [hair_id6, Pprs6] = trichrome(rawImage, bwLabel, 6);
                    [tri(6), n1] = size(hair_id6);
                    [hair_id7, Pprs7] = trichrome(rawImage, bwLabel, 7);
                    [tri(7), n1] = size(hair_id7);
                    [area_intervein, perimeter_intervein, eccentricity_intervein, major_intervein, ...
                        minor_intervein, positional_feature_intervein] = interveinalFeaturesBasic(rawImage, bwLabel);
                    featureWing(count,1:7) = area_intervein;
                    featureWing(count,8:14) = tri;
                    featureWing(count,15) = wingindex;
                    FilesName{count} = strcat(baseFileNames);
                    count = count+1;
                end              
            end
            %save('feature_imp_2293.mat','feature_imp_2293')
            fprintf('Processing image file %s\n', [baseFileNamesTIFF(k).folder filesep baseFileNamesTIFF(k).name]);
        end
        end
    end
else
    fprintf('Folder %s has no image files in it.\n', thisFolder);
    wingindex = wingindex + 1; 
end

toc
toc - tic