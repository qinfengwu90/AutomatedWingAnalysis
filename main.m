% Start with a folder and get a list of all subfolders.
% Finds and prints names of all PNG, JPG, and TIF images in 
% that folder and all of its subfolders.
% Similar to imageSet() function in the Computer Vision System Toolbox: http://www.mathworks.com/help/vision/ref/imageset-class.html
clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
% Define a starting folder.
start_path = fullfile(matlabroot, 'C:\Users\Nilay\Desktop\AutomatedWingAnalysis\WingAnalyserv_1.0\data');
% Ask user to confirm or change.
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
	return;
end
tic
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames)
COUNT = 1;
wingindex = 0;
% Process all image files in those folders.
for k = 1 : numberOfFolders
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
	
% 	% Get PNG files.
 	filePattern = sprintf('%s/*.tif', thisFolder);
    baseFileNames = dir(filePattern);
    
% 	% Add on TIF files.
%  	filePattern = sprintf('%s/*.png', thisFolder);
%  	baseFileNames = [baseFileNames; dir(filePattern)];

 	numberOfImageFiles = length(baseFileNames)
 	if numberOfImageFiles >= 1
 		% Go through all those image files.
        
        %featureWing = [];
        %FilesName = [];
 		for f = 1 : numberOfImageFiles
 			fullFileName = fullfile(thisFolder, baseFileNames(f).name);
            [filepath,name,ext] = fileparts(fullFileName)
            fullFileName2 = fullFileName(1:end-4);
            fullFileNameMask = strcat(fullFileName2,'_Simple Segmentation.png');
            fullFileNameLabel = strcat(fullFileName2,'_Label.jpg');
            rawImage = imread(fullFileName);
            segmentationMask = imread(fullFileNameMask);
            [bw_label] = wingMorphFilter(rawImage, segmentationMask);
            
            %classificn
            
            max(max(bw_label))
            
            
            if ( max(max(bw_label) == 7) )
                    [bw_label, yfit] = Classificn(bw_label);
                    if ( length(yfit) == length(unique(yfit)) )
                    imwrite(label2rgb(bw_label),fullFileNameLabel)
                    [hair_id1, Pprs1] = trichrome(rawImage, bw_label, 1);
                    [tri(1), n1] = size(hair_id1);
                    [hair_id2, Pprs2] = trichrome(rawImage, bw_label, 2);
                    [tri(2), n1] = size(hair_id2);
                    [hair_id3, Pprs3] = trichrome(rawImage, bw_label, 3);
                    [tri(3), n1] = size(hair_id3);
                    [hair_id4, Pprs4] = trichrome(rawImage, bw_label, 4)
                    [tri(4), n1] = size(hair_id4);
                    [hair_id5, Pprs5] = trichrome(rawImage, bw_label, 5);
                    [tri(5), n1] = size(hair_id5);
                    [hair_id6, Pprs6] = trichrome(rawImage, bw_label, 6);
                    [tri(6), n1] = size(hair_id6);
                    [hair_id7, Pprs7] = trichrome(rawImage, bw_label, 7);
                    [tri(7), n1] = size(hair_id7);
                    [area_intervein, perimeter_intervein, eccentricity_intervein, major_intervein, minor_intervein, positional_feature_intervein] = interveinalFeaturesBasic(rawImage, bw_label)
                    featureWing(COUNT,1:7) = area_intervein;
                    featureWing(COUNT,8:14) = tri;
                    featureWing(COUNT,15) = wingindex;
                    FilesName{COUNT} = strcat(name);
                    COUNT = COUNT+1;
                    end
                    
                end

            %save('feature_imp_2293.mat','feature_imp_2293')
            
 			fprintf('     Processing image file %s\n', fullFileName);
 		end
 	else
 		fprintf('     Folder %s has no image files in it.\n', thisFolder);
 	end

wingindex = wingindex+1;
end

toc
toc-tic