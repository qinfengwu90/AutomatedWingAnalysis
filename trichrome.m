%Description of this function

function numTrichome = trichrome(rawImage, bwLabel)

bwRawImage(:,:) = rgb2gray(rawImage);
numTrichome = zeros(1,7);

for i = 1:7
    interveinImage = bwRawImage;
    interveinImage(bwLabel ~= i) = 0;
    
    %%Obtain local pixel minima
    erodedImage = imerode(interveinImage,strel('disk',3));
    trichomeImage = erodedImage == interveinImage;
    
    %%Identify the coordinates of the trichomes
    stats = regionprops(trichomeImage,'Centroid');
    hairCoordinate = cat(1,stats.Centroid);
    
    %%Eliminate coordiantes that are closer than a threshold
    distanceMatrix = squareform(pdist(hairCoordinate));
    distThreshold = 4;
    pointsTooClose = any(triu((distanceMatrix<distThreshold)&~eye(size(distanceMatrix))));
    hairCoordinate(pointsTooClose,:) = []; 
    
    [numTrichome(1,i), ~] = size(hairCoordinate);
end

end
