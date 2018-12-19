%Description of this function

function [hairCoordinate, interveinImage] = trichrome(rawImage, bwLabel, interveinID )

interveinImage(:,:) = rgb2gray(rawImage);
interveinImage(bwLabel ~= interveinID) = 0;

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
end
