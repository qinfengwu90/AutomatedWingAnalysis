
ctr = 1;
%% Reading directories for training data

rootFolder = fullfile('classification');
categories = {'normal','fold','crumbled','broken','melanotic'}; 
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
tbl = countEachLabel(imds)

%% Training the CNN

% determine the smallest amount of images in a category
minSetCount = min(tbl{:,2}); 
% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');
% Notice that each set now has exactly the same number of images.
countEachLabel(imds)

normal = find(imds.Labels == 'normal', 1);
fold = find(imds.Labels == 'fold', 1);
crumbled = find(imds.Labels == 'crumbled', 1);
broken = find(imds.Labels == 'broken', 1);
melanotic = find(imds.Labels == 'melanotic', 1);

figure
subplot(1,5,1);
imshow(readimage(imds,normal))
subplot(1,5,2);
imshow(readimage(imds,fold))
subplot(1,5,3);
imshow(readimage(imds,crumbled))
subplot(1,5,4);
imshow(readimage(imds,broken))
subplot(1,5,5);
imshow(readimage(imds,melanotic))

net = resnet50();
net.Layers(1)
% Inspect the last layer
net.Layers(end)
% Number of class names for ImageNet classification task
numel(net.Layers(end).ClassNames)
[trainingSet, testSet] = splitEachLabel(imds, 0.8, 'randomize');
imageSize = net.Layers(1).InputSize;
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet, 'ColorPreprocessing', 'gray2rgb');
w1 = net.Layers(2).Weights;
% Scale and resize the weights for visualization
w1 = mat2gray(w1);
w1 = imresize(w1,5);
% Display a montage of network weights. There are 96 individual sets of
% weights in the first layer.
figure
montage(w1)
title('First convolutional layer weights')
featureLayer = 'fc1000';
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');
% Get training labels from the trainingSet
trainingLabels = trainingSet.Labels;
% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
classifier = fitcecoc(trainingFeatures, trainingLabels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');
% Extract test features using the CNN
testFeatures = activations(net, augmentedTestSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');
% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');
% Get the known labels
testLabels = testSet.Labels;
% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);
% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))
mean(diag(confMat))

figure
plotconfusion(testLabels,predictedLabels)

%% Testing the classifier on new images

newImage = imread('15468_2.png');
% Create augmentedImageDatastore to automatically resize the image when
% image features are extracted using activations.
ds = augmentedImageDatastore(imageSize, newImage, 'ColorPreprocessing', 'gray2rgb');
% Extract image features using the CNN
imageFeatures = activations(net, ds, featureLayer, 'OutputAs', 'columns');
% Make a prediction using the classifier
label = predict(classifier, imageFeatures, 'ObservationsIn', 'columns')

%% Bulk processing 

start_path = fullfile(matlabroot, 'C:\Users\Nilay\Desktop\AutomatedWingAnalysis\11-26-2018\data');
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

% Process all image files in those folders.
for k = 1 : numberOfFolders
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
	
% 	% Get PNG files.
 	filePattern = sprintf('%s/*.jpg', thisFolder);
    baseFileNames = dir(filePattern);
    
% 	% Add on TIF files.
%  	filePattern = sprintf('%s/*.png', thisFolder);
%  	baseFileNames = [baseFileNames; dir(filePattern)];

 	numberOfImageFiles = length(baseFileNames)
 	if numberOfImageFiles >= 1
 		% Go through all those image files.
        COUNT = 1;
 		for f = 1 : numberOfImageFiles
 			fullFileName = fullfile(thisFolder, baseFileNames(f).name);
            fullFileName2 = fullFileName(1:end-4);
            fullFileNameMask = strcat(fullFileName2,'_Simple Segmentation.tif');
            fullFileNameLabel = strcat(fullFileName2,'_Label.jpg');
            rawImage = imread(fullFileName);
            newImage = rawImage;
            % Create augmentedImageDatastore to automatically resize the image when
            % image features are extracted using activations.
            ds = augmentedImageDatastore(imageSize, newImage, 'ColorPreprocessing', 'gray2rgb');
            % Extract image features using the CNN
            imageFeatures = activations(net, ds, featureLayer, 'OutputAs', 'columns');
            FeatureMain(:,ctr) = imageFeatures;
            ctr = ctr+1;
            
 			fprintf('     Processing image file %s\n', fullFileName);
 		end
 	else
 		fprintf('     Folder %s has no image files in it.\n', thisFolder);
 	end


end

toc
toc-tic

