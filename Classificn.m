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

function [L, yfit] = Classificn(bw_label)

load('trainedModelBT.mat');


%L = bwlabel(BW3);
L = bw_label;
L1 = L;
[num_rows num_columns] = size(L);
statsfilter = regionprops(L,'Area');
arealabelfilter = cat(1,statsfilter.Area);
[sorteddistance sortedindex] = sort(arealabelfilter,'descend');

for i = 1:num_rows
    for j = 1:num_columns
        if L(i,j) == sortedindex(1)
            L(i,j) = 1;
        elseif L(i,j) == sortedindex(2)
            L(i,j) = 2;
        elseif L(i,j) == sortedindex(3)
            L(i,j) = 3;
        elseif L(i,j) == sortedindex(4)
            L(i,j) = 4;
        elseif L(i,j) == sortedindex(5)
            L(i,j) = 5;
        elseif L(i,j) == sortedindex(6)
            L(i,j) = 6;
        elseif L(i,j) == sortedindex(7)
            L(i,j) = 7;
        else
            L(i,j) = 0;
        end
    end
end
L2 = L;

stats = regionprops(L,'Area','Perimeter','Solidity','MajorAxisLength','MinorAxisLength','Centroid');
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
        if L(i,j) == 1
            L(i,j) = yfit(1);
        elseif L(i,j) == 2
            L(i,j) = yfit(2);
        elseif L(i,j) == 3
            L(i,j) = yfit(3);
        elseif L(i,j) == 4
            L(i,j) = yfit(4);
        elseif L(i,j) == 5
            L(i,j) = yfit(5);
        elseif L(i,j) == 6
            L(i,j) = yfit(6);
        elseif L(i,j) == 7
            L(i,j) = yfit(7);
        end
    end
end

end

 


