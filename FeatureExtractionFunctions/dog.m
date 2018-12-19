
clc;
clear;
img = imread('15583_5.jpg');
image(:,:) = img(:,:,1); 
label = imread('15583_5_Simple Segmentation.png');
label(label ~= 1) = 2;
rgb_img = label2rgb(label);
 bw_img = im2bw(rgb_img);
 bw_img = imcomplement(bw_img);
 bw_img = bwareafilt(bw_img,7)
bw_img = imfill(bw_img,'holes')
se = strel('disk', 10);
bw_img = imerode(bw_img,se);
bw_img = imfill(bw_img,'holes');
bw_img = bwareafilt(bw_img,7)
bw_img = imdilate(bw_img,se);
bw_label = bwlabel(bw_img);
imshow(bw_label)
%  bw_label(bw_label > 1) = 0;imshow()
%  image(bw_label ~= 1) = 0;
 
% [hair_id, Pprs1] = trichrome(image, bw_label, 2)
 [area_intervein, perimeter_intervein, eccentricity_intervein, major_intervein, minor_intervein, positional_feature_intervein, pigmentation_intervein] = interveinalFeaturesBasic(img, bw_label)
 
 comp_area = sum(area_intervein)

