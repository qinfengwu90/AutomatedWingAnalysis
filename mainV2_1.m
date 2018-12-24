% Start with a folder and get a list of all subfolders.
% Finds and prints names of all PNG, JPG, and TIF images in that folder and all of its subfolders.
% Similar to imageSet() function in the Computer Vision System Toolbox: http://www.mathworks.com/help/vision/ref/imageset-class.html

%% Prepare workspace
clc; % Clear the command window.
clearvars
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;

%% Identify raw images and segmentation masks
% Define a starting folder.
DataFolder = 'data';
tic
% Get list of all subfolders.
ListOfFolderNames = dir([DataFolder filesep]);
NumberOfFolders = length(ListOfFolderNames);

%% Process all image files in those folders.
if NumberOfFolders >= 1
    for k = 1 : NumberOfFolders
        % Display foler name, get PNG files and TIFF files
        ThisFolder = ListOfFolderNames(k).name;
        fprintf('Processing folder %s\n', ThisFolder);
        BaseFileNamesPNG = dir([ListOfFolderNames(k).folder filesep ListOfFolderNames(k).name filesep '*.png']);
        BaseFileNamesTIFF = dir([ListOfFolderNames(k).folder filesep ListOfFolderNames(k).name filesep '*.tif']);
        NumberOfImageFiles = length(BaseFileNamesTIFF);
        WingStatsAll = table;
        % Loop through all those image files
        if NumberOfImageFiles >= 1
            for f = 1 : NumberOfImageFiles
                RawImage = imread([BaseFileNamesTIFF(f).folder filesep BaseFileNamesTIFF(f).name]);
                SegmentationMask = imread([BaseFileNamesPNG(f).folder filesep BaseFileNamesPNG(f).name]);
                BwLabel = wingMorphFilter(SegmentationMask); %Label the regions in the seg mask. There should be 7 interveinal regions.
                BaseFileNames = BaseFileNamesTIFF(f).name(1:end-4);
                FullFileNameLabel = [BaseFileNames '_Label.jpg'];
                FullFileNameMask = [BaseFileNames '_Simple Segmentation.png'];
                %Check if the segmentation mask has 7 pixel classifications
                if max(max(BwLabel) == 7)
                    [BwLabel, yfit] = Classificn(BwLabel);
                    if length(yfit) == length(unique(yfit))
                        imwrite(label2rgb(BwLabel),[DataFolder filesep ThisFolder filesep FullFileNameLabel])
                        WingStats = ExtractWingStats(RawImage, BwLabel); 
                        WingStatsAll = addvars(WingStatsAll,WingStats);
                        WingName = ['Wing_' BaseFileNames];
                        WingStatsAll.Properties.VariableNames{'WingStats'} = WingName;
                    end
                end
                fprintf('Processing image file: %s\n', BaseFileNames);
                MATFileName = [DataFolder filesep BaseFileNames '.mat'];
                writetable(MATFileName,WingStatsAll);
            end
        end
        %save the data into a .MAT file
        
    end
else
    fprintf('Folder %s has no image files in it.\n', ThisFolder);  
    wingindex = wingindex + 1;
end

toc
toc-tic