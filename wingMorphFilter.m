%%Description of the function

function bwLabel = wingMorphFilter(segmentationMask)

    segmentationMask(segmentationMask == 3) = 2;
    segmentationMask(segmentationMask == 4) = 2;
    rgbImage = label2rgb(segmentationMask);
    bwImage = im2bw(rgbImage);
    bwImage = imcomplement(bwImage);
    bwImage = bwareafilt(bwImage,7);
    bwImage = imfill(bwImage,'holes');
    se = strel('disk', 8);
    bwImage = imerode(bwImage,se);
    bwImage = imfill(bwImage,'holes');
    bwImage = bwareafilt(bwImage,7);
    bwImage = imdilate(bwImage,se);

%     D = -bwdist(~bw_img);
%     imshow(D,[])
%     Ld = watershed(D);
%     imshow(label2rgb(Ld))
%     bw2 = bw_img;
%     bw2(Ld == 0) = 0;
%     imshow(bw2)
%     mask = imextendedmin(D,100);
%     imshowpair(bw_img,mask,'blend')
%     D2 = imimposemin(D,mask);
%     Ld2 = watershed(D2);
%     bw3 = bw_img;
%     bw3(Ld2 == 0) = 0;
%     imshow(bw3)
    bwLabel = bwlabel(bwImage);
   % imshow(label2rgb(bwLabel))

    %bw_label(bw_label > 1) = 0;
    %image(bw_label ~= 1) = 0;

end



