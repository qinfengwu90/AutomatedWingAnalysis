
A(A==0) = NaN;
A(isnan(A)) = 255;

figure(1)
a=A(round(boundingBox(2)):(round(boundingBox(2)) + boundingBox(4)), ...
round(boundingBox(1)):(round(boundingBox(1)) + boundingBox(3)));
imshow(a,[])

figure(2)
b=imerode(A(round(boundingBox(2)):(round(boundingBox(2)) + boundingBox(4)), ...
round(boundingBox(1)):(round(boundingBox(1)) + boundingBox(3))),strel('disk',3));
imshow(b,[])

figure(3)
c = a==b;
imshow(c,[])

stats = regionprops(c, 'Centroid');

figure(4)

imshow(a,[])
hold on
centroids = cat(1,stats.Centroid);
scatter(centroids(:,1),centroids(:,2),'.r')

dist_mat = squareform(pdist(centroids));
threshold = 4;

close = any(triu((dist_mat<threshold)&~eye(size(dist_mat))));
centroids(close,:) = [];
scatter(centroids(:,1),centroids(:,2),'y')
