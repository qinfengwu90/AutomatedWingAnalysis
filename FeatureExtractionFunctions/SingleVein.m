img = imread('15583_2.jpg');
image(:,:) = img(:,:,1); 
label = imread('15583_2_Simple Segmentation.png');
label(label == 3) = 2;
rgb_img = label2rgb(label);
bw_img = im2bw(rgb_img);
bw_img = imcomplement(bw_img);
bw_img = bwareafilt(bw_img,7);
se = strel('disk', 10);
bw_img = imerode(bw_img,se);
bw_img = imfill(bw_img,'holes');
bw_img = bwareafilt(bw_img,7);
bw_img = imdilate(bw_img,se);
bw_label = bwlabel(bw_img);

% L1-L2 vein
dummy1 = bw_label;
[m n] = size(dummy1)
for i = 1:m
    for j = 1:n
        if dummy1(i,j) == 4 || dummy1(i,j) == 5
            dummy1(i,j) = 1;
        else
            dummy1(i,j) = 0;
        end
    end
end

se = strel('disk', 10);
dummy2 = imdilate(dummy1,se);
dummy3 = imerode(dummy2,se);
vein1 = imsubtract(dummy3,dummy1)

% L2 L3 vein

dummy1 = bw_label;
[m n] = size(dummy1)
for i = 1:m
    for j = 1:n
        if dummy1(i,j) == 3 || dummy1(i,j) == 6
            dummy1(i,j) = 1;
        else
            dummy1(i,j) = 0;
        end
    end
end

se = strel('disk', 10);
dummy2 = imdilate(dummy1,se);
dummy56 = imerode(dummy2,se);

dummy1 = bw_label
for i = 1:m
    for j = 1:n
        if dummy56(i,j) ~= 0 || dummy1(i,j) == 5
            dummy1(i,j) = 1;
        else
            dummy1(i,j) = 0;
        end
    end
end

dummy2 = imdilate(dummy1,se);
dummy3 = imerode(dummy2,se);
vein2 = imsubtract(dummy3,dummy1)
vein2 = bwareafilt(vein2,1);


% L3 L4 vein

dummy1 = bw_label;
[m n] = size(dummy1)
for i = 1:m
    for j = 1:n
        if dummy1(i,j) == 3 || dummy1(i,j) == 6
            dummy1(i,j) = 1;
        else
            dummy1(i,j) = 0;
        end
    end
end
dummy2 = imdilate(dummy1,se);
dummy3 = imerode(dummy2,se);
join1 = dummy3;

dummy1 = bw_label;
[m n] = size(dummy1)
for i = 1:m
    for j = 1:n
        if dummy1(i,j) == 2 || dummy1(i,j) == 7
            dummy1(i,j) = 1;
        else
            dummy1(i,j) = 0;
        end
    end
end
dummy2 = imdilate(dummy1,se);
dummy3 = imerode(dummy2,se);
join2 = dummy3;

join = join1|join2;
dummy2 = imdilate(join,se);
dummy3 = imerode(dummy2,se);
vein3 = imsubtract(dummy3,join)
vein3 = bwareafilt(vein3,1);



% L4 L5 vein
dummy1 = bw_label;
[m n] = size(dummy1)
for i = 1:m
    for j = 1:n
        if dummy1(i,j) == 2 || dummy1(i,j) == 5
            dummy1(i,j) = 1;
        else
            dummy1(i,j) = 0;
        end
    end
end

se = strel('disk', 10);
dummy2 = imdilate(dummy1,se);
dummy56 = imerode(dummy2,se);

dummy1 = bw_label
for i = 1:m
    for j = 1:n
        if dummy56(i,j) ~= 0 || dummy1(i,j) == 1
            dummy1(i,j) = 1;
        else
            dummy1(i,j) = 0;
        end
    end
end

dummy2 = imdilate(dummy1,se);
dummy3 = imerode(dummy2,se);
vein4 = imsubtract(dummy3,dummy1)
vein4 = bwareafilt(vein4,1);

%svein1
dummy1 = bw_label;
[m n] = size(dummy1)
for i = 1:m
    for j = 1:n
        if dummy1(i,j) == 2 || dummy1(i,j) == 5
            dummy1(i,j) = 1;
        else
            dummy1(i,j) = 0;
        end
    end
end

se = strel('disk', 10);
dummy2 = imdilate(dummy1,se);
dummy3 = imerode(dummy2,se);
vein5 = imsubtract(dummy3,dummy1)
vein5 = bwareafilt(vein5,1);
%svein2
dummy1 = bw_label;
[m n] = size(dummy1)
for i = 1:m
    for j = 1:n
        if dummy1(i,j) == 3 || dummy1(i,j) == 6
            dummy1(i,j) = 1;
        else
            dummy1(i,j) = 0;
        end
    end
end

se = strel('disk', 10);
dummy2 = imdilate(dummy1,se);
dummy3 = imerode(dummy2,se);
vein6 = imsubtract(dummy3,dummy1)
vein6 = bwareafilt(vein6,1);

vc = vein1|vein2|vein3|vein4|vein5|vein6