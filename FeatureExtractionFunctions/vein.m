img = imread('15583_2.jpg');
image(:,:) = img(:,:,1); 
label = imread('15583_2_Simple Segmentation.png');
% label(label == 3) = 2;
% label(label == 4) = 2;
% rgb_img = label2rgb(label);
% bw_img = im2bw(rgb_img);
% bw_img = imcomplement(bw_img);
% bw_img = imfill(bw_img,'holes');
% se = strel('disk', 3);
% bw_img = imerode(bw_img,se);
% bw_img = bwareafilt(bw_img,7);
% 
% L = watershed(bw_img);
% Lrgb = label2rgb(L);
% imshow(Lrgb)
% imshow(imfuse(bw_img,Lrgb))
% bw2 = ~bwareaopen(~bw_img, 10);
% imshow(bw2)
% D = -bwdist(~bw2);
% imshow(D,[])
% Ld = watershed(D);
% imshow(label2rgb(Ld))
% 
% bw2(Ld == 0) = 0;
% imshow(bw2)
% 
% mask = imextendedmin(D,2);
% imshowpair(bw2,mask,'blend')
% 
% D2 = imimposemin(D,mask);
% Ld2 = watershed(D2);
% bw3 = bw_img;
% bw3(Ld2 == 0) = 0;
% imshow(bw3)



% bw_img = imfill(bw_img,'holes');
% bw_img = bwareafilt(bw_img,7);
% bw_img = imdilate(bw_img,se);
% bw_label = bwlabel(bw_img);
% bw_label(bw_label ~= 7) = 0;
% imshow(label2rgb(bw_label))