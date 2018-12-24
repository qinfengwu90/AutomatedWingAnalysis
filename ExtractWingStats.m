%Description

function WingStats = ExtractWingStats(rawImage, bwLabel)
%% Get region properties of each intervein region
WingStatsPartial = regionprops(bwLabel,'Centroid', 'Area', 'Perimeter', 'Eccentricity' , 'MajorAxisLength', 'MinorAxisLength');

%% Get trichome number in each intervein region
BwRawImage(:,:) = rgb2gray(rawImage);
NumTrichome = zeros(7,1);

for i = 1:7
    InterveinImage = BwRawImage;
    InterveinImage(bwLabel ~= i) = 0;
    
    %%Obtain local pixel minima
    ErodedImage = imerode(InterveinImage,strel('disk',3));
    TrichomeImage = ErodedImage == InterveinImage;
    
    %%Identify the coordinates of the trichomes
    Stats = regionprops(TrichomeImage,'Centroid');
    HairCoordinate = cat(1,Stats.Centroid);
    
    %%Eliminate coordiantes that are closer than a threshold
    DistanceMatrix = squareform(pdist(HairCoordinate));
    DistThreshold = 4;
    PointsTooClose = any(triu((DistanceMatrix<DistThreshold)&~eye(size(DistanceMatrix))));
    HairCoordinate(PointsTooClose,:) = [];
    
    [NumTrichome(i,1), ~] = size(HairCoordinate);
end

%% Assemble all stats into a table
WingStats = [array2table(NumTrichome,'VariableNames',{'NumTrichome'}),struct2table(WingStatsPartial)];
WingStats.Properties.RowNames = {'Intervein1','Intervein2','Intervein3', ...
    'Intervein4','Intervein5','Intervein6','Intervein7'};
end