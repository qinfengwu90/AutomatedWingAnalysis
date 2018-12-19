% clearvars
% dirtraininglabels = ['traininglabels' filesep];
% traininglist = dir([dirtraininglabels '*.mat']);
% traininglistname = {traininglist.name};
% 
% for i = 1:length(traininglistname)
%     stats = regionprops(struct2array(load(traininglistname{i})),'Area','Perimeter','Solidity','MajorAxisLength','MinorAxisLength');
%     AreaLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.Area);
%     PerimeterLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.Perimeter);
%     SolidityLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.Solidity);
%     MajorAxisLengthLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.MajorAxisLength);
%     MinorAxisLengthLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.MinorAxisLength);
%     Labels(7*(i-1)+1:7*i, 1) = 1:7;
% end
% 
% TableFeaturesTraining = table(AreaLabels,PerimeterLabels,SolidityLabels,MajorAxisLengthLabels,MinorAxisLengthLabels,Labels);

function [bwLabel, yfit] = Classificn(bwLabel)

load('trainedModelBT.mat'); %What is this .mat file?

[num_rows, num_columns] = size(bwLabel);
statsfilter = regionprops(bwLabel,'Area');
arealabelfilter = cat(1,statsfilter.Area);
[sortedDistance, sortedIndex] = sort(arealabelfilter,'descend');

for i = 1:num_rows
    for j = 1:num_columns
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

stats = regionprops(bwLabel,'Area','Perimeter','Solidity','MajorAxisLength','MinorAxisLength','Centroid');
AreaLabels = cat(1,stats.Area);
PerimeterLabels = cat(1,stats.Perimeter);
SolidityLabels = cat(1,stats.Solidity);
MajorAxisLengthLabels = cat(1,stats.MajorAxisLength);
MinorAxisLengthLabels = cat(1,stats.MinorAxisLength);
centroids_temp = cat(1,stats.Centroid);
area_temp = cat(1,stats.Area);
mean_x = 0;
mean_y = 0;
area_sum = 0;
for p = 1:7
    mean_x = mean_x + centroids_temp(p,1)*area_temp(p);
    mean_y = mean_y + centroids_temp(p,2)*area_temp(p);
    area_sum = area_sum + area_temp(p);
end 
mean_x = mean_x/area_sum;
mean_y = mean_y/area_sum;
for q = 1:7
   d_centre(q) =  (centroids_temp(q,1) - mean_x)^2 + (centroids_temp(q,2) - mean_y)^2;
end
 distanceLabels = d_centre';

TableFeaturesTest = table(AreaLabels,PerimeterLabels,SolidityLabels,MajorAxisLengthLabels,distanceLabels,MinorAxisLengthLabels);
yfit = trainedModelBT.predictFcn(TableFeaturesTest);

for i = 1:num_rows
    for j = 1:num_columns
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

 


