
function [area_intervein, perimeter_intervein, eccentricity_intervein, major_intervein, minor_intervein, positional_feature_intervein] = interveinalFeaturesBasic(img, bw_label)


% image_red(:,:) = img(:,:,1);
% image_green(:,:) = img(:,:,2);
% image_blue(:,:) = img(:,:,3);
stats = regionprops(bw_label,'Centroid', 'Area', 'Perimeter', 'Eccentricity' , 'MajorAxisLength', 'MinorAxisLength')
centroids_intervein = cat(1,stats.Centroid)
area_intervein = cat(1,stats.Area)
perimeter_intervein = cat(1,stats.Area)
eccentricity_intervein = cat(1,stats.Area)
major_intervein = cat(1,stats.Area)
minor_intervein = cat(1,stats.Area)

[dummy_sizex dummy_sizey] = size(centroids_intervein);

for i = 1:dummy_sizex
    for j = 1:dummy_sizex
        positional_feature_intervein(i,j) = ((centroids_intervein(i,1) - centroids_intervein(j,1))^2 + (centroids_intervein(i,2) - centroids_intervein(j,2))^2)^0.5; 
    end
end

% stats_pigmentation_red = regionprops(bw_label,image_red,'MeanIntensity')
% stats_pigmentation_green = regionprops(bw_label,image_green,'MeanIntensity')
% stats_pigmentation_blue = regionprops(bw_label,image_blue,'MeanIntensity')
% pigmentation_intervein(:,1) = cat(1,stats_pigmentation_red.MeanIntensity)
% pigmentation_intervein(:,2) = cat(1,stats_pigmentation_green.MeanIntensity)
% pigmentation_intervein(:,3) = cat(1,stats_pigmentation_blue.MeanIntensity)


end


