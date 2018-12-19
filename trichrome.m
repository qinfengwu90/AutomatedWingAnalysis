%Description of this function

function [hairCoordinate, interveinImage] = trichrome(rawImage, bwLabel, interveinID )

interveinImage(:,:) = rawImage(:,:,1);
interveinImage(bwLabel ~= interveinID) = 0;
A = interveinImage;
boundingBox = regionprops(bwLabel == interveinID, 'BoundingBox');
boundingBox = cell2mat(struct2cell(boundingBox));
erodedImage = imerode(interveinImage,strel('disk',3));
trichomeImage = erodedImage == interveinImage;
stats = regionprops(trichomeImage,'Centroid');
hairCoordinate = cat(1,stats.Centroid);
interveinDimension = boundingBox(3) * boundingBox(4);
counter_n = 1; 
% (indices in hairCoordinate instead of actual coordiantes) that are too close to each other
for i = 1:k
    for j = 1:k
        hairDistance = ((hairCoordinate(i,1) - hairCoordinate(j,1))^2 + (hairCoordinate(i,2) - hairCoordinate(j,2))^2)^0.5;
        
        if hairDistance <= 2 && i~=j
            hairOutliers(counter_n,1) = i;
            hairOutliers(counter_n,2) = j;
            counter_n = counter_n + 1;
        end
    end
end

if ~isempty(hairOutliers) %if there are two coordinates that are two close to each other
    numOutliers = sum(hairOutliers(:,1) ~= 0, 1);
    outliers_vectorized(1:numOutliers) =  hairOutliers(1:numOutliers,1);
    outliers_vectorized(numOutliers+1:2*numOutliers) =  hairOutliers(1:numOutliers,2); %Cancatenate the Y-coordinates after teh X-coordinates. 
    outliers_vectorized = sort(outliers_vectorized);
    removal = zeros(numOutliers/2, 1);
    for i = 1:numOutliers/2
        removal(i) = outliers_vectorized(4*i);
    end
    hairCoordinate(removal,:) = [];
end
end
