%%Description of the function

function [bwLabel, yfit] = Classificn(bwLabel)
%% 
load('trainedModelBT.mat'); %What is this .mat file?

[numRows, numColumns] = size(bwLabel);
statsFilter = regionprops(bwLabel,'Area');
areaLabelFilter = cat(1,statsFilter.Area);
[~, sortedIndex] = sort(areaLabelFilter,'descend');

%% Numbering the intervein regions based on descending sizes
for i = 1:numRows
    for j = 1:numColumns
        if bwLabel(i,j) == sortedIndex(1)
            bwLabel(i,j) = 1;
        elseif bwLabel(i,j) == sortedIndex(2)
            bwLabel(i,j) = 2;
        elseif bwLabel(i,j) == sortedIndex(3)
            bwLabel(i,j) = 3;
        elseif bwLabel(i,j) == sortedIndex(4)
            bwLabel(i,j) = 4;
        elseif bwLabel(i,j) == sortedIndex(5)
            bwLabel(i,j) = 5;
        elseif bwLabel(i,j) == sortedIndex(6)
            bwLabel(i,j) = 6;
        elseif bwLabel(i,j) == sortedIndex(7)
            bwLabel(i,j) = 7;
        else
            bwLabel(i,j) = 0;
        end
    end
end

%% Extract properties of the 7 intervein regions
stats = regionprops(bwLabel,'Area','Perimeter','Solidity','MajorAxisLength','MinorAxisLength','Centroid');
AreaLabels = cat(1,stats.Area);
PerimeterLabels = cat(1,stats.Perimeter);
SolidityLabels = cat(1,stats.Solidity);
MajorAxisLengthLabels = cat(1,stats.MajorAxisLength);
MinorAxisLengthLabels = cat(1,stats.MinorAxisLength);
CentroidsLabels = cat(1,stats.Centroid);
meanCentroid = [0,0];
areaSum = 0;

%% Calculate weighted average centroid of the wing
for p = 1:7
    meanCentroid(1) = meanCentroid(1) + CentroidsLabels(p,1)*AreaLabels(p);
    meanCentroid(2) = meanCentroid(2) + CentroidsLabels(p,2)*AreaLabels(p);
    areaSum = areaSum + AreaLabels(p);
end 
meanCentroid = meanCentroid/areaSum;

%% Prepare parameters as input into the trained machine learning model
for q = 1:7
   d_centre(q) =  (CentroidsLabels(q,1) - meanCentroid(1))^2 + (CentroidsLabels(q,2) - meanCentroid(2))^2;
end
 distanceLabels = d_centre';

TableFeaturesTest = table(AreaLabels,PerimeterLabels,SolidityLabels,MajorAxisLengthLabels,distanceLabels,MinorAxisLengthLabels);
yfit = trainedModelBT.predictFcn(TableFeaturesTest);

%% Renumber the intervein regions based on the output of the ML model
for i = 1:numRows
    for j = 1:numColumns
        if bwLabel(i,j) == 1
            bwLabel(i,j) = yfit(1);
        elseif bwLabel(i,j) == 2
            bwLabel(i,j) = yfit(2);
        elseif bwLabel(i,j) == 3
            bwLabel(i,j) = yfit(3);
        elseif bwLabel(i,j) == 4
            bwLabel(i,j) = yfit(4);
        elseif bwLabel(i,j) == 5
            bwLabel(i,j) = yfit(5);
        elseif bwLabel(i,j) == 6
            bwLabel(i,j) = yfit(6);
        elseif bwLabel(i,j) == 7
            bwLabel(i,j) = yfit(7);
        end
    end
end

end

 


