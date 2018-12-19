
clearvars
dirtraininglabels = ['PixelLabelData' filesep];
traininglist = dir([dirtraininglabels '*.png']);
traininglistname = {traininglist.name};

for i = 1:length(traininglistname)
    stats = regionprops((imread(traininglistname{i})), 'Area','Perimeter','Solidity','MajorAxisLength','MinorAxisLength');
    AreaLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.Area);
    PerimeterLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.Perimeter);
    SolidityLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.Solidity);
    MajorAxisLengthLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.MajorAxisLength);
    MinorAxisLengthLabels(7*(i-1)+1:7*i, 1) = cat(1,stats.MinorAxisLength);
    Labels(7*(i-1)+1:7*i, 1) = 1:7;
end

TableFeaturesTraining = table(AreaLabels,PerimeterLabels,SolidityLabels,MajorAxisLengthLabels,MinorAxisLengthLabels,Labels);