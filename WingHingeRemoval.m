%% Removing hinge from Drosophila wings

%% Reading in the folder containing input images (!!Don't forget to change the directory address!!)
myFolder = 'C:\Users\Nilay\Desktop\AutomatedWingAnalysis\control';
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
%% Making a database of all the '.tif' images inside the input folder
filePattern = fullfile(myFolder, '*.jpg');
pngFiles = dir(filePattern);
imagename = strings(length(pngFiles));
intervenalareasum = zeros(length(pngFiles));
%% Looping across individual files
for k = 1:length(pngFiles)
%% Loading individual file from the database  
baseFileName = pngFiles(k).name;
fullFileName = fullfile(myFolder, baseFileName);
fprintf(1, 'Now reading %s\n', fullFileName);
testcase = imread(fullFileName);    
I = testcase; 

%% Cropping out the hinge using roipoly command
BW = roipoly(I);
[m n] = size(I);
n = n/3;
for i = 1:m
    for j = 1:n
        if BW(i,j) == 1
            I(i,j,1) = 240;
            I(i,j,2) = 240;
            I(i,j,3) = 240;
        end
    end
end
%% Writing the image
imwrite(I,baseFileName)
end
%% End of code


