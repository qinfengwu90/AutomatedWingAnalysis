function bwLabel = wingMorphFilter(rawImage, label)

    label(label == 3) = 2;
    label(label == 4) = 2;
    rgb_img = label2rgb(label);
    bw_img = im2bw(rgb_img);
    bw_img = imcomplement(bw_img);
    bw_img = bwareafilt(bw_img,7);
    bw_img = imfill(bw_img,'holes');
    se = strel('disk', 8);
    bw_img = imerode(bw_img,se);
    bw_img = imfill(bw_img,'holes');
    bw_img = bwareafilt(bw_img,7);
    bw_img = imdilate(bw_img,se);

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
    bwLabel = bwlabel(bw_img);
    imshow(label2rgb(bwLabel))

    %bw_label(bw_label > 1) = 0;
    %image(bw_label ~= 1) = 0;

end



